Return-Path: <kvm+bounces-5183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C250A81CD3C
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 17:46:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AACCB21F6F
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 16:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E9E25542;
	Fri, 22 Dec 2023 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kdf6RSzj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D15C24B3D;
	Fri, 22 Dec 2023 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703263581; x=1734799581;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1gHtIi5ZDJywJxcUmkGdvgFhi10SfEDFuYpaixHJUtY=;
  b=Kdf6RSzj29f8KByghRrO0bvVNUM5KQTHGBrvi/dlk/FUT3DgmmT9RzwV
   0Nh0Bfe4sEdXR1xkf+2NSfC95B5Wy5yXzAlxLw4S2wRESXWpvH8sCR2Cv
   vFFJICxFtP4oo1wpNG/Hied4b7QsBD4em8dG0aXt4/AFSAUbTBd/YHROq
   y0rSUUsHJKdngtUzznuLQUBLwBFTg5Iaf7Dy0HGX2Ez/u4ODSTqMhfxDa
   SDsbWlE4cZTPFEWFnXnoy21F0eaONUY56K9clkH+i8xRhBC5K71yT2UEy
   K4vzkYu7ZAHBK6HuEiwa6kQQ7aBV1SQa+27Ngj3XBlfpRi9TRTfogSG3S
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10932"; a="460466358"
X-IronPort-AV: E=Sophos;i="6.04,297,1695711600"; 
   d="scan'208";a="460466358"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2023 08:46:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10932"; a="726828321"
X-IronPort-AV: E=Sophos;i="6.04,297,1695711600"; 
   d="scan'208";a="726828321"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2023 08:46:16 -0800
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhi.a.wang@intel.com,
	artem.bityutskiy@linux.intel.com,
	yuan.yao@intel.com,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH v1] KVM: nVMX: Fix handling triple fault on RSM instruction
Date: Fri, 22 Dec 2023 18:45:43 +0200
Message-ID: <20231222164543.918037-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzkaller found a warning triggered in nested_vmx_vmexit().
vmx->nested.nested_run_pending is non-zero, even though we're in
nested_vmx_vmexit(). Generally, trying  to cancel a pending entry is
considered a bug. However in this particular scenario, the kernel
behavior seems correct.

Syzkaller scenario:
1) Set up VCPU's
2) Run some code with KVM_RUN in L2 as a nested guest
3) Return from KVM_RUN
4) Inject KVM_SMI into the VCPU
5) Change the EFER register with KVM_SET_SREGS to value 0x2501
6) Run some code on the VCPU using KVM_RUN
7) Observe following behavior:

kvm_smm_transition: vcpu 0: entering SMM, smbase 0x30000
kvm_entry: vcpu 0, rip 0x8000
kvm_entry: vcpu 0, rip 0x8000
kvm_entry: vcpu 0, rip 0x8002
kvm_smm_transition: vcpu 0: leaving SMM, smbase 0x30000
kvm_nested_vmenter: rip: 0x0000000000008002 vmcs: 0x0000000000007000
                    nested_rip: 0x0000000000000000 int_ctl: 0x00000000
		    event_inj: 0x00000000 nested_ept=n guest
		    cr3: 0x0000000000002000
kvm_nested_vmexit_inject: reason: TRIPLE_FAULT ext_inf1: 0x0000000000000000
                          ext_inf2: 0x0000000000000000 ext_int: 0x00000000
			  ext_int_err: 0x00000000

What happened here is an SMI was injected immediately and the handler was
called at address 0x8000; all is good. Later, an RSM instruction is
executed in an emulator to return to the nested VM. em_rsm() is called,
which leads to emulator_leave_smm(). A part of this function calls VMX/SVM
callback, in this case vmx_leave_smm(). It attempts to set up a pending
reentry to guest VM by calling nested_vmx_enter_non_root_mode() and sets
vmx->nested.nested_run_pending to one. Unfortunately, later in
emulator_leave_smm(), rsm_load_state_64() fails to write invalid EFER to
the MSR. This results in em_rsm() calling triple_fault callback. At this
point it's clear that the KVM should call the vmexit, but
vmx->nested.nested_run_pending is left set to 1. To fix this reset the
vmx->nested.nested_run_pending flag in triple_fault handler.

TL;DR (courtesy of Yuan Yao)
Clear nested_run_pending in case of RSM failure on return from L2 SMM.
The pending VMENTRY to L2 should be cancelled due to such failure leads
to triple fault which should be injected to L1.

Possible alternative approach:
While the proposed approach works, the concern is that it would be
simpler, and more readable to cancel the nested_run_pending in em_rsm().
This would, however, require introducing new callback e.g,
post_leave_smm(), that would cancel nested_run_pending in case of a
failure to resume from SMM.

Additionally, while the proposed code fixes VMX specific issue, SVM also
might suffer from similar problem as it also uses it's own
nested_run_pending variable.

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Closes: https://lore.kernel.org/all/CAMhUBjmXMYsEoVYw_M8hSZjBMHh24i88QYm-RY6HDta5YZ7Wgw@mail.gmail.com
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff7..44432e19eea6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4904,7 +4904,16 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 static void nested_vmx_triple_fault(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
 	kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
+	/* In case of a triple fault, cancel the nested reentry. This may occur
+	 * when the RSM instruction fails while attempting to restore the state
+	 * from SMRAM.
+	 */
+	vmx->nested.nested_run_pending = 0;
+
 	nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0);
 }
 
-- 
2.41.0



Return-Path: <kvm+bounces-16372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA0E98B909D
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 22:30:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18D9D1C21585
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF1941635D9;
	Wed,  1 May 2024 20:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="anQHXj3y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DDF1635C4
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 20:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714595397; cv=none; b=Pz2v0lvjB+vrKVvgi3ib5gqtTwNNtvpk9IT+humhBiVKSHSfnphJzo8A9LFeUN2URqtpOIq7gaMrYDa9PDsRXJXLumODe8iYe4vdDKzBr54KLmuR66CiOVwPCGJMYsqd+Q8QeinpezXzOLAww35GTyIm4vfk7IIleVgHzSUNjjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714595397; c=relaxed/simple;
	bh=1erQnYRAnn/EZoo4Yru1wovhxaVBwRZVzokKm2u6sKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NVoAG5EMdAvbyD1/zufC8TfVln9z/LYsXV7Zp0ybMNJAO0r+6I/rTkUm+q3fpGE5IrnoIRHLGwqer1cr3D+5T40CRsmC9WZ1OLRSE6aiUQJjYSoqHt5ocQba5s3oAVlMlzyV6P3VMjPY8h43oSAuqr3IsQB6j7tS8OSLkivicHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=anQHXj3y; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714595395; x=1746131395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1erQnYRAnn/EZoo4Yru1wovhxaVBwRZVzokKm2u6sKc=;
  b=anQHXj3yM/z+n79NHgpFkc5aRlpqpk4rAWltEfQy6yhdjrNOHRKNGjou
   /1QDTfUfjrDiZUBsGwtnVZb88kIxscfWcfp0m6flmd+freZ8aCDAjS8tq
   S/0s9YPgtnBmkRZm2/SOSrziuOAvFuAQGXhBGgrtSYjFo3TGOkvA6KcNU
   qe+vIb5sZ4E9s1OjV69Za/2a6eYbprGDbYBVfwn/PIk3HD+y1hNeg3zBi
   WBDTPtqO1QOBripOP+OyT67iciNGMrbLcJJVm+mLRqh7+PeR2Pj6Fa4ki
   FOc5zb1asWl4NlgIWvhy4kSqHWm7m8UZZzcmw6jgkzAG8ljFgsQAgLg/N
   g==;
X-CSE-ConnectionGUID: CkV7kNQUREWWwZpJkdQ3gQ==
X-CSE-MsgGUID: TQ3iFFUfRT62jz6G8OaQmA==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="10472615"
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="10472615"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 13:29:52 -0700
X-CSE-ConnectionGUID: e9Dz3pNRQ+SrABGTzwtH+g==
X-CSE-MsgGUID: TpJjWaoMTWmnG/bzAlp1GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="26890451"
Received: from otc-tsn-4.jf.intel.com ([10.23.153.135])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 13:29:52 -0700
From: Kishen Maloor <kishen.maloor@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	mlevitsk@redhat.com,
	zheyuma97@gmail.com
Cc: Kishen Maloor <kishen.maloor@intel.com>,
	Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH v3 2/2] KVM: x86: nSVM/nVMX: Fix RSM logic leading to L2 VM-Entries
Date: Wed,  1 May 2024 16:29:34 -0400
Message-Id: <20240501202934.1365061-3-kishen.maloor@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240501202934.1365061-1-kishen.maloor@intel.com>
References: <20240501202934.1365061-1-kishen.maloor@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzkaller found a warning triggered in nested_vmx_vmexit().
The nested_run_pending flag is non-zero, even though we're in
nested_vmx_vmexit(). Generally, trying to cancel a pending entry is
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
which leads to emulator_leave_smm(). A part of this function calls the
VMX/SVM callback, in this case vmx_leave_smm(). It attempts to set up a
pending reentry to the guest VM by calling nested_vmx_enter_non_root_mode()
and sets the nested_run_pending flag to one. Unfortunately, later in
emulator_leave_smm(), rsm_load_state_64() fails to write an invalid EFER to
the MSR. This results in em_rsm() calling the triple_fault callback. At this
point, it's clear that KVM should perform a vmexit, but nested_run_pending
is left set to 1.

Similar flow goes for SVM, as the bug also reproduces on AMD platforms.

[Notes above by Michal Wilczynski of the bug analysis]

To address the issue, this change sets the nested_run_pending flag only
after a successful emulation of the RSM instruction. Previously, it
was set (prematurely) inside the vendor-specific leave_smm() callback since
commit 759cbd59674a ("KVM: x86: nSVM/nVMX: set nested_run_pending on VM
entry which is a result of RSM").

Fixes: 759cbd59674a ("KVM: x86: nSVM/nVMX: set nested_run_pending on VM entry which is a result of RSM")
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Closes: https://lore.kernel.org/all/CAMhUBjmXMYsEoVYw_M8hSZjBMHh24i88QYm-RY6HDta5YZ7Wgw@mail.gmail.com
Analyzed-by: Michal Wilczynski <michal.wilczynski@intel.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
---
 arch/x86/kvm/smm.c     | 12 ++++++++++--
 arch/x86/kvm/svm/svm.c |  2 --
 arch/x86/kvm/vmx/vmx.c |  1 -
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index d06d43d8d2aa..b1dac967f1a5 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -633,8 +633,16 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
-		return rsm_load_state_64(ctxt, &smram.smram64);
+		ret = rsm_load_state_64(ctxt, &smram.smram64);
 	else
 #endif
-		return rsm_load_state_32(ctxt, &smram.smram32);
+		ret = rsm_load_state_32(ctxt, &smram.smram32);
+
+	/*
+	 * Set nested_run_pending to ensure completion of a nested VM-Entry
+	 */
+	if (ret == X86EMUL_CONTINUE && ctxt->ops->is_guest_mode(ctxt))
+		vcpu->arch.nested_run_pending = 1;
+
+	return ret;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index debc53b73ea3..4c3f0e1f0dd0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4699,8 +4699,6 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	if (ret)
 		goto unmap_save;
 
-	vcpu->arch.nested_run_pending = 1;
-
 unmap_save:
 	kvm_vcpu_unmap(vcpu, &map_save, true);
 unmap_map:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e83439ecd956..e66fc14b54be 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8214,7 +8214,6 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 		if (ret)
 			return ret;
 
-		vcpu->arch.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
 	}
 	return 0;
-- 
2.31.1



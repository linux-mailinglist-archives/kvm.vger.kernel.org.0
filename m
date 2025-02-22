Return-Path: <kvm+bounces-38931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B015BA404D0
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50B5D3B8451
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D30E202F60;
	Sat, 22 Feb 2025 01:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XV7fS8lX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BB5201270;
	Sat, 22 Feb 2025 01:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188472; cv=none; b=puaRQsOealM8BwOlRgsHPf1UN0HXsjvsV+6bjs0nP7XHJrhOfocJ8KZ2tgfhQy64pNWoSF5hXYHTu75TwrUbH3GwYLuBPPXb6CHwj/aOw/ypBnhY5ENTam2PsYLINNrdAkNTvdF2qWmkT+PUR46Y5w5FFopxpFo7wwYKoxEIz+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188472; c=relaxed/simple;
	bh=Zkm1Wv929Y7ynRBsU/THIgczu5F+uiDlIs8XolmKdwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzQL2C8Ve3WJrF4ggx1C9A+zogrUSPROErzxrXLJO/UezhWqM/n2dU5BxsC51R0Ne2FG3T/jeJP4tgC8+BbBryn7SlUVPIrg9Y6cgGh58mKejxqxdJFTzplMfpCAm5z5QqCPgs1j0R9YKwL61Jj7EpBDYZ+T0tYVGBafONrEsVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XV7fS8lX; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188471; x=1771724471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zkm1Wv929Y7ynRBsU/THIgczu5F+uiDlIs8XolmKdwg=;
  b=XV7fS8lXuOzHIM/r/CSiQjaMWEnvq1R9J0a7zNqmhjsYd7OAsTKhx14r
   MhlxagPUtNP3s7JmnJV6PDKDVn+BEmexmQ3f5U4kbHp4dvSAPaGDY/SwN
   9CWyoMMH9ppX66jcihNLi1uN//oZniD5I9UrKj1cCxdcNVmxrpAtuSpH7
   /5ZcwL3D5QZ6mVfwpnTf5CCZG1s/IkzjXeXhCgzFs8PTXOUu322XFttYT
   LF2T84Gs/MkZ9d8nFoeRdLluqSDhnj06cHebXzy6W5Zc1yFfgI41Qzpmq
   KrEJY0EdZZ8Cxhh4W9P3Pl9+ELZVwC1zTjdHRsDH9CM/NN2qr6AHESLCh
   g==;
X-CSE-ConnectionGUID: 6LQPFOomRW+W83ufiLx0Jw==
X-CSE-MsgGUID: FW8hfV4fSkiz5RH0pAhBpw==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="40893278"
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="40893278"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:10 -0800
X-CSE-ConnectionGUID: 1DP9U+hWT6CNBp1mX1Qyww==
X-CSE-MsgGUID: USt8ZWJSTsOXVOptAOmgbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="146370251"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:07 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 5/9] KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL
Date: Sat, 22 Feb 2025 09:42:21 +0800
Message-ID: <20250222014225.897298-6-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014225.897298-1-binbin.wu@linux.intel.com>
References: <20250222014225.897298-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle KVM hypercall for TDX according to TDX Guest-Host Communication
Interface (GHCI) specification.

The TDX GHCI specification defines the ABI for the guest TD to issue
hypercalls.  When R10 is non-zero, it indicates the TDG.VP.VMCALL is
vendor-specific.  KVM uses R10 as KVM hypercall number and R11-R14
as 4 arguments, while the error code is returned in R10.

Morph the TDG.VP.VMCALL with KVM hypercall to EXIT_REASON_VMCALL and
marshall r10~r14 from vp_enter_args to the appropriate x86 registers for
KVM hypercall handling.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Hypercalls exit to userspace v3:
- No change.

Hypercalls exit to userspace v2:
- Morph the TDG.VP.VMCALL with KVM hypercall to EXIT_REASON_VMCALL.
- Marshall values to the appropriate x86 registers for KVM hypercall
  handling.

Hypercalls exit to userspace v1:
- Renamed from "KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL" to
  "KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL".
- Update the change log.
- Rebased on Sean's "Prep KVM hypercall handling for TDX" patch set.
  https://lore.kernel.org/kvm/20241128004344.4072099-1-seanjc@google.com
- Use the right register (i.e. R10) to set the return code after returning
  back from userspace.
---
 arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7a5f375d976a..4f659ca50469 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -967,6 +967,23 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	return tdx_exit_handlers_fastpath(vcpu);
 }
 
+static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
+{
+	tdvmcall_set_return_code(vcpu, vcpu->run->hypercall.ret);
+	return 1;
+}
+
+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
+{
+	kvm_rax_write(vcpu, to_tdx(vcpu)->vp_enter_args.r10);
+	kvm_rbx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r11);
+	kvm_rcx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r12);
+	kvm_rdx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r13);
+	kvm_rsi_write(vcpu, to_tdx(vcpu)->vp_enter_args.r14);
+
+	return __kvm_emulate_hypercall(vcpu, 0, complete_hypercall_exit);
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
@@ -1338,6 +1355,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return 0;
 	case EXIT_REASON_TDCALL:
 		return handle_tdvmcall(vcpu);
+	case EXIT_REASON_VMCALL:
+		return tdx_emulate_vmcall(vcpu);
 	default:
 		break;
 	}
-- 
2.46.0



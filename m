Return-Path: <kvm+bounces-9037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F84D859DA1
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C30D51C21C0E
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC0044368;
	Mon, 19 Feb 2024 07:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m6iNdcgH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F5C3CF5E;
	Mon, 19 Feb 2024 07:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328880; cv=none; b=Ea0iKDUDbRP+RRUbyAx6miu5hXZhjb8iWt/2We0HU7gquIwx/Vke0/qXTYch2kDH9KcQaxqZRitVFG4xxsmUYxvLuMiJoxunyQubVn37p6ld1M1207XJHW4L99W6Fvz+lHTPtJm3yn2FEyzozsp6FtCtW8NHGfIpuYbzPtu2nkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328880; c=relaxed/simple;
	bh=amnQUCWuTb+cZ7qxz14jEfsX5/6hnGY9dMCWTjruETs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxpqZqfFDhfZynzAe7+Ad0eUNt8MkrUgsKlSDF8P09FohHohviJygrWawUD4gM9accG1IObMGQp6ZkVFeDppnlMSjuk5O5sJaHVTsCRRc3fWQfsPSQvbRUE53Wh/sM+gwqRZDg4p/Qj6IHRjUkuJBulFaeuUxoSHe3CQKSu5fWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m6iNdcgH; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328878; x=1739864878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=amnQUCWuTb+cZ7qxz14jEfsX5/6hnGY9dMCWTjruETs=;
  b=m6iNdcgHVATwAxX1s/spcOtpzdT71he+o9ESwsA5Zgvv408Ypm/dp/m5
   Dt3S+W+qZ2o9mKKQte/xznf8Z6bi5ZIyAvRd/1uaQx+PMPWRUoVKCFYFN
   dV/NH9RI80phkN+COTsx1X3bTu6jDWH7IwMAoNvWEvL/j3Mr4I0CIMb/F
   fHvGA22cRn0XamMulCtXFLo+PqGv8VyehJjtflzsSBbYZYFCiptnjgqJL
   RVRWP09BfWslaWpHNh6P9kXC1kCSbctXRFzouifGlJCi8Kp7ppYjL6is1
   QKJoIe4n3aTDSx/jMKzcBvoaYRsoqEYo08Wu22bdEKZugN3xRCx9GwtdL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535166"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535166"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966134"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966134"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 25/27] KVM: nVMX: Introduce new VMX_BASIC bit for event error_code delivery to L1
Date: Sun, 18 Feb 2024 23:47:31 -0800
Message-ID: <20240219074733.122080-26-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Per SDM description(Vol.3D, Appendix A.1):
"If bit 56 is read as 1, software can use VM entry to deliver a hardware
exception with or without an error code, regardless of vector"

Modify has_error_code check before inject events to nested guest. Only
enforce the check when guest is in real mode, the exception is not hard
exception and the platform doesn't enumerate bit56 in VMX_BASIC, in all
other case ignore the check to make the logic consistent with SDM.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 27 ++++++++++++++++++---------
 arch/x86/kvm/vmx/nested.h |  5 +++++
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4be0078ca713..0439208523b8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1230,9 +1230,9 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
 	const u64 feature_and_reserved =
 		/* feature (except bit 48; see below) */
-		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
+		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) | BIT_ULL(56) |
 		/* reserved */
-		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
+		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 57);
 	u64 vmx_basic = vmcs_config.nested.basic;
 
 	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
@@ -2865,7 +2865,6 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		u8 vector = intr_info & INTR_INFO_VECTOR_MASK;
 		u32 intr_type = intr_info & INTR_INFO_INTR_TYPE_MASK;
 		bool has_error_code = intr_info & INTR_INFO_DELIVER_CODE_MASK;
-		bool should_have_error_code;
 		bool urg = nested_cpu_has2(vmcs12,
 					   SECONDARY_EXEC_UNRESTRICTED_GUEST);
 		bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
@@ -2882,12 +2881,20 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
 			return -EINVAL;
 
-		/* VM-entry interruption-info field: deliver error code */
-		should_have_error_code =
-			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
-			x86_exception_has_error_code(vector);
-		if (CC(has_error_code != should_have_error_code))
-			return -EINVAL;
+		/*
+		 * Cannot deliver error code in real mode or if the interrupt
+		 * type is not hardware exception. For other cases, do the
+		 * consistency check only if the vCPU doesn't enumerate
+		 * VMX_BASIC_NO_HW_ERROR_CODE_CC.
+		 */
+		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION) {
+			if (CC(has_error_code))
+				return -EINVAL;
+		} else if (!nested_cpu_has_no_hw_errcode_cc(vcpu)) {
+			if (CC(has_error_code !=
+			       x86_exception_has_error_code(vector)))
+				return -EINVAL;
+		}
 
 		/* VM-entry exception error code */
 		if (CC(has_error_code &&
@@ -7011,6 +7018,8 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
+	if (cpu_has_vmx_basic_no_hw_errcode())
+		msrs->basic |= VMX_BASIC_NO_HW_ERROR_CODE_CC;
 }
 
 static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index cce4e2aa30fb..747061c2aeb9 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -285,6 +285,11 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
 	       __kvm_is_valid_cr4(vcpu, val);
 }
 
+static inline bool nested_cpu_has_no_hw_errcode_cc(struct kvm_vcpu *vcpu)
+{
+	return to_vmx(vcpu)->nested.msrs.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
+}
+
 /* No difference in the restrictions on guest and host CR4 in VMX operation. */
 #define nested_guest_cr4_valid	nested_cr4_valid
 #define nested_host_cr4_valid	nested_cr4_valid
-- 
2.43.0



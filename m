Return-Path: <kvm+bounces-57081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF632B4A88E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:46:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 936013B2413
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A092230F539;
	Tue,  9 Sep 2025 09:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H6KdpPgS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2D630AAD2;
	Tue,  9 Sep 2025 09:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410809; cv=none; b=WDO5m2ARjrAPOlvj2DQlVapF5wfYUHqDNmbxmSV1RqTNX+zZJ4I5tydHyEjcII0wjB1XcJ6oD2mqJk7Xd0DisTRaGwYiXjHbiL+QX1XAbS43+u4/hSJdRMPOHmwdMwYbi53geo9ygLgwbdcWnD7kcMDPJRqzz810zxQUppQ1bqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410809; c=relaxed/simple;
	bh=JNqRa0UFPixeO+5rVEt+vIHXdc6JK5UH9Iu5LAZURYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+dhkK1tra5Txy1FoCUn9vKTi/4yu4tm6PNKbfeeArI2CFFmKOe3X4xcpGRVYk7kel66MlNN2XtIP9azh11y19cwfV4Qs67ZNMiu4SWpDgpSD+ANzhm59ERXVBSVwsEPC2F2bqbYI9F4FwH7ypdNVmWfbfZyB9sdLC2NtjFauhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H6KdpPgS; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410807; x=1788946807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JNqRa0UFPixeO+5rVEt+vIHXdc6JK5UH9Iu5LAZURYs=;
  b=H6KdpPgSuuV+XrIVLUJnaknwQDePL0k7fs56B1GAIsQ0ynCvnTy2nmpj
   9zvAJ5hvUnXg8zEsP3rEuImVO/0ln26byhlyuOJfgCEN6IY4xaNW4ZZUz
   cqd8nCfRfLWOaCfp0mpT+ZBVWZuW9fuadS1CChAtbH+3xrrUWciGN8ZzC
   xbPC4CvpsLmUktnCO9qHt4zabwa2wSZKWK1BZ9XbIOmXOH/CggfMa/8FB
   62sCEqzuinbWEo/DsQeWYXRIVaqeaa/t6sunsHROtoVQPD6lhRm0Jp4GP
   S8y039xdWSCh+T/TX2MTsEd9KDE+Ru4RZNVVH3KwSeM2sfKt7iLW4M57U
   w==;
X-CSE-ConnectionGUID: gSsA8jUNR5mde9/DAMW2HQ==
X-CSE-MsgGUID: 3iH0TqQJSCmkPa69VV3QMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307320"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307320"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:57 -0700
X-CSE-ConnectionGUID: 07vA4nkATBSwJo1ylQoEDg==
X-CSE-MsgGUID: MIhQX/joTSaU5DRYGhbXUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207436"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:57 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 17/22] KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1 event injection to L2
Date: Tue,  9 Sep 2025 02:39:48 -0700
Message-ID: <20250909093953.202028-18-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

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
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 28 +++++++++++++++++++---------
 arch/x86/kvm/vmx/nested.h |  5 +++++
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2156c9a854f4..14f9822b611d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1272,9 +1272,10 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
 	const u64 feature_bits = VMX_BASIC_DUAL_MONITOR_TREATMENT |
 				 VMX_BASIC_INOUT |
-				 VMX_BASIC_TRUE_CTLS;
+				 VMX_BASIC_TRUE_CTLS |
+				 VMX_BASIC_NO_HW_ERROR_CODE_CC;
 
-	const u64 reserved_bits = GENMASK_ULL(63, 56) |
+	const u64 reserved_bits = GENMASK_ULL(63, 57) |
 				  GENMASK_ULL(47, 45) |
 				  BIT_ULL(31);
 
@@ -2949,7 +2950,6 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		u8 vector = intr_info & INTR_INFO_VECTOR_MASK;
 		u32 intr_type = intr_info & INTR_INFO_INTR_TYPE_MASK;
 		bool has_error_code = intr_info & INTR_INFO_DELIVER_CODE_MASK;
-		bool should_have_error_code;
 		bool urg = nested_cpu_has2(vmcs12,
 					   SECONDARY_EXEC_UNRESTRICTED_GUEST);
 		bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
@@ -2966,12 +2966,20 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
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
@@ -7214,6 +7222,8 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 	msrs->basic |= VMX_BASIC_TRUE_CTLS;
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
+	if (cpu_has_vmx_basic_no_hw_errcode())
+		msrs->basic |= VMX_BASIC_NO_HW_ERROR_CODE_CC;
 }
 
 static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 6eedcfc91070..983484d42ebf 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -309,6 +309,11 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
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
2.47.3



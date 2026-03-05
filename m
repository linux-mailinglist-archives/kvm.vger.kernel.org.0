Return-Path: <kvm+bounces-72900-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SDtaMYvBqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72900-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:46:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 68EA821671D
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 809B030361AE
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AB23FB068;
	Thu,  5 Mar 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X4NwnYXR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF7F3EBF35;
	Thu,  5 Mar 2026 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732681; cv=none; b=Zbhg26JifdrNU3CBUmLm5d/YtcedlUCqW6iBtGvgpFOSix6OAwgfZzxVrCN1PznOPIzczRTmladuu7Gt1KE0OZD/AYP68uHChLPsu7WtqmbJlzfZ6vZksh2I+ES+4tN1yvxfOR0axLQhxkBS5R0q+w/hmMFKdw36ZG1OWILS98s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732681; c=relaxed/simple;
	bh=1aenzwDGDxj7/Xy0K7xK2VZ8ll7V/R5F1ZAMykoI7BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WifR8ZOnzyX6/TR15s3y7l55kZLVzzImSO8UaqQ6XtoiVeyHhzFHg6TjA6erEjG4JRrulwNAl2jd3aUBylRa+NPpz8IoGfkjyCx9iCZoCaKqIwwszHurknotEK8lX7i6G4fvuYH64jErcn4Rd8TTMS2vo0GiWeNDoDAEIP8MaSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X4NwnYXR; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732680; x=1804268680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1aenzwDGDxj7/Xy0K7xK2VZ8ll7V/R5F1ZAMykoI7BM=;
  b=X4NwnYXR/chAu7rRuf6GoHH1FXyLBQ8M/Cp7jJpHThgzRj/NQrBfx4jl
   X+rwjpOAgmKdlrRvtXSMvKJTVYxnNewECpWADCNS74jvzWCnkS+micCVI
   KQovzI4x4lnv8VbkSTYFG/2UHKHWERcxDZBWjHRZtmOSVK0RwOpcDCPJo
   avCRtYe5T/IHZOkvE2m1LdvCp71dd3BqDf7vugPs/Of/m0Pch4sti+2YJ
   /xqULQ3wNxH1JpH2Amsk0RLFNIFe4D+Ms+CTzDN7nWdzsEvXwtLTV06n5
   u8pwaNloxgqSA2dzAXcqH+bh5pG4XPCZ2MFn+2gHNd/HgcYl0Jz+8VKeh
   w==;
X-CSE-ConnectionGUID: b5dDoaVyTA2stI8wj/0Psg==
X-CSE-MsgGUID: kwecv7DPTuecj4Z5OOT8Yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431574"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431574"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:37 -0800
X-CSE-ConnectionGUID: TI3CSsrbTZCmStv+UxZP4Q==
X-CSE-MsgGUID: z8MdqYnZRdiexiuXckp1jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447877"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:37 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/36] KVM: nVMX: Add tertiary VM-execution control VMCS support
Date: Thu,  5 Mar 2026 09:43:52 -0800
Message-ID: <bb1c21699b8299b53fc33e35ef21398ef9677954.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 68EA821671D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72900-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Support tertiary processor-based VM-execution control VMCS field.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/hyperv.c | 10 ++++++++++
 arch/x86/kvm/vmx/nested.c | 17 +++++++++++++++++
 arch/x86/kvm/vmx/nested.h |  7 +++++++
 arch/x86/kvm/vmx/vmcs12.c |  1 +
 arch/x86/kvm/vmx/vmcs12.h |  3 ++-
 5 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index 2731c2e4b0e5..70e210472681 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -166,6 +166,12 @@ static bool nested_evmcs_is_valid_controls(enum evmcs_ctrl_type ctrl_type,
 	return !(val & ~evmcs_get_supported_ctls(ctrl_type));
 }
 
+static bool nested_evmcs_is_valid_controls64(enum evmcs_ctrl_type ctrl_type,
+					     u64 val)
+{
+	return !(val & ~evmcs_get_supported_ctls(ctrl_type));
+}
+
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 {
 	if (CC(!nested_evmcs_is_valid_controls(EVMCS_PINCTRL,
@@ -188,6 +194,10 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 					       vmcs12->vm_entry_controls)))
 		return -EINVAL;
 
+	if (CC(!nested_evmcs_is_valid_controls64(EVMCS_3RDEXEC,
+						 vmcs12->tertiary_vm_exec_control)))
+		return -EINVAL;
+
 	/*
 	 * VM-Func controls are 64-bit, but KVM currently doesn't support any
 	 * controls in bits 63:32, i.e. dropping those bits on the consistency
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index be6b92b3c66a..1bd5e164e285 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1815,6 +1815,7 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->vm_exit_controls = evmcs->vm_exit_controls;
 		vmcs12->secondary_vm_exec_control =
 			evmcs->secondary_vm_exec_control;
+		vmcs12->tertiary_vm_exec_control = 0;
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -2511,6 +2512,17 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		secondary_exec_controls_set(vmx, exec_control);
 	}
 
+	/*
+	 * TERTIARY EXEC CONTROLS
+	 */
+	if (cpu_has_tertiary_exec_ctrls()) {
+		u64 ctls = 0;
+
+		/* guest apic timer virtualization will come */
+
+		tertiary_exec_controls_set(vmx, ctls);
+	}
+
 	/*
 	 * ENTRY CONTROLS
 	 *
@@ -2969,6 +2981,11 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
 				   vmx->nested.msrs.secondary_ctls_high)))
 		return -EINVAL;
 
+	if (nested_cpu_has(vmcs12, CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) &&
+	    CC(!vmx_control64_verify(vmcs12->tertiary_vm_exec_control,
+				     vmx->nested.msrs.tertiary_ctls)))
+		return -EINVAL;
+
 	if (CC(vmcs12->cr3_target_count > nested_cpu_vmx_misc_cr3_count(vcpu)) ||
 	    nested_vmx_check_io_bitmap_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_msr_bitmap_controls(vcpu, vmcs12) ||
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 8c25054a710e..52bf035bcc03 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -175,6 +175,13 @@ static inline bool nested_cpu_has2(struct vmcs12 *vmcs12, u32 bit)
 		(vmcs12->secondary_vm_exec_control & bit);
 }
 
+static inline bool nested_cpu_has3(struct vmcs12 *vmcs12, u64 bit)
+{
+	return (vmcs12->cpu_based_vm_exec_control &
+			CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) &&
+		(vmcs12->tertiary_vm_exec_control & bit);
+}
+
 static inline bool nested_cpu_has_preemption_timer(struct vmcs12 *vmcs12)
 {
 	return vmcs12->pin_based_vm_exec_control &
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 1ebe67c384ad..e2e2a99c8aa9 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -38,6 +38,7 @@ static const u16 kvm_supported_vmcs12_field_offsets[] __initconst = {
 	FIELD64(PML_ADDRESS, pml_address),
 	FIELD64(TSC_OFFSET, tsc_offset),
 	FIELD64(TSC_MULTIPLIER, tsc_multiplier),
+	FIELD64(TERTIARY_VM_EXEC_CONTROL, tertiary_vm_exec_control),
 	FIELD64(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr),
 	FIELD64(APIC_ACCESS_ADDR, apic_access_addr),
 	FIELD64(POSTED_INTR_DESC_ADDR, posted_intr_desc_addr),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 8c9d4c22b960..b7d30a2cf23f 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -71,7 +71,7 @@ struct __packed vmcs12 {
 	u64 pml_address;
 	u64 encls_exiting_bitmap;
 	u64 tsc_multiplier;
-	u64 padding64[1]; /* room for future expansion */
+	u64 tertiary_vm_exec_control;
 	/*
 	 * To allow migration of L1 (complete with its L2 guests) between
 	 * machines of different natural widths (32 or 64 bit), we cannot have
@@ -262,6 +262,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(pml_address, 312);
 	CHECK_OFFSET(encls_exiting_bitmap, 320);
 	CHECK_OFFSET(tsc_multiplier, 328);
+	CHECK_OFFSET(tertiary_vm_exec_control, 336);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
-- 
2.45.2



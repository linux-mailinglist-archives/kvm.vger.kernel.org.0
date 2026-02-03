Return-Path: <kvm+bounces-70042-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WDfoHgs9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70042-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:23:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 32052DD81D
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C925530C628F
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7B03D7D81;
	Tue,  3 Feb 2026 18:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GZal9T58"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9761E36A00D;
	Tue,  3 Feb 2026 18:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142664; cv=none; b=C60F6geASvTlMXeh0EJFIS2B/NjMMnsBRjbheVXnkzTptITyRqg6RXVa91qxl4fUWC/8DX3pfZcjRyreIpEI2Rm3j8KDr4awrBi9bAVzSUYP/D1ga/PoTj0fESpdhfujrqWeyw/f7gkiAJ2dzgf9QGX4EKSdvKe5wPQPP8kDk+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142664; c=relaxed/simple;
	bh=vtqwmnv6BUztDTb7SL0PpDFYYt8itAFaXzecMcCYsr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxU8bnITnGz+yktY6LGWsOoDU/qNVZQ7GkkXNL2vlo/l+raL/IYp+YObVD+JSPAj6VvWNjFiFfDYEBwvfzkDzXt6cbI3J6rJNKDyrj+0BfFhGeVUgUDuNBpSgDvSTFZ0Q2krls9kcfyWAz5oKwxQIuTgUmrHMMP6qUNdHEK1xOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GZal9T58; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142663; x=1801678663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vtqwmnv6BUztDTb7SL0PpDFYYt8itAFaXzecMcCYsr4=;
  b=GZal9T58aRpWR2Cnb3u8i4grqRfJNKZvR0GwRcyVWuDFGAK2XEv5JvQI
   EuAAho7eYmcWRFwYEx1UvT9CCf84SSemEwxwoF1N1FLE2utMTTf1ToUwg
   Nxvgk9gKkB2NB6vGaNZgMIr2bJvrbL7MRtAa/rwFASJ0ETbvn0PvMJXZt
   CveC6DPNYf/aLOL3WhSGQxlxjHTUFgWRBrVauwHIcQRYY5TEHbrTG6fK4
   wu8jFCDgsuRrFQbLedsbK+wc8dlcHgfIuhyLUsdrQr+QgZijCZJy09PLj
   mpCXMlJXFwAoAAMHSiZP7OESPPVqmY+1jo/BbVJTfGVGnO78Jxe3dInCI
   g==;
X-CSE-ConnectionGUID: sf9gSDeERuKIddwHXALkKg==
X-CSE-MsgGUID: E10XV0H6R9Oj1g0Sq85Beg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745797"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745797"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:41 -0800
X-CSE-ConnectionGUID: G3ZU3MZiRXqYk1HIocWDrg==
X-CSE-MsgGUID: sS8uGskaSfKOvHAVm5XCBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605479"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:40 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/32] KVM: nVMX: Add tertiary VM-execution control VMCS support
Date: Tue,  3 Feb 2026 10:16:54 -0800
Message-ID: <efc567ad1a1e4b6045323f2e78bc51ff948f9a75.1770116051.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1770116050.git.isaku.yamahata@intel.com>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70042-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 32052DD81D
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
index 8cd56e9f1cf0..3e02dee38e9c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1813,6 +1813,7 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 		vmcs12->vm_exit_controls = evmcs->vm_exit_controls;
 		vmcs12->secondary_vm_exec_control =
 			evmcs->secondary_vm_exec_control;
+		vmcs12->tertiary_vm_exec_control = 0;
 	}
 
 	if (unlikely(!(hv_clean_fields &
@@ -2510,6 +2511,17 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
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
@@ -2955,6 +2967,11 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
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
index d6d89ae1daec..2a3768a194fe 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -170,6 +170,13 @@ static inline bool nested_cpu_has2(struct vmcs12 *vmcs12, u32 bit)
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
index 4233b5ca9461..2a21864a020a 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -38,6 +38,7 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD64(PML_ADDRESS, pml_address),
 	FIELD64(TSC_OFFSET, tsc_offset),
 	FIELD64(TSC_MULTIPLIER, tsc_multiplier),
+	FIELD64(TERTIARY_VM_EXEC_CONTROL, tertiary_vm_exec_control),
 	FIELD64(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr),
 	FIELD64(APIC_ACCESS_ADDR, apic_access_addr),
 	FIELD64(POSTED_INTR_DESC_ADDR, posted_intr_desc_addr),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 4ad6b16525b9..db1f86a48343 100644
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
@@ -261,6 +261,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(pml_address, 312);
 	CHECK_OFFSET(encls_exiting_bitmap, 320);
 	CHECK_OFFSET(tsc_multiplier, 328);
+	CHECK_OFFSET(tertiary_vm_exec_control, 336);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
-- 
2.45.2



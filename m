Return-Path: <kvm+bounces-70041-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iLsYIeA8gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70041-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:22:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B87DD7F9
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:22:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9BA15314104F
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C76C33D6691;
	Tue,  3 Feb 2026 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gcf2mJic"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760773D6474;
	Tue,  3 Feb 2026 18:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142663; cv=none; b=a/0ZbrDZYXyCAI5+v53EJLoeETYs9ZSQTa0Q2cNjlGkxESKHLdo6I7EVPB2Kefmd1+PDMJcvwuu+yUK7C0YPpcTAg/ljq4+DRM578RB79rv01JDimhgBNUWhSLGI5F3zhLdg/i7y8jDu6psM8nTqZ/psMmZ2IzcvLT1p9olwiYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142663; c=relaxed/simple;
	bh=c9TKvGjIeGGIhjlMGzJs9IJ4jamyM/FgsY22RuZP+Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWnYJgkH7HVspgSlJAwp+sfj+dGGSXVYD+bowDz0nV19SwH9XY0nipV9dl3NgEgCQ7OPZYRz+8I0A6YeNZhHA86cxTw5L4IIwDMlyVurZ2PrC91YbDdWYV1lSS8gg0Hci1K1/cmF1W4CSQIgkQf0vHxMAR6DpJ2uaHCSdd2YA2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gcf2mJic; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142662; x=1801678662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c9TKvGjIeGGIhjlMGzJs9IJ4jamyM/FgsY22RuZP+Tg=;
  b=Gcf2mJicUHeKBWjHlJ5dMJNyZNBLOJNu7TUxvdszgwiKo3nY2M2CGcEO
   3wCfyCP+5IIOcqQnYIaEf+VgHGtZSUAyEwfDkQXQYtsd0gzH3vqoQB+nO
   er3hvcPgFtXRxuFOF1gnjZ/t+g1YO0eBrDzbiI0Y2ZZU+sk/EEnNZbuIM
   al8AVDzajxWhtTJaZy+FrfciduImiRVinZC0TkXO/Vy+JnOro11j8Lprl
   R3Xvj8uIREQri4ZdVYeepRm0R4bajJA8xcOvJ4DnX1cOK7HxC7cAqsSds
   dvAO9jWCLYG19pCqAh7DlJd1r3IVdhLrrS1wihlN4HoANP0bnlBbL9UNv
   Q==;
X-CSE-ConnectionGUID: hqS9oOkxT5KoRYbwAQsvBQ==
X-CSE-MsgGUID: vd/2Kw9hQ2mCFpy7qSxp3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745794"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745794"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:41 -0800
X-CSE-ConnectionGUID: 6lBy9vnTR72Vz8XFoA+OcQ==
X-CSE-MsgGUID: 4ZMv1rGuRGa3vKdWagkSEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605475"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:40 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 10/32] KVM: nVMX: Supports VMX tertiary controls and GUEST_APIC_TIMER bit
Date: Tue,  3 Feb 2026 10:16:53 -0800
Message-ID: <db2b5ea67d9275463f1b613e19fa7194858ca5a1.1770116051.git.isaku.yamahata@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70041-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: E9B87DD7F9
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Emulate MSR_IA32_VMX_PROCBASED_CTLS3 to advertise APIC timer virtualization
feature to the L2 guest.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/hyperv.c       |  7 ++++++
 arch/x86/kvm/vmx/nested.c       | 42 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.h       |  5 ++++
 arch/x86/kvm/x86.h              |  2 +-
 5 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index ffc51fe9a455..f73a50c887ac 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -47,6 +47,7 @@ struct nested_vmx_msrs {
 	u64 cr4_fixed1;
 	u64 vmcs_enum;
 	u64 vmfunc_controls;
+	u64 tertiary_ctls;
 };
 
 struct vmcs_config {
diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index fa41d036acd4..2731c2e4b0e5 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -141,6 +141,13 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
 		ctl_high &= evmcs_get_supported_ctls(EVMCS_2NDEXEC);
 		break;
+	case MSR_IA32_VMX_PROCBASED_CTLS3:
+		/*
+		 * tertiary procbased controls are 64-bit. 0 means unsupported,
+		 * 1 supported.
+		 */
+		*pdata &= evmcs_get_supported_ctls(EVMCS_3RDEXEC);
+		return;
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
 		ctl_high &= evmcs_get_supported_ctls(EVMCS_PINCTRL);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b1b8f0c88ca5..8cd56e9f1cf0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -215,6 +215,11 @@ static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
 	return fixed_bits_valid(control, low, high);
 }
 
+static inline bool vmx_control64_verify(u64 control, u64 msr)
+{
+	return !(control & ~msr);
+}
+
 static inline u64 vmx_control_msr(u32 low, u32 high)
 {
 	return low | ((u64)high << 32);
@@ -1515,6 +1520,19 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
 		return vmx_restore_control_msr(vmx, msr_index, data);
+	case MSR_IA32_VMX_PROCBASED_CTLS3:
+		if (!__nested_cpu_supports_tertiary_ctls(&vmcs_config.nested))
+			return -EINVAL;
+
+		/* read-only for guest. */
+		if (!msr_info->host_initiated)
+			return -EINVAL;
+
+		if (!vmx_control64_verify(data,
+					  vmcs_config.nested.tertiary_ctls))
+			return -EINVAL;
+		vmx->nested.msrs.tertiary_ctls = data;
+		return 0;
 	case MSR_IA32_VMX_MISC:
 		return vmx_restore_vmx_misc(vmx, data);
 	case MSR_IA32_VMX_CR0_FIXED0:
@@ -1612,6 +1630,16 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, struct msr_data *msr_info)
 			msrs->secondary_ctls_low,
 			msrs->secondary_ctls_high);
 		break;
+	case MSR_IA32_VMX_PROCBASED_CTLS3:
+		if (!__nested_cpu_supports_tertiary_ctls(&vmcs_config.nested))
+			return KVM_MSR_RET_UNSUPPORTED;
+
+		if (!msr_info->host_initiated &&
+		    !__nested_cpu_supports_tertiary_ctls(msrs))
+			return -EINVAL;
+
+		*pdata = msrs->tertiary_ctls;
+		break;
 	case MSR_IA32_VMX_EPT_VPID_CAP:
 		*pdata = msrs->ept_caps |
 			((u64)msrs->vpid_caps << 32);
@@ -7314,6 +7342,18 @@ static void nested_vmx_setup_secondary_ctls(u32 ept_caps,
 		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
 }
 
+static void nested_vmx_setup_tertiary_ctls(struct vmcs_config *vmcs_conf,
+					   struct nested_vmx_msrs *msrs)
+{
+	msrs->tertiary_ctls = vmcs_conf->cpu_based_3rd_exec_ctrl;
+
+	msrs->tertiary_ctls &= TERTIARY_EXEC_GUEST_APIC_TIMER;
+
+	if (msrs->tertiary_ctls)
+		msrs->procbased_ctls_high |=
+			CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+}
+
 static void nested_vmx_setup_misc_data(struct vmcs_config *vmcs_conf,
 				       struct nested_vmx_msrs *msrs)
 {
@@ -7402,6 +7442,8 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 
 	nested_vmx_setup_secondary_ctls(ept_caps, vmcs_conf, msrs);
 
+	nested_vmx_setup_tertiary_ctls(vmcs_conf, msrs);
+
 	nested_vmx_setup_misc_data(vmcs_conf, msrs);
 
 	nested_vmx_setup_basic(msrs);
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index f51d7cac8a58..d6d89ae1daec 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -153,6 +153,11 @@ static inline bool nested_cpu_has_vmx_shadow_vmcs(struct kvm_vcpu *vcpu)
 		SECONDARY_EXEC_SHADOW_VMCS;
 }
 
+static inline bool __nested_cpu_supports_tertiary_ctls(struct nested_vmx_msrs *msrs)
+{
+	return msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+}
+
 static inline bool nested_cpu_has(struct vmcs12 *vmcs12, u32 bit)
 {
 	return vmcs12->cpu_based_vm_exec_control & bit;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fdab0ad49098..7ba7abf02bbd 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -92,7 +92,7 @@ do {											\
  * associated feature that KVM supports for nested virtualization.
  */
 #define KVM_FIRST_EMULATED_VMX_MSR	MSR_IA32_VMX_BASIC
-#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_VMFUNC
+#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_PROCBASED_CTLS3
 
 #define KVM_DEFAULT_PLE_GAP		128
 #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
-- 
2.45.2



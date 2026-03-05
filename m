Return-Path: <kvm+bounces-72896-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJqnAFXCqWkhEQEAu9opvQ
	(envelope-from <kvm+bounces-72896-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:50:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F083216809
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB9B731BEF42
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD213ED5AC;
	Thu,  5 Mar 2026 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NxE3PNmD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6173E7165;
	Thu,  5 Mar 2026 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732679; cv=none; b=tK9BxdkJlHSot07nx5hKr0G+ah/ZALQBw689vSDVHmClv8Mq1q04WogA6YluXf8A9ozxzNUj8zQJCYxZ+4yA5oOurcL8XdrpH0zH4YhKoO8wbq/o8pJ9ZQfG5T1yk7VLyk87gTyH65N9zMDaOhI1Via244Z6lwWvBwzpr+mU0bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732679; c=relaxed/simple;
	bh=GYO3BcEy0W4OwMj5OBUNmbyKGduNT0dfVKh7yWRCh0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSzI3JP96N6nBYAH/Wp8+FS5udhVKV8Eb0ztvI2egG6jQwYLq6zQEEro2Qn7jfThzjoY1IrHVgHe6s8aBq1J/0yOTa40QjD6rBzXLfj0wW20RubS5bhGSTsYZLfYUbyWBn7ODOjLstqHnpO/8aebPw7WaCSBlXhyXW3XldkwhAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NxE3PNmD; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732678; x=1804268678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GYO3BcEy0W4OwMj5OBUNmbyKGduNT0dfVKh7yWRCh0U=;
  b=NxE3PNmDszupo14OdVzGiXPRg9qv+6nRjZIxjNVx4axKcXWEqtBnTa/Z
   aXHqUJAcAqD7D8E5Fej0jjt0tDjexy7T4RjdLxuqNjPBDpDZOYNjy7jSg
   xwYrEVVFmcgcwWRYp22skezKoU6vx5W7IiDdbvaGzdegK93sy+xYcoflL
   /DNFw37qFx3Nh8yzGgjvF2Zrz4AdAUPZJfZHsWs64KWrF8YPBtpO8fKFQ
   7k5GwxEJG2zajz9mj3Nw3hFXBUwC+HEUV8cmAqTVcXO2z7dNkYZqNDVTy
   fryCfiYfMUdxt4SyJk+LbPqC+JIi45IRbg89EH8G+CLhB2tB1lWq5sqAV
   g==;
X-CSE-ConnectionGUID: 5S/pC2a6S2eWOMADzBpXnA==
X-CSE-MsgGUID: 4NboIcsPTbixRK3WHyUsPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431565"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431565"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:36 -0800
X-CSE-ConnectionGUID: h4z0xLY+ToyyoNg35eJQKQ==
X-CSE-MsgGUID: NrMiyqIGQGu7PXt2j+XoGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447867"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:36 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	syzbot+ci66a37fb2e2f8de71@syzkaller.appspotmail.com
Subject: [PATCH v2 10/36] KVM: nVMX: Supports VMX tertiary controls and GUEST_APIC_TIMER bit
Date: Thu,  5 Mar 2026 09:43:50 -0800
Message-ID: <fbcfb9547ee374f85d427e23d4d4c61aa9dfb42c.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: 4F083216809
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org,syzkaller.appspotmail.com];
	TAGGED_FROM(0.00)[bounces-72896-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,ci66a37fb2e2f8de71];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Emulate MSR_IA32_VMX_PROCBASED_CTLS3 to advertise APIC timer virtualization
feature to the L2 guest.

Reported-by: syzbot+ci66a37fb2e2f8de71@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/kvm/6982f952.050a0220.3b3015.0012.GAE@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes:
v1 -> v2:
- When in-kernel lapic is disabled, disable nested apic timer
  virtualization.
- disable apic timer virtualization bit in nested tertiary vm exec control
  when in-kernel lapic is disabled.
---
 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/hyperv.c       |  7 +++++
 arch/x86/kvm/vmx/nested.c       | 48 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.h       | 11 ++++++++
 arch/x86/kvm/vmx/vmx.c          |  6 ++++-
 arch/x86/kvm/x86.h              |  2 +-
 6 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c5cb098f579b..8d67be77f02c 100644
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
index 5f0ac8acd768..be6b92b3c66a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -218,6 +218,11 @@ static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
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
@@ -1511,6 +1516,25 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
 		return vmx_restore_control_msr(vmx, msr_index, data);
+	case MSR_IA32_VMX_PROCBASED_CTLS3: {
+		u64 ctls3;
+
+		if (!__nested_cpu_supports_tertiary_ctls(&vmcs_config.nested))
+			return -EINVAL;
+
+		/* read-only for guest. */
+		if (!msr_info->host_initiated)
+			return -EINVAL;
+
+		ctls3 = vmcs_config.nested.tertiary_ctls;
+		if (!nested_cpu_can_support_apic_virt_timer(vcpu))
+			ctls3 &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+
+		if (!vmx_control64_verify(data, ctls3))
+			return -EINVAL;
+		vmx->nested.msrs.tertiary_ctls = data;
+		return 0;
+	}
 	case MSR_IA32_VMX_MISC:
 		return vmx_restore_vmx_misc(vmx, data);
 	case MSR_IA32_VMX_CR0_FIXED0:
@@ -1608,6 +1632,16 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, struct msr_data *msr_info)
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
@@ -7285,6 +7319,18 @@ static void nested_vmx_setup_secondary_ctls(u32 ept_caps,
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
@@ -7373,6 +7419,8 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 
 	nested_vmx_setup_secondary_ctls(ept_caps, vmcs_conf, msrs);
 
+	nested_vmx_setup_tertiary_ctls(vmcs_conf, msrs);
+
 	nested_vmx_setup_misc_data(vmcs_conf, msrs);
 
 	nested_vmx_setup_basic(msrs);
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index d0257447b7cb..8c25054a710e 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -152,6 +152,17 @@ static inline bool nested_cpu_has_vmx_shadow_vmcs(struct kvm_vcpu *vcpu)
 		SECONDARY_EXEC_SHADOW_VMCS;
 }
 
+static inline bool __nested_cpu_supports_tertiary_ctls(struct nested_vmx_msrs *msrs)
+{
+	return msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+}
+
+/* APIC TIMER VIRTUALIZATION requires in-kernel lapic. */
+static inline bool nested_cpu_can_support_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	return cpu_has_vmx_apic_timer_virt() && lapic_in_kernel(vcpu);
+}
+
 static inline bool nested_cpu_has(struct vmcs12 *vmcs12, u32 bit)
 {
 	return vmcs12->cpu_based_vm_exec_control & bit;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9177b693df1b..25f31103cb21 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4985,9 +4985,13 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	init_vmcs(vmx);
 
 	if (nested &&
-	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS))
+	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS)) {
 		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
 
+		if (!nested_cpu_can_support_apic_virt_timer(vcpu))
+			vmx->nested.msrs.tertiary_ctls &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+	}
+
 	vcpu_setup_sgx_lepubkeyhash(vcpu);
 
 	vmx->nested.posted_intr_nv = -1;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 44a28d343d40..1de31aae9c6c 100644
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



Return-Path: <kvm+bounces-70048-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Je8InA9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70048-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:24:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A8BEDD87C
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4380331959DB
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AC83DA7F3;
	Tue,  3 Feb 2026 18:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jzx0wYqa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64363D7D70;
	Tue,  3 Feb 2026 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142666; cv=none; b=lWz6h6RsRXcIScw7lawnzxd7m+qBD4CoEh8BFeDcG5xphpGYmYPRW/qNzBWbu3GQHhKyqmJ/hFAs3USTH395Fo85j74eRhIJjPMOEx6c6nGC4OR0gRQxppP9ZuWELy7CE8ZrYogJTelHleJSYaGw1UMjrVlEhRiqpa59z7XatMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142666; c=relaxed/simple;
	bh=MtffooadCDO7564JErY6ne+USupfnVx4VISpnugLIYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bprsDwVWNa3JRV1U5Sk9Ik73xq0lP8HZVRFsFLH+lvrD5TjGk7cnk2R7ub9HNuxv30QhUlOemgXDG/adQ+BHs95m75kwBEGrMix9RA0dr30Sry6k98BGI6DUyqM/4QsqcJYPl67vqHan5YyG7ZhgNhErzkD3Y0tqHEkYBDYhslw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jzx0wYqa; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142665; x=1801678665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MtffooadCDO7564JErY6ne+USupfnVx4VISpnugLIYQ=;
  b=Jzx0wYqaOuzs940xbCBDLpJydaEzvEOuxPR0ZJchNjjbb0samts3DEC0
   F8YBMUhS50bvuj93+u2PS1wedTNkrADwFuGRtf9vZ4H32IWXm181V1DSQ
   NfczawqUZPsugcBIBQyvT+AkHjzICg9NAP/fIWDTttLlChZK/LJ8dBnTv
   yl1zIdCVPuWeqOu9rxrV1yUPVu78v2PaifhM+gnqnVr2o1au7n3uX9uYA
   26isgINp5EcfenfZF0fMRSMYgI9d5IgwC/Xzz4kmAaDsB306RlsP6ubtd
   V10if45Emq7Z7kKoY/XuVJlfQuCmwWB3+WjPvqH3vyJa9Hzz/KBtVaisV
   w==;
X-CSE-ConnectionGUID: 4iI74/tETzy+PUNlXxQjDw==
X-CSE-MsgGUID: Pi1DVcYETEWCtg4jHoEF9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745814"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745814"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:43 -0800
X-CSE-ConnectionGUID: qyzcQAUgTv2Y3wgSirMolg==
X-CSE-MsgGUID: Nl/bJ16GSwidw17TFMn5TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605492"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:42 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 15/32] KVM: nVMX: Enable guest deadline and its shadow VMCS field
Date: Tue,  3 Feb 2026 10:16:58 -0800
Message-ID: <dbb1e23b41e503692b3f825ebb80e0ccc6870684.1770116051.git.isaku.yamahata@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70048-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 2A8BEDD87C
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Support the guest deadline and the guest deadline shadow VMCS field.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 48 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmcs12.c |  2 ++
 arch/x86/kvm/vmx/vmcs12.h |  6 +++++
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 4 files changed, 58 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5829562145a7..66adc1821671 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2763,6 +2763,22 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	set_cr4_guest_host_mask(vmx);
 }
 
+static void nested_guest_apic_timer(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
+{
+	u64 guest_deadline_shadow = vmcs12->guest_deadline_shadow;
+	u64 guest_deadline = vmcs12->guest_deadline;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!vmx->nested.guest_deadline_dirty)
+		return;
+
+	guest_deadline = vmx_calc_deadline_l1_to_host(vcpu, guest_deadline);
+
+	vmcs_write64(GUEST_DEADLINE_PHY, guest_deadline);
+	vmcs_write64(GUEST_DEADLINE_VIR, guest_deadline_shadow);
+	vmx->nested.guest_deadline_dirty = false;
+}
+
 /*
  * prepare_vmcs02 is called when the L1 guest hypervisor runs its nested
  * L2 guest. L1 has a vmcs for L2 (vmcs12), and this function "merges" it
@@ -2840,6 +2856,9 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (kvm_caps.has_tsc_control)
 		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
 
+	if (nested_cpu_has_guest_apic_timer(vmcs12))
+		nested_guest_apic_timer(vcpu, vmcs12);
+
 	nested_vmx_transition_tlb_flush(vcpu, vmcs12, true);
 
 	if (nested_cpu_has_ept(vmcs12))
@@ -4637,6 +4656,8 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_DEADLINE_PHY:
+	case GUEST_DEADLINE_VIR:
 		return true;
 	default:
 		break;
@@ -4687,6 +4708,24 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 	vmcs12->guest_pending_dbg_exceptions =
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 
+	if (nested_cpu_has_guest_apic_timer(vmcs12)) {
+		u64 guest_deadline_shadow = vmcs_read64(GUEST_DEADLINE_VIR);
+		u64 guest_deadline = vmcs_read64(GUEST_DEADLINE_PHY);
+
+		if (guest_deadline) {
+			guest_deadline = kvm_read_l1_tsc(vcpu, guest_deadline);
+			if (!guest_deadline)
+				guest_deadline = 1;
+		}
+
+		vmcs12->guest_deadline = guest_deadline;
+		vmcs12->guest_deadline_shadow = guest_deadline_shadow;
+	} else if (vmx->nested.msrs.tertiary_ctls & TERTIARY_EXEC_GUEST_APIC_TIMER) {
+		vmcs12->guest_deadline = 0;
+		vmcs12->guest_deadline_shadow = 0;
+	}
+	vmx->nested.guest_deadline_dirty = false;
+
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
 
@@ -5959,6 +5998,13 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		vmx->nested.dirty_vmcs12 = true;
 	}
 
+	if (!is_guest_mode(vcpu) &&
+	    (field == GUEST_DEADLINE_PHY ||
+	     field == GUEST_DEADLINE_PHY_HIGH ||
+	     field == GUEST_DEADLINE_VIR ||
+	     field == GUEST_DEADLINE_VIR_HIGH))
+		vmx->nested.guest_deadline_dirty = true;
+
 	return nested_vmx_succeed(vcpu);
 }
 
@@ -5973,6 +6019,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 	}
 	vmx->nested.dirty_vmcs12 = true;
 	vmx->nested.force_msr_bitmap_recalc = true;
+	vmx->nested.guest_deadline_dirty = true;
 }
 
 /* Emulate the VMPTRLD instruction */
@@ -7150,6 +7197,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 
 	vmx->nested.dirty_vmcs12 = true;
 	vmx->nested.force_msr_bitmap_recalc = true;
+	vmx->nested.guest_deadline_dirty = true;
 	ret = nested_vmx_enter_non_root_mode(vcpu, false);
 	if (ret)
 		goto error_guest_mode;
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 3842ee1ddabf..6849790a0af1 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -70,6 +70,8 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD64(HOST_IA32_PAT, host_ia32_pat),
 	FIELD64(HOST_IA32_EFER, host_ia32_efer),
 	FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
+	FIELD64(GUEST_DEADLINE_PHY, guest_deadline),
+	FIELD64(GUEST_DEADLINE_VIR, guest_deadline_shadow),
 	FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control),
 	FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control),
 	FIELD(EXCEPTION_BITMAP, exception_bitmap),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index d8e09de44f2a..c0d5981475b3 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -192,6 +192,10 @@ struct __packed vmcs12 {
 	u16 host_tr_selector;
 	u16 guest_pml_index;
 	u16 virtual_timer_vector;
+
+	/* offset 0x3e8 */
+	u64 guest_deadline;
+	u64 guest_deadline_shadow;
 };
 
 /*
@@ -375,6 +379,8 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_tr_selector, 994);
 	CHECK_OFFSET(guest_pml_index, 996);
 	CHECK_OFFSET(virtual_timer_vector, 998);
+	CHECK_OFFSET(guest_deadline, 1000);
+	CHECK_OFFSET(guest_deadline_shadow, 1008);
 }
 
 extern const unsigned short vmcs12_field_offsets[];
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 28625a2d17bd..bdeef2e12640 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -169,6 +169,8 @@ struct nested_vmx {
 	bool has_preemption_timer_deadline;
 	bool preemption_timer_expired;
 
+	bool guest_deadline_dirty;
+
 	/*
 	 * Used to snapshot MSRs that are conditionally loaded on VM-Enter in
 	 * order to propagate the guest's pre-VM-Enter value into vmcs02.  For
-- 
2.45.2



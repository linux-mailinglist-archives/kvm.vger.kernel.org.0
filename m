Return-Path: <kvm+bounces-72906-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KCLHDPbBqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72906-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:48:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D8121678D
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:48:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 09F1830162BC
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA054218B1;
	Thu,  5 Mar 2026 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T3p9JFcF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5B23EFD1B;
	Thu,  5 Mar 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732683; cv=none; b=mek5L0wQeif8mr0CE5i4uYC4+RVaOdle901Xe6wy/YLtLgVgvX3cR3JXRYGhQb/Trpkwi3NAtsQX9g+PSmCdoLX2kK8tXPsA/62d9HJePBGRBgbioFrNjg52mHIuqqljBHtysFBWKQC29Q16jnotbAGduJTGD5qB8aQFfH3Wl4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732683; c=relaxed/simple;
	bh=huoyecPz/KqXQIsJELqEpkmIqLLtCWXKLwItJRSV4Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYmNJMQiZgQtx0szYmPCRcgV2EfS54sEf+Kq62tRK0noVjMZN4BzJgCcFoD+Gp2y+NELsmTK3qnBDEGeBOTsZFlgmptCl04KDT/JMKytvzoSsC1pf8Rj4AdhMlTZTy+ti+TzGI+iPje042j6l/NFw9SUTtLQlAkld0vmqHaqFR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T3p9JFcF; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732682; x=1804268682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=huoyecPz/KqXQIsJELqEpkmIqLLtCWXKLwItJRSV4Ww=;
  b=T3p9JFcFdpfuF135KJKs3N72BCQWlj7TXfgZ8cpI/+7+j/+nBBx6n4z8
   S8u1I5MC6JQV7PRzrVRwsPo2GZe4bq3yPzbWV/CKMiFTOcELrLyc3aj5l
   TlHgocjN0lTgORseVkdeuou0Ew26lwyi08tbSqm0qmFNhNM8nrAFBh3rb
   DHGCCZiL3fB04DjJMOugcmUssk2PX4R7Z09E+g/4UC5e94u1e/hsnpgno
   wXOsEf7QZ8R5Z01hs2eytM+WlPO/4NG55ChfSlBgH5LuCZ1x02YxAExDy
   lAu4EaDIHndWiYlmuRiA5MHnhNgm+PHrDCEl3JjqWLBeTXrWHIKz1vlAl
   Q==;
X-CSE-ConnectionGUID: GznQX1t/RSWziGaHCbeHcg==
X-CSE-MsgGUID: mGNGYQneTsq2Kp6gwthNjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431583"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431583"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:39 -0800
X-CSE-ConnectionGUID: 43bUw0QRTcyiNNbpraHERg==
X-CSE-MsgGUID: 74Vlv3WxSmGfw9VvEzNlsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447891"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:38 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 16/36] KVM: nVMX: Enable guest deadline and its shadow VMCS field
Date: Thu,  5 Mar 2026 09:43:56 -0800
Message-ID: <e9d6845e7727f297bd702f5a05c8006f88fc7e8f.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: B6D8121678D
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
	TAGGED_FROM(0.00)[bounces-72906-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Support the guest deadline and the guest deadline shadow VMCS field.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes:
v1 -> v2:
- the offsets of vmcs fields changed due to rebase.
---
 arch/x86/kvm/vmx/nested.c | 48 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmcs12.c |  2 ++
 arch/x86/kvm/vmx/vmcs12.h |  5 ++++
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 4 files changed, 57 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b7561f8f4565..3f1318736205 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2768,6 +2768,22 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
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
@@ -2845,6 +2861,9 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (kvm_caps.has_tsc_control)
 		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
 
+	if (nested_cpu_has_guest_apic_timer(vmcs12))
+		nested_guest_apic_timer(vcpu, vmcs12);
+
 	nested_vmx_transition_tlb_flush(vcpu, vmcs12, true);
 
 	if (nested_cpu_has_ept(vmcs12))
@@ -4635,6 +4654,8 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_DEADLINE_PHY:
+	case GUEST_DEADLINE_VIR:
 		return true;
 	default:
 		break;
@@ -4685,6 +4706,24 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
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
 
@@ -5933,6 +5972,13 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
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
 
@@ -5947,6 +5993,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 	}
 	vmx->nested.dirty_vmcs12 = true;
 	vmx->nested.force_msr_bitmap_recalc = true;
+	vmx->nested.guest_deadline_dirty = true;
 }
 
 /* Emulate the VMPTRLD instruction */
@@ -7124,6 +7171,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 
 	vmx->nested.dirty_vmcs12 = true;
 	vmx->nested.force_msr_bitmap_recalc = true;
+	vmx->nested.guest_deadline_dirty = true;
 	ret = nested_vmx_enter_non_root_mode(vcpu, false);
 	if (ret)
 		goto error_guest_mode;
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index dac796fc20f2..d2098767dd7a 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -70,6 +70,8 @@ static const u16 kvm_supported_vmcs12_field_offsets[] __initconst = {
 	FIELD64(HOST_IA32_PAT, host_ia32_pat),
 	FIELD64(HOST_IA32_EFER, host_ia32_efer),
 	FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
+	FIELD64(GUEST_DEADLINE_PHY, guest_deadline),
+	FIELD64(GUEST_DEADLINE_VIR, guest_deadline_shadow),
 	FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control),
 	FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control),
 	FIELD(EXCEPTION_BITMAP, exception_bitmap),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 7a20d6661da0..0846033b6759 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -192,6 +192,9 @@ struct __packed vmcs12 {
 	u16 host_tr_selector;
 	u16 guest_pml_index;
 	u16 virtual_timer_vector;
+
+	u64 guest_deadline;
+	u64 guest_deadline_shadow;
 };
 
 /*
@@ -376,6 +379,8 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_tr_selector, 994);
 	CHECK_OFFSET(guest_pml_index, 996);
 	CHECK_OFFSET(virtual_timer_vector, 998);
+	CHECK_OFFSET(guest_deadline, 1000);
+	CHECK_OFFSET(guest_deadline_shadow, 1008);
 }
 
 extern u16 vmcs12_field_offsets[] __ro_after_init;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6f1caf3ef5b7..fbbbae46e0b2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -163,6 +163,8 @@ struct nested_vmx {
 	bool has_preemption_timer_deadline;
 	bool preemption_timer_expired;
 
+	bool guest_deadline_dirty;
+
 	/*
 	 * Used to snapshot MSRs that are conditionally loaded on VM-Enter in
 	 * order to propagate the guest's pre-VM-Enter value into vmcs02.  For
-- 
2.45.2



Return-Path: <kvm+bounces-70503-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eD0vKo0+hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70503-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:18:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6004810299D
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6953930F1C0B
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5E7C449EA8;
	Fri,  6 Feb 2026 19:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VLiu3UQw"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894934418E1
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404992; cv=none; b=HaMZAH8L1JR3T9p4UIxFCo74I/bQ6X5fsVIBSNQ/xg4y/lXMn/exUPR4F520ARt6WVEMuejvBRplk68w/YcDjhJ+DG0L/wq6zJXe0LUlbR1lLM26XSmnTRKNU7NL1OMM4zUcs6f+ayPBZhajYvOQCENsSarzWe2AYD8ksBL2t8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404992; c=relaxed/simple;
	bh=UR82i0rKsjMPvvFyaxQqjSxuopCoGUDmtDTfiU5AeG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVlxyhXHuY6bi8uiPF+RY3ror4k2ocpgkr6GnfS06ybGbI8j1kCHs4mm/1rhhhSor73ZDhABuoFoR3IfMNfGwEOMqV5mWtRcKQLxYHb7JM/ThdCKUCMaZyajTcTa73JfOEPSxcp6SlGgm93z7xq0FTHumQTt4wsT9x1Hg+le/+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VLiu3UQw; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=37/5OKaxAssey0ciUs5DRHclakNo+RTAWEaX8rkwNvA=;
	b=VLiu3UQwr/E35h50dD1s0hjJ2fDD3bvpKTPgyckyz4sCtzVGnBhp4cjjy4g52v11u366+l
	Go6kj3QBBqEEWIER2X3yEBoQ70mU3BCCvflcR8vKkTCdLWuVoxUDCZxIoW8sU7a1MMYgDK
	ug/eY3UjvYzi1Cb1IHIDX7x6KhtAIYg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v5 25/26] KVM: nSVM: Sanitize control fields copied from VMCB12
Date: Fri,  6 Feb 2026 19:08:50 +0000
Message-ID: <20260206190851.860662-26-yosry.ahmed@linux.dev>
In-Reply-To: <20260206190851.860662-1-yosry.ahmed@linux.dev>
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70503-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.997];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 6004810299D
X-Rspamd-Action: no action

Make sure all fields used from VMCB12 in creating the VMCB02 are
sanitized, such that no unhandled or reserved bits end up in the VMCB02.

The following control fields are read from VMCB12 and have bits that are
either reserved or not handled/advertised by KVM: tlb_ctl, int_ctl,
int_state, int_vector, event_inj, misc_ctl, and misc_ctl2.

The following fields do not require any extra sanitizing:
- int_ctl: bits from VMCB12 are copied bit-by-bit as needed.
- misc_ctl: only used in consistency checks (particularly NP_ENABLE).
- misc_ctl2: bits from VMCB12 are copied bit-by-bit as needed.

For the remaining fields, make sure only defined bits are copied from
L1's VMCB12 into KVM'cache by defining appropriate masks where needed.
The only exception is tlb_ctl, which is unused, so remove it.

Opportunistically cleanup ignoring the lower bits of {io/msr}pm_base_pa
in __nested_copy_vmcb_control_to_cache() by using PAGE_MASK. Also, move
the ASID copying ahead with other special cases, and expand the comment
about the ASID being copied only for consistency checks.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h |  5 +++++
 arch/x86/kvm/svm/nested.c  | 28 +++++++++++++++-------------
 arch/x86/kvm/svm/svm.h     |  1 -
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index c169256c415f..fe3b6d9cea31 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -222,6 +222,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define X2APIC_MODE_SHIFT 30
 #define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
 
+#define SVM_INT_VECTOR_MASK GENMASK(7, 0)
+
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
@@ -635,6 +637,9 @@ static inline void __unused_size_checks(void)
 #define SVM_EVTINJ_VALID (1 << 31)
 #define SVM_EVTINJ_VALID_ERR (1 << 11)
 
+#define SVM_EVTINJ_RESERVED_BITS ~(SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | \
+				   SVM_EVTINJ_VALID_ERR | SVM_EVTINJ_VALID)
+
 #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
 #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0a7bb01f5404..c87738962970 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -499,32 +499,35 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
 		to->misc_ctl &= ~SVM_MISC_ENABLE_NP;
 
-	to->iopm_base_pa        = from->iopm_base_pa;
-	to->msrpm_base_pa       = from->msrpm_base_pa;
+	/*
+	 * Copy the ASID here because nested_vmcb_check_controls() will check
+	 * it.  The ASID could be invalid, or conflict with another VM's ASID ,
+	 * so it should never be used directly to run L2.
+	 */
+	to->asid = from->asid;
+
+	/* Lower bits of IOPM_BASE_PA and MSRPM_BASE_PA are ignored */
+	to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
+	to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
+
 	to->tsc_offset          = from->tsc_offset;
-	to->tlb_ctl             = from->tlb_ctl;
 	to->erap_ctl            = from->erap_ctl;
 	to->int_ctl             = from->int_ctl;
-	to->int_vector          = from->int_vector;
-	to->int_state           = from->int_state;
+	to->int_vector          = from->int_vector & SVM_INT_VECTOR_MASK;
+	to->int_state           = from->int_state & SVM_INTERRUPT_SHADOW_MASK;
 	to->exit_code           = from->exit_code;
 	to->exit_info_1         = from->exit_info_1;
 	to->exit_info_2         = from->exit_info_2;
 	to->exit_int_info       = from->exit_int_info;
 	to->exit_int_info_err   = from->exit_int_info_err;
-	to->event_inj           = from->event_inj;
+	to->event_inj           = from->event_inj & ~SVM_EVTINJ_RESERVED_BITS;
 	to->event_inj_err       = from->event_inj_err;
 	to->next_rip            = from->next_rip;
 	to->nested_cr3          = from->nested_cr3;
-	to->misc_ctl2            = from->misc_ctl2;
+	to->misc_ctl2		= from->misc_ctl2;
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
-	/* Copy asid here because nested_vmcb_check_controls() will check it */
-	to->asid           = from->asid;
-	to->msrpm_base_pa &= ~0x0fffULL;
-	to->iopm_base_pa  &= ~0x0fffULL;
-
 #ifdef CONFIG_KVM_HYPERV
 	/* Hyper-V extensions (Enlightened VMCB) */
 	if (kvm_hv_hypercall_enabled(vcpu)) {
@@ -1832,7 +1835,6 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
 	dst->tsc_offset           = from->tsc_offset;
 	dst->asid                 = from->asid;
-	dst->tlb_ctl              = from->tlb_ctl;
 	dst->erap_ctl             = from->erap_ctl;
 	dst->int_ctl              = from->int_ctl;
 	dst->int_vector           = from->int_vector;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 388aaa5d63d2..0bb93879abfe 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -176,7 +176,6 @@ struct vmcb_ctrl_area_cached {
 	u64 msrpm_base_pa;
 	u64 tsc_offset;
 	u32 asid;
-	u8 tlb_ctl;
 	u8 erap_ctl;
 	u32 int_ctl;
 	u32 int_vector;
-- 
2.53.0.rc2.204.g2597b5adb4-goog



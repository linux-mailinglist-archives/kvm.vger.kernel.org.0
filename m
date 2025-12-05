Return-Path: <kvm+bounces-65324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BB402CA6B19
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 09:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 055F232C8CE8
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F8634A77C;
	Fri,  5 Dec 2025 07:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XZuoENj7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XZuoENj7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE908339709
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920812; cv=none; b=e7wJZ5cTjkdF+A+Ac4UyROEmIR4bWp1RWsk8p+BOh7MwFY3/36HWkQ4pzpQQ+p9yp9F/ajuLxnF2N+2lNkXcAh0LIv8FhEOIo+AEcjhuT2MbJZQHoeSe5d4+BpYTKnXEadfPKLNO44EGF4jvSjvz5K7GOZjGk/fMben1Flthy90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920812; c=relaxed/simple;
	bh=CmxEd3gwC/8Nz/x9nvFR4obE78Cdg8JtwhxAC4uFGFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBGkhPGFDK9F5wg3g1IaUgIgr1cuWSfhXhhMOKlRPbibbmMb6VmGdYSGwysXU4OaJzN6Gbh7ngjjq8waax1lIgAzaOeQfNa6NcRHzbBKoUy+8aizEdqEKZljIY0dDW+XjZDcuz9DK2yy7dZSNWt/k2QK/iD+cARi7iz8T+mMDVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XZuoENj7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XZuoENj7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D3C25BD1E;
	Fri,  5 Dec 2025 07:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wNVZfctafYmu8yiKdSAno+os0/M8AOzDx0NA54YEouo=;
	b=XZuoENj7PRNgEvavCSBK382SMW36i9zpaARDYnzy6XHF3C1i701lNf6GQEGlzMTSZCVz+L
	i5zt0gBM4k/kqtHQnGVaUtFkPYNfCO2D8xqyiSsLAZFHZi54fewodFB+a1pshhxFBWliKj
	pjO8E/HUr21PMSGLRCl3JxlNW6/UKo8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wNVZfctafYmu8yiKdSAno+os0/M8AOzDx0NA54YEouo=;
	b=XZuoENj7PRNgEvavCSBK382SMW36i9zpaARDYnzy6XHF3C1i701lNf6GQEGlzMTSZCVz+L
	i5zt0gBM4k/kqtHQnGVaUtFkPYNfCO2D8xqyiSsLAZFHZi54fewodFB+a1pshhxFBWliKj
	pjO8E/HUr21PMSGLRCl3JxlNW6/UKo8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C904F3EA63;
	Fri,  5 Dec 2025 07:46:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EL2KL8aNMmmBEgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:46:14 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 06/10] KVM/x86: Use defines for APIC related MSR emulation
Date: Fri,  5 Dec 2025 08:45:33 +0100
Message-ID: <20251205074537.17072-7-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205074537.17072-1-jgross@suse.com>
References: <20251205074537.17072-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.988];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	R_RATELIMIT(0.00)[to_ip_from(RLfdszjqhz8kzzb9uwpzdm8png)];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

Instead of "0" and "1" use the related KVM_MSR_RET_* defines in the
emulation code of APIC related MSR registers.

No change of functionality intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/lapic.c | 48 ++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..bd4c0768b270 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2339,7 +2339,7 @@ static int get_lvt_index(u32 reg)
 
 static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 {
-	int ret = 0;
+	int ret = KVM_MSR_RET_OK;
 
 	trace_kvm_apic_write(reg, val);
 
@@ -2348,7 +2348,7 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		if (!apic_x2apic_mode(apic)) {
 			kvm_apic_set_xapic_id(apic, val >> 24);
 		} else {
-			ret = 1;
+			ret = KVM_MSR_RET_ERR;
 		}
 		break;
 
@@ -2365,14 +2365,14 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		if (!apic_x2apic_mode(apic))
 			kvm_apic_set_ldr(apic, val & APIC_LDR_MASK);
 		else
-			ret = 1;
+			ret = KVM_MSR_RET_ERR;
 		break;
 
 	case APIC_DFR:
 		if (!apic_x2apic_mode(apic))
 			kvm_apic_set_dfr(apic, val | 0x0FFFFFFF);
 		else
-			ret = 1;
+			ret = KVM_MSR_RET_ERR;
 		break;
 
 	case APIC_SPIV: {
@@ -2403,7 +2403,7 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 	case APIC_ICR2:
 		if (apic_x2apic_mode(apic))
-			ret = 1;
+			ret = KVM_MSR_RET_ERR;
 		else
 			kvm_lapic_set_reg(apic, APIC_ICR2, val & 0xff000000);
 		break;
@@ -2418,7 +2418,7 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_LVTCMCI: {
 		u32 index = get_lvt_index(reg);
 		if (!kvm_lapic_lvt_supported(apic, index)) {
-			ret = 1;
+			ret = KVM_MSR_RET_ERR;
 			break;
 		}
 		if (!kvm_apic_sw_enabled(apic))
@@ -2460,7 +2460,7 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	}
 	case APIC_ESR:
 		if (apic_x2apic_mode(apic) && val != 0)
-			ret = 1;
+			ret = KVM_MSR_RET_ERR;
 		break;
 
 	case APIC_SELF_IPI:
@@ -2469,12 +2469,12 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		 * the vector, everything else is reserved.
 		 */
 		if (!apic_x2apic_mode(apic) || (val & ~APIC_VECTOR_MASK))
-			ret = 1;
+			ret = KVM_MSR_RET_ERR;
 		else
 			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
 		break;
 	default:
-		ret = 1;
+		ret = KVM_MSR_RET_ERR;
 		break;
 	}
 
@@ -2532,7 +2532,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lapic_set_eoi);
 static int __kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data, bool fast)
 {
 	if (data & X2APIC_ICR_RESERVED_BITS)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	/*
 	 * The BUSY bit is reserved on both Intel and AMD in x2APIC mode, but
@@ -2565,7 +2565,7 @@ static int __kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data, bool fast)
 		kvm_lapic_set_reg64(apic, APIC_ICR, data);
 	}
 	trace_kvm_apic_write(APIC_ICR, data);
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
@@ -2728,23 +2728,23 @@ int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated)
 	enum lapic_mode new_mode = kvm_apic_mode(value);
 
 	if (vcpu->arch.apic_base == value)
-		return 0;
+		return KVM_MSR_RET_OK;
 
 	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
 		(guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
 
 	if ((value & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
-		return 1;
+		return KVM_MSR_RET_ERR;
 	if (!host_initiated) {
 		if (old_mode == LAPIC_MODE_X2APIC && new_mode == LAPIC_MODE_XAPIC)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (old_mode == LAPIC_MODE_DISABLED && new_mode == LAPIC_MODE_X2APIC)
-			return 1;
+			return KVM_MSR_RET_ERR;
 	}
 
 	__kvm_apic_set_base(vcpu, value);
 	kvm_recalculate_apic_map(vcpu->kvm);
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_apic_set_base);
 
@@ -3362,15 +3362,15 @@ static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
 
 	if (reg == APIC_ICR) {
 		*data = kvm_x2apic_icr_read(apic);
-		return 0;
+		return KVM_MSR_RET_OK;
 	}
 
 	if (kvm_lapic_reg_read(apic, reg, 4, &low))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	*data = low;
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data)
@@ -3385,7 +3385,7 @@ static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data)
 
 	/* Bits 63:32 are reserved in all other registers. */
 	if (data >> 32)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
@@ -3396,7 +3396,7 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	u32 reg = (msr - APIC_BASE_MSR) << 4;
 
 	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	return kvm_lapic_msr_write(apic, reg, data);
 }
@@ -3407,7 +3407,7 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	u32 reg = (msr - APIC_BASE_MSR) << 4;
 
 	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	return kvm_lapic_msr_read(apic, reg, data);
 }
@@ -3415,7 +3415,7 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
 {
 	if (!lapic_in_kernel(vcpu))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	return kvm_lapic_msr_write(vcpu->arch.apic, reg, data);
 }
@@ -3423,7 +3423,7 @@ int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
 int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
 {
 	if (!lapic_in_kernel(vcpu))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	return kvm_lapic_msr_read(vcpu->arch.apic, reg, data);
 }
-- 
2.51.0



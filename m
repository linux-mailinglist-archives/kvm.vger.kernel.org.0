Return-Path: <kvm+bounces-30349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD259B97B7
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:38:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22282B2152C
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE621CF2AF;
	Fri,  1 Nov 2024 18:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dgfN+Q51"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411601D0DE9
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730486173; cv=none; b=pvRPMxm3qI23LF2g/QnNaUgiHTIJmZ3Mv6EnJNlZpKMvjpcH0GMhtcqBC/+Lr/tOCQr1V22+FwF6QO63T8P7t2NBFLPZYkqD0AEZyPuDgS44EO1gEE+P0wFPcDrRu637PTspNSOnRu3ZuzJlUc6w+Zh3ozp+jvWTa1zNoqNuz74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730486173; c=relaxed/simple;
	bh=/frGkRXoQlzrjkWvNh5KGw/1JeGin0TpI2B3D2X+sy8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nbv84/rjJ70tKWPkRk7h8iZdr5cwL2NCBVw+1L7UpvbBL1S+LWm5+pgad+kzqG/RX+9hwqr4BuMYtjpG74wIEFp7MzHuvuzekpnKjit/ZycKRcPKB7/uTlAGPomL3btWCuwviXss6bvZyzqSPabjFEK3qGSylLqnX9O4+9ykY/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dgfN+Q51; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e38fabff35so43718097b3.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730486171; x=1731090971; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=o15oczZjLr65ny5I+TbaXC6dNA2ZMYul3o5wZUJGViI=;
        b=dgfN+Q51vS8AgcAnzRzp26kucDbAP5S5O0P9bbVJvLvU6Lzx2BTHWEurFjU9ywaM3S
         +BLOtYGSy0JGyKHt1oMNI9q3SH7vo2tXd3YcNtMqPdXPTC07usx1bKD6XL8kRz5ZaXXC
         PO1f0Ik+897lSmQR2Ki0bT6kVT2Ew0wqO1XWK2QgH/6Gjj1BSTQ77Z4JhZ2AJ99iuUM0
         4xIkXzwYH4AbDR46jXjqnmNTpZBNh7emm/zd8nvIfZTgYEMkJJ6endCQuw7EgWKym6U2
         3FAgAGbzGBuk03f3b+GDIQaRIQXwqD5KLuz/1qtTJDJTEeTbVr1LPMlun8jRNNiVjo1l
         8wnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730486171; x=1731090971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o15oczZjLr65ny5I+TbaXC6dNA2ZMYul3o5wZUJGViI=;
        b=Y4nAZq0OG5QaN+gOF9DLUzEnjnSSN+ASoQrjrjapRngrHX8dk1VixjGjOzkGnzpqfr
         WS4iS4EOe48PE0WmrhnUfg2fACWhhYnYrIQFUfhEkebK4X39bcAsF9mfvl30ZaYm5tt/
         mPJkKY+Eh26qRWVPZtFFJb3TWs1QjXMvvJYQvrRaj8bfd7D5An5iQB7NZWbDAL/R+r22
         JW9RLzk5cAQFJRGsV/0s3N4IUhb+b+gyNDx6TYt3U5wwSSQ2afKLk5JMu9dN/Oa35oPi
         F3d+NE5mH0bVKm0A/CHfJ2Z1ohhTxpJvq2gNREb5IsjstJ9MD63sAyMhIg0TYO8hXF4j
         5JNQ==
X-Gm-Message-State: AOJu0Yw3UDOrkmKl9eXdBnbw3pajii99jTk/ich05cRnGISzEAU1BtkC
	xamPc8VbKmttLQEXeCEVglLlVFD/6cX5vjexyqbEj4Av1NkTRt3XDHPlrxpqa40C2+c76JD4RHi
	aXA==
X-Google-Smtp-Source: AGHT+IFAnYY7eTRPwUDiTbrEgfBgDblXGdjqSKzoGufvhnLN4rVG8UxtuXTk54TsLBw0n2mqTw17pJu+pNo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4510:b0:6e2:371f:4afe with SMTP id
 00721157ae682-6e9d8b21492mr11215937b3.4.1730486171289; Fri, 01 Nov 2024
 11:36:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 11:35:52 -0700
In-Reply-To: <20241101183555.1794700-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101183555.1794700-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101183555.1794700-7-seanjc@google.com>
Subject: [PATCH v2 6/9] KVM: x86: Rename APIC base setters to better capture
 their relationship
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename kvm_set_apic_base() and kvm_lapic_set_base() to kvm_apic_set_base()
and __kvm_apic_set_base() respectively to capture that the underscores
version is a "special" variant (it exists purely to avoid recalculating
the optimized map multiple times when stuffing the RESET value).

Opportunistically add a comment explaining why kvm_lapic_reset() uses the
inner helper.  Note, KVM deliberately invokes kvm_arch_vcpu_create() while
kvm->lock is NOT held so that vCPU setup isn't serialized if userspace is
creating multiple/all vCPUs in parallel.  I.e. triggering an extra
recalculation is not limited to theoretical/rare edge cases, and so is
worth avoiding.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20241009181742.1128779-7-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 15 +++++++++++----
 arch/x86/kvm/lapic.h |  3 +--
 arch/x86/kvm/x86.c   |  4 ++--
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b4cc5b0e8796..0472a94e7b3b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2577,7 +2577,7 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
 	return (tpr & 0xf0) >> 4;
 }
 
-void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
+static void __kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value)
 {
 	u64 old_value = vcpu->arch.apic_base;
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -2628,7 +2628,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	}
 }
 
-int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+int kvm_apic_set_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
 	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
@@ -2644,7 +2644,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 	}
 
-	kvm_lapic_set_base(vcpu, msr_info->data);
+	__kvm_apic_set_base(vcpu, msr_info->data);
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
@@ -2740,7 +2740,14 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
 		if (kvm_vcpu_is_reset_bsp(vcpu))
 			msr_val |= MSR_IA32_APICBASE_BSP;
-		kvm_lapic_set_base(vcpu, msr_val);
+
+		/*
+		 * Use the inner helper to avoid an extra recalcuation of the
+		 * optimized APIC map if some other task has dirtied the map.
+		 * The recalculation needed for this vCPU will be done after
+		 * all APIC state has been initialized (see below).
+		 */
+		__kvm_apic_set_base(vcpu, msr_val);
 	}
 
 	if (!apic)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index fc4bd36d44cf..0dd5055852ad 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -95,7 +95,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
-void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 void kvm_recalculate_apic_map(struct kvm *kvm);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
@@ -117,7 +116,7 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
-int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+int kvm_apic_set_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 57dca2bdd40d..e01188dc82d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3863,7 +3863,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_MTRRdefType:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
-		return kvm_set_apic_base(vcpu, msr_info);
+		return kvm_apic_set_base(vcpu, msr_info);
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_write(vcpu, msr, data);
 	case MSR_IA32_TSC_DEADLINE:
@@ -11879,7 +11879,7 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 
 	apic_base_msr.data = sregs->apic_base;
 	apic_base_msr.host_initiated = true;
-	if (kvm_set_apic_base(vcpu, &apic_base_msr))
+	if (kvm_apic_set_base(vcpu, &apic_base_msr))
 		return -EINVAL;
 
 	if (vcpu->arch.guest_state_protected)
-- 
2.47.0.163.g1226f6d8fa-goog



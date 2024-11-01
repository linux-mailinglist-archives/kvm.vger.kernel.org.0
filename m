Return-Path: <kvm+bounces-30351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A42F29B97BC
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2887D1F233FA
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C781D1F4D;
	Fri,  1 Nov 2024 18:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HgoMX9CP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337831D12FB
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730486177; cv=none; b=ZNAzgJaZXC/68Q9rA3RIRIQyaH9v67dBgw+UcEPzKlJu4DyznUJ4FdMejbf4DswMW/R1/ZXdrw7IldltN4pMDTbCm8xz9DaxrxI9wh82oYgZFxjeQIrO6knLpzuQW8NbYxwJaQNsew0LZqlK8RdbiVoeqnBx2hoXKrC+B68dQ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730486177; c=relaxed/simple;
	bh=xTRxQxZLwJ4nMy+y+tKIFp/3uKotLx1vv5T1qyPMJ2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NkmKTA4jfPWZ05ju7Uj87MDCi/0HzD+R2EFxvol6ZnYXRlT3fUvemMmg/5b7SmqiWbdMAs8B2ykn2VmCtTvxUNqXdHb4Glys856inBCjX0mENKDMEf69jrxHdXV/dclk8AI4/GyS6s6u6XLOyeJQKgOg4xOQp6EJTZhcDTbaTgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HgoMX9CP; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e0082c1dd0so53005267b3.3
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730486175; x=1731090975; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rdMTMV14I8S9mlDGalYCD9r7IonKg5RbW8JA0XpZZZo=;
        b=HgoMX9CPtqRFtczCPAbPWWAWyumSuMkQKj0eibfdGCmVjKGvruo5I615+91UkIvKEx
         cnhN8yLJh2RufT6MgTOk8hw84Uyv8Jhb4tiR0H3VuXV1i5Al/MaQHCxVV56ZtDkfDGjM
         JmZFN7btEbB8CTPHvm1/ZVwCeSHCEJSt+mUxx47bXa9blkfJ0U6mdYzutsL2Qw0/GG8O
         SwGrwAMMq6IVpkLdfEwmtMsMqSrNbxENlfTIrI1z0+RV+Nm/5NUChPYY09gZ5sSkvPDl
         D61Nx4ybXGAguX0cg8AfUtLKI3EMaGd+vMTV8DZkKs1ZgxRS585/DRoN3I06/m715Q5e
         cvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730486175; x=1731090975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rdMTMV14I8S9mlDGalYCD9r7IonKg5RbW8JA0XpZZZo=;
        b=jEDIvOMwYS3wFYMsOKrE+mnIOU/xLIN+6VhOe+j1zzwOQfOoZVtnwLlVvF1xMK4u74
         y3HU7WCfNxEEBICgUcAa1tFZ+yifH4I2KLJcBv8bQpUcQZHA03fMv0tGB11WWA//n+ii
         UVFjsMTiZGWZLdu65BWJA55EDqwnXyOtvRpf29gK2Ukv5+yqYmsQaPae83VwmRDbN9c5
         UnIWhnGM+bGo/0VXwlnDCqydeLs2s5M7KRfskL1CBiKbnfY4sRszO5ExtoSe8hd6KpAV
         ogL7+Qhr7r+5nAzCoxcT+WLGc0HIghWfXgJpfjY39kjsg5GqHzauOk7otEWxmdLoquKT
         oTww==
X-Gm-Message-State: AOJu0YyF0gl7chM4n7LA2+1kgofC4R39mbi5qCtAh2p4vHmA8t0NujdG
	hzu1tPlkVOnVSyqLPlujEKJQmdldfVG1aUowzJB1sIMeXL23Up/TnjZCd0tPK0A0egVtVRBQgwB
	+0Q==
X-Google-Smtp-Source: AGHT+IHPt+QUH9dPUzxntcxqiIHKttKNl1vJk3v2qJSERf0BWXO6FKSBZF5MJjSzw0vlhoa9bYeqWzIk7uo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:aa66:0:b0:e29:6e61:3daf with SMTP id
 3f1490d57ef6-e30cf3e6ac7mr7184276.2.1730486174949; Fri, 01 Nov 2024 11:36:14
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 11:35:54 -0700
In-Reply-To: <20241101183555.1794700-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101183555.1794700-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101183555.1794700-9-seanjc@google.com>
Subject: [PATCH v2 8/9] KVM: x86: Unpack msr_data structure prior to calling kvm_apic_set_base()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Pass in the new value and "host initiated" as separate parameters to
kvm_apic_set_base(), as forcing the KVM_SET_SREGS path to declare and fill
an msr_data structure is awkward and kludgy, e.g. __set_sregs_common()
doesn't even bother to set the proper MSR index.

No functional change intended.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 10 +++++-----
 arch/x86/kvm/lapic.h |  2 +-
 arch/x86/kvm/x86.c   |  7 ++-----
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7ddbebf78761..7b2342e40e4e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2628,23 +2628,23 @@ static void __kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	}
 }
 
-int kvm_apic_set_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated)
 {
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
-	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
+	enum lapic_mode new_mode = kvm_apic_mode(value);
 	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
 		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
 
-	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
+	if ((value & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
 		return 1;
-	if (!msr_info->host_initiated) {
+	if (!host_initiated) {
 		if (old_mode == LAPIC_MODE_X2APIC && new_mode == LAPIC_MODE_XAPIC)
 			return 1;
 		if (old_mode == LAPIC_MODE_DISABLED && new_mode == LAPIC_MODE_X2APIC)
 			return 1;
 	}
 
-	__kvm_apic_set_base(vcpu, msr_info->data);
+	__kvm_apic_set_base(vcpu, value);
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index fdd6cf29a0be..24add38beaf0 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -115,7 +115,7 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
-int kvm_apic_set_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e01188dc82d1..8637bc001096 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3863,7 +3863,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_MTRRdefType:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
-		return kvm_apic_set_base(vcpu, msr_info);
+		return kvm_apic_set_base(vcpu, data, msr_info->host_initiated);
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_write(vcpu, msr, data);
 	case MSR_IA32_TSC_DEADLINE:
@@ -11870,16 +11870,13 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 		int *mmu_reset_needed, bool update_pdptrs)
 {
-	struct msr_data apic_base_msr;
 	int idx;
 	struct desc_ptr dt;
 
 	if (!kvm_is_valid_sregs(vcpu, sregs))
 		return -EINVAL;
 
-	apic_base_msr.data = sregs->apic_base;
-	apic_base_msr.host_initiated = true;
-	if (kvm_apic_set_base(vcpu, &apic_base_msr))
+	if (kvm_apic_set_base(vcpu, sregs->apic_base, true))
 		return -EINVAL;
 
 	if (vcpu->arch.guest_state_protected)
-- 
2.47.0.163.g1226f6d8fa-goog



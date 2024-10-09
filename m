Return-Path: <kvm+bounces-28308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 630A19974C7
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 20:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 114991F22EC5
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C233B1E32BE;
	Wed,  9 Oct 2024 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IwBjmCun"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE0A1E283F
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728497878; cv=none; b=oSthG0+v1APiFezN1w1bVmgk/2ZT0vC3/DTjQyfa/mERNvObg1is6ZCOH2Hg3UHQYcx1W6hLhjxcLZAROifnHshWt54ZPvsMkC+PxPju5dk9E5IrI3Axhmx7aVo8GvD10fccp2OnD8Zx4x9nH/AmjWkeD4aSVdkozgfa5hu4iIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728497878; c=relaxed/simple;
	bh=lT1ZYT62nfExH90IUevqSKyYCT9nh/Q35XBGNwwaFTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aDdNoMrYyf09FgppivnWGJvGgHrXsbZZ5IL4QPONIYWfcRrqAqe/q1Rvv7IJoQwZfMjeCufLO5IZpZVMuAhYX7PVuJZT8T8jKct+Fghrz4ZVah5IqmjIl6xRwmnSlK+NGqAqbI+t06MPh0dql7n2f+Ps4OrNAss0WZGdhHLS4wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IwBjmCun; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e26ba37314so5833737b3.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 11:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728497875; x=1729102675; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Kt7FHOB1935LxbC6vNqAogsIeVnq7546lEYAivm6tgg=;
        b=IwBjmCunJKcjnpHjPu3yLpGnAYlIglcmQtpe5d5tZReInudwhtCzZSrUX/i/zXaq44
         Bgi0CG9LiUR3NwKYcyx9ZWXY3crwgMSONiEfemSS8j7AHQ483g8iOmxWF3bynlaQUlmJ
         QR7bD0dKTRXl7pNYGiKQR1qYcG5gmzxjfsW8ZGzc8czwNiwnSvYcmwWDAxbBjMZFekas
         5wihCJjsCMtqqGxktX1RGaITxnl/xh+MAAbsD6YE5sgYiJEhxp/S8lLWXZm7RO6Fn9iz
         aSh767f6xIGpwSnZ/2KOjWDRxCGnIqEQrN2W3/dIi0kS3Uxo/b2GxaMI7D+hgEvxJH82
         WMLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728497875; x=1729102675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kt7FHOB1935LxbC6vNqAogsIeVnq7546lEYAivm6tgg=;
        b=SD4ApxTChB21g6H5Lb/r8WHmdF4dnxU0tmEzu0R0SVgrBseV3B7YKKB7O/dl0Wde8Y
         7Zf0uZu/C4+CB+Peg1hOf0FAOVXFIoMN79gswlHJxR1kXhJQlkjdNlHwDktRfdRunUu3
         o9v4u6wSpYxASsoawAflF26jwc9YOMbqWoSmRTO+h4zPc5zB+h7mMU5iWGiPLl5/9RU3
         OpRYxaHSSeHuPWi1GgEix/9xp4NiXYsHEOmCw8CkvenJWcFBsMEkFF/BI6pZSexifcDC
         OUwt/xjqWw00/qtrrEBSUIqqMsVlTf32zv8tEF5OA2tk0yuccA9BNIef/COZDS1zqUKS
         izgQ==
X-Gm-Message-State: AOJu0YyeMChXHGPhZUr5ZJ8EChmoWqh0lZwpObICNz8SJ8ZC+hkU2ziZ
	XnCrC7AVk+fgaolYcG3s1YM8vpRbOkXRHlBCUCqZQBV4YVy008Y4mEv6G4uFeRVSVCmEGs8gNK9
	GXQ==
X-Google-Smtp-Source: AGHT+IGocRXOmVCQlqmoBkHUcGAAivPICXDUGWlVk79DtpyGqwVyyI7/c8wZnPktuAFL8/nvHRwhlb2HbiE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:d806:0:b0:e22:5fcb:5e22 with SMTP id
 3f1490d57ef6-e28fe33b922mr2742276.3.1728497875306; Wed, 09 Oct 2024 11:17:55
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 11:17:40 -0700
In-Reply-To: <20241009181742.1128779-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009181742.1128779-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009181742.1128779-7-seanjc@google.com>
Subject: [PATCH 6/7] KVM: x86: Rename APIC base setters to better capture
 their relationship
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Rename kvm_set_apic_base() and kvm_lapic_set_base() to kvm_apic_set_base()
and __kvm_apic_set_base() respectively to capture that the underscores
version is a "special" variant (it exists purely to avoid recalculating
the optimized map multiple times when stuffing the RESET value).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 8 ++++----
 arch/x86/kvm/lapic.h | 3 +--
 arch/x86/kvm/x86.c   | 4 ++--
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6239cfd89aad..0a73d9a09fe0 100644
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
@@ -2752,7 +2752,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
 		if (kvm_vcpu_is_reset_bsp(vcpu))
 			msr_val |= MSR_IA32_APICBASE_BSP;
-		kvm_lapic_set_base(vcpu, msr_val);
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
index a2a2a6126e67..803db3e9ab8a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3858,7 +3858,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_MTRRdefType:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
-		return kvm_set_apic_base(vcpu, msr_info);
+		return kvm_apic_set_base(vcpu, msr_info);
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_write(vcpu, msr, data);
 	case MSR_IA32_TSC_DEADLINE:
@@ -11865,7 +11865,7 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 
 	apic_base_msr.data = sregs->apic_base;
 	apic_base_msr.host_initiated = true;
-	if (kvm_set_apic_base(vcpu, &apic_base_msr))
+	if (kvm_apic_set_base(vcpu, &apic_base_msr))
 		return -EINVAL;
 
 	if (vcpu->arch.guest_state_protected)
-- 
2.47.0.rc1.288.g06298d1525-goog



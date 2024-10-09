Return-Path: <kvm+bounces-28307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD71C9974C4
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 20:19:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7617B28AC0F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE811E284F;
	Wed,  9 Oct 2024 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o8b4Ykvc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA571E2604
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 18:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728497876; cv=none; b=LSgefF3OD+XnSW6ewjFsLoh5XIQQQTHV4oYq7XUy4nDpcyqELxejrtOZ7HeCKLLqNRb2eZIFAw9jnWsXs9un1Y59RHPjtNBayJmma09IdT9tIRDj6l93dT7UEpFayM7/bOzWGlMUe5lNbYu9JShfHeR0JAjKMVi/4vuFDaKmxc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728497876; c=relaxed/simple;
	bh=GnpcuwMdkFaGr6O5Lmms01caFImUqZlbd0zCVFngLZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Av+o/eM2TjSKHIzWlZZPCBwKI1SKuGzWGn1iBBr4hdxaXO65h+9oQTNFEVp9AQGIHutU9B2VphGLTOqXzTGyZhBmdvb8n4PT6DCRydufVjf/u0U+FXraJUcY0PksY9p5J3NkGDHznbRTjMasVU91WW5ula069kAzUI7m8si1JoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o8b4Ykvc; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e28edea9af6so40234276.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 11:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728497873; x=1729102673; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rMwbZf1LmTNfEGZdnzInWLtMby5O9zhLRFRQddIF11U=;
        b=o8b4Ykvcjx+cVqgOjQ8unNtBY3JAXK9ySaWkuGvWmf2+TKp4Z/0EctnUX+4zyrI8eS
         ixTc8ALs0AsA7wKm8Gphuza9NRZoWX5d01kvlFm/EZErXsjfw+FQLlhmyZ4Fmh9CarOV
         vAk5LyKLsYvS9CMEhd1b9DPwDO4LJBkUqljrtM/zrn8oG7H0OATO+hDpsBfP4wBnjW9F
         UXi0rU71qz5HZDDyc5+R3DGsQJZKv8k/WQuIYOvCw5k0QLz5/bhWccaAiHFLPZ/WOc0V
         +6ZuOuCuFBHkRXQcZUlzGEMshW5hP9/W8nj7RUXHh8GNNMRlkgmrftREFFHKEfeuU4Rt
         qIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728497873; x=1729102673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rMwbZf1LmTNfEGZdnzInWLtMby5O9zhLRFRQddIF11U=;
        b=c/ShJ7yoRjy8S0c8PYPaWczWYz3FWov0DfIAtCOPGyCMYblExkn8msHEUjitWqU/aD
         RWfuopw9BsjyJqeYaK4BM2QpKnRBkLUMIcMHyMG18rTGJJziIIa6bvd9XoU8u4w2pKEK
         +zhcxxwC2z4kIS59ep7D2IpTXMHlQPGCLcy6B5PiSloykC4FjrHp16HHVGmBu/49/72E
         W77W7eaKXBzrhkEke++MyZ2E8kWgk3IQ/OAHufBbaLOqQ1ldV6jzzPwl0mHmRMo/xb8B
         c+Siq/SkQ4L9CS+fqgVIzMdWjDMwkRODs0WxC+WEb08ddrdWtOdP0B3lQGW+LdHiNlh6
         UjAw==
X-Gm-Message-State: AOJu0YzGIyQGlSME/I5Wo0H74G2t3JQztNtnwlPBcvpaCLq72v01mxQT
	NcmwxOhjTo/TPIfW17+9S9BqC0rvAkC0m3FN2LjcCzOJ3j3zQLcp+xx8or8kRhSlGqDBOy5C5V1
	EJQ==
X-Google-Smtp-Source: AGHT+IEvsS4c3s6n9g7x2z5D5H012XZQOsx3RuO4m9O7OjJK48IPzr0OmRE9xbrojGbugDgpO+45yxUumnA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:d84c:0:b0:e28:e9ea:8cca with SMTP id
 3f1490d57ef6-e28fe3fc233mr56043276.8.1728497873567; Wed, 09 Oct 2024 11:17:53
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 11:17:39 -0700
In-Reply-To: <20241009181742.1128779-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009181742.1128779-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009181742.1128779-6-seanjc@google.com>
Subject: [PATCH 5/7] KVM: x86: Move kvm_set_apic_base() implementation to
 lapic.c (from x86.c)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move kvm_set_apic_base() to lapic.c so that the bulk of KVM's local APIC
code resides in lapic.c, regardless of whether or not KVM is emulating the
local APIC in-kernel.  This will also allow making various helpers visible
only to lapic.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 21 +++++++++++++++++++++
 arch/x86/kvm/x86.c   | 21 ---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fe30f465611f..6239cfd89aad 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2628,6 +2628,27 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	}
 }
 
+int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
+	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
+	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
+		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
+
+	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
+		return 1;
+	if (!msr_info->host_initiated) {
+		if (old_mode == LAPIC_MODE_X2APIC && new_mode == LAPIC_MODE_XAPIC)
+			return 1;
+		if (old_mode == LAPIC_MODE_DISABLED && new_mode == LAPIC_MODE_X2APIC)
+			return 1;
+	}
+
+	kvm_lapic_set_base(vcpu, msr_info->data);
+	kvm_recalculate_apic_map(vcpu->kvm);
+	return 0;
+}
+
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c70ee3b33b93..a2a2a6126e67 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -667,27 +667,6 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
-{
-	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
-	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
-	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
-		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
-
-	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
-		return 1;
-	if (!msr_info->host_initiated) {
-		if (old_mode == LAPIC_MODE_X2APIC && new_mode == LAPIC_MODE_XAPIC)
-			return 1;
-		if (old_mode == LAPIC_MODE_DISABLED && new_mode == LAPIC_MODE_X2APIC)
-			return 1;
-	}
-
-	kvm_lapic_set_base(vcpu, msr_info->data);
-	kvm_recalculate_apic_map(vcpu->kvm);
-	return 0;
-}
-
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
  *
-- 
2.47.0.rc1.288.g06298d1525-goog



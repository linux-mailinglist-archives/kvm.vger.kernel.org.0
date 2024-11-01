Return-Path: <kvm+bounces-30348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D30879B97B6
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6ECA0B219E0
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99981D079C;
	Fri,  1 Nov 2024 18:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h+0/seQw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A687E1D0405
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730486169; cv=none; b=TTbOegP/AxB6jF3oS8eQajkckwZHpzGjVuNgnj8822Fn9Ks8iz0kguS6b4d0isbOMFQGqYjl+kg5KVWoW+faF3m7oNS9kX6jlR5Zn8L1Uv+jA+zBjA3bxJdmrki3SgivjujvU5h89iwLX+o5jE55Fc02B6u9K9lDrS5dm5AWfTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730486169; c=relaxed/simple;
	bh=Zq395NiiKporolLjoST+6+2+QTwzJOuMC+X29AbEL8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Voc+/OAxC0MKYwoUIKvrm7sKZYR0afg34ZSN8HIsy+9zd+Bpl7Xu6WaxsKn5iXwCHG6UnfmZqzT6atvbrg32+OINDQu1fIY09ZzruK8wawVeGnZof/FXPAhnSt4VnURJ/RxnoESeTKm7RVixghU2ttddDlSYto0Iu5akUZ5FcaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h+0/seQw; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ee07d0f395so2453303a12.3
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730486167; x=1731090967; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6jSxIG8GHxBvV25BqBO2yI1fCAIS8ozpFMSRDXOmwqc=;
        b=h+0/seQwYnhYGdnQNS7FT1h53uIlhgyljfiZluwq9hSH4/GWPJCTQo6LlM2YS5gnUJ
         BO1aphj1nfZjNRaF74cS3iaYRN7rmbbol1M2yzzMjKePaW7LWv5dzx+mgOuueMLQbTYY
         bxu3e6zNhymaSULDHYzAtV2Xy4MfR6gOzT6itK+xtuQLPFYe98BpzyqlbKKJRHICCLLD
         ZE2bzX6KTTXI9uQJF/0AvwnPVveFoX++ybYWZvdbZc59DA7H4GVb232E623w5+LAnFJx
         uPcMC0LWpv/pR/2mYr40YOPFcbRrS3+qAFI6OJ4YegyMUEkTbwvGjTBK5NvJFXlS0MWa
         ye2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730486167; x=1731090967;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6jSxIG8GHxBvV25BqBO2yI1fCAIS8ozpFMSRDXOmwqc=;
        b=CSISY4w/NQYu3iUZxklKJGhowMqsuCK1yUNsLarOiEu4t8nPEq1OIBYBnWexhCWiJ5
         6E5b8X7jpFt7+52yEGqOQbE7XcWUMdLDwFqbo1YF0ovMSVZZYflU5eTVXACyuCpJuYB/
         YzH/HaZIE1yjA+7z0Z+CZPVLH/JqJQofKFrpcnLlqc8S+TYLoLUk96R9xsjnSRMWlt9X
         CMPCabA1GX+Ujk/ln66FvflWwrKEx9u+qw05//u+S6D4UqL6UtQ5yGMDyZVQtQFJg4jA
         UdFjHtdTnBRk/CeqwoO5UhMwU3KstVSpvnL1EY2XBTjir+fx9fswJRyDzrAiqd+mmce4
         m/Kg==
X-Gm-Message-State: AOJu0YwaXEljnxsrWHkTH7t0Vd47GAA85razpieEjZeuQGAKmI46Tsas
	u2JSeOLYlsIkpfg8jw9EpBMZwN6gjk2nlBE1yELSNsbBB4YVq89x3GpfoAEYyZGa9ye3jX/zkzE
	enQ==
X-Google-Smtp-Source: AGHT+IFrzmaPgq4f61T2d+s5PZaLEK0ub9APvURzd9YoOZMotBWAM23YHpiHaxsWiIK/KyaT/0sYL80OMUA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:864b:b0:20c:90b9:3cf1 with SMTP id
 d9443c01a7336-21103cf3ef7mr80685ad.7.1730486167022; Fri, 01 Nov 2024 11:36:07
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 11:35:51 -0700
In-Reply-To: <20241101183555.1794700-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101183555.1794700-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101183555.1794700-6-seanjc@google.com>
Subject: [PATCH v2 5/9] KVM: x86: Move kvm_set_apic_base() implementation to
 lapic.c (from x86.c)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move kvm_set_apic_base() to lapic.c so that the bulk of KVM's local APIC
code resides in lapic.c, regardless of whether or not KVM is emulating the
local APIC in-kernel.  This will also allow making various helpers visible
only to lapic.c.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20241009181742.1128779-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 21 +++++++++++++++++++++
 arch/x86/kvm/x86.c   | 21 ---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9f88a49654b0..b4cc5b0e8796 100644
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
index 95af45542355..57dca2bdd40d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -668,27 +668,6 @@ static void drop_user_return_notifiers(void)
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
2.47.0.163.g1226f6d8fa-goog



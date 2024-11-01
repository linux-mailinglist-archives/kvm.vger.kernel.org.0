Return-Path: <kvm+bounces-30347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93F3E9B97B4
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BABF1F22805
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B80F1D0433;
	Fri,  1 Nov 2024 18:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zCJeDBy8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF4F1CFED7
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730486167; cv=none; b=E3fPRkM2YdV8KLXBf66Jaq5UbSguIcTYD/qyVMirB3MMPitxHezTJPHZvyCFcX4IKYO36ZFy7oeviXA5kfODRsBZvptzlVJgyYjTRLVEP6YUrdU0Czy6z9392fVP4cUWIENjU03sYNUoCgMVEXd3H4YXY472gQm57JFpRg5Xjv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730486167; c=relaxed/simple;
	bh=ZvhPKlVHbgPPM+VoBwR5IIXoCb+DdIwR8vcjRgoEO1A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ejwJq8u33SgkWZe14ntaIpzaYLKTetRGVePjgC+Mt3gpj6nR5uerga+ihzsJ4oY0BG98WtN8tFmCQadxyIQGyQsCM13IKapy4US40lXKyH1080mAQb7h6KxFNivVXcTyu2Q9z6/CEIl21BSRrWhiUeTZAOtdB9SpeRHYXpFmcZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zCJeDBy8; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30ba241e7eso4540518276.2
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730486165; x=1731090965; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QM3s7U/z00nQJq1TtO3+CW97lZlfwpLmjD1tvhSkGao=;
        b=zCJeDBy8Y7Alyac/pvMt7u4ZZkwOrcgZi4vWHPGT1PJhrD2bzlQFa8jF07Wc2oMfKA
         83hMl1ldCzHpUNF3xsyzzoqEZsxseG9UCy0wjP3LFGBCoGne73blcmwHfX7KLCs+SBiD
         dMER9od0vs1OQ5CBxKIhnIs9cbuFAUqngNA4friNrtfq7D32WSlxnDF/Ykn4qRSiuaq2
         Mm5DEfp6jX8bNv2TnDpNR/eU+dEr88SZf6IXMGw3zBGUFC8diXKqqlJw7SA5tVLhnd27
         CRDpElF+OmF+RaxW5NlwZyCS2vA5mT1fht+IqeGrej9WqYwyU195ZCppic4JUWcK568V
         gWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730486165; x=1731090965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QM3s7U/z00nQJq1TtO3+CW97lZlfwpLmjD1tvhSkGao=;
        b=QmsYogj8dslT6oAFDDdvyPJosubGEFWTuftPm15Fy/dWvyAhNekY+TlSh8Tr+4fZEQ
         riejpKwPjPfwqqKoYJ+9zequ4CIuDYD5DtIhl2J4SAAHjooLkl+i4P+1oSrpaARuSBRd
         KonOmqM7UaWgHTD9OITCzRcfG04PVq4XLZmMD8NgYiKCekyT8KzpbH0W5KcYGzHJR45M
         JzaHwvICEt5wbMPMoDnl8z0UIzZZFyM6+gMuwH8GRoy+K1RnshU8Pz9vFhAYgl3pVXsR
         9uwDO+BZ6Fb+a3H3t7sZqGghJSuPVvnHudbOMn09wEcL8b3ucZVqadz1xg9lvfczPscr
         L1sQ==
X-Gm-Message-State: AOJu0Yy2VtVEyWcEwkx4RcCGdOINfDjA0PR87JzwN59aPBok+Qs/Yo3K
	ADj5DlVTrhShtaixu4m9MwSGRMNnvolQKQPDTi8b0doU77LerWJX/cn8fJlbg9+CPLQjbfMAhDJ
	6xA==
X-Google-Smtp-Source: AGHT+IG3BgrIkNF6YeRzyo0VcV/pAm0pQUkv9rII4p7eMueQ7pEvcf2Etu5yQzbU5p84yZjVWLlKD1CGFP0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:83c3:0:b0:e30:c79e:16bc with SMTP id
 3f1490d57ef6-e30c79e1861mr13666276.8.1730486165271; Fri, 01 Nov 2024 11:36:05
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 11:35:50 -0700
In-Reply-To: <20241101183555.1794700-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101183555.1794700-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101183555.1794700-5-seanjc@google.com>
Subject: [PATCH v2 4/9] KVM: x86: Inline kvm_get_apic_mode() in lapic.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Inline kvm_get_apic_mode() in lapic.h to avoid a CALL+RET as well as an
export.  The underlying kvm_apic_mode() helper is public information, i.e.
there is no state/information that needs to be hidden from vendor modules.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20241009181742.1128779-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.h | 6 +++++-
 arch/x86/kvm/x86.c   | 6 ------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 441abc4f4afd..fc4bd36d44cf 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -120,7 +120,6 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
-enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
@@ -270,6 +269,11 @@ static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
 }
 
+static inline enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
+{
+	return kvm_apic_mode(vcpu->arch.apic_base);
+}
+
 static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 {
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 118e6eba35ba..95af45542355 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -668,12 +668,6 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
-{
-	return kvm_apic_mode(vcpu->arch.apic_base);
-}
-EXPORT_SYMBOL_GPL(kvm_get_apic_mode);
-
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
-- 
2.47.0.163.g1226f6d8fa-goog



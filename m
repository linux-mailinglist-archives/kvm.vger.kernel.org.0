Return-Path: <kvm+bounces-19823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 890ED90BC94
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 23:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADDF41C239C7
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 21:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B849919A290;
	Mon, 17 Jun 2024 21:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tYMgxtG1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F411993BE
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 21:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658286; cv=none; b=iixzpE/EB0qA5qtTONkbjQtgK0IeadChKR3nwTAro1NoSXBUt76np5KRFSYVryHBn7YZinzhYOh/heCxyRYzDe6kVmlgxDaRmt7eiDt3dbGYr1TtURNcWQsjBKmCrzduzgM4nLbTVxj/EPXxDLwKHcVyd+q8yKau0e6eR04WIq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658286; c=relaxed/simple;
	bh=abcNN6/yOl1D2N06tiJ3hT0s2jLzDjcN7nV9gnKoViE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hikzASWJYfNJSV0jmtA+b/uTkSaQrxxfRURHzkcc510jKCFVhDdS7IU2iWDPYD2tRc67YfxZ9WA0xm9zDC/4fDP8tvMTGUugnr2vMMnWQJ3i5ySdwrAAQr/N4MoOCqwQLnN5v3vFA0JzcS5jsoGBFSIpTFQEQEceUimLVNlACHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tYMgxtG1; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6338f71a577so54059757b3.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 14:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718658283; x=1719263083; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+W/+ANKl6aDY00ytIycx9vklTfPR8Zq4BBj+gxYemOg=;
        b=tYMgxtG1fxADn2T9ChLOoUlEIcv4hZIyXdgj3JvGK/sE9J92R8Rg2M+L6E3FAA/ZDi
         aMInrbnQnqZdkHRNCkvro5C3e4Dt3NUCknUtLkjKdO8dV8+lfy9HecmdKha0ZNrTcM7i
         n2XkHnInCV94sMqEc2jYZlVgtVYqx+aKO36cB3skcl188fsE83S1CMnDcKQYuHoY7SYM
         d2R5nQJ3rx38oPk8um6D07NdGeuYEmaxFMZGHWITCIUF+dG9OX6LuEjSUIYt7sc2/Jq9
         Qb9Kzl2FPqLqWYQHant/QKwZfKA3KjgYMq71HIyCx5/VzhFmiylCSnz2a8fkDhpllb7D
         hzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718658283; x=1719263083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+W/+ANKl6aDY00ytIycx9vklTfPR8Zq4BBj+gxYemOg=;
        b=OQ3h1vcB7JzmcgFHIQEuy7Hm7PEdJI9CcJwYZti/HqyxPJ5pXvKJJBB1Xf3b1bmAtp
         HwyP541O32ylGzwsaF/gZaxHMqZ+SygxtEQ2C6CjugNMo8AF8bE2Abt1hpEE4mu+PUOe
         M1tGkkV/7BNzLnXrq/Kzlvog0xw+RfJxqa4mMNnRfh09hZu4Wml7r9DevMoZpYBHzJP8
         Ee/pt0tfLNxdjpi/BMjerEMbu6t4cUHGctSJcUsucjJ6M9ZMh41nti9E9ZvGp+YE2G9I
         EXO/LavnFNXzRlvZZWtgGcGfEPHoOaedDMQE65zIOKoUpQ4HZguNwh67WlZk58TFrGjn
         PIFA==
X-Gm-Message-State: AOJu0YxJh1mOyVl1dwd5Bdv3PEiSo0oX10fOU0gfrHluP2sMrJO/bZbW
	HHqK8pR4WOZIrG3mffyi/EiFzqi+aPHIgq0w6LjPJjxOLgfJBgOcj3gzpmE2BTaoJKB/kMDZPdm
	6Kg==
X-Google-Smtp-Source: AGHT+IEN6Rwwh4iwjkOFUoqjrBzVaK6d8aiiHhe3RLuNcj2xLyObA9Gk4dpr4kRqjva8iIoe6Ang/bKSdPE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b84:b0:de5:bc2f:72bb with SMTP id
 3f1490d57ef6-dff1554e6cdmr1092359276.12.1718658283661; Mon, 17 Jun 2024
 14:04:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 17 Jun 2024 14:04:32 -0700
In-Reply-To: <20240617210432.1642542-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240617210432.1642542-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <20240617210432.1642542-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: SVM: Use compound literal in lieu of __maybe_unused
 rdmsr() param
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"

When reading MSR_TSC_AUX, which is effectively a 32-bit value, use a
compound literal to consume/ignore the upper 32 bits instead of a "maybe"
unused local variable.  While (ab)using a compound literal to discard an
unused output is unusual, it's perfectly legal as compound literals are
valid, modifiable l-values in C99 and beyond.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cf285472fea6..69c0dea5cc0d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -678,11 +678,8 @@ static int svm_hardware_enable(void)
 	 * Since Linux does not change the value of TSC_AUX once set, prime the
 	 * TSC_AUX field now to avoid a RDMSR on every vCPU run.
 	 */
-	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
-		u32 __maybe_unused msr_hi;
-
-		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
-	}
+	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX))
+		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, (u32){0});
 
 	return 0;
 }
-- 
2.45.2.627.g7a2c4fd464-goog



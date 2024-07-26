Return-Path: <kvm+bounces-22368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C17A93DB49
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:54:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F70A1C2322E
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D99157484;
	Fri, 26 Jul 2024 23:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EvFvTRdS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDF3156231
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037970; cv=none; b=JK7p7y0d/kAVZ7q5Z3PAyJX1b4Sq37uGOWgUXOs7ZLHdJ5xYbNZVO9+drTEeO6wLaU56zD80JWwN9oijL6fJSIJG7IQqu/5ZNRv7JEX4zGfBHlnO1MgJP9jL33wKIr3D2+K40kvc1rYiFzCi2HcoBctyGyuCaaM+tgDMTPWPtuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037970; c=relaxed/simple;
	bh=o0JBLF6HQjluB3iIirHhfso1PE7Zf/Ht0oB2KRN4Rqk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h27rFLBfusonksMKUnfYOXTSpodejj0HkOtwzcKjCCSwCB2CupI4r4qzcdSRHsIgQdGJKqLl5RV8dtZI7go201Rm0MIfyVMs2EUllSn+qSljXDZAz6OgKFjpjpIm7PpQGkw3uMO96GP38nVDJam1IYzUrzxAOV4aUMpR0oyV0Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EvFvTRdS; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d14709555so1472816b3a.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037968; x=1722642768; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1PAT6v4tn5ltatT/kjen/UunIT1fRhHnj971W9WBYQU=;
        b=EvFvTRdSkvDWHv908ZV4vYnJ4Jp/OKYzGWKs7fmL2vIG50ZsyAH9BuQT3QfDq8b3wl
         qjwOZltJXn0Zi5OhsW8YD77lQIKTgplFRugC7S0s4MbfgfWbdi9GlojuvdFAOojuRne5
         VZbJAcqVblteXXtyd+c3/ddzmTLwHdH/mJ5CAj6zgdrAjHKhKXowlTeb5naqO1DRMW8g
         ahVRGYUVq4TU4Qewt+h/TY+qlOhV2NSrcb0GNTsU2Y9q+mx7LYbQNAyc2Ol+hcDm6Pfc
         ia5vG2Yyct4CeBPcv22CgTUC/zlL8VYuu3hgT1iPjeQUl9VL84RgwyCv/VTuL7czUhgS
         Uk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037968; x=1722642768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1PAT6v4tn5ltatT/kjen/UunIT1fRhHnj971W9WBYQU=;
        b=Vrjgfwh/EK0CH/pX1xWDEmZScOdjWAyozh6GxzcIMeoCxtqVbd3T0xDJo95ynHIgOJ
         /KXnJOiegpOm1/NTnw4hAGm5B0mERVYuZ2q/Q6w/ooqWlI/7IS5ebStSUQ0ogy17PM1u
         v+C01czz8S8q4wrLc1AjAtH3lG6aCzkNSTXz69/ma0fZOsrkNKFlypi/pWLBlGzB3wOb
         eVMDUPBYH5CAnzt4Da0RJHPOKSK0Q1qaUE4wXiXpf1q01k6DWWSpoGFA6kvNlZRH+qbl
         umrJm2yBUOwcEAHGV9mO/DpbQ7M7dckUAjMfrPmMwqjnyzQi6E5uk0+KO/MzUVgn+YWM
         m2sQ==
X-Gm-Message-State: AOJu0Ywj9z7HH1N+7YVvDxeXhZdnLD67xIyyNHrDvTpvPI0Vb8bg1sTL
	3GLsIsdFysfv19CgYJiaou/He0M412FqkcrMfgj+hQz0YrGjWGFEMlAooUX3xAix9UUElt0dXRK
	I6g==
X-Google-Smtp-Source: AGHT+IGybwcUaaDWGaRnVlNYMzL2lybkBwi+pdiFBv1toqDzA479d7SifMoC4AbRMiwOqaRTolCzzwjRN5U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:731c:b0:70d:13c2:1d08 with SMTP id
 d2e1a72fcca58-70ecedb0dfamr2514b3a.3.1722037967857; Fri, 26 Jul 2024 16:52:47
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:14 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-6-seanjc@google.com>
Subject: [PATCH v12 05/84] KVM: Add kvm_release_page_unused() API to put pages
 that KVM never consumes
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Add an API to release an unused page, i.e. to put a page without marking
it accessed or dirty.  The API will be used when KVM faults-in a page but
bails before installing the guest mapping (and other similar flows).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3d9617d1de41..c5d39a337aa3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1201,6 +1201,15 @@ unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable);
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
 				      bool *writable);
+
+static inline void kvm_release_page_unused(struct page *page)
+{
+	if (!page)
+		return;
+
+	put_page(page);
+}
+
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog



Return-Path: <kvm+bounces-17903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 593DB8CB8A0
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 03:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9A9B1F23453
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 01:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F0C33993;
	Wed, 22 May 2024 01:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HbL6e8Aa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6029B2940F
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 01:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716342029; cv=none; b=KLjXEH1OpGK38YkArZP6n52hNx4Esp7Baff6zUGxldD+i8+p5KC5aWlypQZvEtqT+98xOS1ZaiJW406s8OwugXv8EeroUTvaunzMvh6R6jgNbFnLLqBXvbVGIc8+ivfKh1Io+965d15CMyzyM74u936HAI2PrujQwH/TKfto0A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716342029; c=relaxed/simple;
	bh=SxCNJ06vwtbyrQkZd4xB8bnO3JXPErYFa83rg1Usdig=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mfHAVBaxqgos9kADg6ZKV6/qeYaS8yo1QvH5RdZsveIO954rN3dUc+C0n0RSIdNjYRcZezSjLrfi2Xn5kd7V3jT8j3zOxSaJ5rIYkIGvyP4mhYmd8Cj0FN6oo6ckGbyqo4Himq5l7jZ1VCzuMOWuFMW8lepOjrcAvJy9fIg8zbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HbL6e8Aa; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6256bc244b7so5338257b3.1
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 18:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716342025; x=1716946825; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9/Jh3NT05cAP4Dr5P4AOID5+N71m8JBqExCgFsAlL8M=;
        b=HbL6e8AaswHNLiWKgo6se20VDshzgLLaTNIEN+U7UssI6ZsuxZEDTbfUqQQxQ4UDna
         irXn3F65FnI03N9WVpnBoPJLPWr1c8SZ3nplMBWABmwV/ZZoH8jlLZEgZeNm6YthcXMl
         fzGJQEoFKEgYnbfLkFI4I/aKUe2sdxyICOAxbYCjIg4yeSxBBFnswVO3hyCX1uFI5tRQ
         zDq9moeNogQDg3+7jND+UBZA+EYM7Fq9IHVj7kKGO29sWTpwsEgLbN5X0RY5VrwbzSxf
         S9cBu/NDD9LyWrTv83wn02X0cNIxMB6xPXkZ9RLMpVxaEMOdYsFYz2qoQsZDI2AnVz/V
         jtVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716342025; x=1716946825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9/Jh3NT05cAP4Dr5P4AOID5+N71m8JBqExCgFsAlL8M=;
        b=AX3deu9TZ7xEY6tJ+3MC+DKJgLnebKbCxuVs9m2563LxlC5m25HpzOIcARD6Xkp2Bw
         eKYwfdCqY6iYK6lj0aY/hV7yzsY6oFhIsFHxM2paRY6/iDJMUe223FhACKE+6n+uIxIW
         naG7DJpafHqY2zsd5jpFJF57N3oUDJmKGdjuAylb4HzlFrs2CXdMIGT2btukTGze4AoG
         KMU7yHB1Q7blfj9NRZvzQ8lqsWN2f5lSt67BdCDSyxIOMSkXHE/4JX93bSUrsK/ZR6uh
         Qfrhk81LjokqfgIIjWN9IpiA/2ef4bhhSohWJP8oklCIKJwDSXvLB8pxMdhF5P4q7bX8
         tPdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjkezZ2pojrxSUre9GUDujrbsSByBoKEeSAdsBcvgX6gVCADMohW5QLIas9qLL7B0iZH6JrZIx9PEyyltEblB+6dyS
X-Gm-Message-State: AOJu0YysBRsFb6ZmLfaSzwOJzX8n05zIWu3Z/2l/g8CBD0Xtw36hcRG4
	/VU/ObK86pyiVZV6I2rkgyXApz+iEgjNd2jcLwsW9E+C0gd3YMLNq9pIjlx1cYgxo/SYoDFtvDf
	hrw==
X-Google-Smtp-Source: AGHT+IFb4ojjFIBjH/g1gqSAZtGdXjScECyPQCKxtonXS1wS1/Q6Sfuh8cMohHl5GHkfuJ7096x7AKNuxdo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:b0:dda:c4ec:7db5 with SMTP id
 3f1490d57ef6-df4e10405f6mr210549276.4.1716342025422; Tue, 21 May 2024
 18:40:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 18:40:12 -0700
In-Reply-To: <20240522014013.1672962-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522014013.1672962-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522014013.1672962-6-seanjc@google.com>
Subject: [PATCH v2 5/6] KVM: x86: Unconditionally set l1tf_flush_l1d during
 vCPU load
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Always set l1tf_flush_l1d during kvm_arch_vcpu_load() instead of setting
it only when the vCPU is being scheduled back in.  The flag is processed
only when VM-Enter is imminent, and KVM obviously needs to load the vCPU
before VM-Enter, so attempting to precisely set l1tf_flush_l1d provides no
meaningful value.  I.e. the flag _will_ be set either way, it's simply a
matter of when.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59aa772af755..60fea297f91f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5006,12 +5006,11 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	if (vcpu->scheduled_out) {
-		vcpu->arch.l1tf_flush_l1d = true;
-		if (pmu->version && unlikely(pmu->event_count)) {
-			pmu->need_cleanup = true;
-			kvm_make_request(KVM_REQ_PMU, vcpu);
-		}
+	vcpu->arch.l1tf_flush_l1d = true;
+
+	if (vcpu->scheduled_out && pmu->version && pmu->event_count) {
+		pmu->need_cleanup = true;
+		kvm_make_request(KVM_REQ_PMU, vcpu);
 	}
 
 	/* Address WBINVD may be executed by guest */
-- 
2.45.0.215.g3402c0e53f-goog



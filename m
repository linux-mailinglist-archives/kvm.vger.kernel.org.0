Return-Path: <kvm+bounces-22434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DB5D93DC35
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F3E31C231F3
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5320518F2FF;
	Fri, 26 Jul 2024 23:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MZFH8Z1f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209FD18F2EB
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038109; cv=none; b=aelrKMR4tQz/DEfk6xXeizQXq6I+3uTtl2JRResFIJVzBZwnnaUT1gqS7AVJIw6vgMxtmOybLVVGKqQHL7gsraZJlDMJ4nwTr3HlcgMBmzNEvFvKHiV3NdBbd2qMrt7CgPqlwyKey+sDTHM4qJiKYsINVBt0rPDkuD5+LFEC6FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038109; c=relaxed/simple;
	bh=LwnbsVmoSkGUot+G6cbXgIy7tatzU4elH4imBAcWXlg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Weqy7k/OhpHhqr2g81gmuTU1lNme7v1kPzeoSgmLvBw8q+9dyofEyhv66u54v2jjoOJjP/YV5IRwHYGjQXVxDz4btt7eMvVRiHELRCLJz25uawFMGuF5MByCRbESVdTzIi+GsUJAdAe4B6e17bSTQlZRxwEBO/1ETn+jtsfM+HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MZFH8Z1f; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc4b03fe76so9985225ad.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038107; x=1722642907; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Agw1NDopTbJHSwXqEMTAoK1oQKqohLcT4CyuwhV7hPY=;
        b=MZFH8Z1f6H+7tRJum8lT1Vm7ri8x+Xug7jf1d83CoRP56DsICdy3/XpfWetgSX84F+
         3O9Uygiu4wzYrBS6TGn9YuOSDHyMhkron0pg612PO657AGWM1CJoXdyZZwSGBxYTKu9L
         uYXTaAzaSeoBPIu2hHk8gw29P9fdLK64zGzFVIjowqj6XMtueIdgrlrw6AoIVQz/Rwg5
         nOrndP0boNuzbW9ZXOcUox7y/7Lgwpgnle+J9kMwZ1GGGeqhvu8LV1TdCWI7DaZrXiaE
         am/ABXWN9T68epdnmT2yOBlUWf0p3L/bMPX5qNRe8KmWoJNGeJTD5sVm+abEEJgZ7Cdu
         cJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038107; x=1722642907;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Agw1NDopTbJHSwXqEMTAoK1oQKqohLcT4CyuwhV7hPY=;
        b=cVek67qkfH8QxoLqVGJY863nbuz5Uz7k4GH3qMgaV7LSs2oMVmodpxknU8GPfDgf1T
         EY5nCD+rdA9l0puomNnW15yu9C7eo3FmD7KFnjfosFKx9G7oMzGXiEDw8QeIa2AbyGjI
         NKAL2++2X+iir0KpLlFVJMQYyiLqjHcqGxqqtXFXYtrZKtEYLcdtn14LdiKT4a4iOBC2
         SEAhgjM4vum+82dyoSTrQBlKidcAfBIyfTCO/xHdxIqd/nR3xal6kMivcfi3u/5bf0to
         igvJHZgtvQYZKTWO2OgdeJRbGMAPHXObWKxHH/FOL7kUmgJGa7VJ2rb3boNxyhzBkmvf
         HFFg==
X-Gm-Message-State: AOJu0YyhKBo35rh7FMd9mV14umupQqlejLysuB0/xby30DOps9pPxF4R
	jayXhEK78JPzKioV2KzaqKcvt+iuN5ALT5p03ggMACQ7o50/KrMLTCE5CQF4zr4wZlfX1OqczdH
	MRA==
X-Google-Smtp-Source: AGHT+IHxZ9LAKt5vIHU7V05HDfJ12gC6skwH/WeW9XOXHpR7B1c0ubRWlOUtq2UiALskA4rClXraM4lFVDE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b18d:b0:1fd:8ebf:672c with SMTP id
 d9443c01a7336-1ff047d8f61mr25415ad.3.1722038107293; Fri, 26 Jul 2024 16:55:07
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:21 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-73-seanjc@google.com>
Subject: [PATCH v12 72/84] KVM: PPC: Remove extra get_page() to fix page
 refcount leak
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

Don't manually do get_page() when patching dcbz, as gfn_to_page() gifts
the caller a reference.  I.e. doing get_page() will leak the page due to
not putting all references.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_pr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 1bdcd4ee4813..ae4757ac0848 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -652,7 +652,6 @@ static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, struct kvmppc_pte *pte)
 	hpage_offset &= ~0xFFFULL;
 	hpage_offset /= 4;
 
-	get_page(hpage);
 	page = kmap_atomic(hpage);
 
 	/* patch dcbz into reserved instruction, so we trap */
-- 
2.46.0.rc1.232.g9752f9e123-goog



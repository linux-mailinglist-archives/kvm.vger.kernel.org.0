Return-Path: <kvm+bounces-49182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1C11AD634F
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D570A3AA5E2
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C899E2E7629;
	Wed, 11 Jun 2025 22:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uGgbHJZy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646C02E6D15
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682081; cv=none; b=EH+kOR7XhgCNb3bINnEGxpQ9yeR5mwn10K7ndqgouwJxMsO2r7SLlyv20dxTuD3yWrmdnew+NEZ/rnFzqvmV2kfNAxWSBsSIvUpmf1mTy+op/uwoVV9m1mTmJ9Qr+rtWdclostyq1VITah8vUpYdVa2DvOlSfouJVWDfd/EScso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682081; c=relaxed/simple;
	bh=i42G1yIKz6UNXah+vwwlH6gSGjE2qsFjyhLN1QFtXLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zl99IADnU9QfYf2ysrfyEXBijuPpf9PiXl186wJ+Kk0eMLGdALRo2P9EZ5d2rUqi8C1BDY35NdCOJcVjSkY+jNJpaUNNjjHmxCadC6QK0p7eUlzEpEP8IXZmKfv3FBptqeUpRt3Q6ann5MYWioAMEWsj6uWm3sPPdFId4ERmOEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uGgbHJZy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so443672a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682078; x=1750286878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aRbYdbPjfnXABceLxP6T4VwYA6vT74WXjV6qwqEpIRA=;
        b=uGgbHJZyghyXGOPw28liofswcngU32FDmw8OkRWgKC/hbYg+9CGlVHsuKE+qjve9PH
         mmV46PRvZO3a2E6ZiZRxA2vAh8K0T4yKQyGFUSiZrluk6gwfnre/yUsqbghDyyfXQLI7
         sFxS50CGEDdS9+hqlu7ZRuEBDyAlW8cMdORWie5CY+MKDiIGaugByXgqvu9nTmUuxQH3
         kPjCH40vPZeM5r3o7p6BXxGlNFHgoshXZf94ay0Tp1khFosMxAKXG15E+tpH2GiJM80C
         enZUos77KcF1ZFK/BeaUfSiHrFQETAhmjh6MUJgZ/Fd2b5fDPJNlijshpj4ntDShYiy7
         zlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682078; x=1750286878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aRbYdbPjfnXABceLxP6T4VwYA6vT74WXjV6qwqEpIRA=;
        b=LcaNqkt6URkPqlmfSD1PcFjJ/F2HSDBqm9ks7wkibRXELGndJ8XEIlipY5jqXtx5bt
         dKfKxkAeEqrKr7RTuk0SGZuHkTXEi9eFd9VImcZ97T528LoHY68k/rFlxyzfsQJs7mAE
         ndW5ocA3qtvnvcxvWK5+hJGYq4T8+7qRQmBUC5xbebSYkk1gc8tptB4fxruUNAkgS5uf
         JkDJftVbA5FCgCX/VfbUpSIPET4U8lShgvANtYNp7CPg195ARMsOnrZ40t5pvB60TSBU
         RtyNwbbxoWy1TL29XpMI3NRQYxPJomN+yjfseLXpgk+rDJ36G8WAP2oJJssQT9mm7ftr
         mkiw==
X-Forwarded-Encrypted: i=1; AJvYcCWBXTU53BIzTUfR0QF52PZT0YaCKYlfbsgbaaXn4aograJWeH/yP9euHNjQdo6jJZMTdys=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1U5lj5W59dmTyJ6SOq2KwQXt/cttCjrYJVA129YSAciGnEujZ
	ljcKNJgTC4Vj+VvpfKYihrK2xyjWLj9MYMYvIZiZ8CDXp8iqcYUwKDnCWJIu2iPUSD2qII4I2J3
	J7Pbn8Q==
X-Google-Smtp-Source: AGHT+IHb+Zv/4CcMgQT32iC66PSsxBVu4fJyVtFcuECRvVY6yAdTVQgUPpLO4I1bFnUpFw9nkCh9cXpZUsg=
X-Received: from pjbkl3.prod.google.com ([2002:a17:90b:4983:b0:311:c197:70a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ec8:b0:311:a314:c2ca
 with SMTP id 98e67ed59e1d1-313c0667dbemr976034a91.6.1749682077795; Wed, 11
 Jun 2025 15:47:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:39 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-38-seanjc@google.com>
Subject: [PATCH v3 36/62] KVM: x86: Don't update IRTE entries when old and new
 routes were !MSI
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Skip the entirety of IRTE updates on a GSI routing change if neither the
old nor the new routing is for an MSI, i.e. if the neither routing setup
allows for posting to a vCPU.  If the IRTE isn't already host controlled,
KVM has bigger problems.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 43e85ebc0d5b..4119c1e880e7 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -618,6 +618,10 @@ void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new)
 {
+	if (new->type != KVM_IRQ_ROUTING_MSI &&
+	    old->type != KVM_IRQ_ROUTING_MSI)
+		return;
+
 	if (old->type == KVM_IRQ_ROUTING_MSI &&
 	    new->type == KVM_IRQ_ROUTING_MSI &&
 	    !memcmp(&old->msi, &new->msi, sizeof(new->msi)))
-- 
2.50.0.rc1.591.g9c95f17f64-goog



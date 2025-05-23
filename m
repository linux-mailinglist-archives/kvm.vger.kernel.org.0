Return-Path: <kvm+bounces-47499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41DAFAC1966
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABC281C05EA5
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E93F2D4B4F;
	Fri, 23 May 2025 01:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mEgUxggE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFC02D4B5D
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962095; cv=none; b=uTpeGAg70Phuqx6XfuI2ecrBaihP89rac7fhDzKaUCupIyfK2+hKrHd1RKgj4i1uuIp15kWbJ0ypedqxGu19NhZOwE8WoIgbHnN0ktmwGsgGtoJiX7B9NNieVs7JFKRl0a+Q5pdjFt2Rol1I38EQbbjW0p2UReZtE7LZBnWCGbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962095; c=relaxed/simple;
	bh=65fTcpLjkBtBO6xCL7Lqhp4uS5GSGwxSjcQbFJFJsvA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k+9cDIYKhtnSaO1CDkqjVZNt2cEm5Lc8V20QcqVYXXoEPuAo1VIQoKDFYn+j68u4zumsR5fvIWxpMMiugQbtfKZAoF/CdRKMHroijs6xYSnyzEV9UJEBG84EMpMRuwE71HD0jrrzdPVi2tX2PQtn0LB5S0U6qtkWgE8jML9PD+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mEgUxggE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e6980471cso6962994a91.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962093; x=1748566893; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jRZ2pwWogb5EDz58ANC8fmbpd84fTXnIK4G2GwCRUWE=;
        b=mEgUxggE4ANPOZJ/Yw7o/codY7ZTjLK/+INcsSrpm4Q3VH3O2wAbzsNCQD7t5Z6La4
         yg9N6trVJRGGAskZksa4X7QmO7H3OnGi4DeMcfIIkqtSqS1aBkyOMxYMdfRE7/fhzqx2
         K0z3m31BYTjxAD8NvxpC2asSzI53jHAwYp9k1GzKl3TStiBs2jZALIXHp9Y44XHUAODL
         QtAi7f2izUoIHXUIelyP8AavYfN+4NNBKc00r/IINmrbnNURmx6NKjpQFBIXfoBiYg1S
         oBRenKJBnQ206Z4wOxJnOB59pKPCoOiuU1Esq2zsd92B83sVyrZ/Dg9NWoqhu9CJ+p1N
         70SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962093; x=1748566893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jRZ2pwWogb5EDz58ANC8fmbpd84fTXnIK4G2GwCRUWE=;
        b=QccFXlVxIH37AC7+KYx/bVeOxCddFY/h1W2ogcqWMKUj5FOyUYF7vgk9uoL0u//jd3
         zywMe1t82bCUaIvTW33BBAikZqBYcBb4WPzzp/rWV+aREN6HKVcFvJwIHr9rdkdMGoj6
         5upzNgKaF6OqZ1jDDzyznLEvNhoBPBJA4lPGfVnMFG+UbQPua4miEFvWTDfCkdNsnjNE
         QlgVIQQ5LC3aqxPV+ZVfBb7iNhIjWvXhV15EUiBYerwh3pvxlraXHCCN2l/b9tUE29No
         B9rmN3WRvMTLUo5y3RdElatqL8FM1VkMH2yjtskWK1ngdDi0wHOQ6A/uBqNGhlJOG9JN
         Q3+A==
X-Gm-Message-State: AOJu0Ywf3+VZdzYBU9CDDeFz9nyObx39AqkD7Igo3h7iGvO0XupSO3kf
	MTD/gUSnAV/keconu6p1nJ8ZyLO8E3tD9EMtJmKCMMgJeEWiEsIbxU2TrmO8bG/3vIGWgCs6tbm
	y+kQFdg==
X-Google-Smtp-Source: AGHT+IFyeeumFKhc4Yu6rkIsxyO1z805cVfyQ8R0sxgmiUuh4VdwSV11ZDutI0EPEQI70l4STndzesKeIW4=
X-Received: from pjbsi3.prod.google.com ([2002:a17:90b:5283:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b48:b0:2ee:d433:7c50
 with SMTP id 98e67ed59e1d1-30e7d5ac7ecmr33847409a91.23.1747962092871; Thu, 22
 May 2025 18:01:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:54 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-50-seanjc@google.com>
Subject: [PATCH v2 49/59] KVM: x86: WARN if IRQ bypass routing is updated
 without in-kernel local APIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Yell if kvm_pi_update_irte() is reached without an in-kernel local APIC,
as kvm_arch_irqfd_allowed() should prevent attaching an irqfd and thus any
and all postable IRQs to an APIC-less VM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index af766130b650..b6263ab4b18d 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -517,8 +517,8 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 	struct kvm_lapic_irq irq;
 	int r;
 
-	if (!irqchip_in_kernel(kvm) || WARN_ON_ONCE(!kvm_arch_has_irq_bypass()))
-		return 0;
+	if (WARN_ON_ONCE(!irqchip_in_kernel(kvm) || !kvm_arch_has_irq_bypass()))
+		return -EINVAL;
 
 	if (entry && entry->type == KVM_IRQ_ROUTING_MSI) {
 		kvm_set_msi_irq(kvm, entry, &irq);
-- 
2.49.0.1151.ga128411c76-goog



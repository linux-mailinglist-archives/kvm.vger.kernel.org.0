Return-Path: <kvm+bounces-49147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB00AAD62FB
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:49:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB4A1176471
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D552580D7;
	Wed, 11 Jun 2025 22:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WkNOWWkF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1662522A8
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682019; cv=none; b=vDhS3UKX7TR+PeIa5MIrwi02r0+0aah222iICjzZa4Q5Kall1jLeb+W75sIOL+ckcLH+yha2ljrYtgc7kTowTX71zs2R1G3skYf+TYiNiYXV9chSZKA/LiVGbs0OMcrAIm4WkAbq/T1OIPcJsK+olboIs5AaZsoTE4E8j17bScQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682019; c=relaxed/simple;
	bh=982YzkJSuPJzcUJ59rC3v9vip8VboXzMkqDEQ2GpPws=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JxJJzXkJZuIsizb13nBFx2/GHpSwpbo9hLsGJUY5uwYkhnUYOskyCNucZs9JucCJP6h28th8rLGWow9P6rq3D+7MCht54mFn92JkTVGEufegdQrYzfgHfvRZW7PLVBZL/mbKqA2R4/Z0AmhlPljowuVepjJmti6aRgEAbDBrzvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WkNOWWkF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311ef4fb5eeso213752a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682017; x=1750286817; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xCMHUlDguheMk1DR0iSlAWm0OxNkDe+tjgoSc4700VQ=;
        b=WkNOWWkFpMLWKe6HNpycC2f2iF34FfKErlaU8Choku5q5eqM1Vy1M6clWQOz9/K7aZ
         5nWUm00+kObSGVOm21fPjEIJWY+1vrvEUdFmf1fHeHe6QNw2Xh92yWHWpULOV1aEWLsL
         pk0Ze/kh5Sft0yXeFmiQJMez89c2k1izUgTdRZnVkPx5ADBcigFQUMCURh/TK7/MiKdH
         WiVLnZMuIOC0+xsvBj766agFZAYeReK9AVyCezTsvZ5IwNBFZ2A5YO5hMGLqGKNCsGo8
         OiyXhQklXFmwKuBMYSLYSiTZHkbbilfRTxXbb/++goOMO+xZoHiingcjpRlFckuezeom
         y4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682017; x=1750286817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xCMHUlDguheMk1DR0iSlAWm0OxNkDe+tjgoSc4700VQ=;
        b=ltwqI7L8coMu19QkvbJVggsRcY/r2EqKvXXVVCuaoMC90+mv5kaAza6IPSw+brJFUH
         Lngnow+vc1mJS89Fk01ZzW2jVhSq95m9LGs+cpACgZo89RcjBBvfaGyVILMlV3ReqsVe
         A9PxJ6QICFOybe27ZdLpB8exaidWCcAp7YAEo7AYOt+nniaZBL4p1zpfsqM0p10oYW7s
         3G12QT7JYmSI8pyjq4MF4TGhX4DycLoIHHjQ0GEgD5Ntsp3pyyMEjFsI4Egjmi6GUluO
         w9yg7GF4AXP7tIIR6NW7IWkrSQ4aVMfCEBbxvqWIuzcf5RdAVicGYdWwtk4jG1czKIFF
         L9yg==
X-Forwarded-Encrypted: i=1; AJvYcCXeFMgVb4cbVLnwhDuMRgI/63Op6YbUbqsm/YsJnN9zcae4LVWn2yZEOm5XkERk+cOXHT0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu7OZSKJRKnwdSgXtZGQMLuUBsljk/kG5c8K8DSjukydXERuVV
	BOTTWTlEfXcx/OFzkWv75luiD0O+CBiLvRYgBGfYpm6EvzoxdOCj37tsWUDckooh8cL0UZpgYz6
	d481HuA==
X-Google-Smtp-Source: AGHT+IF9lRdjIaJMGffmVpoig7dkM1EZi9TG7goqvwtOE+A6AKDHS0ehZiZ8FiJ1CPYjTylPsun8hRe7S+Y=
X-Received: from pjbpv3.prod.google.com ([2002:a17:90b:3c83:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d406:b0:2fa:1e56:5d82
 with SMTP id 98e67ed59e1d1-313bfdcc12emr1459552a91.17.1749682017517; Wed, 11
 Jun 2025 15:46:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:04 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-3-seanjc@google.com>
Subject: [PATCH v3 01/62] KVM: arm64: Explicitly treat routing entry type
 changes as changes
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

Explicitly treat type differences as GSI routing changes, as comparing MSI
data between two entries could get a false negative, e.g. if userspace
changed the type but left the type-specific data as-

Note, the same bug was fixed in x86 by commit bcda70c56f3e ("KVM: x86:
Explicitly treat routing entry type changes as changes").

Fixes: 4bf3693d36af ("KVM: arm64: Unmap vLPIs affected by changes to GSI routing information")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index de2b4e9c9f9f..38a91bb5d4c7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2764,7 +2764,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
 				  struct kvm_kernel_irq_routing_entry *new)
 {
-	if (new->type != KVM_IRQ_ROUTING_MSI)
+	if (old->type != KVM_IRQ_ROUTING_MSI ||
+	    new->type != KVM_IRQ_ROUTING_MSI)
 		return true;
 
 	return memcmp(&old->msi, &new->msi, sizeof(new->msi));
-- 
2.50.0.rc1.591.g9c95f17f64-goog



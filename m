Return-Path: <kvm+bounces-49181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E69CFAD6341
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:58:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59D4416A8CA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82B2B2E6D30;
	Wed, 11 Jun 2025 22:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eA4tLM3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CB62D6632
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682078; cv=none; b=ScIwnF34nb/E1hpam3EcRAeU80i+m1WAyHjSsgMP+qwDNWv9uGccGdM5s8KXym+5E+Q8oneZo5op3YlZ+sl29MlLCnQmkC1EB+0blzSon+XPCBMTo41O1EGk18KpHnJkR3g9YkfgpP7ZQ4NUDFipNRcdVvrhXgG/Z3sLKvZ4kEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682078; c=relaxed/simple;
	bh=j41Uf6UxRmW62fWWWKV7gcUywbZjarY50CWC7KTpVXA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZDR4C41qhJRz4JnTTf6Ns2pOzrmsD3lQDbjJdczZXGEqYekkbKxvAoiioVUe1FHuha47Ef6+eP/lm1DETe1D9AIHBWYgDp01BCZKyLlFG0BSG33cEvohZlp9Nf3wjwd2PWQBXy79sO+cXe4bPv/Ci80Ui/tRB0gX1+r6JBI4FvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eA4tLM3Y; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311f4f2e6baso327482a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682076; x=1750286876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=D1Ge4V/cjACONoBs0qgFEJo1LJMRo9yRFlMmYU8swmk=;
        b=eA4tLM3Yi52za73ooiv79+d3S/er8qBYCKtL18unqtsyJgJu3Lq22XhfpOaD0vZurm
         xXYN10bXubV8rFKk7CCcsczJre1z7gsCGVkxlj1FzYmLEH13Lz4tDHYeyRI+O/oRIYHd
         iiPt3vrajGMFddZR5owv1uZ/0iUhuYR7bxoExddV+5FYmpMIY9nDqoLZlorKacXKM0a6
         T2ibhTBScXraava2TJ2MzYmxvTOY7TTUYTOHex6949Qx7uhoxeONVMGyoLdvrQlimVpX
         bNBOEYniYSA1qBjz0Fcy9sonyXC02x5xFUeAdtWM7TDiwt0EPBxbfh7bEoDwzq+2oELG
         Do5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682076; x=1750286876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D1Ge4V/cjACONoBs0qgFEJo1LJMRo9yRFlMmYU8swmk=;
        b=fd022X4DHQ3DoX5ae7SGfM00UlcTQnSv+wwciR7FZdZeOpB6ulTCMLPFC9IUu+nEO6
         xT6DrXlC25Km6hHFGuC1kNPkbsDEwmuDWKjelXi7lUk0buopK3NSvy080iVgknvrZbXu
         eAOnj4ctX/czIkb06yuO+7ntLg1y9bH2zylTCchiZeF/bjILpYtmtan9oZiQ+qFGSm75
         tsithmib7S4nHOivr1e9U5ScRIfjRg0W05K+l+N253bnLUzKBNIB+ebZh8tedkR3l4nc
         up29IvwCMcQ5fbyFg1PE3Kcn+cNNa96tEBH7CEPoQuBrrk7qwyAHXSe6bZeI0Ubymv/Z
         aPZw==
X-Forwarded-Encrypted: i=1; AJvYcCUETiM9w4fO3q2x3f+pW1uKqFGS2/VhPEfBd6g2cxZW9XxB0SmRP4Jf13bukJtvAtnWKgY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyim5BSrMirRPWhJwAuhxbnHrz81KMcFrRyDysSgvOvl24vg6wB
	CNe5yLkMff2Kj/anFza0l5oe49bpJkVz/+0ps4F3Jj/7FaZ/c+hu4Qzo7Da8oToBKJjbRJuRpRL
	0wqt5vQ==
X-Google-Smtp-Source: AGHT+IFqa2w2kmXbZWMF8yccOdDvEvpmv9cb25OglMZKL4EfpfzN4NVZljxUxuB5ee0yWW1el6qOh8n1yDU=
X-Received: from pjbsk13.prod.google.com ([2002:a17:90b:2dcd:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3dc7:b0:311:d670:a10d
 with SMTP id 98e67ed59e1d1-313c08d2876mr905787a91.26.1749682076024; Wed, 11
 Jun 2025 15:47:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:38 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-37-seanjc@google.com>
Subject: [PATCH v3 35/62] KVM: x86: Skip IOMMU IRTE updates if there's no old
 or new vCPU being targeted
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

Don't "reconfigure" an IRTE into host controlled mode when it's already in
the state, i.e. if KVM's GSI routing changes but the IRQ wasn't and still
isn't being posted to a vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 6447ea518d01..43e85ebc0d5b 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -542,6 +542,9 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 			vcpu = NULL;
 	}
 
+	if (!irqfd->irq_bypass_vcpu && !vcpu)
+		return 0;
+
 	r = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, host_irq, irqfd->gsi,
 					 vcpu, irq.vector);
 	if (r) {
-- 
2.50.0.rc1.591.g9c95f17f64-goog



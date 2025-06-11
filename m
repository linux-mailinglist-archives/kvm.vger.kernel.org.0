Return-Path: <kvm+bounces-49202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 981A6AD637A
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC0F918890A9
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D28B2ED86C;
	Wed, 11 Jun 2025 22:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OP75ptim"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950B92ECE82
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682115; cv=none; b=AErF/ER3d6+w64Mt1woRc9npXKU1j5vpZ9YGlcA7M9C4n9Ypo5sjXsp69EEBI2A3teF/uvDiVHdKlENoKszpfYdjDvam63+X1dCoh87gcUPtIuoeWVbEuxrkAdqFJfffqb3L8Gk9haFLAOqfNeZuLWF+mOzBK0f7Q5m0wiuCADs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682115; c=relaxed/simple;
	bh=oClo+BVpPugtrWJhwqiJOJyGd7gX17MvqJmd+Hb+bsE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JGGtNSScI3g5Q/sE1teVdxfv2bmz5A631ttJACZFEIPcgGSvwcxToueznOkWwICrXkgEn84om6kr/mLEdN+iPqTzIvnB9nO/LnItQgDi3dl2203OoPiXzWwFLmWRcpERX/e6OsrOWMneP0Q9fNkzcdQF7qfItb6ZKhcXWx4h4fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OP75ptim; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7377139d8b1so263636b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682113; x=1750286913; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wAqMQv4ZCiS/o57gwDnKWsXRvD97E5JGl6V3dBiKRrw=;
        b=OP75ptimfV4GgJxdvKZQ6P3R5KDdhNrkj8rrwLfEhhtIRVFxuLZM9yPBfwjGwz/30I
         kiQ0AUTg6qRvgg4PL6GKAy7JA3oIaLPQ0KKV7t9foQsVjUaCb5QKUxD9Xq9w3eYs0OQj
         0cXm2uS2qiVuOaOHI7LnMHO/3wseKNNiMnu/iKHBzc4GkN1V9KOhsW4b7qeFgBFKYD0S
         jw7mxRyl5vLNbNkEJDaXBH06RUw+86RqGoB6j+7cuNv4QcpUnYHjPS+FqJlVRG9skWU1
         odKsZNu5RFmGyAu/De9iAn6RpLnAjnprRjc6W4ojhGIyDMgH/O196CQINm3f59EvXw1i
         ZO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682113; x=1750286913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wAqMQv4ZCiS/o57gwDnKWsXRvD97E5JGl6V3dBiKRrw=;
        b=pfj6/g/XmzdTluE9WZEBC1uRr/YuVr1wCoglxMWBTM4USF+CvT4F7jQZIM9BKjDDQE
         uMk2T+Q23MHtHqTP1uU2eNfrP1ViddTTWkqbRoQtO6UMcINGttg61EVfy7MT8wpgWLyd
         Nnz10aE7gMYAKDku8vWzgJP0Wa8WQFksdqB4p7XbUwCO4TCVU369IjwS0D4OA5aPwQ8L
         h9MR+yYd+Cvka/yBrmfyuE+YyHFfiXyWV9ceitPW4CYmu2utAN9wNoyXcxwe3cz8f+xn
         2E0cQEp1tMpeM3XqScQF2rCr2quZJdOlovQxRXuDcw8cQC2xyPdVi5gVftHEQvMckbIY
         bZdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWHTy14+YgLETGVHec2aIc8RlIqHrSDfQ7xiqr6vLcOHRxifVjvi5oZ18B96Lth748Uh4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmyuKzL4Dw3LbAo1yzWzCbWlbUIEM/7ERuHU4ikON7lulQbA1Q
	gtrsABUPC2zxV6fuXTn6I/KZaVOIW7dvnJYzNfxeDz5acQ1VFKFoa4BPRIN6+eIa1i77hJaG73z
	Gclhn3Q==
X-Google-Smtp-Source: AGHT+IGWXeo6wLxobJN8weuZ+dD2iRb7MDLZVxncM/6se6ioUirEafScJTOie1Jy0cagndCeqMrM68HvN2k=
X-Received: from pfms8.prod.google.com ([2002:aa7:8288:0:b0:746:1a7b:a39a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a86:b0:736:5f75:4a3b
 with SMTP id d2e1a72fcca58-7487e0f2cb6mr1014723b3a.7.1749682112843; Wed, 11
 Jun 2025 15:48:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:59 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-58-seanjc@google.com>
Subject: [PATCH v3 56/62] iommu/amd: WARN if KVM calls GA IRTE helpers without
 virtual APIC support
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

WARN if KVM attempts to update IRTE entries when virtual APIC isn't fully
supported, as KVM should guard all such calls on IRQ posting being enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/iommu/amd/iommu.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index becef69a306d..926dcdfe08c8 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3836,8 +3836,10 @@ int amd_iommu_update_ga(int cpu, void *data)
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || !entry->lo.fields_vapic.guest_mode)
+	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
+		return -EINVAL;
+
+	if (!entry || !entry->lo.fields_vapic.guest_mode)
 		return 0;
 
 	if (!ir_data->iommu)
@@ -3856,7 +3858,10 @@ int amd_iommu_activate_guest_mode(void *data, int cpu)
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 	u64 valid;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) || !entry)
+	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
+		return -EINVAL;
+
+	if (!entry)
 		return 0;
 
 	valid = entry->lo.fields_vapic.valid;
@@ -3885,8 +3890,10 @@ int amd_iommu_deactivate_guest_mode(void *data)
 	struct irq_cfg *cfg = ir_data->cfg;
 	u64 valid;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || !entry->lo.fields_vapic.guest_mode)
+	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
+		return -EINVAL;
+
+	if (!entry || !entry->lo.fields_vapic.guest_mode)
 		return 0;
 
 	valid = entry->lo.fields_remap.valid;
-- 
2.50.0.rc1.591.g9c95f17f64-goog



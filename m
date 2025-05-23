Return-Path: <kvm+bounces-47504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0B5AC1975
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 800D51C06162
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B342E62BD;
	Fri, 23 May 2025 01:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zglV9pXa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B492A2E3378
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962103; cv=none; b=a16Iq/rwANiLLKNNhHSYxdV+mQHIgffDbanZj2phWwcmh8KW7Fv8UBg/0/l2EERYf+qCh77xCpyxmstlihhwbppHmMqIMa5aSp6IlTMaSYFbAz/9NUPObjGDLjIk13AVS6ITW2gnyuZ/M5ChLsXpS9FBZF0wK6n1Ob5sE2ARB60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962103; c=relaxed/simple;
	bh=afVOpJ4NkdTCnGlO7BZombLV0TeNOaBswisvqbRPcJo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ve3nBubXmVBnfWiboJTxA77/u/Xq66Nq+bJqT96XZRF3udf+Qu5+SJFcfBo1d4JljDrr0UyTOGRup9EXyKxJxl2MIqfOI6xlHPptKIb1n35mI/Yrka2qBuxSQBTuYxIvqtg1MgL8DnQR/De1Gr2zk0/QKBMnf9nBEZ+YGWGbtYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zglV9pXa; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b1fa2cad5c9so5173156a12.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962101; x=1748566901; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IHC46AiM3qnXIL3uFh2RBrG63I23lKwAO4ZOidIFzK0=;
        b=zglV9pXaY6tPmhkZMteS7ceglFoiwF8Nxta//bzSZ6s/9lEARrlnJyf1AOWB8OHvg5
         or9gf61AoEnyNRHYHDxKcqsgzHUCXkg/xJpqpUM1i1ocCaxiqb2sMihsCNfrSjkb26xH
         Q5wemGUGRAeuaAqsR/T9JKFvV4/ItKXegmRkZ+OKdwKdXwPYLISzLTpHhkI5+KNCtFZP
         MvA4bM/zeRHnDuw8/cX1bOrRYNcC8ZXsrnL5etOK26myO5ljtqUjZyBu7gq5EIWjG87/
         Ia2/KTJLqDMt3qRHyWVB0jXC4U8OqqQflGgA46bdCkPJu0ZwDSSCliduqZ6hag3FnK/L
         GH3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962101; x=1748566901;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IHC46AiM3qnXIL3uFh2RBrG63I23lKwAO4ZOidIFzK0=;
        b=M06tRRnapNi2Mwna/dGLzwwAJrGRDq2PoTjsl9xe/bMEAb67UuqcVs14m2dOOpcyzD
         7cilXbQDMK3d8BGMOH86eh6/QA+VKwHJxAOrXib0jiEGlzm2YWM25hVYGKVaEFj3xNjR
         9g1CaQojiQrx3sbZFcvrsh61JuPAaMjSXNwnst4Nl49hqcVJB/yRN11CMgtU2hD4eIC/
         EdCYm/GdS/y68K/U1OGwhhLZ1BdaHP4me/C9QSxvLtTPeSu2FBNhD4kFwbSNj4UnQ0p8
         p4eAf3TSybQNUBxVHXG+Q8y8imqwnkPZGv60EqJVdov4qCcc/YkGPo2FxjdeVXlE/EbS
         8n9g==
X-Gm-Message-State: AOJu0YzJuD4GNsbQ/uyMCXtr7EMrGJcjnsYoDkOMcPjt2eiRkUPD0BBS
	MuDI9sDzTtlUKL8PcbIp/JGA/JE10wqPVrT69dMPKmFLUmBZpfB+f82d0XUA6BDhXvpYSZrH8Xj
	fl4RchA==
X-Google-Smtp-Source: AGHT+IFKx4toGdoUHBPdA+oUHyZ0aWvYYcvHAK1ugv08dOHNkGrE3/X+OpJV9alJPESRVigE+cn0CzzRfh4=
X-Received: from pfbhd3.prod.google.com ([2002:a05:6a00:6583:b0:742:a60b:3336])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:8b0f:b0:215:eb6b:8714
 with SMTP id adf61e73a8af0-2170cdf1503mr41735775637.30.1747962101096; Thu, 22
 May 2025 18:01:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:59 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-55-seanjc@google.com>
Subject: [PATCH v2 54/59] iommu/amd: WARN if KVM calls GA IRTE helpers without
 virtual APIC support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
2.49.0.1151.ga128411c76-goog



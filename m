Return-Path: <kvm+bounces-42691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 053C5A7C402
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C900C1B615C4
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D8E221F1C;
	Fri,  4 Apr 2025 19:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pGmF37eA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E6B221D90
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795598; cv=none; b=lVpiNIK+QaOyG3YrpOGRSoRwFtlUt0F/ld2EWROVmvGVk++r7jBwXwlXbodHBN3Jc90AhjrL7JYkFdU5XJCbeaSJ+ntdcOxnngoJI62MvlPJivriFfictyLoE00EK3hkzPhqbomvz8oKGQYE+QagMU+JsRRxXX8K/BW7h+hR+8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795598; c=relaxed/simple;
	bh=El/LUiSqQ2qSjpNZ7D93xQ4xLdhReczWf1b9uZIPSLc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fmr7cVdRpxSNqt6NU1r29eXUYsTj6gVdrvEEZNf4cK7ILO26oN2LV7b8VdxhfaqTagmddPrCkPDJkCJTY4l14OHEPhEu8xSSq7DKXE7gwxVxMBU24PgUoJfqj75Zs40P3nqKY1g1pIrbsqRRccKCBNAlQU5SZY8rOaa333HhdJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pGmF37eA; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73009f59215so2923265b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795596; x=1744400396; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9j6UAaWlpuGUtNDZ5PloVVAXeMJcTkL+Ix626QW6lmA=;
        b=pGmF37eAJErsv3HhD+5YGlLgbZ7LcAF50/Pd3TKXyyEnyNvMEp62EDn17SrXXb5q0z
         RnhDFFYMko5LRt+BSGhW0yoaAIqm9spsVdxHuWuiUN9ZPG3tRTJm8v0yywuJU5p62Bpq
         dPiy8/QfqLrETxyrTuFaOSB+XEE5et3TQCDPax6UZ9z9MZrjikC2v2drLWV/WkJdYh5B
         U0Yd1IejSnIQmgmrkW96XbU9sQqKp2P5PI5Xi9fb6c7VM40w57i0EuoJX+l8njSmTR2O
         MkHhIfltgQ1Le6o70CLOx5Ed+xD+80s0QhuFgtiIp5CIXr0nPjSkznROBHcJcTmt1wN1
         aoGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795596; x=1744400396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9j6UAaWlpuGUtNDZ5PloVVAXeMJcTkL+Ix626QW6lmA=;
        b=AevqUc/HRxPNHtr5NOeNhe7iltRVnofNl6UpxRlk1DfSmax9psKegbtdV56JyIOzgi
         nZGmzRV+zukC3MMLV/qfPRbL/Si5oyGGCOox3sqQ9MgwT/j1X5XsVoAiTJsJ6S/dnbRx
         USD/l9ijv5E9ISbDTvOmJlfcj8K5F7JsxUzTlhK9N3JUyuIM6qFbhKluJdR97J7eNpiw
         HsRxFJziN4i/xaWscg/EpJgygzZ6XHWVvuFEnowXrnYD4ru4umvhbEfYBRMkSNJjeX7I
         H0CC3JFApUpHKSRoH1JeEGu1vDz6WXkg5HjbpDyVvj6X3u1ICOhnWhyKSVOg5ACk7uHb
         zWnA==
X-Gm-Message-State: AOJu0YxFbuVqYTbeLs1VbS552TSsqViBAlHJ/KnYF/SncLYdaudPZbGO
	ywZRCTuNOCnx5MBINpjlLw9w53qEPMqlQFq1srZFAF5rAa5aL3J+EPUgOLpjq9QQriE1k1Sm+Lw
	9EQ==
X-Google-Smtp-Source: AGHT+IHxE6ieJP/dqM4OtZ03l/OzhOac1l4SZVj083VbfNgDZX7xJqOUlyT5SF6DOaOv2f4SNNau/XxOkn4=
X-Received: from pfbjo41.prod.google.com ([2002:a05:6a00:90a9:b0:736:3cd5:ba36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a0f:b0:736:4e0a:7e82
 with SMTP id d2e1a72fcca58-739e6ff6b10mr4756745b3a.10.1743795595718; Fri, 04
 Apr 2025 12:39:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:20 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-6-seanjc@google.com>
Subject: [PATCH 05/67] iommu/amd: Return an error if vCPU affinity is set for
 non-vCPU IRTE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Return -EINVAL instead of success if amd_ir_set_vcpu_affinity() is
invoked without use_vapic; lying to KVM about whether or not the IRTE was
configured to post IRQs is all kinds of bad.

Fixes: d98de49a53e4 ("iommu/amd: Enable vAPIC interrupt remapping mode by default")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/iommu/amd/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index cd5116d8c3b2..b3a01b7757ee 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3850,7 +3850,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 	 * we should not modify the IRTE
 	 */
 	if (!dev_data || !dev_data->use_vapic)
-		return 0;
+		return -EINVAL;
 
 	ir_data->cfg = irqd_cfg(data);
 	pi_data->ir_data = ir_data;
-- 
2.49.0.504.g3bcea36a83-goog



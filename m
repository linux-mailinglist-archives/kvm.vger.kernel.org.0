Return-Path: <kvm+bounces-49187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93231AD635A
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:02:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 399191885F47
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45EA12E92A3;
	Wed, 11 Jun 2025 22:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XBb9ZyZ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714182E888B
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682089; cv=none; b=OdMd/tteL70rfqOJ+RB13eBgMUJPpVW31B5+J2oB+mSYxHVIDAVAHeDcyfYr/5JdibP/2RzfE4NOYXQbV3f1dQ9oclM+bJJU5U1ZbuCds7eo7dCw1kR1+bfWBhWw+YWS0q/grR9lPpcW9qEV6ZFS9sU4wbZ6zLjw3SaO+jbA7Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682089; c=relaxed/simple;
	bh=agTLIs+7ZgnhH/9jfFd6zwG8Wf/TcWn7XJunEBhtSx4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JNGQAzHIC0lG/OuiS8XHYqnSA6pNwEWTVaeUa+gQx+reXgsmd4WrnLOcLVsF78iOjdPZTCmhU1irsYL8Cfkg0D8bGgTpEuHOLDhe+Ip8ETOUogP8NZ6IcG/kFC9dPnhpoY0fjpt8bovtYzZsuOJjaTbVtEhrje0wbLJvmQ5xIE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XBb9ZyZ0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so443822a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682086; x=1750286886; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1jGPlsD+uHDpRgxTkjVCkrhVGHj4h2DSBv3sZnUZ6I=;
        b=XBb9ZyZ0aIx/1zh4cX0XMmptSqx7eZkrg7fdjMQ+iwDXLvy0a2SfkfCnaqlrKsweXW
         uicWjN8U2LytcbXJzstyQGhTHMKwjwVf3HTrwA3jfHQjvKo7sEnteqVioOT8y1yFl0ld
         j7IwMBPRPxYMhj3t/YVeTOdGgEqNIvRUUcspYvmusDPUb5p6gYl8Nh3acpfx1StWiJlz
         HOgkPRslXRI61TDeCC4xc6Af2uTx8yZhdm+CPbUo8EfT4lS8q/LqV53GXQJ9fUCCBIH6
         xRQRMCYQAkbbjJIndMsHI42dx4AYJKbo8qfBuwg9Cwm+UU98cLyGqyoX4Bzq3tljA+q5
         lZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682086; x=1750286886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q1jGPlsD+uHDpRgxTkjVCkrhVGHj4h2DSBv3sZnUZ6I=;
        b=gy/yTXVjzt5bFxuUvy5Yre8tZpmmtqx0/rKAlvHw+/yyJHwTp131f3w25oaUSAMiko
         SzcyKxeO6NgG2Y9nwHvY98czXQvcUToVQGduie7x9f10o3+O3uxMOU01IipgphEzzHay
         00VA4UueeiOFPOGUPUuC7qi4ZWzZXbPhzMatTIyA638dM8O7wWVYn5xNA/jdGtQg7+CQ
         dQiZ4HehHX5oOiiITcpy9VxY8HsMjnkW0nS5qrUvl2BtHXWKQHIGCr2yrCGQhqxg71QY
         aXsqamnL2roZjVpmXWBE5ebLS3RogS8Bg9QN7GRYDsxU6a9YpAEzgkwGMksbyuYFcdWg
         S9zg==
X-Forwarded-Encrypted: i=1; AJvYcCWUZsJqBS+RbpMdkJ2ZBaboYeKBSokfKMBDv3AN79qoI4bovNHANjDTf8Pr8UpQrhKsBJI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvg00TDSVbgwGWj/hRK/hjfHVqY4lOe4swVdFRu9tmQQ5YyzDq
	aQVnsQcOfrU+iTndUGfQ4MTA0Ps5aQo2MN2wHEgtWC6hIbhL5acgcbBrClfRkU/u+Kbkwqa9l4W
	1j5b8tg==
X-Google-Smtp-Source: AGHT+IGHoNvr6Cnk8J+KREg0HNO21SSc1Je6u1/AJsjFVgdYxx6GvgmCCTNG7aYe4NPsZfXP33le5zKfeT8=
X-Received: from pjbsb6.prod.google.com ([2002:a17:90b:50c6:b0:312:2b3:7143])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b41:b0:311:c1ec:7d12
 with SMTP id 98e67ed59e1d1-313c08cf229mr1001910a91.23.1749682086599; Wed, 11
 Jun 2025 15:48:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:44 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-43-seanjc@google.com>
Subject: [PATCH v3 41/62] iommu/amd: Factor out helper for manipulating IRTE
 GA/CPU info
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

Split the guts of amd_iommu_update_ga() to a dedicated helper so that the
logic can be shared with flows that put the IRTE into posted mode.

Opportunistically move amd_iommu_update_ga() and its new helper above
amd_iommu_activate_guest_mode() so that it's all co-located.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/iommu/amd/iommu.c | 87 +++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 41 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index bb804bbc916b..15718b7b8bd4 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3804,6 +3804,52 @@ static const struct irq_domain_ops amd_ir_domain_ops = {
 	.deactivate = irq_remapping_deactivate,
 };
 
+static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu)
+{
+	if (cpu >= 0) {
+		entry->lo.fields_vapic.destination =
+					APICID_TO_IRTE_DEST_LO(cpu);
+		entry->hi.fields.destination =
+					APICID_TO_IRTE_DEST_HI(cpu);
+		entry->lo.fields_vapic.is_run = true;
+	} else {
+		entry->lo.fields_vapic.is_run = false;
+	}
+}
+
+/*
+ * Update the pCPU information for an IRTE that is configured to post IRQs to
+ * a vCPU, without issuing an IOMMU invalidation for the IRTE.
+ *
+ * If the vCPU is associated with a pCPU (@cpu >= 0), configure the Destination
+ * with the pCPU's APIC ID and set IsRun, else clear IsRun.  I.e. treat vCPUs
+ * that are associated with a pCPU as running.  This API is intended to be used
+ * when a vCPU is scheduled in/out (or stops running for any reason), to do a
+ * fast update of IsRun and (conditionally) Destination.
+ *
+ * Per the IOMMU spec, the Destination, IsRun, and GATag fields are not cached
+ * and thus don't require an invalidation to ensure the IOMMU consumes fresh
+ * information.
+ */
+int amd_iommu_update_ga(int cpu, void *data)
+{
+	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
+	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
+
+	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
+	    !entry || !entry->lo.fields_vapic.guest_mode)
+		return 0;
+
+	if (!ir_data->iommu)
+		return -ENODEV;
+
+	__amd_iommu_update_ga(entry, cpu);
+
+	return __modify_irte_ga(ir_data->iommu, ir_data->irq_2_irte.devid,
+				ir_data->irq_2_irte.index, entry);
+}
+EXPORT_SYMBOL(amd_iommu_update_ga);
+
 int amd_iommu_activate_guest_mode(void *data)
 {
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
@@ -3985,45 +4031,4 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 
 	return 0;
 }
-
-/*
- * Update the pCPU information for an IRTE that is configured to post IRQs to
- * a vCPU, without issuing an IOMMU invalidation for the IRTE.
- *
- * If the vCPU is associated with a pCPU (@cpu >= 0), configure the Destination
- * with the pCPU's APIC ID and set IsRun, else clear IsRun.  I.e. treat vCPUs
- * that are associated with a pCPU as running.  This API is intended to be used
- * when a vCPU is scheduled in/out (or stops running for any reason), to do a
- * fast update of IsRun and (conditionally) Destination.
- *
- * Per the IOMMU spec, the Destination, IsRun, and GATag fields are not cached
- * and thus don't require an invalidation to ensure the IOMMU consumes fresh
- * information.
- */
-int amd_iommu_update_ga(int cpu, void *data)
-{
-	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
-	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
-
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || !entry->lo.fields_vapic.guest_mode)
-		return 0;
-
-	if (!ir_data->iommu)
-		return -ENODEV;
-
-	if (cpu >= 0) {
-		entry->lo.fields_vapic.destination =
-					APICID_TO_IRTE_DEST_LO(cpu);
-		entry->hi.fields.destination =
-					APICID_TO_IRTE_DEST_HI(cpu);
-		entry->lo.fields_vapic.is_run = true;
-	} else {
-		entry->lo.fields_vapic.is_run = false;
-	}
-
-	return __modify_irte_ga(ir_data->iommu, ir_data->irq_2_irte.devid,
-				ir_data->irq_2_irte.index, entry);
-}
-EXPORT_SYMBOL(amd_iommu_update_ga);
 #endif
-- 
2.50.0.rc1.591.g9c95f17f64-goog



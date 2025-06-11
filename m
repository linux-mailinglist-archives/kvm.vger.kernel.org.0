Return-Path: <kvm+bounces-49185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 912C4AD6356
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3C91188B61D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA3E2C032C;
	Wed, 11 Jun 2025 22:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BHLc5AJ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA5E2E7F08
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682085; cv=none; b=ZgIK73/ln+MRvMUqxFEvRIu4ahFn+jfnmjrJpzCgWAB5w5Ffy1yGSSGX1kvFDp9YxxRSp5ERJ3aQftfQaSgXOS3DJYe65Ho+HyuiEB8AIh+g2PJ0Fz3cUJIbPww1T61DMJ9OsrQJyVfGooudhx/4izywPmilPskDsovSjKZhCHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682085; c=relaxed/simple;
	bh=WiRNHbtpZOil+9fwHPGuk9Q4bsY1vkPwMWiwfcncPr8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=an0NFtb6VmzzLhkypuVGzlHkpJMOZnYpFsxOa0wtGTmuPgpeMj/TBAnkmrFoXAU7M9F8n3UNXwmIqBmJrS6d4DN4yTO1YaXqNv8iCSpdAyK4+JKNNlgmSaDDURGDM6aaumZpnD4gkOHhyCmlxOxc13dQrlASGLGfpnRF6GwwOLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BHLc5AJ6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c38df7ed2so145997a12.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682083; x=1750286883; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1o3WGFG+EaR4ZcOuVZ9zENMrapystEeQsKqGzB4EF5M=;
        b=BHLc5AJ6MXYp+grENKn9fzIqeizbNmT/T+U8X1A9hPjPt6o5IIEiT0u6N7UaT3Hbgo
         6ovsyQ6DRoadZ20o9JWJbeTvGilb1Qz7dEC13UvUHTjoLWl1t3HE/fHxc8ofGMMqmgHE
         qlx2LG9A55axp7Sd9PpwbVxG1/h4P45FnR7u3+mEWps3V/CVuF6b0mzkhZHBXxS2UgGN
         UtouXKQxduIMW0SLp0Gkh+PJeHWt4bDbVhBbg0V/k8jDjcL+ZdfQHqjJwIrDbVWJyOwb
         qiy1z0Vziq/aJp0ymPN/E7ZyHtRtPX+q6budwwblv4LnFyu4eNjmBXdYzxL+FYEfETBk
         z05Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682083; x=1750286883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1o3WGFG+EaR4ZcOuVZ9zENMrapystEeQsKqGzB4EF5M=;
        b=eNdWaGchevPTU0GmOEumksRF9W4Sm7Jp7/qg0VTal7ommtOwJch2EpFhCWMJX/Fo2V
         BOuUtguto0YJjXVmcUOs+NIJL16aJxZuB9Hw6zHxTXFRJFhorWIdNbHAZr6awBpNumHu
         VkzXrqYT5a2qExAmsjZsC9bIgIrfHa5OcC95IUbL9SjFjHZPctsRb5IEguQjVMjTY4UL
         e444o83wQM1GNZK2SZulPc7pdOpdOFEPdLvL1pE+RZhbBK8Zwyqz8ZYHbasl95NvQ+fu
         6k1vNMndEgM3RCdqNtwVtEaCnzecVf1bSCk67GhrPp9nG6RIfU73jOl/PqkdBY9CC9HK
         yC1g==
X-Forwarded-Encrypted: i=1; AJvYcCX30ggYrZBpSsZVj5jR9seFaDj9LzZJzXSEccZO9kyuOwSK7gSGzWxW32LsqjmBOvTqm6M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyD5SAJdIWKd0z72giU2TVyGbG9UkFDLAVzL6pOt6Pe8WR31/M5
	ifqDLj6t64g/1HrRcvkyIcmx6IIDs4Tlrtb+iBOjvhFsW+GRqfkViS2HfFy2i9uS2cVLVMr9IS5
	/bWMDEA==
X-Google-Smtp-Source: AGHT+IGR4w9J3onYODzU2Sfz5wEnxfVemQzL0W0aJt8YvQhN18RuJB+dzan66R+cAm17xLYHnG+IrBPZWnM=
X-Received: from pgbdr17.prod.google.com ([2002:a05:6a02:fd1:b0:b2e:c00e:65ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:8cca:b0:215:d4be:b0b2
 with SMTP id adf61e73a8af0-21f9b93f637mr691254637.34.1749682083132; Wed, 11
 Jun 2025 15:48:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:42 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-41-seanjc@google.com>
Subject: [PATCH v3 39/62] iommu/amd: Document which IRTE fields
 amd_iommu_update_ga() can modify
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

Add a comment to amd_iommu_update_ga() to document what fields it can
safely modify without issuing an invalidation of the IRTE, and to explain
its role in keeping GA IRTEs up-to-date.

Per page 93 of the IOMMU spec dated Feb 2025:

  When virtual interrupts are enabled by setting MMIO Offset 0018h[GAEn] and
  IRTE[GuestMode=1], IRTE[IsRun], IRTE[Destination], and if present IRTE[GATag],
  are not cached by the IOMMU. Modifications to these fields do not require an
  invalidation of the Interrupt Remapping Table.

Link: https://lore.kernel.org/all/9b7ceea3-8c47-4383-ad9c-1a9bbdc9044a@oracle.com
Cc: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/iommu/amd/iommu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 36749efcc781..5adc932b947e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3986,6 +3986,18 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 	return 0;
 }
 
+/*
+ * Update the pCPU information for an IRTE that is configured to post IRQs to
+ * a vCPU, without issuing an IOMMU invalidation for the IRTE.
+ *
+ * This API is intended to be used when a vCPU is scheduled in/out (or stops
+ * running for any reason), to do a fast update of IsRun and (conditionally)
+ * Destination.
+ *
+ * Per the IOMMU spec, the Destination, IsRun, and GATag fields are not cached
+ * and thus don't require an invalidation to ensure the IOMMU consumes fresh
+ * information.
+ */
 int amd_iommu_update_ga(int cpu, bool is_run, void *data)
 {
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
-- 
2.50.0.rc1.591.g9c95f17f64-goog



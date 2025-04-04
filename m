Return-Path: <kvm+bounces-42731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB08CA7C43D
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96EE61B61BA9
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5967D23BFBC;
	Fri,  4 Apr 2025 19:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GDNv8tyl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2201221DA2
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795666; cv=none; b=KXreNwVLGq5HPfM+1hkbaM4FyuKyzJIEVm9kV7VgWjig2Xkdo4quzfL+8oZXrGoNpTir9W+8rgKP1oXh40CwN5P9JoUTp+TjTEP0+PL5g1Nxr0wQzuI4gGjN8N0BkXxxUT6YbaB9f69biGEKM1xfk3Z8FTyoTNkp5n94HchT6k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795666; c=relaxed/simple;
	bh=l9/TMQHoV8daxs6LkFNlEupntQ06coEMa2x+aKyzlWY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l3OyfxdR2/L+z569gsGjgq1becsGSexmGfwbgY83lhDE04U+S5d+2kFuQRHPxrOcS1IQRQbxWSEdFNNtFi+EjdhVefvl2vHMPzwX0kW5eIzWoOvs0AyQ3h8h/VQCJSt1AoypiVofNFsVHfm9ZQsZUsp7nAQKQ8qCrgC06fARtqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GDNv8tyl; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736c0306242so3286580b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795664; x=1744400464; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l67GfpOlJHxEJdXm0d3y4sV8FlCkfwhTj3jmH6dDpac=;
        b=GDNv8tylaFqQpdGTp7C+N42x09fGsCELW7nUl/z2BsNVn3hv4yMiwzq+5GIqy2L5dX
         AzL9ATqXTGbjWKKp2qSN6mNdS+L9kQ1jApCcPKJDAzxv8DP42hapRIQNK2LFjPv/ja9f
         OEhYzcYKFgyKBlVBikVLBjZxOA2n6CTBMwPkDz6glvz4yQp6JieI0Hh7Mm/7bmNVg3H8
         iDBHnweBRMq6e+9ZMkUykJ6rS2MBdKr87MbxJ4Jhh5kAuxpBgmfAl8LahzvLZIXIgt8v
         wZxUR1ZMNJnm1mYkFgnEqxMDtBDoZtEBh2kBKvEoUPaYKn4/73UkexFrQgPcX9qLNCVs
         rm0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795664; x=1744400464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l67GfpOlJHxEJdXm0d3y4sV8FlCkfwhTj3jmH6dDpac=;
        b=uIKasnjhhVlXkxSFVtQ0rncjXMK1Ip6m+OpndGJ0H+Zq24sDGvrRuhWiNFe+VZzHi0
         9pcQCCCdGTzX4fyiiUA9obA00ufiyoLBe3LKA1ctiav3eGJZtrn9tystJrU5GC/CjPBz
         DccC9F4Op+za/ZwkmqqFnYyNC6nTnLIbEG3OTGDPLJdotln8OTlC+MMmEvfrBgU2IWTt
         urSRnRRDH43ghjD+IPkIQW5Qu5953Smx4zTpwOqzI64nLiwpHhpHLpuQnPan1EBsJX29
         /9YNQRp5pLRqzt6eVSLlbl32RbY2kiWgTQ6wWlNJ0NA+K0TVXb1HlYBp/RYNHzUUbbqY
         BpgA==
X-Gm-Message-State: AOJu0Yw38mGeJFyX6k9gb9HekzzqTZR0fwVUmUOOuHV8TyR7V1xjwgU2
	qCuIU35sMgpFWOUsQ203iBGkgtdOACt9ia+Y19fqIM3KfSntdNcIilSXftfA6eaE3+xV9fL5+fp
	/xA==
X-Google-Smtp-Source: AGHT+IEsFzK6cRrJ4WqDr7v3u7M9JaAhLsSDAqEgoXQfJ0GjLsWP9yEnMTwux+uXm8Wz38v+7YUWG83LmH0=
X-Received: from pfgs23.prod.google.com ([2002:a05:6a00:1797:b0:732:6425:de9a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:398f:b0:730:9752:d02a
 with SMTP id d2e1a72fcca58-739e48cefc2mr6715054b3a.4.1743795664464; Fri, 04
 Apr 2025 12:41:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:00 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-46-seanjc@google.com>
Subject: [PATCH 45/67] iommu/amd: Factor out helper for manipulating IRTE
 GA/CPU info
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Split the guts of amd_iommu_update_ga() to a dedicated helper so that the
logic can be shared with flows that put the IRTE into posted mode.

Opportunistically move amd_iommu_update_ga() and its new helper above
amd_iommu_activate_guest_mode() so that it's all co-located.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/iommu/amd/iommu.c | 59 +++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index ba3a1a403cb2..4fdf1502be69 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3775,6 +3775,38 @@ static const struct irq_domain_ops amd_ir_domain_ops = {
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
@@ -3956,31 +3988,4 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 
 	return 0;
 }
-
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
2.49.0.504.g3bcea36a83-goog



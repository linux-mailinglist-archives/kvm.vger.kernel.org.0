Return-Path: <kvm+bounces-47489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BEFAAC1968
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:14:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0ED697BD86B
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA29B29615B;
	Fri, 23 May 2025 01:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QebTaCgn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F442918D2
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962077; cv=none; b=uiAdJyVze8ATO/7EN4ON6Di+RzTK1mu1UZN2k6T/y1yNUA8VVEjiWtEYOGf5tHOE52VwWgVo8gHFsWkUIyXuKvRc6TFOy/vsjWATuMUmx+WxHycqfNnBcMsSJa6bDdq3Nax3nBPWtnx8MrQP/2Z1eFsE75uixHxSJb46gg1aOKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962077; c=relaxed/simple;
	bh=OTyd4z4G26pTKv/gtSvFLn3KOsoDuaV6Uaii5aU2CKU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J9/GXZS0AgwO8pdtC60qQHLRhrSgQtH5tfCWGj74M4c1N64Jhrl0QqHYcuRxeBaRKnqayG0rrn6dQCqxYm77VqB+QXTcBcqlJDWHUh/PgHVJG/4wjvJu+EGn9xf/TytCuJ+FjB7rtxzw18D3EtQlvUD6l7+k1wGThk2G+f9vWns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QebTaCgn; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-231dfb7315eso42753415ad.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962076; x=1748566876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=v1/xwskHEy3a7iwKlZ21odoIzGy2RsxvZsd2bkDzu00=;
        b=QebTaCgnAdCEG8ZT/5OYz/P3ldJeWrienJm9h910NBlbxBoLYrG8z+gdqBoa1aKgBP
         JBgra85HFKiUJRh3mfHn2Wg/X86skXciEmg39xpcqA4g/yr4v1RwdPhFgS5ApFcsexpP
         TT+A3sxX1S76CQ5quMrWBnnpXuJ9ZxBn1pRLQ5Oi/4eEUSJJWPUl2hVmZXY8p9/RzkH/
         PLjo4q/e7dy0xkNYI6qKV/f9hRN5B0p/tPf2ipCb7HYhHDHr6cZHPY4opTqRkOUKw2kX
         8Ch04U1hJOORFwH2/CDIcU/NI7vz+mhWgAXZZyaIhuNeU4gd/2dR1ROEljLuVVk6+NC5
         gIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962076; x=1748566876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v1/xwskHEy3a7iwKlZ21odoIzGy2RsxvZsd2bkDzu00=;
        b=aHQW7dUy2ueucJgWhCnSldsZAuNmROUsrDjMAVlJgZG8wFhLjCCThR+KcyiF3rsMC+
         ygOyjBEyNeHdo6WjKxpXBvOxcgIFQI7hQ13382vMghoPzJZe+jkSHB4yoUySxc5And/7
         R7vuWrsgzGkH3dAv7UeVEkkskDMz6JzhOD2iVOqEMPtMeE8faBwj8+6/rpnACPOtmoWz
         w9KN1fqaEJ2nMDhPgUZZc9hLZv1xurjn4rCXawtN/Ki6mC4mvy7BwZRpb3yy0970BugW
         EOS+L0ixdRCmX1Je+FRQwxCeUYQhg/M+vwh1QEzKrIycj3ddEonmYADWKo1cmgCRtSqx
         bKFA==
X-Gm-Message-State: AOJu0YyimDk9JV04kYs7Qw7KWQH342QQgsQKZuROhyKj+GL4Hcj5UJvs
	jskdYstchFiVhCRogtd8k0bMJ86kuJilVHiOJq26lbLbftssiQOwT650EPIHL+F2W35Z5KN3CjS
	i3777Vg==
X-Google-Smtp-Source: AGHT+IHjCMH4aai/H7vZNCaUw2MuOMj84va8p0PVDKonC3W735IHcQVEgyMS2pGd5RXUwW7ue5Pu6DTe2ak=
X-Received: from plbq8.prod.google.com ([2002:a17:903:1788:b0:223:551e:911c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a43:b0:215:b9a6:5cb9
 with SMTP id d9443c01a7336-233f21be86dmr16748935ad.5.1747962075669; Thu, 22
 May 2025 18:01:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:44 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-40-seanjc@google.com>
Subject: [PATCH v2 39/59] iommu/amd: Factor out helper for manipulating IRTE
 GA/CPU info
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
2.49.0.1151.ga128411c76-goog



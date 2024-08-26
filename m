Return-Path: <kvm+bounces-25093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B89BE95FADE
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66F591F21FA5
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B357B1A01AD;
	Mon, 26 Aug 2024 20:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T411QiG3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C3419FA91
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705066; cv=none; b=JZWVIMMg6XKN6wVajwpusTUb8KN16qkHT9mzFX0U440MkiKgEy0v0+1QaDyoaEA/DVJ3Tyb0ejGLJ9JMb5q4wDr38YqX0Ji21UbOwP5QlbxkqaZxQm0MuhNIN1hARqDltYANGmLdDemRvu8tJmpFPh0VyytizSuV8KnP1YuW3ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705066; c=relaxed/simple;
	bh=BQuf5gTrb+LFvvLLmklTnMaR8Ti7tRzNRxtQXaWJ5ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaeCeV6bmoxJkHzneKgvP77QcM5R0blVluwoq9UJrybbebckDmLXpCq1I6ehYIrMm4igatU8JyvMl42OCJrHgZdJCrKROsmd1zWQIvC/P4ykeaVSqTuUVNgrk84NCBi4eRok+rLpbrMNKw1VdmD+a2vAdawPvgQkK619hFrc178=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T411QiG3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HLBqit68L/U2mdwYaFkydFK3txHa+LkmL8n2YTQXnnw=;
	b=T411QiG3k0KnR/Jp0Y6Zo5OLSjptvrt0k8Gu+LCM8i79bNd8XItHKQ0L1NCpbH9j/KwLan
	51Q6bQUCYhpvIAS4WXuLHiF/5tUcIkUXo2J8tyPM18QnR2eGY2fs0pEt3LeMYp7yAWv/Mz
	MkSV8/taXD+LQlEn7Pmx5vfr9jzcOVE=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-OgZPF1ScPCajcp384GWIMg-1; Mon, 26 Aug 2024 16:44:23 -0400
X-MC-Unique: OgZPF1ScPCajcp384GWIMg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6b3fec974e5so90045407b3.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705063; x=1725309863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HLBqit68L/U2mdwYaFkydFK3txHa+LkmL8n2YTQXnnw=;
        b=YpIRjmD0T5IjMf+JC08SdrrY6U08Iuivjr78iamrph8HVewyVFG01+qAOdlq6CDmi3
         S13zsgcIAeZpXgX65dlXL6PetjJWigKbhSWiPcjAgReLJLsOcZIufu1DZyXXt/DmopAb
         coQGkkGawZG2ISWYYGgI9k+sb9wRKkCmmN2jJclQ3qf/nzMCC6hYiKhd/KcPmMCBAw3D
         lZBQFR+ly76OZzYUjo4HYRINDw0T0g1N8/i35fgO1rUWDmMnO2PeQWbMiyOXaClgnMlU
         TRcJTPHzzx+OoFrL78+61GsYGGozUjW/lVd7ULOLcwY4r5ZqJrWrDG0PObU69CCqKD4e
         u7Jg==
X-Forwarded-Encrypted: i=1; AJvYcCVKuWZOw6q+//gIFG2b6lMLzNYiOlPsHV96iYDCcWlViUV1PsAwGUma0Uk/vRCMOv5CdlM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOgR1lcejjN1mTk0yEohW4NY0k/+W+43XQsGTnixkAYouneD+D
	agr+a3tJx3kJAexo7WwcfWLmL+5+zEHkUgzxKE9WXEcWSq788HVe4J81L9AeJxio/3qtjCkzskq
	eAU6g2W1d5upR8O5f8/fGIx7jX2eqBfcyD2rPz+a8kfkEEHladw==
X-Received: by 2002:a05:690c:39b:b0:62f:aaaa:187a with SMTP id 00721157ae682-6c625a4cc55mr151107017b3.14.1724705062742;
        Mon, 26 Aug 2024 13:44:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeaoJv/EbB8r7mSzacjacGidgTJuNMUQKi5I30qkj93MEO5BseX564RMMiUfXmELj5ALvNSw==
X-Received: by 2002:a05:690c:39b:b0:62f:aaaa:187a with SMTP id 00721157ae682-6c625a4cc55mr151106717b3.14.1724705062426;
        Mon, 26 Aug 2024 13:44:22 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:21 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 13/19] vfio: Use the new follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:47 -0400
Message-ID: <20240826204353.2228736-14-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240826204353.2228736-1-peterx@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the new API that can understand huge pfn mappings.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0960699e7554..bf391b40e576 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -513,12 +513,10 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
 			    bool write_fault)
 {
-	pte_t *ptep;
-	pte_t pte;
-	spinlock_t *ptl;
+	struct follow_pfnmap_args args = { .vma = vma, .address = vaddr };
 	int ret;
 
-	ret = follow_pte(vma, vaddr, &ptep, &ptl);
+	ret = follow_pfnmap_start(&args);
 	if (ret) {
 		bool unlocked = false;
 
@@ -532,19 +530,17 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 		if (ret)
 			return ret;
 
-		ret = follow_pte(vma, vaddr, &ptep, &ptl);
+		ret = follow_pfnmap_start(&args);
 		if (ret)
 			return ret;
 	}
 
-	pte = ptep_get(ptep);
-
-	if (write_fault && !pte_write(pte))
+	if (write_fault && !args.writable)
 		ret = -EFAULT;
 	else
-		*pfn = pte_pfn(pte);
+		*pfn = args.pfn;
 
-	pte_unmap_unlock(ptep, ptl);
+	follow_pfnmap_end(&args);
 	return ret;
 }
 
-- 
2.45.0



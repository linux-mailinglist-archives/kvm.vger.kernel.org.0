Return-Path: <kvm+bounces-23721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ABB194D44F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC976B231C7
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9625519D8B4;
	Fri,  9 Aug 2024 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TutlbcGV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA1D19D880
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219788; cv=none; b=ZkQu70LmM/t6PI59sc0Yts/E3W3AH43UO3pa9+9e6aK5Sc1w4SMpU6E7Ez28JYjm76N4jCZew/+wG1qkO4dVriupABXTdb9GCp17/8Ay3/dBVq+jGOnj7BygJODMsMEJdRAl0yXKckxVBfcLlU21whHx8NcaX98HfTlS8cpKl50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219788; c=relaxed/simple;
	bh=BQuf5gTrb+LFvvLLmklTnMaR8Ti7tRzNRxtQXaWJ5ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZRE6DsHEYJskHjYPG18L1pMkql0nWdlHypmpFzg0DBRb+fdNGJ85dPfB72RDKX3eXIKC/DkZ47DGHoQ132CtKUBSx6ajIZXIgYUel6qnWE3fafdJniJy6gb13tQB8DMkdrjL97NqjStZQgkfv9OXrtzK/acsqbQ1RlMrJJFsnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TutlbcGV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HLBqit68L/U2mdwYaFkydFK3txHa+LkmL8n2YTQXnnw=;
	b=TutlbcGVSJNNlcvN9XGBcssDqQCAvuGKSnOUBaHjCtsHktXvs5aGKYIliG1sEOojv/5vYI
	1X0Z8Grqev/KiSG8m2MnpNs5yJKbe/o+1A90VrmmhOkYqDdGVwFgeq1X0ULlbndHcOkm5y
	NSgy7JTqdlzveTIX/SuGDxEwg5Q5h1U=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-IHLM6ygLOaeuxJSKqUGobQ-1; Fri, 09 Aug 2024 12:09:45 -0400
X-MC-Unique: IHLM6ygLOaeuxJSKqUGobQ-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4503ee1b5d6so5447001cf.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219784; x=1723824584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HLBqit68L/U2mdwYaFkydFK3txHa+LkmL8n2YTQXnnw=;
        b=J91QfHg5Xwwc9luhOjiQrz/ZutZDyuvfQ0HJn/ALXP5i+lzLXPJmWshXAv2VfOf/Yn
         iKllfkNW8Ho97terwxZyZ1PGCOMkvTUElw9OLui7yVoso5S7MOQqcxsW8nFy1UNJJ9SK
         Th5sIMyKv1qWMs4ycwSHByxZnY5PcS6oYp8gwgtWMhOh2/QYtbZT957cMgtPqYFoknul
         2lr0lYnJK7Ns9kQdQNpnaKmEkxJbF5xr/AG7AbzvYVzb9pgRTamV1p+O8wjupkN4D/DL
         eHr6lnM1Rjt/KvTbAEZiQqYbLY6l5zh1/ZbHuBq5guTNN9UgykCV4YSg7734BkJsimsL
         kgRg==
X-Forwarded-Encrypted: i=1; AJvYcCWSbOLTlz2EFB3lw1Q2KV5M+VMmOy+su03pqYG2+igRckD2JOQ09jBydo9QaZj/XVmjttTd3DjHpkcNxh7SBZugCKTB
X-Gm-Message-State: AOJu0YzH8WGrDoqDI1AiA3xM46gtWBwZyimz3jp76dceNVoCytfUhjhr
	y88SoapZB+R44gwtOYqkYQg/QnWmhZaHSXjXQLIz3kJ0FPbM03aHy86qa4pMQ0zrzqN3oKq9nrI
	80Kq6BNcKLNExtpIWddNA2p1j+FsC23xMp/Cwr3mzY8wgtELNdQ==
X-Received: by 2002:ac8:5f10:0:b0:450:349:1170 with SMTP id d75a77b69052e-4531255c62dmr14745281cf.6.1723219784587;
        Fri, 09 Aug 2024 09:09:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFbC3kPrc0fRPufwvcIMbfwNKbDcEyDmf8f6qiGpsAJzwvtAb4AIbgx0osGWWLWwEBOAE+Pw==
X-Received: by 2002:ac8:5f10:0:b0:450:349:1170 with SMTP id d75a77b69052e-4531255c62dmr14745171cf.6.1723219784295;
        Fri, 09 Aug 2024 09:09:44 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:43 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	peterx@redhat.com,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 13/19] vfio: Use the new follow_pfnmap API
Date: Fri,  9 Aug 2024 12:09:03 -0400
Message-ID: <20240809160909.1023470-14-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240809160909.1023470-1-peterx@redhat.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
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



Return-Path: <kvm+bounces-23722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6027C94D451
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAC47B2348C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6924A19DF6D;
	Fri,  9 Aug 2024 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FxGnCoP8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDAB19DF45
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219791; cv=none; b=eTyEigwBofKmCRcIZ751DBOAfZHxa73Nv6IZDvJtx3jyZokq3pKxhIRF3IStv0NPlHFV89SVI1EJ+zivwA5vNES8bWT085Mpyq4XuZ8/64LWttjR5LgnhgvPjDPiUo9g2K414+7olJJmELlurq41T+sl4L4CFeCXTujH/SIomZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219791; c=relaxed/simple;
	bh=RxaKGf99KcIXWtv8SyMqO8KfjLx2VTZrfelSTDMLhuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2tPd6dxSWXBXc/aYAn1IBnxRir/JGSfy0MrqQhPjg6PQwGISE4qYbT4p7VBhIv5wqtBq6+TBFk5tBamLanNoOmL4pD6pfsdqhuzfMBGiTuGOib5heZMxGaA2FiUc2lvJ2n8LLcDSWus+ffOt+pPm50ucF6CiRps4XCGr5k6joY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FxGnCoP8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d0kI5he4gLOJUpsF87CpEeiS1FOCa69CaYI81su9df0=;
	b=FxGnCoP8SUfK8tA5RcVz8ty+i+dCCHyLzapYZu+lYunDTQifcu8gEcZpFnSBUbAz6sLbP6
	sMJeP0OgMdZYek3O8slkrNCFwMn7b2a5EFLF3aFudhwkGT78D7kxshvg8zZ+6hCcCoBlW3
	OtZsIw/UVoDnwfczGVeXUXnuP6GwZLM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-JLVXzBLkM42347RHlZGVAA-1; Fri, 09 Aug 2024 12:09:48 -0400
X-MC-Unique: JLVXzBLkM42347RHlZGVAA-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-44ff25bbfe1so3070441cf.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219787; x=1723824587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0kI5he4gLOJUpsF87CpEeiS1FOCa69CaYI81su9df0=;
        b=RF4tVWAqmNVW3OYaOUfB8/JN3BKoykBGRyZZHS57Vn5uIn/ZJphByaT91eGJz9zTnl
         cmt5hwsdlBeFTD9fhRbnMR6u3MO8lOGmMuKa/X3F0igpEI4dTsRSPtQ6fzGxqeDCtKYd
         IvjXJl7Dw94g69udeQITQPE6ZlSwdS6zk+Y1Q7J4mi3hWCbnF57FN0iJW3ovRIgYT8FJ
         ag0EUJ+sY1tZMfaLEF5rzgrnpyCR5wuNUUe/K3uTejwPf6obhyQJbB1uWZKg4K1boBcL
         c6EejvmtIcab4ObmpBsGJ+Iqv1kB4NiAdc1UdwQ/mxW1Q3eiKGlgmwX6JNq/GiVd3Qaj
         33tg==
X-Forwarded-Encrypted: i=1; AJvYcCWlx9l4QfMspgPGWALnZL9a6+UOWHsdnD5QcBNReWf3aFGDY0iUR0w0R8/yL9WmybsUoH0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3oJAZD0Cb7zvwzWLQUVa0xp3bp4AvAF3xj/AiZs48wU65qgif
	i4R4DlcrBqhwkh35p2vG78ZbR0hZsMdlSYZ6V6qiip7tX1VyiDNhb90eBCWHXS0W1zXUS4YgOvl
	8fX+mCOQWngOjTz0GJcQTfw2F6zSACQxomihIYJomIY+YVfSJMQ==
X-Received: by 2002:ac8:5acc:0:b0:450:26ca:9170 with SMTP id d75a77b69052e-4531255b48dmr13596631cf.5.1723219787023;
        Fri, 09 Aug 2024 09:09:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxpG5xPFbbw3Y9PVyV1kJ47S21qHA1+Fquj+FmgsVP6Zo0aX1jKS3YWr/9l77XMEl3bpPFxw==
X-Received: by 2002:ac8:5acc:0:b0:450:26ca:9170 with SMTP id d75a77b69052e-4531255b48dmr13596351cf.5.1723219786668;
        Fri, 09 Aug 2024 09:09:46 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:45 -0700 (PDT)
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
Subject: [PATCH 14/19] acrn: Use the new follow_pfnmap API
Date: Fri,  9 Aug 2024 12:09:04 -0400
Message-ID: <20240809160909.1023470-15-peterx@redhat.com>
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

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/virt/acrn/mm.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/virt/acrn/mm.c b/drivers/virt/acrn/mm.c
index db8ff1d0ac23..4c2f28715b70 100644
--- a/drivers/virt/acrn/mm.c
+++ b/drivers/virt/acrn/mm.c
@@ -177,9 +177,7 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 	vma = vma_lookup(current->mm, memmap->vma_base);
 	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
 		unsigned long start_pfn, cur_pfn;
-		spinlock_t *ptl;
 		bool writable;
-		pte_t *ptep;
 
 		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
 			mmap_read_unlock(current->mm);
@@ -187,16 +185,20 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 		}
 
 		for (i = 0; i < nr_pages; i++) {
-			ret = follow_pte(vma, memmap->vma_base + i * PAGE_SIZE,
-					 &ptep, &ptl);
+			struct follow_pfnmap_args args = {
+				.vma = vma,
+				.address = memmap->vma_base + i * PAGE_SIZE,
+			};
+
+			ret = follow_pfnmap_start(&args);
 			if (ret)
 				break;
 
-			cur_pfn = pte_pfn(ptep_get(ptep));
+			cur_pfn = args.pfn;
 			if (i == 0)
 				start_pfn = cur_pfn;
-			writable = !!pte_write(ptep_get(ptep));
-			pte_unmap_unlock(ptep, ptl);
+			writable = args.writable;
+			follow_pfnmap_end(&args);
 
 			/* Disallow write access if the PTE is not writable. */
 			if (!writable &&
-- 
2.45.0



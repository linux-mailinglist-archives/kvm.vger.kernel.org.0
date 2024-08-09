Return-Path: <kvm+bounces-23723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0CC94D453
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B97528650F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A97119DFA2;
	Fri,  9 Aug 2024 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EWkpGJB9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D826119DF5F
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219793; cv=none; b=Da3ziQiz7y0sHtx8MjozEo301eSKXSdj0EItOqC0z5Qjxyv4pu7NWi9U6VupK9kK4hJadw37CGzGFNGNoYnTv6fAcdrbfPkeNMURpJlk0GuIxDXonhEchWjRx6woCfuqF0WUAJaA/hFKCsWYDTSrvnySd2btx7PBqinxa4I2VBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219793; c=relaxed/simple;
	bh=oaBnSvpJERjRBU4mG2zRAc+u205z76QvJz7BlHn3mFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ub5zuwndqBuoZNA7zuEc/rbRuJ0zpWTL8+RNggOvc/sn1pHlODwlQFqzHWmW940Da3R8PJ+qa2oNCWYTS5NXdTbh8iB6+Xy4N/IFmlIGKGhyX4ftw9xV0uuUvOjdO2ij3c7TxZA4e4D/IZ/4pTPsRSHsbougUn7dS+UEH7QjH40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EWkpGJB9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FTs1XtnGv67Q34nCFPbcUqDR1Dyk8Tfq0P0nZ4zw7U=;
	b=EWkpGJB9yukEdJFlqJlsDn0v09vGPmQHACYE792f040Ts870fkR/OmRP45y9m53MjPvMBt
	nI8YZg8Ed1u8evzruu7rxZ18p0P6izczQD3/YulugyF2Iu5nvgPKM4k0EeTmtQSKWxvcF6
	Od/mFbvn0Kg1Ot6DCHbJhPzn3LmXDnA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-GOfxvW5hPrKLpt3uKCltMQ-1; Fri, 09 Aug 2024 12:09:49 -0400
X-MC-Unique: GOfxvW5hPrKLpt3uKCltMQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6b7973ab9cbso5685826d6.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219789; x=1723824589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9FTs1XtnGv67Q34nCFPbcUqDR1Dyk8Tfq0P0nZ4zw7U=;
        b=R3qzg+Ex1dVsY/YtWyUttYTkL+xXHuLl4EVtfsFr0l/K1JgwsczdySVjF9S9o45Wca
         Lk2LbfkdAnMNNQ9Pucs1up0mU9pFsB0spoYYuPR2wu7CCt4auwiJcnleXnr3vVkWJy56
         CGXl8e5yXDdDU780lBgp8wyebddkV1YZCC9C+dszcnvehsSZI71j/U5wP7PDOp2Uv5D2
         61u8O9nfyAbS+5czBCqFf6E9O4bBMA1qjI1MmL9ntQvAehDhvAVzyr+FCcMBBA3RLoQH
         zzpphU9yKn9Ddg4UNUqtCZdhxyR71DdPGUSJyrWsEBIQrCduwaz9Y2WtKPfKuh7Va/Yj
         PK3g==
X-Forwarded-Encrypted: i=1; AJvYcCUrdW37LvxhYf9Y44CLCdvC/NkHy8dvaq6Qsn7dd/GheRwtDHdiVdpw/Wx7lx3Te+13jbE9/kwMaaDhAVV3o/9wOZfw
X-Gm-Message-State: AOJu0Yxrpf3TZd9W8N3sXBHg4E7jaI351WYM/w1qD4lW9g8hOL6BHtLs
	nw2qx1yQj6dYbKdfIoFO7uec7XE8jsMT7DU8m/FmBC4tYMarE/wGHCcN2GiMQOwp5fW6q+BFedc
	NxZ9DX3Knh+X/rh0XEniv8ehtcfFnbg1Yb4c5fLp2gnakMvNW3Q==
X-Received: by 2002:a05:622a:11d1:b0:446:5b0a:e778 with SMTP id d75a77b69052e-4531235a44cmr11674971cf.0.1723219788788;
        Fri, 09 Aug 2024 09:09:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3kKOCpVIG6mSA6dMC4Xb4vB8Z6SmUroM26OhSq4nP1v0KE/gOqkuWVbJLnRl3s3aUYCeIEQ==
X-Received: by 2002:a05:622a:11d1:b0:446:5b0a:e778 with SMTP id d75a77b69052e-4531235a44cmr11674811cf.0.1723219788421;
        Fri, 09 Aug 2024 09:09:48 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:48 -0700 (PDT)
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
Subject: [PATCH 15/19] mm/access_process_vm: Use the new follow_pfnmap API
Date: Fri,  9 Aug 2024 12:09:05 -0400
Message-ID: <20240809160909.1023470-16-peterx@redhat.com>
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
 mm/memory.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2194e0f9f541..313c17eedf56 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6504,34 +6504,34 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	resource_size_t phys_addr;
 	unsigned long prot = 0;
 	void __iomem *maddr;
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
+	bool writable;
+	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
 
 retry:
-	if (follow_pte(vma, addr, &ptep, &ptl))
+	if (follow_pfnmap_start(&args))
 		return -EINVAL;
-	pte = ptep_get(ptep);
-	pte_unmap_unlock(ptep, ptl);
+	prot = pgprot_val(args.pgprot);
+	phys_addr = (resource_size_t)args.pfn << PAGE_SHIFT;
+	writable = args.writable;
+	follow_pfnmap_end(&args);
 
-	prot = pgprot_val(pte_pgprot(pte));
-	phys_addr = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
-
-	if ((write & FOLL_WRITE) && !pte_write(pte))
+	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
 	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
 	if (!maddr)
 		return -ENOMEM;
 
-	if (follow_pte(vma, addr, &ptep, &ptl))
+	if (follow_pfnmap_start(&args))
 		goto out_unmap;
 
-	if (!pte_same(pte, ptep_get(ptep))) {
-		pte_unmap_unlock(ptep, ptl);
+	if ((prot != pgprot_val(args.pgprot)) ||
+	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
+	    (writable != args.writable)) {
+		follow_pfnmap_end(&args);
 		iounmap(maddr);
-
 		goto retry;
 	}
 
@@ -6540,7 +6540,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	else
 		memcpy_fromio(buf, maddr + offset, len);
 	ret = len;
-	pte_unmap_unlock(ptep, ptl);
+	follow_pfnmap_end(&args);
 out_unmap:
 	iounmap(maddr);
 
-- 
2.45.0



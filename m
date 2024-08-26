Return-Path: <kvm+bounces-25095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2D995FAE2
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33E151F23E96
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58721A0721;
	Mon, 26 Aug 2024 20:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RE2//aLs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741091A01D4
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705071; cv=none; b=HxgmESalJihDU2kghNU1ZDBMpJvGpR7ohcz6yXE9nflOZ/eRyrJ1IDEixkawLHQonzRKiz65sESRKdGdv4rTvntwm2VtRuV6pnAKyBYiUVuxbUhewjoNdY1C3g7WUk2yMIqc5PfWU4NaIO2zmDxpS403LhsDf6mDeOdlDTk88Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705071; c=relaxed/simple;
	bh=hpLmEYhsByAEmqEdBsP006I9UauZryxW/FlKEPWnJc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foliOG1ioSZ/GpC5VLARFpBkC3YFkbvdOgHZU5LarTYOgoAr3wvqiAZ0JC7qcxjgHFUrKOtDjB1pJux78JezjakFAFWyytFULk1zCG/7zbYLybu8eX4b8Ai1T/v40wclXGgKBqljyvl8wNwQSPTXJa+JjkWInEGjDNWuA4YT7c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RE2//aLs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t75nynj+5ccZ6qy3UooqAYOOLyCQeJyCwmKKtTf1Ss4=;
	b=RE2//aLsidYqxI/Vq6eXXVa8odw+UOLLRE4cBut+e9JGmNhrdEGZav1WTRmgPolejdkoS2
	GXNceF38y1X7f85RMpx7fRHAn8o442O4PKfKb9LIQkO53QWXQISHWxIDypra9ZkyCgoLm1
	ySXdhrh0LQKdxI7FLpsx0tu4+ft/VvY=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-inRu7sl3OE2epc-tPpi9xA-1; Mon, 26 Aug 2024 16:44:27 -0400
X-MC-Unique: inRu7sl3OE2epc-tPpi9xA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-27061a48e70so6268033fac.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705066; x=1725309866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t75nynj+5ccZ6qy3UooqAYOOLyCQeJyCwmKKtTf1Ss4=;
        b=Gp6QmrQcUJ7V3aoTeEnydLXXV6j6SpZThDM1GAo6sqYG6cthlU8FrsGldADOuYJq9W
         BKYf5Vmu6m5bPtDA+OQ3BWu0LoSZyPr5syYi4kxZcO8zmPoTAAgFKb+hVj5IuCWiSqTK
         NfcJDFsDFJ3jchHam2hM/priUjEKSvgm5re4WZFzRTOBq4xzLp1g6Taj/reLoS9twyBH
         sBMjfzMQiAQAjFM5jVEsrdk3F02DzX8hjdKdK6mhAaxvdXOaPhXW6E3tosu/HQ2RuGnS
         seil02Nr3De9+87rlgT2Q1m0SPn8+mPCeO9jZpLZsiz48056lU6fIHxBs4ULnb6/OzFC
         g3vA==
X-Forwarded-Encrypted: i=1; AJvYcCVGHywL/ikKt5pHcV+PI34V3yuaf6fJnonem1xnhJIaQxVBrNg1cNlzq+IGJnUIf8u4i4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YybJpkE1hhOL1FIBNevDGBLoC3JLb9krFfBD8y3hbF/aNQYOaoJ
	xetXrzQL0q/btjj6OlZyDHR8iCBy+pysJHgqQslB89AqG9SlxSrmKT8Xd/dF7Qvp9gjW93gV5nT
	XOq4iJo0CtJX1qtF5Q3siGI+DUrSSss6WScbCqMHARoWwpitPKA==
X-Received: by 2002:a05:6358:3a07:b0:1ad:10ff:341e with SMTP id e5c5f4694b2df-1b5c3a3b69dmr1457843355d.4.1724705066539;
        Mon, 26 Aug 2024 13:44:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoPajws+HFHWojCbb3D8qBEyBE/zIeN3nkxAxD5pVBn23+qUQ20h6jqSHyvqmBY4DTTGYw+g==
X-Received: by 2002:a05:6358:3a07:b0:1ad:10ff:341e with SMTP id e5c5f4694b2df-1b5c3a3b69dmr1457841255d.4.1724705066240;
        Mon, 26 Aug 2024 13:44:26 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:25 -0700 (PDT)
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
Subject: [PATCH v2 15/19] mm/access_process_vm: Use the new follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:49 -0400
Message-ID: <20240826204353.2228736-16-peterx@redhat.com>
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

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/memory.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0b136c398257..b5d07f493d5d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6342,34 +6342,34 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
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
 
@@ -6378,7 +6378,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	else
 		memcpy_fromio(buf, maddr + offset, len);
 	ret = len;
-	pte_unmap_unlock(ptep, ptl);
+	follow_pfnmap_end(&args);
 out_unmap:
 	iounmap(maddr);
 
-- 
2.45.0



Return-Path: <kvm+bounces-25092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 718F495FADC
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:47:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 257A01F240A1
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE6419AD94;
	Mon, 26 Aug 2024 20:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PafE/RZG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E71B19F47A
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705064; cv=none; b=JauRQJ/mZxSeLW0mFhbMWj97D5+/MJOjpD2dX3A1+tl3ii2GC2oq4lIFFZJLpbu/mA7AEDUWg+T7XnEchjR8GO0u8jIlEdwrtUrin0bthzDhuntZsTFVFOuqC1/VaV6LNRs24rK0yh+BwWat1ZvCXLYsj7ZcttMZgtfPm877biE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705064; c=relaxed/simple;
	bh=tylq1muqjeOnFYCjzZOC/g07tmHzw2/ZVGGdJsJupkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsMoxEA2dQqhpHYQCzWhSriLSleh4mDSImqUsrrzDdZeEn9+7KHQNQb/TWspn/XLT0a2grFRI25pKcg+sI/UbUmsyn0ZZ94Zz5EoN7H3FfY4dKQaTp0uaCJjjcdyqNylXlGr/MJFlHclYhOzquazS0L6ThFk10M8IuXEnqEoUKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PafE/RZG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=moprxbUn5M7+L+63SZwwyqeq4iL0OHeeIJZbsfnkOho=;
	b=PafE/RZGFVTYMxQTpjZoYnyhDgjwSIbUlcuYbqOJj5uf1Cn+leiVrI+5fxn80s9scRnU4D
	ytXSUtmLaKapmz2+dRy6A0bEB+pj1At4oU+ZmBzwxjgIXKSahSZunouU+K8KljZpaKF5HJ
	Z5eoBzjHwAGQHnGqxehQe8nirXQcQGY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-5HcWGlDaO2uz19YfwB3Y0g-1; Mon, 26 Aug 2024 16:44:21 -0400
X-MC-Unique: 5HcWGlDaO2uz19YfwB3Y0g-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a1d690cef9so882239385a.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705061; x=1725309861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=moprxbUn5M7+L+63SZwwyqeq4iL0OHeeIJZbsfnkOho=;
        b=o7k1pPtfLr5xxKfWvtWjh+WpW8sTz7WBbLfybGv/wMD5MimyT1vpmuELn4VLbp1SLQ
         F6gsZcXH+vz0guObDydWL7edtQ6rTBLOvqft7Ts483cokO7wiIGrtdaaH6CByUAWorVs
         /G+yFGNPtHrtkHhf01jOwbwqcDxeSY+HLnViexnFXmJiexoG/Au2WBtFmyDnVYc9BLmU
         /nXnj+v8IrspDNZcz/9TZhX8yBCBU7x2/gOls0+RquhrpzO71msGRAITzDn5AZLIrxBj
         OxMAanJyURvgGLy1y6qWPDB9tMyXLdt3LRk0zuTNY/XJYeJxjOMaXGi6tKPVv+0w9j0J
         sW7w==
X-Forwarded-Encrypted: i=1; AJvYcCXS2ulYZvaoxoMZgR78JK6+DUo8IGGpi/rJUn7bwgExO7oLkJB43jmhmuYKzVgIMw1ohdI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoHz+chLG8JtnA/bGO79M246k/5K7xzh+iL5ePwXplvQbemdQg
	+9MMoKL+GsDSS0glkcqH33vFGB4homrXgODa0b8ZLX0Qnr+OhXjdNT/juIQgX91f9YnV4Q9Ihtd
	UNrheZusfj/mp+NrKYWv+mlK892NauBG9SW+0BtY3pC6GFXkbeg==
X-Received: by 2002:a05:620a:1a92:b0:7a1:e341:d543 with SMTP id af79cd13be357-7a7e4cf3a3fmr158797885a.28.1724705060677;
        Mon, 26 Aug 2024 13:44:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8L+Naz3FkxDynSQ3yMse2qHglqFkf4LqBPi/5cD3sQEuFfYs6yWPMbT2Qk9XtpK98A+7trg==
X-Received: by 2002:a05:620a:1a92:b0:7a1:e341:d543 with SMTP id af79cd13be357-7a7e4cf3a3fmr158793685a.28.1724705060390;
        Mon, 26 Aug 2024 13:44:20 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:19 -0700 (PDT)
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
Subject: [PATCH v2 12/19] mm/x86/pat: Use the new follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:46 -0400
Message-ID: <20240826204353.2228736-13-peterx@redhat.com>
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

Cc: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/mm/pat/memtype.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index 1fa0bf6ed295..f73b5ce270b3 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -951,23 +951,20 @@ static void free_pfn_range(u64 paddr, unsigned long size)
 static int follow_phys(struct vm_area_struct *vma, unsigned long *prot,
 		resource_size_t *phys)
 {
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
+	struct follow_pfnmap_args args = { .vma = vma, .address = vma->vm_start };
 
-	if (follow_pte(vma, vma->vm_start, &ptep, &ptl))
+	if (follow_pfnmap_start(&args))
 		return -EINVAL;
 
-	pte = ptep_get(ptep);
-
 	/* Never return PFNs of anon folios in COW mappings. */
-	if (vm_normal_folio(vma, vma->vm_start, pte)) {
-		pte_unmap_unlock(ptep, ptl);
+	if (!args.special) {
+		follow_pfnmap_end(&args);
 		return -EINVAL;
 	}
 
-	*prot = pgprot_val(pte_pgprot(pte));
-	*phys = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
-	pte_unmap_unlock(ptep, ptl);
+	*prot = pgprot_val(args.pgprot);
+	*phys = (resource_size_t)args.pfn << PAGE_SHIFT;
+	follow_pfnmap_end(&args);
 	return 0;
 }
 
-- 
2.45.0



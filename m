Return-Path: <kvm+bounces-23720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E0394D44D
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E95CAB2453B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955D019D88B;
	Fri,  9 Aug 2024 16:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pwy5jr0F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACC319B3C6
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219786; cv=none; b=aynlJnUOUy9s+2amdi1Bl0Hb7Yyas4DBmjH2URvMD4Gh+nRCQFl5qX1ne0rrzte4S1TeHxnZo77zNvMy6B8zZF9fAyUEGd5fqiayFwZuE20wTwa+yU4Ymcspp14zxnYJ3XYQgoD8hZRP4wmb+nnZWfQU9pJAINHZ6IBmIk3ZdNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219786; c=relaxed/simple;
	bh=cEBXN2JPB5h1OhPiVAJoVLWyvN7G/G3nl780c90YYQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kc3gA+srep9hOAke50W9eQfGFZ/lPqgo1LkKSZENj0CbatY7vEVH/129FQ3upvZnVVBh9ZHn0J3KoM/Ae1akQEXvVdJ1AXfu268J2TJuvPE9LwJFngm6HzVaE6tTIo5nIMAQmX5tC1JkhAehtIyERTFb/n1QNrrpDLQ4QCWMK6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pwy5jr0F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dHUdq0ZI2fvSzmSbu56kn/TFI4mY4GVPslnR6ZzQETQ=;
	b=Pwy5jr0FWp9f9lKMhTPNW66YCIQpcq7yB16eGBtHYi0Yz1mpYI/WG1e7dtaZC8N/Ik1H3B
	A9R6jrD2AmYijGzdH3kk5y9Ue3DZzoMj7kWtQRQkET0Ag4kfZRosAeixyTWusG0h16eNlH
	Qu2Ls129nThiUeO0Slrj93TkAn/BbfU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-Q4MpPjTNM3ecUiZ0cqc-tg-1; Fri, 09 Aug 2024 12:09:43 -0400
X-MC-Unique: Q4MpPjTNM3ecUiZ0cqc-tg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6b79c5c972eso2605446d6.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219783; x=1723824583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHUdq0ZI2fvSzmSbu56kn/TFI4mY4GVPslnR6ZzQETQ=;
        b=gnUdN4PAKcuagv0h6G9NVTkxzJ4KHOhqBqueYksiG63nrG/mhhezSEYD7VDTli3J+i
         nUWUE9LHisxA5qzK0MGZkow9G706mCPV4sVhcGIrhjf/3ZuF6DCKZ70TnQ0JBkNGUtlb
         nPcTdXDlBVbcLlJxCSWm2l9/PbKG1wF3z0DhGtsKPvTj4jDVWETsWUKyGQKzFiXHioU/
         fZtzWEL7x1fWUAR3NcF4VGGj6zKaqIGZq4DFJwQ9fFLmian3yfT/Q0zkkjFy/v03y7Gp
         mPYifrUCRU+/nJ27RUmqTXo+PfEkAWwICUNfYpKQR1kiyS2j8PoWFXUZwoa4fmhLUXgg
         lptg==
X-Forwarded-Encrypted: i=1; AJvYcCWN5ZhUbLKH1BAiuYC2+1DO76hzCrrep+m6s8w2CDs8pJlnlVTn6UWt/xZBMttR3J+b7Zw3VYTo397PY98mH+7tpXtX
X-Gm-Message-State: AOJu0YwZd3wzKYB4Un+/LM6xfFy9h1g98jtwY1WR/GuczTviHWrQJNsw
	/4FafGwrl29j20XXfBl5KVb7iJqCyReFpq3G1R67OlgoEdpmNG2iIMwquoZAtyQX9cRiEvF8fSD
	sRtf3Pf1eV91E89IdLoYjyWoMvlyd+cxdvSHsukG7gPGKGJZe5A==
X-Received: by 2002:a05:620a:460d:b0:7a3:5e3f:cbf4 with SMTP id af79cd13be357-7a4c18467b6mr127416085a.8.1723219782741;
        Fri, 09 Aug 2024 09:09:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqMMArTR19FgmAq+7tz35tycS6tSaD4MMjthIpuW8WNcff+L3Yj5M2c5Huoz5dZxDipeszqw==
X-Received: by 2002:a05:620a:460d:b0:7a3:5e3f:cbf4 with SMTP id af79cd13be357-7a4c18467b6mr127412385a.8.1723219782335;
        Fri, 09 Aug 2024 09:09:42 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:41 -0700 (PDT)
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
Subject: [PATCH 12/19] mm/x86/pat: Use the new follow_pfnmap API
Date: Fri,  9 Aug 2024 12:09:02 -0400
Message-ID: <20240809160909.1023470-13-peterx@redhat.com>
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
index bdc2a240c2aa..fd210b362a04 100644
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



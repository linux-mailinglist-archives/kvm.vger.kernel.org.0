Return-Path: <kvm+bounces-23711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A1A94D437
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1FF01F229D4
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F53199398;
	Fri,  9 Aug 2024 16:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dzy9cGwo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D33919924D
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219766; cv=none; b=QI84c55+4vU1pNE9ZRIowCo4P28F00Q02iko/1HPfWvshdruoT/qIRmIl5zsWz2okKFVPn6Aymja+myp6z4XbEOn1ebvmourjIjjHuIePB0VCFXD2ilmVCxrkO6jNgKG6upO+oxucHhRwaBxn/co77w9SGr+WjgnQH1xAKWpOlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219766; c=relaxed/simple;
	bh=c/Kt4iwzwH+bi+XcBBAmrHfE490XylwYWMNetRWl84M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPc1ERyC9BWXyPBEIoKCULvwxWDhNGVzBHHNrTL996keTzzMjBqXGBm7erpnunLSP461It1fXStzcbdq6L+zG8W1YF7mn4QYrOozl9p0WRBZdpZzBX/4PinzJe/jxqJf18yA4hrFyndPesolSHe1k9HcHoYNwSViFOi4pSGkuiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dzy9cGwo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pOevS25kl1+p5C9bnayjnL4IWCIfturozNfzs94vCz8=;
	b=dzy9cGwoDlnVfld0DZTrbmzpJXb+FM0sY3FC/cq2XjzLFzwEckd5B9ZzKPmcPINDjADbBL
	iLWZKpoKE9Uc0VX+HHVMXIGhTo8i6qbzf3E0tcfNxfpNoRehoxZhVj2e6K+9a2h82NqiL1
	p7SfX32IH2m6jppX2gpUfr8jjd9LgaQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-q59OqY5BPIusNpvmo4OleA-1; Fri, 09 Aug 2024 12:09:22 -0400
X-MC-Unique: q59OqY5BPIusNpvmo4OleA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7a1d3c02fcfso7767285a.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219762; x=1723824562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pOevS25kl1+p5C9bnayjnL4IWCIfturozNfzs94vCz8=;
        b=HSZBQlXP4x86UvumcYA03fk5FMmQLZn/ZZcpFp3ozyAPDwmvFT23YHA95osOGzUbin
         BZh/f8N7CdcIFlFHGcHKuk4P8LAAauVJk0KDrlFUy8Y2xsjfeG1zYrgyTI8PPK5mQ2Ek
         vTzZ96wHvmeC43hnZFGOEpF+r76l2um5cKAMIn5tgH40UyAde8GD8+XDcfmPBIRmW0NI
         FTz8rpL1hUoo0X833PTFlHiJzcDPL4cGz1SprYIs2gk4V624EKABUMNRgO0fH4yYX6ua
         utLr/9lmCZbKAVRs0VKQkoQMz/wra6SHPQ9YbvhOXOtQnDwsYg20xe5M2+yTZn3d5zsR
         FP7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJisVCMWPCq6BijdHMUr7wWQw6h5LfzqvA3SiBEBtnAipzkBKIbyiAzOeGvQ5mzTIiqFw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQSAywKknlHMXA5f6wvKNKwJqykAvMeCcY8P7URV9dpWWKPtlZ
	O1P1tFZIAtDQOFQselKDF4HzXD4eEx3jlerC6D5+2usYbvUdJ/kd7fFYrUHK1P5RVSxt9JupWvI
	a1V61q3XW8rgQtAYua6ipLPB0oXW4iR2nonDELRh797IBHI9ygA==
X-Received: by 2002:a05:622a:1a8b:b0:44f:89e3:d119 with SMTP id d75a77b69052e-453126babcemr11885571cf.12.1723219761635;
        Fri, 09 Aug 2024 09:09:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHUujWoHeQHvUCs2OAJSjyQdbxlWd9FX1yi8fb3RZKwv0O5abV6g6G64GeuNGe2uyjoJD48A==
X-Received: by 2002:a05:622a:1a8b:b0:44f:89e3:d119 with SMTP id d75a77b69052e-453126babcemr11885331cf.12.1723219761262;
        Fri, 09 Aug 2024 09:09:21 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:20 -0700 (PDT)
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
Subject: [PATCH 03/19] mm: Mark special bits for huge pfn mappings when inject
Date: Fri,  9 Aug 2024 12:08:53 -0400
Message-ID: <20240809160909.1023470-4-peterx@redhat.com>
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

We need these special bits to be around to enable gup-fast on pfnmaps.
Mark properly for !devmap case, reflecting that there's no page struct
backing the entry.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/huge_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 39c401a62e87..e95b3a468aee 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1162,6 +1162,8 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
 	if (pfn_t_devmap(pfn))
 		entry = pmd_mkdevmap(entry);
+	else
+		entry = pmd_mkspecial(entry);
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
 		entry = maybe_pmd_mkwrite(entry, vma);
@@ -1258,6 +1260,8 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
 	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
 	if (pfn_t_devmap(pfn))
 		entry = pud_mkdevmap(entry);
+	else
+		entry = pud_mkspecial(entry);
 	if (write) {
 		entry = pud_mkyoung(pud_mkdirty(entry));
 		entry = maybe_pud_mkwrite(entry, vma);
-- 
2.45.0



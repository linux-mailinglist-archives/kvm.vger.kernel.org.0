Return-Path: <kvm+bounces-25083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2851A95FAC8
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:45:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5CB01F22487
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6180419D070;
	Mon, 26 Aug 2024 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bvNdCgRH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DE219B5A3
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705047; cv=none; b=Ft5Mrv8Jjz8HZpof4VEJbAmIzLgp7uUkLDcf0oujKa9Z8HGy82ElTUZwVO6PqW3zHRoe/0uE2xTilyifokPCBomed/hxCIm/5ugyAN+fqe/JfYRp+VZnu+M+AIUvM/aTu7NKGexEf4iCRBVeSgL28pcLDVkqAYhwAAEgZtcZPJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705047; c=relaxed/simple;
	bh=cBR1CRPKBp17TA49iECdr5UwUokaTW4WPHX9nl57T+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIhY2LRzTqEfiq4Sn3ajQ3UU+fnAtIDd7Ssy5mjAMkLxM2edUC7Q5nm7b4lm6te+EmXFFGi0UxAysSEzVrSGeiZ5TwbOqMV854Ss5kLeJWZqjW8KqXNWRyxpjXCqI9gs/7TY/S9/kl955CUAIxAKmgxNLKOzdc6C4wJhdaLtx28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bvNdCgRH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gD9ggS8OhpZf/NsZoH3fZjUIikns33eAnWwzmGyUsEI=;
	b=bvNdCgRHgeQDfPqTbXy7AOUtvm0fWfrTmB5EjOt3NmkIiJxJA40jKncg7xorr+Rj266uPC
	E0a9fSq06CDyW12F62o+QzYyGibPC/6PVULu0Q0IaiXSKNNh2HZfbDn0bENMaFACv8QVvq
	zByNYMCE1/rDAndJdHjwHuzNPpWfbOo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-ELkz5TTNOPC7Seit0yP3-A-1; Mon, 26 Aug 2024 16:44:03 -0400
X-MC-Unique: ELkz5TTNOPC7Seit0yP3-A-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7a66bf35402so589827285a.3
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705043; x=1725309843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gD9ggS8OhpZf/NsZoH3fZjUIikns33eAnWwzmGyUsEI=;
        b=E0n5urttRui6J55hTbWmU5SWe/lqSifv+7mez8xxLc+Rw0WRrY6cPzw5BijENnfTP7
         9n7Dzo1+Gk9e6crfV8DtgrWqCfmyOinteQ8j7jGnFd2EoJP/e3aIOp7SOI3WFxD+9Z4T
         7fQOLPsmhCCTTTS6mhlLMQvalIDqPkxOZ3U0ZEgcxplpS6drvaPEXonGzCnlF0Er0I/f
         NucI3Vj5E29zej0MPzSNL32+2Y08dw8/h2b+PnJDVCAmOKomRVQkmKwB37PvvwPbiykI
         PKoZidBMJLS4ka3kP22BDlO/xWsSxNSul0Skset4ugdyauQuB8BKaE7vbwqnqAL/kYkv
         9dfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUugjB1TKPmwc9g36yk1kWv6Gewh2VN+Hc3mnl5pQ2+B6qUzi+9VOLHUcM8+x6ZomM02zo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdn0QAr4x+MJq5ErEJgLfLKjiTkYSuBskpeYVp4RSveFQKWi1Y
	ZqeDyfYUK9O+7s2N0je7HNqV27Wt2KOlruFFhP0sBQxfsAaPhN/03LWpSOZSzt7EXIEF6fML/8b
	GKzprfLop/+JOr4NFsaCUy7GvIPn1eb3Nkr2BiF1/WIIuiBWKew==
X-Received: by 2002:a05:620a:24d5:b0:7a3:6dd9:ef9d with SMTP id af79cd13be357-7a6897c6e76mr1277666885a.62.1724705042591;
        Mon, 26 Aug 2024 13:44:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIqrjqvJMs9Ym5fhhSHDCZDk2wQ6104PL5R9Vk0hTAFm1CUlIqFGQmzGdyDHGQhWdDyxioXg==
X-Received: by 2002:a05:620a:24d5:b0:7a3:6dd9:ef9d with SMTP id af79cd13be357-7a6897c6e76mr1277664185a.62.1724705042003;
        Mon, 26 Aug 2024 13:44:02 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:01 -0700 (PDT)
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
Subject: [PATCH v2 03/19] mm: Mark special bits for huge pfn mappings when inject
Date: Mon, 26 Aug 2024 16:43:37 -0400
Message-ID: <20240826204353.2228736-4-peterx@redhat.com>
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

We need these special bits to be around on pfnmaps.  Mark properly for
!devmap case, reflecting that there's no page struct backing the entry.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/huge_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3f74b09ada38..dec17d09390f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1346,6 +1346,8 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
 	if (pfn_t_devmap(pfn))
 		entry = pmd_mkdevmap(entry);
+	else
+		entry = pmd_mkspecial(entry);
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
 		entry = maybe_pmd_mkwrite(entry, vma);
@@ -1442,6 +1444,8 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
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



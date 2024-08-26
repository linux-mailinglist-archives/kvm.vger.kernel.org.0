Return-Path: <kvm+bounces-25094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E74695FAE0
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BD7E287F3F
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0A31A01CE;
	Mon, 26 Aug 2024 20:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XHPLT0oc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BB71A00F1
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705068; cv=none; b=EqwdTUYsl46jjGClcv6XAjvThJ1aAP/V1perb6BMKXaAcRSGL1XddQUArH7lzqhIrCtpyRw5EjRnYeCc18bJqYrTEtIYdmVPPlZhCCP+FDjkythebpr70aN0SMQu4BRveBN62PqAMY3PskSOVHA9q6JhuqzK5Jh2d1h1vx90m+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705068; c=relaxed/simple;
	bh=RxaKGf99KcIXWtv8SyMqO8KfjLx2VTZrfelSTDMLhuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDnK9pttdOAVJk/R04FIlnAtvRO3iXpFVBN47ej8lNg42U3OeKtUUKT8ncWihNcR/pdDd4oV6umpVPU8ZrFF0bMsHpac0u68uQENeEyIvGdJVGz3oGGpUJggSLkolQkluwc4PkYpOeqAReaI5BCI3dhUhaHMqA5KaJ7UgGRGmhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XHPLT0oc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d0kI5he4gLOJUpsF87CpEeiS1FOCa69CaYI81su9df0=;
	b=XHPLT0ocyeIQ6bYspsizMfyy1L6CijBqwhoWZYQQKXNk5pXtlAAmZMWKWiCexzSL0kNvjI
	+TbjBiSfURXsDzVHKba+Jtk3fRwp2PyRZmfY4iq+qek+n77XJpc/GLCkS2p1OUneD2wf70
	i3Zj+AJdEOOwMpGLsPMKrRUv81iBb1s=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-l84EIBdLPK-WoGI5AGF9uQ-1; Mon, 26 Aug 2024 16:44:25 -0400
X-MC-Unique: l84EIBdLPK-WoGI5AGF9uQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a66c19d33fso676637985a.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705064; x=1725309864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0kI5he4gLOJUpsF87CpEeiS1FOCa69CaYI81su9df0=;
        b=frtEy8/12PTcVx8HhWPTtWol4+aPRK7wCKO22VYzcNYgMvQjq9Ih8T6CQ8PqSXN2Po
         15MOiGwIn8o5N84+tAYjiJwRRRv2uM/i8w6jzmw8gZqnf0spb04T5TIWCO0xur1USq1F
         3EOM8ZLDY+RvYnpgA2SVpZmAEtz9MR9SthoAeImQPDgIVr8qXT4JkjBhP6rbrE8jDeUQ
         0yNdgS+IV73UVqfyKW1O26bNesf/HMQqorHlP7FrtkWxeLp+D3PSOqncE8ZmehO+lYoy
         sTrFpROJ3VvVk+mXac4Knk0L7pbNQuLLebxqlTev8yS7H6Sl1BjzAhPv6V7qR9NcB0P+
         WY3g==
X-Forwarded-Encrypted: i=1; AJvYcCWlMBwwETXNWP466CqoQ8CFmYgLCFK40e3jfSdh12MwxWU/ajDGX7L6PM5tQYtxKlPSItE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx747qNVGFVKva/Q1up9Rhd9JOvkt3f6yD9D74QyYAl5nlf3s0H
	WRx9xZQU9iZPlpXCXvNo2uCC2Juh+WUWQMJfH3cmUU9y4ldZ2ScZKq3uPflBD7Vc5Oealm4xmxN
	llXdnwEfPu80mb3C14J1ZTCsrHGaBLLpuCzAqH/xwBLW3ILhKHQ==
X-Received: by 2002:a05:620a:2484:b0:79e:ff41:fd47 with SMTP id af79cd13be357-7a7e4dc9528mr93288085a.28.1724705064647;
        Mon, 26 Aug 2024 13:44:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEloa5qz2QVMofE8PCWJJ6gTfdMgC7cjn+h2anZ9qsldjcOaIzzaCXqVOAeeqkMcyU6B13FuA==
X-Received: by 2002:a05:620a:2484:b0:79e:ff41:fd47 with SMTP id af79cd13be357-7a7e4dc9528mr93286485a.28.1724705064315;
        Mon, 26 Aug 2024 13:44:24 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:23 -0700 (PDT)
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
Subject: [PATCH v2 14/19] acrn: Use the new follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:48 -0400
Message-ID: <20240826204353.2228736-15-peterx@redhat.com>
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



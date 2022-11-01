Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3207A614839
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 12:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiKALJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 07:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiKALJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 07:09:13 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C1718E23;
        Tue,  1 Nov 2022 04:09:12 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CFFAB6732D; Tue,  1 Nov 2022 12:09:08 +0100 (CET)
Date:   Tue, 1 Nov 2022 12:09:08 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH kernel v2] swiotlb: Half the size if allocation failed
Message-ID: <20221101110908.GA14146@lst.de>
References: <20221031081327.47089-1-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031081327.47089-1-aik@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks.  I've applied this with minor edits (see below).

---
From 8d58aa484920c4f9be4834a7aeb446cdced21a37 Mon Sep 17 00:00:00 2001
From: Alexey Kardashevskiy <aik@amd.com>
Date: Mon, 31 Oct 2022 19:13:27 +1100
Subject: swiotlb: reduce the swiotlb buffer size on allocation failure

At the moment the AMD encrypted platform reserves 6% of RAM for SWIOTLB
or 1GB, whichever is less. However it is possible that there is no block
big enough in the low memory which make SWIOTLB allocation fail and
the kernel continues without DMA. In such case a VM hangs on DMA.

This moves alloc+remap to a helper and calls it from a loop where
the size is halved on each iteration.

This updates default_nslabs on successful allocation which looks like
an oversight as not doing so should have broken callers of
swiotlb_size_or_default().

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/dma/swiotlb.c | 63 +++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 339a990554e7f..a34c38bbe28f1 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -300,6 +300,37 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 	return;
 }
 
+static void *swiotlb_memblock_alloc(unsigned long nslabs, unsigned int flags,
+		int (*remap)(void *tlb, unsigned long nslabs))
+{
+	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
+	void *tlb;
+
+	/*
+	 * By default allocate the bounce buffer memory from low memory, but
+	 * allow to pick a location everywhere for hypervisors with guest
+	 * memory encryption.
+	 */
+	if (flags & SWIOTLB_ANY)
+		tlb = memblock_alloc(bytes, PAGE_SIZE);
+	else
+		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
+
+	if (!tlb) {
+		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
+			__func__, bytes);
+		return NULL;
+	}
+
+	if (remap && remap(tlb, nslabs) < 0) {
+		memblock_free(tlb, PAGE_ALIGN(bytes));
+		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
+		return NULL;
+	}
+
+	return tlb;
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -310,7 +341,6 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 	struct io_tlb_mem *mem = &io_tlb_default_mem;
 	unsigned long nslabs;
 	size_t alloc_size;
-	size_t bytes;
 	void *tlb;
 
 	if (!addressing_limit && !swiotlb_force_bounce)
@@ -326,31 +356,16 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 	nslabs = default_nslabs;
-	/*
-	 * By default allocate the bounce buffer memory from low memory, but
-	 * allow to pick a location everywhere for hypervisors with guest
-	 * memory encryption.
-	 */
-retry:
-	bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
-	if (flags & SWIOTLB_ANY)
-		tlb = memblock_alloc(bytes, PAGE_SIZE);
-	else
-		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
-	if (!tlb) {
-		pr_warn("%s: failed to allocate tlb structure\n", __func__);
-		return;
-	}
-
-	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
-
+	while ((tlb = swiotlb_memblock_alloc(nslabs, flags, remap)) == NULL) {
+		if (nslabs <= IO_TLB_MIN_SLABS)
+			return;
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
-		if (nslabs >= IO_TLB_MIN_SLABS)
-			goto retry;
+	}
 
-		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
-		return;
+	if (default_nslabs != nslabs) {
+		pr_info("SWIOTLB bounce buffer size adjusted %lu -> %lu slabs",
+			default_nslabs, nslabs);
+		default_nslabs = nslabs;
 	}
 
 	alloc_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), nslabs));
-- 
2.30.2


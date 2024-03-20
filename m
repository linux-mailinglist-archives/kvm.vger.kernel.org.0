Return-Path: <kvm+bounces-12261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F52880DFA
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 516C51F27187
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FAC439FEB;
	Wed, 20 Mar 2024 08:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/LiyTzX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF7838DED;
	Wed, 20 Mar 2024 08:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924941; cv=none; b=UHdM1Hg8r1muRhWJkYOF3F2Dex7naIiCUMny0+Nu8k4vZ+gbYU6DEHZUQ4ra8hx8y5mk8O0pDC3gUJTsbj+NtZMeIoB9DvWxqkWc7QZQ6iI51NTfy0NHJwQ6EnTLmpxnPLC8jfK5l4h8MQxPd4P1dVlXBekNSasw6jONQ1D7gkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924941; c=relaxed/simple;
	bh=gdJJxHO47QTHX7IJIQn/yNoS/qXqccMa+6/0bsPpjEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYL9g3lml6ieP4sXRl2bvE2Za2nD+nGZDMxw5YERMPe9wGS+63JyLTVqK1R9wfq4DMIbLxdZ/MzYetllVDTFe/nRcDNc4s+BNj+HFsyZcW7fvkqlsl7i1/Y1Uzj9nj64r7HfRZmCMjKdsMgynY7dQsXxUVRSnXrG29huU0w3wBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/LiyTzX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66867C433C7;
	Wed, 20 Mar 2024 08:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710924941;
	bh=gdJJxHO47QTHX7IJIQn/yNoS/qXqccMa+6/0bsPpjEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k/LiyTzXOZm/bpwg/R7K7z83777XKyGQEoOkmI0+JirTc+A3Irgqqlo/MTqIaHAuT
	 LaDz5/N89UQYLdibXxPlCFj22TikvtLMQmCsrzfiu9c8ExWvxD7lgnlxbCUAnPTxSu
	 ovGWRjpBoZtNhTrQF2nDJYdWAWTZvyEET/dz7cc/V7Of5+KdYPv3eTw24b9yYI6Vth
	 LvOmZtFkDBkj+IBOqsu96vPj5qqCbR/FSCbJ8WT6U9SUo/vlTPTqZ2qWSWdndiAJJg
	 HA55nQnMV03il6CwCvqo9aY5LSDVcJcESBRt/qQPtJTao2MeNigIFRqvGlKDldCtwy
	 dX0egkjrYM2eg==
Date: Wed, 20 Mar 2024 10:55:36 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Message-ID: <20240320085536.GA14887@unreal>
References: <20240306162022.GB28427@lst.de>
 <20240306174456.GO9225@ziepe.ca>
 <20240306221400.GA8663@lst.de>
 <20240307000036.GP9225@ziepe.ca>
 <20240307150505.GA28978@lst.de>
 <20240307210116.GQ9225@ziepe.ca>
 <20240308164920.GA17991@lst.de>
 <20240308202342.GZ9225@ziepe.ca>
 <20240309161418.GA27113@lst.de>
 <20240319153620.GB66976@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319153620.GB66976@ziepe.ca>

On Tue, Mar 19, 2024 at 12:36:20PM -0300, Jason Gunthorpe wrote:
> On Sat, Mar 09, 2024 at 05:14:18PM +0100, Christoph Hellwig wrote:
> > On Fri, Mar 08, 2024 at 04:23:42PM -0400, Jason Gunthorpe wrote:
> > > > The DMA API callers really need to know what is P2P or not for
> > > > various reasons.  And they should generally have that information
> > > > available, either from pin_user_pages that needs to special case
> > > > it or from the in-kernel I/O submitter that build it from P2P and
> > > > normal memory.
> > > 
> > > I think that is a BIO thing. RDMA just calls with FOLL_PCI_P2PDMA and
> > > shoves the resulting page list into in a scattertable. It never checks
> > > if any returned page is P2P - it has no reason to care. dma_map_sg()
> > > does all the work.
> > 
> > Right now it does, but that's not really a good interface.  If we have
> > a pin_user_pages variant that only pins until the next relevant P2P
> > boundary and tells you about we can significantly simplify the overall
> > interface.
> 
> Sorry for the delay, I was away..

<...>

> Can we tweak what Leon has done to keep the hmm_range_fault support
> and non-uniformity for RDMA but add a uniformity optimized flow for
> BIO?

Something like this will do the trick.

From 45e739e7073fb04bc168624f77320130bb3f9267 Mon Sep 17 00:00:00 2001
Message-ID: <45e739e7073fb04bc168624f77320130bb3f9267.1710924764.git.leonro@nvidia.com>
From: Leon Romanovsky <leonro@nvidia.com>
Date: Mon, 18 Mar 2024 11:16:41 +0200
Subject: [PATCH] mm/gup: add strict interface to pin user pages according to
 FOLL flag

All pin_user_pages*() and get_user_pages*() callbacks allocate user
pages by partially taking into account their p2p vs. non-p2p properties.

In case, user sets FOLL_PCI_P2PDMA flag, the allocated pages will include
both p2p and "regular" pages, while if FOLL_PCI_P2PDMA flag is not provided,
only regular pages are returned.

In order to make sure that with FOLL_PCI_P2PDMA flag, only p2p pages are
returned, let's introduce new internal FOLL_STRICT flag and provide special
pin_user_pages_fast_strict() API call.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mm.h |  3 +++
 mm/gup.c           | 36 +++++++++++++++++++++++++++++++++++-
 mm/internal.h      |  4 +++-
 3 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f5a97dec5169..910b65dde24a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2491,6 +2491,9 @@ int pin_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages);
 void folio_add_pin(struct folio *folio);
 
+int pin_user_pages_fast_strict(unsigned long start, int nr_pages,
+			       unsigned int gup_flags, struct page **pages);
+
 int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
 			struct task_struct *task, bool bypass_rlim);
diff --git a/mm/gup.c b/mm/gup.c
index df83182ec72d..11b5c626a4ab 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -133,6 +133,10 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
 	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
 		return NULL;
 
+	if (flags & FOLL_STRICT)
+		if (flags & FOLL_PCI_P2PDMA && !is_pci_p2pdma_page(page))
+			return NULL;
+
 	if (flags & FOLL_GET)
 		return try_get_folio(page, refs);
 
@@ -232,6 +236,10 @@ int __must_check try_grab_page(struct page *page, unsigned int flags)
 	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
 		return -EREMOTEIO;
 
+	if (flags & FOLL_STRICT)
+		if (flags & FOLL_PCI_P2PDMA && !is_pci_p2pdma_page(page))
+			return -EREMOTEIO;
+
 	if (flags & FOLL_GET)
 		folio_ref_inc(folio);
 	else if (flags & FOLL_PIN) {
@@ -2243,6 +2251,8 @@ static bool is_valid_gup_args(struct page **pages, int *locked,
 	 * - FOLL_TOUCH/FOLL_PIN/FOLL_TRIED/FOLL_FAST_ONLY are internal only
 	 * - FOLL_REMOTE is internal only and used on follow_page()
 	 * - FOLL_UNLOCKABLE is internal only and used if locked is !NULL
+	 * - FOLL_STRICT is internal only and used to distinguish between p2p
+	 *   and "regular" pages.
 	 */
 	if (WARN_ON_ONCE(gup_flags & INTERNAL_GUP_FLAGS))
 		return false;
@@ -3187,7 +3197,8 @@ static int internal_get_user_pages_fast(unsigned long start,
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
 				       FOLL_FORCE | FOLL_PIN | FOLL_GET |
 				       FOLL_FAST_ONLY | FOLL_NOFAULT |
-				       FOLL_PCI_P2PDMA | FOLL_HONOR_NUMA_FAULT)))
+				       FOLL_PCI_P2PDMA | FOLL_HONOR_NUMA_FAULT |
+				       FOLL_STRICT)))
 		return -EINVAL;
 
 	if (gup_flags & FOLL_PIN)
@@ -3322,6 +3333,29 @@ int pin_user_pages_fast(unsigned long start, int nr_pages,
 }
 EXPORT_SYMBOL_GPL(pin_user_pages_fast);
 
+/**
+ * pin_user_pages_fast_strict() - this is pin_user_pages_fast() variant, which
+ * makes sure that only pages with same properties are pinned.
+ *
+ * @start:      starting user address
+ * @nr_pages:   number of pages from start to pin
+ * @gup_flags:  flags modifying pin behaviour
+ * @pages:      array that receives pointers to the pages pinned.
+ *              Should be at least nr_pages long.
+ *
+ * Nearly the same as pin_user_pages_fastt(), except that FOLL_STRICT is set.
+ *
+ * FOLL_STRICT means that the pages are allocated with specific FOLL_* properties.
+ */
+int pin_user_pages_fast_strict(unsigned long start, int nr_pages,
+			       unsigned int gup_flags, struct page **pages)
+{
+	if (!is_valid_gup_args(pages, NULL, &gup_flags, FOLL_PIN | FOLL_STRICT))
+		return -EINVAL;
+	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
+}
+EXPORT_SYMBOL_GPL(pin_user_pages_fast_strict);
+
 /**
  * pin_user_pages_remote() - pin pages of a remote process
  *
diff --git a/mm/internal.h b/mm/internal.h
index f309a010d50f..7578837a0444 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1031,10 +1031,12 @@ enum {
 	FOLL_FAST_ONLY = 1 << 20,
 	/* allow unlocking the mmap lock */
 	FOLL_UNLOCKABLE = 1 << 21,
+	/* don't mix pages with different properties, e.g. p2p with "regular" ones */
+	FOLL_STRICT = 1 << 22,
 };
 
 #define INTERNAL_GUP_FLAGS (FOLL_TOUCH | FOLL_TRIED | FOLL_REMOTE | FOLL_PIN | \
-			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE)
+			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE | FOLL_STRICT)
 
 /*
  * Indicates for which pages that are write-protected in the page table,
-- 
2.44.0


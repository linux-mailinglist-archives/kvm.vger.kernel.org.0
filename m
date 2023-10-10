Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5963F7BF715
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 11:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjJJJSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 05:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjJJJSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 05:18:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D491A7;
        Tue, 10 Oct 2023 02:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696929515; x=1728465515;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nhMjTskI0kdje3r63TqyWep3YjWnF2MvMNQ53LvDfCs=;
  b=UN+jLhqfsSbaBaPO9pDGfUUVfbmdIYGRn5IqelQmiBlj8sMfNnv2RX7A
   7DQ5i+buRfPE5lYFJ6pPrSs7ADpYJgTGaqyRlbT9kJmgqmOl9cN4VOQs7
   pkCS7fhESPkkF359bWE1jYgnGOhZjEHX/ErC/Wub1u/39QI6SZNvSv884
   oTOF1CukH2jW5ItoBpRvD+kI6GD4DkYwhqU4LrZ8IBq2BX2SgQvxOfdIe
   4OtT4DgbcqD6NrIWdfkeuB5qlCqQaLXUU87EYTemH9QyxwSO9xsN/lcfm
   NeBkspYuVPmdZc/sOvt3YFqH+B0DFzplD06LqQCTzmtZ9FS6+Q7I+d7VK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="364643123"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="364643123"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 02:18:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="844048252"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="844048252"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Oct 2023 02:18:30 -0700
Date:   Tue, 10 Oct 2023 17:17:36 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6/8] KVM: gmem, x86: Add gmem hook for invalidating
 private memory
Message-ID: <ZSUWsK8dGPjlrCR1@yilunxu-OptiPlex-7050>
References: <cover.1692119201.git.isaku.yamahata@intel.com>
 <8c9f0470ba6e5dc122f3f4e37c4dcfb6fb97b184.1692119201.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c9f0470ba6e5dc122f3f4e37c4dcfb6fb97b184.1692119201.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-08-15 at 10:18:53 -0700, isaku.yamahata@intel.com wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> TODO: add a CONFIG option that can be to completely skip arch
> invalidation loop and avoid __weak references for arch/platforms that
> don't need an additional invalidation hook.
> 
> In some cases, like with SEV-SNP, guest memory needs to be updated in a
> platform-specific manner before it can be safely freed back to the host.
> Add hooks to wire up handling of this sort when freeing memory in
> response to FALLOC_FL_PUNCH_HOLE operations.
> 
> Also issue invalidations of all allocated pages when releasing the gmem
> file so that the pages are not left in an unusable state when they get
> freed back to the host.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Link: https://lore.kernel.org/r/20230612042559.375660-3-michael.roth@amd.com
>

[...]
 
> +/* Handle arch-specific hooks needed before releasing guarded pages. */
> +static void kvm_gmem_issue_arch_invalidate(struct kvm *kvm, struct file *file,
> +					   pgoff_t start, pgoff_t end)
> +{
> +	pgoff_t file_end = i_size_read(file_inode(file)) >> PAGE_SHIFT;
> +	pgoff_t index = start;
> +
> +	end = min(end, file_end);
> +
> +	while (index < end) {
> +		struct folio *folio;
> +		unsigned int order;
> +		struct page *page;
> +		kvm_pfn_t pfn;
> +
> +		folio = __filemap_get_folio(file->f_mapping, index,
> +					    FGP_LOCK, 0);
> +		if (!folio) {
> +			index++;
> +			continue;
> +		}
> +
> +		page = folio_file_page(folio, index);
> +		pfn = page_to_pfn(page);
> +		order = folio_order(folio);
> +
> +		kvm_arch_gmem_invalidate(kvm, pfn, pfn + min((1ul << order), end - index));

Observed an issue there.

The valid page may not point to the first page in the folio, then the
range [pfn, pfn + (1ul << order)) expands to the next folio. This makes
a part of the pages be invalidated again when loop to the next folio.

On TDX, it causes TDH_PHYMEM_PAGE_WBINVD failed.

> +
> +		index = folio_next_index(folio);
> +		folio_unlock(folio);
> +		folio_put(folio);
> +
> +		cond_resched();
> +	}
> +}

My fix would be:

diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index e629782d73d5..3665003c3746 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -155,7 +155,7 @@ static void kvm_gmem_issue_arch_invalidate(struct kvm *kvm, struct inode *inode,

        while (index < end) {
                struct folio *folio;
-               unsigned int order;
+               pgoff_t ntails;
                struct page *page;
                kvm_pfn_t pfn;

@@ -168,9 +168,9 @@ static void kvm_gmem_issue_arch_invalidate(struct kvm *kvm, struct inode *inode,

                page = folio_file_page(folio, index);
                pfn = page_to_pfn(page);
-               order = folio_order(folio);
+               ntails = folio_nr_pages(folio) - folio_page_idx(folio, page);

-               kvm_arch_gmem_invalidate(kvm, pfn, pfn + min((1ul << order), end - index));
+               kvm_arch_gmem_invalidate(kvm, pfn, pfn + min(ntails, end - index));

                index = folio_next_index(folio);
                folio_unlock(folio);

Thanks,
Yilun

Return-Path: <kvm+bounces-24491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDF0F9567DA
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 12:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F06AE1C219CD
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 10:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFB615EFBF;
	Mon, 19 Aug 2024 10:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t4sKtkWJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040CE15ECF8;
	Mon, 19 Aug 2024 10:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724062208; cv=none; b=OhoIOZtHIGAdCG75QN+BBS2KylT+gIF+IuVKWFRo82yXfYd2mX9fMdpCDaXWrgmnKe2cbCp/DeZiDPnhGPmZZtgxOd+YbRvpjJsNXgDDdYZwG/omIIqZFu/smpKc2iKQRLdNRhs67hPOyovu8Jvvj+YQuE/SrgqpKVYqlH76sz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724062208; c=relaxed/simple;
	bh=MqrpAk0V4swle/LX6Ozj2eaNefXVewFamWFL4cNI//U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ka1fO9xq9DUyrk8mpT2ta6VG/598Ur4avKFJs+/wP2cxI3KhH1eInT1ZOUZ5RMN1uhtxvRYEk9OEUhw/eAbyaGCV0RoYxacsCuggBXfXpbfUgQ9LYSjWFIC6idXRw8NUyIk4VbMnQ2UR+1KUcqHR0nEkaLIoy83wKM4d3qKvPQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t4sKtkWJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DADC4AF0C;
	Mon, 19 Aug 2024 10:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724062207;
	bh=MqrpAk0V4swle/LX6Ozj2eaNefXVewFamWFL4cNI//U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t4sKtkWJVVCgI2rS4IoPvGbNm65zpijEGUb87xPR92lTxJWadFrmYGp17FlT5BmMw
	 Raoy/HAEGKk6MiWKgewOFVKgiJ2Cks7Lbo4X3E6B75qiQamcZFSjPoplIQUM3UnUkp
	 H1Ws0m0vTihHLcXVVp81Y9rj+9UfHfnxT50hqT318+xGVFZ9VlfVqT0uh6uN41KJ7y
	 oMjgxN2lcg1W3WjJkP6R1gvbtB4nOvxO7hg10DYA4/00n/I8q8wKtdd/Du9hjO7/Ma
	 Px3EMt9mQEHUvD19cbuoHmbg2nwnntQpkhG88CuF/Z1kGVqVLcdkuirtDdavsBQItj
	 LvZ3bGVz3R7KQ==
Date: Mon, 19 Aug 2024 13:09:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Elliot Berman <quic_eberman@quicinc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Fuad Tabba <tabba@google.com>, David Hildenbrand <david@redhat.com>,
	Patrick Roy <roypat@amazon.co.uk>, qperret@google.com,
	Ackerley Tng <ackerleytng@google.com>, linux-coco@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] mm: guest_memfd: Add option to remove guest
 private memory from direct map
Message-ID: <ZsMZ8C2lnpMW+BT5@kernel.org>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>

On Mon, Aug 05, 2024 at 11:34:49AM -0700, Elliot Berman wrote:
> This patch was reworked from Patrick's patch:
> https://lore.kernel.org/all/20240709132041.3625501-6-roypat@amazon.co.uk/
> 
> While guest_memfd is not available to be mapped by userspace, it is
> still accessible through the kernel's direct map. This means that in
> scenarios where guest-private memory is not hardware protected, it can
> be speculatively read and its contents potentially leaked through
> hardware side-channels. Removing guest-private memory from the direct
> map, thus mitigates a large class of speculative execution issues
> [1, Table 1].
> 
> Direct map removal do not reuse the `.prepare` machinery, since
> `prepare` can be called multiple time, and it is the responsibility of
> the preparation routine to not "prepare" the same folio twice [2]. Thus,
> instead explicitly check if `filemap_grab_folio` allocated a new folio,
> and remove the returned folio from the direct map only if this was the
> case.
> 
> The patch uses release_folio instead of free_folio to reinsert pages
> back into the direct map as by the time free_folio is called,
> folio->mapping can already be NULL. This means that a call to
> folio_inode inside free_folio might deference a NULL pointer, leaving no
> way to access the inode which stores the flags that allow determining
> whether the page was removed from the direct map in the first place.
> 
> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
> 
> Cc: Patrick Roy <roypat@amazon.co.uk>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
>  include/linux/guest_memfd.h |  8 ++++++
>  mm/guest_memfd.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 72 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> index be56d9d53067..f9e4a27aed67 100644
> --- a/include/linux/guest_memfd.h
> +++ b/include/linux/guest_memfd.h
> @@ -25,6 +25,14 @@ struct guest_memfd_operations {
>  	int (*release)(struct inode *inode);
>  };
>  
> +/**
> + * @GUEST_MEMFD_FLAG_NO_DIRECT_MAP: When making folios inaccessible by host, also
> + *                                  remove them from the kernel's direct map.
> + */
> +enum {

please name this enum, otherwise kernel-doc wont' be happy

> +	GUEST_MEMFD_FLAG_NO_DIRECT_MAP		= BIT(0),
> +};
> +
>  /**
>   * @GUEST_MEMFD_GRAB_UPTODATE: Ensure pages are zeroed/up to date.
>   *                             If trusted hyp will do it, can ommit this flag
> diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
> index 580138b0f9d4..e9d8cab72b28 100644
> --- a/mm/guest_memfd.c
> +++ b/mm/guest_memfd.c
> @@ -7,9 +7,55 @@
>  #include <linux/falloc.h>
>  #include <linux/guest_memfd.h>
>  #include <linux/pagemap.h>
> +#include <linux/set_memory.h>
> +
> +static inline int guest_memfd_folio_private(struct folio *folio)
> +{
> +	unsigned long nr_pages = folio_nr_pages(folio);
> +	unsigned long i;
> +	int r;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		struct page *page = folio_page(folio, i);
> +
> +		r = set_direct_map_invalid_noflush(page);
> +		if (r < 0)
> +			goto out_remap;
> +	}
> +
> +	folio_set_private(folio);
> +	return 0;
> +out_remap:
> +	for (; i > 0; i--) {
> +		struct page *page = folio_page(folio, i - 1);
> +
> +		BUG_ON(set_direct_map_default_noflush(page));
> +	}
> +	return r;
> +}
> +
> +static inline void guest_memfd_folio_clear_private(struct folio *folio)
> +{
> +	unsigned long start = (unsigned long)folio_address(folio);
> +	unsigned long nr = folio_nr_pages(folio);
> +	unsigned long i;
> +
> +	if (!folio_test_private(folio))
> +		return;
> +
> +	for (i = 0; i < nr; i++) {
> +		struct page *page = folio_page(folio, i);
> +
> +		BUG_ON(set_direct_map_default_noflush(page));
> +	}
> +	flush_tlb_kernel_range(start, start + folio_size(folio));

I think that TLB flush should come after removing pages from the direct map
rather than after adding them back.

> +
> +	folio_clear_private(folio);
> +}
>  
>  struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
>  {
> +	unsigned long gmem_flags = (unsigned long)file->private_data;
>  	struct inode *inode = file_inode(file);
>  	struct guest_memfd_operations *ops = inode->i_private;
>  	struct folio *folio;

-- 
Sincerely yours,
Mike.


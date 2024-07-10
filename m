Return-Path: <kvm+bounces-21274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FDE492CBF7
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93CFC1C224FA
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 07:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BF284A3E;
	Wed, 10 Jul 2024 07:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRVvovir"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFA183A19;
	Wed, 10 Jul 2024 07:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720596861; cv=none; b=L02f1Sm7lcIq7D9MW4q30dkBSASvQ9PUu27oq8dO8HyCcjHD+k8TRtdSTfaefNNHrfVU3W8Yn8iJfWKyOAKQ9XShm4gqBfbWyKct5/Yb2Xed3XtPBjxdRF3Wo/TW2917n7M8b3B5OO8y8+30rKcT4z4j+aRYtCN6aAQVwOQtk0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720596861; c=relaxed/simple;
	bh=dvoKNXwrD28MkkI8y466iNL0VlvuCYSk/fPFFvZKz3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgofaytIANv1dpFUhg9C2F0muyg/DoeLlHQpS2sfeM8j3VzWOLz8X5Y7Oem96EYL05BNJjyCGN90k6cUmOPBrRghgW4WE6O4k9w3OlTdwXPcocSVgRxHvl2ezKkO0aFy07Xu89Nxqvx9lYwhGSYldVPqSGu1kkw5m4ibvFYM/gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRVvovir; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F9CC32782;
	Wed, 10 Jul 2024 07:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720596861;
	bh=dvoKNXwrD28MkkI8y466iNL0VlvuCYSk/fPFFvZKz3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LRVvovireNfQcRKQxb/uK2FuFMyJjw3TkEkJ22O/546QnRRV2zF7JWMfct3nzE+pd
	 iu4WoPH27IVKO9aIdF5W6mx5AJgNXnQlImXYZ2/2vRBRfs4R71WfQU2nzevFuhPqnF
	 TKKqwdfacz/bphBPOxDi0xD/k65vyQB0f+56uxW7A98Sq9jbnHoo6YuLaNO73gcuSH
	 cbsB4K96xVc+RBmY0Qjj4u//FkFW1Z6G9r0XLNEMXUUOAvfE13MLwkgQW5HMcJq7S7
	 3jJDBzQoeHsLcy2+VZ/lfvQA6qTD4yc6Cx9Fi3rjJMFD58cOk7fuwpyVec1qQT8rQp
	 3/UutjGYb5zSg==
Date: Wed, 10 Jul 2024 10:31:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Patrick Roy <roypat@amazon.co.uk>
Cc: seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org,
	dwmw@amazon.co.uk, david@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, willy@infradead.org, graf@amazon.com,
	derekmn@amazon.com, kalyazin@amazon.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	dmatlack@google.com, tabba@google.com, chao.p.peng@linux.intel.com,
	xmarcalx@amazon.co.uk
Subject: Re: [RFC PATCH 5/8] kvm: gmem: add option to remove guest private
 memory from direct map
Message-ID: <Zo441yz7Yw2JZcPs@kernel.org>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-6-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709132041.3625501-6-roypat@amazon.co.uk>

On Tue, Jul 09, 2024 at 02:20:33PM +0100, Patrick Roy wrote:
> While guest_memfd is not available to be mapped by userspace, it is
> still accessible through the kernel's direct map. This means that in
> scenarios where guest-private memory is not hardware protected, it can
> be speculatively read and its contents potentially leaked through
> hardware side-channels. Removing guest-private memory from the direct
> map, thus mitigates a large class of speculative execution issues
> [1, Table 1].
> 
> This patch adds a flag to the `KVM_CREATE_GUEST_MEMFD` which, if set, removes the
> struct pages backing guest-private memory from the direct map. Should
> `CONFIG_HAVE_KVM_GMEM_{INVALIDATE, PREPARE}` be set, pages are removed
> after preparation and before invalidation, so that the
> prepare/invalidate routines do not have to worry about potentially
> absent direct map entries.
> 
> Direct map removal do not reuse the `KVM_GMEM_PREPARE` machinery, since `prepare` can be
> called multiple time, and it is the responsibility of the preparation
> routine to not "prepare" the same folio twice [2]. Thus, instead
> explicitly check if `filemap_grab_folio` allocated a new folio, and
> remove the returned folio from the direct map only if this was the case.
> 
> The patch uses release_folio instead of free_folio to reinsert pages
> back into the direct map as by the time free_folio is called,
> folio->mapping can already be NULL. This means that a call to
> folio_inode inside free_folio might deference a NULL pointer, leaving no
> way to access the inode which stores the flags that allow determining
> whether the page was removed from the direct map in the first place.
> 
> Lastly, the patch uses set_direct_map_{invalid,default}_noflush instead
> of `set_memory_[n]p` to avoid expensive flushes of TLBs and the L*-cache
> hierarchy. This is especially important once KVM restores direct map
> entries on-demand in later patches, where simple FIO benchmarks of a
> virtio-blk device have shown that TLB flushes on a Intel(R) Xeon(R)
> Platinum 8375C CPU @ 2.90GHz resulted in 80% degradation in throughput
> compared to a non-flushing solution.
> 
> Not flushing the TLB means that until TLB entries for temporarily
> restored direct map entries get naturally evicted, they can be used
> during speculative execution, and effectively "unhide" the memory for
> longer than intended. We consider this acceptable, as the only pages
> that are temporarily reinserted into the direct map like this will
> either hold PV data structures (kvm-clock, asyncpf, etc), or pages
> containing privileged instructions inside the guest kernel image (in the
> MMIO emulation case).
> 
> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
> 
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  include/uapi/linux/kvm.h |  2 ++
>  virt/kvm/guest_memfd.c   | 52 ++++++++++++++++++++++++++++++++++------
>  2 files changed, 47 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index e065d9fe7ab2..409116aa23c9 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1563,4 +1563,6 @@ struct kvm_create_guest_memfd {
>  	__u64 reserved[6];
>  };
>  
> +#define KVM_GMEM_NO_DIRECT_MAP                 (1ULL << 0)
> +
>  #endif /* __LINUX_KVM_H */
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9148b9679bb1..dc9b0c2d0b0e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/pagemap.h>
>  #include <linux/anon_inodes.h>
> +#include <linux/set_memory.h>
>  
>  #include "kvm_mm.h"
>  
> @@ -49,9 +50,16 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
>  	return 0;
>  }
>  
> +static bool kvm_gmem_not_present(struct inode *inode)
> +{
> +	return ((unsigned long)inode->i_private & KVM_GMEM_NO_DIRECT_MAP) != 0;
> +}
> +
>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
>  {
>  	struct folio *folio;
> +	bool zap_direct_map = false;
> +	int r;
>  
>  	/* TODO: Support huge pages. */
>  	folio = filemap_grab_folio(inode->i_mapping, index);
> @@ -74,16 +82,30 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
>  		for (i = 0; i < nr_pages; i++)
>  			clear_highpage(folio_page(folio, i));
>  
> +		// We need to clear the folio before calling kvm_gmem_prepare_folio,
> +		// but can only remove it from the direct map _after_ preparation is done.

No C++ comments please

> +		zap_direct_map = kvm_gmem_not_present(inode);
> +
>  		folio_mark_uptodate(folio);
>  	}
>  
>  	if (prepare) {
> -		int r =	kvm_gmem_prepare_folio(inode, index, folio);
> -		if (r < 0) {
> -			folio_unlock(folio);
> -			folio_put(folio);
> -			return ERR_PTR(r);
> -		}
> +		r = kvm_gmem_prepare_folio(inode, index, folio);
> +		if (r < 0)
> +			goto out_err;
> +	}
> +
> +	if (zap_direct_map) {
> +		r = set_direct_map_invalid_noflush(&folio->page);

It's not future proof to presume that folio is a single page here.
You should loop over folio pages and add a TLB flush after the loop.

> +		if (r < 0)
> +			goto out_err;
> +
> +		// We use the private flag to track whether the folio has been removed
> +		// from the direct map. This is because inside of ->free_folio,
> +		// we do not have access to the address_space anymore, meaning we
> +		// cannot check folio_inode(folio)->i_private to determine whether
> +		// KVM_GMEM_NO_DIRECT_MAP was set.
> +		folio_set_private(folio);
>  	}
>  
>  	/*
> @@ -91,6 +113,10 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
>  	 * unevictable and there is no storage to write back to.
>  	 */
>  	return folio;
> +out_err:
> +	folio_unlock(folio);
> +	folio_put(folio);
> +	return ERR_PTR(r);
>  }
>  
>  static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
> @@ -354,10 +380,22 @@ static void kvm_gmem_free_folio(struct folio *folio)
>  }
>  #endif
>  
> +static void kvm_gmem_invalidate_folio(struct folio *folio, size_t start, size_t end)
> +{
> +	if (start == 0 && end == PAGE_SIZE) {
> +		// We only get here if PG_private is set, which only happens if kvm_gmem_not_present
> +		// returned true in kvm_gmem_get_folio. Thus no need to do that check again.
> +		BUG_ON(set_direct_map_default_noflush(&folio->page));

Ditto.

> +
> +		folio_clear_private(folio);
> +	}
> +}
> +
>  static const struct address_space_operations kvm_gmem_aops = {
>  	.dirty_folio = noop_dirty_folio,
>  	.migrate_folio	= kvm_gmem_migrate_folio,
>  	.error_remove_folio = kvm_gmem_error_folio,
> +	.invalidate_folio = kvm_gmem_invalidate_folio,
>  #ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
>  	.free_folio = kvm_gmem_free_folio,
>  #endif
> @@ -443,7 +481,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  {
>  	loff_t size = args->size;
>  	u64 flags = args->flags;
> -	u64 valid_flags = 0;
> +	u64 valid_flags = KVM_GMEM_NO_DIRECT_MAP;
>  
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
> -- 
> 2.45.2
> 

-- 
Sincerely yours,
Mike.


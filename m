Return-Path: <kvm+bounces-27062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A81397B78A
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 07:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AF3F2871AE
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 05:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49F1156225;
	Wed, 18 Sep 2024 05:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmvMj4Vn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7CD136327;
	Wed, 18 Sep 2024 05:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726638719; cv=none; b=WkOpL7M19c6tnVJvyD/hPYLoYf+e2eTyDQq26EeHchjFER8/YwIDITdu5x33Ezfsuzh+mDnMw738dN1e3x62lFroVRu81Y/vTDtzMHDX6W+/pG/aUZC+y9TV4kSnRCYiADovgErzbbNTprK/k5D9pUzI+glMiATv+eLYzUCAQp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726638719; c=relaxed/simple;
	bh=k4p5yAWG1/S7eqbUX0zVSAQcPzHPeBPvL5Uur8qzQXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ob6ruO1uFjhSGql55rh/a/83K371O6FMUIAR+Hgy+MATdYYA5rLxzV9QJDoSqciQklRIdqbGgAT+8V3j5vNF2dUdjtz3FrVs0oRZJUEXgRoKbgPNccYNLi+laiEphYqFhG73TLPyxDn8VyfQv8TOJeX2eTC7IA+5p2lC+SAZ4sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmvMj4Vn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CC3C4CEC3;
	Wed, 18 Sep 2024 05:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726638718;
	bh=k4p5yAWG1/S7eqbUX0zVSAQcPzHPeBPvL5Uur8qzQXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NmvMj4Vno/SD/Lxb/VrmunICZNou7xy3jI904aeaU+2RWv/oQAeHzrsUZhlAxnK38
	 m19Py8rK9HSNtGAlkBKUrp/a5Tw7uyWu+tm2REdoni3IJUK7mstBogdzIOvNyOjAit
	 ktuxvgC08XvjkcFIvy2iSLfzpfXlvZgasnTM18u0nLEzRP0Hd+O/rXbi0y3yhi8GGE
	 ilhr1D8N3E+N/1LgwTLzW3gydvbcEd8tFK1r22AcTJZrYpjMQvDZUwLwMjV869m1ec
	 AJnoOd/Lw+PV2i91v52ltZz0oRyFvpoMsqH5EAh3Cy//GmUX5EKhIJc9a40Q0beMUI
	 6HNAh4UYf6b7Q==
Date: Wed, 18 Sep 2024 07:48:54 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Patrick Roy <roypat@amazon.co.uk>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rostedt@goodmis.org,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, quic_eberman@quicinc.com,
	dwmw@amazon.com, david@redhat.com, tabba@google.com,
	linux-mm@kvack.org, dmatlack@google.com, graf@amazon.com,
	jgowans@amazon.com, derekmn@amazon.com, kalyazin@amazon.com,
	xmarcalx@amazon.com
Subject: Re: [RFC PATCH v2 01/10] kvm: gmem: Add option to remove gmem from
 direct map
Message-ID: <Zuppxn_uW5JhDBjR@kernel.org>
References: <20240910163038.1298452-1-roypat@amazon.co.uk>
 <20240910163038.1298452-2-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910163038.1298452-2-roypat@amazon.co.uk>

On Tue, Sep 10, 2024 at 05:30:27PM +0100, Patrick Roy wrote:
> Add a flag to the KVM_CREATE_GUEST_MEMFD ioctl that causes gmem pfns
> to be removed from the host kernel's direct map. Memory is removed
> immediately after allocation and preparation of gmem folios (after
> preparation, as the prepare callback might expect the direct map entry
> to be present). Direct map entries are restored before
> kvm_arch_gmem_invalidate is called (as ->invalidate_folio is called
> before ->free_folio), for the same reason.
> 
> Use the PG_private flag to indicate that a folio is part of gmem with
> direct map removal enabled. While in this patch, PG_private does have a
> meaning of "folio not in direct map", this will no longer be true in
> follow up patches. Gmem folios might get temporarily reinserted into the
> direct map, but the PG_private flag needs to remain set, as the folios
> will have private data that needs to be freed independently of direct
> map status. This is why kvm_gmem_folio_clear_private does not call
> folio_clear_private.
> 
> kvm_gmem_{set,clear}_folio_private must be called with the folio lock
> held.
> 
> To ensure that failures in kvm_gmem_{clear,set}_private do not cause
> system instability due to leaving holes in the direct map, try to always
> restore direct map entries on failure. Pages for which restoration of
> direct map entries fails are marked as HWPOISON, to prevent the
> kernel from ever touching them again.
> 
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  include/uapi/linux/kvm.h |  2 +
>  virt/kvm/guest_memfd.c   | 96 +++++++++++++++++++++++++++++++++++++---
>  2 files changed, 91 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 637efc0551453..81b0f4a236b8c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1564,6 +1564,8 @@ struct kvm_create_guest_memfd {
>  	__u64 reserved[6];
>  };
>  
> +#define KVM_GMEM_NO_DIRECT_MAP			(1ULL << 0)
> +
>  #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
>  
>  struct kvm_pre_fault_memory {
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 1c509c3512614..2ed27992206f3 100644
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
> @@ -49,8 +50,69 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
>  	return 0;
>  }
>  
> +static bool kvm_gmem_test_no_direct_map(struct inode *inode)
> +{
> +	return ((unsigned long)inode->i_private & KVM_GMEM_NO_DIRECT_MAP) == KVM_GMEM_NO_DIRECT_MAP;
> +}
> +
> +static int kvm_gmem_folio_set_private(struct folio *folio)
> +{
> +	unsigned long start, npages, i;
> +	int r;
> +
> +	start = (unsigned long) folio_address(folio);
> +	npages = folio_nr_pages(folio);
> +
> +	for (i = 0; i < npages; ++i) {
> +		r = set_direct_map_invalid_noflush(folio_page(folio, i));
> +		if (r)
> +			goto out_remap;
> +	}

I feels like we need a new helper that takes care of contiguous pages.
arm64 already has set_memory_valid(), so it may be something like

	int set_direct_map_valid_noflush(struct page *p, unsigned nr, bool valid);

> +	flush_tlb_kernel_range(start, start + folio_size(folio));
> +	folio_set_private(folio);
> +	return 0;
> +out_remap:
> +	for (; i > 0; i--) {
> +		struct page *page = folio_page(folio, i - 1);
> +
> +		if (WARN_ON_ONCE(set_direct_map_default_noflush(page))) {
> +			/*
> +			 * Random holes in the direct map are bad, let's mark
> +			 * these pages as corrupted memory so that the kernel
> +			 * avoids ever touching them again.
> +			 */
> +			folio_set_hwpoison(folio);
> +			r = -EHWPOISON;
> +		}
> +	}
> +	return r;
> +}
> +

-- 
Sincerely yours,
Mike.


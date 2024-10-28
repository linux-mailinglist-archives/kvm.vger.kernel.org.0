Return-Path: <kvm+bounces-29874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F48E9B3824
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:48:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 338E8282E11
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38CA61E0B95;
	Mon, 28 Oct 2024 17:44:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6B21DF74C;
	Mon, 28 Oct 2024 17:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730137476; cv=none; b=aCEUsXMpD/VrSoN6dmDxxgTWwrsrMAx3Rof60x6/d6vcF8SrtM6J+c0uWimKaXn8FeGil4jqfJ2igMdA/hy6YF+hm9mef3lEoCyDB6mKE7+6ORW0/dL3yD64YUK7qLPmxO56PJYOvV6MzPcILe/DPZgg4Jkv71LiKkqUhxlSBoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730137476; c=relaxed/simple;
	bh=qYHQccaUHX1B5FxGZXBCYY5h73M309VvW3KOYFQw26Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTVR8sphtp8zxDsAMWAuMMg99p7dFAaqizmRcEwQw5PmNfYskiA5mayIrjoELmv8+7BYm6DU48+nhNeJbxwFiGU3VvPGQE0uQWRX1VhtMVlHU58i7rKPSIEDbU0/vsvue7TSv8TRyFEmtjCptSdmkuuLW0oIp1HqaSCy4tEJM/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85665C4CEC3;
	Mon, 28 Oct 2024 17:44:34 +0000 (UTC)
Date: Mon, 28 Oct 2024 17:44:32 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, KVM <kvm@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Yang Shi <yang@os.amperecomputing.com>
Subject: Re: linux-next: manual merge of the kvm tree with the arm64 tree
Message-ID: <Zx_NgJnjsGIrW4uF@arm.com>
References: <20241028170310.3051da53@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028170310.3051da53@canb.auug.org.au>

On Mon, Oct 28, 2024 at 05:03:10PM +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the kvm tree got a conflict in:
> 
>   arch/arm64/kvm/guest.c
> 
> between commit:
> 
>   25c17c4b55de ("hugetlb: arm64: add mte support")
> 
> from the arm64 tree and commit:
> 
>   570d666c11af ("KVM: arm64: Use __gfn_to_page() when copying MTE tags to/from userspace")
> 
> from the kvm tree.
[...]
> diff --cc arch/arm64/kvm/guest.c
> index e738a353b20e,4cd7ffa76794..000000000000
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@@ -1051,13 -1051,11 +1051,12 @@@ int kvm_vm_ioctl_mte_copy_tags(struct k
>   	}
>   
>   	while (length > 0) {
> - 		kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
> + 		struct page *page = __gfn_to_page(kvm, gfn, write);
>   		void *maddr;
>   		unsigned long num_tags;
> - 		struct page *page;
>  +		struct folio *folio;
>   
> - 		if (is_error_noslot_pfn(pfn)) {
> + 		if (!page) {
>   			ret = -EFAULT;
>   			goto out;
>   		}
> @@@ -1099,12 -1090,8 +1097,12 @@@
>   			/* uaccess failed, don't leave stale tags */
>   			if (num_tags != MTE_GRANULES_PER_PAGE)
>   				mte_clear_page_tags(maddr);
>  -			set_page_mte_tagged(page);
>  +			if (folio_test_hugetlb(folio))
>  +				folio_set_hugetlb_mte_tagged(folio);
>  +			else
>  +				set_page_mte_tagged(page);
>  +
> - 			kvm_release_pfn_dirty(pfn);
> + 			kvm_release_page_dirty(page);
>   		}
>   
>   		if (num_tags != MTE_GRANULES_PER_PAGE) {

Thanks Stephen. The resolution looks fine and I'm happy to leave to
Linus to fix it up during the merging window.

To the KVM maintainers, if you prefer a conflict-free linux-next, feel
free to pull the arm64 for-next/mte branch with the above commit (and a
kselftest). The other way around is not something I'd suggest we do,
there are over 80 patches in that kvm series.

-- 
Catalin


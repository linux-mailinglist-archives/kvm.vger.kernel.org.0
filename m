Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54000747BB4
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 05:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjGEDKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 23:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjGEDKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 23:10:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8976E7A;
        Tue,  4 Jul 2023 20:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688526606; x=1720062606;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n5qL7D4xdHLBhI/AKoJrtNUl9WSrYurpJvD6rVhtxD8=;
  b=UhGTcteOjFqbFkzJu6GeixmPSTcoV4R/awqv6QobYoaPeNpd5khAKgIT
   YMm8JBBp3rswrxeUuhas/uL5OVQx3vw2pGfrYOt0M5/TFIsMh0covJ/t/
   T+xAQoj0llvu/8bp7H3fqNgi0tilr0ucPLhBQpPuDi47avIVRzHmVkVCb
   6bNhDswF0YTBRmEcSFgk2C1Kx5p3G5JMSkdp4c5HXvAXWzydcjV1lj8iH
   QQSNr1qb/5Zi9wmnv7AEAinh5ods0T2Kwov0QdiAiYb1QfOlhn9cY4zHe
   9M93XiUa1cga8bl7BE0m0BUUxkZTeii+ddN0EyUy78KMr9WdQcc6Sx1tX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="393984900"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="393984900"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2023 20:10:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="719085049"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="719085049"
Received: from jialinji-mobl4.ccr.corp.intel.com (HELO localhost) ([10.255.30.200])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2023 20:10:02 -0700
Date:   Wed, 5 Jul 2023 11:10:02 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 2/8] KVM: Introduce __kvm_follow_pfn function
Message-ID: <20230705031002.xrxk42hli6oavtlt@linux.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-3-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704075054.3344915-3-stevensd@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> @@ -2514,35 +2512,26 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
>   * The slow path to get the pfn of the specified host virtual address,
>   * 1 indicates success, -errno is returned if error is detected.
>   */
> -static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
> -			   bool interruptible, bool *writable, kvm_pfn_t *pfn)
> +static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
>  {
> -	unsigned int flags = FOLL_HWPOISON;
> +	unsigned int flags = FOLL_HWPOISON | FOLL_GET | foll->flags;
>  	struct page *page;
>  	int npages;
>  
>  	might_sleep();
>  
> -	if (writable)
> -		*writable = write_fault;
> -
> -	if (write_fault)
> -		flags |= FOLL_WRITE;
> -	if (async)
> -		flags |= FOLL_NOWAIT;
> -	if (interruptible)
> -		flags |= FOLL_INTERRUPTIBLE;
> -
> -	npages = get_user_pages_unlocked(addr, 1, &page, flags);
> +	npages = get_user_pages_unlocked(foll->hva, 1, &page, flags);
>  	if (npages != 1)
>  		return npages;
>  
> +	foll->writable = (foll->flags & FOLL_WRITE) && foll->allow_write_mapping;
> +
>  	/* map read fault as writable if possible */
> -	if (unlikely(!write_fault) && writable) {
> +	if (unlikely(!foll->writable) && foll->allow_write_mapping) {

I guess !foll->writable should be !(foll->flags & FOLL_WRITE) here.

>  		struct page *wpage;
>  
> -		if (get_user_page_fast_only(addr, FOLL_WRITE, &wpage)) {
> -			*writable = true;
> +		if (get_user_page_fast_only(foll->hva, FOLL_WRITE, &wpage)) {
> +			foll->writable = true;
>  			put_page(page);
>  			page = wpage;
>  		}
> @@ -2572,23 +2561,23 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
>  	return get_page_unless_zero(page);
>  }
>  
...

> +kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> +			       bool atomic, bool interruptible, bool *async,
> +			       bool write_fault, bool *writable, hva_t *hva)
> +{
> +	kvm_pfn_t pfn;
> +	struct kvm_follow_pfn foll = {
> +		.slot = slot,
> +		.gfn = gfn,
> +		.flags = 0,
> +		.atomic = atomic,
> +		.allow_write_mapping = !!writable,
> +	};
> +
> +	if (write_fault)
> +		foll.flags |= FOLL_WRITE;
> +	if (async)
> +		foll.flags |= FOLL_NOWAIT;
> +	if (interruptible)
> +		foll.flags |= FOLL_INTERRUPTIBLE;
> +
> +	pfn = __kvm_follow_pfn(&foll);
> +	if (pfn == KVM_PFN_ERR_NEEDS_IO) {

Could we just use KVM_PFN_ERR_FAULT and foll.flags here? I.e.,
	if (pfn == KVM_PFN_ERR_FAULT && (foll.flags & FOLL_NOWAIT))?
Setting pfn to KVM_PFN_ERR_NEEDS_IO just to indicate an async fault
seems unnecessary.

> +		*async = true;
> +		pfn = KVM_PFN_ERR_FAULT;
> +	}
> +	if (hva)
> +		*hva = foll.hva;
> +	if (writable)
> +		*writable = foll.writable;
> +	return pfn;
>  }
>  EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
>  

B.R.
Yu

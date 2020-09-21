Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A465A273304
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 21:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgIUTkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 15:40:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:10920 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbgIUTkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 15:40:46 -0400
IronPort-SDR: X2sAdc1W0Zz3Vp7Qdv7J+r1WngaGwDhANN1d31iML0ihg1rUJ7Oeu2k/mXCBqLmvt3AftGSy59
 8dWfcRlx0aXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="157845371"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="157845371"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 12:40:45 -0700
IronPort-SDR: 4+l38j24hNiGJ17N6i54FNIZFFFW4BUVirSldGQPq31tEVquF1cNQucMRevMEx+alcVm4K0oZN
 4BFnvW/OWXzg==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="485638277"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 12:40:44 -0700
Date:   Mon, 21 Sep 2020 12:40:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: fix counting of rmap entries in
 pte_list_add
Message-ID: <20200921194043.GA25005@linux.intel.com>
References: <1600684166-32430-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600684166-32430-1-git-send-email-lirongqing@baidu.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 21, 2020 at 06:29:26PM +0800, Li RongQing wrote:
> counting of rmap entries was missed when desc->sptes is full
> and desc->more is NULL
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a5d0207e7189..8ffa4e40b650 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1280,6 +1280,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>  		if (desc->sptes[PTE_LIST_EXT-1]) {
>  			desc->more = mmu_alloc_pte_list_desc(vcpu);
>  			desc = desc->more;
> +			count += PTE_LIST_EXT;

Kind of a nit, but what do you think about merging the two PTE_LIST_EXT-1
check?  For me, that makes the resulting code more obviously correct, and it
might be slightly more performant as it avoids the extra comparison, though
the compiler may be smart enough to optimize that away without help.

		while (desc->sptes[PTE_LIST_EXIT-1]) {
			count += PTE_LIST_EXT;

			if (!desc->more) {
				desc->more = mmu_alloc_pte_list_desc(vcpu);
				desc = desc->more;
				break;
			}
			desc = desc->more;
		}

>  		}
>  		for (i = 0; desc->sptes[i]; ++i)
>  			++count;
> -- 
> 2.16.2
> 

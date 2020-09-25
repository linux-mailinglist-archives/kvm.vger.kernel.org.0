Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09677278EED
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 18:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgIYQnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 12:43:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:28425 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgIYQng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 12:43:36 -0400
IronPort-SDR: tA0bg4iFV4nYZEbOmQKiRyruy7ZfU15ZfSR/iK9i/IFSAlhMxrAFkyOFwqH2gK9vLa0vUMeLXi
 vP7g29AlPNwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="161667894"
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="161667894"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 09:43:34 -0700
IronPort-SDR: f4B58X8SpgGLHw963RM5Ma+/Ae2KBFNCvbxcs1+f9vGq3wJ3fv8bTzD2xJgaEXP6yOryHuJmJh
 /7ANeBf3Roeg==
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="512229079"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 09:43:34 -0700
Date:   Fri, 25 Sep 2020 09:43:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH][v2] KVM: x86/mmu: fix counting of rmap entries in
 pte_list_add
Message-ID: <20200925164332.GA31528@linux.intel.com>
References: <1600837138-21110-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600837138-21110-1-git-send-email-lirongqing@baidu.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 12:58:58PM +0800, Li RongQing wrote:
> counting of rmap entries was missed when desc->sptes is full
> and desc->more is NULL
> 
> and merging two PTE_LIST_EXT-1 check as one, to avoids the
> extra comparison to give slightly optimization

Please write complete sentences, and use proper capitalization and punctuation.
It's not a big deal for short changelogs, but it's crucial for readability of
larger changelogs.

E.g.

  Fix an off-by-one style bug in pte_list_add() where it failed to account
  the last full set of SPTEs, i.e. when desc->sptes is full and desc->more
  is NULL.

  Merge the two "PTE_LIST_EXT-1" checks as part of the fix to avoid an
  extra comparison.

> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>

No need to give me credit, I just nitpicked the code, identifying the bug
and the fix was all you. :-)

Thanks for the fix!

> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Paolo,

Although it's a bug fix, I don't think this needs a Fixes / Cc:stable.  The bug
only results in rmap recycling being delayed by one rmap.  Stable kernels can
probably live with an off-by-one bug given that RMAP_RECYCLE_THRESHOLD is
completely arbitrary. :-)

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> ---
> diff with v1: merge two check as one
> 
>  arch/x86/kvm/mmu/mmu.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a5d0207e7189..c4068be6bb3f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1273,12 +1273,14 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>  	} else {
>  		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
>  		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
> -		while (desc->sptes[PTE_LIST_EXT-1] && desc->more) {
> -			desc = desc->more;
> +		while (desc->sptes[PTE_LIST_EXT-1]) {
>  			count += PTE_LIST_EXT;
> -		}
> -		if (desc->sptes[PTE_LIST_EXT-1]) {
> -			desc->more = mmu_alloc_pte_list_desc(vcpu);
> +
> +			if (!desc->more) {
> +				desc->more = mmu_alloc_pte_list_desc(vcpu);
> +				desc = desc->more;
> +				break;
> +			}
>  			desc = desc->more;
>  		}
>  		for (i = 0; desc->sptes[i]; ++i)
> -- 
> 2.16.2
> 

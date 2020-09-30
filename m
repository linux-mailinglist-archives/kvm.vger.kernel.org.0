Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7BE27E044
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 07:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgI3FYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 01:24:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:41459 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgI3FYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 01:24:16 -0400
IronPort-SDR: phxydRIEyJ44lyoVi9ogsxL7uhXsi8zXX1/ttftwijydsX1ab0mETn6jpGxR2LIEjf4bV6CRct
 F8EjEpXdHfRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="223961565"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="223961565"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 22:24:11 -0700
IronPort-SDR: DNTn5ynefQnzo+L9x33WNVLdL6eBV4IKbQpSD6Oxarc3rRsSzemgV4WEPi22KTykLNwOxnHXoO
 0pWH5dccL6nA==
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="495598916"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 22:24:11 -0700
Date:   Tue, 29 Sep 2020 22:24:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 02/22] kvm: mmu: Introduce tdp_iter
Message-ID: <20200930052336.GD29405@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-3-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:42PM -0700, Ben Gardon wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> new file mode 100644
> index 0000000000000..ee90d62d2a9b1
> --- /dev/null
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -0,0 +1,163 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include "mmu_internal.h"
> +#include "tdp_iter.h"
> +
> +/*
> + * Recalculates the pointer to the SPTE for the current GFN and level and
> + * reread the SPTE.
> + */
> +static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
> +{
> +	iter->sptep = iter->pt_path[iter->level - 1] +
> +		SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
> +	iter->old_spte = READ_ONCE(*iter->sptep);
> +}
> +
> +/*
> + * Sets a TDP iterator to walk a pre-order traversal of the paging structure
> + * rooted at root_pt, starting with the walk to translate goal_gfn.
> + */
> +void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
> +		    gfn_t goal_gfn)
> +{
> +	WARN_ON(root_level < 1);
> +	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
> +
> +	iter->goal_gfn = goal_gfn;
> +	iter->root_level = root_level;
> +	iter->level = root_level;
> +	iter->pt_path[iter->level - 1] = root_pt;
> +
> +	iter->gfn = iter->goal_gfn -
> +		(iter->goal_gfn % KVM_PAGES_PER_HPAGE(iter->level));

Maybe use the params, if only to avoid the line wrap?

	iter->gfn = goal_gfn - (goal_gfn % KVM_PAGES_PER_HPAGE(root_level));

Actually, peeking further into the file, this calculation is repeated in both
try_step_up and try_step_down,  probably worth adding a helper of some form.

> +	tdp_iter_refresh_sptep(iter);
> +
> +	iter->valid = true;
> +}
> +
> +/*
> + * Given an SPTE and its level, returns a pointer containing the host virtual
> + * address of the child page table referenced by the SPTE. Returns null if
> + * there is no such entry.
> + */
> +u64 *spte_to_child_pt(u64 spte, int level)
> +{
> +	u64 *pt;
> +	/* There's no child entry if this entry isn't present */
> +	if (!is_shadow_present_pte(spte))
> +		return NULL;
> +
> +	/* There is no child page table if this is a leaf entry. */
> +	if (is_last_spte(spte, level))
> +		return NULL;

I'd collapse the checks and their comments.

> +
> +	pt = (u64 *)__va(spte_to_pfn(spte) << PAGE_SHIFT);
> +	return pt;

No need for the local variable or the explicit cast.

	/* There's no child if this entry is non-present or a leaf entry. */
	if (!is_shadow_present_pte(spte) || is_last_spte(spte, level))
		return NULL;

	return __va(spte_to_pfn(spte) << PAGE_SHIFT);

> +}

...

> +void tdp_iter_next(struct tdp_iter *iter)
> +{
> +	bool done;
> +
> +	done = try_step_down(iter);
> +	if (done)
> +		return;
> +
> +	done = try_step_side(iter);
> +	while (!done) {
> +		if (!try_step_up(iter)) {
> +			iter->valid = false;
> +			break;
> +		}
> +		done = try_step_side(iter);
> +	}

At the risk of being too clever:

	bool done;

	if (try_step_down(iter))
		return;

	do {
		done = try_step_side(iter);
	} while (!done && try_step_up(iter));

	iter->valid = done;

> +}

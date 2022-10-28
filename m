Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A449B6106BB
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 02:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiJ1ARt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 20:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiJ1ARs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 20:17:48 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B928C03F
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 17:17:46 -0700 (PDT)
Date:   Fri, 28 Oct 2022 00:17:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666916264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Y4lxu0Rs341PBPmflTbdmhLFMGIleK8lMVPgSwPa5I=;
        b=Dv4ZmSswg2fxYyklKNOE8N6gBdhz8PIqYek8qHQjHl4JZ35+tOZnJKbcd5bpwcfh+743oQ
        viiOHwj9hsV99SByAesVJX3USOny2iiyiQUUq9K3WblCHOLOTGY4KJ4dTcn6moydy4yspb
        FKzvcs7+M8kNU81nIhKhp43o+BTxTpg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>,
        kernel-team@android.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 02/25] KVM: arm64: Allow attaching of non-coalescable
 pages to a hyp pool
Message-ID: <Y1sfpM3IjNvr8ckf@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-3-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020133827.5541-3-will@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022 at 02:38:04PM +0100, Will Deacon wrote:
> From: Quentin Perret <qperret@google.com>
> 
> All the contiguous pages used to initialize a 'struct hyp_pool' are
> considered coalescable, which means that the hyp page allocator will
> actively try to merge them with their buddies on the hyp_put_page() path.
> However, using hyp_put_page() on a page that is not part of the inital
> memory range given to a hyp_pool() is currently unsupported.
> 
> In order to allow dynamically extending hyp pools at run-time, add a
> check to __hyp_attach_page() to allow inserting 'external' pages into
> the free-list of order 0. This will be necessary to allow lazy donation
> of pages from the host to the hypervisor when allocating guest stage-2
> page-table pages at EL2.

Is it ever going to be the case that we wind up mixing static and
dynamic memory within the same buddy allocator? Reading ahead a bit it
would seem pKVM uses separate allocators (i.e. pkvm_hyp_vm::pool for
donated memory) but just wanted to make sure.

I suppose what I'm getting at is the fact that the pool range makes
little sense in this case. Adding a field to hyp_pool describing the
type of pool that it is would make this more readable, such that we know
a pool contains only donated memory, and thus zero order pages should
never be coalesced.

> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> index 1ded09fc9b10..0d15227aced8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> @@ -93,11 +93,15 @@ static inline struct hyp_page *node_to_page(struct list_head *node)
>  static void __hyp_attach_page(struct hyp_pool *pool,
>  			      struct hyp_page *p)
>  {
> +	phys_addr_t phys = hyp_page_to_phys(p);
>  	unsigned short order = p->order;
>  	struct hyp_page *buddy;
>  
>  	memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
>  
> +	if (phys < pool->range_start || phys >= pool->range_end)
> +		goto insert;
> +

Assuming this is kept as-is...

This check reads really odd to me, but I understand how it applies to
the use case here. Perhaps create a helper (to be shared with
__find_buddy_nocheck()) and add a nice comment atop it describing the
significance of pages that exist outside the boundaries of the buddy
allocator.

--
Thanks,
Oliver

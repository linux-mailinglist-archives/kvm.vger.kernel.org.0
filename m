Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B3F610BA2
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 09:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiJ1Hwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 03:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJ1Hwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 03:52:47 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06257773B0
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 00:52:45 -0700 (PDT)
Date:   Fri, 28 Oct 2022 07:52:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666943563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rp2EPcG+Xzug6liQFKvQ1Gq+Ftk+ay1U8u/K5+jOK8o=;
        b=i4n1nkJutC82yE9tj6+VGyg1+QacDJpn1+yBtmVnLuc+khhOChWPu7jQj1jnnwvpmYgVqn
        UC5QA4iGAePkkdCpkVfpL7LOeKkhf9ePlTrmGhe9LvtaW1i5r2+AkXmjN/Kkshc8BzD9lX
        c/q8SEfnJpEekeguGK3j8EnERLCrdEI=
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
Subject: Re: [PATCH v5 06/25] KVM: arm64: Implement do_donate() helper for
 donating memory
Message-ID: <Y1uKRkFHve6S4JcP@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-7-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020133827.5541-7-will@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022 at 02:38:08PM +0100, Will Deacon wrote:
> Transferring ownership information of a memory region from one component
> to another can be achieved using a "donate" operation, which results
> in the previous owner losing access to the underlying pages entirely
> and the new owner having exclusive access to the page.
> 
> Implement a do_donate() helper, along the same lines as do_{un,}share,
> and provide this functionality for the host-{to,from}-hyp cases as this
> will later be used to donate/reclaim memory pages to store VM metadata
> at EL2.
> 
> In a similar manner to the sharing transitions, permission checks are
> performed by the hypervisor to ensure that the component initiating the
> transition really is the owner of the page and also that the completer
> does not currently have a page mapped at the target address.

Is the intention of this infra to support memory donations between more
than just the host + hyp components? This patch goes out of its way to
build some generic helpers for things, but it isn't immediately obvious
why that is necessary for just two supported state transitions.

[...]

> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index f5705a1e972f..c87b19b2d468 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -60,6 +60,8 @@ enum pkvm_component_id {
>  int __pkvm_prot_finalize(void);
>  int __pkvm_host_share_hyp(u64 pfn);
>  int __pkvm_host_unshare_hyp(u64 pfn);
> +int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> +int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
>  
>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index ff86f5bd230f..c30402737548 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -391,6 +391,9 @@ struct pkvm_mem_transition {
>  				/* Address in the completer's address space */
>  				u64	completer_addr;
>  			} host;
> +			struct {
> +				u64	completer_addr;
> +			} hyp;

I don't believe the union is providing a ton of value here. In fact, the
whole layout of the pkvm_mem_transition structure confuses me a little.
Why not move 'completer_addr' to pkvm_mem_transition::completer::addr?

You'd then have two identical structs for describing the source and
target addresses for a chunk of memory. IDK if this would be needed
later on, but such a struct could be worthy of its own type as it fully
describes the address and its owning address space.

Spitballing:

	struct pkvm_mem_transition {
		u64	nr_pages;

		struct {
			enum pkvm_component_id	id;
			u64			addr;
		} source;

		struct {
			enum pkvm_component_id	id;
			u64			addr;
		} target;
	};

>  		};
>  	} initiator;
>  
> @@ -404,6 +407,10 @@ struct pkvm_mem_share {
>  	const enum kvm_pgtable_prot		completer_prot;
>  };
>  
> +struct pkvm_mem_donation {
> +	const struct pkvm_mem_transition	tx;
> +};
> +

What is the purpose of introducing another struct here? AFAICT none of
the subsequent patches add fields to this.

>  struct check_walk_data {
>  	enum pkvm_page_state	desired;
>  	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte);
> @@ -503,6 +510,46 @@ static int host_initiate_unshare(u64 *completer_addr,
>  	return __host_set_page_state_range(addr, size, PKVM_PAGE_OWNED);
>  }
>  
> +static int host_initiate_donation(u64 *completer_addr,
> +				  const struct pkvm_mem_transition *tx)

<bikeshed>

The {host,hyp}_initiate_donation() function names are a tiny bit
confusing. IMO, referring to this phase of the donation as 'disowning'
might make it more obvious what is actually changing in the page tables
at this moment.

</bikeshed>

> +{
> +	u8 owner_id = tx->completer.id;
> +	u64 size = tx->nr_pages * PAGE_SIZE;
> +
> +	*completer_addr = tx->initiator.host.completer_addr;

This kind of out pointer is extremely funky... Rejigging
pkvm_mem_transition would allow __do_donate() to work out the
'completer_addr' directly.

> +	return host_stage2_set_owner_locked(tx->initiator.addr, size, owner_id);
> +}
> +
> +static bool __host_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
> +{
> +	return !(IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) ||
> +		 tx->initiator.id != PKVM_ID_HYP);
> +}
> +
> +static int __host_ack_transition(u64 addr, const struct pkvm_mem_transition *tx,
> +				 enum pkvm_page_state state)
> +{
> +	u64 size = tx->nr_pages * PAGE_SIZE;
> +
> +	if (__host_ack_skip_pgtable_check(tx))
> +		return 0;
> +
> +	return __host_check_page_state_range(addr, size, state);
> +}
> +
> +static int host_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
> +{
> +	return __host_ack_transition(addr, tx, PKVM_NOPAGE);
> +}
> +
> +static int host_complete_donation(u64 addr, const struct pkvm_mem_transition *tx)
> +{
> +	u64 size = tx->nr_pages * PAGE_SIZE;
> +	u8 host_id = tx->completer.id;
> +
> +	return host_stage2_set_owner_locked(addr, size, host_id);
> +}
> +
>  static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
>  {
>  	if (!kvm_pte_valid(pte))
> @@ -523,6 +570,27 @@ static int __hyp_check_page_state_range(u64 addr, u64 size,
>  	return check_page_state_range(&pkvm_pgtable, addr, size, &d);
>  }
>  
> +static int hyp_request_donation(u64 *completer_addr,
> +				const struct pkvm_mem_transition *tx)

I'm not too big of a fan of the request/ack verbiage here. IMO, it is
suggestive of some form of message passing between the two components.
But, AFAICT:

 - 'request' checks that the component owns the pages it is trying to
   donate.

 - 'ack' checks that the component doesn't have anything mapped at the
   target address

Why not call it {host,hyp}_check_range_owned() and
{host,hyp}_check_range_unmapped()? That way it is immediately obvious
what conditions are being tested in check_donation().

Sorry, I see that there is some groundwork for this already upstream,
but I still find it confusing.

[...]

> +static int check_donation(struct pkvm_mem_donation *donation)
> +{
> +	const struct pkvm_mem_transition *tx = &donation->tx;
> +	u64 completer_addr;
> +	int ret;
> +
> +	switch (tx->initiator.id) {
> +	case PKVM_ID_HOST:
> +		ret = host_request_owned_transition(&completer_addr, tx);
> +		break;
> +	case PKVM_ID_HYP:
> +		ret = hyp_request_donation(&completer_addr, tx);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	if (ret)
> +		return ret;
> +
> +	switch (tx->completer.id){
				^^
nit: whitespace

> +	case PKVM_ID_HOST:
> +		ret = host_ack_donation(completer_addr, tx);
> +		break;
> +	case PKVM_ID_HYP:
> +		ret = hyp_ack_donation(completer_addr, tx);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int __do_donate(struct pkvm_mem_donation *donation)
> +{
> +	const struct pkvm_mem_transition *tx = &donation->tx;
> +	u64 completer_addr;
> +	int ret;
> +
> +	switch (tx->initiator.id) {
> +	case PKVM_ID_HOST:
> +		ret = host_initiate_donation(&completer_addr, tx);
> +		break;
> +	case PKVM_ID_HYP:
> +		ret = hyp_initiate_donation(&completer_addr, tx);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	if (ret)
> +		return ret;
> +
> +	switch (tx->completer.id){
				^^
nit: whitespace

--
Thanks,
Oliver

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4D255A802
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 10:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiFYIOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jun 2022 04:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiFYIOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jun 2022 04:14:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DA3530541
        for <kvm@vger.kernel.org>; Sat, 25 Jun 2022 01:14:53 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1327CD6E;
        Sat, 25 Jun 2022 01:14:53 -0700 (PDT)
Received: from [192.168.1.79] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A9BC3F534;
        Sat, 25 Jun 2022 01:14:51 -0700 (PDT)
Message-ID: <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
Date:   Sat, 25 Jun 2022 09:14:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Content-Language: en-GB
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Peter Collingbourne <pcc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <YrXu0Uzi73pUDwye@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/2022 18:05, Catalin Marinas wrote:
> + Steven as he added the KVM and swap support for MTE.
> 
> On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
>> Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
>> depend on being able to map guest memory as MAP_SHARED. The current
>> restriction on sharing MAP_SHARED pages with the guest is preventing
>> the use of those features with MTE. Therefore, remove this restriction.
> 
> We already have some corner cases where the PG_mte_tagged logic fails
> even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
> KVM MAP_SHARED will potentially make things worse (or hard to reason
> about; for example the VMM sets PROT_MTE as well). I'm more inclined to
> get rid of PG_mte_tagged altogether, always zero (or restore) the tags
> on user page allocation, copy them on write. For swap we can scan and if
> all tags are 0 and just skip saving them.
> 
> Another aspect is a change in the KVM ABI with this patch. It's probably
> not that bad since it's rather a relaxation but it has the potential to
> confuse the VMM, especially as it doesn't know whether it's running on
> older kernels or not (it would have to probe unless we expose this info
> to the VMM in some other way).
> 
>> To avoid races between multiple tasks attempting to clear tags on the
>> same page, introduce a new page flag, PG_mte_tag_clearing, and test-set it
>> atomically before beginning to clear tags on a page. If the flag was not
>> initially set, spin until the other task has finished clearing the tags.
> 
> TBH, I can't mentally model all the corner cases, so maybe a formal
> model would help (I can have a go with TLA+, though not sure when I find
> a bit of time this summer). If we get rid of PG_mte_tagged altogether,
> this would simplify things (hopefully).
> 
> As you noticed, the problem is that setting PG_mte_tagged and clearing
> (or restoring) the tags is not an atomic operation. There are places
> like mprotect() + CoW where one task can end up with stale tags. Another
> is shared memfd mappings if more than one mapping sets PROT_MTE and
> there's the swap restoring on top.
> 
>> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
>> index f6b00743c399..8f9655053a9f 100644
>> --- a/arch/arm64/kernel/mte.c
>> +++ b/arch/arm64/kernel/mte.c
>> @@ -57,7 +57,18 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
>>  	 * the new page->flags are visible before the tags were updated.
>>  	 */
>>  	smp_wmb();
>> -	mte_clear_page_tags(page_address(page));
>> +	mte_ensure_page_tags_cleared(page);
>> +}
>> +
>> +void mte_ensure_page_tags_cleared(struct page *page)
>> +{
>> +	if (test_and_set_bit(PG_mte_tag_clearing, &page->flags)) {
>> +		while (!test_bit(PG_mte_tagged, &page->flags))
>> +			;
>> +	} else {
>> +		mte_clear_page_tags(page_address(page));
>> +		set_bit(PG_mte_tagged, &page->flags);
>> +	}

I'm pretty sure we need some form of barrier in here to ensure the tag
clearing is visible to the other CPU. Otherwise I can't immediately see
any problems with the approach of a second flag (it was something I had
considered). But I do also think we should seriously consider Catalin's
approach of simply zeroing tags unconditionally - it would certainly
simplify the code.

The main issue with unconditionally zeroing is if you then want to
(ab)use the tag memory carveout as extra memory for regions that are not
being used for tags. Personally it seems pretty crazy (a whole lot of
extra complexity for a small gain in ram), and I'm not convinced that
memory is sufficiently moveable for it to reliably work.

>>  }
> 
> mte_sync_tags() already sets PG_mte_tagged prior to clearing the page
> tags. The reason was so that multiple concurrent set_pte_at() would not
> all rush to clear (or restore) the tags. But we do have the risk of one
> thread accessing the page with the stale tags (copy_user_highpage() is
> worse as the tags would be wrong in the destination page). I'd rather be
> consistent everywhere with how we set the flags.
> 
> However, I find it easier to reason about if we used the new flag as a
> lock. IOW, if PG_mte_tagged is set, we know that tags are valid. If not
> set, take the PG_mte_locked flag, check PG_mte_tagged again and
> clear/restore the tags followed by PG_mte_tagged (and you can use
> test_and_set_bit_lock() for the acquire semantics).

I agree - when I considered this before it was using the second flag as
a lock.

Steve

> 
> It would be interesting to benchmark the cost of always zeroing the tags
> on allocation and copy when MTE is not in use:
> 
> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> index 0dea80bf6de4..d31708886bf9 100644
> --- a/arch/arm64/mm/copypage.c
> +++ b/arch/arm64/mm/copypage.c
> @@ -21,7 +21,7 @@ void copy_highpage(struct page *to, struct page *from)
>  
>  	copy_page(kto, kfrom);
>  
> -	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
> +	if (system_supports_mte()) {
>  		set_bit(PG_mte_tagged, &to->flags);
>  		page_kasan_tag_reset(to);
>  		/*
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index c5e11768e5c1..b42cad9b9349 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -913,12 +913,7 @@ struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
>  {
>  	gfp_t flags = GFP_HIGHUSER_MOVABLE | __GFP_ZERO;
>  
> -	/*
> -	 * If the page is mapped with PROT_MTE, initialise the tags at the
> -	 * point of allocation and page zeroing as this is usually faster than
> -	 * separate DC ZVA and STGM.
> -	 */
> -	if (vma->vm_flags & VM_MTE)
> +	if (system_supports_mte())
>  		flags |= __GFP_ZEROTAGS;
>  
>  	return alloc_page_vma(flags, vma, vaddr);
> 
> If that's negligible, we can hopefully get rid of PG_mte_tagged. For
> swap we could move the restoring to arch_do_swap_page() (but move the
> call one line above set_pte_at() in do_swap_page()).
> 


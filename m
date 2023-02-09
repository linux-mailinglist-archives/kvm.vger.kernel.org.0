Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429496913BC
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 23:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjBIWtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 17:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjBIWtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 17:49:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9905F30B3F
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 14:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675982903;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WZaDBzx58JAMjEn7EDEgD2XWnnJnFhK/yUPI3hFd8g8=;
        b=QWaXula7DFJmbYg4X+NFcZ4WdukiwliHItWxVnAqQt6VyW89tSJpkqUPdkFUZ0o75rnGXe
        uuI+dJvdpg0tmSBLLoRiGRDnC3631zybFyG5Rj3UYwoMuOl5+osQJ6eJYGDb10aVxOp295
        Usr79R7KIVAQvMA5Q8W1rUPvpqq9N/Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-vfsIj0iqMe-BmbPY66kaMw-1; Thu, 09 Feb 2023 17:48:22 -0500
X-MC-Unique: vfsIj0iqMe-BmbPY66kaMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D490585A588;
        Thu,  9 Feb 2023 22:48:20 +0000 (UTC)
Received: from [10.64.54.63] (vpn2-54-63.bne.redhat.com [10.64.54.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 563582166B29;
        Thu,  9 Feb 2023 22:48:14 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To:     Ricardo Koller <ricarkol@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
References: <20230206165851.3106338-1-ricarkol@google.com>
 <20230206165851.3106338-5-ricarkol@google.com>
 <cae4a1d9-b5c2-2929-6d88-5a3fbe719651@redhat.com>
 <CAOHnOrxqEsbRD302Wwn9N06d6xj5NWy4p+C9DBjEm6Z4z2FvXg@mail.gmail.com>
 <CAOHnOrwprM8v3xXCA5sEVD1cHVQRS6vsPvdXiC1NocrzyQcoYw@mail.gmail.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <e8513463-75cc-ca11-2fe8-1ba1b32411d8@redhat.com>
Date:   Fri, 10 Feb 2023 09:48:11 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <CAOHnOrwprM8v3xXCA5sEVD1cHVQRS6vsPvdXiC1NocrzyQcoYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/23 3:17 AM, Ricardo Koller wrote:
> "(> > > +     if (data->mc_capacity < nr_pages)
>>>> +             return -ENOMEM;
>>>> +
>>>> +     phys = kvm_pte_to_phys(pte);
>>>> +     prot = kvm_pgtable_stage2_pte_prot(pte);
>>>> +
>>>> +     ret = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, &new, phys,
>>>> +                                              level, prot, mc, force_pte);
>>>> +     if (ret)
>>>> +             return ret;
>>>> +
>>>> +     if (!stage2_try_break_pte(ctx, data->mmu)) {
>>>> +             childp = kvm_pte_follow(new, mm_ops);
>>>> +             kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
>>>> +             mm_ops->put_page(childp);
>>>> +             return -EAGAIN;
>>>> +     }
>>>> +
>>>> +     /*
>>>> +      * Note, the contents of the page table are guaranteed to be made
>>>> +      * visible before the new PTE is assigned because stage2_make_pte()
>>>> +      * writes the PTE using smp_store_release().
>>>> +      */
>>>> +     stage2_make_pte(ctx, new);
>>>> +     dsb(ishst);
>>>> +     data->mc_capacity -= nr_pages;
>>>> +     return 0;
>>>> +}
>>>> +
>>>
>>> I think it's possible 'data->mc_capability' to be replaced by 'mc->nobjs'
>>> because they're same thing. With this, we needn't to maintain a duplicate
>>> 'data->mc_capability' since 'data->mc' has been existing.
>>
>> Ah, nice, yes. That would be simpler.
>>
> 
> Actually, there's a complication. The memcache details are hidden
> inside of pgtable.c,
> so different types of memcaches (for vhe and nvhe) can be used for allocations.
> Specifically, the memcache objects are passed as an opaque pointer ("void *")
> and can be used with "struct hyp_pool" and "struct kvm_mmu_memory_cache".
> 
> So, here are all the options that I can think of:
> 
>          1. stage2_split_walker() is just used on the VHE case with the
>          "struct kvm_mmu_memory_cache" memcache, so we could just use it
>          instead of a "void *":
> 
>                  kvm_pgtable_stage2_split(..., struct kvm_mmu_memory_cache *mc);
> 
>          However, it could be used for the NVHE case as well, plus
>          this would go against the overall design of pgtable.c which tries
>          to use opaque objects for most things.
> 
>          2. add a "get_nobjs()" method to both memcaches. This is tricky
>          because "struct hyp_pool" doesn't directly track its capacity. I
>          would rather not mess with it.
> 
>          3. This whole accounting of available pages in the memcache is
>          needed because of the way I implemented stage2_split_walker() and
>          the memcache interface.  stage2_split_walker() tries to allocate
>          as many pages for the new table as allowed by the capacity of the
>          memcache. The issue with blindingly trying until the allocation
>          fails is that kvm_mmu_memory_cache_alloc() WARNs and tries to
>          allocate using GFP_ATOMIC when !nobjs. We don't want to do that,
>          so we could extend kvm_pgtable_mm_ops.zalloc_page() with a
>          NO_GFP_ATOMIC_ON_EMPTY (or similar). This flag would have to be
>          ignored on the hyp side.
> 
>          4. what this patch is currently doing: tracking the capacity by
>          hand.
> 
> I prefer options 4 and 3. WDYT?
> 

Yeah, stage2_split_walker() is currently only used by VHE and it calls to
stage2_map_walker() to create the unlinked page table, which is shared by
VHE and nVHE. I think option 3 would be better than 4 because we generally
just want to fetch the pre-allocated page table, instead of allocating a
new page table with GFP_ATOMIC. However, I'm also fine with option 4. I
think this can be improved in the future if you agree.

>>
>>>
>>>> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
>>>> +                          void *mc, u64 mc_capacity)
>>>> +{
>>>> +     struct stage2_split_data split_data = {
>>>> +             .mmu            = pgt->mmu,
>>>> +             .memcache       = mc,
>>>> +             .mc_capacity    = mc_capacity,
>>>> +     };
>>>> +
>>>> +     struct kvm_pgtable_walker walker = {
>>>> +             .cb     = stage2_split_walker,
>>>> +             .flags  = KVM_PGTABLE_WALK_LEAF,
>>>> +             .arg    = &split_data,
>>>> +     };
>>>> +
>>>> +     return kvm_pgtable_walk(pgt, addr, size, &walker);
>>>> +}
>>>> +
>>>>    int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>>>>                              struct kvm_pgtable_mm_ops *mm_ops,
>>>>                              enum kvm_pgtable_stage2_flags flags,
>>>>
>>>

Thanks,
Gavin


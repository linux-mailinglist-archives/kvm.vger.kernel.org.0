Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EE477DB1F
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 09:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242424AbjHPH35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 03:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242417AbjHPH3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 03:29:31 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 486E1B3;
        Wed, 16 Aug 2023 00:29:28 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Cx5_HVetxkdgoZAA--.51429S3;
        Wed, 16 Aug 2023 15:29:25 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxLCPSetxkms5bAA--.9796S3;
        Wed, 16 Aug 2023 15:29:23 +0800 (CST)
Message-ID: <42ff33c7-ec50-1310-3e57-37e8283b9b16@loongson.cn>
Date:   Wed, 16 Aug 2023 15:29:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mike.kravetz@oracle.com, apopple@nvidia.com,
        jgg@nvidia.com, rppt@kernel.org, akpm@linux-foundation.org,
        kevin.tian@intel.com, david@redhat.com
References: <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
 <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn>
 <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com> <ZNZshVZI5bRq4mZQ@google.com>
 <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com> <ZNpZDH9//vk8Rqvo@google.com>
 <ZNra3eDNTaKVc7MT@yzhao56-desk.sh.intel.com> <ZNuQ0grC44Dbh5hS@google.com>
 <107cdaaf-237f-16b9-ebe2-7eefd2b21f8f@loongson.cn>
 <c8ccc8f1-300a-09be-db6b-df2a1dedd4cf@loongson.cn>
 <ZNxbLPG8qbs1FjhM@yzhao56-desk.sh.intel.com>
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <ZNxbLPG8qbs1FjhM@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxLCPSetxkms5bAA--.9796S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxuF1xJFWDtry8tw15Ww4kuFX_yoWrGryUpa
        yY9FW8Kr4DJ3yak34jqw4UAFyYg3yxXr48Xas8t34rAas8tryUCr4UKwn09Fy7JrnxXr12
        qa1jq3Zrua4UZagCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcApnDU
        UUU
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/8/16 13:14, Yan Zhao 写道:
> On Wed, Aug 16, 2023 at 11:44:29AM +0800, bibo mao wrote:
>>
>>
>> 在 2023/8/16 10:43, bibo mao 写道:
>>>
>>>
>>> 在 2023/8/15 22:50, Sean Christopherson 写道:
>>>> On Tue, Aug 15, 2023, Yan Zhao wrote:
>>>>> On Mon, Aug 14, 2023 at 09:40:44AM -0700, Sean Christopherson wrote:
>>>>>>>> Note, I'm assuming secondary MMUs aren't allowed to map swap entries...
>>>>>>>>
>>>>>>>> Compile tested only.
>>>>>>>
>>>>>>> I don't find a matching end to each
>>>>>>> mmu_notifier_invalidate_range_start_nonblock().
>>>>>>
>>>>>> It pairs with existing call to mmu_notifier_invalidate_range_end() in change_pmd_range():
>>>>>>
>>>>>> 	if (range.start)
>>>>>> 		mmu_notifier_invalidate_range_end(&range);
>>>>> No, It doesn't work for mmu_notifier_invalidate_range_start() sent in change_pte_range(),
>>>>> if we only want the range to include pages successfully set to PROT_NONE.
>>>>
>>>> Precise invalidation was a non-goal for my hack-a-patch.  The intent was purely
>>>> to defer invalidation until it was actually needed, but still perform only a
>>>> single notification so as to batch the TLB flushes, e.g. the start() call still
>>>> used the original @end.
>>>>
>>>> The idea was to play nice with the scenario where nothing in a VMA could be migrated.
>>>> It was complete untested though, so it may not have actually done anything to reduce
>>>> the number of pointless invalidations.
>>> For numa-balance scenery, can original page still be used by application even if pte
>>> is changed with PROT_NONE?  If it can be used, maybe we can zap shadow mmu and flush tlb
> For GUPs that does not honor FOLL_HONOR_NUMA_FAULT, yes,
> 
> See https://lore.kernel.org/all/20230803143208.383663-1-david@redhat.com/
> 
>> Since there is kvm_mmu_notifier_change_pte notification when numa page is replaced with
>> new page, my meaning that can original page still be used by application even if pte
>> is changed with PROT_NONE and before replaced with new page?
> It's not .change_pte() notification, which is sent when COW.
> The do_numa_page()/do_huge_pmd_numa_page() will try to unmap old page
> protected with PROT_NONE, and if every check passes, a separate
> .invalidate_range_start()/end() with event type MMU_NOTIFY_CLEAR will be
> sent.
yes, you are right. change_pte() notification will be will called
when migrate_vma_pages, I messed it with numa page migration. However
invalidate_range_start()/end() with event type MMU_NOTIFY_CLEAR will be
sent also when new page is replaced.
> 
> So, I think KVM (though it honors FOLL_HONOR_NUMA_FAULT), can safely
> keep mapping maybe-dma pages until MMU_NOTIFY_CLEAR is sent.
> (this approach is implemented in RFC v1
> https://lore.kernel.org/all/20230810085636.25914-1-yan.y.zhao@intel.com/)
> 
>>
>> And for primary mmu, tlb is flushed after pte is changed with PROT_NONE and 
>> after mmu_notifier_invalidate_range_end notification for secondary mmu.
>> Regards
>> Bibo Mao
> 
>>>> in notification mmu_notifier_invalidate_range_end with precised range, the range can
> But I don't think flush tlb only in the .invalidate_range_end() in
> secondary MMU is a good idea.
I have no good idea, and it beyond my ability to modify kvm framework now :(

> Flush must be done before kvm->mmu_lock is unlocked, otherwise,
> confusion will be caused when multiple threads trying to update the
> secondary MMU.
Since tlb flush is delayed after all pte entries are cleared, and currently
there is no tlb flush range supported for secondary mmu. I do know why there
is confusion before or after kvm->mmu_lock.

Regards
Bibo Mao
> 
>>>> be cross-range between range mmu_gather and mmu_notifier_range.
> 
> 


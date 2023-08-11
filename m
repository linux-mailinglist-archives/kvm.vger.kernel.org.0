Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07170778866
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 09:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjHKHku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 03:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjHKHkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 03:40:49 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FFF4E73;
        Fri, 11 Aug 2023 00:40:48 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8AxTev+5dVkiWYVAA--.40376S3;
        Fri, 11 Aug 2023 15:40:46 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxF8z95dVkupVUAA--.39429S3;
        Fri, 11 Aug 2023 15:40:45 +0800 (CST)
Message-ID: <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn>
Date:   Fri, 11 Aug 2023 15:40:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        mike.kravetz@oracle.com, apopple@nvidia.com, jgg@nvidia.com,
        rppt@kernel.org, akpm@linux-foundation.org, kevin.tian@intel.com,
        david@redhat.com
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <20230810090218.26244-1-yan.y.zhao@intel.com>
 <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn>
 <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxF8z95dVkupVUAA--.39429S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXr4xGw1UJr43Wry5Cw18CrX_yoWrJF17pF
        W3KFy7Kr4DXr1jyryjvw1DAry7Zr18Xa4fX343GF9Yy3s8Zr17Gr1xZ34kJryUJ34DXF1Y
        vF4qqa48uFyDZagCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2-VyUU
        UUU
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/8/11 11:45, Yan Zhao 写道:
>>> +static void kvm_mmu_notifier_numa_protect(struct mmu_notifier *mn,
>>> +					  struct mm_struct *mm,
>>> +					  unsigned long start,
>>> +					  unsigned long end)
>>> +{
>>> +	struct kvm *kvm = mmu_notifier_to_kvm(mn);
>>> +
>>> +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
>>> +	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
>>> +		return;
>>> +
>>> +	kvm_handle_hva_range(mn, start, end, __pte(0), kvm_unmap_gfn_range);
>>> +}
>> numa balance will scan wide memory range, and there will be one time
> Though scanning memory range is wide, .invalidate_range_start() is sent
> for each 2M range.
yes, range is huge page size when changing numa protection during numa scanning.

> 
>> ipi notification with kvm_flush_remote_tlbs. With page level notification,
>> it may bring out lots of flush remote tlb ipi notification.
> 
> Hmm, for VMs with assigned devices, apparently, the flush remote tlb IPIs
> will be reduced to 0 with this series.
> 
> For VMs without assigned devices or mdev devices, I was previously also
> worried about that there might be more IPIs.
> But with current test data, there's no more remote tlb IPIs on average.
> 
> The reason is below:
> 
> Before this series, kvm_unmap_gfn_range() is called for once for a 2M
> range.
> After this series, kvm_unmap_gfn_range() is called for once if the 2M is
> mapped to a huge page in primary MMU, and called for at most 512 times
> if mapped to 4K pages in primary MMU.
> 
> 
> Though kvm_unmap_gfn_range() is only called once before this series,
> as the range is blockable, when there're contentions, remote tlb IPIs
> can be sent page by page in 4K granularity (in tdp_mmu_iter_cond_resched())
I do not know much about x86, does this happen always or only need reschedule
from code?  so that there will be many times of tlb IPIs in only once function
call about kvm_unmap_gfn_range.

> if the pages are mapped in 4K in secondary MMU.
> 
> With this series, on the other hand, .numa_protect() sets range to be
> unblockable. So there could be less remote tlb IPIs when a 2M range is
> mapped into small PTEs in secondary MMU.
> Besides, .numa_protect() is not sent for all pages in a given 2M range.
No, .numa_protect() is not sent for all pages. It depends on the workload,
whether the page is accessed for different cpu threads cross-nodes.

> 
> Below is my testing data on a VM without assigned devices:
> The data is an average of 10 times guest boot-up.
>                    
>     data           | numa balancing caused  | numa balancing caused    
>   on average       | #kvm_unmap_gfn_range() | #kvm_flush_remote_tlbs() 
> -------------------|------------------------|--------------------------
> before this series |         35             |     8625                 
> after  this series |      10037             |     4610   
just be cautious, before the series there are  8625/35 = 246 IPI tlb flush ops
during one time kvm_unmap_gfn_range, is that x86 specific or generic? 

By the way are primary mmu and secondary mmu both 4K small page size "on average"?

Regards
Bibo Mao
              
> 
> For a single guest bootup,
>                    | numa balancing caused  | numa balancing caused    
>     best  data     | #kvm_unmap_gfn_range() | #kvm_flush_remote_tlbs() 
> -------------------|------------------------|--------------------------
> before this series |         28             |       13                  
> after  this series |        406             |      195                  
> 
>                    | numa balancing caused  | numa balancing caused    
>    worst  data     | #kvm_unmap_gfn_range() | #kvm_flush_remote_tlbs() 
> -------------------|------------------------|--------------------------
> before this series |         44             |    43920               
> after  this series |      17352             |     8668                 

> 
> 
>>
>> however numa balance notification, pmd table of vm maybe needs not be freed
>> in kvm_unmap_gfn_range.
>>
>  


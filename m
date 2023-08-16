Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6710B77D932
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 05:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241619AbjHPDpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 23:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241608AbjHPDom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 23:44:42 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A9CF26B9;
        Tue, 15 Aug 2023 20:44:31 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8BxY_AeRtxk3_4YAA--.51413S3;
        Wed, 16 Aug 2023 11:44:30 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDCMdRtxkIKxbAA--.9932S3;
        Wed, 16 Aug 2023 11:44:29 +0800 (CST)
Message-ID: <c8ccc8f1-300a-09be-db6b-df2a1dedd4cf@loongson.cn>
Date:   Wed, 16 Aug 2023 11:44:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Content-Language: en-US
From:   bibo mao <maobibo@loongson.cn>
To:     Sean Christopherson <seanjc@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com, david@redhat.com
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <20230810090218.26244-1-yan.y.zhao@intel.com>
 <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn>
 <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
 <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn>
 <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com> <ZNZshVZI5bRq4mZQ@google.com>
 <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com> <ZNpZDH9//vk8Rqvo@google.com>
 <ZNra3eDNTaKVc7MT@yzhao56-desk.sh.intel.com> <ZNuQ0grC44Dbh5hS@google.com>
 <107cdaaf-237f-16b9-ebe2-7eefd2b21f8f@loongson.cn>
In-Reply-To: <107cdaaf-237f-16b9-ebe2-7eefd2b21f8f@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxDCMdRtxkIKxbAA--.9932S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxuF1xJFWkXF48CFWfGry7twc_yoWrCr1Upa
        yrKay8tF4DJrZrC34ktw48AFy2ga92gF18Wry5K34qyFn8trnFkr4UtrZIkFyxArn5Xr1a
        qw4jqFsxua4UZagCm3ZEXasCq-sJn29KB7ZKAUJUUUUD529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
        6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
        1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jr9NsUUU
        UU=
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/8/16 10:43, bibo mao 写道:
> 
> 
> 在 2023/8/15 22:50, Sean Christopherson 写道:
>> On Tue, Aug 15, 2023, Yan Zhao wrote:
>>> On Mon, Aug 14, 2023 at 09:40:44AM -0700, Sean Christopherson wrote:
>>>>>> Note, I'm assuming secondary MMUs aren't allowed to map swap entries...
>>>>>>
>>>>>> Compile tested only.
>>>>>
>>>>> I don't find a matching end to each
>>>>> mmu_notifier_invalidate_range_start_nonblock().
>>>>
>>>> It pairs with existing call to mmu_notifier_invalidate_range_end() in change_pmd_range():
>>>>
>>>> 	if (range.start)
>>>> 		mmu_notifier_invalidate_range_end(&range);
>>> No, It doesn't work for mmu_notifier_invalidate_range_start() sent in change_pte_range(),
>>> if we only want the range to include pages successfully set to PROT_NONE.
>>
>> Precise invalidation was a non-goal for my hack-a-patch.  The intent was purely
>> to defer invalidation until it was actually needed, but still perform only a
>> single notification so as to batch the TLB flushes, e.g. the start() call still
>> used the original @end.
>>
>> The idea was to play nice with the scenario where nothing in a VMA could be migrated.
>> It was complete untested though, so it may not have actually done anything to reduce
>> the number of pointless invalidations.
> For numa-balance scenery, can original page still be used by application even if pte
> is changed with PROT_NONE?  If it can be used, maybe we can zap shadow mmu and flush tlb
Since there is kvm_mmu_notifier_change_pte notification when numa page is replaced with
new page, my meaning that can original page still be used by application even if pte
is changed with PROT_NONE and before replaced with new page?

And for primary mmu, tlb is flushed after pte is changed with PROT_NONE and 
after mmu_notifier_invalidate_range_end notification for secondary mmu.

Regards
Bibo Mao
> in notification mmu_notifier_invalidate_range_end with precised range, the range can
> be cross-range between range mmu_gather and mmu_notifier_range.
> 
> Regards
> Bibo Mao
>>
>>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>>> index 9e4cd8b4a202..f29718a16211 100644
>>>> --- a/arch/x86/kvm/mmu/mmu.c
>>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>>> @@ -4345,6 +4345,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>>>>  	if (unlikely(!fault->slot))
>>>>  		return kvm_handle_noslot_fault(vcpu, fault, access);
>>>>  
>>>> +	if (mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva))
>>>> +		return RET_PF_RETRY;
>>>> +
>>> This can effectively reduce the remote flush IPIs a lot!
>>> One Nit is that, maybe rmb() or READ_ONCE() is required for kvm->mmu_invalidate_range_start
>>> and kvm->mmu_invalidate_range_end.
>>> Otherwise, I'm somewhat worried about constant false positive and retry.
>>
>> If anything, this needs a READ_ONCE() on mmu_invalidate_in_progress.  The ranges
>> aren't touched when when mmu_invalidate_in_progress goes to zero, so ensuring they
>> are reloaded wouldn't do anything.  The key to making forward progress is seeing
>> that there is no in-progress invalidation.
>>
>> I did consider adding said READ_ONCE(), but practically speaking, constant false
>> positives are impossible.  KVM will re-enter the guest when retrying, and there
>> is zero chance of the compiler avoiding reloads across VM-Enter+VM-Exit.
>>
>> I suppose in theory we might someday differentiate between "retry because a different
>> vCPU may have fixed the fault" and "retry because there's an in-progress invalidation",
>> and not bother re-entering the guest for the latter, e.g. have it try to yield
>> instead.  
>>
>> All that said, READ_ONCE() on mmu_invalidate_in_progress should effectively be a
>> nop, so it wouldn't hurt to be paranoid in this case.
>>
>> Hmm, at that point, it probably makes sense to add a READ_ONCE() for mmu_invalidate_seq
>> too, e.g. so that a sufficiently clever compiler doesn't completely optimize away
>> the check.  Losing the check wouldn't be problematic (false negatives are fine,
>> especially on that particular check), but the generated code would *look* buggy.


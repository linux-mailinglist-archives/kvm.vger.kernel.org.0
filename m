Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BE7530D4D
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbiEWJ2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbiEWJ2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:28:11 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 173104755C;
        Mon, 23 May 2022 02:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=8lgLT
        VHt5fsC5K0SV0wgHt+zhEuifJz0vyvqOUOw1zQ=; b=lmGEh22dqallu5hpjSUMw
        7l2paGbeCgu94+rNkzWiAWkIT6iIAP2p6XL13zArOlZscjVz8vDpJVpCwT/AaQn+
        9U7bxbTOwY5dOyxHoE+prRcNW/ypIIu6cVN2JLedXEnvMWnWpg2Nd9nh4boswiNU
        jDsOYPrjEfNrmqF4C/kQgU=
Received: from [172.20.109.18] (unknown [116.128.244.169])
        by smtp5 (Coremail) with SMTP id HdxpCgAXlv2LU4timWBXDw--.1293S2;
        Mon, 23 May 2022 17:27:40 +0800 (CST)
Subject: Re: [PATCH] KVM: x86/mmu: optimizing the code in
 mmu_try_to_unsync_pages
To:     Sean Christopherson <seanjc@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220520060907.863136-1-luyun_611@163.com>
 <20220520095428.bahy37jxkznqtwx5@yy-desk-7060> <YoeqB2KAN/wsHMpk@google.com>
From:   Yun Lu <luyun_611@163.com>
Message-ID: <02b0b2de-2dd1-3a18-a679-0e8199db1530@163.com>
Date:   Mon, 23 May 2022 17:27:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YoeqB2KAN/wsHMpk@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: HdxpCgAXlv2LU4timWBXDw--.1293S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur1kur47CFWUJF4kCFy3Jwb_yoW5Jr13pr
        W8GFs3AF4YqrW3G3s29w1DG3s7urs7tF4UZr98Kas5ZwnF9rnxtry8G3WY9r93JryfGF1S
        va1Y9FW3uFn3JaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Ur-B_UUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: pox130jbwriqqrwthudrp/1tbiMhsKzlWBziNRmQAAsc
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/5/20 下午10:47, Sean Christopherson wrote:

> On Fri, May 20, 2022, Yuan Yao wrote:
>> On Fri, May 20, 2022 at 02:09:07PM +0800, Yun Lu wrote:
>>> There is no need to check can_unsync and prefetch in the loop
>>> every time, just move this check before the loop.
>>>
>>> Signed-off-by: Yun Lu <luyun@kylinos.cn>
>>> ---
>>>   arch/x86/kvm/mmu/mmu.c | 12 ++++++------
>>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index 311e4e1d7870..e51e7735adca 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -2534,6 +2534,12 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>>>   	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
>>>   		return -EPERM;
>>>
>>> +	if (!can_unsync)
>>> +		return -EPERM;
>>> +
>>> +	if (prefetch)
>>> +		return -EEXIST;
>>> +
>>>   	/*
>>>   	 * The page is not write-tracked, mark existing shadow pages unsync
>>>   	 * unless KVM is synchronizing an unsync SP (can_unsync = false).  In
>>> @@ -2541,15 +2547,9 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>>>   	 * allowing shadow pages to become unsync (writable by the guest).
>>>   	 */
>>>   	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
>>> -		if (!can_unsync)
>>> -			return -EPERM;
>>> -
>>>   		if (sp->unsync)
>>>   			continue;
>>>
>>> -		if (prefetch)
>>> -			return -EEXIST;
>>> -
>> Consider the case that for_each_gfn_indirect_valid_sp() loop is
>> not triggered, means the gfn is not MMU page table page:
>>
>> The old behavior when : return 0;
>> The new behavior with this change: returrn -EPERM / -EEXIST;
>>
>> It at least breaks FNAME(sync_page) -> make_spte(prefetch = true, can_unsync = false)
>> which removes PT_WRITABLE_MASK from last level mapping unexpectedly.
> Yep, the flags should be queried if and only if there's at least one valid, indirect
> SP for th gfn.  And querying whether there's such a SP is quite expesnive and requires
> looping over a list, so checking every iteration of the loop is far cheaper.  E.g. each
> check is a single uop on modern CPUs as both gcc and clang are smart enough to stash
> the flags in registers so that there's no reload from memory on each loop.  And that
> also means the CPU can more than likely correctly predict subsequent iterations.
OK, it's my mistake.  Thanks for your answers.


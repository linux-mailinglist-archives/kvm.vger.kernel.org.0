Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87D35FF80C
	for <lists+kvm@lfdr.de>; Sat, 15 Oct 2022 04:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiJOCjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 22:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiJOCje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 22:39:34 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97DD72B77;
        Fri, 14 Oct 2022 19:39:32 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mq6mD4VyszmVJx;
        Sat, 15 Oct 2022 10:34:52 +0800 (CST)
Received: from [10.174.151.185] (10.174.151.185) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 15 Oct 2022 10:39:30 +0800
Subject: Re: [PATCH] KVM: x86/mmu: use helper macro SPTE_ENT_PER_PAGE
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220913085452.25561-1-linmiaohe@huawei.com>
 <Yz4Qi7cn7TWTWQjj@google.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ab27ae74-b23a-9c23-a3c6-3328b0aa0f2f@huawei.com>
Date:   Sat, 15 Oct 2022 10:39:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <Yz4Qi7cn7TWTWQjj@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.151.185]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/10/6 7:17, Sean Christopherson wrote:
> On Tue, Sep 13, 2022, Miaohe Lin wrote:
>> Use helper macro SPTE_ENT_PER_PAGE to get the number of spte entries
>> per page. Minor readability improvement.
>>
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Many thanks for your review and comment. And sorry for late respond. A really busy week. :)

> 
>>  arch/x86/kvm/mmu/mmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 858bc53cfab4..45c532d00f78 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -1645,7 +1645,7 @@ static int is_empty_shadow_page(u64 *spt)
>>  	u64 *pos;
>>  	u64 *end;
>>  
>> -	for (pos = spt, end = pos + PAGE_SIZE / sizeof(u64); pos != end; pos++)
>> +	for (pos = spt, end = pos + SPTE_ENT_PER_PAGE; pos != end; pos++)
> 
> This is buried under MMU_DEBUG, and turning that on to compile test, which requires
> manually changing kernel code to enable, results in some minor warnings.  Given the
> existence of CONFIG_KVM_WERROR=y, I think it's safe to say this code hasn't been
> exercised in a very long time.  E.g. this is literally the first time I've actually
> enabled MMU_DEBUG.
> 
> This particular check seems like it would be quite useful, but the pgprintk() and
> rmap_printk() hooks, not so much.  E.g. the knob is too coarse grained, and many
> of the prints now have tracepoints.
> 
> So, unless someone actually actively uses MMU_DEBUG+dbg, I'm inclined to just delete
> pgprintk() and rmap_printk(), and then rename MMU_WARN_ON => KVM_MMU_WARN_ON and
> add a Kconfig for that, e.g. CONFIG_KVM_PROVE_MMU.
> 
> Hmm, and maybe clean up this helper too, e.g. get rid of the pointer arithmetic,
> and take the full kvm_mmu_page so that the error message can print out things like
> the gfn (a host kernel pointer is going to be useless for debug).
> 
> Thoughts?  Objections?

I tend to agree with you. MMU_DEBUG might even be an obsolete DEBUG component. I believe above
changes will improve the current code. Am I supposed to do this or will you kindly do this?

Thanks again,
Miaohe Lin



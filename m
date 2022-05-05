Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6184C51C0F6
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 15:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354819AbiEENlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 09:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiEENlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 09:41:37 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556B756C03;
        Thu,  5 May 2022 06:37:56 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nmbfl-0006wu-8K; Thu, 05 May 2022 15:37:37 +0200
Message-ID: <fdd2d7e2-cf7c-4bfd-39d2-af5a3cf60b26@maciej.szmigiero.name>
Date:   Thu, 5 May 2022 15:37:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] x86: Function missing integer return value
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, Li kunyu <kunyu@nfschina.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, seanjc@google.com
References: <20220505113218.93520-1-kunyu@nfschina.com>
 <ba469ccc-f5c4-248a-4c26-1cbf487fd62e@suse.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <ba469ccc-f5c4-248a-4c26-1cbf487fd62e@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5.05.2022 13:36, Juergen Gross wrote:
> On 05.05.22 13:32, Li kunyu wrote:
>> This function may need to return a value
>>
>> Signed-off-by: Li kunyu <kunyu@nfschina.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 64a2a7e2be90..68f33b932f94 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -6500,6 +6500,8 @@ static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
>>           kvm_recover_nx_lpages(kvm);
>>       }
>> +
>> +    return 0;
> 
> This statement is not reachable, so the patch is adding unneeded dead
> code only.

Maybe some static checker isn't smart enough to figure this out.

In this case it would probably be better to also change:
> if (kthread_should_stop())
>     return 0;

into:
> if (kthread_should_stop())
>     break;

so the newly introduced code isn't dead.

> Juergen

Thanks,
Maciej

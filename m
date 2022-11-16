Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169FF62B84D
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 11:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbiKPK3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 05:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbiKPK3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 05:29:05 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF552DAB6;
        Wed, 16 Nov 2022 02:25:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9144F2253F;
        Wed, 16 Nov 2022 10:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1668594343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1atUjbIyUaMaYihjlkpcyaP3lEClWkvRyG7NKN3Z3Q=;
        b=RNpR/Sx+Jg2uaRc88v7vhpfYpIqNjdv1Mn4X8/DF+sBZ3w8MDNxuji4tt62S3dQsV/tGZn
        m1BmTx12r9FVx7x9a3zAPONfWMmMzZWG4gxavxV7GHa0ZTQ8fpA5lH0iX5qOILYxKMnPnP
        03hojEgd4zE1lLbQQRWoUye7fFOYKWY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1668594343;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1atUjbIyUaMaYihjlkpcyaP3lEClWkvRyG7NKN3Z3Q=;
        b=ZvysxcSQhynBE1JO3p1uCaVafwuMj8wiR9T+Tu2wzUpu0cPDOaB1WDlT1DbWxTmlcuuDGD
        U6CxtA2uOiA1FRBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F338913480;
        Wed, 16 Nov 2022 10:25:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id exqhOqa6dGP6TgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 16 Nov 2022 10:25:42 +0000
Message-ID: <41b8c83e-2a1a-1dda-945e-99329ca8e7e9@suse.cz>
Date:   Wed, 16 Nov 2022 11:25:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     "Kalra, Ashish" <ashish.kalra@amd.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic> <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic> <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic> <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
 <9d9f1afe-c981-4df9-f012-89c4cb783cc3@amd.com>
 <973c6f79-38ad-aa30-bfec-c2a1c7db5d70@suse.cz>
 <8692e736-7518-d6d2-ae83-720e42e7a059@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <8692e736-7518-d6d2-ae83-720e42e7a059@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/22 11:19, Kalra, Ashish wrote:
> On 11/16/2022 3:08 AM, Vlastimil Babka wrote:
>> On 11/15/22 19:15, Kalra, Ashish wrote:
>>>
>>> On 11/15/2022 11:24 AM, Kalra, Ashish wrote:
>>>> Hello Vlastimil,
>>>>
>>>> On 11/15/2022 9:14 AM, Vlastimil Babka wrote:
>>>>> Cc'ing memory failure folks, the beinning of this subthread is here:
>>>>>
>>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra%40amd.com%2F&amp;data=05%7C01%7Cashish.kalra%40amd.com%7C38f8b76238014c67049308dac7b213a5%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638041865033588985%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=DDm7tZhUJLy%2BMzS1SXUnsBmBQnAI5dqR6tWZhCKRMEI%3D&amp;reserved=0
>>>>>
>>>>> On 11/15/22 00:36, Kalra, Ashish wrote:
>>>>>> Hello Boris,
>>>>>>
>>>>>> On 11/2/2022 6:22 AM, Borislav Petkov wrote:
>>>>>>> On Mon, Oct 31, 2022 at 04:58:38PM -0500, Kalra, Ashish wrote:
>>>>>>>>         if (snp_lookup_rmpentry(pfn, &rmp_level)) {
>>>>>>>>                do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
>>>>>>>>                return RMP_PF_RETRY;
>>>>>>>
>>>>>>> Does this issue some halfway understandable error message why the
>>>>>>> process got killed?
>>>>>>>
>>>>>>>> Will look at adding our own recovery function for the same, but that
>>>>>>>> will
>>>>>>>> again mark the pages as poisoned, right ?
>>>>>>>
>>>>>>> Well, not poisoned but PG_offlimits or whatever the mm folks agree upon.
>>>>>>> Semantically, it'll be handled the same way, ofc.
>>>>>>
>>>>>> Added a new PG_offlimits flag and a simple corresponding handler for it.
>>>>>
>>>>> One thing is, there's not enough page flags to be adding more (except
>>>>> aliases for existing) for cases that can avoid it, but as Boris says, if
>>>>> using alias to PG_hwpoison it depends what will become confused with the
>>>>> actual hwpoison.
>>>>>
>>>>>> But there is still added complexity of handling hugepages as part of
>>>>>> reclamation failures (both HugeTLB and transparent hugepages) and that
>>>>>> means calling more static functions in mm/memory_failure.c
>>>>>>
>>>>>> There is probably a more appropriate handler in mm/memory-failure.c:
>>>>>>
>>>>>> soft_offline_page() - this will mark the page as HWPoisoned and also has
>>>>>> handling for hugepages. And we can avoid adding a new page flag too.
>>>>>>
>>>>>> soft_offline_page - Soft offline a page.
>>>>>> Soft offline a page, by migration or invalidation, without killing
>>>>>> anything.
>>>>>>
>>>>>> So, this looks like a good option to call
>>>>>> soft_offline_page() instead of memory_failure() in case of
>>>>>> failure to transition the page back to HV/shared state via
>>>>>> SNP_RECLAIM_CMD
>>>>>> and/or RMPUPDATE instruction.
>>>>>
>>>>> So it's a bit unclear to me what exact situation we are handling here. The
>>>>> original patch here seems to me to be just leaking back pages that are
>>>>> unsafe for further use. soft_offline_page() seems to fit that scenario
>>>>> of a
>>>>> graceful leak before something is irrepairably corrupt and we page fault
>>>>> on it.
>>>>> But then in the thread you discus PF handling and killing. So what is the
>>>>> case here? If we detect this need to call snp_leak_pages() does it mean:
>>>>>
>>>>> a) nobody that could page fault at them (the guest?) is running
>>>>> anymore, we
>>>>> are tearing it down, we just can't reuse the pages further on the host
>>>>
>>>> The host can page fault on them, if anything on the host tries to write to
>>>> these pages. Host reads will return garbage data.
>>>>
>>>>> - seem like soft_offline_page() could work, but maybe we could just put
>>>>> the
>>>>> pages on some leaked lists without special page? The only thing that
>>>>> should
>>>>> matter is not to free the pages to the page allocator so they would be
>>>>> reused by something else.
>>>>>
>>>>> b) something can stil page fault at them (what?) - AFAIU can't be resolved
>>>>> without killing something, memory_failure() might limit the damage
>>>>
>>>> As i mentioned above, host writes will cause RMP violation page fault.
>>>>
>>>
>>> And to add here, if its a guest private page, then the above fault cannot be
>>> resolved, so the faulting process is terminated.
>>
>> BTW would this not be mostly resolved as part of rebasing to UPM?
>> - host will not have these pages mapped in the first place (both kernel
>> directmap and qemu userspace)
>> - guest will have them mapped, but I assume that the conversion from private
>> to shared (that might fail?) can only happen after guest's mappings are
>> invalidated in the first place?
>>
> 
> Yes, that will be true for guest private pages. But then there are host
> allocated pages for firmware use which will remain in firmware page state or
> reclaim state if they can't be transitioned back to HV/shared state once the
> firmware releases them back to the host and accessing them at this point can
> potentially cause RMP violation #PF.
> 
> Again i don't think this is going to happen regularly or frequently so it
> will be a rare error case where the page reclamation, i.e., the transition
> back to HV/shared state fails and now these pages are no longer safe to be
> used.
> 
> Referring back to your thoughts about putting these pages on some leaked
> pages list, do any such leaked pages list exist currently ?

Not AFAIK, you could just create a list_head somewhere appropriate (some snp
state structure?) and put the pages there, maybe with a counter exposed in
debugs. The point would be mostly that if something goes so wrong it would
be leaking substantial amounts of memory, we can at least recognize the
cause (but I suppose the dmesg will be also full of messages) and e.g. find
the pages in a crash dump.

> Thanks,
> Ashish
> 
>>>>
>>>>>>
>>>>>>>
>>>>>>>> Still waiting for some/more feedback from mm folks on the same.
>>>>>>>
>>>>>>> Just send the patch and they'll give it.
>>>>>>>
>>>>>>> Thx.
>>>>>>>
>>>>>
>>


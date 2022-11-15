Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA7629D13
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 16:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiKOPOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 10:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiKOPOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 10:14:45 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7285127FC5;
        Tue, 15 Nov 2022 07:14:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2A43D1F8D2;
        Tue, 15 Nov 2022 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1668525283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t/Ojq7esMZK1UpIZw2DCNQEYBbxO60KA3dy0uIVi5dI=;
        b=femMqr0zM7sK7IDyHk+wRHu13d6aqFkag91Q9FkaEeTOfVD3Ynz/2LW73N01t0fEgWC27H
        QuX31155LvxDVPPqvf2ijYDNEXVdxrDYHEog5E1T73IAix+8nUyqY59SdZ+mTBlxPVkCyi
        Oi/J7qttoGTmyV1M3XWeDVfeBmkOYxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1668525283;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t/Ojq7esMZK1UpIZw2DCNQEYBbxO60KA3dy0uIVi5dI=;
        b=W3Q9Q4+Juw62o7Z2XISJgT5h/Vrie6Hs9f4/wbuxSsfn9htzzZGtNAhMjPpllC/MGdPhjG
        KxESqqV+6aWKmlAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8953C13A91;
        Tue, 15 Nov 2022 15:14:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AqPDIOKsc2OiGAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 15 Nov 2022 15:14:42 +0000
Message-ID: <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
Date:   Tue, 15 Nov 2022 16:14:42 +0100
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
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
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

Cc'ing memory failure folks, the beinning of this subthread is here:

https://lore.kernel.org/all/3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com/

On 11/15/22 00:36, Kalra, Ashish wrote:
> Hello Boris,
> 
> On 11/2/2022 6:22 AM, Borislav Petkov wrote:
>> On Mon, Oct 31, 2022 at 04:58:38PM -0500, Kalra, Ashish wrote:
>>>       if (snp_lookup_rmpentry(pfn, &rmp_level)) {
>>>              do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
>>>              return RMP_PF_RETRY;
>>
>> Does this issue some halfway understandable error message why the
>> process got killed?
>>
>>> Will look at adding our own recovery function for the same, but that will
>>> again mark the pages as poisoned, right ?
>>
>> Well, not poisoned but PG_offlimits or whatever the mm folks agree upon.
>> Semantically, it'll be handled the same way, ofc.
> 
> Added a new PG_offlimits flag and a simple corresponding handler for it.

One thing is, there's not enough page flags to be adding more (except
aliases for existing) for cases that can avoid it, but as Boris says, if
using alias to PG_hwpoison it depends what will become confused with the
actual hwpoison.

> But there is still added complexity of handling hugepages as part of
> reclamation failures (both HugeTLB and transparent hugepages) and that
> means calling more static functions in mm/memory_failure.c
> 
> There is probably a more appropriate handler in mm/memory-failure.c:
> 
> soft_offline_page() - this will mark the page as HWPoisoned and also has
> handling for hugepages. And we can avoid adding a new page flag too.
> 
> soft_offline_page - Soft offline a page.
> Soft offline a page, by migration or invalidation, without killing anything.
> 
> So, this looks like a good option to call
> soft_offline_page() instead of memory_failure() in case of
> failure to transition the page back to HV/shared state via SNP_RECLAIM_CMD
> and/or RMPUPDATE instruction.

So it's a bit unclear to me what exact situation we are handling here. The
original patch here seems to me to be just leaking back pages that are
unsafe for further use. soft_offline_page() seems to fit that scenario of a
graceful leak before something is irrepairably corrupt and we page fault on it.
But then in the thread you discus PF handling and killing. So what is the
case here? If we detect this need to call snp_leak_pages() does it mean:

a) nobody that could page fault at them (the guest?) is running anymore, we
are tearing it down, we just can't reuse the pages further on the host
- seem like soft_offline_page() could work, but maybe we could just put the
pages on some leaked lists without special page? The only thing that should
matter is not to free the pages to the page allocator so they would be
reused by something else.

b) something can stil page fault at them (what?) - AFAIU can't be resolved
without killing something, memory_failure() might limit the damage

> Thanks,
> Ashish
> 
>>
>>> Still waiting for some/more feedback from mm folks on the same.
>>
>> Just send the patch and they'll give it.
>>
>> Thx.
>>


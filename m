Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BF7666593
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 22:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbjAKVYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 16:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235513AbjAKVYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 16:24:40 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7BB4087C;
        Wed, 11 Jan 2023 13:24:37 -0800 (PST)
Received: from [192.168.2.218] (unknown [109.252.117.89])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 95C896602DA2;
        Wed, 11 Jan 2023 21:24:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1673472276;
        bh=yjvk/0iHuNc/6gjXb7iSX0HCbGV45DhPyBUVGUboafg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=S2AAaU9eH0N/eTke6q3vQol0nEyoxzD+ib+vRiMLxKxzbOTNGmD32bFW/5pM9GCcx
         wTlRvYH1lYn4sow4cU8HytoxBVBX8yBiVtZ3wIujKwRfeqW1Y5ZrxCJqtxbDxh5Gp5
         DraN21bg3GYCJDG5nQ1/xK1/Lf4wjhBVUwxjUkAKfDAbi2NIawf2J7L170fePjY+uY
         PWa6T/JNGT0jwH6ZkO1oWRDVfHJDCEeb5v+63573hPDybMVWqxgQu8KBv2rC3RAyIx
         qd631w8Ey91yhCNY9/uLi/AwAxwZ8KmaigPHk1u7Y85uVelplDxi7z01upCcl4i/84
         NjMvujsiapnZw==
Message-ID: <77d0dece-8139-f292-a4de-84e91eaed64b@collabora.com>
Date:   Thu, 12 Jan 2023 00:24:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1] drm/ttm: Refcount allocated tail pages
To:     Sean Christopherson <seanjc@google.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc:     David Airlie <airlied@linux.ie>, Huang Rui <ray.huang@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Trigger Huang <Trigger.Huang@gmail.com>,
        Gert Wollny <gert.wollny@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>, kvm@vger.kernel.org,
        kernel@collabora.com, virtualization@lists.linux-foundation.org,
        Bob Beckett <bbeckett@collabora.com>
References: <8f749cd0-9a04-7c72-6a4f-a42d501e1489@amd.com>
 <5340d876-62b8-8a64-aa6d-7736c2c8710f@collabora.com>
 <594f1013-b925-3c75-be61-2d649f5ca54e@amd.com>
 <6893d5e9-4b60-0efb-2a87-698b1bcda63e@collabora.com>
 <73e5ed8d-0d25-7d44-8fa2-e1d61b1f5a04@amd.com>
 <c9d89644-409e-0363-69f0-a3b8f2ef0ae4@collabora.com>
 <6effcd33-8cc3-a4e0-3608-b9cef7a76da7@collabora.com>
 <ff28e1b4-cda2-14b8-b9bf-10706ae52cac@collabora.com>
 <48b5dd12-b0df-3cc6-a72d-f35156679844@collabora.com>
 <b1963713-4df6-956f-c16f-81a0cf1a978b@amd.com> <Y77sQZI0IfFVx7Jo@google.com>
Content-Language: en-US
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <Y77sQZI0IfFVx7Jo@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

On 1/11/23 20:05, Sean Christopherson wrote:
> On Thu, Aug 18, 2022, Christian König wrote:
>> Am 18.08.22 um 01:13 schrieb Dmitry Osipenko:
>>> On 8/18/22 01:57, Dmitry Osipenko wrote:
>>>> On 8/15/22 18:54, Dmitry Osipenko wrote:
>>>>> On 8/15/22 17:57, Dmitry Osipenko wrote:
>>>>>> On 8/15/22 16:53, Christian König wrote:
>>>>>>> Am 15.08.22 um 15:45 schrieb Dmitry Osipenko:
>>>>>>>> [SNIP]
>>>>>>>>> Well that comment sounds like KVM is doing the right thing, so I'm
>>>>>>>>> wondering what exactly is going on here.
>>>>>>>> KVM actually doesn't hold the page reference, it takes the temporal
>>>>>>>> reference during page fault and then drops the reference once page is
>>>>>>>> mapped, IIUC. Is it still illegal for TTM? Or there is a possibility for
>>>>>>>> a race condition here?
>>>>>>>>
>>>>>>> Well the question is why does KVM grab the page reference in the first
>>>>>>> place?
>>>>>>>
>>>>>>> If that is to prevent the mapping from changing then yes that's illegal
>>>>>>> and won't work. It can always happen that you grab the address, solve
>>>>>>> the fault and then immediately fault again because the address you just
>>>>>>> grabbed is invalidated.
>>>>>>>
>>>>>>> If it's for some other reason than we should probably investigate if we
>>>>>>> shouldn't stop doing this.
> 
> ...
> 
>>>>> If we need to bump the refcount only for VM_MIXEDMAP and not for
>>>>> VM_PFNMAP, then perhaps we could add a flag for that to the kvm_main
>>>>> code that will denote to kvm_release_page_clean whether it needs to put
>>>>> the page?
>>>> The other variant that kind of works is to mark TTM pages reserved using
>>>> SetPageReserved/ClearPageReserved, telling KVM not to mess with the page
>>>> struct. But the potential consequences of doing this are unclear to me.
>>>>
>>>> Christian, do you think we can do it?
>>> Although, no. It also doesn't work with KVM without additional changes
>>> to KVM.
>>
>> Well my fundamental problem is that I can't fit together why KVM is grabing
>> a page reference in the first place.
> 
> It's to workaround a deficiency in KVM.
> 
>> See the idea of the page reference is that you have one reference is that
>> you count the reference so that the memory is not reused while you access
>> it, e.g. for I/O or mapping it into different address spaces etc...
>>
>> But none of those use cases seem to apply to KVM. If I'm not totally
>> mistaken in KVM you want to make sure that the address space mapping, e.g.
>> the translation between virtual and physical address, don't change while you
>> handle it, but grabbing a page reference is the completely wrong approach
>> for that.
> 
> TL;DR: 100% agree, and we're working on fixing this in KVM, but were still months
> away from a full solution.
> 
> Yep.  KVM uses mmu_notifiers to react to mapping changes, with a few caveats that
> we are (slowly) fixing, though those caveats are only tangentially related.
> 
> The deficiency in KVM is that KVM's internal APIs to translate a virtual address
> to a physical address spit out only the resulting host PFN.  The details of _how_
> that PFN was acquired are not captured.  Specifically, KVM loses track of whether
> or not a PFN was acquired via gup() or follow_pte() (KVM is very permissive when
> it comes to backing guest memory).
> 
> Because gup() gifts the caller a reference, that means KVM also loses track of
> whether or not KVM holds a page refcount.  To avoid pinning guest memory, KVM does
> quickly put the reference gifted by gup(), but because KVM doesn't _know_ if it
> holds a reference, KVM uses a heuristic, which is essentially "is the PFN associated
> with a 'normal' struct page?".
> 
>    /*
>     * Returns a 'struct page' if the pfn is "valid" and backed by a refcounted
>     * page, NULL otherwise.  Note, the list of refcounted PG_reserved page types
>     * is likely incomplete, it has been compiled purely through people wanting to
>     * back guest with a certain type of memory and encountering issues.
>     */
>    struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn)
> 
> That heuristic also triggers if follow_pte() resolves to a PFN that is associated
> with a "struct page", and so to avoid putting a reference it doesn't own, KVM does
> the silly thing of manually getting a reference immediately after follow_pte().
> 
> And that in turn gets tripped up non-refcounted tail pages because KVM sees a
> normal, valid "struct page" and assumes it's refcounted.  To fudge around that
> issue, KVM requires "struct page" memory to be refcounted.
> 
> The long-term solution is to refactor KVM to precisely track whether or not KVM
> holds a reference.  Patches have been prosposed to do exactly that[1], but they
> were put on hold due to the aforementioned caveats with mmu_notifiers.  The
> caveats are that most flows where KVM plumbs a physical address into hardware
> structures aren't wired up to KVM's mmu_notifier.
> 
> KVM could support non-refcounted struct page memory without first fixing the
> mmu_notifier issues, but I was (and still am) concerned that that would create an
> even larger hole in KVM until the mmu_notifier issues are sorted out[2].
>  
> [1] https://lore.kernel.org/all/20211129034317.2964790-1-stevensd@google.com
> [2] https://lore.kernel.org/all/Ydhq5aHW+JFo15UF@google.com

Thanks for the summary! Indeed, it's the KVM side that needs to be
patched. Couple months ago I found that a non-TTM i915 driver also
suffers from the same problem because it uses huge pages that we want
map to a guest. So we definitely will need to fix the KVM side.

-- 
Best regards,
Dmitry


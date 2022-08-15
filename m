Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB9759328E
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 17:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiHOPyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 11:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiHOPyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 11:54:53 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8987217077;
        Mon, 15 Aug 2022 08:54:52 -0700 (PDT)
Received: from [192.168.2.145] (109-252-119-13.nat.spd-mgts.ru [109.252.119.13])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 37E3D6601DAE;
        Mon, 15 Aug 2022 16:54:50 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1660578891;
        bh=R9SmFeYZ1iN/MuMsg2JDoB8UWfkyjtJieOUNto4HnGc=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=Sq3+jVX9uKW2EvCZcTaUGXKBFblrK2ajudH7TdKurWfkYXP/ERVIA0JRHClwf0pYK
         xXhV2QbzM4Krsbu56L4ryvQZp1bm4oj5YzXdSauekrqt1dR6d/8nAwhKPq9x6qESqx
         Sd2lnyaLyP18BM0F0mIXv4zFvhWjiX8q6PM6WCRUlSrljEZ0Utd/V7h9t4WthO4ODF
         lI1hawKBM9898koa3SuQtvBu1Td29uudK3byjwnkGa6ithZrr+YwGSsXkmFC2K3Z3e
         68qt4nYuu47BwJGIYtOTmMXS9gPmcv6qZjGdjSNg5EHAKLhJZ6vRZ3ePMLWdzPBHq8
         008+F6NR/mUAw==
Message-ID: <6effcd33-8cc3-a4e0-3608-b9cef7a76da7@collabora.com>
Date:   Mon, 15 Aug 2022 18:54:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v1] drm/ttm: Refcount allocated tail pages
Content-Language: en-US
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, Huang Rui <ray.huang@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Trigger Huang <Trigger.Huang@gmail.com>,
        Gert Wollny <gert.wollny@collabora.com>,
        Antonio Caggiano <antonio.caggiano@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>, kvm@vger.kernel.org,
        kernel@collabora.com, virtualization@lists.linux-foundation.org
References: <20220815095423.11131-1-dmitry.osipenko@collabora.com>
 <8230a356-be38-f228-4a8e-95124e8e8db6@amd.com>
 <134bce02-58d6-8553-bb73-42dfda18a595@collabora.com>
 <8caf3008-dcf3-985a-631e-e019b277c6f0@amd.com>
 <4fcc4739-2da9-1b89-209c-876129604d7d@amd.com>
 <14be3b22-1d60-732b-c695-ddacc6b21055@collabora.com>
 <2df57a30-2afb-23dc-c7f5-f61c113dd5b4@collabora.com>
 <57562db8-bacf-e82d-8417-ab6343c1d2fa@amd.com>
 <86a87de8-24a9-3c53-3ac7-612ca97e41df@collabora.com>
 <8f749cd0-9a04-7c72-6a4f-a42d501e1489@amd.com>
 <5340d876-62b8-8a64-aa6d-7736c2c8710f@collabora.com>
 <594f1013-b925-3c75-be61-2d649f5ca54e@amd.com>
 <6893d5e9-4b60-0efb-2a87-698b1bcda63e@collabora.com>
 <73e5ed8d-0d25-7d44-8fa2-e1d61b1f5a04@amd.com>
 <c9d89644-409e-0363-69f0-a3b8f2ef0ae4@collabora.com>
In-Reply-To: <c9d89644-409e-0363-69f0-a3b8f2ef0ae4@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/15/22 17:57, Dmitry Osipenko wrote:
> On 8/15/22 16:53, Christian König wrote:
>> Am 15.08.22 um 15:45 schrieb Dmitry Osipenko:
>>> [SNIP]
>>>> Well that comment sounds like KVM is doing the right thing, so I'm
>>>> wondering what exactly is going on here.
>>> KVM actually doesn't hold the page reference, it takes the temporal
>>> reference during page fault and then drops the reference once page is
>>> mapped, IIUC. Is it still illegal for TTM? Or there is a possibility for
>>> a race condition here?
>>>
>>
>> Well the question is why does KVM grab the page reference in the first
>> place?
>>
>> If that is to prevent the mapping from changing then yes that's illegal
>> and won't work. It can always happen that you grab the address, solve
>> the fault and then immediately fault again because the address you just
>> grabbed is invalidated.
>>
>> If it's for some other reason than we should probably investigate if we
>> shouldn't stop doing this.
> 
> CC: +Paolo Bonzini who introduced this code
> 
> commit add6a0cd1c5ba51b201e1361b05a5df817083618
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Tue Jun 7 17:51:18 2016 +0200
> 
>     KVM: MMU: try to fix up page faults before giving up
> 
>     The vGPU folks would like to trap the first access to a BAR by setting
>     vm_ops on the VMAs produced by mmap-ing a VFIO device.  The fault
> handler
>     then can use remap_pfn_range to place some non-reserved pages in the
> VMA.
> 
>     This kind of VM_PFNMAP mapping is not handled by KVM, but follow_pfn
>     and fixup_user_fault together help supporting it.  The patch also
> supports
>     VM_MIXEDMAP vmas where the pfns are not reserved and thus subject to
>     reference counting.
> 
> @Paolo,
> https://lore.kernel.org/dri-devel/73e5ed8d-0d25-7d44-8fa2-e1d61b1f5a04@amd.com/T/#m7647ce5f8c4749599d2c6bc15a2b45f8d8cf8154
> 

If we need to bump the refcount only for VM_MIXEDMAP and not for
VM_PFNMAP, then perhaps we could add a flag for that to the kvm_main
code that will denote to kvm_release_page_clean whether it needs to put
the page?

-- 
Best regards,
Dmitry

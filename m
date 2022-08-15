Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E1D592E7A
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 13:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiHOLu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 07:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiHOLu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 07:50:27 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3A56598;
        Mon, 15 Aug 2022 04:50:25 -0700 (PDT)
Received: from [192.168.2.145] (109-252-119-13.nat.spd-mgts.ru [109.252.119.13])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 6F4AF6601DA5;
        Mon, 15 Aug 2022 12:50:23 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1660564224;
        bh=E8nqT1c6+89KY4W9Oy2uPm+ut6tNvo9I/f1SbKKEwcI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=V64QCit7+5r/d3HX1Qfm8ZX5xXKWNR1Upa7xN4BURysTKZ5LQO6zDzVB5EmjLbKr+
         ZZ2uxtjUqYpb/hG1bXXn1nN64kxrQKjNJJAsdLE0R5oRQmVBhXucZi6NtCirjwCmdh
         84fW4QvC599wgAYZfA8Ojfpbes6tC7tpG0m4cUZasCegbBuyECQ2gnRx/ByNn7r0+k
         qSuVBjTRTT6SUe4S7/pplCe11xB5ooy8dcxGELM3RI131PscdXJ+ewRA9Z1yAdCxL9
         U3Gl7UImm57hxrYbBL8GkRA18u/L7b9qIEiKrSjJsjDBli+lcJr7TDRIaKwTdEwrj5
         p1M9Z5zEoN9DA==
Message-ID: <5340d876-62b8-8a64-aa6d-7736c2c8710f@collabora.com>
Date:   Mon, 15 Aug 2022 14:50:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v1] drm/ttm: Refcount allocated tail pages
Content-Language: en-US
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, Huang Rui <ray.huang@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Trigger Huang <Trigger.Huang@gmail.com>,
        Gert Wollny <gert.wollny@collabora.com>,
        Antonio Caggiano <antonio.caggiano@collabora.com>
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
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <8f749cd0-9a04-7c72-6a4f-a42d501e1489@amd.com>
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

On 8/15/22 14:28, Christian König wrote:
>>>> Maybe it was discussed privately? In this case I will be happy to get
>>>> more info from you about the root of the problem so I could start to
>>>> look at how to fix it properly. It's not apparent where the problem is
>>>> to a TTM newbie like me.
>>>>
>>> Well this is completely unfixable. See the whole purpose of TTM is to
>>> allow tracing where what is mapped of a buffer object.
>>>
>>> If you circumvent that and increase the page reference yourself than
>>> that whole functionality can't work correctly any more.
>> Are you suggesting that the problem is that TTM doesn't see the KVM page
>> faults/mappings?
> 
> Yes, and no. It's one of the issues, but there is more behind that (e.g.
> what happens when TTM switches from pages to local memory for backing a
> BO).

If KVM page fault could reach TTM, then it should be able to relocate
BO. I see now where is the problem, thanks. Although, I'm wondering
whether it already works somehow.. I'll try to play with the the AMDGPU
shrinker and see what will happen on guest mapping of a relocated BO.

> Another question is why is KVM accessing the page structure in the first
> place? The VMA is mapped with VM_PFNMAP and VM_IO, KVM should never ever
> touch any of those pages.

https://elixir.bootlin.com/linux/v5.19/source/virt/kvm/kvm_main.c#L2549

-- 
Best regards,
Dmitry

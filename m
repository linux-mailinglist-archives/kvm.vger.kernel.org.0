Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB045592E0D
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 13:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiHOLTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 07:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiHOLTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 07:19:38 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67023193EB;
        Mon, 15 Aug 2022 04:19:34 -0700 (PDT)
Received: from [IPV6:2a00:5f00:102:0:10b3:10ff:fe5d:4ec1] (unknown [IPv6:2a00:5f00:102:0:10b3:10ff:fe5d:4ec1])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id F2F006601BAA;
        Mon, 15 Aug 2022 12:19:31 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1660562373;
        bh=7VDcfaY/61kZaEB/yFutUdzjWcyPgxyXS1ILuPerbbU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jk5DoI+IH5DYDThdYAo546xqwrzNCAlGeakw8UoWGqd8lV9gPA2b/KQ2YYWjGdqUA
         hmOdI4LhKNgbWTbZJnGvpI8USo6SvGUJYC2/kOzfe1jLwnIqNFVGLmJIbD9SVt0mPT
         3Z7ifO3oOZ9O//shzPPbcdg1fE59p8WVl5Pz7PDyNnZbBqpXysQFiiGWGuzQdMIbWH
         COLFjkRwkYNSw4fMMQlnXtHRjMVjiHrwHghVaz66ujxWugpReUYjFLzUybnU+Gd4J0
         okPvahpqO2uP+RBtORXRy6zurFHcO8Rct6B15w5znGEA6qIPyZttehvwgD5m+bfLft
         555lX0zRQXyaA==
Message-ID: <86a87de8-24a9-3c53-3ac7-612ca97e41df@collabora.com>
Date:   Mon, 15 Aug 2022 14:19:28 +0300
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
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <57562db8-bacf-e82d-8417-ab6343c1d2fa@amd.com>
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

On 8/15/22 13:51, Christian König wrote:
> Am 15.08.22 um 12:47 schrieb Dmitry Osipenko:
>> On 8/15/22 13:18, Dmitry Osipenko wrote:
>>> On 8/15/22 13:14, Christian König wrote:
>>>> Am 15.08.22 um 12:11 schrieb Christian König:
>>>>> Am 15.08.22 um 12:09 schrieb Dmitry Osipenko:
>>>>>> On 8/15/22 13:05, Christian König wrote:
>>>>>>> Am 15.08.22 um 11:54 schrieb Dmitry Osipenko:
>>>>>>>> Higher order pages allocated using alloc_pages() aren't
>>>>>>>> refcounted and
>>>>>>>> they
>>>>>>>> need to be refcounted, otherwise it's impossible to map them by
>>>>>>>> KVM. This
>>>>>>>> patch sets the refcount of the tail pages and fixes the KVM memory
>>>>>>>> mapping
>>>>>>>> faults.
>>>>>>>>
>>>>>>>> Without this change guest virgl driver can't map host buffers into
>>>>>>>> guest
>>>>>>>> and can't provide OpenGL 4.5 profile support to the guest. The host
>>>>>>>> mappings are also needed for enabling the Venus driver using
>>>>>>>> host GPU
>>>>>>>> drivers that are utilizing TTM.
>>>>>>>>
>>>>>>>> Based on a patch proposed by Trigger Huang.
>>>>>>> Well I can't count how often I have repeated this: This is an
>>>>>>> absolutely
>>>>>>> clear NAK!
>>>>>>>
>>>>>>> TTM pages are not reference counted in the first place and
>>>>>>> because of
>>>>>>> this giving them to virgl is illegal.
>>>>>> A? The first page is refcounted when allocated, the tail pages are
>>>>>> not.
>>>>> No they aren't. The first page is just by coincident initialized with
>>>>> a refcount of 1. This refcount is completely ignored and not used
>>>>> at all.
>>>>>
>>>>> Incrementing the reference count and by this mapping the page into
>>>>> some other address space is illegal and corrupts the internal state
>>>>> tracking of TTM.
>>>> See this comment in the source code as well:
>>>>
>>>>          /* Don't set the __GFP_COMP flag for higher order allocations.
>>>>           * Mapping pages directly into an userspace process and
>>>> calling
>>>>           * put_page() on a TTM allocated page is illegal.
>>>>           */
>>>>
>>>> I have absolutely no idea how somebody had the idea he could do this.
>>> I saw this comment, but it doesn't make sense because it doesn't explain
>>> why it's illegal. Hence it looks like a bogus comment since the
>>> refcouting certainly works, at least to a some degree because I haven't
>>> noticed any problems in practice, maybe by luck :)
>>>
>>> I'll try to dig out the older discussions, thank you for the quick
>>> reply!
>> Are you sure it was really discussed in public previously? All I can
>> find is yours two answers to a similar patches where you're saying that
>> this it's a wrong solution without in-depth explanation and further
>> discussions.
> 
> Yeah, that's my problem as well I can't find that of hand.
> 
> But yes it certainly was discussed in public.

If it was only CC'd to dri-devel, then could be that emails didn't pass
the spam moderation :/

>> Maybe it was discussed privately? In this case I will be happy to get
>> more info from you about the root of the problem so I could start to
>> look at how to fix it properly. It's not apparent where the problem is
>> to a TTM newbie like me.
>>
> 
> Well this is completely unfixable. See the whole purpose of TTM is to
> allow tracing where what is mapped of a buffer object.
> 
> If you circumvent that and increase the page reference yourself than
> that whole functionality can't work correctly any more.

Are you suggesting that the problem is that TTM doesn't see the KVM page
faults/mappings?

-- 
Best regards,
Dmitry

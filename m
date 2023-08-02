Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9B76C6F5
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 09:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbjHBHf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 03:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbjHBHfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 03:35:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1642F1BF6;
        Wed,  2 Aug 2023 00:35:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92E6F61841;
        Wed,  2 Aug 2023 07:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A9DC433C7;
        Wed,  2 Aug 2023 07:34:56 +0000 (UTC)
Message-ID: <364ea644-1b2c-472a-92da-9435f2795a89@xs4all.nl>
Date:   Wed, 2 Aug 2023 09:34:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 01/47] media/vivid: Use fbdev I/O helpers
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>, deller@gmx.de,
        javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20230801101541.900-1-tzimmermann@suse.de>
 <20230801101541.900-2-tzimmermann@suse.de>
 <ee03c6c9-4e6a-2732-0416-43fd5418c950@xs4all.nl>
 <0f2521b6-3d72-923c-df89-d94ca7f2fe52@suse.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <0f2521b6-3d72-923c-df89-d94ca7f2fe52@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/08/2023 18:54, Thomas Zimmermann wrote:
> Hi
> 
> Am 01.08.23 um 13:22 schrieb Hans Verkuil:
>> On 01/08/2023 12:13, Thomas Zimmermann wrote:
>>> Set struct fb_ops and with FB_DEFAULT_IO_OPS, fbdev's initializer
>>> for I/O memory. Sets the callbacks to the cfb_ and fb_io_ functions.
>>> Select the correct modules with Kconfig's FB_IO_HELPERS token.
>>>
>>> The macro and token set the currently selected values, so there is
>>> no functional change.
>>>
>>> v2:
>>>     * updated to use _IOMEM_ tokens
>>>
>>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>> Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
>>> Acked-by: Helge Deller <deller@gmx.de>
>>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>>> ---
>>>   drivers/media/test-drivers/vivid/Kconfig     | 4 +---
>>>   drivers/media/test-drivers/vivid/vivid-osd.c | 4 +---
>>>   2 files changed, 2 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/media/test-drivers/vivid/Kconfig b/drivers/media/test-drivers/vivid/Kconfig
>>> index 318799d317ba..5b08a5ad291e 100644
>>> --- a/drivers/media/test-drivers/vivid/Kconfig
>>> +++ b/drivers/media/test-drivers/vivid/Kconfig
>>> @@ -3,11 +3,9 @@ config VIDEO_VIVID
>>>       tristate "Virtual Video Test Driver"
>>>       depends on VIDEO_DEV && !SPARC32 && !SPARC64 && FB
>>>       depends on HAS_DMA
>>> +    select FB_IOMEM_HELPERS
>>>       select FONT_SUPPORT
>>>       select FONT_8x16
>>> -    select FB_CFB_FILLRECT
>>> -    select FB_CFB_COPYAREA
>>> -    select FB_CFB_IMAGEBLIT
>>>       select VIDEOBUF2_VMALLOC
>>>       select VIDEOBUF2_DMA_CONTIG
>>>       select VIDEO_V4L2_TPG
>>> diff --git a/drivers/media/test-drivers/vivid/vivid-osd.c b/drivers/media/test-drivers/vivid/vivid-osd.c
>>> index 051f1805a16d..5c931b94a7b5 100644
>>> --- a/drivers/media/test-drivers/vivid/vivid-osd.c
>>> +++ b/drivers/media/test-drivers/vivid/vivid-osd.c
>>> @@ -246,12 +246,10 @@ static int vivid_fb_blank(int blank_mode, struct fb_info *info)
>>>     static const struct fb_ops vivid_fb_ops = {
>>>       .owner = THIS_MODULE,
>>> +    FB_DEFAULT_IOMEM_OPS,
>>
>> This macro also sets fb_read and fb_write ops here, in addition to the
>> cfb_* ops, based on this patch:
>>
>> https://lore.kernel.org/all/20230729193157.15446-2-tzimmermann@suse.de/#Z2e.:20230729193157.15446-2-tzimmermann::40suse.de:1include:linux:fb.h
>>
>> But those two ops were never set in this driver before.
>>
>> It's been ages since I last worked with this, so I can't tell whether that's
>> good or bad, all I know is that it makes what appears to be a functional change.
>>
>> Can you explain a bit more? Am I missing something?
> 
> That change is intentional and welcome. If no fb_read/fb_write pointers are given fbdev uses them as their default. See
> 
> 
> https://elixir.bootlin.com/linux/v6.5-rc1/source/drivers/video/fbdev/core/fbmem.c#L773
> 
> and below. Once all drivers set these pointers explicitly, we can drop the default and make the helpers optional and modular. For the drivers in this patchset there's no functional change.

Ah, that explains it!

I wonder if it wouldn't be a good idea to include that information in the commit log.

In any case, for this patch:

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> 
> Best regards
> Thomas
> 
>>
>> Regards,
>>
>>     Hans
>>
>>>       .fb_check_var   = vivid_fb_check_var,
>>>       .fb_set_par     = vivid_fb_set_par,
>>>       .fb_setcolreg   = vivid_fb_setcolreg,
>>> -    .fb_fillrect    = cfb_fillrect,
>>> -    .fb_copyarea    = cfb_copyarea,
>>> -    .fb_imageblit   = cfb_imageblit,
>>>       .fb_cursor      = NULL,
>>>       .fb_ioctl       = vivid_fb_ioctl,
>>>       .fb_pan_display = vivid_fb_pan_display,
>>
> 


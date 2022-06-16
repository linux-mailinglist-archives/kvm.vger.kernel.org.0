Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DA454ED2F
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 00:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378859AbiFPWSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 18:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiFPWSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 18:18:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C575060041
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 15:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655417891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9DWpHhljjMLBCYm+B5HqD4SLrNJSN/X7QHRnWVk9iss=;
        b=e9zS0j//AEAuZs8NfvfGHGNOHnPBsqgn962EbFQjhxfWmd61jxwbJZ4fGIZnDCG5FU2MvX
        4YFDMvIsIj77eM+TGnXWqyRhzLVD+0v98WVstJdT1Qxi/72noKYArzokoZCfx7uTwyGR9W
        offrOwc7v2rckRDarrYIs54aeM/5Vpw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-wp9qcvtCPoKeVUx-w0eenA-1; Thu, 16 Jun 2022 18:18:10 -0400
X-MC-Unique: wp9qcvtCPoKeVUx-w0eenA-1
Received: by mail-wm1-f71.google.com with SMTP id m22-20020a7bcb96000000b0039c4f6ade4dso1100814wmi.8
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 15:18:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9DWpHhljjMLBCYm+B5HqD4SLrNJSN/X7QHRnWVk9iss=;
        b=iPPjozpIIMA/MEUcIS9cWEOhbheofSo9hUnS8PS95yJDiiI3QBdpYe2yhHNtkqmiYy
         YFc6LR4EOYBflOIskmv9CpZWOhaZwwIKti2MDudnKgqu+QzaKUjNAGhPwlNu9kf7rs68
         CnxhJxwhgopQ9LS9nqu+hhYA0fjpLwCk1qRQq2xp0AkwP3ihwFyIOTZTpPS8bWFjROKV
         MEqGPUoT0TX5WzET5RD70jKsJ/DysCGPL0WogSFcxwQh3mwRXo0n/oSh96OXO6LbEo06
         vfDI5Z4rVX5HyrTxdwo4I/oTy65qoSBvGRvOJ53gLWs4dBJjIUMImn5maAOgmS8Lmp9G
         M+JA==
X-Gm-Message-State: AJIora8WRAs7ejeLlBlhu41BXKCRnjnG6CFitFmxKMN/2Gqm2skHoLUC
        N0cgNRcIeDl8kwPkWChRS02yCzRM79qC/kCCth8X303mPKlqt7c6lePCr2N7FwvcF9bx6DnWT4d
        XXnm7RCP5AYZs
X-Received: by 2002:adf:e181:0:b0:213:bbe1:ba66 with SMTP id az1-20020adfe181000000b00213bbe1ba66mr6215478wrb.325.1655417887946;
        Thu, 16 Jun 2022 15:18:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uO1cJJMNUcHhX2JKlWJowzj7WQI64QGyPrnUyRc32kSMp0t+NjedvVfCVD7/vwLeNG3ZUpmw==
X-Received: by 2002:adf:e181:0:b0:213:bbe1:ba66 with SMTP id az1-20020adfe181000000b00213bbe1ba66mr6215452wrb.325.1655417887629;
        Thu, 16 Jun 2022 15:18:07 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id l15-20020a05600c2ccf00b003974a00697esm7435615wmc.38.2022.06.16.15.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 15:18:07 -0700 (PDT)
Message-ID: <a633d605-4cb3-2e04-1818-85892cf6f7b0@redhat.com>
Date:   Fri, 17 Jun 2022 00:18:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 3/5] fbdev: Disable sysfb device registration when
 removing conflicting FBs
Content-Language: en-US
To:     Zack Rusin <zackr@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "lersek@redhat.com" <lersek@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "deller@gmx.de" <deller@gmx.de>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>
References: <20220607182338.344270-1-javierm@redhat.com>
 <20220607182338.344270-4-javierm@redhat.com>
 <de83ae8cb6de7ee7c88aa2121513e91bb0a74608.camel@vmware.com>
 <38473dcd-0666-67b9-28bd-afa2d0ce434a@redhat.com>
 <603e3613b9b8ff7815b63f294510d417b5b12937.camel@vmware.com>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <603e3613b9b8ff7815b63f294510d417b5b12937.camel@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/16/22 23:03, Zack Rusin wrote:
> On Thu, 2022-06-16 at 21:55 +0200, Javier Martinez Canillas wrote:
>> Hello Zack,
>>
>> On 6/16/22 21:29, Zack Rusin wrote:
>>> On Tue, 2022-06-07 at 20:23 +0200, Javier Martinez Canillas wrote:
>>>> The platform devices registered by sysfb match with firmware-based DRM or
>>>> fbdev drivers, that are used to have early graphics using a framebuffer
>>>> provided by the system firmware.
>>>>
>>
>> [snip]
>>
>>>
>>> Hi, Javier.
>>>
>>> This change broke arm64 with vmwgfx. We get a kernel oops at boot (let me know if
>>> you'd like .config or just have us test something directly for you):
>>>
>>
>> Yes please share your .config and I'll try to reproduce on an arm64 machine.
> 
> Attached. It might be a little hard to reproduce unless you have an arm64 machine
> with a dedicated gpu. You'll need a system that actually transitions from a generic
> fb driver (e.g. efifb) to the dedicated one.
>

Yes, all my testing for this was done with a rpi4 so I should be able to reproduce
that case. I'm confused though because I tested efifb -> vc4, simplefb -> vc4 and
simpledrm -> vc4.
 
>>>
>>>  Unable to handle kernel NULL pointer dereference at virtual address
>>> 0000000000000008
>>>  Mem abort info:
>>>    ESR = 0x96000004
>>>    EC = 0x25: DABT (current EL), IL = 32 bits
>>>    SET = 0, FnV = 0
>>>    EA = 0, S1PTW = 0
>>>    FSC = 0x04: level 0 translation fault
>>>  Data abort info:
>>>    ISV = 0, ISS = 0x00000004
>>>    CM = 0, WnR = 0
>>>  user pgtable: 4k pages, 48-bit VAs, pgdp=00000001787ee000
>>>  [0000000000000008] pgd=0000000000000000, p4d=0000000000000000
>>>  Internal error: Oops: 96000004 [#1] SMP
>>>  Modules linked in: vmwgfx(+) e1000e(+) nvme ahci(+) xhci_pci drm_ttm_helper ttm
>>> sha256_arm64 sha1_ce nvme_core xhci_pci_renesas aes_neon_bs aes_neon_blk aes>
>>>  CPU: 3 PID: 215 Comm: systemd-udevd Tainted: G     U            5.18.0-rc5-vmwgfx
>>> #12
>>
>> I'm confused, your kernel version seems to be 5.18.0-rc5 but this patch
>> is only in drm-misc-next now and will land in 5.20...
>>
>> Did you backport it? Can you please try to reproduce with latest drm-tip ?
> 
> No, this is drm-misc-next as of yesterday. drm-misc-next was still on 5.18.0-rc5
> yesterday.
> 

Right! I looked at the base for drm-tip but forgot that drm-misc was still on 5.18.

I'll look at this tomorrow but in the meantime, could you please look if the following
commits on top of drm-misc-next help ?

d258d00fb9c7 fbdev: efifb: Cleanup fb_info in .fb_destroy rather than .remove
1b5853dfab7f fbdev: efifb: Fix a use-after-free due early fb_info cleanup

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4259454EA69
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 21:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbiFPTze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 15:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377772AbiFPTzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 15:55:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EE07546B0
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 12:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655409331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ys2keuyjGOnYxAsZaMh0khOvW2SYs1SLvLOIoAesU54=;
        b=bBVX4I5EyF4SaS6q3UCYTcYjiIB7wmUzbgnYrPBpckOtTxCZjLT6oMJf5ExQ+65OgqIK/z
        AxWrbzJPrz9/D5fPoO103/zmBmEW0o9KZEPYdqV+lMmi3Z7VLPXQH1wAyl5wGsNC3vTPH5
        JryzyK2hZpyHTDt14WQ1H6Z/5+JnuTM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-19u7fjckPT6tRP0sKGqhUA-1; Thu, 16 Jun 2022 15:55:30 -0400
X-MC-Unique: 19u7fjckPT6tRP0sKGqhUA-1
Received: by mail-wm1-f72.google.com with SMTP id m22-20020a7bcb96000000b0039c4f6ade4dso994148wmi.8
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 12:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ys2keuyjGOnYxAsZaMh0khOvW2SYs1SLvLOIoAesU54=;
        b=ZMnYyluSPaXocg8Aen5i0fQnozA8xg5QTe5IIaaDxJ95SepPLHOFlTwcCRK1bG5ME8
         DMcoVq7sj0QawrYDKolu6X3AwHFYTK0HFdr4cLLccz1LNA8HXgd8OC0a0eoR91iC0q3T
         ZkmO8PzY2jJuS5GAeliGbqZAgdys+UXsFnmgxPoObifGlR30JwKJ+JgCzeA1CZc0M204
         XXnXCx0QEiElMJ6veNXqr02XRq7hZT5KTxdt/w1JAbPgn4OlZN6Mdes6BY1GMRHUvHzi
         5enCwdeBDTdEKv78fpVvYTYZfGoXWsg1JObGnzMLsAYzduisn3jiHxn51yzI/PELGlyP
         16sA==
X-Gm-Message-State: AOAM530VjnDZw+q30MRWG87cA+nQdn4kVbkO9lCatK8NAjYs1+btAN/V
        GrTyzrF/IBdYuk6PdRrkTfMIGf51x92lcwyBMWVsj7Uoeu8Whic6yapl8wmx+W3xNXqW237KKS1
        WH3hI0Sqs5g2h
X-Received: by 2002:a05:600c:294a:b0:39c:4df5:f825 with SMTP id n10-20020a05600c294a00b0039c4df5f825mr17322093wmd.55.1655409326743;
        Thu, 16 Jun 2022 12:55:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwR8ZU9QDRz515iHBXgPuPCog+HviQMDV3yKwqceawwks+wUtwyLzvQ0pWFkTp40mYRTIYHHg==
X-Received: by 2002:a05:600c:294a:b0:39c:4df5:f825 with SMTP id n10-20020a05600c294a00b0039c4df5f825mr17322057wmd.55.1655409326396;
        Thu, 16 Jun 2022 12:55:26 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id b17-20020a5d6351000000b0020fee88d0f2sm3262351wrw.0.2022.06.16.12.55.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 12:55:25 -0700 (PDT)
Message-ID: <38473dcd-0666-67b9-28bd-afa2d0ce434a@redhat.com>
Date:   Thu, 16 Jun 2022 21:55:24 +0200
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
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <de83ae8cb6de7ee7c88aa2121513e91bb0a74608.camel@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Zack,

On 6/16/22 21:29, Zack Rusin wrote:
> On Tue, 2022-06-07 at 20:23 +0200, Javier Martinez Canillas wrote:
>> The platform devices registered by sysfb match with firmware-based DRM or
>> fbdev drivers, that are used to have early graphics using a framebuffer
>> provided by the system firmware.
>>

[snip]

> 
> Hi, Javier.
> 
> This change broke arm64 with vmwgfx. We get a kernel oops at boot (let me know if
> you'd like .config or just have us test something directly for you):
>

Yes please share your .config and I'll try to reproduce on an arm64 machine.

> 
>  Unable to handle kernel NULL pointer dereference at virtual address
> 0000000000000008
>  Mem abort info:
>    ESR = 0x96000004
>    EC = 0x25: DABT (current EL), IL = 32 bits
>    SET = 0, FnV = 0
>    EA = 0, S1PTW = 0
>    FSC = 0x04: level 0 translation fault
>  Data abort info:
>    ISV = 0, ISS = 0x00000004
>    CM = 0, WnR = 0
>  user pgtable: 4k pages, 48-bit VAs, pgdp=00000001787ee000
>  [0000000000000008] pgd=0000000000000000, p4d=0000000000000000
>  Internal error: Oops: 96000004 [#1] SMP
>  Modules linked in: vmwgfx(+) e1000e(+) nvme ahci(+) xhci_pci drm_ttm_helper ttm
> sha256_arm64 sha1_ce nvme_core xhci_pci_renesas aes_neon_bs aes_neon_blk aes>
>  CPU: 3 PID: 215 Comm: systemd-udevd Tainted: G     U            5.18.0-rc5-vmwgfx
> #12

I'm confused, your kernel version seems to be 5.18.0-rc5 but this patch
is only in drm-misc-next now and will land in 5.20...

Did you backport it? Can you please try to reproduce with latest drm-tip ?

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat


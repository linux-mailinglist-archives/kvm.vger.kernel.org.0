Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40BA54F130
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 08:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243756AbiFQGqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 02:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380317AbiFQGq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 02:46:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04ED15716E
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 23:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655448384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hQ4DbL4FBpOEp/E50yBIWWCZyfpTsZUOXGgMRiUx5A=;
        b=G1/pTfJy2OCbNrOSW32zfzuZAFdZaPiOsJXyl2USrFCmRbPY1pXGP+P9GxIqXw6RkYByLN
        zK+B2tY5FTOfwBmrSoYilg6NADCHv57rNWM/cT5r08jKhHTKWsugtC7FYt/Pak7tFBfv60
        pfZrnXS5U4ynkaxus3uyZ4vU1Jyf9Ns=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-pZUU8KuSM6ijb5OBs_k03A-1; Fri, 17 Jun 2022 02:46:22 -0400
X-MC-Unique: pZUU8KuSM6ijb5OBs_k03A-1
Received: by mail-wm1-f72.google.com with SMTP id z13-20020a7bc7cd000000b0039c4a238eadso1265890wmk.9
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 23:46:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+hQ4DbL4FBpOEp/E50yBIWWCZyfpTsZUOXGgMRiUx5A=;
        b=QszocJlCAt2fN6g/7fNQ6RmhshLvBjpWA7UQVmH8irOzBHYEh5bF5Ox+y0BbJ9QoMt
         JNM/03DXjQbJxwcVdP9hkU7czCyqsayOa4GIwhRDy2gWjY7ZJBQkGF8263tRrAhWsOt+
         QpmAi9fBiSDgzEjmLziRvkRu03s6O2XmB4rR13aPiHHTiaHSmTYjXpZTdZS91r/Wj5Xw
         cp923QSSlJNcgCgI/hWh3ZwOydoylOt2nkR2YtAzXWB9YcMgyT5GyA2Rk/4WnsqIYXqh
         +Bu0SJxzklG3E/8xON/DqEFG/hSYQ2K0aED15161BlfCV7qdV7P0IMiPamA7sjhRwazQ
         CS5w==
X-Gm-Message-State: AJIora+KDXuQi4TS0+Q/pH6ynDzuUuMs6GEypGFZuIhYBw8bLJe6tGL2
        tvZN+v7jQbBvEX4lGM/r9CpwH+MAJPhwe270Bj1ktrCStMvFY5mZ8NP/zfAL3ITYmrcYm+2MEKo
        sTacvs0oedzBx
X-Received: by 2002:a05:600c:3489:b0:39d:b58f:6797 with SMTP id a9-20020a05600c348900b0039db58f6797mr8604230wmq.205.1655448381561;
        Thu, 16 Jun 2022 23:46:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sQ/maUwRNsLJ+dTUUPQVEZ65LnPBk/IMQjAM9szqh0Rf1kxBOzJQNiJ8h903v4iEFev4ehFw==
X-Received: by 2002:a05:600c:3489:b0:39d:b58f:6797 with SMTP id a9-20020a05600c348900b0039db58f6797mr8604207wmq.205.1655448381308;
        Thu, 16 Jun 2022 23:46:21 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c4e8b00b003973a3fe4fasm4787183wmq.42.2022.06.16.23.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 23:46:20 -0700 (PDT)
Message-ID: <aa144e20-a555-5c30-4796-09713c12ab0e@redhat.com>
Date:   Fri, 17 Jun 2022 08:46:18 +0200
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
 <a633d605-4cb3-2e04-1818-85892cf6f7b0@redhat.com>
 <97565fb5-cf7f-5991-6fb3-db96fe239ee8@redhat.com>
 <711c88299ef41afd8556132b7c1dcb75ee7e6117.camel@vmware.com>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <711c88299ef41afd8556132b7c1dcb75ee7e6117.camel@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Zack,

On 6/17/22 03:35, Zack Rusin wrote:
> On Fri, 2022-06-17 at 01:21 +0200, Javier Martinez Canillas wrote:
>> On 6/17/22 00:18, Javier Martinez Canillas wrote:
>>> On 6/16/22 23:03, Zack Rusin wrote:
>>
>> [snip]
>>
>>>
>>> I'll look at this tomorrow but in the meantime, could you please look if the following
>>> commits on top of drm-misc-next help ?
>>>
>>> d258d00fb9c7 fbdev: efifb: Cleanup fb_info in .fb_destroy rather than .remove
>>> 1b5853dfab7f fbdev: efifb: Fix a use-after-free due early fb_info cleanup
>>>
>>
>> Scratch that. I see in your config now that you are not using efifb but instead
>> simpledrm: CONFIG_DRM_SIMPLEDRM=y, CONFIG_SYSFB_SIMPLEFB=y and CONFIG_DRM_VMWGFX.
>>
>> Since you mentioned efifb I misunderstood that you are using it. Anyways, as
>> said I'll investigate this tomorrow.
> 
> Sounds good. Let me know if you'd like me to try it without SIMPLEFB.
>

Yes, please do. Either with CONFIG_SYSFB_SIMPLEFB disabled and CONFIG_FB_EFI
enabled (so that "efi-framebuffer" is registered and efifb probed) or with
CONFIG_SYSFB_SIMPLEFB but CONFIG_FB_SIMPLE enabled (so "simple-framebuffer
is used too but with simplefb instead of simpledrm).
 
I'm not able to reproduce, it would be useful to have another data point.

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C338354EDD7
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 01:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379384AbiFPXVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 19:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378901AbiFPXVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 19:21:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AD3962BC0
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 16:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655421682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Sk05nK8yr31d0PfEhMiImAlc8BO2DlseMPnx7U4OyI=;
        b=EvVNDX0+d/ibOTI3v/x09FUZYtvzU7jEKVBJov68pNKQDLrz9B33dM0cYskN7ZEsfYmA8t
        T99scoEO9FHxpyYfV+BRMSqIkLsEsczQSP/hkIkxx+TzQqaAS9x27vUVBKiNNjUtk/UeNl
        IYW6WptacsMSzolTVWsdPlw0WnNxIfA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-nSrJvMX9PZaVQsBSMGAd3w-1; Thu, 16 Jun 2022 19:21:21 -0400
X-MC-Unique: nSrJvMX9PZaVQsBSMGAd3w-1
Received: by mail-wm1-f69.google.com with SMTP id l3-20020a05600c1d0300b0039c7efa2526so1480531wms.3
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 16:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=7Sk05nK8yr31d0PfEhMiImAlc8BO2DlseMPnx7U4OyI=;
        b=i6NNai7oCOU2x95bnKvzaHjpJ5kL6BPKCMzS66yMY+OVNDJfu6HgvXi6NdhsMCHwRD
         Xdh+PwfYQB7n43KR63RE/QD1vp9rV3I7rEkop4MJb2dtVWRC690F+NvWoO6gP9x8yQqS
         3ralD8o4dmn4kKL+Jh+4K6FYCfDdrzvkmLI5MDG8S3kbsyHT2TrMrI/GBExRUkkoFHZs
         q0QZTsz6pJ/k77L59N22Uvan6VeZcKdlArGUNqvqpAcjCpPrCXXM5MSj1z7Z60NknygY
         C0qqgLvEGnYIpUVEbrM+Z5bIZAlrZQMo2XWE6QMieoEO0Sv15M/I7BcaHv+BEwchUmzH
         otIg==
X-Gm-Message-State: AJIora/BQ8syEdGiHwuG37EdKU4eI7/XZeozNdlHxTbqZUyCw7OI4YWx
        yIjfXZInD/I9gpx9LPvD8rw6kAyyqnwt8Hkc2oEuFnWExxkgJ1XQAGgDvz5mAST9AdLACqk/yy/
        IePcDMbaYFEdw
X-Received: by 2002:adf:dd50:0:b0:21a:ba8:6c8d with SMTP id u16-20020adfdd50000000b0021a0ba86c8dmr6836474wrm.133.1655421680442;
        Thu, 16 Jun 2022 16:21:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sb3IFUqs3ZqGZX9qvUxp1wuRL6DIG8sHZblCmseyvlgwUjG0m1h+TgWCsvv3Al2+33swPkSg==
X-Received: by 2002:adf:dd50:0:b0:21a:ba8:6c8d with SMTP id u16-20020adfdd50000000b0021a0ba86c8dmr6836452wrm.133.1655421680150;
        Thu, 16 Jun 2022 16:21:20 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id r15-20020a05600c35cf00b0039c4ff5e0a7sm3658603wmq.38.2022.06.16.16.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 16:21:19 -0700 (PDT)
Message-ID: <97565fb5-cf7f-5991-6fb3-db96fe239ee8@redhat.com>
Date:   Fri, 17 Jun 2022 01:21:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 3/5] fbdev: Disable sysfb device registration when
 removing conflicting FBs
Content-Language: en-US
From:   Javier Martinez Canillas <javierm@redhat.com>
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
In-Reply-To: <a633d605-4cb3-2e04-1818-85892cf6f7b0@redhat.com>
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

On 6/17/22 00:18, Javier Martinez Canillas wrote:
> On 6/16/22 23:03, Zack Rusin wrote:

[snip]

> 
> I'll look at this tomorrow but in the meantime, could you please look if the following
> commits on top of drm-misc-next help ?
> 
> d258d00fb9c7 fbdev: efifb: Cleanup fb_info in .fb_destroy rather than .remove
> 1b5853dfab7f fbdev: efifb: Fix a use-after-free due early fb_info cleanup
> 

Scratch that. I see in your config now that you are not using efifb but instead
simpledrm: CONFIG_DRM_SIMPLEDRM=y, CONFIG_SYSFB_SIMPLEFB=y and CONFIG_DRM_VMWGFX.

Since you mentioned efifb I misunderstood that you are using it. Anyways, as
said I'll investigate this tomorrow.

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat


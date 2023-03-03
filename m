Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C5A6A98CF
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 14:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCCNmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 08:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCCNmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 08:42:32 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B135B5C6
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 05:42:12 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id p16so1592268wmq.5
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 05:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677850879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UKgjWWy9H9EG0XzxlO1YDjPJ2XHm1SI8XxncS1yfG0A=;
        b=IhgkCh0h6W4l/CPo3AEztC4mXQzuJ21aNy43KzTlE7zGPE5y5vxEKru2UBgdsTXjjT
         PSuHi1EiM9K/zNf45+WSbV8bAkhhlsOaHXRJ1CsJdvSfJ+nJ741johrAsDReetJumt3E
         MLcvMRIzlv5TWmk2wK3C0gGR7SJKxqLdkjuvO/hBvR3bduIUC6BevB5+xrIj5+gPaKok
         uG+wZKJpI43Tag+n20smAuoYcKUDpjA+Mzdauv1zuRAF0NONlt5rifPGBPFdo2TQwozc
         /8xhE4qoiaxqhgF5tRTmUSUqz6Fjcd+B0MywgZ+uzQx9WJs9a0KheOzBEOnVHItS85vX
         mUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677850879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UKgjWWy9H9EG0XzxlO1YDjPJ2XHm1SI8XxncS1yfG0A=;
        b=LMl157uBnfWVl9qVP+3w5hgxjTn31IICR1AA6RdR1MqPqD0Js4yJ3YTYCYVHQxaUAA
         PGrTbeLJO7DOFYvY6Bk6G3UywXTpR8JVngE3TIObZjPBtgClnMEdLK4Qb7hRmK6L5y9L
         Ihz81u29gfPIWhk0A/cfxXvyTjujhY7yrqRg8z65GZEbyj4TgBC1RhP+z6lMPxg6BuxI
         yvl25yRd9WUd9ITkw3OLN1yVgAALm989+wt1j7fB82ohVUtBwaneIyWWHYke00mMV+0V
         zawbeBAk5nfNqOyCgLVVJmBa4cGLc37myjy/15RqSiz5JLEdzWxxiJY7TSvzQ6fp0gQd
         LxhA==
X-Gm-Message-State: AO0yUKV6xmGS1KTsHy3zBpG/jlnskraHKQEJwe+2jfUocFBIGEhtHQEF
        h/N+gJ1oPlPoIc/6QYXGcIZuSQ==
X-Google-Smtp-Source: AK7set9H+Qo8gOK5AAmOxhuxk+rZjX1O8EU8rsboVmALQNLBLI+Z3sp/4Elm1Qv/YLBWze/UJ1NKdA==
X-Received: by 2002:a05:600c:538d:b0:3e1:e754:70cb with SMTP id hg13-20020a05600c538d00b003e1e75470cbmr175334wmb.4.1677850879267;
        Fri, 03 Mar 2023 05:41:19 -0800 (PST)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d510b000000b002c55b0e6ef1sm2374175wrt.4.2023.03.03.05.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 05:41:18 -0800 (PST)
Date:   Fri, 3 Mar 2023 13:41:14 +0000
From:   Mostafa Saleh <smostafa@google.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     eric.auger@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/platform: Fix reset_required behaviour
Message-ID: <ZAH4+rJGPC+CyDPb@google.com>
References: <20230303121151.3489618-1-smostafa@google.com>
 <20230303063451.1525d123.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303063451.1525d123.alex.williamson@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 03, 2023 at 06:34:51AM -0700, Alex Williamson wrote:
> On Fri,  3 Mar 2023 12:11:52 +0000
> Mostafa Saleh <smostafa@google.com> wrote:
> 
> > vfio_platform_device has a flag reset_required that can be set from
> > module_param or vfio driver which indicates that reset is not a
> > requirement and it bypasses related checks.
> > 
> > This was introduced and implemented in vfio_platform_probe_common in
> > "b5add544d67 vfio, platform: make reset driver a requirement by default"
> > 
> > However, vfio_platform_probe_common was removed in
> > "ac1237912fb vfio/amba: Use the new device life cycle helpers"
> > 
> > And new implementation added in vfio_platform_init_common in
> > "5f6c7e0831a vfio/platform: Use the new device life cycle helpers"
> > 
> > which causes an error even if vfio-platform.reset_required=0, as it
> > only guards printing and not the return as before.
> > 
> > This patch fixes this by returning 0 if there is no reset function
> > for the device and reset_required=0. This is also consistent with
> > checks in vfio_platform_open_device and vfio_platform_close_device.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  drivers/vfio/platform/vfio_platform_common.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> > index 1a0a238ffa35..7325ff463cf0 100644
> > --- a/drivers/vfio/platform/vfio_platform_common.c
> > +++ b/drivers/vfio/platform/vfio_platform_common.c
> > @@ -650,10 +650,13 @@ int vfio_platform_init_common(struct vfio_platform_device *vdev)
> >  	mutex_init(&vdev->igate);
> >  
> >  	ret = vfio_platform_get_reset(vdev);
> > -	if (ret && vdev->reset_required)
> > +	if (ret && vdev->reset_required) {
> >  		dev_err(dev, "No reset function found for device %s\n",
> >  			vdev->name);
> > -	return ret;
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_platform_init_common);
> >  
> 
> An identical patch has already accepted and merged for v6.3:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=168a9c91fe0a1180959b6394f4566de7080244b6

Oh, sorry, missed that!

Thanks,
Mostafa


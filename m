Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D8A5A689B
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 18:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiH3Qov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 12:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiH3Qot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 12:44:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727951AF2D
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 09:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661877887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sYkEcIEcYJVPnhVJ5B4453HGLPxDPLa2+9KAMnSSp18=;
        b=FQXTNdvD/DHhobY6Va82AmR75Up0KSyHYHNB0sb3iFQF8r0g+fvn30IxkRKxKwwa48GU5t
        MEin0cibUj07spAUs5bIWhgQLBBe4cZdhxIX49POd93AT8/RJUZDhAxQq58j07P7LXvuqr
        QGbr0t5M7CPu+pNTDMJAvApp/FLAO2U=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-30-7xYcm7ESMp2y28lc2kwVWg-1; Tue, 30 Aug 2022 12:43:47 -0400
X-MC-Unique: 7xYcm7ESMp2y28lc2kwVWg-1
Received: by mail-il1-f198.google.com with SMTP id c7-20020a056e020bc700b002e59be6ce85so8636727ilu.12
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 09:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=sYkEcIEcYJVPnhVJ5B4453HGLPxDPLa2+9KAMnSSp18=;
        b=VB3vh7OtlTQxjHGgoRv0CB9sfH48TBS0nYpJSpovB04eoH2UfRXwGT63kjhWFivz72
         qzDPMqNE9I+CVDelYEjrs4Wg8Xkq3fae7SDrIogsah2R3eR6oW5DidlpdrX/FrNdv+fl
         SiJCUqAtrIUExuttNcv3OV6DW82X4EJZpeNYhQmy9AwXgJREgwI9rW8EBTyCD4XXxmsd
         qV8TaTteB3Tn6w7EvTdA0sk3aeAzjKHMBq0QM1v5H3qImxRDPYDBoWOf2yDQ6IWSa0/E
         tT3bZQvdth7Ltpe6aUG21dD7bqpHryHyAtjrlQvAsaOd08cN0wrm5X6HynjeQMRAeVhs
         RnYA==
X-Gm-Message-State: ACgBeo1gGThGOHBq07OkVOqnBWD+nmRVdY2S3gDTog2LCMYBS/58/nhY
        xgcc6GfroEFwFjuL9CuargBRqCfUDSaYcFB0MIRAriq71dX3w0I0lmOMYA9f5nJgcZBRQpuc2xi
        ROcwHn+ckQwbP
X-Received: by 2002:a6b:580e:0:b0:689:af21:6f3f with SMTP id m14-20020a6b580e000000b00689af216f3fmr11840459iob.116.1661877805304;
        Tue, 30 Aug 2022 09:43:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR74qq+ShMV0B7MOD9pLRKsUex3QAMRhvAeMKdRCeHWVY7Q4aWani6aoYi2AyG2iCWoRh0iOVg==
X-Received: by 2002:a6b:580e:0:b0:689:af21:6f3f with SMTP id m14-20020a6b580e000000b00689af216f3fmr11840450iob.116.1661877805128;
        Tue, 30 Aug 2022 09:43:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f30-20020a02a11e000000b0034a0275ae76sm5682440jag.139.2022.08.30.09.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 09:43:24 -0700 (PDT)
Date:   Tue, 30 Aug 2022 10:43:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: [PATCH 8/8] vfio: Split VFIO_GROUP_GET_STATUS into a function
Message-ID: <20220830104323.14b6d460.alex.williamson@redhat.com>
In-Reply-To: <Ywlai0AR7RuF9FlI@nvidia.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
        <8-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
        <Ywlai0AR7RuF9FlI@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Aug 2022 20:43:07 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Aug 17, 2022 at 01:07:25PM -0300, Jason Gunthorpe wrote:
> > This is the last sizable implementation in vfio_group_fops_unl_ioctl(),
> > move it to a function so vfio_group_fops_unl_ioctl() is emptied out.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/vfio_main.c | 55 ++++++++++++++++++++--------------------
> >  1 file changed, 27 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 78957f45c37a34..6f96e6d07a5e98 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -1227,6 +1227,32 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
> >  	vfio_device_put(device);
> >  	return ret;
> >  }
> > +static int vfio_group_ioctl_get_status(struct vfio_group *group,
> > +				       struct vfio_group_status __user *arg)  
> 
> There is a missing blank line after the } here

Fixed locally if there's no other need for a respin.  Thanks,

Alex


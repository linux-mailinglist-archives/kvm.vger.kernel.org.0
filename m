Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB839559BCC
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 16:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiFXOld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiFXOlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:41:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C358667E62
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656081689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cYn+Z8xYkBR/kjGkJUKMs3IbuXDax0YYChOhxAD/LDU=;
        b=PqOgWZw9/STN2dYxDoD5OlLCy0DruP0tHoF89Nlg4pFW/wt7QFa6f8qtKbm6U3Y4laFczy
        CE0SIXkxav+SfXL1ptP8Y2cAz32obhiZoSurg+0+86HR0KJrHKFfR9XhHXbM+ZvmO8rmvA
        r3MOew5Tbr2MQuW7YsI19Ev3jsxC/wc=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-B84aMNacORqEXzagBjiNJw-1; Fri, 24 Jun 2022 10:41:28 -0400
X-MC-Unique: B84aMNacORqEXzagBjiNJw-1
Received: by mail-io1-f71.google.com with SMTP id t11-20020a6bdb0b000000b00674fd106c0cso1262733ioc.16
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cYn+Z8xYkBR/kjGkJUKMs3IbuXDax0YYChOhxAD/LDU=;
        b=VlOWf1frBOXtVWvr1FYBI+24k75suAbwuwhcy1ObTXMS8bImfJNd3CYMJilEu2Fi87
         9UnNP/ch0MtrWm7cboZ8F5vvz+tWGNCl727CFDwDSQA57Uk0bDeNjOvdCn4FoaK8ELPz
         LUf0xxsQIIKntggz8igqpdhlRbM1bGzML1o5AYQKA0vbFTZ68EBNhUIBeXzL+PeBEs66
         UJ3lXHjT8USQpsykOcjR9mzNvGEyjeuuK9xCgPTmA4rhck99wQZsIWhCDWiif4x3zODb
         iDMox0lmT0tBWIS6Zbk6baIXZPU7Xelt4l+ZegC4MNyNZD9fST/pTQ6/yClvwPpaMxG8
         Ps0g==
X-Gm-Message-State: AJIora8cqqZhy1rff4jgNygXTg/XigOokqNiZQ3OXJSiE5iJvnSpK3+B
        xCMGAN5t9llxoaFOzhX2HlYwo8F2H0mE+bwU437dTwv+riPFKKJWQw1Bnc402t36N80QL4xA4ZY
        PDQqQjA/TiE3/
X-Received: by 2002:a05:6e02:174d:b0:2d9:302a:7b70 with SMTP id y13-20020a056e02174d00b002d9302a7b70mr8675323ill.22.1656081687761;
        Fri, 24 Jun 2022 07:41:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vlGeXFysA7pIar8yoiWHx50WguWAXItqPfjHqKYSmPkMmYB7hUy3vSuUqsYht9oWVk8xrlJw==
X-Received: by 2002:a05:6e02:174d:b0:2d9:302a:7b70 with SMTP id y13-20020a056e02174d00b002d9302a7b70mr8675304ill.22.1656081687485;
        Fri, 24 Jun 2022 07:41:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x66-20020a0294c8000000b00339dd803fddsm1126428jah.174.2022.06.24.07.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 07:41:27 -0700 (PDT)
Date:   Fri, 24 Jun 2022 08:41:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        liulongfang <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Message-ID: <20220624084125.6d819a3c.alex.williamson@redhat.com>
In-Reply-To: <20220624141237.GQ4147@nvidia.com>
References: <20220606085619.7757-3-yishaih@nvidia.com>
        <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
        <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
        <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
        <20220616170118.497620ba.alex.williamson@redhat.com>
        <6f6b36765fe9408f902d1d644b149df3@huawei.com>
        <20220617084723.00298d67.alex.williamson@redhat.com>
        <4f14e015-e4f7-7632-3cd7-0e644ed05c99@nvidia.com>
        <20220620034909.GC5219@nvidia.com>
        <20220621104146.368b429a.alex.williamson@redhat.com>
        <20220624141237.GQ4147@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Jun 2022 11:12:37 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 21, 2022 at 10:41:46AM -0600, Alex Williamson wrote:
> > On Mon, 20 Jun 2022 00:49:09 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Sun, Jun 19, 2022 at 12:25:50PM +0300, Yishai Hadas wrote:
> > >   
> > > > Means, staying with a single device_ops but just inline a check whether
> > > > migration is really supported inside the migration get/set state callbacks
> > > > and let the core call it unconditionally.    
> > > 
> > > I find it much cleaner to have op == NULL means unsupported.
> > > 
> > > As soon as you start linking supported/unsupported to other flags it
> > > can get very complicated fairly fast. I have this experiance from RDMA
> > > where we've spent a long time now ripping out hundreds of flag tests
> > > and replacing them with NULL op checks. Many bugs were fixed doing
> > > this as drivers never fully understood what the flags mean and ended
> > > up with flags set that their driver doesn't properly implement.
> > > 
> > > The mistake we made in RDMA was not splitting the ops, instead the ops
> > > were left mutable so the driver could load the right combination based
> > > on HW ability.  
> > 
> > I don't really have an issue with splitting the ops, but what
> > techniques have you learned from RDMA to make drivers setting ops less
> > ad-hoc than proposed here?  Are drivers expected to set ops before a
> > formally defined registration point?    
> 
> Yes, the flow is the same three step process as in VFIO:
> 
>  vfio_init_group_dev()
>  [driver continues to prepare the vfio_device]
>  vfio_register_group_dev()
> 
> I included the 'ops' as an argument to vfio_init_group_dev() as a code
> reduction not a statement that the ops must be fully set before
> vfio_init_group_dev() returns.
> 
> The entire point of the init step is to allow the core and driver to
> co-operate and fully initialize the object before moving to register.
> 
> So I don't view it as ad-hoc that the object needs further setup after
> vfio_init_group_dev().
> 
> > Is there an API for setting ops or is it open coded per driver?  
> 
> RDMA uses a function ib_set_device_ops() but that is only because
> there is alot of code in that function to do the copying of ops
> pointers. Splitting avoids the copying so we don't really need a
> function.

So maybe we just need a comment in the definition of the
vfio_migration_ops that vfio_device.mig_ops is a static property of the
vfio_device which must be set prior to registering the vfio_device.
Thanks,

Alex


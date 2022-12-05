Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB3364383A
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 23:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiLEWh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 17:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiLEWh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 17:37:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1006B1C439
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 14:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670279788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8z7QafXRkPfBe2bVdmRZxp81gkkRQQwpTT/06vWqX0=;
        b=XxkYctdHS6Q3ir7niOJz29h7HkHNkk2RQorlwt2XKLAHLEkQ36nEBFDv18agVVv1uSrtyK
        07v8zwg+elMF/iqhL56QiPoWh1QrTGZ2w3oJYfezktoCDc2svVfR+2DRaKlC9hXreqP6jf
        wbd/8rnn56080pQ4XLdn6ZrTRpwSHqk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596-d0NZrK-SPJ6AexFVcGKipg-1; Mon, 05 Dec 2022 17:36:26 -0500
X-MC-Unique: d0NZrK-SPJ6AexFVcGKipg-1
Received: by mail-io1-f71.google.com with SMTP id c23-20020a6b4e17000000b006db1063fc9aso10684115iob.14
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 14:36:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p8z7QafXRkPfBe2bVdmRZxp81gkkRQQwpTT/06vWqX0=;
        b=dutYLgEjQpkGaun5ENRsK1db7ViV/ib3GVx9kSb2Z/8undztw+obcrrxmFwCcA2QXJ
         CsmWX7bzJ6tQ2SFpEI0S5NXLsPYhNyJbKjYXz+mRUjVVDqKLeIa6IX7xgBB4Y+tsXnBI
         tepkLc/eBlhgag1oUsLft62a13yA/9gxtiEHX3hfYpAXQKV1/dU/3YjMFVkXS5Us4r0R
         okxR5xeQJ75lko4rp6161kJMlsBOT4ipiQZruT846vU0+/VXCSBnQAodH4tiF6j8UDQ0
         JA3LuVgY4Ff2aup6EmImfE2H87tkxL3+10SKa8SyYi+Xfmc1o5x2B2nwQosHvZ/2LEJy
         dVzA==
X-Gm-Message-State: ANoB5plE0KofzdqXqGfS3C3PkRUh/GHpQH2DxS/urWs4H8+ReKQc1Jb5
        JSEMxdFUiTWIc9h5GDwbWD9lv8yVoOdNRvvNDxYhP5teX+JdAuEocuWJgn8DfGHZikb145aqpOH
        f1cwkKc6kDTCj
X-Received: by 2002:a05:6e02:4a4:b0:303:259:fefc with SMTP id e4-20020a056e0204a400b003030259fefcmr20784829ils.81.1670279784902;
        Mon, 05 Dec 2022 14:36:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4fmlrdibchKFTN8fMxycnszSSP/gO7bql4wO54fsTCkuWpwY5s6m5QuBQyHyH1Agujwn0LqQ==
X-Received: by 2002:a05:6e02:4a4:b0:303:259:fefc with SMTP id e4-20020a056e0204a400b003030259fefcmr20784818ils.81.1670279784693;
        Mon, 05 Dec 2022 14:36:24 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p18-20020a056638217200b00363da904602sm1377619jak.13.2022.12.05.14.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 14:36:24 -0800 (PST)
Date:   Mon, 5 Dec 2022 15:36:23 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Anthony Krowiak <akrowiak@linux.ibm.com>
Cc:     ruanjinjie <ruanjinjie@huawei.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/ap/ccw/samples: Fix device_register() unwind path
Message-ID: <20221205153623.6a5bf415.alex.williamson@redhat.com>
In-Reply-To: <9fe1e000-e3ff-bf42-28f7-169fb57dc1ce@linux.ibm.com>
References: <166999942139.645727.12439756512449846442.stgit@omen>
        <9fe1e000-e3ff-bf42-28f7-169fb57dc1ce@linux.ibm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Dec 2022 14:20:53 -0500
Anthony Krowiak <akrowiak@linux.ibm.com> wrote:

> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> 
> On 12/2/22 11:46 AM, Alex Williamson wrote:
> > We always need to call put_device() if device_register() fails.
> > All vfio drivers calling device_register() include a similar unwind
> > stack via gotos, therefore split device_unregister() into its
> > device_del() and put_device() components in the unwind path, and
> > add a goto target to handle only the put_device() requirement.
> >
> > Reported-by: Ruan Jinjie <ruanjinjie@huawei.com>
> > Link: https://lore.kernel.org/all/20221118032827.3725190-1-ruanjinjie@huawei.com
> > Fixes: d61fc96f47fd ("sample: vfio mdev display - host device")
> > Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
> > Fixes: a5e6e6505f38 ("sample: vfio bochs vbe display (host device for bochs-drm)")
> > Fixes: 9e6f07cd1eaa ("vfio/ccw: create a parent struct")
> > Fixes: 36360658eb5a ("s390: vfio_ap: link the vfio_ap devices to the vfio_ap bus subsystem")
> > Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> > Cc: Halil Pasic <pasic@linux.ibm.com>
> > Cc: Jason Herne <jjherne@linux.ibm.com>
> > Cc: Kirti Wankhede <kwankhede@nvidia.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Eric Farman <farman@linux.ibm.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---

With all the ccw and ap acks, applied to vfio next branch for v6.2.
Thanks,

Alex

> >
> > I didn't intend to usurp Ruan's patch, but since the inline version is
> > collecting reviews, formally post it and include additional fixes tags
> > for vfio-ccw and vfio-ap.
> >
> >   drivers/s390/cio/vfio_ccw_drv.c   |    3 ++-
> >   drivers/s390/crypto/vfio_ap_drv.c |    2 +-
> >   samples/vfio-mdev/mbochs.c        |    7 ++++---
> >   samples/vfio-mdev/mdpy.c          |    7 ++++---
> >   samples/vfio-mdev/mtty.c          |    7 ++++---
> >   5 files changed, 15 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> > index c2a65808605a..54aba7cceb33 100644
> > --- a/drivers/s390/cio/vfio_ccw_drv.c
> > +++ b/drivers/s390/cio/vfio_ccw_drv.c
> > @@ -199,8 +199,9 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
> >   	return 0;
> >   
> >   out_unreg:
> > -	device_unregister(&parent->dev);
> > +	device_del(&parent->dev);
> >   out_free:
> > +	put_device(&parent->dev);
> >   	dev_set_drvdata(&sch->dev, NULL);
> >   	return ret;
> >   }
> > diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> > index f43cfeabd2cc..997b524bdd2b 100644
> > --- a/drivers/s390/crypto/vfio_ap_drv.c
> > +++ b/drivers/s390/crypto/vfio_ap_drv.c
> > @@ -122,7 +122,7 @@ static int vfio_ap_matrix_dev_create(void)
> >   	return 0;
> >   
> >   matrix_drv_err:
> > -	device_unregister(&matrix_dev->device);
> > +	device_del(&matrix_dev->device);
> >   matrix_reg_err:
> >   	put_device(&matrix_dev->device);
> >   matrix_alloc_err:
> > diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> > index 8b5a3a778a25..e54eb752e1ba 100644
> > --- a/samples/vfio-mdev/mbochs.c
> > +++ b/samples/vfio-mdev/mbochs.c
> > @@ -1430,7 +1430,7 @@ static int __init mbochs_dev_init(void)
> >   
> >   	ret = device_register(&mbochs_dev);
> >   	if (ret)
> > -		goto err_class;
> > +		goto err_put;
> >   
> >   	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver,
> >   				   mbochs_mdev_types,
> > @@ -1441,8 +1441,9 @@ static int __init mbochs_dev_init(void)
> >   	return 0;
> >   
> >   err_device:
> > -	device_unregister(&mbochs_dev);
> > -err_class:
> > +	device_del(&mbochs_dev);
> > +err_put:
> > +	put_device(&mbochs_dev);
> >   	class_destroy(mbochs_class);
> >   err_driver:
> >   	mdev_unregister_driver(&mbochs_driver);
> > diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> > index 721fb06c6413..e8400fdab71d 100644
> > --- a/samples/vfio-mdev/mdpy.c
> > +++ b/samples/vfio-mdev/mdpy.c
> > @@ -717,7 +717,7 @@ static int __init mdpy_dev_init(void)
> >   
> >   	ret = device_register(&mdpy_dev);
> >   	if (ret)
> > -		goto err_class;
> > +		goto err_put;
> >   
> >   	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver,
> >   				   mdpy_mdev_types,
> > @@ -728,8 +728,9 @@ static int __init mdpy_dev_init(void)
> >   	return 0;
> >   
> >   err_device:
> > -	device_unregister(&mdpy_dev);
> > -err_class:
> > +	device_del(&mdpy_dev);
> > +err_put:
> > +	put_device(&mdpy_dev);
> >   	class_destroy(mdpy_class);
> >   err_driver:
> >   	mdev_unregister_driver(&mdpy_driver);
> > diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> > index 3c2a421b9b69..e887de672c52 100644
> > --- a/samples/vfio-mdev/mtty.c
> > +++ b/samples/vfio-mdev/mtty.c
> > @@ -1330,7 +1330,7 @@ static int __init mtty_dev_init(void)
> >   
> >   	ret = device_register(&mtty_dev.dev);
> >   	if (ret)
> > -		goto err_class;
> > +		goto err_put;
> >   
> >   	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
> >   				   &mtty_driver, mtty_mdev_types,
> > @@ -1340,8 +1340,9 @@ static int __init mtty_dev_init(void)
> >   	return 0;
> >   
> >   err_device:
> > -	device_unregister(&mtty_dev.dev);
> > -err_class:
> > +	device_del(&mtty_dev.dev);
> > +err_put:
> > +	put_device(&mtty_dev.dev);
> >   	class_destroy(mtty_dev.vd_class);
> >   err_driver:
> >   	mdev_unregister_driver(&mtty_driver);
> >
> >  
> 


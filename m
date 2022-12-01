Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C59063F992
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 22:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiLAVLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 16:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiLAVLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 16:11:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D098BEE1C
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 13:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669929018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ZG3sGb+U+LRPySnTCOGhSvzYDNSfM2+mgL0KXCWRaI=;
        b=FDX0TcJyUoNMBKTxRR5ZB+neCtUIBbG0etmoJItq6LtUF/KEk2CpRSCE+SrcpE99NNaxnp
        6zwxI86bmFphP9FbIy+wo8CM+9nBtLW4Lv5vs4layhfj+iGoW2URu0FIM+s3iWGJHTSzM1
        Pr2pxv53sT5GGCGnTGK36HwPE7fAReE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-500-EWs0dOUzOAGvLTtM9Q5WjQ-1; Thu, 01 Dec 2022 16:10:17 -0500
X-MC-Unique: EWs0dOUzOAGvLTtM9Q5WjQ-1
Received: by mail-il1-f199.google.com with SMTP id n10-20020a056e02140a00b00302aa23f73fso3207618ilo.20
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 13:10:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ZG3sGb+U+LRPySnTCOGhSvzYDNSfM2+mgL0KXCWRaI=;
        b=0Hb7glq3ltN25NCQKxBHN1yhIqCjrtPNu0nRgirDeF+ysQepp8kmWVp+kcCtcC00Oq
         HcHP8+vICFupw6xRGE07moiB32fjF4dQHGdTgM5ufeC6YsKh3bVylsDivi2lOZHjU2Qd
         Hecs7RpxNZ/1SULOXsfwHQ4soRVgV60h6VN3Tg/2pkSV2+yfRZeYfJNSR2ekJ6MKePay
         afY7N8IMn5y62uJgOGA4qhKguB2EqDWBIkWiX9Kno5vn5/lEfTpyOv1e5743EEC9Luvv
         cWjKPO+r49HkVnRhDugXsxHlwRpSGydV7m/1v4Fm0IxEg4oNWZwonl1lVh8D7DRV8nW9
         D13Q==
X-Gm-Message-State: ANoB5plb/lgX7y9r7uUOXn04m/Vo4uhibxe8RBJQAyZPcwPjzwvVdwUA
        8wdZWm5kWvHRREBPp9NDsGMR5HhQCwc2BKZdbVJpcV1lX5Y3z4u6vvPDbP/p5ek1duxJZfy6Ke7
        MxDUp9EbbDva1
X-Received: by 2002:a05:6638:164a:b0:389:d66d:c049 with SMTP id a10-20020a056638164a00b00389d66dc049mr13199708jat.195.1669929015968;
        Thu, 01 Dec 2022 13:10:15 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4pKQqQjhRn0EcxfBEEp7y59Lnpk5P4WU8x8eOLVuwJfOHGMDoPHk+gJpm8IWwvfwF2WWMSjA==
X-Received: by 2002:a05:6638:164a:b0:389:d66d:c049 with SMTP id a10-20020a056638164a00b00389d66dc049mr13199696jat.195.1669929015701;
        Thu, 01 Dec 2022 13:10:15 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g12-20020a056602072c00b006cab79c4214sm1963330iox.46.2022.12.01.13.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 13:10:14 -0800 (PST)
Date:   Thu, 1 Dec 2022 14:10:13 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     ruanjinjie <ruanjinjie@huawei.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>
Subject: Re: [PATCH] vfio/mdev: fix possible memory leak in module init
 funcs
Message-ID: <20221201141013.68d2b0cf.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276BC0B7E656465950E3A558C149@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221118032827.3725190-1-ruanjinjie@huawei.com>
        <20221130160622.0cf3e47d.alex.williamson@redhat.com>
        <BN9PR11MB5276BC0B7E656465950E3A558C149@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Thu, 1 Dec 2022 02:00:57 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, December 1, 2022 7:06 AM
> > 
> > [Cc +vfio-ap, vfio-ccw]
> > 
> > On Fri, 18 Nov 2022 11:28:27 +0800
> > ruanjinjie <ruanjinjie@huawei.com> wrote:
> >   
> > > Inject fault while probing module, if device_register() fails,
> > > but the refcount of kobject is not decreased to 0, the name
> > > allocated in dev_set_name() is leaked. Fix this by calling
> > > put_device(), so that name can be freed in callback function
> > > kobject_cleanup().  
> 
> It's not just about the name. The problem of kboject not being
> released is a bigger one.
> 
> put_device() is always required no matter device_register()
> succeeds or not:
> 
> * NOTE: _Never_ directly free @dev after calling this function, even
>  * if it returned an error! Always use put_device() to give up the
>  * reference initialized in this function instead.
>  */
> int device_register(struct device *dev)
> 
> > > @@ -1430,8 +1430,10 @@ static int __init mbochs_dev_init(void)
> > >  	dev_set_name(&mbochs_dev, "%s", MBOCHS_NAME);
> > >
> > >  	ret = device_register(&mbochs_dev);
> > > -	if (ret)
> > > +	if (ret) {
> > > +		put_device(&mbochs_dev);
> > >  		goto err_class;
> > > +	}
> > >
> > >  	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev,  
> > &mbochs_driver,  
> > >  				   mbochs_mdev_types,  
> > 
> > 
> > vfio-ap has a similar unwind as the sample drivers, but actually makes
> > an attempt to catch this ex:
> > 
> > 	...
> >         ret = device_register(&matrix_dev->device);
> >         if (ret)
> >                 goto matrix_reg_err;
> > 
> >         ret = driver_register(&matrix_driver);
> >         if (ret)
> >                 goto matrix_drv_err;
> > 
> >         return 0;
> > 
> > matrix_drv_err:
> >         device_unregister(&matrix_dev->device);
> > matrix_reg_err:
> >         put_device(&matrix_dev->device);
> > 	...
> > 
> > So of the vfio drivers calling device_register(), vfio-ap is the only
> > one that does a put_device() if device_register() fails, but it also
> > seems sketchy to call both device_unregister() and put_device() in the
> > case that we exit via matrix_drv_err.
> > 
> > I wonder if all of these shouldn't adopt a flow like:
> > 
> > 	ret = device_register(&dev);
> > 	if (ret)
> > 		goto err1;
> > 
> > 	....
> > 
> > 	return 0;
> > 
> > err2:
> > 	device_del(&dev);
> > err1:
> > 	put_device(&dev);
> >   
> 
> It's kind of a mixed model.
> 
> With above unwind it's clearer to use device_initialize() and device_add() instead.

That would go against the comment for device_register() recommending
that device_initialize() and device_add() should only be called
separately if we have a clearly defined need.  I can only imagine a
patch bot would quickly come along to rectify the situation if we
simply open code device_register() for aesthetics.  I don't see that
splitting device_unregister() for the purpose of having a common unwind
path necessitates any changes relative to device_register().

> Otherwise what this patch does looks better IMHO:
> 
> 	ret = device_register(&dev);
> 	if (ret) {
> 		put_device(&dev);
> 		goto err1;
> 	}
> 
> 	...
> 
> 	return 0;
> 
> err2:
> 	device_unregister(&dev);
> err1:
> 	earlier_unwind();
> 

This is essentially what was originally proposed.  It could also be
called a "mixed model", implementing part of the unwind in the error
branch before jumping to the common unwind.  As demonstrated below,
every current vfio driver calling device_register() follows a similar
goto unwind stack as found in the sample drivers, which makes it
trivially easy to split the device_unregister() call and add a goto
target in between.

Either way, they're equivalent and I'll take whichever version
addresses all the vfio related use cases and gets acks from their
maintainers.  Thanks,

Alex

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index c2a65808605a..54aba7cceb33 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -199,8 +199,9 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	return 0;
 
 out_unreg:
-	device_unregister(&parent->dev);
+	device_del(&parent->dev);
 out_free:
+	put_device(&parent->dev);
 	dev_set_drvdata(&sch->dev, NULL);
 	return ret;
 }
diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index f43cfeabd2cc..997b524bdd2b 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -122,7 +122,7 @@ static int vfio_ap_matrix_dev_create(void)
 	return 0;
 
 matrix_drv_err:
-	device_unregister(&matrix_dev->device);
+	device_del(&matrix_dev->device);
 matrix_reg_err:
 	put_device(&matrix_dev->device);
 matrix_alloc_err:
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 8b5a3a778a25..e54eb752e1ba 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1430,7 +1430,7 @@ static int __init mbochs_dev_init(void)
 
 	ret = device_register(&mbochs_dev);
 	if (ret)
-		goto err_class;
+		goto err_put;
 
 	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver,
 				   mbochs_mdev_types,
@@ -1441,8 +1441,9 @@ static int __init mbochs_dev_init(void)
 	return 0;
 
 err_device:
-	device_unregister(&mbochs_dev);
-err_class:
+	device_del(&mbochs_dev);
+err_put:
+	put_device(&mbochs_dev);
 	class_destroy(mbochs_class);
 err_driver:
 	mdev_unregister_driver(&mbochs_driver);
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 721fb06c6413..e8400fdab71d 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -717,7 +717,7 @@ static int __init mdpy_dev_init(void)
 
 	ret = device_register(&mdpy_dev);
 	if (ret)
-		goto err_class;
+		goto err_put;
 
 	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver,
 				   mdpy_mdev_types,
@@ -728,8 +728,9 @@ static int __init mdpy_dev_init(void)
 	return 0;
 
 err_device:
-	device_unregister(&mdpy_dev);
-err_class:
+	device_del(&mdpy_dev);
+err_put:
+	put_device(&mdpy_dev);
 	class_destroy(mdpy_class);
 err_driver:
 	mdev_unregister_driver(&mdpy_driver);
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 3c2a421b9b69..e887de672c52 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1330,7 +1330,7 @@ static int __init mtty_dev_init(void)
 
 	ret = device_register(&mtty_dev.dev);
 	if (ret)
-		goto err_class;
+		goto err_put;
 
 	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
 				   &mtty_driver, mtty_mdev_types,
@@ -1340,8 +1340,9 @@ static int __init mtty_dev_init(void)
 	return 0;
 
 err_device:
-	device_unregister(&mtty_dev.dev);
-err_class:
+	device_del(&mtty_dev.dev);
+err_put:
+	put_device(&mtty_dev.dev);
 	class_destroy(mtty_dev.vd_class);
 err_driver:
 	mdev_unregister_driver(&mtty_driver);


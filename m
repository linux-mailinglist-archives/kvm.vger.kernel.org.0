Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE9961A2D8
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 22:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKDVA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 17:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiKDVA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 17:00:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341C93E0AB
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 13:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667595572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QCRdcvX2etR1etLUUNmnsFxH7uU855IQhgyBna/6pCw=;
        b=Pi4CEsPlyYsuPurl+OIGxV1qABg22MpEVOFiHUnqq/9XMSkrDdESYZBP2Y2GZXklPCbNV5
        i5CPQLaJrxGKn8cAsZH5WGjQ1B0gGVm4w1scdeymigLwNTIxZDVV32Dn0jnGEDCZPMBcn/
        3qRA1Z0VKItNkTQVy5lflSce1vF+ECU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-161-CH8k_C9yP2O_-Ozf0lTqwA-1; Fri, 04 Nov 2022 16:59:28 -0400
X-MC-Unique: CH8k_C9yP2O_-Ozf0lTqwA-1
Received: by mail-io1-f71.google.com with SMTP id n1-20020a6b7701000000b006d1f2c2850aso3760303iom.0
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 13:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QCRdcvX2etR1etLUUNmnsFxH7uU855IQhgyBna/6pCw=;
        b=n7YDPyRm7ian+QUUQfhj16/BlZAerr9DL92KJZ5OSwtFM1Yjuh2y20pEJyAJ8AmU+f
         TQmLE/j2jIfzecerCmCcFz8CGOPl+7xJxshr3ZxlZCn8+r+T/wf4L+jgzYwLSGkZ4lAo
         GFsgHbUD5b9NbdA00kUPJg4kz3u2zr/KZDa5d2z4BXaqDoj/MT0Z3fcaJGQPcXHY2bGD
         MRXIBY77JxlMhOM42k1A5dIcyyMhwzFMxRpxwnYc6Ul9hqsT48cMe50cg8ehfpMP3q+3
         ebmJlV0esgHhbWlV2SgVegLW0kdZgamRJfTEtaw5Y8u/sJLOboCxNwS3nrIIL8K+v+S/
         DPDw==
X-Gm-Message-State: ACrzQf3CKF8QAbCQM+CWk112Aif3M2RdA+cGkXALo78XAx+V0G7qiELS
        9zMHd8zrJ5fPko8WLfXkByzQ4NEIgkdmGbc6zTm4Y5hZ02sAkfUyQMGPKqbf/Bel21mHbPdFcpb
        +Ki9nFfYODPpE
X-Received: by 2002:a02:7108:0:b0:375:6182:d1fe with SMTP id n8-20020a027108000000b003756182d1femr16959559jac.301.1667595567862;
        Fri, 04 Nov 2022 13:59:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM46k/0nHKFuXgTCpoNTbYGm+ZAfZr6Sd80CSl1P3j9Zy6MBYJ5Qgldg2CyycPbAJpOnOBo0qA==
X-Received: by 2002:a02:7108:0:b0:375:6182:d1fe with SMTP id n8-20020a027108000000b003756182d1femr16959544jac.301.1667595567642;
        Fri, 04 Nov 2022 13:59:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z7-20020a029387000000b00349d33a92a2sm3623jah.140.2022.11.04.13.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:59:27 -0700 (PDT)
Date:   Fri, 4 Nov 2022 14:59:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: Re: [PATCH v4 2/3] vfio: Add an open counter to vfio_device_set
Message-ID: <20221104145918.265aa409.alex.williamson@redhat.com>
In-Reply-To: <20221104195727.4629-3-ajderossi@gmail.com>
References: <20221104195727.4629-1-ajderossi@gmail.com>
        <20221104195727.4629-3-ajderossi@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  4 Nov 2022 12:57:26 -0700
Anthony DeRossi <ajderossi@gmail.com> wrote:

> open_count is incremented before open_device() and decremented after
> close_device() for each device in the set. This allows devices to
> determine whether shared resources are in use without tracking them
> manually or accessing the private open_count in vfio_device.
> 
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> ---
>  drivers/vfio/vfio_main.c | 3 +++
>  include/linux/vfio.h     | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 9a4af880e941..6c65418fc7e3 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -761,6 +761,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  		mutex_lock(&device->group->group_lock);
>  		device->kvm = device->group->kvm;
>  
> +		device->dev_set->open_count++;

Note that this is on the device first open path...

>  		if (device->ops->open_device) {
>  			ret = device->ops->open_device(device);
>  			if (ret)
> @@ -809,6 +810,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  	}
>  err_undo_count:
>  	mutex_unlock(&device->group->group_lock);
> +	device->dev_set->open_count--;

But this can be reached for non-first open faults.

>  	device->open_count--;
>  	if (device->open_count == 0 && device->kvm)
>  		device->kvm = NULL;
> @@ -1023,6 +1025,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  			device->ops->close_device(device);
>  
>  		vfio_device_container_unregister(device);
> +		device->dev_set->open_count--;

This is on the last-close path, so aside from the above bug this is more
of an open device counter across the device set rather than than a
number of open device file descriptors counter as we have on each
device.

There's some complexity thinking about the difference between those for
our scenario, it works, but requires a bit of deduction.  For example,
a device set might have a count of 1 here, but that one device could be
opened multiple times.  It works for the scenario you address in the
next patch, but is maybe not as generically useful.

Like it seems maybe you're going for by your more recent comment, I was
thinking an interface rather than tracking a new field on the device
set.  Thanks,

Alex

>  	}
>  	mutex_unlock(&device->group->group_lock);
>  	device->open_count--;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e7cebeb875dd..5becdcdf4ba2 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -28,6 +28,7 @@ struct vfio_device_set {
>  	struct mutex lock;
>  	struct list_head device_list;
>  	unsigned int device_count;
> +	unsigned int open_count;
>  };
>  
>  struct vfio_device {


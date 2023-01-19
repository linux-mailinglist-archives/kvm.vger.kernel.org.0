Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E76E6743A9
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjASUtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjASUsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:48:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B401966D6
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674161250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IIowsBrf9b3JCaK9pHoD6oxsa3VcB7SaCU8GOAbl9E8=;
        b=AiTcxijN5+2xS82TrZuWJesaYKboVz2IaOPDAZxe2tCEp71mfZlw3msY7PcqNBP4orlq1c
        UvHN+u61UCSizA26YdNo9QFVvFR3cqBWBumOgROJc6FmCd1RIG47Vd8ISsjpNhC0z6322o
        VZLeTjiwQQRGqp+WrUpi3COZ5WJYzEE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-192-r3dgnVTsM3yljAFoCltzHw-1; Thu, 19 Jan 2023 15:47:28 -0500
X-MC-Unique: r3dgnVTsM3yljAFoCltzHw-1
Received: by mail-il1-f199.google.com with SMTP id i7-20020a056e021b0700b003033a763270so2419347ilv.19
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:47:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IIowsBrf9b3JCaK9pHoD6oxsa3VcB7SaCU8GOAbl9E8=;
        b=NsJIltSGXP8XmO0aE/AkeWO6Y5Fl12paoVLhM0OJvRdBHTt/KDj1rd/ofxgpYJNEIS
         NOrPD8Vm8WQ4ihxIJ5BXM3wYjobWoBYoD5/Rqi+Gz6mBcK+YCBK1BelsqnqqyHU4o7+Y
         ESwop3mPfPq48J7DGcpx6Gn3k18ayxQ3NXWRNwwLcQaKlpsQJ+25Y4yjQ4gI5tfzJCH6
         r7ajLbiO9kdQH52FdNz04BJatXR0wBmYCRUrB7NsB3p5hMBYPlZ43w4C1NPW//wGn37Q
         XoWoVUJOWieXW+2eHlTKO0dwbbMsXAypig0xC6R92ly/RoQ8m3tU7oaakRn5RErBb52C
         z5yg==
X-Gm-Message-State: AFqh2kqkHJ+BH53zVVcQgKxgknOY4oYvRxu8aoVfWWA99DLkv/uhZo7q
        nQSg+DKp1C18InlwjSXH8F817fV0RQQ1OvKAPZSnLkHqA2ncJTDiPihjL/4evdYIqpOpLQp2ZIK
        7+3Wa6BQZEIzt
X-Received: by 2002:a5d:9c16:0:b0:6df:820f:beae with SMTP id 22-20020a5d9c16000000b006df820fbeaemr8991259ioe.18.1674161248146;
        Thu, 19 Jan 2023 12:47:28 -0800 (PST)
X-Google-Smtp-Source: AMrXdXul5eTiTgaIeDVtkmgrhxBLkc/24OqBtha+BQx8gHk4Ea5M/QKYBoDcNlzzKrBGRaGGf1559w==
X-Received: by 2002:a5d:9c16:0:b0:6df:820f:beae with SMTP id 22-20020a5d9c16000000b006df820fbeaemr8991251ioe.18.1674161247919;
        Thu, 19 Jan 2023 12:47:27 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w14-20020a02b0ce000000b003a5eae30e55sm2778065jah.75.2023.01.19.12.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 12:47:27 -0800 (PST)
Date:   Thu, 19 Jan 2023 13:47:26 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: Re: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Message-ID: <20230119134726.5e381c10.alex.williamson@redhat.com>
In-Reply-To: <20230117134942.101112-9-yi.l.liu@intel.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
        <20230117134942.101112-9-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Jan 2023 05:49:37 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> Allow the vfio_device file to be in a state where the device FD is
> opened but the device cannot be used by userspace (i.e. its .open_device()
> hasn't been called). This inbetween state is not used when the device
> FD is spawned from the group FD, however when we create the device FD
> directly by opening a cdev it will be opened in the blocked state.
> 
> In the blocked state, currently only the bind operation is allowed,
> other device accesses are not allowed. Completing bind will allow user
> to further access the device.
> 
> This is implemented by adding a flag in struct vfio_device_file to mark
> the blocked state and using a simple smp_load_acquire() to obtain the
> flag value and serialize all the device setup with the thread accessing
> this device.
> 
> Due to this scheme it is not possible to unbind the FD, once it is bound,
> it remains bound until the FD is closed.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio.h      |  1 +
>  drivers/vfio/vfio_main.c | 29 +++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 3d8ba165146c..c69a9902ea84 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -20,6 +20,7 @@ struct vfio_device_file {
>  	struct vfio_device *device;
>  	struct kvm *kvm;
>  	struct iommufd_ctx *iommufd;
> +	bool access_granted;
>  };
>  
>  void vfio_device_put_registration(struct vfio_device *device);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 3df71bd9cd1e..d442ebaa4b21 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -430,6 +430,11 @@ int vfio_device_open(struct vfio_device_file *df)
>  		}
>  	}
>  
> +	/*
> +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> +	 * read/write/mmap
> +	 */
> +	smp_store_release(&df->access_granted, true);

Why is this happening outside of the first-open branch?  Thanks,

Alex


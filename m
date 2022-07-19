Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12E557A7C9
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 21:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiGST6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 15:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240082AbiGST5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 15:57:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 874AD5E304
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658260645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmfj/HdGo7zFRPrsqEE+zb+jXM6fuJ575jDepw2rtxo=;
        b=FcXRvr9axihcqd+i22QM0kkjJzF2iiIWq5VvQeLw+ThVrd7sYpa6Ji0f/94Hy+joXA7KVh
        qCpehDWmYHbyi0eDwWdt9DhRUccLQ9UTOCdaA9egL9V1UNzQzx4lSbWYAd93H/4/7yIxTu
        fFSPUsZR/X6H78FYyrgQDgdHRUjDsjo=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-9K8_AP-ZOrm36AsCz6OU1A-1; Tue, 19 Jul 2022 15:57:16 -0400
X-MC-Unique: 9K8_AP-ZOrm36AsCz6OU1A-1
Received: by mail-io1-f72.google.com with SMTP id u10-20020a6be30a000000b0067bcbb8a637so7247995ioc.3
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:57:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nmfj/HdGo7zFRPrsqEE+zb+jXM6fuJ575jDepw2rtxo=;
        b=TRNz6XEyVaKPJ+5g5uMYWXQdR3+b7x6GcLwuyNCEtir4F51L8PcxNGDhDNa/qIexqf
         j8Xq4lucJWHEl5saw3cKN7ZlP3vvVcXXLm+CG4o/sLt2FnhZ35FQx9IR8ipbpyYNJ9Rb
         BD1ehVYICQuCBXeQwHcQDIoRbbGVDTjSO+vePYab8ROdYIaJXiD0yBMPkYJxJamlU0a/
         5KKT1SQMqVESVUaAbmLgjf6zIPMhF2D4KusJSw/AsscizEmIJjfIXb7NOmLSNHOtF9Kg
         3o15D/cHbDhyUTz4h3FKT7QmqYbI33/RxcCetGBkYAI0j9evQc47knT5l1wJZLJ30XCi
         sY4w==
X-Gm-Message-State: AJIora8uyXgBmc2IfGTruNaDrYGjJI6+er5ZjW4ruLdTS2BB+3Me27KX
        fz9fPuHLgc0A/RtMoKNICnwo/pEpElslHAgARnkS0N1KARjhazsf+BeEKwxZqLwzkcMCDgQBzfJ
        PsRdrA7htva9V
X-Received: by 2002:a05:6638:3387:b0:33c:9f9e:5a17 with SMTP id h7-20020a056638338700b0033c9f9e5a17mr18235292jav.12.1658260636112;
        Tue, 19 Jul 2022 12:57:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sQetubxeBzqoGe5fqjeSCwtA6S4PWe6B2nZ4dj8f5zYaQba41N3W8PtWwuSRb7EBMTMQ3JGg==
X-Received: by 2002:a05:6638:3387:b0:33c:9f9e:5a17 with SMTP id h7-20020a056638338700b0033c9f9e5a17mr18235279jav.12.1658260635833;
        Tue, 19 Jul 2022 12:57:15 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i13-20020a02ca0d000000b00339c1f7130csm7099085jak.84.2022.07.19.12.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 12:57:15 -0700 (PDT)
Date:   Tue, 19 Jul 2022 13:57:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <20220719135714.330297ed.alex.williamson@redhat.com>
In-Reply-To: <49bb237a-5d95-f9fc-6d0b-8bcf082034c1@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
        <20220714081251.240584-4-yishaih@nvidia.com>
        <20220718162957.45ac2a0b.alex.williamson@redhat.com>
        <49bb237a-5d95-f9fc-6d0b-8bcf082034c1@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jul 2022 10:49:42 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 19/07/2022 1:29, Alex Williamson wrote:
> > On Thu, 14 Jul 2022 11:12:43 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >  
> >> DMA logging allows a device to internally record what DMAs the device is
> >> initiating and report them back to userspace. It is part of the VFIO
> >> migration infrastructure that allows implementing dirty page tracking
> >> during the pre copy phase of live migration. Only DMA WRITEs are logged,
> >> and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> >>
> >> This patch introduces the DMA logging involved uAPIs.
> >>
> >> It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.
> >>
> >> It exposes a PROBE option to detect if the device supports DMA logging.
> >> It exposes a SET option to start device DMA logging in given IOVAs
> >> ranges.
> >> It exposes a SET option to stop device DMA logging that was previously
> >> started.
> >> It exposes a GET option to read back and clear the device DMA log.
> >>
> >> Extra details exist as part of vfio.h per a specific option.  
> >
> > Kevin, Kirti, others, any comments on this uAPI proposal?  Are there
> > potentially other devices that might make use of this or is everyone
> > else waiting for IOMMU based dirty tracking?
> >
> >     
> >> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >> ---
> >>   include/uapi/linux/vfio.h | 79 +++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 79 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index 733a1cddde30..81475c3e7c92 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -986,6 +986,85 @@ enum vfio_device_mig_state {
> >>   	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
> >>   };
> >>   
> >> +/*
> >> + * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.
> >> + * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device supports
> >> + * DMA logging.
> >> + *
> >> + * DMA logging allows a device to internally record what DMAs the device is
> >> + * initiating and report them back to userspace. It is part of the VFIO
> >> + * migration infrastructure that allows implementing dirty page tracking
> >> + * during the pre copy phase of live migration. Only DMA WRITEs are logged,
> >> + * and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> >> + *
> >> + * When DMA logging is started a range of IOVAs to monitor is provided and the
> >> + * device can optimize its logging to cover only the IOVA range given. Each
> >> + * DMA that the device initiates inside the range will be logged by the device
> >> + * for later retrieval.
> >> + *
> >> + * page_size is an input that hints what tracking granularity the device
> >> + * should try to achieve. If the device cannot do the hinted page size then it
> >> + * should pick the next closest page size it supports. On output the device
> >> + * will return the page size it selected.
> >> + *
> >> + * ranges is a pointer to an array of
> >> + * struct vfio_device_feature_dma_logging_range.
> >> + */
> >> +struct vfio_device_feature_dma_logging_control {
> >> +	__aligned_u64 page_size;
> >> +	__u32 num_ranges;
> >> +	__u32 __reserved;
> >> +	__aligned_u64 ranges;
> >> +};
> >> +
> >> +struct vfio_device_feature_dma_logging_range {
> >> +	__aligned_u64 iova;
> >> +	__aligned_u64 length;
> >> +};
> >> +
> >> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3
> >> +
> >> +/*
> >> + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
> >> + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
> >> + */
> >> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4
> >> +
> >> +/*
> >> + * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA log
> >> + *
> >> + * Query the device's DMA log for written pages within the given IOVA range.
> >> + * During querying the log is cleared for the IOVA range.
> >> + *
> >> + * bitmap is a pointer to an array of u64s that will hold the output bitmap
> >> + * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to bits
> >> + * is given by:
> >> + *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
> >> + *
> >> + * The input page_size can be any power of two value and does not have to
> >> + * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START. The driver
> >> + * will format its internal logging to match the reporting page size, possibly
> >> + * by replicating bits if the internal page size is lower than requested.
> >> + *
> >> + * Bits will be updated in bitmap using atomic or to allow userspace to

s/or/OR/

> >> + * combine bitmaps from multiple trackers together. Therefore userspace must
> >> + * zero the bitmap before doing any reports.  
> > Somewhat confusing, perhaps "between report sets"?  
> 
> The idea was that the driver just turns on its own dirty bits and 
> doesn't touch others.

Right, we can aggregate dirty bits from multiple devices into a single
bitmap.

> Do you suggest the below ?
> 
> "Therefore userspace must zero the bitmap between report sets".

It may be best to simply drop this guidance, we don't need to presume
the user algorithm, we only need to make it apparent that
LOGGING_REPORT will only set bits in the bitmap and never clear or
preform any initialization of the user provided bitmap.

> >> + *
> >> + * If any error is returned userspace should assume that the dirty log is
> >> + * corrupted and restart.  
> > Restart what?  The user can't just zero the bitmap and retry, dirty
> > information at the device has been lost.  
> 
> Right
> 
> >   Are we suggesting they stop
> > DMA logging and restart it, which sounds a lot like failing a migration
> > and starting over.  Or could the user gratuitously mark the bitmap
> > fully dirty and a subsequent logging report iteration might work?
> > Thanks,
> >
> > Alex  
> 
> An error at that step is not expected and might be fatal.
> 
> User space can consider marking all as dirty and continue with that 
> approach for next iterations, maybe even without calling the driver.
> 
> Alternatively, user space can abort the migration and retry later on.
> 
> We can come with some rephrasing as of the above.
> 
> What do you think ?

If userspace needs to consider the bitmap undefined for any errno,
that's a pretty serious usage restriction that may negate the
practical utility of atomically OR'ing in dirty bits.  We can certainly
have EINVAL, ENOTTY, EFAULT, E2BIG, ENOMEM conditions that don't result
in a corrupted/undefined bitmap, right?  Maybe some of those result in
an incomplete bitmap, but how does the bitmap actually get corrupted?
It seems like such a condition should be pretty narrowly defined and
separate from errors resulting in an incomplete bitmap, maybe we'd
reserve -EIO for such a case.  The driver itself can also gratuitously
mark ranges dirty itself if it loses sync with the device, and can
probably do so at a much more accurate granularity than userspace.
Thanks,

Alex

> >> + *
> >> + * If DMA logging is not enabled, an error will be returned.
> >> + *
> >> + */
> >> +struct vfio_device_feature_dma_logging_report {
> >> +	__aligned_u64 iova;
> >> +	__aligned_u64 length;
> >> +	__aligned_u64 page_size;
> >> +	__aligned_u64 bitmap;
> >> +};
> >> +
> >> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 5
> >> +
> >>   /* -------- API for Type1 VFIO IOMMU -------- */
> >>   
> >>   /**  
> 
> 


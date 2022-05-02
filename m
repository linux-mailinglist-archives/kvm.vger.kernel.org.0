Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C0D51771A
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 21:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiEBTKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 15:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiEBTKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 15:10:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1B3EDE9A
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 12:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651518424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YMs1KO7tReJ868UWygCaWRLqhtk6BJZ1R1GoNbTZO/o=;
        b=jEieexz/P3LdWaGzQqe2uePaCb1ER+J/QGWmeRggXjDrp/iPySOncQFcYyevR/2A8wu1xA
        By7arLMwCEssowYfw0sUMNUYd7cL5EwCsGYQbQflUbr1F4HJJ7UgedM3MvhXTVXWqpAumQ
        h40TXIRMuL9xnICW4IwgvB25/yVL/Kw=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-rI64xx6SPnuWVoJogAb8Bw-1; Mon, 02 May 2022 15:07:04 -0400
X-MC-Unique: rI64xx6SPnuWVoJogAb8Bw-1
Received: by mail-io1-f72.google.com with SMTP id 204-20020a6b01d5000000b00657bb7a0f33so9435984iob.4
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 12:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YMs1KO7tReJ868UWygCaWRLqhtk6BJZ1R1GoNbTZO/o=;
        b=zLwFSogUZ6Ppl9evu65CKrg2GaOK0ahNO4UeAEHcRELADQjW5S1xDjysGBnMVkjYuG
         kRGU+78X6s0AcVmEMnhqg6wNpnprvuxaEXtXOTK1dZIa+nADNmdu99HpH/9/Os3Jfpgv
         XCUtWhDsN0d2GCbvE/Hgmr5hL9Vm7BaoRDfDc5q2Pt6yE5keuAINfZKpc4/WRs51J/Cr
         t9eD3STlEjkRFFYqCli4MEQu4IU1ivOa6ClLuccwCLmNSZ3btE2Zs0i/WmeevHT8Ots7
         Jsy6udaI2bTsvy0RDkppE8qJrChpRvt9m8l7ZvYl8FzrdOfxAhiM/OnQ2t4en0lpf2ML
         9IxQ==
X-Gm-Message-State: AOAM531DBlmVJ9E1/IEyC4f1rJS1VNBpXDrbngX6nW0dnHinhGcmzKtP
        WYnYPJB+LVVFEVawJs0WT6tihm7FcZjZJJdGSZEQuzzCsw7AMeBXAJwS9wP+HCxojOc+Un7i7II
        rsiM/oy+pS+fo
X-Received: by 2002:a05:6e02:1c82:b0:2cf:2b74:d155 with SMTP id w2-20020a056e021c8200b002cf2b74d155mr686537ill.4.1651518423051;
        Mon, 02 May 2022 12:07:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzycV+kimL2WO+mWbyGkiT40b5WeWQsX4U6EZxp5vNEI0sKquSMaYF5rEHHOCU0b0DFhdl1A==
X-Received: by 2002:a05:6e02:1c82:b0:2cf:2b74:d155 with SMTP id w2-20020a056e021c8200b002cf2b74d155mr686522ill.4.1651518422792;
        Mon, 02 May 2022 12:07:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p27-20020a02781b000000b0032b3a7817e2sm3257979jac.166.2022.05.02.12.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 12:07:02 -0700 (PDT)
Date:   Mon, 2 May 2022 13:07:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <maorg@nvidia.com>,
        <cohuck@redhat.com>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <cjia@nvidia.com>,
        <kwankhede@nvidia.com>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <eric.auger@redhat.com>
Subject: Re: [PATCH RFC] vfio: Introduce DMA logging uAPIs for VFIO device
Message-ID: <20220502130701.62e10b00.alex.williamson@redhat.com>
In-Reply-To: <20220501123301.127279-1-yishaih@nvidia.com>
References: <20220501123301.127279-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 1 May 2022 15:33:00 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> DMA logging allows a device to internally record what DMAs the device is
> initiation and report them back to userspace.
> 
> It is part of the VFIO migration infrastructure that allows implementing
> dirty page tracking during the pre-copy phase of live migration.
> 
> Only DMA WRITEs are logged, and this API is not connected to
> VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> 
> This RFC patch shows the expected usage of the DMA logging involved
> uAPIs for VFIO device-tracker.
> 
> It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.
> 
> It exposes a PROBE option to detect if the device supports DMA logging.
> 
> It exposes a SET option to start device DMA logging in given of IOVA
> ranges.
> 
> It exposes a SET option to stop device DMA logging that was previously
> started.
> 
> It exposes a GET option to read back and clear the device DMA log.
> 
> Extra details exist as part of vfio.h per a specific option in this RFC
> patch.
> 
> Note:
> To have IOMMU hardware support for dirty pages the below RFC [1] that
> was sent by Joao Martins can be referenced.
> 
> [1] https://lore.kernel.org/all/2d369e58-8ac0-f263-7b94-fe73917782e1@linux.intel.com/T/
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 80 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 80 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index fea86061b44e..9d0b7e73e999 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -986,6 +986,86 @@ enum vfio_device_mig_state {
>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>  };
>  
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.
> + * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device supports
> + * DMA logging.
> + *
> + * DMA logging allows a device to internally record what DMAs the device is
> + * initiation and report them back to userspace. It is part of the VFIO
> + * migration infrastructure that allows implementing dirty page tracking
> + * during the pre copy phase of live migration. Only DMA WRITEs are logged,
> + * and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> + *
> + * When DMA logging is started a range of IOVAs to monitor is provided and the
> + * device can optimize its logging to cover only the IOVA range given. Each
> + * DMA that the device initiates inside the range will be logged by the device
> + * for later retrieval.
> + *
> + * page_size is an input that hints what tracking granularity the device
> + * should try to achieve. If the device cannot do the hinted page size then it
> + * should pick the next closest page size it supports. On output the device
> + * will return the page size it selected.
> + *
> + * ranges is a pointer to an array of
> + * struct vfio_device_feature_dma_logging_range.
> + */
> +struct vfio_device_feature_dma_logging_control {
> +	__aligned_u64 page_size;
> +	__u32 num_ranges;
> +	__u32 __reserved;
> +	__aligned_u64 ranges;
> +};
> +
> +struct vfio_device_feature_dma_logging_range {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3
> +
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
> + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
> + */
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4

This seems difficult to use from a QEMU perspective, where a vfio
device typically operates on a MemoryListener and we only have
visibility to one range at a time.  I don't see any indication that
LOGGING_START is meant to be cumulative such that userspace could
incrementally add ranges to be watched, nor clearly does LOGGING_STOP
appear to have any sort of IOVA range granularity.  Is userspace
intended to pass the full vCPU physical address range here, and if so
would a single min/max IOVA be sufficient?  I'm not sure how else we
could support memory hotplug while this was enabled.

How does this work with IOMMU based tracking, I assume that if devices
share an IOAS we wouldn't be able to exclude devices supporting
device-level tracking from the IOAS log.

> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA log
> + *
> + * Query the device's DMA log for written pages within the given IOVA range.
> + * During querying the log is cleared for the IOVA range.
> + *
> + * bitmap is a pointer to an array of u64s that will hold the output bitmap
> + * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to bits
> + * is given by:
> + *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
> + *
> + * The input page_size can be any power of two value and does not have to
> + * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START. The driver
> + * will format its internal logging to match the reporting page size, possibly
> + * by replicating bits if the internal page size is lower than requested.

Or setting multiple bits if the internal page size is larger than
requested.

Is there a bitmap size limit?  We've minimally needed to impose limits
to reflect limitations of the bitmap code internally in the past.
Userspace needs a means to learn such limits.  Thanks,

Alex

> + *
> + * Bits will be updated in bitmap using atomic or to allow userspace to
> + * combine bitmaps from multiple trackers together. Therefore userspace must
> + * zero the bitmap before doing any reports.
> + *
> + * If any error is returned userspace should assume that the dirty log is
> + * corrupted and restart.
> + *
> + * If DMA logging is not enabled, an error will be returned.
> + *
> + */
> +struct vfio_device_feature_dma_logging_report {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +	__aligned_u64 page_size;
> +	__aligned_u64 bitmap;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 5
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E505177A0
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 21:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbiEBUCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 16:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiEBUCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 16:02:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 766A2627C
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 12:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651521520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lIgdxaD9cF0Fq3lRG6pYyTVBdpsMf74UgN9hADFh79w=;
        b=S3FBj+d76F4cOKHHC1FKC+HBTFrluATHQnDKumxZsUo3SwyvV136Ue19ywMcO9F5nM8GxN
        e8pJuXxrg92wa37OlIeT1D7ctPbKGSoQyLfqWh9HMilTT6/Wn/iDq6l592sywKOSlxNwzi
        2T13ff9+ZTLlIa/xUlKXILF3NFFV798=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-bRrfzVhHON6JNOa0uv_jTw-1; Mon, 02 May 2022 15:58:39 -0400
X-MC-Unique: bRrfzVhHON6JNOa0uv_jTw-1
Received: by mail-il1-f199.google.com with SMTP id j16-20020a056e02125000b002cc39632ab9so7793508ilq.9
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 12:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lIgdxaD9cF0Fq3lRG6pYyTVBdpsMf74UgN9hADFh79w=;
        b=YkhhvQ6uotpcRxU21scrO4PZyG01vcmb95xxci9t57N2J2qJ+aNTRGj9O2MQ7dOxkE
         ZJReobVHaQDyTPr4JzjL0VLM7bsLn6PEhtHtYec72BATr6c3EwcGlvuXOLaBCTLKZBGY
         LtgC1KSRYDnZWDyJq3Ad3JqYa67zuUW2f9s6a4lWiteZvz5FmzW4KsA1pc1yhnVd9Sn4
         fuFtYJHzUtDSfqiQECu+2WUFrr3U7Lx6B8IbG72oRWqxLhJJCVSpQzMV0yEmxpR+/+Xj
         qB60qKWimtJMFgvkuYe17mJi++uavP9rGzpE6TyXB0q2bmdvaY+p011pMNA+DhMVJcU9
         g5Dg==
X-Gm-Message-State: AOAM532gqk7cnzsv80IDKUuZJQ9GgRF0XDtdw2/iMrcDae+P2j9reBoX
        J9Wtiun/tVRkkwXgLgmxwDexooi0B4VEJNBarZJ9E+td+BzZCwdLREkdwCkRzaspwEe56TeARxC
        POVL3tLoHCCAr
X-Received: by 2002:a6b:ee12:0:b0:64d:2f8f:15bb with SMTP id i18-20020a6bee12000000b0064d2f8f15bbmr4692964ioh.16.1651521518754;
        Mon, 02 May 2022 12:58:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzi6e8f+eor4/r2ezP1kzbIxtjIPuRpLBC4cS8t9A9EsPGuqOE77H7dp/e/xB3RRm3KSM7uWw==
X-Received: by 2002:a6b:ee12:0:b0:64d:2f8f:15bb with SMTP id i18-20020a6bee12000000b0064d2f8f15bbmr4692962ioh.16.1651521518533;
        Mon, 02 May 2022 12:58:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u9-20020a02cb89000000b0032b7884915asm424685jap.175.2022.05.02.12.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 12:58:38 -0700 (PDT)
Date:   Mon, 2 May 2022 13:58:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, cohuck@redhat.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        eric.auger@redhat.com
Subject: Re: [PATCH RFC] vfio: Introduce DMA logging uAPIs for VFIO device
Message-ID: <20220502135837.49ad40aa.alex.williamson@redhat.com>
In-Reply-To: <20220502192541.GS8364@nvidia.com>
References: <20220501123301.127279-1-yishaih@nvidia.com>
        <20220502130701.62e10b00.alex.williamson@redhat.com>
        <20220502192541.GS8364@nvidia.com>
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

On Mon, 2 May 2022 16:25:41 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, May 02, 2022 at 01:07:01PM -0600, Alex Williamson wrote:
> 
> > > +/*
> > > + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
> > > + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
> > > + */
> > > +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4  
> > 
> > This seems difficult to use from a QEMU perspective, where a vfio
> > device typically operates on a MemoryListener and we only have
> > visibility to one range at a time.  I don't see any indication that
> > LOGGING_START is meant to be cumulative such that userspace could
> > incrementally add ranges to be watched, nor clearly does LOGGING_STOP
> > appear to have any sort of IOVA range granularity.    
> 
> Correct, at least mlx5 HW just cannot do a change tracking operation,
> so userspace must pre-select some kind of IOVA range to monitor based
> on the current VM configuration.
> 
> > Is userspace intended to pass the full vCPU physical address range
> > here, and if so would a single min/max IOVA be sufficient?    
> 
> At least mlx5 doesn't have enough capacity for that. Some reasonable
> in-between of the current address space, and maybe a speculative extra
> for hot plug.

Ah great, implicit limitations not reported to the user that I hadn't
even guessed!  How does a user learn about any limitations in the
number of ranges or size of each range?
 
> Multi-range is needed to support some arch cases that have a big
> discontinuity in their IOVA space, like PPC for instance.
> 
> > I'm not sure how else we could support memory hotplug while this was
> > enabled.  
> 
> Most likely memory hot plug events will have to take a 'everything got
> dirty' hit during pre-copy - not much else we can do with this HW.
> 
> > How does this work with IOMMU based tracking, I assume that if devices
> > share an IOAS we wouldn't be able to exclude devices supporting
> > device-level tracking from the IOAS log.  
> 
> Exclusion is possible, the userspace would have to manually create
> iommu_domains and attach devices to them with the idea that only
> iommu_domains for devices it wants to track would have dma dirty
> tracking turned on.

Well yeah, but that's the separate IOAS solution.

> But I'm not sure it makes much sense, if the iommu will track dirties,
> and you have to use it for another devices, then it is unlikely there
> will be a performance win to inject a device tracker as well.
> 
> In any case the two interfaces are orthogonal, I would not expect
> userspace to want to track with both, but if it does everything does
> work.
> 
> > Is there a bitmap size limit?    
> 
> Joao's code doesn't have a limit, it pulls user pages incrementally as
> it goes.
> 
> I'm expecting VFIO devices to use the same bitmap library as the IOMMU
> drivers so we have a consistent reporting.

I haven't reviewed that series in any detail yet, but it seems to
impose the same bitmap size and reporting to userspace features as
type1 based in internal limits of bitmap_set().  Thanks,

Alex


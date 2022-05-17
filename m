Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F9F52ACAD
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 22:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347382AbiEQU1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 16:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343619AbiEQU1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 16:27:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43430527F3
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652819221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RX9upDrgl+JlhubOZECKMiNUlSGALkg7zYaH+YeMTbs=;
        b=azQNIK+azywAg00boRt0qruoX7s2s07b46i1VIZJ48AiKn5xma/Zm0VQDghPnb/T29v5+S
        UfZEiwItpb1bc2/EC/YbOAI3iSfaOzzoldxYKtPi7ThO8K0sgaxwW1MuSB/eDarvYzK1i/
        EBmngRbrkDwV1N3ucw1aJL952Bx3jdo=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-BzniTu3IN-unUh0yZGsEFg-1; Tue, 17 May 2022 16:26:59 -0400
X-MC-Unique: BzniTu3IN-unUh0yZGsEFg-1
Received: by mail-io1-f69.google.com with SMTP id k2-20020a0566022d8200b0065ad142f8c1so13128761iow.12
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:26:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RX9upDrgl+JlhubOZECKMiNUlSGALkg7zYaH+YeMTbs=;
        b=szGEstr3BaYgtAuOom19Iv0mp/VA91VU2I1HwljFoS3bz8TV0c5BcF1f31sWvaooNT
         YTDTeT7wmVSvkK1u3GrhiXKC8HxtBxx+r3YXpowBKEiOo3Ft7UyqXcCh47yn5GNfiZxM
         yVdV3tBhgEaTfmvnFz3TdPQBBqfyBM0nKAN7n45DYqpG06f2REc4X8LnNTXcPaeG2Y5n
         vmluU0FrsqROUkXLmbl7hKd8jGHUb4obfg8WNaHaHjefiZiISuSFpcLlVdvybmjYv7hX
         vqDYOKH/O2m3294QIXP1x1RdrIr0VuRu/q5KIqhtUVJMfhRXrrUlmZZy2znPOPtmRV3Y
         ik9Q==
X-Gm-Message-State: AOAM530Y7eEMlGmpht9/HPVW1lGj84eM4qkAkyC/oFXD3n2MmoSuXFX2
        g/MuFsbv0iYH+p/EpMTUTqcZNcvt/cadWCCaxr1hD/IAww08vGlx4Hh8nLeqVEx3dLLMtniQ244
        aaPB43s370yLN
X-Received: by 2002:a92:cac4:0:b0:2c8:1095:b352 with SMTP id m4-20020a92cac4000000b002c81095b352mr11988155ilq.103.1652819218956;
        Tue, 17 May 2022 13:26:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeEI0mf6y/nWlK0I2cVK0c81aFILPDB/atAD9zcPbSBdqjQTCdzs8m0yRuQ4ofsMRcU9qzYw==
X-Received: by 2002:a92:cac4:0:b0:2c8:1095:b352 with SMTP id m4-20020a92cac4000000b002c81095b352mr11988133ilq.103.1652819218343;
        Tue, 17 May 2022 13:26:58 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id j12-20020a02cc6c000000b0032e0720e2ffsm19301jaq.86.2022.05.17.13.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:26:57 -0700 (PDT)
Date:   Tue, 17 May 2022 14:26:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Message-ID: <20220517142656.140deb10.alex.williamson@redhat.com>
In-Reply-To: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
References: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 May 2022 13:55:24 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This control causes the ARM SMMU drivers to choose a stage 2
> implementation for the IO pagetable (vs the stage 1 usual default),
> however this choice has no visible impact to the VFIO user. Further qemu
> never implemented this and no other userspace user is known.
> 
> The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
> new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
> SMMU translation services to the guest operating system" however the rest
> of the API to set the guest table pointer for the stage 1 was never
> completed, or at least never upstreamed, rendering this part useless dead
> code.
> 
> Since the current patches to enable nested translation, aka userspace page
> tables, rely on iommufd and will not use the enable_nesting()
> iommu_domain_op, remove this infrastructure. However, don't cut too deep
> into the SMMU drivers for now expecting the iommufd work to pick it up -
> we still need to create S2 IO page tables.
> 
> Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
> enable_nesting iommu_domain_op.
> 
> Just in-case there is some userspace using this continue to treat
> requesting it as a NOP, but do not advertise support any more.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ----------------
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       | 16 ----------------
>  drivers/iommu/iommu.c                       | 10 ----------
>  drivers/vfio/vfio_iommu_type1.c             | 12 +-----------
>  include/linux/iommu.h                       |  3 ---
>  include/uapi/linux/vfio.h                   |  2 +-
>  6 files changed, 2 insertions(+), 57 deletions(-)
> 
> It would probably make sense for this to go through the VFIO tree with Robin's
> ack for the SMMU changes.

I'd be in favor of applying this, but it seems Robin and Eric are
looking for a stay of execution and I'd also be looking for an ack from
Joerg.  Thanks,

Alex


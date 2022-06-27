Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5520E55C5B6
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbiF0WI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 18:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242692AbiF0WH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 18:07:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DC1B1EACF
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 15:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656367606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZ/0VFUsE1d9kZvm1sE1gAvxnVwUtDWBiRbGTRNr4sc=;
        b=HMi6E6FWvHZW/iiFd8MJ36OF1eDkQ5EAvfFfMsyhy3AZgae8Ttib8MohRmaXJDK+WOBHZE
        4LEWRGUMYZqsl4gYjBQRuF3uVal8HDmDTDcl+f365v8FWbqZ7joWP5pEYHSe9wU6PVc4FF
        uex2cHeJ4CrbKotF96b9rXbcqZOZh6Q=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-tZ1RGwrlMBGrpN5v-TTZIA-1; Mon, 27 Jun 2022 18:06:43 -0400
X-MC-Unique: tZ1RGwrlMBGrpN5v-TTZIA-1
Received: by mail-io1-f71.google.com with SMTP id o11-20020a6bcf0b000000b0067328c4275bso6290642ioa.8
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 15:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HZ/0VFUsE1d9kZvm1sE1gAvxnVwUtDWBiRbGTRNr4sc=;
        b=mmU63bswox7l2TdZdZUFNJ62QCxf9ipuDv16PwO7KotloSQfkD1I/rQ7J/MNLYMQBh
         Zr5512xaE6ZYbbXrLKJB1r2x8bg7slMkM7gkCdrTQnn7q1O43as9TrwQFNwULXElruxy
         GKZbikK+GLnoHeTwjMtgVZvHHs9yD3rDmsb4qnEDzR68+qXPDMPPn3PHUtPgz2VnlMm8
         6RQZZuol74JNU3q0/9Z64PVUAmrvvQJvsxW9jVuhpEOlDgQj+BO9Y5BGlK9dN2mQsMJN
         Ydhsi6kH6+21ADuSne8fp6/wa5vWR7plsP8E0hniZn38MtQxUW5MpgP0G5yl2sJh9Ava
         EzGA==
X-Gm-Message-State: AJIora+4S3x4SaHpgrOBPNoUE4zeNtjyjlTYQe4GVwrIgaP9C+mgKXOf
        ah4Hfpns0DN8c8S4mM1+bUjU1sZ3jembXwjSzDAIHNbB+01P7YdIzECNNptaaqxiFGM5u0erGhL
        sNKXoRYKvYDYB
X-Received: by 2002:a02:c503:0:b0:339:ec67:b0a4 with SMTP id s3-20020a02c503000000b00339ec67b0a4mr9354416jam.27.1656367602699;
        Mon, 27 Jun 2022 15:06:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vJu+p7efIp5RqCbZdmaWIB31YUy2oUvJlHvKxzgXHmLMwAfmlwT6tRQqUEqSDaByl6KgI3JA==
X-Received: by 2002:a02:c503:0:b0:339:ec67:b0a4 with SMTP id s3-20020a02c503000000b00339ec67b0a4mr9354407jam.27.1656367602497;
        Mon, 27 Jun 2022 15:06:42 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d137-20020a02628f000000b00339c5bff7c0sm5155314jac.134.2022.06.27.15.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 15:06:42 -0700 (PDT)
Date:   Mon, 27 Jun 2022 16:06:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     lizhe.67@bytedance.com, cohuck@redhat.com, jgg@ziepe.ca,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizefan.x@bytedance.com
Subject: Re: [PATCH] vfio: remove useless judgement
Message-ID: <20220627160640.7edca0dd.alex.williamson@redhat.com>
In-Reply-To: <20220627035109.73745-1-lizhe.67@bytedance.com>
References: <20220627035109.73745-1-lizhe.67@bytedance.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hey Steve, how did you get around this for cpr or is this a gap?
Thanks,

Alex

On Mon, 27 Jun 2022 11:51:09 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> In function vfio_dma_do_unmap(), we currently prevent process to unmap
> vfio dma region whose mm_struct is different from the vfio_dma->task.
> In our virtual machine scenario which is using kvm and qemu, this
> judgement stops us from liveupgrading our qemu, which uses fork() &&
> exec() to load the new binary but the new process cannot do the
> VFIO_IOMMU_UNMAP_DMA action during vm exit because of this judgement.
>
> This judgement is added in commit 8f0d5bb95f76 ("vfio iommu type1: Add
> task structure to vfio_dma") for the security reason. But it seems that
> no other task who has no family relationship with old and new process
> can get the same vfio_dma struct here for the reason of resource
> isolation. So this patch delete it.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Reviewed-by: Jason Gunthorpe <jgg@ziepe.ca>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c13b9290e357..a8ff00dad834 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1377,12 +1377,6 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  
>  		if (!iommu->v2 && iova > dma->iova)
>  			break;
> -		/*
> -		 * Task with same address space who mapped this iova range is
> -		 * allowed to unmap the iova range.
> -		 */
> -		if (dma->task->mm != current->mm)
> -			break;
>  
>  		if (invalidate_vaddr) {
>  			if (dma->vaddr_invalid) {


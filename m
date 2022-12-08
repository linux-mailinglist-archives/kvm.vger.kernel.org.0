Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BB36478BC
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiLHWTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHWTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 17:19:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE3B5F6F3
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 14:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670537924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94/PP0+bBPuGA++5Ttu5qGao1fJbqtQpvsckA3Zm8y8=;
        b=dsm27Aks2pvxIQeOxyY/FJ/YccPFxgmfTcGxmHd31w+90csTRsUE/MgnurrZRniS8c55+m
        X8Oq05agBHCzbFQxQPUoX2UCmJbeelE86OW8o5NXwWn5qSm9CP3kFZwR3NXJip4/ezaAVD
        UBY2DxFej3Anc+hUZtzSmze4wZmGV6Q=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-563-pKzXaxDsOcGGkl_xBafY4g-1; Thu, 08 Dec 2022 17:18:43 -0500
X-MC-Unique: pKzXaxDsOcGGkl_xBafY4g-1
Received: by mail-io1-f70.google.com with SMTP id g11-20020a6be60b000000b006e2c707e565so1059531ioh.14
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 14:18:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=94/PP0+bBPuGA++5Ttu5qGao1fJbqtQpvsckA3Zm8y8=;
        b=Zc8css80z3Wv1E77iX5H9YsqB17JqXcm26hGCmL1qmc5rV3zPvXFS6s+teEQA2Jqdo
         a1C+NlVRe2wKs2pC0hLuOr17WSUoIJPySXn1hrv4dzIiKOeEv58EBd7xMw0XNCQF08aS
         CkGeRrk8QxlTQft+lEru44Iz8E0OtWydoKsBlKGpp0XfJoFTUOY9cyjtGt2pVP5Vdr2H
         EmvCDf00a/NTK3x4hOGwybMbMKVKHy4JOzzjPlS8XAqu7OQip5fYMjFgTu4mw9mdFdg4
         5DWDtLcmsjSRLPfEzZr2soY9KLiwjFHKYK2U+sYyQipmiJLWmuAa4tXtXnzoPxaSy3I6
         5PhQ==
X-Gm-Message-State: ANoB5pngFlecE3hoK/FKGY5movPh8t3lAOLMh9wACX+5/rXlt5XX3i6L
        tYAPvEwqRdjEn9luut9rjNVdC9mrmqi1q507vybTFxF2aJF32+qJ9l50Eg7RJ2NdIXR4pDdvLCR
        Wfuj/U83OgKpe
X-Received: by 2002:a02:3f1d:0:b0:375:bee:4c7c with SMTP id d29-20020a023f1d000000b003750bee4c7cmr44527360jaa.161.1670537922709;
        Thu, 08 Dec 2022 14:18:42 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7KVPzmlH1tfn92n/KlLFtY21t5xBAMmMVtRmA2fwJEuOqW/LUpmfKgIVJF41g2nmLNBme9cA==
X-Received: by 2002:a02:3f1d:0:b0:375:bee:4c7c with SMTP id d29-20020a023f1d000000b003750bee4c7cmr44527357jaa.161.1670537922511;
        Thu, 08 Dec 2022 14:18:42 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t17-20020a02c491000000b00387c86afdbasm7098323jam.95.2022.12.08.14.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 14:18:41 -0800 (PST)
Date:   Thu, 8 Dec 2022 15:18:40 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
Message-ID: <20221208151840.3b0c0fdd.alex.williamson@redhat.com>
In-Reply-To: <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
        <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
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

On Tue,  6 Dec 2022 13:55:46 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Delete the interfaces that allow an iova range to be re-mapped in a new
> address space.  They allow userland to indefinitely block vfio mediated
> device kernel threads, and do not propagate the locked_vm count to a
> new mm.
> 
>   - disable the VFIO_UPDATE_VADDR extension
>   - delete VFIO_DMA_UNMAP_FLAG_VADDR
>   - delete most of VFIO_DMA_MAP_FLAG_VADDR (but keep some for use in a
>     new implementation in a subsequent patch).
> 
> Revert most of the code of these commits:
> 
>   441e810 ("vfio: interfaces to update vaddr")
>   c3cbab2 ("vfio/type1: implement interfaces to update vaddr")
>   898b9ea ("vfio/type1: block on invalid vaddr")
> 
> Revert these commits.  They are harmless, but no longer used after the
> above are reverted, and this kind of functionality is better handled by
> adding new methods to vfio_iommu_driver_ops.
> 
>   ec5e329 ("vfio: iommu driver notify callback")
>   487ace1 ("vfio/type1: implement notify callback")
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/container.c        |   5 --
>  drivers/vfio/vfio.h             |   7 --
>  drivers/vfio/vfio_iommu_type1.c | 144 ++--------------------------------------
>  include/uapi/linux/vfio.h       |  17 +----
>  4 files changed, 8 insertions(+), 165 deletions(-)

Picked just this patch and applied to the vfio next branch w/ my
follow-up patch to clean out the remainder of the VADDR code and mark
feature and flags as deprecated.  Added stable cc for both.  Thanks,

Alex


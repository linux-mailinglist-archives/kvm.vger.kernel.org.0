Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAB5733A70
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 22:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjFPUIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 16:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjFPUIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 16:08:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887652D79
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 13:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686946096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9FHIShx3ok7ttiJLXRHQNT2AZWHVgsob1KG47xjdjeI=;
        b=WtRbrUAyO+m3eICftPmvarLYZUAf7mkoXsDZ17qid9CGwz8ZomVIDweKN+OuBQGhaJajaN
        wdrAvOxqKA7PsN07qGZu0uHAVCmuyOZAgVCJ4mVgk3S+5sCuBeETSouHwDqnMByajBIMmY
        POHRAEdXncd8uRakzy7mLAwrq1tqscw=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57--3UDA5f6PnWQU1lntVIoMg-1; Fri, 16 Jun 2023 16:08:14 -0400
X-MC-Unique: -3UDA5f6PnWQU1lntVIoMg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-77b186093afso90243539f.0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 13:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686946093; x=1689538093;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9FHIShx3ok7ttiJLXRHQNT2AZWHVgsob1KG47xjdjeI=;
        b=gj8s/BwUgT35J05ScfFWkl83hRqw0lWnsT3bWeXCGZlzceD9BqA6B09KEFwFeWM0JN
         nupWPVyIgY0utOPuozHqr1HbofzEMmVjNEMykcbu7h2XI1aswHqeySAdZokn4q1mwtIt
         rgshdpHd5KFBQyPTAynsEDfgxEbCie+ACwtO9Af/mNvejd001m74+iUL6NV+B/vPmJXb
         kbMktxJ+dsOvYPbEeEpX3Mjfs8ACkL+83aFFA3Zn+bjR/y9Bo/DwhXacYqjF16NH9yF7
         9op+hY45ttMs+2Kv90ORS9qZUdnJNEKR9zO6CdXgfOQuE7y78CZTDoRuLJnxWDr4OQFk
         HwEg==
X-Gm-Message-State: AC+VfDyrYSaNm+vjP0XzM+YGjdGVCL3DAnAnpo2z+2N6x2ZN16jzu1Ot
        WxbTLy5wHzOVEyNPPyEoyB1nyhkNAsUeQ//i37HZNead8bzBjoBmj0nNJAlrWRCa86BIteicYHl
        eFuBGgpMJTYp9
X-Received: by 2002:a5e:a918:0:b0:76c:785f:8f82 with SMTP id c24-20020a5ea918000000b0076c785f8f82mr215182iod.6.1686946093473;
        Fri, 16 Jun 2023 13:08:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ62AjDXsrpmoKuXzeKWjRip2U0KfskgmXJGtEvG25rkOe8Yfqf6qCIZQe8RWyPyKG/yPo2gRA==
X-Received: by 2002:a5e:a918:0:b0:76c:785f:8f82 with SMTP id c24-20020a5ea918000000b0076c785f8f82mr215166iod.6.1686946093279;
        Fri, 16 Jun 2023 13:08:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s17-20020a6bdc11000000b007635e28bc11sm6820694ioc.6.2023.06.16.13.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 13:08:12 -0700 (PDT)
Date:   Fri, 16 Jun 2023 14:08:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     <jgg@ziepe.ca>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <masahiroy@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <nicolas@fjasle.eu>, <git@amd.com>,
        <harpreet.anand@amd.com>, <pieter.jansen-van-vuuren@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>
Subject: Re: [PATCH v7] vfio/cdx: add support for CDX bus
Message-ID: <20230616140811.548d2c92.alex.williamson@redhat.com>
In-Reply-To: <20230531124557.11009-1-nipun.gupta@amd.com>
References: <20230531124557.11009-1-nipun.gupta@amd.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 May 2023 18:15:57 +0530
Nipun Gupta <nipun.gupta@amd.com> wrote:

> vfio-cdx driver enables IOCTLs for user space to query
> MMIO regions for CDX devices and mmap them. This change
> also adds support for reset of CDX devices. With VFIO
> enabled on CDX devices, user-space applications can also
> exercise DMA securely via IOMMU on these devices.
> 
> This change adds the VFIO CDX driver and enables the following
> ioctls for CDX devices:
>  - VFIO_DEVICE_GET_INFO:
>  - VFIO_DEVICE_GET_REGION_INFO
>  - VFIO_DEVICE_RESET
> 
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Tested-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
> ---
> 
> Changed to support driver managed dma in CDX bus has been
> submitted at:
> https://lore.kernel.org/lkml/20230117134139.1298-1-nipun.gupta@amd.com/T/
> 
> Changes v6->v7:
> - updated GFP_KERNEL to GFP_KERNEL_ACCOUNT in kcalloc
> - remove redundant error condition
> - updated return codes

Applied to vfio next branch for v6.5.  Thanks,

Alex


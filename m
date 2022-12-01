Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFDC63FACA
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 23:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiLAWop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 17:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiLAWoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 17:44:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DEEDCB
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 14:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669934630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k4+7ejlOF0FKUf5gSKhn1iqodNLhlqAHPdkzMA3rYGY=;
        b=alOP6p2tY9YvO704KzRkgYF3S/w7hJCy775wPdlxHxGWfM18E4xkT/JSsIOiRdfL5PSZvh
        4jxKbWX/c6WwhxnsNuiksOOtzY0CYZg9fa5co7IdWK7ASvoyi+jqARq81HsYbO5JBowNdr
        SUV9JqCcCQ8m2wMqsErGHSRL21ZT4CI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-io6ujRXwNz-rUP02aIxVFw-1; Thu, 01 Dec 2022 17:43:49 -0500
X-MC-Unique: io6ujRXwNz-rUP02aIxVFw-1
Received: by mail-il1-f199.google.com with SMTP id h20-20020a056e021d9400b00300581edaa5so3438289ila.12
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 14:43:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k4+7ejlOF0FKUf5gSKhn1iqodNLhlqAHPdkzMA3rYGY=;
        b=yPf+p/r5Y/tUvLJMtgqLxgwCmcsj20at9J5m+/Y4hhzwgBHycfLjhHCcY/0M9gWJNT
         HwN1H1HLzXienl8BayRXQXrL2h2i4XFNHV3RIkai4xq391GWMwFBi5ioyY87tvAOIGmJ
         ytyCGnH4ZhraZ83wnr3i2Ikaiz48EHavNYwe2i1exvx6xO3YFb9MpEUId3YrAmVc7IcR
         g1NJVKHjD811ENwWEiVwe/hr5p0SPvY+sMOoe467D/LO5ActfSoK49ZGC1PjmnOATbrp
         Wdhso7juM1cztjeSz6RAYGJ7ol+9RiC96+prOIVO8YTFHMCJWq3TrOcV5vu2EkzKLITj
         E6YQ==
X-Gm-Message-State: ANoB5pmT3ETJtiRy4euWvE2KyzJtOOkNwSuqkMfrgPk8KC2BtxRRZd/G
        ysNRlwKnVP8z1kAfnmmZZRnC6Sw2KqaqHg1XdsTXkzCcEBx0affdBxgCJ8GzUPo2+nP6j/gl6Dm
        VjfyfWd8iLTCF
X-Received: by 2002:a5d:9ecc:0:b0:6d9:c117:7a1c with SMTP id a12-20020a5d9ecc000000b006d9c1177a1cmr27246309ioe.187.1669934628614;
        Thu, 01 Dec 2022 14:43:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7QDaNqZrsW4rcW2KBcbd1P3MMUirM8s0jXBZcswlpdNNJ0E0gNiLqOmhrMca0j3vWi619kPQ==
X-Received: by 2002:a5d:9ecc:0:b0:6d9:c117:7a1c with SMTP id a12-20020a5d9ecc000000b006d9c1177a1cmr27246299ioe.187.1669934628391;
        Thu, 01 Dec 2022 14:43:48 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s5-20020a056602168500b006bbfb3856d6sm2068339iow.5.2022.12.01.14.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:43:47 -0800 (PST)
Date:   Thu, 1 Dec 2022 15:43:46 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>,
        <cohuck@redhat.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V2 vfio 02/14] vfio: Extend the device migration
 protocol with PRE_COPY
Message-ID: <20221201154346.58e49361.alex.williamson@redhat.com>
In-Reply-To: <20221201152931.47913-3-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
        <20221201152931.47913-3-yishaih@nvidia.com>
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

On Thu, 1 Dec 2022 17:29:19 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> The optional PRE_COPY states open the saving data transfer FD before
> reaching STOP_COPY and allows the device to dirty track internal state
> changes with the general idea to reduce the volume of data transferred
> in the STOP_COPY stage.
> 
> While in PRE_COPY the device remains RUNNING, but the saving FD is open.
> 
> Only if the device also supports RUNNING_P2P can it support PRE_COPY_P2P,
> which halts P2P transfers while continuing the saving FD.
> 
> PRE_COPY, with P2P support, requires the driver to implement 7 new arcs
> and exists as an optional FSM branch between RUNNING and STOP_COPY:
>     RUNNING -> PRE_COPY -> PRE_COPY_P2P -> STOP_COPY
> 
> A new ioctl VFIO_MIG_GET_PRECOPY_INFO is provided to allow userspace to
> query the progress of the precopy operation in the driver with the idea it
> will judge to move to STOP_COPY at least once the initial data set is
> transferred, and possibly after the dirty size has shrunk appropriately.
> 
> This ioctl is valid only in PRE_COPY states and kernel driver should
> return -EINVAL from any other migration state.
> 
> Compared to the v1 clarification, STOP_COPY -> PRE_COPY is blocked
> and to be defined in future.
> We also split the pending_bytes report into the initial and sustaining
> values, e.g.: initial_bytes and dirty_bytes.
> initial_bytes: Amount of initial precopy data.
> dirty_bytes: Device state changes relative to data previously retrieved.
> These fields are not required to have any bearing to STOP_COPY phase.
> 
> It is recommended to leave PRE_COPY for STOP_COPY only after the
> initial_bytes field reaches zero. Leaving PRE_COPY earlier might make
> things slower.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c  |  74 ++++++++++++++++++++++-
>  include/uapi/linux/vfio.h | 122 ++++++++++++++++++++++++++++++++++++--
>  2 files changed, 190 insertions(+), 6 deletions(-)

This looks ok to me, so if you want to provide a branch for the first
patch we can move forward with the rest through the vfio tree as was
mentioned.

Comments and reviews still welcome, particularly I expect Shameer has
already reviewed this for the hisi-acc implementation.  Thanks,

Alex


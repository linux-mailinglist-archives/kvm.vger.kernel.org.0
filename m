Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AD66220EE
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 01:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKIAnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 19:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKIAnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 19:43:37 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE3912D3B
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 16:43:35 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id hh9so9613599qtb.13
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 16:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qZpiZmrUvCfPtBR1TeJ+FM1FAuTKRXAgy3PSmsZRMyo=;
        b=SvoSXYgoYQUvz85DastB10X2PmNmCVo86EC6nwRD0LJAuuqqCSp66IKEsjGAETw+EN
         PP1968e2RTDOF/qyPJ0HB173UgImb51yz7+LZgIzl1lPs6NnFnxpO9ImIw9PAp9E6dpK
         3akDK5u0a8LEQ2fo9Z+anFx/ox9ayPZBYPw8aLAIYQLdtwPmH/A2eC07e6tapG6iddfd
         Exip3a9zC/rk7qnLq9Z01ECc4E5cq98Pos0dt9ugaOKos0bPgo5vPATLzYUP/5m3DgE8
         2HqaqKjZOY+zylckRjSuSXkT99MzuPbE2cBAkTiEA2OSIvTO0jEhDE3gpLFFrp8KnFqL
         B2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qZpiZmrUvCfPtBR1TeJ+FM1FAuTKRXAgy3PSmsZRMyo=;
        b=zuWU13j8D3SZ1878XXqPGYlo8KaSQ+Vg52N8cii4RRaYVo+Ig379PkXQ8BCCAPa98x
         l/PXOnnFHym+rretvHfawWI+uJSkSxVjSG7oFh4RlssEwI8wIHxcBLwsAZ5PSXeYm098
         r0QWmT99WgypK+hyYRhH4NmcLeow0PLFZButccXZZlkZ2T4aPyvttLaEHtRfZOdgWSyP
         5feC396Cw6PEiNQxL9N1y4pxX5mtmePwOxDXgDihFuaUVRZNN9g+CrD7L52aJHuM5vsn
         4TKzCYiKgNPIpvcYdd5wIXfpZ3eJzS87FDiDnRcAIp3QgWPJliIoiu7H/tHCtj/mhHwx
         suPw==
X-Gm-Message-State: ACrzQf1g5xIEdL1EEcbYz3h1p2uzIs6hf5d07xYe6dU46QY5g+wb2no+
        BbfBKuCq0QSAk7zuq+P5TfuNoA==
X-Google-Smtp-Source: AMsMyM7TProS2w7iBSB4nY3UiX2hZr7xp7e/ItyV872FSIrGnGoRUj3GV5mSyw1Oq04FJPHlpQ7M1A==
X-Received: by 2002:ac8:6998:0:b0:3a5:410a:1a33 with SMTP id o24-20020ac86998000000b003a5410a1a33mr31470392qtq.337.1667954614038;
        Tue, 08 Nov 2022 16:43:34 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id v14-20020a05620a440e00b006fab416015csm9416174qkp.25.2022.11.08.16.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:43:33 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1osZBj-00HZmk-WA;
        Tue, 08 Nov 2022 20:43:32 -0400
Date:   Tue, 8 Nov 2022 20:43:31 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     kvm@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: Re: [PATCH v5 1/3] vfio: Fix container device registration life cycle
Message-ID: <Y2r3syYBbIdb8dr4@ziepe.ca>
References: <20221105224458.8180-1-ajderossi@gmail.com>
 <20221105224458.8180-2-ajderossi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105224458.8180-2-ajderossi@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 05, 2022 at 03:44:56PM -0700, Anthony DeRossi wrote:
> In vfio_device_open(), vfio_container_device_register() is always called
> when open_count == 1. On error, vfio_device_container_unregister() is
> only called when open_count == 1 and close_device is set. This leaks a
> registration for devices without a close_device implementation.
> 
> In vfio_device_fops_release(), vfio_device_container_unregister() is
> called unconditionally. This can cause a device to be unregistered
> multiple times.
> 
> Treating container device registration/unregistration uniformly (always
> when open_count == 1) fixes both issues.
> 
> Fixes: ce4b4657ff18 ("vfio: Replace the DMA unmapping notifier with a callback")
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> ---
>  drivers/vfio/vfio_main.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

This seems to only effect the mbochs sample, but it looks OK

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

This will generate conflicts with the iommufd treee, so please lets
think about how to avoid them..

Jason

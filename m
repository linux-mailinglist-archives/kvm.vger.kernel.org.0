Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091F0435423
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 21:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhJTTzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 15:55:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230484AbhJTTzJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 15:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634759574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TAteW0jZ0sdNj3bdDG1k/ScxBVg5AqdPo8otMjjySxY=;
        b=b8UCRTf5MwYPuBX5vgqnhaA3nL6fp+Du6VNkOdIfdp5gtootJyOBzCKfax9NNdWK+LBTeo
        JYs0dBRGSCmXO5wPS9En/J0FXbKK449gHIjl5F7csN7nFHTZbAyElP59o7YYZRmkM2ZwHf
        +q1VH+lDkWyyEl9uqkZeejG/PwrwoMs=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-mSLyW0bPPbeXVcKCpddsPw-1; Wed, 20 Oct 2021 15:52:52 -0400
X-MC-Unique: mSLyW0bPPbeXVcKCpddsPw-1
Received: by mail-ot1-f71.google.com with SMTP id o23-20020a9d7197000000b0054e537c6628so4245369otj.14
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 12:52:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TAteW0jZ0sdNj3bdDG1k/ScxBVg5AqdPo8otMjjySxY=;
        b=1tmOx20bmoWDJuWiC7nfccAsLXztMsZ6S7dnkjZxYkFEkPCQk7UMzf60STIqpBEztG
         WXBwo/ntcaLlynga9oOIWT1mcZQZTn7VLwBhWEraII4Rab3TaGSMowPmO6zvzTAfyCM2
         l9Mo/egsJ5juII1iE8EFxb2qgfOcBZF3wlyzQ7bbrlIYy2vFfzV7v4T53EFe4U13B4bK
         d+g5jN8slxVgqsFQ6d2TMMXybWwjpsAhG9wR04cFbSbbg0caCb70sVJltq/FDanM2vx5
         1E1evx24OIdnZz1FJoXBfUYe0ez0WsThqSBqus7GoylZb+McstUmfsSeqDqyxBiTjlQh
         O7dw==
X-Gm-Message-State: AOAM5328pr+wnPXMiw7XRJFPlw+0pkSen+d6CB2ws4QtStlrFIIjz71X
        nCRyiTKcKEGjjHJnyIVSh++xLWk6DifWks0+RVHGenwU9JeDoKW5lJwOx4pEOKhvr2HtwjyeGvE
        w0XU0GUotSoFA
X-Received: by 2002:a05:6830:101:: with SMTP id i1mr1012112otp.107.1634759572082;
        Wed, 20 Oct 2021 12:52:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZlCUgEaIYe66/0c8z6HHUVNQU6iZcSCYu7Cq4OXr07UD4vmiW2VwnS7uAcCkU0oLkeEs1kw==
X-Received: by 2002:a05:6830:101:: with SMTP id i1mr1012092otp.107.1634759571849;
        Wed, 20 Oct 2021 12:52:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e1sm680150oiw.16.2021.10.20.12.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:52:51 -0700 (PDT)
Date:   Wed, 20 Oct 2021 13:52:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v3 0/5] Update vfio_group to use the modern cdev
 lifecycle
Message-ID: <20211020135250.76821d83.alex.williamson@redhat.com>
In-Reply-To: <0-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
References: <0-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Oct 2021 08:40:49 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> These days drivers with state should use cdev_device_add() and
> cdev_device_del() to manage the cdev and sysfs lifetime. This simple
> pattern ties all the state (vfio, dev, and cdev) together in one memory
> structure and uses container_of() to navigate between the layers.
> 
> This is a followup to the discussion here:
> 
> https://lore.kernel.org/kvm/20210921155705.GN327412@nvidia.com/
> 
> This builds on Christoph's work to revise how the vfio_group works and is
> against the latest VFIO tree.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_group_cdev
> 
> v3:
>  - Streamline vfio_group_find_or_alloc()
>  - Remove vfio_group_try_get() and just opencode the refcount_inc_not_zero
> v2: https://lore.kernel.org/r/0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com
>  - Remove comment before iommu_group_unregister_notifier()
>  - Add comment explaining what the WARN_ONs vfio_group_put() do
>  - Fix error logic around vfio_create_group() in patch 3
>  - Add horizontal whitespace
>  - Clarify comment is refering to group->users
> v1: https://lore.kernel.org/r/0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com
> 
> Cc: Liu Yi L <yi.l.liu@intel.com>
> Cc: "Tian, Kevin" <kevin.tian@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (5):
>   vfio: Delete vfio_get/put_group from vfio_iommu_group_notifier()
>   vfio: Do not open code the group list search in vfio_create_group()
>   vfio: Don't leak a group reference if the group already exists
>   vfio: Use a refcount_t instead of a kref in the vfio_group
>   vfio: Use cdev_device_add() instead of device_create()
> 
>  drivers/vfio/vfio.c | 381 +++++++++++++++++---------------------------
>  1 file changed, 149 insertions(+), 232 deletions(-)

Applied to vfio next branch for v5.16.  Thanks,

Alex


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF625F14EC
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 23:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiI3VcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 17:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiI3VcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 17:32:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C965197F29
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 14:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664573518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pGkWMTg66lPlawlfmY1q2ZECHFVFGNdAgfMQyGIB/3c=;
        b=RSushoY6/se/S/0pZXLujvgkB2UAjzjV8mOTE5l1wggGsMBwjGPUAqClyBbEuTgtZWy14z
        ddE6c071ngzeR7YTgGVYih1y0/7s77NOtySK/ydDKD1RGMGpoZ0MCqPG3JWfCSWoB/vjJR
        UHF72DOxCfq0iSMDr0rDHtnXXU0ItpQ=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-u6qEiubzOHyQ_HvE7tP9OQ-1; Fri, 30 Sep 2022 17:31:57 -0400
X-MC-Unique: u6qEiubzOHyQ_HvE7tP9OQ-1
Received: by mail-il1-f199.google.com with SMTP id g1-20020a92cda1000000b002f612391d5bso4311820ild.2
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 14:31:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=pGkWMTg66lPlawlfmY1q2ZECHFVFGNdAgfMQyGIB/3c=;
        b=Ja0VnF1FK+LaJjwIdwqkwS5d+jW2x025HHPBtt6Qqv1SGe12DJAN0Uz0SX7fLTtYR1
         6ZP9C04gP1IGz4ltcpH8VK4uXc6SyPJkoburEgKRnqBBT5LXJkMOOqgUBWm87W8aidPV
         0o0ky0JUgq/GefP1KT+QYsF/w8+/NmRxlfGJpQjFj2840u++iKyQ6IrI/9gx5aczwe/o
         +6hZj7gSbgo3qGAJLUpEj/ndWTcYKOmlxBMDlAd23psWtz7YW5OUG3FrEQkUF1hodefu
         Aa4E7w+G10QjmkzJcBgzLjc+vIJbFW85qUcLW6UsFb7I2wUpXIRIwoOAiwb1jAwlQpy0
         WaSA==
X-Gm-Message-State: ACrzQf32kvFGD29ILBijgaQYnIHsSP9rtdhksyGKq5aFHp4q4Vs0XYvF
        bRYh2otKdwLy6oxiLOCUL1w7Ix1z+UqD1TI6Ny8DLcmKgi99cXDoiIcY3Ppa6XNvSeH19a7o3M6
        /YgrCxBzDk+af
X-Received: by 2002:a02:a313:0:b0:35b:877:1d11 with SMTP id q19-20020a02a313000000b0035b08771d11mr5756865jai.120.1664573517143;
        Fri, 30 Sep 2022 14:31:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4C+kISRDVgKGEULXrlyMkNpE7N94H+pcP3Sc6apakJteVRd2TGm4hgfsE6vRmmX3OxwOu6Cg==
X-Received: by 2002:a02:a313:0:b0:35b:877:1d11 with SMTP id q19-20020a02a313000000b0035b08771d11mr5756855jai.120.1664573516942;
        Fri, 30 Sep 2022 14:31:56 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z7-20020a92cec7000000b002f19d9838c6sm1342914ilq.25.2022.09.30.14.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 14:31:55 -0700 (PDT)
Date:   Fri, 30 Sep 2022 15:31:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] Simplify some of the locking in vfio_group
Message-ID: <20220930153154.4d0b2882.alex.williamson@redhat.com>
In-Reply-To: <0-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
References: <0-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Sep 2022 11:59:23 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Kevin points out that the vfio_group->users doesn't really need to exist
> now, and some other inspection shows that the group_rwsem has outlived its
> utility as well. Replace both with simpler constructs.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (2):
>   vfio: Remove the vfio_group->users and users_comp
>   vfio: Change vfio_group->group_rwsem to a mutex
> 
>  drivers/vfio/container.c | 10 ++---
>  drivers/vfio/vfio.h      |  5 +--
>  drivers/vfio/vfio_main.c | 92 +++++++++++++++++++---------------------
>  3 files changed, 50 insertions(+), 57 deletions(-)
> 
> 
> base-commit: 42e1d1eed20a17c6cbb1d600c77a6ca69a632d4c

Applied to vfio next branch for v6.1.  Thanks,

Alex


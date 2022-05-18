Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2452C1C2
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241246AbiERRvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241244AbiERRvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:51:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8000D36E21
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652896290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ewfT51o0ypFUSEVlm40AQIOPjFcrO0z8pqklHpRxlg=;
        b=BVerOaxLOxF7Jr/MeG5ZloQBU7gTxs2XhPM7+bvJgka4qiJlJ+wK/WhIt7AH4mAG7mCjer
        HwXL1lLGKRzXAHnElZaS3g7W95Au3Od1xp5UD3GF/BWtyarOtV4SRNT94lGku4X8GWB3h+
        RGOs9Nv3fejnLemxKOj/Tfqw/smNMnI=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-arS164f4PSWMxzw7cEulaw-1; Wed, 18 May 2022 13:51:29 -0400
X-MC-Unique: arS164f4PSWMxzw7cEulaw-1
Received: by mail-il1-f200.google.com with SMTP id k6-20020a056e02156600b002cf4afa295bso1681427ilu.8
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2ewfT51o0ypFUSEVlm40AQIOPjFcrO0z8pqklHpRxlg=;
        b=3y98nEuhu+uEu41JPmfW+OX9AG1yOejPZfDYWWXcCGu1q4F9wh16sWSIBLFjNKFoiD
         aypmfwHSPVyUNFwlojaDB4NLu+UDVbPtzEf4qpxkQ79yPDZa1rXIcTuHj6awob/KwAPu
         ovAMDDdl9NKZegng/Pm1BGxvproQCkZmDcq6T/B+Lrp0TR5oxAFhNigYDA4E2GTdeUuu
         SPHJjCyb18YFb5t9wlQL3JHJEwFbgXGkTuXhKdDALNQAMJxuBbNPSst7jKqnV0XSRbVS
         fIxRF2wmVI679l9Rfs5qjLKnHSWlHxkoHgmkxkZZnmrSjsyDhiBimM7zd8YIAVCpv6W9
         ZFqA==
X-Gm-Message-State: AOAM5304w6C2ShSOzVzHKnwIqX5tfPYMDkArSHWIoHJLogbYYhCMMCPE
        df6pYLHfCx1Xblx7dz7du+TYCy19rs7dDUhZJ+JDpCVziRCwcgAYmGKyXZxHdtNRRCnmbW3CqwK
        Aq1H4Aj8FrWOu
X-Received: by 2002:a05:6602:2b0d:b0:649:b2f:6290 with SMTP id p13-20020a0566022b0d00b006490b2f6290mr409624iov.94.1652896288277;
        Wed, 18 May 2022 10:51:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzMqzc7BoYIMw+I22nVBTVW38QHUyvGvqhqWypNpqBTVfXH+Qj2isYEocpZAbxr9rgUc5mJA==
X-Received: by 2002:a05:6602:2b0d:b0:649:b2f:6290 with SMTP id p13-20020a0566022b0d00b006490b2f6290mr409614iov.94.1652896288051;
        Wed, 18 May 2022 10:51:28 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x1-20020a920601000000b002cde6e352e1sm707844ilg.43.2022.05.18.10.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 10:51:27 -0700 (PDT)
Date:   Wed, 18 May 2022 11:51:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v2 0/6] Fully lock the container members of struct
 vfio_group
Message-ID: <20220518115126.15f3634d.alex.williamson@redhat.com>
In-Reply-To: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
References: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 May 2022 20:41:16 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The atomic based scheme for tracking the group->container and group->kvm
> has two race conditions, simplify it by adding a rwsem to protect those
> values and related and remove the atomics.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_group_locking
> 
> v2:
>  - Updated comments and commit messages
>  - Rebased on vfio next
>  - Left the dev_warn in place, will adjust it later
>  - s/singleton_file/opened_file/
> v1: https://lore.kernel.org/r/0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com
> 
> Cc: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (6):
>   vfio: Add missing locking for struct vfio_group::kvm
>   vfio: Change struct vfio_group::opened from an atomic to bool
>   vfio: Split up vfio_group_get_device_fd()
>   vfio: Fully lock struct vfio_group::container
>   vfio: Simplify the life cycle of the group FD
>   vfio: Change struct vfio_group::container_users to a non-atomic int
> 
>  drivers/vfio/vfio.c | 266 +++++++++++++++++++++++++++-----------------
>  1 file changed, 163 insertions(+), 103 deletions(-)
> 
> 
> base-commit: 6a985ae80befcf2c00e7c889336bfe9e9739e2ef

Applied to vfio next branch for v5.19.  Thanks!

Alex


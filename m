Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316DD7CE45F
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjJRRZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjJRRZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:25:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF644496
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 10:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697649895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5AOd0/hJo+xQgO9OcEYZKv2n43WMiR7HBnvKw0ANJXA=;
        b=RpLe8K5mAbONvk3pVUNsI4+KdLJWkb4Zd9ewl7cxXQAdsznE4rGSePUyLJFZV8w27RY0b4
        i9ifvv9a0k6avUvykWdoY4WksisMo9a39GlOOQELElu2KislSdpYgCyQbG6VKGGHfv+yCk
        uTlHixqRbVjrgO5F6jvHbypvUdwpEc4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-mK0c5G8dPmCtZRQRB0f9XQ-1; Wed, 18 Oct 2023 13:24:53 -0400
X-MC-Unique: mK0c5G8dPmCtZRQRB0f9XQ-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2c5047f94bdso42264871fa.1
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 10:24:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697649892; x=1698254692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5AOd0/hJo+xQgO9OcEYZKv2n43WMiR7HBnvKw0ANJXA=;
        b=hR97AhCYFTi/PUDZnQ5Q8VMke6bXAaoUzwBeVg8U28S1b4HhrpfUl9s+lcVCgiFQX6
         BSkAhCLgTtJ/EEbZY1EYMv1w3ll175iSE9Lvzwb5FPhi6iKoHu6YreYjCtmA86stUZl1
         LWR54wnHVx+s3bqeBbxS4ydKjc0ULw0lH6HLJY8zJXa+Vh0YrFt7Q8v8qB2xZHlgdNgC
         mN7MLuIwWaTlnujqDjPAt/A04YC86+hcWsfwb37g0JsqUuVCceSyDrJ3Dvvi9CZLfRwv
         EGrC+Gh8PQ6fobuMi/A1sezGDWGtgElnP0FY6ecCLACEFsgakJ/fZ+ZVLb7CJxNcpQOA
         MzbQ==
X-Gm-Message-State: AOJu0YxTTq1bsVm2x7ZoqzP0A6hQWGyz7c7slWsYsvi59da1i69h1pTK
        UEOVhFlFNIzIZwxfRCdzgg3aI/g4WTsY/tx0Nc3MF2PpTZX92AfzEYdtPp+j7PzIX8dFAtjKyxo
        xGz9wQb0CRh7I
X-Received: by 2002:a2e:3619:0:b0:2bf:a9b6:d254 with SMTP id d25-20020a2e3619000000b002bfa9b6d254mr3934011lja.50.1697649892292;
        Wed, 18 Oct 2023 10:24:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBwF/FZH/EqE5Pe6mKGEiyQtBuyLQcUH3K5SG7IYfDvAmL8IFrvXOTzgtqDTf2JFbCaqPxsA==
X-Received: by 2002:a2e:3619:0:b0:2bf:a9b6:d254 with SMTP id d25-20020a2e3619000000b002bfa9b6d254mr3933990lja.50.1697649891837;
        Wed, 18 Oct 2023 10:24:51 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f2:2037:f34:d61b:7da0:a7be])
        by smtp.gmail.com with ESMTPSA id r9-20020a05600c320900b0040644e699a0sm2184668wmp.45.2023.10.18.10.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:24:51 -0700 (PDT)
Date:   Wed, 18 Oct 2023 13:24:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Dragos Tatulea <dtatulea@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v4 00/16] vdpa: Add support for vq descriptor
 mappings
Message-ID: <20231018132347-mutt-send-email-mst@kernel.org>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 08:14:39PM +0300, Dragos Tatulea wrote:
> This patch series adds support for vq descriptor table mappings which
> are used to improve vdpa live migration downtime. The improvement comes
> from using smaller mappings which take less time to create and destroy
> in hw.
> 
> The first part adds the vdpa core changes from Si-Wei [0].
> 
> The second part adds support in mlx5_vdpa:
> - Refactor the mr code to be able to cleanly add descriptor mappings.
> - Add hardware descriptor mr support.
> - Properly update iotlb for cvq during ASID switch.
> 
> Changes in v4:
> 
> - Improved the handling of empty iotlbs. See mlx5_vdpa_change_map
>   section in patch "12/16 vdpa/mlx5: Improve mr upate flow".
> - Fixed a invalid usage of desc_group_mkey hw vq field when the
>   capability is not there. See patch
>   "15/16 vdpa/mlx5: Enable hw support for vq descriptor map".

At this point, whether this patchset makes it in 6.7 will largely depend
on how many rcs there are in 6.6, so it can get some time in next.


> Changes in v3:
> 
> - dup_iotlb now checks for src == dst case and returns an error.
> - Renamed iotlb parameter in dup_iotlb to dst.
> - Removed a redundant check of the asid value.
> - Fixed a commit message.
> - mx5_ifc.h patch has been applied to mlx5-vhost tree. When applying
>   this series please pull from that tree first.
> 
> Changes in v2:
> 
> - The "vdpa/mlx5: Enable hw support for vq descriptor mapping" change
>   was split off into two patches to avoid merge conflicts into the tree
>   of Linus.
> 
>   The first patch contains only changes for mlx5_ifc.h. This must be
>   applied into the mlx5-vdpa tree [1] first. Once this patch is applied
>   on mlx5-vdpa, the change has to be pulled fom mlx5-vdpa into the vhost
>   tree and only then the remaining patches can be applied.
> 
> [0] https://lore.kernel.org/virtualization/1694248959-13369-1-git-send-email-si-wei.liu@oracle.com
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vhost
> 
> Dragos Tatulea (13):
>   vdpa/mlx5: Expose descriptor group mkey hw capability
>   vdpa/mlx5: Create helper function for dma mappings
>   vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code
>   vdpa/mlx5: Take cvq iotlb lock during refresh
>   vdpa/mlx5: Collapse "dvq" mr add/delete functions
>   vdpa/mlx5: Rename mr destroy functions
>   vdpa/mlx5: Allow creation/deletion of any given mr struct
>   vdpa/mlx5: Move mr mutex out of mr struct
>   vdpa/mlx5: Improve mr update flow
>   vdpa/mlx5: Introduce mr for vq descriptor
>   vdpa/mlx5: Enable hw support for vq descriptor mapping
>   vdpa/mlx5: Make iotlb helper functions more generic
>   vdpa/mlx5: Update cvq iotlb mapping on ASID change
> 
> Si-Wei Liu (3):
>   vdpa: introduce dedicated descriptor group for virtqueue
>   vhost-vdpa: introduce descriptor group backend feature
>   vhost-vdpa: uAPI to get dedicated descriptor group id
> 
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  31 +++--
>  drivers/vdpa/mlx5/core/mr.c        | 194 ++++++++++++++++-------------
>  drivers/vdpa/mlx5/core/resources.c |   6 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 105 +++++++++++-----
>  drivers/vhost/vdpa.c               |  27 ++++
>  include/linux/mlx5/mlx5_ifc.h      |   8 +-
>  include/linux/mlx5/mlx5_ifc_vdpa.h |   7 +-
>  include/linux/vdpa.h               |  11 ++
>  include/uapi/linux/vhost.h         |   8 ++
>  include/uapi/linux/vhost_types.h   |   5 +
>  10 files changed, 272 insertions(+), 130 deletions(-)
> 
> -- 
> 2.41.0


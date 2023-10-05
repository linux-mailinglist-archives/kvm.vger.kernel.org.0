Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24597BA9EB
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 21:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjJETTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 15:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbjJETTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 15:19:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8243C98
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 12:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696533513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2R8nvS1fGysVMS5a70TnQ+euq+3ceDHbf0f2W4kS2b4=;
        b=YEYT4lWvpl4ZjSkxKuMIdLg8RcnEbUV7llXv6ShimJYgcHacNhhGIHkaR3GRopUphsqz7E
        jZxUYLecdUNkmAagJEPWJDFffitGN2SXNff8tZ5Je+sddJMXMVUYA/dyfu1tGsrd8FlzCV
        nB33ysQJ2EFyRuVLeNXihvuerZeLYeI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-wLT3cMAENXaUFBP1jeiCng-1; Thu, 05 Oct 2023 15:18:31 -0400
X-MC-Unique: wLT3cMAENXaUFBP1jeiCng-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fe182913c5so9951205e9.0
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 12:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696533510; x=1697138310;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2R8nvS1fGysVMS5a70TnQ+euq+3ceDHbf0f2W4kS2b4=;
        b=Jga4No1k+x1R/FTzxrsdtOf1cAuTYAAJRbKYkr3yuH8VnYMgagH8leHRGNGwqKsRz2
         +qx6wY62PWL17rKlHXqw/onPvdQV2cLCPysCmWVSeRyxmiyT3N9Y3A7XWZqEpDptqHOZ
         AA0I2Ow4asUsBZ8c/2OoQirHQJoKBZn+DZPPe7o31Jsfcp/c3ihQItreErbvwE7Ji8tE
         YFqO5v/U/3cE1KWbm6Erm3ltrHl5G/LbExveqbHnkZoaAANGidgbOMza4cEH9mQlIcP3
         MVRQuwfc66XX1j64amf9scKw/bulpmlu+E/gjxww9aeq40N6C2t/2jGs/gfphfeLkGLr
         KiEg==
X-Gm-Message-State: AOJu0YzMrqMaWk7EUDThbJPEFed1DnJ3Toy6yV6jEcE3FWrqjt+q6OKc
        Ww8E0SK+w4msqIRfX8Z/STsoBhgf4w0SrCsugBPX8uCN9A32ku8HycXvlvtTPudQ6w+0UL8zDW4
        1Snhis0ALMOb5
X-Received: by 2002:a5d:58c2:0:b0:319:7a9f:c63 with SMTP id o2-20020a5d58c2000000b003197a9f0c63mr5707832wrf.50.1696533510572;
        Thu, 05 Oct 2023 12:18:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJSoSJCYUxP/9cvc2Te2pM2upBQSmDoYt/HKnGitt6LjIRBQVlh0qAuXtMDSL56hXqGRauRg==
X-Received: by 2002:a5d:58c2:0:b0:319:7a9f:c63 with SMTP id o2-20020a5d58c2000000b003197a9f0c63mr5707810wrf.50.1696533510205;
        Thu, 05 Oct 2023 12:18:30 -0700 (PDT)
Received: from redhat.com ([2.52.3.174])
        by smtp.gmail.com with ESMTPSA id e1-20020adffc41000000b003267b4692e5sm2421018wrs.19.2023.10.05.12.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 12:18:28 -0700 (PDT)
Date:   Thu, 5 Oct 2023 15:18:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Dragos Tatulea <dtatulea@nvidia.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Gal Pressman <gal@nvidia.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH vhost v2 00/16] vdpa: Add support for vq descriptor
 mappings
Message-ID: <20231005151812-mutt-send-email-mst@kernel.org>
References: <20230928164550.980832-2-dtatulea@nvidia.com>
 <20231005133054-mutt-send-email-mst@kernel.org>
 <9dfa552011c20a58d8550bd794977de821212df4.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9dfa552011c20a58d8550bd794977de821212df4.camel@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 05, 2023 at 05:44:01PM +0000, Dragos Tatulea wrote:
> On Thu, 2023-10-05 at 13:31 -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 28, 2023 at 07:45:11PM +0300, Dragos Tatulea wrote:
> > > This patch series adds support for vq descriptor table mappings which
> > > are used to improve vdpa live migration downtime. The improvement comes
> > > from using smaller mappings which take less time to create and destroy
> > > in hw.
> > > 
> > > The first part adds the vdpa core changes from Si-Wei [0].
> > > 
> > > The second part adds support in mlx5_vdpa:
> > > - Refactor the mr code to be able to cleanly add descriptor mappings.
> > > - Add hardware descriptor mr support.
> > > - Properly update iotlb for cvq during ASID switch.
> > > 
> > > Changes in v2:
> > > 
> > > - The "vdpa/mlx5: Enable hw support for vq descriptor mapping" change
> > >   was split off into two patches to avoid merge conflicts into the tree
> > >   of Linus.
> > > 
> > >   The first patch contains only changes for mlx5_ifc.h. This must be
> > >   applied into the mlx5-next tree [1] first. Once this patch is applied
> > >   on mlx5-next, the change has to be pulled fom mlx5-next into the vhost
> > >   tree and only then the remaining patches can be applied.
> > 
> > 
> > I get it you plan v3?
> There are some very small improvements (commit message in 13/16 and fix in
> 16/16) that could make a v3. The latter can be addressed as a separate patch
> when moving dup_iotlb to vhost/iotlb. What do you think?


if there's a fix by all means post v3.

> > 
> > > [0]
> > > https://lore.kernel.org/virtualization/1694248959-13369-1-git-send-email-si-wei.liu@oracle.com
> > > [1]
> > > https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-next
> > > 
> > > Dragos Tatulea (13):
> > >   vdpa/mlx5: Expose descriptor group mkey hw capability
> > >   vdpa/mlx5: Create helper function for dma mappings
> > >   vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code
> > >   vdpa/mlx5: Take cvq iotlb lock during refresh
> > >   vdpa/mlx5: Collapse "dvq" mr add/delete functions
> > >   vdpa/mlx5: Rename mr destroy functions
> > >   vdpa/mlx5: Allow creation/deletion of any given mr struct
> > >   vdpa/mlx5: Move mr mutex out of mr struct
> > >   vdpa/mlx5: Improve mr update flow
> > >   vdpa/mlx5: Introduce mr for vq descriptor
> > >   vdpa/mlx5: Enable hw support for vq descriptor mapping
> > >   vdpa/mlx5: Make iotlb helper functions more generic
> > >   vdpa/mlx5: Update cvq iotlb mapping on ASID change
> > > 
> > > Si-Wei Liu (3):
> > >   vdpa: introduce dedicated descriptor group for virtqueue
> > >   vhost-vdpa: introduce descriptor group backend feature
> > >   vhost-vdpa: uAPI to get dedicated descriptor group id
> > > 
> > >  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  31 +++--
> > >  drivers/vdpa/mlx5/core/mr.c        | 191 ++++++++++++++++-------------
> > >  drivers/vdpa/mlx5/core/resources.c |   6 +-
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 100 ++++++++++-----
> > >  drivers/vhost/vdpa.c               |  27 ++++
> > >  include/linux/mlx5/mlx5_ifc.h      |   8 +-
> > >  include/linux/mlx5/mlx5_ifc_vdpa.h |   7 +-
> > >  include/linux/vdpa.h               |  11 ++
> > >  include/uapi/linux/vhost.h         |   8 ++
> > >  include/uapi/linux/vhost_types.h   |   5 +
> > >  10 files changed, 264 insertions(+), 130 deletions(-)
> > > 
> > > -- 
> > > 2.41.0
> > 
> 


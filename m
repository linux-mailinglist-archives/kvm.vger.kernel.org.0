Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E71D7D47AB
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 08:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjJXGqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 02:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbjJXGqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 02:46:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD86E11A
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 23:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698129954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BE5jVX5fnuNHBiu/EslZBnrBPYvlGW0tmMa0k/b9PBk=;
        b=MD8aQWMMST0h1pFv7q0uJSuCwjAP5dMvAT9M5yldlllPLNrO5C/deBjrEMDHlmlZ9WpY91
        //ChK8LeyWDQwlKZ37T1TcIrBGsPcfzxK6lIrkc1spDlTD34boKV6cNnOwpdKz+HAIK81E
        pKliMkL/cBArm/YmgD2CFLjtvjKkXjE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-IFkXYDCiO76tir8mEmKCtg-1; Tue, 24 Oct 2023 02:45:53 -0400
X-MC-Unique: IFkXYDCiO76tir8mEmKCtg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-51da39aa6dcso2640050a12.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 23:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698129951; x=1698734751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BE5jVX5fnuNHBiu/EslZBnrBPYvlGW0tmMa0k/b9PBk=;
        b=MGdwT6Nys4yodGqEztKx/I+q7NCGG/VczTmDdqNOxCusUWH03kBqGLAoHG04kIRuFY
         8u5folk0KCwZ2cwpM1EA2C+hvQTpCV0g23VEfOLHiJll1+qIe5YPEQ82TIzeXVjoo8om
         f9cI3w0rheuwru9Q7uFMAiz7GQmgRx45pBN38fpfoINobe0/VazE6Z3N7ibzxO3/WBuZ
         844IUpAaE51HKQ1t2y8bzHznevCKRqS73kDYlSV2wkjE/fQGG+xLr182WlMspPvK4EvD
         utoPZ5DaNi0LQXEzKjzUAVJI7wVGXsn71omD7sf1svby2yv9Yj1uZZn3GM6rS/59p7Z+
         jWBw==
X-Gm-Message-State: AOJu0YxpLf1N1o0+cOUf+eoz/dQtUQrlemonP/T50r46L2DoAU+/YO/p
        pZ4h973GLBKsMv9Nv8/TwN1AAHpM9KzsnHsOLrhnX8eOhvCT/GcJAiEqEidWrEMj8BDhZoB2Xd7
        azs4oLjyR2hHKb2roG8Xy8lhZ9x/N1oaPJuoDEbaIBA==
X-Received: by 2002:a05:6402:42c5:b0:540:2ece:79 with SMTP id i5-20020a05640242c500b005402ece0079mr5899801edc.10.1698129951267;
        Mon, 23 Oct 2023 23:45:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgNZWI9uhoTtkVPn63A9ZoXab5BfIhKlWbTreT3y3kifMYOd2sQUkJet981s6n86VslmjOv+KibM7qY9+2T5A=
X-Received: by 2002:a05:6402:42c5:b0:540:2ece:79 with SMTP id
 i5-20020a05640242c500b005402ece0079mr5899783edc.10.1698129950979; Mon, 23 Oct
 2023 23:45:50 -0700 (PDT)
MIME-Version: 1.0
References: <20231018171456.1624030-2-dtatulea@nvidia.com> <94caea55-b399-40c2-98ef-d435c228808f@oracle.com>
In-Reply-To: <94caea55-b399-40c2-98ef-d435c228808f@oracle.com>
From:   Lei Yang <leiyang@redhat.com>
Date:   Tue, 24 Oct 2023 14:45:14 +0800
Message-ID: <CAPpAL=zf=g0dyo4u7iOfmaTV+_voT+yLcx-Dav1ROFnya4aK_Q@mail.gmail.com>
Subject: Re: [PATCH vhost v4 00/16] vdpa: Add support for vq descriptor mappings
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Dragos Tatulea <dtatulea@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QE tested this series v4 with regression testing on real nic, there
are no new issues.

Tested-by: Lei Yang <leiyang@redhat.com>


On Fri, Oct 20, 2023 at 7:50=E2=80=AFAM Si-Wei Liu <si-wei.liu@oracle.com> =
wrote:
>
> For patches 05-16:
>
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Tested-by: Si-Wei Liu <si-wei.liu@oracle.com>
>
> Thanks for the fixes!
>
> On 10/18/2023 10:14 AM, Dragos Tatulea wrote:
> > This patch series adds support for vq descriptor table mappings which
> > are used to improve vdpa live migration downtime. The improvement comes
> > from using smaller mappings which take less time to create and destroy
> > in hw.
> >
> > The first part adds the vdpa core changes from Si-Wei [0].
> >
> > The second part adds support in mlx5_vdpa:
> > - Refactor the mr code to be able to cleanly add descriptor mappings.
> > - Add hardware descriptor mr support.
> > - Properly update iotlb for cvq during ASID switch.
> >
> > Changes in v4:
> >
> > - Improved the handling of empty iotlbs. See mlx5_vdpa_change_map
> >    section in patch "12/16 vdpa/mlx5: Improve mr upate flow".
> > - Fixed a invalid usage of desc_group_mkey hw vq field when the
> >    capability is not there. See patch
> >    "15/16 vdpa/mlx5: Enable hw support for vq descriptor map".
> >
> > Changes in v3:
> >
> > - dup_iotlb now checks for src =3D=3D dst case and returns an error.
> > - Renamed iotlb parameter in dup_iotlb to dst.
> > - Removed a redundant check of the asid value.
> > - Fixed a commit message.
> > - mx5_ifc.h patch has been applied to mlx5-vhost tree. When applying
> >    this series please pull from that tree first.
> >
> > Changes in v2:
> >
> > - The "vdpa/mlx5: Enable hw support for vq descriptor mapping" change
> >    was split off into two patches to avoid merge conflicts into the tre=
e
> >    of Linus.
> >
> >    The first patch contains only changes for mlx5_ifc.h. This must be
> >    applied into the mlx5-vdpa tree [1] first. Once this patch is applie=
d
> >    on mlx5-vdpa, the change has to be pulled fom mlx5-vdpa into the vho=
st
> >    tree and only then the remaining patches can be applied.
> >
> > [0] https://lore.kernel.org/virtualization/1694248959-13369-1-git-send-=
email-si-wei.liu@oracle.com
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/=
log/?h=3Dmlx5-vhost
> >
> > Dragos Tatulea (13):
> >    vdpa/mlx5: Expose descriptor group mkey hw capability
> >    vdpa/mlx5: Create helper function for dma mappings
> >    vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code
> >    vdpa/mlx5: Take cvq iotlb lock during refresh
> >    vdpa/mlx5: Collapse "dvq" mr add/delete functions
> >    vdpa/mlx5: Rename mr destroy functions
> >    vdpa/mlx5: Allow creation/deletion of any given mr struct
> >    vdpa/mlx5: Move mr mutex out of mr struct
> >    vdpa/mlx5: Improve mr update flow
> >    vdpa/mlx5: Introduce mr for vq descriptor
> >    vdpa/mlx5: Enable hw support for vq descriptor mapping
> >    vdpa/mlx5: Make iotlb helper functions more generic
> >    vdpa/mlx5: Update cvq iotlb mapping on ASID change
> >
> > Si-Wei Liu (3):
> >    vdpa: introduce dedicated descriptor group for virtqueue
> >    vhost-vdpa: introduce descriptor group backend feature
> >    vhost-vdpa: uAPI to get dedicated descriptor group id
> >
> >   drivers/vdpa/mlx5/core/mlx5_vdpa.h |  31 +++--
> >   drivers/vdpa/mlx5/core/mr.c        | 194 ++++++++++++++++------------=
-
> >   drivers/vdpa/mlx5/core/resources.c |   6 +-
> >   drivers/vdpa/mlx5/net/mlx5_vnet.c  | 105 +++++++++++-----
> >   drivers/vhost/vdpa.c               |  27 ++++
> >   include/linux/mlx5/mlx5_ifc.h      |   8 +-
> >   include/linux/mlx5/mlx5_ifc_vdpa.h |   7 +-
> >   include/linux/vdpa.h               |  11 ++
> >   include/uapi/linux/vhost.h         |   8 ++
> >   include/uapi/linux/vhost_types.h   |   5 +
> >   10 files changed, 272 insertions(+), 130 deletions(-)
> >
>


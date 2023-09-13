Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D30079DD5B
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 03:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbjIMBEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 21:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjIMBEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 21:04:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A35391706
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 18:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694567035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5NRCL/xSBSuFgu7em92vBs1igQbTUxJIfZeUuKm3Sk4=;
        b=WF2Oeh02NiaxnayvoUL9mAQ4d/8+mPIWtliiJuygy20Njh8EKkBzflXGJ+i6xHhMqeCZTi
        FV/T13IUp27R2SCoIjF6fIj49N5QkyiSEeCGGxPsmTJLDsw1XBj1yIVK3xa/DdKtap3xpD
        iGL2/4ADtwd/ADmDCCpYwKKGMtp0Py4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-upGOa8YmPdivPEJdHKWchw-1; Tue, 12 Sep 2023 21:03:54 -0400
X-MC-Unique: upGOa8YmPdivPEJdHKWchw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-52c03bb5327so4126841a12.0
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 18:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694567033; x=1695171833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NRCL/xSBSuFgu7em92vBs1igQbTUxJIfZeUuKm3Sk4=;
        b=EChlvDvXu+30B9grw5pR4DzP/byo/a/PVle5cJP0Gshkia0qSUF/wzGrFjtl4DOUqz
         sShOrxf6vWgTDcZH0DMrRSy37qJjEY7UHReoKZXgMkraIxTagIgfq/UqLE8kKwzowlGF
         NchllgfeODORTVb5svk2N5zy95M6U+QHGr4PKnN3rItqbWNIdLdfXCxFmlwoN4ywu69+
         SI/6sc6eXrYmYYW7McL/Lg4UpoAoLdamIyPmD5DO/kM3Qzq5AR87R2bjf0RF3dO201SS
         Tucmh+ZZ16cB/Kvgh2L7s7vPy5Ojh9utT1Vvi1MzqTlOQMAS6YjBqaLAQ0yF7/oxFmxk
         JFSA==
X-Gm-Message-State: AOJu0YzXZWqx1IidQDEUPRp4NrqZwAjU0ZwcIDY7xrtRj6N9zhZxwBOD
        +ylpjvU4kcZ+oF8ZHch6IGesIE1nj8PQNN/EOn6IDWJmwXyvpt9G+KqzwkNmLyFnQcrhOiCuH5g
        Mm8Ci5ExWGhySHonmLKr89KPz8lpy
X-Received: by 2002:aa7:c50b:0:b0:523:cc3d:9121 with SMTP id o11-20020aa7c50b000000b00523cc3d9121mr857282edq.14.1694567032759;
        Tue, 12 Sep 2023 18:03:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFu64JnfHFzyZtEh4sWY+VJP3IlZTzEnel5Sw1uyDAqbUJK4erdPM+M7Hz8BqtRBiR06pvVlXvXC0tnu7fHLCc=
X-Received: by 2002:aa7:c50b:0:b0:523:cc3d:9121 with SMTP id
 o11-20020aa7c50b000000b00523cc3d9121mr857267edq.14.1694567032457; Tue, 12 Sep
 2023 18:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230912130132.561193-1-dtatulea@nvidia.com>
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
From:   Lei Yang <leiyang@redhat.com>
Date:   Wed, 13 Sep 2023 09:03:15 +0800
Message-ID: <CAPpAL=w6KeBG5Ur037GNQa=n_fdoUwrFo+ATsFtX9HbWPHZvsg@mail.gmail.com>
Subject: Re: [PATCH 00/16] vdpa: Add support for vq descriptor mappings
To:     Dragos Tatulea <dtatulea@nvidia.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dragos, Eugenio and Si-Wei

My name is Lei Yang, a software Quality Engineer from Red Hat.  And
always paying attention to improving the live migration downtime
issues because there are others QE asked about this problem when I
share live migration status  recently. Therefore I would like to test
it in my environment. Before the testing I want to know if there is an
expectation of downtime range based on this series of patches? In
addition, QE also can help do a regression test based on this series
of patches if there is a requirement.

Regards and thanks
Lei


On Tue, Sep 12, 2023 at 9:04=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
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
> [0] https://lore.kernel.org/virtualization/1694248959-13369-1-git-send-em=
ail-si-wei.liu@oracle.com
>
> Dragos Tatulea (13):
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
>   Cover letter: vdpa/mlx5: Add support for vq descriptor mappings
>
> Si-Wei Liu (3):
>   vdpa: introduce dedicated descriptor group for virtqueue
>   vhost-vdpa: introduce descriptor group backend feature
>   vhost-vdpa: uAPI to get dedicated descriptor group id
>
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  31 +++--
>  drivers/vdpa/mlx5/core/mr.c        | 191 ++++++++++++++++-------------
>  drivers/vdpa/mlx5/core/resources.c |   6 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 100 ++++++++++-----
>  drivers/vhost/vdpa.c               |  27 ++++
>  include/linux/mlx5/mlx5_ifc.h      |   8 +-
>  include/linux/mlx5/mlx5_ifc_vdpa.h |   7 +-
>  include/linux/vdpa.h               |  11 ++
>  include/uapi/linux/vhost.h         |   8 ++
>  include/uapi/linux/vhost_types.h   |   5 +
>  10 files changed, 264 insertions(+), 130 deletions(-)
>
> --
> 2.41.0
>


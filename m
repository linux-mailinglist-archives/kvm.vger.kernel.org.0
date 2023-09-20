Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3FC7A7003
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 03:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjITBPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 21:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbjITBPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 21:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E79B3
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 18:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695172495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99BVBvPZ3yZ06BgSazMx7Jl4RmSGfTzaJowoaUdSNng=;
        b=fW5q/tPisdAnb8N30fxrCSi8jFCgF6nEqBQ85ia2RevSVLLAWXmSdTeSwczGSsJN1fL5Bn
        jiui+xHlj/XvgPc2f1+xLhM4z7rzCDBs74LSHX6ntA08YkMKsLa+WlXX2W1Y0tPCxWrmqL
        1MfV5ke5C6OasRm9tEhdXTTMYYWuasQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-HZtp4XX2PXWD9J1kqWHjig-1; Tue, 19 Sep 2023 21:14:53 -0400
X-MC-Unique: HZtp4XX2PXWD9J1kqWHjig-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-500a9156daaso7614773e87.0
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 18:14:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695172492; x=1695777292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99BVBvPZ3yZ06BgSazMx7Jl4RmSGfTzaJowoaUdSNng=;
        b=kLQn3cD2J4aiYriD/E7nwuKS3zdxY3BpTH6TbZsfY1Y7hYrCuQPdAcJPS1IlVf+MXu
         O0sHhwg2qYxXlUSIC49Ol2c2ljZoKeYS5m5m2bu86YBH6VRyMz7W67Y4SMoroOQqlnGQ
         4bVSueeAUUt6UzVxMdfhLqt0R8xRBpLRaCv0Yj/L70eFFWsNA+Xf/A/kip0qlEBa6K6a
         hVoBXAK60hkt5tbjkNh/Vdlh/ldfzCfw1xesbdG28aiU2ri7eYkBYW1WQzDwZ1UBrxWH
         epKsgkN8nnxUX+Q4v95cTClmdmY6YjJT46ZSsdtwbdabyiANiU35+V8AbQKro1lIG8Mr
         weRQ==
X-Gm-Message-State: AOJu0YxNbfnbGeI5UyoivJivSkcrz2UZ0H7I/2GeZTQkuGHQRqw3D2PO
        cjD1oXV8U6S79Cqg+O7TRz8D9grzxPAHo1XiH/J0GC804OEad/sNeOU6k6LCk0f2ZH9+xpMdOEp
        WCq+3TmXM9jPx4dap71o8ONATdIkN
X-Received: by 2002:a19:2d15:0:b0:500:acf1:b432 with SMTP id k21-20020a192d15000000b00500acf1b432mr902221lfj.63.1695172492105;
        Tue, 19 Sep 2023 18:14:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHj7eAx4jZAQah1riRAQMhwzq3vg+DaA8QjTtiq/c1iWCtJMTr/gNV0zbLVkJXSfKfeswovEpIUFLQUMBtrxoc=
X-Received: by 2002:a19:2d15:0:b0:500:acf1:b432 with SMTP id
 k21-20020a192d15000000b00500acf1b432mr902204lfj.63.1695172491630; Tue, 19 Sep
 2023 18:14:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230912130132.561193-1-dtatulea@nvidia.com> <CAPpAL=w6KeBG5Ur037GNQa=n_fdoUwrFo+ATsFtX9HbWPHZvsg@mail.gmail.com>
 <CAJaqyWeVjKTPmGWwZ26TgebuzCaN8Z2FmPontHvZauOTQj0brQ@mail.gmail.com> <b223d828-2c08-841f-47fb-7cb072fa5ec9@oracle.com>
In-Reply-To: <b223d828-2c08-841f-47fb-7cb072fa5ec9@oracle.com>
From:   Lei Yang <leiyang@redhat.com>
Date:   Wed, 20 Sep 2023 09:14:14 +0800
Message-ID: <CAPpAL=zwz32gVmXzqEHEe6nZPfuE-GTXHdUa2MF9brpdZWw5+Q@mail.gmail.com>
Subject: Re: [PATCH 00/16] vdpa: Add support for vq descriptor mappings
To:     Si-Wei Liu <si-wei.liu@oracle.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QE tested this series with regression testing on real nic, there are
no new issues.

Tested-by: Lei Yang <leiyang@redhat.com>



On Fri, Sep 15, 2023 at 2:34=E2=80=AFPM Si-Wei Liu <si-wei.liu@oracle.com> =
wrote:
>
>
>
> On 9/13/2023 9:08 AM, Eugenio Perez Martin wrote:
> > On Wed, Sep 13, 2023 at 3:03=E2=80=AFAM Lei Yang <leiyang@redhat.com> w=
rote:
> >> Hi Dragos, Eugenio and Si-Wei
> >>
> >> My name is Lei Yang, a software Quality Engineer from Red Hat.  And
> >> always paying attention to improving the live migration downtime
> >> issues because there are others QE asked about this problem when I
> >> share live migration status  recently. Therefore I would like to test
> >> it in my environment. Before the testing I want to know if there is an
> >> expectation of downtime range based on this series of patches? In
> >> addition, QE also can help do a regression test based on this series
> >> of patches if there is a requirement.
> >>
> > Hi Lei,
> >
> > Thanks for offering the testing bandwidth!
> >
> > I think we can only do regression tests here, as the userland part is
> > still not sent to qemu.
> Right. Regression for now, even QEMU has it, to exercise the relevant
> feature it would need a supporting firmware that is not yet available
> for now. Just stay tuned.
>
> thanks for your patience,
> -Siwei
> >
> >> Regards and thanks
> >> Lei
> >>
> >>
> >> On Tue, Sep 12, 2023 at 9:04=E2=80=AFPM Dragos Tatulea <dtatulea@nvidi=
a.com> wrote:
> >>> This patch series adds support for vq descriptor table mappings which
> >>> are used to improve vdpa live migration downtime. The improvement com=
es
> >>> from using smaller mappings which take less time to create and destro=
y
> >>> in hw.
> >>>
> >>> The first part adds the vdpa core changes from Si-Wei [0].
> >>>
> >>> The second part adds support in mlx5_vdpa:
> >>> - Refactor the mr code to be able to cleanly add descriptor mappings.
> >>> - Add hardware descriptor mr support.
> >>> - Properly update iotlb for cvq during ASID switch.
> >>>
> >>> [0] https://lore.kernel.org/virtualization/1694248959-13369-1-git-sen=
d-email-si-wei.liu@oracle.com
> >>>
> >>> Dragos Tatulea (13):
> >>>    vdpa/mlx5: Create helper function for dma mappings
> >>>    vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code
> >>>    vdpa/mlx5: Take cvq iotlb lock during refresh
> >>>    vdpa/mlx5: Collapse "dvq" mr add/delete functions
> >>>    vdpa/mlx5: Rename mr destroy functions
> >>>    vdpa/mlx5: Allow creation/deletion of any given mr struct
> >>>    vdpa/mlx5: Move mr mutex out of mr struct
> >>>    vdpa/mlx5: Improve mr update flow
> >>>    vdpa/mlx5: Introduce mr for vq descriptor
> >>>    vdpa/mlx5: Enable hw support for vq descriptor mapping
> >>>    vdpa/mlx5: Make iotlb helper functions more generic
> >>>    vdpa/mlx5: Update cvq iotlb mapping on ASID change
> >>>    Cover letter: vdpa/mlx5: Add support for vq descriptor mappings
> >>>
> >>> Si-Wei Liu (3):
> >>>    vdpa: introduce dedicated descriptor group for virtqueue
> >>>    vhost-vdpa: introduce descriptor group backend feature
> >>>    vhost-vdpa: uAPI to get dedicated descriptor group id
> >>>
> >>>   drivers/vdpa/mlx5/core/mlx5_vdpa.h |  31 +++--
> >>>   drivers/vdpa/mlx5/core/mr.c        | 191 ++++++++++++++++----------=
---
> >>>   drivers/vdpa/mlx5/core/resources.c |   6 +-
> >>>   drivers/vdpa/mlx5/net/mlx5_vnet.c  | 100 ++++++++++-----
> >>>   drivers/vhost/vdpa.c               |  27 ++++
> >>>   include/linux/mlx5/mlx5_ifc.h      |   8 +-
> >>>   include/linux/mlx5/mlx5_ifc_vdpa.h |   7 +-
> >>>   include/linux/vdpa.h               |  11 ++
> >>>   include/uapi/linux/vhost.h         |   8 ++
> >>>   include/uapi/linux/vhost_types.h   |   5 +
> >>>   10 files changed, 264 insertions(+), 130 deletions(-)
> >>>
> >>> --
> >>> 2.41.0
> >>>
>


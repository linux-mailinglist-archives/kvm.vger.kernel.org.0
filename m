Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2576242A6
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 13:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiKJM54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 07:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiKJM5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 07:57:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F6F1FFB8
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 04:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668085013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jS8OHYvX+RFJyPMobgu3Swmgc9dl0FKn3jnAC7W8AEY=;
        b=KGUf7M8QoCv5gxuMaRVJfqSHx9mYq1k6Q5gFntS+7qrsPXskxFfkJfAEznFzMpQnHPNLnO
        kR6bIlqkabqIJTNLSzeNSSaPUyZffEr3s/qoQLDnQllF7dnjfZE4me6lgxX5As+eyc4FkI
        eumWNCQDKF5bDwdp0MMB+xwBTNPmsAE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-481-AGFS8sRpN-icPqhCe6wPPA-1; Thu, 10 Nov 2022 07:56:52 -0500
X-MC-Unique: AGFS8sRpN-icPqhCe6wPPA-1
Received: by mail-pg1-f200.google.com with SMTP id x23-20020a634857000000b0043c700f6441so961729pgk.21
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 04:56:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jS8OHYvX+RFJyPMobgu3Swmgc9dl0FKn3jnAC7W8AEY=;
        b=PGQM8jldvWvtSQ9YuJSOesZs5jZqh7Et2bOw1DLF7mtZASJFxvpCoaVaoVCwjrPOma
         DCj7N4d0/tIhhSLMbUjClnRDlKF88XhePAjF/IF3pe807GOJQIZ9IyxmP8c2w0Dd5J+R
         YUoiRxrFnYmCu7GSOFl3w/19mHUdKS5y4DQQdYew9w630Dd9mzi96bGtXB9dMNQfcQlX
         R1TmxN5eFDceYeTj3pTFfPyRPg14Yv9InEzzgQm657tN7cHlBNEZHsGeuC3bHYuXAjGC
         Y5C2C5Wykxwzc6vZSFdTLUNIod/SlztnABB5h9j0vVID/zgun4GjmgHyPtIeELv/Ll9K
         PHaw==
X-Gm-Message-State: ACrzQf2zLJj6IeaQG5HJSHHgpaE66wCSvONuwpNMpQz1zxY2QkBQ6/Y4
        WMMBRJe1eH8fiMO3alm4giqZPe4B6xCbubGVRdJyojG3q903Ub7SPUwkYuKbEuFkfE/wEbE+F06
        ow9zKSHbI5JWibq8ceJOvGvcp4kTL
X-Received: by 2002:a63:40c4:0:b0:470:18d5:e914 with SMTP id n187-20020a6340c4000000b0047018d5e914mr35128927pga.58.1668085011364;
        Thu, 10 Nov 2022 04:56:51 -0800 (PST)
X-Google-Smtp-Source: AMsMyM73AiJ/tFA+L0uf7V/sAqT2Ut/jA/N6LjkyupDWLgaZJP43gptz6xz4rukdQyecVU9Fj8PKSI/Z2Nj87VjS1Bc=
X-Received: by 2002:a63:40c4:0:b0:470:18d5:e914 with SMTP id
 n187-20020a6340c4000000b0047018d5e914mr35128918pga.58.1668085011097; Thu, 10
 Nov 2022 04:56:51 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221110072455-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221110072455-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 10 Nov 2022 13:56:14 +0100
Message-ID: <CAJaqyWfCC9W_Dec3EqSxBk_CQ9E-CRDu947EKfyQtxQNZXeDOw@mail.gmail.com>
Subject: Re: [PATCH v6 00/10] ASID support in vhost-vdpa net
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 1:25 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Nov 08, 2022 at 06:07:45PM +0100, Eugenio P=C3=A9rez wrote:
> > Control VQ is the way net devices use to send changes to the device sta=
te, like
> > the number of active queues or its mac address.
> >
> > QEMU needs to intercept this queue so it can track these changes and is=
 able to
> > migrate the device. It can do it from 1576dbb5bbc4 ("vdpa: Add x-svq to
> > NetdevVhostVDPAOptions"). However, to enable x-svq implies to shadow al=
l VirtIO
> > device's virtqueues, which will damage performance.
> >
> > This series adds address space isolation, so the device and the guest
> > communicate directly with them (passthrough) and CVQ communication is s=
plit in
> > two: The guest communicates with QEMU and QEMU forwards the commands to=
 the
> > device.
> >
> > Comments are welcome. Thanks!
>
>
> This is not 7.2 material, right?
>

No it is not.

I should have noted it after PATCH in the subject, sorry.

> > v6:
> > - Do not allocate SVQ resources like file descriptors if SVQ cannot be =
used.
> > - Disable shadow CVQ if the device does not support it because of net
> >   features.
> >
> > v5:
> > - Move vring state in vhost_vdpa_get_vring_group instead of using a
> >   parameter.
> > - Rename VHOST_VDPA_NET_CVQ_PASSTHROUGH to VHOST_VDPA_NET_DATA_ASID
> >
> > v4:
> > - Rebased on last CVQ start series, that allocated CVQ cmd bufs at load
> > - Squash vhost_vdpa_cvq_group_is_independent.
> > - Do not check for cvq index on vhost_vdpa_net_prepare, we only have on=
e
> >   that callback registered in that NetClientInfo.
> > - Add comment specifying behavior if device does not support _F_ASID
> > - Update headers to a later Linux commit to not to remove SETUP_RNG_SEE=
D
> >
> > v3:
> > - Do not return an error but just print a warning if vdpa device initia=
lization
> >   returns failure while getting AS num of VQ groups
> > - Delete extra newline
> >
> > v2:
> > - Much as commented on series [1], handle vhost_net backend through
> >   NetClientInfo callbacks instead of directly.
> > - Fix not freeing SVQ properly when device does not support CVQ
> > - Add BIT_ULL missed checking device's backend feature for _F_ASID.
> >
> > Eugenio P=C3=A9rez (10):
> >   vdpa: Use v->shadow_vqs_enabled in vhost_vdpa_svqs_start & stop
> >   vhost: set SVQ device call handler at SVQ start
> >   vhost: Allocate SVQ device file descriptors at device start
> >   vdpa: add vhost_vdpa_net_valid_svq_features
> >   vdpa: move SVQ vring features check to net/
> >   vdpa: Allocate SVQ unconditionally
> >   vdpa: Add asid parameter to vhost_vdpa_dma_map/unmap
> >   vdpa: Store x-svq parameter in VhostVDPAState
> >   vdpa: Add listener_shadow_vq to vhost_vdpa
> >   vdpa: Always start CVQ in SVQ mode
> >
> >  include/hw/virtio/vhost-vdpa.h     |  10 +-
> >  hw/virtio/vhost-shadow-virtqueue.c |  35 +-----
> >  hw/virtio/vhost-vdpa.c             | 114 ++++++++++---------
> >  net/vhost-vdpa.c                   | 171 ++++++++++++++++++++++++++---
> >  hw/virtio/trace-events             |   4 +-
> >  5 files changed, 222 insertions(+), 112 deletions(-)
> >
> > --
> > 2.31.1
> >
>


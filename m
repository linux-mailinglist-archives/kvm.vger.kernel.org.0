Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19946538BDD
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 09:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244459AbiEaHOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 03:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244448AbiEaHOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 03:14:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20E27915B5
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 00:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653981257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33Q+kZ3exxiCIGxTXejuFhcm2TRKe5xhqodtK0AziM4=;
        b=KCEEKl3GXEmz3ruD79j2/X3BRFeQj3yLqJCUny6x63GQ2Xy1kIitu7qQJ+GbGvmJtIpIsK
        AJGIqwZy+fpEGLa4Gb4CH/JDyXL4oD/WdE4hnVTpAEPt8D2FmNq2LjV3JIPug8YTLn+o3t
        8s6cm1s3kX5iKhYJgwud+Te3TBHPqkg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-YGYuJgSTOQ2VV7WQGbrRNQ-1; Tue, 31 May 2022 03:14:15 -0400
X-MC-Unique: YGYuJgSTOQ2VV7WQGbrRNQ-1
Received: by mail-qv1-f71.google.com with SMTP id o99-20020a0c906c000000b00456332167ffso9539453qvo.13
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 00:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=33Q+kZ3exxiCIGxTXejuFhcm2TRKe5xhqodtK0AziM4=;
        b=dgq63x+zq0KZG447/OWhBgSNSPtwbhc86EKPC03AHh28jn/v1mTcRP1Zi6s7M/gRdm
         wVzmDKHd9+vhJIfRS5Fwdz9FrAHbl60z2Oa7gwYZDBuvnw44Yh4OqANXKvsvLg/MqL2N
         c6DLnuzId0EQGmERjAua5LOmr/iLPUDNFZi7U2DrsfNw7KVBZYhAMNCjSHkX+wu1DJ6u
         ZAoOSBrWoiJI/xhwO3LSJUgkFkWo4Wx8RAOjp0vC2P7RhhHdlx80JvUbkuRG4NA+NAgD
         dFQjMXpbeS+OEbPXATHtSjLcly98xi2ZH2IXUasJFdDmukmKWcNdcADa5tL5CrweRv2N
         Cp6A==
X-Gm-Message-State: AOAM530VaVD5mP080lhmilTHvjRU/zRC4h7lORzWRzXd6vsvCw5KT9F4
        iU0q2Xen3c4euNEpQt9glrITRxplcd9/k1cSackWL7TW7ffQaVUQ/u6vtB+ZWl0oVcMj/CzStYn
        m3+S0kW+MdPt7wVXWdC/UtSF7F8WD
X-Received: by 2002:ac8:5ad0:0:b0:2f3:e37a:e768 with SMTP id d16-20020ac85ad0000000b002f3e37ae768mr45957237qtd.592.1653981254773;
        Tue, 31 May 2022 00:14:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfsK62AT66aNNUrpiRT8Q1h/z0vwoFAfZ6ojK+Cso5QwGPLczuZn5KrJtMDcQKDAqYGqbzNtxijjj7ElUmbMA=
X-Received: by 2002:ac8:5ad0:0:b0:2f3:e37a:e768 with SMTP id
 d16-20020ac85ad0000000b002f3e37ae768mr45957224qtd.592.1653981254525; Tue, 31
 May 2022 00:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <20220531014108-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220531014108-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 31 May 2022 09:13:38 +0200
Message-ID: <CAJaqyWfRSD6xiS8DROkPvjJ4Y4dotOPWqUzaQeM3X=q_XgABdw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Martin Porter <martinpo@xilinx.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Cindy Lu <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, ecree.xilinx@gmail.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>, habetsm.xilinx@gmail.com,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 31, 2022 at 7:42 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, May 26, 2022 at 02:43:34PM +0200, Eugenio P=C3=A9rez wrote:
> > Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> > that backend feature and userspace can effectively stop the device.
> >
> > This is a must before get virtqueue indexes (base) for live migration,
> > since the device could modify them after userland gets them. There are
> > individual ways to perform that action for some devices
> > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> > way to perform it for any vhost device (and, in particular, vhost-vdpa)=
.
> >
> > After the return of ioctl with stop !=3D 0, the device MUST finish any
> > pending operations like in flight requests. It must also preserve all
> > the necessary state (the virtqueue vring base plus the possible device
> > specific states) that is required for restoring in the future. The
> > device must not change its configuration after that point.
> >
> > After the return of ioctl with stop =3D=3D 0, the device can continue
> > processing buffers as long as typical conditions are met (vq is enabled=
,
> > DRIVER_OK status bit is enabled, etc).
> >
> > In the future, we will provide features similar to VHOST_USER_GET_INFLI=
GHT_FD
> > so the device can save pending operations.
> >
> > Comments are welcome.
>
>
> So given this is just for simulator and affects UAPI I think it's fine
> to make it wait for the next merge window, until there's a consensus.
> Right?
>

While the change is only implemented in the simulator at this moment,
it's just the very last missing piece in the kernel to implement
complete live migration for net devices with cvq :). All vendor
drivers can implement this call with current code, just a little bit
of plumbing is needed. And it was accepted in previous meetings.

If it proves it works for every configuration (nested, etc), the
implementation can forward the call to the admin vq for example. At
the moment, it follows the proposed stop status bit sematic to stop
the device, which POC has been tested in these circumstances.

Thanks!

> > v4:
> > * Replace VHOST_STOP to VHOST_VDPA_STOP in vhost ioctl switch case too.
> >
> > v3:
> > * s/VHOST_STOP/VHOST_VDPA_STOP/
> > * Add documentation and requirements of the ioctl above its definition.
> >
> > v2:
> > * Replace raw _F_STOP with BIT_ULL(_F_STOP).
> > * Fix obtaining of stop ioctl arg (it was not obtained but written).
> > * Add stop to vdpa_sim_blk.
> >
> > Eugenio P=C3=A9rez (4):
> >   vdpa: Add stop operation
> >   vhost-vdpa: introduce STOP backend feature bit
> >   vhost-vdpa: uAPI to stop the device
> >   vdpa_sim: Implement stop vdpa op
> >
> >  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++
> >  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
> >  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
> >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
> >  drivers/vhost/vdpa.c                 | 34 +++++++++++++++++++++++++++-
> >  include/linux/vdpa.h                 |  6 +++++
> >  include/uapi/linux/vhost.h           | 14 ++++++++++++
> >  include/uapi/linux/vhost_types.h     |  2 ++
> >  8 files changed, 83 insertions(+), 1 deletion(-)
> >
> > --
> > 2.31.1
> >
>


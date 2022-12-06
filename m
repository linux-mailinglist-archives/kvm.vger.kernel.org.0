Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6F9643E87
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbiLFI0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiLFI00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:26:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6501FD8C
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670315131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zZAq/PtnFU0rbP7eP7C+jdgThKNnH+Mi6t7KTAN4IpE=;
        b=gqD5ee0mkbeDQZ+rDbN/hy5krK9c9f8Jsd4Rl3IHTzWkRFnio4Xgayn1CCH7cVnk7VnRef
        VBkqx6o1desSHB5Jdz3gBG+IKSnMAL0UOYhBjsGF9zdOY+Imj8xsXCqILDbESSbfWisy/N
        cIs7RHod/Vr0lbJnVbd6LHo0g64pgXE=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-372-QbWMlR20O4Kp1-94um7FcA-1; Tue, 06 Dec 2022 03:25:30 -0500
X-MC-Unique: QbWMlR20O4Kp1-94um7FcA-1
Received: by mail-oi1-f200.google.com with SMTP id bo36-20020a05680822a400b00359dee97833so6252005oib.1
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 00:25:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zZAq/PtnFU0rbP7eP7C+jdgThKNnH+Mi6t7KTAN4IpE=;
        b=pb3YolOo9OWDVUOw2dA7GiQSt8F14PLVYNt1kkHi0wU6xqzdq4oQ5/ewY70Ygxp2dh
         3Qz339WNViHY00sr9fkKCD1fmR+Mf++twPcUI+R9nELR+f7Tkqxkw+yDACS0iz029RHn
         SfDh66J4VnCe70cD2iSIw8SgmYpo40liLJyTP4ot01MhiGe16emdGeKQklQw/AJNB2mc
         /enVFhx8fjHZiOgTqwM6KyCqyVR8zIdPd3ZY/gL/vDCVR8U4mplcNnamh0Bt4C4qNn3u
         LVUnNgGGRyvsc/nTQ923vClG+YkUIfMG/AInWEsCibcmcIrKVa2zmlrgdvBJ5axi+jKm
         HP8g==
X-Gm-Message-State: ANoB5pnX9jR+jdV4O3cyL0QiCj07iszSa8Rbt91ZZOKo3mgz4WkCf/rx
        zbLlouK4DL0tBQMHLJmNIhZRpfAWwksuYy8Jh7NCb0h6LXOqkHI13FoBVMG9UI0Aqi7cBXtDPlX
        hF9U0ji180KBdAwWjh6hMjQD/Bzg6
X-Received: by 2002:a9d:832:0:b0:670:5283:dd3e with SMTP id 47-20020a9d0832000000b006705283dd3emr2305379oty.201.1670315129731;
        Tue, 06 Dec 2022 00:25:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf63/YSWSVfAKhDkxJJhg5tVQ6edTZ8+z5593ZO8OwAtsLg+gnP7Sk7CJg2MlOyZ4umJty76Hd1HiuYim0ssmgc=
X-Received: by 2002:a9d:832:0:b0:670:5283:dd3e with SMTP id
 47-20020a9d0832000000b006705283dd3emr2305371oty.201.1670315129501; Tue, 06
 Dec 2022 00:25:29 -0800 (PST)
MIME-Version: 1.0
References: <20221125145724.1129962-1-lingshan.zhu@intel.com>
In-Reply-To: <20221125145724.1129962-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 6 Dec 2022 16:25:17 +0800
Message-ID: <CACGkMEvEwutEZT4UyosOZmTcKjvhhS6covy6FgyMWm4nmtKn8w@mail.gmail.com>
Subject: Re: [PATCH V2 00/12] ifcvf/vDPA implement features provisioning
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, hang.yuan@intel.com, piotr.uminski@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 11:06 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This series implements features provisioning for ifcvf.
> By applying this series, we allow userspace to create
> a vDPA device with selected (management device supported)
> feature bits and mask out others.
>
> Examples:
> a)The management device supported features:
> $ vdpa mgmtdev show pci/0000:01:00.5
> pci/0000:01:00.5:
>   supported_classes net
>   max_supported_vqs 9
>   dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM
>
> b)Provision a vDPA device with all supported features:
> $ vdpa dev add name vdpa0 mgmtdev pci/0000:01:00.5
> $ vdpa/vdpa dev config show vdpa0
> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
>   negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
>
> c)Provision a vDPA device with a subset of the supported features:
> $ vdpa dev add name vdpa0 mgmtdev pci/0000:01:00.5 device_features 0x300020020
> $ vdpa dev config show vdpa0
> mac 00:e8:ca:11:be:05 link up link_announce false
>   negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
>
> Please help review
>
> Thanks
>
> Changes from V1:
> split original patch 1 ~ patch 3 to small patches that are less
> than 100 lines,

True but.

>so they can be applied to stalbe kernel(Jason)
>

It requires each patch fixes a real issue so I think those can not go
to -stable.

Btw, looking at git history what you want to decouple is basically
functional equivalent to a partial revert of this commit:

commit 378b2e956820ff5c082d05f42828badcfbabb614
Author: Zhu Lingshan <lingshan.zhu@intel.com>
Date:   Fri Jul 22 19:53:05 2022 +0800

    vDPA/ifcvf: support userspace to query features and MQ of a
management device

    Adapting to current netlink interfaces, this commit allows userspace
    to query feature bits and MQ capability of a management device.

    Currently both the vDPA device and the management device are the VF itself,
    thus this ifcvf should initialize the virtio capabilities in probe() before
    setting up the struct vdpa_mgmt_dev.

    Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
    Message-Id: <20220722115309.82746-3-lingshan.zhu@intel.com>
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Before this commit. adapter was allocated/freed in device_add/del
which should be fine.

Can we go back to doing things that way?

Thanks

> Zhu Lingshan (12):
>   vDPA/ifcvf: decouple hw features manipulators from the adapter
>   vDPA/ifcvf: decouple config space ops from the adapter
>   vDPA/ifcvf: alloc the mgmt_dev before the adapter
>   vDPA/ifcvf: decouple vq IRQ releasers from the adapter
>   vDPA/ifcvf: decouple config IRQ releaser from the adapter
>   vDPA/ifcvf: decouple vq irq requester from the adapter
>   vDPA/ifcvf: decouple config/dev IRQ requester and vectors allocator
>     from the adapter
>   vDPA/ifcvf: ifcvf_request_irq works on ifcvf_hw
>   vDPA/ifcvf: manage ifcvf_hw in the mgmt_dev
>   vDPA/ifcvf: allocate the adapter in dev_add()
>   vDPA/ifcvf: retire ifcvf_private_to_vf
>   vDPA/ifcvf: implement features provisioning
>
>  drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
>  drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
>  drivers/vdpa/ifcvf/ifcvf_main.c | 162 +++++++++++++++-----------------
>  3 files changed, 91 insertions(+), 113 deletions(-)
>
> --
> 2.31.1
>


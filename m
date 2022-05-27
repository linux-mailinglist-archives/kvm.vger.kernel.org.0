Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E495B535AC2
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 09:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348156AbiE0H4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 03:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346452AbiE0H4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 03:56:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0F19FC4D9
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 00:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653638162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CA+R9olX9BNKnTqlZ0IZTGggNbz8tWHe/TMK4H707bg=;
        b=fEyVtYUNt4GRdSlLLGYDzeJox2V32q0LRnO3Ss4QtdEBfbeXbr2nc0Ns6k0V4B93q13kJ1
        0ce6sIDxS6KP8UmwGsGqPbQoh0A7LaSgqoluvaobAdsoCNOEuo6oU/nG/w8cMADpujpVbM
        3Jskeg3vGokdXXgNC4swuYR2H4+wj2w=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-zAdYBt1RPpCBVmreHMl0BQ-1; Fri, 27 May 2022 03:56:00 -0400
X-MC-Unique: zAdYBt1RPpCBVmreHMl0BQ-1
Received: by mail-qv1-f72.google.com with SMTP id fw9-20020a056214238900b0043522aa5b81so2845818qvb.21
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 00:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CA+R9olX9BNKnTqlZ0IZTGggNbz8tWHe/TMK4H707bg=;
        b=u1r9c1aTQgGc//4s3zzb6FD2Rx9K8XFpv1eQbk+VzJn+w2e4UUu1oKLo4bwFWGcO8L
         lnfYhgUQ5qNPY+iIvobdzyct7Hroa6HSHv7o8lhUQgXl7TI/PMKsZeDyJkQbhkpJCBZS
         nMPJumfMacv6sx68PO6/hbtXuiJe5ESZQG/h2fUTa+nHUlxhq8zAsh75DKjsXW0Ur8K4
         NfUtZzBqGC7WzBi/7+WJ4dCD9ILVGCuwSOnngJGfyzg9pTK1FFjYt0ZYilMy4SAWXyUj
         6/7+8qSk+9jJY1wNdlwGehkcWkZNAlqxjRxg79EYeZ9rJZLnfcQBsVdHSc6Olpje2TRi
         kWqg==
X-Gm-Message-State: AOAM530+iY8EAQiPGqdKQ+/g/WkdtJnWkC6zeZaIXV30bThgTXrk2+5f
        qUi+KEV8pnia9R8pGIWysngSJhVC5Xy5+Jg48AyKBANG8BAvEGr4w1p2mMyYieMPy2HzO3D+8Tp
        DZE6Eo3NCuq4oo8UbD3hjoUa7uNqB
X-Received: by 2002:a05:6214:400e:b0:462:5d6:5f47 with SMTP id kd14-20020a056214400e00b0046205d65f47mr31100668qvb.70.1653638160359;
        Fri, 27 May 2022 00:56:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylroTpRZpeeO0qtJQiqEAiLIxT6iU6LRe7ndfiDx59PJHC+Rmgm12rix1MW2ISsQFjDw6wHv3KBekDpydjKiM=
X-Received: by 2002:a05:6214:400e:b0:462:5d6:5f47 with SMTP id
 kd14-20020a056214400e00b0046205d65f47mr31100652qvb.70.1653638160151; Fri, 27
 May 2022 00:56:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEu1YenjBHAssP=FvKX6WxDQ5Aa50r-BsnkfR4zqNTk6hg@mail.gmail.com>
In-Reply-To: <CACGkMEu1YenjBHAssP=FvKX6WxDQ5Aa50r-BsnkfR4zqNTk6hg@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 27 May 2022 09:55:24 +0200
Message-ID: <CAJaqyWfzoORc7V=xqdyLsdRPRYGNJBvWaPcZDhOb1vJWhbixoA@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 27, 2022 at 4:26 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Thu, May 26, 2022 at 8:54 PM Parav Pandit <parav@nvidia.com> wrote:
> >
> >
> >
> > > From: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > Sent: Thursday, May 26, 2022 8:44 AM
> >
> > > Implement stop operation for vdpa_sim devices, so vhost-vdpa will off=
er
> > >
> > > that backend feature and userspace can effectively stop the device.
> > >
> > >
> > >
> > > This is a must before get virtqueue indexes (base) for live migration=
,
> > >
> > > since the device could modify them after userland gets them. There ar=
e
> > >
> > > individual ways to perform that action for some devices
> > >
> > > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there
> > > was no
> > >
> > > way to perform it for any vhost device (and, in particular, vhost-vdp=
a).
> > >
> > >
> > >
> > > After the return of ioctl with stop !=3D 0, the device MUST finish an=
y
> > >
> > > pending operations like in flight requests. It must also preserve all
> > >
> > > the necessary state (the virtqueue vring base plus the possible devic=
e
> > >
> > > specific states) that is required for restoring in the future. The
> > >
> > > device must not change its configuration after that point.
> > >
> > >
> > >
> > > After the return of ioctl with stop =3D=3D 0, the device can continue
> > >
> > > processing buffers as long as typical conditions are met (vq is enabl=
ed,
> > >
> > > DRIVER_OK status bit is enabled, etc).
> >
> > Just to be clear, we are adding vdpa level new ioctl() that doesn=E2=80=
=99t map to any mechanism in the virtio spec.
>
> We try to provide forward compatibility to VIRTIO_CONFIG_S_STOP. That
> means it is expected to implement at least a subset of
> VIRTIO_CONFIG_S_STOP.
>

Appending a link to the proposal, just for reference [1].

> >
> > Why can't we use this ioctl() to indicate driver to start/stop the devi=
ce instead of driving it through the driver_ok?
>

Parav, I'm not sure I follow you here.

By the proposal, the resume of the device is (From qemu POV):
1. To configure all data vqs and cvq (addr, num, ...)
2. To enable only CVQ, not data vqs
3. To send DRIVER_OK
4. Wait for all buffers of CVQ to be used
5. To enable all others data vqs (individual ioctl at the moment)

Where can we fit the resume (as "stop(false)") here? If the device is
stopped (as if we send stop(true) before DRIVER_OK), we don't read CVQ
first. If we send it right after (or instead) DRIVER_OK, data buffers
can reach data vqs before configuring RSS.

> So the idea is to add capability that does not exist in the spec. Then
> came the stop/resume which can't be done via DRIVER_OK. I think we
> should only allow the stop/resume to succeed after DRIVER_OK is set.
>
> > This is in the context of other discussion we had in the LM series.
>
> Do you see any issue that blocks the live migration?
>
> Thanks
>


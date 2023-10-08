Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264A87BCC04
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 06:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344338AbjJHE3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 00:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344307AbjJHE3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 00:29:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BBFBA
        for <kvm@vger.kernel.org>; Sat,  7 Oct 2023 21:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696739318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vxT8bBpg2V2sCWkrIObviz4MEWDATPF4LhOqMoHGX6U=;
        b=iqe9uA9RSpajl2G2Irx5QOb5Nr+b7YxAcaGjp04VR7/4QcOiE0kULiJ4C0GndFceVvNRC9
        ZSWMsb3IRZmLhCWTw1v3RXB4bv7UeucWLn5IeEeraUnC9B882v04FkgeL+trAxup/2j1WS
        3F4fPmfC7EXY7M9nQ/ySjn7InFWTyBs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-Tle0EjSBPti4gVjwhh4sMQ-1; Sun, 08 Oct 2023 00:28:35 -0400
X-MC-Unique: Tle0EjSBPti4gVjwhh4sMQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5047e8f812bso3322234e87.3
        for <kvm@vger.kernel.org>; Sat, 07 Oct 2023 21:28:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696739313; x=1697344113;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vxT8bBpg2V2sCWkrIObviz4MEWDATPF4LhOqMoHGX6U=;
        b=EzMWTx9lb2yDz+AJ1aF9xoORHlTgpvxL1Q4gmaz0qnDvaV3N8I5W7iFQc5UK/xyDPS
         qjV27qpCNMaRu9v0vvMvZi5dKoZREe1FC9qIj1NVB6L/j+ji3zAVSCZv9J1dhON3kwO4
         sYj4cluEZbjOzPy8zS24KHhNcGVFmGcgbhUMVmlU2mwH/HDuePWMypPHFgUtiMJsQyQo
         LAI94zEFieXokcf4/+UL1PRFdwwe3k/PsICHo5LePGmXPGqWmCF/BXuqk4ReBd+tEkDr
         PA0phIFkkghgICIBsn4Jya6HTaRVxqbPkePdZkWc5xvRl8FvlYOMgQFdprGakhnTfRax
         chLQ==
X-Gm-Message-State: AOJu0Yyhbzs/IbCZPi/w+9s5PyTx6icuvPVgudxqt8dz9AfqWuM8jnKX
        hdfgC+1beeATS4tNyuY+zR2xCPww8TdgKstjaYKwOUVneWTx+9Tey+DtehM+XlP1dtjtcvfSc72
        PzYZdD2qN9AWwT45b0EOeTm3geJWi
X-Received: by 2002:a05:6512:3c9c:b0:503:99d:5a97 with SMTP id h28-20020a0565123c9c00b00503099d5a97mr12369549lfv.20.1696739313652;
        Sat, 07 Oct 2023 21:28:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoEe5Q/MlUvUVOzxqVsG9NUenNLyabZh1JOdQa1QFbx1vsgKHGV/b4ObGp9egUs1P1EC63rh8s6MrImoMupDQ=
X-Received: by 2002:a05:6512:3c9c:b0:503:99d:5a97 with SMTP id
 h28-20020a0565123c9c00b00503099d5a97mr12369541lfv.20.1696739313349; Sat, 07
 Oct 2023 21:28:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230921181637.GU13733@nvidia.com> <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com> <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com> <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEv9_+6sYp1JZpCZr19csg0jO-jLVhuygWqm+s9mWr3Lew@mail.gmail.com> <20230926074520-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230926074520-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 8 Oct 2023 12:28:21 +0800
Message-ID: <CACGkMEtq_2xyRuOcgaVp11jxwCX_vfKxncCcke6_Z2nLKgpKww@mail.gmail.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
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

On Tue, Sep 26, 2023 at 7:49=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Sep 26, 2023 at 10:32:39AM +0800, Jason Wang wrote:
> > It's the implementation details in legacy. The device needs to make
> > sure (reset) the driver can work (is done before get_status return).
>
> I think that there's no way to make it reliably work for all legacy drive=
rs.

Yes, we may have ancient drivers.

>
> They just assumed a software backend and did not bother with DMA
> ordering. You can try to avoid resets, they are not that common so
> things will tend to mostly work if you don't stress them to much with
> things like hot plug/unplug in a loop.  Or you can try to use a driver
> after 2011 which is more aware of hardware ordering and flushes the
> reset write with a read.  One of these two tricks, I think, is the magic
> behind the device exposing memory bar 0 that you mention.

Right this is what I see for hardware legacy devices shipped by some
cloud vendors.

Thanks

>
> --
> MST
>


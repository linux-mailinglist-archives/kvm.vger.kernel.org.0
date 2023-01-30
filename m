Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55556680ACD
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 11:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbjA3Kac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 05:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjA3Kaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 05:30:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5737E2CFD6
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 02:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675074589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NUnPVEBBxIK0dhVU8A6ATxwGvwjkqSeEKSc364XgM28=;
        b=aFZTp/kvygAynfRAbqrrhvJ6wCAt9kIRgnlWq8zy34XcRTddpKTVuf6DN+3JKv7Imy5i/X
        4LTsZY4a26o8jBmfVE8wRajDMzWpmgWHHludlfCNymufyixGzfGaY/eKG+J64Ri32/qK8n
        /iu5WNjBd2KlY8T1m6QwZsY9tiIecsU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-580-77s6auKqMcaPnZHZVaVC5w-1; Mon, 30 Jan 2023 05:29:48 -0500
X-MC-Unique: 77s6auKqMcaPnZHZVaVC5w-1
Received: by mail-ej1-f70.google.com with SMTP id nc27-20020a1709071c1b00b0086dae705676so7212045ejc.12
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 02:29:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NUnPVEBBxIK0dhVU8A6ATxwGvwjkqSeEKSc364XgM28=;
        b=xdpasctx2gm7GQM2EWe2vVEjIji/Fk86IV8XLr2lgY8D179IGToPAM0kUYGkRga7ff
         zSnnHs+jrVLIpwCoRxOokrv35aePCjfxpNnmK/AWOGwM8b+EX58MMvRTVTopyZlaVO87
         8o9muSIVBnMybVPcrgg4GqViqvb6Ok9Mr3pqkqlBMIHtitx6fLnS5VSjbmebUec05X1d
         iHGkRwLlzGtB1Axz6tS1fh71DpXp8n9IGU7ZsPDGkUQDpP/26veZm1yRDW/EvK3gpVNb
         bVbjVi+KWsEIDVLJgXHNgC19Rfy50m4FMGcUjtOv6nQY50EJma7O7I+CC229sr2dWv7s
         8p0g==
X-Gm-Message-State: AO0yUKUToF5TRCFnXKa6CjE/lmT2Tro5rgKnOm27vqB/sIG/odZiZR5s
        W+vX/kxeqGPqx1307r6B+7XqWaGpIQuV4/QSkS6Cyyol9tPSS7DUTCrJ/kgyfcEUrKPrRWeFxK6
        zBIBDZ+fLcmqT
X-Received: by 2002:a17:907:1c11:b0:889:5861:ad1e with SMTP id nc17-20020a1709071c1100b008895861ad1emr2966815ejc.72.1675074586093;
        Mon, 30 Jan 2023 02:29:46 -0800 (PST)
X-Google-Smtp-Source: AK7set9vr6xJ4tOlsEGn0tpljaQxv0SWAz4CKUa/rlY4lr4aGez7CA131y4YgeYOklFXYHFLfxVV9g==
X-Received: by 2002:a17:907:1c11:b0:889:5861:ad1e with SMTP id nc17-20020a1709071c1100b008895861ad1emr2966802ejc.72.1675074585807;
        Mon, 30 Jan 2023 02:29:45 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id n21-20020a170906089500b0087ba1ed4a58sm5439689eje.191.2023.01.30.02.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 02:29:45 -0800 (PST)
Date:   Mon, 30 Jan 2023 05:29:41 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, hengqi@linux.alibaba.com,
        Kangjie Xu <kangjie.xu@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] vhost-net: support VIRTIO_F_RING_RESET
Message-ID: <20230130052929-mutt-send-email-mst@kernel.org>
References: <20220825085610.80315-1-kangjie.xu@linux.alibaba.com>
 <10630d99-e0bd-c067-8766-19266b38d2fe@redhat.com>
 <1675064346.4139252-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1675064346.4139252-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 30, 2023 at 03:39:06PM +0800, Xuan Zhuo wrote:
> On Mon, 5 Sep 2022 16:32:19 +0800, Jason Wang <jasowang@redhat.com> wrote:
> >
> > 在 2022/8/25 16:56, Kangjie Xu 写道:
> > > Add VIRTIO_F_RING_RESET, which indicates that the driver can reset a
> > > queue individually.
> > >
> > > VIRTIO_F_RING_RESET feature is added to virtio-spec 1.2. The relevant
> > > information is in
> > >      oasis-tcs/virtio-spec#124
> > >      oasis-tcs/virtio-spec#139
> > >
> > > The implementation only adds the feature bit in supported features. It
> > > does not require any other changes because we reuse the existing vhost
> > > protocol.
> > >
> > > The virtqueue reset process can be concluded as two parts:
> > > 1. The driver can reset a virtqueue. When it is triggered, we use the
> > > set_backend to disable the virtqueue.
> > > 2. After the virtqueue is disabled, the driver may optionally re-enable
> > > it. The process is basically similar to when the device is started,
> > > except that the restart process does not need to set features and set
> > > mem table since they do not change. QEMU will send messages containing
> > > size, base, addr, kickfd and callfd of the virtqueue in order.
> > > Specifically, the host kernel will receive these messages in order:
> > >      a. VHOST_SET_VRING_NUM
> > >      b. VHOST_SET_VRING_BASE
> > >      c. VHOST_SET_VRING_ADDR
> > >      d. VHOST_SET_VRING_KICK
> > >      e. VHOST_SET_VRING_CALL
> > >      f. VHOST_NET_SET_BACKEND
> > > Finally, after we use set_backend to attach the virtqueue, the virtqueue
> > > will be enabled and start to work.
> > >
> > > Signed-off-by: Kangjie Xu <kangjie.xu@linux.alibaba.com>
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >
> >
> > Acked-by: Jason Wang <jasowang@redhat.com>
> 
> @mst
> 
> Do we miss this?
> 
> Thanks.

I did, thanks! tagged now.

> >
> >
> > > ---
> > >
> > > Test environment and method:
> > >      Host: 5.19.0-rc3
> > >      Qemu: QEMU emulator version 7.0.50 (With vq rset support)
> > >      Guest: 5.19.0-rc3 (With vq reset support)
> > >      Test Cmd: ethtool -g eth1; ethtool -G eth1 rx $1 tx $2; ethtool -g eth1;
> > >
> > >      The drvier can resize the virtio queue, then virtio queue reset function should
> > >      be triggered.
> > >
> > >      The default is split mode, modify Qemu virtio-net to add PACKED feature to
> > >      test packed mode.
> > >
> > > Guest Kernel Patch:
> > >      https://lore.kernel.org/bpf/20220801063902.129329-1-xuanzhuo@linux.alibaba.com/
> > >
> > > QEMU Patch:
> > >      https://lore.kernel.org/qemu-devel/cover.1661414345.git.kangjie.xu@linux.alibaba.com/
> > >
> > > Looking forward to your review and comments. Thanks.
> > >
> > >   drivers/vhost/net.c | 3 ++-
> > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > index 68e4ecd1cc0e..8a34928d4fef 100644
> > > --- a/drivers/vhost/net.c
> > > +++ b/drivers/vhost/net.c
> > > @@ -73,7 +73,8 @@ enum {
> > >   	VHOST_NET_FEATURES = VHOST_FEATURES |
> > >   			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
> > >   			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> > > -			 (1ULL << VIRTIO_F_ACCESS_PLATFORM)
> > > +			 (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> > > +			 (1ULL << VIRTIO_F_RING_RESET)
> > >   };
> > >
> > >   enum {
> >


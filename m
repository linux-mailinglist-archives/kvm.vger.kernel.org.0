Return-Path: <kvm+bounces-2983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E497FF872
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CFBE2817AA
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C7958116;
	Thu, 30 Nov 2023 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eX1KMwsG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBE61994
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701365881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gbZ5P+nGgfAbJb3fpnTGprfWggeghoTX11Iv3xmxV90=;
	b=eX1KMwsGILi9rz8v0tG59nsque67nP2sK+0+omId4sZCIYC+A7TzI7u+8dlSyL725B8X70
	yAF6UgCrtHYeAah+Xyb+PMfnv86up/d98jYjjUCfKbVPAALNOFIKLJDGYkNr3ZZmUDvLDX
	vnbKuk0CcU8IK9lZc3wrzAU8VseyV2A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-jqNvDYaSP1OXJLLYkSBCJg-1; Thu, 30 Nov 2023 12:38:00 -0500
X-MC-Unique: jqNvDYaSP1OXJLLYkSBCJg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40b53e5fc6bso9395145e9.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:38:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701365879; x=1701970679;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbZ5P+nGgfAbJb3fpnTGprfWggeghoTX11Iv3xmxV90=;
        b=u1n6cQa5mfYh9c1ZCObNBQ4Ajlr8pQroTKislndp1mx55hWwM0kdK5+DCZll8rPfV9
         zQ/HDhgvX59/X1Go+Gb9JsGsLHL07q4+nJYh5CPNBSP6u6Km0EtI+ZOy+s3rStdrluHa
         JCdMDUTKeH9aAe3ERJcOTjt1IcDGwtzvHI0lfIEr6NN675Y6uesAw3r66V5HDsFXh7sJ
         rsACKdtSfqvu3bBVC102g3tMt4WAYdJKAzRCqfsYNHG6lyEjEOoex198dPaKDQonyAYg
         coPpnBmFLkYLn4D5VwzDl93KLjRNuZiFFfF3zbNZ0t9+Q1SlUKx6AgS+Ej0u5De08B19
         3SyQ==
X-Gm-Message-State: AOJu0Yxjtx/GisCe+bPwsvC02YYadd7KLiyKJe5lghSK4sBLqwJPLAyO
	jt/n78fB84ZClNMjsyzeftvYVJNocH7DT/vSJFf5sNBDQZLI4d7v3oRcrH7Iw6f+xfsguts+/5y
	IWN6s0xJViXIA
X-Received: by 2002:a05:600c:46d1:b0:40b:4be4:738c with SMTP id q17-20020a05600c46d100b0040b4be4738cmr940wmo.37.1701365878565;
        Thu, 30 Nov 2023 09:37:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZQwuNJ0/UhUbwbnkOIMnJanuql2BfMQsxOxJaRRWODRHGQtzOtahnevlp3tHT1VPV7tWsWA==
X-Received: by 2002:a05:600c:46d1:b0:40b:4be4:738c with SMTP id q17-20020a05600c46d100b0040b4be4738cmr833wmo.37.1701365878002;
        Thu, 30 Nov 2023 09:37:58 -0800 (PST)
Received: from redhat.com ([2.55.10.128])
        by smtp.gmail.com with ESMTPSA id x1-20020adfdd81000000b0033318b927besm2096494wrl.42.2023.11.30.09.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:37:57 -0800 (PST)
Date: Thu, 30 Nov 2023 12:37:53 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v5 2/3] virtio/vsock: send credit update during
 setting SO_RCVLOWAT
Message-ID: <20231130123653-mutt-send-email-mst@kernel.org>
References: <20231130130840.253733-1-avkrasnov@salutedevices.com>
 <20231130130840.253733-3-avkrasnov@salutedevices.com>
 <20231130084044-mutt-send-email-mst@kernel.org>
 <02de8982-ec4a-b3b2-e8e5-1bca28cfc01b@salutedevices.com>
 <20231130085445-mutt-send-email-mst@kernel.org>
 <pbkiwezwlf6dmogx7exur6tjrtcfzxyn7eqlehqxivqifbkojv@xlziiuzekon4>
 <b3fa2aaa-9fdc-30a2-4c87-53eb106900ee@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3fa2aaa-9fdc-30a2-4c87-53eb106900ee@salutedevices.com>

On Thu, Nov 30, 2023 at 06:41:56PM +0300, Arseniy Krasnov wrote:
> 
> 
> On 30.11.2023 17:11, Stefano Garzarella wrote:
> > On Thu, Nov 30, 2023 at 08:58:58AM -0500, Michael S. Tsirkin wrote:
> >> On Thu, Nov 30, 2023 at 04:43:34PM +0300, Arseniy Krasnov wrote:
> >>>
> >>>
> >>> On 30.11.2023 16:42, Michael S. Tsirkin wrote:
> >>> > On Thu, Nov 30, 2023 at 04:08:39PM +0300, Arseniy Krasnov wrote:
> >>> >> Send credit update message when SO_RCVLOWAT is updated and it is bigger
> >>> >> than number of bytes in rx queue. It is needed, because 'poll()' will
> >>> >> wait until number of bytes in rx queue will be not smaller than
> >>> >> SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
> >>> >> for tx/rx is possible: sender waits for free space and receiver is
> >>> >> waiting data in 'poll()'.
> >>> >>
> >>> >> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> >>> >> ---
> >>> >>  Changelog:
> >>> >>  v1 -> v2:
> >>> >>   * Update commit message by removing 'This patch adds XXX' manner.
> >>> >>   * Do not initialize 'send_update' variable - set it directly during
> >>> >>     first usage.
> >>> >>  v3 -> v4:
> >>> >>   * Fit comment in 'virtio_transport_notify_set_rcvlowat()' to 80 chars.
> >>> >>  v4 -> v5:
> >>> >>   * Do not change callbacks order in transport structures.
> >>> >>
> >>> >>  drivers/vhost/vsock.c                   |  1 +
> >>> >>  include/linux/virtio_vsock.h            |  1 +
> >>> >>  net/vmw_vsock/virtio_transport.c        |  1 +
> >>> >>  net/vmw_vsock/virtio_transport_common.c | 27 +++++++++++++++++++++++++
> >>> >>  net/vmw_vsock/vsock_loopback.c          |  1 +
> >>> >>  5 files changed, 31 insertions(+)
> >>> >>
> >>> >> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >>> >> index f75731396b7e..4146f80db8ac 100644
> >>> >> --- a/drivers/vhost/vsock.c
> >>> >> +++ b/drivers/vhost/vsock.c
> >>> >> @@ -451,6 +451,7 @@ static struct virtio_transport vhost_transport = {
> >>> >>          .notify_buffer_size       = virtio_transport_notify_buffer_size,
> >>> >>
> >>> >>          .read_skb = virtio_transport_read_skb,
> >>> >> +        .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
> >>> >>      },
> >>> >>
> >>> >>      .send_pkt = vhost_transport_send_pkt,
> >>> >> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> >>> >> index ebb3ce63d64d..c82089dee0c8 100644
> >>> >> --- a/include/linux/virtio_vsock.h
> >>> >> +++ b/include/linux/virtio_vsock.h
> >>> >> @@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
> >>> >>  void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
> >>> >>  int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
> >>> >>  int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
> >>> >> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val);
> >>> >>  #endif /* _LINUX_VIRTIO_VSOCK_H */
> >>> >> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> >>> >> index af5bab1acee1..8007593a3a93 100644
> >>> >> --- a/net/vmw_vsock/virtio_transport.c
> >>> >> +++ b/net/vmw_vsock/virtio_transport.c
> >>> >> @@ -539,6 +539,7 @@ static struct virtio_transport virtio_transport = {
> >>> >>          .notify_buffer_size       = virtio_transport_notify_buffer_size,
> >>> >>
> >>> >>          .read_skb = virtio_transport_read_skb,
> >>> >> +        .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
> >>> >>      },
> >>> >>
> >>> >>      .send_pkt = virtio_transport_send_pkt,
> >>> >> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >>> >> index f6dc896bf44c..1cb556ad4597 100644
> >>> >> --- a/net/vmw_vsock/virtio_transport_common.c
> >>> >> +++ b/net/vmw_vsock/virtio_transport_common.c
> >>> >> @@ -1684,6 +1684,33 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
> >>> >>  }
> >>> >>  EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
> >>> >>
> >>> >> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, >> int val)
> >>> >> +{
> >>> >> +    struct virtio_vsock_sock *vvs = vsk->trans;
> >>> >> +    bool send_update;
> >>> >> +
> >>> >> +    spin_lock_bh(&vvs->rx_lock);
> >>> >> +
> >>> >> +    /* If number of available bytes is less than new SO_RCVLOWAT value,
> >>> >> +     * kick sender to send more data, because sender may sleep in >> its
> >>> >> +     * 'send()' syscall waiting for enough space at our side.
> >>> >> +     */
> >>> >> +    send_update = vvs->rx_bytes < val;
> >>> >> +
> >>> >> +    spin_unlock_bh(&vvs->rx_lock);
> >>> >> +
> >>> >> +    if (send_update) {
> >>> >> +        int err;
> >>> >> +
> >>> >> +        err = virtio_transport_send_credit_update(vsk);
> >>> >> +        if (err < 0)
> >>> >> +            return err;
> >>> >> +    }
> >>> >> +
> >>> >> +    return 0;
> >>> >> +}
> >>> >
> >>> >
> >>> > I find it strange that this will send a credit update
> >>> > even if nothing changed since this was called previously.
> >>> > I'm not sure whether this is a problem protocol-wise,
> >>> > but it certainly was not envisioned when the protocol was
> >>> > built. WDYT?
> >>>
> >>> >From virtio spec I found:
> >>>
> >>> It is also valid to send a VIRTIO_VSOCK_OP_CREDIT_UPDATE packet without previously receiving a
> >>> VIRTIO_VSOCK_OP_CREDIT_REQUEST packet. This allows communicating updates any time a change
> >>> in buffer space occurs.
> >>> So I guess there is no limitations to send such type of packet, e.g. it is not
> >>> required to be a reply for some another packet. Please, correct me if im wrong.
> >>>
> >>> Thanks, Arseniy
> >>
> >>
> >> Absolutely. My point was different - with this patch it is possible
> >> that you are not adding any credits at all since the previous
> >> VIRTIO_VSOCK_OP_CREDIT_UPDATE.
> > 
> > I think the problem we're solving here is that since as an optimization we avoid sending the update for every byte we consume, but we put a threshold, then we make sure we update the peer.
> > 
> > A credit update contains a snapshot and sending it the same as the previous one should not create any problem.
> > 
> > My doubt now is that we only do this when we set RCVLOWAT , should we also do something when we consume bytes to avoid the optimization we have?
> 
> @Michael, Stefano just reproduced problem during bytes reading, but there is already old fix for this, which we forget to merge:)
> I think it must be included to this patchset.
> 
> https://lore.kernel.org/netdev/f304eabe-d2ef-11b1-f115-6967632f0339@sberdevices.ru/
> 
> Thanks, Arseniy


I generally don't merge patches tagged as RFC.
Repost without that tag?
Also, it looks like a bugfix we need either way, no?

> > 
> > Stefano
> > 



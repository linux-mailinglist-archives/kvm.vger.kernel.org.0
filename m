Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BC173E517
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjFZQak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjFZQaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:30:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF02170D
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687796918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4O/2NH0yzSJoeQQqIwYX3nixVBwHLA7LkW0cO2CrI0s=;
        b=et8zJWhlhwdtXFVcaXGzXJJWL6HikERtno9bem16rTzmuixrKfazG6LCouFCMlBsxWcBLj
        9xLGGej9fF8khxXu4c8Z8lhMuKnJqCuAdB1o4WA+T0GjO5Z8dxbUHlYQFV5aeidfXQTGkp
        RjbUKOXNpaDI/5xVZYuXi4+Rbok02+Q=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-7oE5Ijx9ObyOw0XdayeqbA-1; Mon, 26 Jun 2023 12:28:37 -0400
X-MC-Unique: 7oE5Ijx9ObyOw0XdayeqbA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7623d5cb0caso354927085a.3
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687796916; x=1690388916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4O/2NH0yzSJoeQQqIwYX3nixVBwHLA7LkW0cO2CrI0s=;
        b=gYKnZnPcVYrhhA+MN8XFBnk3gSJgQaN7FW97gxLCB5x/eY7TJnzx9k20L0qZiDPmes
         Z4GOj/iZjWIGh8tiPEjaznApXTd0cVcGwpry/Yv1/yGbzdFAsXd+VPdhg8eAd6hDbb9K
         hv0dAvPkg/TGBEpz6TbVbZ6IlthIlKB6QqNMAcs6Pz1Rwlm0JjxZhsmb/0s44nWkom5d
         Fr0MSUG0C7xS62e5NvlGo8gnFMuVElJQtkxKurFtMApy9OxGjxx6+XGlnRY90BLpUndk
         TeXgLBDc9sIVwgCkvPFoRq7v8uGNKLkLTxd5Lm//NoAul0iu8aZjzxTvVZgQOwdZQeMH
         OtSw==
X-Gm-Message-State: AC+VfDysU2GrA330w8lbvhcqkX4A32pNsDZBqoDkzDIrWVCMLyd6YNao
        U0Gt6z8WpHGzn98febh3jCCo++VtZj+IiptnWkS/fvtWwmDyxAuXqdTFyRMj22aIfIVNcRgvo3M
        bmqmzDHWWVUoU
X-Received: by 2002:a05:620a:1a93:b0:763:9e59:5f72 with SMTP id bl19-20020a05620a1a9300b007639e595f72mr25681283qkb.41.1687796916283;
        Mon, 26 Jun 2023 09:28:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5x5ugD0TqhCXgVw9va06ED6hrsB+ZQed5/Tu0Pg5AhOHB/hmdqOV0biY+XBPnHF/pES4ZZUQ==
X-Received: by 2002:a05:620a:1a93:b0:763:9e59:5f72 with SMTP id bl19-20020a05620a1a9300b007639e595f72mr25681263qkb.41.1687796916050;
        Mon, 26 Jun 2023 09:28:36 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id oo25-20020a05620a531900b0075c9abecdf8sm2877975qkn.1.2023.06.26.09.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 09:28:35 -0700 (PDT)
Date:   Mon, 26 Jun 2023 18:28:31 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 2/4] virtio/vsock: support MSG_PEEK for
 SOCK_SEQPACKET
Message-ID: <yiy3kssoiyzs6ehnlo7g2xsb26zee5vih3jpgyc7i3dvfcyfpv@xvokxez3lzpo>
References: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
 <20230618062451.79980-3-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230618062451.79980-3-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 18, 2023 at 09:24:49AM +0300, Arseniy Krasnov wrote:
>This adds support of MSG_PEEK flag for SOCK_SEQPACKET type of socket.
>Difference with SOCK_STREAM is that this callback returns either length
>of the message or error.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 63 +++++++++++++++++++++++--
> 1 file changed, 60 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 2ee40574c339..352d042b130b 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -460,6 +460,63 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static ssize_t
>+virtio_transport_seqpacket_do_peek(struct vsock_sock *vsk,
>+				   struct msghdr *msg)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct sk_buff *skb;
>+	size_t total, len;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	if (!vvs->msg_count) {
>+		spin_unlock_bh(&vvs->rx_lock);
>+		return 0;
>+	}
>+
>+	total = 0;
>+	len = msg_data_left(msg);
>+
>+	skb_queue_walk(&vvs->rx_queue, skb) {
>+		struct virtio_vsock_hdr *hdr;
>+
>+		if (total < len) {
>+			size_t bytes;
>+			int err;
>+
>+			bytes = len - total;
>+			if (bytes > skb->len)
>+				bytes = skb->len;
>+
>+			spin_unlock_bh(&vvs->rx_lock);
>+
>+			/* sk_lock is held by caller so no one else can dequeue.
>+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>+			 */
>+			err = memcpy_to_msg(msg, skb->data, bytes);
>+			if (err)
>+				return err;
>+
>+			spin_lock_bh(&vvs->rx_lock);
>+		}
>+
>+		total += skb->len;
>+		hdr = virtio_vsock_hdr(skb);
>+
>+		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) {
>+			if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOR)
>+				msg->msg_flags |= MSG_EOR;
>+
>+			break;
>+		}
>+	}
>+
>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	return total;

Should we return the minimum between total and len?

Thanks,
Stefano

>+}
>+
> static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 						 struct msghdr *msg,
> 						 int flags)
>@@ -554,9 +611,9 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> 				   int flags)
> {
> 	if (flags & MSG_PEEK)
>-		return -EOPNOTSUPP;
>-
>-	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
>+		return virtio_transport_seqpacket_do_peek(vsk, msg);
>+	else
>+		return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>
>-- 
>2.25.1
>


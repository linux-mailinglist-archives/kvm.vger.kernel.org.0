Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7DC366760
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 10:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbhDUI5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 04:57:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42575 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234632AbhDUI5Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 04:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618995411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SEt58VbFvs2xemicT0zBRkhdh8N6/jqkICXkVkT9euM=;
        b=cZm+KwkLdm0d34/aLSayBy99G+aWAf80SXiafy1XhW52uIk/VN7+8IPBN+lumBns+TY+2H
        252mrKhcK5qQU2XAqXyUUQQ5/CD+94da5ZE4LZ1Bvz+GmLOuShBWbHlS8BtahU5AOJprHn
        DHXURcvzF8PVif3tY/2MIO9PrANB5Xg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549--jpjHtK3MMepxOCl2YEXzQ-1; Wed, 21 Apr 2021 04:56:49 -0400
X-MC-Unique: -jpjHtK3MMepxOCl2YEXzQ-1
Received: by mail-ed1-f72.google.com with SMTP id w15-20020a056402268fb02903828f878ec5so14645246edd.5
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 01:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SEt58VbFvs2xemicT0zBRkhdh8N6/jqkICXkVkT9euM=;
        b=SHzTibeld0BJKhPv0mREOA3MtERabRmG79tK3X1zqGZdimId3IjCEPD0nfRWhFpH+k
         ginvZsyf0Wgl6n0GuYMrrYOXDcgdvlXGXzwvvPVs/dBGzuJKPXUL3rFrUMNMviwWgXEM
         wIZdkbjPtZKCA2igfLXkwWyJ0FVyooMWbOoW3O4isUQREGfO8e6qgmQEpeNG7sb5+OqD
         M9pKMhzInbMoNynoCIHsP/yHu4ItI8MH0qvyXJ1zVD66NZu/qfvtO8JXL1543ZKD7UVa
         gaUMA4coH41CCYePVuJCT6+g3R1xGZdXv0FIwMH6ExhBchmNXMM6Dtd7nGw92FsL3xgp
         dYfw==
X-Gm-Message-State: AOAM530j1+JKDQltA4Gss4z2eTlNkD4w9FCURdrK3Cij/XaD4YhJlZxS
        GwSvAUNRYTwdgmauMiO3jnWB4FoGL9Oh9azYhSIaIhIQwy+XMP5/mSWEpqzDP64M9KD8nhU69R4
        ySsEHqF37ECg7
X-Received: by 2002:a05:6402:3079:: with SMTP id bs25mr37112000edb.369.1618995408385;
        Wed, 21 Apr 2021 01:56:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVKAFDOm/ut3DgHKQpFeoviJZKXQkE7zcUV8M8seOk13Zkiub5ZYnl8jEUrk51HHxRRca4Uw==
X-Received: by 2002:a05:6402:3079:: with SMTP id bs25mr37111975edb.369.1618995408182;
        Wed, 21 Apr 2021 01:56:48 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id w1sm2452811edt.89.2021.04.21.01.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 01:56:47 -0700 (PDT)
Date:   Wed, 21 Apr 2021 10:56:45 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        stsp <stsp2@yandex.ru>, Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v8 11/19] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <CAGxU2F7pCfVow7B5KG4hSYjxyH2LcL3wriRvrgURTxeqzn8M9A@mail.gmail.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124443.3403382-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413124443.3403382-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 03:44:40PM +0300, Arseny Krasnov wrote:
>This adds transport callback and it's logic for SEQPACKET dequeue.
>Callback fetches RW packets from rx queue of socket until whole record
>is copied(if user's buffer is full, user is not woken up). This is done
>to not stall sender, because if we wake up user and it leaves syscall,
>nobody will send credit update for rest of record, and sender will wait
>for next enter of read syscall at receiver's side. So if user buffer is
>full, we just send credit update and drop data.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
>v7 -> v8:
> - Things like SEQ_BEGIN, SEQ_END, 'msg_len' and 'msg_id' now removed.
>   This callback fetches and copies RW packets to user's buffer, until
>   last packet of message found(this packet is marked in 'flags' field
>   of header).
>
> include/linux/virtio_vsock.h            |  5 ++
> net/vmw_vsock/virtio_transport_common.c | 73 +++++++++++++++++++++++++
> 2 files changed, 78 insertions(+)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index dc636b727179..02acf6e9ae04 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>                              struct msghdr *msg,
>                              size_t len, int flags);
>
>+ssize_t
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+                                 struct msghdr *msg,
>+                                 int flags,
>+                                 bool *msg_ready);
> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 833104b71a1c..8492b8bd5df5 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -393,6 +393,67 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>       return err;
> }
>
>+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>+                                               struct msghdr *msg,
>+                                               int flags,
>+                                               bool *msg_ready)
>+{
>+      struct virtio_vsock_sock *vvs = vsk->trans;
>+      struct virtio_vsock_pkt *pkt;
>+      int err = 0;
>+      size_t user_buf_len = msg->msg_iter.count;
>+
>+      *msg_ready = false;
>+      spin_lock_bh(&vvs->rx_lock);
>+
>+      while (!*msg_ready && !list_empty(&vvs->rx_queue) && err >= 0) {
>+              pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>+
>+              if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RW) {

Is this check still necessary, should they all be RW?

>+                      size_t bytes_to_copy;
>+                      size_t pkt_len;
>+
>+                      pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>+                      bytes_to_copy = min(user_buf_len, pkt_len);
>+

If bytes_to_copy == 0, we can avoid the next steps (release the lock try 
to copy 0 bytes, reacquire the lock)

>+                      /* sk_lock is held by caller so no one else can dequeue.
>+                       * Unlock rx_lock since memcpy_to_msg() may sleep.
>+                       */
>+                      spin_unlock_bh(&vvs->rx_lock);
>+
>+                      if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy)) {
>+                              err = -EINVAL;

Here we should reacquire the lock or prevent it from being released out
of cycle.

>+                              break;
>+                      }
>+
>+                      spin_lock_bh(&vvs->rx_lock);
>+

As mentioned before, I think we could move this part into the core and 
here always return the real dimension.

>+                      /* If user sets 'MSG_TRUNC' we return real 
>length
>+                       * of message.
>+                       */
>+                      if (flags & MSG_TRUNC)
>+                              err += pkt_len;
>+                      else
>+                              err += bytes_to_copy;
>+
>+                      user_buf_len -= bytes_to_copy;
>+
>+                      if (pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)
                                     ^
We should use le32_to_cpu() to read the flags.


>+                              *msg_ready = true;
>+              }
>+
>+              virtio_transport_dec_rx_pkt(vvs, pkt);
>+              list_del(&pkt->list);
>+              virtio_transport_free_pkt(pkt);
>+      }
>+
>+      spin_unlock_bh(&vvs->rx_lock);
>+
>+      virtio_transport_send_credit_update(vsk);
>+
>+      return err;
>+}
>+
> ssize_t
> virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>                               struct msghdr *msg,
>@@ -405,6 +466,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> }
> EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
>
>+ssize_t
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+                                 struct msghdr *msg,
>+                                 int flags, bool *msg_ready)
>+{
>+      if (flags & MSG_PEEK)
>+              return -EOPNOTSUPP;
>+
>+      return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags,
>msg_ready);
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>+
> int
> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>                              struct msghdr *msg,
>--
>2.25.1
>


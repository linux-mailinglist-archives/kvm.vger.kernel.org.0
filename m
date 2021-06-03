Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F36F39A394
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 16:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhFCOrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 10:47:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229744AbhFCOrN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 10:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622731527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YABTD2STAWQQlm5tg1g6NJ074ZuyxPbxn7absUYPnjc=;
        b=Mi9+2JOFx8LWvH2uflgajWcrwnFORLvs4sy3e5rcWQYS6Gw3ckQ+78TtTNmynYX9fSM2z2
        Wv/EZWtvF7HBUIqPLsRaEf+bD+yzN7oBeVJAAy3XltFOCpK+e81kNOV8YEvwAovExaJUo4
        0O9VqEGp6hAXI2VJiVtF+6iapaBKqPM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-0ZAV7_Q5OKm4Zg2xBq3dnQ-1; Thu, 03 Jun 2021 10:45:20 -0400
X-MC-Unique: 0ZAV7_Q5OKm4Zg2xBq3dnQ-1
Received: by mail-ed1-f69.google.com with SMTP id z16-20020aa7d4100000b029038feb83da57so3387758edq.4
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 07:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YABTD2STAWQQlm5tg1g6NJ074ZuyxPbxn7absUYPnjc=;
        b=bE2OFsdXYOAL3n4t+LfLA6qoRDjFpuFFDamHFqiMtZFUBDE1UeoJJSje1kiWBL5cj0
         Pe6hdd2wUJo+ujAEaYRFSQXcGRTBCUawwWZBPXq0w0BOKpNdyya4ptRoTVmjGgso+Orn
         cRBVpIsnY2ecbDKcTfKtgpMmRoybDOrI1BN32XhD1HLq4IwYaT6qhMl+AtfAtNLz1TAG
         WXGt0qXvMcNgviomTUY7fyxnIiE1xjEpoLbxNx+eeC/0EDdIcM3nEF7w6/iuFPPUcr8z
         ALCeLVpbhc7epBpCermQMLOJ5IMaywfkpZwSu5anau85NQ2PyVHR/6tC5U02qdmzHA+4
         QvUw==
X-Gm-Message-State: AOAM5305G4OUctzqOLRzm7CtaZIy1zVJQAtXFfuM5NvIn2bvyFrDFJH2
        IS65lhU5oHS8bP0B4r351NRJVyHJFv9kpT5g3LXraUxJ0cZz73aYbxbSY2xNR6lKvHsiIyAA5Ao
        1AkMqsUW/rIVt
X-Received: by 2002:a50:afe4:: with SMTP id h91mr203591edd.28.1622731518862;
        Thu, 03 Jun 2021 07:45:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJXKlXoitE1mjpn8GN6FD+0N7T0+mjhG0D3VTzD5XyuA6+OeMMiJZX3H1kZB9DlLneqf+VlA==
X-Received: by 2002:a50:afe4:: with SMTP id h91mr203573edd.28.1622731518678;
        Thu, 03 Jun 2021 07:45:18 -0700 (PDT)
Received: from steredhat ([5.170.129.82])
        by smtp.gmail.com with ESMTPSA id bh3sm1622721ejb.19.2021.06.03.07.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 07:45:17 -0700 (PDT)
Date:   Thu, 3 Jun 2021 16:45:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210603144513.ryjzauq7abnjogu3@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191801.1272027-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191801.1272027-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 10:17:58PM +0300, Arseny Krasnov wrote:
>Callback fetches RW packets from rx queue of socket until whole record
>is copied(if user's buffer is full, user is not woken up). This is done
>to not stall sender, because if we wake up user and it leaves syscall,
>nobody will send credit update for rest of record, and sender will wait
>for next enter of read syscall at receiver's side. So if user buffer is
>full, we just send credit update and drop data.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v9 -> v10:
> 1) Number of dequeued bytes incremented even in case when
>    user's buffer is full.
> 2) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
> 3) Rename variable 'err' to 'dequeued_len', in case of error
>    it has negative value.
>
> include/linux/virtio_vsock.h            |  5 ++
> net/vmw_vsock/virtio_transport_common.c | 65 +++++++++++++++++++++++++
> 2 files changed, 70 insertions(+)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index dc636b727179..02acf6e9ae04 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+ssize_t
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags,
>+				   bool *msg_ready);
> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index ad0d34d41444..61349b2ea7fe 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -393,6 +393,59 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>+						 struct msghdr *msg,
>+						 int flags,
>+						 bool *msg_ready)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct virtio_vsock_pkt *pkt;
>+	int dequeued_len = 0;
>+	size_t user_buf_len = msg_data_left(msg);
>+
>+	*msg_ready = false;
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	while (!*msg_ready && !list_empty(&vvs->rx_queue) && dequeued_len >= 0) {

I'

>+		size_t bytes_to_copy;
>+		size_t pkt_len;
>+
>+		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>+		pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>+		bytes_to_copy = min(user_buf_len, pkt_len);
>+
>+		if (bytes_to_copy) {
>+			/* sk_lock is held by caller so no one else can dequeue.
>+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>+			 */
>+			spin_unlock_bh(&vvs->rx_lock);
>+
>+			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy))
>+				dequeued_len = -EINVAL;

I think here is better to return the error returned by memcpy_to_msg(), 
as we do in the other place where we use memcpy_to_msg().

I mean something like this:
			err = memcpy_to_msgmsg, pkt->buf, bytes_to_copy);
			if (err)
				dequeued_len = err;

>+			else
>+				user_buf_len -= bytes_to_copy;
>+
>+			spin_lock_bh(&vvs->rx_lock);
>+		}
>+

Maybe here we can simply break the cycle if we have an error:
		if (dequeued_len < 0)
			break;

Or we can refactor a bit, simplifying the while() condition and also the 
code in this way (not tested):

	while (!*msg_ready && !list_empty(&vvs->rx_queue)) {
		...

		if (bytes_to_copy) {
			int err;

			/* ...
			*/
			spin_unlock_bh(&vvs->rx_lock);
			err = memcpy_to_msgmsg, pkt->buf, bytes_to_copy);
			if (err) {
				dequeued_len = err;
				goto out;
			}
			spin_lock_bh(&vvs->rx_lock);

			user_buf_len -= bytes_to_copy;
		}

		dequeued_len += pkt_len;

		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
			*msg_ready = true;

		virtio_transport_dec_rx_pkt(vvs, pkt);
		list_del(&pkt->list);
		virtio_transport_free_pkt(pkt);
	}

out:
	spin_unlock_bh(&vvs->rx_lock);

	virtio_transport_send_credit_update(vsk);

	return dequeued_len;
}


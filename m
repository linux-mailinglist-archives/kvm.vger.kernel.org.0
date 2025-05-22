Return-Path: <kvm+bounces-47339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC38CAC026C
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 04:18:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE7CB4E2E88
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 02:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26AD684D34;
	Thu, 22 May 2025 02:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aNt++kvn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC44B1854;
	Thu, 22 May 2025 02:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747880278; cv=none; b=bILhnpm0XQusiNiqFVCBMAoLv0AboScpH16POeG/e9tTOmaGzVdPySEDaR4A4VrmCTtABc1Wxc0vz72yN7RcbFe9ayXZwlfd9sMeFnkUb306lgNfB9L5j0LMfwOW8Cp4fWZei9fQpkqP2bzTX+L18iMEypvD2Oa6SfV2dfPu3IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747880278; c=relaxed/simple;
	bh=ZKHlp2Nech7ncXIlk7l+RizijugHYBco9l6vR+ZotRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jto2EkQm2pNXW+8mjdD54p6XgdUcAZzrXPlgRfg+HZ9gRotpTXnPhUkfeqMI6hW5UGi1PyhuEq5J5uDVgnAD8TwIeFpdDUw7x5kRDdznIswIQW6GJVIKpKbvMKenW/jZkjej8d6YST0d5rht31ph/lYr9tXgLxGmJV0rQL6ZnvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aNt++kvn; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-742c9563fd9so3813711b3a.3;
        Wed, 21 May 2025 19:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747880276; x=1748485076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D921nCJ6FrC9kndO6rYQP/8DUS7TGpst7yDOrwd7H6w=;
        b=aNt++kvnpZKH9dAipVCX7H3aRwL9BR0ngtuNjb+KjI3tEuxk/oHPkQ+TIIGZqShY07
         Z3cYwKN8hSryHmVrSO1wN6LxD1AJtW5SgYI/vCgAxK4L2uQN8DMQaeHpKOMekcT3zNW1
         cGOjXgd2zIsKVGiM0kD0qcKan1mcuS1f3IG4Q8SeYxn7UkYuwRIeiRyG2DCnpPhkzmeM
         zNVRHXJBGfen9vWiIPtc2IMK/OY6riWo83lT4lLQQrbAh1wFcODkJIbqqGpExO0ukkEd
         Ot/NtD7nPjIyQc3NZ0zwcSfpFTwyqe6ld9StU77j/PozydhI/bSbuvO5GfXroCUXj0aL
         /48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747880276; x=1748485076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D921nCJ6FrC9kndO6rYQP/8DUS7TGpst7yDOrwd7H6w=;
        b=qbjbq3GA8OCSnFUKttSMG/ZByDfhu1BXEiyq764+XQvNy+j4Q+8Rc2z9WUe4F3lUjG
         rVpqbpH+somqAXEwGln3pugMVa9zJ67zdjGSMeX9yVarISc1U9wzyeH3dV8z3bDwHbgw
         SzlLmgUoiWX7c/9HwFc3yg0o69chTe11+dnbmzYSpxbRac5TjkGBXCkFdBqdwClM4iSy
         JmyU0tORdBlQwMgsGpwFkObHM+2AtITMc94yF1giiHSV1GQs/97u4TpkeBI4UieYiWVa
         89uMkQvFYSDqLrW+/AyNwY99G5BtZ9vwSwIRQkNwpn1DpkNLYlt6CsFbn2tUxW3nYTc1
         8eeA==
X-Forwarded-Encrypted: i=1; AJvYcCWEIbWpHD2a9yqiczihoE0zO+45/ipE3OM1tqifbhZgreCYxiDSdQFI+dS6lPDHVBl4IvqMp9pVzC20FoWx@vger.kernel.org, AJvYcCXKX9gyAZlurSJqYtxjXIBN8RthpzTJUwaycmZ+R9Gh7WVRHsuI7DENWOThQuRntgEzbTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPa+br2J91ux2pMps8byKWE3OFnLXeAomJ0v4uSSFD03mLjfmk
	76EoHOmocd68Te4HLn1+aeqaVcEkN5UZ0XH05msfcal6NmUyk5Fqlgvn1+aMQkep61M=
X-Gm-Gg: ASbGnctqCITzWJkBvOucgY//daSsgtleZ5p+CRvGtszT4b//xmEb8JL7vw6S7ZECmM2
	FUEWsdIafDAXXUJrNFiqF8cD/e7os5WTTfmTr7KDHUQ3sbool0XOSMk9Xz3cTFkFLL7HVHqd7cJ
	nWgPn0loZ80I/M62jTIFr8w7IBmCza42LEoH8dhWQ5GVUCVczifqLhaAlC11lYdvpDTo6XZWYWR
	ykwjnO7nZY89oxmhdQ1/1ETVJBVQMObgNGj4Jx2iOR4MEdQ0I9de8+56XmKZw6aTxQVMx5PpcnJ
	cnBgJ1JpN3yTQjChPib1JjpDkaVXJfAuF7IgFftRvoUInNvnqycDK84oG3RzZ8Y+yeRTOdt5FA=
	=
X-Google-Smtp-Source: AGHT+IHZzsGo8/7lkBUgo0SExevzjPKhKdaR3FROnQpsvJA4S96qjNIpAkDzf1CO5av9nl8PYHKI/A==
X-Received: by 2002:a05:6a00:e0e:b0:730:9946:5973 with SMTP id d2e1a72fcca58-742acc8da9fmr27434635b3a.5.1747880275746;
        Wed, 21 May 2025 19:17:55 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a96e2106sm10542863b3a.17.2025.05.21.19.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 19:17:55 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: Oxffffaa@gmail.com,
	davem@davemloft.net,
	fupan.lfp@antgroup.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH 2/3] vsock/virtio: Add SIOCINQ support for all virtio based transports
Date: Thu, 22 May 2025 10:17:39 +0800
Message-Id: <20250522021739.3363194-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAGxU2F4k-K+nvF4re8kQwdMfPZ=a6KLvgj-ntAPZVxyQKv6E_w@mail.gmail.com>
References: <CAGxU2F4k-K+nvF4re8kQwdMfPZ=a6KLvgj-ntAPZVxyQKv6E_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Wed, 21 May 2025 at 10:58, Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > Forgot to CC Arseniy.
> >
> > On Wed, 21 May 2025 at 10:57, Stefano Garzarella <sgarzare@redhat.com> wrote:
> > >
> > > On Wed, May 21, 2025 at 10:06:13AM +0800, Xuewei Niu wrote:
> > > >> On Mon, May 19, 2025 at 03:06:48PM +0800, Xuewei Niu wrote:
> > > >> >The virtio_vsock_sock has a new field called bytes_unread as the return
> > > >> >value of the SIOCINQ ioctl.
> > > >> >
> > > >> >Though the rx_bytes exists, we introduce a bytes_unread field to the
> > > >> >virtio_vsock_sock struct. The reason is that it will not be updated
> > > >> >until the skbuff is fully consumed, which causes inconsistency.
> > > >> >
> > > >> >The byte_unread is increased by the length of the skbuff when skbuff is
> > > >> >enqueued, and it is decreased when dequeued.
> > > >> >
> > > >> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> > > >> >---
> > > >> > drivers/vhost/vsock.c                   |  1 +
> > > >> > include/linux/virtio_vsock.h            |  2 ++
> > > >> > net/vmw_vsock/virtio_transport.c        |  1 +
> > > >> > net/vmw_vsock/virtio_transport_common.c | 17 +++++++++++++++++
> > > >> > net/vmw_vsock/vsock_loopback.c          |  1 +
> > > >> > 5 files changed, 22 insertions(+)
> > > >> >
> > > >> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > >> >index 802153e23073..0f20af6e5036 100644
> > > >> >--- a/drivers/vhost/vsock.c
> > > >> >+++ b/drivers/vhost/vsock.c
> > > >> >@@ -452,6 +452,7 @@ static struct virtio_transport vhost_transport = {
> > > >> >            .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
> > > >> >
> > > >> >            .unsent_bytes             = virtio_transport_unsent_bytes,
> > > >> >+           .unread_bytes             = virtio_transport_unread_bytes,
> > > >> >
> > > >> >            .read_skb = virtio_transport_read_skb,
> > > >> >    },
> > > >> >diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > > >> >index 0387d64e2c66..0a7bd240113a 100644
> > > >> >--- a/include/linux/virtio_vsock.h
> > > >> >+++ b/include/linux/virtio_vsock.h
> > > >> >@@ -142,6 +142,7 @@ struct virtio_vsock_sock {
> > > >> >    u32 buf_alloc;
> > > >> >    struct sk_buff_head rx_queue;
> > > >> >    u32 msg_count;
> > > >> >+   size_t bytes_unread;
> > > >>
> > > >> Can we just use `rx_bytes` field we already have?
> > > >>
> > > >> Thanks,
> > > >> Stefano
> > > >
> > > >I perfer not. The `rx_bytes` won't be updated until the skbuff is fully
> > > >consumed, causing inconsistency issues. If it is acceptable to you, I'll
> > > >reuse the field instead.
> > >
> > > I think here we found a little pre-existing issue that should be related
> > > also to what Arseniy (CCed) is trying to fix (low_rx_bytes).
> > >
> > > We basically have 2 counters:
> > > - rx_bytes, which we use internally to see if there are bytes to read
> > >    and for sock_rcvlowat
> > > - fwd_cnt, which we use instead for the credit mechanism and informing
> > >    the other peer whether we have space or not
> > >
> > > These are updated with virtio_transport_dec_rx_pkt() and
> > > virtio_transport_inc_rx_pkt()
> > >
> > > As far as I can see, from the beginning, we call
> > > virtio_transport_dec_rx_pkt() only when we consume the entire packet.
> > > This makes sense for `fwd_cnt`, because we still have occupied space in
> > > memory and we don't want to update the credit until we free all the
> > > space, but I think it makes no sense for `rx_bytes`, which is only used
> > > internally and should reflect the current situation of bytes to read.
> > >
> > > So in my opinion we should fix it this way (untested):
> > >
> > > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > > index 11eae88c60fc..ee70cb114328 100644
> > > --- a/net/vmw_vsock/virtio_transport_common.c
> > > +++ b/net/vmw_vsock/virtio_transport_common.c
> > > @@ -449,10 +449,10 @@ static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
> > >   }
> > >
> > >   static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
> > > -                                       u32 len)
> > > +                                       u32 bytes_read, u32 bytes_dequeued)
> > >   {
> > > -       vvs->rx_bytes -= len;
> > > -       vvs->fwd_cnt += len;
> > > +       vvs->rx_bytes -= bytes_read;
> > > +       vvs->fwd_cnt += bytes_dequeued;
> > >   }
> > >
> > >   void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb)
> > > @@ -581,11 +581,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> > >                                    size_t len)
> > >   {
> > >         struct virtio_vsock_sock *vvs = vsk->trans;
> > > -       size_t bytes, total = 0;
> > >         struct sk_buff *skb;
> > >         u32 fwd_cnt_delta;
> > >         bool low_rx_bytes;
> > >         int err = -EFAULT;
> > > +       size_t total = 0;
> > >         u32 free_space;
> > >
> > >         spin_lock_bh(&vvs->rx_lock);
> > > @@ -597,6 +597,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> > >         }
> > >
> > >         while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
> > > +               size_t bytes, dequeued = 0;
> > > +
> > >                 skb = skb_peek(&vvs->rx_queue);
> > >
> > >                 bytes = min_t(size_t, len - total,
> > > @@ -620,12 +622,12 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> > >                 VIRTIO_VSOCK_SKB_CB(skb)->offset += bytes;
> > >
> > >                 if (skb->len == VIRTIO_VSOCK_SKB_CB(skb)->offset) {
> > > -                       u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
> > > -
> > > -                       virtio_transport_dec_rx_pkt(vvs, pkt_len);
> > > +                       dequeued = le32_to_cpu(virtio_vsock_hdr(skb)->len);
> > >                         __skb_unlink(skb, &vvs->rx_queue);
> > >                         consume_skb(skb);
> > >                 }
> > > +
> > > +               virtio_transport_dec_rx_pkt(vvs, bytes, dequeued);
> > >         }
> > >
> > >         fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
> > > @@ -782,7 +784,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> > >                                 msg->msg_flags |= MSG_EOR;
> > >                 }
> > >
> > > -               virtio_transport_dec_rx_pkt(vvs, pkt_len);
> > > +               virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
> > >                 vvs->bytes_unread -= pkt_len;
> > >                 kfree_skb(skb);
> > >         }
> > > @@ -1752,6 +1754,7 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
> > >         struct sock *sk = sk_vsock(vsk);
> > >         struct virtio_vsock_hdr *hdr;
> > >         struct sk_buff *skb;
> > > +       u32 pkt_len;
> > >         int off = 0;
> > >         int err;
> > >
> > > @@ -1769,7 +1772,8 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
> > >         if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
> > >                 vvs->msg_count--;
> > >
> > > -       virtio_transport_dec_rx_pkt(vvs, le32_to_cpu(hdr->len));
> > > +       pkt_len = le32_to_cpu(hdr->len);
> > > +       virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
> > >         spin_unlock_bh(&vvs->rx_lock);
> > >
> > >         virtio_transport_send_credit_update(vsk);
> > >
> > > @Arseniy WDYT?
> > > I will test it and send a proper patch.
> > >
> > > @Xuewei with that fixed, I think you can use `rx_bytes`, right?
> 
> If it's true, can we just use `vsock_stream_has_data()` return value
> instead of adding a new transport's callback?
> 
> Thanks,
> Stefano

Nice catch! Will do.

Thanks,
Xuewei

> > >
> > > Also because you missed for example `virtio_transport_read_skb()` used
> > > by ebpf (see commit 3543152f2d33 ("vsock: Update rx_bytes on
> > > read_skb()")).
> > >
> > > Thanks,
> > > Stefano


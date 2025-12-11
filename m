Return-Path: <kvm+bounces-65749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 435EECB572E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:09:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 50B06302651D
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0CFF2FE050;
	Thu, 11 Dec 2025 10:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UDl+7uZW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZkAkRUqs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8122FD67F
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 10:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765447716; cv=none; b=DqFIku9NyxS18SyfxkK4xjKQXPGjtgN35kd+6M79SesZVFItPKLiwwOX0wcBD8cOhMISTxq8fy+YOuo5UwifSyqmk/YlW2cNMXGmFRTpaGv8jYz6ZId/VYyv93JRm7xmiPL9Ka3GzVjd0MbcA3x4ZXsmoqfFgowZo8sgfvIDFRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765447716; c=relaxed/simple;
	bh=Z6F4cyJG0ag9g4o6gvbAfAEBxmgGeyUKxQcpLWwALwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dUZil00VJ12iVyFz3RcRDnwJvyJToEtQcVt4VTQOXGeXqJyEfsockAU1GTtBtGG+kvK3eckuBgF50ZAy0BRekE4b1GfhxsPUWiZwIq2e8uGAKf0UqLskwQKxAV68ccUZ8mWX8utuq1i4lHRRDWJ6QdMTaUDMPDPpNZl01B/WaSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UDl+7uZW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZkAkRUqs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765447712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=It7DxdigJxddZuWUloOutXizs1cOeKKTv93WFfqSdUU=;
	b=UDl+7uZWzHfeTTiRYo9OP7bYqodTJH2CcWMQjkE1ChW0siV3Ki8Zf8KsslkDEvJbWbRKgL
	a2eTrTQVcICU5QB4SvzLIztL8ZRtDY+1f8F0Cng2LzkdHLQ2fw2vxUR3j8zLPaigk94Vd8
	kjtJhXfXVoH+Xzlnz424X3CZLL7IRv4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-CrEhnzzXPOmgvg0A929QWw-1; Thu, 11 Dec 2025 05:08:31 -0500
X-MC-Unique: CrEhnzzXPOmgvg0A929QWw-1
X-Mimecast-MFC-AGG-ID: CrEhnzzXPOmgvg0A929QWw_1765447710
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-64161017e34so1115036a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 02:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765447710; x=1766052510; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=It7DxdigJxddZuWUloOutXizs1cOeKKTv93WFfqSdUU=;
        b=ZkAkRUqs6f9THRQHFFWyPLGAdOLuM03VKsZ6e4gBkiCp4q4Mn7XxBisA/kqB0E4M8y
         qUOrXEPDhNqngkNAG1EjbD3inoVJCe5QQMEBEcAoaTkKUL/8s1D+pkDBr658xOhu2mRR
         WGsyoWniXnXWMs7yJcDzTWur4PKAnbDLvi47ORr780wm3dJlT4oQ8PJi2OFfQ6yj4xcF
         bBcap+ocHFVgHzqSzyxqaBTlADWHuE5zqLISHiLu9mH4tBVVfYLoYJ7N88YTwed0+ZSe
         fJhmDhD+xmZ/SPYbi7sk09iA+a0yf9XG5CgdB6E+KEbs2AOUqVIQKVVYOpGZdfx+U3un
         /dAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765447710; x=1766052510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=It7DxdigJxddZuWUloOutXizs1cOeKKTv93WFfqSdUU=;
        b=Ould769eP4JANXWUo/h/CyllsgdjCfo7muUU9Greo0m1pgwqDGQPKyXylRXmUXaZpb
         xfV+TN9PcWcO7VAN6SHyGbulhfieq3eIB3039oxScQc0ahmBy8DgH/kCDDIb54SEi7lL
         +mHxRpKrCDfCrzxJUwHCKS6s45p2JIvEDxhgZURdcZpqn6GtNbo7+Py0vQTxW0msHEnB
         lSLmICqaBHJaLK4BCxlewtTTdL0CsTqL4h3CLkZxJy9Htq/08IiTARNITgO878zqdwFj
         6+KCZNWbYGxveGJH9oKV+uaNuB3P1IyqH2+LgG/3wCgszRN0tOw6xhaKct3RXshLRW42
         qmSw==
X-Forwarded-Encrypted: i=1; AJvYcCVTIIGaBpOZ/xBAs4A6x3iOuSe9AScsOJnXHjkihyOVBGdCfn/waj1kJrXmQx6Lba/5muc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+QBmXcTekbL8jLBtVtbeKh/negONP6ovzk8adiSGFU/6+5PPM
	x/J4PmAnBNLR2RuDf8OnzSBoDiRuAi1A7Q5q8bNkCQ96JdB1ihYep5fJhLmR93IKtTSPelkeCiE
	mtUAUVv1nDcWbfc7uXCroBFMANUpG5ZhssqSZeZj+qbigzvnwMYe/oA==
X-Gm-Gg: AY/fxX7CZD57CQmWJ3QhxKZV5uXtW0+eBiY4CwNe2g2ADRBSUMVimQ0Ca4R0EwyNvNZ
	F8akh8RpeJIbKz/HbGpPWVMDH8+Y7b11KZTwkpZ//pVdiyMhEIJE4ghLpRPWtBEilAaUnzgkPUS
	MLCtrQwY0Tjafgi285HCU7tlFd0b7U5dMegna5foVxJufDyZmDOBRyMlB8nTKtSCFvjFJwJIbEL
	i3Ne7xmxn44Fo7aCuLrAHslVJztpu5YZkE748hXAZefw5pUHNOquuxtIfmS3dNHbBppHuyIWaqt
	DqOCIFqvCYi6MLEKGYrXNeSbNZ76RYY8v99G5ndYJpeW7Nz/DZiGLSn7xHA8OvwNM2GoVCdBnN2
	CzPnz+fUks8fnxBLd9ENcWdLfGUijdEb25t549bom5HS/bS+vYGgL0W9oqwktLw==
X-Received: by 2002:a17:907:da2:b0:b73:43ee:a262 with SMTP id a640c23a62f3a-b7ce847d2f4mr637244166b.51.1765447709779;
        Thu, 11 Dec 2025 02:08:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIvJ2BgbEFzBe9LXBrZFx1TCLyohl5hausmIEk65oCIi6GUKf+K0NeBup5hRhrXwmZL3RA0g==
X-Received: by 2002:a17:907:da2:b0:b73:43ee:a262 with SMTP id a640c23a62f3a-b7ce847d2f4mr637239766b.51.1765447709120;
        Thu, 11 Dec 2025 02:08:29 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa29eb69sm230379866b.6.2025.12.11.02.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 02:08:27 -0800 (PST)
Date: Thu, 11 Dec 2025 11:08:21 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org
Subject: Re: [PATCH] vsock/virtio: cap TX credit to local buffer size
Message-ID: <CAGxU2F6TMP7tOo=DONL9CJUW921NXyx9T65y_Ai5pbzh1LAQaA@mail.gmail.com>
References: <20251210150019.48458-1-mlbnkm1@gmail.com>
 <ctubihgjn65za4hbmanhkzg7psr6kmj3jeqfj5sfxnnxjjvrsy@l6644u74vrn6>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ctubihgjn65za4hbmanhkzg7psr6kmj3jeqfj5sfxnnxjjvrsy@l6644u74vrn6>

On Thu, 11 Dec 2025 at 10:10, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Wed, Dec 10, 2025 at 04:00:19PM +0100, Melbin K Mathew wrote:
> >The virtio vsock transport currently derives its TX credit directly
> >from peer_buf_alloc, which is set from the remote endpoint's
> >SO_VM_SOCKETS_BUFFER_SIZE value.
>
> Why removing the target tree [net] from the tags?
>
> Also this is a v2, so the tags should have been [PATCH net v2], please
> check it in next versions, more info:
>
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#subject-line
>
> >
> >On the host side this means that the amount of data we are willing to
> >queue for a connection is scaled by a guest-chosen buffer size,
> >rather than the host's own vsock configuration. A malicious guest can
> >advertise a large buffer and read slowly, causing the host to allocate
> >a correspondingly large amount of sk_buff memory.
> >
> >Introduce a small helper, virtio_transport_peer_buf_alloc(), that
> >returns min(peer_buf_alloc, buf_alloc), and use it wherever we consume
> >peer_buf_alloc:
> >
> >  - virtio_transport_get_credit()
> >  - virtio_transport_has_space()
> >  - virtio_transport_seqpacket_enqueue()
> >
> >This ensures the effective TX window is bounded by both the peer's
> >advertised buffer and our own buf_alloc (already clamped to
> >buffer_max_size via SO_VM_SOCKETS_BUFFER_MAX_SIZE), so a remote guest
> >cannot force the host to queue more data than allowed by the host's
> >own vsock settings.
> >
> >On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
> >32 guest vsock connections advertising 2 GiB each and reading slowly
> >drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB and the system only
> >recovered after killing the QEMU process.
> >
> >With this patch applied, rerunning the same PoC yields:
> >
> >  Before:
> >    MemFree:        ~61.6 GiB
> >    MemAvailable:   ~62.3 GiB
> >    Slab:           ~142 MiB
> >    SUnreclaim:     ~117 MiB
> >
> >  After 32 high-credit connections:
> >    MemFree:        ~61.5 GiB
> >    MemAvailable:   ~62.3 GiB
> >    Slab:           ~178 MiB
> >    SUnreclaim:     ~152 MiB
> >
> >i.e. only ~35 MiB increase in Slab/SUnreclaim, no host OOM, and the
> >guest remains responsive.
>
> I think we should include here a summary of what you replied to Michael
> about other transports.
>
> I can't find your reply in the archive, but I mean the reply to
> https://lore.kernel.org/netdev/20251210084318-mutt-send-email-mst@kernel.org/
>
> >
> >Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> >Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
> >Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
> >---
> > net/vmw_vsock/virtio_transport_common.c | 27 ++++++++++++++++++++++---
> > 1 file changed, 24 insertions(+), 3 deletions(-)
> >
> >diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >index dcc8a1d58..02eeb96dd 100644
> >--- a/net/vmw_vsock/virtio_transport_common.c
> >+++ b/net/vmw_vsock/virtio_transport_common.c
> >@@ -491,6 +491,25 @@ void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
> > }
> > EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
> >
> >+/*
> >+ * Return the effective peer buffer size for TX credit computation.
>
> nit: block comment in this file doesn't leave empty line, so I'd follow
> it:
>
> @@ -491,8 +491,7 @@ void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
>   }
>   EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>
> -/*
> - * Return the effective peer buffer size for TX credit computation.
> +/* Return the effective peer buffer size for TX credit computation.
>    *
>    * The peer advertises its receive buffer via peer_buf_alloc, but we
>    * cap that to our local buf_alloc (derived from
>
> >+ *
> >+ * The peer advertises its receive buffer via peer_buf_alloc, but we
> >+ * cap that to our local buf_alloc (derived from
> >+ * SO_VM_SOCKETS_BUFFER_SIZE and already clamped to buffer_max_size)
> >+ * so that a remote endpoint cannot force us to queue more data than
> >+ * our own configuration allows.
> >+ */
> >+static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
> >+{
> >+      u32 peer  = vvs->peer_buf_alloc;
> >+      u32 local = vvs->buf_alloc;
> >+
> >+      if (peer > local)
> >+              return local;
> >+      return peer;
> >+}
> >+
>
> I think here Michael was suggesting this:
>
> @@ -502,12 +502,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>    */
>   static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
>   {
> -       u32 peer  = vvs->peer_buf_alloc;
> -       u32 local = vvs->buf_alloc;
> -
> -       if (peer > local)
> -               return local;
> -       return peer;
> +       return min(vvs->peer_buf_alloc, vvs->buf_alloc);
>   }
>
>
> > u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> > {
> >       u32 ret;
> >@@ -499,7 +518,8 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> >               return 0;
> >
> >       spin_lock_bh(&vvs->tx_lock);
> >-      ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
> >+      ret = virtio_transport_tx_buf_alloc(vvs) -
> >+            (vvs->tx_cnt - vvs->peer_fwd_cnt);
> >       if (ret > credit)
> >               ret = credit;
> >       vvs->tx_cnt += ret;
> >@@ -831,7 +851,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
> >
> >       spin_lock_bh(&vvs->tx_lock);
> >
> >-      if (len > vvs->peer_buf_alloc) {
> >+      if (len > virtio_transport_tx_buf_alloc(vvs)) {
> >               spin_unlock_bh(&vvs->tx_lock);
> >               return -EMSGSIZE;
> >       }
> >@@ -882,7 +902,8 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
> >       struct virtio_vsock_sock *vvs = vsk->trans;
> >       s64 bytes;
> >
> >-      bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
> >+      bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
> >+            (vvs->tx_cnt - vvs->peer_fwd_cnt);
>
> nit: please align this:
>
> @@ -903,7 +898,7 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
>          s64 bytes;
>
>          bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
> -             (vvs->tx_cnt - vvs->peer_fwd_cnt);
> +               (vvs->tx_cnt - vvs->peer_fwd_cnt);
>          if (bytes < 0)
>                  bytes = 0;
>
>
> Just minor things, but the patch LGTM, thanks!

I just noticed that vsock_test are now failing because one peer (client)
try to send more than TX buffer while the RX is waiting for the whole
data.

This should fix the test:

From b69ca1fd3d544345b02cedfbeb362493950a87c1 Mon Sep 17 00:00:00 2001
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 11 Dec 2025 10:55:06 +0100
Subject: [PATCH 1/1] vsock/test: fix seqpacket message bounds test

From: Stefano Garzarella <sgarzare@redhat.com>

The test requires the sender (client) to send all messages before waking
up the receiver (server).
Since virtio-vsock had a bug and did not respect the size of the TX
buffer, this test worked, but now that we have fixed the bug, it hangs
because the sender fills the TX buffer before waking up the receiver.

Set the buffer size in the sender (client) as well, as we already do for
the receiver (server).

Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/vsock_test.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 9e1250790f33..af6665ed19d5 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -351,6 +351,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 
 static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
 {
+	unsigned long long sock_buf_size;
 	unsigned long curr_hash;
 	size_t max_msg_size;
 	int page_size;
@@ -363,6 +364,16 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
+	sock_buf_size = SOCK_BUF_SIZE;
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
+			    sock_buf_size,
+			    "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
+			    sock_buf_size,
+			    "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
+
 	/* Wait, until receiver sets buffer size. */
 	control_expectln("SRVREADY");
 
-- 
2.52.0

Please add that patch to a series (e.g. v3) which includes your patch,
and that fix for the test.

Maybe we can also add a new test to check exactly the problem you're
fixing, to avoid regressions.

Thanks,
Stefano



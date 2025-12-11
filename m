Return-Path: <kvm+bounces-65764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B6822CB5F3A
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 13:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 078443003102
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 12:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0552F290E;
	Thu, 11 Dec 2025 12:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZGgfy0I";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eh60qQl9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804943126D5
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 12:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765457734; cv=none; b=gmBk6f3BNwvQzVNj+m7fwLdXQtgpeO/Gk0H7F+Df5Af2sbAA8hXj1TwkQxnuUp8YfVs0Os4WuSwe+w+Sll67TTiDkBchvqXxF31c47S/mYOuJXmKJkZuwRMsTulD/KhzS2wiGiT4exKDHDW6c0bDT9gdCK58swsHOzQjRVYi2dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765457734; c=relaxed/simple;
	bh=GBLapbLKXBRGhmi3VzSpdfUo6M+SRluFuLYf0fhNOzI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f75XT9UhkZ2r6HWEvgY4LrF0ASRxrHpFZzF7fLMpL2bTIjuwT4xaeFAy/X8fUy5ampR2RNRzoKPuSF4C6u/bY1eEOszwmcym23J32wMwtEIdWogwHQssWBZ5PkPbVPEG3xV9JJEr/zaZqiTb4HpxrucYKIBG2ZqnwMQRkP6xQVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aZGgfy0I; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eh60qQl9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765457731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/U3/mIIeh6oyj7R9BdLHvhs0yBtnDcHOXobfBr2NkWQ=;
	b=aZGgfy0IMaYM28ir8vSF+nXkgITffyBtlp4c7tEId5XgH34FhWUj1hso8m9kWT7zMVhPmW
	WZ/QSuNOQk9nfDUJrvQOxRQqyXktwXMAH6SD6sIC4aBQF8W3Sl+oGmBZLkl/fZvHSvhCjs
	JyzrOFTy47gCZCH72k72ADYR6vJYZkM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-iis1vxnqOfa6UaemT7TDhg-1; Thu, 11 Dec 2025 07:55:25 -0500
X-MC-Unique: iis1vxnqOfa6UaemT7TDhg-1
X-Mimecast-MFC-AGG-ID: iis1vxnqOfa6UaemT7TDhg_1765457724
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-297df52c960so822685ad.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 04:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765457724; x=1766062524; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/U3/mIIeh6oyj7R9BdLHvhs0yBtnDcHOXobfBr2NkWQ=;
        b=Eh60qQl9d8B6+sESkeOXajUzkrUYX75S9x8YRnfa2vpOCmzwUgeooL019+LndoaibR
         7IQ/Wg3fV9nXNKWaYzpbts6v1SeYotp/d+QQeDr+EEg6foT+JjICFvX95U+GDVe31w2g
         LSJl+XphWl+/wnxrLBh8W7hoZ8E/gEinO7ZVV33HkcN6M0IsvvtazMsmxzRkEGgqQ5Ys
         mxvLLxjxWIJW8kYhLucDvFReDrcfDClA9yY0vGRmpFF5XtvzSjd3oUpYT3K8eQbADk4a
         DlRXe8+7I4HrWfDi9C6WtAGpI5r/Zft3+9Yvbu+fuNfTLyAWH4lZZv+NkuRYw+tuoul7
         thWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765457724; x=1766062524;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/U3/mIIeh6oyj7R9BdLHvhs0yBtnDcHOXobfBr2NkWQ=;
        b=grvCRDzbSWT0pLE8ZrYjsW1+PAUUgf6I4EGae2ua3wmsrbuknN9F9/j1VSwQCSH03h
         CsOOaA0GdxJNzeSj3+vKCrBxWiRIgCQ1oc43THxdF5D+F+I9Vv5olEtw/0wl+mlaw77l
         pQYJGmAv+KW9KTSnEL/jerekNAf6qPa7yFHUpmAD+o015Rpzl9ht+o7FeeyXHJPRiZQC
         OkfYXGMmEaLhKVACIBxwSNixCPEcIBNuYPxq7WkaXYPDgin+EP0I1B+Z17PbzO2i1+vm
         5azyDdGRsR1cBIgZq8sf0ggzobJpj7JRO0gI3Fd2ElMwyypYxSe4h8HlKWcQ5uQI4ZO6
         yS7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXUyO4BcO+c7zx4E+KaDn9Xl1KszuZ1SfmHAK0OY1KCVxW4+MbtEI5fh59r0FDQpIVePjM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7FTRh5IwkRB2hXPv/emY8Gp27CyABhd4wJdhNRkBS+6+7/VEr
	NKjrH1tdx0uC3hdFW/3o4ZlMaKZbc2UKjUa0OxOI/UlplhWI0Wp55DW2BAxU6N4JdkmWSnldJXu
	HOD/PtZAf1btbVQ/lsDDWdFJRpKHg9oinfmj5ERfV0H1hCIE7OLJp0Av9Jyz700CV+ZCWHolui8
	zjG+TA2sQktCh4MYI/IR90gEIdAiA5
X-Gm-Gg: AY/fxX6pmKlB+eGlukm4GeZUWkfWZ3QciGiItjBe6Dzt8loaim/Dv+oF7KodMPAcHuy
	rI/lX32YfAe+lQf8XWrxVmsYqUadijaqHVLkXCetGVPF4+YE1C7s1V7j7TlGMrgfdY6yfi7BDGB
	X0sGIP/+elvIFFVcj2oQ2alzcScqUuvcELkZHkhr+97qbZlK5URgc239G6iz+q4U09
X-Received: by 2002:a17:902:e884:b0:295:6122:5c42 with SMTP id d9443c01a7336-29ec231b394mr60323495ad.24.1765457724358;
        Thu, 11 Dec 2025 04:55:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEKrUwXdtxOoTMBu1hJiIk5hrSkflSXqA/00cWHE0pi1/DVYyeztZ61eYy+lFh4s6sAmcADzgtP6/HmaQ0F6IA=
X-Received: by 2002:a17:902:e884:b0:295:6122:5c42 with SMTP id
 d9443c01a7336-29ec231b394mr60323315ad.24.1765457723923; Thu, 11 Dec 2025
 04:55:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210150019.48458-1-mlbnkm1@gmail.com> <ctubihgjn65za4hbmanhkzg7psr6kmj3jeqfj5sfxnnxjjvrsy@l6644u74vrn6>
 <CAGxU2F6TMP7tOo=DONL9CJUW921NXyx9T65y_Ai5pbzh1LAQaA@mail.gmail.com>
In-Reply-To: <CAGxU2F6TMP7tOo=DONL9CJUW921NXyx9T65y_Ai5pbzh1LAQaA@mail.gmail.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 11 Dec 2025 13:55:12 +0100
X-Gm-Features: AQt7F2oc1BVBAdK92iMl4jOy7fPeE1y7G4q5UMwstrOZRfr8mNpcaD9xZswoaek
Message-ID: <CAGxU2F6RkU-6id5Z9wBFKPfmws9CJ00mnBQgCYZasLshLnYn=w@mail.gmail.com>
Subject: Re: [PATCH] vsock/virtio: cap TX credit to local buffer size
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Dec 2025 at 11:08, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Thu, 11 Dec 2025 at 10:10, Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > On Wed, Dec 10, 2025 at 04:00:19PM +0100, Melbin K Mathew wrote:
> > >The virtio vsock transport currently derives its TX credit directly
> > >from peer_buf_alloc, which is set from the remote endpoint's
> > >SO_VM_SOCKETS_BUFFER_SIZE value.
> >
> > Why removing the target tree [net] from the tags?
> >
> > Also this is a v2, so the tags should have been [PATCH net v2], please
> > check it in next versions, more info:
> >
> > https://www.kernel.org/doc/html/latest/process/submitting-patches.html#subject-line
> >
> > >
> > >On the host side this means that the amount of data we are willing to
> > >queue for a connection is scaled by a guest-chosen buffer size,
> > >rather than the host's own vsock configuration. A malicious guest can
> > >advertise a large buffer and read slowly, causing the host to allocate
> > >a correspondingly large amount of sk_buff memory.
> > >
> > >Introduce a small helper, virtio_transport_peer_buf_alloc(), that
> > >returns min(peer_buf_alloc, buf_alloc), and use it wherever we consume
> > >peer_buf_alloc:
> > >
> > >  - virtio_transport_get_credit()
> > >  - virtio_transport_has_space()
> > >  - virtio_transport_seqpacket_enqueue()
> > >
> > >This ensures the effective TX window is bounded by both the peer's
> > >advertised buffer and our own buf_alloc (already clamped to
> > >buffer_max_size via SO_VM_SOCKETS_BUFFER_MAX_SIZE), so a remote guest
> > >cannot force the host to queue more data than allowed by the host's
> > >own vsock settings.
> > >
> > >On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
> > >32 guest vsock connections advertising 2 GiB each and reading slowly
> > >drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB and the system only
> > >recovered after killing the QEMU process.
> > >
> > >With this patch applied, rerunning the same PoC yields:
> > >
> > >  Before:
> > >    MemFree:        ~61.6 GiB
> > >    MemAvailable:   ~62.3 GiB
> > >    Slab:           ~142 MiB
> > >    SUnreclaim:     ~117 MiB
> > >
> > >  After 32 high-credit connections:
> > >    MemFree:        ~61.5 GiB
> > >    MemAvailable:   ~62.3 GiB
> > >    Slab:           ~178 MiB
> > >    SUnreclaim:     ~152 MiB
> > >
> > >i.e. only ~35 MiB increase in Slab/SUnreclaim, no host OOM, and the
> > >guest remains responsive.
> >
> > I think we should include here a summary of what you replied to Michael
> > about other transports.
> >
> > I can't find your reply in the archive, but I mean the reply to
> > https://lore.kernel.org/netdev/20251210084318-mutt-send-email-mst@kernel.org/
> >
> > >
> > >Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> > >Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
> > >Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
> > >---
> > > net/vmw_vsock/virtio_transport_common.c | 27 ++++++++++++++++++++++---
> > > 1 file changed, 24 insertions(+), 3 deletions(-)
> > >
> > >diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > >index dcc8a1d58..02eeb96dd 100644
> > >--- a/net/vmw_vsock/virtio_transport_common.c
> > >+++ b/net/vmw_vsock/virtio_transport_common.c
> > >@@ -491,6 +491,25 @@ void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
> > > }
> > > EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
> > >
> > >+/*
> > >+ * Return the effective peer buffer size for TX credit computation.
> >
> > nit: block comment in this file doesn't leave empty line, so I'd follow
> > it:
> >
> > @@ -491,8 +491,7 @@ void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
> >   }
> >   EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
> >
> > -/*
> > - * Return the effective peer buffer size for TX credit computation.
> > +/* Return the effective peer buffer size for TX credit computation.
> >    *
> >    * The peer advertises its receive buffer via peer_buf_alloc, but we
> >    * cap that to our local buf_alloc (derived from
> >
> > >+ *
> > >+ * The peer advertises its receive buffer via peer_buf_alloc, but we
> > >+ * cap that to our local buf_alloc (derived from
> > >+ * SO_VM_SOCKETS_BUFFER_SIZE and already clamped to buffer_max_size)
> > >+ * so that a remote endpoint cannot force us to queue more data than
> > >+ * our own configuration allows.
> > >+ */
> > >+static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
> > >+{
> > >+      u32 peer  = vvs->peer_buf_alloc;
> > >+      u32 local = vvs->buf_alloc;
> > >+
> > >+      if (peer > local)
> > >+              return local;
> > >+      return peer;
> > >+}
> > >+
> >
> > I think here Michael was suggesting this:
> >
> > @@ -502,12 +502,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
> >    */
> >   static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
> >   {
> > -       u32 peer  = vvs->peer_buf_alloc;
> > -       u32 local = vvs->buf_alloc;
> > -
> > -       if (peer > local)
> > -               return local;
> > -       return peer;
> > +       return min(vvs->peer_buf_alloc, vvs->buf_alloc);
> >   }
> >
> >
> > > u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> > > {
> > >       u32 ret;
> > >@@ -499,7 +518,8 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> > >               return 0;
> > >
> > >       spin_lock_bh(&vvs->tx_lock);
> > >-      ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
> > >+      ret = virtio_transport_tx_buf_alloc(vvs) -
> > >+            (vvs->tx_cnt - vvs->peer_fwd_cnt);
> > >       if (ret > credit)
> > >               ret = credit;
> > >       vvs->tx_cnt += ret;
> > >@@ -831,7 +851,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
> > >
> > >       spin_lock_bh(&vvs->tx_lock);
> > >
> > >-      if (len > vvs->peer_buf_alloc) {
> > >+      if (len > virtio_transport_tx_buf_alloc(vvs)) {
> > >               spin_unlock_bh(&vvs->tx_lock);
> > >               return -EMSGSIZE;
> > >       }
> > >@@ -882,7 +902,8 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
> > >       struct virtio_vsock_sock *vvs = vsk->trans;
> > >       s64 bytes;
> > >
> > >-      bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
> > >+      bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
> > >+            (vvs->tx_cnt - vvs->peer_fwd_cnt);
> >
> > nit: please align this:
> >
> > @@ -903,7 +898,7 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
> >          s64 bytes;
> >
> >          bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
> > -             (vvs->tx_cnt - vvs->peer_fwd_cnt);
> > +               (vvs->tx_cnt - vvs->peer_fwd_cnt);
> >          if (bytes < 0)
> >                  bytes = 0;
> >
> >
> > Just minor things, but the patch LGTM, thanks!
>
> I just noticed that vsock_test are now failing because one peer (client)
> try to send more than TX buffer while the RX is waiting for the whole
> data.
>
> This should fix the test:
>
> From b69ca1fd3d544345b02cedfbeb362493950a87c1 Mon Sep 17 00:00:00 2001
> From: Stefano Garzarella <sgarzare@redhat.com>
> Date: Thu, 11 Dec 2025 10:55:06 +0100
> Subject: [PATCH 1/1] vsock/test: fix seqpacket message bounds test
>
> From: Stefano Garzarella <sgarzare@redhat.com>
>
> The test requires the sender (client) to send all messages before waking
> up the receiver (server).
> Since virtio-vsock had a bug and did not respect the size of the TX
> buffer, this test worked, but now that we have fixed the bug, it hangs
> because the sender fills the TX buffer before waking up the receiver.
>
> Set the buffer size in the sender (client) as well, as we already do for
> the receiver (server).
>
> Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  tools/testing/vsock/vsock_test.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> index 9e1250790f33..af6665ed19d5 100644
> --- a/tools/testing/vsock/vsock_test.c
> +++ b/tools/testing/vsock/vsock_test.c
> @@ -351,6 +351,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
>
>  static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>  {
> +       unsigned long long sock_buf_size;
>         unsigned long curr_hash;
>         size_t max_msg_size;
>         int page_size;
> @@ -363,6 +364,16 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>                 exit(EXIT_FAILURE);
>         }
>
> +       sock_buf_size = SOCK_BUF_SIZE;
> +
> +       setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
> +                           sock_buf_size,
> +                           "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
> +
> +       setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
> +                           sock_buf_size,
> +                           "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
> +
>         /* Wait, until receiver sets buffer size. */
>         control_expectln("SRVREADY");
>
> --
> 2.52.0
>
> Please add that patch to a series (e.g. v3) which includes your patch,
> and that fix for the test.

I saw you sent v3 without this, never mind, I'll post it directly.

Stefano

>
> Maybe we can also add a new test to check exactly the problem you're
> fixing, to avoid regressions.
>
> Thanks,
> Stefano



Return-Path: <kvm+bounces-65745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2A0CB5529
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:13:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E61F3016706
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 09:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265E32D8799;
	Thu, 11 Dec 2025 09:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LQYJhjHu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AwjIrvlS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26402D97AC
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 09:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765444260; cv=none; b=sSq3vvVeGuQvUEbNVk2mLdfi3USCkaBXy5wWaVwwMFBW0BeRhKtqcv6LOuG/kL9/QA6YZY5gKUiyhlQ6ZhyeHtwy9gRot3Is2vbdmls78PUMVO0xBdxiL2d7AHBajfnDm+OSml6hUY9m2jCu2LIPKfEmvHsGmI+xRv6FoGChPAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765444260; c=relaxed/simple;
	bh=2bjsuHgqR2pBqJTjwbviCLdqZiOgEWxTUpAVbpAw2Zg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpj0LqACfxc8b3uEHb/8Gv1zmCAAvtk8QkFT8e0qZx286JBuz9dK/d2R9E8y5SF9cUQ8FVXJp2rH6EwWgSoZaOs0ix7cWvyRssc4fnsjMwT/qw3MPBQaLa/ic6v8n2+6BHO5ZwM4fgFtIzMVtCprxkjesfqf9F3L/zmqk0W/a9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LQYJhjHu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AwjIrvlS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765444257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=69iEnCdCnSl1sInX4QnhnjanZznNSbsv0LHo8vEaadA=;
	b=LQYJhjHuxKIua+Q6QzVHPJMLEjLY0zW1F9c5SuTy3yyBpNZJQhikQ3eYbL32c1ig2WXZDt
	NE2a5MFWvKxQE4iMGY34lwhsje/+4gzmHgF5ZTZCWSvQBjDuvbodU1ktC46zajw6LeEjhR
	ox2tBKSM5Rz/9Lmm5ZzXjjoWD1Lzr+8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-1c3WJmKgPj-cbGWkM0bPug-1; Thu, 11 Dec 2025 04:10:55 -0500
X-MC-Unique: 1c3WJmKgPj-cbGWkM0bPug-1
X-Mimecast-MFC-AGG-ID: 1c3WJmKgPj-cbGWkM0bPug_1765444254
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-64537824851so642285a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 01:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765444254; x=1766049054; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=69iEnCdCnSl1sInX4QnhnjanZznNSbsv0LHo8vEaadA=;
        b=AwjIrvlSGIfOsHi0FNVysIQaUpecNf2erisMl7Uz0KtOTvzHGkORYpDAxKH7KMm+o0
         hB9Sh7Ohb0B0dHFdUMzzfl3pWRqMYHF5KtwBzKai3CnMCO31U/yiYgkUnid4cC0xr/Ki
         j2B4NEcOApBFYJqvQqCcYJaJqiAb3AvfpfWhorxHpVTJouPpiGn/0jREVMx7Eyg7OLAw
         5pntfLKpZ/ziMfLL9VNRfwjk/PrQA3bnfIT5heWRKJnNRDUiC3Zkys7l7/bYZdRSG9ZJ
         +BYM2gNLlWahFvvmiRBynU9VyX9eGdsM7/MxvKgMfrNijkUcTS8ftlxpgh6xpwbHIaaw
         4vcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765444254; x=1766049054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69iEnCdCnSl1sInX4QnhnjanZznNSbsv0LHo8vEaadA=;
        b=c5jYQg77Nwwkk6Y/auzCmgenAE0FLtqkm+sbyccbe8DjKif28a05dXBVZmiHg6UXDm
         7czBJFTvo2aXEhEf871I+FesZlmNDsHN488tlMIUFn/YUjCIPtJtNGXF56KHDzH7pV/1
         /R94rW74T8lEwLJNRBIuaIqchShmtPEkm7Y4UCgp4voZBv0/kw0NxpB4LP6Y/SF7gbFj
         q6lp5ANqmtLmtPAB97gRpLO4ZmGhR0tWCpPPO1yadAuLUkS5bALbJe2l3RsHW/U8y4PM
         X+7PMQ2g4wsXNuWBUSzbgNTY25LkzTdosmHo5+VHk9Yq9jx2aHYe2D6mg0kB7j0JkDhj
         x33Q==
X-Forwarded-Encrypted: i=1; AJvYcCXE0j/quNOI/qXAtadvN/pkb+GIE8AnbQ/uW+mJnfqgCo9icV99xN8WkflvcHd1Zlgq3wM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUTk7WcwqlOPCMJMit7wHjc6m9jfWl4MZahawF+RapnYOl7tEo
	emOMVNtlfRMJJVOKSZVateqEcEtIrVwt1UVcTbY3twTYDDAREoac9YIk2CCoRP3IOE2LdxfCA68
	l7p8oyZuvvuLNxtqtmr6W/DSZUVuk3wVDcektdeBQv3Y8LV7NSZzhYQ==
X-Gm-Gg: ASbGncu9yvh5NdBTcfHm8SqBSrE8vMpHnUHvw3GOukG/twPH1WzvmMovpCbqXy6Dv0e
	bZiraBtGF5Gu30vLHh489eaWznlLDUYwRn3V+AQAA/wLshFHYxT6jXyOrSjHL/AtlStkznrOzCY
	tGlwk6wyL3wyQwPqG8xxLNPvmeZtKiZZknlerCVUJxIuJSDKRN9c595kLm1cvNWMWTiO8altsKz
	pVpSIAcDPvTptlPCguZ+Av+wpseUzww0gRcNe96Gi/ZTRQQO1yR6mw5yxBEIy94USVRmCOiinzK
	zIqOtXihxqO9f7CMT1iDoHrIJKFmyxuaCLOF2fM9EbWQBfVdLVjxrXgsUCirmXq11PcKkEpQWaX
	9c8TuMbHF8Ch8kBS/IlNbDt4lcrbFwRftDRfzkGzTM/Rob0J0vHrAM6+UwEC9Nw==
X-Received: by 2002:a17:906:d551:b0:b73:301c:b158 with SMTP id a640c23a62f3a-b7ce823a81dmr540584966b.6.1765444253882;
        Thu, 11 Dec 2025 01:10:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEew10O4bon7Xzeax0PYRU5JDJoxS0/dSqVq0TxsHXl0IJlpZHr0G2pLqtxoNtfkJvXUfn7Sg==
X-Received: by 2002:a17:906:d551:b0:b73:301c:b158 with SMTP id a640c23a62f3a-b7ce823a81dmr540582966b.6.1765444253322;
        Thu, 11 Dec 2025 01:10:53 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa56c152sm203140766b.56.2025.12.11.01.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 01:10:52 -0800 (PST)
Date: Thu, 11 Dec 2025 10:10:38 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org
Subject: Re: [PATCH] vsock/virtio: cap TX credit to local buffer size
Message-ID: <ctubihgjn65za4hbmanhkzg7psr6kmj3jeqfj5sfxnnxjjvrsy@l6644u74vrn6>
References: <20251210150019.48458-1-mlbnkm1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251210150019.48458-1-mlbnkm1@gmail.com>

On Wed, Dec 10, 2025 at 04:00:19PM +0100, Melbin K Mathew wrote:
>The virtio vsock transport currently derives its TX credit directly
>from peer_buf_alloc, which is set from the remote endpoint's
>SO_VM_SOCKETS_BUFFER_SIZE value.

Why removing the target tree [net] from the tags?

Also this is a v2, so the tags should have been [PATCH net v2], please 
check it in next versions, more info:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#subject-line

>
>On the host side this means that the amount of data we are willing to
>queue for a connection is scaled by a guest-chosen buffer size,
>rather than the host's own vsock configuration. A malicious guest can
>advertise a large buffer and read slowly, causing the host to allocate
>a correspondingly large amount of sk_buff memory.
>
>Introduce a small helper, virtio_transport_peer_buf_alloc(), that
>returns min(peer_buf_alloc, buf_alloc), and use it wherever we consume
>peer_buf_alloc:
>
>  - virtio_transport_get_credit()
>  - virtio_transport_has_space()
>  - virtio_transport_seqpacket_enqueue()
>
>This ensures the effective TX window is bounded by both the peer's
>advertised buffer and our own buf_alloc (already clamped to
>buffer_max_size via SO_VM_SOCKETS_BUFFER_MAX_SIZE), so a remote guest
>cannot force the host to queue more data than allowed by the host's
>own vsock settings.
>
>On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
>32 guest vsock connections advertising 2 GiB each and reading slowly
>drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB and the system only
>recovered after killing the QEMU process.
>
>With this patch applied, rerunning the same PoC yields:
>
>  Before:
>    MemFree:        ~61.6 GiB
>    MemAvailable:   ~62.3 GiB
>    Slab:           ~142 MiB
>    SUnreclaim:     ~117 MiB
>
>  After 32 high-credit connections:
>    MemFree:        ~61.5 GiB
>    MemAvailable:   ~62.3 GiB
>    Slab:           ~178 MiB
>    SUnreclaim:     ~152 MiB
>
>i.e. only ~35 MiB increase in Slab/SUnreclaim, no host OOM, and the
>guest remains responsive.

I think we should include here a summary of what you replied to Michael 
about other transports.

I can't find your reply in the archive, but I mean the reply to
https://lore.kernel.org/netdev/20251210084318-mutt-send-email-mst@kernel.org/

>
>Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 27 ++++++++++++++++++++++---
> 1 file changed, 24 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index dcc8a1d58..02eeb96dd 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -491,6 +491,25 @@ void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>
>+/*
>+ * Return the effective peer buffer size for TX credit computation.

nit: block comment in this file doesn't leave empty line, so I'd follow
it:

@@ -491,8 +491,7 @@ void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
  }
  EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);

-/*
- * Return the effective peer buffer size for TX credit computation.
+/* Return the effective peer buffer size for TX credit computation.
   *
   * The peer advertises its receive buffer via peer_buf_alloc, but we
   * cap that to our local buf_alloc (derived from

>+ *
>+ * The peer advertises its receive buffer via peer_buf_alloc, but we
>+ * cap that to our local buf_alloc (derived from
>+ * SO_VM_SOCKETS_BUFFER_SIZE and already clamped to buffer_max_size)
>+ * so that a remote endpoint cannot force us to queue more data than
>+ * our own configuration allows.
>+ */
>+static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
>+{
>+	u32 peer  = vvs->peer_buf_alloc;
>+	u32 local = vvs->buf_alloc;
>+
>+	if (peer > local)
>+		return local;
>+	return peer;
>+}
>+

I think here Michael was suggesting this:

@@ -502,12 +502,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
   */
  static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
  {
-       u32 peer  = vvs->peer_buf_alloc;
-       u32 local = vvs->buf_alloc;
-
-       if (peer > local)
-               return local;
-       return peer;
+       return min(vvs->peer_buf_alloc, vvs->buf_alloc);
  }


> u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> {
> 	u32 ret;
>@@ -499,7 +518,8 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> 		return 0;
>
> 	spin_lock_bh(&vvs->tx_lock);
>-	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>+	ret = virtio_transport_tx_buf_alloc(vvs) -
>+	      (vvs->tx_cnt - vvs->peer_fwd_cnt);
> 	if (ret > credit)
> 		ret = credit;
> 	vvs->tx_cnt += ret;
>@@ -831,7 +851,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>
> 	spin_lock_bh(&vvs->tx_lock);
>
>-	if (len > vvs->peer_buf_alloc) {
>+	if (len > virtio_transport_tx_buf_alloc(vvs)) {
> 		spin_unlock_bh(&vvs->tx_lock);
> 		return -EMSGSIZE;
> 	}
>@@ -882,7 +902,8 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
> 	struct virtio_vsock_sock *vvs = vsk->trans;
> 	s64 bytes;
>
>-	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>+	bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
>+	      (vvs->tx_cnt - vvs->peer_fwd_cnt);

nit: please align this:

@@ -903,7 +898,7 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
         s64 bytes;

         bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
-             (vvs->tx_cnt - vvs->peer_fwd_cnt);
+               (vvs->tx_cnt - vvs->peer_fwd_cnt);
         if (bytes < 0)
                 bytes = 0;


Just minor things, but the patch LGTM, thanks!
Stefano

> 	if (bytes < 0)
> 		bytes = 0;
>
>-- 
>2.34.1
>



Return-Path: <kvm+bounces-65825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E819ECB8CD5
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 13:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C988A30B917E
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 12:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1B231814F;
	Fri, 12 Dec 2025 12:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HTBz9cs1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lEGzlNF5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E0C30FF1D
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 12:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765542427; cv=none; b=Xb44/4wmZa9PpDnF/7KX28BSydAJ7n4bQ2rfXxapdAKfT/RPafTjefjoY+JDftso71sFxh5alMViWGrrVAtfn75s8dDWMHlYWEuKy2sBWtxJ+uE/+SqGFFSwhEVVItFW1UhtFWvwGSSFY6Ss4FgT6cRXqq4TVWhjt054/JXLIJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765542427; c=relaxed/simple;
	bh=arpZlHgTP/Q2XHdUgjjUMg9eCk7R5xCuBgD64udECtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IjCDLBmTYRMLd8VLIL2tIFeiOEYMhWhHXjZtnCLWo1kWvPqqZBmMJov+E/yEHt8QctSw52G3hh6xzbyqMHZ9pthZnNwqFRCrrqm/AANsixn7qSFA/dZEBjfR44jyNcYYm2TceUChpBAW7te6uLjbVbuQyyp1NHzH6SPXP4n/9Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HTBz9cs1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lEGzlNF5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765542424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L/arTEPx+inQ9VeH2LUAllPPM58s2xpZHbogC2hjw54=;
	b=HTBz9cs1qTuhx+d4AiohJI3TB/i8ihZYVd9Lpz3iGmDXzoJy5e4eJH+F6d8q6x7NR+8VD8
	4nGbSpN8S0Y0NbFK5WiK/TeFC6EdC0K56m1YbymRFLiahgarOVZEXTYJye7p0sZVIwgDZt
	+yZRFj47tQcVwBFFctEhcpbGzZ2Uql0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-fy2Ri8qCM2yPxqolb215Ow-1; Fri, 12 Dec 2025 07:27:02 -0500
X-MC-Unique: fy2Ri8qCM2yPxqolb215Ow-1
X-Mimecast-MFC-AGG-ID: fy2Ri8qCM2yPxqolb215Ow_1765542421
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b79f6dcde96so338462766b.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 04:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765542421; x=1766147221; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L/arTEPx+inQ9VeH2LUAllPPM58s2xpZHbogC2hjw54=;
        b=lEGzlNF5cayoMdKbULUEBdVlSfh9P/IGjoOhuJq/slfWpsCyZBbLfsvFFssmGFpzas
         YUGAtM6xikqYbPaGImxgUcfJqp2GYIxKo9h0GN+/+c8U9dpQSYXV4oRKUFnZ6mTAs/GQ
         sqMYM5aViyzqJfxWQG5ywetrpedgxoVkoUYhx820uvfDyZ2cCmRdTk/ZoO4+gDFPB1hS
         m3NzjLpU3Qd3cDFgirXTJYIMZ9M4IZPlsEBDIrLOlvfNDsrNWj7cNWrL/KcqHAXmo8LV
         SEfHWscvSj965wIEavYSQFFPRZF6SOeYgm3GtAV1B+RTMm9tQT6jGQSzIKUVtYxOlOS0
         5sTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765542421; x=1766147221;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L/arTEPx+inQ9VeH2LUAllPPM58s2xpZHbogC2hjw54=;
        b=tA3q1KXEvks2bRWs9R5v15lpDhP7tKU1stczVRsT4ELdiQobAb+6UrFcTKgW8hSFuk
         OhOimTxTP1uZEs/rCRZpRzx+c6H1Gle7UbVgoMiSB1w0TwjPxXNe/WjjxL6N3H+X2bKX
         WnhZwehI46/oi2Y7zj5xlypb9M7sl3QINv1jE+VnaD2e2N0GP0tXy1Fcn/JQGipn7ANu
         B2HRaA+r9rXb+/2J/uPIPZVdrAfmu0Wg2b14AoSHoHDz9qCU3a2IQDaYdI5ivoAcvEBY
         mEV+AkRsNGTc6Q5ZfUdg74mZ17sJjNtXrVBegusPng7T0jXp3nTtBEXhge6/f9YhrBiH
         2mUA==
X-Forwarded-Encrypted: i=1; AJvYcCWMfxiqvYo2GK7GGaBXtTH1l4NlozUMPfCQyCGeCV1QbSmNqhsFp0XMqZCMPbEAhPANimc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMd/0c5lvgJQWZeSA1UFAcIVoNWbKk6yiVFYQyJC5v2B11RV3y
	OCt2Wn/axXeshrmHJqwOlsk+2sY9um5rKtBs7bGBK8GwjCcfqCbkNhyGyWKfBJWcIuoNDL0imMw
	eNs1EfjMtim1GcqvxIdMOUnrA0D76gEU3oUBz4MtZ1mppZh199ZirXQ==
X-Gm-Gg: AY/fxX5jDmIbwTO1bItFpkv5vICxAr28MInNysUnQxg4J8vXko4d5Z9mXFG+Jt0tDwO
	6/kW0dcymLBX7dD1ZAXP3VZPnwAhU9L6hPQdMs4UmLgJ1tUPnxoBaWZd0unlaQUvfUWrkIeRtbZ
	CcSMF/IU1lqeOqPiyp4SttNFOyiTSNU3QV09oppzcvZBioKzRpcdYxGpcMGe8ZcFWcJVwhC4CbX
	gKr8Q+y9Sh3qXogt7UiE3cdQTgSw0YDtr71titHSigwBykn4BM2Agqa8tNI29R6RO2fapws0y3Y
	u7TzacXZw8ZQsfstQaROWlHw3NZ63YDCsyBxGxLxww7pL+dfxIyUegMcUqHX2Ljn/VEhn4eMpJA
	r4Ur/s2RfXpDyXoYcx03tEEcv2S61vzzcN5vKHpenlsv2tK6bCz7nWZczpxNccQ==
X-Received: by 2002:a17:907:7f23:b0:b73:3e15:a370 with SMTP id a640c23a62f3a-b7d23d0519emr166950666b.57.1765542421339;
        Fri, 12 Dec 2025 04:27:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHJ8k95XyEgRKLOlMYKPgD8ZmrsPj3lizzCfh8rKYc1FUcJTIMFHxjLZLBoQTYJNZQdaPwGmw==
X-Received: by 2002:a17:907:7f23:b0:b73:3e15:a370 with SMTP id a640c23a62f3a-b7d23d0519emr166946666b.57.1765542420793;
        Fri, 12 Dec 2025 04:27:00 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cf9f38778sm570646266b.0.2025.12.12.04.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 04:27:00 -0800 (PST)
Date: Fri, 12 Dec 2025 13:26:44 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, stefanha@redhat.com, 
	kvm@vger.kernel.org, netdev@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	eperezma@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org
Subject: Re: [PATCH net v3] vsock/virtio: cap TX credit to local buffer size
Message-ID: <tandvvk6vas3kgqjuo6w3aagqai246qxejfnzhkbvbxds3w4y6@umqvf7f3m5ie>
References: <20251211125104.375020-1-mlbnkm1@gmail.com>
 <20251211080251-mutt-send-email-mst@kernel.org>
 <zlhixzduyindq24osaedkt2xnukmatwhugfkqmaugvor6wlcol@56jsodxn4rhi>
 <CAMKc4jDpMsk1TtSN-GPLM1M_qp_jpoE1XL1g5qXRUiB-M0BPgQ@mail.gmail.com>
 <CAGxU2F7WOLs7bDJao-7Qd=GOqj_tOmS+EptviMphGqSrgsadqg@mail.gmail.com>
 <CAMKc4jDLdcGsL5_d+4CP6n-57s-R0vzrX2M7Ni=1GeCB1cxVYA@mail.gmail.com>
 <bwmol6raorw233ryb3dleh4meaui5vbe7no53boixckl3wgclz@s6grefw5dqen>
 <deccf66c-dcd3-4187-9fb6-43ddf7d0a905@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <deccf66c-dcd3-4187-9fb6-43ddf7d0a905@gmail.com>

On Fri, Dec 12, 2025 at 11:40:03AM +0000, Melbin K Mathew wrote:
>
>
>On 12/12/2025 10:40, Stefano Garzarella wrote:
>>On Fri, Dec 12, 2025 at 09:56:28AM +0000, Melbin Mathew Antony wrote:
>>>Hi Stefano, Michael,
>>>
>>>Thanks for the suggestions and guidance.
>>
>>You're welcome, but please avoid top-posting in the future:
>>https://www.kernel.org/doc/html/latest/process/submitting- 
>>patches.html#use-trimmed-interleaved-replies-in-email-discussions
>>
>Sure. Thanks
>>>
>>>I’ve drafted a 4-part series based on the recap. I’ve included the
>>>four diffs below for discussion. Can wait for comments, iterate, and
>>>then send the patch series in a few days.
>>>
>>>---
>>>
>>>Patch 1/4 — vsock/virtio: make get_credit() s64-safe and clamp negatives
>>>
>>>virtio_transport_get_credit() was doing unsigned arithmetic; if the
>>>peer shrinks its window, the subtraction can underflow and look like
>>>“lots of credit”. This makes it compute “space” in s64 and clamp < 0
>>>to 0.
>>>
>>>diff --git a/net/vmw_vsock/virtio_transport_common.c
>>>b/net/vmw_vsock/virtio_transport_common.c
>>>--- a/net/vmw_vsock/virtio_transport_common.c
>>>+++ b/net/vmw_vsock/virtio_transport_common.c
>>>@@ -494,16 +494,23 @@ 
>>>EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>>>u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 
>>>credit)
>>>{
>>>+ s64 bytes;
>>> u32 ret;
>>>
>>> if (!credit)
>>> return 0;
>>>
>>> spin_lock_bh(&vvs->tx_lock);
>>>- ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>>>- if (ret > credit)
>>>- ret = credit;
>>>+ bytes = (s64)vvs->peer_buf_alloc -
>>
>>Why not just calling virtio_transport_has_space()?
>virtio_transport_has_space() takes struct vsock_sock *, while 
>virtio_transport_get_credit() takes struct virtio_vsock_sock *, so I 
>cannot directly call has_space() from get_credit() without changing 
>signatures.
>
>Would you be OK if I factor the common “space” calculation into a 
>small helper that operates on struct virtio_vsock_sock * and is used 
>by both paths? Something like:

Why not just change the signature of virtio_transport_has_space()?

Thanks,
Stefano

>
>/* Must be called with vvs->tx_lock held. Returns >= 0. */
>static s64 virtio_transport_tx_space(struct virtio_vsock_sock *vvs)
>{
>	s64 bytes;
>
>	bytes = (s64)vvs->peer_buf_alloc -
>		((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>	if (bytes < 0)
>		bytes = 0;
>
>	return bytes;
>}
>
>Then:
>
>get_credit() would do bytes = virtio_transport_tx_space(vvs); ret = 
>min_t(u32, credit, (u32)bytes);
>
>has_space() would use the same helper after obtaining vvs = vsk->trans;
>
>Does that match what you had in mind, or would you prefer a different 
>factoring?
>
>>
>>>+ ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>>>+ if (bytes < 0)
>>>+ bytes = 0;
>>>+
>>>+ ret = min_t(u32, credit, (u32)bytes);
>>> vvs->tx_cnt += ret;
>>> vvs->bytes_unsent += ret;
>>> spin_unlock_bh(&vvs->tx_lock);
>>>
>>> return ret;
>>>}
>>>
>>>
>>>---
>>>
>>>Patch 2/4 — vsock/virtio: cap TX window by local buffer (helper + use
>>>everywhere in TX path)
>>>
>>>Cap the effective advertised window to min(peer_buf_alloc, buf_alloc)
>>>and use it consistently in TX paths (get_credit, has_space,
>>>seqpacket_enqueue).
>>>
>>>diff --git a/net/vmw_vsock/virtio_transport_common.c
>>>b/net/vmw_vsock/virtio_transport_common.c
>>>--- a/net/vmw_vsock/virtio_transport_common.c
>>>+++ b/net/vmw_vsock/virtio_transport_common.c
>>>@@ -491,6 +491,16 @@ void virtio_transport_consume_skb_sent(struct
>>>sk_buff *skb, bool consume)
>>>}
>>>EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>>>+/* Return the effective peer buffer size for TX credit computation.
>>>+ *
>>>+ * The peer advertises its receive buffer via peer_buf_alloc, but 
>>>we cap it
>>>+ * to our local buf_alloc (derived from SO_VM_SOCKETS_BUFFER_SIZE and
>>>+ * already clamped to buffer_max_size).
>>>+ */
>>>+static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
>>>+{
>>>+ return min(vvs->peer_buf_alloc, vvs->buf_alloc);
>>>+}
>>>
>>>u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 
>>>credit)
>>>{
>>> s64 bytes;
>>>@@ -502,7 +512,8 @@ u32 virtio_transport_get_credit(struct
>>>virtio_vsock_sock *vvs, u32 credit)
>>> return 0;
>>>
>>> spin_lock_bh(&vvs->tx_lock);
>>>- bytes = (s64)vvs->peer_buf_alloc -
>>>+ bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
>>> ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>>> if (bytes < 0)
>>> bytes = 0;
>>>@@ -834,7 +845,7 @@ virtio_transport_seqpacket_enqueue(struct 
>>>vsock_sock *vsk,
>>> spin_lock_bh(&vvs->tx_lock);
>>>
>>>- if (len > vvs->peer_buf_alloc) {
>>>+ if (len > virtio_transport_tx_buf_alloc(vvs)) {
>>> spin_unlock_bh(&vvs->tx_lock);
>>> return -EMSGSIZE;
>>> }
>>>@@ -884,7 +895,8 @@ static s64 virtio_transport_has_space(struct
>>>vsock_sock *vsk)
>>> struct virtio_vsock_sock *vvs = vsk->trans;
>>> s64 bytes;
>>>
>>>- bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>>>+ bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
>>>+ ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>>> if (bytes < 0)
>>> bytes = 0;
>>>
>>> return bytes;
>>>}
>>>
>>>
>>>---
>>>
>>>Patch 3/4 — vsock/test: fix seqpacket msg bounds test (set client 
>>>buf too)
>>
>>Please just include in the series the patch I sent to you.
>>
>Thanks. I'll use your vsock_test.c patch as-is for 3/4
>>>
>>>After fixing TX credit bounds, the client can fill its TX window and
>>>block before it wakes the server. Setting the buffer on the client
>>>makes the test deterministic again.
>>>
>>>diff --git a/tools/testing/vsock/vsock_test.c 
>>>b/tools/testing/vsock/ vsock_test.c
>>>--- a/tools/testing/vsock/vsock_test.c
>>>+++ b/tools/testing/vsock/vsock_test.c
>>>@@ -353,6 +353,7 @@ static void test_stream_msg_peek_server(const
>>>struct test_opts *opts)
>>>
>>>static void test_seqpacket_msg_bounds_client(const struct 
>>>test_opts *opts)
>>>{
>>>+ unsigned long long sock_buf_size;
>>> unsigned long curr_hash;
>>> size_t max_msg_size;
>>> int page_size;
>>>@@ -366,6 +367,18 @@ static void
>>>test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>>> exit(EXIT_FAILURE);
>>> }
>>>
>>>+ sock_buf_size = SOCK_BUF_SIZE;
>>>+
>>>+ setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
>>>+    sock_buf_size,
>>>+    "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
>>>+
>>>+ setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>>>+    sock_buf_size,
>>>+    "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
>>>+
>>> /* Wait, until receiver sets buffer size. */
>>> control_expectln("SRVREADY");
>>>
>>>
>>>---
>>>
>>>Patch 4/4 — vsock/test: add stream TX credit bounds regression test
>>>
>>>This directly guards the original failure mode for stream sockets: if
>>>the peer advertises a large window but the sender’s local policy is
>>>small, the sender must stall quickly (hit EAGAIN in nonblocking mode)
>>>rather than queueing megabytes.
>>
>>Yeah, using nonblocking mode LGTM!
>>
>>>
>>>diff --git a/tools/testing/vsock/vsock_test.c 
>>>b/tools/testing/vsock/ vsock_test.c
>>>--- a/tools/testing/vsock/vsock_test.c
>>>+++ b/tools/testing/vsock/vsock_test.c
>>>@@ -349,6 +349,7 @@
>>>#define SOCK_BUF_SIZE (2 * 1024 * 1024)
>>>+#define SMALL_SOCK_BUF_SIZE (64 * 1024ULL)
>>>#define MAX_MSG_PAGES 4
>>>
>>>/* Insert new test functions after test_stream_msg_peek_server, before
>>> * test_seqpacket_msg_bounds_client (around line 352) */
>>>
>>>+static void test_stream_tx_credit_bounds_client(const struct 
>>>test_opts *opts)
>>>+{
>>>+ ... /* full function as provided */
>>>+}
>>>+
>>>+static void test_stream_tx_credit_bounds_server(const struct 
>>>test_opts *opts)
>>>+{
>>>+ ... /* full function as provided */
>>>+}
>>>
>>>@@ -2224,6 +2305,10 @@
>>> .run_client = test_stream_msg_peek_client,
>>> .run_server = test_stream_msg_peek_server,
>>> },
>>>+ {
>>>+ .name = "SOCK_STREAM TX credit bounds",
>>>+ .run_client = test_stream_tx_credit_bounds_client,
>>>+ .run_server = test_stream_tx_credit_bounds_server,
>>>+ },
>>
>>Please put it at the bottom. Tests are skipped by index, so we don't 
>>want to change index of old tests.
>>
>>Please fix your editor, those diffs are hard to read without tabs/spaces.
>seems like some issue with my email client. Hope it is okay now
>>
>>Thanks,
>>Stefano
>>
>



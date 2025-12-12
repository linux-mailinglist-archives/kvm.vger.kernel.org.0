Return-Path: <kvm+bounces-65821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9869BCB8A38
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 11:41:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4BAAB3064BC9
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 10:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DEBF3191CA;
	Fri, 12 Dec 2025 10:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OGcdxemN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5RMoOdW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C1030EF6A
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 10:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765536049; cv=none; b=W8q5uNun5qcYoGaP7CGV9c7T6EffY5Kh3L1KITL5+R8ScnuJagxnNI+SL7rUDx16GpvkDRsC4zEAJw7VfRVM4sFjTESkiIy6OlqyvtMdikzVx51FcThdzoqzBn1Yqyai8nh+PJq2V1lS1xJkE7Ni2rlBcBEMi/vlbshhTKNz4D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765536049; c=relaxed/simple;
	bh=juHhcADP8tSX/U+Hzz1qM4RQI3ZNmRL0KWC/XVrAlqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V3Wrbi/u1yMRxhBaNRrII0nI37TYrTnCVpbz+LqgGEyMypQw4JIxl0YAO+U0Z5lTrYsObcY92Ok+zizciCUaXHeR+igIi6MypvGrfONkVmw9jgmvLAbaNzlmBMe6aiMhqqJL4B9INyMFFmP0CtTXjfmqe7yi4XFv2qajm/QJLfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OGcdxemN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5RMoOdW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765536046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=btMp3bkAYfxz34CrZuJ4KKYXKtJJ+/4EuQmWIkdS/mQ=;
	b=OGcdxemN4DOa72sGoYka3K9kDwKYjSHeccM8IAfOWfegKkt4vAKo3Aokr425tYFzP4MksG
	pdGiLChnlt/9kD5RsAwR+bJwq0SrtviJEXOwf/IS8LuOa3mClc6RDw08U0ykpYaZ+xYq6Y
	1DxWe3sMLklRU69cGsJFjJAjJrOwS7U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-F2lqmtgmPlmuLXWArrvTUQ-1; Fri, 12 Dec 2025 05:40:45 -0500
X-MC-Unique: F2lqmtgmPlmuLXWArrvTUQ-1
X-Mimecast-MFC-AGG-ID: F2lqmtgmPlmuLXWArrvTUQ_1765536044
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47910af0c8bso8066925e9.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 02:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765536044; x=1766140844; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=btMp3bkAYfxz34CrZuJ4KKYXKtJJ+/4EuQmWIkdS/mQ=;
        b=M5RMoOdWrtFaJvAtXukjqlBwgffc2aqfv8hqq+iEWznFqHaK+locxNievtI4/4BmBa
         1HGmOWVtqtv6KzD7XwUP0coh3GOD2JUBhOSTiJBWqMtxcLE8QTqr66daSbW37j5/YRPz
         tg8nGBI/XDbkUAyyncCpSeYYqbidWoX1cC+jlX4FK7dxBFBDbZkbWQOZdqms1zFfzumq
         ic5Z9+dISyppuWOU6zL9FO+ySNzy+fxivhnkkMscgEmvAUYv46ydDLkjPetN4Ex4ZPTB
         cEmeXjQsNRmBpQrp9NRC5yMDxf/j97NMaulogIqBXSC4eHjQsrzUeOFPTRXn3ZhAIILC
         yCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765536044; x=1766140844;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btMp3bkAYfxz34CrZuJ4KKYXKtJJ+/4EuQmWIkdS/mQ=;
        b=F+WZYvT5Gw9lrNOXvw1Z904XWbtw9kmnKrO3LY8eSZVOHYdV3uO/XReoVPFvHd3fMm
         Af0mQSgWUTcluMHLj6p99FFJ+1Gk42y4HJaAcD58ooGLj7PjyM5KgQ+72JJ0M9/E15cE
         /coScJVCQXG7C1K3arCd7MTEFnmsZ0QaA4HmcKqxUcM3uquWNKpQVPEUG/irkgOgAkaf
         ib/0An+OAC16zYgG9v4NIYD8G2V7cACXbOKWev1/MsBBseRoyF2eFLHwwytj+Sb5gHHi
         tBfVLr0rLTue4CmX27A2FpFcM0dLTaavg/f0O5gxcv24GjVaXJvEetTeRIvC7dY56svZ
         Po2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXZ1v3IzCfEdvz5giAp2o+9xY/Q3RBQXnSAbTbWgRxfEhsAIvhhWhM6Af7vRXzRk252Bis=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYgrFXDVEes5BeSDcW166a5j8E2+eXEZk8kq3TT6Y6RsRjdL8U
	OKOKMxwp3V7J+8Pgc+icoV/TqRuR/49qxKjy+DwOfzFOH6nFchH5hszfe3sQx+3YX3SbLzNMVn9
	XlZR6mjggtVg0OWscxcdckFOrWnvkGk0M/r2Z9TLIP2YoR/KmmU4DGA==
X-Gm-Gg: AY/fxX5smYfSDuiCUBsESkNO79CQ0/o226qNqgv2XZKtJuyv6Q42rURVheDJk8svtiE
	+CBo/mg7yqOpfcZL6uEfOglx0lsf+egDgj+Jb+kUE92kBE4WrJ3ZCWOYDsJFeKw+URVvwWa4pjm
	5nfHD5FlBWsbvY0SQXHs1qUhz89Sn4sEZwJpRI2D9C0dZrzBJMAUimMp7QMgzamoHOMoDZCf9Pm
	egxYCcqRO0c8L+HnRNVHrL48suZk7Tsn1Tu1yz0+jqvWy3mlLx+O7HawMTSEVyjWaqCRlm6KZ9b
	rMKgA+7PwPMUT36KIPGF5kCRP40FGlV/Rlosvya6UVOg/rgVMYgfFqJIX8p1yldJCX3aoFlOUdZ
	YI8PhipV8QCnc2q1GE2ll0IEwaVpaLPhrfrsnea66m0k8z/F95ZFqI6ZBHgqamA==
X-Received: by 2002:a05:600c:4f4a:b0:477:28c1:26ce with SMTP id 5b1f17b1804b1-47a8f8a717dmr17072845e9.7.1765536043607;
        Fri, 12 Dec 2025 02:40:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEnx0bmUc/ydNQn5LSl5u0NC7NieI6tARPsnRE+HvfZJmOj/MEYoW4ZaY3zSqQw060VHGGH9w==
X-Received: by 2002:a05:600c:4f4a:b0:477:28c1:26ce with SMTP id 5b1f17b1804b1-47a8f8a717dmr17072405e9.7.1765536043061;
        Fri, 12 Dec 2025 02:40:43 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f6f118esm10057005e9.3.2025.12.12.02.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 02:40:41 -0800 (PST)
Date: Fri, 12 Dec 2025 11:40:36 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin Mathew Antony <mlbnkm1@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, stefanha@redhat.com, 
	kvm@vger.kernel.org, netdev@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	eperezma@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org
Subject: Re: [PATCH net v3] vsock/virtio: cap TX credit to local buffer size
Message-ID: <bwmol6raorw233ryb3dleh4meaui5vbe7no53boixckl3wgclz@s6grefw5dqen>
References: <20251211125104.375020-1-mlbnkm1@gmail.com>
 <20251211080251-mutt-send-email-mst@kernel.org>
 <zlhixzduyindq24osaedkt2xnukmatwhugfkqmaugvor6wlcol@56jsodxn4rhi>
 <CAMKc4jDpMsk1TtSN-GPLM1M_qp_jpoE1XL1g5qXRUiB-M0BPgQ@mail.gmail.com>
 <CAGxU2F7WOLs7bDJao-7Qd=GOqj_tOmS+EptviMphGqSrgsadqg@mail.gmail.com>
 <CAMKc4jDLdcGsL5_d+4CP6n-57s-R0vzrX2M7Ni=1GeCB1cxVYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMKc4jDLdcGsL5_d+4CP6n-57s-R0vzrX2M7Ni=1GeCB1cxVYA@mail.gmail.com>

On Fri, Dec 12, 2025 at 09:56:28AM +0000, Melbin Mathew Antony wrote:
>Hi Stefano, Michael,
>
>Thanks for the suggestions and guidance.

You're welcome, but please avoid top-posting in the future:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#use-trimmed-interleaved-replies-in-email-discussions

>
>I’ve drafted a 4-part series based on the recap. I’ve included the
>four diffs below for discussion. Can wait for comments, iterate, and
>then send the patch series in a few days.
>
>---
>
>Patch 1/4 — vsock/virtio: make get_credit() s64-safe and clamp negatives
>
>virtio_transport_get_credit() was doing unsigned arithmetic; if the
>peer shrinks its window, the subtraction can underflow and look like
>“lots of credit”. This makes it compute “space” in s64 and clamp < 0
>to 0.
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c
>b/net/vmw_vsock/virtio_transport_common.c
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -494,16 +494,23 @@ EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
> u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> {
>+ s64 bytes;
>  u32 ret;
>
>  if (!credit)
>  return 0;
>
>  spin_lock_bh(&vvs->tx_lock);
>- ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>- if (ret > credit)
>- ret = credit;
>+ bytes = (s64)vvs->peer_buf_alloc -

Why not just calling virtio_transport_has_space()?

>+ ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>+ if (bytes < 0)
>+ bytes = 0;
>+
>+ ret = min_t(u32, credit, (u32)bytes);
>  vvs->tx_cnt += ret;
>  vvs->bytes_unsent += ret;
>  spin_unlock_bh(&vvs->tx_lock);
>
>  return ret;
> }
>
>
>---
>
>Patch 2/4 — vsock/virtio: cap TX window by local buffer (helper + use
>everywhere in TX path)
>
>Cap the effective advertised window to min(peer_buf_alloc, buf_alloc)
>and use it consistently in TX paths (get_credit, has_space,
>seqpacket_enqueue).
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c
>b/net/vmw_vsock/virtio_transport_common.c
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -491,6 +491,16 @@ void virtio_transport_consume_skb_sent(struct
>sk_buff *skb, bool consume)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>+/* Return the effective peer buffer size for TX credit computation.
>+ *
>+ * The peer advertises its receive buffer via peer_buf_alloc, but we cap it
>+ * to our local buf_alloc (derived from SO_VM_SOCKETS_BUFFER_SIZE and
>+ * already clamped to buffer_max_size).
>+ */
>+static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
>+{
>+ return min(vvs->peer_buf_alloc, vvs->buf_alloc);
>+}
>
> u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> {
>  s64 bytes;
>@@ -502,7 +512,8 @@ u32 virtio_transport_get_credit(struct
>virtio_vsock_sock *vvs, u32 credit)
>  return 0;
>
>  spin_lock_bh(&vvs->tx_lock);
>- bytes = (s64)vvs->peer_buf_alloc -
>+ bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
>  ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>  if (bytes < 0)
>  bytes = 0;
>@@ -834,7 +845,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>  spin_lock_bh(&vvs->tx_lock);
>
>- if (len > vvs->peer_buf_alloc) {
>+ if (len > virtio_transport_tx_buf_alloc(vvs)) {
>  spin_unlock_bh(&vvs->tx_lock);
>  return -EMSGSIZE;
>  }
>@@ -884,7 +895,8 @@ static s64 virtio_transport_has_space(struct
>vsock_sock *vsk)
>  struct virtio_vsock_sock *vvs = vsk->trans;
>  s64 bytes;
>
>- bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>+ bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
>+ ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>  if (bytes < 0)
>  bytes = 0;
>
>  return bytes;
> }
>
>
>---
>
>Patch 3/4 — vsock/test: fix seqpacket msg bounds test (set client buf too)

Please just include in the series the patch I sent to you.

>
>After fixing TX credit bounds, the client can fill its TX window and
>block before it wakes the server. Setting the buffer on the client
>makes the test deterministic again.
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -353,6 +353,7 @@ static void test_stream_msg_peek_server(const
>struct test_opts *opts)
>
> static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
> {
>+ unsigned long long sock_buf_size;
>  unsigned long curr_hash;
>  size_t max_msg_size;
>  int page_size;
>@@ -366,6 +367,18 @@ static void
>test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>  exit(EXIT_FAILURE);
>  }
>
>+ sock_buf_size = SOCK_BUF_SIZE;
>+
>+ setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
>+    sock_buf_size,
>+    "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
>+
>+ setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>+    sock_buf_size,
>+    "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
>+
>  /* Wait, until receiver sets buffer size. */
>  control_expectln("SRVREADY");
>
>
>---
>
>Patch 4/4 — vsock/test: add stream TX credit bounds regression test
>
>This directly guards the original failure mode for stream sockets: if
>the peer advertises a large window but the sender’s local policy is
>small, the sender must stall quickly (hit EAGAIN in nonblocking mode)
>rather than queueing megabytes.

Yeah, using nonblocking mode LGTM!

>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -349,6 +349,7 @@
> #define SOCK_BUF_SIZE (2 * 1024 * 1024)
>+#define SMALL_SOCK_BUF_SIZE (64 * 1024ULL)
> #define MAX_MSG_PAGES 4
>
> /* Insert new test functions after test_stream_msg_peek_server, before
>  * test_seqpacket_msg_bounds_client (around line 352) */
>
>+static void test_stream_tx_credit_bounds_client(const struct test_opts *opts)
>+{
>+ ... /* full function as provided */
>+}
>+
>+static void test_stream_tx_credit_bounds_server(const struct test_opts *opts)
>+{
>+ ... /* full function as provided */
>+}
>
>@@ -2224,6 +2305,10 @@
>  .run_client = test_stream_msg_peek_client,
>  .run_server = test_stream_msg_peek_server,
>  },
>+ {
>+ .name = "SOCK_STREAM TX credit bounds",
>+ .run_client = test_stream_tx_credit_bounds_client,
>+ .run_server = test_stream_tx_credit_bounds_server,
>+ },

Please put it at the bottom. Tests are skipped by index, so we don't 
want to change index of old tests.

Please fix your editor, those diffs are hard to read without 
tabs/spaces.

Thanks,
Stefano



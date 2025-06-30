Return-Path: <kvm+bounces-51073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51CF7AED65B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50918165A5D
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D59D242928;
	Mon, 30 Jun 2025 07:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k7On0m/+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0497024291E;
	Mon, 30 Jun 2025 07:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751270272; cv=none; b=kODxea5Hd6Ff83fZt4eszwGiLq86gVYFWPeOVgAu1q7B/uFDZDpkSJGtYsQvpkx/wCjQIhwlUOEAcXWeNGNdiyGEZ3uPDi2fCnjx+I2tnyPKjR0BlggUnKXUNzrzZb6wA0RQQQqnU2rl3ISjd+VxqZFF06AZYJ9dvbPlG/6GIaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751270272; c=relaxed/simple;
	bh=8zHWFlCigM4oKQM+XUD7NX3O01Q7p6W6jnTQzPT3UPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b5Tv3EIk8BUEwuo23hROX0bCkGVs81yH9O58O3N7Qz7r6LuOO62DxLJNPw5GztT1+2lGNvPAnfR2s1xlinE1KPlsi1AqRKwu2EvZKpc3o64KSOb6JOZumCNLx68Lqpj/T8HNUuOh9fd2Re1lKTICquwo1eqUgpjt+FhK9m6xYWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k7On0m/+; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b2fca9dc5f8so3881766a12.1;
        Mon, 30 Jun 2025 00:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751270270; x=1751875070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zxu7ig/S9LCUmwMcMSykN7rd/mLUHqPQuKn7T6xu2vY=;
        b=k7On0m/+hW871AFCg8SU73/PKUUU8djkf0zkzK1bca9YVYUN9CEcQredebPX80VXSg
         yBQE9zhCKOczJEXXOiiAL73h0KYkJuyJVDgzMa1VMnNgPg7w2MMXDYfg4iw79/uHsNOf
         7wUPpNX5DuXgpwhNPfSvkvAxqB4iOL7jKWlM+LV5vOohx3PkxC5qi3o8YeadMir8vLcE
         ZzYA+LbW7vF8ObDWUS48BVsaI7NhhO3IDcDpwVkUYs6ZXC6AXC3v3NJggEaY7G2w7eCk
         mZ18D2D6jwHA1q183WiqZk0eGEda3h7vH7Lfvo6E9PlcEVQr10Pn0kGe2gnDk3HqBKeZ
         cCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751270270; x=1751875070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zxu7ig/S9LCUmwMcMSykN7rd/mLUHqPQuKn7T6xu2vY=;
        b=mH8psfRN0E/IlWW02lFlCHFJS03TO26hAbb+7wpiv6CTbcaYzFgdxOltOPSd1sAQBM
         amtG7mnY+y5yrAVrCTiEiwbeUCikm42X/Xe7OIpD4l09K0tc4MGV4nH8aSlQuh5tcIOT
         NvKzgoSlgiuj+J1/7hrRISclbwPBdn1swJBHvpP0URJ5hohsg9LUv92HzExnM0yK6XPk
         JanBMp1Smmg0M8KNCHuSqrM3u4vXZSpNPMU7sumaeOhlDHDlafdiZttCVygW0UyEI+1j
         4CLuOJxMtGSxvo9MtlfNAn1a6Ft9C94Uq6bYWY6+tqJib9SAsHCUKtL5GWkRvveTRE1Q
         Fbug==
X-Forwarded-Encrypted: i=1; AJvYcCVebRQl65IMRNz8SgEucH49RLx1uQIX8bxZi83++I8CAhtGW4F4B9h5JicQLUCpa70ezPU=@vger.kernel.org, AJvYcCVndUvTTDVVxJfTkgjMONsLv6OdXysUFNvyJ+7jtIvrt/R9rghaEtCvF8X592E3TM/MLaTO3+gJ@vger.kernel.org, AJvYcCWtA2ISEVdM98PkZ+Hr86GTgW15iZRkD5E9aK36a+WlVO6FpQUlxYLSrKj0Gb7/ZRbjcvQ97bvt+jmxPhQg@vger.kernel.org
X-Gm-Message-State: AOJu0YyKXdmAJn0I+CaQJJOIEDPg1XuKqdaOhj1pXBT6l/zBtMeDOMiI
	lXByLGUbN4ztCo7BRz67h7YNKRrUYwy5PKFb6Lr25gwZPLt/GvZ4z9qD
X-Gm-Gg: ASbGncvixEPks3MgJcql7QIj25Skqft+XnFWTlHo8Dx5wEpl+URLOC3lDWJHgxjcbf+
	+SJKSBosC+6u9IwwaIsanM+xKk5I0UcpMr+yTkk3HMKikjompww0Qxn7FUkzihDC/nlBziuVIpA
	w0bpf4V4gv2peA4Os0DFViqU+uq06JzP8ounqDgrOSJwnPjl4BnwqT+FXQQwUuSag3MWzUBVYVZ
	nK5M6/LbwgkzO7/P1Lam0SjU31YITSLT1/spM8rggnSUB6ueKONTHfZvgqwdShcudvlZOitIsUV
	HK1HL9mfchvU/faRUtDlbIyVQESWchDgOO7ZfreJT7wIAi9aW2PMunkBu3fy1klWnbtT7zuFCgT
	jJUi+oXA8
X-Google-Smtp-Source: AGHT+IFeB5QAqHDhB/+cLf2rBEoPse3nWkgqjJpbJmYfyGIZdEChb2MyNa+j8tvsdcGZfOOX40t+Dg==
X-Received: by 2002:a05:6a20:9194:b0:1f5:9098:e42e with SMTP id adf61e73a8af0-220a12a4a3cmr20966808637.7.1751270270193;
        Mon, 30 Jun 2025 00:57:50 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31db02esm7414931a12.63.2025.06.30.00.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:57:49 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com,
	mst@redhat.com,
	pabeni@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	stefanha@redhat.com,
	leonardi@redhat.com,
	decui@microsoft.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fupan.lfp@antgroup.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [RESEND PATCH net-next v4 2/4] hv_sock: Return the readable bytes in hvs_stream_has_data()
Date: Mon, 30 Jun 2025 15:57:25 +0800
Message-Id: <20250630075727.210462-3-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
References: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When hv_sock was originally added, __vsock_stream_recvmsg() and
vsock_stream_has_data() actually only needed to know whether there
is any readable data or not, so hvs_stream_has_data() was written to
return 1 or 0 for simplicity.

However, now hvs_stream_has_data() should return the readable bytes
because vsock_data_ready() -> vsock_stream_has_data() needs to know the
actual bytes rather than a boolean value of 1 or 0.

The SIOCINQ ioctl support also needs hvs_stream_has_data() to return
the readable bytes.

Let hvs_stream_has_data() return the readable bytes of the payload in
the next host-to-guest VMBus hv_sock packet.

Note: there may be multpile incoming hv_sock packets pending in the
VMBus channel's ringbuffer, but so far there is not a VMBus API that
allows us to know all the readable bytes in total without reading and
caching the payload of the multiple packets, so let's just return the
readable bytes of the next single packet. In the future, we'll either
add a VMBus API that allows us to know the total readable bytes without
touching the data in the ringbuffer, or the hv_sock driver needs to
understand the VMBus packet format and parse the packets directly.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 net/vmw_vsock/hyperv_transport.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 31342ab502b4..64f1290a9ae7 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -694,15 +694,25 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
 static s64 hvs_stream_has_data(struct vsock_sock *vsk)
 {
 	struct hvsock *hvs = vsk->trans;
+	bool need_refill = !hvs->recv_desc;
 	s64 ret;
 
 	if (hvs->recv_data_len > 0)
-		return 1;
+		return hvs->recv_data_len;
 
 	switch (hvs_channel_readable_payload(hvs->chan)) {
 	case 1:
-		ret = 1;
-		break;
+		if (!need_refill)
+			return -EIO;
+
+		hvs->recv_desc = hv_pkt_iter_first(hvs->chan);
+		if (!hvs->recv_desc)
+			return -ENOBUFS;
+
+		ret = hvs_update_recv_data(hvs);
+		if (ret)
+			return ret;
+		return hvs->recv_data_len;
 	case 0:
 		vsk->peer_shutdown |= SEND_SHUTDOWN;
 		ret = 0;
-- 
2.34.1



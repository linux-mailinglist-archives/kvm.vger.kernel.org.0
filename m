Return-Path: <kvm+bounces-68391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0633D386ED
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:17:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0EF86302821F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 20:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA2E3A4F50;
	Fri, 16 Jan 2026 20:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T5Fg/iH8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="s4drjzkS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D10A3A4AAA
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768594535; cv=none; b=dP94M7e2vnyrc6T6e6ClEbddsFsokt/0ue7ocnTxmt9udBfxSC79CEejmO34KqVb2VaTQ3mXbRU8113MMAfpPFNhZNvpu8t20XszVnHCql4egJgiVCWhY0weB3GFhZ6Psnon3P9+b+o7dwArVW5qkrzlUKKcfreswD2OMRNO8qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768594535; c=relaxed/simple;
	bh=JvMvAj7ZpINza73ylybZV6srp9RLkEGmGWUWUCTvQu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoUdgTlltnnMEylPFNMOLgwkRBIYAgG/fypcmRis2srpxgMVk3DelEfIKTQr/qTLOuQzMeS1XwfZXfcSa4qiiAfLB7SQpC8R7n798cl4JKvMwdqNhYhDW/tJGBAWXw4uh7i0/FYgKd9R9gt+UprNm2V640DaqcI/x5T3iYe2Gao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T5Fg/iH8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=s4drjzkS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768594533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voXLQ/q07d6hv5Ud8qhwOuK2vYxSCpA8ze6BckDLUOE=;
	b=T5Fg/iH8XEvaTimViOWHu4w6D7Ae/DEt5qqUfRtZyHdJ1v0br0w+1y/gh36nzqmWP1eubD
	Ed+QOZ6dW1zeqqozgzPLerD+k7l67niy2HnvuDpqYOY/II/o/NRiBy1/yTecLiM63gyOJ6
	nv9jT6Zlybp2YgRX+985oYjJgQaES/w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-7e2m03YpNpSiXX8W5WqNog-1; Fri, 16 Jan 2026 15:15:32 -0500
X-MC-Unique: 7e2m03YpNpSiXX8W5WqNog-1
X-Mimecast-MFC-AGG-ID: 7e2m03YpNpSiXX8W5WqNog_1768594531
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430fdaba167so1831876f8f.3
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 12:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768594531; x=1769199331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=voXLQ/q07d6hv5Ud8qhwOuK2vYxSCpA8ze6BckDLUOE=;
        b=s4drjzkSE7J8Ch70zdEa41Rb6nvttyuts1gOncRU5ubWNQGo1ZN5AdUwTBA7Od1Wsq
         CQcwnwkaoyVOp/11t121ssTNnVmRhK1x6+xfxaMzpjY6BBWUE1pMa7ssHwhqw5fcJJHS
         vSMkpIpNl9cd0TgSI4wa4Aet25nVRZH+ZFy46Kk86t4DaFME/8Ay9daZle4pvsBi+1AY
         6byvPdkO9ua8aoe7vUflNtvWFb1e7YIdpCxtCQBjw0yR6cZ8rvptc5UAXGilss/31VGn
         hqCsRKClvb+itmKlRTt3T77bGh1eHu8AVihLEppmm9jf1tRgnYIrLnFck0sB1ZztBN39
         URzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768594531; x=1769199331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=voXLQ/q07d6hv5Ud8qhwOuK2vYxSCpA8ze6BckDLUOE=;
        b=kb6dAPvbSk/Xn7fsbw0EO3JJpJ1C7gpScUhjBljvxgO9rHLoBXO7pEYBp7Dd6G8LW8
         5wZcsTNxZTk9T8FS0Ac3MjHR+GYakkCD9EWp+A3CA8FDicZStRFFXCfFYUQFg1fEPoBZ
         jaTPz0sk+DbTLl3jL4kg0LQo8+tviascYEC/ts7ovr6BOgxGEN1047nPYz3FWIQmIjTs
         1T0MzX0cmchYzmu4rjSblgsjAoONkda3L4Ex/GViExfUD5CWo7rRU2guVFV1qUTfVSg9
         zq+3jdn9WM6WHsbtl6W0KWeRq2TYdHdf4M92MUshkDQRqXsqwi45E3929DYlL2Htosjh
         r7oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjdottnhlTHYkQrsUp9MwgpGCOjzApBtMc4Hzp0gQAjqBCRNOdAiArM1tBj9RASZQnhDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyySGbUj9cu26jQeDKf/rGK5FpjXGtjWgJPs6FVed+ACzQB7ymO
	zu1A7gvDQk/Mq4WTEJG0ANeUsBCnCihWT3UGYj2w8y/WnFJ3BqQw91Z1+me1wEMpvXUZ9GDTssR
	gqsrRN54VGRXwoQsqyrJmdo916TXR/nDU4EdQZPtGlcODhsQKFoe4hw==
X-Gm-Gg: AY/fxX5PCEXt2z6Ly9PtajkWHBLWZ/Z3Ce/TnDmLxK+TMt1Fr+/M+0NF9sBSV4juqbP
	S6rV4RBENFS/a6CAJfjuGxVElwfh0HSJWoM9oG8K2eHmlrcIb6533altDP1HWanDhc+191y/hAT
	LFnctt5f2SYhayLpXbWerbJHJOVkcAENcmm6u2y9GfRGVxVrj/BLiD1cYOaBe7Ee/fXPrvvobTS
	MrX0fHUGVOCF2Y3Yvz6XDrH0yGtBRigq0cbR/1lgd2CRHFus6iBoeOPX792anHdSoUId4q60xND
	BRMxKWTC+PUMavt7QMM/sM9SfAvOWVp7TGXjnapiqSQIlrJ2NOlPUnLkdhw8zKVd1Eu1sh7cUly
	ZwQVSnH6kkjfWy/iEYCe2k8/gHQexWmHXvE0lmHJQYMqMxI/mGmamARKrYqgY
X-Received: by 2002:a05:6000:238a:b0:432:c07a:ee62 with SMTP id ffacd0b85a97d-43569bd48a4mr5632677f8f.62.1768594530755;
        Fri, 16 Jan 2026 12:15:30 -0800 (PST)
X-Received: by 2002:a05:6000:238a:b0:432:c07a:ee62 with SMTP id ffacd0b85a97d-43569bd48a4mr5632658f8f.62.1768594530330;
        Fri, 16 Jan 2026 12:15:30 -0800 (PST)
Received: from stex1.redhat.com (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356992681esm7109861f8f.11.2026.01.16.12.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 12:15:28 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: virtualization@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	kvm@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Asias He <asias@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH RESEND net v5 2/4] vsock/test: fix seqpacket message bounds test
Date: Fri, 16 Jan 2026 21:15:15 +0100
Message-ID: <20260116201517.273302-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260116201517.273302-1-sgarzare@redhat.com>
References: <20260116201517.273302-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefano Garzarella <sgarzare@redhat.com>

The test requires the sender (client) to send all messages before waking
up the receiver (server).
Since virtio-vsock had a bug and did not respect the size of the TX
buffer, this test worked, but now that we are going to fix the bug, the
test hangs because the sender would fill the TX buffer before waking up
the receiver.

Set the buffer size in the sender (client) as well, as we already do for
the receiver (server).

Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/vsock_test.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index bbe3723babdc..ad1eea0f5ab8 100644
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
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
+
 	/* Wait, until receiver sets buffer size. */
 	control_expectln("SRVREADY");
 
-- 
2.52.0



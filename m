Return-Path: <kvm+bounces-66190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AD78CCC9410
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 19:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 681BB3110AD2
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 18:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A4C33D6F4;
	Wed, 17 Dec 2025 18:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMJmwxe6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C604A28136C
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 18:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995160; cv=none; b=T78hMNoDS9J7B7l511LCswO54mhcsvtCmxFbhLzm48LmzWp+uib2CxwwykxvW/NrAJdwuLfUzPXU7QFaZ2NWZkMyel0tiEeWjk+zDhPftmbVIsXT5hiUQXMuiiaapivIpArGHb3mchzAf3eFsHHgyRa2FFdhzYsoudITIljId4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995160; c=relaxed/simple;
	bh=wEb7l9+dIaLrF3lOxuBu98VyqaJvK7HaA2qlpIF1m8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KVZ0UTN3t8p1vHYTKD/m5ucKjw/emuSbzNoF8hFiBPmNzk0ldRwKqYvCfIPmO6H9RFYs4vvwSXKaIgKVh9xlGhjbXzmKWgDnaX/S8hxtCaQVXaK0VUzSbhdb2aZvgV25ySZX/0AdUZJxvMwfNKeo6rcBKgv9tMErdty2P19OtK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AMJmwxe6; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-594285c6509so6944280e87.0
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 10:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765995154; x=1766599954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NbWRXdgRl3LSSNhNbS1goR3DTsrT8qwsPNUfgEKOHFM=;
        b=AMJmwxe6e3qInCTSDqPgOpxkBY6S+OuSUKcbnI6M3baax9apxG+fw/fm838sXn8uGb
         cSEk7IkO95C96WX+iPC+ue1nnUoWerPFtG1uhvGga3mHnQHs5Q60n42/4j8YJWp80QQd
         Y/hoBIcvOVK7XijVle7OwqQZ5NcZ0Fig0NrfQFRhhPUwlE9D7gH8ZkHGQCiKuHbvtac9
         DRgPq+VNMi00peI5lHkMTdq71jKg2OiFKEf9qNKZoHavibz1Hi3i67oNpE6cJqqYLbYy
         m2R8eQP8JnbOx+nvEs5DLk1+UOjZhy9ME6KPQvaqrqJo7te0U+OihE8c3FFWtjM4gesc
         G7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765995154; x=1766599954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NbWRXdgRl3LSSNhNbS1goR3DTsrT8qwsPNUfgEKOHFM=;
        b=q3sY/qDWqDCspdU5Qhl4ob3wO+o2EFSe0VYtsjQE9DL5aO02fnQt61zN4XoIBrCTkB
         kNRxWhwGGoqFaTGcfZKwZHixZgSMhnjbZoIDUCqROOxh3n02JW9NmPPi5ykcSKF3A4mq
         7sy+CKgHEhfKySy9FHKSrAmEJF9o2IPl7UiwWRZPCtru4+WWts/tqfp05TuphvOE3Ad6
         zECgYD3hxwQGluttHv6DlVBdyuRiyHdpenan9ckvP92mjS+USNLsOVcbt9u1BAfiXBqR
         wav3iiEV8veHxT37AY54bytRRn5TIFlZKCYqt+A9B/6+/2pf8Jp47dj4OQ95TZD7Go55
         wVrg==
X-Gm-Message-State: AOJu0YzPtKDt7wz7tqvSxgV4w/t9/CzqNoCEkQjfUg4H76IQd9YMULmw
	rFwvZHObQaBgUbU0bW1Zcn3sT7225UdHY26DJCey8C2t3TWBwihPFMDt
X-Gm-Gg: AY/fxX6fzWtmbcmgADoa1GQX8QkkdKI1ZWb+bgseebcRS4/192i/P3UkuBYmtjpUmCX
	qhtPHBXzpp/nhRRz+oNGkNP+9Xsp8COr1nfWzrvISBPRKZPUUQAqTbz+VrTD1nfrhNyezztvaln
	ZTYQqPkS2Htkz3PMr/7fuwPenhMs3p/A+bWzvO6GljmKxBf5qK3h7uQskwpSANfcyQOwwgdW53d
	BxeO0iAfn3XnBkWwTLOETSEQa1qtKY6CyvLClD7zVtjWY+OEmsmi0TCLOC9j/v/tPk13aUZxkHx
	3Z/BWtTIxA1UcLXaMiVYsDj2PszVoF8DYjyCVAygBcanAY3SYgOYXnn663kJC+sQlLIYBShxvKL
	MnXAOlzrxM8jT5XBmwgLtECaBA2Hv4lQ7v28yfToFX4cwCzDyKi7SZyl81IooI1yS9ZGNyTz3nZ
	ZbswCvtYCbKux2IXogjqfKJg==
X-Google-Smtp-Source: AGHT+IEL8x2ZTlMBEs3LqicoHEeKL6huCiyi0aBC5yPRWitKdewpftY1eFTFYFReON3iTv0egPnjNQ==
X-Received: by 2002:a05:6512:230e:b0:598:dea9:4f4d with SMTP id 2adb3069b0e04-598faa98d29mr6053767e87.53.1765995153840;
        Wed, 17 Dec 2025 10:12:33 -0800 (PST)
Received: from Ubuntu-2204-jammy-amd64-base.. ([2a01:4f9:6a:4e9f::2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5990da790efsm2591419e87.102.2025.12.17.10.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 10:12:32 -0800 (PST)
From: Melbin K Mathew <mlbnkm1@gmail.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com
Cc: kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH net v4 3/4] vsock/test: fix seqpacket message bounds test
Date: Wed, 17 Dec 2025 19:12:05 +0100
Message-Id: <20251217181206.3681159-4-mlbnkm1@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251217181206.3681159-1-mlbnkm1@gmail.com>
References: <20251217181206.3681159-1-mlbnkm1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test requires the sender (client) to send all messages before waking
up the receiver (server).

Since virtio-vsock had a bug and did not respect the size of the TX
buffer, this test worked, but now that we have fixed the bug, it hangs
because the sender fills the TX buffer before waking up the receiver.

Set the buffer size in the sender (client) as well, as we already do for
the receiver (server).

Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
---
 tools/testing/vsock/vsock_test.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 9e1250790f33..0e8e173dfbdc 100644
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
+				sock_buf_size,
+				"setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
+				sock_buf_size,
+				"setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
+
 	/* Wait, until receiver sets buffer size. */
 	control_expectln("SRVREADY");
 
-- 
2.34.1



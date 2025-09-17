Return-Path: <kvm+bounces-57895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FFEB7F996
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:54:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E637F2A4EF7
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A129186294;
	Wed, 17 Sep 2025 13:44:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4676B1B424F
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116666; cv=none; b=GgJH7HN7ZnZ+tNCG2p/ifZ+MlRLfS5n/aX7arQYXDtd+bE+jQYkclcwKu3LvpuYMX6qo1lz0lQzw3KNeiNqlLgZeuLBR0iVPp6vX1nvrZUuuKKED6ppphLdg93Uo0x3RcEjfALOpH8kV/KMzFAv1KHdLwkeZwu04tiigTJ8qbV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116666; c=relaxed/simple;
	bh=x7G/RbDkaW2GjK/tfMNlFD6q3qI9IuGU1XjryNOFYEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p9KEOCfYjeaHtyUKYiC6caRIWW/EhKKydcJWWOB1PYaU0ziGcdeXGVfUFWdNb9ocizakAR0aId/QZTSEb3jsiD91FKQgdg9AFenRDNf7GyWclfSAMUb0Y3kkAy/Y6Hx4L2K180q7XmWDBicUeRBV9WH+xwdVvJNNn+2FAmqxMw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23CF3113E;
	Wed, 17 Sep 2025 06:44:14 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.26.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02CF03F66E;
	Wed, 17 Sep 2025 06:44:20 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: kvm@vger.kernel.org,
	Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH kvmtool v2] net/uip: Avoid deadlock in uip_tcp_socket_free()
Date: Wed, 17 Sep 2025 14:44:14 +0100
Message-ID: <20250917134414.63621-1-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function uip_tcp_socket_free() is called with the sk lock held, but
then goes on to call uip_tcp_socket_close() which attempts to aquire the
lock a second time, triggering a deadlock if there are outstanding TCP
connections.

Rename the existing uip_tcp_socket_close() to a _locked variety and
removing the locking from it. Add a new uip_tcp_socket_close() which
takes the lock and calls the _locked variety.

Fixes: d87b503f4d6e ("net/uip: Add exit function")
Signed-off-by: Steven Price <steven.price@arm.com>
---
v2: Rather than duplicate the cleanup in uip_tcp_socket_free() rejig the
code to have two functions with one _locked.
---
 net/uip/tcp.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/uip/tcp.c b/net/uip/tcp.c
index 8e0ad5235240..42e6e992cd6a 100644
--- a/net/uip/tcp.c
+++ b/net/uip/tcp.c
@@ -6,7 +6,7 @@
 #include <linux/list.h>
 #include <arpa/inet.h>
 
-static int uip_tcp_socket_close(struct uip_tcp_socket *sk, int how)
+static int uip_tcp_socket_close_locked(struct uip_tcp_socket *sk, int how)
 {
 	shutdown(sk->fd, how);
 
@@ -14,9 +14,7 @@ static int uip_tcp_socket_close(struct uip_tcp_socket *sk, int how)
 		shutdown(sk->fd, SHUT_RDWR);
 		close(sk->fd);
 
-		mutex_lock(sk->lock);
 		list_del(&sk->list);
-		mutex_unlock(sk->lock);
 
 		free(sk->buf);
 		free(sk);
@@ -25,6 +23,17 @@ static int uip_tcp_socket_close(struct uip_tcp_socket *sk, int how)
 	return 0;
 }
 
+static int uip_tcp_socket_close(struct uip_tcp_socket *sk, int how)
+{
+	int ret;
+
+	mutex_lock(sk->lock);
+	ret = uip_tcp_socket_close_locked(sk, how);
+	mutex_unlock(sk->lock);
+
+	return ret;
+}
+
 static struct uip_tcp_socket *uip_tcp_socket_find(struct uip_tx_arg *arg, u32 sip, u32 dip, u16 sport, u16 dport)
 {
 	struct list_head *sk_head;
@@ -110,7 +119,7 @@ static void uip_tcp_socket_free(struct uip_tcp_socket *sk)
 	}
 
 	sk->write_done = sk->read_done = 1;
-	uip_tcp_socket_close(sk, SHUT_RDWR);
+	uip_tcp_socket_close_locked(sk, SHUT_RDWR);
 }
 
 static int uip_tcp_payload_send(struct uip_tcp_socket *sk, u8 flag, u16 payload_len)
-- 
2.43.0



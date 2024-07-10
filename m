Return-Path: <kvm+bounces-21349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B020292DAC5
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 649C8281DDC
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36BB1527AA;
	Wed, 10 Jul 2024 21:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FFpMvWPJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310AB1422A8;
	Wed, 10 Jul 2024 21:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646761; cv=none; b=lRZoiQcQQs37426fOS9+F1wNzK463IGPuz7Z6qmAfGdOCkFyL5kCZVyxxbnaiu+Vzzm9Bpa2/xl4zX1GD+D+E2Ek4fn0MS9tHypbIYAGhyUoL44dh4A3CqX8o1C+f+qP6XUggwx2/x4defLVrsIlIItCMo4XmNx2fiYNMG2Qihg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646761; c=relaxed/simple;
	bh=uhCcNYibbkqcdwdVnInAQFJ9ST2PnHWFbtJHgHboauo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HIM5gYpv+q06qmYY+n0sIKAetSJ7PsPk3V8TnuWNKo/IOr5JFp3se4Kt+l18KK6/Ssrwg7j4wy3TjHsqTs/mehIl9oX85Pwg8Knp9hrbppUaL2UeozBuWI2HeDMFF0zUlqDh6qDBg+LYvIxiUQHL7GO4m35cQCTc8lfSeQEAJUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FFpMvWPJ; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3d9bcb47182so149545b6e.3;
        Wed, 10 Jul 2024 14:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646759; x=1721251559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NmXSwxoqzjXnEZ3Wwvngpw8L/cu5lmFAezrwWUUIofg=;
        b=FFpMvWPJVIPc0AZ5ibgwLJy2z6P2pjrJVL1or2/9XNnMY1ZoaW3PkqVVXug7yk9j4c
         Xfwu/yH7ChcwXYNHWvm9fYy98GVo5oHm9vI58SOcUkgP2ui3bnZANhGRpQHu/lub1EQl
         hN4BXDE3eB/MvuEhoqCju2VU49/NxSFD4bXZWT6dfIPyHolzZeBRge9t2yN2oomJfnKQ
         LWzpx/Pvgopy8RJE12x16hPmrzhSBv6jj8H9VNW3uqcdGRWLp/2he+3TY47k4ao5B1x3
         +PfW60nbwrB8apylEy1TnMKGWe9pDSNETY9vqpFAvxo1CBiKZyOs/Q93YGoaP6KG4lG1
         EyLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646759; x=1721251559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NmXSwxoqzjXnEZ3Wwvngpw8L/cu5lmFAezrwWUUIofg=;
        b=H1AhFnbQ3we/buO0rWbo7FgiJojHQKyNmcFn5m1dc4WyntQ22/FmM/vnOebUBWNBDj
         orTNT8b1BIYEuxm2TTNSmDzyVKXs5eeGwDKBvvS49k9Qtge9MBhWnRyamsIqAqWY+Sc6
         lyi9SY5pXCUmwNoVMhk9TIEKDcrg4MafXKnaIBJ1X6tZrNEl5P1ABE0So3W7SQWgtiVU
         vrI9cR3erOBbKKCctJV6TIyY4w7Q5giv1PKBqT/QZ2bdf6ktGRsW2zJV6fIWomtwifDE
         0w0m54hN6xR0sdoeFIZ0g6l4RuPNlEMMhWSolHQ3VXEhwOPV33tieyyOgDR5HhAsvLau
         MI/w==
X-Forwarded-Encrypted: i=1; AJvYcCWat6svQWZLoayj3xcw3yiqndtIJFRVM3PDne31NQGe8Bz62X0eLNP9ja995SzMDjlO3fPyt5tfe4d6Q51qGqVWiGIc7NjlaJ4OjhKB8xdmm/jm3ys9I2DsfBWI3rF3JiJNKCnlE6L/rUtNCXOpYokNlQutxN5JBhkwltMXPkbUGFaFbW4JmSL98ICAYUuoKkcC06GouiWaKS6SlvnFLbv6xa5BzSyyDR6b3S40
X-Gm-Message-State: AOJu0YzJ5Q73z+L/lmfBGusEybDYnMuvEL2PYy22GPBWT7wvVl+roq8T
	Jcjze06wNDhdG0knIJWvQJme8C/MnJxK728Sb8TcORlsq66ipUww
X-Google-Smtp-Source: AGHT+IHAi58F+5PJOYlliCTAylnZUgBqrqKTaxEPrlPEhkPkEh9JQbful2UvFJHyD7bxBrd2xbJ6sw==
X-Received: by 2002:a05:6808:2129:b0:3d9:29c1:be4c with SMTP id 5614622812f47-3d93c07b10amr7068703b6e.38.1720646759158;
        Wed, 10 Jul 2024 14:25:59 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:25:58 -0700 (PDT)
From: Amery Hung <ameryhung@gmail.com>
X-Google-Original-From: Amery Hung <amery.hung@bytedance.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	bryantan@vmware.com,
	vdasa@vmware.com,
	pv-drivers@vmware.com
Cc: dan.carpenter@linaro.org,
	simon.horman@corigine.com,
	oxffffaa@gmail.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	bobby.eshleman@bytedance.com,
	jiang.wang@bytedance.com,
	amery.hung@bytedance.com,
	ameryhung@gmail.com,
	xiyou.wangcong@gmail.com
Subject: [RFC PATCH net-next v6 04/14] af_vsock: generalize bind table functions
Date: Wed, 10 Jul 2024 21:25:45 +0000
Message-Id: <20240710212555.1617795-5-amery.hung@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240710212555.1617795-1-amery.hung@bytedance.com>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bobby Eshleman <bobby.eshleman@bytedance.com>

This commit makes the bind table management functions in vsock usable
for different bind tables. Future work will introduce a new table for
datagrams to avoid address collisions, and these functions will be used
there.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 net/vmw_vsock/af_vsock.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index acc15e11700c..d571be9cdbf0 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -232,11 +232,12 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
 	sock_put(&vsk->sk);
 }
 
-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
+static struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *addr,
+						   struct list_head *bind_table)
 {
 	struct vsock_sock *vsk;
 
-	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
+	list_for_each_entry(vsk, bind_table, bound_table) {
 		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
 			return sk_vsock(vsk);
 
@@ -249,6 +250,11 @@ static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
 	return NULL;
 }
 
+static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
+{
+	return vsock_find_bound_socket_common(addr, vsock_bound_sockets(addr));
+}
+
 static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
 						  struct sockaddr_vm *dst)
 {
@@ -671,12 +677,18 @@ static void vsock_pending_work(struct work_struct *work)
 
 /**** SOCKET OPERATIONS ****/
 
-static int __vsock_bind_connectible(struct vsock_sock *vsk,
-				    struct sockaddr_vm *addr)
+static int vsock_bind_common(struct vsock_sock *vsk,
+			     struct sockaddr_vm *addr,
+			     struct list_head *bind_table,
+			     size_t table_size)
 {
 	static u32 port;
 	struct sockaddr_vm new_addr;
 
+	if (WARN_ONCE(table_size < VSOCK_HASH_SIZE,
+		      "table size too small, may cause overflow"))
+		return -EINVAL;
+
 	if (!port)
 		port = get_random_u32_above(LAST_RESERVED_PORT);
 
@@ -692,7 +704,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 
 			new_addr.svm_port = port++;
 
-			if (!__vsock_find_bound_socket(&new_addr)) {
+			if (!vsock_find_bound_socket_common(&new_addr,
+							    &bind_table[VSOCK_HASH(addr)])) {
 				found = true;
 				break;
 			}
@@ -709,7 +722,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 			return -EACCES;
 		}
 
-		if (__vsock_find_bound_socket(&new_addr))
+		if (vsock_find_bound_socket_common(&new_addr,
+						   &bind_table[VSOCK_HASH(addr)]))
 			return -EADDRINUSE;
 	}
 
@@ -721,11 +735,17 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 	 * by AF_UNIX.
 	 */
 	__vsock_remove_bound(vsk);
-	__vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vsk);
+	__vsock_insert_bound(&bind_table[VSOCK_HASH(&vsk->local_addr)], vsk);
 
 	return 0;
 }
 
+static int __vsock_bind_connectible(struct vsock_sock *vsk,
+				    struct sockaddr_vm *addr)
+{
+	return vsock_bind_common(vsk, addr, vsock_bind_table, VSOCK_HASH_SIZE + 1);
+}
+
 static int __vsock_bind_dgram(struct vsock_sock *vsk,
 			      struct sockaddr_vm *addr)
 {
-- 
2.20.1



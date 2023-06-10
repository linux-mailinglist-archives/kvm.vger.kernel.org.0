Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0C072A73A
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 02:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjFJA7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 20:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjFJA7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 20:59:12 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A8D3A9E
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 17:58:48 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-62884fa0e53so17813616d6.0
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 17:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1686358728; x=1688950728;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R1vY4qAtc5xUmwIOF/wXuc4xbGrdjFfiVCQ6YVrfe4Y=;
        b=CPB0lHtHpC0VvuE1XUOxtVINK+5k1qVb8FsGYnJckM3/Ks1XlEQoUKE0zegBrEfALJ
         SQtz8S9XlQZroBiFXFi1poXrMRfUi5nVCFE73lzpfTqxv3q0x7QsUrbJuK9Nny8gYyAD
         19dh4c+sYmGEPptwgm8/cvTOs0wSxgv9ggqwYzBIoWNGXG+O27QYrc9w3fQC9rSW17t0
         22UT2Dbl0MOtDJ24lCo1j3rNJCZl+3E5gXrAZHZT5lyu4A7wO6Pw3+U9OYfzGgQ16sy7
         rsQxset4dICcVxssuHh7XsXqhabkT2/Pu2T5IhTDeaIomYFPHbPfdcmIEfEWQg4wfR9/
         D+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686358728; x=1688950728;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R1vY4qAtc5xUmwIOF/wXuc4xbGrdjFfiVCQ6YVrfe4Y=;
        b=b5UcOd/h0FM68kOEUoX2BBULDgqKUn0eAJhIp4eleq9PqJL+/ea5I0plOB69jCRibR
         eJVm0+RumVKu1zNlUQwlHV7gX6i67bWE4aQWVCw/ervQJmh1q+FhhOIRDRujTitTKKqc
         fQE9v82fblc4N0wgYVkcw+yC9oUeuFjzY3jutS9ppxYYqWcfSwRlDBuPiT/3+YUmYiFB
         DkmV0rDF4u7Rv1KCa+tMATQUadHj640qzGkROB/K8r2ueD/lbUxHv8xnExpvZ6WYCJiE
         9a4znQwyaZDdSA+rWnY1AnGGUzsrzd0MGAEYNMauCXI6ZMgwcV85S/zecY9dkyDaC3xx
         AO1w==
X-Gm-Message-State: AC+VfDw6LzIfAPV3rzx9G0bTQdVBjCWg9ISkyv10URSdAGOaPOAJXeJB
        J11rnLlWFr/ooR08WOC4zTHc9g==
X-Google-Smtp-Source: ACHHUZ7TFSxbJy+liBH3dNJpH+AuvL8DZMKGs4Lwqi6QxHI9rtYXs7508N3ZLZJa9kuqpp+iUlVSGg==
X-Received: by 2002:a05:6214:250e:b0:62b:4e7e:8aba with SMTP id gf14-20020a056214250e00b0062b4e7e8abamr4016793qvb.60.1686358728054;
        Fri, 09 Jun 2023 17:58:48 -0700 (PDT)
Received: from [172.17.0.4] ([130.44.212.126])
        by smtp.gmail.com with ESMTPSA id x17-20020a0ce251000000b00606750abaf9sm1504075qvl.136.2023.06.09.17.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 17:58:47 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Sat, 10 Jun 2023 00:58:31 +0000
Subject: [PATCH RFC net-next v4 4/8] vsock: make vsock bind reusable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v4-4-0cebbb2ae899@bytedance.com>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit makes the bind table management functions in vsock usable
for different bind tables. For use by datagrams in a future patch.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 net/vmw_vsock/af_vsock.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ef86765f3765..7a3ca4270446 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -230,11 +230,12 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
 	sock_put(&vsk->sk);
 }
 
-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
+struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *addr,
+					    struct list_head *bind_table)
 {
 	struct vsock_sock *vsk;
 
-	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
+	list_for_each_entry(vsk, bind_table, bound_table) {
 		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
 			return sk_vsock(vsk);
 
@@ -247,6 +248,11 @@ static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
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
@@ -646,12 +652,17 @@ static void vsock_pending_work(struct work_struct *work)
 
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
 
+	if (table_size < VSOCK_HASH_SIZE)
+		return -1;
+
 	if (!port)
 		port = get_random_u32_above(LAST_RESERVED_PORT);
 
@@ -667,7 +678,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 
 			new_addr.svm_port = port++;
 
-			if (!__vsock_find_bound_socket(&new_addr)) {
+			if (!vsock_find_bound_socket_common(&new_addr,
+							    &bind_table[VSOCK_HASH(addr)])) {
 				found = true;
 				break;
 			}
@@ -684,7 +696,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 			return -EACCES;
 		}
 
-		if (__vsock_find_bound_socket(&new_addr))
+		if (vsock_find_bound_socket_common(&new_addr,
+						   &bind_table[VSOCK_HASH(addr)]))
 			return -EADDRINUSE;
 	}
 
@@ -696,11 +709,17 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
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
2.30.2


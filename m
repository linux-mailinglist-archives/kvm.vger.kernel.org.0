Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F887758A33
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 02:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjGSAuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 20:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjGSAuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 20:50:19 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11515E53
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:14 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-7659db6339eso14243085a.1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689727813; x=1692319813;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XE7xx9iLHROSi//2aw1ggMmi4lxgJG8eDx6KZfuDE2w=;
        b=jbFfw6yWrqm8g/M0Mcm+rEYLs48/1lNS5DfgbjSPZLziZ1zzRSoFeF6UAVq0kp0nF5
         Cs2hs25n+QV8K9l49XImvLmuUoDjQG6ucRk/M5Ys0kVrVbZ0dXRZ/9agC3Hj6z0TBJ+3
         6D1woGsbITvafqZe8OjSVxhjUN6E5zS25TjNZo+AAOcg2Pqy6UQRL2n5J2y25oBX9mo6
         /vaj5R627b1+5VJNai3wzRCLJPlv10FwPHVU6ohOnSErLHaWoVgFC7w+mQxHKT/2DOTL
         SWBf5dVuwcel47Dkk9qjotggT8IfTLddlywb9KQNSHIYUjxQUlMEe6GtCL58viKLFd+/
         sUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689727813; x=1692319813;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XE7xx9iLHROSi//2aw1ggMmi4lxgJG8eDx6KZfuDE2w=;
        b=ZvDpWI752+EH54GyNP6/o+l1xZmJGe5VMXAOGRfyVqFhGnsDwIxZ58pFRtMuFxSpD8
         RLh4RtG2OTC/jVDVEhsYtwPAaSEZtAxYgS33slS23cyxXfY9ITAjWazHAwyuhjyOk6DM
         N18b4Gm+UnjmjJuGNLQdeUn/RALRLSuSNyBBBql91xysLimqEbtvKD8RoQMtxKVdqCdb
         S4alitH3qH5up7C5sWFzWNTq95fdd+6Nc2NOdTeBw7XPM+H5uFxszFjgrSOMCXiooJhp
         Nl+HgHMlP9rTLPUDvlQdkIMHNuvgujb7OwruQdNczouKK8Jn8YfvZvTCgXBK4pCyqijx
         I8vQ==
X-Gm-Message-State: ABy/qLZllaGjMf/bUsOm8f7W2oJSWuXt3Kgv/Aof6ajn6HlIOeB4m5qe
        /DEcy+hnbgyWQCCAdROF1Mzbfw==
X-Google-Smtp-Source: APBJJlHtNG3Vjvbanag9Ylbtwm71pbwmGv9mx1Yk5a7s0jvHNn9FPB7k7XBcyXavplaBgBmQcaMX+w==
X-Received: by 2002:a05:620a:2489:b0:766:f9a5:c7ec with SMTP id i9-20020a05620a248900b00766f9a5c7ecmr810938qkn.18.1689727812816;
        Tue, 18 Jul 2023 17:50:12 -0700 (PDT)
Received: from [172.17.0.7] ([130.44.212.112])
        by smtp.gmail.com with ESMTPSA id c5-20020a05620a11a500b0076738337cd1sm968696qkk.1.2023.07.18.17.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 17:50:12 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 19 Jul 2023 00:50:08 +0000
Subject: [PATCH RFC net-next v5 04/14] af_vsock: generalize bind table
 functions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v5-4-581bd37fdb26@bytedance.com>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
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
for different bind tables. Future work will introduce a new table for
datagrams to avoid address collisions, and these functions will be used
there.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 net/vmw_vsock/af_vsock.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 26c97b33d55a..88100154156c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -231,11 +231,12 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
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
 
@@ -248,6 +249,11 @@ static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
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
@@ -647,12 +653,18 @@ static void vsock_pending_work(struct work_struct *work)
 
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
 
@@ -668,7 +680,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 
 			new_addr.svm_port = port++;
 
-			if (!__vsock_find_bound_socket(&new_addr)) {
+			if (!vsock_find_bound_socket_common(&new_addr,
+							    &bind_table[VSOCK_HASH(addr)])) {
 				found = true;
 				break;
 			}
@@ -685,7 +698,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 			return -EACCES;
 		}
 
-		if (__vsock_find_bound_socket(&new_addr))
+		if (vsock_find_bound_socket_common(&new_addr,
+						   &bind_table[VSOCK_HASH(addr)]))
 			return -EADDRINUSE;
 	}
 
@@ -697,11 +711,17 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
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


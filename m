Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E234D4765
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 13:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242189AbiCJM4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 07:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242164AbiCJM4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 07:56:00 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340FA14A06E
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:54:52 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2dbda4f6331so39689597b3.11
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4/lo4O5bvYf7GLQ1V3jQOnUyhynYGZYN44Y/DiquDY0=;
        b=theA46R8KffoZd25AjZTMiCu8NKBDf3uh7N3Iynxw+ETIC/n6GFcUZBZd4a0gn6msc
         xbHQoWfMZ7U/NE4qsR+6neaSSiEyffUPWb82q+JfC4lHTOeqGhpjMPpbKi1E5GQlfKLH
         m9by6havb9tJl0S+E/5LduHHKijEnTjWvlNwkanFYn2n+jpslZ7b5WDSzgYXF2SYsBeZ
         ixTfu41+UZMVgI1jOjAdx4siWpVTOOALKgduhfD4kVQ2O21JbpR3lBsZtM0iLESqNJnq
         LgDrd4vI+pHGlQLSaQULkljE2PyWpYx7bCVYwOuVbvEjeoZOzCE2/A7QrCF+xITFmSeE
         IHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4/lo4O5bvYf7GLQ1V3jQOnUyhynYGZYN44Y/DiquDY0=;
        b=iiAG17hqqFx9TcKch/ObMFtI6YF4BEX2r6p3Akp4e17eFoaupbYbtPc/7wEsYcT85D
         kRcI7ZxwQttNKupu8hWM7S41Dj0NjO9qNLymO5ETotllvX4QI4MtTZRGoeSOJp/b9SJO
         GN68d0dIFYxGy+p0cY+B/gEU3vBY7ZQpIA+gLh6QXx8i0NcrpXRENU7ypp/Q3jNVFTCu
         100SmXcd/qrHzFEgkYj3OuLEU6jRDNnulcYb2GUeCLd8AkUC2fbjJo3T8Tca+pWqePZ4
         WFtdSrx54KSsSap0C+5ZdoaUjwLaseIl5bSz3KVyvCQiVZdQWThha/BHbVNMlyS9xj57
         YAWA==
X-Gm-Message-State: AOAM530dDal4VEqMEevM+W2vnek1lcBUmsDsrljah0x4gUWfSjpwiptM
        /c2odoYxdECstWb8M9LBaEA6x05zdbU=
X-Google-Smtp-Source: ABdhPJxJ9mMyBKHyHWzl1YnU6RbNR2+LGq4lvPfkj5Km3/Epcd/kGV2Cxd0xbU89Bh6FvfjYN8EejRIX8SU=
X-Received: from jiyong.seo.corp.google.com ([2401:fa00:d:11:f59e:134:eb7:e1d2])
 (user=jiyong job=sendgmr) by 2002:a81:9c47:0:b0:2db:9e18:6e75 with SMTP id
 n7-20020a819c47000000b002db9e186e75mr3694892ywa.437.1646916891346; Thu, 10
 Mar 2022 04:54:51 -0800 (PST)
Date:   Thu, 10 Mar 2022 21:54:25 +0900
In-Reply-To: <20220310125425.4193879-1-jiyong@google.com>
Message-Id: <20220310125425.4193879-3-jiyong@google.com>
Mime-Version: 1.0
References: <20220310125425.4193879-1-jiyong@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 2/2] vsock: refactor vsock_for_each_connected_socket
From:   Jiyong Park <jiyong@google.com>
To:     sgarzare@redhat.com, stefanha@redhat.com, mst@redhat.com,
        jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org
Cc:     adelva@google.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiyong Park <jiyong@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vsock_for_each_connected_socket now cycles over sockets of a specific
transport only, rather than asking callers to do the filtering manually,
which is error-prone.

Signed-off-by: Jiyong Park <jiyong@google.com>
---
 drivers/vhost/vsock.c            |  7 ++-----
 include/net/af_vsock.h           |  3 ++-
 net/vmw_vsock/af_vsock.c         |  9 +++++++--
 net/vmw_vsock/virtio_transport.c | 12 ++++--------
 net/vmw_vsock/vmci_transport.c   |  8 ++------
 5 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 853ddac00d5b..e6c9d41db1de 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -722,10 +722,6 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 	 * executing.
 	 */
 
-	/* Only handle our own sockets */
-	if (vsk->transport != &vhost_transport.transport)
-		return;
-
 	/* If the peer is still valid, no need to reset connection */
 	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
 		return;
@@ -757,7 +753,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 
 	/* Iterating over all connections for all CIDs to find orphans is
 	 * inefficient.  Room for improvement here. */
-	vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
+	vsock_for_each_connected_socket(&vhost_transport.transport,
+					vhost_vsock_reset_orphans);
 
 	/* Don't check the owner, because we are in the release path, so we
 	 * need to stop the vsock device in any case.
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index ab207677e0a8..f742e50207fb 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -205,7 +205,8 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
 struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
 					 struct sockaddr_vm *dst);
 void vsock_remove_sock(struct vsock_sock *vsk);
-void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
+void vsock_for_each_connected_socket(struct vsock_transport *transport,
+				     void (*fn)(struct sock *sk));
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 bool vsock_find_cid(unsigned int cid);
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 38baeb189d4e..f04abf662ec6 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -334,7 +334,8 @@ void vsock_remove_sock(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_remove_sock);
 
-void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
+void vsock_for_each_connected_socket(struct vsock_transport *transport,
+				     void (*fn)(struct sock *sk))
 {
 	int i;
 
@@ -343,8 +344,12 @@ void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
 	for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++) {
 		struct vsock_sock *vsk;
 		list_for_each_entry(vsk, &vsock_connected_table[i],
-				    connected_table)
+				    connected_table) {
+			if (vsk->transport != transport)
+				continue;
+
 			fn(sk_vsock(vsk));
+		}
 	}
 
 	spin_unlock_bh(&vsock_table_lock);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 61b24eb31d4b..5afc194a58bb 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -358,17 +358,11 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
 
 static void virtio_vsock_reset_sock(struct sock *sk)
 {
-	struct vsock_sock *vsk = vsock_sk(sk);
-
 	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
 	 * under vsock_table_lock so the sock cannot disappear while we're
 	 * executing.
 	 */
 
-	/* Only handle our own sockets */
-	if (vsk->transport != &virtio_transport.transport)
-		return;
-
 	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = ECONNRESET;
 	sk_error_report(sk);
@@ -391,7 +385,8 @@ static void virtio_vsock_event_handle(struct virtio_vsock *vsock,
 	switch (le32_to_cpu(event->id)) {
 	case VIRTIO_VSOCK_EVENT_TRANSPORT_RESET:
 		virtio_vsock_update_guest_cid(vsock);
-		vsock_for_each_connected_socket(virtio_vsock_reset_sock);
+		vsock_for_each_connected_socket(&virtio_transport.transport,
+						virtio_vsock_reset_sock);
 		break;
 	}
 }
@@ -669,7 +664,8 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	synchronize_rcu();
 
 	/* Reset all connected sockets when the device disappear */
-	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
+	vsock_for_each_connected_socket(&virtio_transport.transport,
+					virtio_vsock_reset_sock);
 
 	/* Stop all work handlers to make sure no one is accessing the device,
 	 * so we can safely call virtio_reset_device().
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index cd2f01513fae..735d5e14608a 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -803,11 +803,6 @@ static void vmci_transport_handle_detach(struct sock *sk)
 	struct vsock_sock *vsk;
 
 	vsk = vsock_sk(sk);
-
-	/* Only handle our own sockets */
-	if (vsk->transport != &vmci_transport)
-		return;
-
 	if (!vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)) {
 		sock_set_flag(sk, SOCK_DONE);
 
@@ -887,7 +882,8 @@ static void vmci_transport_qp_resumed_cb(u32 sub_id,
 					 const struct vmci_event_data *e_data,
 					 void *client_data)
 {
-	vsock_for_each_connected_socket(vmci_transport_handle_detach);
+	vsock_for_each_connected_socket(&vmci_transport,
+					vmci_transport_handle_detach);
 }
 
 static void vmci_transport_recv_pkt_work(struct work_struct *work)
-- 
2.35.1.723.g4982287a31-goog


Return-Path: <kvm+bounces-22118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0365693A2FA
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 16:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC14428493B
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 14:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B040155A3C;
	Tue, 23 Jul 2024 14:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WdRWtYSO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48D4155733
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721745702; cv=none; b=ZmJI4xS/IU3LniCaXOI3CtMTCm1g+nm2I2HWxUEw6rxdgWwA964do/6A/l86mev/Fz3zOTpDLYXBRjgyaUmQCw7gkQiDk1uEApZkEGfadYieKEayhIo4QrCSeZ3DXzHchFfpf0PoytBu2xgIeyk2vFXWeq53AKU46OcztcZUgb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721745702; c=relaxed/simple;
	bh=WdnJ+hMhGSMponqG4kViC1DgyInGjvuh4n/NZkUg7Bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+dgeWchPNCr46a97Qkizkqz0budWdaWJevX3XVD52yOVEoOPng7MCsSQtQZt6xFd4ioBPjNGNcVBBB0m8BaMUb0Vmy/i1V5bc93n7abFmYB6UgsIm4o2mJHWjpaYWF/lKApQ47mlgYKn8u/QAQQdNioJzWOT22ww6zYdvZz6bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WdRWtYSO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721745699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/9NlmFu+bsd8CcBEWR/pkh/Yo2pe8bBZ3WwTXW/wFkg=;
	b=WdRWtYSOgPUssTYXjOxsea3HCCzy1VJt9U8NY41tXc7CDhmSpdRf5Tq7ALW9hTtYp3XGz3
	G95xAVJUuVk65xuqsut2iFCagkdcxwhXa4EvUI1VZkXh9dxK2fGp3lU2IB7uUfQKuCsxuR
	Pn9fiQWtUiY/vJm7H+U3ZwwaxBOb5kY=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-iGobAmF9OxCHTgufpYovmQ-1; Tue, 23 Jul 2024 10:41:37 -0400
X-MC-Unique: iGobAmF9OxCHTgufpYovmQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-26106c817baso5381983fac.1
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 07:41:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721745697; x=1722350497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9NlmFu+bsd8CcBEWR/pkh/Yo2pe8bBZ3WwTXW/wFkg=;
        b=LmN/YM2PXn6Q4JTdYBrfSluO8POSVEG+Du/kL828Jztt7Ng1PLd1vZ+qMZLRMPn7xW
         +z/3EI17nFGW1tIzMpKJNALFW5fyvmhzxZ2QwlfeiLcGdb1A3q3tUMbtYH6AG48s+fIL
         1WjZtWrhaXMrc9Q8uPJaD/Z0rNussIa3YX2vtUL/YYwr/cw5ojsBGfpCY5pq3+8ppE0k
         gIqcWIYxMLsKlU931K4CPUOjxdMM2z0An+x5OVEqcQ33dDvbkh4JQwdRiv40htyWS5Zm
         Rj/O17Bcmc/2hVPNtlVFVywfkNC22csQjESJuYcQI7HcvWqAww5UtRzFKZxNnKOmd+pf
         gHtw==
X-Forwarded-Encrypted: i=1; AJvYcCXNLKMHEjpXUbeKra8Bt+FjNXcWy9FgUhraQu/E9iNqjEnIZVDBSiKjIjs0LYeglxFWbRqKxeuw8ilGMY+im9N7gdn0
X-Gm-Message-State: AOJu0YxH+nXFgUyWr4CqRbDJj6+L7v9Blqnwds1lMtDc/hnUvhLn2hGc
	CZQHcjlJILri6H0jq9qsdkp5hKLYx96C950Fzt+u3I7olUkaFRNBg6c6KCUf+Io5HmmFeERg9oQ
	UqubjCSTxEfeixaLDYJ60OElNkuVzo0ZMas1thfjw2yEuiv/7Rw==
X-Received: by 2002:a05:6870:96a9:b0:260:fc8c:2d29 with SMTP id 586e51a60fabf-264690736f3mr2997452fac.20.1721745696866;
        Tue, 23 Jul 2024 07:41:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1TDBnmRZA2Q8ZLvYfzA17+JeqzePSJLyyDpiBaSk2AXZTKm1LxcD+OQB0EG7X+jHIcZhWGQ==
X-Received: by 2002:a05:6870:96a9:b0:260:fc8c:2d29 with SMTP id 586e51a60fabf-264690736f3mr2997416fac.20.1721745696294;
        Tue, 23 Jul 2024 07:41:36 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-79.retail.telecomitalia.it. [82.57.51.79])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a198fad0c0sm486726185a.15.2024.07.23.07.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 07:41:35 -0700 (PDT)
Date: Tue, 23 Jul 2024 16:41:29 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Amery Hung <ameryhung@gmail.com>
Cc: stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org, 
	decui@microsoft.com, bryantan@vmware.com, vdasa@vmware.com, pv-drivers@vmware.com, 
	dan.carpenter@linaro.org, simon.horman@corigine.com, oxffffaa@gmail.com, 
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	bpf@vger.kernel.org, bobby.eshleman@bytedance.com, jiang.wang@bytedance.com, 
	amery.hung@bytedance.com, xiyou.wangcong@gmail.com
Subject: Re: [RFC PATCH net-next v6 05/14] af_vsock: use a separate dgram
 bind table
Message-ID: <pghfa4vh7vb7sggelop5asuyj6bqtq4rbgm2q3bdslcoeicihj@6arcanemghjo>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
 <20240710212555.1617795-6-amery.hung@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240710212555.1617795-6-amery.hung@bytedance.com>

On Wed, Jul 10, 2024 at 09:25:46PM GMT, Amery Hung wrote:
>From: Bobby Eshleman <bobby.eshleman@bytedance.com>
>
>This commit adds support for bound dgram sockets to be tracked in a
>separate bind table from connectible sockets in order to avoid address
>collisions. With this commit, users can simultaneously bind a dgram
>socket and connectible socket to the same CID and port.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> net/vmw_vsock/af_vsock.c | 103 +++++++++++++++++++++++++++++----------
> 1 file changed, 76 insertions(+), 27 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d571be9cdbf0..ab08cd81720e 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -10,18 +10,23 @@
>  * - There are two kinds of sockets: those created by user action (such as
>  * calling socket(2)) and those created by incoming connection request packets.
>  *
>- * - There are two "global" tables, one for bound sockets (sockets that have
>- * specified an address that they are responsible for) and one for connected
>- * sockets (sockets that have established a connection with another socket).
>- * These tables are "global" in that all sockets on the system are placed
>- * within them. - Note, though, that the bound table contains an extra entry
>- * for a list of unbound sockets and SOCK_DGRAM sockets will always remain in
>- * that list. The bound table is used solely for lookup of sockets when packets
>- * are received and that's not necessary for SOCK_DGRAM sockets since we create
>- * a datagram handle for each and need not perform a lookup.  Keeping SOCK_DGRAM
>- * sockets out of the bound hash buckets will reduce the chance of collisions
>- * when looking for SOCK_STREAM sockets and prevents us from having to check the
>- * socket type in the hash table lookups.
>+ * - There are three "global" tables, one for bound connectible (stream /
>+ * seqpacket) sockets, one for bound datagram sockets, and one for connected
>+ * sockets. Bound sockets are sockets that have specified an address that
>+ * they are responsible for. Connected sockets are sockets that have
>+ * established a connection with another socket. These tables are "global" in
>+ * that all sockets on the system are placed within them. - Note, though,
>+ * that the bound tables contain an extra entry for a list of unbound
>+ * sockets. The bound tables are used solely for lookup of sockets when packets
>+ * are received.
>+ *
>+ * - There are separate bind tables for connectible and datagram sockets to avoid
>+ * address collisions between stream/seqpacket sockets and datagram sockets.
>+ *
>+ * - Transports may elect to NOT use the global datagram bind table by
>+ * implementing the ->dgram_bind() callback. If that callback is implemented,
>+ * the global bind table is not used and the responsibility of bound datagram
>+ * socket tracking is deferred to the transport.
>  *
>  * - Sockets created by user action will either be "client" sockets that
>  * initiate a connection or "server" sockets that listen for connections; we do
>@@ -116,6 +121,7 @@
> static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
> static void vsock_sk_destruct(struct sock *sk);
> static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
>+static bool sock_type_connectible(u16 type);
>
> /* Protocol family. */
> struct proto vsock_proto = {
>@@ -152,21 +158,25 @@ static DEFINE_MUTEX(vsock_register_mutex);
>  * VSocket is stored in the connected hash table.
>  *
>  * Unbound sockets are all put on the same list attached to the end of the hash
>- * table (vsock_unbound_sockets).  Bound sockets are added to the hash table in
>- * the bucket that their local address hashes to (vsock_bound_sockets(addr)
>- * represents the list that addr hashes to).
>+ * tables (vsock_unbound_sockets/vsock_unbound_dgram_sockets).  Bound sockets
>+ * are added to the hash table in the bucket that their local address hashes to
>+ * (vsock_bound_sockets(addr) and vsock_bound_dgram_sockets(addr) represents
>+ * the list that addr hashes to).
>  *
>- * Specifically, we initialize the vsock_bind_table array to a size of
>- * VSOCK_HASH_SIZE + 1 so that vsock_bind_table[0] through
>- * vsock_bind_table[VSOCK_HASH_SIZE - 1] are for bound sockets and
>- * vsock_bind_table[VSOCK_HASH_SIZE] is for unbound sockets.  The hash function
>- * mods with VSOCK_HASH_SIZE to ensure this.
>+ * Specifically, taking connectible sockets as an example we initialize the
>+ * vsock_bind_table array to a size of VSOCK_HASH_SIZE + 1 so that
>+ * vsock_bind_table[0] through vsock_bind_table[VSOCK_HASH_SIZE - 1] are for
>+ * bound sockets and vsock_bind_table[VSOCK_HASH_SIZE] is for unbound sockets.
>+ * The hash function mods with VSOCK_HASH_SIZE to ensure this.
>+ * Datagrams and vsock_dgram_bind_table operate in the same way.
>  */
> #define MAX_PORT_RETRIES        24
>
> #define VSOCK_HASH(addr)        ((addr)->svm_port % VSOCK_HASH_SIZE)
> #define vsock_bound_sockets(addr) (&vsock_bind_table[VSOCK_HASH(addr)])
>+#define vsock_bound_dgram_sockets(addr) (&vsock_dgram_bind_table[VSOCK_HASH(addr)])
> #define vsock_unbound_sockets     (&vsock_bind_table[VSOCK_HASH_SIZE])
>+#define vsock_unbound_dgram_sockets     (&vsock_dgram_bind_table[VSOCK_HASH_SIZE])
>
> /* XXX This can probably be implemented in a better way. */
> #define VSOCK_CONN_HASH(src, dst)				\
>@@ -182,6 +192,8 @@ struct list_head vsock_connected_table[VSOCK_HASH_SIZE];
> EXPORT_SYMBOL_GPL(vsock_connected_table);
> DEFINE_SPINLOCK(vsock_table_lock);
> EXPORT_SYMBOL_GPL(vsock_table_lock);
>+static struct list_head vsock_dgram_bind_table[VSOCK_HASH_SIZE + 1];
>+static DEFINE_SPINLOCK(vsock_dgram_table_lock);
>
> /* Autobind this socket to the local address if necessary. */
> static int vsock_auto_bind(struct vsock_sock *vsk)
>@@ -204,6 +216,9 @@ static void vsock_init_tables(void)
>
> 	for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++)
> 		INIT_LIST_HEAD(&vsock_connected_table[i]);
>+
>+	for (i = 0; i < ARRAY_SIZE(vsock_dgram_bind_table); i++)
>+		INIT_LIST_HEAD(&vsock_dgram_bind_table[i]);
> }
>
> static void __vsock_insert_bound(struct list_head *list,
>@@ -271,13 +286,28 @@ static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
> 	return NULL;
> }
>
>-static void vsock_insert_unbound(struct vsock_sock *vsk)
>+static void __vsock_insert_dgram_unbound(struct vsock_sock *vsk)
>+{
>+	spin_lock_bh(&vsock_dgram_table_lock);
>+	__vsock_insert_bound(vsock_unbound_dgram_sockets, vsk);
>+	spin_unlock_bh(&vsock_dgram_table_lock);
>+}
>+
>+static void __vsock_insert_connectible_unbound(struct vsock_sock *vsk)
> {
> 	spin_lock_bh(&vsock_table_lock);
> 	__vsock_insert_bound(vsock_unbound_sockets, vsk);
> 	spin_unlock_bh(&vsock_table_lock);
> }
>
>+static void vsock_insert_unbound(struct vsock_sock *vsk)
>+{
>+	if (sock_type_connectible(sk_vsock(vsk)->sk_type))
>+		__vsock_insert_connectible_unbound(vsk);
>+	else
>+		__vsock_insert_dgram_unbound(vsk);
>+}
>+
> void vsock_insert_connected(struct vsock_sock *vsk)
> {
> 	struct list_head *list = vsock_connected_sockets(
>@@ -289,6 +319,14 @@ void vsock_insert_connected(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(vsock_insert_connected);
>
>+static void vsock_remove_dgram_bound(struct vsock_sock *vsk)
>+{
>+	spin_lock_bh(&vsock_dgram_table_lock);
>+	if (__vsock_in_bound_table(vsk))
>+		__vsock_remove_bound(vsk);
>+	spin_unlock_bh(&vsock_dgram_table_lock);
>+}
>+
> void vsock_remove_bound(struct vsock_sock *vsk)
> {
> 	spin_lock_bh(&vsock_table_lock);
>@@ -340,7 +378,10 @@ EXPORT_SYMBOL_GPL(vsock_find_connected_socket);
>
> void vsock_remove_sock(struct vsock_sock *vsk)
> {
>-	vsock_remove_bound(vsk);
>+	if (sock_type_connectible(sk_vsock(vsk)->sk_type))
>+		vsock_remove_bound(vsk);
>+	else
>+		vsock_remove_dgram_bound(vsk);

Can we try to be consistent, for example we have vsock_insert_unbound()
which calls internally sock_type_connectible(), while
vsock_remove_bound() is just for connectible sockets. It's a bit
confusing.

> 	vsock_remove_connected(vsk);
> }
> EXPORT_SYMBOL_GPL(vsock_remove_sock);
>@@ -746,11 +787,19 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> 	return vsock_bind_common(vsk, addr, vsock_bind_table, VSOCK_HASH_SIZE + 1);
> }
>
>-static int __vsock_bind_dgram(struct vsock_sock *vsk,
>-			      struct sockaddr_vm *addr)
>+static int vsock_bind_dgram(struct vsock_sock *vsk,
>+			    struct sockaddr_vm *addr)

Why we are renaming this?

> {
>-	if (!vsk->transport || !vsk->transport->dgram_bind)
>-		return -EINVAL;
>+	if (!vsk->transport || !vsk->transport->dgram_bind) {

Why this condition?

Maybe a comment here is needed because I'm lost...

>+		int retval;
>+
>+		spin_lock_bh(&vsock_dgram_table_lock);
>+		retval = vsock_bind_common(vsk, addr, vsock_dgram_bind_table,
>+					   VSOCK_HASH_SIZE);

Should we use VSOCK_HASH_SIZE + 1 here?

Using ARRAY_SIZE(x) should avoid this problem.


>+		spin_unlock_bh(&vsock_dgram_table_lock);
>+
>+		return retval;
>+	}
>
> 	return vsk->transport->dgram_bind(vsk, addr);
> }
>@@ -781,7 +830,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
> 		break;
>
> 	case SOCK_DGRAM:
>-		retval = __vsock_bind_dgram(vsk, addr);
>+		retval = vsock_bind_dgram(vsk, addr);
> 		break;
>
> 	default:
>-- 
>2.20.1
>



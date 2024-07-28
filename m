Return-Path: <kvm+bounces-22473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 515F993E9BC
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 23:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C74DC1F21CC9
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 21:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C65277F10;
	Sun, 28 Jul 2024 21:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngfS4ksB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9FE12B94;
	Sun, 28 Jul 2024 21:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722202658; cv=none; b=EwOvj4qMAEVRhLeiOXAm33MH8LOTztQQeE1uGEMqxdoDz0mEAoRpHjA58tVZvW/z+cvh3aKqPQkYBJahgwAtqM/teI2yA6wRO+4Hz1xU+Tn8WM3ezmzPzuSq+25KsuazfoY3piVm2jHmg6fgy3S777bxKgkhkV8QiGCP+xnOtU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722202658; c=relaxed/simple;
	bh=2Sn68X7uDls3sP1EZexTSLlGYbfSYXNz2o7k80QTDUs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lkq7CpsxufqsfV9wnRolkQ55dU+ESVrxkndRzuaOrQLqxWrkhbBMDrrLUYHiya4D3e9qqTnUrmcQ4CvtzkwoCO5zEDXlY9kcG4YFCfrxqcINcivcS94znqzD8U2bE9GRXqf4O2ZDnHQf3dgVdK5qx/F5WcCzeYiI3dgOUuqH1A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ngfS4ksB; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e0885b4f1d5so1275167276.1;
        Sun, 28 Jul 2024 14:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722202656; x=1722807456; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9cFCXNlBUwwoGYk4agpmfzd90AIjSqmRZ4wGHZIvL4=;
        b=ngfS4ksBEQprRybEaUydabCt7dMpXXLj3dQO38xieO6SAqstF0qDJo4vlq/+ALTzW4
         CKEzHupnesmyqsZxkWvcuBKupdRQ4eZHY/y4JG0mVUctnN/H9fobwcmnJFRLR+shZDjb
         weE//EL4Syo16G7FgMXYmbIPiY5Tcz8dC9qOXneJARkxACl1dThzUeB6NRQq1dEfVlFI
         yQGdTHjyxQq7r8N1h3T8bYO0NFtQzzvZRbfcd1FhhggHieCNiq2GA8rKqabMcBA0aLz6
         h6sjrdNoMIk5dHmAomojGvzhYHzzdITOxaG5wIVXc/QtSo2j8t0cOIW7hBienHCk2qoT
         Mjjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722202656; x=1722807456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K9cFCXNlBUwwoGYk4agpmfzd90AIjSqmRZ4wGHZIvL4=;
        b=JbxJS0461mIa95J9wjhDi1L+bhadVkhFGbwWZg84MIMYcqXlQzrl543/T2PMgyNV3E
         sn5DkT9SuwzIOp/EXvxpD/YHVVDPb273NcP6V/HsbVPP3RUQ+Dwv42KaVgDvfebn0Jw4
         jjC4Y5Vs/B6lRhzb+OlWkMekUip6MmkXIQc5PFWOdUZKFhZlYBHDn3+RXgeek9p3cSj2
         fi2fjHrfjK1tg/CsxdfzObKCfQDfLiVCH3YxNgYC3i1uGldJs4y/vZsSXVxN/k8zL3QP
         luXyiFaYRE7pssO7VQW1C7e1IwDXeNAFKqg34giI0BMlKfoQE6+/BY5miBS8rDj1P4St
         tP5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUBWXgRq7ZmM1ueIniiN7kfNyaKqy2xH1/ZYWOham3LHS3XT27w0Bz8sbpjfwI7m+yRDSKQJ5bLiHNdTd7XX9ln6CdM0GUx+sQ9WttrQ+mmIOfZYS4J3ShjCK4XQfyoyeH3xBtmmEoaM30okCjIqq3XyMp/PmnT8vxCQ2iW+o2sPOGdxFASfkENqv5yzft2BpzLvdKJinnMM6obCVzx4kiFE+dJIkwFhF6/EEFm
X-Gm-Message-State: AOJu0Yw/cNNZZdu8djkaRH+ImJENc3nAygNwKKd94kPdllQytx5hpReA
	KLIuN5kzNKEC4odb4Zc5EEP6SrLZrAKrP5sB88SNkoVPlx/Ac3r5FavEPdCxfbywwClwF9MekIe
	DGJW3CACbTdoVEY9RKKto6MnjUbc=
X-Google-Smtp-Source: AGHT+IFVP55gj+sT0MrYRVitmwH+mCztNmVoK2xGhUz6Qlhx2dO5zlQtp2zqP2YBKFY/JMujHOiS1/r6Ulhctp/0vN4=
X-Received: by 2002:a05:6902:240e:b0:e06:6e0c:5e0 with SMTP id
 3f1490d57ef6-e0b5459ca5dmr5791170276.38.1722202655671; Sun, 28 Jul 2024
 14:37:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
 <20240710212555.1617795-6-amery.hung@bytedance.com> <pghfa4vh7vb7sggelop5asuyj6bqtq4rbgm2q3bdslcoeicihj@6arcanemghjo>
In-Reply-To: <pghfa4vh7vb7sggelop5asuyj6bqtq4rbgm2q3bdslcoeicihj@6arcanemghjo>
From: Amery Hung <ameryhung@gmail.com>
Date: Sun, 28 Jul 2024 14:37:24 -0700
Message-ID: <CAMB2axNL_O3Twksi+ROUz0B298A-xQ_EYsgYzc2jLRbpikrdJQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 05/14] af_vsock: use a separate dgram bind table
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com, 
	wei.liu@kernel.org, decui@microsoft.com, bryantan@vmware.com, 
	vdasa@vmware.com, pv-drivers@vmware.com, dan.carpenter@linaro.org, 
	simon.horman@corigine.com, oxffffaa@gmail.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	bpf@vger.kernel.org, bobby.eshleman@bytedance.com, jiang.wang@bytedance.com, 
	amery.hung@bytedance.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2024 at 7:41=E2=80=AFAM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Wed, Jul 10, 2024 at 09:25:46PM GMT, Amery Hung wrote:
> >From: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >
> >This commit adds support for bound dgram sockets to be tracked in a
> >separate bind table from connectible sockets in order to avoid address
> >collisions. With this commit, users can simultaneously bind a dgram
> >socket and connectible socket to the same CID and port.
> >
> >Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >---
> > net/vmw_vsock/af_vsock.c | 103 +++++++++++++++++++++++++++++----------
> > 1 file changed, 76 insertions(+), 27 deletions(-)
> >
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index d571be9cdbf0..ab08cd81720e 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -10,18 +10,23 @@
> >  * - There are two kinds of sockets: those created by user action (such=
 as
> >  * calling socket(2)) and those created by incoming connection request =
packets.
> >  *
> >- * - There are two "global" tables, one for bound sockets (sockets that=
 have
> >- * specified an address that they are responsible for) and one for conn=
ected
> >- * sockets (sockets that have established a connection with another soc=
ket).
> >- * These tables are "global" in that all sockets on the system are plac=
ed
> >- * within them. - Note, though, that the bound table contains an extra =
entry
> >- * for a list of unbound sockets and SOCK_DGRAM sockets will always rem=
ain in
> >- * that list. The bound table is used solely for lookup of sockets when=
 packets
> >- * are received and that's not necessary for SOCK_DGRAM sockets since w=
e create
> >- * a datagram handle for each and need not perform a lookup.  Keeping S=
OCK_DGRAM
> >- * sockets out of the bound hash buckets will reduce the chance of coll=
isions
> >- * when looking for SOCK_STREAM sockets and prevents us from having to =
check the
> >- * socket type in the hash table lookups.
> >+ * - There are three "global" tables, one for bound connectible (stream=
 /
> >+ * seqpacket) sockets, one for bound datagram sockets, and one for conn=
ected
> >+ * sockets. Bound sockets are sockets that have specified an address th=
at
> >+ * they are responsible for. Connected sockets are sockets that have
> >+ * established a connection with another socket. These tables are "glob=
al" in
> >+ * that all sockets on the system are placed within them. - Note, thoug=
h,
> >+ * that the bound tables contain an extra entry for a list of unbound
> >+ * sockets. The bound tables are used solely for lookup of sockets when=
 packets
> >+ * are received.
> >+ *
> >+ * - There are separate bind tables for connectible and datagram socket=
s to avoid
> >+ * address collisions between stream/seqpacket sockets and datagram soc=
kets.
> >+ *
> >+ * - Transports may elect to NOT use the global datagram bind table by
> >+ * implementing the ->dgram_bind() callback. If that callback is implem=
ented,
> >+ * the global bind table is not used and the responsibility of bound da=
tagram
> >+ * socket tracking is deferred to the transport.
> >  *
> >  * - Sockets created by user action will either be "client" sockets tha=
t
> >  * initiate a connection or "server" sockets that listen for connection=
s; we do
> >@@ -116,6 +121,7 @@
> > static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
> > static void vsock_sk_destruct(struct sock *sk);
> > static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
> >+static bool sock_type_connectible(u16 type);
> >
> > /* Protocol family. */
> > struct proto vsock_proto =3D {
> >@@ -152,21 +158,25 @@ static DEFINE_MUTEX(vsock_register_mutex);
> >  * VSocket is stored in the connected hash table.
> >  *
> >  * Unbound sockets are all put on the same list attached to the end of =
the hash
> >- * table (vsock_unbound_sockets).  Bound sockets are added to the hash =
table in
> >- * the bucket that their local address hashes to (vsock_bound_sockets(a=
ddr)
> >- * represents the list that addr hashes to).
> >+ * tables (vsock_unbound_sockets/vsock_unbound_dgram_sockets).  Bound s=
ockets
> >+ * are added to the hash table in the bucket that their local address h=
ashes to
> >+ * (vsock_bound_sockets(addr) and vsock_bound_dgram_sockets(addr) repre=
sents
> >+ * the list that addr hashes to).
> >  *
> >- * Specifically, we initialize the vsock_bind_table array to a size of
> >- * VSOCK_HASH_SIZE + 1 so that vsock_bind_table[0] through
> >- * vsock_bind_table[VSOCK_HASH_SIZE - 1] are for bound sockets and
> >- * vsock_bind_table[VSOCK_HASH_SIZE] is for unbound sockets.  The hash =
function
> >- * mods with VSOCK_HASH_SIZE to ensure this.
> >+ * Specifically, taking connectible sockets as an example we initialize=
 the
> >+ * vsock_bind_table array to a size of VSOCK_HASH_SIZE + 1 so that
> >+ * vsock_bind_table[0] through vsock_bind_table[VSOCK_HASH_SIZE - 1] ar=
e for
> >+ * bound sockets and vsock_bind_table[VSOCK_HASH_SIZE] is for unbound s=
ockets.
> >+ * The hash function mods with VSOCK_HASH_SIZE to ensure this.
> >+ * Datagrams and vsock_dgram_bind_table operate in the same way.
> >  */
> > #define MAX_PORT_RETRIES        24
> >
> > #define VSOCK_HASH(addr)        ((addr)->svm_port % VSOCK_HASH_SIZE)
> > #define vsock_bound_sockets(addr) (&vsock_bind_table[VSOCK_HASH(addr)])
> >+#define vsock_bound_dgram_sockets(addr) (&vsock_dgram_bind_table[VSOCK_=
HASH(addr)])
> > #define vsock_unbound_sockets     (&vsock_bind_table[VSOCK_HASH_SIZE])
> >+#define vsock_unbound_dgram_sockets     (&vsock_dgram_bind_table[VSOCK_=
HASH_SIZE])
> >
> > /* XXX This can probably be implemented in a better way. */
> > #define VSOCK_CONN_HASH(src, dst)                             \
> >@@ -182,6 +192,8 @@ struct list_head vsock_connected_table[VSOCK_HASH_SI=
ZE];
> > EXPORT_SYMBOL_GPL(vsock_connected_table);
> > DEFINE_SPINLOCK(vsock_table_lock);
> > EXPORT_SYMBOL_GPL(vsock_table_lock);
> >+static struct list_head vsock_dgram_bind_table[VSOCK_HASH_SIZE + 1];
> >+static DEFINE_SPINLOCK(vsock_dgram_table_lock);
> >
> > /* Autobind this socket to the local address if necessary. */
> > static int vsock_auto_bind(struct vsock_sock *vsk)
> >@@ -204,6 +216,9 @@ static void vsock_init_tables(void)
> >
> >       for (i =3D 0; i < ARRAY_SIZE(vsock_connected_table); i++)
> >               INIT_LIST_HEAD(&vsock_connected_table[i]);
> >+
> >+      for (i =3D 0; i < ARRAY_SIZE(vsock_dgram_bind_table); i++)
> >+              INIT_LIST_HEAD(&vsock_dgram_bind_table[i]);
> > }
> >
> > static void __vsock_insert_bound(struct list_head *list,
> >@@ -271,13 +286,28 @@ static struct sock *__vsock_find_connected_socket(=
struct sockaddr_vm *src,
> >       return NULL;
> > }
> >
> >-static void vsock_insert_unbound(struct vsock_sock *vsk)
> >+static void __vsock_insert_dgram_unbound(struct vsock_sock *vsk)
> >+{
> >+      spin_lock_bh(&vsock_dgram_table_lock);
> >+      __vsock_insert_bound(vsock_unbound_dgram_sockets, vsk);
> >+      spin_unlock_bh(&vsock_dgram_table_lock);
> >+}
> >+
> >+static void __vsock_insert_connectible_unbound(struct vsock_sock *vsk)
> > {
> >       spin_lock_bh(&vsock_table_lock);
> >       __vsock_insert_bound(vsock_unbound_sockets, vsk);
> >       spin_unlock_bh(&vsock_table_lock);
> > }
> >
> >+static void vsock_insert_unbound(struct vsock_sock *vsk)
> >+{
> >+      if (sock_type_connectible(sk_vsock(vsk)->sk_type))
> >+              __vsock_insert_connectible_unbound(vsk);
> >+      else
> >+              __vsock_insert_dgram_unbound(vsk);
> >+}
> >+
> > void vsock_insert_connected(struct vsock_sock *vsk)
> > {
> >       struct list_head *list =3D vsock_connected_sockets(
> >@@ -289,6 +319,14 @@ void vsock_insert_connected(struct vsock_sock *vsk)
> > }
> > EXPORT_SYMBOL_GPL(vsock_insert_connected);
> >
> >+static void vsock_remove_dgram_bound(struct vsock_sock *vsk)
> >+{
> >+      spin_lock_bh(&vsock_dgram_table_lock);
> >+      if (__vsock_in_bound_table(vsk))
> >+              __vsock_remove_bound(vsk);
> >+      spin_unlock_bh(&vsock_dgram_table_lock);
> >+}
> >+
> > void vsock_remove_bound(struct vsock_sock *vsk)
> > {
> >       spin_lock_bh(&vsock_table_lock);
> >@@ -340,7 +378,10 @@ EXPORT_SYMBOL_GPL(vsock_find_connected_socket);
> >
> > void vsock_remove_sock(struct vsock_sock *vsk)
> > {
> >-      vsock_remove_bound(vsk);
> >+      if (sock_type_connectible(sk_vsock(vsk)->sk_type))
> >+              vsock_remove_bound(vsk);
> >+      else
> >+              vsock_remove_dgram_bound(vsk);
>
> Can we try to be consistent, for example we have vsock_insert_unbound()
> which calls internally sock_type_connectible(), while
> vsock_remove_bound() is just for connectible sockets. It's a bit
> confusing.

I agree with you. I will make the style more consistent by keeping
vsock_insert_unbound() only work on connectible sockets.

>
> >       vsock_remove_connected(vsk);
> > }
> > EXPORT_SYMBOL_GPL(vsock_remove_sock);
> >@@ -746,11 +787,19 @@ static int __vsock_bind_connectible(struct vsock_s=
ock *vsk,
> >       return vsock_bind_common(vsk, addr, vsock_bind_table, VSOCK_HASH_=
SIZE + 1);
> > }
> >
> >-static int __vsock_bind_dgram(struct vsock_sock *vsk,
> >-                            struct sockaddr_vm *addr)
> >+static int vsock_bind_dgram(struct vsock_sock *vsk,
> >+                          struct sockaddr_vm *addr)
>
> Why we are renaming this?

I will keep the original __vsock_bind_dgram() for consistency.

>
> > {
> >-      if (!vsk->transport || !vsk->transport->dgram_bind)
> >-              return -EINVAL;
> >+      if (!vsk->transport || !vsk->transport->dgram_bind) {
>
> Why this condition?
>
> Maybe a comment here is needed because I'm lost...

We currently use !vsk->transport->dgram_bind to determine if this is
VMCI dgram transport. Will add a comment explaining this.

>
> >+              int retval;
> >+
> >+              spin_lock_bh(&vsock_dgram_table_lock);
> >+              retval =3D vsock_bind_common(vsk, addr, vsock_dgram_bind_=
table,
> >+                                         VSOCK_HASH_SIZE);
>
> Should we use VSOCK_HASH_SIZE + 1 here?
>
> Using ARRAY_SIZE(x) should avoid this problem.

Yes. The size here is wrong. I will remove the size check (the
discussion is in patch 4).

Thanks,
Amery



>
>
> >+              spin_unlock_bh(&vsock_dgram_table_lock);
> >+
> >+              return retval;
> >+      }
> >
> >       return vsk->transport->dgram_bind(vsk, addr);
> > }
> >@@ -781,7 +830,7 @@ static int __vsock_bind(struct sock *sk, struct sock=
addr_vm *addr)
> >               break;
> >
> >       case SOCK_DGRAM:
> >-              retval =3D __vsock_bind_dgram(vsk, addr);
> >+              retval =3D vsock_bind_dgram(vsk, addr);
> >               break;
> >
> >       default:
> >--
> >2.20.1
> >
>


Return-Path: <kvm+bounces-22686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DED81941F18
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B6C9B2542E
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 17:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A784418A6C0;
	Tue, 30 Jul 2024 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mVkAudVa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA1E184547;
	Tue, 30 Jul 2024 17:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722362220; cv=none; b=E4VQlCzumnSOWsOEuCxcRLPydhw/YJmmHlwWxfjVLZIU+Vbr8ournb7dR0JbHaKAElRVR0rczktChrvP/QUfixRSv0xI73UNMkwAijg9q1XOFYUces3Wd4FpDBkszhp43aDT9hL4pDpaOlTu0UCrW1Ymbunusy9KRx22hkJtIBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722362220; c=relaxed/simple;
	bh=Yq/ggOUNW+hktq+nK4p6E6tkRE5rk8sFRRmqvpaJpcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hk4kUmZ3oUdpP9f0xJqb5KfY+cqIWEPN4J4ie2MW6EA7UM6JhD7xOEIIhuw4GPG2/5pnFySjWlnTuW7RKiaIORVqhyjvFwB/tVQoGyBcm1wP+d7z/dNA11UTALToDisW5HpqSRSuUxqk6qRv9382T19gy1LPAlQ6Hsr8ycDur5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mVkAudVa; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e087641d2a2so3753220276.0;
        Tue, 30 Jul 2024 10:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722362218; x=1722967018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tJ9LmFr+EeYpInIUds90yt7v1m8/2stEKp9e7T6m1w=;
        b=mVkAudVa+U7V3BVQqZjVzNSi1MmaSQOlplVTk7tx+na8oQY5C9/nANgcxJnWWUzSQd
         pSmhh6KYmzoUHWBpHAMcMwBDaIKa/AgNuME2BnINvxTK63P2x1EIdIvY1vAv5OGvuQ+i
         yVBtxHNzD6CEAXrzNYk74QjvBcMtIpwQQUCJfxODo5VQKapOX28oyOqD5UptbVNQve29
         lyc/eCQaEDPQAjZ7paoJnDixR6tWXKMSV4Bmt7DghhO1FKTtNKk89S6HSFBj1yCe0/MB
         CF2s+wtvOpLhkdR6500Gxw+umBB37bFSANpQy/MUHrwGmnf/6jdviXzeiZwbPWElDid0
         CILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722362218; x=1722967018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2tJ9LmFr+EeYpInIUds90yt7v1m8/2stEKp9e7T6m1w=;
        b=fyX37PNuMzLO2uc9wz7n89ePnQFcaEc9n0br4C/HEo28KNGT0cxhY2gj8DuVdI56Iq
         s465syl770b7Yey9OWwRcRIfqFtHkQISd7k8ZLUBnsxR+jisjsXkyqGiWjnBkT4mhSV6
         JVRR0pT9Mk1BJWses5kqTtXiZfyjVFMm8lFRb7kwaPcznPK4DWNc5ZqTqUasz3fS7Ioz
         M0UNaorBLtaRzBpxx65gSEYWXMbPLZa1kbzSxbR5cBk3EhneUMe6xXQGPVSkIokDG48I
         Tv+xeFKxcC4ul/Pe2cJwtPHsDI2MZlmaO85yNFOuFOLAYwOmvXnPKg7XtryX8fNVdFBg
         Kgtw==
X-Forwarded-Encrypted: i=1; AJvYcCXy3I8H5ZfaSBJmC/fjnSQ15yQBl2jjB62jUuhrOgoUccbXJLglYEQDQs9Sd21O6I7cAnNBha0HLzoJzJeIV4iuqiyDYQu7QH+ujgtAYvXabY8DVKy9tx2/NUupCJ1ljy//NBrgxaNvmW2LiWxP7u02tyyTFWZdo6ijgEagbIhtfI7XL951CEpoV8hsUkvWOfZZNMJKUwoaRYB23PF5DzIKId9ewSW88RTr2Jzf
X-Gm-Message-State: AOJu0Yy1QtZGw3xmVFUKuskJ8Tq/lOxfM55WXaqN25l9H6bFICCpG6z/
	PNK+1H4AutMReJxMfj5ywBke9b8axXo9GjG5TN8ZotOiwlWzOCc4/XiSpsQL1fjkkHoFepD4WR0
	aM9RsqXrOlHLS6+sVUGq8kbXYmcY=
X-Google-Smtp-Source: AGHT+IEeFCqCt/8oTNqAY4RtLq00QVkD5Ag05gXDYxk2tQVY/F4tyERpQH8H3d42Bd+DygSbMlFnsnAzg7VIuPpEhJA=
X-Received: by 2002:a05:6902:2742:b0:e0b:b2d6:f528 with SMTP id
 3f1490d57ef6-e0bb2d701c8mr529006276.38.1722362218035; Tue, 30 Jul 2024
 10:56:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
 <20240710212555.1617795-5-amery.hung@bytedance.com> <CAGxU2F7wCUR-KhDRBopK+0gv=bM0PCKeWM87j1vEYmbvhO8WHQ@mail.gmail.com>
 <CAMB2axNUZa221WKTjLt0G5KNdtkAbm20ViDZRGBh6pL9y3wosg@mail.gmail.com> <ba2hivznnjcyeftr7ch7gvrwjvkimx5u2t2anv7wv7n7yb3j36@dbagnaylvu6o>
In-Reply-To: <ba2hivznnjcyeftr7ch7gvrwjvkimx5u2t2anv7wv7n7yb3j36@dbagnaylvu6o>
From: Amery Hung <ameryhung@gmail.com>
Date: Tue, 30 Jul 2024 10:56:46 -0700
Message-ID: <CAMB2axPfz0kOFau0tX2=87e=2EPSLxX1AXHPpsv3QyaLYaBvoA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 04/14] af_vsock: generalize bind table functions
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

On Tue, Jul 30, 2024 at 1:00=E2=80=AFAM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Sun, Jul 28, 2024 at 11:52:54AM GMT, Amery Hung wrote:
> >On Tue, Jul 23, 2024 at 7:40=E2=80=AFAM Stefano Garzarella <sgarzare@red=
hat.com> wrote:
> >>
> >> On Wed, Jul 10, 2024 at 09:25:45PM GMT, Amery Hung wrote:
> >> >From: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >> >
> >> >This commit makes the bind table management functions in vsock usable
> >> >for different bind tables. Future work will introduce a new table for
> >> >datagrams to avoid address collisions, and these functions will be us=
ed
> >> >there.
> >> >
> >> >Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >> >---
> >> > net/vmw_vsock/af_vsock.c | 34 +++++++++++++++++++++++++++-------
> >> > 1 file changed, 27 insertions(+), 7 deletions(-)
> >> >
> >> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >> >index acc15e11700c..d571be9cdbf0 100644
> >> >--- a/net/vmw_vsock/af_vsock.c
> >> >+++ b/net/vmw_vsock/af_vsock.c
> >> >@@ -232,11 +232,12 @@ static void __vsock_remove_connected(struct vso=
ck_sock *vsk)
> >> >       sock_put(&vsk->sk);
> >> > }
> >> >
> >> >-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *ad=
dr)
> >> >+static struct sock *vsock_find_bound_socket_common(struct sockaddr_v=
m *addr,
> >> >+                                                 struct list_head *b=
ind_table)
> >> > {
> >> >       struct vsock_sock *vsk;
> >> >
> >> >-      list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_tabl=
e) {
> >> >+      list_for_each_entry(vsk, bind_table, bound_table) {
> >> >               if (vsock_addr_equals_addr(addr, &vsk->local_addr))
> >> >                       return sk_vsock(vsk);
> >> >
> >> >@@ -249,6 +250,11 @@ static struct sock *__vsock_find_bound_socket(st=
ruct sockaddr_vm *addr)
> >> >       return NULL;
> >> > }
> >> >
> >> >+static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *ad=
dr)
> >> >+{
> >> >+      return vsock_find_bound_socket_common(addr, vsock_bound_socket=
s(addr));
> >> >+}
> >> >+
> >> > static struct sock *__vsock_find_connected_socket(struct sockaddr_vm=
 *src,
> >> >                                                 struct sockaddr_vm *=
dst)
> >> > {
> >> >@@ -671,12 +677,18 @@ static void vsock_pending_work(struct work_stru=
ct *work)
> >> >
> >> > /**** SOCKET OPERATIONS ****/
> >> >
> >> >-static int __vsock_bind_connectible(struct vsock_sock *vsk,
> >> >-                                  struct sockaddr_vm *addr)
> >> >+static int vsock_bind_common(struct vsock_sock *vsk,
> >> >+                           struct sockaddr_vm *addr,
> >> >+                           struct list_head *bind_table,
> >> >+                           size_t table_size)
> >> > {
> >> >       static u32 port;
> >> >       struct sockaddr_vm new_addr;
> >> >
> >> >+      if (WARN_ONCE(table_size < VSOCK_HASH_SIZE,
> >> >+                    "table size too small, may cause overflow"))
> >> >+              return -EINVAL;
> >> >+
> >>
> >> I'd add this in another commit.
> >>
> >> >       if (!port)
> >> >               port =3D get_random_u32_above(LAST_RESERVED_PORT);
> >> >
> >> >@@ -692,7 +704,8 @@ static int __vsock_bind_connectible(struct
> >> >vsock_sock *vsk,
> >> >
> >> >                       new_addr.svm_port =3D port++;
> >> >
> >> >-                      if (!__vsock_find_bound_socket(&new_addr)) {
> >> >+                      if (!vsock_find_bound_socket_common(&new_addr,
> >> >+                                                          &bind_tabl=
e[VSOCK_HASH(addr)])) {
> >>
> >> Can we add a macro for `&bind_table[VSOCK_HASH(addr)])` ?
> >>
> >
> >Definitely. I will add the following macro:
> >
> >#define vsock_bound_sockets_in_table(bind_table, addr) \
> >        (&bind_table[VSOCK_HASH(addr)])
>
> yeah.
>
> >
> >> >                               found =3D true;
> >> >                               break;
> >> >                       }
> >> >@@ -709,7 +722,8 @@ static int __vsock_bind_connectible(struct vsock_=
sock *vsk,
> >> >                       return -EACCES;
> >> >               }
> >> >
> >> >-              if (__vsock_find_bound_socket(&new_addr))
> >> >+              if (vsock_find_bound_socket_common(&new_addr,
> >> >+                                                 &bind_table[VSOCK_H=
ASH(addr)]))
> >> >                       return -EADDRINUSE;
> >> >       }
> >> >
> >> >@@ -721,11 +735,17 @@ static int __vsock_bind_connectible(struct vsoc=
k_sock *vsk,
> >> >        * by AF_UNIX.
> >> >        */
> >> >       __vsock_remove_bound(vsk);
> >> >-      __vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vs=
k);
> >> >+      __vsock_insert_bound(&bind_table[VSOCK_HASH(&vsk->local_addr)]=
, vsk);
> >> >
> >> >       return 0;
> >> > }
> >> >
> >> >+static int __vsock_bind_connectible(struct vsock_sock *vsk,
> >> >+                                  struct sockaddr_vm *addr)
> >> >+{
> >> >+      return vsock_bind_common(vsk, addr, vsock_bind_table, VSOCK_HA=
SH_SIZE + 1);
> >>
> >> What about using ARRAY_SIZE(x) ?
> >>
> >> BTW we are using that size just to check it, but all the arrays we use
> >> are statically allocated, so what about a compile time check like
> >> BUILD_BUG_ON()?
> >>
> >
> >I will remove the table_size check you mentioned earlier and the
> >argument here as the arrays are allocated statically like you
> >mentioned.
> >
> >If you think this check may be a good addition, I can add a
> >BUILD_BUG_ON() in the new vsock_bound_sockets_in_table() macro.
>
> If you want to add it, we need to do it in a separate commit. But since
> we already have so many changes and both arrays are statically allocated
> in the same file, IMHO we can avoid the check.
>
> Stefano
>

Okay. I will not add the check.

Thanks,
Amery


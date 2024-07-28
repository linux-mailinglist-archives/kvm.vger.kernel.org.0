Return-Path: <kvm+bounces-22471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5543E93E8F0
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 20:53:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD786B20FE4
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 18:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90FF5757EB;
	Sun, 28 Jul 2024 18:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJ6Fzakj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5AA53AC;
	Sun, 28 Jul 2024 18:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722192787; cv=none; b=OQ1hAqWRvXgxjw1Dr7H9PtKPISQwSYPDQRrgS1/9CHxVgXdWwVSdgDm9YX/zSyq3MaCxDrL3JW4zSgMpkFcjU6ZOIu33doftl+9aV/CjKrCkOA2nGeXHtDDMvSblODfHzc8Ecp7HpO7KHYOUnijnX5L78hXbICoLX8iQFVyK3bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722192787; c=relaxed/simple;
	bh=PPREMhC5736ADe8UjUj7yOVHwR1uO6w7vYqpo8l6SzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lftrWYSO+Op+FpE61rq4PDzqKXK+vN1ZF2z8P038t679OwSLKANIxQlfQeqY67SsXAYdQs08dJNxt+mm7IwYHi4wDeXzQHv/GPic3OFzi/ROtMHHXKcWHm0q92Vikue2+L6uzoFIKhpDTp97XNWqe2HpV0gEcHZH0SqKZbADrSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJ6Fzakj; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e0875778facso1207688276.3;
        Sun, 28 Jul 2024 11:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722192785; x=1722797585; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+WaFwUhUy7huwacOsYHZwdSyihUsKnDhkCHGxr+gg2M=;
        b=RJ6FzakjqLqJvGSjc4irmshpPsI+/KrXGgxVErb/pvnTMvk3JfWZ+qi9d54Pxn3cuA
         mcBDDMaxWyPZVTa+FhpbcYnL/f12HSDBLvfkq/vgfRbzMpYTcDzGXvkfZGBZVmyZs8nR
         gWtwxwDi4e4jujYJ62Urecih/rSrkVCeQRtJdWnVuNftH4w+XTge0LzwyOi0QpIMmRC9
         knTGCU0r2jOs6SuGlhsi3Wf3gzn1fBAoY5YaS6r9FzxlKjkJBrgQSz8j8scqXPMPALJC
         xrwjjdJ7rjD6GGuoygLjnYCXWuJHvsscFyQFg1JP7mN4w+tiEwXu8lmeAEpdwrgVJ4EV
         q/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722192785; x=1722797585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+WaFwUhUy7huwacOsYHZwdSyihUsKnDhkCHGxr+gg2M=;
        b=pEOQbBVdyBYtF/U4tckeCXaz5ejZW4igLwhG34+Hv7ZP3TwkBLjJEPcmqfvSSssL1q
         f7HRPScmmAfOzZ4+WmaG197E3O1ez2904GqwC3Gs9xu0oNnKwy7csRFRSd9vJ0Q1DgNl
         Zq4+t0825kGzxemmZGGb2gwax0Vvm/6zBickrLJZsuDsHd0SpNG5ZGghfamB5hDsPKLl
         nYFHvhPjSrkO/113PREbi7n93Vm62ZG9w/7LpSQJzKDdYUfMVez7ienUSTaistyF71wQ
         9RAsU5ZrqmxMvhxrLji73NwbMcCh0dm2jg6YsK89bOk6IwJjAYQ3014GbzwngtoGGiut
         DBEg==
X-Forwarded-Encrypted: i=1; AJvYcCW3ekoQHL5W86kEZYxnfa3ZmdTcjFs06BsBIfIu1Q97FDiq0FaFi9kutlQ9F08Q31hBbR58s7x7Ugx9EN2QjVdWV0UFoxYMx8TolFP5MUPRptTWKEX9P0To1eW3oXp27fKZ9AiltsWXdMXOxBEOrPO2FHWAEF/OB6p00rerRXqy21q3ArcQuXLv+coX+ZYl4L31WVSpoL+ETPjF09CoutzCRXTQioVbePnwv9iz
X-Gm-Message-State: AOJu0YwARApF2BQBlv2nchwk0RRGv8kpiHXUe1uxwDAxfPT2C96N1W44
	DC/aFqfHz3gC7Kb2aM8qnqidbl6H1ezwA7zpCJlESb5SIZH0CmUEtFyu18zLiGG7Vkq8bVnlEGb
	b+K7bhLblXUsZ/NU4eSRTGC8kRds=
X-Google-Smtp-Source: AGHT+IFTRoCPd34HHWfTgIQNU+sTEkr3o4CgrkzGKLra2JgW08IJHV2eZgSUAorTK4dr8M4YsaVo8uy6TqxmtUJfv/0=
X-Received: by 2002:a25:854f:0:b0:e08:70e7:91d3 with SMTP id
 3f1490d57ef6-e0b546070aamr5384474276.56.1722192784965; Sun, 28 Jul 2024
 11:53:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
 <20240710212555.1617795-5-amery.hung@bytedance.com> <CAGxU2F7wCUR-KhDRBopK+0gv=bM0PCKeWM87j1vEYmbvhO8WHQ@mail.gmail.com>
In-Reply-To: <CAGxU2F7wCUR-KhDRBopK+0gv=bM0PCKeWM87j1vEYmbvhO8WHQ@mail.gmail.com>
From: Amery Hung <ameryhung@gmail.com>
Date: Sun, 28 Jul 2024 11:52:54 -0700
Message-ID: <CAMB2axNUZa221WKTjLt0G5KNdtkAbm20ViDZRGBh6pL9y3wosg@mail.gmail.com>
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

On Tue, Jul 23, 2024 at 7:40=E2=80=AFAM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Wed, Jul 10, 2024 at 09:25:45PM GMT, Amery Hung wrote:
> >From: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >
> >This commit makes the bind table management functions in vsock usable
> >for different bind tables. Future work will introduce a new table for
> >datagrams to avoid address collisions, and these functions will be used
> >there.
> >
> >Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >---
> > net/vmw_vsock/af_vsock.c | 34 +++++++++++++++++++++++++++-------
> > 1 file changed, 27 insertions(+), 7 deletions(-)
> >
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index acc15e11700c..d571be9cdbf0 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -232,11 +232,12 @@ static void __vsock_remove_connected(struct vsock_=
sock *vsk)
> >       sock_put(&vsk->sk);
> > }
> >
> >-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> >+static struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *=
addr,
> >+                                                 struct list_head *bind=
_table)
> > {
> >       struct vsock_sock *vsk;
> >
> >-      list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) =
{
> >+      list_for_each_entry(vsk, bind_table, bound_table) {
> >               if (vsock_addr_equals_addr(addr, &vsk->local_addr))
> >                       return sk_vsock(vsk);
> >
> >@@ -249,6 +250,11 @@ static struct sock *__vsock_find_bound_socket(struc=
t sockaddr_vm *addr)
> >       return NULL;
> > }
> >
> >+static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> >+{
> >+      return vsock_find_bound_socket_common(addr, vsock_bound_sockets(a=
ddr));
> >+}
> >+
> > static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *s=
rc,
> >                                                 struct sockaddr_vm *dst=
)
> > {
> >@@ -671,12 +677,18 @@ static void vsock_pending_work(struct work_struct =
*work)
> >
> > /**** SOCKET OPERATIONS ****/
> >
> >-static int __vsock_bind_connectible(struct vsock_sock *vsk,
> >-                                  struct sockaddr_vm *addr)
> >+static int vsock_bind_common(struct vsock_sock *vsk,
> >+                           struct sockaddr_vm *addr,
> >+                           struct list_head *bind_table,
> >+                           size_t table_size)
> > {
> >       static u32 port;
> >       struct sockaddr_vm new_addr;
> >
> >+      if (WARN_ONCE(table_size < VSOCK_HASH_SIZE,
> >+                    "table size too small, may cause overflow"))
> >+              return -EINVAL;
> >+
>
> I'd add this in another commit.
>
> >       if (!port)
> >               port =3D get_random_u32_above(LAST_RESERVED_PORT);
> >
> >@@ -692,7 +704,8 @@ static int __vsock_bind_connectible(struct
> >vsock_sock *vsk,
> >
> >                       new_addr.svm_port =3D port++;
> >
> >-                      if (!__vsock_find_bound_socket(&new_addr)) {
> >+                      if (!vsock_find_bound_socket_common(&new_addr,
> >+                                                          &bind_table[V=
SOCK_HASH(addr)])) {
>
> Can we add a macro for `&bind_table[VSOCK_HASH(addr)])` ?
>

Definitely. I will add the following macro:

#define vsock_bound_sockets_in_table(bind_table, addr) \
        (&bind_table[VSOCK_HASH(addr)])

> >                               found =3D true;
> >                               break;
> >                       }
> >@@ -709,7 +722,8 @@ static int __vsock_bind_connectible(struct vsock_soc=
k *vsk,
> >                       return -EACCES;
> >               }
> >
> >-              if (__vsock_find_bound_socket(&new_addr))
> >+              if (vsock_find_bound_socket_common(&new_addr,
> >+                                                 &bind_table[VSOCK_HASH=
(addr)]))
> >                       return -EADDRINUSE;
> >       }
> >
> >@@ -721,11 +735,17 @@ static int __vsock_bind_connectible(struct vsock_s=
ock *vsk,
> >        * by AF_UNIX.
> >        */
> >       __vsock_remove_bound(vsk);
> >-      __vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vsk);
> >+      __vsock_insert_bound(&bind_table[VSOCK_HASH(&vsk->local_addr)], v=
sk);
> >
> >       return 0;
> > }
> >
> >+static int __vsock_bind_connectible(struct vsock_sock *vsk,
> >+                                  struct sockaddr_vm *addr)
> >+{
> >+      return vsock_bind_common(vsk, addr, vsock_bind_table, VSOCK_HASH_=
SIZE + 1);
>
> What about using ARRAY_SIZE(x) ?
>
> BTW we are using that size just to check it, but all the arrays we use
> are statically allocated, so what about a compile time check like
> BUILD_BUG_ON()?
>

I will remove the table_size check you mentioned earlier and the
argument here as the arrays are allocated statically like you
mentioned.

If you think this check may be a good addition, I can add a
BUILD_BUG_ON() in the new vsock_bound_sockets_in_table() macro.

Thanks,
Amery

> Thanks,
> Stefano
>
>
> >+}
> >+
> > static int __vsock_bind_dgram(struct vsock_sock *vsk,
> >                             struct sockaddr_vm *addr)
> > {
> >--
> >2.20.1
> >
>


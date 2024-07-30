Return-Path: <kvm+bounces-22611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B62940AA4
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0AE32812C0
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E305194121;
	Tue, 30 Jul 2024 08:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S47sM72U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F7418784F
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722326439; cv=none; b=P1fjd15uV/7jJ5h4i6j/nOuRpfptlYTM1k9o6P7UBf4ZBZZ51DNWIyJIFlI8sOkXEKB2xT8lwTbYTPcwlEOrkZXwSrVYxzTrmdnuCvPEPybXXMh8UUlNTPUxG/a8RcnvvJpPlW3ce1gtAYLXR6+ABunyERWPYZdO3Bc6U1KtE48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722326439; c=relaxed/simple;
	bh=trwZ6o7rehpDaqVsUVCfcq0HbmYKcWR5iz0dYHW4Jrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fo1vDFM3a5YofjL4bSA+rz8ORG9nKFuZmeHbZk0fQv4QioGt94YRdcUp6LhL0Wd7tza4CLULy//mADr9xZiqmEOuAMbamrjjoFkqem9JWQwA4F5Wylst7EXpYBTW/i/M/WJFmYa+YwKxfj9z8v97h3YdjnEHSOItfaUdl7CyibQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S47sM72U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722326435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pxacbdL3FJeAXrV3TFbvw9W3EhUwqie1OGKtk+yVIvU=;
	b=S47sM72UIlg9yO0YdG/U42nACtwvmaW12HbD87lMMbWSZFbwcaWcBxdKeAq1CcYLzNoryX
	zXFcir9nnfpNHzrSJFQq8zdZqu395HwWqCVJ84NamkKmLZQnGuO3Ob3vGPSX6ONqDp1iZH
	Uz+Bw5lfzdufkUp+0zZooIfQ2A4Yjco=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-f6ChnipWMNWZp2t-8diMKQ-1; Tue, 30 Jul 2024 04:00:32 -0400
X-MC-Unique: f6ChnipWMNWZp2t-8diMKQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4280d8e685eso25054655e9.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 01:00:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722326431; x=1722931231;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxacbdL3FJeAXrV3TFbvw9W3EhUwqie1OGKtk+yVIvU=;
        b=wjsox8QUA819m9bqbPCixIybUlLELM4xLRSmZLFHZFVijIwrDLsJh+hzVGVlE1X9W5
         fdzNVdJQYanbaCG/nvO9sca7n3TMtuRALQjyW6mwRA0dIDYnsMoPezh0LlO3fp+mum9S
         hXWd16JHshgAnAubD2AZqpcpjVmEE0kJNpAFbUBijTPfN+Mwm0IcclOmCenUL/7o0fYJ
         2VkuY+V6I3AI0/QXc7I8be5AGKTlN6I6SeTpu0F/FcpSrgscceY44/IYSltXpbKTKf3/
         2hViR861vfSbnGT/hn9JZE1yHYQa4ZReavgs7H9aRuOXOagTypVY1IPk+WD2cBeoFE7S
         GWBA==
X-Forwarded-Encrypted: i=1; AJvYcCV1uKer4xMuTw6Av/VTtb+2+7XD1WcKaKdpbzMd/LVV6DfW7LJ5ndTQ1kYp/m6HDG/gFKc1VJJWGVEpWtXYhehGUvad
X-Gm-Message-State: AOJu0YzqVhnrZcOfT8XR52LxX9PgDI3ZYgzwcQ64pkQzL5fP4Smy3dIb
	AXmRBE/+3VxEqY4FYiiK1Q5ENrmGWRG5Om2D53STqtkJs7HHNTjuI3/X8QybuA4XDij0lqv4wXL
	HDksVR0aDF/04CTEe++3wVjgt36iXJrloNZybWHAQzIqrvyPAzQ==
X-Received: by 2002:a05:600c:1c83:b0:426:622d:9e6b with SMTP id 5b1f17b1804b1-42811dd79fbmr66276895e9.23.1722326430682;
        Tue, 30 Jul 2024 01:00:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOWCFqW/SaDwkVD/PGge9k+/l+vMiylzg43IopSMzOrTgQOVgmPKCvBcKQbTb1kZSxSstYJw==
X-Received: by 2002:a05:600c:1c83:b0:426:622d:9e6b with SMTP id 5b1f17b1804b1-42811dd79fbmr66276385e9.23.1722326429913;
        Tue, 30 Jul 2024 01:00:29 -0700 (PDT)
Received: from sgarzare-redhat ([62.205.9.89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b36857e3bsm13973574f8f.81.2024.07.30.01.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 01:00:28 -0700 (PDT)
Date: Tue, 30 Jul 2024 10:00:25 +0200
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
Subject: Re: [RFC PATCH net-next v6 04/14] af_vsock: generalize bind table
 functions
Message-ID: <ba2hivznnjcyeftr7ch7gvrwjvkimx5u2t2anv7wv7n7yb3j36@dbagnaylvu6o>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
 <20240710212555.1617795-5-amery.hung@bytedance.com>
 <CAGxU2F7wCUR-KhDRBopK+0gv=bM0PCKeWM87j1vEYmbvhO8WHQ@mail.gmail.com>
 <CAMB2axNUZa221WKTjLt0G5KNdtkAbm20ViDZRGBh6pL9y3wosg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMB2axNUZa221WKTjLt0G5KNdtkAbm20ViDZRGBh6pL9y3wosg@mail.gmail.com>

On Sun, Jul 28, 2024 at 11:52:54AM GMT, Amery Hung wrote:
>On Tue, Jul 23, 2024 at 7:40 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Wed, Jul 10, 2024 at 09:25:45PM GMT, Amery Hung wrote:
>> >From: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> >
>> >This commit makes the bind table management functions in vsock usable
>> >for different bind tables. Future work will introduce a new table for
>> >datagrams to avoid address collisions, and these functions will be used
>> >there.
>> >
>> >Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> >---
>> > net/vmw_vsock/af_vsock.c | 34 +++++++++++++++++++++++++++-------
>> > 1 file changed, 27 insertions(+), 7 deletions(-)
>> >
>> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> >index acc15e11700c..d571be9cdbf0 100644
>> >--- a/net/vmw_vsock/af_vsock.c
>> >+++ b/net/vmw_vsock/af_vsock.c
>> >@@ -232,11 +232,12 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
>> >       sock_put(&vsk->sk);
>> > }
>> >
>> >-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>> >+static struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *addr,
>> >+                                                 struct list_head *bind_table)
>> > {
>> >       struct vsock_sock *vsk;
>> >
>> >-      list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
>> >+      list_for_each_entry(vsk, bind_table, bound_table) {
>> >               if (vsock_addr_equals_addr(addr, &vsk->local_addr))
>> >                       return sk_vsock(vsk);
>> >
>> >@@ -249,6 +250,11 @@ static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>> >       return NULL;
>> > }
>> >
>> >+static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>> >+{
>> >+      return vsock_find_bound_socket_common(addr, vsock_bound_sockets(addr));
>> >+}
>> >+
>> > static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
>> >                                                 struct sockaddr_vm *dst)
>> > {
>> >@@ -671,12 +677,18 @@ static void vsock_pending_work(struct work_struct *work)
>> >
>> > /**** SOCKET OPERATIONS ****/
>> >
>> >-static int __vsock_bind_connectible(struct vsock_sock *vsk,
>> >-                                  struct sockaddr_vm *addr)
>> >+static int vsock_bind_common(struct vsock_sock *vsk,
>> >+                           struct sockaddr_vm *addr,
>> >+                           struct list_head *bind_table,
>> >+                           size_t table_size)
>> > {
>> >       static u32 port;
>> >       struct sockaddr_vm new_addr;
>> >
>> >+      if (WARN_ONCE(table_size < VSOCK_HASH_SIZE,
>> >+                    "table size too small, may cause overflow"))
>> >+              return -EINVAL;
>> >+
>>
>> I'd add this in another commit.
>>
>> >       if (!port)
>> >               port = get_random_u32_above(LAST_RESERVED_PORT);
>> >
>> >@@ -692,7 +704,8 @@ static int __vsock_bind_connectible(struct
>> >vsock_sock *vsk,
>> >
>> >                       new_addr.svm_port = port++;
>> >
>> >-                      if (!__vsock_find_bound_socket(&new_addr)) {
>> >+                      if (!vsock_find_bound_socket_common(&new_addr,
>> >+                                                          &bind_table[VSOCK_HASH(addr)])) {
>>
>> Can we add a macro for `&bind_table[VSOCK_HASH(addr)])` ?
>>
>
>Definitely. I will add the following macro:
>
>#define vsock_bound_sockets_in_table(bind_table, addr) \
>        (&bind_table[VSOCK_HASH(addr)])

yeah.

>
>> >                               found = true;
>> >                               break;
>> >                       }
>> >@@ -709,7 +722,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>> >                       return -EACCES;
>> >               }
>> >
>> >-              if (__vsock_find_bound_socket(&new_addr))
>> >+              if (vsock_find_bound_socket_common(&new_addr,
>> >+                                                 &bind_table[VSOCK_HASH(addr)]))
>> >                       return -EADDRINUSE;
>> >       }
>> >
>> >@@ -721,11 +735,17 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>> >        * by AF_UNIX.
>> >        */
>> >       __vsock_remove_bound(vsk);
>> >-      __vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vsk);
>> >+      __vsock_insert_bound(&bind_table[VSOCK_HASH(&vsk->local_addr)], vsk);
>> >
>> >       return 0;
>> > }
>> >
>> >+static int __vsock_bind_connectible(struct vsock_sock *vsk,
>> >+                                  struct sockaddr_vm *addr)
>> >+{
>> >+      return vsock_bind_common(vsk, addr, vsock_bind_table, VSOCK_HASH_SIZE + 1);
>>
>> What about using ARRAY_SIZE(x) ?
>>
>> BTW we are using that size just to check it, but all the arrays we use
>> are statically allocated, so what about a compile time check like
>> BUILD_BUG_ON()?
>>
>
>I will remove the table_size check you mentioned earlier and the
>argument here as the arrays are allocated statically like you
>mentioned.
>
>If you think this check may be a good addition, I can add a
>BUILD_BUG_ON() in the new vsock_bound_sockets_in_table() macro.

If you want to add it, we need to do it in a separate commit. But since 
we already have so many changes and both arrays are statically allocated 
in the same file, IMHO we can avoid the check.

Stefano



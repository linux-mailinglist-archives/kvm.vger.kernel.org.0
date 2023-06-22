Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E8E73A4E3
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 17:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjFVP1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 11:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjFVP1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 11:27:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D6E2127
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 08:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687447576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s9naFD7gfaMNd05hAGGf5tsGc4tvi4lWlW620oNdE7s=;
        b=fzMt9IwcIUQnQEZbCqiEgUUeGOdy9QykP8hfEH2VugEp2mhiht0ufh4AUB2mlxiekzje3K
        vsVTWLMXYOQk8ef7liU/KNwfpts6FQXKE3AnSRq0/t0rvDbiaz+KO/gBLpvUMVgsRVN0eQ
        Hwlin8VBr8xNrqIa+4MkKuRqdKxbjME=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-6Yggl3LaPkOBd2Lv4sg8hQ-1; Thu, 22 Jun 2023 11:26:05 -0400
X-MC-Unique: 6Yggl3LaPkOBd2Lv4sg8hQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f42bcef2acso30384735e9.2
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 08:26:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687447559; x=1690039559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s9naFD7gfaMNd05hAGGf5tsGc4tvi4lWlW620oNdE7s=;
        b=h+2N+QYS7i2NmqaVyHkjtkBKI378K85yKViKrt7X3ic7YF1cKYRBHLItX223qksWUl
         GDb4B4pZb/u6mxHkVuP4NGHZ9F96Gc/ep/KH/rpK8d/KVhGe/ZSwAJ6dL+A6oycGseXD
         aQMVNfPvZ/arkNsxA6bl3AVt1FJPEj4/+sooOXGCYM40VprJFUircKuj+C5A/hb87cZF
         o+PmH7Wqne9BGHHSxf3NQzY3jEdMzZDjdlaSInR/5WbHkfgDRO13pBkCJinbDBFiJOcV
         B8wmb0i0WaAwph7/gcGJ9mbCVOHcU34Yb2sYOL960NMFzXGXAh+TNdnG4iZk9su870tk
         Ia9Q==
X-Gm-Message-State: AC+VfDyKQwaCNo5hfBwNmOwreWwnaS9v+MIZaSuK0woBwfDfoyTQqzRl
        qcippVWGG+LfYh/SZE9qhQOeQuS1AoNgdLPgBg/CIxo2mNq4kdiRO6NOS4XghwGxkvzjHAMo/oH
        P3l6SHewiTFpB
X-Received: by 2002:a7b:cb90:0:b0:3f9:c2f6:335 with SMTP id m16-20020a7bcb90000000b003f9c2f60335mr3570367wmi.36.1687447559670;
        Thu, 22 Jun 2023 08:25:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5yc3YiqgFnTK1MzlExfaEms+r4U/DMqe75/V1PK4F+LuHCCZzMXuAmW0ik7zmWglpxBefjHA==
X-Received: by 2002:a7b:cb90:0:b0:3f9:c2f6:335 with SMTP id m16-20020a7bcb90000000b003f9c2f60335mr3570346wmi.36.1687447559371;
        Thu, 22 Jun 2023 08:25:59 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id n20-20020a1c7214000000b003f8d85b481esm19011755wmc.21.2023.06.22.08.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 08:25:58 -0700 (PDT)
Date:   Thu, 22 Jun 2023 17:25:55 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
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
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC net-next v4 4/8] vsock: make vsock bind reusable
Message-ID: <p2tgn3wczd3t3dodyicczetr2nqnqpwcadz6ql5hpvg2cd2dxa@phheksxhxfna>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-4-0cebbb2ae899@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v4-4-0cebbb2ae899@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 10, 2023 at 12:58:31AM +0000, Bobby Eshleman wrote:
>This commit makes the bind table management functions in vsock usable
>for different bind tables. For use by datagrams in a future patch.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> net/vmw_vsock/af_vsock.c | 33 ++++++++++++++++++++++++++-------
> 1 file changed, 26 insertions(+), 7 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index ef86765f3765..7a3ca4270446 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -230,11 +230,12 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
> 	sock_put(&vsk->sk);
> }
>
>-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>+struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *addr,
>+					    struct list_head *bind_table)
> {
> 	struct vsock_sock *vsk;
>
>-	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
>+	list_for_each_entry(vsk, bind_table, bound_table) {
> 		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
> 			return sk_vsock(vsk);
>
>@@ -247,6 +248,11 @@ static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> 	return NULL;
> }
>
>+static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>+{
>+	return vsock_find_bound_socket_common(addr, vsock_bound_sockets(addr));
>+}
>+
> static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
> 						  struct sockaddr_vm *dst)
> {
>@@ -646,12 +652,17 @@ static void vsock_pending_work(struct work_struct *work)
>
> /**** SOCKET OPERATIONS ****/
>
>-static int __vsock_bind_connectible(struct vsock_sock *vsk,
>-				    struct sockaddr_vm *addr)
>+static int vsock_bind_common(struct vsock_sock *vsk,
>+			     struct sockaddr_vm *addr,
>+			     struct list_head *bind_table,
>+			     size_t table_size)
> {
> 	static u32 port;
> 	struct sockaddr_vm new_addr;
>
>+	if (table_size < VSOCK_HASH_SIZE)
>+		return -1;

Why we need this check now?

>+
> 	if (!port)
> 		port = get_random_u32_above(LAST_RESERVED_PORT);
>
>@@ -667,7 +678,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>
> 			new_addr.svm_port = port++;
>
>-			if (!__vsock_find_bound_socket(&new_addr)) {
>+			if (!vsock_find_bound_socket_common(&new_addr,
>+							    &bind_table[VSOCK_HASH(addr)])) {
> 				found = true;
> 				break;
> 			}
>@@ -684,7 +696,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> 			return -EACCES;
> 		}
>
>-		if (__vsock_find_bound_socket(&new_addr))
>+		if (vsock_find_bound_socket_common(&new_addr,
>+						   &bind_table[VSOCK_HASH(addr)]))
> 			return -EADDRINUSE;
> 	}
>
>@@ -696,11 +709,17 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> 	 * by AF_UNIX.
> 	 */
> 	__vsock_remove_bound(vsk);
>-	__vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vsk);
>+	__vsock_insert_bound(&bind_table[VSOCK_HASH(&vsk->local_addr)], vsk);
>
> 	return 0;
> }
>
>+static int __vsock_bind_connectible(struct vsock_sock *vsk,
>+				    struct sockaddr_vm *addr)
>+{
>+	return vsock_bind_common(vsk, addr, vsock_bind_table, VSOCK_HASH_SIZE + 1);
>+}
>+
> static int __vsock_bind_dgram(struct vsock_sock *vsk,
> 			      struct sockaddr_vm *addr)
> {
>
>-- 
>2.30.2
>

The rest seems okay to me, but I agree with Simon's suggestion.

Stefano


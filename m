Return-Path: <kvm+bounces-44882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80800AA4759
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:37:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D02197B2CC1
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 09:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DDB62356D3;
	Wed, 30 Apr 2025 09:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N42GECj3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BF8235072
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746005811; cv=none; b=P1QJjjd1mg9SeETM/IOM/tifhUE9KP39W5TB/ifnHKLzNQluEjGvOmyb6Q5ZiU9cTZD1WxFiXuoLLMFu4sWlUb52f5vh1fbSY3022wdKxlY+s4jCvC9MW2Cv8ivK5XEeKjgbTZV8IvXCNQQ5jfwfNMFdKu8J3YXQFDcQFPi+jd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746005811; c=relaxed/simple;
	bh=5Ocuw4e8b8MCvcgZG8tAmtt1ISXlU0QTVvz2XLE1ZV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1o4QJttePJvhvmKADNlvWSn0CqQovUrRo7xmtTLrN/wSeY726nlTWgY7wSahxlt0bbN3JbVsbjmZwDmWF2ofL8YpUX64j+lc7KrugyI3xW4NaUR+adRt1ijfrH4qp5vfbK5hf/lKbW5dNJ+nKg5V//epIAKShVxpUQb9sy66HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N42GECj3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746005809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PklXpf2mtZZMeIyH7dbSdoSYGX/kozHo8SVimCxZe+I=;
	b=N42GECj3sg0Sz29eLBuQj/uOvOjzezcs+2NptComHwGSHi3WwGwX6bW+2crb6smLpTTO6m
	7LEuk8QFa9qDNDTHni7W/bAxWVSq+YjEQj4bDsqF66L+8QtThth0HxC+wYzH9mcdXf4brp
	is+BdxnXaHj3mmmLIsbT8qYPK1v82KM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-WugmHWneOhqvcJqjKktM1g-1; Wed, 30 Apr 2025 05:36:47 -0400
X-MC-Unique: WugmHWneOhqvcJqjKktM1g-1
X-Mimecast-MFC-AGG-ID: WugmHWneOhqvcJqjKktM1g_1746005806
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5f620c5f8e4so7155604a12.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 02:36:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746005806; x=1746610606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PklXpf2mtZZMeIyH7dbSdoSYGX/kozHo8SVimCxZe+I=;
        b=blHbbAYB+GRlDWf/vvezK3Ct6cnT2JxOFyYSP5o6zc2+CwEHemAHz1euyzFZU8m674
         862zJ1+Io4jfbTTI/OoHUI+SS7SZsOAHXwX9FBS/PapbHPSVud/oZ+sSJRVesNCZV/mU
         NLA9vwRdQ9QDIzus4OLcxerxSM4aM8K84p0MFFn0xW2/usKSRsDdPgATcsrgF76bTHzI
         HMggpLMiGOrhFtq+E+TFWO08rz5votspbxMqwimf+AWean3YdRzKJzMtmpRQySP9V4BQ
         6QbUqCm0ikJZLrUk1onvg/fwZfFT9ersAgXHCbs82SyVIlqqC10VCCE3jCdahWvfkcrj
         MN5Q==
X-Forwarded-Encrypted: i=1; AJvYcCURF5PFrBoOZzG85HBAb4RKstMi+pkWl744eud7z20sXvlai5Y0L46kyPYAQVbRFYd45DA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBNWKouE//YstHCc3H6L5r7XJidkv84mjmB7NHpXxmG9FMXuyz
	K6SkiimjgAupkV778+koH1EfJ3Z2hJuGQJCJZbd+1dhGN/TpkCLuVt0/Z5b0u3Mnz+O+t1VqQe1
	UyeFDXGWiQgVr61xpf6dz3ARidTfKOKyy7YWyQ5GMvuxhD51T4A==
X-Gm-Gg: ASbGncshXku+hw5ojtpS03HcgnJzEqbdRLRPw2rA/nalOseCnNBSaYWN9dpQm94LTE4
	0oDRS6zV5t6JAiNZdJB+Pj1SZptotz2r2f8anN73sBhLzVmrsMaqE3xQeu/pXY70J+5ROelTTzT
	9RHylphZmAqhGvs1PtPGWD018pzf1YP289ZUPaiHkf7GB6uhcXC+jehLoLk7MLxtm/qqn9EVESK
	m8MBN0avnnljuqrVIZPb/bVpBdxOD83wCsywdnD/TZr1Wf5fPhbpaA7aoZ0JXG/hoowT8NzQBHu
	raF21sLyaPvQRWUv9Q==
X-Received: by 2002:a05:6402:2709:b0:5f0:48df:25ae with SMTP id 4fb4d7f45d1cf-5f89ab673f7mr1878505a12.2.1746005806207;
        Wed, 30 Apr 2025 02:36:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHof0+CLIrQBgrHPd0uIgVEPaVcOjpvBaOfPCPKfVxm8p9SM0QtTIrzlcOdGN1NnRYvxDRhEg==
X-Received: by 2002:a05:6402:2709:b0:5f0:48df:25ae with SMTP id 4fb4d7f45d1cf-5f89ab673f7mr1878477a12.2.1746005805553;
        Wed, 30 Apr 2025 02:36:45 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.220.254])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7013fef5esm8463493a12.18.2025.04.30.02.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 02:36:44 -0700 (PDT)
Date: Wed, 30 Apr 2025 11:36:30 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] vsock: Move lingering logic to af_vsock
 core
Message-ID: <oo5tmbu7okyqojwxt4xked4jvq6jqydrddowspz3p66nsjzajt@36mxuduci4am>
References: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
 <20250430-vsock-linger-v3-3-ddbe73b53457@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250430-vsock-linger-v3-3-ddbe73b53457@rbox.co>

On Wed, Apr 30, 2025 at 11:10:29AM +0200, Michal Luczaj wrote:
>Lingering should be transport-independent in the long run. In preparation
>for supporting other transports, as well the linger on shutdown(), move
>code to core.
>
>Guard against an unimplemented vsock_transport::unsent_bytes() callback.
>
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> include/net/af_vsock.h                  |  1 +
> net/vmw_vsock/af_vsock.c                | 25 +++++++++++++++++++++++++
> net/vmw_vsock/virtio_transport_common.c | 23 +----------------------
> 3 files changed, 27 insertions(+), 22 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 9e85424c834353d016a527070dd62e15ff3bfce1..bd8b88d70423051dd05fc445fe37971af631ba03 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -221,6 +221,7 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
> 				     void (*fn)(struct sock *sk));
> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
> bool vsock_find_cid(unsigned int cid);
>+void vsock_linger(struct sock *sk, long timeout);
>
> /**** TAP ****/
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index fc6afbc8d6806a4d98c66abc3af4bd139c583b08..946b37de679a0e68b84cd982a3af2a959c60ee57 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1013,6 +1013,31 @@ static int vsock_getname(struct socket *sock,
> 	return err;
> }
>
>+void vsock_linger(struct sock *sk, long timeout)
>+{
>+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>+	ssize_t (*unsent)(struct vsock_sock *vsk);
>+	struct vsock_sock *vsk = vsock_sk(sk);
>+
>+	if (!timeout)
>+		return;
>+
>+	/* unsent_bytes() may be unimplemented. */
>+	unsent = vsk->transport->unsent_bytes;
>+	if (!unsent)
>+		return;
>+
>+	add_wait_queue(sk_sleep(sk), &wait);
>+
>+	do {
>+		if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
>+			break;
>+	} while (!signal_pending(current) && timeout);
>+
>+	remove_wait_queue(sk_sleep(sk), &wait);
>+}
>+EXPORT_SYMBOL_GPL(vsock_linger);
>+
> static int vsock_shutdown(struct socket *sock, int mode)
> {
> 	int err;
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 4425802c5d718f65aaea425ea35886ad64e2fe6e..9230b8358ef2ac1f6e72a5961bae39f9093c8884 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1192,27 +1192,6 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
> 	vsock_remove_sock(vsk);
> }
>
>-static void virtio_transport_wait_close(struct sock *sk, long timeout)
>-{
>-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>-	ssize_t (*unsent)(struct vsock_sock *vsk);
>-	struct vsock_sock *vsk = vsock_sk(sk);
>-
>-	if (!timeout)
>-		return;
>-
>-	unsent = vsk->transport->unsent_bytes;
>-
>-	add_wait_queue(sk_sleep(sk), &wait);
>-
>-	do {
>-		if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
>-			break;
>-	} while (!signal_pending(current) && timeout);
>-
>-	remove_wait_queue(sk_sleep(sk), &wait);
>-}
>-
> static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
> 					       bool cancel_timeout)
> {
>@@ -1283,7 +1262,7 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
> 		(void)virtio_transport_shutdown(vsk, SHUTDOWN_MASK);
>
> 	if (sock_flag(sk, SOCK_LINGER) && !(current->flags & PF_EXITING))
>-		virtio_transport_wait_close(sk, sk->sk_lingertime);
>+		vsock_linger(sk, sk->sk_lingertime);

Ah, I'd also move the check in that function, I mean:

void vsock_linger(struct sock *sk) {
	...
	if (!sock_flag(sk, SOCK_LINGER) || (current->flags & PF_EXITING))
		return;

	...
}

Or, if we move the call to vsock_linger() in __vsock_release(), we can
do the check there.

Thanks,
Stefano

>
> 	if (sock_flag(sk, SOCK_DONE)) {
> 		return true;
>
>-- 
>2.49.0
>
>



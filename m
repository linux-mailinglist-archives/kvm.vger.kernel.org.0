Return-Path: <kvm+bounces-31097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF159C0232
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80FB7B22267
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BFF41EC01C;
	Thu,  7 Nov 2024 10:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eGTcGYSK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF12E1E6DD5
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974951; cv=none; b=mkp0ZIUSS6ZikPuhsOQ3jblzWYyG+PjLctjc4KdK3ytOOwGhVq8tpzN29bRJsoRq0Sjtolj4lzoSTeEOsoGZW7DpBjeTCATuJIgY1lY4WiANdPTMY6Tbs1dXc7r6WH/9T65aHqcAZxq75EeJv4fB4vzVpNs6oUnYs5kj6ls9eoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974951; c=relaxed/simple;
	bh=V9NpU14QYVeWan0vHTGnaXzW9/fUraIqiInUNJ6WR64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYtfKaFo5IFABcpqw6hdUaepIIhwqARNqVoLfdcWv3UyES9+kf2ZHDbrM77TTZHrp+oQwGCMMQtrFuaP4U/BE5BZzBHMrabFdN90LYbv60KPob5CoIYkLD6m8+74OwkOsSeKrq5/6IJugMMV9y9YOWIRDODafaHqnAh4XVBy73A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eGTcGYSK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730974949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M/rk41amqTRxMFOn/UjLc5ZQtOWZ+WqrRln+PhszSu8=;
	b=eGTcGYSK8+PHY0IQXrHjBq329snUYMDPz7b/8OYPyduytV3roEUgIxwvnH5C6oYWKpY3U5
	phTKccCFXVFj2JQR6C9lQOZd6O6tKQSL4NUO/AHUVIWaPNjYbI7DUC0gXiVyp5VdjFbVBv
	2BPMqJh1GBRC4fZEzHEWts0YC4/CVfw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-ZeZQSSmePGmb0yf7dXvLIg-1; Thu, 07 Nov 2024 05:22:27 -0500
X-MC-Unique: ZeZQSSmePGmb0yf7dXvLIg-1
X-Mimecast-MFC-AGG-ID: ZeZQSSmePGmb0yf7dXvLIg
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b14073eabdso87379685a.3
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 02:22:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730974947; x=1731579747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/rk41amqTRxMFOn/UjLc5ZQtOWZ+WqrRln+PhszSu8=;
        b=A+uUWbsgqq6iB36i1s3/AX1lvsVAVDk6cSi9rWhvWdsj0HmK6ORnGDQ4NS9JoNNUPn
         Eoz3dKV6kG3Bp/hODs/iD59VV5IMYlfR2srckEGQecp/jg/Wjp2h2oa3KibITKj677CH
         mrZ1WVBozIn/jOiyXpCHiU1H0ifYqO50aTIEcUBpU6lHL/fsW7TOyyTK07jqpjrnn2KB
         3vSltk8sXbFNEYAHEVCdRQn39x4fVV/ts84FfVs/FOI3kLQCUDSEeuCf4YtyH2s7MtIh
         Q58xi5+j3ocd3Og087+QG+eMnxpjxU9AY7MDO5f+pPYL2P4MmtkClfZPc7Zubi23Y2lw
         aE4A==
X-Forwarded-Encrypted: i=1; AJvYcCU4+kcP42rwi+2+pC1eBcLhvea0vb4ulb9XtowQi2eYQYVIbYl3tiUM4O6RptnKSyWx6TU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzFX/XLg5NrEE7hZtnbBgqexOLO26PM4GAasvyxl+d01dBD0LD
	5h4KZCkmDGQAm84scgM+BhTANciPmPwKbeanpF4ctrafhNDmT1jnH3iREwbROqsy/C78tbsqidh
	XKvqW5u1NtKrhFfZlJKv+MYVUIluoWOUM5scerH9nz92PISFVeQ==
X-Received: by 2002:a05:620a:2a12:b0:7b1:4caf:3750 with SMTP id af79cd13be357-7b2fb9beb07mr3543633085a.53.1730974947208;
        Thu, 07 Nov 2024 02:22:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwf5lDb7bXsoa9a9hWJCOiDp2nDecqoUe9Y1TkckHnyCQWTiTj30iao7oA6EM5S1LIifvLqA==
X-Received: by 2002:a05:620a:2a12:b0:7b1:4caf:3750 with SMTP id af79cd13be357-7b2fb9beb07mr3543629485a.53.1730974946829;
        Thu, 07 Nov 2024 02:22:26 -0800 (PST)
Received: from sgarzare-redhat ([5.77.70.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b32ac43811sm49735285a.35.2024.11.07.02.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 02:22:26 -0800 (PST)
Date: Thu, 7 Nov 2024 11:22:16 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jia He <justin.he@arm.com>, Arseniy Krasnov <avkrasnov@salutedevices.com>, 
	Dmitry Torokhov <dtor@vmware.com>, Andy King <acking@vmware.com>, 
	George Zhang <georgezhang@vmware.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org
Subject: Re: [PATCH net 4/4] virtio/vsock: Put vsock_connected_sockets_vsk()
 to use
Message-ID: <ucfa7kvzvfvcstufnkhg3rxb4vrke7nuovqwtlw5awxrhiktqo@lc543oliswzk>
References: <20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co>
 <20241106-vsock-mem-leaks-v1-4-8f4ffc3099e6@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241106-vsock-mem-leaks-v1-4-8f4ffc3099e6@rbox.co>

On Wed, Nov 06, 2024 at 06:51:21PM +0100, Michal Luczaj wrote:
>Macro vsock_connected_sockets_vsk() has been unused since its introduction.
>Instead of removing it, utilise it in vsock_insert_connected() where it's
>been open-coded.
>
>No functional change intended.
>
>Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")

This is not a fix, so please remove the Fixes tag, we don't need to 
backport this patch in stable branches.

Also in this case this is not related at all with virtio transport, so 
please remove `virtio` from the commit title.

In addition maybe you can remove this patch from this series, and send 
it to net-next.

Thanks,
Stefano

>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> net/vmw_vsock/af_vsock.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index dfd29160fe11c4675f872c1ee123d65b2da0dae6..c3a37c3d4bf3c8117fbc8bd020da8dc1c9212732 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -275,8 +275,7 @@ static void vsock_insert_unbound(struct vsock_sock *vsk)
>
> void vsock_insert_connected(struct vsock_sock *vsk)
> {
>-	struct list_head *list = vsock_connected_sockets(
>-		&vsk->remote_addr, &vsk->local_addr);
>+	struct list_head *list = vsock_connected_sockets_vsk(vsk);
>
> 	spin_lock_bh(&vsock_table_lock);
> 	__vsock_insert_connected(list, vsk);
>
>-- 
>2.46.2
>



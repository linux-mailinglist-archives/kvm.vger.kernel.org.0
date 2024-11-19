Return-Path: <kvm+bounces-32046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2179E9D23A5
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 11:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D009E1F223DA
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 10:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5761C3F1D;
	Tue, 19 Nov 2024 10:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aYPZokXi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5A61C2DB4
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 10:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732012323; cv=none; b=tylVBw7VLUlLdioG/XJSCbO5egR8ejmPRI6o7BMQdK0yZVZm3yVZ7n/ux/qDv9Wou355n14ObixjDYkJu2hjXMxHII4GvOz4IH9NWxDoJeuFfVNcwFkWHNe/oNb7c47MheNfZItJJ4AeTK1XdKqmx4aGwHjduHQALYVvRY0NtTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732012323; c=relaxed/simple;
	bh=BlAjTcLgGJY8uAZ7SU9fmGPwNwkxmWnaguL65nNmxGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3r7z/pZ3oOndx80mKV5rgGACkBGX7sRsAFvOdpnvTReaZ+Z0KMFHw96Yq75LDY7qtFi6IJ2UKFr88xC2vXlvAbyYEIi99o/ukwFSsye/U5eCNO+p+JhfYZjto2kt4P6F61hha4Dl3VDdFGSrKShbZwImwoa+LOoYy95sTgLCos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aYPZokXi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732012321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XZR/k63cZYtzau/fs0C+ufqda6l8PKbNVPXXgaTEROQ=;
	b=aYPZokXiUnz3PPTssRP6mm2ahpRdvoHAMbEyyp25MmWCbv/yjvPTp213/+O5thG/3DC4mA
	k7OVzuDsZwh+XjmCcYrtoZaY4oLvTyQrx02h+UVBBU9XmcKgEMbCVTSvhmegJICJN38I3W
	XfI9GxZ2g9ak0FAVEGKq7XttiMHQK+k=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-mPNOrC_pNSOBTLBqsOhcLA-1; Tue, 19 Nov 2024 05:31:59 -0500
X-MC-Unique: mPNOrC_pNSOBTLBqsOhcLA-1
X-Mimecast-MFC-AGG-ID: mPNOrC_pNSOBTLBqsOhcLA
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3e60e1775bdso4539260b6e.2
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 02:31:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732012319; x=1732617119;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZR/k63cZYtzau/fs0C+ufqda6l8PKbNVPXXgaTEROQ=;
        b=tPENICDo6ZTpsvweR+etydRe3IjhQi1YYRal9t1wxnQyLZKl38zCtQdKf1kLW9pPPG
         gMCB6sW5D79+vhGPdgneJVSuYUVgy7sgQ3FdZ3t+1NDbBtR+1BjEr6PABIfTmrxqsIjB
         VQwQtTUNqcXLqbo8Ws6YfgWpN7+d0DSCQtvGlOxQJrcS3+YaXkFp3iFSIYZ3rGGkwINp
         DOP97rIdrwFWaKbC0fSxc95qaxlhqwonHTFiEI2tZpIMIc2aeNhBBdnTZfXjHD5Kib6P
         U8V8TWvhwAnyd+UkdAWdYtIoAELYV9dVuhHqjOeyl0yHH7S//acrf/MDLyeMyhE+LA2h
         Yhbg==
X-Forwarded-Encrypted: i=1; AJvYcCUNYqINjAciZV6aL5iAIcjspmu496nPhLaY1gVmXJrUba/DV3H0U84BNtO/MOH5sFi8Pv0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZX34QlqRItCkpU5YBiP975WaykJcYSwfs3W/euSrsEnOdr2zn
	HDXVFLL10w3+heZ2ovkORuo97hSRQI3/QVjyghewp9xpKJQDj1L645/8vMoB+3DLuXpMgRPnb6n
	5+1Sx+FpyfzXWw5DBAvU/hfJ8xa/lLqhqGYHCHxJFZYzrtJGTQA==
X-Received: by 2002:a05:6808:1a0f:b0:3e5:ed42:ef13 with SMTP id 5614622812f47-3e7bc7b5902mr14809450b6e.11.1732012319005;
        Tue, 19 Nov 2024 02:31:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWEwvUPqOGaW7LnP5oJa5I+dvpQDN13kppHSp+DXkJ5wuJF6S6yGrtvxP38Z3lsuqk+AOaDw==
X-Received: by 2002:a05:6808:1a0f:b0:3e5:ed42:ef13 with SMTP id 5614622812f47-3e7bc7b5902mr14809420b6e.11.1732012318535;
        Tue, 19 Nov 2024 02:31:58 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-129.retail.telecomitalia.it. [79.46.200.129])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d40ddd02cesm46568686d6.121.2024.11.19.02.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:31:57 -0800 (PST)
Date: Tue, 19 Nov 2024 11:31:49 +0100
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
Subject: Re: [PATCH net v2 0/3] virtio/vsock: Fix memory leaks
Message-ID: <7wixs5lrstuggf2xwgu6qva2t6atqnthcxycg6mpfpx52gl6fq@qmwb6gtgpad2>
References: <20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co>

Hi Michal,

On Thu, Nov 07, 2024 at 09:46:11PM +0100, Michal Luczaj wrote:
>Short series fixing some memory leaks that I've stumbled upon while 
>toying
>with the selftests.

Are these tests already upstream?
I would like to add them to my suite, can you tell me how to run them?

Thanks,
Stefano

>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
>Changes in v2:
>- Remove the refactoring patch from the series [Stefano]
>- PATCH 2: Drop "virtio" from the commit title [Stefano]
>- Collect Reviewed-by [Stefano]
>- Link to v1: https://lore.kernel.org/r/20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co
>
>---
>Michal Luczaj (3):
>      virtio/vsock: Fix accept_queue memory leak
>      vsock: Fix sk_error_queue memory leak
>      virtio/vsock: Improve MSG_ZEROCOPY error handling
>
> net/vmw_vsock/af_vsock.c                | 3 +++
> net/vmw_vsock/virtio_transport_common.c | 9 +++++++++
> 2 files changed, 12 insertions(+)
>---
>base-commit: 71712cf519faeed529549a79559c06c7fc250a15
>change-id: 20241106-vsock-mem-leaks-9b63e912560a
>
>Best regards,
>-- 
>Michal Luczaj <mhal@rbox.co>
>



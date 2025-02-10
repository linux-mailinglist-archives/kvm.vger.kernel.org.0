Return-Path: <kvm+bounces-37691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C4E3A2EBD2
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 12:49:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CF9916715A
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 11:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A94B1F55E0;
	Mon, 10 Feb 2025 11:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P2vwLeOF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FABF1F3BB1
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 11:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739188092; cv=none; b=DM3IZ0CYWtZvcZFsoZxujAm609jn6tVv9XkNUyLVXGO5XjYCk581h8jTlkG9iducacBmwtMtp6GGgbOZVu0eRm6XtU6/XB/wquccHmu29B1QRMd1gMSHNHUR6F45iaHg0qvBAdP9+INvSyx0yOlYU4HH1mL989mPx9VhmdhWlgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739188092; c=relaxed/simple;
	bh=d/DnoVtSkV/Nkf8oyOpZiRm12klhEJ7Wo4KRtp9gtVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XcI+G+lWpNn8Krg6WzlsBJC2+EZGy3rytu6DDV14XfZS5yergcxOBMbEx41WKdLKDcTX+nKVqGEBkUtgSxOhIeMnFdA3WAtNz1YffNiXMhV0U6hdX81q4lZoQ6ssgOHdmOtj+LNlcaDAsHuefDkOKM96dSXiIWB+6adFiFnO7SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P2vwLeOF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739188089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V96jX69C9DLp/pa7eUqKAsyCn0HykOC/OsS7VPjv/yE=;
	b=P2vwLeOFeMbfUhPZ3pd0htceHd2zhil/+5K0SeUIpWJVw6TNCMl+UBN2mYHTA81I6ab1BB
	3RlSeXPgKNejodL6vW2VoNj2lNHV8haEMFKqHzkKSOw8hjBld/yQXry6viNaopsA9M5DVp
	UEpg8NzlQf3NNwvcWQx+JRC/a420bZU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-tKXuJIUmM5uDPbSs4phdjw-1; Mon, 10 Feb 2025 06:48:08 -0500
X-MC-Unique: tKXuJIUmM5uDPbSs4phdjw-1
X-Mimecast-MFC-AGG-ID: tKXuJIUmM5uDPbSs4phdjw
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43945f32e2dso5298715e9.2
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 03:48:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739188087; x=1739792887;
        h=in-reply-to:content-disposition:mime-version:references:ifrom
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V96jX69C9DLp/pa7eUqKAsyCn0HykOC/OsS7VPjv/yE=;
        b=UAtbTMARyUkGo60yWANpbCq5oy5WXEU6M+7y3+11el7910i4Sb/lEH4JgDPs5vVqh5
         o/RVit+vRZickIyR3GlZRm0JeGtcb7qkdcjtdRPeACHTHX5ixHVlQLT9i6R8zmDqVsFj
         Ol2pQmpYm4XSdqu+mfZvjNtQIs3SqedLyzPqfSbE4YpW+fw11ZD31WvHrQe1GjzQJCLs
         gyLVmBH5xkL6W7+QBDsmM/j88wg5GV+Ixxnnz1nJEi8qjophSHyywkQD7++qZdr17WlL
         433Rk14LUbvdRmNspXDjUYZ1Mc3Wfg6xp94I3rSSf18h5RP/4AsvRpAIvjVsdu0hgk01
         TKLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDVjw7YKbumXpKzHMY8h3A1dIVsGxd7mtwZfnKa9tg3xOkEJKhXnV6WoCHx95q90SHx5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlDkkA9bsHy1XGWM4chI7zA1fudNt6Ltp1r2Wv/fDyprgsNgWp
	tFiaJfRlwJvL5lX0lqLQkCJuJQCTbkNqTNe0HgbGzD9+b3dC3otcO13BmDFPXXUKCi3K1boD8++
	mU5zL/hUyF6Hppd/F95c6tdz0H4UJh37MB/3IjJNSAi+fr5LXlw==
X-Gm-Gg: ASbGncszQzGf6mUQ3WsykiS5Ng5aBlx0sCz3h4Qz41ibiRT+1JphG2d1gU8bSkVPggK
	S6UJr6ps3iOoN9t9gQ53iIDIxm0WK0TX2Dp3yDxx1gDoZfCYiHP1UZfnMexFGzM1rb751SpW8Jk
	GzwMHl3B6urVqEP0NmovZ5WJPZwBbQJBL0xHd8xQpxZJY4DqWqcOj1Mb9rNQ7Y/etIFBUUnmdxy
	at4pVH8RjGnrGbzfYrLhj/7vYjzuE3+Af8LeftFASglimMNR/6YEdlQwDKXiE2pKM0YTxmPPsDA
	mNY1cZPM
X-Received: by 2002:a05:600c:1da7:b0:439:34e2:455f with SMTP id 5b1f17b1804b1-43934e24665mr67131415e9.12.1739188086693;
        Mon, 10 Feb 2025 03:48:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEGN3KR5R07uNE78CVdV7zyw1euIY35SEs9+TXB0gKXhyKCy8SuRwCQFSKXWIpDT0SeS4gsMg==
X-Received: by 2002:a05:600c:1da7:b0:439:34e2:455f with SMTP id 5b1f17b1804b1-43934e24665mr67131065e9.12.1739188086265;
        Mon, 10 Feb 2025 03:48:06 -0800 (PST)
Received: from leonardi-redhat ([176.206.32.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4392fc0856csm76891455e9.34.2025.02.10.03.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 03:48:05 -0800 (PST)
Date: Mon, 10 Feb 2025 12:48:03 +0100
From: leonardi@redhat.com
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, mindong.zhao@samsung.com, 
	q1.huang@samsung.com, ying01.gao@samsung.com, ying123.xu@samsung.com
Subject: Re: [PATCH 2/2] vsock/virtio: Don't reset the created SOCKET during
 s2r
Message-ID: <rnri3i5jues4rjgtb36purbjmct56u4m5e6swaqb3smevtlozw@ki7gdlbdbmve>
iFrom: Luigi Leonardi <leonardi@redhat.com>
References: <20250207052033.2222629-1-junnan01.wu@samsung.com>
 <CGME20250207051946epcas5p295a3f6455ad1dbd9658ed1bcf131ced5@epcas5p2.samsung.com>
 <20250207052033.2222629-2-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250207052033.2222629-2-junnan01.wu@samsung.com>

Like for the other patch, some maintainers have not been CCd.

On Fri, Feb 07, 2025 at 01:20:33PM +0800, Junnan Wu wrote:
>From: Ying Gao <ying01.gao@samsung.com>
>
>If suspend is executed during vsock communication and the
>socket is reset, the original socket will be unusable after resume.
>
>Judge the value of vdev->priv in function virtio_vsock_vqs_del,
>only when the function is invoked by virtio_vsock_remove,
>all vsock connections will be reset.
>
The second part of the commit message is not that clear, do you mind 
rephrasing it?

>Signed-off-by: Ying Gao <ying01.gao@samsung.com>
Missing Co-developed-by?
>Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>


>---
> net/vmw_vsock/virtio_transport.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 9eefd0fba92b..9df609581755 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -717,8 +717,10 @@ static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
> 	struct sk_buff *skb;
>
> 	/* Reset all connected sockets when the VQs disappear */
>-	vsock_for_each_connected_socket(&virtio_transport.transport,
>-					virtio_vsock_reset_sock);
I would add a comment explaining why you are adding this check.
>+	if (!vdev->priv) {
>+		vsock_for_each_connected_socket(&virtio_transport.transport,
>+						virtio_vsock_reset_sock);
>+	}
>
> 	/* Stop all work handlers to make sure no one is accessing the device,
> 	 * so we can safely call virtio_reset_device().
>-- 
>2.34.1
>

I am not familiar with freeze/resume, but I don't see any problems with 
this patch.

Thank you,
Luigi



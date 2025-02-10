Return-Path: <kvm+bounces-37703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C67A2F44F
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 17:54:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7566518825CF
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 16:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5815C255E4C;
	Mon, 10 Feb 2025 16:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YlXHDGNp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BC02586D7
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 16:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739206354; cv=none; b=GPhz8YkqVMy85Bco14NTL0qnCyK4VhcNcgNWBB5jCMS3RP99rdugg3q2TzJz33ZrZ/ztrVCN6Md/QnBdzNyl0jv44E+IGf9ju+sQmkxFFmaI8pmJRuG5iW/UTh//sHjouIXA8SZLS2rb4WSBWImu3xw2wa0fxgtftFHda9A/v3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739206354; c=relaxed/simple;
	bh=0D7FejxdMSdNwq4d8Iw/FTH+8Vh58GxW2QYBqWIyCxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjoD9THti3W1Asi+AjqjH0sHJuMO7x10PNuGZhktqyUeaHmX96wRbq5zchT5L+/oZdn0i7PqZ5slqVcvv8CI4g2qjfOLO7+1IkhL9fhhFu0SeeZc4CDB6DXftKlv+htw4nCIBADu8JGKLVAZHyrpRzn0a+YIpxdOSIeqqjri5Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YlXHDGNp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739206351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jobaAwA+Fk2dqvWn152x6BfQDd/w8Mf+7rUPoxAJHww=;
	b=YlXHDGNpAa9TGBKhtvoQl3NXKy2Q+DUpXwvI4wzhKIIqeOCvtUEQokKwm8bBveXtOgFzt6
	R/plB1wR45pLT0+vr84v1Mot+elw1VaDVWLJ2gTanMI1BPHA/R6+PqrESUi4+MDM5/qxBl
	DrQqaOEHODbaTrhae/z7otPqQIvQEuQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-CQFCYD33O5aYCGUXSHj5-Q-1; Mon, 10 Feb 2025 11:52:28 -0500
X-MC-Unique: CQFCYD33O5aYCGUXSHj5-Q-1
X-Mimecast-MFC-AGG-ID: CQFCYD33O5aYCGUXSHj5-Q
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4394c747c72so903195e9.1
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 08:52:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739206347; x=1739811147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jobaAwA+Fk2dqvWn152x6BfQDd/w8Mf+7rUPoxAJHww=;
        b=S40cafBZ7D1ciyd905Xfq7lsmXhzupn4DMWOjNEbsZJCAi27DTJekoMNg24hvLp055
         nofJdWVD3w4KThE2X1V+0ZamhHc/LF9L9HRFmkNr6RSgjdMHy7AbWFgxbkTqASnMHn5g
         vFNvyxGbEpZQP2wkmNpX0h8liLPvB8fMP1tFCA6ZzVeV7hufBb0ybsfcUOSSR/TN3RpY
         gbpsAQ2kuZWrGI+Hb/cCF3kkJHFw0EUc8HKSMt0rbl26OFDHeQ6oHumJRkHgXHmPGJqM
         l79949fZYHaF6IiJbjZPAXllWV2wEvmY0tcNrDANZpyo6uLo9i6XRzxNNN38n1fESHcI
         3Qng==
X-Forwarded-Encrypted: i=1; AJvYcCVTvCmZInJP8Ss9vYlmj1uUGQwVNNamypeGNThDG1lWx5/c4GBkFnJjJf9ahaZ2NXgk+ik=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqawEmQmYFB11idBGlcgQgMg9HarS2++imnAB6/cE0ELk8MgDi
	/DwkjHY9P/mf+KwuRz3WXlae1Nkevix9KCoZrx9OolkwevoFneU0hxKk/YnGYVqGD8wtyUUK5qE
	hrLAJV4J4+nz22ou8O47dhnhFniw6GtAOqRQ6A+cpx9b3qoerBA==
X-Gm-Gg: ASbGncuUQVLArDwCVqY2Oh3rYN+S/c8/aCxAYDkRUzehBskvRFJ7syLNCr+uHt5j6lp
	fNXWNTmoXV4OHSlPl2vw6poVxEHzDByF3BFJTVK+O1QkVpIsZtyei6yIZbP1Q8UQ57IWXSWy23L
	2IBxSCfYIfVbBvGtGE8LmEFYtevpUTKZSi5MUjjSd3wmUPa06TboRBmXxx5ccrOAqxrIZOzc9Lz
	MTWPJzpPHNS+vbM16frrOV0oDc1fDdrHzPVNjwVXjTEkXRLwhZIGn4wDKfpDtxMuWCSkvjG6f7/
	Ts0bG7ztis1MTUKiCD1kPCLkj9RAfCn54l1GWACim0LKzAyIff9mLA==
X-Received: by 2002:a05:600c:4589:b0:434:f609:1af7 with SMTP id 5b1f17b1804b1-4394c808849mr5820085e9.4.1739206347628;
        Mon, 10 Feb 2025 08:52:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzQ/jMNKz482G2FvYPl7tsnY56iQpM2aodBvtMBbJOao7+wP//TbIwcCW+7o1f40GNOhLyTA==
X-Received: by 2002:a05:600c:4589:b0:434:f609:1af7 with SMTP id 5b1f17b1804b1-4394c808849mr5819735e9.4.1739206346931;
        Mon, 10 Feb 2025 08:52:26 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dcb88d5e6sm9636306f8f.1.2025.02.10.08.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 08:52:26 -0800 (PST)
Date: Mon, 10 Feb 2025 17:52:19 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: leonardi@redhat.com, Junnan Wu <junnan01.wu@samsung.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, mindong.zhao@samsung.com, 
	q1.huang@samsung.com, ying01.gao@samsung.com, ying123.xu@samsung.com
Subject: Re: [PATCH 2/2] vsock/virtio: Don't reset the created SOCKET during
 s2r
Message-ID: <iv6oalr6yuwsfkoxnorp4t77fdjheteyojauwf2phshucdxatf@ominy3hfcpxb>
References: <20250207052033.2222629-1-junnan01.wu@samsung.com>
 <CGME20250207051946epcas5p295a3f6455ad1dbd9658ed1bcf131ced5@epcas5p2.samsung.com>
 <20250207052033.2222629-2-junnan01.wu@samsung.com>
 <rnri3i5jues4rjgtb36purbjmct56u4m5e6swaqb3smevtlozw@ki7gdlbdbmve>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <rnri3i5jues4rjgtb36purbjmct56u4m5e6swaqb3smevtlozw@ki7gdlbdbmve>

On Mon, Feb 10, 2025 at 12:48:03PM +0100, leonardi@redhat.com wrote:
>Like for the other patch, some maintainers have not been CCd.

Yes, please use `scripts/get_maintainer.pl`.

>
>On Fri, Feb 07, 2025 at 01:20:33PM +0800, Junnan Wu wrote:
>>From: Ying Gao <ying01.gao@samsung.com>
>>
>>If suspend is executed during vsock communication and the
>>socket is reset, the original socket will be unusable after resume.

Why? (I mean for a good commit description)

>>
>>Judge the value of vdev->priv in function virtio_vsock_vqs_del,
>>only when the function is invoked by virtio_vsock_remove,
>>all vsock connections will be reset.
>>
>The second part of the commit message is not that clear, do you mind 
>rephrasing it?

+1 on that

Also in this case, why checking `vdev->priv` fixes the issue?

>
>>Signed-off-by: Ying Gao <ying01.gao@samsung.com>
>Missing Co-developed-by?
>>Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
>
>
>>---
>>net/vmw_vsock/virtio_transport.c | 6 ++++--
>>1 file changed, 4 insertions(+), 2 deletions(-)
>>
>>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>index 9eefd0fba92b..9df609581755 100644
>>--- a/net/vmw_vsock/virtio_transport.c
>>+++ b/net/vmw_vsock/virtio_transport.c
>>@@ -717,8 +717,10 @@ static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>>	struct sk_buff *skb;
>>
>>	/* Reset all connected sockets when the VQs disappear */
>>-	vsock_for_each_connected_socket(&virtio_transport.transport,
>>-					virtio_vsock_reset_sock);
>I would add a comment explaining why you are adding this check.

Yes, please.

>>+	if (!vdev->priv) {
>>+		vsock_for_each_connected_socket(&virtio_transport.transport,
>>+						virtio_vsock_reset_sock);
>>+	}

Okay, after looking at the code I understood why, but please write it 
into the commit next time!

virtio_vsock_vqs_del() is called in 2 cases:
1 - in virtio_vsock_remove() after setting `vdev->priv` to null since
     the drive is about to be unloaded because the device is for example
     removed (hot-unplug)

2 - in virtio_vsock_freeze() when suspending, but in this case
     `vdev->priv` is not touched.

I don't think is a good idea using that because in the future it could 
change. So better to add a parameter to virtio_vsock_vqs_del() to 
differentiate the 2 use cases.


That said, I think this patch is wrong:

We are deallocating virtqueues, so all packets that are "in flight" will 
be completely discarded. Our transport (virtqueues) has no mechanism to 
retransmit them, so those packets would be lost forever. So we cannot 
guarantee the reliability of SOCK_STREAM sockets for example.

In any case, after a suspension, many connections will be expired in the 
host anyway, so does it make sense to keep them open in the guest?

If you want to support this use case, you must first provide a way to 
keep those packets somewhere (e.g. avoiding to remove the virtqueues?), 
but I honestly don't understand the use case.

To be clear, this behavior is intended, and it's for example the same as 
when suspending the VM is the hypervisor directly, which after that, it 
sends an event to the guest, just to close all connections because it's 
complicated to keep them active.

Thanks,
Stefano

>>
>>	/* Stop all work handlers to make sure no one is accessing the device,
>>	 * so we can safely call virtio_reset_device().
>>-- 
>>2.34.1
>>
>
>I am not familiar with freeze/resume, but I don't see any problems 
>with this patch.
>
>Thank you,
>Luigi
>



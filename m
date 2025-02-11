Return-Path: <kvm+bounces-37827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53503A30648
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:50:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54CB63A3E02
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82FF91F0E4E;
	Tue, 11 Feb 2025 08:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRhP0661"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBE61EF0B6
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739263784; cv=none; b=JdeSZKaNZdGxQDXYaYJKmiTp9Z+q3QjcEsr8YvZjBcXLu7/Dw0oCark67NDy7dlAiHat3dK16oU7F8ByFLLgoJXdwN0M+yY2xOWIqsdG6wAJyoAECrLKFep+q7W6uotYbSUfa15CQleXk1i7mHhSjwQt3ysoSW2Ny3Tw8ncWhdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739263784; c=relaxed/simple;
	bh=tGGe6R9k07bfXinl0nS+60J8kkCn9Msd7ZYZxAChr1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLYiKB4pxCVCq7rvLQMzFM3Z9fVPKXNsrhNLiXj63IawaK5IBzsa9bvCPtBEYXvRmSjdgc5Bfxrz5e16oceHMbEF7Va0TcIixmeSC9qolk5mceu1KREpUGPvb9eRLILVo0/30ZJYMk08aaOyPeifwmttpULW2dM4x5U6Ujgs++o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CRhP0661; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739263781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LRMrU6yeeMWRAhnsRZJcbJf4YV+OqMKei44I5o7lAMg=;
	b=CRhP0661Y7fWgDMgWjdBkixpKdUX+Mwj36oK/xgbczE9/IbIKvkVuxAfmjcMyWaPxcAzjP
	gvzjVeoffj1AIzC8uI6ixxvbJMnstWvVOEgkD96cy7mnHRjgIoyzeEJ5NhNUoWgH2ctI6W
	Ng3VRyivbnKMh5StutajlP5HcdFOmWs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-xRrdr-eNMDqK48OikEXeuA-1; Tue, 11 Feb 2025 03:49:39 -0500
X-MC-Unique: xRrdr-eNMDqK48OikEXeuA-1
X-Mimecast-MFC-AGG-ID: xRrdr-eNMDqK48OikEXeuA
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38ddee833e0so1009836f8f.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 00:49:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739263778; x=1739868578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LRMrU6yeeMWRAhnsRZJcbJf4YV+OqMKei44I5o7lAMg=;
        b=ScIb1AKNp3j37fiqZZX9Y6U+SxBs/Mj0M1tIUWQWkdXKgyrzyJNRqn0QSGFMzRmtLh
         A/nxjYgVayWmgy9BJzO5KTH50BgCk8v4BBlWxmdnap9j3ifMbcevJEQ0gwUvvA0vJBUY
         8NHYRlf3oU6w8t+A5wboPBc3ZulxIYcIUg3a0n/qaSrkV3H1PEcRj2NfN4WMjzkK7CyC
         2p2pdpPDy8ZAurBXA+jVY13RJO1dayHZxgrUUXfmX5IlB1eCeWug+CLVv1kIxRPNCclU
         Rf9dqfkt5aXaayw9uHhwc2JvrZCo6/7ZGw8QEj/CHRE3SgvJPl+VZX+Fuh+RdRNbxwMj
         N8Dg==
X-Forwarded-Encrypted: i=1; AJvYcCUPgJJ7gBMj+p12ehHXadWWcxJAIIQANmr3Gm40JXvVurWHgiyXN7OIzqs1pdeEe3AybLo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMW0ggAhdlbNmF5FECQyPEeRg0kN5NV5rM5w3ouCQJpeXUio2X
	0+UZdo3sd8pGbnzGi8eBaLRhU3v7F81PPHIypXuCsgdyI9pdiGD9118TyCPJs01dSIEVPHZaXrj
	ZnAaDogfl1MOhUlv48waxtGSj6aX7D1fBX4jN052xR14WQunSmQ==
X-Gm-Gg: ASbGnct6+diES2hl0dySpGhY2T1+o5wFakXT4PU6PhdeX9SJCInQRoZVOfkRGai17HJ
	e4O8c6Z2Pq8ZXr5RJL/w75uvcxbHeZQMDu3qU8VBgSMviW+kL2Cyfq2/6h3mT9z7uZIaq7BCwff
	LUiZFYFAYG1yeptVzSkbQXizln0Wx6v7iz4cC0fBzepjQmJJDzWxORAAl8hP7yYujIEOCxOkRQE
	3cMBVarGdSuYcbl1zBhL6kOPGFcKjwLiYpl12hBLSxZv3EBpFiHLzfc6v0hXzMLy3viDGHU+kYL
	LZtS+L3JGmbgd3eizTTlA4H5TGjCAEG7hFPGbB7jMxXCM5JfuuqNdQ==
X-Received: by 2002:a05:6000:1a8e:b0:38d:dffc:c14f with SMTP id ffacd0b85a97d-38de438e616mr1875233f8f.1.1739263778449;
        Tue, 11 Feb 2025 00:49:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGeTzJoifNHnY5TL4dY0IJ4mNA0Zko6YQk6M6uAACokDE0hpUh2u8Fm8WqTwc8m/eZy3oWQ1Q==
X-Received: by 2002:a05:6000:1a8e:b0:38d:dffc:c14f with SMTP id ffacd0b85a97d-38de438e616mr1875201f8f.1.1739263777811;
        Tue, 11 Feb 2025 00:49:37 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d94d7c7sm202714805e9.14.2025.02.11.00.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 00:49:37 -0800 (PST)
Date: Tue, 11 Feb 2025 09:49:32 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	xuanzhuo@linux.alibaba.com, eperezma@redhat.com, horms@kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	q1.huang@samsung.com, ying01.gao@samsung.com, ying123.xu@samsung.com, 
	lei19.wang@samsung.com
Subject: Re: [Patch net 2/2] vsock/virtio: Don't reset the created SOCKET
 during suspend to ram
Message-ID: <cmpw6mtpzkhsdqvsls6zutnswwgf3exuwdqvw5f5673fzuktol@y6fpwfcb73ns>
References: <20250211071922.2311873-1-junnan01.wu@samsung.com>
 <CGME20250211071946epcas5p3c2afde3813ab81142e81cff110ab7afa@epcas5p3.samsung.com>
 <20250211071922.2311873-3-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250211071922.2311873-3-junnan01.wu@samsung.com>

On Tue, Feb 11, 2025 at 03:19:22PM +0800, Junnan Wu wrote:
>Function virtio_vsock_vqs_del will be invoked in 2 cases
>virtio_vsock_remove() and virtio_vsock_freeze().
>
>And when driver freeze, the connected socket will be set to TCP_CLOSE
>and it will cause that socket can not be unusable after resume.
>
>Refactor function virtio_vsock_vqs_del to differentiate the 2 use cases.
>
>Co-developed-by: Ying Gao <ying01.gao@samsung.com>
>Signed-off-by: Ying Gao <ying01.gao@samsung.com>
>Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
>---
> net/vmw_vsock/virtio_transport.c | 18 ++++++++++++------
> 1 file changed, 12 insertions(+), 6 deletions(-)

We are still discussing this in v1:

https://lore.kernel.org/virtualization/iv6oalr6yuwsfkoxnorp4t77fdjheteyojauwf2phshucdxatf@ominy3hfcpxb/T/#u

Please stop sending new versions before reaching an agreement!

BTW I still think this is wrong, so:

Nacked-by: Stefano Garzarella <sgarzare@redhat.com>


>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index f0e48e6911fc..909048c9069b 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -716,14 +716,20 @@ static void virtio_vsock_vqs_start(struct virtio_vsock *vsock)
> 	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
> }
>
>-static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>+static void virtio_vsock_vqs_del(struct virtio_vsock *vsock, bool vsock_reset)
> {
> 	struct virtio_device *vdev = vsock->vdev;
> 	struct sk_buff *skb;
>
>-	/* Reset all connected sockets when the VQs disappear */
>-	vsock_for_each_connected_socket(&virtio_transport.transport,
>-					virtio_vsock_reset_sock);
>+	/* When driver is removed, reset all connected
>+	 * sockets because the VQs disappear.

You wrote it here too, you have to reset them because the VQs are going 
to disappear, isn't it the same after the freeze?

>+	 * When driver is just freezed, don't do that because the connected
>+	 * socket still need to use after restore.
>+	 */
>+	if (vsock_reset) {
>+		vsock_for_each_connected_socket(&virtio_transport.transport,
>+						virtio_vsock_reset_sock);
>+	}
>
> 	/* Stop all work handlers to make sure no one is accessing the device,
> 	 * so we can safely call virtio_reset_device().
>@@ -831,7 +837,7 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> 	rcu_assign_pointer(the_virtio_vsock, NULL);
> 	synchronize_rcu();
>
>-	virtio_vsock_vqs_del(vsock);
>+	virtio_vsock_vqs_del(vsock, true);
>
> 	/* Other works can be queued before 'config->del_vqs()', so we flush
> 	 * all works before to free the vsock object to avoid use after free.
>@@ -856,7 +862,7 @@ static int virtio_vsock_freeze(struct virtio_device *vdev)
> 	rcu_assign_pointer(the_virtio_vsock, NULL);
> 	synchronize_rcu();
>
>-	virtio_vsock_vqs_del(vsock);
>+	virtio_vsock_vqs_del(vsock, false);
>
> 	mutex_unlock(&the_virtio_vsock_mutex);
>
>-- 
>2.34.1
>



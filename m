Return-Path: <kvm+bounces-41521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D44B8A69A96
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 22:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20B12423E75
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 21:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9219F215F76;
	Wed, 19 Mar 2025 21:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KXh7tijh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAF41F099A
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 21:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742418592; cv=none; b=FrUKj4bxnh61iBnGVe7OKfsPMxRUE/bc8NsctgNiQz4s2RUo+W44Cqwu7QNRxfwbd45CG0MH9tRvvoyVR35EETpQzERORGHrZrfh7KwjgQNsyAHqfs2wzv5+ndIJRprWWsp+tZG1wb8690uQM8YM+6gn4G0UPMCl2RXlSNo92Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742418592; c=relaxed/simple;
	bh=t0DQSzj76o+q28S/J/Q+aN0pxw+YPVtotQKrAVrAB6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uFMmR5Ib5gbPFy5JTL8eHgtSFuXfcQDY337qE6JpwgD8dyCawcdd/Ik3/vFD0Dj/9TGX9gL2oxdxR/1GRdxuLrHVonRPWao0Xa/RG/kLh6SWyliOJSoazDL4UPbDcRE+CPlXRzBRXLebMN12pyrlu3yXA1+4JMaPpzDu7CASYLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KXh7tijh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742418589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j7HoSvSm7GM5yXTNBY3sCZv8nsyIwGMkLSsX5gJEiNY=;
	b=KXh7tijhQ2SyWwxeKP+y7Xt9PN/Oj8yMA88paJ3c3gGz5USuHtS+iBmyI45JsFbcB6lVrN
	feZqdLpBxsHR9IHY0PwlUoTYsyDAgTCkzQpLBja83fnOTSvQbpdiMnbyGCVegAPDy4zncZ
	NxS6OJq823GIiNppE4CbxWiN0v/9rHw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-2XF_Lbk0OwGqmABGLCpdTg-1; Wed, 19 Mar 2025 17:09:48 -0400
X-MC-Unique: 2XF_Lbk0OwGqmABGLCpdTg-1
X-Mimecast-MFC-AGG-ID: 2XF_Lbk0OwGqmABGLCpdTg_1742418587
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43ced8c2eb7so548545e9.1
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 14:09:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742418587; x=1743023387;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j7HoSvSm7GM5yXTNBY3sCZv8nsyIwGMkLSsX5gJEiNY=;
        b=gJOjj+qzpZjtuUo582n4pGW18XO2ZjhIWm9c4ROzBnKugQ0NROewgwyLkRQp9csOXl
         b4RpDEGBI3uiy7tl+yr1+TIcpYZQbnCL7qivXurgMqN/qbLycDcFYjM3A/8KJx+/HkWz
         hahhMYGLxoYIn2w4J1IYKlzanAXQMB2k2fe0pSJNllAaOyggEj0naQrXe9OR77gODLgk
         kOpqL5KAWfePM5G6A9NoKZYW0JEYVpiu7ZFfeItL7hzolAcSy+f3lTV/ib7iQSQkZePb
         oHYoNvwig+tKTv3i+bQDT9oDPuuBDjEsUNlk1HAIGUTMZKYUVqFfJkkmoqhqxDvLgpDi
         QknQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgH2oU7ctTUrcozIJwkDS7EIl9NU5mw8IMzdv9axhWmHH74xB6dwYRs0bRlfaWfctKrdA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcPp0GPEYHeCBn+JIntGDx1RVOU2rK7DwZh0u0Im0YpO5nnGV7
	jUvCUr1pfEmo3Uw0AtL1EYt2QT7McbGD6mwpWycW8seniI7yzCg9BkIO3CowHHRVGnVwxdLDG0V
	XtadEsvhroxhSnHpdusRzUAGAG6Vy24b/UW1Okn3yW+D7X38ThQ==
X-Gm-Gg: ASbGncu8fer+1LQU0Kctx8kMyEUwpb6+YStWS6DOt5nhQOomPEkvNedFi/6QBkigvzZ
	bYSf5tC1tzwQ06WRbXU8eCr0I7tx1ip2LAXf0krK/bioEcPpzHRXKTZkoJMqezr4NHV9pOyPybR
	SyA7NHuK0aAzv4HWr7j14pGhEML7Mo4IdAPlcLGuF3zb1zlKot7JJH9uply8WOQaVOwsETXifA8
	fsqauk191ZqKvW0u2bKfCQZg0KzMTjhsrGXLMyF9Jw8NwA9Ji4L1J0qjthIteMwulaDORx6h5wd
	lt73gClIMG+00ZwSRsznsFH5+fgpdvE+dSpRi/DMJDVnUg==
X-Received: by 2002:a5d:5f4f:0:b0:38f:231a:635e with SMTP id ffacd0b85a97d-399795c2ademr966969f8f.25.1742418587032;
        Wed, 19 Mar 2025 14:09:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUNp5m5kg5nT9dIUi3KyGpUUwGQCEZhhXoTguvu2e0VxM6ACwAq8iInQv4AfDuk3Kc6Z9FwQ==
X-Received: by 2002:a5d:5f4f:0:b0:38f:231a:635e with SMTP id ffacd0b85a97d-399795c2ademr966951f8f.25.1742418586581;
        Wed, 19 Mar 2025 14:09:46 -0700 (PDT)
Received: from [192.168.88.253] (146-241-10-172.dyn.eolo.it. [146.241.10.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c7df35ecsm22151312f8f.16.2025.03.19.14.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 14:09:46 -0700 (PDT)
Message-ID: <09c84a94-85f3-4e28-8e7d-bdc227bf99ab@redhat.com>
Date: Wed, 19 Mar 2025 22:09:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] vhost/vsock: use netns of process that opens the
 vhost-vsock-netns device
To: Bobby Eshleman <bobbyeshleman@gmail.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Bryan Tan <bryan-bt.tan@broadcom.com>,
 Vishnu Dasa <vishnu.dasa@broadcom.com>,
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: "David S. Miller" <davem@davemloft.net>, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/12/25 9:59 PM, Bobby Eshleman wrote:
> @@ -753,6 +783,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>  	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
>  
>  	vhost_dev_cleanup(&vsock->dev);
> +	if (vsock->net)
> +		put_net(vsock->net);

put_net() is a deprecated API, you should use put_net_track() instead.

>  	kfree(vsock->dev.vqs);
>  	vhost_vsock_free(vsock);
>  	return 0;

Also series introducing new features should also include the related
self-tests.

Thanks,

Paolo



Return-Path: <kvm+bounces-38171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FDC7A35F5D
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 14:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 719BB1692E5
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 13:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0D6264FA7;
	Fri, 14 Feb 2025 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K6pPOnDh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF22B227BB9
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 13:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739540092; cv=none; b=hVVCnuZh5Puay7aWLSwJtLb+VCw9yt1EguKNnda0mua/X6d7aTUqR9guQ0ZXQJEysuKfEGp358GDTuq27pI+eTSZxD/zV4RMFQKr94tPkBJsMdDpWCRJwyCFi9QT8Dg5fK0eRNvhCRlmUDF9X3Nr9lVRvdTArLSeVkydHY/ZlHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739540092; c=relaxed/simple;
	bh=1rIrvF0Jv/axJissqScQNVkSpcTz+uHX2dYGRedQ3fQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGFIMVsByOKeFcJQh6qhfAttm8WBwmd+MupQAhAVuXRNkgXxck5Pb6ntvz01+L/1IcaJ+6crPliyTrKrsPyQlwvU4x7r7ovzs0wrmFcuk6kMiG/Hr0fpiWO5I29TeDamUwiqpmZuSMf0NzkpoI9oDbPxWBe+Vk6F1fPhx8tskSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K6pPOnDh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739540089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1rIrvF0Jv/axJissqScQNVkSpcTz+uHX2dYGRedQ3fQ=;
	b=K6pPOnDhV74gGzuTWg15x69yg2zSywkhIEN6WRy+QkLDIxrlqohijfLa12IuWmI0fW6pPp
	9Pp6lSmoURoTTI6sVEgJ1gxSryefOXXsVZ77sMEQhnnFOPqo1yIxO0ueoR7NuynWyqm2H9
	lgzjOoQoXQLZQEiPsB8pGGnZRoHKYmo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-1aOaBuu4O4yI72CZn4BGkg-1; Fri, 14 Feb 2025 08:34:48 -0500
X-MC-Unique: 1aOaBuu4O4yI72CZn4BGkg-1
X-Mimecast-MFC-AGG-ID: 1aOaBuu4O4yI72CZn4BGkg_1739540087
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38f2f78aee1so359980f8f.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 05:34:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739540087; x=1740144887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rIrvF0Jv/axJissqScQNVkSpcTz+uHX2dYGRedQ3fQ=;
        b=D1brYNIsEqR8HgkvPXmeNatm3byX9MFwK+hZL1md69n/Ded8oaFMcAQsT2W7WugU7z
         Wfys4ro6kwlgJAXmD4a1MqvvzVOPRiHYg1N4IgTlscqzFgMaM6YsdgFx9akjzA0vThEy
         K9dqQDzJVSeqad7B7S+MdEkNDmIeHqaUxXAhCT1o8qdeq6jpcD4EBTpl8bz+47dNyAjT
         6GI4Q7n7HtRypFcOaJNLwbSBORFkXyYWlgRgMZeo2DzbXT1ztnoLevJvYMLmEqD2G9zd
         BVDhZgJ9T7Zqj+/cyrfYSFWwAiGUK1Z9KseQRx7yonTEfsNidOQGl+WqGux24fosbB8k
         Rzqg==
X-Forwarded-Encrypted: i=1; AJvYcCWGwXQRsUscZxXwXqJmefZ7k3/SGWijBhvM4P2RchF9t2LwaWN7HsfkPMaGy3Z2HqO/AMU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3GgWyF9ts3D7C98FcBRUpTcr5poOEIBz637XuXonyJ6TzOD1z
	8YlIXcaQTaUq7aFE0nkBsZisq2D8zPF1M6qDYb8GlgJIvNzMYa0hGshkJWRQeJeckith/jMaOK2
	Tx4Np+mRopwbr4+OLU18FpKpCE7rvBYBKjCX48Xri0R3Sp4aVtA==
X-Gm-Gg: ASbGncvJ5bt/VZO5MIp8Pe5JEORQIUuzOft60EV0qRLxnCWaA7N/JjlbiCbWtNBZKdg
	KyBajhBXJmAvHvTUlhIE98WfbYpg/Xhqf9XN9NTqKE9SMpFjvUwyD6ztgN1NcXd0HU8wfPaS39z
	if1rX1deqqD1hAWWtZ4a1KwWURI99hqkIVg2MvSADNxeHO4kCZOjp++4rZul8/uyoPU+7QQVwdU
	nVbHt5Xky/FkxU0XLeBgGKSevjq6kYZIJ7+qFvI63BpeOqvdlGt9JYVwQmxbv/Wg9QZaZ/whB3R
	8Qt0Sl0DUpQomRH0ED4cqcgJd3yoauij7QcTXoB+9y9RCaekA8Uisw==
X-Received: by 2002:a5d:4ad2:0:b0:38d:e3da:8b4f with SMTP id ffacd0b85a97d-38f24e1bfd4mr7382223f8f.0.1739540087271;
        Fri, 14 Feb 2025 05:34:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBDfyv1SdJm7R5cH01+wLfhjW4AOVc7JnS47asJmAAjRGNm0ow+MsDNI0LRQYW/dCz7cuhNA==
X-Received: by 2002:a5d:4ad2:0:b0:38d:e3da:8b4f with SMTP id ffacd0b85a97d-38f24e1bfd4mr7382167f8f.0.1739540086611;
        Fri, 14 Feb 2025 05:34:46 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b43d4sm4600179f8f.4.2025.02.14.05.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 05:34:46 -0800 (PST)
Date: Fri, 14 Feb 2025 14:34:40 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com, 
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org, 
	lei19.wang@samsung.com, linux-kernel@vger.kernel.org, mst@redhat.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, q1.huang@samsung.com, stefanha@redhat.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com, ying01.gao@samsung.com, 
	ying123.xu@samsung.com
Subject: Re: [Patch net v3] vsock/virtio: fix variables initialization during
 resuming
Message-ID: <7zof7x3scn2jlszxwynyaw3i5lcwfo5j3yrgw2sraq6pw545h5@zwoqaewlq2m4>
References: <CAGxU2F7PKH34N7Jd5d=STCAybJi-DDTB-XGiXSAS9BBvGVN4GA@mail.gmail.com>
 <CGME20250214012219epcas5p2840feb4b4539929f37c171375e2f646b@epcas5p2.samsung.com>
 <20250214012200.1883896-1-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250214012200.1883896-1-junnan01.wu@samsung.com>

On Fri, Feb 14, 2025 at 09:22:00AM +0800, Junnan Wu wrote:
>When executing suspend to ram twice in a row,
>the `rx_buf_nr` and `rx_buf_max_nr` increase to three times vq->num_free.
>Then after virtqueue_get_buf and `rx_buf_nr` decreased
>in function virtio_transport_rx_work,
>the condition to fill rx buffer
>(rx_buf_nr < rx_buf_max_nr / 2) will never be met.
>
>It is because that `rx_buf_nr` and `rx_buf_max_nr`
>are initialized only in virtio_vsock_probe(),
>but they should be reset whenever virtqueues are recreated,
>like after a suspend/resume.
>
>Move the `rx_buf_nr` and `rx_buf_max_nr` initialization in
>virtio_vsock_vqs_init(), so we are sure that they are properly
>initialized, every time we initialize the virtqueues, either when we
>load the driver or after a suspend/resume.
>
>To prevent erroneous atomic load operations on the `queued_replies`
>in the virtio_transport_send_pkt_work() function
>which may disrupt the scheduling of vsock->rx_work
>when transmitting reply-required socket packets,
>this atomic variable must undergo synchronized initialization
>alongside the preceding two variables after a suspend/resume.
>
>Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
>Link: https://lore.kernel.org/virtualization/20250207052033.2222629-1-junnan01.wu@samsung.com/
>Co-developed-by: Ying Gao <ying01.gao@samsung.com>
>Signed-off-by: Ying Gao <ying01.gao@samsung.com>
>Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
>---
> net/vmw_vsock/virtio_transport.c | 10 +++++++---
> 1 file changed, 7 insertions(+), 3 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>



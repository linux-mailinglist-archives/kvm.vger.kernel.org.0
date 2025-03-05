Return-Path: <kvm+bounces-40152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B58AA4FA7A
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 10:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D33F3AB674
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 09:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF91B205504;
	Wed,  5 Mar 2025 09:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nj0JnatA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D38E205AC8
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 09:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741167796; cv=none; b=ehPCLFmvUhS1/7cO/LX6//n/94G8bWwNLeqioE+iUenibY4rRtXrh4xs0IcwL0isadQaQ4hq+Jw6nj+GrodXa21AbMk98aNvuOoneB1Dn7irMlT16/H1xYlKDQtJBuq3oGBR/qK5UokwOrXcwqVkjyLXE8dq7n9ssRRE6j2JB1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741167796; c=relaxed/simple;
	bh=imtuAnpaAXGOP6kzkiTdpwhJ9L3ewSs/OCqwVl5NK7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h7exHWSVMiPAWgCN2ENr3AWZm/FzZ8NLdkVWnSfkTY0tLWCYRut6ZdHZDbGs3AryOpNiW0LUhHkCpY6SoUqkHFRfnGA4KiRZZp4y8iX/DgJA6bctoLidWHJnb6D+KPGL4RbSsuGldFaK3vyVex6NSRinvHfAwstd3o5N4WRzRAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nj0JnatA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741167793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vq2Dveu3Lu0iWioX9TM10BGhlOQ2RzAuJnxk7fM0ty0=;
	b=Nj0JnatAECUV5VOB1esIorcmwRciGTkJA7auRLteGsfg7AFz8M9d+S8IEd4Ei3B4mueMJK
	pLRy65QpuU91vaY5/MxLfzk3g83NWogO9bdlEVzmLDatql7fHQ6brltTeVLuYhwUaoVTxI
	H48numTeVAhLzkqDaWeH++gGu3k4dk4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-ZPs0NUNcPdaXbtez8BVAwg-1; Wed, 05 Mar 2025 04:43:04 -0500
X-MC-Unique: ZPs0NUNcPdaXbtez8BVAwg-1
X-Mimecast-MFC-AGG-ID: ZPs0NUNcPdaXbtez8BVAwg_1741167783
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-abf4c4294b0so68378166b.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 01:43:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741167783; x=1741772583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vq2Dveu3Lu0iWioX9TM10BGhlOQ2RzAuJnxk7fM0ty0=;
        b=iGY39pSC52gWsox/MKrFMQD/QBemBTmlc0V4U2eJxP5BUH/rJ32HELlWnYVvH1Lo3V
         n936TL8qLqwpvDr3pkelKHhFfpncAN3koevjMyjvTTowpiavZCzy+IbT1Mrj2gr4+Xgd
         FGOXW6OAxfQkJPqTu0OujHhxNVgF55EINF6rP4C50mEojBw6mUMW6Q8QX3BqebNvB9GY
         13e79cTuuW5YapMCF5SMxkMai8hRC569bcCUCx5iKD3u97zW+x2W8EUz9Gs2XQs8r74a
         NWkYhqIBzLyQTRvqoYrugLbyh251Gues5NHjBRXhAMGmvDKV/9lTcIw+8gwlrGFzvgfm
         ouYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUps9MB2lORgH8pvf8SCEU0XAAILlTp7EHj6xeo6nmBqsnthpLMaw1Y+DJ+tCAZBFqp1Z4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi8AYhRV9XatCBCHDI2A3Df919q4grQ/lqUTsFSwU9pBeyPlwP
	IAg5iF45J51kzeAtwttgEq63iHOfij23xe+NgNt4rNkyjNWP4E5dkfLpgQLqogjWxfJtkodCucJ
	XenQedfjbMCssF26qMo5dAce9Ui16xHFZkYFSRAXRjrsb/cdz5w==
X-Gm-Gg: ASbGncsFPBHiY8q6bq/aRSJkv73+YJ8UU03A5rMjIgUJ6g1/uE/TPTIwNX6Jm9vTaTy
	Hitt/CEA4KA80Ymupho7Y5EFbi3MnMn9IZvgB1VmHDcGEC4m2hLBh1QK/zYnJhFr+Y2lbvXzNsS
	xzgU04TfJ22mG5TrwSLlWJ5dO3PztJeXgqAWyI/82Y6GGfiMpOhad21bZBIQ/HYCWkXn6ZViCK5
	x3a2od8gTKTiqLP7jBOVULcsX0Gr1qFnHVHgAgWjAAjIarqjshNT9jyPGN212mabdPO4zKQjqqD
	DLqPHc63yTe9pDXmiYXMrONOFqJF06qp8+nrNNNHKETsTAAfHDwyMsoDBPUBDOHy
X-Received: by 2002:a17:906:c148:b0:ac1:f247:69f5 with SMTP id a640c23a62f3a-ac20f0139aemr209685266b.28.1741167783279;
        Wed, 05 Mar 2025 01:43:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5B6S50i1HDHEaJU/jj+bI1k8KZTn2nF4k4C13v/0HHoQCH0wJ+1c900aMe64d5Ks6YGak+w==
X-Received: by 2002:a17:906:c148:b0:ac1:f247:69f5 with SMTP id a640c23a62f3a-ac20f0139aemr209681866b.28.1741167782581;
        Wed, 05 Mar 2025 01:43:02 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac21dd2c297sm28756566b.110.2025.03.05.01.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 01:43:02 -0800 (PST)
Date: Wed, 5 Mar 2025 10:42:58 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>, 
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>, 
	virtualization@lists.linux-foundation.org, linux-hyperv@vger.kernel.org, 
	"Michael S. Tsirkin" <mst@redhat.com>, Dexuan Cui <decui@microsoft.com>, 
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <cmkkkyzyo34pspkewbuthotojte4fcjrzqivjxxgi4agpw7bck@ddofpz3g77z7>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <Z8eVanBR7r90FK7m@devvm6277.cco0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Z8eVanBR7r90FK7m@devvm6277.cco0.facebook.com>

On Tue, Mar 04, 2025 at 04:06:02PM -0800, Bobby Eshleman wrote:
>On Thu, Jan 16, 2020 at 06:24:25PM +0100, Stefano Garzarella wrote:
>> RFC -> v1:
>>  * added 'netns' module param to vsock.ko to enable the
>>    network namespace support (disabled by default)
>>  * added 'vsock_net_eq()' to check the "net" assigned to a socket
>>    only when 'netns' support is enabled
>>
>> RFC: https://patchwork.ozlabs.org/cover/1202235/
>>
>> Now that we have multi-transport upstream, I started to take a look to
>> support network namespace in vsock.
>>
>> As we partially discussed in the multi-transport proposal [1], it could
>> be nice to support network namespace in vsock to reach the following
>> goals:
>> - isolate host applications from guest applications using the same ports
>>   with CID_ANY
>> - assign the same CID of VMs running in different network namespaces
>> - partition VMs between VMMs or at finer granularity
>>
>> This new feature is disabled by default, because it changes vsock's
>> behavior with network namespaces and could break existing applications.
>> It can be enabled with the new 'netns' module parameter of vsock.ko.
>>
>> This implementation provides the following behavior:
>> - packets received from the host (received by G2H transports) are
>>   assigned to the default netns (init_net)
>> - packets received from the guest (received by H2G - vhost-vsock) are
>>   assigned to the netns of the process that opens /dev/vhost-vsock
>>   (usually the VMM, qemu in my tests, opens the /dev/vhost-vsock)
>>     - for vmci I need some suggestions, because I don't know how to do
>>       and test the same in the vmci driver, for now vmci uses the
>>       init_net
>> - loopback packets are exchanged only in the same netns
>
>
>Hey Stefano,
>
>I recently picked up this series and am hoping to help update it / get
>it merged to address a known use case. I have some questions and
>thoughts (in other parts of this thread) and would love some
>suggestions!

Great!

>
>I already have a local branch with this updated with skbs and using
>/dev/vhost-vsock-netns to opt-in the VM as per the discussion in this
>thread.
>
>One question: what is the behavior we expect from guest namespaces?  In
>v2, you mentioned prototyping a /dev/vsock ioctl() to define the
>namespace for the virtio-vsock device. This would mean only one
>namespace could use vsock in the guest? Do we want to make sure that our
>design makes it possible to support multiple namespaces in the future if
>the use case arrives?

Yes, I guess it makes sense that multiple namespaces can communicate 
with the host and then use the virtio-vsock device!

IIRC, the main use case here was also nested VMs. So a netns could be 
used to isolate a nested VM in L1 and it may not need to talk to L0, so 
the software in the L1 netns can use vsock, but only to talk to L2.

>
>More questions/comments in other parts of this thread.

Sure, I'm happy to help with this effort with discussions/reviews!

Stefano



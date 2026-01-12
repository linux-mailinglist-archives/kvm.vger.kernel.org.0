Return-Path: <kvm+bounces-67753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F3606D12E13
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:45:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 59EEA302A12D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85D535A93D;
	Mon, 12 Jan 2026 13:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AWUr2+59";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qiNS3od3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8B1330339
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768225477; cv=none; b=H1iS2w5AC1Kk5KhQfX/dapKddale8xBEuw4p/f483h9X9MvCzoq7DM8gGIqQVI95ldIUKaQ54Ni3GvWSCT25fkJ1lNM1ZkKP/VZKhi7+JtTl0+fZSGeYktVXQc4LsOmShwrqb8GXJdssqz38GVLZN7sJj2g0xqG0g4a2XjQ97pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768225477; c=relaxed/simple;
	bh=DCCkMKE37W8wsRrMCbvNOdPo7w9XG07KVqWsm2N1Xpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abyOa45z17RkTYrB/jmEmKGuikZEn5AkXCZ1dVXUSjRQ6Qjg7LZsUBA5aGAj7jg1ZqFu3Y+jhAXW7L+YD/Q8ZkpXUxAa7HXy9Rk3x8wKZFEcuihCM3GkhnVRKuKk37iMn8rq+Ak+Ie6EWoHL0GZ2tvs3mlRohZvO4EOxrGlONm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AWUr2+59; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qiNS3od3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768225474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GGW9mZKBtph9QlALl3Ep6OTQikES/GMT3cQq+RonefE=;
	b=AWUr2+59kaumIcEiBOCLbIFfzVrQtfWpY3tRIkWQDRUI8kjxlgvnw7zpvFhQjrKmsXAJ5J
	BCo0cFHhM9TNoTelVeUVsFoOaKumEJKsTm8RpxWMwZ/bpp3CcCenV4NnZVb0i4+a6NWpOW
	3Nr31bcTafrFcgwyO+hWk6O4i+Dr28k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-C3rem0CWPvaCznfXtTgjyw-1; Mon, 12 Jan 2026 08:44:32 -0500
X-MC-Unique: C3rem0CWPvaCznfXtTgjyw-1
X-Mimecast-MFC-AGG-ID: C3rem0CWPvaCznfXtTgjyw_1768225472
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so74667625e9.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768225472; x=1768830272; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GGW9mZKBtph9QlALl3Ep6OTQikES/GMT3cQq+RonefE=;
        b=qiNS3od3GOnLgq+P5/7oimKOOWqNtEzTGNDE1Y8jOTXWY/Mx/zbF2cQfEoo/xKuNSJ
         cJRhF/jxpe+geDPEHe3DEqMZpJ0QLAbtFQQCDoylksUczBezAg6HnK20djEVlR3uDBjK
         dz4qKoeaSk1E2xzcG0oW1YKCtGEpgG5M6zB1Gy9Q85jfq5iiuaLQvC7lDY1zuMFIOFEY
         Ai4xBGwkASoOY5bq79cl2K0YcrjI6GXqixAUKJlqOn0o9IpV4B1CaN2bOgjYvV9wJ2rA
         yn2NnevsMvbGtHPyBX7Dc51wxtVvZ1rnQKy6QYi8hR8icxb+sEQQNL1O4tT11sCjIFWN
         r2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768225472; x=1768830272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GGW9mZKBtph9QlALl3Ep6OTQikES/GMT3cQq+RonefE=;
        b=ty+IeZSl3HNMELrLo5gh7VuNClCvlWq4eMeyvD88SZasBu6QUr9TTP9YScb3tnPlM9
         eBn5cnlAmHoMf0iYMLLZCpS+xCoLuTX1HyIrtTFdRmfHbABBKZHz1ldxK199pUlPEmnF
         6PwF3t3ZanHrZm/HFs3lh5t9n/tAT2HwzED6JFQAIf9Nneq2oCSQtwAApPfYopEvqOS6
         ygJbqxdjgVoHoh5PWYu4PwFA1IYV33OxZMUUacZj8TAH3f7YL8tUW6o9e2qh8VU1O3v1
         3esurAh28wWLv8R4/4p85tSFogBh1zHLpikimdwZxHx6GAuZF9p3fYuo9weBm1A/1EDk
         Bpjw==
X-Forwarded-Encrypted: i=1; AJvYcCVlbJdS2dXHUXO/BpWuT339jMJ3kmu2gyq2mpD7J3eRGEXK83skB1PQifOwWUZIGESQPzg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6SXmTT/xy/irC4GcfpoyTHPulMrrMxfzuqVOrP76DjvpcrX2c
	ZyPk3qEHOsP4ub/0svPTiFI+OOf4hJeMiY9O6H+kOKUPfbme69lrD5xJWB3AekLAjvOY4CP637A
	bnziENzv+1VDmn0eQo2nUny6daGvAzNvAVA93FDO+ebUsmgp0nA3Wew==
X-Gm-Gg: AY/fxX6uNOI6GkRBhpOZuuKTZ/hX8SXORLCaAj+nB9ohADMtcEstwfSkMRxXF24YbxE
	RIV16o5jdmaoX24KFsUB2FWJ9tqNGNjR1H5rFNe3xDRJuKKG28MUHW17OhIXHyQ0iIDPUrQBAWM
	c8qY9W9oZG6ftQ7MXGSFGg3J1qEZKVjHiaUxyLK9HtOZ8Ak88DV8fQAZT1ADPixoGMc6qKKZrv9
	VbX2d9dLn2WXOs8eUAQbLX0znh/H8eM6Mn2PACttbASy86pcmsMqaZcQy81/hEcS8NchSpqcO6Q
	seoHQ0maZkcvtPQioq1l2D+s420u/Jxh46CuiRMrtfodcWi/XCwcN2kPoVc/skh1u5zy4dwMXnZ
	qEDXpgQKhw+nvU48Kd0vsSCkQnVCH4bkstV0mwG1tM2BAsaxM50/hyFT+UlcJVQ==
X-Received: by 2002:a05:600c:8506:b0:477:9ce2:a0d8 with SMTP id 5b1f17b1804b1-47d849bd201mr172455845e9.0.1768225471678;
        Mon, 12 Jan 2026 05:44:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGm2s3Ka0LVsovFun71Z5V7/5VR95//yL24AIdoBztX46nKJnlOhC/MqZHEuukOdh9k4vo5Pw==
X-Received: by 2002:a05:600c:8506:b0:477:9ce2:a0d8 with SMTP id 5b1f17b1804b1-47d849bd201mr172455485e9.0.1768225471211;
        Mon, 12 Jan 2026 05:44:31 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432d286cdecsm25026149f8f.7.2026.01.12.05.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:44:30 -0800 (PST)
Date: Mon, 12 Jan 2026 14:44:24 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vsock/test: Add test for a linear and non-linear skb
 getting coalesced
Message-ID: <aWT6EH8oWpw-ADtm@sgarzare-redhat>
References: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
 <20260108-vsock-recv-coalescence-v1-2-26f97bb9a99b@rbox.co>
 <aWEqjjE1vb_t35lQ@sgarzare-redhat>
 <76ca0c9f-dcda-4a53-ac1f-c5c28d1ecf44@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <76ca0c9f-dcda-4a53-ac1f-c5c28d1ecf44@rbox.co>

On Sun, Jan 11, 2026 at 11:59:54AM +0100, Michal Luczaj wrote:
>On 1/9/26 17:32, Stefano Garzarella wrote:
>> On Thu, Jan 08, 2026 at 10:54:55AM +0100, Michal Luczaj wrote:
>>> Loopback transport can mangle data in rx queue when a linear skb is
>>> followed by a small MSG_ZEROCOPY packet.
>>
>> Can we describe a bit more what the test is doing?
>
>I've expanded the commit message:
>
>To exercise the logic, send out two packets: a weirdly sized one (to ensure
>some spare tail room in the skb) and a zerocopy one that's small enough to
>fit in the spare room of its predecessor. Then, wait for both to land in
>the rx queue, and check the data received. Faulty packets merger manifests
>itself by corrupting payload of the later packet.

Thanks! LGTM!

>
>>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>>> ---
>>> tools/testing/vsock/vsock_test.c          |  5 +++
>>> tools/testing/vsock/vsock_test_zerocopy.c | 67 +++++++++++++++++++++++++++++++
>>> tools/testing/vsock/vsock_test_zerocopy.h |  3 ++
>>> 3 files changed, 75 insertions(+)
>>>
>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>> index bbe3723babdc..21c8616100f1 100644
>>> --- a/tools/testing/vsock/vsock_test.c
>>> +++ b/tools/testing/vsock/vsock_test.c
>>> @@ -2403,6 +2403,11 @@ static struct test_case test_cases[] = {
>>> 		.run_client = test_stream_accepted_setsockopt_client,
>>> 		.run_server = test_stream_accepted_setsockopt_server,
>>> 	},
>>> +	{
>>> +		.name = "SOCK_STREAM MSG_ZEROCOPY coalescence corruption",
>>
>> This is essentially a regression test for virtio transport, so I'd add
>> virtio in the test name.
>
>Isn't virtio transport unaffected? It's about loopback transport (that
>shares common code with virtio transport).

Why virtio transport is not affected?

>
>>> +		.run_client = test_stream_msgzcopy_mangle_client,
>>> +		.run_server = test_stream_msgzcopy_mangle_server,
>>> +	},
>>> 	{},
>>> };
>>>
>>> diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
>>> index 9d9a6cb9614a..6735a9d7525d 100644
>>> --- a/tools/testing/vsock/vsock_test_zerocopy.c
>>> +++ b/tools/testing/vsock/vsock_test_zerocopy.c
>>> @@ -9,11 +9,13 @@
>>> #include <stdio.h>
>>> #include <stdlib.h>
>>> #include <string.h>
>>> +#include <sys/ioctl.h>
>>> #include <sys/mman.h>
>>> #include <unistd.h>
>>> #include <poll.h>
>>> #include <linux/errqueue.h>
>>> #include <linux/kernel.h>
>>> +#include <linux/sockios.h>
>>> #include <errno.h>
>>>
>>> #include "control.h"
>>> @@ -356,3 +358,68 @@ void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts)
>>> 	control_expectln("DONE");
>>> 	close(fd);
>>> }
>>> +
>>> +#define GOOD_COPY_LEN	128	/* net/vmw_vsock/virtio_transport_common.c */
>>
>> I think we don't need this, I mean we can eventually just send a single
>> byte, no?
>
>For a single byte sent, you get a single byte of uninitialized kernel
>memory. Uninitialized memory can by anything, in particular it can be
>(coincidentally) what you happen to expect. Which would result in a false
>positive. So instead of estimating what length sufficiently reduces
>probability of such false positive, I just took the upper bound.

I see, makes sense to me.

>
>BTW, I've realized recv_verify() is reinventing the wheel. How about
>dropping it in favour of what test_seqpacket_msg_bounds_client() does, i.e.
>calc the hash of payload and send it over the control channel for verification?

Yeah, strongly agree on that.

>
>>> +
>>> +void test_stream_msgzcopy_mangle_client(const struct test_opts *opts)
>>> +{
>>> +	char sbuf1[PAGE_SIZE + 1], sbuf2[GOOD_COPY_LEN];
>>> +	struct pollfd fds;
>>> +	int fd;
>>> +
>>> +	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
>>> +	if (fd < 0) {
>>> +		perror("connect");
>>> +		exit(EXIT_FAILURE);
>>> +	}
>>> +
>>> +	enable_so_zerocopy_check(fd);
>>> +
>>> +	memset(sbuf1, '1', sizeof(sbuf1));
>>> +	memset(sbuf2, '2', sizeof(sbuf2));
>>> +
>>> +	send_buf(fd, sbuf1, sizeof(sbuf1), 0, sizeof(sbuf1));
>>> +	send_buf(fd, sbuf2, sizeof(sbuf2), MSG_ZEROCOPY, sizeof(sbuf2));
>>> +
>>> +	fds.fd = fd;
>>> +	fds.events = 0;
>>> +
>>> +	if (poll(&fds, 1, -1) != 1 || !(fds.revents & POLLERR)) {
>>> +		perror("poll");
>>> +		exit(EXIT_FAILURE);
>>> +	}
>>
>> Should we also call vsock_recv_completion() or we don't care about the
>> result?
>>
>> If we need it, maybe we can factor our the poll +
>> vsock_recv_completion().
>
>Nope, we don't care about the result.
>

Okay, I see.

Thanks,
Stefano



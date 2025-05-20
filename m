Return-Path: <kvm+bounces-47089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D2EABD270
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 583301714EE
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CF626772C;
	Tue, 20 May 2025 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZrIrwnOF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228AC265CAC
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 08:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747731288; cv=none; b=JyUK3Xhg2PlPhiSLyF2u9+RyAUo1ubv0I0kg4i7XDtKdSLS/7eMacIkZqYYkmcHM1XAN95WztjN78wxTLv4+MWuCxb4u3HqVF6YckQgxeogBitCX7ZIqXsAOi85eFjXlwUTZ2MS2rHl8Jy3KT39XeXaRfL5CmgVsOZ8RSz7UX8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747731288; c=relaxed/simple;
	bh=EW8+ltB5RD/cj4k61+Elnw7V9Vm0GX9HYQV8/qmM9fY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DjT2RLePNWYQosEpeXoU99uCBQ/tmikGkkhUbXgzwigkb4lWpK4CPK9RJsBck5RJjIVy3SXxZSvYfx78uFjbL43PcZIMT26jOst8jbBj346hb5gSF8Pr6sxPS2GtV/CuAbOd4Mr8jJf88PDeDlC33yFX4xGv8/etLoZUxJIWDQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZrIrwnOF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747731285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K84RlwjKxdVMrP8H1/lSZbVNtNLQI+5UHNrYUWsQ7to=;
	b=ZrIrwnOFEuqLWNPfXWVdj5GnZ9sinNb4i+fTjtkI1q4GTVomC/LHWPfArrOwEqA/HLrHLM
	3TBfDjoiHkfgLKlDUTg8Gfmc9npmfyizgiu3fs51sceQNE8rMrVhxT8XLZ5WJFrEkrZhHi
	CEMMXRK1Gg4TMsgEComHckS/XOS7Xt8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-HjrlBCrrNx6Gn8Zd-KIjHw-1; Tue, 20 May 2025 04:54:43 -0400
X-MC-Unique: HjrlBCrrNx6Gn8Zd-KIjHw-1
X-Mimecast-MFC-AGG-ID: HjrlBCrrNx6Gn8Zd-KIjHw_1747731282
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ad55e9a80acso166565766b.3
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 01:54:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747731282; x=1748336082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K84RlwjKxdVMrP8H1/lSZbVNtNLQI+5UHNrYUWsQ7to=;
        b=B9pHJ2KjDD4u6uZSkPQsLpkmDMRedCFxZVgsVwM2F6anYg5B18u8DpKfCiMmiQNG8N
         fVa9i8EMR5WxYR8WrGTYprlzwsHCbfJvmOljaCZrkPOQv2WAF2bfaMnEnYQb93mHwCxL
         3KgKgxE8cYZdlyZQobaSm+8F9uyWEuXo0E368pcVC9ELhujgjRkAOzylRw4/DEhCb60i
         92QmIpum2OTvjlxUJWD/f7fw8l36uX6Ip+3rjdxliQzkSVMozFEqAzruNJPR5wJnXvXa
         EGXF8FCDWatwSrb79NcUIDLWXtZ0h0oXiQk0M0d3I6bJSxZXmNWcrVO9gF5PYkrVvqTK
         VT3g==
X-Forwarded-Encrypted: i=1; AJvYcCVVlb1r6VmCT4Uxgom5VwMfmB3wN73vyT5FY6Vo1YjJhYwnzIxZ2aoLyk0gEe90DPizWwI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCWDblPZg6mEt9SihiouuOb9+0LXiNcgE4Ho5TdJrXhWXknqCv
	0Q4jdCJ+bR3/dj1j/hW3lAYv0zTHp1vkBSnRrxcPcdGEeUl9S0f+oTOMoLc3a6eAAVBZvaf/FxR
	ZVDqBEL9ryshMt6RcgXY2jkwwfB2Jt6S4GS7VfCSNNI6IPGiK+RsV8A==
X-Gm-Gg: ASbGncvd4WBm2WOf4++JxdGSMS5YgR/5PC9mV68z46VurHo1WSf0eVKstVySkCfzhhP
	Ju14+gd9sNBdLd0bGUiitZPYBcoZgzYA7+mn3CLSDpnaFSlsdgkiSI7+ea5cx6/o5dH7ahZkKqn
	f4uMGA2x63WemMGKBZs4pv9/BQIBBP6IKH1tJdixaol/wBVrmqatN0lrCR4/O0oHYlRAff6l6Jm
	/jM+4A1fdZgxCBuLtbyfwA0GTM+Wk1uLnDgxfdHYgUVa/awSHo2/e4+LDAwh1knMy77tvMIc3Mv
	QBVNjkX+ld21A/EK9R7TjYzBo/eL/kfpaZ/n9lMwrU1MGpn0TNcWjbvhZV0U
X-Received: by 2002:a17:907:7e87:b0:acb:5c83:25b with SMTP id a640c23a62f3a-ad52d42bf0cmr1554050166b.7.1747731282108;
        Tue, 20 May 2025 01:54:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1u3cs6wd8rFHSzcQTyYA8XLXVHbvNEiRktGHBow2x1xCtVqQdufsC3hsDqcyuuMCDDTKafQ==
X-Received: by 2002:a17:907:7e87:b0:acb:5c83:25b with SMTP id a640c23a62f3a-ad52d42bf0cmr1554045766b.7.1747731281366;
        Tue, 20 May 2025 01:54:41 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d278282sm689962766b.80.2025.05.20.01.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 01:54:40 -0700 (PDT)
Date: Tue, 20 May 2025 10:54:33 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/3] vsock/test: Expand linger test to ensure
 close() does not misbehave
Message-ID: <37c5ymzjhr3pivvx6sygsdqmrr72solzqltwhcsiyvvc3iagiy@3vc3rbxrbcab>
References: <20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co>
 <20250501-vsock-linger-v4-3-beabbd8a0847@rbox.co>
 <g5wemyogxthe43rkigufv7p5wrkegbdxbleujlsrk45dmbmm4l@qdynsbqfjwbk>
 <CAGxU2F59O7QK2Q7TeaP6GU9wHrDMTpcO94TKz72UQndXfgNLVA@mail.gmail.com>
 <ff959c3e-4c47-4f93-8ab8-32446bb0e0d0@rbox.co>
 <CAGxU2F77OT5_Pd6EUF1QcvPDC38e-nuhfwKmPSTau262Eey5vQ@mail.gmail.com>
 <720f6986-8b32-4d00-b309-66a6f0c1ca40@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <720f6986-8b32-4d00-b309-66a6f0c1ca40@rbox.co>

On Mon, May 12, 2025 at 02:23:12PM +0200, Michal Luczaj wrote:
>On 5/7/25 10:26, Stefano Garzarella wrote:
>> On Wed, 7 May 2025 at 00:47, Michal Luczaj <mhal@rbox.co> wrote:
>>>
>>> On 5/6/25 11:46, Stefano Garzarella wrote:
>>>> On Tue, 6 May 2025 at 11:43, Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>>>
>>>>> On Thu, May 01, 2025 at 10:05:24AM +0200, Michal Luczaj wrote:
>>>>>> There was an issue with SO_LINGER: instead of blocking until all queued
>>>>>> messages for the socket have been successfully sent (or the linger timeout
>>>>>> has been reached), close() would block until packets were handled by the
>>>>>> peer.
>>>>>
>>>>> This is a new behaviour that only new kernels will follow, so I think
>>>>> it is better to add a new test instead of extending a pre-existing test
>>>>> that we described as "SOCK_STREAM SO_LINGER null-ptr-deref".
>>>>>
>>>>> The old test should continue to check the null-ptr-deref also for old
>>>>> kernels, while the new test will check the new behaviour, so we can skip
>>>>> the new test while testing an old kernel.
>>>
>>> Right, I'll split it.
>>>
>>>> I also saw that we don't have any test to verify that actually the
>>>> lingering is working, should we add it since we are touching it?
>>>
>>> Yeah, I agree we should. Do you have any suggestion how this could be done
>>> reliably?
>>
>> Can we play with SO_VM_SOCKETS_BUFFER_SIZE like in credit-update tests?
>>
>> One peer can set it (e.g. to 1k), accept the connection, but without
>> read anything. The other peer can set the linger timeout, send more
>> bytes than the buffer size set by the receiver.
>> At this point the extra bytes should stay on the sender socket buffer,
>> so we can do the close() and it should time out, and we can check if
>> it happens.
>>
>> WDYT?
>
>Haven't we discussed this approach in [1]? I've reported that I can't make

Sorry, I forgot. What was the conclusion? Why this can't work?

>it work. But maybe I'm misunderstanding something, please see the code 
>below.

What I should check in the code below?

Thanks,
Stefano

>
>[1]:
>https://lore.kernel.org/netdev/df2d51fd-03e7-477f-8aea-938446f47864@rbox.co/
>
>import termios, time
>from socket import *
>
>SIOCOUTQ = termios.TIOCOUTQ
>VMADDR_CID_LOCAL = 1
>SZ = 1024
>
>def set_linger(s, timeout):
>	optval = (timeout << 32) | 1
>	s.setsockopt(SOL_SOCKET, SO_LINGER, optval)
>	assert s.getsockopt(SOL_SOCKET, SO_LINGER) == optval
>
>def set_bufsz(s, size):
>	s.setsockopt(AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE, size)
>	assert s.getsockopt(AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE) == size
>
>def check_lingering(addr):
>	lis = socket(AF_VSOCK, SOCK_STREAM)
>	lis.bind(addr)
>	lis.listen()
>	set_bufsz(lis, SZ)
>
>	s = socket(AF_VSOCK, SOCK_STREAM)
>	set_linger(s, 5)
>	s.connect(lis.getsockname())
>
>	p, _ = lis.accept()
>
>	s.send(b'x')
>	p.recv(1)
>
>	print("sending...")
>	s.send(b'x' * (SZ+1)) # blocks
>	print("sent")
>
>	print("closing...")
>	ts = time.time()
>	s.close()
>	print("done in %ds" % (time.time() - ts))
>
>check_lingering((VMADDR_CID_LOCAL, 1234))
>



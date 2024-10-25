Return-Path: <kvm+bounces-29704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE009B009A
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 12:54:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C543285465
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 10:54:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5611F8F08;
	Fri, 25 Oct 2024 10:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q9RFf7MX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CA61F81AF
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 10:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729853680; cv=none; b=tcbQ0G4XMN48OiZ2Zl6WqyQrbUz5bB7wLhf+DzuonOhQ0Py7HHD3qEojnFlc36uUICDrHLYxAAxoRC5A4i2ea4xocxsZDBpafjoUO5IpUtSQhSvqx+F0frLBeraqZf01Btb0cuSP/Zl6R1uOiV2Vdz9B5TavXPNC5L3R7SY6YYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729853680; c=relaxed/simple;
	bh=avMLLefhq5M2tr0I4Wur4AOze6yAMsZFBYF9tCtbbCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aORLgxz7SQ15B2jy62DTVUxLJ2yG4zZv4wkfklTNroa8dj6ykJdej/b1OCBeCFt3xcD7hIQPOimPR+B4THfJLtx4qLajsB/+mKdLJALQ2WMY87piRy+JrnMY/GijJsNuXrCWjHPQodU7Qfowz6zbMk2LISPLSKSntdsnA1XT+9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q9RFf7MX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729853677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lX6wkw61ogYPGQv+Og/9qyA9gtBeGLjVgM8dxDOIajo=;
	b=Q9RFf7MXatjJvG+x24BOLiePfgICinkosSBQPAEpyIu84acX4Zkm6Hv1p+AjtZCakH10Nb
	sXv1deFwFvrg4H34inG75DPOgJRX8daec3Kyg6bsp+MfQul2M0naEjuNeg1SzWqrirekZC
	OjQ1/fT12SsLcCyOCSUz6T+EW981AD4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-HPJPgD7BN7-3J7-LxkDF6g-1; Fri, 25 Oct 2024 06:54:35 -0400
X-MC-Unique: HPJPgD7BN7-3J7-LxkDF6g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4314f023f55so14497975e9.2
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 03:54:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729853674; x=1730458474;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lX6wkw61ogYPGQv+Og/9qyA9gtBeGLjVgM8dxDOIajo=;
        b=BFZZzdeUMjp/Y6mtSjddoUTZHcIT3SPyhCefC8OjvZy+E/e/Vd0O9gSxRHFaH7zaWz
         XFtFrur7olhBizI+gTJ2TdTO3R0xcNHiVhk3ZlfOcbeHtu2i13ZX9P2MBuceD11OoaWC
         E2YeJ7RHdu5dZgRoPLu46BjQc81m8yyPRuLsis1J+aPwd9uj83CjgVniesqGRZd/PQ8e
         BlyO6bEyscSSNrGe+NrHBgCzfs1fVy3bUMGE+Gcw8krESmDWLky83ZL04ofXZ86ib2Bx
         SrvHJAaCH4/ze8QicyTM9kmW/HuKYS5nzDDAfBKTgqpEOEyKBKp3qydFwj95ybQTiy0E
         49cg==
X-Forwarded-Encrypted: i=1; AJvYcCV+XSRKF9XNRDVY67OLyYx0Aeznow8uaAKown9i00rotuKMNnMBlRGO1W3Fv1s5rhcjE0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPKQR3BbMXELbJiOTn46Z7Ro64aIi5E7sPbHxQ1Ctkg/vMWiSG
	AzwcdOwwTdK+oLDH5bkVCdDPylHdX6r7U35eZdD3OiUgfDoLHBuS/f98Y8kgrjN0trN0wGjJ1Nz
	cS5fFd925R2vkHzeRPhXQ7aUQO5tmyFvhPzlMXypnGev3AmreEg==
X-Received: by 2002:a05:600c:1c07:b0:431:93d8:e1a1 with SMTP id 5b1f17b1804b1-43193d8e71dmr10357235e9.27.1729853674525;
        Fri, 25 Oct 2024 03:54:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7IVOreW4+B4iSirpxWHeAO6cOJxr4GiTaPS55IIWw1AHwJeNbZt687nEp5ciutpoHBueS4Q==
X-Received: by 2002:a05:600c:1c07:b0:431:93d8:e1a1 with SMTP id 5b1f17b1804b1-43193d8e71dmr10357085e9.27.1729853674128;
        Fri, 25 Oct 2024 03:54:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:d800:499c:485a:c734:f290? (p200300cbc70dd800499c485ac734f290.dip0.t-ipconnect.de. [2003:cb:c70d:d800:499c:485a:c734:f290])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4319360c0besm14204715e9.41.2024.10.25.03.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2024 03:54:33 -0700 (PDT)
Message-ID: <8395194d-6c9d-4324-a475-1b856707a729@redhat.com>
Date: Fri, 25 Oct 2024 12:54:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] virtio-mem: s390 support
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014185659.10447-H-hca@linux.ibm.com>
 <20241015095735.189a93a9@p-imbrenda.boeblingen.de.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241015095735.189a93a9@p-imbrenda.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.10.24 09:57, Claudio Imbrenda wrote:
> On Mon, 14 Oct 2024 20:56:59 +0200
> Heiko Carstens <hca@linux.ibm.com> wrote:
> 
>> On Mon, Oct 14, 2024 at 04:46:12PM +0200, David Hildenbrand wrote:
>>> Let's finally add s390 support for virtio-mem; my last RFC was sent
>>> 4 years ago, and a lot changed in the meantime.
>>>
>>> The latest QEMU series is available at [1], which contains some more
>>> details and a usage example on s390 (last patch).
>>>
>>> There is not too much in here: The biggest part is querying a new diag(500)
>>> STORAGE_LIMIT hypercall to obtain the proper "max_physmem_end".
>>>
>>> The last two patches are not strictly required but certainly nice-to-have.
>>>
>>> Note that -- in contrast to standby memory -- virtio-mem memory must be
>>> configured to be automatically onlined as soon as hotplugged. The easiest
>>> approach is using the "memhp_default_state=" kernel parameter or by using
>>> proper udev rules. More details can be found at [2].
>>>
>>> I have reviving+upstreaming a systemd service to handle configuring
>>> that on my todo list, but for some reason I keep getting distracted ...
>>>
>>> I tested various things, including:
>>>   * Various memory hotplug/hotunplug combinations
>>>   * Device hotplug/hotunplug
>>>   * /proc/iomem output
>>>   * reboot
>>>   * kexec
>>>   * kdump: make sure we don't hotplug memory
>>>
>>> One remaining work item is kdump support for virtio-mem memory. This will
>>> be sent out separately once initial support landed.
>>
>> Besides the open kdump question, which I think is quite important, how
>> is this supposed to go upstream?
>>
>> This could go via s390, however in any case this needs reviews and/or
>> Acks from kvm folks.
> 
> we're working on it :)

I'll be sending a v3 later today, and a v1 of kdump support (which 
involves a bunch of changes to fs/proc/vmcore.c and virtio-mem) separately.

-- 
Cheers,

David / dhildenb



Return-Path: <kvm+bounces-21506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8F992FB3A
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DA091F23117
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 13:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41B916F85C;
	Fri, 12 Jul 2024 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cxtISaIr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BDB13CFB0
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 13:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720790580; cv=none; b=IhRBQ/vxHyAW/TZFvofkUvtenjgH7t/XBKWHjoKTSIXO9ORDZbaxua2quXzXbzw5KMkDdwvqL5b7EHvVib2OugFUk0PCrJg53lQln8/NldBCnwTQQK0DSm2/iQTwVs+7+VdYaQ8HTIgY6X6Eht2drdKC2D9ULKjZ5rSMszWWxUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720790580; c=relaxed/simple;
	bh=Wo9nqwrN5caNWtK6ZosRdYWBGQnDSRi2uQ9LRIPns8o=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=hxL5Dw25f6a/sClcLIEXAoPLybjEpc46oKu0Syar5XsGerqtf1vmvgfMujBvRKxAwTqxNZ7cMyuoWkkVjlSMSqBVbnOg9hk4HfQ1GVewlGZMmXMRkPAOHlY8AtA5dWLxjuPbsNInRIHYuR5i3d+uNDTtONbU6dllS8U/wu0v+T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cxtISaIr; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2ebed33cb65so27545601fa.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 06:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720790576; x=1721395376; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tpohQPzFdqbOyVoIMbbq1FYVlIhGGnCPtjiHv7/MD8Q=;
        b=cxtISaIrKF3scSL8qg7ua/7mIceABOg+jN+eQ/u4CXdKwM7OaU2uhzUt/EGQ8dx+iO
         2LfQu0QJ165hqCyDIbozJuaMNfzYatYHWAi/3TSr8sFbeeZYvna5KJRNKWwm1YZhuzlq
         /U2vIl7xAFLs+fx+C3USOBEpRD73YHHmBcwP8AgGTLCQRyxJ4aYEv1JUQfrrtcbyTlGl
         brc6/QdW/Xpt1a8xmtP8GcncEKhnJ1a6w1RHx7ZNdm9WF6eu7tQjX/X5FySarri0uNDK
         gQBYjy/fcm6Xu0no9R8vJquBgVZ8MKYFvviuheL9zKOJURhfR91oedx/9BYIZn5YN2ns
         c/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720790576; x=1721395376;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tpohQPzFdqbOyVoIMbbq1FYVlIhGGnCPtjiHv7/MD8Q=;
        b=BZME52/980hCDRTIvPD9CK/SHlkLKOGxj7wwLDxChPVFmhxEDhrVY+y5TvWWoEctK+
         DkC8a/hmPcGnir1G+uL6gybzTk/ZdxKkPGjR5xNaxOUhxo9+dOWFQA1RPki/eqoZDa/L
         4zu6T6PHyt5wtD9z+vTFltgxRkgCBoxa8kM3Ep6lY/PL85MYxzr9CURecKpeHo07uhSj
         R1aRkVkxCjJqo/0JpxCI+UpjZyQLXFM0bgppseBEVlx30ZJMmd1tsDmL6LPu4ecREDof
         /IF+GcTfZJPIHhTGXgwNHDqf+oGkxhLZSysP/D8L7a3MBpoHwvadgQcTEpjuEXSuUqpo
         EwRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIGn9QSQKxB1Yq4UaRVJOtd2OnTf9p/MNX1m5N8afMDQ4Bj2kiH/1hG3MXiqQmLZg5DCYr+q0Wvbg1ojii/oe+oHfC
X-Gm-Message-State: AOJu0YybEqAPYIWShRn60cCu9X8PzdFi66PmCDx8HP9rQX3SnAAT43Y2
	FBEn8XH33HKVNx+y4+gUbnaeNup/FfGa12+LkqCwUZ+GtXPu+FyS
X-Google-Smtp-Source: AGHT+IHUXeYg4yzp6K+Wrdh2NaPNP1aI3fllYXe5FtdTS4lQu4TqDS2Dew/pooKdowEG18/Kt3TJSw==
X-Received: by 2002:a2e:b163:0:b0:2ee:8b58:5ec2 with SMTP id 38308e7fff4ca-2eeb3188cbamr74940511fa.32.1720790576173;
        Fri, 12 Jul 2024 06:22:56 -0700 (PDT)
Received: from [192.168.9.51] (54-240-197-224.amazon.com. [54.240.197.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f2cc499sm22817605e9.29.2024.07.12.06.22.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 06:22:55 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <6caf5328-80e5-481b-ae2b-9c0e55d81994@xen.org>
Date: Fri, 12 Jul 2024 15:22:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] KVM: Add KVM_CREATE_COALESCED_MMIO_BUFFER ioctl
To: Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com
Cc: pdurrant@amazon.co.uk, dwmw@amazon.co.uk, Laurent.Vivier@bull.net,
 ghaskins@novell.com, avi@redhat.com, mst@redhat.com,
 levinsasha928@gmail.com, peng.hao2@zte.com.cn, nh-open-source@amazon.com
References: <20240710085259.2125131-1-ilstam@amazon.com>
 <20240710085259.2125131-3-ilstam@amazon.com>
Content-Language: en-US
Reply-To: paul@xen.org
Organization: Xen Project
In-Reply-To: <20240710085259.2125131-3-ilstam@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/07/2024 10:52, Ilias Stamatis wrote:
> The current MMIO coalescing design has a few drawbacks which limit its
> usefulness. Currently all coalesced MMIO zones use the same ring buffer.
> That means that upon a userspace exit we have to handle potentially
> unrelated MMIO writes synchronously. And a VM-wide lock needs to be
> taken in the kernel when an MMIO exit occurs.
> 
> Additionally, there is no direct way for userspace to be notified about
> coalesced MMIO writes. If the next MMIO exit to userspace is when the
> ring buffer has filled then a substantial (and unbounded) amount of time
> may have passed since the first coalesced MMIO.
> 
> Add a KVM_CREATE_COALESCED_MMIO_BUFFER ioctl to KVM. This ioctl simply
> returns a file descriptor to the caller but does not allocate a ring
> buffer. Userspace can then pass this fd to mmap() to actually allocate a
> buffer and map it to its address space.
> 
> Subsequent patches will allow userspace to:
> 
> - Associate the fd with a coalescing zone when registering it so that
>    writes to that zone are accumulated in that specific ring buffer
>    rather than the VM-wide one.
> - Poll for MMIO writes using this fd.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>   include/linux/kvm_host.h  |   1 +
>   include/uapi/linux/kvm.h  |   2 +
>   virt/kvm/coalesced_mmio.c | 142 +++++++++++++++++++++++++++++++++++---
>   virt/kvm/coalesced_mmio.h |   9 +++
>   virt/kvm/kvm_main.c       |   4 ++
>   5 files changed, 150 insertions(+), 8 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>



Return-Path: <kvm+bounces-16825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2518BE1BD
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 14:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38C6228479F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 12:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D672156F37;
	Tue,  7 May 2024 12:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdaVbSEv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84A6152526
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 12:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715083933; cv=none; b=XHsqiK49KJJysvtfR7l2jz11hpnNwDe5RWCRTS1bsR1HmIYlIbKGy0F/GYf/FzaxFCOyE70hITeZ7PGPyGJ+0mgv+BDXswhSxU/K5/zU17QvViDsyqJ5J3gkYcQIBwG4SZlxMrSMBrcMjSnF42e1ZLcseQ7VslW80lnP4UK3f2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715083933; c=relaxed/simple;
	bh=Dm7BMCqISXd2ReMkwouRU7WnBhcSYa6TYWJVoX3yX0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=irCow2w8jzp2Skn4j7yCCEq5hUQu05lBT32d3eAX1j1zLc4yNJoREoG9COkg+cbtbYqzzJqS2seNj3RGXTAQbq0gk18bJ0gMN8kDktyjdCeIvTKebFEESHH2TWEkcc3PQJb0fY1q1UrlJ0XOjCS0TTNqLR/jiQLkEl+W32RY7r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BdaVbSEv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715083930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S/Rt/oXApoYK9IP8vZV0dgBdJum8ffeGB8fzTzIwuIQ=;
	b=BdaVbSEvJHMVkErZfPwDbkUWG36AT9LlxDXLKykVTuoiuSTc1R64VvwH6m7ZJ05inYq74q
	wiOpWJmtaivYvFxeCg6oONAiOQ9vUkzjeESwanJ97gobVMX6h6BpQp9YNumItoRgcanzCU
	n8TWW1wromstFDpqxi4nz9IFE+cdDoQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-x1ayAd_OMa60yPnqVEFcWg-1; Tue, 07 May 2024 08:12:08 -0400
X-MC-Unique: x1ayAd_OMa60yPnqVEFcWg-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-43d3072072cso36944391cf.3
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 05:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715083928; x=1715688728;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S/Rt/oXApoYK9IP8vZV0dgBdJum8ffeGB8fzTzIwuIQ=;
        b=ZFlN6jqQ5Dlbz6BpgvbLQmhGqunYKiHGTu5aSOnWPWdz9ShkGaPwZJz+9SRO8ROfEz
         oP+tCkk/d9+MCOh1fnTc3xKz6R8fC9oGTpBTy9EtFtEm3nEnRPqCH3b7EHsnFAzkYiyZ
         TbKd2zGBYZer0hh4DMfK0/quSLzUheVoDmWugkFco2vNP80f+FvwkV8eZrOIznBuhr/J
         H5JHm1km8w7+ioCiPUXIS2/SzZf01H71HvYMmPTV+FmnEum9ZHEYU46U47yZUwKBiq7h
         f8zBaFr/nz8HH7U6wH4W4c41fqqldIUbDx1eUwBfS4wItn4MJodwn7Iw8q5iF7ImRL+N
         zzMg==
X-Forwarded-Encrypted: i=1; AJvYcCWOQ9NnIStuSOTQGgdXq8XSS+02OiYN3B/O8KMT9eCuIKjxqbouimy0PuSCWYdFyglE/Gi4HmTeo3d/asrVKmi/Zdt+
X-Gm-Message-State: AOJu0YzApVQ250Il+ZtqOCrWN9T99XJ0/zaL8SUk2LisaND+NOETQvVv
	YwhejyzZGvo4kvYd2kmhv7ccZ8SICev5QOzB+u53X6c5ZsKhxfaQ3CWi/h6qE4GiFqOKyDZz3IM
	jHSG3xgvTJlbvHghGrGknzv1RFy+5t7sNZCxIv1GpcH92re7pTw==
X-Received: by 2002:ac8:5981:0:b0:43a:f577:ea0e with SMTP id e1-20020ac85981000000b0043af577ea0emr16270080qte.47.1715083927890;
        Tue, 07 May 2024 05:12:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/yP6bwlMLnw6uz4Cw+ijC7SOgK2UxZaa1PcaL8Md2gPm+ER9vgzABsQYNLXRCjlkuXORSCw==
X-Received: by 2002:ac8:5981:0:b0:43a:f577:ea0e with SMTP id e1-20020ac85981000000b0043af577ea0emr16270060qte.47.1715083927546;
        Tue, 07 May 2024 05:12:07 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-40-241-109.web.vodafone.de. [109.40.241.109])
        by smtp.gmail.com with ESMTPSA id f9-20020ac84989000000b0043d7b229014sm1629966qtq.77.2024.05.07.05.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 05:12:07 -0700 (PDT)
Message-ID: <1125bbbe-9af0-4d0b-b841-4e0506670acc@redhat.com>
Date: Tue, 7 May 2024 14:12:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 12/31] powerpc: general interrupt tests
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-13-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-13-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> Add basic testing of various kinds of interrupts, machine check,
> page fault, illegal, decrementer, trace, syscall, etc.
> 
> This has a known failure on QEMU TCG pseries machines where MSR[ME]
> can be incorrectly set to 0.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/asm/processor.h |   4 +
>   lib/powerpc/asm/reg.h       |  17 ++
>   lib/powerpc/setup.c         |  11 +
>   lib/ppc64/asm/ptrace.h      |  16 ++
>   powerpc/Makefile.common     |   3 +-
>   powerpc/interrupts.c        | 414 ++++++++++++++++++++++++++++++++++++
>   powerpc/unittests.cfg       |   3 +
>   7 files changed, 467 insertions(+), 1 deletion(-)
>   create mode 100644 powerpc/interrupts.c

Acked-by: Thomas Huth <thuth@redhat.com>



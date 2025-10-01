Return-Path: <kvm+bounces-59369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 370B1BB1BC6
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 23:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4CB83B7993
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 21:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD9818DB26;
	Wed,  1 Oct 2025 21:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H6MBU+hJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933C130AAD7
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 21:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352581; cv=none; b=Q327+TY25OwIWNfAC4ONgHk+1UpWYIw6vm4WeO+R/awvsI3SSJisA5U/clnEhB2pWMl+ruSLb0fRg+ORzMMfvuTrZl/7u76Ad88CwETsCtq6Nxc2JExjN0XTuZlZow9SiaS1LLbXS3BlKu4N19U4Ycpm2Mo8PzwT32sFFqdW4k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352581; c=relaxed/simple;
	bh=OynZ7Soq7x6YNk8QKMdI1fWSQfLaXph+Ty4QyzRY4fs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lxx/RQ6TdRKibsur+S33VA5QMT/Lr33c7vHYuMOMCcBVMbkEr+3uMQ7oOtsFmQ7/MGG14Sa1Dkfr9PCuFrZdmd3aNEXAPJ9qTvLv3me310tO5BnaGnWxOtQGBw4ZFT9zij3FRVbr2jW/XfM32I57sDPOORcxwX9bnFsgcjkw7QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H6MBU+hJ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7800ff158d5so324963b3a.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 14:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759352579; x=1759957379; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TVyQQB+Wmr9wiHfhpv1Q0vD0koj+NE+rQBNo24Jg+8c=;
        b=H6MBU+hJrz7MlmNhavFlvjibpZjnjxI4gV6GAPw1/qpeixKRmlX0tOQsHhpMIkcfpk
         5bD8yAPXqmTkr+Vg0839RGbSWViomYwuMUg6mUqLlen3XAJN5bhXM11Zmi+e6E9yEAdA
         doktijgmoFsEonoPeN809daqzCosTgHzFcm24xuBAeNv/bKfsD7/FjyP3V1o9W23n/Ko
         vtn6CpXLbDf5EPMtDw5yoeJBpI11btUJ/1XitQHRK5dCreVHOeLz3OLemkNi/UKgm8kp
         FdFBwg/cPuZnNreTxEB+uZB8QYdOY6RO9gLPgU1Km+mvJWgyTaMsOOH3WL1KatPvnN7k
         rJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352579; x=1759957379;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TVyQQB+Wmr9wiHfhpv1Q0vD0koj+NE+rQBNo24Jg+8c=;
        b=t17w7Mg7eH/2NDo8qk6omM11cyb3jqp807XZ+6zStb4+Nqkh3LFHcrdqh0Qt64TTuU
         VtEiCDUUyEEDlB1dGCu/eB2nQm66U0/bkdEDZWpBLUWtNhrNqJ2i2p963OSyIytueq9e
         d4LzgcGUK40wG9TfLSU448qE2riyU9JJKFFFMreELR1X2Pv+pUQ+TIVTUjfGE6Je1vEI
         KWuY2C0P1vpPpfxTIA8woXPwiWeR2hTDR5npGJu4hrGFPN8MOBvsrdLlL+tUwaR3t1YQ
         5MS3C5Fkazua7uUBXhPlktmkdC2nBLCNScpLDqVGyERr5qsMtQWRsADQ3z49IuNiNeYJ
         /ShQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVBjAaSYxJzffMTlVSfGZAaZqRiwwxtoZKiVwu7QFH+HERB1ya1FhmPQsxqdyD7jR79fM=@vger.kernel.org
X-Gm-Message-State: AOJu0YynRMKqSyqJtlYXS57/j7LEoGLlgZgMhgU/pQcScpm8jgg80ixJ
	m9okvKetQJsqgMwZszAt7oZjDXdEyc/kqVoaGZfkNvz2tw7UKYc3DfgEyB+fnPkryL8=
X-Gm-Gg: ASbGnctp+PBnMSfu6lLPk0mR8i3HWgI3141kItwjJkpHbgxMLWxghqpm7jBKt5j/ep8
	XcFKlSVMymM+BltUxyIPW7cRx3WjjiKWDpo1GfzmA3ppZUvOhPqqxI1vTEoDQ2ZUg25JiyH3IFB
	RNJmCNqT6H3nrZw8G2fJK+/5Iv4sp57ftwQCzAnnpiOX8T0mGriUKivrZlUDQojzPAVJVPOpyNI
	2c31cgv6nGSQTB9ccVIO6FrbJCXcAy+HUY73KX4oqyGfqXlV64FGnCtqQhtoJakb6SgdX+913rG
	ADfL+6RmE5ADIEagqNt42nST0QVDoDxnOrh+z0kVcfHYQBJZ47NxijqnjwsmH4LFeJG+Wick2xy
	P7EpitB3RkHzvItxibe6tG7l4ZNNP42dhebXBdxMv7L5S4fn0FLQinJrbYJv2
X-Google-Smtp-Source: AGHT+IF7yK2d5OhlOk2zuF/JBEnY8Tk0IxeJcaQU8ZwgxhbKMJ9tPMbVc9dRybkbnnQOcP+NOcEr1g==
X-Received: by 2002:a05:6a20:3946:b0:2e3:a914:aa93 with SMTP id adf61e73a8af0-321e477bf0dmr6715698637.30.1759352578852;
        Wed, 01 Oct 2025 14:02:58 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.157.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b02094847sm561906b3a.89.2025.10.01.14.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 14:02:58 -0700 (PDT)
Message-ID: <7974c867-b7c4-470a-afaa-87583a20d467@linaro.org>
Date: Wed, 1 Oct 2025 14:02:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] system/ramblock: Remove obsolete comment
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Peter Xu <peterx@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 David Hildenbrand <david@redhat.com>
References: <20251001164456.3230-1-philmd@linaro.org>
 <20251001164456.3230-2-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20251001164456.3230-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/1/25 09:44, Philippe Mathieu-Daudé wrote:
> This comment was added almost 5 years ago in commit 41aa4e9fd84
> ("ram_addr: Split RAMBlock definition"). Clearly it got ignored:
> 
>    $ git grep -l system/ramblock.h
>    hw/display/virtio-gpu-udmabuf.c
>    hw/hyperv/hv-balloon.c
>    hw/virtio/vhost-user.c
>    migration/dirtyrate.c
>    migration/file.c
>    migration/multifd-nocomp.c
>    migration/multifd-qatzip.c
>    migration/multifd-qpl.c
>    migration/multifd-uadk.c
>    migration/multifd-zero-page.c
>    migration/multifd-zlib.c
>    migration/multifd-zstd.c
>    migration/multifd.c
>    migration/postcopy-ram.c
>    system/ram-block-attributes.c
>    target/i386/kvm/tdx.c
>    tests/qtest/fuzz/generic_fuzz.c
> 
> At this point it seems saner to just remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> ---
>   include/system/ramblock.h | 5 -----
>   1 file changed, 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~


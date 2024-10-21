Return-Path: <kvm+bounces-29277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F92F9A6681
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 13:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18032B26609
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 11:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4128C1E7C0A;
	Mon, 21 Oct 2024 11:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZfS4iPL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FA91E5728
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 11:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729509654; cv=none; b=KX3JqZ9qDIJYxT0DxktChVPsrW6iFDnWQOk6k1XkDrxRuvRzb7NCECn00lOgcbCctKg+KXTMD21/ukrymaxZqmjO7ZizlCsfZ5bt83ke5dvIIbymVAvbuqUCMBLno7681avJc6tN50hA3b1ZhLP5JKJu/7BVQP5R5Mczh36fEPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729509654; c=relaxed/simple;
	bh=vN1ylj+X91hQZw4H17XL5HLnuy4ALKIQAm1oA5MM2rA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BBtqV8o8MNTifVba1UiYyf7wscig8qHrJxtTVy5TAv19NMi94IKkNfRWFkDXigpnHjjPWeiRMMLotnURXxC590izsSx+EJ8sjobGLDKzME3CqlKxMFXYKMAfsAVlNSGE+C97D7Zyb+vKSHrYIwjMIYGwqtzBM53b+HwDNH1kqhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LZfS4iPL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729509650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5EJq3nTCY2846K0vo9vaCnqoyl72A9YpQztvsfdIGoY=;
	b=LZfS4iPLnPwXhszaGgO6nJTNGrL2cKd5yBH+39LUsgokaWhh4HtxDSZwr1mlp/7FlIEVXt
	gTfy2ewLMuOb8i4FDdlBfo2XDa4/DiTIq+H/jHEhm3v+acH9GWuJ742jbaeFlhAgS9sXQH
	8xDLWkf8PnOshIKVEMYxQg8d6u58b2U=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-6ESkhNA8Poi0ZDQw1Qjp6Q-1; Mon, 21 Oct 2024 07:20:49 -0400
X-MC-Unique: 6ESkhNA8Poi0ZDQw1Qjp6Q-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-850069b5c2dso594271241.1
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 04:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729509649; x=1730114449;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5EJq3nTCY2846K0vo9vaCnqoyl72A9YpQztvsfdIGoY=;
        b=Z2WEG/YEC8vMalYXRfolBeF9i7TBnVOx6iMqQq6tikXxlPZ5Avqonpd0traIctU55n
         +dKt4TomWL2meL7EU0Vh/mPGbErLU8mWRkmHDW34QK7emlF4HlxADuG4WTf6IS+35T9o
         /Q7VRYVgDBOboY447b8poXjcRvRX7HhHavlNSLPbUrZCsKyBNoW1jYCP3M00FFcZK2or
         MzHSi0gaB2jdqTBe7zacr4NVbkdlDusMxXqK5J/HMQMYoodFFrLxtw0u5lsUeljdaGZY
         VckifltaDP9Y4pZmrJdWyE8G84UNDQsCQq1nY10G67fUunWCI6ViXE2wfCVl7AlCTbne
         E7KQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYUrKzeNUgjVmYscW0Lwg3Z0oiLtJrFeN6dujroPLhBENv+PW0eKuXD0PageNRGNT9J1w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6ZXVl2Pzw/3myw6ktITyUcTRuUZQd13WwKfH5PeJPCIHE5D/H
	AwcW4dUqGj9n7t2J+xKhVW7fNqx1QTFSuQL36jbQ2adZLod2vg9gZSwphq78hiICUlWT2vSnyAo
	bu6x7z+4J+hILYDrsty2vU5FULmb3lyz/NqVqw+TegFfM8IekHg==
X-Received: by 2002:a05:6102:ccb:b0:4a3:ce37:9137 with SMTP id ada2fe7eead31-4a5d6b080cbmr9475728137.13.1729509648301;
        Mon, 21 Oct 2024 04:20:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeyi/HIFqi2HtXCMmpe1qAaPmojvVF0iexyAfT2ooED6UKyLdMATTFLlU05hPn3kNpW2Vngw==
X-Received: by 2002:a05:6102:ccb:b0:4a3:ce37:9137 with SMTP id ada2fe7eead31-4a5d6b080cbmr9475690137.13.1729509647916;
        Mon, 21 Oct 2024 04:20:47 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:36d3:2b96:a142:a05b? ([2a09:80c0:192:0:36d3:2b96:a142:a05b])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-460d3c62e9esm16564851cf.27.2024.10.21.04.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 04:20:47 -0700 (PDT)
Message-ID: <7213ebbd-49d1-422d-84f2-14b48a14ed82@redhat.com>
Date: Mon, 21 Oct 2024 13:20:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: kvm: Adds a judgment on the return value
To: Liu Jing <liujing@cmss.chinamobile.com>, borntraeger@linux.ibm.com
Cc: frankja@linux.ibm.com, imbrenda@linux.ibm.com, pbonzini@redhat.com,
 shuah@kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241021100644.3591-1-liujing@cmss.chinamobile.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
In-Reply-To: <20241021100644.3591-1-liujing@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



Am 21.10.24 um 12:06 schrieb Liu Jing:
> The global variable errno is not recommended to be assigned,

Just curious: from where is that information?

Reading the man page:

"errno is defined by the ISO C standard to be a modifiable lvalue
  of type int, and must not be explicitly declared; errno may be a
  macro.  errno is thread-local; setting it in one thread does not
  affect its value in any other thread."

Paired with

"For some system calls and library functions (e.g.,
  getpriority(2)), -1 is a valid return on success.  In such cases,
  a successful return can be distinguished from an error return by
  setting errno to zero before the call"

Not objecting that relying on the rc looks cleaner.

>      and rc in the function does not check its return value, so it is fixed
> 
> Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
> ---
>   tools/testing/selftests/kvm/s390x/cmma_test.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/s390x/cmma_test.c b/tools/testing/selftests/kvm/s390x/cmma_test.c
> index e32dd59703a0..c59c21f28bbd 100644
> --- a/tools/testing/selftests/kvm/s390x/cmma_test.c
> +++ b/tools/testing/selftests/kvm/s390x/cmma_test.c
> @@ -210,7 +210,7 @@ static int vm_get_cmma_bits(struct kvm_vm *vm, u64 flags, int *errno_out)
>   	struct kvm_s390_cmma_log args;
>   	int rc;
>   
> -	errno = 0;
> +	*errno_out = 0;
>   
>   	args = (struct kvm_s390_cmma_log){
>   		.start_gfn = 0,
> @@ -219,8 +219,10 @@ static int vm_get_cmma_bits(struct kvm_vm *vm, u64 flags, int *errno_out)
>   		.values = (__u64)&cmma_value_buf[0]
>   	};
>   	rc = __vm_ioctl(vm, KVM_S390_GET_CMMA_BITS, &args);
> +	if (rc < 0) {
> +		*errno_out = errno;
> +	}
>   

if (rc < 0)
	*errno_out = errno;

-- 
Cheers,

David / dhildenb



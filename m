Return-Path: <kvm+bounces-24239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EFDE952C54
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 12:36:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F25C7282A97
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 10:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9076C1A706C;
	Thu, 15 Aug 2024 09:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IrCIUgQ/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF141A00D3
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 09:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723715355; cv=none; b=g4UY4hc6E1ylH1RPkXeXfz+W5DVolAMkihjZvr8E9cbdFOOmH1nRrUh06huO8YWFQISYd1+ocgNAS/N8Tl5sYcA8svElbcwsOOqSfPx3cO1+jp3qlU8K3tBmxfx8hZnh/tgAUfuS2Z38qbnVzz3AqtcBwrIdzZHMitRRLN7OXo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723715355; c=relaxed/simple;
	bh=FuQCG594ONPCPeIJoHoIxmxhtPKz6t8gwvkBfk2KdSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MystlA6kQCkCtpnzv/gcEe6vQ7uY5+KpBA7gJlRs20gp2WX8oKkFyIvAdiJH9FWAN63Gc1Su+R6WXnrpWG8E+w9zM8ws1xDVNdygbDsJIOEUDfcblmksIYLa1c6TlNoRWB0/H31iVMkos4QL4CKGAx3q/Uw2frcY25S/zymfmXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IrCIUgQ/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723715352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6K/w3mydahKSJzUZNevQ4VpM26b9qlYm6tF4qoxzK2k=;
	b=IrCIUgQ/KxhfrR3oWv9E28802jEphZcQyLqPrjFVpvfZb6IlUIIN3EkAhTt4NFo24vSegU
	+nB9h5LwOXBwXv7cJ7NhCJG+b3aqLdMD2bHKXd1x08BLDa7IvcVehwZcZhsT7Xs383LSUz
	Pb80Dean8ZySB7Te69gWxHVpAX+PnhE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-vytJdOnrMimm5NZ0tL6EPw-1; Thu, 15 Aug 2024 05:49:10 -0400
X-MC-Unique: vytJdOnrMimm5NZ0tL6EPw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5a7c6a0f440so678486a12.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 02:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723715349; x=1724320149;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6K/w3mydahKSJzUZNevQ4VpM26b9qlYm6tF4qoxzK2k=;
        b=LYCOCGichuYgq4Abqaqxu6BzQ5hDlk6Is0zJ3q57x/Ez6pHMcnfFXbKR3or3Kx7BTP
         B5YUiXNGLMzrJMKqZY+Yj9ggeKTniZEZt6P+RWFZmnXFn7OhUwgN8QUhHm1kAzK38IPx
         jlE/MGVXvu5oA3zjYHt/Fd1ePAcNhrfKJ5uPos6orXt4iV59i4u900MpVHkTPDYyQu1M
         4b+pWFAqv3QZzyj2xoXjtuONQVImLbeghUQWiV2Mc8fNM1At9JI+o7Mc0/BGz6AeS24s
         aCbceeoR5jzL+csCY7gfBxqeXRPm1XIlIs/C0Dw56759hkVNeltVglliKemBkrn/NFqw
         GN5g==
X-Forwarded-Encrypted: i=1; AJvYcCXCZf1aksN/kTBLquwAwAdbLgjAur/ExhKvph5qQ65OJZoHJTEFhpLDdUIBzRKv4VLDK5dLiox6vR3LX0kRcnazY2e0
X-Gm-Message-State: AOJu0YzOB4lCWvlif4E4U7dbSawhJf7aGcIXn6wEKU6JWeGz9/lwOavz
	pE8VHNdGAZJTTWFs7UrSvolkvXvEBuONzW0W9VOEPCC4LSQK0sx8kIe0WkxqzsdCRcuWD5u5eZy
	tlZYYoRZdgaaY7hkPlx22XEVzXpfuwrHm+DPfy2kGUtc1/WmguA==
X-Received: by 2002:a05:6402:84b:b0:58d:31f6:2162 with SMTP id 4fb4d7f45d1cf-5bea1cb45d8mr3780871a12.36.1723715349522;
        Thu, 15 Aug 2024 02:49:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1m5Pl5eenfSbutxhQdGlTkYyEy0lVZJCPE4JfY56s/TLO8Ou65Y+so3cWaGaLnhXRNbNJzA==
X-Received: by 2002:a05:6402:84b:b0:58d:31f6:2162 with SMTP id 4fb4d7f45d1cf-5bea1cb45d8mr3780843a12.36.1723715349050;
        Thu, 15 Aug 2024 02:49:09 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-177-15.web.vodafone.de. [109.43.177.15])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbe7f80dsm658138a12.64.2024.08.15.02.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 02:49:08 -0700 (PDT)
Message-ID: <81e236a1-2a75-4719-a8a3-c0daaad1ac85@redhat.com>
Date: Thu, 15 Aug 2024 11:49:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] target/i386: fix build warning (gcc-12
 -fsanitize=thread)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>, David Hildenbrand <david@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-s390x@nongnu.org,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>, QEMU Trivial <qemu-trivial@nongnu.org>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-3-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240814224132.897098-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/08/2024 00.41, Pierrick Bouvier wrote:
> Found on debian stable.
> 
> ../target/i386/kvm/kvm.c: In function ‘kvm_handle_rdmsr’:
> ../target/i386/kvm/kvm.c:5345:1: error: control reaches end of non-void function [-Werror=return-type]
>   5345 | }
>        | ^
> ../target/i386/kvm/kvm.c: In function ‘kvm_handle_wrmsr’:
> ../target/i386/kvm/kvm.c:5364:1: error: control reaches end of non-void function [-Werror=return-type]
>   5364 | }
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/i386/kvm/kvm.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 31f149c9902..ddec27edd5b 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5770,7 +5770,7 @@ static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
>           }
>       }
>   
> -    assert(false);
> +    g_assert_not_reached();
>   }
>   
>   static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
> @@ -5789,7 +5789,7 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
>           }
>       }
>   
> -    assert(false);
> +    g_assert_not_reached();
>   }
>   
>   static bool has_sgx_provisioning;

Reviewed-by: Thomas Huth <thuth@redhat.com>



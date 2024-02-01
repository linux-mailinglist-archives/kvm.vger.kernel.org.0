Return-Path: <kvm+bounces-7690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA94384547C
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 566111F25C61
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E5F4DA1F;
	Thu,  1 Feb 2024 09:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V9CUkDpv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FE34DA1B
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 09:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706780757; cv=none; b=nCYgdLB6PCMNFxtJFCcDBPqCuSPrHWkDFrm1uOpECS4SRWFuS1h1uODDE5xjhvAebshNkm/ccEDTan467H7HhUpbasajsT3/DugarbRV7W0PTknPrgZXNaWVDQrDhVCWZWjAKt/eAegMpdodi23qDEV7enl/6mXIeo9SsfusGWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706780757; c=relaxed/simple;
	bh=aNqWZW6RcqK8RA8lTfX+odywxwnNVRg2P8cqZ4BDSgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qlwb/44zA80BzZUEQ00wY9upABYxt3qLQT5wgdH+kq66XCdRNNVjyXPWWYirX9NrOsDKPWycpAqKBb6rMM3woX2tGNEo16V3XdSskUz7oD41uw2xVPZSHisHGp5RcJoKMZbXpF/Yppr6onHLicXjj5n0dcTywZrmhtCpRf+eAds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V9CUkDpv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706780753;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DrVU+bxCb/uw2+gU2fqkwUl2STpHNw8pC2Tx+pltE8s=;
	b=V9CUkDpvgYtdu6upsAlRyNWR0ir04Ddx3qSqBVrY8YzthnCZhgaQzr3wx00WIRDSPMmYbF
	wpMroSxYdaI5DVOzgSjyQQGwJEnl+8o4qP7PCjnK0RQUYFtLmSrRgdi4D7CwDNB2Ef2UoZ
	VsFB7zl8P+BALOq2PlaKOFEzYGAGTXY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-Yflc9WzrPLW0IbGdpS18HQ-1; Thu, 01 Feb 2024 04:45:52 -0500
X-MC-Unique: Yflc9WzrPLW0IbGdpS18HQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-68c4ea596cdso8149626d6.2
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 01:45:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706780752; x=1707385552;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DrVU+bxCb/uw2+gU2fqkwUl2STpHNw8pC2Tx+pltE8s=;
        b=mTTuizPe+42b+eglYaBhHgGXDtt/in61p1ayrd4bGixVxOkzvTtLI0Gxbenc7bvRkH
         Q1I2uhgWP5Eljm627TaHT58uLK5zieYHeK3JnFjnLmFiyrZHQNcyt/MSeqSHVEbrbeVK
         oEUtJiXg8UPTdFXK22e07aNA+jH4GG8QIWt3zoiQ6yl9nyr2rqonGlfc22yXtYnccC1R
         hV9dxvTvL/8qmCH+17EtPbka+rB49q3UIDMS68bmsztWre5y+YdClt7qagsWaxRSxW6o
         UcWRCC3j8PlMRjBJ1HchcFd5/NXlqPK3JeNn+b86Yb7iqQjHyWryV85GPxeDXjVDRwpr
         SjwQ==
X-Gm-Message-State: AOJu0Yztgi4s277VqDUfBy4pem+YBEwJcXNZtEjJVE8j63w9hqUqerTD
	vzvYYR4KPztpr/tp9Crc4emgweYPYWfYQevcJ1eeKFQbRfzuMouiSXqH3y9juQLIJYO9LjgmIUG
	7Ir5EC2hvsj9IRtDmQ7avFJngPUyk3iiVGHAHQ3BxqGRTvNLncw==
X-Received: by 2002:a05:6214:1314:b0:685:a8d7:4c24 with SMTP id pn20-20020a056214131400b00685a8d74c24mr4751652qvb.32.1706780752218;
        Thu, 01 Feb 2024 01:45:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFG28NP3prMqpJ8rQDWnq3QonHb0ZxcexPRck7gHhbp2xafjHdgp1Ueix8Ur/1n+r+ZLdchpQ==
X-Received: by 2002:a05:6214:1314:b0:685:a8d7:4c24 with SMTP id pn20-20020a056214131400b00685a8d74c24mr4751642qvb.32.1706780751974;
        Thu, 01 Feb 2024 01:45:51 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXXSldVy67JtjS3zYuvLQ7dLV4xY/2lUtZvTKDaUuT0poXQEL5joBK+zCKbk+yFEg7eH7J4zGbGgVU8gLcIS2J0NtDzyEml/cW46f8HI9Ul/EsGro9DzrmVJYV83VPhR91gxoNGWiB9CYdGp24L8KdJ/kzwUm3oEt5OwURZHUKhPZO1lYPEeEOxPRxA/3sI2Xbh/OFBpmmc8ozfV+kKjCwC835yioAfFprDR7EzY5RKi1sqUcUC3Z+nFu2F9628d8GmbL/RsepRn4w+2Byvm7KkE90IojwX7w+6wUnCnrDy3X6dCVlv7/A=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ma4-20020a0562145b0400b006843f949b29sm6375102qvb.16.2024.02.01.01.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 01:45:51 -0800 (PST)
Message-ID: <9087ae37-e42c-456c-a9f1-b62fd101e9e0@redhat.com>
Date: Thu, 1 Feb 2024 10:45:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 21/24] lib: Add strcasecmp and
 strncasecmp
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-47-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-47-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/24 15:23, Andrew Jones wrote:
> We'll soon want a case insensitive string comparison. Add toupper()
> and tolower() too (the latter gets used by the new string functions).
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/ctype.h  | 10 ++++++++++
>  lib/string.c | 14 ++++++++++++++
>  lib/string.h |  2 ++
>  3 files changed, 26 insertions(+)
>
> diff --git a/lib/ctype.h b/lib/ctype.h
> index 48a9c16300f8..45c96f111e19 100644
> --- a/lib/ctype.h
> +++ b/lib/ctype.h
> @@ -37,4 +37,14 @@ static inline int isspace(int c)
>          return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
>  }
>  
> +static inline int toupper(int c)
> +{
> +	return islower(c) ? c - 'a' + 'A' : c;
> +}
> +
> +static inline int tolower(int c)
> +{
> +	return isupper(c) ? c - 'A' + 'a' : c;
> +}
> +
>  #endif /* _CTYPE_H_ */
> diff --git a/lib/string.c b/lib/string.c
> index 6d8a6380db92..ab6a724a3144 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -54,11 +54,25 @@ int strncmp(const char *a, const char *b, size_t n)
>  	return 0;
>  }
>  
> +int strncasecmp(const char *a, const char *b, size_t n)
> +{
> +	for (; n--; ++a, ++b)
> +		if (tolower(*a) != tolower(*b) || *a == '\0')
> +			return tolower(*a) - tolower(*b);
> +
> +	return 0;
> +}
> +
>  int strcmp(const char *a, const char *b)
>  {
>  	return strncmp(a, b, SIZE_MAX);
>  }
>  
> +int strcasecmp(const char *a, const char *b)
> +{
> +	return strncasecmp(a, b, SIZE_MAX);
> +}
> +
>  char *strchr(const char *s, int c)
>  {
>  	while (*s != (char)c)
> diff --git a/lib/string.h b/lib/string.h
> index 758dca8af36a..a28d75641530 100644
> --- a/lib/string.h
> +++ b/lib/string.h
> @@ -15,6 +15,8 @@ extern char *strcat(char *dest, const char *src);
>  extern char *strcpy(char *dest, const char *src);
>  extern int strcmp(const char *a, const char *b);
>  extern int strncmp(const char *a, const char *b, size_t n);
> +int strcasecmp(const char *a, const char *b);
> +int strncasecmp(const char *a, const char *b, size_t n);
>  extern char *strchr(const char *s, int c);
>  extern char *strrchr(const char *s, int c);
>  extern char *strchrnul(const char *s, int c);



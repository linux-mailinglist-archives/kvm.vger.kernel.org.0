Return-Path: <kvm+bounces-42631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B697FA7BA9F
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:23:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76142174912
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B6A1B0434;
	Fri,  4 Apr 2025 10:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EGCXKKJC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C606219D8B7
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762176; cv=none; b=Lffhq513jrVK5KiY7xEB4Fc6a4JgrrntKgREcqIzL8J9wUxFTcQA7aSe/kTDsdUE9AvA1R8Sqrf6idlswfB1NlxRW6tbEuBxobbaYqV4K2JOMMwQhLiwOvYskeyyz3F7CWdSRKEp4ZnY727dw6BRKjKLiU2osJKNZMf0WAzo2mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762176; c=relaxed/simple;
	bh=JtreWaK1HxThyWsdFhRvKmWImSDOAWofMIBdnx78l+o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=pMQAElZzITSv48m7GKsjCqM4kaLMK2EJrHW3jwWmaprFRQ/PpJKnatLC/ty8t+B6IwOA1ohf1ZAyTat4AV6tywXCxAb55OLqIYoy3qxhDTze0txePNwLGHtOR2H72Fz6Kzf+FDXvWJbthdR33seZd/vMHs0ZwJgRfM3q1/pBRfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EGCXKKJC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743762173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DNVoYJhFq7cXruMh9BbCFB9GyK713s6YFzIH0vw/1ok=;
	b=EGCXKKJCmFT+puB0IXuwKa61ttfk9u2a+ZCbR0H4vTKWxwlrdOHqBv6xYZ5Z2erUrgGvsE
	FFhVyTNcFDhTKDJkIuJ4Lp2QO/Me6NHVCKqg7o9jw4ic4Ty2ptA6k+gUtXYj88ei2k1wWS
	CACs89epl6S/7L398Eb1bpho8eLSU9s=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-SQpHuL6xOROnC0se4O4dFw-1; Fri, 04 Apr 2025 06:22:52 -0400
X-MC-Unique: SQpHuL6xOROnC0se4O4dFw-1
X-Mimecast-MFC-AGG-ID: SQpHuL6xOROnC0se4O4dFw_1743762171
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5e6caac1488so2047198a12.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 03:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743762171; x=1744366971;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DNVoYJhFq7cXruMh9BbCFB9GyK713s6YFzIH0vw/1ok=;
        b=B4LojrKFIFlg6achJdY4GYQByEYPYo++VsgI4cQVxVkkGvvsPDpaHQiaKUUjZW+jTr
         zG3uJ6TFbg6XCxSZbgJ+h+PFx3g0vWs4HzQc/LqJ38WVdkuRdiOaOHAdTzohCX9kEWOh
         ubJFpI5fvXz1yC8XoXgKP4Sv7nt2ydCA4L8g0GJeLlO1svIeReg1EqsWlHTDemjKLeFY
         6NO1BufQUeG6v3c1l6fRXhLg1tCnpqyRdeRTok/XQd8GxOmbtUtstkJsAJlkGR57FYDM
         7s90oK/di8IZQiRkmvpDltgs3SaeewZJdgCgpTUXby2YdpIQswGrahVYJVnQfTPbhapM
         0LRw==
X-Forwarded-Encrypted: i=1; AJvYcCXbQ6127n2owQy+ZFIH4WYyYZitAtAvS9WaU2JNp7yo2RxzbYSjSiK+A3srIQjJus2EsO0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgsqlsNbHEx8ZIwRayJREO5yzgGtyiDVVRuX4C/WgoS5V1q0Wr
	Un8AVUONdhZfp61NiVrhGoN0fUG2k4a8czCKv3m7y0k9DDpaKaFY5fFWz3dWHMAQv6Ra0vEER87
	apb+jFwdzQayWHCJsXV0mm/ayDdIEagbAOOQCedmjDqOiFanuVRsHy0qXyg==
X-Gm-Gg: ASbGncvzVHpqWl+CH9EvZpmOiAJwewmh8GbsT31oOV6tMD49ECwrMIIscLQoqEc0pY/
	k/uH58wiT/9DId83nfTcfgVVZ41gF1L906WpSMab2g/n5WTEDmv0JpYQtN47mfjPUiT4nqpvwDh
	sgTnCAS7VkJosb2OrpNWdXq1hI1xLfuR/E5I9CAwR5KuuM3/AVhR/4pe2ABoGRrUV6ZAQGVWFKf
	IslQk/lsBYgiiC7k3TfIH4V96e0jPtYJsPVuVoVJWisEEp9kd2zo7OHRu/t4ODcgj1w5HTDEy5z
	Y9OeGVq3gda8reK+EYI2
X-Received: by 2002:a05:6402:2714:b0:5e7:87cd:2479 with SMTP id 4fb4d7f45d1cf-5f0b28821dbmr2250723a12.8.1743762170820;
        Fri, 04 Apr 2025 03:22:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHM+zZOy5sRewTG5wad0dtUfjY+Jh0Y6kbMGiejkGMj5j7Z6poTz19CfMKHeKcGq5Wo1d3wQ==
X-Received: by 2002:a05:6402:2714:b0:5e7:87cd:2479 with SMTP id 4fb4d7f45d1cf-5f0b28821dbmr2250708a12.8.1743762170453;
        Fri, 04 Apr 2025 03:22:50 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.230.224])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5f087f0d6bbsm2224445a12.46.2025.04.04.03.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 03:22:49 -0700 (PDT)
Message-ID: <68d3aed1-2afc-43ba-9b84-c28e01637d45@redhat.com>
Date: Fri, 4 Apr 2025 12:22:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: kvm: bring list of exit reasons up to date
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250331221851.614582-1-pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250331221851.614582-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/25 00:18, Paolo Bonzini wrote:
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   tools/testing/selftests/kvm/lib/kvm_util.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)

Applied now.

Paolo

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 279ad8946040..815bc45dd8dc 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2019,9 +2019,8 @@ static struct exit_reason {
>   	KVM_EXIT_STRING(RISCV_SBI),
>   	KVM_EXIT_STRING(RISCV_CSR),
>   	KVM_EXIT_STRING(NOTIFY),
> -#ifdef KVM_EXIT_MEMORY_NOT_PRESENT
> -	KVM_EXIT_STRING(MEMORY_NOT_PRESENT),
> -#endif
> +	KVM_EXIT_STRING(LOONGARCH_IOCSR),
> +	KVM_EXIT_STRING(MEMORY_FAULT),
>   };
>   
>   /*



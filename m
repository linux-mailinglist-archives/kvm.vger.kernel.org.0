Return-Path: <kvm+bounces-25832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D4696B157
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 08:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87965B260F8
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 06:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC22712C49C;
	Wed,  4 Sep 2024 06:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JOs91JMn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745BB3D6B
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 06:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725430564; cv=none; b=LnkXLKmOgSdGs/8eNlWBfnl4WPJqtWOAhMdPcuXSPDo+fkBee7JkQsmKBK3LQMPYtQqqLWl1h5QdR6BNCmZre2cCXOlTR/eqw3JFZVzQktE/vSeAua7BaHWo9LHKOQ/DA/ZAOm+433r+W2MtNY4whA0lY/FcRs7Pb1yXp6YAIng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725430564; c=relaxed/simple;
	bh=bwl7J8Ei0oLXUFycI7mAAA8XLCISgfFwAHSrsJFGlrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LzvINNEK6C7W8MEOqW7yIspscwh6WYYQT5RgPxYmRQyLGZexU2VhyrSAIVLazL5HKxFd1i4afNi6P5tK0ARr3wwPCzhvPHHGx49h6f67V9cqI6f44xKSH8GLB5nIBioHivYgi6gfzZo7G1FojEGh/NB/8VzqoqpuPWr17w4CF9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JOs91JMn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725430561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pFi+GvA472wwOZH0lUKoPWTzWmpUD/+iLOVkN6gRHFI=;
	b=JOs91JMnIfq1lzhmIDwCTX3wZqXPNmqFbSR/sBBa7vAv3wXzDMcdwGeCrmCxlNFm3oukDg
	xwPRFCPFNJ9SVS64UNjLUbnk0HQISE2vbZiYTuTEc1d3pst836v8vc4n0AuUw11lYWkZAR
	3lI90ncZKlQKv0i0AHGz5qxHFEhESHc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-dNg8sJYaMLCVPEJwkMUZ8g-1; Wed, 04 Sep 2024 02:12:29 -0400
X-MC-Unique: dNg8sJYaMLCVPEJwkMUZ8g-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a7a83fad218so556376066b.3
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 23:12:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725430348; x=1726035148;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pFi+GvA472wwOZH0lUKoPWTzWmpUD/+iLOVkN6gRHFI=;
        b=QSMCEUrRJlTNI/QdvE4UlfGScD5ccYLYtxZmSDjXvC8sW0fGDsdmsp6SctwJZk8TTH
         Ey2VcR97MI8IC7G4JrrB6yDi0xVSX6aHZiLMfZa/D5wcu6QOlyDrkYEMaEBmKJDXN3c3
         srFURKRwkviZGNjlRuuKP8uEFsmaNtio9noqRN/+WvBTTkqS0ej3AqM8prSRQ+zy6a/b
         qMzVX4DhtqFpQNRq7bM/tZVbsk9qDxa4V/YNDlRZnYbloB3/za9brhgfyPLZBOoww96Q
         OGE8LkEEwJT3ijG6tqoaDmJnKvf7hDJp8goSWR83i2E4M0x5HGPhtd3gKDnBa6Jf63XR
         5HEg==
X-Forwarded-Encrypted: i=1; AJvYcCUSy4N2SPl3QKIyH05++azO+kE1i8TayqPT37PDwYxTxOF/4YM9WmpNGCQfzqJTCutKXbI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyo6FXJOSOlsRjhOopbnG4Z+zdLSkXL9vSfmQnwSbSOymMunzL
	RCVFg7xEzm4hExmzjqKswOMInDHp6p9nujiQZS8S0e4awGkxW+BIgFZRdvS6u82IKXsYUnuTRcw
	a6DxRVOrpf0+hDdNQNTLbSAZfuiXbU5YsFf+0tXBPleMdu4759w==
X-Received: by 2002:a17:907:968a:b0:a86:7b01:7dcc with SMTP id a640c23a62f3a-a89b94c72ddmr951639066b.18.1725430348604;
        Tue, 03 Sep 2024 23:12:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDGkN9s2Jmw7XcWlEqSmMDSJiOFB+htHItlggYvkQ9RraTtZHA1IDxBlv8WOsHPBd0lfuW2g==
X-Received: by 2002:a17:907:968a:b0:a86:7b01:7dcc with SMTP id a640c23a62f3a-a89b94c72ddmr951636566b.18.1725430348097;
        Tue, 03 Sep 2024 23:12:28 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-176-181.web.vodafone.de. [109.43.176.181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8988feb767sm773020966b.16.2024.09.03.23.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2024 23:12:27 -0700 (PDT)
Message-ID: <7ef4ee12-ce0b-41e6-904a-ff43ee571be1@redhat.com>
Date: Wed, 4 Sep 2024 08:12:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/3] riscv: Drop mstrict-align
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com, lvivier@redhat.com, frankja@linux.ibm.com,
 imbrenda@linux.ibm.com, nrb@linux.ibm.com, atishp@rivosinc.com,
 cade.richard@berkeley.edu, jamestiotio@gmail.com
References: <20240903163046.869262-5-andrew.jones@linux.dev>
 <20240903163046.869262-6-andrew.jones@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240903163046.869262-6-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/09/2024 18.30, Andrew Jones wrote:
> The spec says unaligned accesses are supported, so this isn't required
> and clang doesn't support it. A platform might have slow unaligned
> accesses, but kvm-unit-tests isn't about speed anyway.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   riscv/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 179a373dbacf..2ee7c5bb5ad8 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -76,7 +76,7 @@ LDFLAGS += -melf32lriscv
>   endif
>   CFLAGS += -DCONFIG_RELOC
>   CFLAGS += -mcmodel=medany
> -CFLAGS += -mstrict-align
> +#CFLAGS += -mstrict-align
>   CFLAGS += -std=gnu99
>   CFLAGS += -ffreestanding
>   CFLAGS += -O2

Reviewed-by: Thomas Huth <thuth@redhat.com>



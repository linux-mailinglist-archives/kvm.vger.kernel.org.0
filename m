Return-Path: <kvm+bounces-41192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 539F8A6492D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AA051896D5E
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7E1238164;
	Mon, 17 Mar 2025 10:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XkLpEo+l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF552376E1
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206442; cv=none; b=c18lcTHhpGq6nAQzL+JlWiSA/9KFN4EGSN6OsVQ2q7Vl3JXw4rpTS+W0sOhF5L9p210cAjJRxFvCsDBqVunrtj0rAJ/zeckVxakWCm1dWCED1O0L5yljlUQu2clgqlfUKhrB4bcVxOES1BewSG8rSbxaZNVceVN/LKc5iYeNXH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206442; c=relaxed/simple;
	bh=C8ZKDv6FkFMfofUcLGU0v3SKi0zrd0R8M/pLyeWdZUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DLQ7zog6u8ubRWxUTNBBGV5+42ZI4FuvXLQ0OT5bJv+2gYPsgXmMSGsh+P//0+fx30shy/FJrg163ju9to7hp1wUm90jfzAMYt3S2AJrdK8mabDE2KDFTI8QoaBTzICtIw7YQkDceQKPkLhV/8IvnxuLfYVmkPqd8Z/J+XztVa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XkLpEo+l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742206438;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tRBnMFtFaoL3oPsaYEgEoYjcIycECPlznLIMwEBWC2U=;
	b=XkLpEo+lJDRfwFDDP8SBBxdQG6FuNZa4oB9HyDPsMWovR0MJfxBEmF/86hmVivRmg6UX+W
	89MwjVoWsnrXl34HD1BkuFNrmzCzVgjXBwNkFBAFCjkH2L/QMwhi5NoqLs2Mt8yAIdbGF2
	mxoyRjfOdhB4W+ZUTXI4fsoeCdu8Nh4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-AnEEceivOPWW2rXkQxamDg-1; Mon, 17 Mar 2025 06:13:57 -0400
X-MC-Unique: AnEEceivOPWW2rXkQxamDg-1
X-Mimecast-MFC-AGG-ID: AnEEceivOPWW2rXkQxamDg_1742206436
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5750ca8b2so710992085a.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:13:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206436; x=1742811236;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tRBnMFtFaoL3oPsaYEgEoYjcIycECPlznLIMwEBWC2U=;
        b=Tjh6LFJ1pHFCmT4flFaRT42uVeX+YcS1TgKv8zqE+KBisDow3K0q50F7PoDM56WBVY
         YDPSw0Sca2cQRM083W4PhPFqqYbTiTh/MPi7EM9kJX0KQaj4P+/tPSqVaMq3HMVN+IQ9
         kM27NUDO72trKBx0XCTLb37mLiP/jD6r0yMGwhKXlPtqGcdixvnZRHClSB8OtYtlfxpp
         RgsToWe9reSyu9ZVc96siN/WFapLl/fd6vWFB9dB276hVByAQ+1J2l5r9KBPt1xCfwJf
         25x/BkPsuU6iwGDXxqr68xbiYbecYrpMPXape7qG8mbl7ct7VOO12580IRE0uJAcPkFG
         vb9A==
X-Forwarded-Encrypted: i=1; AJvYcCX4VS8w5Ah/8P37vKkDhJUwP2SSxV9TtMCRN2RKjr5QtxDATOz2Z7KwTLtnUzPLOgWUkB8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzDjeYO2pQrir3AenNkCpIw01ytcPQGmflMUy9kIvlQumnEHHh
	ijtNQYlveOBXgD1w8gJG1/qYVKwmBuT2KbS86HrRUaadmN9xO/iD/8ByLWct6brWoR1NmdSr9B4
	pZE8m/AeujWBzStlW3978A2e5QJfDjDcWAiSysRNpuwwURkQahQ==
X-Gm-Gg: ASbGncu2Tn6BMN61Sg+lNNcNcwLno/txTOURiVthGWHpLGGt1WquHobAjkHdNwtFKRc
	mWJF6QIYULgZ2NV/hA7+cmz+zj3nIVYYh5dLLF/fqhWIJ5fcqBQ0FW0iPMhMPGBediJLpAbGoeH
	bqSyCojHOcBlmYvuKodG9Krv/680tElVI9XO/z5URBFTJrVYKh/Fbl1ffAxV7mklgHS6XqvvSKB
	tbspmKeKNkYbj06HvpqeksZu9MBkjsv4Xgk02u1QoC/MDbaMX5HlQG8JTPfWOjdniaU3GPOfg3a
	JmMqD/MhIfvDxRbrlNldr1NItCmqnnU0qHWQjX+MX1XtAUbQI6CMz+4/IimOrsA=
X-Received: by 2002:a05:620a:2948:b0:7c5:5768:40ac with SMTP id af79cd13be357-7c57c7c20f3mr1847837285a.30.1742206436613;
        Mon, 17 Mar 2025 03:13:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIOCaxHvQVjTZIrGZZ+aLZbn1xQMAi5UZQbQFIiZdjRyvxK5f639qijZj7sKktMuvUlWabOQ==
X-Received: by 2002:a05:620a:2948:b0:7c5:5768:40ac with SMTP id af79cd13be357-7c57c7c20f3mr1847834685a.30.1742206436273;
        Mon, 17 Mar 2025 03:13:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573c7d869sm566706385a.39.2025.03.17.03.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 03:13:55 -0700 (PDT)
Message-ID: <1ad28176-d564-4d62-898d-d1d80a2609b0@redhat.com>
Date: Mon, 17 Mar 2025 11:13:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] arm64: Use -cpu max as the default
 for TCG
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-7-jean-philippe@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250314154904.3946484-7-jean-philippe@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jean-Philippe,


On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> In order to test all the latest features, default to "max" as the QEMU
> CPU type on arm64.
>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/run | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arm/run b/arm/run
> index 561bafab..84232e28 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -45,7 +45,7 @@ if [ -z "$qemu_cpu" ]; then
>  			qemu_cpu+=",aarch64=off"
>  		fi
>  	elif [ "$ARCH" = "arm64" ]; then
> -		qemu_cpu="cortex-a57"
> +		qemu_cpu="max"
>  	else
>  		qemu_cpu="cortex-a15"
>  	fi



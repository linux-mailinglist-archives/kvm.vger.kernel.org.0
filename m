Return-Path: <kvm+bounces-41562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7673A6A781
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:46:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8D218A41BE
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EC421D5AE;
	Thu, 20 Mar 2025 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2vrbL47I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327591388
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 13:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742478275; cv=none; b=GCWWLWkwn5EUd/iIsO68VcjahkSUy8WNmuc5O1qbOoeIPiqqEkJjfgbKZSAnY4YvL2+TBFO7RiQCKBpa5kk5yXuJgeHdwAytN7/qW+L+as9FA0ikrobtEGQOvXsvwTPZK/KBzR4ME3B/csiH2ii/TeHsddfCfZcfpTJ3LmAELog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742478275; c=relaxed/simple;
	bh=i2TDMTklbXI0rHQKsDSJlUMs8cq8dh7FiaCVJV7RsuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QJSBehf0Vtkdwu1dVuLPhO7aZW9qB8UuOGzqFPpwFjZ5In8d/FOE2ZcKAy6jRlBecSi9CdXXVbLwJtEi8kVgdIlbCx4YSD4xkU9fxIq9X0wxsPQk8jbiilDQkxHxjSFPstJSrc9JDHdcQaY5eVsUjC3wcnsBlUpFF4cI9QlDi70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2vrbL47I; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43690d4605dso5352155e9.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 06:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742478271; x=1743083071; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wmu2SYxKWaUXZphIv9tzLlkJ4fqhqSXSAkoab85VEl4=;
        b=2vrbL47ISa2b6FWKWuJmTI29N7bzNEguty5oDgG5P9m/2Zkc+FunDb9Ma4NSsMNdrT
         Nt2CkMxPXrEKup83pQ3tUspi4HzRMSg62XU2LZXHslp9UgYgaPUljQBm5aLcFNST+F7Z
         uMdT7H7iXxgpnM4mg4TrXtssBknukTrWgwVIp56pRKe/sNMbAwRllmZaIHVCWABn7Bpv
         zyMduFAuSIZhu29QCglnmWqqLTYdqu6NXFGYmUVWc2BsHd05tVvy3REBxi/EIs3Ae/dD
         6c2gQIBh60xx8FyZq2Z4PC2mDM1jLeX7qH2ot4CvW/W4sjNCH/MhPPEpEXFmGTAfPjet
         Vx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742478271; x=1743083071;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wmu2SYxKWaUXZphIv9tzLlkJ4fqhqSXSAkoab85VEl4=;
        b=q5n55++KNDs1LHycEyHrX9QwvcVkwa65Z5/4ux0YMee67X4sPK8oam6FV0xte3+nMZ
         nn0/1TXC0Ek5pibTtbtV7dZrgQqDbLne6eU6EeRl51LRjUuy8gElQjlMayHLAQ1yhXWO
         sKQ+i9IvaT8sgxX/U/019cTStAh5bZpp/E8RobTgQI8n18zKrizlaQgnkgu7O/Cw6D8T
         1e4CBvx5ZLZxgBuMsKJapk0rUFdJnd6RDoQjnQo8QE6YICeh9F9q2KTu62aMHh0Ghafm
         dSF+D9hopdMeGjPmY+nFlkc0AXvxdRcyO5OK4aI2s+SSWFyFd+Q/RS6d8O2OKzU5xjmt
         dMMA==
X-Gm-Message-State: AOJu0YwCGkaFCElR2Vdw9Y46btB2/z+YwsfGCHR19eBmzjgD3I17vUmX
	e169l19dWwnLVe2zdDg/10nhJCiy/wIZyNnt/kBmYoO53Nw5qCKrBJu5byYIxIg=
X-Gm-Gg: ASbGncuDvMZ1pxpnzrOrHEJqBm/f/hmWI9Tc04paXMSXBbmJT5oHNHTbyqD5DrC47/a
	xUfeZZrOBDoRCFrBdoMrxaoCGoSqaqhB8OdYrFHqvfFWii2fv/hSWicSSVSwyatnMattE/I1zg2
	czJnkxXcbOSEzXZ/tLaYVhsE8m4Xriohcg2ILuL+Df3yatdf9306ra+wYZPnm7YE39CMV68s3OX
	wWw2o6ni0COfxf0m/fc3/1OvdG0XUmv7bkdkpKtzTXRvcXqoUao2slHXbyftbtvJNmll1yCZd3U
	dxEZWMkOrVhdX7NpuFRUHvSidBieGWw276zI2xrh92uLYaOs75dAd2BYqte0r3lm85NUgLnOjKz
	mFDZWl2CoDQBC+A==
X-Google-Smtp-Source: AGHT+IERvTzbGrGJZzSa+H/W4kMrQnsWdb7vNeUSPRle6rJopTbtJgkW4W0Y48vwUYZ7ZJJ64N2k/g==
X-Received: by 2002:a05:600c:8187:b0:43d:47e:3205 with SMTP id 5b1f17b1804b1-43d43793a12mr66521115e9.11.1742478271339;
        Thu, 20 Mar 2025 06:44:31 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997d508c1esm1046858f8f.93.2025.03.20.06.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 06:44:30 -0700 (PDT)
Message-ID: <0e6de092-4dde-4a50-9373-a8e5b37a8c1e@rivosinc.com>
Date: Thu, 20 Mar 2025 14:44:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v11 8/8] riscv: sbi: Add SSE extension
 tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
 <20250317164655.1120015-9-cleger@rivosinc.com>
 <20250320-ab264d08531d4ff10b874485@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250320-ab264d08531d4ff10b874485@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 20/03/2025 14:40, Andrew Jones wrote:
> On Mon, Mar 17, 2025 at 05:46:53PM +0100, Clément Léger wrote:
> ...
>> +	/* Test all flags allowed for SBI_SSE_ATTR_INTERRUPTED_FLAGS */
>> +	attr = SBI_SSE_ATTR_INTERRUPTED_FLAGS;
>> +	ret = sbi_sse_read_attrs(event_id, attr, 1, &prev_value);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Save interrupted flags");
>> +
>> +	for (i = 0; i < ARRAY_SIZE(interrupted_flags); i++) {
>> +		flags = interrupted_flags[i];
>> +		ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>> +		sbiret_report_error(&ret, SBI_SUCCESS,
>> +				    "Set interrupted flags bit 0x%lx value", flags);
>> +		ret = sbi_sse_read_attrs(event_id, attr, 1, &value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get interrupted flags after set");
>> +		report(value == flags, "interrupted flags modified value: 0x%lx", value);
>> +	}
>> +
>> +	/* Write invalid bit in flag register */
>> +	flags = SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT << 1;
>> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
>> +			    flags);
>> +
>> +	flags = BIT(SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT + 1);
> 
> This broke compiling for rv32, but just changing it to BIT_ULL wouldn't be
> right either since SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT is a BIT().
> I think the test just above this one is what this test was aiming to do,
> making it redundant. Instead of removing it, I changed it as below to get
> more coverage, at least on rv64.

Hum yeah indeed, that wasn't what was intended to be done. You fix is
correct.

Thanks,

Clément

> 
> Thanks,
> drew
> 
> diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
> index fb4ee7dd44b2..f9e389728616 100644
> --- a/riscv/sbi-sse.c
> +++ b/riscv/sbi-sse.c
> @@ -495,10 +495,12 @@ static void sse_simple_handler(void *data, struct pt_regs *regs, unsigned int ha
>         sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
>                             flags);
> 
> -       flags = BIT(SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT + 1);
> +#if __riscv_xlen > 32
> +       flags = BIT(32);
>         ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>         sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
>                             flags);
> +#endif
> 
>         ret = sbi_sse_write_attrs(event_id, attr, 1, &prev_value);
>         sbiret_report_error(&ret, SBI_SUCCESS, "Restore interrupted flags");



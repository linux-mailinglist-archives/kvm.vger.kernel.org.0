Return-Path: <kvm+bounces-41564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A66DDA6A7A0
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AD0A487246
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF0A22332E;
	Thu, 20 Mar 2025 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="di4bG7Wq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCF721CC6A
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 13:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742478632; cv=none; b=l2ut/BZtDgSgbd6cPmpv+RTTZtQg8Jt8gAxZn3v3UF50Oh9D29mcC8LR3P5QiIZunppCbio58flA2m5RbpoFsULm06gNiVk8UHhalPPydOClpS4q0Ra5urLoaPInTQgdPdS3hEI2QkmNoX9LuXBlFPiUaUhN+yQYbwPboQke1V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742478632; c=relaxed/simple;
	bh=0DkpglpVUl7c87GAtMPW84EgMcmGd/MgOhtUIBBphPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uHpNCcy98pL+vbjXi3jCCJsTPmuYylNqBUaNPD84YNOMcGqOoUFRjW5yO0jjTpnxrPHwbHA9FrFt6gs45czsbFVQo3K3x1vSyZj1a1AYFhvBXSF7O8+NynteFCnzxrWmwUw3hwoFALFMknhxxgtJq12HKX774XLh9hwegWTeBUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=di4bG7Wq; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cfb6e9031so7838975e9.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 06:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742478629; x=1743083429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NuPoJfes2OtJ2RBwmkn+k7W/PYQswwEeCRSMmHPYtkM=;
        b=di4bG7WqMEdQlLSeGDuv9kZST+Gg6ICZIdw2/XzLNKE5JXxajNPLJgeJX5rSNKpV9i
         iuxMmurmNk60QUpRPs8HEj00XU9OG+PuBV4ThEqMCsO8m2OtI5FmzrkswZLUQvoUhW6U
         itH2fMdyZfe3+/4dc/VuqVjwQNNm2/xfcDdpSvL+YZ9DmGiTFPsKlgnXUOH3bfd/hAby
         lKPhXHXpzkPR1KwJCz5YpZbXCGoKCMIy7DxxUCzh3Ee7V47/ZXw1E8OaGRQb3a9J1TjR
         7YBh5EizE0YIJ8npAIW/x2AsBe7nSstX5b3Uy3K+9cH4qjjiNKgmUfQz9DwZxQriYUSB
         UH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742478629; x=1743083429;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NuPoJfes2OtJ2RBwmkn+k7W/PYQswwEeCRSMmHPYtkM=;
        b=jnNxeeMK3m5TKGu29fpZX2A7oaoPXy751H+c4RANkRdDqy6xqsIdXdjwgqmAdK8SEI
         I85VlgWitVIBEPxwj3CM0GvkfiCEOe9p78PIUdTw8xQUUlGj4TRjYTledANBdAQwqxEU
         7hLyZYHSGfa/jq7pZFLbJRobAvduc4cFJo9Iuab7Rpi7R/5ZpPXj5eMeTpQgobmqhVZe
         NKWZEeGDhoOaZKxbl6qLPGU7P+JwxuaKQm9FHtThywZxo7ZAFtNfoRrlb9qzToKXfwEV
         nzGHT8gMDx/UDdI8zmjPOVQwJP6oBTkAdkIdYF06RjRN4yzPgSxvEx38Jt4RKa0KJ+W7
         7+3w==
X-Gm-Message-State: AOJu0Yxi4vJJKiZnEspzLTlzO1vblD8E9MJoiVW4BxLDE3c0aEoBMX5V
	1ezkkms98tAxnrZ/tn9jFxApZz70GWW6NcXI4RdM3aI/55x7s/ikMFVcCMXunIA=
X-Gm-Gg: ASbGncsyDNn5egyVbJlNpzx+Z8kbU7xrXFY/n3geg2kBqGeI97VcXAdGcitf9fZGBN9
	wTdnlWQyy1WT5RpD3fcFCtf3QFA4RTewIT+bHM0d96oBJ7C9SULeB1tV7vEMHKxoUeBRG7dTw9i
	UZWkTdAwkf/D9vRdDGz8PII6MZjlAL8044V7u7HsH9YQ4FEDVmu3DnFkS8mwGDiLRbpm89MO4+Z
	MMz8R/vCPt3mYyNSg4WSB2az1ZsuVDgafo8Pswh1w3xWh0LzMlrkjAjT8Pwz0AV/m8lPw/8fwGA
	lmXOtcEQsfw7fzCHyfin1PtwFn7t/XCO8jb4BgOvJDl5Abv4QhTpdv+kPZhT9Mk0sgcMHSEoxX6
	uCu+FxavtzTG1bQ==
X-Google-Smtp-Source: AGHT+IHqUiP0O9w6v3bEaXNMY8vIoRS85WaGhkOLXmI7IvrJnv/wq3DzqnlZ9QwRdbEFGXaXrcqpRQ==
X-Received: by 2002:a5d:64e7:0:b0:390:e2a3:cb7b with SMTP id ffacd0b85a97d-39973afaca8mr5207870f8f.34.1742478628789;
        Thu, 20 Mar 2025 06:50:28 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318aa1sm24479712f8f.64.2025.03.20.06.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 06:50:28 -0700 (PDT)
Message-ID: <78fc8b1a-6dfb-44a4-bbec-fe25b1cc4af8@rivosinc.com>
Date: Thu, 20 Mar 2025 14:50:27 +0100
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
 <20250320-48e2478cb96a804bfb1008e3@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250320-48e2478cb96a804bfb1008e3@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 20/03/2025 14:46, Andrew Jones wrote:
> ...
>> +cleanup:
>> +	switch (state) {
>> +	case SBI_SSE_STATE_ENABLED:
>> +		ret = sbi_sse_disable(event_id);
>> +		if (ret.error) {
>> +			sbiret_report_error(&ret, SBI_SUCCESS, "disable event 0x%x", event_id);
>> +			break;
>> +		}
>> +	case SBI_SSE_STATE_REGISTERED:
>> +		sbi_sse_unregister(event_id);
>> +		if (ret.error)
>> +			sbiret_report_error(&ret, SBI_SUCCESS, "unregister event 0x%x", event_id);
>> +	default:
> 
> I had to add break here to make clang happy (and same for the other two
> defaults without statements).

Ok. Not directly related but I could/should have added "/* passthrough
*/" comments on the two cases above though.

Thanks,

Clément

> 
> Thanks,
> drew



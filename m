Return-Path: <kvm+bounces-41069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC12BA61393
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EAFA188615B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC68200BBE;
	Fri, 14 Mar 2025 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="tUFdyWYr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FB0200BA3
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 14:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741962223; cv=none; b=RtKWyEi4iCBxIXjrXaHu0F4R7LhfNdGFLx6oo+XfoH8Osl8gnD+tqJgN8RLgJOP0zF0cpuqhuwRkS/Q0OCJhKzUpPHR0JU2g4twFXgsDlkeM+1WABuF3J6vaztNeDAFx9oWCBCmXql5t2eq8kQMts29iaL16gNZO7w0HS7lpEUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741962223; c=relaxed/simple;
	bh=nhsPDmFI8Y7SDu/KyZWk9V1j/CgrHuLTYSob6o1ncqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hKT+rdZNEvCog6qC8/ssC5VykuopwrBLs4W930tuA1uLEZzvxkkmF/ogLmV9vI/IAowlbBYbMYxyM2sAiJ9zxXeALl7fyAs/W+59bdQAjjKjHz1vhRhDSjNh9mAEsuUMNYhZd8bQqDFx/liTR+LmK394ZSQ5zcrY6LX52NvLLkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=tUFdyWYr; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3913fdd0120so1216123f8f.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 07:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741962220; x=1742567020; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lb8jB3tZVhj1VGb1r3eSYUdMFkU+qvZg8Yqngtmhcpw=;
        b=tUFdyWYrAgrJfVzRH5JEDW2ZNX+kUXrbl+ZnKgMwuGNxjVcDPgcqqtASbWHAO0Souh
         7wf1yqOlpIaSigjvf0A1SoDSwoP9B4xD8vRlihsaDXg6VGlEz4X53f/jOuRyCgunICcm
         EL2Sb9yryECYes26nU8F6qtZ2WmTMk5Vm7icZitao12bUA3pAnTOjsg4iSYibUfHnFk6
         WhQdTP3Uw72Q0B7zh0d4SGHyn8+mE0gL3bUlCTdPZwbtqEgKvHq8PyJYDSlKNDNAWJ0z
         jSC1WzO9h6KJm9fTRkMHWUYrSDfqfwaFGr9gZIa4a+WnqDdWfSf7nuqc5k3JvL5dDKRk
         8/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741962220; x=1742567020;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lb8jB3tZVhj1VGb1r3eSYUdMFkU+qvZg8Yqngtmhcpw=;
        b=FRU64YN2uqTQ/MZlYQxm/FkjqvvLmkmEXSio+E3WCY0r2QPzR5CagO54D/YuKcf2j9
         mZJgSJ/3eo0+xK0HKVUf3J/zRxoR2iOCDZD8kjnEmzxWeJbBdoTRA2BN4/2ku0wOOGRV
         uFvWcTIdlz7hb1fRz0J1K7oqlT4YUMsuTt5gEw9E1ziKj20lYFRwerUuLwJi5IwB3wZN
         85c8ce3m68YK4Vyo1J/QGHxFurYnl/rpFP6LAzCEIOanFSqdrHnTYKLu0+70L4hV3+zb
         /SPDtjpX4auCxgOuQnUWa82DbavbPrnzPqAwK8qmhWVZTp9udSvim2U32yaXkasrbq8w
         0ybw==
X-Gm-Message-State: AOJu0Yy2upGQS2M/inH+tS/XZq7Cytl3khBHdPM/qPrmYjDuOWLOXy6U
	jzjlnIwp+/2SvHIkgHucEt6DZ0X7FM3FoMFXdO/O+Sqb3CX+15Xi5xOfrjcTIFY=
X-Gm-Gg: ASbGncvqPPiAP6yDXfiGNoD5NgC2qobZZabOhClwnaLqjtTGWPhrkIEwqKSUnumJjgL
	9iza+ohU+G3NtGPjqBGqBifTEogNPLmgaG7KYVUFBxJZbOrdbmIKCK5F7cQUyZOI8fhjoafdJNw
	t0nR/jDvYY+2j7LzB3+sNrCOVXdW4RGmFSplrz0I07M77gLPVHazRdoaRTd19QhbtR2Tp9LMSJK
	dd0z7kM7fMW/yHQiAH57IxIDSdLNkIuNbodYuqPB/chLZBKoUSypyyn4R4K/kW0qxQshsesU7NS
	lzFovOomHLiKNLiHOBOJIVW/Bny2c4llkdz6WPVE8Cd58ssf6EYT65hi/dlLkUOUGdGQsoZDoWZ
	tTwipd5+ri4fG+w==
X-Google-Smtp-Source: AGHT+IFYg4LjWh5txKo3LZf8ZSZWkKoHLuS9DuFJjCF4JXWiQnv/UzyjdE5CaArqASIFKFfGR+2mvg==
X-Received: by 2002:a05:6000:178c:b0:390:e8d4:6517 with SMTP id ffacd0b85a97d-3971d9f1c77mr3591221f8f.21.1741962219826;
        Fri, 14 Mar 2025 07:23:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1ffbcf95sm18771065e9.14.2025.03.14.07.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 07:23:39 -0700 (PDT)
Message-ID: <eaf88dbb-39bb-4755-830a-7c801099c790@rivosinc.com>
Date: Fri, 14 Mar 2025 15:23:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 0/6] riscv: add SBI SSE extension tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
 <20250314-eb8cf0b719942c912e254ab2@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250314-eb8cf0b719942c912e254ab2@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 14/03/2025 15:19, Andrew Jones wrote:
> On Fri, Mar 14, 2025 at 12:10:23PM +0100, Clément Léger wrote:
>> This series adds tests for SBI SSE extension as well as needed
>> infrastructure for SSE support. It also adds test specific asm-offsets
>> generation to use custom OFFSET and DEFINE from the test directory.
> 
> Is there an opensbi branch I should be using to test this? There are
> currently 54 failures reported with opensbi's master branch, and, with
> opensbi v1.5.1, which is the version provided by qemu's master branch,
> I get a crash which leads to a recursive stack walk. The crash occurs
> in what I'm guessing is sbi_sse_inject() by the last successful output.

Yeah that's due to a6/a7 being inverted at injection time.

> 
> I can't merge this without it skipping/kfailing with qemu's opensbi,
> otherwise it'll fail CI. We could change CI to be more tolerant, but I'd
> rather use kfail instead, and of course not crash.

Yes, the branch dev/cleger/sse on github can be used:

https://github.com/rivosinc/opensbi/tree/dev/cleger/sse

I'm waiting for the specification error changes to be merged before
sending this one.

Thanks,

Clément

> 
> Thanks,
> drew



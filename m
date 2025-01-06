Return-Path: <kvm+bounces-34579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D362AA022B5
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 11:12:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FD91188430E
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 10:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF67D1D8DF6;
	Mon,  6 Jan 2025 10:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="D4f46Chq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127CA1CEAC2
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 10:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736158316; cv=none; b=LEnPsD6nem+jFAX/0pEdj0ido2PxVF5vm6yD7O4gMhnwpWcR8T1PReu9Lv5gsNwJCKzIAq07wISsUjnzqahzdXWvzIFZLH983yVmquxkkOlOD0sPW5q5fV017An2e0JFJfOu9onMxNR+U52/C+h0njyvB3fNgtB6tunQsMQK4i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736158316; c=relaxed/simple;
	bh=EvNMV41fdHlsyOMzdqJDRZdBlAAk6fqcfgwEqQ/4ppQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tRx6KZQd4Ftofwjko1kBwhXbBqNqCbNhdwuP7vze7pBivGD3zwGh6dR4SHk3N1h3A1YqQILsQ/ONZGASC/82/aWp/WUmmzr2Qp4jbKRTegOS6S6QEGXDi3QJbUrofxjgqDYCdFejdnudbOA8kW09GLuic8TFVdai075B2+BQ0Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=D4f46Chq; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2163b0c09afso199986155ad.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 02:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736158313; x=1736763113; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7nNzXHvCvx5cfEB7aLBAj3zATBDNr4fPLoierC9e9z0=;
        b=D4f46ChqQKsauOnB35AVetaZ2atkoiQl2G2L8QhwvL28wN8+7X8VN1a75jZEQ1Ak/Y
         7keH1erXnW9+qKBUSXNDk32BMRt1HVjzLbHRiXD5HlzhfYWa0DwIuCBKgRjyG6XsLaAa
         y6QRdkMCg1xjzHoGwW9/PTu/E5PxBT020evFf+hvIiE5HmzQHwLH9htb5WVqI/CpGzh/
         zfUNnQR+9fiJQOqvLKnZK91oahLhiMty0qbppTN3gNDU2a81xieX9oiSvzv04P8MGsYX
         Kgck0wEYIT4o9PKDUDnhjScS9xugeU4n2QhQARqZinXeysnv2Wuy5ZHHWRDUR1LcAGOt
         IVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736158313; x=1736763113;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7nNzXHvCvx5cfEB7aLBAj3zATBDNr4fPLoierC9e9z0=;
        b=W3ne3agxAeNw6adprmofHOhxskKEkXLVeNV4+ecwXh+QC9n27PKQwYCCPDOhFr8qmd
         FpQ7a5oDZkrX/t94JxEjfhLXmTOonlG2+uJd4B9mfFbxXEREaXRJ12ibVnnhNVaXFgcW
         R+kZb6TEnMf9jKPwSwWjR62YX2ja3P86d8EDyZpkIcinHsoky4qpkMzFQJra17swFAwP
         yN7qcYw21hq3Foj3MCbt40xYsbo6nZ/HK/4ZUeuJeSpWVbIeKkfKaXKbWWOrfpUEkUyB
         ZWTg+7263zBEyCS+XJOtFZg5xZFbGKcd0Rkckdl9vXhQVLDhcfCRBrQCEaTjzJvco8l4
         VQeA==
X-Gm-Message-State: AOJu0Yyv83qr8vfFOWrkpRkZFWMM/04djJmKEEcaqYpROJQCLPqH60C+
	CRu09S2x78IG83mEQ2GnfxyoIed52f85bTGmDL/y73xPJ1ZC+cGHZwBLnfF8YeKauGmyG2fnqTY
	U
X-Gm-Gg: ASbGnctRNziNX6QLofsMK/a4WqPLYWOy2ji3RWvHNFx8oC7aNcPCcc57iDCd0ytHnJP
	RIShlkG8zfvBBJ18xafheg7BaS3BZY9J9TerVg10Bs1fM2ANIhpQzowOSlHQXUo2X+xqh6SieVU
	06QtRz5A+f/f6hfhuqFwEtgD6yLEcBfY8CFKYkVMDrtaBgDvuAqv+J3a+xE6Mq5o5UGtv6MVos9
	n3lMdtiI5bR5QwBGN0Mk9iC1oF+UclS79CIBBkSxClMZTvNDvJSPyW0wgutY5rnXdCDrETwqEtE
	DAQ88q7I8P4CpqrXzxXNtZNY+g==
X-Google-Smtp-Source: AGHT+IFO+37IN1wvmUy/LvYiiE5d0fjJX5//1AkKi+DZydWL7qBtX1lnxZ9O36lro7vlSKtbDgpLuQ==
X-Received: by 2002:a17:902:da81:b0:211:fcad:d6ea with SMTP id d9443c01a7336-219e6f108b5mr688405345ad.45.1736158312840;
        Mon, 06 Jan 2025 02:11:52 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9cde37sm290040905ad.131.2025.01.06.02.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 02:11:52 -0800 (PST)
Message-ID: <ada1c6da-d91c-4177-9173-9a7cdb0af2fb@rivosinc.com>
Date: Mon, 6 Jan 2025 11:11:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 0/5] riscv: add SBI SSE extension tests
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: Andrew Jones <ajones@ventanamicro.com>,
 Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20241125162200.1630845-1-cleger@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Gentle ping ?

Thanks,

Clément

On 25/11/2024 17:21, Clément Léger wrote:
> This series adds an individual test for SBI SSE extension as well as
> needed infrastructure for SSE support. It also adds test specific
> asm-offsets generation to use custom OFFSET and DEFINE from the test
> directory.
> 
> ---
> 
> V4:
>  - Fix typo sbi_ext_ss_fid -> sbi_ext_sse_fid
>  - Add proper asm-offset generation for tests
>  - Move SSE specific file from lib/riscv to riscv/
> 
> V3:
>  - Add -deps variable for test specific dependencies
>  - Fix formatting errors/typo in sbi.h
>  - Add missing double trap event
>  - Alphabetize sbi-sse.c includes
>  - Fix a6 content after unmasking event
>  - Add SSE HART_MASK/UNMASK test
>  - Use mv instead of move
>  - move sbi_check_sse() definition in sbi.c
>  - Remove sbi_sse test from unitests.cfg
> 
> V2:
>  - Rebased on origin/master and integrate it into sbi.c tests
> 
> Clément Léger (5):
>   kbuild: allow multiple asm-offsets file to be generated
>   riscv: use asm-offsets to generate SBI_EXT_HSM values
>   riscv: Add "-deps" handling for tests
>   riscv: lib: Add SBI SSE extension definitions
>   riscv: sbi: Add SSE extension tests
> 
>  scripts/asm-offsets.mak  |   22 +-
>  riscv/Makefile           |   10 +-
>  lib/riscv/asm/csr.h      |    2 +
>  lib/riscv/asm/sbi.h      |   83 +++
>  riscv/sbi-tests.h        |   12 +
>  riscv/sbi-asm.S          |   96 +++-
>  riscv/asm-offsets-test.c |   19 +
>  riscv/sbi-sse.c          | 1043 ++++++++++++++++++++++++++++++++++++++
>  riscv/sbi.c              |    3 +
>  riscv/.gitignore         |    1 +
>  10 files changed, 1278 insertions(+), 13 deletions(-)
>  create mode 100644 riscv/asm-offsets-test.c
>  create mode 100644 riscv/sbi-sse.c
>  create mode 100644 riscv/.gitignore
> 



Return-Path: <kvm+bounces-35013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE077A08C10
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:31:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA5663AB099
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC18F20ADF9;
	Fri, 10 Jan 2025 09:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rUY8RT4C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7664720ADC5
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 09:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736501024; cv=none; b=WhJ6ii+tBoHHI8S1SLIuDqgUko7NJ0QJgpvqTgW1ULCSndOJpFMZI15yJC7u8mU2IEDnMMJBYlVKnGPmDKqS0jVU+BADBfdAFAuIX2CU7XwPWx1gF70XQDaMT42o/nAis5CYA5KKjO1BaK2q2Jrr0O2xLvavp7zlWT1kXPNr12I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736501024; c=relaxed/simple;
	bh=zDliBtx/z6R35uOENVkS8CgF4klrZVGcOMWwhYIWhA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mh8zEL+PrbSuSL0XvvBTiueEH3s+u4+bHblcjoCj9naR1xsi8n7Ve/5KLaUMKiLZ2dXfjz4trMNsaW7JgnQODqJC0sSW89ThKz7Stflq2amUR+4RSgGCMX701+AaHB5lJGT+Z98V8UPsFANEYJp472L/FsPlBKlRj6oZt9XATpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=rUY8RT4C; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-436637e8c8dso19666155e9.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 01:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736501020; x=1737105820; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iblOg47SqMhCepIMm1yTeFpLob2mvaxvFIUpMBZ/N44=;
        b=rUY8RT4CWtpXX+JBnaer9N6JW8HO4XxTjZDb5FbA97G1RB4T489V1Je6C/Ghd/MF1/
         JGvOjl4ibEhTlhkKF5Eq0Ct2UQWuKMInFME852QqiQifr36jZSk99Wsf9tESN1J3m8pP
         pjmw9mz8BOoP0ABXIul2DK2SID9pocBcRBKG2K/bYyZd7kFx6zRsdvO6hSYs7A/m4f50
         K0MuUTEvnIlUF9RjSKbQeIcRY75H9kLyBdjNl7oDtEHDZMAgNcC4V7gdS/lUpz3X2iyc
         1qLwmjx1JdacZaz1DD0Z34SlmyBvUEeedI1MSCX8W0Z2VvYqipvcTYHCUYQKKR8qBqZS
         gFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736501020; x=1737105820;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iblOg47SqMhCepIMm1yTeFpLob2mvaxvFIUpMBZ/N44=;
        b=KtBrrp0j0TyZCv/uC8Gro5leTvsiwgMJfz//u6LVi3+0xScZRFPlBAFCRFHEluVQmP
         KcByWlaS64kiiCOHXBZK4A6PoVSNKfBz1OnOgCB90HXU3WfQTvneem/nky60+wNa12y8
         oAbioLEw/Yx/pzjiaIEgffa02tvhO3q3KZvPCGWqh5wFtrX0olcCBdWN4xIZHDMgCC6G
         XqT6/bd5y8RftDUNUdg0vfAwA5zDpSK/BYfH+EIoMlgkg49rkQ0S6RCM7QiYcvJbrW7W
         Ja1rr7t4odyWHSWEABXajH31/7Qy1EPJwSHricnCRv900dtga0HEKdv0hrZKrRchj2Ey
         lr4A==
X-Gm-Message-State: AOJu0YyzaEG3rKUgF+i9uhipvwyECIu0u4YDAyi4vSoKnIRUU8vOHnyO
	WxXJ2D3fmv6F/Znd1jjsBwMGh10cF5YBLMD3PoILKTLf3QOXVl4BevSBzYZww2v70w/X37J52c8
	S
X-Gm-Gg: ASbGncsQglVgI3tqZwks22S6eTXOe5KCWPiTOiI6Xyme3CoQiMPTS8FxwrI9fAXzIaS
	Bq4qxT2esnbWrpYgkiPl8AzxOaW5+uwFrTfH5bxyAhRiqFyE7A0DK+yHTxKNMY3ZzV2eIvNBeX5
	drPrKMddXzzSlv40dysKvhneNL2Tz0ZR7dxnT7VCHdr99t8dPodZ16K2/+dYGO+MycavxarMwbK
	KsCQV3XGD0J6ZjPFTahkQ0CLjkxZzYstWJXEsTDHWDOGDnXWCHmDndAV9DJmdSi3dhWH6DGYnPU
	8H6YzTD/XaW8Fdgw0df4FGKTeA==
X-Google-Smtp-Source: AGHT+IHmPDT7lummp4HIP/KoVk1LUf7yhzdRFnEabDGyfdw44hXV+escqPFxOsyhmfs5JxEIBNTe+A==
X-Received: by 2002:a5d:64aa:0:b0:385:dedb:a12f with SMTP id ffacd0b85a97d-38a872fc200mr8365963f8f.6.1736501020360;
        Fri, 10 Jan 2025 01:23:40 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4c3428sm3929818f8f.87.2025.01.10.01.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 01:23:39 -0800 (PST)
Message-ID: <6e1e0e1c-b8e2-45f7-b4dd-2b651b994b4b@rivosinc.com>
Date: Fri, 10 Jan 2025 10:23:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v5 0/5] riscv: add SBI SSE extension tests
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: Andrew Jones <ajones@ventanamicro.com>,
 Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250110085120.2643853-1-cleger@rivosinc.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250110085120.2643853-1-cleger@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

After testing with a clean build, it seems like asm-offset.h generation
is broken.

Sorry for that, I'll fix it and sent another version.

Thanks,

Clément

On 10/01/2025 09:51, Clément Léger wrote:
> This series adds an individual test for SBI SSE extension as well as
> needed infrastructure for SSE support. It also adds test specific
> asm-offsets generation to use custom OFFSET and DEFINE from the test
> directory.
> 
> ---
> 
> V5:
>  - Update event ranges based on latest spec
>  - Rename asm-offset-test.c to sbi-asm-offset.c
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
>  scripts/asm-offsets.mak |   22 +-
>  riscv/Makefile          |   10 +-
>  lib/riscv/asm/csr.h     |    2 +
>  lib/riscv/asm/sbi.h     |   89 ++++
>  riscv/sbi-tests.h       |   12 +
>  riscv/sbi-asm.S         |   96 +++-
>  riscv/sbi-asm-offsets.c |   19 +
>  riscv/sbi-sse.c         | 1060 +++++++++++++++++++++++++++++++++++++++
>  riscv/sbi.c             |    3 +
>  riscv/.gitignore        |    1 +
>  10 files changed, 1301 insertions(+), 13 deletions(-)
>  create mode 100644 riscv/sbi-asm-offsets.c
>  create mode 100644 riscv/sbi-sse.c
>  create mode 100644 riscv/.gitignore
> 



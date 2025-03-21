Return-Path: <kvm+bounces-41710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0AD3A6C214
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:04:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 677314829AC
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A0822E405;
	Fri, 21 Mar 2025 18:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="URQ2eG9Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891691DB366
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580257; cv=none; b=eqvfsiSnFwipoZ7yzuwoQjAxChaNx/qsVOe8hjUBmbXFE7QGQJUlwIenzdKa2eoCnNqqcDonKNvO6OnG5twLkD0rljqYceB2qULANYod8XW1ZSFbUNbvaehrLbKDpYiDEsxvc0UyeaX+UYSVrLrkDSebCUxLxGZAVSqlsbIitM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580257; c=relaxed/simple;
	bh=n68KxPdhAFY8m38AD/Oi4t4KWLz14lPXtzXy3INa6Mg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H7TS4VTw+XkCgxSzBYmJ3opqdVJ+Wg36OQFo7AqeL9ozcIMYY3LB5pi1Nsgbah56WJcXY2SAlVTCcwdN9tBBiX2L/tVEHy2OtMTPOh4ARs5N9KElq1V9bVc6JIROQ00zn+ZOamf4wud8v7svVsB7u60HHnXE2yQQ/ZJLCjO+GQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=URQ2eG9Z; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ff4a4f901fso4440172a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 11:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742580255; x=1743185055; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PL0qPEA+zXgSlNQNFSDmg2xA01GQB55ILLw+Apqjr2Q=;
        b=URQ2eG9ZwlfP8IwH+iDwRbKIC5L4sIC8Q2WHbnSV6LNO6M0SbKTZKzNuiv1LtkPmV6
         vQ0ZJqMEDEhQ82z7+CdAxEw3q4UWTANvX78N8QZzY5YNilMUx/atk4nhy6zqWw6RFhwY
         ZIsu1ugUmjggirBdlbEEQj5aCIHWJ4/t2C3sp5bMM8QY8sn/N3+aVjLn5stc+j1zIM9K
         P59tI5z8uxlGV1WAH1udbzxnn0qzn0fc5blHC42bT7P0mccAYOm+fIFBiWEp7CQVS1o8
         bd86p7jMBc05kQvV5LE5DCX+OkC0/lDkLnj4AO+lDdwYjBDzqVzhTsj+3z0vLgrlTmsc
         viTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580255; x=1743185055;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PL0qPEA+zXgSlNQNFSDmg2xA01GQB55ILLw+Apqjr2Q=;
        b=nZY17BncVjTvnYCj8yX3q/hFTuAXvZb1w7+uWn6lBgjerw5oPRDHwBMKcmTqye1awW
         3LfRSeFltBJs7dqaZ2jmzk/rTXVUV6bnGeHMCejrDXM7m1FPAKymRoE3wOTHA2gj8O4D
         TKysRd0J0DhL//PIkJ+cbRiTRrTmqN5AL81AN5h/FjrC30wsVvZLmpAmIpTmKLKMmWnE
         MeAay3P0nppiPGe91PkUGww0wfX72kKpvsxUBZJwBio64dNhEAl1X/VLFwnNLjK2j76B
         bZ2+n5fFG3L7LvaKnOqZ0ce2qpJcB8bXQsh/W6BUWT1K5USmBqSiDXzYGLwnnfuJ9xSR
         SmTA==
X-Gm-Message-State: AOJu0Ywrfhd6h+S3GVLwh7r8O6iaEj+V3r34QWxCA+W3YXJYuiICTSSz
	l7S68IEzc33wKrTpXPiKnuGumDRCWM/VOBo4+3xerspg9e6i03njzeKnhl5rv7I=
X-Gm-Gg: ASbGncv798l2q0YGG19R4UI2g9cYaYpbEZ20POiAFb+k6FRPj6rNt03oWMYTsAVLWMM
	I9UAxCInsqian1HtMDrccD0Cu+hPFU26gDVT1c5WRASND4bSvVfLWMdMqLl2d/XXg1POzmAhOyf
	DZJxRit4AzcxVFlNYaFQQ2fkhJqF0lWPB2TGABBBA8mPEbEmOZzyk5dC48sxzj5EgiZFG1X1cWV
	wk+c0JhjSn2Z3mFR0OpS46TQ6GwhV/L7ccrJPB+Ak2UTi56OlGFTbdMhrTfFuLnq1B0+zE+ip0t
	OO+mGMF07ldEWFfFiQT0ut68J46mdNb0tryVFSP8Gp+CzgTXc+B/SA+8RJog3y7FXLCHLc/k8+5
	DwZMCe+1I
X-Google-Smtp-Source: AGHT+IHKXjEUCnE6VzHVkCLtFKWbbVt3Ake1Wt6ZXFbYB7MNgjYHbGv/cN9TbzfMXRXziM2HTCsBvw==
X-Received: by 2002:a17:90b:4c0a:b0:2ee:ee77:227c with SMTP id 98e67ed59e1d1-3030fe72754mr4960108a91.3.1742580254676;
        Fri, 21 Mar 2025 11:04:14 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3030f5b782esm2369450a91.2.2025.03.21.11.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 11:04:14 -0700 (PDT)
Message-ID: <39d4c320-1487-4bf1-8505-5a50ecb9768d@linaro.org>
Date: Fri, 21 Mar 2025 11:04:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/30] exec/cpu-all: remove this header
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-17-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-17-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   accel/tcg/tb-internal.h |  1 -
>   include/exec/cpu-all.h  | 22 ----------------------
>   include/hw/core/cpu.h   |  2 +-
>   include/qemu/bswap.h    |  2 +-
>   target/alpha/cpu.h      |  2 --
>   target/arm/cpu.h        |  2 --
>   target/avr/cpu.h        |  2 --
>   target/hexagon/cpu.h    |  2 --
>   target/hppa/cpu.h       |  2 --
>   target/i386/cpu.h       |  1 -
>   target/loongarch/cpu.h  |  2 --
>   target/m68k/cpu.h       |  2 --
>   target/microblaze/cpu.h |  2 --
>   target/mips/cpu.h       |  2 --
>   target/openrisc/cpu.h   |  2 --
>   target/ppc/cpu.h        |  2 --
>   target/riscv/cpu.h      |  2 --
>   target/rx/cpu.h         |  2 --
>   target/s390x/cpu.h      |  2 --
>   target/sh4/cpu.h        |  2 --
>   target/sparc/cpu.h      |  2 --
>   target/tricore/cpu.h    |  2 --
>   target/xtensa/cpu.h     |  2 --
>   accel/tcg/cpu-exec.c    |  1 -
>   semihosting/uaccess.c   |  1 -
>   tcg/tcg-op-ldst.c       |  2 +-
>   26 files changed, 3 insertions(+), 65 deletions(-)
>   delete mode 100644 include/exec/cpu-all.h

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~


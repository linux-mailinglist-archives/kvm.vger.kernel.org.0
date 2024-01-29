Return-Path: <kvm+bounces-7376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1648840C53
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 673591F23CB5
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B2E15444C;
	Mon, 29 Jan 2024 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nMUwdnmD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7D3156985
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706547020; cv=none; b=d1VMRuON+iYOdAlZCjl+7HCCL2iU+QKQeHa3aUoo87OBNheVMtjTytcM9DT3pijQXe0+GnyWKCiNKlzidsTbS/rndP0ENrhO7N7qCTiDxV/NUsEK/Uv0QVtDqA9RweO88mk3gZWymFOHVcW1Y1NiQWjZOL/s/vUpMldqNsqDDSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706547020; c=relaxed/simple;
	bh=2jiB8PCGB3vEggK5RKZkMUhbm7h6Z75bqS58k4Tnaus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aVpEjBIOhar1WEPlCHRiGqMv7IdI0BxKOUd/L4kgT7CAb+J8GMpwR+GqeqRg8OZsO/vVRtIpsVhppgaQYtDGN74fRL6kzW3CXXGFqMxBUJH+ArqQInk2pLf9/WWlqhxV4rJhqKgA6sQFzrSL1b31Cw6vPtth2t5q6N5Vm0m/+WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nMUwdnmD; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40ee705e9bfso32639635e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706547017; x=1707151817; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=omKaa0iHW1o+ye+O07qQ9YI+SPw/nbBCLeN2GURIQnI=;
        b=nMUwdnmD0LHRCfXxqvXdhiYMqfWTDjcUFRkmTbpCvvEnCKGi4PSiLmIrpk0mhx2aWd
         3BBmzl6cVEdoWUwlBsuvwWYHL+IHsI3gYKzmKOMNo70pb/vzQAxELvcKWgkGWjNcxvqy
         /v/97Q9pohmRJTfLRpGdRIpMsfLkNqNVg7cGHgraE7IabeAN7j0ZF2GS5aTcgI+z7D2u
         mcCmmLXW3psGCVKih7yW2SqLcL6ZWO21Q70gpJ//vcWQYt8pOCYIpptp/ggoBpjw8Aan
         k+TI4qHU0ztcOyccm9k/8Xpkzlve2r7AFEctmT7IrXKIDeGKjgqOCdo1dzwfRlMjGDBI
         p7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706547017; x=1707151817;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omKaa0iHW1o+ye+O07qQ9YI+SPw/nbBCLeN2GURIQnI=;
        b=MVjEps3SYqUvfpIgPlT3cUJlwAt8kSjibijx502VIOUiykVlxg0VeEfNsJBK7+BWFq
         jgtgVTK2CRIylokaY/VO116pUqPalTSNqUHYpFhtB5qmuK6VrXTNDL9At1DCEdh2iKI8
         4F905+Qqc4xKAOrqnReNRE1aI0yXUY3ekCqf638Wy9RZQ/1OaKYbdrICyfhoxI/RpRKV
         55hG/rpUXZvaLZ04kAyCgyIsNszEcpD1bMiD16hs1eQm+pbNz498Kbu7R1+rYRnqAgkt
         mSUX89XCwRwcN/lmfVqO5bKF9Ks+w3xQcYs85QwKw2pMaoJ5haRMh753/NMYZQeEg8LM
         33/A==
X-Gm-Message-State: AOJu0YymIGZsmEWv5+mGlSWCQOo3xOgE3EGMr2hxaCy5nbyFzPxe48w9
	16c3rhgjqBjAj8B9rHMcViT19foQ8w25ryJyzB+zT3sLJy6W79iR9od6bKbc28M=
X-Google-Smtp-Source: AGHT+IENRodsNqBb2ZsMapK29qw3M64BL/PIvqlcP6V/HUTtgCz0m1D+dNQrPnYAHAiX3P1S+64j7w==
X-Received: by 2002:a05:600c:4e88:b0:40e:5523:e6dd with SMTP id f8-20020a05600c4e8800b0040e5523e6ddmr5423979wmq.30.1706547016686;
        Mon, 29 Jan 2024 08:50:16 -0800 (PST)
Received: from [192.168.69.100] ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id iv16-20020a05600c549000b0040e3635ca65sm14633892wmb.2.2024.01.29.08.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 08:50:16 -0800 (PST)
Message-ID: <36852ecc-36da-4b8e-bb81-13938a100100@linaro.org>
Date: Mon, 29 Jan 2024 17:50:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/29] target/i386: Prefer fast cpu_env() over slower
 CPU QOM cast macro
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony Perard <anthony.perard@citrix.com>, Paul Durrant <paul@xen.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, xen-devel@lists.xenproject.org
References: <20240129164514.73104-1-philmd@linaro.org>
 <20240129164514.73104-15-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240129164514.73104-15-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29/1/24 17:44, Philippe Mathieu-Daudé wrote:
> Mechanical patch produced running the command documented
> in scripts/coccinelle/cpu_env.cocci_template header.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/i386/hvf/vmx.h                | 13 ++-------
>   hw/i386/fw_cfg.c                     |  3 +-
>   hw/i386/vmmouse.c                    |  6 ++--
>   hw/i386/xen/xen-hvm.c                |  3 +-
>   target/i386/arch_dump.c              | 11 ++------
>   target/i386/arch_memory_mapping.c    |  3 +-
>   target/i386/cpu-dump.c               |  3 +-
>   target/i386/cpu.c                    | 37 ++++++++----------------
>   target/i386/helper.c                 | 42 ++++++++--------------------
>   target/i386/hvf/hvf.c                |  8 ++----
>   target/i386/hvf/x86.c                |  4 +--
>   target/i386/hvf/x86_emu.c            |  6 ++--
>   target/i386/hvf/x86_task.c           | 10 ++-----
>   target/i386/hvf/x86hvf.c             |  9 ++----
>   target/i386/kvm/kvm.c                |  6 ++--
>   target/i386/kvm/xen-emu.c            | 32 +++++++--------------
>   target/i386/tcg/sysemu/bpt_helper.c  |  3 +-
>   target/i386/tcg/sysemu/excp_helper.c |  3 +-
>   target/i386/tcg/tcg-cpu.c            | 14 +++-------
>   target/i386/tcg/user/excp_helper.c   |  6 ++--
>   target/i386/tcg/user/seg_helper.c    |  3 +-
>   21 files changed, 67 insertions(+), 158 deletions(-)

Actually this one had:

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Acked-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

But since I addressed Zhao's suggestion in patch 1
("bulk: Access existing variables initialized to &S->F when available")
which added more changes to this patch, I dropped the tags.


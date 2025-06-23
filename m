Return-Path: <kvm+bounces-50281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F6EAAE37DD
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3E68188F855
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 08:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C77EA217660;
	Mon, 23 Jun 2025 08:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ZN/k0oYg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744991C84D7
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 08:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750666083; cv=none; b=Xlhde+QsI178DEcfj0+++wiPG2/ek+qJyO0XXVTWndkiMFShe23Ywhk1+kgMXMiUovBReIX3/sZecLLk31fhfC0pScKLXoy6RFW+/fUB6JoGylhoTiV/00stIPVSBeGM6TXAIpVLwnB3zyQNBeLas5WJAul1/Krtf77bINm/9Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750666083; c=relaxed/simple;
	bh=Yh1kw1hKQqBhWmop6qzlDNGwkyJtpBrDnLSzRWo41xM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bl3ZovpkpK9iwnusDxw6+/KquxCRyJzN7GvfrpJSWGjCtP2yiW1RlfGmcOK2s8zAohY0t3H39iRExQKBbGRXHyODFgd7+4GCjyA11KlKRpwNZ9PiadhrtECtcEKTzVhJzR9dsTWG6gzEcXhkMMoOTSJR4ADbXM4WXdH/utFKPW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ZN/k0oYg; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-74801bc6dc5so2977688b3a.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 01:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750666081; x=1751270881; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZxpsxBnAztApt9xBJdH0Ct2uH1bvpAVjnJKcApgLnKg=;
        b=ZN/k0oYgm7mf2IOMeQbB27IlZfKRQfxx3nCy5eSeWWNlZH6GV4+Wzm6EexWWrKJQHu
         3XgtI6TNo9KEJ+hZZiB9cpiTv6xUBh7vYPtF03Dzlcud7iFvP/977oxi3afWDErsCJtr
         0TTtX4nW4FZ9sugzr7I2gygFI7aTbNdyz4vlxVziDXa3dTzj0zBAgk2gYnsF51zzKYEF
         vrVOsVnurBxMA1GLuy/ZDPKGvAm+MyUWNMB6My0TWj7NBs2Y1e0pCpmo2SKDwwo/17YR
         S8NQPCxk5QB2GqKu1dzMe6dTYQf4w2CQUa0C/VA6nNNIcQjx4ZfU8INzEXngp+b8yn/E
         qvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750666081; x=1751270881;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxpsxBnAztApt9xBJdH0Ct2uH1bvpAVjnJKcApgLnKg=;
        b=X0nmL94Bw/nLbbDJgK5oIlk8DPtpWNzfo6Y4GXcb0joVA5a6TacFGt91g153+uhIxP
         /gqjWk6hmdkIrWj/i12HX/CyFpQZB8edF/KeFZtDfU8tFob5h/UxJw6MK8XR9VAzGWW7
         L+5caU2oMeg0d2L7Yb3Klf9Gy3UjnYrimS89M+IKUz8toRqr7DYYQbHxQ7jtaevJvCc6
         kST3a6fvE62dP8/GOarcJ5HRqXIV6aqkDVLOBQTcNGlY8RwyHrBOOUcTgiBHkM+Rwgeb
         EZ2DAoJxrezxWzx3PBLjXlbwDXWJwmIRrCnaBpJ0LeFl0BYW7Is0UdcAaoYze9OXUVls
         RhwA==
X-Forwarded-Encrypted: i=1; AJvYcCUDbwIhpvBTiq0hJ+/wbPgwfEHqQOfRvCgEvUcidiA7xIfbd/R/dyQNBfMqczq9suHSQCg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyU74ZgyujEwQKxUYKJLTtMKb0fA9dewzcwgbknlejYoxLM/0o+
	zUY1oMylEFgYw1ykG4HI+mHvlvJiv1DJWmX8cL/J9RHjZWTTDbTJN4E9P/y1bUweOBU=
X-Gm-Gg: ASbGncvORI8UvcF+HmzhcEboGrU8CpEwKgm+HMA3YtbwJapLMZZ2xWxKZT+Em3taurc
	BX0pXzLAePUiEF2kRnRuQSvhT6FW1jL1H/ig4KkXsJAs+bo/a0DYPyvpem887qCby2pF4+BTdZ8
	yiFbxOcTRCnQYFMXslert/ZDuN0gHk0l7kb0ErqbjginQ3HUaqwkY0I0/tX6qNp3QVbPtO9NBxY
	Mt6RM6dFfv7W1SLxOcOg5rLcB/4FZcXuDkNCeF01+02nHkrpeY6G3RfEvUxam3gzS5JpwbewD+z
	CQ0cYxtNzQ1ugByReoPTAsi1AHKeD+fpeVzvY6KB//AIdX1tLjD84NcWuegkYoH4wPQbsZsV49e
	4ma9hCBuofF4DD9P22s/J6afDel8CYJAnW6rLvcEWmg==
X-Google-Smtp-Source: AGHT+IHuhK51wxxmabIbzoHHlgBq8UYX82HbhRz2QXhvMRsa67AChvnWz1JFNbTr22S/kvZSFTb/jQ==
X-Received: by 2002:a05:6a00:cd4:b0:742:ae7e:7da1 with SMTP id d2e1a72fcca58-7490f287c44mr14337992b3a.0.1750666080714;
        Mon, 23 Jun 2025 01:08:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7490a64b2aasm7719241b3a.116.2025.06.23.01.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 01:08:00 -0700 (PDT)
Message-ID: <c12729a1-5046-4821-b5fe-5fea72af76c8@rivosinc.com>
Date: Mon, 23 Jun 2025 10:07:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/3] Move duplicated instructions macros into
 asm/insn.h
To: Alexandre Ghiti <alexghiti@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atish.patra@linux.dev>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Andrew Jones <ajones@ventanamicro.com>
References: <20250620-dev-alex-insn_duplicate_v5_manual-v5-0-d865dc9ad180@rivosinc.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250620-dev-alex-insn_duplicate_v5_manual-v5-0-d865dc9ad180@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 20/06/2025 22:21, Alexandre Ghiti wrote:
> The instructions parsing macros were duplicated and one of them had different
> implementations, which is error prone.
> 
> So let's consolidate those macros in asm/insn.h.
> 
> v1: https://lore.kernel.org/linux-riscv/20250422082545.450453-1-alexghiti@rivosinc.com/
> v2: https://lore.kernel.org/linux-riscv/20250508082215.88658-1-alexghiti@rivosinc.com/
> v3: https://lore.kernel.org/linux-riscv/20250508125202.108613-1-alexghiti@rivosinc.com/
> v4: https://lore.kernel.org/linux-riscv/20250516140805.282770-1-alexghiti@rivosinc.com/
> 
> Changes in v5:
> - Rebase on top of 6.16-rc1
> 
> Changes in v4:
> - Rebase on top of for-next (on top of 6.15-rc6)
> 
> Changes in v3:
> - Fix patch 2 which caused build failures (linux riscv bot), but the
>   patchset is exactly the same as v2
> 
> Changes in v2:
> - Rebase on top of 6.15-rc5
> - Add RB tags
> - Define RV_X() using RV_X_mask() (Clément)
> - Remove unused defines (Clément)
> - Fix tabulations (Drew)
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
> Alexandre Ghiti (3):
>       riscv: Fix typo EXRACT -> EXTRACT
>       riscv: Strengthen duplicate and inconsistent definition of RV_X()
>       riscv: Move all duplicate insn parsing macros into asm/insn.h
> 
>  arch/riscv/include/asm/insn.h          | 206 +++++++++++++++++++++++++++++----
>  arch/riscv/kernel/machine_kexec_file.c |   2 +-
>  arch/riscv/kernel/traps_misaligned.c   | 144 +----------------------
>  arch/riscv/kernel/vector.c             |   2 +-
>  arch/riscv/kvm/vcpu_insn.c             | 128 +-------------------
>  5 files changed, 188 insertions(+), 294 deletions(-)
> ---
> base-commit: 731e998c429974cb141a049c1347a9cab444e44c
> change-id: 20250620-dev-alex-insn_duplicate_v5_manual-2c23191c30fb
> 
> Best regards,

Hi Alex,

I already gave my Reviewed-by for the last two commits of this series in V4.

Thanks,

Clément


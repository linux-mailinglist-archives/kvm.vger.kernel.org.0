Return-Path: <kvm+bounces-41768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25EC3A6D0C8
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47F863B3D01
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F286019C55E;
	Sun, 23 Mar 2025 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z9HaoeJK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F607F510
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742758153; cv=none; b=YOpt5r61ba8EG83aiG3lUelrGQE0HjGbAfchQ6Yoy73qRQpizMjxScT4+qq49S/nQhySfVs/Zb8DGd0pJfsmdp/qpA2Okx2IgEQoLiDo0fMOb+BVpwObh9/fXeNEMJ/bbmxthXqSBlM5ICj4Q1li64YtgPNZSKq1Sg6Tu/Uspuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742758153; c=relaxed/simple;
	bh=l/sd1LLbo3+0cm2e6YTzz7r0tboaAKh+TyRTqHjBAZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EgQ08eQQn1EcYHjuk7SKRLuAInZjJeDXYX4huUUHt5JZFKbM+OXFoA3my9a1TmM2kJmd5LQ+gAx7jcwsj3RVD/DDK7G3Kb+sOIFU/QGYtEGvLtKtH4hWUpTWNPLOkpzaDHeCdniLtV+bpKv9yNeAtHQ+M1Z/bxqV1iZYvyIvxUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z9HaoeJK; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-224341bbc1dso66288535ad.3
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742758151; x=1743362951; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PnAmtE3n3/paQ0lzVCvVubbi6PO9bdEfhffrgZLoMMY=;
        b=Z9HaoeJKG/7TlGUr1RhOGLHFpDkAIHRP8PBJxLpHbgg+ntsetSEnK6rZ8M8wvi4E8t
         S/gN4kkwRMbMVhrtyC+5a+Xg1B+AuX0TBVPc9P4Fo06uAKMNNXqjsuO0gbrQx71V09Gn
         y41i1U/FPEJy/XHkc2Q9RhgR0CYA9G+Kpg5j1MlINZ0TngrqMcSkhXxek6Y/GJ0FmHMZ
         fVnxLp0H5CscjtfDHU25QreZpVlMIgjThlrQkb3yDyDX11fjGo/S0UTXOiq3UnmZzbXN
         6u9UEqTAZs+pfjXUd6idyoFZSzzT3vVL7YmrJaOiTL2yMpeDLGG+v5tPL1o9Qi9u85T0
         DR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742758151; x=1743362951;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnAmtE3n3/paQ0lzVCvVubbi6PO9bdEfhffrgZLoMMY=;
        b=STSiMiqBRWhICyDnIxNvxWjZC3A2o6wYgVfjahUEtF7ztfwW0M5UtOGadcZw13WBN0
         EugNHAs+vK4zbmwcbBOwRwmNHarhOm3xlK0j4qIpUEYsWqz5DTlV+9wQeEfWBnMgxwdZ
         vi/J3ISeUAOVD4JBo4xCSjq+pjj8mwUw69ywmF291ZAoNLizTclcbCus7Zio2LlKNvEK
         TyyK5ptUx9Oa0J6Tn9b09APoKGbZLQqoA/Mjoq+3NlwCEDcqNqxX7vROrx+mtK6MGivz
         uLlRUnqbLf0PzO7ttayCnMre/ETg/2tNSFenvR3SS6neE4Qp2UQNnBOUSN3ZEpvuvtbF
         NJWw==
X-Gm-Message-State: AOJu0YyJR5YRfpyAD0Bs3waHMMcxDvEO1MDjBA7G93KPZkLkdE4p/MtA
	rQzu+DsyA3D3YtfeZgh1PDuB7iRqtrgpDl8znQqhoNyGZgCq79vPW6E+BH7wQmg=
X-Gm-Gg: ASbGncsDlb3NqcOpS4tPmAY59On94cN3I5f0BAtMte0bbwMEQ8/mSADVJQMewCFha8Q
	pgTmPmhSuf1xHGz1VVaLZhwp+nl+NAs3JMQR+vP+lq7Rq/BE1F42gC5kE8CpZhxwGjlWpsBKZB9
	ECeaTo3+D3E85exrj0ked07q0i/dRASiQENzm1hFzJU4PrcOzgLI6UPEmWBOeBazUKYf1ui+eXT
	DmpTXw8Na5U9SlnCpmFeFFdvWKtQcT6TDQZXbez8Luu306de0lzcKmGJUyplAZhZL47ulOD3H0y
	bvVdIwv3cDvHb/gQeYvxFioul0V0PP7WVRpafpW93x5SXT+mXzG/fzK+J4Phu/W+a8ODGPoJ1jk
	kST3YVYQ1
X-Google-Smtp-Source: AGHT+IHhpB3aRRBvUNs1iJcgRmDfGzmnOHPpyNLwpQfZOeU+obhVJxFhxXQ0Gu/SEvcE09tL6vTwmA==
X-Received: by 2002:a17:902:ebc9:b0:220:c63b:d93c with SMTP id d9443c01a7336-22780e234c5mr155026135ad.44.1742758150853;
        Sun, 23 Mar 2025 12:29:10 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8c2sm6366198b3a.107.2025.03.23.12.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:29:10 -0700 (PDT)
Message-ID: <587270a8-6758-4c24-9d1b-911d754ce1e3@linaro.org>
Date: Sun, 23 Mar 2025 12:29:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/30] exec/cpu-all: remove exec/target_page include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-11-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-11-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   hw/s390x/ipl.h                      | 1 +
>   include/exec/cpu-all.h              | 3 ---
>   include/exec/exec-all.h             | 1 +
>   include/exec/tlb-flags.h            | 1 +
>   linux-user/sparc/target_syscall.h   | 2 ++
>   hw/alpha/dp264.c                    | 1 +
>   hw/arm/boot.c                       | 1 +
>   hw/arm/smmuv3.c                     | 1 +
>   hw/hppa/machine.c                   | 1 +
>   hw/i386/multiboot.c                 | 1 +
>   hw/i386/pc.c                        | 1 +
>   hw/i386/pc_sysfw_ovmf.c             | 1 +
>   hw/i386/vapic.c                     | 1 +
>   hw/loongarch/virt.c                 | 1 +
>   hw/m68k/q800.c                      | 1 +
>   hw/m68k/virt.c                      | 1 +
>   hw/openrisc/boot.c                  | 1 +
>   hw/pci-host/astro.c                 | 1 +
>   hw/ppc/e500.c                       | 1 +
>   hw/ppc/mac_newworld.c               | 1 +
>   hw/ppc/mac_oldworld.c               | 1 +
>   hw/ppc/ppc_booke.c                  | 1 +
>   hw/ppc/prep.c                       | 1 +
>   hw/ppc/spapr_hcall.c                | 1 +
>   hw/riscv/riscv-iommu-pci.c          | 1 +
>   hw/riscv/riscv-iommu.c              | 1 +
>   hw/s390x/s390-pci-bus.c             | 1 +
>   hw/s390x/s390-pci-inst.c            | 1 +
>   hw/s390x/s390-skeys.c               | 1 +
>   hw/sparc/sun4m.c                    | 1 +
>   hw/sparc64/sun4u.c                  | 1 +
>   monitor/hmp-cmds-target.c           | 1 +
>   target/alpha/helper.c               | 1 +
>   target/arm/gdbstub64.c              | 1 +
>   target/arm/tcg/tlb-insns.c          | 1 +
>   target/avr/helper.c                 | 1 +
>   target/hexagon/translate.c          | 1 +
>   target/i386/helper.c                | 1 +
>   target/i386/hvf/hvf.c               | 1 +
>   target/i386/kvm/hyperv.c            | 1 +
>   target/i386/kvm/kvm.c               | 1 +
>   target/i386/kvm/xen-emu.c           | 1 +
>   target/i386/sev.c                   | 1 +
>   target/loongarch/cpu_helper.c       | 1 +
>   target/loongarch/tcg/translate.c    | 1 +
>   target/microblaze/helper.c          | 1 +
>   target/microblaze/mmu.c             | 1 +
>   target/mips/tcg/system/cp0_helper.c | 1 +
>   target/mips/tcg/translate.c         | 1 +
>   target/openrisc/mmu.c               | 1 +
>   target/riscv/pmp.c                  | 1 +
>   target/rx/cpu.c                     | 1 +
>   target/s390x/helper.c               | 1 +
>   target/s390x/ioinst.c               | 1 +
>   target/tricore/helper.c             | 1 +
>   target/xtensa/helper.c              | 1 +
>   target/xtensa/xtensa-semi.c         | 1 +
>   57 files changed, 57 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~


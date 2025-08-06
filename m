Return-Path: <kvm+bounces-54105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E3DB1C3F9
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 12:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E059B18C0CF2
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 10:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3F628AAE3;
	Wed,  6 Aug 2025 09:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="JodVtdKs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7BC28A725
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 09:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754474354; cv=none; b=jiyupdMEWQBhHhbjf9g41ULixc8tdJ2Ta3kmnoVm3pRNnkw8H9KF4o3RpEWx/CiCuGnBfYGuIJr4Kapj8MWHJolJI6rDCpdZLYndzyHEq/qIR5dnEZqYjMuLajTfrPHmc6m6dMhIfUVCjn1MeYBcMwn2jfyGjfLdxOcBxqgkBcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754474354; c=relaxed/simple;
	bh=IKb5uL5a/Yv1fqtDIHgQ8CxYzBv3w+4eE2yq1mQQMCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TIb/1yarJlotyu4bbAQQdmXuDI+fDmjrAw8bFDu5ByTWh8lVXD7h9BVnCmRXJmTJJ7Ad6t25I/x+CQv/G8JGi/krS0rqV7CBCm79gjS8DaVP5415GfIuaWzCY+dxz3EMe72qNU2t+vJSlSJb4uE0d3dxFWEJUGFMv1LFpT3Uc7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=JodVtdKs; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-23636167afeso46693945ad.3
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 02:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1754474351; x=1755079151; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nVGDM3I4SAq4IdauxFBCdAq636kZPPhTHlfXhatdxwg=;
        b=JodVtdKsakt68yizrYENPkHCaH3/eKoTv0iLPGBcmALd3xSznwfqITVwSooAL5tYTk
         w7Wgssl02hmfqArrUqCZUqAoGvQ0Ijdd9HPn0VQjBdFEcL117a6gSr2aH+l0KtpVmKuF
         0Yu3x1xPmp5v8jpqY+nWy6XLZxaEiGJsYtgh5kQQLSnryYTZXbZGB5+o6Zo6KcYonx3B
         vGagya54iV1VXzwtGf4z1CQ8aBXOqpLuHHYGRxqjlhC3Y7jVxPyf6iAV3QoHlccBCEEm
         3ZTQnoQl+s8dVJECoS5vmqVFxfPKDf8kJRDrIb8VWukXjFT5tBJzitnHC3AeF/dDNl2r
         q75g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754474351; x=1755079151;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nVGDM3I4SAq4IdauxFBCdAq636kZPPhTHlfXhatdxwg=;
        b=LKOO6iF7ZMmrf2Q6ezU/I81NSLPllfMeEPK0uyRcakI2OGqJi32ybHJko5aOXOAkjy
         vUKxammbdzcb9f2+E13JzuGr0flgayUTUHAK6eV5sSVWr6cd9tgeN+q8VLyUDVf7XsDd
         MjNdmVOwPqsbW5QJ2yE4ANhC4PmPieu8g9j6xouyfFTO8KsTMh/JjfqDq96UUHkpRmu/
         QZJilLMdxKdzGOaLsYMz9TvmTPXIsS9T4t8xRT+0IR4N9JVMK/Z2cgWN7cqDpab/3XcM
         gAIjMwOScMYjqEpq/2uUq6d+JZiZXZiNYfIG5btGchdses0IHI0JkTAmmEan1nqaZTP3
         EHJw==
X-Gm-Message-State: AOJu0YxZussnibRkymR5LuPukTc3Uzem3MZc6i10bASnpajtK5MF/NhH
	aWhSq3/nJN/m9maa9bVWjOyHAgFwnabe8Hy3yFsdcA8/42D6JlPMFuKx8prnzBkdkMw=
X-Gm-Gg: ASbGncs5d4XDunY9ykJakCPSbqREJYZVfA1PaLHmHse+RCpKBo/TwSCkQs5C6yP+aSy
	MHCm4QQBCnAY2N8pJ/ZoccwPy4aA8ZoTICvgTya98tn1Yp0Ejhioz/KL0zFDd3oF4HPTA7pXmjs
	jb+uuhdwM2yB7tMckQ3h6x5kU4FiQq4wK7BiA0+MtstL1cLX0Akc5vpMMrxgdSpPj0jNqt4+jew
	SGTsOwpGV2jEQKVXEjMIYODJemNltrnRElyws+b9H6evcBaghstyqX2wNF48PqE02NpldC4Lzt2
	HjQ18P7+zGBwXuZBR5hiNraF+vi1TQaA+5ZtAdEdlkLqZbR8XYCrpNBIYJNFdlL3u+TnYz25oBw
	qztvGMZM7vF+0wqPI9S6kfqycRKdH9nR0SAI=
X-Google-Smtp-Source: AGHT+IFDQkiy8dEal9JGcheFb4DCeMC/D2uxTEcourcA4xojZOo5yHWKjW3OBM8sYPB5X5rv1iZYAg==
X-Received: by 2002:a17:903:2302:b0:240:25f3:211b with SMTP id d9443c01a7336-242a0beacd1mr26147005ad.51.1754474351119;
        Wed, 06 Aug 2025 02:59:11 -0700 (PDT)
Received: from [192.168.68.110] ([177.170.244.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8975c03sm154551605ad.97.2025.08.06.02.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 02:59:10 -0700 (PDT)
Message-ID: <953d2f4c-d82f-4e8f-a905-b7dfbf690ef7@ventanamicro.com>
Date: Wed, 6 Aug 2025 06:59:06 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RISC-V: KVM: fix stack overrun when loading vlenb
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>,
 kvm-riscv@lists.infradead.org
Cc: kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 stable@vger.kernel.org
References: <20250805104418.196023-4-rkrcmar@ventanamicro.com>
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Content-Language: en-US
In-Reply-To: <20250805104418.196023-4-rkrcmar@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/5/25 7:44 AM, Radim Krčmář wrote:
> The userspace load can put up to 2048 bits into an xlen bit stack
> buffer.  We want only xlen bits, so check the size beforehand.
> 
> Fixes: 2fa290372dfe ("RISC-V: KVM: add 'vlenb' Vector CSR")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
> ---

Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

>   arch/riscv/kvm/vcpu_vector.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
> index a5f88cb717f3..05f3cc2d8e31 100644
> --- a/arch/riscv/kvm/vcpu_vector.c
> +++ b/arch/riscv/kvm/vcpu_vector.c
> @@ -182,6 +182,8 @@ int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
>   		struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
>   		unsigned long reg_val;
>   
> +		if (reg_size != sizeof(reg_val))
> +			return -EINVAL;
>   		if (copy_from_user(&reg_val, uaddr, reg_size))
>   			return -EFAULT;
>   		if (reg_val != cntx->vector.vlenb)



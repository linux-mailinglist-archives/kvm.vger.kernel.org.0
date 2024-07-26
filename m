Return-Path: <kvm+bounces-22307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 471FF93D00E
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 11:04:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6360E1C21212
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6D6178369;
	Fri, 26 Jul 2024 09:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="evI9lmLZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A20E1F951
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 09:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721984682; cv=none; b=Iyv5ohqB7bbtviVwIxriOWYakhcRXP8hw7+1TNTNuiF7Bh6mX19vzIjAuEetGzhK+IjD0ifT88j6Hd3Gq+7KxxsfboNpIJQ2EKY6wujMG5QRh/eJrJBO3kxeMthHqyhS2LApUdEzAZtS8n8PoKiK9BqAzJCv/qiswvDLB2hp6Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721984682; c=relaxed/simple;
	bh=d/QR2vivKnmDTRAhxMFOAcqhKM9oDO/AaQHBmraNENo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yq+0G7wHUBpi1DzVtzs5dz/q2TAtJZFQbY1/C0S2ojMNGeCmaGcjBEnK/bQ4lzKDk6c5GZWVh4fc36Pj/vRU+eiMc5RiPN0vk8fEX87YkakukyIOW8C5fJT5gbHdZFmJpBKy5x2ifHfyuszLFSoX/x85nEVMkMTitioNs0lxC90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=evI9lmLZ; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-427d8f2611fso2202145e9.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 02:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1721984677; x=1722589477; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nPNljb5qNYMPMOw83Na142uqAvImzCX5024L1+3yenM=;
        b=evI9lmLZojlQD3uj70kgsH61A5vmPlJhSa3v5N344QRF3Q8pbhJtLGfYcSZmOUz6B4
         TUjhi3MV4Ma6RQj7IOd4eD8PEPytJioWFCosURjqN9ytHxb9ZnvXGWi7avpdEFVEuIc8
         nT//n4qCmUHy/LKuoMtFqZZ/xb1gn3hHkhcV6oS5OpTCX6lCvoMd3VhTU8TQzIKEcp6T
         b0QIbbrBYYskZQZL28jZvxHSsatlCN8nRW6dkzC40E71VYtMeF0wfjdzdHTIn7E4nj9M
         Mi1tJCeSprzgQbWQGELeIp7u+GVmv+URNULEN1+IlSuZsPJ+Byxqc8lKT1AkvPDwEHwD
         wjBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721984677; x=1722589477;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nPNljb5qNYMPMOw83Na142uqAvImzCX5024L1+3yenM=;
        b=HZECdXS9PSUxYZZrfzxzg3l6cStvp1PvkTKO0lbGgnWV6TRW4ibBv99gVyFnzIrlBL
         U8kSizpAtwy5USV2juIUBipCZva9IQhN3mftT2G0uhbYcbVIpFP6jc1GHT5zsPjBHa71
         t9ChgxDATEr9bCuFD6O8hHgzcYOiJraiSSCJgKkUnrS34qA9ShgtjN1LBDhg1UPt3zd2
         l8MB7nmTqxL7SgQb3A7LNnz+bcYiHZJsXXoDk97qgZO2QD/SAMSSdXylo3hJd50/4Y22
         jAOuD0/vblEWM+fODTSaHSgfzoxdQkpFPY4A2EFr17u2h7uKRtG9KxlRIIdZXPrBrYm2
         eBew==
X-Forwarded-Encrypted: i=1; AJvYcCV13Qdfo0oaRpOBhZGnDMwVjrCWLhyfsm1w0LBfpwwkz3RaaPtLpfyNuPp712o932hlNhLasN6A2fLPofyRgqJ4RbxV
X-Gm-Message-State: AOJu0YwQ/fHUuovt2a72qnjetHaqjokQTo7t3BQHmHSfyyWGBUW/ZvNx
	GsF5VcMOirSlDHVvBxtFfvd7rzsu/ZjRrLjj9sWHG1VmUYXjWSBXBHuADfsbkio+BO4X4tkY9/N
	FZM8=
X-Google-Smtp-Source: AGHT+IHpM5WQagCaKcwKi7l210VOh4MjHNgi0pLYAhmXUw4nGhc+sr2ehr8mh8kMFL5gq6elvxoPuw==
X-Received: by 2002:a05:600c:3b87:b0:426:5f08:542b with SMTP id 5b1f17b1804b1-428053c9c55mr21919405e9.0.1721984677149;
        Fri, 26 Jul 2024 02:04:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367c032bsm4476347f8f.12.2024.07.26.02.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 02:04:36 -0700 (PDT)
Message-ID: <f65d5184-d397-46ce-b8ba-dfe2d3a5ad40@rivosinc.com>
Date: Fri, 26 Jul 2024 11:04:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/5] KVM: riscv: selftests: Fix compile error
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 linux-kselftest@vger.kernel.org
References: <20240726084931.28924-1-yongxuan.wang@sifive.com>
 <20240726084931.28924-5-yongxuan.wang@sifive.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20240726084931.28924-5-yongxuan.wang@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 26/07/2024 10:49, Yong-Xuan Wang wrote:
> Fix compile error introduced by commit d27c34a73514 ("KVM: riscv:
> selftests: Add some Zc* extensions to get-reg-list test"). These
> 4 lines should be end with ";".
> 
> Fixes: d27c34a73514 ("KVM: riscv: selftests: Add some Zc* extensions to get-reg-list test")
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index f92c2fb23fcd..8e34f7fa44e9 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -961,10 +961,10 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zbkb, ZBKB);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zbkc, ZBKC);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zbkx, ZBKX);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zbs, ZBS);
> -KVM_ISA_EXT_SIMPLE_CONFIG(zca, ZCA),
> -KVM_ISA_EXT_SIMPLE_CONFIG(zcb, ZCB),
> -KVM_ISA_EXT_SIMPLE_CONFIG(zcd, ZCD),
> -KVM_ISA_EXT_SIMPLE_CONFIG(zcf, ZCF),
> +KVM_ISA_EXT_SIMPLE_CONFIG(zca, ZCA);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zcb, ZCB);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zcd, ZCD);
> +KVM_ISA_EXT_SIMPLE_CONFIG(zcf, ZCF);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zcmop, ZCMOP);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zfa, ZFA);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);

Arg, my bad. Thanks for fixing that.

Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément


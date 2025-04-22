Return-Path: <kvm+bounces-43801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D499A963A4
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 11:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B21441885EE7
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664F91F03F2;
	Tue, 22 Apr 2025 09:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="hYqdLi1c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B9D9476
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745312706; cv=none; b=KxoYM/J/UumtGvzgRRRCAqrrXL8EX1NhsRDGuFHblkFuRa4Gts7MI2pHQ9CEKGGL1RMp+gWcVnjhNrYj6ZHxNNlnlS0yAo8AsQqT8GRdhwJg3MKx2U+gqMMNxl619by2zHse9h0f+yEbAYVlugndXh9kt6KYQNFYMfG0FjTmUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745312706; c=relaxed/simple;
	bh=kvFqZqPFPLrf+AXNRqtRi5kNmumBCHlZasr9Kaopxks=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lJ64Pi7RUJHOqJLBttuFtx5YW4wSUgp7JnH1DTYk3gzY25ZnJ9FExbEHRiQXv4+ImxFzvW8JJDXizuM+4ulcckk3G+aW6iO0pYI/RQuvyGa+TkyhGSueGEVbZ2a0CwlX6qvSZM5muLEaEjGK05bKz2xxnNHldVzSQVcjrlUTUjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=hYqdLi1c; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22c33e5013aso54862465ad.0
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 02:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745312704; x=1745917504; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9sbWhyfY9HhbUloK/aOxoz84ZiMRz1BlzsEwnFKYVZM=;
        b=hYqdLi1c8lDxS5uTWt4tnCVXPFoFVIQY1kGsubjceziBpk2Bl89e6Hv0R8FEYfpZkh
         PtHIi6NrSMZGwohUreEjdtAHv9vtfdlGbqDmlVWxyTaM9GtEkVpZiRB9XPieWHuNf0Dq
         7Xd4AWc5QUoUqTRH6rlXk4aucxcDX6att0ySmOhErD38SoNcibpFge2w3fligFP+sG19
         n/QL9oDhrir6klD9V3xLQT5cPc1WTLACVYPBXrrFInz4DShJl89MlfKqonihpeES3QVf
         mcWlfTnFaUyKukLTgnylLwdJYQSxxsq/bUCkmg2vzqDvB3EQLg5W9bS/8mUJLBnY3yi4
         M/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745312704; x=1745917504;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9sbWhyfY9HhbUloK/aOxoz84ZiMRz1BlzsEwnFKYVZM=;
        b=q6CouiV56QnWN32U+/AkoJKsv0jD3Vb+wL6z6ehrqEmBPmENoMkeK0pU/FkFG9jOCZ
         +bXmCFhNvRrF+5d771vETXuEeraWUarf3JwmNV4+wigUA+PKt7ZXtyigUN9jZLYKAIbk
         ApCofnbHu3Bp7e1mhvLlI3Pmy2C8/hOVbkfmq7zhYB+MoUPfQQYb7qZ85tnuc7xcnVNn
         QBs8kmWsPRzp8BvuFTpXRftf8Z9L1XWXQOClNdc63Z2R2sQ74Q/huOzbaAbW+A8F2em/
         O5CtbD/wPT94ERiZgDpbmOUUom/Ps1O1/yhAtwc712q5y9M2R/nH8CyAR1YKz16M/zOS
         3DPw==
X-Forwarded-Encrypted: i=1; AJvYcCWs8CTtj5+cX2lkA25z/MbWNE1eEzS7oMUywC71g/aUsm9prput7/fOs635C0kWNotmmz8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0ghswgN6QRvoSFLdquQ8HZiz11OA1Vkb/0Q+zmFlRmHziHcq9
	poGMIoih0sSoimGSwcUTiIIdrKWiptw0xny3ik97QFVNiWr6bFak2zbEWXPnX4o=
X-Gm-Gg: ASbGnctaoPpNWyqEP8gWRV+CDLdQHuh60xB1sdDhHknRKxc6+KxKRNkA7LE2GdP6ORK
	quBK4VQskcMZN0SlfZmpokFtCWSuA0JpRyXrrf2p+qOdQUcJE3eL7wNH2DhiGVkpJ62N0V0KH/m
	/Y7ihdHZvfBzl+xiJrw0nFQux5xLw9ZHvBGcA3Qo1Xntg7mJUzvEV/c3rGO/PNnPt4L4Q2ct/7A
	rhtTOZjz0hkpTTh+vLV2/9c/v1/Tyv0IHKVmDeoPUhmIkqFotaVAVadDT8qWiulwe+EA6b23gJd
	6nKpuejBv6RKT4TwJyR+C824CuvJfEyi4+dxJeWrnlVogS4chM94rslIz9dWK/sDxo+iIcBq0d4
	q4LpzUcVHTQ==
X-Google-Smtp-Source: AGHT+IFQAi0wfUdXECfqD6I8bX3VpVnKTNf9yhWhTBL6GpAb8S8NxnHQlFHw5TO7+BUIVct0khX/5A==
X-Received: by 2002:a17:902:db03:b0:223:4c09:20b8 with SMTP id d9443c01a7336-22c5360dc1emr185868245ad.37.1745312704167;
        Tue, 22 Apr 2025 02:05:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50bdaad1sm79600495ad.28.2025.04.22.02.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 02:05:03 -0700 (PDT)
Message-ID: <db59c652-c4ea-4ed9-abf3-75886924057a@rivosinc.com>
Date: Tue, 22 Apr 2025 11:04:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] riscv: Fix typo EXRACT -> EXTRACT
To: Alexandre Ghiti <alexghiti@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20250422082545.450453-1-alexghiti@rivosinc.com>
 <20250422082545.450453-2-alexghiti@rivosinc.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250422082545.450453-2-alexghiti@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 22/04/2025 10:25, Alexandre Ghiti wrote:
> Simply fix a typo.
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>  arch/riscv/include/asm/insn.h | 2 +-
>  arch/riscv/kernel/vector.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
> index 09fde95a5e8f..2a589a58b291 100644
> --- a/arch/riscv/include/asm/insn.h
> +++ b/arch/riscv/include/asm/insn.h
> @@ -352,7 +352,7 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
>  	({typeof(x) x_ = (x); RV_X(x_, RVFDQ_FL_FS_WIDTH_OFF, \
>  				   RVFDQ_FL_FS_WIDTH_MASK); })
>  
> -#define RVV_EXRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
> +#define RVV_EXTRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
>  
>  /*
>   * Get the immediate from a J-type instruction.
> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> index 184f780c932d..901e67adf576 100644
> --- a/arch/riscv/kernel/vector.c
> +++ b/arch/riscv/kernel/vector.c
> @@ -93,7 +93,7 @@ bool insn_is_vector(u32 insn_buf)
>  		return true;
>  	case RVV_OPCODE_VL:
>  	case RVV_OPCODE_VS:
> -		width = RVV_EXRACT_VL_VS_WIDTH(insn_buf);
> +		width = RVV_EXTRACT_VL_VS_WIDTH(insn_buf);
>  		if (width == RVV_VL_VS_WIDTH_8 || width == RVV_VL_VS_WIDTH_16 ||
>  		    width == RVV_VL_VS_WIDTH_32 || width == RVV_VL_VS_WIDTH_64)
>  			return true;

Hi Alex,

Looks good to me,

Reviewed-By: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément


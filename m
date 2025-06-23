Return-Path: <kvm+bounces-50279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BACFAE37C9
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D2B61887E11
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 08:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E608214A7D;
	Mon, 23 Jun 2025 08:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="hlIr0+xG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFCF20408A
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 08:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750665900; cv=none; b=JNwaZfnHu2WEL2exKzCLcEFOhgvkY0iNgO1XP2BqzpL89jNIkIT7sNcD7nDy1+Sk0ZntXe4bAj6GN7N2/Xd2041mAjlIC1mK/k3PBuxNHEaWhQP8YBmBXDT7E1p2dLikeLhv5dYe5DGv70ECEvMC738w3fN8O7JC1RXWi2Pt3Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750665900; c=relaxed/simple;
	bh=G1w0adoxO+ajxlGkY1rIijF7bO7HKR5s4V4mGepiLAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DBQ3OZKttBIseDShUwHWdvs7oWxiD4lEC/yjeqKTF+gu1SfGhnK6Uep1ULSqgNzyzartci6D4k0HnGM+e8BhCFLBQBC8/OIFNb1lBKF52i8cCHiVJoViKZ8tqh0HaToaS2hCOwNuKXwQ7QHcFwv4yn8jJGA0wjTslrXeIBWoWUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=hlIr0+xG; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-235ef62066eso51211915ad.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 01:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750665897; x=1751270697; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4vmYNde3494s1oZAkDWHVWSrNdQuXQcEtL0WwaKvH1w=;
        b=hlIr0+xGB14mwjiEXA1GHSOqonDemjrupW/YtxymfiQuoHKBs13aFZNwFSuIz+wYO2
         9UDbsuw5/rxifbu4pD04jD3VXm1UyxqaQw8f/REsRRPqFEQDlAg/WH0gS9MXfnbIn6sv
         Y1tvmZQ/Qa3V6d9mRJ04yJolXqaOeZJ8mragNHy0c0CQknPCdKTWGqZpYodPD4vwEZsj
         wXjohd06RXos8QZM71VsBImA/OKRY7opwiVO6xR4Zphj0HTDCzC9N6VivNesaflLCsnG
         qhyRLuBFN2n7qj+27IBQV1VUvBpJ171FXM7cc0ujx2U6lGuWJoYTvRfEHa6uzqEJXEMb
         W8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750665897; x=1751270697;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4vmYNde3494s1oZAkDWHVWSrNdQuXQcEtL0WwaKvH1w=;
        b=kvWGaLORA9ciL6w+GSr+Y7DkzH50GSJ+aGlBg4xZ4itv8+i20gsOLY18AaGW2zU/OJ
         R/DuiBECwBSoqdjifgIfiAEYsl6IGARe/v7EIkRooa3IlgVady0HOOQ5f7HrWz7FrlIs
         BWbGck7pBw62SKj+ljMm14IOkpeVpzsL1bD+0coZ4B5lXW0TblJzKG8y8Xri0uC/sXZW
         EAQCK1uONk7+onu3eY0K4mdesLpLp3wnemO9JjiYbU9yyTxFn9Ctp8LPNq6K8rRKjoSp
         nm6+ldUZRhsezUkmql9NB1TCwQ60hp5na1z9Fvn+A2Sb/NDAVUsDq9l1BnIk2XCr2+9u
         ObNw==
X-Gm-Message-State: AOJu0YxDR1MWUueLMshagc5Mp40KYTG0/uiSVzy32wcxG0jK/+PVKOSc
	if7Xe75LeeEfG5GKiOln/oOwTUwWWCQHSWS8LVhVb/fuTZ6sbodtDRmViiOvfqTV1io=
X-Gm-Gg: ASbGncuhIztcL+El8xB1M8u5/ookNp44cllu6EqoLgDVLyr1im4QEg5mVESvmZCHEUo
	SND503CKcW+O7WyZr9oy7TQwztWyNtPMMBinxG5vzUk6lc2uESmIr887Dt1if3WGAF++BYmmlGX
	Dinjz3W3vVvAcgfFtH5+xpgRXQNR+tr9nSaZDUcHnHxO6r040i4r5mXVgmdFXSZ96FMPIeO4HC8
	aujgl+NO7zHiwoSU5mzqICvgjHbyakPxvv4HHDqgRM1M1YgxpbxppDPH4stleR5mvjmyAI/fxuV
	dVneXD+tSPZiUQkv15VZV88SXx5R/QSfpCU3CyFZTSXZ1kugCkkSUSOcx7vZHgXiSFaJ0LeYhgc
	sdTmfXXFCbIijBE5skMbR9XUm//7NXhQ=
X-Google-Smtp-Source: AGHT+IGAu8sRN9d6YginLzXnR26SBrwXTWtMoIeqalY4gdd+wB4xJaqi8iWblIrCKepqAoQGghGYIw==
X-Received: by 2002:a17:903:4b30:b0:234:8c3d:2912 with SMTP id d9443c01a7336-237d96b6361mr175973175ad.11.1750665897172;
        Mon, 23 Jun 2025 01:04:57 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d867f8d0sm78007835ad.175.2025.06.23.01.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 01:04:56 -0700 (PDT)
Message-ID: <1d9ad2a8-6ab5-4f5e-b514-4a902392e074@rivosinc.com>
Date: Mon, 23 Jun 2025 10:04:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RISC-V: KVM: Delegate illegal instruction fault
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>,
 Xu Lu <luxu.kernel@bytedance.com>, anup@brainfault.org,
 atish.patra@linux.dev, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-riscv <linux-riscv-bounces@lists.infradead.org>
References: <20250620091720.85633-1-luxu.kernel@bytedance.com>
 <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 20/06/2025 14:04, Radim Krčmář wrote:
> 2025-06-20T17:17:20+08:00, Xu Lu <luxu.kernel@bytedance.com>:
>> Delegate illegal instruction fault to VS mode in default to avoid such
>> exceptions being trapped to HS and redirected back to VS.
>>
>> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
>> ---
>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
>> @@ -48,6 +48,7 @@
>> +					 BIT(EXC_INST_ILLEGAL)    | \
> 
> You should also remove the dead code in kvm_riscv_vcpu_exit.
> 
> And why not delegate the others as well?
> (EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
>  EXC_STORE_ACCESS, and EXC_INST_ACCESS.)

Currently, OpenSBI does not delegate misaligned exception by default and
handles misaligned access by itself, this is (partially) why we added
the FWFT SBI extension to request such delegation. Since some supervisor
software expect that default, they do not have code to handle misaligned
accesses emulation. So they should not be delegated by default.

Thanks,

Clément

> 
> Thanks.
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv



Return-Path: <kvm+bounces-16116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE7D8B46DF
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 17:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2C9A1C20D35
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 15:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0751A125D6;
	Sat, 27 Apr 2024 15:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Ybhgi47L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94445660
	for <kvm@vger.kernel.org>; Sat, 27 Apr 2024 15:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714232169; cv=none; b=XLq8kwlVfcYkTd9AJnt/Bk9uk065B8YeEcuwP3wS+J6vSYTENOiFLfr92BSYevUUnKyh7QNVwtf03m7qcb1fAic44XZwugrlD6NYblArKdlNa5JHSZZsau31ytstoLUwXAi1TIwxJtwhPDN3rPfd39lhDVWpLzEmrI/UFOCFU5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714232169; c=relaxed/simple;
	bh=XpAmTcqGbFNcfVbx6nwYPgUEFZ1UPcnzA08aPj4a1mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k03XF5QBqEYYOjG6M1BPwZkHg6wketyk9Lzr+ez93MoOFC3K4e9udZt93kECVqB0oxXjulMCD50IIhMTWXgSDrDal+Zc9cViSItbxGf0EQbeXeBwiS+ITJZg2EHpQLWnBETMC5+NEX7irtEZFWGqOkhtIkQIvt0h/4im8heQ6Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Ybhgi47L; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2a2d0ca3c92so2258570a91.0
        for <kvm@vger.kernel.org>; Sat, 27 Apr 2024 08:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1714232167; x=1714836967; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zTJw2A6adNJVmUl2COe/T/6PCi87dKKLBY/6yf/6PZY=;
        b=Ybhgi47LCZelfTXohltLiFSy02ew48EaZ4am4Vm77HDYBbUkkpXUNfkKcaYUQzzbue
         9wFcK3gVtjRdUyRKQlD0n9208ZSL12U/jiVelDg9iTBiHPxLqEv+Ua0t17Cjrd/NofFc
         qC6RyDyA3SZFa8dmNts5DtRYFbxlrXK3TrP9kn87qRWvu3PKtmvHrV12Q5NmRarYMdUP
         61/Vo+AL7URqfmGMPnoLPGcaR6X7BZqFIR50P9kPw4ZOc0nbLZNzHIu1GzeNLkWnXpHi
         DPT0n8o+A/4agnTQJ618ti4E8cuHeFtj6EcjJU58FtVseufIkFYjFaqmCrhjo/tBeU8V
         GbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714232167; x=1714836967;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zTJw2A6adNJVmUl2COe/T/6PCi87dKKLBY/6yf/6PZY=;
        b=Oq/Hznby+lP/Bf4ZcJurrDIxxCaSsTMNAJqvnIy60DjzRZ4A+vM9tvDQXp1LXPyw1v
         WDeI2JR8UEHrsf/cEIpGx6Mzx1P/EqirpkAFB2+KPyKVHu370qwR8eV3lU1E9SaKmDDh
         RfxmCbUqwz22Qqtmpe7gPtABr8rl73l2lWa8EX8hQxzzq76mnWob2GgYjx8o8KK2L8ym
         vFTaWI4sz1hjI7QXR8Rn3JCG5UkncNg4FyuMl8iqwS3j9yMLnQXxzIRpMWT7Ov1GwbHA
         EUcQD6JUfcmg04Y6wZTIW86V0pzc+CwfL4zOiYehIDgePUdnqz/jYaceAUS1lx2a1tqH
         yjFg==
X-Forwarded-Encrypted: i=1; AJvYcCWnLXdgUGslWtuUfNKEryAkc2SEoyjjbiOsiquxsYEMOYPn4oda6qCrg6LiFHtgDwlbZMuG7Hf6V0mBpdLR8v9V2O6l
X-Gm-Message-State: AOJu0YxN6mMV7WBRWFHInDu90jSuk1X9caJQwwNljowsIxr1oxxPAmHm
	HnQw+Rh66Ht6diHMssv3Hwq+toWcmd5Ui4kPae7WYONRBFo3ORE7nwWLh1Cv8Ho=
X-Google-Smtp-Source: AGHT+IF6xNtPoqawhIMLLPfVYL8r6zdUx0EVLZnU+vKFPxJUtAEJkdQ96JtmkdV5ZJvwpBa+CNpRDw==
X-Received: by 2002:a17:90a:4610:b0:2a7:329c:7976 with SMTP id w16-20020a17090a461000b002a7329c7976mr7869349pjg.8.1714232166957;
        Sat, 27 Apr 2024 08:36:06 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id r6-20020a17090a5c8600b002ade3490b4asm10494669pji.22.2024.04.27.08.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Apr 2024 08:36:06 -0700 (PDT)
Date: Sat, 27 Apr 2024 08:36:04 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [RFC PATCH 6/7] riscv: kvm: add SBI FWFT support for
 SBI_FWFT_DOUBLE_TRAP_ENABLE
Message-ID: <Zi0bZPoNIYbanIfO@debug.ba.rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
 <20240418142701.1493091-7-cleger@rivosinc.com>
 <ZixSFLZYZaf8BKHP@debug.ba.rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZixSFLZYZaf8BKHP@debug.ba.rivosinc.com>

On Fri, Apr 26, 2024 at 06:17:08PM -0700, Deepak Gupta wrote:
>On Thu, Apr 18, 2024 at 04:26:45PM +0200, Clément Léger wrote:
>>Add support in KVM SBI FWFT extension to allow VS-mode to request double
>>trap enabling. Double traps can then be generated by VS-mode, allowing
>>M-mode to redirect them to S-mode.
>>
>>Signed-off-by: Clément Léger <cleger@rivosinc.com>
>>---
>>arch/riscv/include/asm/csr.h               |  1 +
>>arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  2 +-
>>arch/riscv/kvm/vcpu_sbi_fwft.c             | 41 ++++++++++++++++++++++
>>3 files changed, 43 insertions(+), 1 deletion(-)
>>
>>diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
>>index 905cdf894a57..ee1b73655bec 100644
>>--- a/arch/riscv/include/asm/csr.h
>>+++ b/arch/riscv/include/asm/csr.h
>>@@ -196,6 +196,7 @@
>>/* xENVCFG flags */
>>#define ENVCFG_STCE			(_AC(1, ULL) << 63)
>>#define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
>>+#define ENVCFG_DTE			(_AC(1, ULL) << 59)
>>#define ENVCFG_CBZE			(_AC(1, UL) << 7)
>>#define ENVCFG_CBCFE			(_AC(1, UL) << 6)
>>#define ENVCFG_CBIE_SHIFT		4
>>diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>>index 7dc1b80c7e6c..a9e20d655126 100644
>>--- a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>>+++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>>@@ -11,7 +11,7 @@
>>
>>#include <asm/sbi.h>
>>
>>-#define KVM_SBI_FWFT_FEATURE_COUNT	1
>>+#define KVM_SBI_FWFT_FEATURE_COUNT	2
>>
>>struct kvm_sbi_fwft_config;
>>struct kvm_vcpu;
>>diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
>>index b9b7f8fa6d22..9e8e397eb02f 100644
>>--- a/arch/riscv/kvm/vcpu_sbi_fwft.c
>>+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
>>@@ -9,10 +9,19 @@
>>#include <linux/errno.h>
>>#include <linux/err.h>
>>#include <linux/kvm_host.h>
>>+#include <linux/riscv_dbltrp.h>
>>#include <asm/sbi.h>
>>#include <asm/kvm_vcpu_sbi.h>
>>#include <asm/kvm_vcpu_sbi_fwft.h>
>>
>>+#ifdef CONFIG_32BIT
>>+# define CSR_HENVCFG_DBLTRP	CSR_HENVCFGH
>>+# define DBLTRP_DTE	(ENVCFG_DTE >> 32)
>>+#else
>>+# define CSR_HENVCFG_DBLTRP	CSR_HENVCFG
>>+# define DBLTRP_DTE	ENVCFG_DTE
>>+#endif
>>+
>>#define MIS_DELEG (1UL << EXC_LOAD_MISALIGNED | 1UL << EXC_STORE_MISALIGNED)
>>
>>static int kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
>>@@ -36,6 +45,33 @@ static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
>>	return SBI_SUCCESS;
>>}
>>
>>+static int kvm_sbi_fwft_set_double_trap(struct kvm_vcpu *vcpu,
>>+					struct kvm_sbi_fwft_config *conf,
>>+					unsigned long value)
>>+{
>>+	if (!riscv_double_trap_enabled())
>>+		return SBI_ERR_NOT_SUPPORTED;
>
>Why its required to check whether host has enabled double trap for itself ?
>It's orthogonal to guest asking hypervisor to enable double trap.
>
>Probably you need a check here whether underlying FW supports handling double
>trap.
>
>Am I missing something here?
>

On this I am indeed missing that menvcfg.DTE has to be 1 for any less priv.
So, nevermind on this comment. Sorry about that.


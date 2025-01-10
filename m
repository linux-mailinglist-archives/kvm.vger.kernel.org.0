Return-Path: <kvm+bounces-35135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 24B57A09EBE
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:36:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5002188CC2B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 882E0222576;
	Fri, 10 Jan 2025 23:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="QXDy0Qp/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB0A221DB1
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 23:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736552157; cv=none; b=tYmLGi+LcC77o9M9tCoPxuEGqSeMZBT+bjzrchBFmGgwU1muAv4JaelCFOewLvtUILD4Gp08bY6gc5g5hYFWyWYRCxdaih3Lr+SHxoxb5aduSjv7HqyjA6+dV7mpth/WgzTLyQgED7xlBs4LgAGRITQDl/qgfHLka/LUuJgWwHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736552157; c=relaxed/simple;
	bh=QHzGVs757UqryEoikrze/1I/KBKZekAJL+KXzR2qz9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=CTCSQYSOz65PKMyRvnd0FADWF35tindBts8Fzx18h+TKU0fcDLpCl3hV+OiSzER3JtYugJUsFLYbsVMfXeh8xNieluZ7xjjv8czx+rtn7MQzwjRqWXMENkUkwaqZ5qrmBmieHinriUNlk5P6cDbjUKS1Tz3PFFyfsnm7nVfhljs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=QXDy0Qp/; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ce4b009465so9912975ab.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 15:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1736552155; x=1737156955; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CcCPEcTZhVQXmN6oY2VQr5WtuHg5l5fqZdLq8t5bbKs=;
        b=QXDy0Qp/6FcLteHsRGv1zaSYojkhyXNGhKXYcw3wqqmSq/BkUz9+l1REa/ZjE9OvEn
         /QGpUPAUaL2Rin47bVX2b+pmy44pb9v0KrAzg1jm57o9K066X5tCKX23vfdlDOKaWsBr
         cHvQ5OPc41wSHoUJowPXeH8s+GzbhY93LrGfvY30koqtvGBmAPOFkUb6MXiIRiZJXNoW
         Gzaiq1rNgP4mDkB8dnq7xe1pCctnJzZ0G6yKPXaNd0gHTKE+cWF5K1mO4jwhqMjbjjp5
         faOODR4yHB/a3DkETIhEOBbgVmfABG7cuF6AtDjAlP6Ltzt1CHDHCqiw6Nvdg8aqduYo
         Z0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736552155; x=1737156955;
        h=content-transfer-encoding:in-reply-to:cc:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CcCPEcTZhVQXmN6oY2VQr5WtuHg5l5fqZdLq8t5bbKs=;
        b=qAsUrmEdYqj9g6AoN96i7MmEMmnoGdJ6HPavcRwyBDZcQIRgpxdrMfNy3176CfuMUC
         IHJG77EdRC59lsalGNb9GiS3sm6LUDXx485GQ7S8rKTFB40ddFjAmVNMikKtAvS/L11l
         1pwhVWZx5y9YH9QIpNqqo7PcGE6z7zY8x2Bk2waGCTdu1JTdLapP+B/HBAKP4NEme+W/
         Fxl3KYdLT2p/aEuB0hAxHC3e9qKoM6DOrjrKaGC9tdJqtlC9d9nQ8rSeDuVB3nPUtAQY
         wJkwvIcI4s+evrA7h6Td5DHAVKK3BEV24kRki1nz6U5vO1iGqlcpq6vCNlXnOSZvlfsv
         2jeA==
X-Forwarded-Encrypted: i=1; AJvYcCXPdYFs5pEzx0aunajo1QnHoZ7W8EBwj51ocdG2kk9wnfjzMu7KmuCti8mXVpvBICoGiXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIlT4/TlKi6QN8aqvYD+hOBJsK1sQ3MP5bYTgOE4fSuT4QaAFh
	kPrKqu8LP6+pxB17fbXYDH/V8TwqbCYPIU4e3YX24MOMM6hs1I5hq0dT9tTiZVU=
X-Gm-Gg: ASbGncu7r9ltXhraHzoRu+YNtOD014oypf11QqNgmryZb5fKSs2NQuC/0P9ET0LxgJG
	+rHnl1PNPef9tY8OghRjLZpXdrohqWx7imE0NtgWvmMohFvWh+vxZdCBYfGFIfNIrhwqtg+pR6X
	lvp3l5uPyTdu/uQlI8fVvcXVWRMzQwOUQKN7Z2cnRCXe6PvliL75B2+n3lV2I3V/Of1fe9QQAJF
	qXdNz0jH+vSdLjUMgpLL+9GVFFI54a8CcZq4tvTbg4S9TB+b3HupC3ZSJFA5sz5fsCqsqtjt6Rc
	X4uH
X-Google-Smtp-Source: AGHT+IE3UsYQDVqDqz5fOJqR2a0LCCbXCtaGplsbj630vzm92X2koBxsyzguh0JSvTc/R+TUuaX3QA==
X-Received: by 2002:a05:6e02:214f:b0:3a7:e528:6ee6 with SMTP id e9e14a558f8ab-3ce3a888287mr91494995ab.13.1736552155091;
        Fri, 10 Jan 2025 15:35:55 -0800 (PST)
Received: from [100.64.0.1] ([165.188.116.9])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b62933bsm1148138173.76.2025.01.10.15.35.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 15:35:54 -0800 (PST)
Message-ID: <fca2a328-f2c4-4df3-9086-06b8a12b8da4@sifive.com>
Date: Fri, 10 Jan 2025 17:35:53 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] riscv: request misaligned exception delegation from
 SBI
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
 <20250106154847.1100344-3-cleger@rivosinc.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
In-Reply-To: <20250106154847.1100344-3-cleger@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Clément,

On 2025-01-06 9:48 AM, Clément Léger wrote:
> Now that the kernel can handle misaligned accesses in S-mode, request
> misaligned access exception delegation from SBI. This uses the FWFT SBI
> extension defined in SBI version 3.0.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/asm/cpufeature.h        |  1 +
>  arch/riscv/kernel/traps_misaligned.c       | 59 ++++++++++++++++++++++
>  arch/riscv/kernel/unaligned_access_speed.c |  2 +
>  3 files changed, 62 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
> index 4bd054c54c21..cd406fe37df8 100644
> --- a/arch/riscv/include/asm/cpufeature.h
> +++ b/arch/riscv/include/asm/cpufeature.h
> @@ -62,6 +62,7 @@ void __init riscv_user_isa_enable(void);
>  	_RISCV_ISA_EXT_DATA(_name, _id, _sub_exts, ARRAY_SIZE(_sub_exts), _validate)
>  
>  bool check_unaligned_access_emulated_all_cpus(void);
> +void unaligned_access_init(void);
>  #if defined(CONFIG_RISCV_SCALAR_MISALIGNED)
>  void check_unaligned_access_emulated(struct work_struct *work __always_unused);
>  void unaligned_emulation_finish(void);
> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
> index 7cc108aed74e..4aca600527e9 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -16,6 +16,7 @@
>  #include <asm/entry-common.h>
>  #include <asm/hwprobe.h>
>  #include <asm/cpufeature.h>
> +#include <asm/sbi.h>
>  #include <asm/vector.h>
>  
>  #define INSN_MATCH_LB			0x3
> @@ -689,3 +690,61 @@ bool check_unaligned_access_emulated_all_cpus(void)
>  	return false;
>  }
>  #endif
> +
> +#ifdef CONFIG_RISCV_SBI
> +
> +struct misaligned_deleg_req {
> +	bool enable;
> +	int error;
> +};
> +
> +static void
> +cpu_unaligned_sbi_request_delegation(void *arg)
> +{
> +	struct misaligned_deleg_req *req = arg;
> +	struct sbiret ret;
> +
> +	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
> +			SBI_FWFT_MISALIGNED_EXC_DELEG, req->enable, 0, 0, 0, 0);
> +	if (ret.error)
> +		req->error = 1;
> +}
> +
> +static void unaligned_sbi_request_delegation(void)
> +{
> +	struct misaligned_deleg_req req = {true, 0};
> +
> +	on_each_cpu(cpu_unaligned_sbi_request_delegation, &req, 1);
> +	if (!req.error) {
> +		pr_info("SBI misaligned access exception delegation ok\n");
> +		/*
> +		 * Note that we don't have to take any specific action here, if
> +		 * the delegation is successful, then
> +		 * check_unaligned_access_emulated() will verify that indeed the
> +		 * platform traps on misaligned accesses.
> +		 */
> +		return;
> +	}
> +
> +	/*
> +	 * If at least delegation request failed on one hart, revert misaligned
> +	 * delegation for all harts, if we don't do that, we'll panic at
> +	 * misaligned delegation check time (see
> +	 * check_unaligned_access_emulated()).
> +	 */
> +	req.enable = false;
> +	req.error = 0;
> +	on_each_cpu(cpu_unaligned_sbi_request_delegation, &req, 1);
> +	if (req.error)
> +		panic("Failed to disable misaligned delegation for all CPUs\n");

This logic doesn't handle the case where the delegation request failed on every
CPU, so there's nothing to revert. This causes a panic in a KVM guest inside
qemu-softmmu (the host kernel detects MISALIGNED_SCALAR_FAST, so
unaligned_ctl_available() returns false, and all FWFT calls fail).

Regards,
Samuel

> +
> +}
> +
> +void unaligned_access_init(void)
> +{
> +	if (sbi_probe_extension(SBI_EXT_FWFT) > 0)
> +		unaligned_sbi_request_delegation();
> +}
> +#else
> +void unaligned_access_init(void) {}
> +#endif
> diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kernel/unaligned_access_speed.c
> index 91f189cf1611..1e3166100837 100644
> --- a/arch/riscv/kernel/unaligned_access_speed.c
> +++ b/arch/riscv/kernel/unaligned_access_speed.c
> @@ -403,6 +403,8 @@ static int check_unaligned_access_all_cpus(void)
>  {
>  	bool all_cpus_emulated, all_cpus_vec_unsupported;
>  
> +	unaligned_access_init();
> +
>  	all_cpus_emulated = check_unaligned_access_emulated_all_cpus();
>  	all_cpus_vec_unsupported = check_vector_unaligned_access_emulated_all_cpus();
>  



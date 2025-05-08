Return-Path: <kvm+bounces-45991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 364C6AB0644
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 01:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7423E4C535E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 23:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC9322B8D5;
	Thu,  8 May 2025 23:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qK6Zu79Q"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E3F1DD525
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 23:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746745287; cv=none; b=ZLnXGj/FkNxCbcdOc63TpocpZ6WTg6TFsT5Pxam/4Q2Ewhnxrb10NjRTWVyPX2kO3LTVr6QT/NrAMXN3+twlugXdd77MXgAkp/feTE5K/Hh4kXuAm2FQOfjVgXljYEWlOkPq/a9C//9CaeONVC6NO77qCcnXUqgfnk6SNEWWdgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746745287; c=relaxed/simple;
	bh=oEuSarxiPIA0IneriI2U0oIkS7qkQy2iN4xv7e9uIV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZ2+8uKrmokncxjVdjFbwtVvgdTWgAZmzOxbRr3pxw4/lgDiuGicsvthrkY4AnLpRBBIjzpcckf8RvXTf8eKBJ3+TBvAIRXRC6cB3trbLdU+qq1KNnWoY/GkxboAtrchLh932MVu5fplUYwliUuecqDtz0vlUztQ39eIgxDzU1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qK6Zu79Q; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <4032b00c-1194-45b1-b1e5-4e9237ed7948@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746745283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0podyQbI7EjhnM5+iaMAYRW3Emc7fSDLhAlACBiE+s0=;
	b=qK6Zu79QrmwiVhmb0SUwlF/AmfkzMu19qf+dkBevTT2rvx0rNBA3gTno6MqT2qWTf4fMVs
	gxD/PLt/EvSGIoMy129aGZ3w/Mkk5JRRS22r4+ABA1HHZbWa7Qf9RDrbOXY3uZqUb00KyB
	qWyz0v9qW0KNNtOBJ9/V3dY4gkoObkE=
Date: Thu, 8 May 2025 16:01:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 05/14] riscv: sbi: add SBI FWFT extension calls
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org
Cc: Samuel Holland <samuel.holland@sifive.com>,
 Andrew Jones <ajones@ventanamicro.com>, Deepak Gupta <debug@rivosinc.com>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
 <20250424173204.1948385-6-cleger@rivosinc.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250424173204.1948385-6-cleger@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 4/24/25 10:31 AM, ClÃ©ment LÃ©ger wrote:
> Add FWFT extension calls. This will be ratified in SBI V3.0 hence, it is
> provided as a separate commit that can be left out if needed.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   arch/riscv/kernel/sbi.c | 20 +++++++++++++++++++-
>   1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
> index d57e4dae7dac..070014ff35d4 100644
> --- a/arch/riscv/kernel/sbi.c
> +++ b/arch/riscv/kernel/sbi.c
> @@ -299,6 +299,8 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
>   	return 0;
>   }
>   
> +static bool sbi_fwft_supported;
> +

super nit: Can declare this along with struct fwft_set_req so that they 
are together ? You can move the sbi_fwft_set to below the struct 
fwft_set_req.

>   /**
>    * sbi_fwft_set() - Set a feature on the local hart
>    * @feature: The feature ID to be set
> @@ -309,7 +311,15 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
>    */
>   int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags)
>   {
> -	return -EOPNOTSUPP;
> +	struct sbiret ret;
> +
> +	if (!sbi_fwft_supported)
> +		return -EOPNOTSUPP;
> +
> +	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
> +			feature, value, flags, 0, 0, 0);
> +
> +	return sbi_err_map_linux_errno(ret.error);
>   }
>   
>   struct fwft_set_req {
> @@ -348,6 +358,9 @@ int sbi_fwft_set_cpumask(const cpumask_t *mask, u32 feature,
>   		.error = ATOMIC_INIT(0),
>   	};
>   
> +	if (!sbi_fwft_supported)
> +		return -EOPNOTSUPP;
> +
>   	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
>   		return -EINVAL;
>   
> @@ -679,6 +692,11 @@ void __init sbi_init(void)
>   			pr_info("SBI DBCN extension detected\n");
>   			sbi_debug_console_available = true;
>   		}
> +		if (sbi_spec_version >= sbi_mk_version(3, 0) &&
> +		    sbi_probe_extension(SBI_EXT_FWFT)) {
> +			pr_info("SBI FWFT extension detected\n");
> +			sbi_fwft_supported = true;
> +		}
>   	} else {
>   		__sbi_set_timer = __sbi_set_timer_v01;
>   		__sbi_send_ipi	= __sbi_send_ipi_v01;

Otherwise, LGTM.

Reviewed-by: Atish Patra <atishp@rivosinc.com>


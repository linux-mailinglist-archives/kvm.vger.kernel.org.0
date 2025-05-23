Return-Path: <kvm+bounces-47612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A7F4AC29DA
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 20:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BC0E9E01A1
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 18:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3544429ACD7;
	Fri, 23 May 2025 18:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="kx+jOfLF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1979299A80
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 18:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748025440; cv=none; b=vA+WgoIYu1JlMfGdaxZVsBRR6tfBQoDTCYbgCjqa6Q2Ml8oiajS/uGjGxtoa0s+ZzvuH/sRc2zWV7+6QSDNrytTsXlspm11HozP5t6+eQQUn2ce7JBu+lROFWgND9jyOAuxcA7AbBgaJgwpBMz0vmZcQbTrso/KBQu3+papmQ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748025440; c=relaxed/simple;
	bh=fBP8ebQ6vsk2kNEGZF28FbWUrY3UqYBKVgD7KsehzoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BV3tQm1NfCGWXg11gWYD5UrA2oxszxtN3oBXgVLFMOcm+MfDv72DxC0k/XyIKtEz67o4EP+t1QBo2ojitYkHA7DrM+UtNz/hyeYbGjVxQgN7W8TIm9lwzjKeUkyCZb0MmM2UGLV6vqe+dmReUz3chmkdZ2GtwthRTX7Z+wSaZUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=kx+jOfLF; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-742caef5896so262832b3a.3
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 11:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1748025437; x=1748630237; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+jN5GB4ngQwEolzoVEKYGux1P77VDkeV8jyjKjQj7pI=;
        b=kx+jOfLFtsQKMtUb47OqLL1G6Io3wm0pD7E2k7rrjbnweQg/NLyAIJyeEu/kyvMhBv
         UQ1hyQxVbMTH3wsGV+2Q+6nM7EDNJGEO+pJ9qNuNd+IGT+E0mANo8wBxsQINqAfnUKqb
         8j2/2v/rD0LLKsDfVorS7JYIypIIA2nuXcPKORQo3Hx5jic2lowqWYB/7eB9KUpHKm+T
         zo6U0kaN6mZ7SqNY+fYX1onRVfj7mqrHVQ/43xyGgRlZINPjp1wNXcEMhGHnSEjJt/+V
         NlkEn+Zqr8j76T1OfE/7WGXYY9+dPbFOz+/k9/YktBhvfeG3QjDvNsuKZLyp6CTcRNle
         hHMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748025437; x=1748630237;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+jN5GB4ngQwEolzoVEKYGux1P77VDkeV8jyjKjQj7pI=;
        b=nljPBVPLW4GEe9nVre7N/iOaeCb7qzCVxv92RM/GCbhbZfbmXGWf4zyZYPnPecTaiR
         H7MLQ1A5F05YnkHcdGiGjlFv5Fi4ii4kRR6tez8coILejHqt3F5vbtAE3YbuAIhN25Ja
         e3Q74Astn7lCP5meNPfYFuPu3zkqJUafzM2E1QMOIcfwCgy2MBHfShTqnHkZhnaHt7UD
         rMexKcDpwZAGzV6JBjwGuqeKwKE0kggaqfJ3gbDe5QA9nSZQo/ibwoaKd4poTfmS/3oJ
         jOxOTGJ/chbLPLWShwz8biTkpLhipPHIHBDIIjRLuaL1IA2XzTZ5LePEPhEmeKM4YcT4
         F5eQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIDwZX5qJS131RC/LUR1qAmP7IZPkEmMEHzqSMOcvGnkGzb9sDPpUhHpuDamzvt2BWnzk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO0f8RxYGQGwP3MrhspT0UlZ7SuzNS/VmzytV4JOP7dSAfBmo6
	DbHIp3GVUtrqfgJuXPmmqTBJtMcfBU9yUgyLm3l2e4gRr84tUCO6gHpTuAV0Ylfspfs=
X-Gm-Gg: ASbGncs1guS85qU7ngsSyPTibf0jiFP0ueD7NoFi+MuP6YOPcppyteoSi/YZTyrFvhe
	On77ihyyBTddtGF8N1WFdkMdtn0q94Ou0FNfizybIywKuYUvSK8yR8WV14oNzY7FEAlPps/b04c
	RavnrTcbW94qmm0Og8OWHoNmcuB/cDsyEV0Ju69hmKTa5rVzv6HKbuH+9OX/F2bYK37IKn8ZIy2
	FkHLmGEKa8L9eAR8XrexCnoUzY0gk7hQkwnD9EL0532JRdlY8+8dVEhj086poechzcjcn/L4b08
	IsHgqNt0cj1osWYrKPY5Rlniqy54jIKZFYR40874IK/Tct0=
X-Google-Smtp-Source: AGHT+IG8tomY7/3cAclRkVBgo4GdCG/oz04LT8S0Un+srTCw4pvpQpH3EIf/46AHjipa24+aocSy/g==
X-Received: by 2002:a17:902:fc44:b0:22c:35c5:e30e with SMTP id d9443c01a7336-23414f69078mr5977735ad.13.1748025437265;
        Fri, 23 May 2025 11:37:17 -0700 (PDT)
Received: from ghost ([2601:647:6700:64d0:bb2c:c7d9:9014:13ab])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9736esm127127745ad.149.2025.05.23.11.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 11:37:16 -0700 (PDT)
Date: Fri, 23 May 2025 11:37:14 -0700
From: Charlie Jenkins <charlie@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>
Subject: Re: [PATCH v8 07/14] riscv: misaligned: use on_each_cpu() for scalar
 misaligned access probing
Message-ID: <aDDAWmNlr_mzrdLm@ghost>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
 <20250523101932.1594077-8-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250523101932.1594077-8-cleger@rivosinc.com>

On Fri, May 23, 2025 at 12:19:24PM +0200, Clément Léger wrote:
> schedule_on_each_cpu() was used without any good reason while documented
> as very slow. This call was in the boot path, so better use
> on_each_cpu() for scalar misaligned checking. Vector misaligned check
> still needs to use schedule_on_each_cpu() since it requires irqs to be
> enabled but that's less of a problem since this code is ran in a kthread.
> Add a comment to explicit that.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>

> ---
>  arch/riscv/kernel/traps_misaligned.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
> index 592b1a28e897..34b4a4e9dfca 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -627,6 +627,10 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
>  {
>  	int cpu;
>  
> +	/*
> +	 * While being documented as very slow, schedule_on_each_cpu() is used since
> +	 * kernel_vector_begin() expects irqs to be enabled or it will panic()
> +	 */
>  	schedule_on_each_cpu(check_vector_unaligned_access_emulated);
>  
>  	for_each_online_cpu(cpu)
> @@ -647,7 +651,7 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
>  
>  static bool unaligned_ctl __read_mostly;
>  
> -static void check_unaligned_access_emulated(struct work_struct *work __always_unused)
> +static void check_unaligned_access_emulated(void *arg __always_unused)
>  {
>  	int cpu = smp_processor_id();
>  	long *mas_ptr = per_cpu_ptr(&misaligned_access_speed, cpu);
> @@ -688,7 +692,7 @@ bool __init check_unaligned_access_emulated_all_cpus(void)
>  	 * accesses emulated since tasks requesting such control can run on any
>  	 * CPU.
>  	 */
> -	schedule_on_each_cpu(check_unaligned_access_emulated);
> +	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
>  
>  	for_each_online_cpu(cpu)
>  		if (per_cpu(misaligned_access_speed, cpu)
> -- 
> 2.49.0
> 


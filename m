Return-Path: <kvm+bounces-6542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39CED836322
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 13:24:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EB441C229CA
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 12:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6A33CF71;
	Mon, 22 Jan 2024 12:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="NB8KyfIb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2B93B79D
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 12:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705926099; cv=none; b=uOMmW8hpoEKmrWswfT6w9SzlI8FL+1A50XW7K5QxKjh+OMs1I3/AzkiXtc+6v+qYHradf5GNE9hQ2zJF/yoGmyZapY9YZo6dcmJp2EmN4d6g15COo5xiKl4Hwd0GWQ6C6mmh5i1GZ4V9FxFt0e648HGUVJCbZmRqjOryhE0aty0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705926099; c=relaxed/simple;
	bh=vNrKTN+Psy0M2VFW5VqZf+0AB0x8oBNn3f2wlhE/7W8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sXNpAXX+M9GoltYDvWF4sjQas5NDL4R9vqmFHZKesbFjz78FGDDfPJOHGZux5CT+c/aPx7t3zCyFIPUGWm/L8FbF5yCBf+AbkF3CqJujKYapd3MoP4bJJSMRhV5qxchd4VTqE8GKCPTERHoUQIxh0Ot3vrW51YZbgiMJ6lYmLhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=NB8KyfIb; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-337d32cd9c1so2794208f8f.2
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 04:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1705926095; x=1706530895; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pNyn/qnqC01DO5aYO0gaP3LnuG+kGrelMJHPp637j+Q=;
        b=NB8KyfIbFNBVYQ1ufr3ciONyyzqZnvIv3ZeQMM709cDbP6zdSH4PN4XqLfchyAGs8u
         962FohRvql4G37TQ1wcv1IWqA1UPMsZOM53AM9XHPXhwxP0qsKIX0tF3JDpidGXe96to
         SiJ+TxzV/JykIbZiNn2fJsJiOBqQwttiPU/1rCExbi1N4Ggh3wy12MjvWZH9Thg7qk7I
         2NJdeNfxc+8O56Wf6sokLJmvXCm09OtQ6ThZuG1rV1BampBdDG5vcaMrgQ9IsKiMetRR
         XWhrnPBPM5qX3wdmbQ/2/pdxDePIAA10H8XLv7q+bvtuA/I0foyQ3uEydrfr7NUZm2UW
         pEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705926095; x=1706530895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNyn/qnqC01DO5aYO0gaP3LnuG+kGrelMJHPp637j+Q=;
        b=tDI/7wzaprwx0e452gokK9dwJnffvx32l4KUppmhP+G96bAUZlwrQ6xXxRZauyAOic
         qJZzZxk/fLr9y8JLh89+QuiFt+ThqIxLqvmxd4/Ag20W7wHYunEmptzyrEFx0LBiM9Mx
         Zkj62EKx3Jli1d+TmClTc7EJpdEqwpdLhq9cMTyf2Q1o8AMq56h3X/oj+1Sbfgm7lSW3
         r+rhOQPmYI7wCge82FC1xHTUn99mn4R//G+BRj3+IM+JspVNL6RgVh4Ikjv7M5tBMELu
         psLnHRVHgJVAy7RIhzpG2+YgBQcMl5CvsrH6rf4WmesLYKIJXUr9naj3cWzs8isT8XFc
         AoJg==
X-Gm-Message-State: AOJu0YwtFxCbA6olYpl3WFPLH/8imnpJF9PFzHqBu1ppbLM6X38hfjGk
	vrOrepYGwSfZHokfiOtbGQQisz+J0+82Ue1nKC1Isr0HW6kue89qHL3vvKLqiGs=
X-Google-Smtp-Source: AGHT+IGjstD5P6UroceP4UshiLynFM2AqV73RXt9NzLqzEsWwmxRvB3J0Fsa/nFM64CECZlIeo29pg==
X-Received: by 2002:a5d:44ce:0:b0:337:c538:6db with SMTP id z14-20020a5d44ce000000b00337c53806dbmr1979837wrr.2.1705926095352;
        Mon, 22 Jan 2024 04:21:35 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id bw12-20020a0560001f8c00b00337cef427f8sm11306084wrb.70.2024.01.22.04.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 04:21:34 -0800 (PST)
Date: Mon, 22 Jan 2024 13:21:33 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	wchen <waylingii@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Samuel Holland <samuel@sholland.org>, Jisheng Zhang <jszhang@kernel.org>, 
	Minda Chen <minda.chen@starfivetech.com>, Sean Christopherson <seanjc@google.com>, 
	Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, Vipin Sharma <vipinsh@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, Thomas Huth <thuth@redhat.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v5 02/12] KVM: arm64: selftests: Data type cleanup for
 arch_timer test
Message-ID: <20240122-0ddedacdeb64808477a7911d@orel>
References: <cover.1705916069.git.haibo1.xu@intel.com>
 <173c9b64c4c43cd585f6b177a7d434dcedc905fa.1705916069.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173c9b64c4c43cd585f6b177a7d434dcedc905fa.1705916069.git.haibo1.xu@intel.com>

On Mon, Jan 22, 2024 at 05:58:32PM +0800, Haibo Xu wrote:
> Change signed type to unsigned in test_args struct which
> only make sense for unsigned value.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/aarch64/arch_timer.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> index 274b8465b42a..3260fefcc1b3 100644
> --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> @@ -42,10 +42,10 @@
>  #define TIMER_TEST_MIGRATION_FREQ_MS	2
>  
>  struct test_args {
> -	int nr_vcpus;
> -	int nr_iter;
> -	int timer_period_ms;
> -	int migration_freq_ms;
> +	uint32_t nr_vcpus;
> +	uint32_t nr_iter;
> +	uint32_t timer_period_ms;
> +	uint32_t migration_freq_ms;
>  	struct kvm_arm_counter_offset offset;
>  };
>  
> @@ -57,7 +57,7 @@ static struct test_args test_args = {
>  	.offset = { .reserved = 1 },
>  };
>  
> -#define msecs_to_usecs(msec)		((msec) * 1000LL)
> +#define msecs_to_usecs(msec)		((msec) * 1000ULL)
>  
>  #define GICD_BASE_GPA			0x8000000ULL
>  #define GICR_BASE_GPA			0x80A0000ULL
> @@ -72,7 +72,7 @@ enum guest_stage {
>  
>  /* Shared variables between host and guest */
>  struct test_vcpu_shared_data {
> -	int nr_iter;
> +	uint32_t nr_iter;
>  	enum guest_stage guest_stage;
>  	uint64_t xcnt;
>  };
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


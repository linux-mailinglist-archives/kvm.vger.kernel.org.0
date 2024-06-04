Return-Path: <kvm+bounces-18725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 679C98FAA45
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C2A91F22790
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9009413DDA3;
	Tue,  4 Jun 2024 05:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="CBf5Io1O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B65F199BC
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 05:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717480457; cv=none; b=bOH1gkFgMYvy3MHZX6VKRVrSuXSVoV0Lfj/gcNLr3Mhml7eeKqpMDcXA6LuTr8PvV/54wmc2+mtqa6KKCrxuvA41P+EVfhutr1Bo1/iv0E1aFSn+DgIhE3WTTOJrgdCSIoECPgO1MRpNRk/bYHSDjYvTlslxEHx3jPa4dTzIVlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717480457; c=relaxed/simple;
	bh=v9Zgv8nkfaxkOkFGYe/TwSXUE8Wzb96dEh0iNm8PB/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHbn7rOOyw2F1mZzcABDX0a5IY8GFrwAFYCPmCnl2kAXcZ31EfofyUumyzClNc5VPGWCkhymvPToN9OHZIm0ndc9GscgR619TyMLmpUcj3a5TSJoF7G7byuEDZzxo4WhVYrKwpqvv9DtfDXkVkF9nsEy2DGv+m0qX1BbdJGAkUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=CBf5Io1O; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-421392b8156so6627545e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 22:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1717480450; x=1718085250; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PxA0a9OaTWEd+DB03KWEhTOxvmFwfmuNhF5UOcsXrno=;
        b=CBf5Io1Oc+EkSwkw2F0HYQwtvG6wpdmMPbM2bPfhRgVSb7sgOuUE3KeEwWi2KoXxwV
         lJi2fsH1stemnJufpRQmagyF74g42OXknHz8sURaw/dAOuPc4HPizClYS/K7AXOyK+7V
         wUex1iajrUpSxEKu3Cjs3ob7QoN3UOX22wPXotL1KoQv6H4R5r3Gw3ZBU7jLy6JfoYtT
         xzMDOc990fxvkP6uREiYdd3ernVRCoNRzWeCAO0ntri+qv/HNV6fUvWEg36lcVyMZ9jh
         2EhciHKA32bU67VMI186evml2k+yKG9GzB2evKytT8mrZXEhE9KV/etzOE6NGpW18NfQ
         DSNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717480450; x=1718085250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxA0a9OaTWEd+DB03KWEhTOxvmFwfmuNhF5UOcsXrno=;
        b=nPXLxFMEDhuoIFP+T7DMGBPZm6CnSojP+vAX5VKYiZSMKZ6Gtz6c0IffSPLbWmu3wg
         9N5CPPrudloKyp9X4zlmL4BmmxuQ8yI8v6rPvOwuhtrpuqWesfPDqHUT+7COprIG7uYI
         C+YR+FlUYgllkGWnzP6HUMb4C8OvhpXo79mB3BC5RMz4kOIN6ZY6BP8gIADKUOnn1rZ0
         k1q13bfpoueNecAvhN0aw3r245MbE0wRuPSaxlo+TtQZe44/R6yxs3nqzPZ9TqLtH/Lw
         vv2K2IjczGlELv3yfXxim9yVRGOBIzFTsAURnXuuqL53+qi5E8ZyVUSjgDwYdiIhcTA6
         n9YA==
X-Gm-Message-State: AOJu0YwaHp5iPV5m2xq0pNHTF6WxeEUtz9cwce9EKsjXB+eOKAakCW8g
	q9DRyqxsg3Bez5incfS/cz1fbBjDa6cVg9LUSKaY0ZJN5bLPIq8zSogHQ2NJUvPTz66qqfQE4mP
	0jyM=
X-Google-Smtp-Source: AGHT+IEXn7MFRfI5diPXzQxtUHrhv+UuANbqBBvKCQrWWuzX+BCLuLiLwWVudjO5zjZliNRE8R5Yzg==
X-Received: by 2002:a05:600c:190b:b0:417:fbc2:caf8 with SMTP id 5b1f17b1804b1-4212e0768cemr79119775e9.23.1717480450477;
        Mon, 03 Jun 2024 22:54:10 -0700 (PDT)
Received: from localhost (cst2-173-81.cust.vodafone.cz. [31.30.173.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421385b1c1csm93343885e9.39.2024.06.03.22.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 22:54:10 -0700 (PDT)
Date: Tue, 4 Jun 2024 07:54:09 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com, seanjc@google.com, anup@brainfault.org, 
	atishp@atishpatra.org
Subject: Re: [PATCH] KVM: selftests: Fix RISC-V compilation
Message-ID: <20240604-e11569f6e3aa7675774628ed@orel>
References: <20240603122045.323064-2-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603122045.323064-2-ajones@ventanamicro.com>

On Mon, Jun 03, 2024 at 02:20:46PM GMT, Andrew Jones wrote:
> Due to commit 2b7deea3ec7c ("Revert "kvm: selftests: move base
> kvm_util.h declarations to kvm_util_base.h"") kvm selftests now
> requires implicitly including ucall_common.h when needed. The commit
           ^ of course I meant 'explicitly' here. Gota love brain inversions
and not reviewing commit messages closely until after posting... Should I
post a v2 or just promise to buy a beer in exchange for a fixup-on-merge?

Thanks,
drew

> added the directives everywhere they were needed at the time, but, by
> merge time, new places had been merged for RISC-V. Add those now to
> fix RISC-V's compilation.
> 
> Fixes: dee7ea42a1eb ("Merge tag 'kvm-x86-selftests_utils-6.10' of https://github.com/kvm-x86/linux into HEAD")
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  tools/testing/selftests/kvm/lib/riscv/ucall.c    | 1 +
>  tools/testing/selftests/kvm/riscv/ebreak_test.c  | 1 +
>  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> index 14ee17151a59..b5035c63d516 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> @@ -9,6 +9,7 @@
>  
>  #include "kvm_util.h"
>  #include "processor.h"
> +#include "sbi.h"
>  
>  void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>  {
> diff --git a/tools/testing/selftests/kvm/riscv/ebreak_test.c b/tools/testing/selftests/kvm/riscv/ebreak_test.c
> index 823c132069b4..0e0712854953 100644
> --- a/tools/testing/selftests/kvm/riscv/ebreak_test.c
> +++ b/tools/testing/selftests/kvm/riscv/ebreak_test.c
> @@ -6,6 +6,7 @@
>   *
>   */
>  #include "kvm_util.h"
> +#include "ucall_common.h"
>  
>  #define LABEL_ADDRESS(v) ((uint64_t)&(v))
>  
> diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> index 69bb94e6b227..f299cbfd23ca 100644
> --- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> +++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> @@ -15,6 +15,7 @@
>  #include "processor.h"
>  #include "sbi.h"
>  #include "arch_timer.h"
> +#include "ucall_common.h"
>  
>  /* Maximum counters(firmware + hardware) */
>  #define RISCV_MAX_PMU_COUNTERS 64
> -- 
> 2.45.1
> 


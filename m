Return-Path: <kvm+bounces-4344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D79F811402
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 15:03:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09BFD282762
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 14:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251552E642;
	Wed, 13 Dec 2023 14:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="cqna6UjT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565BB11B
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 06:02:54 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-40c41df5577so38148525e9.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 06:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1702476173; x=1703080973; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8CNgTMGbobolB1r9w8VNb165BlBAplPuvdaxYrWog0=;
        b=cqna6UjTYgeJ8FSvk+RW1RP2hFvImNPYN83jAtbXOkXJaaksS/kR0sg96ap1082BKz
         p38ZcoACnlhalY9oCt9dN7rZhZa8OLQl0WdCTDIjA2myxB9XkFsY5tvdBeNIsvNf929d
         2bHGlm4E8SZWSXGjCd2Vf9vCNHc2X5LXyTgmCN20k7IQ9ihxzMwZBTsIf1IF8Cu42b3w
         QMvYW5BRq+cDMcsF+JLCeeFnBGZeyeYUMgkRfjtstVMlvMpnBK8ncqFkw9e8o5WI7bas
         dB3CLtU/QVU64DFhNif9pTGGCu885Ln8G8pOFNuIr5ueW3o+4frxFeVFfufN+vrVh8hX
         xlhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702476173; x=1703080973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8CNgTMGbobolB1r9w8VNb165BlBAplPuvdaxYrWog0=;
        b=LWB8f3PIV6Lz18XaJFs0gdkSPxZNWExrjreShTZ2OSCwVKI0t9rdUjHMq8k96cZY48
         uEkIKYiCj37ut5NFHX5oMw/z5SQ3mobvzH5CXv/ZcE7q3XUZ8Fac1IVR1muj3ar/5sh9
         GxUv5yB5lUgo4/ApLEcFllE0NTth+UfVEs5qzrHga1EI9xdCQjjSy7bNaUEn2HrK0No2
         yTh0WzJtDY3eDi7/kfL+Vx4DWXuUN1bcfE6aUu5YYuA7IqMlA2ZLIzXVW202KeWetL23
         OR9rDoV5ydV8+lDVXu7ZnxKWP7gn9ctdx4yHPytv1mQuU2EsVfpuKjJZBuDZ7D/hQueS
         bKjA==
X-Gm-Message-State: AOJu0YwMtyW7Avn6CfnpaPLXqSiUEGzvJg7hMXYg8WjhlxYSPlD4k/sD
	8xsqVxTOlq9LANzTUzgO/tC/Lg==
X-Google-Smtp-Source: AGHT+IHHe1VYvYeZf/3ceduRCoWvVbIdH20JSg3fNMXtxhw7fHkTGIiZ2b27mL7MboW3CuD0I846lA==
X-Received: by 2002:a05:600c:2483:b0:40c:3314:5be0 with SMTP id 3-20020a05600c248300b0040c33145be0mr1879277wms.295.1702476172702;
        Wed, 13 Dec 2023 06:02:52 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id fm14-20020a05600c0c0e00b00407b93d8085sm22968185wmb.27.2023.12.13.06.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 06:02:52 -0800 (PST)
Date: Wed, 13 Dec 2023 15:02:51 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Jisheng Zhang <jszhang@kernel.org>, 
	Samuel Holland <samuel@sholland.org>, Minda Chen <minda.chen@starfivetech.com>, 
	Sean Christopherson <seanjc@google.com>, Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, 
	Vipin Sharma <vipinsh@google.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
	Thomas Huth <thuth@redhat.com>, Aaron Lewis <aaronlewis@google.com>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v4 05/11] tools: riscv: Add header file vdso/processor.h
Message-ID: <20231213-9d5ad03bed3056007c6e714d@orel>
References: <cover.1702371136.git.haibo1.xu@intel.com>
 <7b633cc441f5133608597463301fef122f5174d3.1702371136.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b633cc441f5133608597463301fef122f5174d3.1702371136.git.haibo1.xu@intel.com>

On Tue, Dec 12, 2023 at 05:31:14PM +0800, Haibo Xu wrote:
> Borrow the cpu_relax() definitions from kernel's
> arch/riscv/include/asm/vdso/processor.h to tools/ for riscv.
> 
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/arch/riscv/include/asm/vdso/processor.h | 32 +++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 tools/arch/riscv/include/asm/vdso/processor.h
> 
> diff --git a/tools/arch/riscv/include/asm/vdso/processor.h b/tools/arch/riscv/include/asm/vdso/processor.h
> new file mode 100644
> index 000000000000..662aca039848
> --- /dev/null
> +++ b/tools/arch/riscv/include/asm/vdso/processor.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __ASM_VDSO_PROCESSOR_H
> +#define __ASM_VDSO_PROCESSOR_H
> +
> +#ifndef __ASSEMBLY__
> +
> +#include <asm-generic/barrier.h>
> +
> +static inline void cpu_relax(void)
> +{
> +#ifdef __riscv_muldiv
> +	int dummy;
> +	/* In lieu of a halt instruction, induce a long-latency stall. */
> +	__asm__ __volatile__ ("div %0, %0, zero" : "=r" (dummy));
> +#endif
> +
> +#ifdef CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE
> +	/*
> +	 * Reduce instruction retirement.
> +	 * This assumes the PC changes.
> +	 */
> +	__asm__ __volatile__ ("pause");
> +#else
> +	/* Encoding of the pause instruction */
> +	__asm__ __volatile__ (".4byte 0x100000F");
> +#endif
> +	barrier();
> +}
> +
> +#endif /* __ASSEMBLY__ */
> +
> +#endif /* __ASM_VDSO_PROCESSOR_H */
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


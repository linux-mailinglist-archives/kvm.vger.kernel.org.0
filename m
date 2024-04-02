Return-Path: <kvm+bounces-13371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB26B89565B
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 16:12:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EED81F23CB9
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 14:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7274F1292D3;
	Tue,  2 Apr 2024 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="du+Ob9F4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCAA86256
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712067134; cv=none; b=aelr2tTTW7tE1JSLoIgcZKLPjLmhUnJfk77JHyHdJyh+/mcBsLKSl3eiFioBgZ+3imYdynMyM3kndKmf0TKyZChE0uslXq9EduuHCaaIOzRjzNqpeV8DFK76AWSVIunojDdYAQuCa958Bp7/1vcWAbLV8+MfWKTdv7qfOJ/DpF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712067134; c=relaxed/simple;
	bh=sqtzLdkkHF7eoc3wt3sssV414hUqto11OAy3YqMHUWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJrtukAUjyl3sr/pOwtFaXfKnwgFlXOMH/DMZVOaBEgm+P69fKKCb4cmleniI9xNR8w+83GDii2Gs6xmaZNCCB9K17o7nSvXDGeu1FfdfuzmpCOoZDnLq18EnvrzqMC7PwRGYIzhcjIbl46qgyjqxefBrVucWIdYuTEyslgXxcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=du+Ob9F4; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d718ee7344so52075011fa.2
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 07:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712067131; x=1712671931; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/0cQjXn5RxGYF1hs4ZqgtS6/DW8noiaC0SrX/L7JoeE=;
        b=du+Ob9F4+riGMx2GBx/d6ZxADfOIBIsApc4oY8aXiJX+aS340x+hD4YD4VRP0d1S9F
         oxkVlm4TZdrOuuuGSzrPS/Yn+JTJaa0RnHxq6oy8lovlqHWxfx5NzW5rt+ZpQd8Qij0k
         NxsV8jM/EPPjEZARtXwi/fGL7UD7kFK5WFX//kcvMguY+upa5dWl+TQPpxDKcAkqN6Sy
         2xswLWN/90joOHUzfHXQP/NR1LC1WdCC0atbfIAUT7LUPcRyGwZkxWyK/iM0AT0gXNVk
         x3Uu2AIEIxP33e1S4nIToQoiAdJGdyagDVKDbNOxFelUAB78RaScsTqnBOK0OXozAIKR
         FX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712067131; x=1712671931;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0cQjXn5RxGYF1hs4ZqgtS6/DW8noiaC0SrX/L7JoeE=;
        b=hys97VaehIcN2H8CkkGQZNyBBBBb8NwmbtqrKUJ1wUg7GmkCIWBFbrMd0ylniaRkca
         P8aEvSK0WCOGHq81VyxvFy41NaQYz9bPIK4qOe14zOP+a9RPzmPPPJpqi993gObbq0eg
         E6GbXFO8bZMfMCx0XBIrMe0sUG0ORDSZ/AmJlZ9C7122rHkCZ6EDI6FUYYco4M7Lwp8U
         W/E9gY2X5OVCqs2xbT6BWHlD83TdzMfPJBuUhees3ZUqZO4m7AxoPosA0Bt9382z3YFr
         hZ1bKGuCD09fPKiwE2nuDZuzpmPsQdj+jDnvG8U8Bwlm2xvPoAYXvsk0vS3qrDJJkB/1
         ES0g==
X-Forwarded-Encrypted: i=1; AJvYcCVbbSmlGnOR/8sN0I7egcwtlayZFc8zixHQwI7TOWOUViuzkD5phkAbEVJAAAyXgrEz9rEvXhIP09R8g7ozIwWC6SI2
X-Gm-Message-State: AOJu0YwnwleEm2gRqEdiuj9ggrgK8z6yaODKQ9BXdhpZhLhgU309kpxk
	CGXVpiLhk3mfiMyVxi5j8nJp8ej+TZ1X9lFIMYSTGai62IHFRe0rcGomYn7feIk=
X-Google-Smtp-Source: AGHT+IE6N5GbqAreIPZgVb2waHGGo5ub3tGfpFdJfv9DhQRFznhz1kQgSzFrTE9IPNvatlBuKLWx+w==
X-Received: by 2002:a2e:9602:0:b0:2d4:2bc5:38dc with SMTP id v2-20020a2e9602000000b002d42bc538dcmr7404927ljh.30.1712067129349;
        Tue, 02 Apr 2024 07:12:09 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id p14-20020a05600c1d8e00b004156ea0faa0sm3322302wms.4.2024.04.02.07.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 07:12:08 -0700 (PDT)
Date: Tue, 2 Apr 2024 16:12:02 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] KVM: riscv: selftests: Add SBI base extension test
Message-ID: <20240402-7bd2b9ed00094befa6927b60@orel>
References: <20240401082019.2318193-1-haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401082019.2318193-1-haibo1.xu@intel.com>

On Mon, Apr 01, 2024 at 04:20:18PM +0800, Haibo Xu wrote:
> This is the first patch to enable the base extension selftest
> for the SBI implementation in KVM. Test for other extensions
> will be added later.

I'm not sure we want SBI tests in KVM selftests since we already
plan to add them to kvm-unit-tests, where they can be used to
test both KVM's SBI implementation and M-mode firmware implementations.
If we also have them here, then we'll end up duplicating that effort.

I do like the approach of only checking for an error, rather than
also for a value, for these ID getters. In kvm-unit-tests we're
currently requiring that the expected value be passed in, otherwise
the whole test is skipped. We could fallback to only checking for
an error instead, as is done here.

Thanks,
drew

> 
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/include/riscv/processor.h   |  8 +-
>  tools/testing/selftests/kvm/riscv/sbi_test.c  | 95 +++++++++++++++++++
>  3 files changed, 103 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/riscv/sbi_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 741c7dc16afc..a6acbbcad757 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -189,6 +189,7 @@ TEST_GEN_PROGS_s390x += rseq_test
>  TEST_GEN_PROGS_s390x += set_memory_region_test
>  TEST_GEN_PROGS_s390x += kvm_binary_stats_test
>  
> +TEST_GEN_PROGS_riscv += riscv/sbi_test
>  TEST_GEN_PROGS_riscv += arch_timer
>  TEST_GEN_PROGS_riscv += demand_paging_test
>  TEST_GEN_PROGS_riscv += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
> index ce473fe251dd..df530ac751c4 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -178,7 +178,13 @@ enum sbi_ext_id {
>  };
>  
>  enum sbi_ext_base_fid {
> -	SBI_EXT_BASE_PROBE_EXT = 3,
> +	SBI_EXT_BASE_GET_SPEC_VERSION = 0,
> +	SBI_EXT_BASE_GET_IMP_ID,
> +	SBI_EXT_BASE_GET_IMP_VERSION,
> +	SBI_EXT_BASE_PROBE_EXT,
> +	SBI_EXT_BASE_GET_MVENDORID,
> +	SBI_EXT_BASE_GET_MARCHID,
> +	SBI_EXT_BASE_GET_MIMPID,
>  };
>  
>  struct sbiret {
> diff --git a/tools/testing/selftests/kvm/riscv/sbi_test.c b/tools/testing/selftests/kvm/riscv/sbi_test.c
> new file mode 100644
> index 000000000000..b9378546e3b6
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/riscv/sbi_test.c
> @@ -0,0 +1,95 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * sbi_test - SBI API test for KVM's SBI implementation.
> + *
> + * Copyright (c) 2024 Intel Corporation
> + *
> + * Test cover the following SBI extentions:
> + *  - Base: All functions in this extension should be supported
> + */
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +
> +/*
> + * Test that all functions in the base extension must be supported
> + */
> +static void base_ext_guest_code(void)
> +{
> +	struct sbiret ret;
> +
> +	/*
> +	 * Since the base extension was introduced in SBI Spec v0.2,
> +	 * assert if the implemented SBI version is below 0.2.
> +	 */
> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0,
> +			0, 0, 0, 0, 0);
> +	__GUEST_ASSERT(!ret.error && ret.value >= 2, "Get Spec Version Error: ret.error=%ld, "
> +			"ret.value=%ld\n", ret.error, ret.value);
> +
> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_ID, 0,
> +			0, 0, 0, 0, 0);
> +	__GUEST_ASSERT(!ret.error && ret.value == 3, "Get Imp ID Error: ret.error=%ld, "
> +			"ret.value=%ld\n",
> +			ret.error, ret.value);
> +
> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0,
> +			0, 0, 0, 0, 0);
> +	__GUEST_ASSERT(!ret.error, "Get Imp Version Error: ret.error=%ld\n", ret.error);
> +
> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, SBI_EXT_BASE,
> +			0, 0, 0, 0, 0);
> +	__GUEST_ASSERT(!ret.error && ret.value == 1, "Probe ext Error: ret.error=%ld, "
> +			"ret.value=%ld\n",
> +			ret.error, ret.value);
> +
> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_MVENDORID, 0,
> +			0, 0, 0, 0, 0);
> +	__GUEST_ASSERT(!ret.error, "Get Machine Vendor ID Error: ret.error=%ld\n", ret.error);
> +
> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_MARCHID, 0,
> +			0, 0, 0, 0, 0);
> +	__GUEST_ASSERT(!ret.error, "Get Machine Arch ID Error: ret.error=%ld\n", ret.error);
> +
> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_MIMPID, 0,
> +			0, 0, 0, 0, 0);
> +	__GUEST_ASSERT(!ret.error, "Get Machine Imp ID Error: ret.error=%ld\n", ret.error);
> +
> +	GUEST_DONE();
> +}
> +
> +static void sbi_base_ext_test(void)
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	struct ucall uc;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, base_ext_guest_code);
> +	while (1) {
> +		vcpu_run(vcpu);
> +		TEST_ASSERT(vcpu->run->exit_reason == UCALL_EXIT_REASON,
> +			    "Unexpected exit reason: %u (%s),",
> +			    vcpu->run->exit_reason, exit_reason_str(vcpu->run->exit_reason));
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_DONE:
> +			goto done;
> +		case UCALL_ABORT:
> +			fprintf(stderr, "Guest assert failed!\n");
> +			REPORT_GUEST_ASSERT(uc);
> +		default:
> +			TEST_FAIL("Unexpected ucall %lu", uc.cmd);
> +		}
> +	}
> +
> +done:
> +	kvm_vm_free(vm);
> +}
> +
> +int main(void)
> +{
> +	sbi_base_ext_test();
> +
> +	return 0;
> +}
> -- 
> 2.34.1
> 


Return-Path: <kvm+bounces-13379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C41D089584D
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 17:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E77691C21E34
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 15:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2AE0131751;
	Tue,  2 Apr 2024 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VJirmWPQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F0784FCD
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 15:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712072172; cv=none; b=Y4hmQ3Jt/tqT2rOSflwAqfabA8yqE1ejFdgdzSbCyoAYA5+SEQnqo47SPCOJBEIwypsCqzZuZe6CxAcp/XJbzzmYECo1NWtmN67QfTDyeZev8N3B6XzHLHe6nhuSO231nO4s/nOKI4u5m/ewYITHMazaBRFCJZthsPIpVnvkAFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712072172; c=relaxed/simple;
	bh=UkkNbQbiFw9fFSRfnrXQw3fbov6y6DqVNZrec2JrMwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtUtuS7yIK3rQmVHM8F5ofHqwMJP2OUe/7unvp/+BWVWWc8cR9ZKzvc0z7xtnslUrZevWtqgHbt1zigAzWUVZhluE/TTC+B9q9/oyrbkYnR8jkpYTsBXtS4mclWyBihKhNqGSd6EQRd2R4f2/dxDRe15QoHAWq3mQK55kJ8PlVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=VJirmWPQ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4161ea9bfd8so2533485e9.1
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 08:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712072168; x=1712676968; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6IuoyqYyOtcjZh+PO5CRbupI6pUO5tv9VaAqh+BF9js=;
        b=VJirmWPQ8/n94pz0PUBFyoUE53BBQWfe1J5e8Rcg4Coiz88Y9i7Vlt4VBUn6Qhg18N
         0ZsE3mz1x82TRKeXzPaN3Tj5RcZ93iF1C9yV4QR1jMRSkQsWazDIUrHVDMTajJMkpcNt
         DA2ntiPbmCBBE72d45y5mv/79sRQrNf3v/+fDIFlVRSf3MB4jnGLahAE2u4Iv7RTwsBQ
         T9crurMVDAQbcVtNah6eag8MG8+0LQIQ0vFh7zd25u1SN5ImMi7KEuW50a54sSUkFPVy
         DTygc2eq/1gt7mQpdReE2nwDQZ13Qw0Svjpl6XShUmlWWXTyGNnDzzujr+7AKHRjYaD9
         dCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712072168; x=1712676968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IuoyqYyOtcjZh+PO5CRbupI6pUO5tv9VaAqh+BF9js=;
        b=uiJTerGBpxs15ScmMqATn+kocs2e8w1i8G1YJ9IU8VXKpRabuDG+UbcO1hGqg21G3T
         Ql7jGSIizs8tKEBCOyanJ4o2gfKNVsOcecnFHBr/9YRo9mfXFvwq8+HscNQJHe3JcwUk
         Lacfi+a5hcrdoJHJu1RzFcEsTOW3WAya/sa6NywGf3zgxMSOmqnYTd/+rVDDTQ8FRFKL
         X+MGEW9OovQOwjhOSy8XuKWrIoWu65z/wndiHkxeFV/g5Su9Hze6aQR49+X9i6BKh4Da
         VQ5knOorUDKbb+nh9i3cH5q01Y2HshJM7c1uUYYsFVD5GFNYv7hUpvkH8izhTrIXudkZ
         yDYA==
X-Gm-Message-State: AOJu0Yxr3MQFvSeQxiNyj9dPJooZNYii2+msHhLrYoC5JKF5STOty8k0
	ryp4ZZrc77qnB/fDpZyREqYGygu4TcQ1i6I2HblxcO1LYhcHFbTyguCBC11K0DI=
X-Google-Smtp-Source: AGHT+IE+edo7D/YooMNpXXL2C4jJOLy9TTXmYpO8gXppwdD+GfpEMOsy5fzhCSMd4E+4OgPBJbw1Ag==
X-Received: by 2002:a05:600c:4fd3:b0:414:860:bdc9 with SMTP id o19-20020a05600c4fd300b004140860bdc9mr124505wmq.33.1712072167826;
        Tue, 02 Apr 2024 08:36:07 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id z2-20020a05600c0a0200b00415515263b4sm14241365wmp.7.2024.04.02.08.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 08:36:07 -0700 (PDT)
Date: Tue, 2 Apr 2024 17:36:06 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	anup@brainfault.org, atishp@atishpatra.org, pbonzini@redhat.com, shuah@kernel.org, 
	dbarboza@ventanamicro.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, haibo1.xu@intel.com, duchao713@qq.com
Subject: Re: [PATCH v4 3/3] RISC-V: KVM: selftests: Add ebreak test support
Message-ID: <20240402-d3a3ebd7da7998f4928f47ba@orel>
References: <20240402062628.5425-1-duchao@eswincomputing.com>
 <20240402062628.5425-4-duchao@eswincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402062628.5425-4-duchao@eswincomputing.com>

On Tue, Apr 02, 2024 at 06:26:28AM +0000, Chao Du wrote:
> Initial support for RISC-V KVM ebreak test. Check the exit reason and
> the PC when guest debug is enabled. Also to make sure the guest could
> handle the ebreak exception without exiting to the VMM when guest debug
> is not enabled.
> 
> Signed-off-by: Chao Du <duchao@eswincomputing.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../testing/selftests/kvm/riscv/ebreak_test.c | 82 +++++++++++++++++++
>  2 files changed, 83 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/riscv/ebreak_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 741c7dc16afc..7f4430242c9e 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -189,6 +189,7 @@ TEST_GEN_PROGS_s390x += rseq_test
>  TEST_GEN_PROGS_s390x += set_memory_region_test
>  TEST_GEN_PROGS_s390x += kvm_binary_stats_test
>  
> +TEST_GEN_PROGS_riscv += riscv/ebreak_test
>  TEST_GEN_PROGS_riscv += arch_timer
>  TEST_GEN_PROGS_riscv += demand_paging_test
>  TEST_GEN_PROGS_riscv += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/riscv/ebreak_test.c b/tools/testing/selftests/kvm/riscv/ebreak_test.c
> new file mode 100644
> index 000000000000..823c132069b4
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/riscv/ebreak_test.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * RISC-V KVM ebreak test.
> + *
> + * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
> + *
> + */
> +#include "kvm_util.h"
> +
> +#define LABEL_ADDRESS(v) ((uint64_t)&(v))
> +
> +extern unsigned char sw_bp_1, sw_bp_2;
> +static uint64_t sw_bp_addr;
> +
> +static void guest_code(void)
> +{
> +	asm volatile(
> +		".option push\n"
> +		".option norvc\n"
> +		"sw_bp_1: ebreak\n"
> +		"sw_bp_2: ebreak\n"
> +		".option pop\n"
> +	);
> +	GUEST_ASSERT_EQ(READ_ONCE(sw_bp_addr), LABEL_ADDRESS(sw_bp_2));
> +
> +	GUEST_DONE();
> +}
> +
> +static void guest_breakpoint_handler(struct ex_regs *regs)
> +{
> +	WRITE_ONCE(sw_bp_addr, regs->epc);
> +	regs->epc += 4;
> +}
> +
> +int main(void)
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	uint64_t pc;
> +	struct kvm_guest_debug debug = {
> +		.control = KVM_GUESTDBG_ENABLE,
> +	};
> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SET_GUEST_DEBUG));
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	vm_init_vector_tables(vm);
> +	vcpu_init_vector_tables(vcpu);
> +	vm_install_exception_handler(vm, EXC_BREAKPOINT,
> +					guest_breakpoint_handler);
> +
> +	/*
> +	 * Enable the guest debug.
> +	 * ebreak should exit to the VMM with KVM_EXIT_DEBUG reason.
> +	 */
> +	vcpu_guest_debug_set(vcpu, &debug);
> +	vcpu_run(vcpu);
> +
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
> +
> +	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc), &pc);
> +	TEST_ASSERT_EQ(pc, LABEL_ADDRESS(sw_bp_1));
> +
> +	/* skip sw_bp_1 */
> +	vcpu_set_reg(vcpu, RISCV_CORE_REG(regs.pc), pc + 4);
> +
> +	/*
> +	 * Disable all debug controls.
> +	 * Guest should handle the ebreak without exiting to the VMM.
> +	 */
> +	memset(&debug, 0, sizeof(debug));
> +	vcpu_guest_debug_set(vcpu, &debug);
> +
> +	vcpu_run(vcpu);
> +
> +	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
> +
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


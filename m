Return-Path: <kvm+bounces-10608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D6E86DE25
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCA8A283DC7
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 09:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653DB6A8A5;
	Fri,  1 Mar 2024 09:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="iVcZvUNx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFECA6A8A3
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 09:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709285098; cv=none; b=ZvcDP8Q4VU8xwPKXtLlZNeD4CBxhe14FGz/jaJM12iIGB7NCgib2+6XBlSLVFLusc004uXRXNhRnzi728oaY9xk7NWqzA3KicbRK5/D/0qmRxDIJGfAvR67Dh3TMl8QKJtt6SSDy4Ac9nh0DwjrX3zsdI3vB+uvNE1diZGj8uL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709285098; c=relaxed/simple;
	bh=lez8nmKTDIjPyg5w8gVS07UWqBp2Gn9gz2f/Vp+V2q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGr/i7xDb35PweHMUSg7T7jiCZ6oqGZNOUS7pK2W7jcJiZQ6QVH0PJMvF+OPr+qR/Hj/sy+O1SOGzHiVJ+8LH9koEDE9qynQsn5ufuUWgpo+BuVJwG7deSc1TWekyWpY/s4vZ2p6BEOe36Qc/oI8YlHiFlSRkXtuve4p2qgMo5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=iVcZvUNx; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-412c1dea53cso9180785e9.1
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 01:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709285095; x=1709889895; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3+vNi0sKNukhWDt8NhoceAj7WQwfmKUE/7827JyNt6g=;
        b=iVcZvUNxnGHoKqhVWJ5L9m20F5cRAYcW4xu1R5xNLpa9thEpczEr19i3odr8DODWKR
         qIbu2S1p05dYMIQ/VLoMwAgB0A2/cDoAN2YyNtjGCccQmETpsfMb5SgmF90g/okpaq0r
         jlq5pE81LXU2D1XBiBD4Xfe90fWq2ojZcPbk+38Up1sYZcqc5pOBH3g2CnoFP/Ub6WG6
         T35kjO3GzdH4zYAyNFp2Zu1/x/lCZalbJM6mHh6WgQTT6yt5+Bg5jWPpOR1JYuxmnjvc
         spM1xeKZ6jAoW5MwILHm3dnioml1mCPJyQQR6dIgk6ynHLv1ojGOkQetPw1Y3zzcrhNY
         6byA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709285095; x=1709889895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3+vNi0sKNukhWDt8NhoceAj7WQwfmKUE/7827JyNt6g=;
        b=HixlfdtWSdcIc5qqXw0jb+kLDlim6Tg92Ng3f4y6GK5NmrqvFByhKvfUS++fkqrmMK
         bpeYBdzptiLgcsc3gD0DP6+fHLGJ8Jh9yZy87HSLXGHDvOb61OkWHD4I/CI/zUzoLAFJ
         uMrZNheYRf/0P1jt6GBspp77isxdWzcy8agw3dKOfKTeSpKguVvUIxFjm4Gt1s1FqNc6
         6iNXUSCdVDFVFQHaDyxm4JA64pyFKmTrvnUuuBbb4Nurk/H/Bhh91HvogINRHdHTLyWP
         PFccso9y9o5NYH9X1TXabZ5/TxFBglO1MtkJbWT8xgOUIbKk5ms/uwQUCv2zoy0K4e9B
         TD0Q==
X-Gm-Message-State: AOJu0YyIGIGGZxxBxH/0zwNrq/8VLxXvSki93FwM3UGThXrO45C4nR8d
	re9sxNDajtbIO/zV3ClAz5R/1YGt71jKChtosuc8F9YL0+ooqYVIu9FNJbHP4ck=
X-Google-Smtp-Source: AGHT+IFHIEvOy2vSy7P223zvbyp73AmyVSr5sDxE8QzvyyzBK+iUJQ9ZJhQbxmFlNp1/509TsBAcfA==
X-Received: by 2002:a05:600c:5192:b0:412:afed:5cfb with SMTP id fa18-20020a05600c519200b00412afed5cfbmr955010wmb.15.1709285094988;
        Fri, 01 Mar 2024 01:24:54 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id iv11-20020a05600c548b00b00412a9a60f83sm4800264wmb.3.2024.03.01.01.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 01:24:54 -0800 (PST)
Date: Fri, 1 Mar 2024 10:24:53 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	anup@brainfault.org, atishp@atishpatra.org, pbonzini@redhat.com, shuah@kernel.org, 
	dbarboza@ventanamicro.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, duchao713@qq.com
Subject: Re: [PATCH v2 3/3] RISC-V: KVM: selftests: Add breakpoints test
 support
Message-ID: <20240301-16a75ed14197d3c5e0e7251e@orel>
References: <20240301013545.10403-1-duchao@eswincomputing.com>
 <20240301013545.10403-4-duchao@eswincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240301013545.10403-4-duchao@eswincomputing.com>

On Fri, Mar 01, 2024 at 01:35:45AM +0000, Chao Du wrote:
> Initial support for RISC-V KVM breakpoint test. Check the exit reason
> and the PC when guest debug is enabled.
> 
> Signed-off-by: Chao Du <duchao@eswincomputing.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../testing/selftests/kvm/riscv/breakpoints.c | 49 +++++++++++++++++++
>  2 files changed, 50 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/riscv/breakpoints.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 492e937fab00..5f9048a740b0 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -184,6 +184,7 @@ TEST_GEN_PROGS_s390x += rseq_test
>  TEST_GEN_PROGS_s390x += set_memory_region_test
>  TEST_GEN_PROGS_s390x += kvm_binary_stats_test
>  
> +TEST_GEN_PROGS_riscv += riscv/breakpoints
>  TEST_GEN_PROGS_riscv += demand_paging_test
>  TEST_GEN_PROGS_riscv += dirty_log_test
>  TEST_GEN_PROGS_riscv += get-reg-list
> diff --git a/tools/testing/selftests/kvm/riscv/breakpoints.c b/tools/testing/selftests/kvm/riscv/breakpoints.c
> new file mode 100644
> index 000000000000..be2d94837c83
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/riscv/breakpoints.c
> @@ -0,0 +1,49 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * RISC-V KVM breakpoint tests.
> + *
> + * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
> + *
> + */
> +#include "kvm_util.h"
> +
> +#define PC(v) ((uint64_t)&(v))
> +
> +extern unsigned char sw_bp;
> +
> +static void guest_code(void)
> +{
> +	asm volatile("sw_bp: ebreak");
> +	asm volatile("nop");
> +	asm volatile("nop");
> +	asm volatile("nop");

What are the nops for? And, since they're all in their own asm()'s the
compiler could be inserting instructions between them and also the ebreak
above. If we need three nops immediately following the ebreak then we
need to put everything in one asm()

  asm volatile(
  "sw_bp:	ebreak\n"
  "		nop\n"
  "		nop\n"
  "		nop\n");

> +
> +	GUEST_DONE();
> +}
> +
> +int main(void)
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_guest_debug debug;
> +	uint64_t pc;
> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SET_GUEST_DEBUG));
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	memset(&debug, 0, sizeof(debug));
> +	debug.control = KVM_GUESTDBG_ENABLE;

nit: The above two lines can be removed if we initialize debug as

  struct kvm_guest_debug debug = {
     .control = KVM_GUESTDBG_ENABLE,
  };

> +	vcpu_guest_debug_set(vcpu, &debug);
> +	vcpu_run(vcpu);
> +
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);

As Anup pointed out, we need to also ensure that without making the
KVM_SET_GUEST_DEBUG ioctl call we get the expected behavior. You
can use GUEST_SYNC() in the guest code to prove that it was able to
issue an ebreak without exiting to the VMM.

> +
> +	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc), &pc);
> +
> +	TEST_ASSERT_EQ(pc, PC(sw_bp));
> +
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}
> -- 
> 2.17.1
>

Thanks,
drew


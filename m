Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9256C3508
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjCUPFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCUPFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:05:45 -0400
Received: from out-26.mta1.migadu.com (out-26.mta1.migadu.com [IPv6:2001:41d0:203:375::1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DA04D2BB
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:05:43 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:05:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679411142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JyvQw2WBRS/YLRqGgensv+vuNhTLTecf55q+CfuCMpA=;
        b=Dg7Lu5uJmd2wB6AmU7Llz8L584EHLEVAf793bPL4VUZ5t3eNaLIcBtz00PL34pqbj42uLX
        UxvCu0T9yzj1CQMJtdSAvWyBhx16NjiDqHIQazvT4ld/b5JuaepEZ5A3VcGLHntsn9Nvqm
        tNs3lf6bYG5vH+S5RPFwl8Pli1kodV0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org
Subject: Re: [kvm-unit-tests PATCH v10 5/7] arm/locking-tests: add
 comprehensive locking test
Message-ID: <20230321150541.bkqkcoyc3hb443tj@orel>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230307112845.452053-6-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230307112845.452053-6-alex.bennee@linaro.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023 at 11:28:43AM +0000, Alex Bennée wrote:
> This test has been written mainly to stress multi-threaded TCG behaviour
> but will demonstrate failure by default on real hardware. The test takes
> the following parameters:
> 
>   - "lock" use GCC's locking semantics
>   - "atomic" use GCC's __atomic primitives
>   - "wfelock" use WaitForEvent sleep
>   - "excl" use load/store exclusive semantics
> 
> Also two more options allow the test to be tweaked
> 
>   - "noshuffle" disables the memory shuffling
>   - "count=%ld" set your own per-CPU increment count
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Message-Id: <20211118184650.661575-8-alex.bennee@linaro.org>
> 
> ---
> v9
>   - move back to unittests.cfg, drop accel=tcg
>   - s/printf/report_info
> v10
>   - dropped spare extra line in shuffle_memory
> ---
>  arm/Makefile.common |   2 +-
>  arm/locking-test.c  | 321 ++++++++++++++++++++++++++++++++++++++++++++
>  arm/spinlock-test.c |  87 ------------
>  arm/unittests.cfg   |  30 +++++
>  4 files changed, 352 insertions(+), 88 deletions(-)
>  create mode 100644 arm/locking-test.c
>  delete mode 100644 arm/spinlock-test.c
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 2c4aad38..3089e3bf 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -5,7 +5,6 @@
>  #
>  
>  tests-common  = $(TEST_DIR)/selftest.flat
> -tests-common += $(TEST_DIR)/spinlock-test.flat
>  tests-common += $(TEST_DIR)/pci-test.flat
>  tests-common += $(TEST_DIR)/pmu.flat
>  tests-common += $(TEST_DIR)/gic.flat
> @@ -13,6 +12,7 @@ tests-common += $(TEST_DIR)/psci.flat
>  tests-common += $(TEST_DIR)/sieve.flat
>  tests-common += $(TEST_DIR)/pl031.flat
>  tests-common += $(TEST_DIR)/tlbflush-code.flat
> +tests-common += $(TEST_DIR)/locking-test.flat
>  
>  tests-all = $(tests-common) $(tests)
>  all: directories $(tests-all)
> diff --git a/arm/locking-test.c b/arm/locking-test.c
> new file mode 100644
> index 00000000..a49c2fd1
> --- /dev/null
> +++ b/arm/locking-test.c
> @@ -0,0 +1,321 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Locking Test
> + *
> + * This test allows us to stress the various atomic primitives of a VM
> + * guest. A number of methods are available that use various patterns
> + * to implement a lock.
> + *
> + * Copyright (C) 2017 Linaro
> + * Author: Alex Bennée <alex.bennee@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <libcflat.h>
> +#include <asm/smp.h>
> +#include <asm/cpumask.h>
> +#include <asm/barrier.h>
> +#include <asm/mmu.h>
> +
> +#include <prng.h>
> +
> +#define MAX_CPUS 8
> +
> +/* Test definition structure
> + *
> + * A simple structure that describes the test name, expected pass and
> + * increment function.
> + */

nit: This and many comment blocks below are missing their opening wings.

Thanks,
drew

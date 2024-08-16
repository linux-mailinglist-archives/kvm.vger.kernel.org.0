Return-Path: <kvm+bounces-24440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F779551CB
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 22:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1723FB2269E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BD91C4631;
	Fri, 16 Aug 2024 20:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CJwC2KM/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDDA1C2325
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 20:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723839682; cv=none; b=Rk82dFDaFB7khmWWfNGhHbywwgoAXaZEeOZWi8xCCQduA3auGGYfOFQqSCrVzj1fvseHL+OSRxj5R4ujl/WOQ+rq24kHW1XUrG7Stio1rNpqQtuc6EtwNB2RaormU/NKKUrImYP39zh6VWXP5FKb9+qdoC2vSgtyV1cYSLfE1Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723839682; c=relaxed/simple;
	bh=RoxnupCzUJOlpAhtqFKUUXI5xaHaw4zPnWSvdo8kXEA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D9gbbf6TPEt7eFbRtrPuW5KmCO09VwnBonBy7Ihq+vE6usK7sORhNgWM3Q7sq8C91HwVMv1YVmZXGDGjsSk8PdI1Wl50jGXrVlWkCHK1nj55IRnWUn9beVhHncFfeGICWj8/mGjD5bzETiQBQDg8+ko90lURddyp+yiqsicchQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CJwC2KM/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d3e42ef85eso1231780a91.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 13:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723839679; x=1724444479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ml/zrxgslqXooti6qi/7d+TVeFAnkInp/7O9MVydVgA=;
        b=CJwC2KM/pqChuCXAri5t/b2G00a9DsJ8SGfE0U09MCDdblJg28GVrPt2dtjdhuN89g
         /lGSP6MtcMuk1vxKg830TfQQozSiYe+SxDznB7qudGJMD99e1CZOzvjxjlEn+yiM3PN4
         Uv6HzkiuT1huIyZCXYtzgrwKJqpHWw51CRCjuFLorTsSJw7/7RGh76qiuTLnztkfzAGC
         b2LOLkchshuAsjwdcuH29BHODhhPxqvh7wN1OzZpEHd3X6VzKiiWwlMvb9VCKaWYFajz
         NWRbLFCjKj3pPo7QZ1FGOFcLWGjTsKu2WhwD+KyGh7VzdLj3mVmMx5linoGaSflW/CNy
         FuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723839679; x=1724444479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ml/zrxgslqXooti6qi/7d+TVeFAnkInp/7O9MVydVgA=;
        b=ZOcAXrvZntFF4GtHJPOQyivGYfwkAWdlzs14njZNpTwBXzY3Vmqpdk4sotzaWE86nw
         zoZAyWgzU4ygCYMVjmYy2SnsGMSKTgWw14Yv3dvs9gT2Qiri36xvnVbD1xWK18PmRdlc
         sl/jxHV3qy7+YHNbtVTFhyG7UlIFNXm2kL8M7Bj43XGwE6bnXoXu3WrXma/oCqSoAYy+
         rehlxJU3D2k9RModSlcj5x+ImZeBP7loLz3DzJNUy5xk9ydDoZ3lUHfdcFNCpvEFGdve
         et90+ttE6HtZEVbKYJu527hERHhCpAR53WmOpooFr/WRd9VCVp3OYm2ay4Q82DLb+eFt
         yRcg==
X-Gm-Message-State: AOJu0YzpzHuheLmPt0AnXuocwTEG10juJSBy+c2c4v301wZ8m8IU6WWk
	ZifULhQyvXIm6fuhd86iL8LoQgCCsp+JUZY3qWbPw/o0ItcKGkcqLGeMvp387ciBjitgFBuQKrt
	g6A==
X-Google-Smtp-Source: AGHT+IFE7Hb7GuPDt7biLsqGWREW3/8zJ3I3cOi53aNTPw9eNpkaFNskEMqAJ4gAR3ybyxYczKq7LZE55/o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ad98:b0:2d3:b7c7:d682 with SMTP id
 98e67ed59e1d1-2d3dffdb498mr9761a91.3.1723839679171; Fri, 16 Aug 2024 13:21:19
 -0700 (PDT)
Date: Fri, 16 Aug 2024 13:21:17 -0700
In-Reply-To: <20240709175145.9986-5-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240709175145.9986-1-manali.shukla@amd.com> <20240709175145.9986-5-manali.shukla@amd.com>
Message-ID: <Zr-0vX9rZDY2qSwl@google.com>
Subject: Re: [RFC PATCH v1 4/4] KVM: selftests: Add bus lock exit test
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, bp@alien8.de, babu.moger@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 09, 2024, Manali Shukla wrote:
> From: Nikunj A Dadhania <nikunj@amd.com>
> 
> Malicious guests can cause bus locks to degrade the performance of
> a system.  The Bus Lock Threshold feature is beneficial for
> hypervisors aiming to restrict the ability of the guests to perform
> excessive bus locks and slow down the system for all the tenants.
> 
> Add a test case to verify the Bus Lock Threshold feature for SVM.
> 
> [Manali:
>   - The KVM_CAP_X86_BUS_LOCK_EXIT capability is not enabled while
>     vcpus are created, changed the VM and vCPU creation logic to
>     resolve the mentioned issue.
>   - Added nested guest test case for bus lock exit.
>   - massage commit message.
>   - misc cleanups. ]

Again, 99% of the changelog is boilerplate that does nothing to help me
understand what the test actually does.

> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Co-developed-by: Manali Shukla <manali.shukla@amd.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/svm_buslock_test.c   | 114 ++++++++++++++++++
>  2 files changed, 115 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/svm_buslock_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index ce8ff8e8ce3a..711ec195e386 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -94,6 +94,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/smaller_maxphyaddr_emulation_test
>  TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>  TEST_GEN_PROGS_x86_64 += x86_64/state_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
> +TEST_GEN_PROGS_x86_64 += x86_64/svm_buslock_test
>  TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
>  TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
>  TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_shutdown_test
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_buslock_test.c b/tools/testing/selftests/kvm/x86_64/svm_buslock_test.c
> new file mode 100644
> index 000000000000..dcb595999046
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/svm_buslock_test.c

I would *very* strongly prefer to have a bus lock test that is comment to VMX
and SVM.  For L1, there's no unique behavior.  And for L2, assuming we don't
support nested bus lock enabling, the only vendor specific bits are launching
L2.

I.e. writing this so it works on both VMX and SVM should be quite straightforward.

> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * svm_buslock_test
> + *
> + * Copyright (C) 2024 Advanced Micro Devices, Inc.
> + *
> + * SVM testing: Buslock exit

Keep the Copyright, ditch everything else.

> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +
> +#define NO_ITERATIONS 100

Heh, NR_ITERATIONS.

> +#define __cacheline_aligned __aligned(128)

Eh, I would just split a page, that's about as future proof as we can get in
terms of cache line sizes.

> +
> +struct buslock_test {
> +	unsigned char pad[126];
> +	atomic_long_t val;
> +} __packed;
> +
> +struct buslock_test test __cacheline_aligned;
> +
> +static __always_inline void buslock_atomic_add(int i, atomic_long_t *v)
> +{
> +	asm volatile(LOCK_PREFIX "addl %1,%0"
> +		     : "+m" (v->counter)
> +		     : "ir" (i) : "memory");
> +}
> +
> +static void buslock_add(void)
> +{
> +	/*
> +	 * Increment a cache unaligned variable atomically.
> +	 * This should generate a bus lock exit.

So... this test doesn't actually verify that a bus lock exit occurs.  The userspace
side will eat an exit if one occurs, but there's literally not a single TEST_ASSERT()
in here.


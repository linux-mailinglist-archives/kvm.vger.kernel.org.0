Return-Path: <kvm+bounces-18943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D36CE8FD5A9
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 20:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CDE4B23EC7
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A9017555;
	Wed,  5 Jun 2024 18:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ACl/NZ6c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A0E624
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717611865; cv=none; b=M10OzpYAGzz8NaYu5q4oM13LnD1kn/t6ALyjcujg58Cst61USPb1J7yT+iNL6W6TPyYDx6VrbK1OCUCpQtpXl6twvNtg5WnTHL5IiT9VO8Tbo0AFqIzMNpmCcOj31f4ZuVbfpuH20VCmH01O2S9kGW0y52bz51OoZ66nxYRN3iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717611865; c=relaxed/simple;
	bh=q0rM+gUKgIyPm6WKCW6mF1rL56wZHLDcuvOojvDMOmE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KkrM0jl+QCWd82neZYfhYP+As75wO/udD78VueV0PepBQWhUsg7E5uoS9YxZAbppnoNiUsAIE+14H0kaR/YQQFvlQXflhCUkZ7Ojp246htDR3/HrHyRr9/ATDzHTyA2nFW1jjRm2wajb0M19EF4xg29WqMg+7jasvGKJI72PWXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ACl/NZ6c; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df78fddad5dso281936276.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 11:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717611863; x=1718216663; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lVUT2ahvRQ5gm+m7FqYZjKLqFMm0OlxDovsVrvEcCao=;
        b=ACl/NZ6cb4dccfpM2i01us4WnWiMp2SfE3gc1vrIXR/5KDN0j4pEhrQ1uIl1jwCVjZ
         iYTjt0ltNHAq6ULtonw73qvn3j80tmo2OCAT9w1kBFN2tAmwi6Kh6GeLTHgMY+ToMFi8
         H/Br2miPoTowudiRRp6U3ZMZHhsDPf5nNBUiOQ93QukO60N9yEc+jLFdDToMyDbqNGBn
         YIJ/vgcRE6FkSCyAckHhVSk5j+aVpjc/EJEhWNOmOw02fPWB0JQ9fcrmv7mDmCXs7kVA
         3radW+T4CwbfC1mYvFf6iHOT+tH0v3msFxi4F4QaxJiGP+lMJPVWe1x7HXGcfkCs0YJf
         76fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717611863; x=1718216663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lVUT2ahvRQ5gm+m7FqYZjKLqFMm0OlxDovsVrvEcCao=;
        b=qTAfdUP5wQUNVgCgnx5Oqbe7sIGCPO3mZzPPLgwiZmpy6U9MnMURhq/FlORMhMTWvU
         n7QBT90usvmBBPGXg2IL42Ppa+H8iaVqWqqB5NMqOoeMMoVwKuBY+Ac2EHY64TMM7p+W
         Z02qxCt+vsX0wDNIIBuChLbSlxmebb+JG4P0QwMX9R9FbHzJbLbWoMn/0EBqfRRwlkEl
         TbT2p3BOvUeUA2Irg/q39KC1nzPIaa2KormQfCFh+ETHZ2bfhcERYH6zEFwnwXpzMOoW
         Sf0ZrWoPPkbfZGU4GDmtTSFsZx7pE3umZ2+2sfv3AsF2hRaUUzK8im3ISo+FrAZdwcDs
         +7SQ==
X-Gm-Message-State: AOJu0Yx25A+nV8wPWKZz5S7C1nkjrXPspe/7QNMIEpE0vYxIqNNWbi48
	s+oJlvhjB9QWytx0haLOV3N+2OqOy3TPzidgP/wJfGaoo/sZuXNN+DYSrdmCuERqdLKXmRs1rDT
	Cdg==
X-Google-Smtp-Source: AGHT+IEnm0a/7jE9JwLRWEUOPi5Jd69/Ve4HxG1b9lcN8naqzVN+/XzVbIZXL3ZJAxIX6+81cjIFzCeJy0U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:72f:b0:df4:a381:5172 with SMTP id
 3f1490d57ef6-dfacacf7237mr794402276.8.1717611862625; Wed, 05 Jun 2024
 11:24:22 -0700 (PDT)
Date: Wed, 5 Jun 2024 11:24:21 -0700
In-Reply-To: <20240122085354.9510-3-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240122085354.9510-1-binbin.wu@linux.intel.com> <20240122085354.9510-3-binbin.wu@linux.intel.com>
Message-ID: <ZmCtVWQ_7KdMqcmf@google.com>
Subject: Re: [kvm-unit-tests PATCH v6 2/4] x86: Add test case for LAM_SUP
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com, 
	robert.hu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 22, 2024, Binbin Wu wrote:
> diff --git a/x86/lam.c b/x86/lam.c
> new file mode 100644
> index 00000000..0ad16be5
> --- /dev/null
> +++ b/x86/lam.c
> @@ -0,0 +1,243 @@
> +/*
> + * Intel LAM unit test
> + *
> + * Copyright (C) 2023 Intel
> + *
> + * Author: Robert Hoo <robert.hu@linux.intel.com>
> + *         Binbin Wu <binbin.wu@linux.intel.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2 or
> + * later.
> + */
> +
> +#include "libcflat.h"
> +#include "processor.h"
> +#include "desc.h"
> +#include "vmalloc.h"
> +#include "alloc_page.h"
> +#include "vm.h"
> +#include "asm/io.h"
> +#include "ioram.h"
> +
> +#define FLAGS_LAM_ACTIVE	BIT_ULL(0)
> +#define FLAGS_LA57		BIT_ULL(1)
> +
> +struct invpcid_desc {
> +	u64 pcid : 12;
> +	u64 rsv  : 52;
> +	u64 addr;
> +};
> +
> +static inline bool is_la57(void)
> +{
> +	return !!(read_cr4() & X86_CR4_LA57);
> +}
> +
> +static inline bool lam_sup_active(void)

Needs an "is_" prefix.  And be consistent, e.g. is_lam_sup() to go with is_la57(),
or is_lam_sup_enabled() and is_la57_enabled().  I'd probably vote for the latter,
though KVM does have is_paging() and the like, so I'm fine either way.

And these belong in processor.h

> +{
> +	return !!(read_cr4() & X86_CR4_LAM_SUP);
> +}
> +
> +static void cr4_set_lam_sup(void *data)
> +{
> +	unsigned long cr4;
> +
> +	cr4 = read_cr4();
> +	write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
> +}
> +
> +static void cr4_clear_lam_sup(void *data)
> +{
> +	unsigned long cr4;
> +
> +	cr4 = read_cr4();
> +	write_cr4_safe(cr4 & ~X86_CR4_LAM_SUP);
> +}

Please drop these helpers and instead use _safe() variants when possible, e.g.

	vector = write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
	report(has_lam ? !vector : vector == GP_VECTOR,
	       "Expected CR4.LAM_SUP=1 to %s" ? has_lam ? "succeed" : "#GP");

	vector = write_cr4_safe(cr4 & ~X86_CR4_LAM_SUP);
	report(!vector, "Expected CR4.LAM_SUP=0 to succeed");

> +static void test_cr4_lam_set_clear(bool has_lam)
> +{
> +	bool fault;
> +
> +	fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
> +	report((fault != has_lam) && (lam_sup_active() == has_lam),
> +	       "Set CR4.LAM_SUP");
> +
> +	fault = test_for_exception(GP_VECTOR, &cr4_clear_lam_sup, NULL);
> +	report(!fault, "Clear CR4.LAM_SUP");
> +}
> +
> +/* Refer to emulator.c */
> +static void do_mov(void *mem)
> +{
> +	unsigned long t1, t2;
> +
> +	t1 = 0x123456789abcdefull & -1ul;
> +	asm volatile("mov %[t1], (%[mem])\n\t"
> +		     "mov (%[mem]), %[t2]"
> +		     : [t2]"=r"(t2)
> +		     : [t1]"r"(t1), [mem]"r"(mem)
> +		     : "memory");
> +	report(t1 == t2, "Mov result check");
> +}
> +
> +static u64 test_ptr(u64 arg1, u64 arg2, u64 arg3, u64 arg4)

There's no reason to name these arg1..arg4.  And unless I'm missing something,
there's no need for these flags at all.  All the info is derived from vCPU state,
so just re-grab it.  The cost of a CR4 read is negligible relative to the expected
runtime of these tests.

> +{
> +	bool lam_active = !!(arg1 & FLAGS_LAM_ACTIVE);
> +	u64 lam_mask = arg2;
> +	u64 *ptr = (u64 *)arg3;
> +	bool is_mmio = !!arg4;
> +	bool fault;
> +
> +	fault = test_for_exception(GP_VECTOR, do_mov, ptr);
> +	report(!fault, "Test untagged addr (%s)", is_mmio ? "MMIO" : "Memory");
> +
> +	ptr = (u64 *)set_la_non_canonical((u64)ptr, lam_mask);
> +	fault = test_for_exception(GP_VECTOR, do_mov, ptr);
> +	report(fault != lam_active,"Test tagged addr (%s)",
> +	       is_mmio ? "MMIO" : "Memory");
> +
> +	return 0;
> +}
> +
> +static void do_invlpg(void *mem)
> +{
> +	invlpg(mem);
> +}
> +
> +static void do_invlpg_fep(void *mem)
> +{
> +	asm volatile(KVM_FEP "invlpg (%0)" ::"r" (mem) : "memory");
> +}
> +
> +/* invlpg with tagged address is same as NOP, no #GP expected. */
> +static void test_invlpg(u64 lam_mask, void *va, bool fep)
> +{
> +	bool fault;
> +	u64 *ptr;
> +
> +	ptr = (u64 *)set_la_non_canonical((u64)va, lam_mask);
> +	if (fep)
> +		fault = test_for_exception(GP_VECTOR, do_invlpg_fep, ptr);
> +	else
> +		fault = test_for_exception(GP_VECTOR, do_invlpg, ptr);

INVLPG never faults, so don't bother with wrappers.  If INVPLG faults, the test
fails, i.e. mission accomplished.

> +
> +	report(!fault, "%sINVLPG with tagged addr", fep ? "fep: " : "");
> +}
> +
> +static void do_invpcid(void *desc)
> +{
> +	struct invpcid_desc *desc_ptr = (struct invpcid_desc *)desc;
> +
> +	asm volatile("invpcid %0, %1" :
> +	                              : "m" (*desc_ptr), "r" (0UL)
> +	                              : "memory");
> +}

Similar thing here, invpcid() belongs in processor.h, alongside invpcid_safe().

> +/* LAM doesn't apply to the linear address in the descriptor of invpcid */
> +static void test_invpcid(u64 flags, u64 lam_mask, void *data)
> +{
> +	/*
> +	 * Reuse the memory address for the descriptor since stack memory
> +	 * address in KUT doesn't follow the kernel address space partitions.
> +	 */
> +	struct invpcid_desc *desc_ptr = (struct invpcid_desc *)data;
> +	bool lam_active = !!(flags & FLAGS_LAM_ACTIVE);
> +	bool fault;
> +
> +	if (!this_cpu_has(X86_FEATURE_PCID) ||

I don't _think_ we need to check for PCID support.  It's a KVM/QEMU bug if INVPCID
is advertised but it doesn't work for the "all PCIDs" flavor.

> +	    !this_cpu_has(X86_FEATURE_INVPCID)) {
> +		report_skip("INVPCID not supported");
> +		return;
> +	}
> +

...

> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 3fe59449..224df45b 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -491,3 +491,13 @@ file = cet.flat
>  arch = x86_64
>  smp = 2
>  extra_params = -enable-kvm -m 2048 -cpu host
> +
> +[intel-lam]
> +file = lam.flat
> +arch = x86_64
> +extra_params = -enable-kvm -cpu host
> +
> +[intel-no-lam]
> +file = lam.flat
> +arch = x86_64
> +extra_params = -enable-kvm -cpu host,-lam

Hrm, not something that needs to be solved now, but we really need a better
interface for iterating over features in tests :-/


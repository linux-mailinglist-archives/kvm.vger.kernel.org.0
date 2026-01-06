Return-Path: <kvm+bounces-67174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E0463CFAE24
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 21:16:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 58395304F537
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 20:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73E2233CE9D;
	Tue,  6 Jan 2026 19:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G9CR+GFt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3083F33B6F7
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 19:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728813; cv=none; b=F2H0Iwerjm0ntTeVYKex4MRI1Wy5B4Gqa5fH2CgsoEm2GA6wVDfZNvx7RNe1Ty/GGPaskXnXc6eGxAAVXsWCgIdA5CcKIDbFHA23U2vcQ1UtaOWPpro0EWLWpy4XSBIrnD6Va9Rosj9Kt6ykmsOtkKZhhl/6HyQ8c9zfMs9JG8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728813; c=relaxed/simple;
	bh=KuSdBZ9CI3H4fvaeuI0u6Uz4UfBd8FAZf6zVOAwDu9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PzjX24Num9BNyU/hOibzwQs3Hgkf21hQe8fUP/FD5zNFTUHAKqRQ94t3biMbXYhOByCDtcGdCgAua3XoVUgKHa6XJbF4edkHts8gEDEoqRTlklTqumiPNRpEMJ5y0dLx3odXlgJmUnJ5eicldKhT2qlwGtE0I/EX0pvEd2zT/vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G9CR+GFt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34aa1d06456so2898500a91.0
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 11:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767728811; x=1768333611; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZriMaEA+mukSvHum14D+f4jkgVLElfimaxrHlh88e8w=;
        b=G9CR+GFt6wLz/IiqTH3Lb4ghXqhUYk93Hlsh+GnEp/w8gv9HreQK8MHqW1HjQyOpAP
         KUlIqI0olkdLOWQHL1vRbwLy6UmRn/wxqllAIZ01BwwMEg28/1iN7U84JWexjTZ3B/l3
         r5gOvWkQrJbPBI9bUVsW2cbwvJsax+cVvqhbH+VG30uBEaJFMZz4lDBSOuHDlrkyBRDQ
         y7StN82oTR3+dGtqeptT2172wX+lHV7ZxPoHhwZVCPnsHflBMV9I6Y9lAyaWgjw87GGx
         qZdpmKtrbSBOlN52toqJ40qtRVGjcfMCQguxN5Ata004OAUeIJqHb3kP9jZK2G1FNVpA
         ERwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767728811; x=1768333611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZriMaEA+mukSvHum14D+f4jkgVLElfimaxrHlh88e8w=;
        b=D+adCi8ZFEW0hmGsSSrcDK/0ZLecQ9PtExtFmLNu69CDTkJoWZD7PUwW6RQPQwpU4N
         n7/r1hC3vHAkITR1R/o9gX6DQNZHJD0DqIhlfb0pZL3Ilku5qm4jGy4JmyB99/TSU/xP
         gB/dix3WoO3iodrVq0IdsPE46UyUuxv2JfSHZXww7jUPPFpvOHgwY8rhv6rb7AW6hPn+
         om9I0cnEcr+FWFj9nEvqlfLneY8iZIKdkoE3C4wv1SbcX1K9hohpgEAmgVuXRMICV+up
         jr+k3H/oRGD5BxnQJbOlIwK+aLx+vKpo7LdB09ovpNT+MBRmOuT2+ATduJCt8ZUcRWFL
         Ghxw==
X-Gm-Message-State: AOJu0YxuMd9UKqCge/ESJFfwB4mENpebFgEDc+gpgwnFa1/l5HOY1OW9
	QNBt3bBGIoTpuvYbYncaORL5x0iSlUEdIXAraMpC3ZVuwuLG8fgvlCOa4QbM1QxQ3QOD4AYmWBU
	BI+1mBg==
X-Google-Smtp-Source: AGHT+IGZby64OMYDLsQncM6OFaUmrTDXzxVCp6nfZzSkjGTInUpS7Y2UQJcRJ5iTle12BuWLNTTKOzutkWY=
X-Received: from pjbbj19.prod.google.com ([2002:a17:90b:893:b0:34c:a40f:705a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c87:b0:34c:a35d:de16
 with SMTP id 98e67ed59e1d1-34f68c282c6mr196827a91.11.1767728811460; Tue, 06
 Jan 2026 11:46:51 -0800 (PST)
Date: Tue, 6 Jan 2026 11:46:49 -0800
In-Reply-To: <20260106092425.1529428-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com> <20260106092425.1529428-5-tabba@google.com>
Message-ID: <aV1mqQtALFIUBHVM@google.com>
Subject: Re: [PATCH v3 4/5] KVM: selftests: Move page_align() to shared header
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 06, 2026, Fuad Tabba wrote:
> To avoid code duplication, move page_align() to the shared `kvm_util.h`
> header file.
> 
> No functional change intended.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h    | 5 +++++
>  tools/testing/selftests/kvm/lib/arm64/processor.c | 5 -----
>  tools/testing/selftests/kvm/lib/riscv/processor.c | 5 -----
>  3 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 81f4355ff28a..dabbe4c3b93f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -1258,6 +1258,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
>  	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
>  }
>  
> +static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)

Maybe vm_page_align()?  So that it's a bit more obvious when reading call sites
that the alignment is done with respect to the guest's "base" page size, not the
host's page size.

> +{
> +	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> +}
> +
>  /*
>   * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
>   * to allow for arch-specific setup that is common to all tests, e.g. computing
> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> index 607a4e462984..143632917766 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -21,11 +21,6 @@
>  
>  static vm_vaddr_t exception_handlers;
>  
> -static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> -{
> -	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> -}
> -
>  static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
>  {
>  	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> index d5e8747b5e69..f8ff4bf938d9 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -26,11 +26,6 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
>  	return !ret && !!value;
>  }
>  
> -static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> -{
> -	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> -}
> -
>  static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
>  {
>  	return ((entry & PGTBL_PTE_ADDR_MASK) >> PGTBL_PTE_ADDR_SHIFT) <<
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 


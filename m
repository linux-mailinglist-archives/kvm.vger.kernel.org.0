Return-Path: <kvm+bounces-56369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4542FB3C3E6
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:47:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9229E188C522
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 20:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC35B3469EE;
	Fri, 29 Aug 2025 20:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ToTXahfk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FBA19D07A
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 20:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756500449; cv=none; b=kuho8r0JKytQi4CQjUKzQwsz0NCDN5cAzBnKZO3eDhgPxODp82hB7fWrcBIURZUb22lRbHpWMdiB182W3Vwjf3+eS2yEUHse/sVGx5TdbAx9nCxt6CnLkI4rUcDie3Gg3wlWj6meGgLAKVUcKApXZNg8c9vYvTL8rbCOzS304qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756500449; c=relaxed/simple;
	bh=9/wSQP4TwiwA28VHXselfVMpk5vyfA21xkhCwpAOusE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o6ycT2lEMCkDsQ8ZbKKK8SL6g3K9YkcHszJDdfXbxFstV20jtehq40VYIpwHdKeX0TiKGoNKSv1TzvHdAmCAbnzFR/mnrko3hRYeTX6AS5L96DN64/ZEwAZNslGPsbsGqjTJRbccPgpfmdoS8q0w1nZ0UjXFAC4l7vv5i7b6t6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ToTXahfk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3235e45b815so2945190a91.0
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 13:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756500447; x=1757105247; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AVbLrwfcaMKrZbEzaIUXHMFK+4ezBC1s3sCq6svjQiA=;
        b=ToTXahfkCYPpuJQrCIJeiRR5rqJCIKh6WcDOebynZAu/Q0ehA7GR0Bznd2eRotavRe
         AbLqSnKkMd0N3juuERwUg2VP5bdIAuckkWMHjkxgoEfyJL2Hrnx9gcVfEmidVcF7upx6
         tFqJXbJ66veK7tk/GGy6w07rO6H0F8jlzpmKqG/Gl5slyefwPKAr4GN2HDndlrASvddd
         XN0HkOUmj8z0DWMuiKXzFwfmLBUkqrO7NraAqPEA/yuzAf5y4REJVs7Z3hn+1ho9ACFR
         NbbTb+dv2O5+xnF87FNxyvvHrYwn76gsV4OK2rH/QyloI2g4Yv+/abyzl6bbZwYj3syp
         X0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756500447; x=1757105247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AVbLrwfcaMKrZbEzaIUXHMFK+4ezBC1s3sCq6svjQiA=;
        b=MR8WNUlDD1sSUhULsTeEhbw7f833fN+5sTGXuAOpwHXjBvhXHSNS3etYDLl1WlEIcU
         QETBcqyLnF8seM8lNzRA7RzMqGSm0rFIa9naYfFEldG6LTQL5Mb4+bHWdTdBrJ4rfNWL
         wtQIKvLpCzeE4pE+8bf5+qEcXadOOCK6YBtFxF9mY8YeXu6/q98+V0FX1O9bbTA+hbtD
         4AO1SRBGY2FnsoaBlpsGF1dMYA1Dv+2X6E7Gae/JuhDitZ3UcR1qSA/mkpzkLxT694bK
         /6ITPOltKFg4VHNrQOntqXPoOGekW6ZC/g4nqWswEMAjjCRPMGIF4bDkMXHP4IPjxtZw
         7sAw==
X-Forwarded-Encrypted: i=1; AJvYcCWF8IkGqHMZfigecWeF9+GmrMP+w08mC+cSijsKkfRQZAdjabUDnwXd1RqYHJ6IsYqnKrk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxnxy6uFhrt4ol1Wy36sPt0/CxN4MNQaUdm2wRcHr1uhFEuXtPS
	i7QQ2YHMwaUn9XZACWv5xganZH8DjUN93hiPAkgbEn4dlf3AKETs602qLri6zWqAQdI3ZROZfyM
	QF8m8DQ==
X-Google-Smtp-Source: AGHT+IEEqHXHhC1dOfepFQ4McJBotwArzkUulxIcLhYJ/fKtpfgV5WqeosCA+M558p3CNkr7r/wGr0do/qg=
X-Received: from pjbli2.prod.google.com ([2002:a17:90b:48c2:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3889:b0:327:b30d:9b7f
 with SMTP id 98e67ed59e1d1-327b30d9cdbmr12852743a91.12.1756500446915; Fri, 29
 Aug 2025 13:47:26 -0700 (PDT)
Date: Fri, 29 Aug 2025 13:47:25 -0700
In-Reply-To: <20250829-pmu_event_info-v5-6-9dca26139a33@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com> <20250829-pmu_event_info-v5-6-9dca26139a33@rivosinc.com>
Message-ID: <aLIR3deQPxVI2VrE@google.com>
Subject: Re: [PATCH v5 6/9] KVM: Add a helper function to check if a gpa is in
 writable memselot
From: Sean Christopherson <seanjc@google.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 29, 2025, Atish Patra wrote:
> The arch specific code may need to know if a particular gpa is valid and
> writable for the shared memory between the host and the guest. Currently,
> there are few places where it is used in RISC-V implementation. Given the
> nature of the function it may be used for other architectures.
> Hence, a common helper function is added.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  include/linux/kvm_host.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 15656b7fba6c..eec5cbbcb4b3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1892,6 +1892,14 @@ static inline bool kvm_is_gpa_in_memslot(struct kvm *kvm, gpa_t gpa)
>  	return !kvm_is_error_hva(hva);
>  }
>  
> +static inline bool kvm_is_gpa_in_writable_memslot(struct kvm *kvm, gpa_t gpa)
> +{
> +	bool writable;
> +	unsigned long hva = gfn_to_hva_prot(kvm, gpa_to_gfn(gpa), &writable);
> +
> +	return !kvm_is_error_hva(hva) && writable;

I don't hate this API, but I don't love it either.  Because knowing that the
_memslot_ is writable doesn't mean all that much.  E.g. in this usage:

	hva = kvm_vcpu_gfn_to_hva_prot(vcpu, shmem >> PAGE_SHIFT, &writable);
	if (kvm_is_error_hva(hva) || !writable)
		return SBI_ERR_INVALID_ADDRESS;

	ret = kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(zero_sta));
	if (ret)
		return SBI_ERR_FAILURE;

the error code returned to the guest will be different if the memslot is read-only
versus if the VMA is read-only (or not even mapped!).  Unless every read-only
memslot is explicitly communicated as such to the guest, I don't see how the guest
can *know* that a memslot is read-only, so returning INVALID_ADDRESS in that case
but not when the underlying VMA isn't writable seems odd.

It's also entirely possible the memslot could be replaced with a read-only memslot
after the check, or vice versa, i.e. become writable after being rejected.  Is it
*really* a problem to return FAILURE if the guest attempts to setup steal-time in
a read-only memslot?  I.e. why not do this and call it good?

	if (!kvm_is_gpa_in_memslot(vcpu->kvm, shmem >> PAGE_SHIFT))
		return SBI_ERR_INVALID_ADDRESS;

	ret = kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(zero_sta));
	if (ret)
		return SBI_ERR_FAILURE;


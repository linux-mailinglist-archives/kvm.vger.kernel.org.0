Return-Path: <kvm+bounces-53163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1AEB0E281
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 19:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAB181887393
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C56D27FB15;
	Tue, 22 Jul 2025 17:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xMAb7cqG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473DF27BF7E
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 17:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753204827; cv=none; b=uxq/EYb0TFesCgYSOpN5tXMWYzel9xTvDwy9X3hSL4MrLBUJVx760fgQ372ouJ5Pq7p32+SfXHngYUcflH375iYi7s0uZDhHi8A5l3Iwbi/CSqTOuaA6lQkkI3N0U++MbfL15j7YRuit8WyMAn6nzL7jLkrfpfam2dRB49F5jJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753204827; c=relaxed/simple;
	bh=qjjgH+eHZG02k1KIgWre37CEcc0cA3Qrq3ps00wAydc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BaBzhnubtAeqyZHT6EurNCQ6htZ3SYZhad6bwiedFOLSqa+5/y6sVC4RuY8UQsIzhdyHqdDUMQKd5iANtT5qB1xuRFkzbhywsUb3LXwtMsKxxGaQwCwTr+pY+B5nORIlpK/fDxP2k42+yr5h1Vn/ixNZt82dDtREqdKzPJslLys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xMAb7cqG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23536f7c2d7so94739375ad.2
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 10:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753204825; x=1753809625; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LxAdZVy5bnkl4KqmKmn73hf8YAbhvCFGtW8F9Kd55hQ=;
        b=xMAb7cqGakTOAM0SJp9K8gGmziq/8I4tQbbVe5gkRI/+oymzQatbimLAecRkLK1rDM
         5WV7FhWHNOvcsdjYyWXosggDf6NCAA3gPiJ0kEfEjyCbabnEx4OF3jgW5CyeBKSUNLgl
         OCoOVbu+Q/jgkyhShZBdMQU7rWB6aGEbPGJgtwiQDMa66nKJpUNQzQzLhh5TdXU7LitB
         tlj9EAJcJrAZ63V6PbN/Ar3XeZardo/xojMazgcoSIlwxTTrZv1+XQEZcTDsxkZA142k
         pzvHcNaAeONONxXy/qr5gt0RpUXxDf3lcyfwI24VHEdyK/kXRSIyquCCr92qPETc74sL
         QK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753204825; x=1753809625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LxAdZVy5bnkl4KqmKmn73hf8YAbhvCFGtW8F9Kd55hQ=;
        b=cx6bqTSYIgdZUMoxFtARBuIpbTeHmzCAPPcdxsSD/SCrz9R6LXXmUlJWKDAUwXbGj3
         nOzG50ZHyl7m+8As/x9eGT9IOlfb3iJxKI0EJyVQr4FoOsJyslh7QwUchOxJG+d7l9zO
         6OXYoxiRbm2VkO3HEjaNkN90/euRjwCdp5Zv+s2FC4C/6XfZaxYgQEUJgu6a/jNAi3lb
         ku9+2N9FyogndNTulUkclBFkg3Jaz9VkfC8yZXkhDT+kymhM6CBPrYDpte/6vRrpBjKW
         z8tlRZ0tRPVPUOSJ6hByxdIKZXqU8mj8r4WAKSA+P3hCFKsQWQn4QRgif7abwArAxHZg
         dd7A==
X-Forwarded-Encrypted: i=1; AJvYcCWZPs+wEu+PUrTFwx/R4UtiouoClu39hlzixfWdV+Xd5zFsx8jzWD4PxEc4sUgbC1RO39Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVvdqABfxZsaRAvGRUf4x3b266e9Mcp2wiZAj9dsyh6E3C412u
	pOsDozqXhscBVFrifMt4Q2nIWljtpyO6sjEwWB37bIk85FOtaaM3r6M1BPQHck/VbG8R7mmDMsw
	XvEea0w==
X-Google-Smtp-Source: AGHT+IFPwqe8zheAvHey8s0KE1DDyf7guFt8iRaY4PC5Rd3QBhN41iFPFY93hbtWc17LP1SCCWCPuinQiL0=
X-Received: from pjbnt20.prod.google.com ([2002:a17:90b:2494:b0:31e:40d4:1d0e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2342:b0:235:ea29:28e9
 with SMTP id d9443c01a7336-23e25764c41mr424140005ad.38.1753204825492; Tue, 22
 Jul 2025 10:20:25 -0700 (PDT)
Date: Tue, 22 Jul 2025 10:20:24 -0700
In-Reply-To: <20250721-pmu_event_info-v4-6-ac76758a4269@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com> <20250721-pmu_event_info-v4-6-ac76758a4269@rivosinc.com>
Message-ID: <aH_IWJUFVODUGuva@google.com>
Subject: Re: [PATCH v4 6/9] KVM: Add a helper function to validate vcpu gpa range
From: Sean Christopherson <seanjc@google.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 21, 2025, Atish Patra wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3bde4fb5c6aa..9532da14b451 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1387,6 +1387,8 @@ static inline int kvm_vcpu_map_readonly(struct kvm_vcpu *vcpu, gpa_t gpa,
>  
>  unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
>  unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
> +int kvm_vcpu_validate_gpa_range(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long len,
> +				bool write_access);
>  int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
>  			     int len);
>  int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa, void *data,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 222f0e894a0c..11bb5c24ed0d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3361,6 +3361,27 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest);
>  
> +int kvm_vcpu_validate_gpa_range(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long len,
> +				bool write_access)

Please no.  "validate" is way too ambiguous, the result is inherently unstable,
I don't want to add vCPU-scoped APIs (too much x86-centric baggage), taking an
arbitrary range without a user adds complexity for no benefit, and this is basically
the same as kvm_is_gpa_in_memslot(), but with write requirements.

I would much prefer to add a simpler helper to complement kvm_is_gpa_in_memslot(),
that makes it as obvious as possible exactly what is being "validated", e.g.

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3bde4fb5c6aa..29be907d28b0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1915,6 +1915,14 @@ static inline bool kvm_is_gpa_in_memslot(struct kvm *kvm, gpa_t gpa)
        return !kvm_is_error_hva(hva);
 }
 
+static inline bool kvm_is_gpa_in_writable_memslot(struct kvm *kvm, gpa_t gpa)
+{
+       bool writable;
+       unsigned long hva = gfn_to_hva_prot(kvm, gpa_to_gfn(gpa), &writable);
+
+       return !kvm_is_error_hva(hva) && writable;
+}
+
 static inline void kvm_gpc_mark_dirty_in_slot(struct gfn_to_pfn_cache *gpc)
 {
        lockdep_assert_held(&gpc->lock);


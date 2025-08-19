Return-Path: <kvm+bounces-55025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB9AFB2CB8C
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6FA03A68E1
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 629D030E0E1;
	Tue, 19 Aug 2025 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1RZ8hcMn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4077727B33A
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755626243; cv=none; b=fhfexK6/XIEiOOG6SLchfSPvOSD7lnwZKT7+vjYV+x0gY1lSmCrv5+FSqgeZav+Rvf/IxuZgl+i3ow9EsckttMxIKTjAn+nSA5j9bKwUeYYFlPNq9WOlcyrG5uhO5+gTyzKa7zpgnPB7XszvqUgPDdJVKaVjeILiLeSdQiYDBTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755626243; c=relaxed/simple;
	bh=Lekw3wykeuF3Waa5M9M8csKwjmFTtD+8UG+rgUe1cR8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y0TBwICcibExGg0RmAdfFH9YBVJXuBuBdj4gmGlSTc/2HksS9NZNbI//Au0vCT6U230IwSPGJdDyB88oo3KEl4oQa1WGTewYUvHUXyyIXOR4xE6VQyx9oSCbOqgXz27AWFP/uIv1wGk3kbH2ImV/YKavQWn/KxiVmfa2/yL45Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1RZ8hcMn; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244570600a1so1328395ad.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 10:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755626241; x=1756231041; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=awFHWzNWAp5SYh09L94PKcRcaUavFe5/Zi4ooub4Zj0=;
        b=1RZ8hcMnY0UkisAccNUEIDq/XVdQshTWeDhlsOTmUmQQZyaenu3QYnjjtQ02U31thh
         hNJqo4/3s/98whJCPC1EFGc7F4W2IcXWvQdUY3JgJkkog8pBWYqADosYUYyvZQesHWxk
         IFkFNLV8RrtWi7NB7dM9Mx7O8JaSTh1sFoPQJidXKTCYXDou4n9Ued/Gpd6zrr+O7nZ5
         3gCP8QD241kALBCqMhKEwUlifjVjTlZFfKKaWWd3G3WgSp2zHmSfFKxSsch63qDNpsuq
         HHFX7JMzffuYvVstdQnAMywKs5qKhGYU9BiQLUAQYfIhUd4hN8qOHARstmFE+hVLxAGO
         Ab9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755626241; x=1756231041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=awFHWzNWAp5SYh09L94PKcRcaUavFe5/Zi4ooub4Zj0=;
        b=Y4MPh2JzMy47/99AA/lySi0hHakVhHQ9zAIIMFSYKqDr0Nm8XTSxiwt81RnPj0dyBy
         wyPaPZIDadTABuzmzcZ1pGIRoPAc3rVMH6p4xWZlwR36HHoyuFQk+OwC6ATqr/8/jNEh
         pV3Wwk9MQ+s8c1PJF6hASkagAx/eJ+MfVQd4VOzVSKwt0r7LiOG9n7m9fFbab05Lvxp9
         Fxhj94HsKV4w2q2ws7lDTyN+GZ/nGfyoFdcpUAfEUv28eGt1Q5dyaZ6O7qlCbGS9pQPD
         ubSGS45BZ4Y+YK9q6EGUUFN8gEvCXo6Mjvc81SKd7b+zxHGhpeo+ADeN5yBhAlCTPd8g
         5tKA==
X-Forwarded-Encrypted: i=1; AJvYcCVqMYrMhcVJ0t+93/9C4Sm9kwKVSe/JH16N7QkdEhWH3n8z+KrXDgB+8VEZndAUFSehZN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXECfJwYshEtkSISe6MwH4d29ikOHLiXQyGDbZuCpIpUvSUAqN
	Qg6ePfBQgNIoT1FO2+0dkYF57Q/AsfARfWIm/f7H0fVp44h+qxnz8yVhWuW8nCy9+c+Sg60/5SQ
	nhIh22g==
X-Google-Smtp-Source: AGHT+IEojSr7GoNvTuxvzXZluQEK52TmYYgrRBoN6UydB/hS70lcHeVWVE771Bsmo2VW75hUu7alv8ngTns=
X-Received: from plhy2.prod.google.com ([2002:a17:902:d642:b0:240:770f:72cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1acc:b0:23e:3911:433e
 with SMTP id d9443c01a7336-245edfd8310mr3177075ad.5.1755626241631; Tue, 19
 Aug 2025 10:57:21 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:57:20 -0700
In-Reply-To: <20250707224720.4016504-2-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com> <20250707224720.4016504-2-jthoughton@google.com>
Message-ID: <aKS7ANG-_EJyEY6U@google.com>
Subject: Re: [PATCH v5 1/7] KVM: x86/mmu: Track TDP MMU NX huge pages separately
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 07, 2025, James Houghton wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4e06e2e89a8fa..f44d7f3acc179 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -65,9 +65,9 @@ int __read_mostly nx_huge_pages = -1;
>  static uint __read_mostly nx_huge_pages_recovery_period_ms;
>  #ifdef CONFIG_PREEMPT_RT
>  /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
> -static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
> +unsigned int __read_mostly nx_huge_pages_recovery_ratio;
>  #else
> -static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
> +unsigned int __read_mostly nx_huge_pages_recovery_ratio = 60;

Spurious changes.

>  #endif
>  
>  static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp);

...

> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index db8f33e4de624..a8fd2de13f707 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -413,7 +413,10 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
>  
> -void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> -void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> +void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> +				 enum kvm_mmu_type mmu_type);
> +void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> +				   enum kvm_mmu_type mmu_type);
>  
> +extern unsigned int nx_huge_pages_recovery_ratio;

And here as well.  I'll fixup when applying.


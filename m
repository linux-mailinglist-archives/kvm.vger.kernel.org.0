Return-Path: <kvm+bounces-64002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E6486C76A37
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:41:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4BC5D4E4A52
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E642F39C7;
	Thu, 20 Nov 2025 23:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NEYOq12a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2EF19E97A
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763682038; cv=none; b=AS4gg/29dSA1vsszalkwZh1fTbxGzbqjXiri1VRXFrkhIiz6H9hbNpsqfSX7CawLAb4I+jCrfam1tbQMu3JuKQ22uHIMiAtn2YkY0Dc1dK7GcIDu+fFzljNujMnAisJGkapbEi361eoS8Cmf8E/8scWOgSsIyqV2HLFxJEo8li8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763682038; c=relaxed/simple;
	bh=mYdfNS2P7JhMQ/kCLY5MBF1zL8mUzoPVYZB5PRLoDcc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GZTuvpCqAlIzFInj3f+jU6nqUhaNTIBQMZNADN0hq1LNN91ymX1+iEIUO8BqKuY+s0lJWMmMNPxHO0FTBEinP+9/I5tn7/3ptFORiYXWkIUp97nU6Muuxq/VmKw3hg2X82uSdQa5DzHriPcwdUtPs+pvB7xFoRoDtRniKFED6OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NEYOq12a; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34188ba5990so4162851a91.0
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763682036; x=1764286836; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tz3mL4IK63e/6boEg0RIE/GfKvJh5AvynCJ73h5jjZE=;
        b=NEYOq12akXiRo6lIJBSD12cAS0Io4xlO7bNnNkrBFblDDPrfBc5cNphsRJFV0PblUR
         q3b3WCCfz+tBqH+pY1ZELDjyKBPl0kurIIwcjnwrXLi1sB30iP4Z5xyfAdxECjXLA/1K
         VYeanUzhd+6vCWZOa+3DtLalVhdE7gNEmpKyw+WAwQRjZBVHOvGlYrVhs1JdpWDJEc/L
         O9fYFPrqq1TG/Sc6zH8G75R+8s7YI11IjPTuzfbYySHYH72u+93buMyeMki+vSn7Ru/m
         C/bTrHttaaihzC5QVjUayO88jFjQtyk6e7Lsz0kl7Z5QQmm68cbmx2oqeCDl8g01Fbkj
         icTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763682036; x=1764286836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tz3mL4IK63e/6boEg0RIE/GfKvJh5AvynCJ73h5jjZE=;
        b=u/mbcpcfxtDZIRxpT/jh390ZK1VXmwfIJ/8WyWmFxM1papS0XsSDIUAWNczwNySwL6
         qf6+O93UArjSC0wk6ibCMyeu4uVXcVoPvniZ8tkrPFn7S145jWoPBaZKabQgX5UNkHa2
         lqp8CNUOA6+BKiIuFGk8gb2ysclJL8OHazyFhAOy9r6v7BodCjYh6t/cNcnKCWJBqFXr
         bvSvbGqsphLIYpGYuQ2dA8W+9vuNh5v1xMZutF52++qvw1tQKyw2AjlTnBwhUxRaHlZB
         HMJ30h1HSWCBl2tteiDbplWedP9jsRH7VpG09iDSO+FifNG0IUFuCPc3mB8fKpRWGEh1
         oZ3w==
X-Forwarded-Encrypted: i=1; AJvYcCUUqVyGjLLRHMH01EiTr8aYcu+hQQfXULgKqKssWhAyqi2uswJibfNJHqICL7wgV7bg3kU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvAPD0vqKA+cDV/J9S8FMBuhiDG5t6ghHUgf7S311yunfshLtn
	H1cXAX5uozOSFCJ8EFQ0K0r3ywfIIyW0SUJds/7jrVGdsTG9CI99lVL4cvwYUc0AfnIhyPk3W/k
	j2KH+lQ==
X-Google-Smtp-Source: AGHT+IEJlKEX1Lo5fr2/obWefb+N5dv3yrF5mObJRdr6qksM1jS9DLvrx305SHZ64+9RjVmAhu+7VAo8ZiQ=
X-Received: from pjst15.prod.google.com ([2002:a17:90b:18f:b0:340:a575:55db])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:268d:b0:336:9dcf:ed14
 with SMTP id 98e67ed59e1d1-34733f2a40bmr258634a91.23.1763682036619; Thu, 20
 Nov 2025 15:40:36 -0800 (PST)
Date: Thu, 20 Nov 2025 15:40:35 -0800
In-Reply-To: <20251021074736.1324328-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev> <20251021074736.1324328-2-yosry.ahmed@linux.dev>
Message-ID: <aR-m85ZKhRIPB14J@google.com>
Subject: Re: [PATCH v2 01/23] KVM: selftests: Minor improvements to asserts in test_vmx_nested_state()
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> Display the address as hex if the asserts for the vmxon_pa and vmcs12_pa
> fail, and assert that the flags are 0 as expected.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  .../selftests/kvm/x86/vmx_set_nested_state_test.c      | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
> index 67a62a5a88951..c4c400d2824c1 100644
> --- a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
> +++ b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
> @@ -241,8 +241,14 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
>  	TEST_ASSERT(state->size >= sizeof(*state) && state->size <= state_sz,
>  		    "Size must be between %ld and %d.  The size returned was %d.",
>  		    sizeof(*state), state_sz, state->size);
> -	TEST_ASSERT(state->hdr.vmx.vmxon_pa == -1ull, "vmxon_pa must be -1ull.");
> -	TEST_ASSERT(state->hdr.vmx.vmcs12_pa == -1ull, "vmcs_pa must be -1ull.");
> +	TEST_ASSERT(state->hdr.vmx.vmxon_pa == -1ull,
> +		    "vmxon_pa must be 0x%llx, but was 0x%llx",
> +		    -1ull, state->hdr.vmx.vmxon_pa);
> +	TEST_ASSERT(state->hdr.vmx.vmcs12_pa == -1ull,
> +		    "vmcs12_pa must be 0x%llx, but was 0x%llx",
> +		    -1llu, state->hdr.vmx.vmcs12_pa);
> +	TEST_ASSERT(state->flags == 0,
> +		    "Flags must be equal to 0, but was 0x%hx", state->flags);

The error messages aren't adding a whole lot, why not just use TEST_ASSERT_EQ()?


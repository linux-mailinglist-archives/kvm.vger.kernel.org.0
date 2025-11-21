Return-Path: <kvm+bounces-64187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3047C7B379
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:07:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FE033A53CF
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3861A350D5F;
	Fri, 21 Nov 2025 18:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VsemThie"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656C334F241
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748316; cv=none; b=rRoGW8ac/3hQa6h0fBrWCLPoZXRPhFFl4Mkcc/SlBxNgCMwcfrffXIist1Fta0qStib48mtldBaakNDKWKduEx3MHQM3Q9pUQ0Hay9E1AVQKxKYdV9LUbAosogios4sSlBoGTLS5uu38Qj+Ax/VnelSnVqCJezcbgO5PiGs0NVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748316; c=relaxed/simple;
	bh=n/cMr41l5S+d9PxhzZBTfRwzCYoF6Eae8lHqi6pLdzA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cjCeZe3Lk9h1r/QzGvQ5ooarfFZTsthrZ9KFgKwlZ6pmgIpWYzMDLXKn5t840Nmk0hsBIqBhtFQ7z0/C6bRC8pupakb07K59iiEXDMYPBFwiAcXUEY6UsQaSbqcTZ1Uuqljec2bY/Qhx+CAbT0+PC4bCEMgm5XxJ1+FwI2l189Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VsemThie; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438b1220bcso2720871a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748311; x=1764353111; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JPIkaMy0Bp2G3Fc2Hk52scy1ehKAAFPWgxTepn4leGE=;
        b=VsemThiewDlymmetr9W83ZADmj1Z5R8WXv0CJCwsY6OCauRrPki55jnQYItzSw0s/5
         1xdu1cBI1IAcQu4AnX89FgHMr11DqjiJRXn0sjt8e/wBnudWVkHxfMMReiuQxnCdW7Sf
         T3OseS5zhSmNlhGVFmhiuy/BxHI0oJkvOtWg6S4DDK+J7btMxQj5RzcA8Pq8+7Rtr6Mx
         xr+94oFsftqS29aINH7Pw7ChB/3ckukcFZZ2yBhMbk5t+/jlGcGl6Wu30tYcHHlwbjsg
         MDlOzY7JNgs+YIAt+/fKGyUr3n0qbGxPShSmp1DZluQr85JWYxGcQDXQxKhgiX0K8Xh8
         3cmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748311; x=1764353111;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPIkaMy0Bp2G3Fc2Hk52scy1ehKAAFPWgxTepn4leGE=;
        b=egJLgdEOAPAPGszhjWK5SQP7jx9VcD92UG/0KBjO8Qs5VrhoEKFbRqqUYA3stw+L+O
         fL7RhMfBseCsCSnjVMZwDKUHd6MKUVDnuIJy5AEN8mv71tHJfAFzAuZp9nSoz5BgZRbB
         Hk6JNP+vxxenkx40VEJ8Zy6v9DN2pqsQ+NegVMGYFYT0CTJsNX7XCly5waR8OwWjQS5R
         8W05wUc/AOwAnDT3NYK7pZfKKc4LC3Hc3EJkJWnlCbfKRM2QwshF10A8cBY9j/SrZEIO
         uJK7Dfu3D4iCUNQLoSM8SXQzYjg0bkGDoCm+8tHu6MHkJcdBqTESLLzTdeuI6VY4Wd/F
         Vlsw==
X-Gm-Message-State: AOJu0Yz2zuZyxju7AdUYivDafYe5yEfyGbiRea0HlZHRNTjYXfqQ3Ff7
	02Npg3Z/6K6iEHrCjRmrYztiox+dbEyk60cu2acmxVyHrXmp9CxLlBtNd0Vu1HUtnxWC4QSTwyB
	km5EUcw==
X-Google-Smtp-Source: AGHT+IGm9rHpG3vI3Z78wdJXg0Tmfwvs7XOVZlOi4qJcZV5YWhRWSRIaQveVtS3WDp0mzv6j72wl7HH5fyM=
X-Received: from pjbqi14.prod.google.com ([2002:a17:90b:274e:b0:340:c015:8e31])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fc8:b0:33f:f22c:8602
 with SMTP id 98e67ed59e1d1-34733f3b7a2mr3951000a91.26.1763748311152; Fri, 21
 Nov 2025 10:05:11 -0800 (PST)
Date: Fri, 21 Nov 2025 10:05:09 -0800
In-Reply-To: <20251114003228.60592-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114003228.60592-1-pbonzini@redhat.com>
Message-ID: <aSCp1f9baI69d4So@google.com>
Subject: Re: [PATCH kvm-unit-tests] xsave: add testcase for emulation of AVX instructions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kbusch@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 13, 2025, Paolo Bonzini wrote:
> Companion patch to the emulator changes in KVM.  Funnily enough,
> no valid combination involving AVX was tried.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/xsave.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/xsave.c b/x86/xsave.c
> index cc8e3a0a..e6d15938 100644
> --- a/x86/xsave.c
> +++ b/x86/xsave.c
> @@ -15,6 +15,34 @@
>  #define XSTATE_SSE      0x2
>  #define XSTATE_YMM      0x4
>  
> +char __attribute__((aligned(32))) v32_1[32] = {
> +    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
> +    128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143,
> +};
> +char __attribute__((aligned(32))) v32_2[32] = { 0 };
> +
> +static __attribute__((target("avx"))) void
> +test_avx_fep(void)

Bizarre wrap.

> +{
> +	asm volatile("vzeroall\n"

Why zero all registers?  I can't think of any reason why VZEROALL is needed, and
clobbering everything for no apparent reason is weird/confusing.

> +	    KVM_FEP "vmovdqa v32_1, %%ymm0\n"

These need to use RIP-relative addressing, otherwise EFI builds fail.

> +	    KVM_FEP "vmovdqa %%ymm0, v32_2\n" : : :
> +	    "memory",
> +	    "%ymm0", "%ymm1", "%ymm2", "%ymm3", "%ymm4", "%ymm5", "%ymm6", "%ymm7",
> +	    "%ymm8", "%ymm9", "%ymm10", "%ymm11", "%ymm12", "%ymm13", "%ymm14", "%ymm15");
> +}
> +
> +static __attribute__((target("avx"))) void
> +test_avx(void)
> +{
> +	asm volatile("vzeroall\n"
> +	    "vmovdqa v32_1, %%ymm0\n"
> +	    "vmovdqa %%ymm0, v32_2\n" : : :

We should also test reg=>reg, registers other than ymm0, and that emulated accesses
are correctly propagated to hardware.  E.g. with macro shenanigans, it's not too
hard:

	asm volatile(FEP "vmovdqa v32_1(%%rip), %%" #reg1 "\n"		\
		     FEP "vmovdqa %%" #reg1 ", %%" #reg2 "\n"		\
		     FEP "vmovdqa %%" #reg2 ", v32_2(%%rip)\n"		\
		     "vmovdqa %%" #reg2 ", v32_3(%%rip)\n"		\
		     ::: "memory", #reg1, #reg2);			\

> +	    "memory",
> +	    "%ymm0", "%ymm1", "%ymm2", "%ymm3", "%ymm4", "%ymm5", "%ymm6", "%ymm7",
> +	    "%ymm8", "%ymm9", "%ymm10", "%ymm11", "%ymm12", "%ymm13", "%ymm14", "%ymm15");
> +}
> +
>  static void test_xsave(void)
>  {
>      unsigned long cr4;
> @@ -45,7 +73,22 @@ static void test_xsave(void)
>      report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
>             "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE)");
>      report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == 0,
> -           "        xgetbv(XCR_XFEATURE_ENABLED_MASK)");
> +           "\t\txgetbv(XCR_XFEATURE_ENABLED_MASK)");

Ugh, this test is ancient and crusty.  We really should have dedicated helpers
for accessing XCR0, it uses spaces instead of tabs, there's unnecessary code
duplication, and a handful of other minor issues.

I'll send a series with a pile of cleanups, and better validation of VMOVDQA
emulation.


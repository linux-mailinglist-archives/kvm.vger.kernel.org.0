Return-Path: <kvm+bounces-16388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 985998B926C
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 01:43:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54B93282862
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 23:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F97416ABEB;
	Wed,  1 May 2024 23:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhZ9tasL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA1843AC3
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714607028; cv=none; b=nzvpQnqGlcxcQxkM8vUjrrxscyAHLtdT5kg3BAk8JbOzxYDYZ0xdWJmbgaJ7JdpgvHQ2qVmR+kvneu1NjJCtNxfzwvr2eJeUotY0CuB1JqhSG4/XH7KhjBIGrMRNrRwIVhV2HTrIm3Tpna+qaR2KTSo04Ykc52NQR6CjJizRFYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714607028; c=relaxed/simple;
	bh=2pkaSNd5mj914kEiaP0QkxFGh2ogAhnZMbOFRd/ZgLI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HEZsnH6ab3752FsucOnh8KGTQ6BWI72T744CAxUIB0y+ZfiwEjIxfU7lho7OKxDGv/cG2WN0FMAgj8CreX0c3+x/B0E410uNBJ5bjENNeztIK0EdID2P+DM53bjXYdF2V+MhVCq5jc2mOotNM62Md/7NkWemrCUYBwe8LeCQ4eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhZ9tasL; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61bed763956so47540397b3.3
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 16:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714607025; x=1715211825; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LVl+Z9tfBjY+uacNoWUqChu9AVbSs20cv47lE0qQwfM=;
        b=dhZ9tasLv2c+b1Xo8BVjkgtl2wNAYDsjhV/VqCMNjMF0GRGfg6ItJf3tu2bACt2po+
         LnaZXPiWUqiX90otpG/lpW6sQDass7r5kPuhXjtI8OiaC4228M915P+vQR4wlu/Naqwj
         ryptbVwoz9B0BNOHKo+7W7pC+6ylgUO87Js7/fgs5d3rhkUCTuW7MATmo3OvHFwDt0ND
         OwEgY56jgWFGutbQwPci1Ag0wgBRcWP7lLvY7r8MyD6xughL4m//wFiyaB50vuSpAWlx
         vAekneQsZe39ZnTUNCOUEh9XsTjB4MgPNg3QqWV9F/dMIltshfEJH3I28+FaI0dcybpn
         Q/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714607025; x=1715211825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LVl+Z9tfBjY+uacNoWUqChu9AVbSs20cv47lE0qQwfM=;
        b=k4CF7l5L6E8Njd+BGOqTeTmSDTrlKUjfnFrgMWE4a4Qz/g6kID94yw3oNnn75NHMN+
         YHnO20zCq7IgWAxQtGiWRjWAzj0JnQT79gC6TDNR2DaNWXtpWSTme/GluNK94sKEEqrE
         OAhU+6R0hvYg1/DtLQVyP3OTmn91ldhne6JvERL83KRY+7uBd0g7bftd2RryEFmIamNf
         zmhE/UZf15xWX9xGq/7DLyHzNCsy/f7vboBjjyQrI1EGBCGnhOzCuSg0lzky0W21w/pq
         6cCV9azk68TY1Pxolwv8eXgdPqzVlXczgmIxdTOVn9BCLcV8mDmaZkOT9I5/fZpJ9Nay
         ZNmw==
X-Gm-Message-State: AOJu0Yx+ru/G/XeoVYHVPuN9rGda70LF8pZRnFc2W0HoZZ2KlrB5YXT3
	+Ve4wB4ui0T3HYWQ62Q99zjz6afnVOGwfLUqqS5xsuapUofM9FqXk/VKdTMf+VjZN17Ehg8iAzc
	Juw==
X-Google-Smtp-Source: AGHT+IH275hUfifH9DyhXjuCF+G+CU78/ek2SP935wGkHsT5NhMu3CMh5+aNt9x7Uggtjb0GmaBEeFMcKTM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4b10:b0:61b:e678:2591 with SMTP id
 ip16-20020a05690c4b1000b0061be6782591mr1157082ywb.4.1714607025187; Wed, 01
 May 2024 16:43:45 -0700 (PDT)
Date: Wed, 1 May 2024 16:43:43 -0700
In-Reply-To: <20240226213244.18441-7-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240226213244.18441-1-john.allen@amd.com> <20240226213244.18441-7-john.allen@amd.com>
Message-ID: <ZjLTr0n0nwBrZW36@google.com>
Subject: Re: [PATCH v2 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, weijiang.yang@intel.com, rick.p.edgecombe@intel.com, 
	thomas.lendacky@amd.com, bp@alien8.de, pbonzini@redhat.com, 
	mlevitsk@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, John Allen wrote:
> When a guest issues a cpuid instruction for Fn0000000D_x0B
> (CetUserOffset), KVM will intercept and need to access the guest
> MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
> included in the GHCB to be visible to the hypervisor.

Heh, too many pronouns and implicit subjects.  I read this, several times, as:

  When a guest issues a cpuid instruction for Fn0000000D_x0B
  (CetUserOffset), KVM will intercept MSR_IA32_XSS and need to access the
  guest MSR_IA32_XSS value.

I think you mean this?

  When a vCPU executes CPUID.0xD.0xB (CetUserOffset), KVM will intercept
  and emulate CPUID.  To emulate CPUID, KVM needs access to the vCPU's
  MSR_IA32_XSS value.  For SEV-ES guests, XSS is encrypted, and so the guest
  must include its XSS value in the GHCB as part of the CPUID request.

Hmm, I suspect that last sentence is wrong though.  Question on that below.

> Signed-off-by: John Allen <john.allen@amd.com>
> ---
> v2:
>   - Omit passing through XSS as this has already been properly
>     implemented in a26b7cd22546 ("KVM: SEV: Do not intercept
>     accesses to MSR_IA32_XSS for SEV-ES guests") 
> ---
>  arch/x86/include/asm/svm.h | 1 +
>  arch/x86/kvm/svm/sev.c     | 9 +++++++--
>  arch/x86/kvm/svm/svm.h     | 1 +
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 728c98175b9c..44cd41e2fb68 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -673,5 +673,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
>  DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
>  DEFINE_GHCB_ACCESSORS(sw_scratch)
>  DEFINE_GHCB_ACCESSORS(xcr0)
> +DEFINE_GHCB_ACCESSORS(xss)
>  
>  #endif
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f06f9e51ad9d..c3060d2068eb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2458,8 +2458,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  
>  	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
>  
> -	if (kvm_ghcb_xcr0_is_valid(svm)) {
> -		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> +	if (kvm_ghcb_xcr0_is_valid(svm) || kvm_ghcb_xss_is_valid(svm)) {
> +		if (kvm_ghcb_xcr0_is_valid(svm))
> +			vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> +
> +		if (kvm_ghcb_xss_is_valid(svm))
> +			vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
> +
>  		kvm_update_cpuid_runtime(vcpu);

Pre-existing code, but isn't updating CPUID runtime on every VMGEXIT super wasteful?
Or is the guest behavior to mark XCR0 and XSS as valid only when changing XCR0/XSS?
If so, the last sentence of the changelog should be something like:

  MSR_IA32_XSS value.  For SEV-ES guests, XSS is encrypted, and so the guest
  must notify the host of XSS changes by performing a ??? VMGEXIT and
  providing its XSS value in the GHCB.


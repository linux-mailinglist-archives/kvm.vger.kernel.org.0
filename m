Return-Path: <kvm+bounces-31765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF73E9C74A1
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90CBA284441
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9FC1200B82;
	Wed, 13 Nov 2024 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y2C87f7Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E01C1D2F42
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731508957; cv=none; b=EMByZX9jKvuDGLH6MLRPhM3nzXG9OgVY8Ak5KZ1b/qZWyFzl3Ew9hBKd7IgEjrPW3DYeCgGUq1NEBAQEokNnb1WD1THS7L7Vp/u2HjkGlZnFIMMtZMYY5OZbZ6t96veLt1QF+QjoVUTifPpDjDVA/fUbN29+Xeidd7JrYEgiYpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731508957; c=relaxed/simple;
	bh=H7pCO0jvWyCgm8+MOuucS9Z3DogWa2ypginOj6t+6HI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UdYSkiMqxrAqeHhFYP5LBJ3388Edq1KRxz2our5ecbPMbHRvi5+ZUq74SWku/RycQ2xYH/t7ckYrkIjiiZjjZ5XiY2ZL9BMjIvdESTeOUvebUx21k6DhixWGRWuY7E9hQmECM8K69dRhvmfcsNSJr7l/gIsAz0AM6P6M05ZG8/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y2C87f7Z; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eaae8b12bfso110853567b3.3
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 06:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731508955; x=1732113755; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rfg9NwqMTcGNJ9bU6dvOqS5YD21NsFaWTC9a5IYTigo=;
        b=Y2C87f7Zv1sYo87oNyRI4NljOlS5AIOTy0DHUvCtjyFTGv6hsnABL79+efXT92XryB
         OiLV1LNZihiTJs52Htz0ClkCCrgYOQhfyrmAIrwgkdz1WBcsviTpMEkNB6NQ8yr67tGk
         8zzyvbVmzEpwKzTdUOFBzpCHrGmUUqvWRH0IxYlHYfLoHCERitJwXK6RttlrgLiBzYuP
         5eib3vM048zHTppLhXqFVuwyChQRgb54C2DNU17vlqfbNaANZFEWwwkqO1jSaKWilFhh
         kZ4xhcwsPWRXR2PXVMRvOJ0yD2inoVCcXfiw9KAdKWWLGVCVUb11gcezPpo2IOfLwB0G
         qoiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731508955; x=1732113755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rfg9NwqMTcGNJ9bU6dvOqS5YD21NsFaWTC9a5IYTigo=;
        b=D6rSPU9K7HTf0G6O5pti2SMH+Dw+XjEMGPrWCV+HsNm+FiGSc3aJctzRrjfYCCK9ct
         qpj+gRz4igfivHJAR73wtjd1REgmIi/nY6xbOsbrQOurkNPk+s5Ct/lJYARcAoUBi+9C
         qZqYridZzw+jC2hMfqkn6luygZu/hdmdItCXicYTOWE0mkBoE79vOoK+XC/KLq1ZUUrx
         d7EFisWfugYb1gBhUkSYsPQ+EXHMzFbThZziYlbWPar1CX074+lBqYZQi4p5YMxWSBFC
         +pQzZ7UCwwafBv9Pksd9GTvNYTnhjPTWMfmsuJCrVshQN3jnv9voyPWmxYlnPPSU5ySv
         Vwpw==
X-Forwarded-Encrypted: i=1; AJvYcCUlAPJrTN5mwi+YHeVlYTkpzYnLtAgRJ1C3tyTLNmCY0+d4X6y+yPcMNZV5WCNmf1V5NKg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsqz/HR3U6IUSakhgb6NeMIUKz3Jm2IDSxv2qQkd+a8mWlvPFL
	95uGfHgI2bL1hsVzrsmJVSCjrg0xbPOQj1upZ02Q1NFBnVUgkWxYgLqVC1bRrStdPHxGL9DAPna
	1dQ==
X-Google-Smtp-Source: AGHT+IExGbRmCOShQCOxBZ1MhL/YgYOz72Zyke6iP58F7aa8yoKgxgYJiR1l0sFnVwHR1gWWT/utdbh7Swc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:d3c6:0:b0:e28:e97f:5394 with SMTP id
 3f1490d57ef6-e35ecdea722mr2191276.4.1731508955058; Wed, 13 Nov 2024 06:42:35
 -0800 (PST)
Date: Wed, 13 Nov 2024 06:42:33 -0800
In-Reply-To: <20241112065415.3974321-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241112065415.3974321-1-arnd@kernel.org>
Message-ID: <ZzS62W60NS_sM31K@google.com>
Subject: Re: [PATCH] x86: kvm: add back X86_LOCAL_APIC dependency
From: Sean Christopherson <seanjc@google.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	kernel test robot <lkp@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 12, 2024, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Enabling KVM now causes a build failure on x86-32 if X86_LOCAL_APIC
> is disabled:
> 
> arch/x86/kvm/svm/svm.c: In function 'svm_emergency_disable_virtualization_cpu':
> arch/x86/kvm/svm/svm.c:597:9: error: 'kvm_rebooting' undeclared (first use in this function); did you mean 'kvm_irq_routing'?
>   597 |         kvm_rebooting = true;
>       |         ^~~~~~~~~~~~~
>       |         kvm_irq_routing
> arch/x86/kvm/svm/svm.c:597:9: note: each undeclared identifier is reported only once for each function it appears in
> make[6]: *** [scripts/Makefile.build:221: arch/x86/kvm/svm/svm.o] Error 1
> In file included from include/linux/rculist.h:11,
>                  from include/linux/hashtable.h:14,
>                  from arch/x86/kvm/svm/avic.c:18:
> arch/x86/kvm/svm/avic.c: In function 'avic_pi_update_irte':
> arch/x86/kvm/svm/avic.c:909:38: error: 'struct kvm' has no member named 'irq_routing'
>   909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
>       |                                      ^~
> include/linux/rcupdate.h:538:17: note: in definition of macro '__rcu_dereference_check'
>   538 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
> 
> Move the dependency to the same place as before.
> 
> Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202410060426.e9Xsnkvi-lkp@intel.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Question: is there actually any point in keeping KVM support for 32-bit host
> processors? From what I can tell, the only 32-bit CPUs that support this are
> the rare Atom E6xx and Z5xx models and the even older Yonah/Sossaman "Core
> Duo", everything else is presumably better off just running a 64-bit kernel
> even for 32-bit guests?
> ---
>  arch/x86/kvm/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 1ed1e4f5d51c..849a03f3ba95 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -19,7 +19,6 @@ if VIRTUALIZATION
>  
>  config KVM_X86
>  	def_tristate KVM if KVM_INTEL || KVM_AMD
> -	depends on X86_LOCAL_APIC
>  	select KVM_COMMON
>  	select KVM_GENERIC_MMU_NOTIFIER
>  	select KVM_ELIDE_TLB_FLUSH_IF_YOUNG
> @@ -93,6 +92,7 @@ config KVM_SW_PROTECTED_VM
>  config KVM_INTEL
>  	tristate "KVM for Intel (and compatible) processors support"
>  	depends on KVM && IA32_FEAT_CTL
> +	depends on X86_LOCAL_APIC
>  	help
>  	  Provides support for KVM on processors equipped with Intel's VT
>  	  extensions, a.k.a. Virtual Machine Extensions (VMX).
> @@ -130,6 +130,7 @@ config X86_SGX_KVM
>  config KVM_AMD
>  	tristate "KVM for AMD processors support"
>  	depends on KVM && (CPU_SUP_AMD || CPU_SUP_HYGON)
> +	depends on X86_LOCAL_APIC

The dependency can and should go on "config KVM", not on the vendor modules.  The
net effect on the build is the same, but preventing the user from selecting KVM
will provide a slightly better experience.


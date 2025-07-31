Return-Path: <kvm+bounces-53780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E7F8B16D34
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A98B65834F4
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48A728D8C9;
	Thu, 31 Jul 2025 08:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YY80rSkw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563E7202C2A
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949353; cv=none; b=d7Vi5sZyEuTqXsJ2+jExZNSymHsICMcoUOPTwgRg1GoEkC7RSikjA/xgJyDCcR13xZ0aJdjgZTZ5jyPz+f64j89XHeL2tyMIVKpqiUSzO4HE1iG8fnDcTYkZvO8CIQ60Iqka71vQ37bXEyfgj/5u4xy5h0glzJQZz1hA7oRilDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949353; c=relaxed/simple;
	bh=3qhIHJybqYLHwwYanOWTSTzOJk3WZo3sjmIfTKSzZ/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eOekUdgBBXSKqV7tvo/Ox5g/jyZ1N0yjm3Gt8rR6VKp44xJawpdmT0Hhr9/pwk8Ap+2A+XKTbfvZ0U1Wsl5PhwZU1faJXi8QpL6GXXRHZkMf8Z17foTVW5dnM1IX3aTRtyeq8f0dUmx9ovgP2E4MQBQopvsta56uX6y1GFo8xEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YY80rSkw; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso274551cf.0
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949350; x=1754554150; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sVpT/rCjQeAh5KIDPEhyQ+wKLpTK8xJK+YrwTKpUU6g=;
        b=YY80rSkwduUsqg6UpX072+7DLqU6BkG2DMBHprq4B+YWG7rAmTMIBrroQKC6yb4Q/4
         wpzayNaaygti/ZuZAp4CeucgLr5sfUXX7x391AEruZEGGgMsvVZNACJvGhcDo/Fv8A1L
         cWryXW3mDcg1CF3QF25XpREVc6h1s5iHo8RoAyM6m/cjuPgx9IUtLA3Vz2xcXg4Bq8/2
         P2+P9kN9JwOC6BKPvVQYDr1DK+he9Mb4l2Ze8AG7l2gyS+dKQK3vFkEoO3F16lekm8Ly
         jeKwiT/l4LgFW0pR6bxRtmaI+thD+UNlgP8wLwleAAH0F8LlVnouLjROUybsUU8K5pUD
         R1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949350; x=1754554150;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sVpT/rCjQeAh5KIDPEhyQ+wKLpTK8xJK+YrwTKpUU6g=;
        b=uRl+H8jnL+SdFqgbdL3VM9CxFq6xYB41+nYnQ8R7nxM60fumCwJFiImZhG59sid7g9
         6drfysnRK/cepv4RFo/oSYgrbekatXWIk08WntJIIMQzL/AbFMB4RGth/PW4kdWSLMCv
         /waAiLlTyDFKIog9Sdei07RHkcqCq9ymYANzvsSvgnE9a1KDtCwAHQYWjev7wBE3G312
         1P1xT/5yD6TPUbjoRg1b0ptstDu3mRE2vsthYqLf516z7tegNzJZMGV6XzC5B3hOAQUA
         ak0jFYFuhgXnhDqtrbKm3cr0sNixjFIRRcP4KjAZFrTZywJi5fF6adPbuU+amx055pZT
         1uPg==
X-Forwarded-Encrypted: i=1; AJvYcCXcfpfcsSmgvIkNPwGsipPZje2t7k3xxJ7LG3HxMyKea+lQQHcd/Z4ahfQqjvPDkh7GE5s=@vger.kernel.org
X-Gm-Message-State: AOJu0YztWHZ1ld/v1UjL3fazNqLm9U3zuCy6KOYx7aZVBfd9sq+Y6aUD
	yiJRpe50nWBgLzgiodjhbFvAQU9ckYxwTY/CMCUlK/cw/yniSXush8Um6j06/AhXpOMwvCyArSP
	isPSNYmTMbXPBuxCnIzIA3So+FI85MDw56Cb/pXqe
X-Gm-Gg: ASbGncuN9uGCD5iz3BMHGceb5aGQEBxwWNN+kD/JrHZGVlofv7JSbTZqGnXCZz85/06
	Dqr1N8vnoA6lZ5wLjl8DYukZPGtDdC1iUTzlocISK95HoSxYVDHnikvSPiVaLWM0/11EvFApTi+
	p2qQfUGLPQjtWcWEiI9Ylhwt54m+2zNNhHaeZIgfMysohKRxa87HYy8PSw644YtZZbcexz0Folr
	BTfDt4=
X-Google-Smtp-Source: AGHT+IGrOVcMpMBT75FdKmxNn0PIJ5gM9b3irx1KceuhF9jVkzaF5hxH8j7i6+oG0xfsaxYdfsfyN79teagnN0ObxVs=
X-Received: by 2002:ac8:5a0b:0:b0:4aa:c3f9:99a7 with SMTP id
 d75a77b69052e-4aeeff4d635mr2252941cf.20.1753949349819; Thu, 31 Jul 2025
 01:09:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-3-seanjc@google.com>
In-Reply-To: <20250729225455.670324-3-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:08:33 +0100
X-Gm-Features: Ac12FXzXuU8fZ8KWH4QzSncdpqMTYPr50tdZb-JZxmCnm--xfHOVid80C_5YEog
Message-ID: <CA+EHjTx7OF2i4MvviAXQq0v6+a7T4SMU0PGsObDBo98Y6zvrBQ@mail.gmail.com>
Subject: Re: [PATCH v17 02/24] KVM: x86: Have all vendor neutral sub-configs
 depend on KVM_X86, not just KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>
> Make all vendor neutral KVM x86 configs depend on KVM_X86, not just KVM,
> i.e. gate them on at least one vendor module being enabled and thus on
> kvm.ko actually being built.  Depending on just KVM allows the user to
> select the configs even though they won't actually take effect, and more
> importantly, makes it all too easy to create unmet dependencies.  E.g.
> KVM_GENERIC_PRIVATE_MEM can't be selected by KVM_SW_PROTECTED_VM, because
> the KVM_GENERIC_MMU_NOTIFIER dependency is select by KVM_X86.
>
> Hiding all sub-configs when neither KVM_AMD nor KVM_INTEL is selected also
> helps communicate to the user that nothing "interesting" is going on, e.g.
>
>   --- Virtualization
>   <M>   Kernel-based Virtual Machine (KVM) support
>   < >   KVM for Intel (and compatible) processors support
>   < >   KVM for AMD processors support
>
> Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---


Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/kvm/Kconfig | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 2c86673155c9..9895fc3cd901 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -74,7 +74,7 @@ config KVM_WERROR
>         # FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
>         # Building KVM with -Werror and KASAN is still doable via enabling
>         # the kernel-wide WERROR=y.
> -       depends on KVM && ((EXPERT && !KASAN) || WERROR)
> +       depends on KVM_X86 && ((EXPERT && !KASAN) || WERROR)
>         help
>           Add -Werror to the build flags for KVM.
>
> @@ -83,7 +83,7 @@ config KVM_WERROR
>  config KVM_SW_PROTECTED_VM
>         bool "Enable support for KVM software-protected VMs"
>         depends on EXPERT
> -       depends on KVM && X86_64
> +       depends on KVM_X86 && X86_64
>         help
>           Enable support for KVM software-protected VMs.  Currently, software-
>           protected VMs are purely a development and testing vehicle for
> @@ -169,7 +169,7 @@ config KVM_AMD_SEV
>  config KVM_IOAPIC
>         bool "I/O APIC, PIC, and PIT emulation"
>         default y
> -       depends on KVM
> +       depends on KVM_X86
>         help
>           Provides support for KVM to emulate an I/O APIC, PIC, and PIT, i.e.
>           for full in-kernel APIC emulation.
> @@ -179,7 +179,7 @@ config KVM_IOAPIC
>  config KVM_SMM
>         bool "System Management Mode emulation"
>         default y
> -       depends on KVM
> +       depends on KVM_X86
>         help
>           Provides support for KVM to emulate System Management Mode (SMM)
>           in virtual machines.  This can be used by the virtual machine
> @@ -189,7 +189,7 @@ config KVM_SMM
>
>  config KVM_HYPERV
>         bool "Support for Microsoft Hyper-V emulation"
> -       depends on KVM
> +       depends on KVM_X86
>         default y
>         help
>           Provides KVM support for emulating Microsoft Hyper-V.  This allows KVM
> @@ -203,7 +203,7 @@ config KVM_HYPERV
>
>  config KVM_XEN
>         bool "Support for Xen hypercall interface"
> -       depends on KVM
> +       depends on KVM_X86
>         help
>           Provides KVM support for the hosting Xen HVM guests and
>           passing Xen hypercalls to userspace.
> @@ -213,7 +213,7 @@ config KVM_XEN
>  config KVM_PROVE_MMU
>         bool "Prove KVM MMU correctness"
>         depends on DEBUG_KERNEL
> -       depends on KVM
> +       depends on KVM_X86
>         depends on EXPERT
>         help
>           Enables runtime assertions in KVM's MMU that are too costly to enable
> @@ -228,7 +228,7 @@ config KVM_EXTERNAL_WRITE_TRACKING
>
>  config KVM_MAX_NR_VCPUS
>         int "Maximum number of vCPUs per KVM guest"
> -       depends on KVM
> +       depends on KVM_X86
>         range 1024 4096
>         default 4096 if MAXSMP
>         default 1024
> --
> 2.50.1.552.g942d659e1b-goog
>


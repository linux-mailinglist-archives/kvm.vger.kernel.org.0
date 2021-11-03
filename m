Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7834444266
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 14:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhKCNbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 09:31:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230282AbhKCNbU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 09:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635946123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vMS7oHTgkCX9bZnQFpsagj1XvoC8N4CL6QUvFHOk+a8=;
        b=i2bIqlkLnuPVdga5hr47NSrK+LSYRSo7WMsr9Dmj85BLYoz5FbDmTjkF2uJruei6NRMlsR
        8R0xXjvpvNzzVPC9thkotC3Afz/cV2TzdcXFM9uEvgEPhZxLgfJNqilLXGQShlc7/Q0enn
        cbzZwBjBaClTB6dhKC229uHcEq/RTZ4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-ta2XxH73O5a9gdR1vJp9Sw-1; Wed, 03 Nov 2021 09:28:42 -0400
X-MC-Unique: ta2XxH73O5a9gdR1vJp9Sw-1
Received: by mail-wm1-f70.google.com with SMTP id 144-20020a1c0496000000b003305ac0e03aso2748396wme.8
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 06:28:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vMS7oHTgkCX9bZnQFpsagj1XvoC8N4CL6QUvFHOk+a8=;
        b=jpu4ANSKrnaFhbI8hZ72EZRUdbcWgzFSJoHFRjCKLjckd6JkH5UCuPgakIwL0ZjT3U
         Ijzeg6T9asyalVSQBlX/xLSNSSRaDCx60qU/PgMzjkw5wkt2z6s27gCVpHYGBrwWbnzs
         a4Ct1jFz9zGeBEJW3hYbzXP6nqeBCZgRYeInbkdu/JSr44807ap4gaweERz3/PAEjkgQ
         f5/UsLz1W/iH9aUxrCSxQzZmoUMRyNVfaozJV5oGgSZ9BEBbOfCm8sQ//q070DXVsvVH
         eyS34CMG+law9dIkFd6WYF0sO4jQKmPxt59/Lypl7ofdcEb+pgS0hSTFndFO1Httql5j
         ElGw==
X-Gm-Message-State: AOAM530wKMtIv6ETW/5PGa2KwK1VWdQOmP2vIdDtuyAJGJUwR8bkOrBs
        L/71ZmJOxXNVYBW3k8etdWu2yR5WANjLwKGvrwWuaRnwueTYZeteLWpK4cifrIGcc7gLw+b9hP4
        LYLPcPsDvHLnk
X-Received: by 2002:a5d:604b:: with SMTP id j11mr33657974wrt.22.1635946121421;
        Wed, 03 Nov 2021 06:28:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJRal0gtOcYhkrlX+fWSK/Zij8Wr/Lzf7bKrSPyKYcdDmszMmp1xspWaMgtBwrJ5oXebJcsw==
X-Received: by 2002:a5d:604b:: with SMTP id j11mr33657952wrt.22.1635946121250;
        Wed, 03 Nov 2021 06:28:41 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y7sm1917658wrw.55.2021.11.03.06.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 06:28:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ
 active
In-Reply-To: <20211103094255.426573-1-mlevitsk@redhat.com>
References: <20211103094255.426573-1-mlevitsk@redhat.com>
Date:   Wed, 03 Nov 2021 14:28:39 +0100
Message-ID: <871r3xnzaw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> KVM_GUESTDBG_BLOCKIRQ relies on interrupts being injected using
> standard kvm's inject_pending_event, and not via APICv/AVIC.
>
> Since this is a debug feature, just inhibit it while it
> is in use.
>
> Fixes: 61e5f69ef0837 ("KVM: x86: implement KVM_GUESTDBG_BLOCKIRQ")
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/avic.c         | 3 ++-
>  arch/x86/kvm/vmx/vmx.c          | 3 ++-
>  arch/x86/kvm/x86.c              | 3 +++
>  4 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 88fce6ab4bbd7..8f6e15b95a4d8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1034,6 +1034,7 @@ struct kvm_x86_msr_filter {
>  #define APICV_INHIBIT_REASON_IRQWIN     3
>  #define APICV_INHIBIT_REASON_PIT_REINJ  4
>  #define APICV_INHIBIT_REASON_X2APIC	5
> +#define APICV_INHIBIT_REASON_BLOCKIRQ	6
>  
>  struct kvm_arch {
>  	unsigned long n_used_mmu_pages;
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 8052d92069e01..affc0ea98d302 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -904,7 +904,8 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
>  			  BIT(APICV_INHIBIT_REASON_NESTED) |
>  			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
>  			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
> -			  BIT(APICV_INHIBIT_REASON_X2APIC);
> +			  BIT(APICV_INHIBIT_REASON_X2APIC) |
> +			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
>  
>  	return supported & BIT(bit);
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 71f54d85f104c..e4fc9ff7cd944 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7565,7 +7565,8 @@ static void hardware_unsetup(void)
>  static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>  {
>  	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
> -			  BIT(APICV_INHIBIT_REASON_HYPERV);
> +			  BIT(APICV_INHIBIT_REASON_HYPERV) |
> +			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
>  
>  	return supported & BIT(bit);
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ac83d873d65b0..dccf927baa4dd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10747,6 +10747,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
>  		vcpu->arch.singlestep_rip = kvm_get_linear_rip(vcpu);
>  
> +	kvm_request_apicv_update(vcpu->kvm,
> +				 !(vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ),
> +				 APICV_INHIBIT_REASON_BLOCKIRQ);
>  	/*
>  	 * Trigger an rflags update that will inject or remove the trace
>  	 * flags.

This fixes the problem for me!

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


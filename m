Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF10444C342
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 15:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhKJOqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 09:46:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231593AbhKJOqs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 09:46:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636555440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WMk4HXudwkyLM6N79xQ3HQrH3t9EJVFqOyMYGOZY8dw=;
        b=RFBvMfHxSCpvW/ZvTSfkyMKXstYoSUpjeVq2Dbf7WW1/kFEipa/2EuS8F/745ZStK72LqQ
        LEiGPlgXCHyljLQXjFZMazr7OAwABkH9nt6oKOPcyXUSEiSeh7DFwaxgCtXlwEihDoT56Y
        AtIWjaXyg4INetcUzFRjEeOq/t2zA5M=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-0_-5ojIkPXWP3klUUFH89g-1; Wed, 10 Nov 2021 09:43:59 -0500
X-MC-Unique: 0_-5ojIkPXWP3klUUFH89g-1
Received: by mail-ed1-f72.google.com with SMTP id o15-20020a056402438f00b003e32b274b24so2474936edc.21
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 06:43:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WMk4HXudwkyLM6N79xQ3HQrH3t9EJVFqOyMYGOZY8dw=;
        b=US/jt56axN7ksF/WlbKSoTZ4DaLFZoToAKD/wXsQgBy+55LqkrMdCvpFw2yaxFF+13
         7n0DMZoPg76VtJNwFNCht9s24cb3sOjBLAqV9dlXpU5iXdbG+9k1iF4LndH98g7ZNJHG
         rWE3X91W34kB+pUS3DG+zywpm2FHDQQXa81eVi1fd44PYv1cfZ70n7RmWYY6a0I/gXFd
         /8+2bzOaA+tXX7OmdtgzQRXqK0+6w/gm7E0Rca8u78oGLhjoWlxUYHOfI5vKShYZQ3hK
         lkwAlG0ECyrWhA/5nnePIOzABt7EnaRpxcHk2izTfEhXvnGXmYEMy8yoa6J/qdgwr3gd
         i3+Q==
X-Gm-Message-State: AOAM533cFsNvmoiSHWJ366UQHfQ9IS7pFwb3dMJuMWaRDlCQuCu9o8mO
        kYavjiSH/14E37HNVlteoAu12vK99xogWJ3AswSZCMdCW/dP5GzaWzePX53r0ZTQLHpq9c+tikp
        Pnba5OcZCowss
X-Received: by 2002:a05:6402:2792:: with SMTP id b18mr79714ede.245.1636555437730;
        Wed, 10 Nov 2021 06:43:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz4oq0ZAKEFdg9lWcdWFm2W0Iow9/jxIAvs2wP5wPmmSiK+XGT6Rn+FfgAIFkLwTkXNtuOhcQ==
X-Received: by 2002:a05:6402:2792:: with SMTP id b18mr79675ede.245.1636555437490;
        Wed, 10 Nov 2021 06:43:57 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id hv17sm7955609ejc.66.2021.11.10.06.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:43:56 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 1/3] KVM: nVMX: extract calculation of the L1's EFER
In-Reply-To: <20211110100018.367426-2-mlevitsk@redhat.com>
References: <20211110100018.367426-1-mlevitsk@redhat.com>
 <20211110100018.367426-2-mlevitsk@redhat.com>
Date:   Wed, 10 Nov 2021 15:43:55 +0100
Message-ID: <87tugkm5p0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> This will be useful in the next patch.

Nitpick: "the next patch" may not be what you expect after merge/when
backporting/... so it's better to call things out explicityly, something
like:

"The newly introduced nested_vmx_get_vmcs12_host_efer() helper will be
used when nested state is restored in vmx_set_nested_state()".

>
> No functional change intended.
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b4ee5e9f9e201..49ae96c0cc4d1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4228,6 +4228,21 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	kvm_clear_interrupt_queue(vcpu);
>  }
>  
> +/*
> + * Given vmcs12, return the expected L1 value of IA32_EFER
> + * after VM exit from that vmcs12
> + */
> +static inline u64 nested_vmx_get_vmcs12_host_efer(struct kvm_vcpu *vcpu,
> +						  struct vmcs12 *vmcs12)
> +{
> +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
> +		return vmcs12->host_ia32_efer;
> +	else if (vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)
> +		return vcpu->arch.efer | (EFER_LMA | EFER_LME);
> +	else
> +		return vcpu->arch.efer & ~(EFER_LMA | EFER_LME);
> +}
> +
>  /*
>   * A part of what we need to when the nested L2 guest exits and we want to
>   * run its L1 parent, is to reset L1's guest state to the host state specified
> @@ -4243,12 +4258,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  	enum vm_entry_failure_code ignored;
>  	struct kvm_segment seg;
>  
> -	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
> -		vcpu->arch.efer = vmcs12->host_ia32_efer;
> -	else if (vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)
> -		vcpu->arch.efer |= (EFER_LMA | EFER_LME);
> -	else
> -		vcpu->arch.efer &= ~(EFER_LMA | EFER_LME);
> +	vcpu->arch.efer = nested_vmx_get_vmcs12_host_efer(vcpu, vmcs12);
>  	vmx_set_efer(vcpu, vcpu->arch.efer);
>  
>  	kvm_rsp_write(vcpu, vmcs12->host_rsp);

-- 
Vitaly


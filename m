Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5705718E92D
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 14:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgCVNiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 09:38:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:28925 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgCVNiA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 22 Mar 2020 09:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584884278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2GuvjGXk9RjsgHc8J4qtgc0NzvRfPOmRjXcou1INlWA=;
        b=fom7hRClYw8A+zF1ciCTjN2GTULddsmbhh0Ewbu6DWWZheLgZB8IVq4z1WpH4f7t+LmMHg
        O6BrUSDSVvLv5LJk9bMsiQwFV3KcJAtRQpiQfGciXB67OQlQ7v8sHNb52W/pYHAoUpXLLD
        hyPe7LRMPBRv1Y7nN3XiB486q/ppBt8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-dszr0YFVNhGnQi2pt-O2fA-1; Sun, 22 Mar 2020 09:37:54 -0400
X-MC-Unique: dszr0YFVNhGnQi2pt-O2fA-1
Received: by mail-wr1-f70.google.com with SMTP id r9so3693880wrs.13
        for <kvm@vger.kernel.org>; Sun, 22 Mar 2020 06:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2GuvjGXk9RjsgHc8J4qtgc0NzvRfPOmRjXcou1INlWA=;
        b=pGNBBecuJTefHsojthcFM0rsu0Z+mDZLgAut9LsvRkBGfJz6vd3bHHkkLxSmeQne0F
         ViBBIlfenWSLa4uW6dSD5fBYPvVGhiqK5A2VZUetEB0mbhLFzCQ4/veYWnJ5EmvjzbPr
         XXkcao9BOhoCal/0265les2vX41NiW15G5CTIJGef80cR0ms2ZQT4aSyU9sePE71P5gA
         ZCTkl1op8HLRtpR7yF4J4h9OoA20MigeRo55JDhNVUzn9ujR52YMdYy2Q4ZkYNbc12MW
         7aPLsjjialDck2rDozQD6fKshO1Btqtk8cAmeiTBn2ZiHKhBNB6bRuHyPBKmAJLQrUkY
         FRPg==
X-Gm-Message-State: ANhLgQ0WVjxJc3DyagL3k7x6YZEQHNWFk/AbpZMU10JUJ/6Xj9ppWsVm
        1aetNpi4+8CGmDD+5ITsdc91PUd49bIHdLlWd/AiaCIbxdJdwcvwlFVUA/OPP4nJM1EhYz061fj
        bhKjrYbSX0Cky
X-Received: by 2002:adf:e60b:: with SMTP id p11mr22708431wrm.140.1584884272726;
        Sun, 22 Mar 2020 06:37:52 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs03y3pVKRYbTeAT36KRES6FOZECQoomDnyeqBy0FVIgahIetvBQmSCdFAeNUXvH2fKP/d9Sg==
X-Received: by 2002:adf:e60b:: with SMTP id p11mr22708417wrm.140.1584884272438;
        Sun, 22 Mar 2020 06:37:52 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g1sm4191923wro.28.2020.03.22.06.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 06:37:51 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: VMX: Gracefully handle faults on VMXON
In-Reply-To: <20200321193751.24985-4-sean.j.christopherson@intel.com>
References: <20200321193751.24985-1-sean.j.christopherson@intel.com> <20200321193751.24985-4-sean.j.christopherson@intel.com>
Date:   Sun, 22 Mar 2020 14:37:50 +0100
Message-ID: <87d094bjdd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Gracefully handle faults on VMXON, e.g. #GP due to VMX being disabled by
> BIOS, instead of letting the fault crash the system.  Now that KVM uses
> cpufeatures to query support instead of reading MSR_IA32_FEAT_CTL
> directly, it's possible for a bug in a different subsystem to cause KVM
> to incorrectly attempt VMXON[*].  Crashing the system is especially
> annoying if the system is configured such that hardware_enable() will
> be triggered during boot.
>
> Oppurtunistically rename @addr to @vmxon_pointer and use a named param
> to reference it in the inline assembly.
>
> Print 0xdeadbeef in the ultra-"rare" case that reading MSR_IA32_FEAT_CTL
> also faults.
>
> [*] https://lkml.kernel.org/r/20200226231615.13664-1-sean.j.christopherson@intel.com
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 07634caa560d..3aba51d782e2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2218,18 +2218,33 @@ static __init int vmx_disabled_by_bios(void)
>  	       !boot_cpu_has(X86_FEATURE_VMX);
>  }
>  
> -static void kvm_cpu_vmxon(u64 addr)
> +static int kvm_cpu_vmxon(u64 vmxon_pointer)
>  {
> +	u64 msr;
> +
>  	cr4_set_bits(X86_CR4_VMXE);
>  	intel_pt_handle_vmx(1);
>  
> -	asm volatile ("vmxon %0" : : "m"(addr));
> +	asm_volatile_goto("1: vmxon %[vmxon_pointer]\n\t"
> +			  _ASM_EXTABLE(1b, %l[fault])
> +			  : : [vmxon_pointer] "m"(vmxon_pointer)
> +			  : : fault);
> +	return 0;
> +
> +fault:
> +	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
> +		  rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);

We seem to be acting under an assumption that the fault is (likelt)
caused my disabled VMX feature but afaics the fault can be caused by
passing a bogus pointer too (but that would be a KVM bug, of course).

> +	intel_pt_handle_vmx(0);
> +	cr4_clear_bits(X86_CR4_VMXE);
> +
> +	return -EFAULT;
>  }
>  
>  static int hardware_enable(void)
>  {
>  	int cpu = raw_smp_processor_id();
>  	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
> +	int r;
>  
>  	if (cr4_read_shadow() & X86_CR4_VMXE)
>  		return -EBUSY;
> @@ -2246,7 +2261,10 @@ static int hardware_enable(void)
>  	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
>  	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
>  
> -	kvm_cpu_vmxon(phys_addr);
> +	r = kvm_cpu_vmxon(phys_addr);
> +	if (r)
> +		return r;
> +
>  	if (enable_ept)
>  		ept_sync_global();

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


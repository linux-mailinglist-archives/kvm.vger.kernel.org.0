Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D282496B17
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 09:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiAVIrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 03:47:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229482AbiAVIrn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 22 Jan 2022 03:47:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642841262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGN4qqFYiv0lpiiUFsTnq5KQGW53nV75SIlvAOABdv8=;
        b=dT7WTWlZK1GGj9F9X5zol6Qw20xWJ3QxTRFhTxySRW1uRMv9SNreWEuzwk6n058GIzO9NX
        HOPRV1MWRWBoPoWPeY+8ageSEwtYBpde8j2vsIGJvOUKercEMNDIffc+C+f0Xa8R9WzzOE
        EwpahXBIWQd5nIew/ZupCjsw4qpTeFI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-odLQm53VOn2VrmmY2syBBw-1; Sat, 22 Jan 2022 03:47:41 -0500
X-MC-Unique: odLQm53VOn2VrmmY2syBBw-1
Received: by mail-wr1-f72.google.com with SMTP id r27-20020adfb1db000000b001d7567e33baso842927wra.12
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 00:47:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iGN4qqFYiv0lpiiUFsTnq5KQGW53nV75SIlvAOABdv8=;
        b=tdNfNe3bP2OUR/MnxXtZyuy/HzXDBWoL9NKcjebjpmpK1kUxAhssZ4LUfqPOo+IJrZ
         llGQAUYjNYtElHKRjf6GwJxFv3cigvuY3ZDguFqX+Ew9COCBOoQGc2+uO2DP64mqhuIY
         Q3y5nhUr6YkirGDNuOR7XnNQKGinxHHlUPZLhgcGXg36uYwohvruKKcq+XezRVXN7VlM
         9ASZJKVE53eOMOj+F1v9+Z1ok0DKGSoEQUPiYtqyl7aQi+N5DRBQHPnHFFc9s/lSNc2L
         Q360VpZ6RR3TMpKjIYPqaVMiOj0RVoFJqljKRE++6uOdkWNWGbz6Yjdo46S1VFcgQ7hm
         cn5A==
X-Gm-Message-State: AOAM532nv652Odv5gIrq3/2Hjui34m8wcgrxgl3cMfffUlRa0CK7E4h7
        iXmIwXcwu4ZgnnLLQqimQFiacCjxpHa2THEQEbZMgxP+E/WHje2lp14neR/XnIENTSqnycRnUbp
        0E43ABU6gOvOW
X-Received: by 2002:adf:9f14:: with SMTP id l20mr6793367wrf.65.1642841259930;
        Sat, 22 Jan 2022 00:47:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7SV8+A5JIpyNSQkYvEz5OrginBETLq8ApjSAS4DgxW3t8BvqQP+dgvekHt5uF/fSwWMErbA==
X-Received: by 2002:adf:9f14:: with SMTP id l20mr6793347wrf.65.1642841259709;
        Sat, 22 Jan 2022 00:47:39 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f8sm7752202wmg.44.2022.01.22.00.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 00:47:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: Re: [PATCH] KVM: VMX: Zero host's SYSENTER_ESP iff SYSENTER is NOT
 used
In-Reply-To: <20220122015211.1468758-1-seanjc@google.com>
References: <20220122015211.1468758-1-seanjc@google.com>
Date:   Sat, 22 Jan 2022 09:47:38 +0100
Message-ID: <8735lgjgwl.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Zero vmcs.HOST_IA32_SYSENTER_ESP when initializing *constant* host state
> if and only if SYSENTER cannot be used, i.e. the kernel is a 64-bit
> kernel and is not emulating 32-bit syscalls.  As the name suggests,
> vmx_set_constant_host_state() is intended for state that is *constant*.
> When SYSENTER is used, SYSENTER_ESP isn't constant because stacks are
> per-CPU, and the VMCS must be updated whenever the vCPU is migrated to a
> new CPU.  The logic in vmx_vcpu_load_vmcs() doesn't differentiate between
> "never loaded" and "loaded on a different CPU", i.e. setting SYSENTER_ESP
> on VMCS load also handles setting correct host state when the VMCS is
> first loaded.
>
> Because a VMCS must be loaded before it is initialized during vCPU RESET,
> zeroing the field in vmx_set_constant_host_state() obliterates the value
> that was written when the VMCS was loaded.  If the vCPU is run before it
> is migrated, the subsequent VM-Exit will zero out MSR_IA32_SYSENTER_ESP,
> leading to a #DF on the next 32-bit syscall.
>
>   double fault: 0000 [#1] SMP
>   CPU: 0 PID: 990 Comm: stable Not tainted 5.16.0+ #97
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   EIP: entry_SYSENTER_32+0x0/0xe7
>   Code: <9c> 50 eb 17 0f 20 d8 a9 00 10 00 00 74 0d 25 ff ef ff ff 0f 22 d8
>   EAX: 000000a2 EBX: a8d1300c ECX: a8d13014 EDX: 00000000
>   ESI: a8f87000 EDI: a8d13014 EBP: a8d12fc0 ESP: 00000000
>   DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00210093
>   CR0: 80050033 CR2: fffffffc CR3: 02c3b000 CR4: 00152e90
>
> Fixes: 6ab8a4053f71 ("KVM: VMX: Avoid to rdmsrl(MSR_IA32_SYSENTER_ESP)")
> Cc: Lai Jiangshan <laijs@linux.alibaba.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a02a28ce7cc3..ce2aae12fcc5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4094,10 +4094,13 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
>  	vmcs_write32(HOST_IA32_SYSENTER_CS, low32);
>  
>  	/*
> -	 * If 32-bit syscall is enabled, vmx_vcpu_load_vcms rewrites
> -	 * HOST_IA32_SYSENTER_ESP.
> +	 * SYSENTER is used only for (emulating) 32-bit kernels, zero out
> +	 * SYSENTER.ESP if it is NOT used.  When SYSENTER is used, the per-CPU
> +	 * stack is set when the VMCS is loaded (and may already be set!).

For an unprepared reader, I'd suggest adding something like "This pairs
with how HOST_IA32_SYSENTER_ESP is written in vmx_vcpu_load_vmcs()".

>  	 */
> -	vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);
> +	if (!IS_ENABLED(CONFIG_IA32_EMULATION) && !IS_ENABLED(CONFIG_X86_32))

Isn't it the same as "!IS_ENABLED(CONFIG_COMPAT_32)"? (same goes to the
check in vmx_vcpu_load_vmcs())

> +		vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);
> +
>  	rdmsrl(MSR_IA32_SYSENTER_EIP, tmpl);
>  	vmcs_writel(HOST_IA32_SYSENTER_EIP, tmpl);   /* 22.2.3 */
>  

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


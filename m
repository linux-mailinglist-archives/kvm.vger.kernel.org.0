Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96011443F70
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 10:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhKCJet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 05:34:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231906AbhKCJeq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 05:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635931930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HXwpnkGi8E1tecrDeHdASgGseLR/pV5+X21g3UrIJX0=;
        b=CNP4Kxsy2XFaeCohXZeLAjZy9to+Qj+URSrN6sCySX4BPYZrN1Qha6+r59EVFOgsASLQpD
        g0lNlionHWKsme1XBpVM1+29vEk1X269Zw5cv5My30wp4rTP6bdBrcown+x2gspPiT/h0V
        e65GTNrZEnlCPI+/BcoLlOd+tUlUXio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-61hBb0CdPaa9GQe4Bh2JFw-1; Wed, 03 Nov 2021 05:32:07 -0400
X-MC-Unique: 61hBb0CdPaa9GQe4Bh2JFw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B896DBBEF7;
        Wed,  3 Nov 2021 09:32:00 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE9BD19723;
        Wed,  3 Nov 2021 09:31:56 +0000 (UTC)
Message-ID: <c6477e5bfb67f2a939a8f62cb22e48c14587a75c.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ
 active
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Wed, 03 Nov 2021 11:31:55 +0200
In-Reply-To: <20211103092912.425128-1-mlevitsk@redhat.com>
References: <e508be0ecda6db330d83b954f4e4d1ad12c08c64.camel@redhat.com>
         <20211103092912.425128-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-11-03 at 11:29 +0200, Maxim Levitsky wrote:
> KVM_GUESTDBG_BLOCKIRQ relies on interrupts being injected using
> standard kvm's inject_pending_event, and not via APICv/AVIC.
> 
> Since this is a debug feature, just inhibit it while it
> is in use.
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
> index ac83d873d65b0..eb3b8d2375713 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10747,6 +10747,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
>  		vcpu->arch.singlestep_rip = kvm_get_linear_rip(vcpu);
>  
> +	kvm_request_apicv_update(vcpu->kvm,
> +			!(vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ),
> +			APICV_INHIBIT_REASON_BLOCKIRQ);
I need more coffee, bad indention here :)

Could you test if this patch works for you?

I managed to reproduce this issue on AVIC, by patching out the x2apic inhibit,
and then this patch fixed the issue for me.


Best regards,
	Maxim Levitsky

>  	/*
>  	 * Trigger an rflags update that will inject or remove the trace
>  	 * flags.



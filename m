Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5BB44113E
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 23:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhJaWdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 18:33:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230462AbhJaWdU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 18:33:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635719447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjQhiLyEbEDnD4Y2r5pZNoATO4AoPvr4JeskA/KrBlI=;
        b=SUFLLT5y35wVl+Sbp3cp6lFvpioFLpYP9H5KMuQRqR/dKhq88EjnVNluwdfOEaYb1hPq4z
        ZnihoZrBb1CLgOrRSkCsYAm2Wff3NFIevltj6ky3DB3cRPZJkzRYj06H4f2F20UMrO4wOt
        Iip+acYrb41i3DqB0YaJ7jPLF+cBZBo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-e9ofhHeAOOizUfULmvajlw-1; Sun, 31 Oct 2021 18:30:42 -0400
X-MC-Unique: e9ofhHeAOOizUfULmvajlw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB52D18125C0;
        Sun, 31 Oct 2021 22:30:38 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8110517155;
        Sun, 31 Oct 2021 22:30:08 +0000 (UTC)
Message-ID: <ffce26d0540acb7550be719255689b61210919c1.camel@redhat.com>
Subject: Re: [PATCH v2 42/43] KVM: VMX: Fold fallback path into triggering
 posted IRQ helper
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Date:   Mon, 01 Nov 2021 00:30:07 +0200
In-Reply-To: <20211009021236.4122790-43-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-43-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Move the fallback "wake_up" path into the helper to trigger posted
> interrupt helper now that the nested and non-nested paths are identical.

Nit: I think you refer to patch 41 here, but I think that nested and non nested paths were identical
before as well, so this patch could be done without patch 41 as well.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f505fee3cf5c..b0d97cf18c34 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3927,7 +3927,7 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
>  	pt_update_intercept_for_msr(vcpu);
>  }
>  
> -static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
> +static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
>  						     int pi_vec)
>  {
>  #ifdef CONFIG_SMP
> @@ -3958,10 +3958,15 @@ static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
>  		 */
>  
>  		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
> -		return true;
> +		return;
>  	}
>  #endif
> -	return false;
> +	/*
> +	 * The vCPU isn't in the guest; wake the vCPU in case it is blocking,
> +	 * otherwise do nothing as KVM will grab the highest priority pending
> +	 * IRQ via ->sync_pir_to_irr() in vcpu_enter_guest().
> +	 */
> +	kvm_vcpu_wake_up(vcpu);
>  }
>  
>  static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
> @@ -3984,8 +3989,7 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
>  		 */
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
>  		/* the PIR and ON have been set by L1. */
> -		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_NESTED_VECTOR))
> -			kvm_vcpu_wake_up(vcpu);
> +		kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_NESTED_VECTOR);
>  		return 0;
>  	}
>  	return -1;
> @@ -4022,9 +4026,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
>  	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
>  	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
>  	 */
> -	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR))
> -		kvm_vcpu_wake_up(vcpu);
> -
> +	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
>  	return 0;
>  }
>  



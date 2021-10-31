Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECA6441135
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 23:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhJaW2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 18:28:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhJaW2X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 18:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635719150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SbOGjXYHIaVWWvxDmyY/7NrfjCgFCeLG7KQq/v0+M1g=;
        b=LFX9W4Orb+uJ6iG3CoroROdTkqnHSqiIs7Z3bXZNjXabTY6WrT3eKlaT+CGEORIB5c6t0A
        5/otLuEz+DzX1BFuRQNrTbgu4ANQYHyvusWUzhEHmmDcMpyvoh7xvZR8GuVa6EnE0ilQQp
        sn7ZeS92W0j2QQDrl7HurhgwyGOIFDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-CLsFAk3fN5iz-7DE45UL9g-1; Sun, 31 Oct 2021 18:25:47 -0400
X-MC-Unique: CLsFAk3fN5iz-7DE45UL9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 058441006AA2;
        Sun, 31 Oct 2021 22:25:44 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E30CC5DD68;
        Sun, 31 Oct 2021 22:25:26 +0000 (UTC)
Message-ID: <0e6e3ed2831a01f5dad9f51b83f3bd1a3c318847.camel@redhat.com>
Subject: Re: [PATCH v2 41/43] KVM: VMX: Pass desired vector instead of bool
 for triggering posted IRQ
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
Date:   Mon, 01 Nov 2021 00:25:25 +0200
In-Reply-To: <20211009021236.4122790-42-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-42-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Refactor the posted interrupt helper to take the desired notification
> vector instead of a bool so that the callers are self-documenting.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 78c8bc7f1b3b..f505fee3cf5c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3928,11 +3928,9 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
>  }
>  
>  static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
> -						     bool nested)
> +						     int pi_vec)
>  {
>  #ifdef CONFIG_SMP
> -	int pi_vec = nested ? POSTED_INTR_NESTED_VECTOR : POSTED_INTR_VECTOR;
> -
>  	if (vcpu->mode == IN_GUEST_MODE) {
>  		/*
>  		 * The vector of interrupt to be delivered to vcpu had
> @@ -3986,7 +3984,7 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
>  		 */
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
>  		/* the PIR and ON have been set by L1. */
> -		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true))
> +		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_NESTED_VECTOR))
>  			kvm_vcpu_wake_up(vcpu);
>  		return 0;
>  	}
> @@ -4024,7 +4022,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
>  	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
>  	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
>  	 */
> -	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> +	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR))
>  		kvm_vcpu_wake_up(vcpu);
>  
>  	return 0;

I both like and don't like this patch.

It is indeed a bit more more self documented, but then it allows caller to
pass anything other than POSTED_INTR_NESTED_VECTOR/POSTED_INTR_VECTOR which
would fail.

Maybe addd an assert?

I won't do bikesheddding about this though, so

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


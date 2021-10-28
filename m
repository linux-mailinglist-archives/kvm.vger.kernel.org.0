Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CB243E000
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 13:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhJ1LbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 07:31:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230225AbhJ1LbT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 07:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635420532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MHpIfrYfSW8Oruu5gZzONXfOs5cqhayPI05VEPrlFqI=;
        b=ZXK1SsScmTgtnETpIVi2QXHMMs18RzTZPLNJsMQPBJZrv9133Un6zEiD04wYDmRLk8iqrN
        iuZX4yT7S6TUZoHT9hESffo8pukWCq5lQV0yzXImlSkMPgQqKPN/CyfuhIr/OGE6dxfDS+
        vegJ1oDUxlGxo3f0//TYGU5zmJ/np9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-eJZbxn5mNyK61ySDSBCRrA-1; Thu, 28 Oct 2021 07:28:46 -0400
X-MC-Unique: eJZbxn5mNyK61ySDSBCRrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF9359F92B;
        Thu, 28 Oct 2021 11:28:42 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 108AF5DA61;
        Thu, 28 Oct 2021 11:28:30 +0000 (UTC)
Message-ID: <643d9c249b5863f04290a6f047ea1a2d98bd75f9.camel@redhat.com>
Subject: Re: [PATCH v2 27/43] KVM: VMX: Move Posted Interrupt ndst
 computation out of write loop
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
Date:   Thu, 28 Oct 2021 14:28:29 +0300
In-Reply-To: <20211009021236.4122790-28-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-28-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Hoist the CPU => APIC ID conversion for the Posted Interrupt descriptor
> out of the loop to write the descriptor, preemption is disabled so the
> CPU won't change, and if the APIC ID changes KVM has bigger problems.
> 
> No functional change intended.

Is preemption always disabled in vmx_vcpu_pi_load? vmx_vcpu_pi_load is called from vmx_vcpu_load,
which is called indirectly from vcpu_load which is called from many ioctls,
which userspace does. In these places I don't think that preemption is disabled.

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index fea343dcc011..2b2206339174 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -51,17 +51,15 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  		goto after_clear_sn;
>  	}
>  
> -	/* The full case.  */
> +	/* The full case.  Set the new destination and clear SN. */
> +	dest = cpu_physical_id(cpu);
> +	if (!x2apic_mode)
> +		dest = (dest << 8) & 0xFF00;
> +
>  	do {
>  		old.control = new.control = READ_ONCE(pi_desc->control);
>  
> -		dest = cpu_physical_id(cpu);
> -
> -		if (x2apic_mode)
> -			new.ndst = dest;
> -		else
> -			new.ndst = (dest << 8) & 0xFF00;
> -
> +		new.ndst = dest;
>  		new.sn = 0;
>  	} while (cmpxchg64(&pi_desc->control, old.control,
>  			   new.control) != old.control);
> @@ -103,15 +101,14 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>  	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
>  	     "Wakeup handler not enabled while the vCPU was blocking");
>  
> +	dest = cpu_physical_id(vcpu->cpu);
> +	if (!x2apic_mode)
> +		dest = (dest << 8) & 0xFF00;
> +
>  	do {
>  		old.control = new.control = READ_ONCE(pi_desc->control);
>  
> -		dest = cpu_physical_id(vcpu->cpu);
> -
> -		if (x2apic_mode)
> -			new.ndst = dest;
> -		else
> -			new.ndst = (dest << 8) & 0xFF00;
> +		new.ndst = dest;
>  
>  		/* set 'NV' to 'notification vector' */
>  		new.nv = POSTED_INTR_VECTOR;



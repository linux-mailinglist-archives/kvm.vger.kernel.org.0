Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A763C43E3E2
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 16:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhJ1Oiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 10:38:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230258AbhJ1Oix (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 10:38:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635431785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rIPy/P0MkwnX24RiVT8XHV56FyrWxedIt/Yy+pyq4E4=;
        b=SMD62PWblhhSX3tgimyLNIpB0WRIOMAOHYQsaYHKx4YxY6WRgW7MgaKl5K04QM3eB+BQbI
        k0iJmCkaKISRTbcw8khw3rq68sCs6If63Np0xpG5MhsvBTCWPutOgwQy+2Axy1UPAQeGQd
        42ItOmFYMlP3kboAvnX4I921aL9wImc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-LuCRe9MpMnC4avaZ8uFX4w-1; Thu, 28 Oct 2021 10:36:24 -0400
X-MC-Unique: LuCRe9MpMnC4avaZ8uFX4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE73C10A8E01;
        Thu, 28 Oct 2021 14:36:19 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18EDF100EA05;
        Thu, 28 Oct 2021 14:36:03 +0000 (UTC)
Message-ID: <33860db1f4951386347913d126ef7c8bc1655440.camel@redhat.com>
Subject: Re: [PATCH v2 22/43] KVM: VMX: Drop unnecessary PI logic to handle
 impossible conditions
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
Date:   Thu, 28 Oct 2021 17:36:02 +0300
In-Reply-To: <20211009021236.4122790-23-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-23-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Drop sanity checks on the validity of the previous pCPU when handling
> vCPU block/unlock for posted interrupts.  Barring a code bug or memory
> corruption, the sanity checks will never fire, and any code bug that does
> trip the WARN is all but guaranteed to completely break posted interrupts,
> i.e. should never get anywhere near production.
> 
> This is the first of several steps toward eliminating kvm_vcpu.pre_cpu.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 67cbe6ab8f66..6c2110d91b06 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -118,12 +118,10 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>  	} while (cmpxchg64(&pi_desc->control, old.control,
>  			   new.control) != old.control);
>  
> -	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
> -		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -		list_del(&vcpu->blocked_vcpu_list);
> -		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -		vcpu->pre_pcpu = -1;
> -	}
> +	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	list_del(&vcpu->blocked_vcpu_list);
> +	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	vcpu->pre_pcpu = -1;
>  }
>  
>  /*
> @@ -153,14 +151,12 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  
>  	WARN_ON(irqs_disabled());
>  	local_irq_disable();
> -	if (!WARN_ON_ONCE(vcpu->pre_pcpu != -1)) {
> -		vcpu->pre_pcpu = vcpu->cpu;
> -		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -		list_add_tail(&vcpu->blocked_vcpu_list,
> -			      &per_cpu(blocked_vcpu_on_cpu,
> -				       vcpu->pre_pcpu));
> -		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -	}
> +
> +	vcpu->pre_pcpu = vcpu->cpu;
> +	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	list_add_tail(&vcpu->blocked_vcpu_list,
> +		      &per_cpu(blocked_vcpu_on_cpu, vcpu->pre_pcpu));
> +	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
>  
>  	WARN(pi_desc->sn == 1,
>  	     "Posted Interrupt Suppress Notification set before blocking");



Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>




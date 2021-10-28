Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0110743DF98
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 12:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhJ1LB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 07:01:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhJ1LB0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 07:01:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635418739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSSD6JYIIX/+OAHh3pR71NKYzpuBAvVzGPZ/3rAMc5k=;
        b=aygBQ52FdVuXhyMYAXyAnpMixAhee9mwMA5CGVvAD4A63S61wvsAOCepyVBmb4kQONsAPh
        oRz7p1w0xZB/uvADqhApVX+sN8TCwoFKGxDRj/1jupGU3Yx7BWW5ZKOXJ4lc98PvZqkp5T
        333mfIMalZNY9zJ7d1FglKjeXD6S5K8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-pBYTSTgoPK2ouWzH2IV0xA-1; Thu, 28 Oct 2021 06:58:56 -0400
X-MC-Unique: pBYTSTgoPK2ouWzH2IV0xA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C6BC10A8E02;
        Thu, 28 Oct 2021 10:58:53 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9D4B19D9F;
        Thu, 28 Oct 2021 10:58:41 +0000 (UTC)
Message-ID: <b078cce30f86672d7d8f8eaa0adc47d24def24e2.camel@redhat.com>
Subject: Re: [PATCH v2 26/43] KVM: VMX: Read Posted Interrupt "control"
 exactly once per loop iteration
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
Date:   Thu, 28 Oct 2021 13:58:40 +0300
In-Reply-To: <20211009021236.4122790-27-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-27-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Use READ_ONCE() when loading the posted interrupt descriptor control
> field to ensure "old" and "new" have the same base value.  If the
> compiler emits separate loads, and loads into "new" before "old", KVM
> could theoretically drop the ON bit if it were set between the loads.
> 
> Fixes: 28b835d60fcc ("KVM: Update Posted-Interrupts Descriptor when vCPU is preempted")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 414ea6972b5c..fea343dcc011 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -53,7 +53,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  	/* The full case.  */
>  	do {
> -		old.control = new.control = pi_desc->control;
> +		old.control = new.control = READ_ONCE(pi_desc->control);
>  
>  		dest = cpu_physical_id(cpu);
>  
> @@ -104,7 +104,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>  	     "Wakeup handler not enabled while the vCPU was blocking");
>  
>  	do {
> -		old.control = new.control = pi_desc->control;
> +		old.control = new.control = READ_ONCE(pi_desc->control);
>  
>  		dest = cpu_physical_id(vcpu->cpu);
>  
> @@ -160,7 +160,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	     "Posted Interrupt Suppress Notification set before blocking");
>  
>  	do {
> -		old.control = new.control = pi_desc->control;
> +		old.control = new.control = READ_ONCE(pi_desc->control);
>  
>  		/* set 'NV' to 'wakeup vector' */
>  		new.nv = POSTED_INTR_WAKEUP_VECTOR;

I wish there was a way to mark fields in a struct, as requiring 'READ_ONCE' on them
so that compiler would complain if this isn't done, or automatically use 'READ_ONCE'
logic.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


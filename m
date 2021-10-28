Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403D943DEC6
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 12:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhJ1KXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 06:23:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229898AbhJ1KXf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 06:23:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635416468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WNjfMGWJgQRyrsFW4O+8W6gSms2YGqJfs44+x3miEeo=;
        b=PYZXtyiTVQwdozDtRgnJY94yy4J4g9dVa4tsm7JzVPygADKddabVVwx6Zg6yojE74PJYzS
        G2Zr35RoUyK866e+nP+LBedWF+tyz4oulJ1WW/IG1IIYmxs0wiXEfxMVGKxhA9e+IMFemT
        lUCvO53j0lwMoUZAWiyLL35Ur3oM2eg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-0q32FwVmMIWh3L38BGVE8w-1; Thu, 28 Oct 2021 06:21:05 -0400
X-MC-Unique: 0q32FwVmMIWh3L38BGVE8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F27B7802682;
        Thu, 28 Oct 2021 10:21:00 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B194417CE1;
        Thu, 28 Oct 2021 10:20:21 +0000 (UTC)
Message-ID: <6b2bdfad87e268e861b6cc331d25790dade8e27b.camel@redhat.com>
Subject: Re: [PATCH v2 21/43] KVM: VMX: Clean up PI pre/post-block WARNs
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
Date:   Thu, 28 Oct 2021 13:20:20 +0300
In-Reply-To: <20211009021236.4122790-22-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-22-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Move the WARN sanity checks out of the PI descriptor update loop so as
> not to spam the kernel log if the condition is violated and the update
> takes multiple attempts due to another writer.  This also eliminates a
> few extra uops from the retry path.
> 
> Technically not checking every attempt could mean KVM will now fail to
> WARN in a scenario that would have failed before, but any such failure
> would be inherently racy as some other agent (CPU or device) would have
> to concurrent modify the PI descriptor.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 351666c41bbc..67cbe6ab8f66 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -100,10 +100,11 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>  	struct pi_desc old, new;
>  	unsigned int dest;
>  
> +	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
> +	     "Wakeup handler not enabled while the vCPU was blocking");
> +
>  	do {
>  		old.control = new.control = pi_desc->control;
> -		WARN(old.nv != POSTED_INTR_WAKEUP_VECTOR,
> -		     "Wakeup handler not enabled while the VCPU is blocked\n");
>  
>  		dest = cpu_physical_id(vcpu->cpu);
>  
> @@ -161,13 +162,12 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
>  	}
>  
> +	WARN(pi_desc->sn == 1,
> +	     "Posted Interrupt Suppress Notification set before blocking");
> +
>  	do {
>  		old.control = new.control = pi_desc->control;
>  
> -		WARN((pi_desc->sn == 1),
> -		     "Warning: SN field of posted-interrupts "
> -		     "is set before blocking\n");
> -
>  		/*
>  		 * Since vCPU can be preempted during this process,
>  		 * vcpu->cpu could be different with pre_pcpu, we

Don't know for sure if this is desired. I'll would just use WARN_ON_ONCE instead
if the warning spams the log.

If there is a race I would rather want to catch it even if rare.

Best regards,
	Maxim Levitsky


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6548643DF89
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 12:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhJ1K4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 06:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230111AbhJ1K4Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 06:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635418429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Wt6hQz793bEAWB8qvBHsZDv2D0O8mIxXIVFLmn+riQ=;
        b=Acpzr//HuX1ckzqdfQwnV1mlxIvMekfj9Hyp0EeHBptmEqefF0JghXKHTtjStobtM9nDN8
        f7XC9QKYbKAQrfBD4HemAOpw13V0W8pxSUELNg4y1AOPc6nIi2mtBJtRTRw8LVGDn1y/AR
        B5rMSRkix1wMnnCbUpFbkzV1MnJgzGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-jwGpmWEnPaGeb-7ShF0kxw-1; Thu, 28 Oct 2021 06:53:45 -0400
X-MC-Unique: jwGpmWEnPaGeb-7ShF0kxw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52A2A1006AA2;
        Thu, 28 Oct 2021 10:53:42 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BBCF5DA61;
        Thu, 28 Oct 2021 10:53:28 +0000 (UTC)
Message-ID: <fcd7739536029260a340247e2528de12293d8ebe.camel@redhat.com>
Subject: Re: [PATCH v2 24/43] KVM: VMX: Drop pointless PI.NDST update when
 blocking
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
Date:   Thu, 28 Oct 2021 13:53:27 +0300
In-Reply-To: <20211009021236.4122790-25-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-25-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Don't update Posted Interrupt's NDST, a.k.a. the target pCPU, in the
> pre-block path, as NDST is guaranteed to be up-to-date.  The comment
> about the vCPU being preempted during the update is simply wrong, as the
> update path runs with IRQs disabled (from before snapshotting vcpu->cpu,
> until after the update completes).
> 
> The vCPU can get preempted _before_ the update starts, but not during.
> And if the vCPU is preempted before, vmx_vcpu_pi_load() is responsible
> for updating NDST when the vCPU is scheduled back in.  In that case, the
> check against the wakeup vector in vmx_vcpu_pi_load() cannot be true as
> that would require the notification vector to have been set to the wakeup
> vector _before_ blocking.
> 
> Opportunistically switch to using vcpu->cpu for the list/lock lookups,
> which presumably used pre_pcpu only for some phantom preemption logic.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 23 +++--------------------
>  1 file changed, 3 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 1688f8dc535a..239e0e72a0dd 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -130,7 +130,6 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>   * - Store the vCPU to the wakeup list, so when interrupts happen
>   *   we can find the right vCPU to wake up.
>   * - Change the Posted-interrupt descriptor as below:
> - *      'NDST' <-- vcpu->pre_pcpu
>   *      'NV' <-- POSTED_INTR_WAKEUP_VECTOR
>   * - If 'ON' is set during this process, which means at least one
>   *   interrupt is posted for this vCPU, we cannot block it, in
> @@ -139,7 +138,6 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>   */
>  int pi_pre_block(struct kvm_vcpu *vcpu)
>  {
> -	unsigned int dest;
>  	struct pi_desc old, new;
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> @@ -153,10 +151,10 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	local_irq_disable();
>  
>  	vcpu->pre_pcpu = vcpu->cpu;
> -	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
>  	list_add_tail(&vcpu->blocked_vcpu_list,
> -		      &per_cpu(blocked_vcpu_on_cpu, vcpu->pre_pcpu));
> -	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +		      &per_cpu(blocked_vcpu_on_cpu, vcpu->cpu));
> +	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
>  
>  	WARN(pi_desc->sn == 1,
>  	     "Posted Interrupt Suppress Notification set before blocking");
> @@ -164,21 +162,6 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	do {
>  		old.control = new.control = pi_desc->control;
>  
> -		/*
> -		 * Since vCPU can be preempted during this process,
> -		 * vcpu->cpu could be different with pre_pcpu, we
> -		 * need to set pre_pcpu as the destination of wakeup
> -		 * notification event, then we can find the right vCPU
> -		 * to wakeup in wakeup handler if interrupts happen
> -		 * when the vCPU is in blocked state.
> -		 */
> -		dest = cpu_physical_id(vcpu->pre_pcpu);
> -
> -		if (x2apic_mode)
> -			new.ndst = dest;
> -		else
> -			new.ndst = (dest << 8) & 0xFF00;
> -
>  		/* set 'NV' to 'wakeup vector' */
>  		new.nv = POSTED_INTR_WAKEUP_VECTOR;
>  	} while (cmpxchg64(&pi_desc->control, old.control,
Reviewed-by : Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


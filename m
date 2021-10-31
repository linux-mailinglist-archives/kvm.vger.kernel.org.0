Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552F3440F74
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 17:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhJaQhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 12:37:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229936AbhJaQhK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 12:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635698075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iolz7u4TGw7YKdAJNXlS5PjuhU48Pq50OJFf9JL7Yf4=;
        b=X9NMF8ndzds0/x3qPimhegcHYDfOLT1cp80akyygPQhAo9f1q4HtRTRzVoX+5E9GuXVb8O
        C6CHs9FdO/Go8WM+zHuTQiOlxBv0//DkwbEJ35XWNl9yW7pcjaqyNoO3V5sF1dcfNt/KgS
        fghRtSERe9C/+00zhs97fRUykHWr8EA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-xYadWGzHPUmgUltMfPd33w-1; Sun, 31 Oct 2021 12:34:30 -0400
X-MC-Unique: xYadWGzHPUmgUltMfPd33w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6E248018AC;
        Sun, 31 Oct 2021 16:34:26 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F80E5C1C5;
        Sun, 31 Oct 2021 16:34:01 +0000 (UTC)
Message-ID: <933f1be27745d56660df13a9e76e46563bbd6261.camel@redhat.com>
Subject: Re: [PATCH v2 37/43] KVM: SVM: Unconditionally mark AVIC as running
 on vCPU load (with APICv)
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
Date:   Sun, 31 Oct 2021 18:34:00 +0200
In-Reply-To: <20211009021236.4122790-38-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-38-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Always mark the AVIC as "running" on vCPU load when the AVIC is enabled and
> drop the vcpu_blocking/unblocking hooks that toggle "running".  There is no
> harm in keeping the flag set for a wee bit longer when a vCPU is blocking,
> i.e. between the start of blocking and being scheduled out.  At worst, an
> agent in the host will unnecessarily signal the doorbell, but that's
> already the status quo in KVM as the "running" flag is set the entire time
> a vCPU is loaded, not just when it's actively running the guest.
> 
> In addition to simplifying the code, keeping the "running" flag set longer
> can reduce the number of VM-Exits due to incomplete IPI delivery.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 53 +++++++++++++----------------------------
>  arch/x86/kvm/svm/svm.c  |  8 -------
>  arch/x86/kvm/svm/svm.h  |  3 ---
>  3 files changed, 17 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index b43b05610ade..213f5223f63e 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -967,6 +967,15 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	int h_physical_id = kvm_cpu_get_apicid(cpu);
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	/* TODO: Document why the unblocking path checks for updates. */
> +	if (kvm_vcpu_is_blocking(vcpu) &&
> +	    kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu)) {
> +		kvm_vcpu_update_apicv(vcpu);
> +
> +		if (!kvm_vcpu_apicv_active(vcpu))
> +			return;
> +	}
> +
>  	/*
>  	 * Since the host physical APIC id is 8 bits,
>  	 * we can support host APIC ID upto 255.
> @@ -974,19 +983,21 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
>  		return;
>  
> +	/*
> +	 * Unconditionally mark the AVIC as "running", even if the vCPU is in
> +	 * kvm_vcpu_block().  kvm_vcpu_check_block() will detect pending IRQs
> +	 * and bail out of the block loop, and if not, avic_vcpu_put() will
> +	 * set the AVIC back to "not running" when the vCPU is scheduled out.
> +	 */
>  	entry = READ_ONCE(*(svm->avic_physical_id_cache));
>  	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>  
>  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
>  	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
> -
> -	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
> -	if (svm->avic_is_running)
> -		entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
> +	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
>  
>  	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
> -	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id,
> -					svm->avic_is_running);
> +	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
>  }
>  
>  void avic_vcpu_put(struct kvm_vcpu *vcpu)
> @@ -1001,33 +1012,3 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
>  	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
>  }
> -
> -/*
> - * This function is called during VCPU halt/unhalt.
> - */
> -static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -
> -	svm->avic_is_running = is_run;
> -
> -	if (!kvm_vcpu_apicv_active(vcpu))
> -		return;
> -
> -	if (is_run)
> -		avic_vcpu_load(vcpu, vcpu->cpu);
> -	else
> -		avic_vcpu_put(vcpu);
> -}
> -
> -void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
> -{
> -	avic_set_running(vcpu, false);
> -}
> -
> -void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
> -{
> -	if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
> -		kvm_vcpu_update_apicv(vcpu);
> -	avic_set_running(vcpu, true);
> -}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 89077160d463..a1ca5707f2c8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1433,12 +1433,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  	if (err)
>  		goto error_free_vmsa_page;
>  
> -	/* We initialize this flag to true to make sure that the is_running
> -	 * bit would be set the first time the vcpu is loaded.
> -	 */
> -	if (irqchip_in_kernel(vcpu->kvm) && kvm_apicv_activated(vcpu->kvm))
> -		svm->avic_is_running = true;
> -
>  	svm->msrpm = svm_vcpu_alloc_msrpm();
>  	if (!svm->msrpm) {
>  		err = -ENOMEM;
> @@ -4597,8 +4591,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.prepare_guest_switch = svm_prepare_guest_switch,
>  	.vcpu_load = svm_vcpu_load,
>  	.vcpu_put = svm_vcpu_put,
> -	.vcpu_blocking = svm_vcpu_blocking,
> -	.vcpu_unblocking = svm_vcpu_unblocking,
>  
>  	.update_exception_bitmap = svm_update_exception_bitmap,
>  	.get_msr_feature = svm_get_msr_feature,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 7f5b01bbee29..652d71acfb6c 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -169,7 +169,6 @@ struct vcpu_svm {
>  	u32 dfr_reg;
>  	struct page *avic_backing_page;
>  	u64 *avic_physical_id_cache;
> -	bool avic_is_running;
>  
>  	/*
>  	 * Per-vcpu list of struct amd_svm_iommu_ir:
> @@ -529,8 +528,6 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
>  bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>  		       uint32_t guest_irq, bool set);
> -void svm_vcpu_blocking(struct kvm_vcpu *vcpu);
> -void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  
>  /* sev.c */
>  

Looks good. It is nice to get rid of all of this logic that was just making things more complicated.

Something else nice to do here which I didn't finish back then when I worked on avic, would be
to maybe rename avic_vcpu_load/avic_vcpu_put because those are also now run on avic inhibit/uninhibit.

Basically the 'svm_refresh_apicv_exec_ctrl' is the full avic activate/deactivate, while
avic_vcpu_load/avic_vcpu_put are the lighter weight partial avic activation/deactivation functions.

So minus the comment from Paolo about the updating avic on unblock which I missed back when I wrote
my patches:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCA639144B
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 12:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhEZKDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 06:03:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233621AbhEZKCz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 06:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622023283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4gAOoRzEIhV3odkZEbRKjYU4BnZThPvYMTxa4gsc234=;
        b=V0xwN3xbbh+8fUnw8OHJZVwqZldvFst0n/infK0zRA3Dy1KjinDTYnBuSOam9rrWps/C/p
        +2rRWDBoyH4XHd/oRfWDHteywpOciYz+Gj+vws1vufLZ+D2JxxbORYFIboPm3kspZwI6Ss
        bH3Bz80T9nns7mCkk0fSFEPFUtDpAi8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-cDdCdrxVPZiG2KjuCe5Ptw-1; Wed, 26 May 2021 06:01:21 -0400
X-MC-Unique: cDdCdrxVPZiG2KjuCe5Ptw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90238107ACE4;
        Wed, 26 May 2021 10:01:20 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 257575DAA5;
        Wed, 26 May 2021 10:01:17 +0000 (UTC)
Message-ID: <68f66acabc5a8c84bf56006ab91bf66028e97152.camel@redhat.com>
Subject: Re: [PATCH v2 5/5] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Date:   Wed, 26 May 2021 13:01:16 +0300
In-Reply-To: <20210518144339.1987982-6-vkuznets@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
         <20210518144339.1987982-6-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-18 at 16:43 +0200, Vitaly Kuznetsov wrote:
> APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
> SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
> however, possible to track whether the feature was actually used by the
> guest and only inhibit APICv/AVIC when needed.
> 
> TLFS suggests a dedicated 'HV_DEPRECATING_AEOI_RECOMMENDED' flag to let
> Windows know that AutoEOI feature should be avoided. While it's up to
> KVM userspace to set the flag, KVM can help a bit by exposing global
> APICv/AVIC enablement: in case APICv/AVIC usage is impossible, AutoEOI
> is still preferred.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++------
>  2 files changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index bf5807d35339..5e03ab4c0e4f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -936,6 +936,9 @@ struct kvm_hv {
>  	/* How many vCPUs have VP index != vCPU index */
>  	atomic_t num_mismatched_vp_indexes;
>  
> +	/* How many SynICs use 'AutoEOI' feature */
> +	atomic_t synic_auto_eoi_used;
> +
>  	struct hv_partition_assist_pg *hv_pa_pg;
>  	struct kvm_hv_syndbg hv_syndbg;
>  };
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index f98370a39936..89e7d5b99279 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -87,6 +87,10 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
>  static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
>  				int vector)
>  {
> +	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
> +	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
> +	int auto_eoi_old, auto_eoi_new;
> +
>  	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
>  		return;
>  
> @@ -95,10 +99,25 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
>  	else
>  		__clear_bit(vector, synic->vec_bitmap);
>  
> +	auto_eoi_old = bitmap_weight(synic->auto_eoi_bitmap, 256);
> +
>  	if (synic_has_vector_auto_eoi(synic, vector))
>  		__set_bit(vector, synic->auto_eoi_bitmap);
>  	else
>  		__clear_bit(vector, synic->auto_eoi_bitmap);
> +
> +	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
> +
> +	/* Hyper-V SynIC auto EOI SINTs are not compatible with APICV */
> +	if (!auto_eoi_old && auto_eoi_new) {
> +		if (atomic_inc_return(&hv->synic_auto_eoi_used) == 1)
> +			kvm_request_apicv_update(vcpu->kvm, false,
> +						 APICV_INHIBIT_REASON_HYPERV);
> +	} else if (!auto_eoi_new && auto_eoi_old) {
> +		if (atomic_dec_return(&hv->synic_auto_eoi_used) == 0)
> +			kvm_request_apicv_update(vcpu->kvm, true,
> +						 APICV_INHIBIT_REASON_HYPERV);
> +	}

A summary of a bug as I explained in my main reply to the patch series:
synic_update_vector can be called on vmexit, holding the SRCU lock,
and it can't currently call kvm_request_apicv_update with SRCU lock held.
because kvm_request_apicv_update indirectly calls synchronize_srcu.

Either we have to add a parameter 'host' synic_update_vector 
that will specify that this function was 
called on msr write from userspace, or from the guest, and for the latter 
drop the srcu lock around kvm_request_apicv_update as it is done in 
svm_toggle_avic_for_irq_window or we should think on how
we can make kvm_request_apicv_update avoid the need to use srcu lock.

We can for example make it not run avic memslot update on current vcpu,
for the synic case, or maybe we can make it avoid memslots update completely.

Other than this bug, especially after I did read the SynIC 
spec, this looks reasonable.

One thing though that I noticed in the SynIC spec is that 
regardless of AutoEOI setting, when we do intercept EOI 
(which we can't with AVIC) (in apic_set_eoi) 
we call kvm_hv_synic_send_eoi, which seems to try to raise stimer again 
on this SINIx.
This is not relevant if STIMER is in direct mode though, then I think
we don't really send anything through SynIC anyway.

So besides the SRCU bug:

Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


>  }
>  
>  static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
> @@ -931,12 +950,6 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
>  
>  	synic = to_hv_synic(vcpu);
>  
> -	/*
> -	 * Hyper-V SynIC auto EOI SINT's are
> -	 * not compatible with APICV, so request
> -	 * to deactivate APICV permanently.
> -	 */
> -	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
>  	synic->active = true;
>  	synic->dont_zero_synic_pages = dont_zero_synic_pages;
>  	synic->control = HV_SYNIC_CONTROL_ENABLE;
> @@ -2198,6 +2211,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  				ent->eax |= HV_X64_ENLIGHTENED_VMCS_RECOMMENDED;
>  			if (!cpu_smt_possible())
>  				ent->eax |= HV_X64_NO_NONARCH_CORESHARING;
> +			if (enable_apicv)
> +				ent->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
>  			/*
>  			 * Default number of spinlock retry attempts, matches
>  			 * HyperV 2016.



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E339391450
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 12:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhEZKEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 06:04:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233568AbhEZKEQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 06:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622023365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BMCDyJ751N8hnlsCOUH+lAy3d3kC1AGxZCaqwRQmLu4=;
        b=YugpLJ5saMSnsgtq4b5l6QQ1wH/6I0QaxkvdzC15R4mC9cjMcVGHaGnvkuH0c8LYdZ0agp
        WpbwTbK5e830Csh4qYybJZscyzqEnKVOEmMJMUKSragLqhPsspMYl+74BF0wiPmc1oAaon
        YF9act7kTdIq3N2Gfu/7YYSikriQVuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-GijBgnq_Nn2oBQZCDfftCw-1; Wed, 26 May 2021 06:02:42 -0400
X-MC-Unique: GijBgnq_Nn2oBQZCDfftCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 914F319251CC;
        Wed, 26 May 2021 10:02:27 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 358295C230;
        Wed, 26 May 2021 10:02:24 +0000 (UTC)
Message-ID: <572a0dbf8f656f49dfcf49596f2b6e10236ba7a9.camel@redhat.com>
Subject: Re: [PATCH v2 5/5] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Date:   Wed, 26 May 2021 13:02:23 +0300
In-Reply-To: <82e2a6a0-337a-4b92-2271-493344a38960@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
         <20210518144339.1987982-6-vkuznets@redhat.com>
         <82e2a6a0-337a-4b92-2271-493344a38960@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-24 at 18:21 +0200, Paolo Bonzini wrote:
> On 18/05/21 16:43, Vitaly Kuznetsov wrote:
> > APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
> > SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
> > however, possible to track whether the feature was actually used by the
> > guest and only inhibit APICv/AVIC when needed.
> > 
> > TLFS suggests a dedicated 'HV_DEPRECATING_AEOI_RECOMMENDED' flag to let
> > Windows know that AutoEOI feature should be avoided. While it's up to
> > KVM userspace to set the flag, KVM can help a bit by exposing global
> > APICv/AVIC enablement: in case APICv/AVIC usage is impossible, AutoEOI
> > is still preferred.
> > 
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Should it also disable APICv unconditionally if 
> HV_DEPRECATING_AEOI_RECOMMENDED is not in the guest CPUID?  That should 
> avoid ping-pong between enabled and disabled APICv even in pathological 
> cases that we cannot think about.

Probably not worth it, as the guest might still not use it.
We already disable/enable AVIC at the rate of a few iterations
per second when PIC sends its interrupts via ExtINT,
and we need an interrupt window.

This is sadly something that windows still does use and
it seems to work.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> > ---
> >   arch/x86/include/asm/kvm_host.h |  3 +++
> >   arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++------
> >   2 files changed, 24 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index bf5807d35339..5e03ab4c0e4f 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -936,6 +936,9 @@ struct kvm_hv {
> >   	/* How many vCPUs have VP index != vCPU index */
> >   	atomic_t num_mismatched_vp_indexes;
> >   
> > +	/* How many SynICs use 'AutoEOI' feature */
> > +	atomic_t synic_auto_eoi_used;
> > +
> >   	struct hv_partition_assist_pg *hv_pa_pg;
> >   	struct kvm_hv_syndbg hv_syndbg;
> >   };
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index f98370a39936..89e7d5b99279 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -87,6 +87,10 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
> >   static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
> >   				int vector)
> >   {
> > +	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
> > +	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
> > +	int auto_eoi_old, auto_eoi_new;
> > +
> >   	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
> >   		return;
> >   
> > @@ -95,10 +99,25 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
> >   	else
> >   		__clear_bit(vector, synic->vec_bitmap);
> >   
> > +	auto_eoi_old = bitmap_weight(synic->auto_eoi_bitmap, 256);
> > +
> >   	if (synic_has_vector_auto_eoi(synic, vector))
> >   		__set_bit(vector, synic->auto_eoi_bitmap);
> >   	else
> >   		__clear_bit(vector, synic->auto_eoi_bitmap);
> > +
> > +	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
> > +
> > +	/* Hyper-V SynIC auto EOI SINTs are not compatible with APICV */
> > +	if (!auto_eoi_old && auto_eoi_new) {
> > +		if (atomic_inc_return(&hv->synic_auto_eoi_used) == 1)
> > +			kvm_request_apicv_update(vcpu->kvm, false,
> > +						 APICV_INHIBIT_REASON_HYPERV);
> > +	} else if (!auto_eoi_new && auto_eoi_old) {
> > +		if (atomic_dec_return(&hv->synic_auto_eoi_used) == 0)
> > +			kvm_request_apicv_update(vcpu->kvm, true,
> > +						 APICV_INHIBIT_REASON_HYPERV);
> > +	}
> >   }
> >   
> >   static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
> > @@ -931,12 +950,6 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
> >   
> >   	synic = to_hv_synic(vcpu);
> >   
> > -	/*
> > -	 * Hyper-V SynIC auto EOI SINT's are
> > -	 * not compatible with APICV, so request
> > -	 * to deactivate APICV permanently.
> > -	 */
> > -	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
> >   	synic->active = true;
> >   	synic->dont_zero_synic_pages = dont_zero_synic_pages;
> >   	synic->control = HV_SYNIC_CONTROL_ENABLE;
> > @@ -2198,6 +2211,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
> >   				ent->eax |= HV_X64_ENLIGHTENED_VMCS_RECOMMENDED;
> >   			if (!cpu_smt_possible())
> >   				ent->eax |= HV_X64_NO_NONARCH_CORESHARING;
> > +			if (enable_apicv)
> > +				ent->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
> >   			/*
> >   			 * Default number of spinlock retry attempts, matches
> >   			 * HyperV 2016.
> > 



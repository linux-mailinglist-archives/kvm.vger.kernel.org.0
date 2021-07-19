Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C7E3CD16D
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 12:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhGSJSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 05:18:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235976AbhGSJSF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 05:18:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626688725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9iuXMiXB3koc/GvJU+Wg2k7jYKX5Po4q4IzNF0aqa3Y=;
        b=hb4L+ULsGFBoTF6ShuSTReiVSAVwKsaEAow/PCi8Ybct3Xl+TABrsLpL3XbuJlEKa1kejI
        x3BR9wmr0eGmbrYZd58jM9VEdFq8WbiIg59FH5b+nF8rXoCDA+rBLehJ6L+kwhDCBQYqPL
        /PZ+TnJj5rGn/5rC2G7wTxBqMSRcSqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-36K-_R-8PYmpgC70XqLYyg-1; Mon, 19 Jul 2021 05:58:43 -0400
X-MC-Unique: 36K-_R-8PYmpgC70XqLYyg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4E32362FD;
        Mon, 19 Jul 2021 09:58:41 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0826A10074FD;
        Mon, 19 Jul 2021 09:58:37 +0000 (UTC)
Message-ID: <779741344dc401aa572c8c9bea05e059afe9a6d2.camel@redhat.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Date:   Mon, 19 Jul 2021 12:58:36 +0300
In-Reply-To: <87tukqzmg7.fsf@vitty.brq.redhat.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
         <20210713142023.106183-9-mlevitsk@redhat.com>
         <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
         <87wnpmzqw3.fsf@vitty.brq.redhat.com>
         <b2978f4868437db23208718b3850b8fb6c0409eb.camel@redhat.com>
         <87tukqzmg7.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-07-19 at 11:23 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Mon, 2021-07-19 at 09:47 +0200, Vitaly Kuznetsov wrote:
> > > Maxim Levitsky <mlevitsk@redhat.com> writes:
> > > 
> > > > On Tue, 2021-07-13 at 17:20 +0300, Maxim Levitsky wrote:
> > > > > From: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > > > 
> > > > > APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
> > > > > SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
> > > > > however, possible to track whether the feature was actually used by the
> > > > > guest and only inhibit APICv/AVIC when needed.
> > > > > 
> > > > > TLFS suggests a dedicated 'HV_DEPRECATING_AEOI_RECOMMENDED' flag to let
> > > > > Windows know that AutoEOI feature should be avoided. While it's up to
> > > > > KVM userspace to set the flag, KVM can help a bit by exposing global
> > > > > APICv/AVIC enablement: in case APICv/AVIC usage is impossible, AutoEOI
> > > > > is still preferred.
> > > > > Maxim:
> > > > >    - added SRCU lock drop around call to kvm_request_apicv_update
> > > > >    - always set HV_DEPRECATING_AEOI_RECOMMENDED in kvm_get_hv_cpuid,
> > > > >      since this feature can be used regardless of AVIC
> > > > > 
> > > > > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > > ---
> > > > >  arch/x86/include/asm/kvm_host.h |  3 +++
> > > > >  arch/x86/kvm/hyperv.c           | 34 +++++++++++++++++++++++++++------
> > > > >  2 files changed, 31 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > > index e11d64aa0bcd..f900dca58af8 100644
> > > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > > @@ -956,6 +956,9 @@ struct kvm_hv {
> > > > >  	/* How many vCPUs have VP index != vCPU index */
> > > > >  	atomic_t num_mismatched_vp_indexes;
> > > > >  
> > > > > +	/* How many SynICs use 'AutoEOI' feature */
> > > > > +	atomic_t synic_auto_eoi_used;
> > > > > +
> > > > >  	struct hv_partition_assist_pg *hv_pa_pg;
> > > > >  	struct kvm_hv_syndbg hv_syndbg;
> > > > >  };
> > > > > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > > > > index b07592ca92f0..6bf47a583d0e 100644
> > > > > --- a/arch/x86/kvm/hyperv.c
> > > > > +++ b/arch/x86/kvm/hyperv.c
> > > > > @@ -85,9 +85,22 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
> > > > >  	return false;
> > > > >  }
> > > > >  
> > > > > +
> > > > > +static void synic_toggle_avic(struct kvm_vcpu *vcpu, bool activate)
> > > > > +{
> > > > > +	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> > > > > +	kvm_request_apicv_update(vcpu->kvm, activate,
> > > > > +			APICV_INHIBIT_REASON_HYPERV);
> > > > > +	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> > > > > +}
> > > > 
> > > > Well turns out that this patch still doesn't work (on this
> > > > weekend I found out that all my AVIC enabled VMs hang on reboot).
> > > > 
> > > > I finally found out what prompted me back then to make srcu lock drop
> > > > in synic_update_vector conditional on whether the write was done
> > > > by the host.
> > > >  
> > > > Turns out that while KVM_SET_MSRS does take the kvm->srcu lock,
> > > > it stores the returned srcu index in a local variable and not
> > > > in vcpu->srcu_idx, thus the lock drop in synic_toggle_avic
> > > > doesn't work.
> > > >  
> > > > So it is likely that I have seen it not work, and blamed 
> > > > KVM_SET_MSRS for not taking the srcu lock which was a wrong assumption.
> > > >  
> > > > I am more inclined to fix this by just tracking if we hold the srcu
> > > > lock on each VCPU manually, just as we track the srcu index anyway,
> > > > and then kvm_request_apicv_update can use this to drop the srcu
> > > > lock when needed.
> > > > 
> > > 
> > > Would it be possible to use some magic value in 'vcpu->srcu_idx' and not
> > > introduce a new 'srcu_ls_locked' flag?
> > 
> > Well, currently the returned index value from srcu_read_lock is opaque 
> > (and we have two SRCU implementations and both I think return small positive numbers, 
> > but I haven't studied them in depth).
> >  
> > We can ask the people that maintain SRCU to reserve a number (like -1)
> > or so.
> > I probably first add the 'srcu_is_locked' thought and then as a follow up patch
> > remove it if they agree.
> > 
> 
> Ah, OK. BTW, I've just discovered srcu_read_lock_held() which sounds
> like the function we need but unfortunately it is not.

Yea, exactly this. :-(

Best regards,
	Maxim Levitsky

> 



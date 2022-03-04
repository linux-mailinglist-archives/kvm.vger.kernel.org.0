Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685554CD3C7
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 12:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbiCDLwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 06:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiCDLwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 06:52:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 908461B2ADC
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 03:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646394709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vZKmcoKe00bB7xWiFgBqQRVmBmt+1lt3ei1GdFPkXBk=;
        b=V3mhgDdgjQikZNJXSvBvxM99hoSXMDPT4D+i/Sv9pBY4qfeXwfHUofhudpMS9iiQQmHjub
        C6wZHxlAyGHCorQLmm84WDqdYqwvEGlm3BCOwSqXUkge//DZLcjYxvVxzwGytXisqSGpKe
        Q1yewJ/xOleONODODwYYUlhifSyvnu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-Y5O1eiU8PguXlxZtp9UqWw-1; Fri, 04 Mar 2022 06:51:48 -0500
X-MC-Unique: Y5O1eiU8PguXlxZtp9UqWw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF1C58070FF;
        Fri,  4 Mar 2022 11:51:46 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4986C10589AF;
        Fri,  4 Mar 2022 11:51:44 +0000 (UTC)
Message-ID: <1c838121e40b8b712fd56dc47675d77cb126121f.camel@redhat.com>
Subject: Re: [RFC PATCH 11/13] KVM: SVM: Add logic to switch between APIC
 and x2APIC virtualization mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Fri, 04 Mar 2022 13:51:42 +0200
In-Reply-To: <6ff5a6ce-780b-0234-aec5-ef5cff290feb@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-12-suravee.suthikulpanit@amd.com>
         <5f3b7d10e63126073fa4c17ba4e095b0fa0795e8.camel@redhat.com>
         <6ff5a6ce-780b-0234-aec5-ef5cff290feb@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 18:22 +0700, Suravee Suthikulpanit wrote:
> Maxim,
> 
> On 2/25/22 3:03 AM, Maxim Levitsky wrote:
> > On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
> > > ....
> > > 
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index 3543b7a4514a..3306b74f1d8b 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -79,6 +79,50 @@ static inline enum avic_modes avic_get_vcpu_apic_mode(struct vcpu_svm *svm)
> > >   		return AVIC_MODE_NONE;
> > >   }
> > >   
> > > +static inline void avic_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0x800; i <= 0x8ff; i++)
> > > +		set_msr_interception(&svm->vcpu, svm->msrpm, i,
> > > +				     !disable, !disable);
> > > +}
> > > +
> > > +void avic_activate_vmcb(struct vcpu_svm *svm)
> > > +{
> > > +	struct vmcb *vmcb = svm->vmcb01.ptr;
> > > +
> > > +	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> > > +
> > > +	if (svm->x2apic_enabled) {
> > Use apic_x2apic_mode here as well
> 
> Okay
> 
> > > +		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> > > +		vmcb->control.avic_physical_id &= ~X2AVIC_MAX_PHYSICAL_ID;
> > > +		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
> > Why not just use
> > 
> > phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));;
> > vmcb->control.avic_physical_id = ppa | X2AVIC_MAX_PHYSICAL_ID;
> > 
> 
> Sorry, I don't quiet understand this part. We just want to update certain bits in the VMCB register.

It seems a bit cleaner to me to create that field again instead of erasing bits like that.
But honestly I don't mind it that much.


> 
> > > ...
> > > +void avic_deactivate_vmcb(struct vcpu_svm *svm)
> > > +{
> > > +	struct vmcb *vmcb = svm->vmcb01.ptr;
> > > +
> > > +	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
> > > +
> > > +	if (svm->x2apic_enabled)
> > > +		vmcb->control.avic_physical_id &= ~X2AVIC_MAX_PHYSICAL_ID;
> > > +	else
> > > +		vmcb->control.avic_physical_id &= ~AVIC_MAX_PHYSICAL_ID;
> > > +
> > > +	/* Enabling MSR intercept for x2APIC registers */
> > > +	avic_set_x2apic_msr_interception(svm, true);
> > > +}
> > > +
> > >   /* Note:
> > >    * This function is called from IOMMU driver to notify
> > >    * SVM to schedule in a particular vCPU of a particular VM.
> > > @@ -195,13 +239,12 @@ void avic_init_vmcb(struct vcpu_svm *svm)
> > >   	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
> > >   	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
> > >   	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
> > > -	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
> > >   	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
> > >   
> > >   	if (kvm_apicv_activated(svm->vcpu.kvm))
> > > -		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> > > +		avic_activate_vmcb(svm);
> > Why not set AVIC_ENABLE_MASK in avic_activate_vmcb ?
> 
> It's already doing "vmcb->control.int_ctl |= X2APIC_MODE_MASK;" in avic_activate_vmcb().
Yes, but why not also to set/clear AVIC_ENABLE_MASK there as well?

> 
> > >   	else
> > > -		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
> > > +		avic_deactivate_vmcb(svm);
> > >   }
> > >   
> > >   static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
> > > @@ -657,6 +700,13 @@ void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
> > >   		 svm->x2apic_enabled ? "x2APIC" : "xAPIC");
> > >   	vmcb_mark_dirty(svm->vmcb, VMCB_AVIC);
> > >   	kvm_vcpu_update_apicv(&svm->vcpu);
> > > +
> > > +	/*
> > > +	 * The VM could be running w/ AVIC activated switching from APIC
> > > +	 * to x2APIC mode. We need to all refresh to make sure that all
> > > +	 * x2AVIC configuration are being done.
> > > +	 */
> > > +	svm_refresh_apicv_exec_ctrl(&svm->vcpu);
> > 
> > That also should be done in avic_set_virtual_apic_mode  instead, but otherwise should be fine.
> 
> Agree, and will be updated to use svm_set_virtual_apic_mode() in v2.
> 
> > Also it seems that .avic_set_virtual_apic_mode will cover you on the case when x2apic is disabled
> > in the guest cpuid - kvm_set_apic_base checks if the guest cpuid has x2apic support and refuses
> > to enable it if it is not set.
> > 
> > But still a WARN_ON_ONCE won't hurt to see that you are not enabling x2avic when not supported.
> 
> Not sure if we need this. The logic for activating x2AVIC in VMCB already
> check if the guest x2APIC mode is set, which can only happen if x2APIC CPUID
> is set.
I don't mind that much, just a suggestion.

> 
> > >   }
> > >   
> > >   void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> > > @@ -722,9 +772,9 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> > >   		 * accordingly before re-activating.
> > >   		 */
> > >   		avic_post_state_restore(vcpu);
> > > -		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> > > +		avic_activate_vmcb(svm);
> > >   	} else {
> > > -		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
> > > +		avic_deactivate_vmcb(svm);
> > >   	}
> > >   	vmcb_mark_dirty(vmcb, VMCB_AVIC);
> > >   
> > > @@ -1019,7 +1069,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > >   		return;
> > >   
> > >   	entry = READ_ONCE(*(svm->avic_physical_id_cache));
> > > -	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
> > Why?
> 
> For AVIC, this WARN_ON is designed to catch the scenario when the vCPU is calling
> avic_vcpu_load() while it is already running. However, with x2AVIC support,
> the vCPU can switch from xAPIC to x2APIC mode while in running state
> (i.e. the AVIC is_running is set). This warning is currently observed due to
> the call from svm_refresh_apicv_exec_ctrl().

Ah, understand you now!

Best regards,
	Thanks,
		Maxim Levitsky

> 
> Regards,
> Suravee
> 



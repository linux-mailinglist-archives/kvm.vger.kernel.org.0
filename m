Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353772FEE30
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732629AbhAUPMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:12:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732600AbhAUPMC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 10:12:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611241836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T98PE8PVwoJEyZJ1pOX8lx3mBxjHJ+tI2w+WLOV5UJA=;
        b=Oyi0upxKLuR88DFlfcPlM8VDXxQzUZmJ9RT1ag5Tc+12zxWF2r4RVVBB5CDT5M6l7K2CaX
        LIjK/Fc6rOJnBk71yU5nBmdyBPVoXoOq8VV0ycu+2nGAWy7WpyoVSR1aGVpBeXQty2HpzK
        Mx90NWXjaKoeN7fjSmdBsJpEwOaQxiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-Fd2dCq-7MvC50yFWLcBBKw-1; Thu, 21 Jan 2021 10:10:34 -0500
X-MC-Unique: Fd2dCq-7MvC50yFWLcBBKw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20E85100C60D;
        Thu, 21 Jan 2021 15:10:32 +0000 (UTC)
Received: from starship (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB1C55F9C8;
        Thu, 21 Jan 2021 15:10:22 +0000 (UTC)
Message-ID: <61a41255d089171e7dc828fac74dd3efe11bd34a.camel@redhat.com>
Subject: Re: [PATCH v2 4/4] KVM: SVM: Support #GP handling for the case of
 nested on nested
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, luto@amacapital.net
Date:   Thu, 21 Jan 2021 17:10:21 +0200
In-Reply-To: <20210121145622.GH3072@work-vm>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
         <20210121065508.1169585-5-wei.huang2@amd.com>
         <20210121145622.GH3072@work-vm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-21 at 14:56 +0000, Dr. David Alan Gilbert wrote:
> * Wei Huang (wei.huang2@amd.com) wrote:
> > Under the case of nested on nested (e.g. L0->L1->L2->L3), #GP triggered
> > by SVM instructions can be hided from L1. Instead the hypervisor can
> > inject the proper #VMEXIT to inform L1 of what is happening. Thus L1
> > can avoid invoking the #GP workaround. For this reason we turns on
> > guest VM's X86_FEATURE_SVME_ADDR_CHK bit for KVM running inside VM to
> > receive the notification and change behavior.
> 
> Doesn't this mean a VM migrated between levels (hmm L2 to L1???) would
> see different behaviour?
> (I've never tried such a migration, but I thought in principal it should
> work).

This is not an issue. The VM will always see the X86_FEATURE_SVME_ADDR_CHK set,
(regardless if host has it, or if KVM emulates it).
This is not different from what KVM does for guest's x2apic.
KVM also always emulates it regardless of the host support.

The hypervisor on the other hand can indeed either see or not that bit set,
but it is prepared to handle both cases, so it will support migrating VMs
between hosts that have and don't have that bit.

I hope that I understand this correctly.

Best regards,
	Maxim Levitsky


> 
> Dave
> 
> 
> > Co-developed-by: Bandan Das <bsd@redhat.com>
> > Signed-off-by: Bandan Das <bsd@redhat.com>
> > Signed-off-by: Wei Huang <wei.huang2@amd.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 2a12870ac71a..89512c0e7663 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2196,6 +2196,11 @@ static int svm_instr_opcode(struct kvm_vcpu *vcpu)
> >  
> >  static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
> >  {
> > +	const int guest_mode_exit_codes[] = {
> > +		[SVM_INSTR_VMRUN] = SVM_EXIT_VMRUN,
> > +		[SVM_INSTR_VMLOAD] = SVM_EXIT_VMLOAD,
> > +		[SVM_INSTR_VMSAVE] = SVM_EXIT_VMSAVE,
> > +	};
> >  	int (*const svm_instr_handlers[])(struct vcpu_svm *svm) = {
> >  		[SVM_INSTR_VMRUN] = vmrun_interception,
> >  		[SVM_INSTR_VMLOAD] = vmload_interception,
> > @@ -2203,7 +2208,14 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
> >  	};
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> >  
> > -	return svm_instr_handlers[opcode](svm);
> > +	if (is_guest_mode(vcpu)) {
> > +		svm->vmcb->control.exit_code = guest_mode_exit_codes[opcode];
> > +		svm->vmcb->control.exit_info_1 = 0;
> > +		svm->vmcb->control.exit_info_2 = 0;
> > +
> > +		return nested_svm_vmexit(svm);
> > +	} else
> > +		return svm_instr_handlers[opcode](svm);
> >  }
> >  
> >  /*
> > @@ -4034,6 +4046,11 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  	/* Check again if INVPCID interception if required */
> >  	svm_check_invpcid(svm);
> >  
> > +	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM)) {
> > +		best = kvm_find_cpuid_entry(vcpu, 0x8000000A, 0);
> > +		best->edx |= (1 << 28);
> > +	}
> > +
> >  	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
> >  	if (sev_guest(vcpu->kvm)) {
> >  		best = kvm_find_cpuid_entry(vcpu, 0x8000001F, 0);
> > -- 
> > 2.27.0
> > 



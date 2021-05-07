Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9183764E7
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 14:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbhEGMNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 08:13:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236061AbhEGMNO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 08:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620389534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7o2rfVJZNyHJwK9ln3g7JbDOs7uu+V/EsDrZzUW8Nqs=;
        b=JbdDJUp3JxKQU7Izks44p9nbvFUEI5xKP4AnxPbfhVUo7rRGZOJ/2Z2H2I75chDLFVvRAL
        FJzpZweQ9bd8hcjkmIYddRPNR4tcEDCb13YBFFhnvoVPlysIkkLfH8PxXKF5v6ofBU1uyJ
        x8/pP3080dhNj7e79okvXHow6pGK34Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-RJMs6oQgM9ybZJpKMQtXjA-1; Fri, 07 May 2021 08:12:12 -0400
X-MC-Unique: RJMs6oQgM9ybZJpKMQtXjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0D4F1936B6A;
        Fri,  7 May 2021 12:12:11 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E9AC10074E0;
        Fri,  7 May 2021 12:12:04 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 84D2B41887F4; Fri,  7 May 2021 09:11:52 -0300 (-03)
Date:   Fri, 7 May 2021 09:11:52 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 2/2 V2] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210507121152.GA367281@fuller.cnet>
References: <20210506185732.609010123@redhat.com>
 <20210506190419.481236922@redhat.com>
 <20210506192125.GA350334@fuller.cnet>
 <YJRhMrxTrSDClwbQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJRhMrxTrSDClwbQ@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Thu, May 06, 2021 at 09:35:46PM +0000, Sean Christopherson wrote:
> On Thu, May 06, 2021, Marcelo Tosatti wrote:
> > Index: kvm/arch/x86/kvm/vmx/posted_intr.c
> > ===================================================================
> > --- kvm.orig/arch/x86/kvm/vmx/posted_intr.c
> > +++ kvm/arch/x86/kvm/vmx/posted_intr.c
> > @@ -114,7 +114,7 @@ static void __pi_post_block(struct kvm_v
> >  	} while (cmpxchg64(&pi_desc->control, old.control,
> >  			   new.control) != old.control);
> >  
> > -	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
> > +	if (vcpu->pre_pcpu != -1) {
> >  		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> >  		list_del(&vcpu->blocked_vcpu_list);
> >  		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> > @@ -135,20 +135,13 @@ static void __pi_post_block(struct kvm_v
> >   *   this case, return 1, otherwise, return 0.
> >   *
> >   */
> > -int pi_pre_block(struct kvm_vcpu *vcpu)
> > +static int __pi_pre_block(struct kvm_vcpu *vcpu)
> >  {
> >  	unsigned int dest;
> >  	struct pi_desc old, new;
> >  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> >  
> > -	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> > -		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
> > -		!kvm_vcpu_apicv_active(vcpu))
> > -		return 0;
> > -
> > -	WARN_ON(irqs_disabled());
> > -	local_irq_disable();
> > -	if (!WARN_ON_ONCE(vcpu->pre_pcpu != -1)) {
> > +	if (vcpu->pre_pcpu == -1) {
> >  		vcpu->pre_pcpu = vcpu->cpu;
> >  		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> >  		list_add_tail(&vcpu->blocked_vcpu_list,
> > @@ -188,12 +181,33 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
> >  	if (pi_test_on(pi_desc) == 1)
> >  		__pi_post_block(vcpu);
> >  
> > +	return (vcpu->pre_pcpu == -1);
> 
> Nothing checks the return of __pi_pre_block(), this can be dropped and the
> helper can be a void return.

Done.

> > +}
> > +
> > +int pi_pre_block(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +
> > +	vmx->in_blocked_section = true;
> > +
> > +	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> > +		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
> > +		!kvm_vcpu_apicv_active(vcpu))
> 
> Opportunistically fix the indentation?

Done.

> > +		return 0;
> > +
> > +	WARN_ON(irqs_disabled());
> > +	local_irq_disable();
> > +	__pi_pre_block(vcpu);
> >  	local_irq_enable();
> > +
> >  	return (vcpu->pre_pcpu == -1);
> >  }
> >  
> >  void pi_post_block(struct kvm_vcpu *vcpu)
> >  {
> > +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +
> > +	vmx->in_blocked_section = false;
> >  	if (vcpu->pre_pcpu == -1)
> >  		return;
> >  
> > @@ -236,6 +250,52 @@ bool pi_has_pending_interrupt(struct kvm
> >  		(pi_test_sn(pi_desc) && !pi_is_pir_empty(pi_desc));
> >  }
> >  
> > +static void pi_update_wakeup_vector(void *data)
> > +{
> > +	struct vcpu_vmx *vmx;
> > +	struct kvm_vcpu *vcpu = data;
> > +
> > +	vmx = to_vmx(vcpu);
> > +
> > +	/* race with pi_post_block ? */
> > +	if (vcpu->pre_pcpu != -1)
> 
> This seems wrong.  The funky code in __pi_pre_block() regarding pre_cpu muddies
> the waters, but I don't think it's safe to call __pi_pre_block() from a pCPU
> other than the pCPU that is associated with the vCPU.

From Intel's manual:

"29.6 POSTED-INTERRUPT PROCESSING

...

Use of the posted-interrupt descriptor differs from that of other
data structures that are referenced by pointers in a VMCS. There is a
general requirement that software ensure that each such data structure
is modified only when no logical processor with a current VMCS that
references it is in VMX non-root operation. That requirement does not
apply to the posted-interrupt descriptor. There is a requirement,
however, that such modifications be done using locked read-modify-write
instructions."

> If the vCPU is migrated after vmx_pi_start_assignment() grabs vcpu->cpu but
> before the IPI arrives (to run pi_update_wakeup_vector()), then it's possible
> that a different pCPU could be running __pi_pre_block() concurrently with this
> code.  If that happens, both pcPUs could see "vcpu->pre_cpu == -1" and corrupt
> the list due to a double list_add_tail.

Good point.

> The existing code is unnecessarily confusing, but unless I'm missing something,
> it's guaranteed to call pi_pre_block() from the pCPU that is associated with the
> pCPU, i.e. arguably it could/should use this_cpu_ptr(). 

Well problem is it might not exit kvm_vcpu_block(). However that can be
fixed.


>  Because the existing
> code grabs vcpu->cpu with IRQs disabled and is called only from KVM_RUN,
> vcpu->cpu is guaranteed to match the current pCPU since vcpu->cpu will be set to
> the current pCPU when the vCPU is scheduled in.
> 
> Assuming my analysis is correct (definitely not guaranteed), I'm struggling to
> come up with an elegant solution.  But, do we need an elegant solution?  E.g.
> can the start_assignment() hook simply kick all vCPUs with APICv active?
> 
> > +		return;
> > +
> > +	if (!vmx->in_blocked_section)
> > +		return;
> > +
> > +	__pi_pre_block(vcpu);
> > +}
> > +
> > +void vmx_pi_start_assignment(struct kvm *kvm, int device_count)
> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	int i;
> > +
> > +	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> > +		return;
> > +
> > +	/* only care about first device assignment */
> > +	if (device_count != 1)
> > +		return;
> > +
> > +	/* Update wakeup vector and add vcpu to blocked_vcpu_list */
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +		int pcpu;
> > +
> > +		if (!kvm_vcpu_apicv_active(vcpu))
> > +			continue;
> > +
> > +		preempt_disable();
> 
> Any reason not to do "cpu = get_cpu()"?  Might make sense to do that outside of
> the for-loop, too.

kvm_vcpu_kick seems cleaner, just need to add another arch
hook to allow kvm_vcpu_block() to return.

Thanks for the review! Will resend after testing.


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765F93FB653
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 14:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbhH3Mqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 08:46:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229957AbhH3Mqh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 08:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630327543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D+jzq5oZx1Has3OWiVMtuBB4fFZoD4UvCMmeyzOU7Ws=;
        b=A6btUu0bODBaSYNZBxX+F0jM+Qcxj4ndaQ2qrjy5hIZwG0dvTLDtLvwRHWL1wOG0yEI366
        5f7r/Vx919dt20lmseIQhI4e4N7OlACBRtAw9rEiLW/gNKTk4HrWy8EVnkjlTkKkekXnFj
        nU0MDB/oA2BQ/Hdz+UCicp7jFsiYRSE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-OLKGGL4RNie0RTmU3GXqpw-1; Mon, 30 Aug 2021 08:45:40 -0400
X-MC-Unique: OLKGGL4RNie0RTmU3GXqpw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57F10100CA8F;
        Mon, 30 Aug 2021 12:45:38 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 325FF60854;
        Mon, 30 Aug 2021 12:45:34 +0000 (UTC)
Message-ID: <0a8368d9f27e3c072865a415fd1ca90190d99d25.camel@redhat.com>
Subject: Re: [PATCH 2/2] VMX: nSVM: enter protected mode prior to returning
 to nested guest from SMM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Date:   Mon, 30 Aug 2021 15:45:33 +0300
In-Reply-To: <YSfAAYN/Ng/L1IMa@google.com>
References: <20210826095750.1650467-1-mlevitsk@redhat.com>
         <20210826095750.1650467-3-mlevitsk@redhat.com>
         <YSfAAYN/Ng/L1IMa@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-08-26 at 16:23 +0000, Sean Christopherson wrote:
> On Thu, Aug 26, 2021, Maxim Levitsky wrote:
> > SMM return code switches CPU to real mode, and
> > then the nested_vmx_enter_non_root_mode first switches to vmcs02,
> > and then restores CR0 in the KVM register cache.
> > 
> > Unfortunately when it restores the CR0, this enables the protection mode
> > which leads us to "restore" the segment registers from
> > "real mode segment cache", which is not up to date vs L2 and trips
> > 'vmx_guest_state_valid check' later, when the
> > unrestricted guest mode is not enabled.
> 
> I suspect this is slightly inaccurate.  When loading vmcs02, vmx_switch_vmcs()
> will do vmx_register_cache_reset(), which also causes the segment cache to be
> reset.  enter_pmode() will still load stale values, but they'll come from vmcs02,
> not KVM's segment register cache.
> 
> > This happens to work otherwise, because after we enter the nested guest,
> > we restore its register state again from SMRAM with correct values
> > and that includes the segment values.
> > 
> > As a workaround to this if we enter protected mode first,
> > then setting CR0 won't cause this damage.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 0c2c0d5ae873..805c415494cf 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7507,6 +7507,13 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> >  	}
> >  
> >  	if (vmx->nested.smm.guest_mode) {
> > +
> > +		/*
> > +		 * Enter protected mode to avoid clobbering L2's segment
> > +		 * registers during nested guest entry
> > +		 */
> > +		vmx_set_cr0(vcpu, vcpu->arch.cr0 | X86_CR0_PE);
> 
> I'd really, really, reaaaally like to avoid stuffing state.  All of the instances
> I've come across where KVM has stuffed state for something like this were just
> papering over one symptom of an underlying bug.

I can't agree more with you on this. I even called this patch a hack in the cover letter,
because I didn't like it either.


> 
> For example, won't this now cause the same bad behavior if L2 is in Real Mode?
> 
> Is the problem purely that emulation_required is stale?  If so, how is it stale?
> Every segment write as part of RSM emulation should reevaluate emulation_required
> via vmx_set_segment().

So this is what is happening:

1. rsm emulation switches the vCPU from the 64 bit protected mode (since BIOS SMM handler
   of course switches to it) to real mode via CR0 write.

   Here 'enter_rmode' is called which saves current segment register values in 'real mode segemnt cache',
   and then fixes the values in VMCS to 'work' in vm86 mode. The saved architectural values in that 'cache'
   are then used, when trying to read them (e.g via vmx_get_segment)

2. vmx_leave_smm is called which calls nested_vmx_enter_non_root_mode
   this is unusually done in real mode, while otherwise VMX non root mode entry is
   only possible from protected mode (all vmx instructions #UD in real mode).

3. nested_vmx_enter_non_root_mode first thing switches to vmcb02 by vmx_switch_vmcs
   which 'loads' the L2 segments, because it zeros the segment cache via vmx_register_cache_reset),
   so any attempt to read them will read them from vmcs02.

   That means that at this point all good segment values are loaded.

4. Now prepare_vmcs02 is called which eventually sets KVM's CR0 using 'vmx_set_cr0'

   At that point that function notices that we are entering protected mode and thus 
   enter_pmode is called, which first reads the segment values from the real mode segment
   cache (which reflect sadly change to CS that rsm emulation did), updates their base & selectors
   but not segment types, and writes back these segments, corrupting the L2 state.

   The code is:

   vmx_get_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_CS], VCPU_SREG_CS); // reads segment cache since vmx->rmode.vm86_active = 1;
   ...
   vmx->rmode.vm86_active = 0;
   ...
   fix_pmode_seg(vcpu, VCPU_SREG_CS, &vmx->rmode.segs[VCPU_SREG_CS]):
	__vmx_set_segment(vcpu, save, seg);


My hack was to avoid all this by setting protected mode first and then doing the nested
entry, which is more natural as I said above.


> 
> Oooooh, or are you talking about the explicit vmx_guest_state_valid() in prepare_vmcs02()?
> If that's the case, then we likely should skip that check entirely.  The only part
> I'm not 100% clear on is whether or not it can/should be skipped for vmx_set_nested_state().

Yes. Initially in the first version (which I didn't post) of the patches I indeed just removed this check and it 
works sans another fix which is correct to have anyway,
(see note below).

The L2 will briefly have invalid state and it will be fixed by loading registers from SMRAM.
 
 
For vmx_set_nested_state I suspect something similiar can happen at least in theory:
We load the nested state, and then restore the registers, and only then the state becomes valid.

So it makes sense to remove this check for all but from_entry==true case.
 
However we do need to extend the check in vmx_vcpu_run that if the guest state is not valid and we
are nested, then fail instead of emulating.
I'll do this.
 

NOTE: There is another fix that has to be done if I remove the
check for validity of the nested state in nested_vmx_enter_non_root_mode, instead of stuffing
the protected mode state hack:

This is what is happening:
 
1. rsm emulation switches vCPU (that is vmcs01) to real mode, this state is left in vmcs01
This means that now L1 state is not valid as well!
(but with my hack that switches vCPU to protected mode, this doesn't happen accidentaly!)
 

2. We switch to vmcb02, L2 state temporary invalid as it has protected mode segments and real mode. 

3. rsm emulation loads L2 registers from SMBASE, and makes the L2 state valid again.
 
4. we (optionally) enter L2
 
5. we exit to L1. L1 guest state is real mode, and invalid now.

We overwrite L1's guest state with vmcb12 host state which is *valid*, however the way the
'load_vmcs12_host_state' works, is that it uses __vmx_set_segment which doesn't update
'emulation_required', and thus the L1 state doesn't become valid, 
we try to emulate it and crash eventually as the emulator can't really emulate everything.

I am now posting a new version of my SMM fixes with title '[PATCH v2 0/6] KVM: few more SMM fixes' 
(I merged the SVM and VMX fixes in single patch series), and I include all of the above there.

Thanks again for the review!
  
Best regards,
	Maxim Levitsky


> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..20bd84554c1f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2547,7 +2547,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>          * which means L1 attempted VMEntry to L2 with invalid state.
>          * Fail the VMEntry.
>          */
> -       if (CC(!vmx_guest_state_valid(vcpu))) {
> +       if (from_vmentry && CC(!vmx_guest_state_valid(vcpu))) {
>                 *entry_failure_code = ENTRY_FAIL_DEFAULT;
>                 return -EINVAL;
>         }
> 
> 
> If we want to retain the check for the common vmx_set_nested_state() path, i.e.
> when the vCPU is truly being restored to guest mode, then we can simply exempt
> the smm.guest_mode case (which also exempts that case when its set via
> vmx_set_nested_state()).  The argument would be that RSM is going to restore L2
> state, so whatever happens to be in vmcs12/vmcs02 is stale.
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..ac30ba6a8592 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2547,7 +2547,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>          * which means L1 attempted VMEntry to L2 with invalid state.
>          * Fail the VMEntry.
>          */
> -       if (CC(!vmx_guest_state_valid(vcpu))) {
> +       if (!vmx->nested.smm.guest_mode && CC(!vmx_guest_state_valid(vcpu))) {
>                 *entry_failure_code = ENTRY_FAIL_DEFAULT;
>                 return -EINVAL;
>         }
> 





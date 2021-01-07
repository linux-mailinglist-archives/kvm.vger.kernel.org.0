Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4EF2ECD09
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbhAGJmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:42:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726326AbhAGJmo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 04:42:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610012477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MFuGyimC71glr5vnCpEbH1WiNIlV5NaV4jZlWQNDsbY=;
        b=Vo4NgCPjXYVOSU9CdzlgmGrsUlK4pB5Ono1iSFFeq/7yD8laxiEIU4Rn5gFMtazgVPzdMz
        /vN7kB/YyQs/78d3c+pPWB4u/3dQvSajXExHqJ984M6WSuzpDtm1NpEaS51AJY7L/FdSoO
        qkz0cD4EELrM4HQPhDv2y7arR/VY9C0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-8q9LojcNNF-ZaCgBrfssvg-1; Thu, 07 Jan 2021 04:41:13 -0500
X-MC-Unique: 8q9LojcNNF-ZaCgBrfssvg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D7C018C89D9;
        Thu,  7 Jan 2021 09:41:11 +0000 (UTC)
Received: from starship (unknown [10.35.206.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD1F310013BD;
        Thu,  7 Jan 2021 09:41:07 +0000 (UTC)
Message-ID: <9a306aa2a5e6741cfd7d03fcf489389e895d651a.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: nVMX: fix for disappearing L1->L2 event
 injection on L1 migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Thu, 07 Jan 2021 11:41:01 +0200
In-Reply-To: <4e9db353de15333e17e023c91e2e0b4ec3d880c7.camel@redhat.com>
References: <20210106105306.450602-1-mlevitsk@redhat.com>
         <20210106105306.450602-3-mlevitsk@redhat.com> <X/X+1q6H/q1Ez6zE@google.com>
         <4e9db353de15333e17e023c91e2e0b4ec3d880c7.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-07 at 04:38 +0200, Maxim Levitsky wrote:
> On Wed, 2021-01-06 at 10:17 -0800, Sean Christopherson wrote:
> > On Wed, Jan 06, 2021, Maxim Levitsky wrote:
> > > If migration happens while L2 entry with an injected event to L2 is pending,
> > > we weren't including the event in the migration state and it would be
> > > lost leading to L2 hang.
> > 
> > But the injected event should still be in vmcs12 and KVM_STATE_NESTED_RUN_PENDING
> > should be set in the migration state, i.e. it should naturally be copied to
> > vmcs02 and thus (re)injected by vmx_set_nested_state().  Is nested_run_pending
> > not set?  Is the info in vmcs12 somehow lost?  Or am I off in left field...
> 
> You are completely right. 
> The injected event can be copied like that since the vmc(b|s)12 is migrated.
> 
> We can safely disregard both these two patches and the parallel two patches for SVM.
> I am almost sure that the real root cause of this bug was that we 
> weren't restoring the nested run pending flag, and I even 
> happened to fix this in this patch series.
> 
> This is the trace of the bug (I removed the timestamps to make it easier to read)
> 
> 
> kvm_exit:             vcpu 0 reason vmrun rip 0xffffffffa0688ffa info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
> kvm_nested_vmrun:     rip: 0xffffffffa0688ffa vmcb: 0x0000000103594000 nrip: 0xffffffff814b3b01 int_ctl: 0x01000001 event_inj: 0x80000036 npt: on
> 																^^^ this is the injection
> kvm_nested_intercepts: cr_read: 0010 cr_write: 0010 excp: 00060042 intercepts: bc4c8027 00006e7f 00000000
> kvm_fpu:              unload
> kvm_userspace_exit:   reason KVM_EXIT_INTR (10)
> 
> ============================================================================
> migration happens here
> ============================================================================
> 
> ...
> kvm_async_pf_ready:   token 0xffffffff gva 0
> kvm_apic_accept_irq:  apicid 0 vec 243 (Fixed|edge)
> 
> kvm_nested_intr_vmexit: rip: 0x000000000000fff0
> 
> ^^^^^ this is the nested vmexit that shouldn't have happened, since nested run is pending,
> and which erased the eventinj field which was migrated correctly just like you say.
> 
> kvm_nested_vmexit_inject: reason: interrupt ext_inf1: 0x0000000000000000 ext_inf2: 0x0000000000000000 ext_int: 0x00000000 ext_int_err: 0x00000000
> ...
> 
> 
> We did notice that this vmexit had a wierd RIP and I 
> even explained this later to myself,
> that this is the default RIP which we put to vmcb, 
> and it wasn't yet updated, since it updates just prior to vm entry.
> 
> My test already survived about 170 iterations (usually it crashes after 20-40 iterations)
> I am leaving the stress test running all night, let see if it survives.

And after leaving it overnight, the test survived about 1000 iterations.

Thanks again!

Best regards,
	Maxim Levitstky


> 
> V2 of the patches is on the way.
> 
> Thanks again for the help!
> 
> Best regards,
> 	Maxim Levitsky
> 
> >  
> > > Fix this by queueing the injected event in similar manner to how we queue
> > > interrupted injections.
> > > 
> > > This can be reproduced by running an IO intense task in L2,
> > > and repeatedly migrating the L1.
> > > 
> > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 12 ++++++------
> > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index e2f26564a12de..2ea0bb14f385f 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -2355,12 +2355,12 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> > >  	 * Interrupt/Exception Fields
> > >  	 */
> > >  	if (vmx->nested.nested_run_pending) {
> > > -		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
> > > -			     vmcs12->vm_entry_intr_info_field);
> > > -		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE,
> > > -			     vmcs12->vm_entry_exception_error_code);
> > > -		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
> > > -			     vmcs12->vm_entry_instruction_len);
> > > +		if ((vmcs12->vm_entry_intr_info_field & VECTORING_INFO_VALID_MASK))
> > > +			vmx_process_injected_event(&vmx->vcpu,
> > > +						   vmcs12->vm_entry_intr_info_field,
> > > +						   vmcs12->vm_entry_instruction_len,
> > > +						   vmcs12->vm_entry_exception_error_code);
> > > +
> > >  		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
> > >  			     vmcs12->guest_interruptibility_info);
> > >  		vmx->loaded_vmcs->nmi_known_unmasked =
> > > -- 
> > > 2.26.2
> > > 



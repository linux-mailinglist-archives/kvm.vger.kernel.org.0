Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899903736E8
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 11:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhEEJTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 05:19:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232004AbhEEJTA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 05:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620206283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=415wEsC8n9BJdmBQmML4a0Ibe+0Z2SD9yQc1XMDCU8o=;
        b=Fhiyrnn/W6cOckyMEnAqxjg2XbYYzmE8MdTKWSCQgR5+s1TpWc+ww5aWF9xZAW07ucndiB
        +CLvuzNtcrJo2vRsdfD1Fh4KbQLtQ6NmDcg6tSKeFPTJKxIlq/3hwKi5pV0+ChjWIBLbjX
        gtgc5H76q4NxwewvyE7HasBUYYdOvIE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-LvPCUHrfMDWCRHW8j8JHfA-1; Wed, 05 May 2021 05:18:00 -0400
X-MC-Unique: LvPCUHrfMDWCRHW8j8JHfA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82370107ACCD;
        Wed,  5 May 2021 09:17:58 +0000 (UTC)
Received: from starship (unknown [10.40.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 388DD10023AB;
        Wed,  5 May 2021 09:17:55 +0000 (UTC)
Message-ID: <571ba73f9a867cff4483f7218592f7deb1405ff8.camel@redhat.com>
Subject: Re: [PATCH 1/4] KVM: nVMX: Always make an attempt to map eVMCS
 after migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 05 May 2021 12:17:55 +0300
In-Reply-To: <87a6p9y3q0.fsf@vitty.brq.redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
         <20210503150854.1144255-2-vkuznets@redhat.com>
         <d56429a80d9c6118370c722d5b3a90b5669e2411.camel@redhat.com>
         <87a6p9y3q0.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-05-05 at 10:39 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Mon, 2021-05-03 at 17:08 +0200, Vitaly Kuznetsov wrote:
> > > When enlightened VMCS is in use and nested state is migrated with
> > > vmx_get_nested_state()/vmx_set_nested_state() KVM can't map evmcs
> > > page right away: evmcs gpa is not 'struct kvm_vmx_nested_state_hdr'
> > > and we can't read it from VP assist page because userspace may decide
> > > to restore HV_X64_MSR_VP_ASSIST_PAGE after restoring nested state
> > > (and QEMU, for example, does exactly that). To make sure eVMCS is
> > > mapped /vmx_set_nested_state() raises KVM_REQ_GET_NESTED_STATE_PAGES
> > > request.
> > > 
> > > Commit f2c7ef3ba955 ("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
> > > on nested vmexit") added KVM_REQ_GET_NESTED_STATE_PAGES clearing to
> > > nested_vmx_vmexit() to make sure MSR permission bitmap is not switched
> > > when an immediate exit from L2 to L1 happens right after migration (caused
> > > by a pending event, for example). Unfortunately, in the exact same
> > > situation we still need to have eVMCS mapped so
> > > nested_sync_vmcs12_to_shadow() reflects changes in VMCS12 to eVMCS.
> > > 
> > > As a band-aid, restore nested_get_evmcs_page() when clearing
> > > KVM_REQ_GET_NESTED_STATE_PAGES in nested_vmx_vmexit(). The 'fix' is far
> > > from being ideal as we can't easily propagate possible failures and even if
> > > we could, this is most likely already too late to do so. The whole
> > > 'KVM_REQ_GET_NESTED_STATE_PAGES' idea for mapping eVMCS after migration
> > > seems to be fragile as we diverge too much from the 'native' path when
> > > vmptr loading happens on vmx_set_nested_state().
> > > 
> > > Fixes: f2c7ef3ba955 ("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit")
> > > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++++++----------
> > >  1 file changed, 19 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 1e069aac7410..2febb1dd68e8 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3098,15 +3098,8 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
> > >  			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
> > >  
> > >  		if (evmptrld_status == EVMPTRLD_VMFAIL ||
> > > -		    evmptrld_status == EVMPTRLD_ERROR) {
> > > -			pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
> > > -					     __func__);
> > > -			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> > > -			vcpu->run->internal.suberror =
> > > -				KVM_INTERNAL_ERROR_EMULATION;
> > > -			vcpu->run->internal.ndata = 0;
> > > +		    evmptrld_status == EVMPTRLD_ERROR)
> > >  			return false;
> > > -		}
> > >  	}
> > >  
> > >  	return true;
> > > @@ -3194,8 +3187,16 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> > >  
> > >  static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
> > >  {
> > > -	if (!nested_get_evmcs_page(vcpu))
> > > +	if (!nested_get_evmcs_page(vcpu)) {
> > > +		pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
> > > +				     __func__);
> > > +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> > > +		vcpu->run->internal.suberror =
> > > +			KVM_INTERNAL_ERROR_EMULATION;
> > > +		vcpu->run->internal.ndata = 0;
> > > +
> > >  		return false;
> > > +	}
> > 
> > Hi!
> > 
> > Any reason to move the debug prints out of nested_get_evmcs_page?
> > 
> 
> Debug print could've probably stayed or could've been dropped
> completely -- I don't really believe it's going to help
> anyone. Debugging such issues without instrumentation/tracing seems to
> be hard-to-impossible...
> 
> > >  
> > >  	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
> > >  		return false;
> > > @@ -4422,7 +4423,15 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
> > >  	/* trying to cancel vmlaunch/vmresume is a bug */
> > >  	WARN_ON_ONCE(vmx->nested.nested_run_pending);
> > >  
> > > -	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> > > +	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> > > +		/*
> > > +		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
> > > +		 * Enlightened VMCS after migration and we still need to
> > > +		 * do that when something is forcing L2->L1 exit prior to
> > > +		 * the first L2 run.
> > > +		 */
> > > +		(void)nested_get_evmcs_page(vcpu);
> > > +	}
> > Yes this is a band-aid, but it has to be done I agree.
> > 
> 
> To restore the status quo, yes.
> 
> > >  
> > >  	/* Service the TLB flush request for L2 before switching to L1. */
> > >  	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
> > 
> > 
> > 
> > I also tested this and it survives a bit better (used to crash instantly
> > after a single migration cycle, but the guest still crashes after around ~20 iterations of my 
> > regular nested migration test).
> > 
> > Blues screen shows that stop code is HYPERVISOR ERROR and nothing else.
> > 
> > I tested both this patch alone and all 4 patches.
> > 
> > Without evmcs, the same VM with same host kernel and qemu survived an overnight
> > test and passed about 1800 migration iterations.
> > (my synthetic migration test doesn't yet work on Intel, I need to investigate why)
> > 
> 
> It would be great to compare on Intel to be 100% sure the issue is eVMCS
> related, Hyper-V may be behaving quite differently on AMD.
Hi!

I tested this on my Intel machine with and without eVMCS, without changing
any other parameters, running the same VM from a snapshot.

As I said without eVMCS the test survived overnight stress of ~1800 migrations.
With eVMCs, it fails pretty much on first try. 
With those patches, it fails after about 20 iterations.

Best regards,
	Maxim Levitsky

> 
> > For reference this is the VM that you gave me to test, kvm/queue kernel,
> > with merged mainline in it,
> > and mostly latest qemu (updated about a week ago or so)
> > 
> > qemu: 3791642c8d60029adf9b00bcb4e34d7d8a1aea4d
> > kernel: 9f242010c3b46e63bc62f08fff42cef992d3801b and
> >         then merge v5.12 from mainline.
> 
> Thanks for testing! I'll try to come up with a selftest for this issue,
> maybe it'll help us discovering others)
> 



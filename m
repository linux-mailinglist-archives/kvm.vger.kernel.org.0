Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FC23550C2
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 12:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245073AbhDFKXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 06:23:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242846AbhDFKXO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 06:23:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617704586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XFA+1T51DRXqHeUXo/P3ZvB0hY4DzAOsO3PZnz0QC7k=;
        b=hdzz3ZCFrreZgFzshtXCFHa3yT78PTnxmJTpMrL/u0Lezx0uxbpVLMxArds0H/Uba+aX0G
        gVQqZgR41TSKUy+SL0+UIyXBLCofJYlVazsgEiSkRil0/7YFujfagmLUsKl10PR6Up6UUz
        Dnvq99ecWFBsz3B2Pvj332a/4NjHOo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-cQKMOWESMUS4jgCP-mT35g-1; Tue, 06 Apr 2021 06:23:05 -0400
X-MC-Unique: cQKMOWESMUS4jgCP-mT35g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B64B1800D50;
        Tue,  6 Apr 2021 10:23:03 +0000 (UTC)
Received: from starship (unknown [10.35.206.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D1A25D9D0;
        Tue,  6 Apr 2021 10:22:59 +0000 (UTC)
Message-ID: <a60c81d35b3f35950486abd99b14a0931adf6848.camel@redhat.com>
Subject: Re: [PATCH 1/6] KVM: nVMX: delay loading of PDPTRs to
 KVM_REQ_GET_NESTED_STATE_PAGES
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Date:   Tue, 06 Apr 2021 13:22:58 +0300
In-Reply-To: <YGdUBvliVWoF0tVl@google.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
         <20210401141814.1029036-2-mlevitsk@redhat.com>
         <YGdUBvliVWoF0tVl@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-04-02 at 17:27 +0000, Sean Christopherson wrote:
> On Thu, Apr 01, 2021, Maxim Levitsky wrote:
> > Similar to the rest of guest page accesses after migration,
> > this should be delayed to KVM_REQ_GET_NESTED_STATE_PAGES
> > request.
> 
> FWIW, I still object to this approach, and this patch has a plethora of issues.
> 
> I'm not against deferring various state loading to KVM_RUN, but wholesale moving
> all of GUEST_CR3 processing without in-depth consideration of all the side
> effects is a really bad idea.
It could be, I won't argue about this.

> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index fd334e4aa6db..b44f1f6b68db 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2564,11 +2564,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> >  		return -EINVAL;
> >  	}
> >  
> > -	/* Shadow page tables on either EPT or shadow page tables. */
> > -	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
> > -				entry_failure_code))
> > -		return -EINVAL;
> > -
> >  	/*
> >  	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
> >  	 * on nested VM-Exit, which can occur without actually running L2 and
> > @@ -3109,11 +3104,16 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
> >  static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> > +	enum vm_entry_failure_code entry_failure_code;
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> >  	struct kvm_host_map *map;
> >  	struct page *page;
> >  	u64 hpa;
> >  
> > +	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
> > +				&entry_failure_code))
> 
> This results in KVM_RUN returning 0 without filling vcpu->run->exit_reason.
> Speaking from experience, debugging those types of issues is beyond painful.
> 
> It also means CR3 is double loaded in the from_vmentry case.
> 
> And it will cause KVM to incorrectly return NVMX_VMENTRY_KVM_INTERNAL_ERROR
> if a consistency check fails when nested_get_vmcs12_pages() is called on
> from_vmentry.  E.g. run unit tests with this and it will silently disappear.

I do remember now that you said something about this, but I wasn't able
to find it in my email. Sorry about this.
I agree with you.

I think that a question I should ask is why do we really need to 
delay accessing guest memory after a migration.

So far I mostly just assumed that we need to do so, thinking that qemu
updates the memslots or something, or maybe because guest memory
isn't fully migrated and relies on post-copy to finish it.

Also I am not against leaving CR3 processing in here and doing only PDPTR load
in KVM_RUN (and only when *SREG2 API is not used).

> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index bbb006a..b8ccc69 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8172,6 +8172,16 @@ static void test_guest_segment_base_addr_fields(void)
>         vmcs_write(GUEST_AR_ES, ar_saved);
>  }
> 
> +static void test_guest_cr3(void)
> +{
> +       u64 cr3_saved = vmcs_read(GUEST_CR3);
> +
> +       vmcs_write(GUEST_CR3, -1ull);
> +       test_guest_state("Bad CR3 fails VM-Enter", true, -1ull, "GUEST_CR3");
> +
> +       vmcs_write(GUEST_DR7, cr3_saved);
> +}
> +
Could you send this test to kvm unit tests?

>  /*
>   * Check that the virtual CPU checks the VMX Guest State Area as
>   * documented in the Intel SDM.
> @@ -8181,6 +8191,8 @@ static void vmx_guest_state_area_test(void)
>         vmx_set_test_stage(1);
>         test_set_guest(guest_state_test_main);
> 
> +       test_guest_cr3();
> +
>         /*
>          * The IA32_SYSENTER_ESP field and the IA32_SYSENTER_EIP field
>          * must each contain a canonical address.
> 
> 
> > +		return false;
> > +
> >  	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
> >  		/*
> >  		 * Translate L1 physical address to host physical
> > @@ -3357,6 +3357,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> >  	}
> >  
> >  	if (from_vmentry) {
> > +		if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3,
> > +		    nested_cpu_has_ept(vmcs12), &entry_failure_code))
> 
> This alignment is messed up; it looks like two separate function calls.
Sorry about this, I see it now.
> 
> > +			goto vmentry_fail_vmexit_guest_mode;
> > +
> >  		failed_index = nested_vmx_load_msr(vcpu,
> >  						   vmcs12->vm_entry_msr_load_addr,
> >  						   vmcs12->vm_entry_msr_load_count);
> > -- 
> > 2.26.2
> > 


Best regards,
	Maxim Levitsky



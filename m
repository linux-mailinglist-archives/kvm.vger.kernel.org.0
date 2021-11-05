Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E304E4465E8
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 16:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhKEPmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 11:42:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231133AbhKEPmw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 11:42:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636126812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oy5dLZ284BPxjfWFSZAw1huCzFf9EBGFoWcl998xsQY=;
        b=Ii5k03UHQkb4SwFAeLTEL9mB00bsopr48zfCphFTf/s4w+RnPG0kYDFr9NoUiS5LEqHeLD
        C1+HlNr7U7g7YyeOZhxp8J2LQb0m9+pw7CHPKVx2p79WbAKtyNOHVn+LnP+59BoXodZg7R
        X+FmUx0WQQ6d7n8VjP8XbJ69B8JkwbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-50unf0LYMwKFYaxfjWr_gg-1; Fri, 05 Nov 2021 11:40:09 -0400
X-MC-Unique: 50unf0LYMwKFYaxfjWr_gg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C27421927803;
        Fri,  5 Nov 2021 15:40:08 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4929679457;
        Fri,  5 Nov 2021 15:39:51 +0000 (UTC)
Message-ID: <e36298eaa7f6663a9afd5045a0ee02398f05dd1b.camel@redhat.com>
Subject: Re: [PATCH v3 1/4] KVM: nVMX: Don't use Enlightened MSR Bitmap for
 L3
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Fri, 05 Nov 2021 17:39:50 +0200
In-Reply-To: <8942e8892b1567354c7e3f3269c0c7baefb9d8c2.camel@redhat.com>
References: <20211013142258.1738415-1-vkuznets@redhat.com>
         <20211013142258.1738415-2-vkuznets@redhat.com>
         <YYSAPotqLVIScunK@google.com>
         <8942e8892b1567354c7e3f3269c0c7baefb9d8c2.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-11-05 at 17:38 +0200, Maxim Levitsky wrote:
> On Fri, 2021-11-05 at 00:52 +0000, Sean Christopherson wrote:
> > On Wed, Oct 13, 2021, Vitaly Kuznetsov wrote:
> > > 3-level nesting is also not a very common setup nowadays.
> > 
> > Says who? :-D
> 
> I regularly test 4 level nesting :P
> It's KVM all the way down.... 
>  
> But jokes aside 3 level nesting will start to happen occasionally more and more often,
> IMHO with windows guests which have accidently/or on purpose enabled HypoerV/Core isolation/WSL3 inside,

*insert some joke about coffee here* 

I mean HyperV/Core Isolation/WSL2. There is no WSL3 yet :)

Best regards,
	Maxim Levitsky
> and that are run nested on KVM.
>  
> Just FYI. I have a patch series pending (reviews are welcome!) which implement nested vVMLOAD/vVMSAVE and
> vGIF which allows L1 to use these optional SVM features to run its nested guests (that is L3s) faster.
> (This series is the reason I was recently stress testing 3/4 level nesting. 
>  
> 4 levels usually work so slow that VM doesn't boot and timeouts in various systemd settings).
> 3rd level works not that bad IMHO.
> 
> All that said I don't have any objections to the patch itself.
> 
> 
> Best regards,
> 	Maxim Levitsky
> > > Don't enable 'Enlightened MSR Bitmap' feature for KVM's L2s (real L3s) for
> > > now.
> > > 
> > > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 21 ++++++++++++---------
> > >  1 file changed, 12 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 1c8b2b6e7ed9..e82cdde58119 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -2655,15 +2655,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
> > >  		if (!loaded_vmcs->msr_bitmap)
> > >  			goto out_vmcs;
> > >  		memset(loaded_vmcs->msr_bitmap, 0xff, PAGE_SIZE);
> > > -
> > > -		if (IS_ENABLED(CONFIG_HYPERV) &&
> > > -		    static_branch_unlikely(&enable_evmcs) &&
> > > -		    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
> > > -			struct hv_enlightened_vmcs *evmcs =
> > > -				(struct hv_enlightened_vmcs *)loaded_vmcs->vmcs;
> > > -
> > > -			evmcs->hv_enlightenments_control.msr_bitmap = 1;
> > > -		}
> > >  	}
> > >  
> > >  	memset(&loaded_vmcs->host_state, 0, sizeof(struct vmcs_host_state));
> > > @@ -6903,6 +6894,18 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
> > >  
> > >  	vmx->loaded_vmcs = &vmx->vmcs01;
> > >  
> > > +	/*
> > > +	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
> > > +	 * nested (L1) hypervisor and Hyper-V in L0 supports it.
> > 
> > And maybe call out specifically that KVM intentionally uses this only for vmcs02?
> > 
> > > +	 */
> > > +	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)
> > > +	    && (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
> > 
> > && on the previous line, I think we'll survive the 82 char line :-)
> > 
> > > +		struct hv_enlightened_vmcs *evmcs =
> > > +			(struct hv_enlightened_vmcs *)vmx->loaded_vmcs->vmcs;
> > 
> > Hmm, what about landing this right after vmcs01's VMCS is allocated?  It's kinda
> > weird, but it makes it more obvious that ->vmcs is not NULL.  And if the cast is
> > simply via a "void *" it all fits on one line.
> > 
> > 	err = alloc_loaded_vmcs(&vmx->vmcs01);
> > 	if (err < 0)
> > 		goto free_pml;
> > 
> > 	/*
> > 	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
> > 	 * nested (L1) hypervisor and Hyper-V in L0 supports it.  Enable an
> > 	 * enlightened bitmap only for vmcs01, KVM currently isn't equipped to
> > 	 * realize any performance benefits from enabling it for vmcs02.
> > 	 */ 
> > 	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
> > 	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
> > 		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
> > 
> > 		evmcs->hv_enlightenments_control.msr_bitmap = 1;
> > 	}
> > 
> > > +
> > > +		evmcs->hv_enlightenments_control.msr_bitmap = 1;
> > > +	}
> > > +
> > >  	if (cpu_need_virtualize_apic_accesses(vcpu)) {
> > >  		err = alloc_apic_access_page(vcpu->kvm);
> > >  		if (err)
> > > -- 
> > > 2.31.1
> > > 



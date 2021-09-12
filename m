Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8983407CDF
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 12:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhILKhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 06:37:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhILKhS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 06:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631442964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SJrlF3qoDx/aav2O69lvlRtO6fUeYfbdtCxqNNdYeAU=;
        b=TBUJE16fnbDz0tff0kVF+ZPDEZ728gGMwpw8Xm7HS3dZcbCRWlAbshMPPUqZBLgRbNRUx0
        pyC0z3QzGQUU6C8JNnSNBa8qWCmqs5q9ETvNmxTHtyy4rvHCtEbrKByjM2sfUOM03Ilwu0
        /xv7IqlkSAkwh+tUoyIVDjIC4fyql8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-EGGFgw44MBKK-GYQVldqYw-1; Sun, 12 Sep 2021 06:36:00 -0400
X-MC-Unique: EGGFgw44MBKK-GYQVldqYw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34F7E1808300;
        Sun, 12 Sep 2021 10:35:59 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A338A60C04;
        Sun, 12 Sep 2021 10:35:54 +0000 (UTC)
Message-ID: <5fb5397289ba9ad44c9c959a5ecc4a1cfce72f00.camel@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: nSVM: call KVM_REQ_GET_NESTED_STATE_PAGES
 on exit from SMM mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Sun, 12 Sep 2021 13:35:53 +0300
In-Reply-To: <YTlcgQHLmkjtvVks@google.com>
References: <20210823114618.1184209-1-mlevitsk@redhat.com>
         <20210823114618.1184209-4-mlevitsk@redhat.com>
         <YTlcgQHLmkjtvVks@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-09-09 at 00:59 +0000, Sean Christopherson wrote:
> On Mon, Aug 23, 2021, Maxim Levitsky wrote:
> > This allows nested SVM code to be more similar to nested VMX code.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 9 ++++++---
> >  arch/x86/kvm/svm/svm.c    | 8 +++++++-
> >  arch/x86/kvm/svm/svm.h    | 3 ++-
> >  3 files changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 5e13357da21e..678fd21f6077 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -572,7 +572,7 @@ static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to
> >  }
> >  
> >  int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
> > -			 struct vmcb *vmcb12)
> > +			 struct vmcb *vmcb12, bool from_entry)
> 
> from_vmrun would be a better name.  VMX uses the slightly absstract from_vmentry
> because of the VMLAUNCH vs. VMRESUME silliness.  If we want to explicitly follow
> VMX then from_vmentry would be more appropriate, but I don't see any reason not
> to be more precise.
OK.

> 
> >  {
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> >  	int ret;
> > @@ -602,13 +602,16 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
> >  	nested_vmcb02_prepare_save(svm, vmcb12);
> >  
> >  	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
> > -				  nested_npt_enabled(svm), true);
> > +				  nested_npt_enabled(svm), from_entry);
> >  	if (ret)
> >  		return ret;
> >  
> >  	if (!npt_enabled)
> >  		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
> >  
> > +	if (!from_entry)
> > +		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> > +
> >  	svm_set_gif(svm, true);
> >  
> >  	return 0;
> > @@ -674,7 +677,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> >  
> >  	svm->nested.nested_run_pending = 1;
> >  
> > -	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12))
> > +	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
> >  		goto out_exit_err;
> >  
> >  	if (nested_svm_vmrun_msrpm(svm))
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index ea7a4dacd42f..76ee15af8c48 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4354,6 +4354,12 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> >  			if (svm_allocate_nested(svm))
> >  				return 1;
> >  
> > +			/* Exit from the SMM to the non root mode also uses
> > +			 * the KVM_REQ_GET_NESTED_STATE_PAGES request,
> > +			 * but in this case the pdptrs must be always reloaded
> > +			 */
> > +			vcpu->arch.pdptrs_from_userspace = false;
> 
> Hmm, I think this belongs in the previous patch.  And I would probably go so far
> as to say it belongs in emulator_leave_smm(), i.e. pdptrs_from_userspace should
> be cleared on RSM regardless of what mode is being resumed.

I actually don't think that this belongs to a previous patch, since this issue didn't exist on SVM,
since it didn't call the KVM_REQ_GET_NESTED_STATE_PAGES.

However I do agree with you that it makes sense to move this hack to the common x86 code.
I had put it to kvm_smm_changed, and will soon send a new version.

> 
> > +
> >  			/*
> >  			 * Restore L1 host state from L1 HSAVE area as VMCB01 was
> >  			 * used during SMM (see svm_enter_smm())
> > @@ -4368,7 +4374,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> >  
> >  			vmcb12 = map.hva;
> >  			nested_load_control_from_vmcb12(svm, &vmcb12->control);
> > -			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
> > +			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
> >  
> >  			kvm_vcpu_unmap(vcpu, &map, true);
> >  			kvm_vcpu_unmap(vcpu, &map_save, true);
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 524d943f3efc..51ffa46ab257 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -459,7 +459,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
> >  	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
> >  }
> >  
> > -int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb_gpa, struct vmcb *vmcb12);
> > +int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
> > +		u64 vmcb_gpa, struct vmcb *vmcb12, bool from_entry);
> 
> Alignment is funky, it can/should match the definition, e.g.
Oops, forgot to check the prototype - these things you write once and forget about them,
as long as it compiles :-)

> 
> int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
> 			 struct vmcb *vmcb12, bool from_entry);
> 
> >  void svm_leave_nested(struct vcpu_svm *svm);
> >  void svm_free_nested(struct vcpu_svm *svm);
> >  int svm_allocate_nested(struct vcpu_svm *svm);
> > -- 
> > 2.26.3
> > 

Thanks for the review!

Best regards,
	Maxim Levitsky


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2373BE65D
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 12:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhGGKcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 06:32:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231406AbhGGKcV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 06:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625653781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36gdxuMNrjjiJ1bvDB0qOJiSWaHh3s756RYVqBBMqgs=;
        b=clmf21Nh706y1h5jNzTsJ1tFqx1O/iY5G1R63xIMxhwn9im45+4InwIhfsRpsBLJTxxsBc
        +0mELVuvINA5hZwThTOw7xpSm62iKbIvV8T74UxZdQ6zl7JmbWofQdCGw8ZzWcstUpf2z/
        i9lfhDtvBIK4d0klXW2k1BBhN7foX/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-eSoWamQsPlGUT9V5d_oqyg-1; Wed, 07 Jul 2021 06:29:38 -0400
X-MC-Unique: eSoWamQsPlGUT9V5d_oqyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAFB25074B;
        Wed,  7 Jul 2021 10:29:36 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A9155D6A8;
        Wed,  7 Jul 2021 10:29:33 +0000 (UTC)
Message-ID: <f6f4e6e26a33809bef8c4f799e9871027c613cb2.camel@redhat.com>
Subject: Re: [PATCH 3/6] KVM: nSVM: Introduce svm_copy_nonvmloadsave_state()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date:   Wed, 07 Jul 2021 13:29:32 +0300
In-Reply-To: <2c79e83c-376f-0e60-f089-84eae7e91f49@redhat.com>
References: <20210628104425.391276-1-vkuznets@redhat.com>
         <20210628104425.391276-4-vkuznets@redhat.com>
         <2c79e83c-376f-0e60-f089-84eae7e91f49@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-07-05 at 14:08 +0200, Paolo Bonzini wrote:
> On 28/06/21 12:44, Vitaly Kuznetsov wrote:
> > Separate the code setting non-VMLOAD-VMSAVE state from
> > svm_set_nested_state() into its own function. This is going to be
> > re-used from svm_enter_smm()/svm_leave_smm().
> > 
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> >   arch/x86/kvm/svm/nested.c | 36 +++++++++++++++++++++---------------
> >   arch/x86/kvm/svm/svm.h    |  2 ++
> >   2 files changed, 23 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 1c6b0698b52e..a1dec2c40181 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -697,6 +697,26 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> >   	return ret;
> >   }
> >   
> > +void svm_copy_nonvmloadsave_state(struct vmcb_save_area *from_save,
> > +				  struct vmcb_save_area *to_save)
> 
> Probably best to name this svm_copy_vmrun_state and perhaps (as a 
> cleanup) change nested_svm_vmloadsave to svm_copy_vmloadsave_state.

I agree with that. I would also add a comment to both 
svm_copy_vmloadsave_state and svm_copy_vmrun_state stating what they
are doing, like "this function copies state save area fields which
are used by vmrun"

Best regards,
	Maxim Levitsky


> 
> Paolo
> 
> > +{
> > +	to_save->es = from_save->es;
> > +	to_save->cs = from_save->cs;
> > +	to_save->ss = from_save->ss;
> > +	to_save->ds = from_save->ds;
> > +	to_save->gdtr = from_save->gdtr;
> > +	to_save->idtr = from_save->idtr;
> > +	to_save->rflags = from_save->rflags | X86_EFLAGS_FIXED;
> > +	to_save->efer = from_save->efer;
> > +	to_save->cr0 = from_save->cr0;
> > +	to_save->cr3 = from_save->cr3;
> > +	to_save->cr4 = from_save->cr4;
> > +	to_save->rax = from_save->rax;
> > +	to_save->rsp = from_save->rsp;
> > +	to_save->rip = from_save->rip;
> > +	to_save->cpl = 0;
> > +}
> > +
> >   void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
> >   {
> >   	to_vmcb->save.fs = from_vmcb->save.fs;
> > @@ -1360,21 +1380,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >   
> >   	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
> >   
> > -	svm->vmcb01.ptr->save.es = save->es;
> > -	svm->vmcb01.ptr->save.cs = save->cs;
> > -	svm->vmcb01.ptr->save.ss = save->ss;
> > -	svm->vmcb01.ptr->save.ds = save->ds;
> > -	svm->vmcb01.ptr->save.gdtr = save->gdtr;
> > -	svm->vmcb01.ptr->save.idtr = save->idtr;
> > -	svm->vmcb01.ptr->save.rflags = save->rflags | X86_EFLAGS_FIXED;
> > -	svm->vmcb01.ptr->save.efer = save->efer;
> > -	svm->vmcb01.ptr->save.cr0 = save->cr0;
> > -	svm->vmcb01.ptr->save.cr3 = save->cr3;
> > -	svm->vmcb01.ptr->save.cr4 = save->cr4;
> > -	svm->vmcb01.ptr->save.rax = save->rax;
> > -	svm->vmcb01.ptr->save.rsp = save->rsp;
> > -	svm->vmcb01.ptr->save.rip = save->rip;
> > -	svm->vmcb01.ptr->save.cpl = 0;
> > +	svm_copy_nonvmloadsave_state(save, &svm->vmcb01.ptr->save);
> >   
> >   	nested_load_control_from_vmcb12(svm, ctl);
> >   
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index f89b623bb591..ff2dac2b23b6 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -463,6 +463,8 @@ void svm_leave_nested(struct vcpu_svm *svm);
> >   void svm_free_nested(struct vcpu_svm *svm);
> >   int svm_allocate_nested(struct vcpu_svm *svm);
> >   int nested_svm_vmrun(struct kvm_vcpu *vcpu);
> > +void svm_copy_nonvmloadsave_state(struct vmcb_save_area *from_save,
> > +				  struct vmcb_save_area *to_save);
> >   void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
> >   int nested_svm_vmexit(struct vcpu_svm *svm);
> >   
> > 



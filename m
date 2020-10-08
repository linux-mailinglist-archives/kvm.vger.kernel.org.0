Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270372875DF
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 16:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgJHOTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 10:19:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729840AbgJHOTL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Oct 2020 10:19:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602166748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wKgG0k2iRRDI443tfzJfPAYzpG41wt9h/XxqXB3s6XU=;
        b=Mj+/EDejGCZ0IqQDVdGfr9Y9nw9meKx3ZP0ZSt2dd629wGKMU2neYz2Nmtc6VNZMRZ++fj
        nsCLAepRRGXjpPCg8U42ej2FAm5E6ruLv+Ob3f6F26K2ngVw8qs8JuIoZIhBOdmFmDT4cL
        /UIJDMo9XqayGplrmqDy/KE8Yx8gDg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-DSyNv9q8Pf61kC71Q9rOkQ-1; Thu, 08 Oct 2020 10:19:06 -0400
X-MC-Unique: DSyNv9q8Pf61kC71Q9rOkQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A52F87950C;
        Thu,  8 Oct 2020 14:19:04 +0000 (UTC)
Received: from starship (unknown [10.35.206.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FB236EF60;
        Thu,  8 Oct 2020 14:19:02 +0000 (UTC)
Message-ID: <928e0acecdcf0bcb75a99a9551ee2aa6def42022.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Use a separate vmcb for the nested L2 guest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
Date:   Thu, 08 Oct 2020 17:19:01 +0300
In-Reply-To: <be93feed-7425-32ea-3e64-99d398674bb1@redhat.com>
References: <20200917192306.2080-1-cavery@redhat.com>
         <587d1da1a037dd3ab7844c5cacc50bfda5ce6021.camel@redhat.com>
         <aaaadb29-6299-5537-47a9-072ca34ba512@redhat.com>
         <0007205290de75f04f5f2a92b891815438fd2f2f.camel@redhat.com>
         <fe491158e791fbe4381ee7fbe5aa050b4e78060e.camel@redhat.com>
         <51d447be4a6f430ed5cc60242457394aceb004e9.camel@redhat.com>
         <85ec3bfd-e46e-a6fa-b530-4dc87f0c7169@redhat.com>
         <fd60d936d1856cafc509c14efa7f2b98d8a1e2ce.camel@redhat.com>
         <be93feed-7425-32ea-3e64-99d398674bb1@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-10-08 at 09:52 -0400, Cathy Avery wrote:
> On 10/8/20 9:11 AM, Maxim Levitsky wrote:
> > On Thu, 2020-10-08 at 08:46 -0400, Cathy Avery wrote:
> > > On 10/8/20 6:54 AM, Maxim Levitsky wrote:
> > > > On Thu, 2020-10-08 at 13:39 +0300, Maxim Levitsky wrote:
> > > > > On Thu, 2020-10-08 at 13:23 +0300, Maxim Levitsky wrote:
> > > > > > On Thu, 2020-10-08 at 07:52 +0200, Paolo Bonzini wrote:
> > > > > > > On 08/10/20 00:14, Maxim Levitsky wrote:
> > > > > > > > > +	if (svm->vmcb01->control.asid == 0)
> > > > > > > > > +		svm->vmcb01->control.asid = svm->nested.vmcb02->control.asid;
> > > > > > > > I think that the above should be done always. The asid field is currently host
> > > > > > > > controlled only (that is L2 value is ignored, selective ASID tlb flush is not
> > > > > > > > advertized to the guest and lnvlpga is emulated as invlpg).
> > > > > > > Yes, in fact I suggested that ASID should be in svm->asid and moved to
> > > > > > > svm->vmcb->asid in svm_vcpu_run.  Then there's no need to special case
> > > > > > > it in nested code.
> > > > > > This makes lot of sense!
> > > > > > > This should be a patch coming before this one.
> > > > > > > 
> > > > > > > > 1. Something wrong with memory types - like guest is using UC memory for everything.
> > > > > > > >       I can't completely rule that out yet
> > > > > > > You can print g_pat and see if it is all zeroes.
> > > > > > I don't even need to print it. I know that it is never set anywhere, unless guest writes it,
> > > > > > but now that I look at it, we set it to a default value and there is no code to set it to
> > > > > > default value for vmcb02. This is it. now my fedora guest boots just fine!
> > > > > > 
> > > > > > I played a lot with g_pat, and yet this didn't occur to me . I was that close :-(
> > > > > > I knew that it has to be something with memory types, but it never occured to me
> > > > > > that guest just doesn't write IA32_PAT and uses our value which we set in init_vmcb
> > > > > > 
> > > > > > 
> > > > > > > In general I think it's better to be explicit with vmcb01 vs. vmcb02,
> > > > > > > like Cathy did, but I can see it's a matter of personal preference to
> > > > > > > some extent.
> > > > > > I also think so in general, but in the code that is outside 'is_guest_mode'
> > > > > > IMHO it is better to refer to vmcb01 as vmcb, although now that I think of
> > > > > > it, its not wrong to do so either.
> > > > > > 
> > > > > > 
> > > > > > My windows hyper-v guest doesn't boot though and I know why.
> > > > > > 
> > > > > > As we know the vmcb save area has extra state which vmrun/vmexit don't touch.
> > > > > > Now suppose a nested hypervisor wants to enter a nested guest.
> > > > > > 
> > > > > > It will do vmload, which will load the extra state from the nested vmcb (vmcb12
> > > > > > or as I woudl say the vmcb that nested hypervisor thinks that it is using),
> > > > > > to the CPU. This can cause some vmexits I think, but this doesn't matter much.
> > > > > > 
> > > > > > Now the nested hypervisor does vmrun. The extra state of L2 guest is in CPU registers,
> > > > > > and it is untouched. We do vmsave on vmcb01 to preserve that state, but later
> > > > > > when we do vmload on vmcb02 prior to vmenter on it, which loads stale state from it.
> > > > > > The same issue happens the other way around on nested vmexit.
> > > > > > 
> > > > > > I fixed this by doing nested_svm_vmloadsave, but that should be probably be
> > > > > > optimized with dirty bits. Now though I guess the goal it to make
> > > > > > it work first.
> > > > > > 
> > > > > > With this fixed HyperV boots fine, and even passes the 'works' test of booting
> > > > > > the windows 10 with hyperv enabled nested itself and starting the vm inside,
> > > > > > which makes that VM L3 (in addition to windows itself that runs as L3 in relation to hyper-v)
> > > > > > 
> > > > > > https://i.imgur.com/sRYqtVV.png
> > > > > > 
> > > > > > In summary this is the diff of fixes (just pasted to email, probably mangled):
> > > > > > 
> > > > > > 
> > > > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > > > index 0a06e62010d8c..7293ba23b3cbc 100644
> > > > > > --- a/arch/x86/kvm/svm/nested.c
> > > > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > > > @@ -436,6 +436,9 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
> > > > > >           WARN_ON(svm->vmcb == svm->nested.vmcb02);
> > > > > >    
> > > > > >           svm->nested.vmcb02->control = svm->vmcb01->control;
> > > > > > +
> > > > > > +       nested_svm_vmloadsave(svm->vmcb01, svm->nested.vmcb02);
> > > > > > +
> > > > > >           svm->vmcb = svm->nested.vmcb02;
> > > > > >           svm->vmcb_pa = svm->nested.vmcb02_pa;
> > > > > >           load_nested_vmcb_control(svm, &nested_vmcb->control);
> > > > > > @@ -622,6 +625,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> > > > > >           if (svm->vmcb01->control.asid == 0)
> > > > > >                   svm->vmcb01->control.asid = svm->nested.vmcb02->control.asid;
> > > > > >    
> > > > > > +       nested_svm_vmloadsave(svm->nested.vmcb02, svm->vmcb01);
> > > > > >           svm->vmcb = svm->vmcb01;
> > > > > >           svm->vmcb_pa = svm->nested.vmcb01_pa;
> > > > > >    
> > > > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > > > index b66239b26885d..ee9f87fe611f2 100644
> > > > > > --- a/arch/x86/kvm/svm/svm.c
> > > > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > > > @@ -1097,6 +1097,7 @@ static void init_vmcb(struct vcpu_svm *svm)
> > > > > >                   clr_cr_intercept(svm, INTERCEPT_CR3_READ);
> > > > > >                   clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
> > > > > >                   save->g_pat = svm->vcpu.arch.pat;
> > > > > > +               svm->nested.vmcb02->save.g_pat = svm->vcpu.arch.pat;
> > > I had noticed that g_pat was not set in vmcb02 and set it to vmcb01's
> > > value which was not helpful but I did not try the current vcpu value.
> > > 
> > > I am getting a #UD which I suspected had something to do with cr3 but
> > > I'll know more after I add your suggestions.
> > > 
> > > emu-system-x86-1647  [033] ....  3167.589402: kvm_nested_vmexit_inject:
> > > reason: UD excp ext_inf1: 0x0000000000000000 ext_inf2:
> > > 0x0000000000000000 ext_int: 0x00000000 ext_int_err: 0x00000000
> > > 
> > > 
> > > > > >                   save->cr3 = 0;
> > > > > >                   save->cr4 = 0;
> > > > > >           }
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > Best regards,
> > > > > > 	Maxim Levitsky
> > > > > > 
> > > > > > > Paolo
> > > > > > > 
> > > > > And another thing I spotted before I forget.
> > > > > 
> > > > > If we setup a tlb flush in ctl.tlb_ctl of vmcb01, just prior to nested vmentry
> > > > > then this field will be copied to vmcb02 but on next vmexit we clear it in current
> > > > > (that is vmcb02) and that change will not propogate to vmcb01.
> > > ctl.tlb_ctl is dependent on the value of save.cr4 which was not being
> > > set in vmcb02.
> > Not sure I understand. Could you explain?
> > 
> > The vmcb02.save.cr4 is set in nested_prepare_vmcb_save, which does
> > svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4),
> > which eventually does 'to_svm(vcpu)->vmcb->save.cr4 = cr4;'
> > And in this point vmcb points to vmcb02.
> 
> Yes it points to vmcb02 but
> 
> int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> {
>          unsigned long host_cr4_mce = cr4_read_shadow() & X86_CR4_MCE;
>          unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;  <--- 
> this vmcb02 was never initialized and will always be zero. Where 
> previously it would have contained L1.save.cr4 and tbl_ctl is set to 
> something other than TLB_CONTROL_DO_NOTHING. I saw this in my traces.
Now I understand, this is another bug, thanks! 
I guess a simple fix something like below  could
work, but I don't know for sure. I need to understand a bit better the relation
to stuff saved into vcpu->arch and in vmcb.

svm->vmcb->save.cr4 = svm->vmcb01->save.cr4;
svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);

Best regards,
	Maxim Levitsky

> 
> > Besides SEV, it seems like ctl.tlb_ctl is set by svm_flush_tlb,
> > which is indeed called from svm_set_cr4, but it is also exposed
> > but .tlb_flush* callbacks from KVM core.
> > 
> > What I meant is that we can create vcpu->arch->needs_tlb_flush, set it in svm_flush_tlb instead of tlb_ctl,
> > and then svm_vcpu_run can set tlb_ctl in the current ctl to that TLB_CONTROL_FLUSH_ASID when
> > vcpu->arch->needs_tlb_flush is set.
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > > > > I am not sure if this is a theorerical issue or not. We probably should apply the same treatment to
> > > > > it as what Paulo suggested to do with asid -
> > > > > set it just prior to vmentry if tlb flush is needed, and clear it afterwards as we do.
> > > > And yet another thing to note is that we curently ignore L2's g_pat. However it _seems_ that we practically
> > > > ignore L1 PAT as well in regard to shadowing NPT mmu. I am not 100% sure about this.
> > > > I'll dig that area eventually.
> > > > 
> > > > Best regards,
> > > > 	Maxim Levitsky
> > > > 
> > > > > Best regards,
> > > > > 	Maxim Levitsky
> > > Thanks,
> > > 
> > > Cathy
> > > 



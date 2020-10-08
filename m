Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912422872A7
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 12:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgJHKj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 06:39:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbgJHKj4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Oct 2020 06:39:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602153594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eon6VS2P0JpFGHeFdcdnTZVEjhXAkVQ0s1V/PIChN9w=;
        b=gYq77iqg0xUKmm1jbYahEvqdM5+sx8r0S5wD/Y2M0G/6klYX/j/2bzekjPtqY/OiAVD3lM
        ggZXspuER+LLqs+tsUWjtRJNHH3iK60GPCAA0DdOoSOFMMaY0Q3VaDLdM2DeNRjb4I0b0g
        W66o5iCIuqyEsNYTURTvuLdPDm3OKKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-0hw275z_P7K4Bmq4oWZ1BQ-1; Thu, 08 Oct 2020 06:39:52 -0400
X-MC-Unique: 0hw275z_P7K4Bmq4oWZ1BQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C318F81EE67;
        Thu,  8 Oct 2020 10:39:51 +0000 (UTC)
Received: from starship (unknown [10.35.206.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82F6660BFA;
        Thu,  8 Oct 2020 10:39:49 +0000 (UTC)
Message-ID: <fe491158e791fbe4381ee7fbe5aa050b4e78060e.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Use a separate vmcb for the nested L2 guest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
Date:   Thu, 08 Oct 2020 13:39:48 +0300
In-Reply-To: <0007205290de75f04f5f2a92b891815438fd2f2f.camel@redhat.com>
References: <20200917192306.2080-1-cavery@redhat.com>
         <587d1da1a037dd3ab7844c5cacc50bfda5ce6021.camel@redhat.com>
         <aaaadb29-6299-5537-47a9-072ca34ba512@redhat.com>
         <0007205290de75f04f5f2a92b891815438fd2f2f.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-10-08 at 13:23 +0300, Maxim Levitsky wrote:
> On Thu, 2020-10-08 at 07:52 +0200, Paolo Bonzini wrote:
> > On 08/10/20 00:14, Maxim Levitsky wrote:
> > > > +	if (svm->vmcb01->control.asid == 0)
> > > > +		svm->vmcb01->control.asid = svm->nested.vmcb02->control.asid;
> > > 
> > > I think that the above should be done always. The asid field is currently host
> > > controlled only (that is L2 value is ignored, selective ASID tlb flush is not
> > > advertized to the guest and lnvlpga is emulated as invlpg). 
> > 
> > Yes, in fact I suggested that ASID should be in svm->asid and moved to
> > svm->vmcb->asid in svm_vcpu_run.  Then there's no need to special case
> > it in nested code.
> This makes lot of sense!
> > This should be a patch coming before this one.
> > 
> > > 1. Something wrong with memory types - like guest is using UC memory for everything.
> > >     I can't completely rule that out yet
> > 
> > You can print g_pat and see if it is all zeroes.
> I don't even need to print it. I know that it is never set anywhere, unless guest writes it,
> but now that I look at it, we set it to a default value and there is no code to set it to
> default value for vmcb02. This is it. now my fedora guest boots just fine!
> 
> I played a lot with g_pat, and yet this didn't occur to me . I was that close :-(
> I knew that it has to be something with memory types, but it never occured to me
> that guest just doesn't write IA32_PAT and uses our value which we set in init_vmcb
> 
> 
> > In general I think it's better to be explicit with vmcb01 vs. vmcb02,
> > like Cathy did, but I can see it's a matter of personal preference to
> > some extent.
> I also think so in general, but in the code that is outside 'is_guest_mode'
> IMHO it is better to refer to vmcb01 as vmcb, although now that I think of
> it, its not wrong to do so either.
> 
> 
> My windows hyper-v guest doesn't boot though and I know why.
> 
> As we know the vmcb save area has extra state which vmrun/vmexit don't touch.
> Now suppose a nested hypervisor wants to enter a nested guest.
> 
> It will do vmload, which will load the extra state from the nested vmcb (vmcb12
> or as I woudl say the vmcb that nested hypervisor thinks that it is using),
> to the CPU. This can cause some vmexits I think, but this doesn't matter much.
> 
> Now the nested hypervisor does vmrun. The extra state of L2 guest is in CPU registers,
> and it is untouched. We do vmsave on vmcb01 to preserve that state, but later
> when we do vmload on vmcb02 prior to vmenter on it, which loads stale state from it.
> The same issue happens the other way around on nested vmexit.
> 
> I fixed this by doing nested_svm_vmloadsave, but that should be probably be 
> optimized with dirty bits. Now though I guess the goal it to make
> it work first.
> 
> With this fixed HyperV boots fine, and even passes the 'works' test of booting
> the windows 10 with hyperv enabled nested itself and starting the vm inside,
> which makes that VM L3 (in addition to windows itself that runs as L3 in relation to hyper-v)
> 
> https://i.imgur.com/sRYqtVV.png
> 
> In summary this is the diff of fixes (just pasted to email, probably mangled):
> 
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 0a06e62010d8c..7293ba23b3cbc 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -436,6 +436,9 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>         WARN_ON(svm->vmcb == svm->nested.vmcb02);
>  
>         svm->nested.vmcb02->control = svm->vmcb01->control;
> +
> +       nested_svm_vmloadsave(svm->vmcb01, svm->nested.vmcb02);
> +
>         svm->vmcb = svm->nested.vmcb02;
>         svm->vmcb_pa = svm->nested.vmcb02_pa;
>         load_nested_vmcb_control(svm, &nested_vmcb->control);
> @@ -622,6 +625,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>         if (svm->vmcb01->control.asid == 0)
>                 svm->vmcb01->control.asid = svm->nested.vmcb02->control.asid;
>  
> +       nested_svm_vmloadsave(svm->nested.vmcb02, svm->vmcb01);
>         svm->vmcb = svm->vmcb01;
>         svm->vmcb_pa = svm->nested.vmcb01_pa;
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b66239b26885d..ee9f87fe611f2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1097,6 +1097,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>                 clr_cr_intercept(svm, INTERCEPT_CR3_READ);
>                 clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
>                 save->g_pat = svm->vcpu.arch.pat;
> +               svm->nested.vmcb02->save.g_pat = svm->vcpu.arch.pat;
>                 save->cr3 = 0;
>                 save->cr4 = 0;
>         }
> 
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> > Paolo
> > 
> 
> 
And another thing I spotted before I forget.

If we setup a tlb flush in ctl.tlb_ctl of vmcb01, just prior to nested vmentry
then this field will be copied to vmcb02 but on next vmexit we clear it in current
(that is vmcb02) and that change will not propogate to vmcb01.

I am not sure if this is a theorerical issue or not. We probably should apply the same treatment to
it as what Paulo suggested to do with asid - 
set it just prior to vmentry if tlb flush is needed, and clear it afterwards as we do.

Best regards,
	Maxim Levitsky


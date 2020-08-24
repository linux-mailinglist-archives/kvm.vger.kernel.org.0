Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3714E24FCE5
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 13:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgHXLoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 07:44:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgHXLoT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Aug 2020 07:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598269457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MfpV3F203s4Q5WIfbp3LWTnnzoF+cnouMwo8pG1/1kU=;
        b=RG0osOb6C7KFTNUFoNb3QMxxPSqJWMtOIRDNENX8i888eLz/4mPwtD7Kg3fzJpQsHVUprZ
        wtz7C67ESUGN/sFIQdY9Mk63jFfKYEF6nAXYbjWsU1CZ0czZO2KTHHJg2gOBM2jdX4Stsj
        ZO4Frg7TyC/fKtyDh/CYgOhaU4KgmUc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-8vo1trLeOMSDM4ElnaAnTA-1; Mon, 24 Aug 2020 07:44:15 -0400
X-MC-Unique: 8vo1trLeOMSDM4ElnaAnTA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35CCD807331;
        Mon, 24 Aug 2020 11:44:14 +0000 (UTC)
Received: from starship (unknown [10.35.206.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D53E42BFBF;
        Mon, 24 Aug 2020 11:43:31 +0000 (UTC)
Message-ID: <4858fb924edbda58b6c46bdd4ed803bda0ceebbb.camel@redhat.com>
Subject: Re: [PATCH v2 3/7] KVM: SVM: refactor msr permission bitmap
 allocation
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Aug 2020 14:43:22 +0300
In-Reply-To: <CALMp9eRoYLqFEGqcVf2tExGvG4bJwy6CURrHiAnYqQ9TrS4eDg@mail.gmail.com>
References: <20200820133339.372823-1-mlevitsk@redhat.com>
         <20200820133339.372823-4-mlevitsk@redhat.com>
         <CALMp9eRoYLqFEGqcVf2tExGvG4bJwy6CURrHiAnYqQ9TrS4eDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-20 at 14:26 -0700, Jim Mattson wrote:
> On Thu, Aug 20, 2020 at 6:34 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > Replace svm_vcpu_init_msrpm with svm_vcpu_alloc_msrpm, that also allocates
> > the msr bitmap and add svm_vcpu_free_msrpm to free it.
> > 
> > This will be used later to move the nested msr permission bitmap allocation
> > to nested.c
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 45 +++++++++++++++++++++---------------------
> >  1 file changed, 23 insertions(+), 22 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index d33013b9b4d7..7bb094bf6494 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -609,18 +609,29 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
> >         msrpm[offset] = tmp;
> >  }
> > 
> > -static void svm_vcpu_init_msrpm(u32 *msrpm)
> > +static u32 *svm_vcpu_alloc_msrpm(void)
> 
> I prefer the original name, since this function does more than allocation.
But it also allocates it. I don't mind using the old name though.
> 
> >  {
> >         int i;
> > +       u32 *msrpm;
> > +       struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
> > +
> > +       if (!pages)
> > +               return NULL;
> > 
> > +       msrpm = page_address(pages);
> >         memset(msrpm, 0xff, PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER));
> > 
> >         for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
> >                 if (!direct_access_msrs[i].always)
> >                         continue;
> > -
> >                 set_msr_interception(msrpm, direct_access_msrs[i].index, 1, 1);
> >         }
> > +       return msrpm;
> > +}
> > +
> > +static void svm_vcpu_free_msrpm(u32 *msrpm)
> > +{
> > +       __free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
> >  }
> > 
> >  static void add_msr_offset(u32 offset)
> > @@ -1172,9 +1183,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> >  {
> >         struct vcpu_svm *svm;
> >         struct page *vmcb_page;
> > -       struct page *msrpm_pages;
> >         struct page *hsave_page;
> > -       struct page *nested_msrpm_pages;
> >         int err;
> > 
> >         BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
> > @@ -1185,21 +1194,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> >         if (!vmcb_page)
> >                 goto out;
> > 
> > -       msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
> > -       if (!msrpm_pages)
> > -               goto free_page1;
> > -
> > -       nested_msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
> > -       if (!nested_msrpm_pages)
> > -               goto free_page2;
> > -
> 
> Reordering the allocations does seem like a functional change to me,
> albeit one that should (hopefully) be benign. For example, if the
> MSRPM_ALLOC_ORDER allocations fail, in the new version of the code,
> the hsave_page will be cleared, but in the old version of the code, no
> page would be cleared.
Noted.
> 
> >         hsave_page = alloc_page(GFP_KERNEL_ACCOUNT);
> 
> Speaking of clearing pages, why not add __GFP_ZERO to the flags above
> and skip the clear_page() call below?
I haven't thought about it, I don't see a reason to not use __GFP_ZERO,
but this is how the old code was.

> 
> >         if (!hsave_page)
> > -               goto free_page3;
> > +               goto free_page1;
> > 
> >         err = avic_init_vcpu(svm);
> >         if (err)
> > -               goto free_page4;
> > +               goto free_page2;
> > 
> >         /* We initialize this flag to true to make sure that the is_running
> >          * bit would be set the first time the vcpu is loaded.
> > @@ -1210,11 +1211,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> >         svm->nested.hsave = page_address(hsave_page);
> >         clear_page(svm->nested.hsave);
> > 
> > -       svm->msrpm = page_address(msrpm_pages);
> > -       svm_vcpu_init_msrpm(svm->msrpm);
> > +       svm->msrpm = svm_vcpu_alloc_msrpm();
> > +       if (!svm->msrpm)
> > +               goto free_page2;
> > 
> > -       svm->nested.msrpm = page_address(nested_msrpm_pages);
> > -       svm_vcpu_init_msrpm(svm->nested.msrpm);
> > +       svm->nested.msrpm = svm_vcpu_alloc_msrpm();
> > +       if (!svm->nested.msrpm)
> > +               goto free_page3;
> > 
> >         svm->vmcb = page_address(vmcb_page);
> >         clear_page(svm->vmcb);
> > @@ -1227,12 +1230,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> > 
> >         return 0;
> > 
> > -free_page4:
> > -       __free_page(hsave_page);
> >  free_page3:
> > -       __free_pages(nested_msrpm_pages, MSRPM_ALLOC_ORDER);
> > +       svm_vcpu_free_msrpm(svm->msrpm);
> >  free_page2:
> > -       __free_pages(msrpm_pages, MSRPM_ALLOC_ORDER);
> > +       __free_page(hsave_page);
> >  free_page1:
> >         __free_page(vmcb_page);
> >  out:
> 
> While you're here, could you improve these labels? Coding-style.rst says:
> 
> Choose label names which say what the goto does or why the goto exists.  An
> example of a good name could be ``out_free_buffer:`` if the goto frees
> ``buffer``.
> Avoid using GW-BASIC names like ``err1:`` and ``err2:``, as you would have to
> renumber them if you ever add or remove exit paths, and they make correctness
> difficult to verify anyway.
I noticed that and I agree. I'll do this in follow up patch.

Thanks for review,
	Best regards,
		Maxim Levitsky


> 



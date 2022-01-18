Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E11492DB1
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348293AbiARSrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348291AbiARSq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 13:46:59 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A22C061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 10:46:59 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so3199330pjj.4
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 10:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fXS78uXhSmoWSsnTWRvk1W8ZphXSF/CI260GoCdAENk=;
        b=HmGEkDklhQg9E1ifJuIEVWwrc1FnQ/8CJjSyCKK2t86Nt2WsGeTnAod7hpsHxBwUvO
         1yVJkrfZW9by+xqFvC1ye4HlCI8oTCa4i8Cu+VmLjgZqL6JnItnIdhxQJ2iD/D0gwGPO
         7X87FK2F6WQXBE8XgQIDUPhtxnYD0kvlHoT3CCRbQWYY1hp1FTM6SdxXmvbt3EnhVVCx
         Qr43hAQJCw325wtIsVPjDhwDisG/slT62o3yy38Vl9nQqM+o2Q7e72Iy3x1x4VNXk7SA
         /kem6mehPf0GGpXQIyiUyts8/S+BLvatqcxdALYs/4ht94/o9Wkx03drNEGd7pUTxzZk
         fXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fXS78uXhSmoWSsnTWRvk1W8ZphXSF/CI260GoCdAENk=;
        b=ri3V3LI+PaSgPXZWZBNbgx6zjdABurTdt0WimBJtXefXR3VvGJP7108cwYt3SU7Kyo
         8l0XjaMEjc2ZuhYEnbHAVCEapbRra15adKC5MMOl6wNfd+TfDD6ppJL3GEc+blEDdvcD
         soISAmexchCAoOLOLyApM+jOChFPg4aWqEoUjNaJz7PtI+7ZqcOQaPOTpStM7O1UMqTl
         tTKPoKX34nksbLmJZUKdmp7rg+PCHeA+/blZeey7V2A6Dw8GSaaNfXe83D2rEiwweppb
         CauCSexf9o7zocN/eRYMtFzfsdPch7fPPJxy8JvZUtuIxmNwB/9pEprVyqWNZUkm5g80
         2oLw==
X-Gm-Message-State: AOAM5336Te8H54iFz8+EQt+UrQuE7BEHQvf6zkd/0/zlExZSRAFMy5gY
        nG/0wwvGbYMZl4YnMv9X7qP8pA==
X-Google-Smtp-Source: ABdhPJxd3mlOV3j1TmuQMKoytdYRgqF8o8Wr/BBHzYd0SQ7KgtQ4XIkNVDytApX388JXnq1+NbGnBg==
X-Received: by 2002:a17:902:9893:b0:14a:c958:2c19 with SMTP id s19-20020a170902989300b0014ac9582c19mr7338202plp.39.1642531618770;
        Tue, 18 Jan 2022 10:46:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h1sm18014816pfi.109.2022.01.18.10.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 10:46:58 -0800 (PST)
Date:   Tue, 18 Jan 2022 18:46:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Liam Merwick <liam.merwick@oracle.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: Query about calling kvm_vcpu_gfn_to_memslot() with a GVA (Re:
 [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
Message-ID: <YecLHrLwtdtnjpsW@google.com>
References: <20200417163843.71624-2-pbonzini@redhat.com>
 <74de09d4-6c3a-77e1-5051-c122de712f9b@oracle.com>
 <YeBZ+QcXUIQ7/fD2@google.com>
 <fcf4c5c8-aa13-11bf-ec6d-1775b3bd9cd2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcf4c5c8-aa13-11bf-ec6d-1775b3bd9cd2@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 17, 2022, Liam Merwick wrote:
> On 13/01/2022 16:57, Sean Christopherson wrote:
> > On Thu, Jan 13, 2022, Liam Merwick wrote:
> > > When looking into an SEV issue it was noted that the second arg to
> > > kvm_vcpu_gfn_to_memslot() is a gfn_t but kvm_rip_read() will return guest
> > > RIP which is a guest virtual address and memslots hold guest physical
> > > addresses. How is KVM supposed to translate it to a memslot
> > > and indicate if the guest RIP is valid?
> > 
> > Ugh, magic?  That code is complete garbage.  It worked to fix the selftest issue
> > because the selftest identity maps the relevant guest code.
> > 
> > The entire idea is a hack.  If KVM gets into an infinite loop because the guest
> > is attempting to fetch from MMIO, then the #NPF/#PF should have the FETCH bit set
> > in the error code.  I.e. I believe the below change should fix the original issue,
> > at which point we can revert the above.  I'll test today and hopefully get a patch
> > sent out.
> 
> Thanks Sean.
> 
> I have been running with this patch along with reverting commit
> e72436bc3a52 ("KVM: SVM: avoid infinite loop on NPF from bad address")
> with over 150 hours runtime on multiple machines and it resolves an SEV
> guest crash I was encountering where if there were no decode assist bytes
> available, it then continued on and hit the invalid RIP check.

Nice!  Thanks for the update.  The below patch doesn't fully remedy KVM's woes,
and it's not the best place to handle PFERR_FETCH_MASK for other reasons, so what
I'll officially post (hopefully soon) will be different, but the basic gist will
be the same.

> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Tested-by: Liam Merwick <liam.merwick@oracle.com>
> 
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index c3d9006478a4..e1d2a46e06bf 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1995,6 +1995,17 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
> >          vmcb_mark_dirty(svm->vmcb, VMCB_DR);
> >   }
> > 
> > +static char *svm_get_pf_insn_bytes(struct vcpu_svm *svm)
> > +{
> > +       if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
> > +               return NULL;
> > +
> > +       if (svm->vmcb->control.exit_info_1 & PFERR_FETCH_MASK)
> > +               return NULL;
> > +
> > +       return svm->vmcb->control.insn_bytes;
> > +}
> > +
> >   static int pf_interception(struct kvm_vcpu *vcpu)
> >   {
> >          struct vcpu_svm *svm = to_svm(vcpu);
> > @@ -2003,9 +2014,8 @@ static int pf_interception(struct kvm_vcpu *vcpu)
> >          u64 error_code = svm->vmcb->control.exit_info_1;
> > 
> >          return kvm_handle_page_fault(vcpu, error_code, fault_address,
> > -                       static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
> > -                       svm->vmcb->control.insn_bytes : NULL,
> > -                       svm->vmcb->control.insn_len);
> > +                                    svm_get_pf_insn_bytes(svm),
> > +                                    svm->vmcb->control.insn_len);
> >   }
> > 
> >   static int npf_interception(struct kvm_vcpu *vcpu)
> > @@ -2017,9 +2027,8 @@ static int npf_interception(struct kvm_vcpu *vcpu)
> > 
> >          trace_kvm_page_fault(fault_address, error_code);
> >          return kvm_mmu_page_fault(vcpu, fault_address, error_code,
> > -                       static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
> > -                       svm->vmcb->control.insn_bytes : NULL,
> > -                       svm->vmcb->control.insn_len);
> > +                                 svm_get_pf_insn_bytes(svm),
> > +                                 svm->vmcb->control.insn_len);
> >   }
> > 
> >   static int db_interception(struct kvm_vcpu *vcpu)
> 

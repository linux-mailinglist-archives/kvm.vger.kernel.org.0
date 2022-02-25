Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774144C4CB4
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 18:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243920AbiBYRks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 12:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbiBYRkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 12:40:46 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EFE1D86FE
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 09:40:14 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z15so5276515pfe.7
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 09:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JKmtUKkJOpl+v2eHp7fJRZP6Qu4r5idk637CbvNmIJE=;
        b=XJrHLexybOF81adHa9QpIxpDlqyPy6E9dafkesOlkXEerQddnkfnHBTUPTx/lZH/uy
         kz4B7IBD6BT1VqDmxyb+qmliXxlQqXy7TGHIw6VyIiigb5mDRob/+65ZQtF8qzOLk7+i
         Lmxm+bdGudUryCrcMgfblvDcOZRQtkBtx0x5u3IZQLZHNnyLUAh9Hp+sSdUpmQC4qeNu
         WXUZSTl54B50BDze87x8BwToENnSVx9sT4HAnKtGFZt18tOPpKswDJ78hdcL7zUyGDtE
         n1t8HHry5/Mbf7+9zKFmlN2UvG2glFyhdY3ExtZzjCuFVPm6ESlRpezDkcHBCFn1+2vK
         2VpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JKmtUKkJOpl+v2eHp7fJRZP6Qu4r5idk637CbvNmIJE=;
        b=1vI5qStu56vbepIUfqhZRbSjhIe/7oh6K9iQ90WlkAEpIlrzVrNyL5betCZeAxyKjg
         xubu6Qkz1xmHPi8029pwwvRjDko0y4/wQW2nBh3N5qup0OJG5Q/J4btb5gCO67z8GK/t
         9dcf5KFF4cV5umEq1uQ/Z3ctK514wDspvsC5QbPOzJ0llWoeecz84XNxzTG2w/OjzbtM
         ilvf65rFW7w1xHi8t7bNRy+RJGbuJaagHbvbT87JvjhIwvIXTk48bhb5vsyWKtSB5gC3
         K6smXFbyqtNgvJcHmSAGUgIGJfXubyUC3D7DZET5hpYTmte7YqWdxL4uFfPoXz/SOsMI
         blDg==
X-Gm-Message-State: AOAM531mblxp1jCTNEOZVobeb6aBcbtQRAa7Ulc6Tkc1adirTK3X4CA9
        MvuPmS+EP92A31N6FyzXru5UeJ6Ap9xQvQ==
X-Google-Smtp-Source: ABdhPJxxiBihs1m/m4HNlrzFLrStjOnrnLaQW5JlyvbOiThUFoeNDEtrFxgOUxxR4fwQf99byGmcEw==
X-Received: by 2002:a65:64d1:0:b0:374:9f3f:d8f5 with SMTP id t17-20020a6564d1000000b003749f3fd8f5mr6969168pgv.186.1645810813494;
        Fri, 25 Feb 2022 09:40:13 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nl12-20020a17090b384c00b001bc1bb5449bsm3191989pjb.2.2022.02.25.09.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 09:40:12 -0800 (PST)
Date:   Fri, 25 Feb 2022 17:40:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 15/18] KVM: x86/mmu: rename kvm_mmu_new_pgd, introduce
 variant that calls get_guest_pgd
Message-ID: <YhkUeNbnbDvTsmNA@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-16-pbonzini@redhat.com>
 <ae3002da-e931-1e08-7a23-8cd296bf8313@redhat.com>
 <YhAI2rq9ms+rhFy5@google.com>
 <667adbb56835c359fbdbacefe4ecdf1153b0c126.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <667adbb56835c359fbdbacefe4ecdf1153b0c126.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022, Maxim Levitsky wrote:
> On Fri, 2022-02-18 at 21:00 +0000, Sean Christopherson wrote:
> > On Fri, Feb 18, 2022, Paolo Bonzini wrote:
> > > On 2/17/22 22:03, Paolo Bonzini wrote:
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index adcee7c305ca..9800c8883a48 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -1189,7 +1189,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> > > >   		return 1;
> > > >   	if (cr3 != kvm_read_cr3(vcpu))
> > > > -		kvm_mmu_new_pgd(vcpu, cr3);
> > > > +		kvm_mmu_update_root(vcpu);
> > > >   	vcpu->arch.cr3 = cr3;
> > > >   	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> > > 
> > > Uh-oh, this has to become:
> > > 
> > >  	vcpu->arch.cr3 = cr3;
> > >  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> > > 	if (!is_pae_paging(vcpu))
> > > 		kvm_mmu_update_root(vcpu);
> > > 
> > > The regression would go away after patch 16, but this is more tidy apart
> > > from having to check is_pae_paging *again*.
> > > 
> > > Incremental patch:
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index adcee7c305ca..0085e9fba372 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -1188,11 +1189,11 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> > >  	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
> > >  		return 1;
> > > -	if (cr3 != kvm_read_cr3(vcpu))
> > > -		kvm_mmu_update_root(vcpu);
> > > -
> > >  	vcpu->arch.cr3 = cr3;
> > >  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> > > +	if (!is_pae_paging(vcpu))
> > > +		kvm_mmu_update_root(vcpu);
> > > +
> > >  	/* Do not call post_set_cr3, we do not get here for confidential guests.  */
> > > 
> > > An alternative is to move the vcpu->arch.cr3 update in load_pdptrs.
> > > Reviewers, let me know if you prefer that, then I'll send v3.
> > 
> >   c) None of the above.
> > 
> > MOV CR3 never requires a new root if TDP is enabled, and the guest_mmu is used if
> > and only if TDP is enabled.  Even when KVM intercepts CR3 when EPT=1 && URG=0, it
> > does so only to snapshot vcpu->arch.cr3, there's no need to get a new PGD.
> > 
> > Unless I'm missing something, your original suggestion of checking tdp_enabled is
> > the way to go.
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 6e0f7f22c6a7..2b02029c63d0 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1187,7 +1187,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >         if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
> >                 return 1;
> > 
> > -       if (cr3 != kvm_read_cr3(vcpu))
> > +       if (!tdp_enabled && cr3 != kvm_read_cr3(vcpu))
> >                 kvm_mmu_new_pgd(vcpu, cr3);
> > 
> >         vcpu->arch.cr3 = cr3;
> > 
> > 
> 
> Is this actually related to the discussion? The original issue that Paolo
> found in his patch was that kvm_mmu_update_root now reads _current_ cr3, thus
> it has to be set before calling it.

Yes, if we instead do the above, then replacing kvm_mmu_new_pgd() with
kvm_mmu_update_root() is unnecessary.  Paolo is trying to fix the case where
kvm_mmu_new_pgd() does the wrong thing for guest_mmu.  My point is that we
should never call kvm_mmu_new_pgd() if mmu == guest_mmu in the first place, and
adding the tdp_enabled checks fixes that bug.

I'm ok with kvm_mmu_new_pgd() acting on a pre-computed role, assuming we actually
get sanity checks.  Deliberately ignoring the pgd/cr3 we already have is silly.

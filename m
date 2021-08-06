Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32303E2F9F
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 21:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243640AbhHFTDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 15:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243614AbhHFTDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 15:03:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB32C0613CF
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 12:02:44 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k11-20020a17090a62cbb02901786a5edc9aso180006pjs.5
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 12:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=//JDUi57RNhRgVwj3CqYJUbGsE82Eu4AK4/nmsaD5vU=;
        b=cuAY00KXCrMqeYrU3J0rSBzrhenEvzRO58iFCxARlVyRpE4KWOVscEbfY9xS2sY39f
         gmE0Q+4yIk3GIHuE1nU8jf7izcAVqvVu9IJjDMNhO+7S2j1pzeITkYsQW+XdwFldMas0
         JGbqybPfZVGYn15bkkFmFjvTALtXy5A/y335xclwUuV4qrxJaVuXM45DTIX1MQQzgeuV
         rqrVwhNULVcY69TonOh4W/XiQ88GYSJa+ztIvtCXuGQVbEXebXH1CbGFgNGYIOm7reVw
         3m0HqlpP7J9vHTgcisR5FzTpr3IQfJcziBr3Q43lKYwVwnAbRVizJSVhGTCnozqjqMMw
         2ecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=//JDUi57RNhRgVwj3CqYJUbGsE82Eu4AK4/nmsaD5vU=;
        b=WcHOZK5/n4Awk2o6/aC48W7j/8qO/Yz57iSTpaTFW7YvWC9Xb50nG8adhTmaQD6e4P
         IMfRQ1v31egw1I7TdYE3kr0krnKuyR8E/boKHhKXiWtAZ0ympeFLOAYk1mr9GoxUnYOU
         XeGhQHV2IWF2PqYqM9362SFV9jmk/rtdfgbE4nlmG2soBn3ORqQ+ADB4XqL2xrjQcUL2
         WFXpxJiXrSOMXXMafdAARHixGcc95OpfAieLZb/LVfGD34AczbY7ykO+loyttO8KZiWv
         meGmH2oVPqb0NDhdcWNyd0qT5uZ4iuBWSrAbBK+R3n2HPCtuIS23pkFxldctnG7ywqFq
         agpQ==
X-Gm-Message-State: AOAM533RFLcrbqufY7y3/nRHbVrRaXisjtMp5lRCWDahHs9UIZ2eh+JT
        pa+BDe+Sfw7zJtpSE0+gX6HbRw==
X-Google-Smtp-Source: ABdhPJz87qusJ0QEC87lGamzHB4pxOoBy2uSRUfMbeuKh0MDo5VtLuZGjwjJsKCHweusz5UqW0ZGpw==
X-Received: by 2002:a17:90b:153:: with SMTP id em19mr23256057pjb.158.1628276564136;
        Fri, 06 Aug 2021 12:02:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d134sm11635908pfd.60.2021.08.06.12.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 12:02:43 -0700 (PDT)
Date:   Fri, 6 Aug 2021 19:02:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen GPA
 bits
Message-ID: <YQ2HT3dL/bFjdEdS@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <c958a131ded780808a687b0f25c02127ca14418a.1625186503.git.isaku.yamahata@intel.com>
 <20210805234424.d14386b79413845b990a18ac@intel.com>
 <YQwMkbBFUuNGnGFw@google.com>
 <20210806095922.6e2ca6587dc6f5b4fe8d52e7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806095922.6e2ca6587dc6f5b4fe8d52e7@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06, 2021, Kai Huang wrote:
> On Thu, 5 Aug 2021 16:06:41 +0000 Sean Christopherson wrote:
> > On Thu, Aug 05, 2021, Kai Huang wrote:
> > > On Fri, 2 Jul 2021 15:04:47 -0700 isaku.yamahata@intel.com wrote:
> > > > From: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > > @@ -2020,6 +2032,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > > >  	sp = kvm_mmu_alloc_page(vcpu, direct);
> > > >  
> > > >  	sp->gfn = gfn;
> > > > +	sp->gfn_stolen_bits = gfn_stolen_bits;
> > > >  	sp->role = role;
> > > >  	hlist_add_head(&sp->hash_link, sp_list);
> > > >  	if (!direct) {
> > > > @@ -2044,6 +2057,13 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > > >  	return sp;
> > > >  }
> > > 
> > > 
> > > Sorry for replying old thread,
> > 
> > Ha, one month isn't old, it's barely even mature.
> > 
> > > but to me it looks weird to have gfn_stolen_bits
> > > in 'struct kvm_mmu_page'.  If I understand correctly, above code basically
> > > means that GFN with different stolen bit will have different 'struct
> > > kvm_mmu_page', but in the context of this patch, mappings with different
> > > stolen bits still use the same root,
> > 
> > You're conflating "mapping" with "PTE".  The GFN is a per-PTE value.  Yes, there
> > is a final GFN that is representative of the mapping, but more directly the final
> > GFN is associated with the leaf PTE.
> > 
> > TDX effectively adds the restriction that all PTEs used for a mapping must have
> > the same shared/private status, so mapping and PTE are somewhat interchangeable
> > when talking about stolen bits (the shared bit), but in the context of this patch,
> > the stolen bits are a property of the PTE.
> 
> Yes it is a property of PTE, this is the reason that I think it's weird to have
> stolen bits in 'struct kvm_mmu_page'. Shouldn't stolen bits in 'struct
> kvm_mmu_page' imply that all PTEs (whether leaf or not) share the same
> stolen bit?

No, the stolen bits are the property of the shadow page.  I'm using "PTE" above
to mean "PTE for this shadow page", not PTEs within the shadow page, if that makes
sense.

> > Back to your statement, it's incorrect.  PTEs (effectively mappings in TDX) with
> > different stolen bits will _not_ use the same root.  kvm_mmu_get_page() includes
> > the stolen bits in both the hash lookup and in the comparison, i.e. restores the
> > stolen bits when looking for an existing shadow page at the target GFN.
> > 
> > @@ -1978,9 +1990,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >                 role.quadrant = quadrant;
> >         }
> > 
> > -       sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> > +       sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn_and_stolen)];
> >         for_each_valid_sp(vcpu->kvm, sp, sp_list) {
> > -               if (sp->gfn != gfn) {
> > +               if ((sp->gfn | sp->gfn_stolen_bits) != gfn_and_stolen) {
> >                         collisions++;
> >                         continue;
> >                 }
> > 
> 
> This only works for non-root table, but there's only one single
> vcpu->arch.mmu->root_hpa, we don't have an array to have one root for each
> stolen bit, i.e. do a loop in mmu_alloc_direct_roots(), so effectively all
> stolen bits share one single root.

Yes, and that's absolutely the required behavior for everything except for TDX
with its two EPTPs.  E.g. any other implement _must_ reject CR3s that set stolen
gfn bits.

> > > which means gfn_stolen_bits doesn't make a lot of sense at least for root
> > > page table. 
> > 
> > It does make sense, even without a follow-up patch.  In Rick's original series,
> > stealing a bit for execute-only guest memory, there was only a single root.  And
> > except for TDX, there can only ever be a single root because the shared EPTP isn't
> > usable, i.e. there's only the regular/private EPTP.
> > 
> > > Instead, having gfn_stolen_bits in 'struct kvm_mmu_page' only makes sense in
> > > the context of TDX, since TDX requires two separate roots for private and
> > > shared mappings.
> > 
> > > So given we cannot tell whether the same root, or different roots should be
> > > used for different stolen bits, I think we should not add 'gfn_stolen_bits' to
> > > 'struct kvm_mmu_page' and use it to determine whether to allocate a new table
> > > for the same GFN, but should use a new role (i.e role.private) to determine.
> > 
> > A new role would work, too, but it has the disadvantage of not automagically
> > working for all uses of stolen bits, e.g. XO support would have to add another
> > role bit.
> 
> For each purpose of particular stolen bit, a new role can be defined.  For
> instance, in __direct_map(), if you see stolen bit is TDX shared bit, you don't
> set role.private (otherwise set role.private).  For XO, if you see the stolen
> bit is XO, you set role.xo.
> 
> We already have info of 'gfn_stolen_mask' in vcpu, so we just need to make sure
> all code paths can find the actual stolen bit based on sp->role and vcpu (I
> haven't gone through all though, assuming the annoying part is rmap).

Yes, and I'm not totally against the idea, but I'm also not 100% sold on it either,
yet...  The idea of a 'private' flag is growing on me.

If we're treating the shared bit as an attribute bit, which we are, then it's
effectively an extension of role.access.  Ditto for XO.

And looking at the code, I think it would be an improvement for TDX, as all of
the is_private_gfn() calls that operate on a shadow page would be simplified and
optimized as they wouldn't have to lookup both gfn_stolen_bits and the vcpu->kvm
mask of the shared bit.

Actually, the more I think about it, the more I like it.  For TDX, there's no
risk of increased hash collisions, as we've already done messed up if there's a
shared vs. private collision.

And for XO, if it ever makes it way upstream, I think we should flat out disallow
referencing XO addresses in non-leaf PTEs, i.e. make the XO permission bit reserved
in non-leaf PTEs.  That would avoid any theoretical problems with the guest doing
something stupid by polluting all its upper level PxEs with XO.  Collisions would
be purely limited to the case where the guest is intentionally creating an alternate
mapping, which should be a rare event (or the guest is comprosied, which is also
hopefully a rare event).



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B962572111
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 18:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiGLQgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 12:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiGLQgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 12:36:15 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA62D31D9
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 09:35:42 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 23so8053969pgc.8
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 09:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pNpgR7KjQZurbGbWyaYhBlQrOEKytoR8yRHws8TVBHE=;
        b=GdmkU9SQ/Luh/zyi5KlOBPHktypKoYVIDapjas/WdAlmty0F0pzGAW+hR+UJUy7lK7
         Bx0s4LcoTaCRMOlNLONekoxEfQOhToyqHbxHrpG7Fb+WayJ0KJ+UTxKm5/0j0gIk+gcP
         37WPz5ZMtQU3zAHIDquIPoQjniYsFEzWa/2OVcVz3oJR1KvggRIVdsJCkBUTw1cicYQV
         0aFk1D46NLMpnbCsQzAuefQGtUQ0BTvCAGuRdBfFP3rAh/uneG+AhKtSIzCrI3FaPGL6
         wR0yAyOGDKMGqjTMZMemJld3SPpC4F5C6th2Nms2SNE3NAp4SjG6e+H+SlgV+5vkTVm5
         L7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pNpgR7KjQZurbGbWyaYhBlQrOEKytoR8yRHws8TVBHE=;
        b=ik3lnS7f6fbGNA176STP6d/NNNESW3Lt5/uccodX6dcC/bf9B7hkWOxMmWJtOlc2AL
         5wZzJ6SPZJRpsui2AIGptJSNj1Th5Oj+3/CYtj+GbBgCPhDM754jxH0TyxJKe9cAKn1k
         CXQNCZyW1pDUMnEBas2L3K1VB6MthxaVVCdavwo5W/dfSfXr6lA6yrzbDNOOFoPNMf5L
         icBWqW5Q+YN3mKuyf4UPdpAy21psx5X8jM0KXJaasUE/LES67y2DY+qxgDe2mHAAe6Xr
         LUslGqHcT8nxBHysTLZf4G45qaHZhLzco/mLF6Ho2oUNSLh+g5lrB8Fgd/nxAlj1UloU
         XG+g==
X-Gm-Message-State: AJIora/MXa2D81PNWv4X7DIPEmTtwVig6PK6XJDJhdysaiPkmjZYXLWU
        FVcLtfLe8pTuf6lahsQnQV6cSg==
X-Google-Smtp-Source: AGRyM1vZhE6tnkL4CzrnqfWOAJrF64lL6s+95FL6N4OVYNlp7L0wFtuLgl1JEoSoNwTKVmVT2HESQQ==
X-Received: by 2002:a63:c15:0:b0:411:f92a:8ec7 with SMTP id b21-20020a630c15000000b00411f92a8ec7mr20993517pgl.86.1657643742090;
        Tue, 12 Jul 2022 09:35:42 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902680b00b0016a11750b50sm7005007plk.16.2022.07.12.09.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 09:35:40 -0700 (PDT)
Date:   Tue, 12 Jul 2022 16:35:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Add dedicated helper to get CPUID entry
 with significant index
Message-ID: <Ys2i2B/jt5yDsAKj@google.com>
References: <20220712000645.1144186-1-seanjc@google.com>
 <8a1ff7338f1252d75ff96c3518f16742919f92d7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a1ff7338f1252d75ff96c3518f16742919f92d7.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022, Maxim Levitsky wrote:
> On Tue, 2022-07-12 at 00:06 +0000, Sean Christopherson wrote:
> >  static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
> > -       struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
> > +       struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
> How I wish that this would be just called EAX and ECX... Anyway....

Heh, I strongly disagree.  EAX and ECX are how the CPUID instruction specifies
the function and index, CPUID the lookup itself operates on function+index,
e.g. there are plenty of situations where KVM queries CPUID info without the
inputs coming from EAX/ECX.

> >  {
> >         struct kvm_cpuid_entry2 *e;
> >         int i;
> > @@ -77,9 +85,22 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
> >         for (i = 0; i < nent; i++) {
> >                 e = &entries[i];
> >  
> > -               if (e->function == function &&
> > -                   (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index))
> > +               if (e->function != function)
> > +                       continue;
> > +
> > +               /*
> > +                * If the index isn't significant, use the first entry with a
> > +                * matching function.  It's userspace's responsibilty to not
> > +                * provide "duplicate" entries in all cases.
> > +                */
> > +               if (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index)
> >                         return e;
> > +
> > +               /*
> > +                * Function matches and index is significant; not specifying an
> > +                * exact index in this case is a KVM bug.
> > +                */
> Nitpick: Why KVM bug? Bad userspace can also provide a index-significant entry for cpuid
> leaf for which index is not significant in the x86 spec.

Ugh, you're right.

> We could arrange a table of all known leaves and for each leaf if it has an index
> in the x86 spec, and warn/reject the userspace CPUID info if it doesn't match.

We have such a table, cpuid_function_is_indexed().  The alternative would be to
do:

		WARN_ON_ONCE(index == KVM_CPUID_INDEX_NOT_SIGNIFICANT &&
			     cpuid_function_is_indexed(function));

The problem with rejecting userspace CPUID on mismatch is that it could break
userspace :-/  Of course, this entire patch would also break userspace to some
extent, e.g. if userspace is relying on an exact match on index==0.  The only
difference being the guest lookups with an exact index would still work.

I think the restriction we could put in place would be that userspace can make
a leaf more relaxed, e.g. to play nice if userspace forgets to set the SIGNFICANT
flag, but rejects attempts to make guest CPUID more restrictive, i.e. disallow
setting the SIGNFICANT flag on leafs that KVM doesn't enumerate as significant.

> > +               WARN_ON_ONCE(index == KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> >         }
> >  
> >         return NULL;
> > @@ -96,7 +117,8 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
> >          * The existing code assumes virtual address is 48-bit or 57-bit in the
> >          * canonical address checks; exit if it is ever changed.
> >          */
> > -       best = cpuid_entry2_find(entries, nent, 0x80000008, 0);
> > +       best = cpuid_entry2_find(entries, nent, 0x80000008,
> > +                                KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> OK.

Thanks for looking through all these!

> >  static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
> > @@ -219,7 +242,7 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
> >         struct kvm_cpuid_entry2 *best;
> >         u64 guest_supported_xcr0 = cpuid_get_supported_xcr0(entries, nent);
> >  
> > -       best = cpuid_entry2_find(entries, nent, 1, 0);
> > +       best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> 
> Leaf 1, no index indeed.
> 
> Offtopic: I wonder why we call this 'best'?

Awful, awful historic code.  IIRC, for functions whose index is not significant,
KVM would iterate over all entries and look for an exact function+index match
anyways.  If there was at least one partial match (function match only) but no
full match, KVM would use the first partial match, which it called the "best" match.

We've been slowly/opportunistically killing off the "best" terminology.

> > -struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
> > -                                             u32 function, u32 index)
> > +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
> > +                                                   u32 function, u32 index)
> Nitpick: could you fix the indention while at it?

The indentation is correct, it's only the diff that appears misaligned.

> > @@ -1353,11 +1384,11 @@ get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
> >                 return NULL;
> >  
> >         if (function >= 0x40000000 && function <= 0x4fffffff)
> > -               class = kvm_find_cpuid_entry(vcpu, function & 0xffffff00, 0);
> > +               class = kvm_find_cpuid_entry(vcpu, function & 0xffffff00);
> >         else if (function >= 0xc0000000)
> > -               class = kvm_find_cpuid_entry(vcpu, 0xc0000000, 0);
> > +               class = kvm_find_cpuid_entry(vcpu, 0xc0000000);
> >         else
> > -               class = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
> > +               class = kvm_find_cpuid_entry(vcpu, function & 0x80000000);
> This assumes that all the classes has first entry whose EAX specifies max leaf
> for this class. True for sure for basic and extended features, don't know
> if true for hypervisor and Centaur entries. Seems OK.

It holds true for all known hypervisors.  There's no formal definition for using
0x400000yy as the hypervisor range, but the de facto standard is to use EBX, ECX,
and EDX for the signature, and EAX for the max leaf.

The Centaur behavior is very much a guess, but odds are it's a correct guess.  When
I added the Centaur code, I spent far too much time trying (and failing) to hunt
down documentation.  


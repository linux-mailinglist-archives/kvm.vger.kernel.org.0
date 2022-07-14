Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3442B574B4D
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 12:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbiGNK5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 06:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiGNK5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 06:57:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9B42558FA
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 03:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657796257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AWPkftNINeppgUpPoshL3adDOP1bEUd/uT+PYson8KY=;
        b=ZceoqNiQM/f6XkJhFQO1ndRTt8aCeTYNyWCIP+jsBJOSfx+4DFSd5UzIOZN8KbJydGj9k9
        66iNASo/eKOnBC7nKTTRjVVWXgUI8hu4q1HMePRAURCmQHQeP+G6xFy+WLZUoGuPlaOO9y
        c5cHGLiG3rF+dVwJuwD1w1QkJfOwvNg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-PFDK1J0nMdC-EV0LIv7V9A-1; Thu, 14 Jul 2022 06:57:35 -0400
X-MC-Unique: PFDK1J0nMdC-EV0LIv7V9A-1
Received: by mail-wm1-f71.google.com with SMTP id 23-20020a05600c229700b003a2eda0c59cso591444wmf.7
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 03:57:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AWPkftNINeppgUpPoshL3adDOP1bEUd/uT+PYson8KY=;
        b=Qj0uS/Hcm0lYC3rdD++b3U8ORrts0wXLLGQUxSSUXW+sUubewLbVrSEmpYltDevveh
         kUq1RiQYQcm2NyE3izU+pugbxnKseyNGf7X0JWcUKxKZnOyeYINVg6HmsRB3QVSjv8f4
         nCL4LzPuFb/wamxbl2oE6e/HAVE5KSg60Z4h3D5Vgg2vnpOUXK2xUwkwuEC9K1Z8z+uW
         Axb7twv91D1t2bCBQwySkOxV6WW/kjZOKdnEtGaAels6C51XPZWzk85OrEA4ysUBF/Iu
         dpcYaTwbsDnFMWdRxL5oWnoma0CxtwwD9dqea27xpBYEdnkNF1Rv6Ia7akwitibbl7hF
         bEuQ==
X-Gm-Message-State: AJIora+j6R0pkEcZCc1bbVo2XW/+rZQPdXP/HXPgybtQ9eGkmLzcSBk4
        vA7VPKKsMC8bH2j1ZCllR6ytCDSc5rxEJuFbqnbg0mvQ/JQWLBu4zoKSpPMo5eURPG7MVqmjrTQ
        1K0dVeZMcjB+m
X-Received: by 2002:adf:fe0d:0:b0:21d:81f3:854a with SMTP id n13-20020adffe0d000000b0021d81f3854amr7467244wrr.540.1657796254208;
        Thu, 14 Jul 2022 03:57:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vsN6Idmpm252Ogd3KnFbeGIDMdjsGqpNyidkS2H62Pg4xDB7zbJ3CHlAcKF5dGW+qa/dp01A==
X-Received: by 2002:adf:fe0d:0:b0:21d:81f3:854a with SMTP id n13-20020adffe0d000000b0021d81f3854amr7467222wrr.540.1657796253911;
        Thu, 14 Jul 2022 03:57:33 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id i16-20020adfb650000000b0021b866397a7sm1150480wre.1.2022.07.14.03.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 03:57:33 -0700 (PDT)
Message-ID: <eeed31d55f20561f9ef06afa40f0fa9d7f3032af.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: Add dedicated helper to get CPUID entry
 with significant index
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 13:57:31 +0300
In-Reply-To: <Ys2i2B/jt5yDsAKj@google.com>
References: <20220712000645.1144186-1-seanjc@google.com>
         <8a1ff7338f1252d75ff96c3518f16742919f92d7.camel@redhat.com>
         <Ys2i2B/jt5yDsAKj@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-12 at 16:35 +0000, Sean Christopherson wrote:
> On Tue, Jul 12, 2022, Maxim Levitsky wrote:
> > On Tue, 2022-07-12 at 00:06 +0000, Sean Christopherson wrote:
> > >  static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
> > > -       struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
> > > +       struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
> > How I wish that this would be just called EAX and ECX... Anyway....
> 
> Heh, I strongly disagree.  EAX and ECX are how the CPUID instruction specifies
> the function and index, CPUID the lookup itself operates on function+index,
> e.g. there are plenty of situations where KVM queries CPUID info without the
> inputs coming from EAX/ECX.

Just a matter of taste I guess - note that outputs of CPUID instructions are always called
as registers (EAX/EBX/ECX/EDX). But anyway it doesn't really mattter to me.

> 
> > >  {
> > >         struct kvm_cpuid_entry2 *e;
> > >         int i;
> > > @@ -77,9 +85,22 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
> > >         for (i = 0; i < nent; i++) {
> > >                 e = &entries[i];
> > >  
> > > -               if (e->function == function &&
> > > -                   (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index))
> > > +               if (e->function != function)
> > > +                       continue;
> > > +
> > > +               /*
> > > +                * If the index isn't significant, use the first entry with a
> > > +                * matching function.  It's userspace's responsibilty to not
> > > +                * provide "duplicate" entries in all cases.
> > > +                */
> > > +               if (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index)
> > >                         return e;
> > > +
> > > +               /*
> > > +                * Function matches and index is significant; not specifying an
> > > +                * exact index in this case is a KVM bug.
> > > +                */
> > Nitpick: Why KVM bug? Bad userspace can also provide a index-significant entry for cpuid
> > leaf for which index is not significant in the x86 spec.
> 
> Ugh, you're right.
> 
> > We could arrange a table of all known leaves and for each leaf if it has an index
> > in the x86 spec, and warn/reject the userspace CPUID info if it doesn't match.
> 
> We have such a table, cpuid_function_is_indexed().  The alternative would be to
> do:
> 
>                 WARN_ON_ONCE(index == KVM_CPUID_INDEX_NOT_SIGNIFICANT &&
>                              cpuid_function_is_indexed(function));
> 
> The problem with rejecting userspace CPUID on mismatch is that it could break
> userspace :-/  Of course, this entire patch would also break userspace to some
> extent, e.g. if userspace is relying on an exact match on index==0.  The only
> difference being the guest lookups with an exact index would still work.
> 
> I think the restriction we could put in place would be that userspace can make
> a leaf more relaxed, e.g. to play nice if userspace forgets to set the SIGNFICANT
> flag, but rejects attempts to make guest CPUID more restrictive, i.e. disallow
> setting the SIGNFICANT flag on leafs that KVM doesn't enumerate as significant.

Makes sense.

> 
> > > +               WARN_ON_ONCE(index == KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> > >         }
> > >  
> > >         return NULL;
> > > @@ -96,7 +117,8 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
> > >          * The existing code assumes virtual address is 48-bit or 57-bit in the
> > >          * canonical address checks; exit if it is ever changed.
> > >          */
> > > -       best = cpuid_entry2_find(entries, nent, 0x80000008, 0);
> > > +       best = cpuid_entry2_find(entries, nent, 0x80000008,
> > > +                                KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> > OK.
> 
> Thanks for looking through all these!
No problem!
> 
> > >  static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
> > > @@ -219,7 +242,7 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
> > >         struct kvm_cpuid_entry2 *best;
> > >         u64 guest_supported_xcr0 = cpuid_get_supported_xcr0(entries, nent);
> > >  
> > > -       best = cpuid_entry2_find(entries, nent, 1, 0);
> > > +       best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> > 
> > Leaf 1, no index indeed.
> > 
> > Offtopic: I wonder why we call this 'best'?
> 
> Awful, awful historic code.  IIRC, for functions whose index is not significant,
> KVM would iterate over all entries and look for an exact function+index match
> anyways.  If there was at least one partial match (function match only) but no
> full match, KVM would use the first partial match, which it called the "best" match.
> 
> We've been slowly/opportunistically killing off the "best" terminology.

Thanks for the explanation. I also noticed that you removed recently the 'stateful'
CPUID code. Good riddance!

> 
> > > -struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
> > > -                                             u32 function, u32 index)
> > > +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
> > > +                                                   u32 function, u32 index)
> > Nitpick: could you fix the indention while at it?
> 
> The indentation is correct, it's only the diff that appears misaligned.

I think I already heard about this once, I will try to not forget and keep
that in mind next time I notice this. Sorry!

> 
> > > @@ -1353,11 +1384,11 @@ get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
> > >                 return NULL;
> > >  
> > >         if (function >= 0x40000000 && function <= 0x4fffffff)
> > > -               class = kvm_find_cpuid_entry(vcpu, function & 0xffffff00, 0);
> > > +               class = kvm_find_cpuid_entry(vcpu, function & 0xffffff00);
> > >         else if (function >= 0xc0000000)
> > > -               class = kvm_find_cpuid_entry(vcpu, 0xc0000000, 0);
> > > +               class = kvm_find_cpuid_entry(vcpu, 0xc0000000);
> > >         else
> > > -               class = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
> > > +               class = kvm_find_cpuid_entry(vcpu, function & 0x80000000);
> > This assumes that all the classes has first entry whose EAX specifies max leaf
> > for this class. True for sure for basic and extended features, don't know
> > if true for hypervisor and Centaur entries. Seems OK.
> 
> It holds true for all known hypervisors.  There's no formal definition for using
> 0x400000yy as the hypervisor range, but the de facto standard is to use EBX, ECX,
> and EDX for the signature, and EAX for the max leaf.
> 
> The Centaur behavior is very much a guess, but odds are it's a correct guess.  When
> I added the Centaur code, I spent far too much time trying (and failing) to hunt
> down documentation. 

I understand very well what you mean.

Best regards,
	Maxim Levitsky

> 



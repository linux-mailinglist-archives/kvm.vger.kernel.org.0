Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E6E637000
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 02:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiKXBtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 20:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKXBtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 20:49:51 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F018019C36
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 17:49:49 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id y83so252995yby.12
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 17:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pFXAYSso24erMxKEqTgV7fqALlyuXGJeC0HNS0f0bq0=;
        b=owMa+l0F1MPgSxktqKWBkBrKYYPKNuE31gk11hVKlLL9Ii0TS7/nbHmeEV7MTunQGA
         NfuA1t0cCxnV+lVGz4ld4y0pXk0vJwdrkjqXJjwiGXTORL48BNuUVpwkAjKZ5aKp63jX
         Muwe2B6B1ZeaJXT0JMEbwVsnDO3h2ZGbDcwXAppbUYH6zhZy4uFo5n3PCzjqepTuEEUH
         AgiIcubvIK/Hx9bpqOhifm1c9wwWp9AEQC6PmO5wQa+CUbtQ0h4xfHVmCC7jO6GfnwQ+
         ji0T5ro9lEG1sDsnAzBZYll8Nqi7iYp892V3lCDmQd+/Otx6AR7Q6XdmBgxjaZDQOIw+
         UjFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pFXAYSso24erMxKEqTgV7fqALlyuXGJeC0HNS0f0bq0=;
        b=Dj13TJvBRac0qoSq1l5JXhAC8Fsfj7OK1vHDTU4nwl/ZCnzGJi++hbmJNWsjvP6uxE
         sK0rHWP0Wp9oNem79qXKux+ztzMxvXv6t7dvwJ3sMaFpU/V5o96NNgRS4I0I3GT0RQ6v
         h3Umiv2T71RCdjNC7Mn70ZFG6YnNQ3Y7yHHabpemXu566+1dGzGwh8wHA3oa2F4Wwuhr
         yuAFNnTHBkQZXDeRGpxzLogazzvqiq/TDAU6CFz9DNYfKLS2XWEK6mQKFnKbEQDyXUbC
         axxiSEmusr3KKMPzpvTIQS5a4qBCQlgUhNzfFP1j1vW7vmkzz1Cm9vcyuGLOky9I59HZ
         bC3A==
X-Gm-Message-State: ANoB5pkV82NxbR/3R0ne2UGmHDoaG4p27np0xqPMCaOLxrMtzY3A4ps+
        SVC3c94F5FpKnoZoCqD0WmhfrlCqaL9M0hivk2VR6w==
X-Google-Smtp-Source: AA0mqf5LTwiPDUXUoLN/KZvqwwrc92jmhMZJc0MgFUigosufWdDxA1Eg3vu4NWyX8Y9tDno3NHHb8jUBrZf7Xx/o28g=
X-Received: by 2002:a25:4ac6:0:b0:6ee:8d5a:3bcc with SMTP id
 x189-20020a254ac6000000b006ee8d5a3bccmr9932060yba.413.1669254588847; Wed, 23
 Nov 2022 17:49:48 -0800 (PST)
MIME-Version: 1.0
References: <20221111014244.1714148-1-vannapurve@google.com>
 <20221111014244.1714148-2-vannapurve@google.com> <20221122100705.GA619277@chaop.bj.intel.com>
 <Y30rqWwDRbH7nQaQ@google.com>
In-Reply-To: <Y30rqWwDRbH7nQaQ@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 23 Nov 2022 17:49:38 -0800
Message-ID: <CAA03e5EXU-TpZP2tyjEjfAAr9aNNcgmgOX6Rqv7ng+4Xc9H5AQ@mail.gmail.com>
Subject: Re: [V1 PATCH 1/6] KVM: x86: Add support for testing private memory
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        shuah@kernel.org, yang.zhong@intel.com, ricarkol@google.com,
        aaronlewis@google.com, wei.w.wang@intel.com,
        kirill.shutemov@linux.intel.com, corbet@lwn.net, hughd@google.com,
        jlayton@kernel.org, bfields@fieldses.org,
        akpm@linux-foundation.org, yu.c.zhang@linux.intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com,
        michael.roth@amd.com, qperret@google.com, steven.price@arm.com,
        ak@linux.intel.com, david@redhat.com, luto@kernel.org,
        vbabka@suse.cz, erdemaktas@google.com, pgonda@google.com,
        nikunj@amd.com, diviness@google.com, maz@kernel.org,
        dmatlack@google.com, axelrasmussen@google.com,
        maciej.szmigiero@oracle.com, mizhang@google.com,
        bgardon@google.com, ackerleytng@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 12:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Nov 22, 2022, Chao Peng wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 10017a9f26ee..b3118d00b284 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4280,6 +4280,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> > >
> > >     fault->gfn = fault->addr >> PAGE_SHIFT;
> > >     fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
> > > +#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING
> > > +   fault->is_private = kvm_slot_can_be_private(fault->slot) &&
> > > +                   kvm_mem_is_private(vcpu->kvm, fault->gfn);
> > > +#endif
> > >
> > >     if (page_fault_handle_page_track(vcpu, fault))
> > >             return RET_PF_EMULATE;
> > > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > > index 5cdff5ca546c..2e759f39c2c5 100644
> > > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > > @@ -188,7 +188,6 @@ struct kvm_page_fault {
> > >
> > >     /* Derived from mmu and global state.  */
> > >     const bool is_tdp;
> > > -   const bool is_private;
> > >     const bool nx_huge_page_workaround_enabled;
> > >
> > >     /*
> > > @@ -221,6 +220,9 @@ struct kvm_page_fault {
> > >     /* The memslot containing gfn. May be NULL. */
> > >     struct kvm_memory_slot *slot;
> > >
> > > +   /* Derived from encryption bits of the faulting GPA for CVMs. */
> > > +   bool is_private;
> >
> > Either we can wrap it with the CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING or if
> > it looks ugly I can remove the "const" in my code.
>
> Hmm, I think we can keep the const.  Similar to the bug in kvm_faultin_pfn()[*],
> the kvm_slot_can_be_private() is bogus.  A fault should be considered private if
> it's marked as private, whether or not userspace has configured the slot to be
> private is irrelevant.  I.e. the xarray is the single source of truth, memslots
> are just plumbing.

If we incorporate Sean's suggestion and use xarray as the single
source of truth, then can we get rid of the
HAVE_KVM_PRIVATE_MEM_TESTING config?

Specifically, the self test can call the KVM_MEMORY_ENCRYPT_REG_REGION
ioctl which will set the bits for the private FD within KVM's xarray.

(Maybe this was part of the point that Sean was making; but his
feedback seemed focused on the discussion about keeping `is_private`
const, whereas I've been staring at this trying to figure out if we
can run the UPM selftests on a non-TDX/SNP VM WITHOUT a special
test-only config. And Sean's idea seems to eliminate the need for the
awkward CONFIG.)

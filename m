Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230165345F5
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 23:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbiEYVpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 17:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiEYVpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 17:45:31 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A1EB36FB
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 14:45:30 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id c19so24965469lfv.5
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 14:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GoHQcTc7Wsv9SwEZbOghaRKz9fDmm73K2D/ZBJdetK0=;
        b=irhC+b9v9qZtwxvP5MydHnwGD3VKeav5v58wHWzrGqIIOocpTu3ejs77IIuuwJGB7h
         mcPgHORLJeyUukYR0PwAvSW9nXBOPYRWqXZAyKhGwseTzyTVIMKbXXLrQSHfR8aoNWXF
         9ltCVMwyQQJ307rdrK62SEpcg29weRwdeiD+BrqRXnhumwixz8xtlqCRvvb17AsonF1o
         LyKOosUSQ58CusfD4giLhD/P0+1vPM4qqat49NGeBac2lndV/vjqcljY9leblaqeDURr
         A9R8voqyNdFslFtP6mBLOSVCmiIF1ipvaPR9uT1aYZWbSTsH95K3l00Qpx3UFqwWkN/T
         FgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GoHQcTc7Wsv9SwEZbOghaRKz9fDmm73K2D/ZBJdetK0=;
        b=GZctOx81Iyx8lXQ604pz3CiYFI5F1NxuAs4GksLAqKsCMwv1vheXp7n109coePv0gj
         IZJriGQsz3uqHCIMwQjdCImZLYPRQj40wsqKF6q/AGH8zT1YPZfjKJDNv0fqtTnfBUwU
         dtXPp3qfYecpJMoigRVFqKb0rdf+O5e6HI6cgwz5eieC7XP+v+B82W9BaXbuwb+pwig/
         drZ7IXXWbWLf0ACTFq84eXfOzYk40Vna19ye4fSdpEQ0JLMhqOckUs9tRQ25bcwNSOR3
         hzx5zOyAKbXWioU7fTXkHDGRLKY5GBsDTNRyo4u9hG+MDWL2nZIzbbZAVuSiZmm7q4D7
         DJqg==
X-Gm-Message-State: AOAM532u/dMubzXIaoQorYc26jQ3avXFKB4Af+s9lSvnFNj1BycUclP6
        3o1DK87q5G4huz+7S3D3vVK7yP8ISg2dTwghz+iPAQ==
X-Google-Smtp-Source: ABdhPJx4Mz3cd/KMdRKZE/U+hy7aV56tDKoTCouAs2sFAgg5UNl6Ryv8KZo3kUlrcSGVwchFApx3oeSzi1EdcQfaT/M=
X-Received: by 2002:a19:674c:0:b0:448:3f49:e6d5 with SMTP id
 e12-20020a19674c000000b004483f49e6d5mr25211060lfj.518.1653515128361; Wed, 25
 May 2022 14:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220415103414.86555-1-jiangshanlai@gmail.com> <YoK3zEVj+DuIBEs7@google.com>
In-Reply-To: <YoK3zEVj+DuIBEs7@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 25 May 2022 14:45:01 -0700
Message-ID: <CALzav=c_WfJ0hvHUFHkLH-+zrDXZSCzKsGHP6kPYd77adwHkUQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86/svm/nested: Cache PDPTEs for nested NPT in PAE
 paging mode
To:     Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Mon, May 16, 2022 at 2:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 15, 2022, Lai Jiangshan wrote:
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> >
> > When NPT enabled L1 is PAE paging, vcpu->arch.mmu->get_pdptrs() which
> > is nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE from memroy
> > unconditionally for each call.
> >
> > The guest PAE root page is not write-protected.
> >
> > The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get different
> > values every time or it is different from the return value of
> > mmu->get_pdptrs() in mmu_alloc_shadow_roots().
> >
> > And it will cause FNAME(fetch) installs the spte in a wrong sp
> > or links a sp to a wrong parent since FNAME(gpte_changed) can't
> > check these kind of changes.
> >
> > Cache the PDPTEs and the problem is resolved.  The guest is responsible
> > to info the host if its PAE root page is updated which will cause
> > nested vmexit and the host updates the cache when next nested run.
>
> Hmm, no, the guest is responsible for invalidating translations that can be
> cached in the TLB, but the guest is not responsible for a full reload of PDPTEs.
> Per the APM, the PDPTEs can be cached like regular PTEs:
>
>   Under SVM, however, when the processor is in guest mode with PAE enabled, the
>   guest PDPT entries are not cached or validated at this point, but instead are
>   loaded and checked on demand in the normal course of address translation, just
>   like page directory and page table entries. Any reserved bit violations ared
>   etected at the point of use, and result in a page-fault (#PF) exception rather
>   than a general-protection (#GP) exception.

This paragraph from the APM describes the behavior of CR3 loads while
in SVM guest-mode. But this patch is changing how KVM emulates SVM
host-mode (i.e. L1), right? It seems like AMD makes no guarantee
whether or not CR3 loads pre-load PDPTEs while in SVM host-mode.
(Although the APM does say that "modern processors" do not pre-load
PDPTEs.)

>
> So if L1 modifies a PDPTE from !PRESENT (or RESERVED) to PRESENT (and valid), then
> any active L2 vCPUs should recognize the new PDPTE without a nested VM-Exit because
> the old entry can't have been cached in the TLB.
>
> In practice, snapshotting at nested VMRUN would likely work, but architecturally
> it's wrong and could cause problems if L1+L2 are engange in paravirt shenanigans,
> e.g. async #PF comes to mind.
>
> I believe the correct way to fix this is to write-protect nNPT PDPTEs like all other
> shadow pages, which shouldn't be too awful to do as part of your series to route
> PDPTEs through kvm_mmu_get_page().

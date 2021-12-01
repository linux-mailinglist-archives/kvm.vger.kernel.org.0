Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495874656BA
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 20:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245430AbhLATws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 14:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbhLATwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 14:52:44 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD26DC061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 11:49:22 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w4so26558410ilv.12
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 11:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jDU8/pih7kWOumekbcpn6tedUi/knOPA6/2DfdBMPWw=;
        b=FAY1DNqOa9kOLqNAsnttqIOKyXX5zRyJ5iV2ZYoIzcN1jMy5614TBzQdMd/4YP6Z4g
         7vJbq+dn2I8An2uNsjl+7sNeT2AY+Pw1cFnu39fFvA/3ITJG/rjKovdBg3zXAdFvGzpU
         aQCR7yQXQACOWOKplpgLSVuMKkOJpq4z5jEuXIt78J89FjAgbWRKHczBmSX9qQcO/YQo
         4j6mYqPvNRJGUKQc/LOiNt03NcQyuZeU0/XVada4jnKmcehClW0Fe6jPkhZGt495e0TI
         N/cgTpdV2IdTe8CAbHAcC5qOUeqVw4Zq25q/RSPf1cmXWlwWmjHxtN1v4U2u9H9EKb48
         L2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jDU8/pih7kWOumekbcpn6tedUi/knOPA6/2DfdBMPWw=;
        b=nwix6GEnjklIxSXmCP1ksXi/Mxdmz5iFfqCKOXgyEBoH6jmuclbOk6xn2FG4o1cwUj
         WSGvjEAaHVvtIWSZSwa/ftV6TwFfLDeV3E1toA/h5Xlwa1PPfq0ZwENg22LayyV7knz7
         uTRDiPeJMr3mbp9nDyHD5NVdgnlwWMTKojZCFWZvHX1eO0m3W/iY5q/L1xcRGeHuN7s2
         Qc+koKWrXCPi5QwvSQPzrIDxfBM6lvR+v3xx5tspXzadFORB96PG8a4TKb0P36RydnnJ
         9CnULyxHS4Nfw/L7nBlN9vCyL+/jX9teLjWFVyJaMP0TeEuYU1YJymqD3AThuNG01K3P
         bNxw==
X-Gm-Message-State: AOAM532Y48lZYFzmwMqsORRIp4iLPGKN7sqrcMnqGIGCrDJlCeW20Tmd
        7Eb6tgNx65bYtb5FZUXcrffRsQtVdu2hJLkfafRFEQ==
X-Google-Smtp-Source: ABdhPJwWnrDz/WFoPrMuEpHfToPVe1GxNBoZdEXOfIdZzMMWJhNewiGV12UL4jzLQsqbakjRvYCDVFlEtK5zCnpGm78=
X-Received: by 2002:a05:6e02:1686:: with SMTP id f6mr11728625ila.298.1638388162054;
 Wed, 01 Dec 2021 11:49:22 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-14-dmatlack@google.com>
 <YafLdpkoTrtyoEjy@google.com>
In-Reply-To: <YafLdpkoTrtyoEjy@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 1 Dec 2021 11:49:11 -0800
Message-ID: <CANgfPd_K9kBu9Fd83wx0heMiWziLthg9tXD=6GsvLsFd0GapYA@mail.gmail.com>
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during CLEAR_DIRTY_LOG
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 1, 2021 at 11:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Nov 19, 2021, David Matlack wrote:
> > When using initially-all-set, large pages are not write-protected when
> > dirty logging is enabled on the memslot. Instead they are
> > write-protected once userspace invoked CLEAR_DIRTY_LOG for the first
> > time, and only for the specific sub-region of the memslot that userspace
> > whishes to clear.
> >
> > Enhance CLEAR_DIRTY_LOG to also try to split large pages prior to
> > write-protecting to avoid causing write-protection faults on vCPU
> > threads. This also allows userspace to smear the cost of large page
> > splitting across multiple ioctls rather than splitting the entire
> > memslot when not using initially-all-set.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  4 ++++
> >  arch/x86/kvm/mmu/mmu.c          | 30 ++++++++++++++++++++++--------
> >  2 files changed, 26 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 432a4df817ec..6b5bf99f57af 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1591,6 +1591,10 @@ void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
> >  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> >                                     const struct kvm_memory_slot *memslot,
> >                                     int start_level);
> > +void kvm_mmu_try_split_large_pages(struct kvm *kvm,
>
> I would prefer we use hugepage when possible, mostly because that's the terminology
> used by the kernel.  KVM is comically inconsistent, but if we make an effort to use
> hugepage when adding new code, hopefully someday we'll have enough inertia to commit
> fully to hugepage.

In my mind "huge page" implies 2M and "large page" is generic to 2m
and 1g. (IDK if we settled on a name for 1G pages)
I've definitely been guilty of reinforcing this inconsistent
terminology. (Though it was consistent in my head, of course.) If we
want to pick one and use it everywhere, I'm happy to get onboard with
a standard terminology.

>
> > +                                const struct kvm_memory_slot *memslot,
> > +                                u64 start, u64 end,
> > +                                int target_level);
> >  void kvm_mmu_slot_try_split_large_pages(struct kvm *kvm,
> >                                       const struct kvm_memory_slot *memslot,
> >                                       int target_level);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6768ef9c0891..4e78ef2dd352 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1448,6 +1448,12 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >               gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
> >               gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
> >
> > +             /*
> > +              * Try to proactively split any large pages down to 4KB so that
> > +              * vCPUs don't have to take write-protection faults.
> > +              */
> > +             kvm_mmu_try_split_large_pages(kvm, slot, start, end, PG_LEVEL_4K);
>
> This should return a value.  If splitting succeeds, there should be no hugepages
> and so walking the page tables to write-protect 2M is unnecessary.  Same for the
> previous patch, although skipping the write-protect path is a little less
> straightforward in that case.
>
> > +
> >               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
> >
> >               /* Cross two large pages? */

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57B1115820
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 21:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfLFUKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 15:10:14 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:37971 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfLFUKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 15:10:14 -0500
Received: by mail-vs1-f67.google.com with SMTP id y195so5955504vsy.5
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 12:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KCnSYM0MTK/bYQiTEoUMYE0zDV+8yWqRT1kXGMhazVw=;
        b=FGiqEpVEMukE+w5GmYTJY/xFRGc28a9kPdgoeEzQELigGGc31oRCZ7Qsc57wTIQqUF
         E7YOcJD8ekx+B1X555iA3/vM9Mu8/2htMWDy8ZdRCwtqDJ8UHb+j7vZHkwln4atLR6c0
         PVq1lqS+2aM1DveoB6SywvPWfsLBmoJaS2oYQEljovr5MfU3g1jo1cmFYgHv89H3vO4d
         HRziKq0J03xVkvvst0YF1lHD+fqeTT89ak08oEVibIyD16OkGLXuRqaowHDN2h4aYUFz
         FR2Uz4R0f/UT8xhW3S45jem+jPSroDfGwENz0GSXKkpE/NT3Is6Dmeezd6T0+OnfI+O8
         rw/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KCnSYM0MTK/bYQiTEoUMYE0zDV+8yWqRT1kXGMhazVw=;
        b=rdoqtwAYjwIX+jq6UaFoe9qE8g4OUF9tr7n7X4EIgS40vwff5+QjtgXwBumy1MICBx
         0q2WA6uiCgdQUiSml6j3YGdLXTieXACe9AdguY3A9tznVkqZIf3gFFhTn2PFPL+bgyBk
         TP1D8DaIWQ/GD6w5JlPm4SDG8gqqQBhBsUVr6GFURuhG7sDVzzzIxYSv5wpRoZO8PNlw
         cisMBGeSlOXZYsE1GTC+sE+PYgej/z3HRfW/x4BxraPbFXXvJu4fgDqcgRTgeBXcUrwA
         FRHmnZVZFYYVEB9aMm+z58HmmVV3oF9Hwg9C5jvy5RFEplhCbqzJb6jMKc8xJ1mvs34F
         uing==
X-Gm-Message-State: APjAAAVULHylJLTE2Ibo2FAJmOH2U6FI62LGK6YQwOf0qOcFM+yiauO0
        OAetwD9f9tglg+IHnxCRIxl3pe+yhKXTj7t4+x/L2Q==
X-Google-Smtp-Source: APXvYqwiFSNXFckF45beWWl25tPHVGzkHQRx8yjU2nNnL7nr3VDipb0Dt9FoPtk3Yb8gxwXabATqw43siCA/RJBbq/g=
X-Received: by 2002:a67:1104:: with SMTP id 4mr10940656vsr.117.1575663013216;
 Fri, 06 Dec 2019 12:10:13 -0800 (PST)
MIME-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com> <20190926231824.149014-5-bgardon@google.com>
 <20191127183911.GD22227@linux.intel.com>
In-Reply-To: <20191127183911.GD22227@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Fri, 6 Dec 2019 12:10:02 -0800
Message-ID: <CANgfPd8Mob-6za8m6wTsU=jk7E0qU6SawNU+Q1geBnuFXDQQLQ@mail.gmail.com>
Subject: Re: [RFC PATCH 04/28] kvm: mmu: Update the lpages stat atomically
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I would definitely support changing all the entries in KVM stat to be
64 bit and making some of them atomic64_t. I agree that doing atomic
operations on int64s is fragile.

On Wed, Nov 27, 2019 at 10:39 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Sep 26, 2019 at 04:18:00PM -0700, Ben Gardon wrote:
> > In order to pave the way for more concurrent MMU operations, updates to
> > VM-global stats need to be done atomically. Change updates to the lpages
> > stat to be atomic in preparation for the introduction of parallel page
> > fault handling.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index 1ecd6d51c0ee0..56587655aecb9 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -1532,7 +1532,7 @@ static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
> >               WARN_ON(page_header(__pa(sptep))->role.level ==
> >                       PT_PAGE_TABLE_LEVEL);
> >               drop_spte(kvm, sptep);
> > -             --kvm->stat.lpages;
> > +             xadd(&kvm->stat.lpages, -1);
>
> Manually doing atomic operations without converting the variable itself to
> an atomic feels like a hack, e.g. lacks the compile time checks provided
> by the atomics framework.
>
> Tangentially related, should the members of struct kvm_vm_stat be forced
> to 64-bit variables to avoid theoretical wrapping on 32-bit KVM?
>
> >               return true;
> >       }
> >
> > @@ -2676,7 +2676,7 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
> >               if (is_last_spte(pte, sp->role.level)) {
> >                       drop_spte(kvm, spte);
> >                       if (is_large_pte(pte))
> > -                             --kvm->stat.lpages;
> > +                             xadd(&kvm->stat.lpages, -1);
> >               } else {
> >                       child = page_header(pte & PT64_BASE_ADDR_MASK);
> >                       drop_parent_pte(child, spte);
> > @@ -3134,7 +3134,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
> >       pgprintk("%s: setting spte %llx\n", __func__, *sptep);
> >       trace_kvm_mmu_set_spte(level, gfn, sptep);
> >       if (!was_rmapped && is_large_pte(*sptep))
> > -             ++vcpu->kvm->stat.lpages;
> > +             xadd(&vcpu->kvm->stat.lpages, 1);
> >
> >       if (is_shadow_present_pte(*sptep)) {
> >               if (!was_rmapped) {
> > --
> > 2.23.0.444.g18eeb5a265-goog
> >

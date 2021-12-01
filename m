Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01018465832
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 22:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhLAVPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 16:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343996AbhLAVPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 16:15:15 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF59C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 13:11:53 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id 207so50693517ljf.10
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 13:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KY5xcYgaaKaQg2jP/3tP3Kpa++oQt5V9+j3IMwXcErM=;
        b=Vaj7BDtscZBqU2wYAlQMQJSzD3jwxYY5YePkb/9bp/XXKXH7dybu9YoZAGxEjfGLk7
         GjBLB4ImlEA4l6HNQMAJz51S2rhpORhS9RNXULmWefvbfCfOiSwyeHNpO5fgncpYtFOI
         n0fKJ5EwTgXODdB2T57xTCLdInL5Il3no7eiqcfTsMqgioHbgMQESlIiSXrvuPdxJJL+
         fkkcM1up9okNMUoB+BJu5K/zxzhOxmktIrgrwRkTaYq11GyoYbsjRPYqSz12PrD+F88G
         HVlw8BbcCJsJsaUFpMYxTC4ayTYtX87U95wYnaL4w9CeFv6begr+kzlroZXpDA4Ri6v0
         facw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KY5xcYgaaKaQg2jP/3tP3Kpa++oQt5V9+j3IMwXcErM=;
        b=JtPs0xi4fWWH3JeIfTk1QDaiOmJZpjLnC7WoC5FoO+LWdmB/PBMfKSG8aMNqJKZqKO
         hsF1r0Fn0eeyJ2ebysWOTpNxMFb9tZOExHQhWC9puSXV7o6cFSRT65NSMh95rPylJC85
         3JmdmOzc+FqKyDpi20XNY3ctfYy+H6zim2X9eCCh2pk0bLvF/8PRF7OITbkRWGjApY30
         Y/ggcm5KBafqB0besDCa0jChJtRWSL4ARAfgyRHN6lwI29Xi7UGRRvMqD7KJi0IS8W8e
         aK+/Y2MhYrbilnopQnIgpRUGHk095hT7f2x1abmUZg6/lAMEJZAVeLYJurUGb7CHXnOr
         EkGg==
X-Gm-Message-State: AOAM530AfqffecUOsgD2MXIsB1cep5fZstatIWtsZUk4v8WJRufnpbPu
        mmD2JtE7cBuIV10lAHiNE5n3HDa0AbbRSu8xbtlPLobSqdU=
X-Google-Smtp-Source: ABdhPJzz1c36QC2BiozdMpwAWo3yZdGHtkaaQy5tX7KSBxrE4wSod4Wc24wbO2KcIy3cEvWUahqUpTuiwI2cHKhiGhU=
X-Received: by 2002:a2e:9e59:: with SMTP id g25mr7782701ljk.464.1638393111970;
 Wed, 01 Dec 2021 13:11:51 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-16-dmatlack@google.com>
 <YafO2QLmiMRfSAcZ@google.com>
In-Reply-To: <YafO2QLmiMRfSAcZ@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 1 Dec 2021 13:11:25 -0800
Message-ID: <CALzav=cVn-R48VaufcZ-gqE-KD2a8WD1cyA5v+azsaJBMYBVdQ@mail.gmail.com>
Subject: Re: [RFC PATCH 15/15] KVM: x86/mmu: Update page stats when splitting
 large pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
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

On Wed, Dec 1, 2021 at 11:37 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Nov 19, 2021, David Matlack wrote:
> > When splitting large pages we need to update the pages stats to reflect
> > all of the new pages at the lower level. We do not need to change the
> > page stats for the large page that was removed as that is already
> > handled tdp_mmu_set_spte_atomic.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 8f60d942c789..4c313613a939 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1299,7 +1299,12 @@ static bool tdp_mmu_split_large_page_atomic(struct kvm *kvm, struct tdp_iter *it
> >               child_sp->spt[i] = child_spte;
> >       }
> >
> > -     return tdp_mmu_install_sp_atomic(kvm, iter, child_sp, false);
> > +     if (!tdp_mmu_install_sp_atomic(kvm, iter, child_sp, false))
> > +             return false;
> > +
> > +     kvm_update_page_stats(kvm, level - 1, PT64_ENT_PER_PAGE);
>
> This should be done when tdp_mmu_split_large_page_atomic() is introduced, otherwise
> this series is effectively introducing a bug and then fixing it.  At a very quick
> glance, I don't see anything that would prevent squashing this in.

Will do.

>
> > +
> > +     return true;
> >  }
> >
> >  static void tdp_mmu_split_large_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > --
> > 2.34.0.rc2.393.gf8c9666880-goog
> >

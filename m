Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980224C1FC3
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 00:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244840AbiBWXgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 18:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241997AbiBWXgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 18:36:12 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE7159A72
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:35:43 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vz16so768217ejb.0
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6BEVhwDl0o7tKtwDnwmP6riaeuofFGCv6jbqHEWrC/Q=;
        b=I0DlJiYDFHk7IF6jgaZdkpolAJPlSmSQOOtbxqc6Q1Xs65GoWrnPlbmQTZHMcVAXoE
         1jnnkyrRYDXGObI7TPCx3N3nQdHvi2EXY0Q4/GagaiPI9Di4AVB9ytf5OXYT9Ykxp8Bi
         egnTcg+o0fTO5sutqDGkSe4Xp11+qccGeJNXjTw4FPiTYXShZ91yrSf6wrNHoOmNi/CX
         yqOzsTmkTbZsrCOVDQS9MhvluzSVHJzJ9CMLydsigfzYTdO6NyOCqsz7CsMX49lGbreB
         J92sVN3EfHLVc+ORGxdYZEPf6tGVFB3Drm1qU00UigKsn7d+nPNiw3xIcfnIMCJxP5U+
         cUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6BEVhwDl0o7tKtwDnwmP6riaeuofFGCv6jbqHEWrC/Q=;
        b=BlaX6E5V5G1GZ5qprq1+ssnsifEbiCMpdY8QTL/uJqa9UMI1t7lsCopmyzOXUZqtLb
         ac4pSxPqBTSYn5FJ4bV7+QkEwvZbEtbKwajEwouKZU/an531EdnQjixYbJLmlnYJ5uZN
         67/b4WzSyLJGR8tau5/bu4c9ucGKKtc/CReiai06nxdfvUZeMGSkV51+8EIk2tNMBZ1q
         hkHqD7UWKmrYKZhG/qBWc83fFLyosh+Z4a+i9QBsiiCqY7E2IGNSYBEq+XmRUQf4GtNk
         uUo43NSaLC1IL3yCXqJ9EbEolEiD372MWgwHw+yAYh0IDco/ikItM//VC0k25JYQypt5
         Vnbw==
X-Gm-Message-State: AOAM533atJRqSKhFO8T5g11AtY2brw7Fb60Oy4CHS5iQ2m+ckCjH8GvQ
        e1u1DjxCDMKos5HvaXPtaliG98TcoYKb6x8KiHgGEQ==
X-Google-Smtp-Source: ABdhPJyyDhEOfnAjb2BcESRXKyd3HSF18oP1vowA94k2h9qm3UvRRAIEvjmnJKRIxHrcOHt+ZZ2ZwcKXN9A2QCz5VfQ=
X-Received: by 2002:a17:906:be1:b0:6ce:c3c8:b4b6 with SMTP id
 z1-20020a1709060be100b006cec3c8b4b6mr36366ejg.617.1645659342359; Wed, 23 Feb
 2022 15:35:42 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-14-dmatlack@google.com>
 <CANgfPd-h7J=j8r_APaHRWSsvJtaP69aYtNGpb=m3h_H6QuR_DA@mail.gmail.com>
In-Reply-To: <CANgfPd-h7J=j8r_APaHRWSsvJtaP69aYtNGpb=m3h_H6QuR_DA@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 23 Feb 2022 15:35:31 -0800
Message-ID: <CANgfPd_wSncCH7QDJk5Ece14ZQ8OQRk0sYTfZ8BmAzY=v8h2Mg@mail.gmail.com>
Subject: Re: [PATCH 13/23] KVM: x86/mmu: Update page stats in __rmap_add()
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm <kvm@vger.kernel.org>
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

On Wed, Feb 23, 2022 at 3:32 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Feb 2, 2022 at 5:02 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Update the page stats in __rmap_add() rather than at the call site. This
> > will avoid having to manually update page stats when splitting huge
> > pages in a subsequent commit.
> >
> > No functional change intended.
> >
>
> Reviewed-by: Ben Gardon <bgardon@google.com>
>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index c2f7f026d414..ae1564e67e49 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1621,6 +1621,8 @@ static void __rmap_add(struct kvm *kvm,
> >         rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
> >         rmap_count = pte_list_add(cache, spte, rmap_head);
> >
> > +       kvm_update_page_stats(kvm, sp->role.level, 1);
> > +

Strictly speaking, this is a functional change since you're moving the
stat update after the rmap update, but there's no synchronization on
the stats anyway, so I don't think it matters if it's updated before
or after.

> >         if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
> >                 kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
> >                 kvm_flush_remote_tlbs_with_address(
> > @@ -2831,7 +2833,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> >
> >         if (!was_rmapped) {
> >                 WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
> > -               kvm_update_page_stats(vcpu->kvm, level, 1);
> >                 rmap_add(vcpu, slot, sptep, gfn);
> >         }
> >
> > --
> > 2.35.0.rc2.247.g8bbb082509-goog
> >

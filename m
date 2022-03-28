Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D164EA322
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 00:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiC1WnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 18:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiC1WnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 18:43:11 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFC44C79C
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 15:41:30 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2e6ceb45174so125670417b3.8
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 15:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oYCH6Tbs6UcHw4KzVWnqyB1tic3vYPe5BOmHRgVgeGc=;
        b=DXMddp8E6FufRbI7n5Mavm/b4sDlNGwYT7SziIoihbl7tK7WJf2VlYhXskH/Lotqxw
         varDp4naHpHQRsmUWhXkzmBOR7a7R9a176GfXY3o7xQbejLy19s+q+erD9NXDpcxObqV
         maBZvTQCN+RdX5ppq0tht/ip46gP3e8Qp4Odw8a/DSGU6LthwR6TMI2zcxwOvhrUWzYr
         WyHvsvcNdMtX023I/zWUxPAbnqUZpVomxEqS9C83U1JnXsEBNw89KUTu8gDyGWJfwPWB
         nKT0gCELCe0m5MhqA4TVxR9TZ585fhUs8KQ7Nwr1vwoOD2pD+TL+YIuzOWg0xyk+c8ik
         zoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oYCH6Tbs6UcHw4KzVWnqyB1tic3vYPe5BOmHRgVgeGc=;
        b=0mfj8FullQMAp8HSvDb185fvHS/fz8QyvAvvUTO4bcbODkJFZbKW9FPrEvD01yg50l
         g95Zu44Wb7zqDgtrqJ9qlq/LdoQj/I4g/n197xpIg7sVC7qbUblUqocOrCMzvFVYMbRL
         8a/gy0JKyB9cA9iJoIRzrS/k7Tlk3oSVVkBdR2tLH3DCxBoCpEAZb7o8U8eXY4Gz839l
         ucJNEiaNYNh3bTY/M7nFFXmloL6rdeCoBZSbmwi+nbnJo4OagZ9iYRZLnQePOY0VSDdJ
         hI4u4KOmmyvegzc7MxCsDSzZqJdBd3gbAb+pTmGC9jERxsUfRxTHsU1OghnCwj+io0A9
         QHmQ==
X-Gm-Message-State: AOAM530YBk/k83SXVwitg5Gxo+bYPbc6tj8HZ4+XXB/JuB4vUzZ9LGvt
        Ak/RStior5g/jI+L+INvuyPsgGEqtMBqsPqvWpQj2Q==
X-Google-Smtp-Source: ABdhPJxD8jid1ituckpG2t6iuULWOFy82bVcu9QN/LK3fH6g7pJWwcDl10kAUx7sb6qz3x62A+urpqCoemYCdl7qCEM=
X-Received: by 2002:a81:15ce:0:b0:2e5:e189:7366 with SMTP id
 197-20020a8115ce000000b002e5e1897366mr28596553ywv.188.1648507289066; Mon, 28
 Mar 2022 15:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220321234844.1543161-1-bgardon@google.com> <20220321234844.1543161-8-bgardon@google.com>
 <YkIYF6HzLy+l6tu8@google.com>
In-Reply-To: <YkIYF6HzLy+l6tu8@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Mar 2022 15:41:18 -0700
Message-ID: <CANgfPd_XYoFAcrwkKE-fkS-wP7omNxC36fagT=OGaSE8Er3JXQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/11] KVM: x86/MMU: Factor out updating NX hugepages
 state for a VM
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Mar 28, 2022 at 1:18 PM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, Mar 21, 2022 at 04:48:40PM -0700, Ben Gardon wrote:
> > Factor out the code to update the NX hugepages state for an individual
> > VM. This will be expanded in future commits to allow per-VM control of
> > Nx hugepages.
> >
> > No functional change intended.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 18 +++++++++++-------
> >  1 file changed, 11 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 3b8da8b0745e..1b59b56642f1 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6195,6 +6195,15 @@ static void __set_nx_huge_pages(bool val)
> >       nx_huge_pages = itlb_multihit_kvm_mitigation = val;
> >  }
> >
> > +static int kvm_update_nx_huge_pages(struct kvm *kvm)
> > +{
> > +     mutex_lock(&kvm->slots_lock);
> > +     kvm_mmu_zap_all_fast(kvm);
> > +     mutex_unlock(&kvm->slots_lock);
> > +
> > +     wake_up_process(kvm->arch.nx_lpage_recovery_thread);
> > +}
> > +
> >  static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
> >  {
> >       bool old_val = nx_huge_pages;
> > @@ -6217,13 +6226,8 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
> >
> >               mutex_lock(&kvm_lock);
> >
>
> nit: This blank line is asymmetrical with mutex_unlock().
>
> > -             list_for_each_entry(kvm, &vm_list, vm_list) {
> > -                     mutex_lock(&kvm->slots_lock);
> > -                     kvm_mmu_zap_all_fast(kvm);
> > -                     mutex_unlock(&kvm->slots_lock);
> > -
> > -                     wake_up_process(kvm->arch.nx_lpage_recovery_thread);
> > -             }
> > +             list_for_each_entry(kvm, &vm_list, vm_list)
> > +                     kvm_set_nx_huge_pages(kvm);
>
> This should be kvm_update_nx_huge_pages() right?

Oh woops, duh. Apparently I did not compile-test this patch individually.

>
> >               mutex_unlock(&kvm_lock);
> >       }
> >
> > --
> > 2.35.1.894.gb6a874cedc-goog
> >

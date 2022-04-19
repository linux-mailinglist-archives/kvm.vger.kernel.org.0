Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D645A506272
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 05:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345904AbiDSDEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 23:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiDSDEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 23:04:31 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5479127149
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 20:01:48 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id bn33so18888953ljb.6
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 20:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KOKDemPG9w5pDIt9lxbcT1h2mNUqVQt2NYUz527H2FM=;
        b=BRVG64HEdUJe/6BxS9eFWGfdYcAnVqQxHDLB5x6yMtfpBCKh/6ZuT+HUdUAiOw6e4p
         O7F/hzLQ7OqSjmSKw+eZ+4Yynmg4nWZ3/hd/iNb2JAU+2vC1aa/A9dO1T3UNs8PF/kR0
         zZQLoaS86IcjcU8jGetyCvpA6p14dwTtRNdQGhZsYsqtnTD9pA58WuqvJ+PfMQOWguA0
         aOXFJeoAYAkZnPNaLW+dFQA7TK0wdnkIiq95yBduGVBtxirNX2rDBPweEgLz23uxKP/f
         01xCaMc/XwsiUSG8SZKg2qFFuRt2yOPtZix+OFvlM/Z7W/fFJemymVb3k0Sqp/ZVW3t6
         GYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KOKDemPG9w5pDIt9lxbcT1h2mNUqVQt2NYUz527H2FM=;
        b=MCGmTcgyVrOviZJgPSYUxRJ5YdTr1un7xOvpU3OjH+yoYnbo5Ib/03linZs5J5AnRD
         QVQy5eONKjf9bI5x4U5PnPxgvR1koXj3xIMGOodhIz23suzEeQ9NUXIXmuzJ21e2bW0y
         1d2K6HQEZE1qY59GRTafzchfMnCsfG8Up/fjzSIhcjpbck9/D8xXX3GU59arJ+kuEol0
         DJ7mgWEKI6eafiu9n3HNvw0dMrGmq4JwaaQlkxXARrZIlzGHd6S6gL1YXWfg7b3L6MxL
         OM6drLkbD0lgY1O1AjVHoqhmwUi4j7rJuaCHGSBA5L2208tAXgzzIBxvULc07yY8iYeF
         hvwQ==
X-Gm-Message-State: AOAM533M3J8eGJkl3MjN7fLSSNoCs9VqtJR5qQNvWwB4Lpk9GH+7A6Q0
        apvqVVk0QwEJ/6zpYcRT3Zq8KPosHhKCPKXuV6b+KSmxTvk=
X-Google-Smtp-Source: ABdhPJy/iU7MkXvcxrILygpddagGbgHmjRKa8yLTk2ky4cPUEnqKc3r7duTSD1q19nSi+eG3N7uR8Svl3ql1n/oBryg=
X-Received: by 2002:a2e:5cc1:0:b0:24b:112f:9b36 with SMTP id
 q184-20020a2e5cc1000000b0024b112f9b36mr9107276ljb.337.1650337304523; Mon, 18
 Apr 2022 20:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <20220415215901.1737897-5-oupton@google.com>
 <Yl4knFR8E8XVbgDj@google.com>
In-Reply-To: <Yl4knFR8E8XVbgDj@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 18 Apr 2022 20:01:33 -0700
Message-ID: <CAOQ_Qsi624p_a7WM74akGZxt6u7=vz_5nrfdh+9iFaz2J6QmEA@mail.gmail.com>
Subject: Re: [RFC PATCH 04/17] KVM: arm64: Protect page table traversal with RCU
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
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

On Mon, Apr 18, 2022 at 7:55 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Fri, Apr 15, 2022 at 09:58:48PM +0000, Oliver Upton wrote:
> > Use RCU to safely traverse the page tables in parallel; the tables
> > themselves will only be freed from an RCU synchronized context. Don't
> > even bother with adding support to hyp, and instead just assume
> > exclusive access of the page tables.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 5b64fbca8a93..d4699f698d6e 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -132,9 +132,28 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
> >       return pte;
> >  }
> >
> > +
> > +#if defined(__KVM_NVHE_HYPERVISOR__)
> > +static inline void kvm_pgtable_walk_begin(void)
> > +{}
> > +
> > +static inline void kvm_pgtable_walk_end(void)
> > +{}
> > +
> > +#define kvm_dereference_ptep rcu_dereference_raw
> > +#else
> > +#define kvm_pgtable_walk_begin       rcu_read_lock
> > +
> > +#define kvm_pgtable_walk_end rcu_read_unlock
> > +
> > +#define kvm_dereference_ptep rcu_dereference
> > +#endif
> > +
> >  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
> >  {
> > -     return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
> > +     kvm_pte_t __rcu *ptep = mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
> > +
> > +     return kvm_dereference_ptep(ptep);
> >  }
> >
> >  static void kvm_clear_pte(kvm_pte_t *ptep)
> > @@ -288,7 +307,9 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >               .walker = walker,
> >       };
> >
> > +     kvm_pgtable_walk_begin();
> >       return _kvm_pgtable_walk(&walk_data);
> > +     kvm_pgtable_walk_end();
>
> This might be fixed later in the series, but at this point the
> rcu_read_unlock is never called.

Well that's embarrassing!

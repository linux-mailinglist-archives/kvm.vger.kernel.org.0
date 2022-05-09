Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5D75207FF
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 00:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiEIWvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 18:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiEIWvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 18:51:14 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039A72C4F43
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 15:47:19 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i1so15190361plg.7
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 15:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HqfHpv0KlKI7R/yNkzZ4Z0O6e/LDYyZQrPZnAWmT71E=;
        b=gBcOu1AAKpSXofktmoX+I7Bsue1fm8qXDW5SAW2z78o+w1vB0SSgx4IklNVsM6AAzZ
         rRanfgSmN+B+INR8d1D8AkH0tSIFfSoPJ6A1yAUns87zIIglHwwo2m30NPBXwdX6TkWW
         SEK+nrP1tpdnPeU3iaz+GJi7tRkKbBkzOi5H4MwWVtOkVkQ/68e+8sIXf2yl0Iu4H6Hw
         OTlElUOOi39t2GII8YY4Ffe6Y2H/8k+QiYj5KX2vieq1bsIMVrRUSDXE38zuU0bl3Ntb
         BAua97uPHpzdm6iAaITSrNyyPFguQ121LRQWWdm6DNlKn8HkFJ2uJNJ4JUyeP1z+xoqX
         Ts5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HqfHpv0KlKI7R/yNkzZ4Z0O6e/LDYyZQrPZnAWmT71E=;
        b=MTNpUnoVfySqqmkciYDSdsg+9C6ZEq0WhJ7iFfZhIgyEgzfTFVGJqUXKNQFwuAJr5H
         Fvo8j7DxKVj+jY+PFhlDCx6jH3hX2okYokQFvGWYKGUaGCYyQD1IkmByMSBTJSWmpLfo
         EqCA7vgMQlPZhtnyPSvkOeZjIBmhXKG2Q/MLE/nw//lRuBZgD1Z44m4jUozXVZ7hvtIQ
         r780e+ndzqOdGjwh24stpZXvGsOmkwR1RIRx/czJwwP7Hi1v36tK9AptMi/ezgxOyJ5O
         W67Fg7DB89tP5ogGPi/Km8gVbBpxNsq9cklUEqi7SmUHFpmv0yoFx2pIISma1UEM3V0y
         1OfA==
X-Gm-Message-State: AOAM531nNukQdjLmI3CCP2MrwECwRc1Vjl38adQVwVG29huznGgdF6OE
        Zn4eXXZ0Fg1fhVxtFssiE/Ja0A==
X-Google-Smtp-Source: ABdhPJzlAs+WsB2F0OyBXHzmXsCE5yKPzcqLqI7jJtlr5bkfm/U8b2uxGA/nhaBtBW85p0tqZlWDJg==
X-Received: by 2002:a17:902:c2c7:b0:159:9f9:85f3 with SMTP id c7-20020a170902c2c700b0015909f985f3mr18070842pla.18.1652136437989;
        Mon, 09 May 2022 15:47:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a018300b001cb978f906esm259814pjc.0.2022.05.09.15.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:47:17 -0700 (PDT)
Date:   Mon, 9 May 2022 22:47:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v4 20/20] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
Message-ID: <YnmZ8jUaWHCuQ++r@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-21-dmatlack@google.com>
 <YnlFzMpJZNfFuFic@google.com>
 <CALzav=fTTf8=u1i0pePxAHtuHr4Q_+N1-d8x09MtRk+6y250rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=fTTf8=u1i0pePxAHtuHr4Q_+N1-d8x09MtRk+6y250rw@mail.gmail.com>
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

On Mon, May 09, 2022, David Matlack wrote:
> On Mon, May 9, 2022 at 9:48 AM Sean Christopherson <seanjc@google.com> wrote:
> > > +static void kvm_nested_mmu_try_split_huge_pages(struct kvm *kvm,
> > > +                                             const struct kvm_memory_slot *slot,
> > > +                                             gfn_t start, gfn_t end,
> > > +                                             int target_level)
> > > +{
> > > +     int level;
> > > +
> > > +     /*
> > > +      * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
> > > +      * down to the target level. This ensures pages are recursively split
> > > +      * all the way to the target level. There's no need to split pages
> > > +      * already at the target level.
> > > +      */
> > > +     for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
> >
> > Unnecessary braces.
> 
> The brace is unnecessary, but when the inner statement is split across
> multiple lines I tend to prefer using braces. (That's why I did the
> same in the other patch and you had the same feedback.) I couldn't
> find any guidance about this in CodingStyle so I'm fine with getting
> rid of the braces if that's what you prefer.

The style varies by subsystem, e.g. I believe perf requires braces in this case.
Absent a "hard" rule, I value consistency above all else, e.g. because KVM doesn't
(usually) include the braces, I started looking for the second statement, i.e. the
lack of an opening brace is an indicator (to me at elast) that a loop/if contains
a single statement.

I actually like Golang's forced braces, but mostly because they are 100% mandatory
and so all code is consistent.
 
> > > +             slot_handle_level_range(kvm, slot,
> > > +                                     nested_mmu_try_split_huge_pages,
> > > +                                     level, level, start, end - 1,
> > > +                                     true, false);
> >
> > IMO it's worth running over by 4 chars to drop 2 lines:
> 
> Will do.
> 
> >
> >         for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--)
> >                 slot_handle_level_range(kvm, slot, nested_mmu_try_split_huge_pages,
> >                                         level, level, start, end - 1, true, false);
> > > +     }
> > > +}
> > > +
> > >  /* Must be called with the mmu_lock held in write-mode. */
> >
> > Add a lockdep assertion, not a comment.
> 
> Agreed but this is an existing comment, so better left to a separate patch.

Doh, I mistook the /* for a +.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0A64E4987
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 00:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiCVXKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 19:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237714AbiCVXKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 19:10:06 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C48F6EB2A
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 16:08:36 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id k21so15779900lfe.4
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 16:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mTTFE/78fuZDPiUjjJj3Ss+v6yYociVg/54x3WiDppI=;
        b=AtUMJgZ9t0Fiz5REAj00cuT2GhuBOVgcleoPH33KuSiD6KinBWwOwkTJUkr9PsgxDN
         TyDPGlBdULNNbsjEeWOukk/bVG7/QNX0CG1Sr3YVimBK2RTwFt9JEwHuXd89blOchI4O
         vwbvArTGQ9IPaoj9TTK+fhuX+VGfQF2u2DCC4WrtNhILbnJociZ7w1dQlFqaV2j0vf7n
         svQP5H4o/8R/VNvsQakatJxIytdbL7IJ3QIgcAEtDTHuN21fPSlb4cnYK4zu1p6CpS65
         YZFFJjFNFeCVNR5eCWbIo5vple/iraGnKrEDxh5nxpkupBxwR6jz94TEofxga2vrX8Dr
         RtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mTTFE/78fuZDPiUjjJj3Ss+v6yYociVg/54x3WiDppI=;
        b=KP3jf8UaUTP/iSfz4r2XeVlUBm6s8h5HJiTSf65nNlNckoGP+w518r5n9i6w4RU9hr
         8ejTvDai0fpr3k7ibjTaKGr/SBxVUpG1LI1rD2Zt48hDT8MeAYPRwdRxNT8ggONn/qWp
         9v0XEb44x/6ZzobcTLL99KI2KEs9SRPPWvkwdF3dsQJm4TnaE+Sm4kTxe9lZakmvG/P4
         8QgeqP6ZZtqk4dN0pDE8oSN7joP19KASQeraIqYpqgUZXBlRaETN7G3aRkxXvGHWvTeT
         qspQ7tj8TETEqoJosnAbBF2Fn1j73n1pH8ImGFPzVIPXw5jEjatoULuNlnUmr7IC8jed
         Bu6A==
X-Gm-Message-State: AOAM533JWgw95rr3hY+5fxvntNiVCyIejCkbL2xGcpU3yZSbZJNVdtrd
        OBzj8sPIrNNdX+FfzkObOHcJE1uRZqW2Mc13zJ4u7Q==
X-Google-Smtp-Source: ABdhPJwvtLvpn2H6Z4lJn9F/iyZNFskD3MwkoE6H+EfWq/OlKZPPiQcbGScUEqtawLL0W5MBlHCvFgFE+wVkBkGa91U=
X-Received: by 2002:a19:674c:0:b0:448:3f49:e6d5 with SMTP id
 e12-20020a19674c000000b004483f49e6d5mr20032193lfj.518.1647990514538; Tue, 22
 Mar 2022 16:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-18-dmatlack@google.com>
 <YjGjWcmn+7sZPjNX@xz-m1.local>
In-Reply-To: <YjGjWcmn+7sZPjNX@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 16:08:08 -0700
Message-ID: <CALzav=d1j-SUFEauqrQaJ5gE89ybSdW3OWnmdsaA6iADVnQfjA@mail.gmail.com>
Subject: Re: [PATCH v2 17/26] KVM: x86/mmu: Pass access information to make_huge_page_split_spte()
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
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

On Wed, Mar 16, 2022 at 1:44 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:19AM +0000, David Matlack wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 85b7bc333302..541b145b2df2 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1430,7 +1430,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> >        * not been linked in yet and thus is not reachable from any other CPU.
> >        */
> >       for (i = 0; i < PT64_ENT_PER_PAGE; i++)
> > -             sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
> > +             sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);
>
> Pure question: is it possible that huge_spte is RO while we passed in
> ACC_ALL here (which has the write bit set)?

Yes that is possible, but only if KVM the page is RO due to host-side
policies (e.g. RO memslot or RO VMA). "access" here is the
guest-allowed access permissions, similar to the pte_access parameter
to mmu_set_spte(). e.g. notice how the TDP MMU passes ACC_ALL to
make_spte().

> Would it be better if we make it a "bool exec" to be clearer?

But all that being said, the ACC_ALL stuff is confusing for exactly
the reason you pointed out so it doesn't make sense to duplicate it
further. I agree it would make more sense to pass in bool exec.

>
> --
> Peter Xu
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BAD4E4605
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 19:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbiCVScG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 14:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239912AbiCVScD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 14:32:03 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAC390FDE
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:30:35 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id c15so25141237ljr.9
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0CNUQIx7db9tcPXPC9iqjrJoWI5B8XllhjqFE5N8sVg=;
        b=CF2Wkl42pAxFG3JegPzy0+/N/gpywxj733ZXOFng8/BIcG6njGR+YAz27HK7YLMvj9
         zFdMX8QKWmGj9CEYEZtyS8SpNQ4Mtndo7DHMJf3YeTeITeLH4DAFFiV4R3Rq5+9j1MSf
         i1dZwBk/3skV8dWO5LjqtEL+QB2F6rU3Gpf8GrAbcSjnfNBllAacDIuTnr9VWfbbybWF
         +YFtcLfSfvwrvRkkoUmCPF/Le7MHeh2uBzbt41SRv1S+WHTomhdlwsURFgIMwhpIVTig
         EbbgVuPNES+r8im5hJ1+nIuCQwBaowhiv3JT0WSWqhNY+UATI4uYOpIqu9cu9XxqPW/s
         I2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0CNUQIx7db9tcPXPC9iqjrJoWI5B8XllhjqFE5N8sVg=;
        b=A0s0I9v4WZhcj9aNTpXZx0ickdzkFDyPJ9927RNLKN3FnduGfqqt4FD6rnhR3YTGXm
         TnEgiGLIviMYVIbZ2JZ5yEjU8VNNnVi+VU2WNaqEHjrpv9WLxqRzCHsV7/Gp24vRdjm0
         tg+okrei5Ad2TxbSNBwqSZyLLHFdWxLohmVWhTx6QNM1sr4tm8vRrbbHbJSay7qkt4Jt
         s2Q4bMjWXOG8agrJ3Cp61auoiiJVIMFNprB/k09Aaaf0kxoa8tej/uFl4QlKFyoAaapV
         sP7TGU9j+y0lm2UEZCoxXgGe1aBoy2ro1u65z/ebg9DN/da2zc5MiuVJsVNVHL4lVYjJ
         RT5A==
X-Gm-Message-State: AOAM530Qx8uptFo9eC7YRZ2CvcjeCz9WAS7OgKKp3SN/3+qCDiubwmAv
        l8RxZuEqfV+gcj+nz6swqPAtLIltTiz653yV355LQw==
X-Google-Smtp-Source: ABdhPJyNKn6/OXQhxmGccGBHaz+yDflLiBEtNop/JRI2h4pzs1fJKVRhlCid5p3SD4A9PdS2WyGUl7n7vQSW1PqSoi4=
X-Received: by 2002:a2e:6804:0:b0:245:f269:618 with SMTP id
 c4-20020a2e6804000000b00245f2690618mr19192245lja.198.1647973833489; Tue, 22
 Mar 2022 11:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-4-dmatlack@google.com>
 <YjBLFZWtdfwhNosG@xz-m1.local>
In-Reply-To: <YjBLFZWtdfwhNosG@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 11:30:07 -0700
Message-ID: <CALzav=dAW999FKid08Ry0YxPA+3Dt8HERrbn6YMkAnk0h+4h_A@mail.gmail.com>
Subject: Re: [PATCH v2 03/26] KVM: x86/mmu: Derive shadow MMU page role from parent
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 1:15 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:05AM +0000, David Matlack wrote:
> > Instead of computing the shadow page role from scratch for every new
> > page, we can derive most of the information from the parent shadow page.
> > This avoids redundant calculations and reduces the number of parameters
> > to kvm_mmu_get_page().
> >
> > Preemptively split out the role calculation to a separate function for
> > use in a following commit.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Looks right..
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> Two more comments/questions below.
>
> > +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> > +{
> > +     struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> > +     union kvm_mmu_page_role role;
> > +
> > +     role = parent_sp->role;
> > +     role.level--;
> > +     role.access = access;
> > +     role.direct = direct;
> > +
> > +     /*
> > +      * If the guest has 4-byte PTEs then that means it's using 32-bit,
> > +      * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> > +      * directories, each mapping 1/4 of the guest's linear address space
> > +      * (1GiB). The shadow pages for those 4 page directories are
> > +      * pre-allocated and assigned a separate quadrant in their role.
> > +      *
> > +      * Since we are allocating a child shadow page and there are only 2
> > +      * levels, this must be a PG_LEVEL_4K shadow page. Here the quadrant
> > +      * will either be 0 or 1 because it maps 1/2 of the address space mapped
> > +      * by the guest's PG_LEVEL_4K page table (or 4MiB huge page) that it
> > +      * is shadowing. In this case, the quadrant can be derived by the index
> > +      * of the SPTE that points to the new child shadow page in the page
> > +      * directory (parent_sp). Specifically, every 2 SPTEs in parent_sp
> > +      * shadow one half of a guest's page table (or 4MiB huge page) so the
> > +      * quadrant is just the parity of the index of the SPTE.
> > +      */
> > +     if (role.has_4_byte_gpte) {
> > +             BUG_ON(role.level != PG_LEVEL_4K);
> > +             role.quadrant = (sptep - parent_sp->spt) % 2;
> > +     }
>
> This made me wonder whether role.quadrant can be dropped, because it seems
> it can be calculated out of the box with has_4_byte_gpte, level and spte
> offset.  I could have missed something, though..

I think you're right that we could compute it on-the-fly. But it'd be
non-trivial to remove since it's currently used to ensure the sp->role
and sp->gfn uniquely identifies each shadow page (e.g. when checking
for collisions in the mmu_page_hash).

>
> > +
> > +     return role;
> > +}
> > +
> > +static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
> > +                                              u64 *sptep, gfn_t gfn,
> > +                                              bool direct, u32 access)
> > +{
> > +     union kvm_mmu_page_role role;
> > +
> > +     role = kvm_mmu_child_role(sptep, direct, access);
> > +     return kvm_mmu_get_page(vcpu, gfn, role);
>
> Nit: it looks nicer to just drop the temp var?
>
>         return kvm_mmu_get_page(vcpu, gfn,
>                                 kvm_mmu_child_role(sptep, direct, access));

Yeah that's simpler. I just have an aversion to line wrapping :)

>
> Thanks,
>
> --
> Peter Xu
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022935206B4
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 23:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiEIVi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 17:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiEIViy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 17:38:54 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396E52C8189
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 14:34:55 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id bx33so7748466ljb.12
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 14:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tN7G2C4PQ3ma2oS8lsGwUMG2S6za5ikyX+q1/ZuZ/h0=;
        b=dnqffuw15iCZYQIzqr3eUW9WYZhCBFPccgCfdSUSeIwz2z5j/6sw6y5DSFHpwgaKwR
         YMoh/zK/zitW9WLxNfK2L4WV4dwQDsMck1fc8KCK3oEizhgnMZv6ZfQVIMhWhk0m7IkT
         k3NtwOMSCP/xsHIdEOMpAzD689LVJPO3xJYOtptqQY/9cupIecGTV/gkE3ZTFu7/HfUp
         wdYSHtOc6FHyUgZgVpawMDXejPCoB7XORrJ+zwveCOWDaVlt9aVx/qlwX7GGn2O0Q+uY
         W3zuml4Es+Jh8Bya8FiLAv/9ZQ9kN3abL7CZjJF1bib6+bZukU9329H+ux2av3qqrrr8
         lurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tN7G2C4PQ3ma2oS8lsGwUMG2S6za5ikyX+q1/ZuZ/h0=;
        b=QZjmarv2dwcsVPSntaIYGZMZsPLHCZ/EDsu5GYePF+fQNj1LNDdt82TMbas3zMxkpa
         AzfHltIrPPM9me5R6bLrfsoR8F5elOjj8lsLyFKNjBALYL60D48nk8KSC+ritW0G0lE1
         QJ1RoDgyYlL2tpGBXEk5k8htizuLLlg+P2FRZgmS+436Mh8xuGOqTE03U5u1SJp60vzA
         Nrf5q4y1iJwtIvXMhua8VjT35tuE7JfVbm8IJVZWFuv8IflCjXBKOd3SgjbOH1/ds2N4
         JYXO+/5PlmLpHxL/WL+manB8kTjsauAv3XtIpjVD1LEbeMpPXZeBakKK4bpXiyvVfgET
         xtPA==
X-Gm-Message-State: AOAM531He96+62bECJDLlNPepHYPMkQmvnMIi4zNXUKd6d4YnZssyH+F
        PriV36sb9agerQXX68aqzPGC8RVWdk13y58NTVPy/g==
X-Google-Smtp-Source: ABdhPJwYgZHhvdFXOAHhV8tAaZIlptVAnf4MbnvZxg6VsGD7IQ1/g5BzdRDRYZ/yR4ilZw5IP/itbOlJUXnAeeSZevc=
X-Received: by 2002:a05:651c:b24:b0:250:6414:c91a with SMTP id
 b36-20020a05651c0b2400b002506414c91amr11545842ljr.198.1652132093384; Mon, 09
 May 2022 14:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-18-dmatlack@google.com>
 <YnlB8n8UMCuaCj1G@google.com>
In-Reply-To: <YnlB8n8UMCuaCj1G@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 May 2022 14:34:27 -0700
Message-ID: <CALzav=fQoqet7-MnNvsJ-deJ7RxiuiH_bHMwAEHNuXJ1VGqg0Q@mail.gmail.com>
Subject: Re: [PATCH v4 17/20] KVM: x86/mmu: Zap collapsible SPTEs at all
 levels in the shadow MMU
To:     Sean Christopherson <seanjc@google.com>
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

On Mon, May 9, 2022 at 9:31 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Maybe a slight tweak to the shortlog?  "Zap collapsible SPTEs at all levels in
> the shadow MMU" left me wondering "when is KVM zapping at all levels?"
>
>   KVM: x86/mmu: Zap all possible levels in shadow MMU when collapsing SPTEs
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
> > in the rmap). This is fine for now KVM never creates intermediate huge
> > pages during dirty logging, i.e. a 1GiB page is never partially split to
> > a 2MiB page.
>
> "partially" is really confusing.  I think what you mean is that KVM can split a
> 1gb to a 2mb page, and not split all the way down to 4kb.  But "partially" makes
> it sound like KVM ends up with a huge SPTE that is half split or something.  I
> think you can just avoid that altogether and be more explicit:
>
>   i.e. a 1GiB pager is never split to just 2MiB, dirty logging always splits
>   down to 4KiB pages.
>
> > However, this will stop being true once the shadow MMU participates in
> > eager page splitting, which can in fact leave behind partially split
>
> "partially" again.  Maybe
>
>   which can in fact leave behind 2MiB pages after splitting 1GiB huge pages.

Looks good, I'll incorporate these edits into v5.

>
> > huge pages. In preparation for that change, change the shadow MMU to
> > iterate over all necessary levels when zapping collapsible SPTEs.
> >
> > No functional change intended.
> >
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ed65899d15a2..479c581e8a96 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6098,18 +6098,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >       return need_tlb_flush;
> >  }
> >
> > +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> > +                                        const struct kvm_memory_slot *slot)
> > +{
> > +     /*
> > +      * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> > +      * pages that are already mapped at the maximum possible level.
> > +      */
> > +     if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> > +                           PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> > +                           true))
> > +             kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +}
> > +
> >  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> >                                  const struct kvm_memory_slot *slot)
> >  {
> >       if (kvm_memslots_have_rmaps(kvm)) {
> >               write_lock(&kvm->mmu_lock);
> > -             /*
> > -              * Zap only 4k SPTEs since the legacy MMU only supports dirty
> > -              * logging at a 4k granularity and never creates collapsible
> > -              * 2m SPTEs during dirty logging.
> > -              */
> > -             if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
> > -                     kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +             kvm_rmap_zap_collapsible_sptes(kvm, slot);
> >               write_unlock(&kvm->mmu_lock);
> >       }
> >
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >

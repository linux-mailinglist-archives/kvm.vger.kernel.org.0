Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1AC5206A9
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 23:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiEIVeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 17:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiEIVeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 17:34:03 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FFB2C13C3
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 14:30:07 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id l19so18585544ljb.7
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 14:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MvwsQDLTKMJTgQOuZM3iVmxfL3yQn70yj6MptUuzyQ4=;
        b=KogQHf/McB9aIwAxL6BCyTJQgbxIayVYsDYOtKkeewIVQ3A710pUY39TcaMq8U+T88
         gv5ruaQ8w1yni6W7HlnAW1N5dHfHt1WakHv8tKw4thLTmjxF5UXYrTav0m+YNbRZNcVT
         +xVoGcPvGLNpEro0SP/zK6DkXhaiaFO9Y8/8D2b9GnaAOzzXtJ+VOxQ0//82acn4t0Vr
         EyNaOMSqCvxhgna4lq3UZ1jUYA59iu4tqGmRv5m5PnsaV+jRbOkS28/53sy/KiAk4Ce5
         91WjSvdmCd1bOkDfCR6jDhvHCuzTjEWGIYJ0Tf8aeQw5yq6MjnvQwk+dlbeoHl04Hrif
         5Wzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MvwsQDLTKMJTgQOuZM3iVmxfL3yQn70yj6MptUuzyQ4=;
        b=BL2pxPP9M4djy71iNvj8wOQFep8Kcp5cxkpMtWCqSHW/GD+VllVF7e1Lbdv5M99PG0
         b7e0l800aXT8l8oNwtUpc4w76jCJ/2za0Ld75MoDr4Af3E+OmCU/DhWaR32Kqmc/f8HV
         bQRvTJLUJGmFDlFKjFNvA8O/XlX3WNViYMX4NAU+/RK0GaFAjRibRdnFkMLUVVEjr86D
         tEflWwkl/fwWzWgf+rIxKHOUDd6BNuj1TuzFHS4fJ4Yop3yW36BOo4ZNWC6tTYU8m7dz
         d7mUi2lzKPcIv+F4jAidOiyQ6o0iutFDqS/wVxUVJc029GXPAX8LqNXdpDD32FNlhjqc
         y3kw==
X-Gm-Message-State: AOAM532MFBV6ps78tp1R5iTxwHcDgXwdLhdibk4cjnAd7RUfnELU0wLt
        ZvUgfdVT94AM1tlXlB34sk5vtI2c0y9zOkDjqng4Pw==
X-Google-Smtp-Source: ABdhPJx+6UQM4mLeHjKTgMzcIwGXK2jygDZun4KACvit/KIbJo02fyOw9JvUPx0VkZs/cp8bQ8Ty95f5uyusbVuZ7zI=
X-Received: by 2002:a2e:9e54:0:b0:250:d6c8:c2a6 with SMTP id
 g20-20020a2e9e54000000b00250d6c8c2a6mr830767ljk.16.1652131805713; Mon, 09 May
 2022 14:30:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-16-dmatlack@google.com>
 <Ynk84xydEn4/3xkT@google.com>
In-Reply-To: <Ynk84xydEn4/3xkT@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 May 2022 14:29:38 -0700
Message-ID: <CALzav=daCnHcUV7ffwvpMGcpdvV5vqHg0JD7Wfs-F6jfaJnfSA@mail.gmail.com>
Subject: Re: [PATCH v4 15/20] KVM: x86/mmu: Cache the access bits of shadowed translations
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

On Mon, May 9, 2022 at 9:10 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > @@ -2820,7 +2861,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> >
> >       if (!was_rmapped) {
> >               WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
> > -             rmap_add(vcpu, slot, sptep, gfn);
> > +             rmap_add(vcpu, slot, sptep, gfn, pte_access);
> > +     } else {
> > +             /* Already rmapped but the pte_access bits may have changed. */
> > +             kvm_mmu_page_set_access(sp, sptep - sp->spt, pte_access);
> >       }
> >
> >       return ret;
>
> ...
>
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index a8a755e1561d..97bf53b29b88 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -978,7 +978,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >  }
> >
> >  /*
> > - * Using the cached information from sp->gfns is safe because:
> > + * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn()
> > + * and kvm_mmu_page_get_access()) is safe because:
> >   * - The spte has a reference to the struct page, so the pfn for a given gfn
> >   *   can't change unless all sptes pointing to it are nuked first.
> >   *
> > @@ -1052,12 +1053,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> >               if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
> >                       continue;
> >
> > -             if (gfn != sp->gfns[i]) {
> > +             if (gfn != kvm_mmu_page_get_gfn(sp, i)) {
> >                       drop_spte(vcpu->kvm, &sp->spt[i]);
> >                       flush = true;
> >                       continue;
> >               }
> >
> > +             if (pte_access != kvm_mmu_page_get_access(sp, i))
>
> I think it makes sense to do this unconditionally, same as mmu_set_spte().  Or
> make the mmu_set_spte() case conditional.  I don't have a strong preference either
> way, but the two callers should be consistent with each other.

I'll make them both unconditional.

>
> > +                     kvm_mmu_page_set_access(sp, i, pte_access);
> > +
> >               sptep = &sp->spt[i];
> >               spte = *sptep;
> >               host_writable = spte & shadow_host_writable_mask;
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >

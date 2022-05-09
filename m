Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225375206A7
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 23:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiEIVcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 17:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiEIVcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 17:32:09 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EFA285AC3
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 14:28:13 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id d15so17540559lfk.5
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 14:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lLXDpS9aIKv2BOfm7qGe20v7/h2Jmvrj+hyHCut5ohw=;
        b=oyNullodeqUuuE421QfGbnwxO+DFaD2869iT7IedC61l5rZttPc/rSSzE78vqgW1qc
         /yDSeSm/xObDW0SQYPjuLw/oabxydsD1u1pqk6iDs+C4RePn/EBKPD26MXSn/Bqau+vE
         0vOQ0geMRnQRwNm4gtwQvXfhzE5wxzP2IR9rDPAfNyK+lM2iV9Bq1y9YKNHQPxElg7dK
         HLSVmL0ZsXbI6xxQJD5n9kbgUSl73kAzVVOPO5r4rxxie5OCXNJsiaS4Mk11+iplA7nS
         pCdRT/tZG9CzS1KAbQLLw6d11fWTcP/PbyYKjlJt8m4+EMQMD/pL6baQwgIfp/nZSGYH
         OVEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lLXDpS9aIKv2BOfm7qGe20v7/h2Jmvrj+hyHCut5ohw=;
        b=T7WaqW2WSOljJux2Og07RkgvDj466t+vRgAHdlcfJQLBcOelE3L2rNTSF1CfKkRQda
         vgRVrsMu7MSVdXPMxxGlB1+YswZrMAa75Py3xC21PepmVbj8LDDcNOrrhqpXiYlE1VgT
         QssVPGHZOcW5I6+maBY6/um9qgfzycvmwAQt/FZeSQnV+TZ8c58L4yJqRKaKztH8vovq
         j9UPxIBZ3MEU4hSnOWGnWWT1rIqmZVX7nqZ3mlVGq9fTwb0xAeABOH7ISLdqZ5u5TdMk
         B/pGjc4obgmbb2+V+gLP90FdCfF5QkzDKliPNreg5HQP67cndhjB6lqQSwHfHiyKTAa6
         Ebgw==
X-Gm-Message-State: AOAM530ZfcIj9RwXZBKcq4zwXIVljQWyvEkiySRz3Z5iyGEtznOgWrOl
        ubwiVuSsN/CHx53SrdekzVjnbcq0xFREoyqLB0mpcA==
X-Google-Smtp-Source: ABdhPJw+OcXl75VxXUJHRSc/tzKR8oEQPG36TfGqgX3Q27P6+ehDBJMpPmSmVmU2xY3hI4g12NO5ncUZ1l7YDKxM7wo=
X-Received: by 2002:ac2:4c54:0:b0:473:a414:1768 with SMTP id
 o20-20020ac24c54000000b00473a4141768mr13960522lfk.537.1652131692052; Mon, 09
 May 2022 14:28:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-14-dmatlack@google.com>
 <YnRh6yyGQZ+U31U1@google.com>
In-Reply-To: <YnRh6yyGQZ+U31U1@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 May 2022 14:27:45 -0700
Message-ID: <CALzav=fSx2VdaLD=pz_wmESCSA8M0n1omLsy9UwSw1GHED7vgQ@mail.gmail.com>
Subject: Re: [PATCH v4 13/20] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 4:46 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > -static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
> > -                          struct kvm_mmu_page *sp)
> > +static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
> > +                            struct kvm_mmu_page *sp)
> >  {
> >       u64 spte;
> >
> > @@ -2297,12 +2300,17 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
> >
> >       mmu_spte_set(sptep, spte);
> >
> > -     mmu_page_add_parent_pte(vcpu, sp, sptep);
> > +     mmu_page_add_parent_pte(cache, sp, sptep);
> >
> >       if (sp->unsync_children || sp->unsync)
> >               mark_unsync(sptep);
> >  }
> >
> > +static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep, struct kvm_mmu_page *sp)
>
> Nit, would prefer to wrap here, especially since __link_shadow_page() wraps.

Will do.

>
> > +{
> > +     __link_shadow_page(&vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
> > +}
> > +
> >  static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >                                  unsigned direct_access)
> >  {
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >

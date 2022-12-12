Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00EA64AA45
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 23:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbiLLWal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 17:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbiLLWai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 17:30:38 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1867E1AF24
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 14:30:35 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id g1so953050pfk.2
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 14:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wDIyaaZP6Sx38V8+GZMMaiCN2LYY75lyx3Qk2zggJjY=;
        b=AsH0HY9ES//YrqC7aVzHEC/CizcXUu59joNA74umGoNmkMvxLqS0wCffNxDluDxyKo
         EAqtkusIPRaWsTDrdjn9/llFRUygCmGbtm2vECAI+G08t237WcwWOvji02G3iAivLRkK
         XtmAOzz+XqYsq2GDP6d9iwh7sTltvZI9fxPTUGYZWGyPiUekYEmb0NyP6jBH0aSpM1QX
         0tz4LyerHFPtS+ochp41KGvy5c0kQvu3ZBbrMJ4Y8A8WkC/7Ukk+1JDMNDpCdZbv+wUw
         sB78NjP1UXJBhqkf6gNp2CwQYVDksQEYfo+cDNGLFgrv7+7q0LQlQIxLu11hgJt4KH7o
         881Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wDIyaaZP6Sx38V8+GZMMaiCN2LYY75lyx3Qk2zggJjY=;
        b=mdG58YAYeN4c8MBhDrr6EKL8WT1xUxQH62L+f3weH92veH4ItQNhiMBPxnxOQejjdC
         7j4Yd4cIXfBf3kL6+vbchk/l68w/h2leIthaUix3cP1cPtZ+z/we3uNxRV1LCmBcHECh
         SCnXrgNfQR8hLiVvmKuPE2TFISjIBrg0kdTp8BhDE9Jj0IDgnyyGMRnFBKHheL8eju3J
         IJN5kPFX16DxVKKpld5use6D2jxJjKBrwFjyO7AdQsbbizzyL5/fHsJ+QdJOLN8YOT1e
         hFKT1BV9VsL9ya3oNOK/mBTbbTWH9QyXAe9hFcBeM8j+Ytal7smOhcIiqijAuXlSvvIz
         b3HA==
X-Gm-Message-State: ANoB5pnzlltt3Zc7ri4pmJ4ZKrCPqn/fIGT5Onc9X2n2QfJm1LItzxX6
        csutNN0h3dHe+7z17xQPb1a6Vw==
X-Google-Smtp-Source: AA0mqf74FM6U4ztV3LqdnGXHnnnSC43RbbAIDoSZcE8bsILwNcSluJ+18YStm6rGNZYFVpgbA3RNLg==
X-Received: by 2002:aa7:9a1c:0:b0:574:3e1d:72dd with SMTP id w28-20020aa79a1c000000b005743e1d72ddmr18119342pfj.19.1670884234340;
        Mon, 12 Dec 2022 14:30:34 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0056d98e31439sm6499921pfn.140.2022.12.12.14.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 14:30:33 -0800 (PST)
Date:   Mon, 12 Dec 2022 14:30:28 -0800
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Subject: Re: [RFC PATCH 10/37] KVM: MMU: Move struct kvm_page_fault to common
 code
Message-ID: <Y5erhA1QOBhqnO5C@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-11-dmatlack@google.com>
 <CANgfPd-DaxszBe6vLQGe=LKNKx8bDX-AC_30qLVAyYkQXwN7WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-DaxszBe6vLQGe=LKNKx8bDX-AC_30qLVAyYkQXwN7WA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 10:24:31AM -0800, Ben Gardon wrote:
> On Thu, Dec 8, 2022 at 11:39 AM David Matlack <dmatlack@google.com> wrote:
> >
> > Move struct kvm_page_fault to common code. This will be used in a future
> > commit to move the TDP MMU to common code.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
[...]
> > diff --git a/include/kvm/mmu_types.h b/include/kvm/mmu_types.h
> > index a9da33d4baa8..9f0ca920bf68 100644
> > --- a/include/kvm/mmu_types.h
> > +++ b/include/kvm/mmu_types.h
> > @@ -66,4 +66,48 @@ struct kvm_mmu_page {
> >         struct kvm_mmu_page_arch arch;
> >  };
> >
> > +struct kvm_page_fault {
> > +       /* The raw faulting address. */
> > +       const gpa_t addr;
> > +
> > +       /* Whether the fault was synthesized to prefetch a mapping. */
> > +       const bool prefetch;
> > +
> > +       /* Information about the cause of the fault. */
> > +       const bool write;
> > +       const bool exec;
> > +
> > +       /* Shifted addr, or result of guest page table walk if shadow paging. */
> > +       gfn_t gfn;
> 
> Is this redundant to have in common code? If we're not doing common
> shadow paging, then this is just addr shifted. Would this be better
> placed in the arch specific struct?

Yes it's redundant but it is actually used by the TDP MMU, unlike @addr.
So if anything I would rather move @addr to kvm_page_fault_arch.

> 
> > +
> > +       /* The memslot that contains @gfn. May be NULL. */
> > +       struct kvm_memory_slot *slot;
> > +
> > +       /* Maximum page size that can be created for this fault. */
> > +       u8 max_level;
> > +
> > +       /*
> > +        * Page size that can be created based on the max_level and the page
> > +        * size used by the host mapping.
> > +        */
> > +       u8 req_level;
> > +
> > +       /* Final page size that will be created. */
> > +       u8 goal_level;
> > +
> > +       /*
> > +        * The value of kvm->mmu_invalidate_seq before fetching the host
> > +        * mapping. Used to verify that the host mapping has not changed
> > +        * after grabbing the MMU lock.
> > +        */
> > +       unsigned long mmu_seq;
> 
> Should this be ifdef'ed with  KVM_ARCH_WANT_MMU_NOTIFIER?

I'll have to take a closer look, but probably yes.

> 
> > +
> > +       /* Information about the host mapping. */
> > +       kvm_pfn_t pfn;
> > +       hva_t hva;
> > +       bool map_writable;
> > +
> > +       struct kvm_page_fault_arch arch;
> > +};
> > +
> >  #endif /* !__KVM_MMU_TYPES_H */
> > --
> > 2.39.0.rc1.256.g54fd8350bd-goog
> >

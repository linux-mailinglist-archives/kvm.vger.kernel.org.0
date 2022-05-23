Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34967531B97
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242489AbiEWRto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 13:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242510AbiEWRsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 13:48:46 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294DBAEE19
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:37:25 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id a23-20020a17090acb9700b001df4e9f4870so14379653pju.1
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uPvB4xKkZsbv/NQuw+LVF1ZeOmndZIablC0q46ZFciY=;
        b=XvH+fP7b6A7IaMFFBQF7IkZCZBYDCe5tYb80MfrbM2f0FYzFokK+x6mgbkPTeOgoUg
         LclNFKJEWXiNeIZWkIZLNbNNePqmTZSw88j10EPFP/TCd88RX+QFgo+8KXnJ7ZFWEqw8
         e258spbjBdsYFehtuKv0B7wbQEdEuoZG2QfXIkOIkFlhdL9EvniL6ve+PR8g87Ue1Ipd
         qlKgwGG9OiDFl7+72jz8mhlBqYjKbIOUmNWAcLmyrAe5QY5hfjJUdhA+UHLy5+ZIOXNQ
         y5rtJrUIwrCDHAi+YfCoOzCaRCeBurqBgL7bm+aoHAkTBJ7vzfBVMAs7LZYNqcNRbsWw
         xF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uPvB4xKkZsbv/NQuw+LVF1ZeOmndZIablC0q46ZFciY=;
        b=BPDpAZCoW81iuMBDhGxVUfkUGE5coB7Pu/UrLQuabjU79ZbRPYg7z8hd37aMLDSWPq
         AJnfnzV2pncjXB89/vu050ms4MowIJaJ7psat1DgiMVVhwhfx0lW2z2EO+KIameew04/
         iRfVwjb2XaXBywpkKyuXBWbd/yLLwhITkZadG/D/0HkZa9Kjmpmitu6yo7BjntEj9ObI
         1353BWMbbliFX2fqdO3O2y+WXY6lfxfCkLHDgwZy1yZ3moHD9ai7xfKIeonz5shSFmyi
         X/POSb8Z74mzuKzZLaCPrg6BBVwDUXKPLa33kP3itV8V8jyDONOLDIdIrNmUQlQh1HIk
         uEvQ==
X-Gm-Message-State: AOAM533DpcOmfrZnFn08eFi8cnK+yBB/9oKVU6wMicQLnk6AXhqA0wcd
        HAFIrOlEik0GtAQ5MVHCyBWmHw==
X-Google-Smtp-Source: ABdhPJw4AGNGxsFqbqwZIS+BFk/8egtH9UXiumvmBRxLQ0/47sCH59HMfF1NiH7idboGwFW37lheDQ==
X-Received: by 2002:a17:90b:4b90:b0:1e0:1b0:1a1 with SMTP id lr16-20020a17090b4b9000b001e001b001a1mr146255pjb.70.1653327444125;
        Mon, 23 May 2022 10:37:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902da8d00b0015e8d4eb260sm5388000plx.170.2022.05.23.10.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 10:37:23 -0700 (PDT)
Date:   Mon, 23 May 2022 17:37:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <YovGUDrYZMZ7PXeY@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
 <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
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

On Fri, May 20, 2022, Mingwei Zhang wrote:
> On Mon, May 16, 2022 at 4:24 PM David Matlack <dmatlack@google.com> wrote:
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index e089db822c12..5e2e75014256 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -369,14 +369,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> >                 return (void *)__get_free_page(gfp_flags);
> >  }
> >
> > -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> >  {
> > +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
> >         void *obj;
> >
> >         if (mc->nobjs >= min)
> >                 return 0;
> > -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > +
> > +       if (unlikely(!mc->objects)) {
> > +               if (WARN_ON_ONCE(!capacity))
> > +                       return -EIO;
> > +
> > +               mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> > +               if (!mc->objects)
> > +                       return -ENOMEM;
> > +
> > +               mc->capacity = capacity;
> 
> Do we want to ensure the minimum value of the capacity? I think
> otherwise, we may more likely start using memory from GFP_ATOMIC if
> the capacity is less than, say 5? But the minimum value seems related
> to each cache type.

Eh, if we specify a minimum, just make the arch default the minimum.  That way we
avoid adding even more magic/arbitrary numbers.  E.g. for whatever reason, MIPS's
default is '4'.

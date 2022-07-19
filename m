Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E181257A158
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbiGSOY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237308AbiGSOYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:24:43 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2432E5464F
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:09:13 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id oy13so27354136ejb.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wop+H3MjB/5C9Ewbg3QxJp56HQLPnXIoMhIZnojQMEA=;
        b=P1YDBjnYh+1NRqEJ8i+WcfhDk7k0rVUu6Hd0mxClejxYWQzPVk/yzMn/Ymw+aS4kQM
         CJ42DyTuxyr4dw066TJyCFOsHv32M0w6p1pv+k9id/d3UKaySmszftqyQNAxCd2oziQe
         d2LTW392A2MO7qDx1Z5f+405JAkTAnXAk7ZAf2mz8XRDBP/y9uFQfHxQrLDnzP13a0i3
         DgY7544+N7h1pgdylXJopKKtkxaT8VDSYAHs9RsMSkzk/OgIenT1e2d6+FER7ysoI8zt
         6gkL54/ejURz42wWmx5wi9AeYVikA+ApZnchKJyze4LncMAXyRa98s6pBBaJDKJW3fRr
         zTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wop+H3MjB/5C9Ewbg3QxJp56HQLPnXIoMhIZnojQMEA=;
        b=1qJqaLTwWxZUKElwYawVkF/k2jQeHu/DNpxjT2ZOz0sDP34XGDekJ09m5+KkPyR/Ae
         u+JAKXCq4XD/DQYBakNDavRMoUufRXJe3vRd+1rJr5gDrysd4P6D34bp02lvjmj1m+2k
         antiBFa47NvaosFnOG6XBOr5TZdm1q7pbq3I0xgmMETXgSysz8aEnqfiOLUdVfWk2Qqz
         lmrwW02WfUcmSEyX8WPATPVHhMTrLPGqic0l7fDlnx1maWM8NxU0R2+bF/LsMPul1c3w
         f0D7fZ9VuOvosA1FlPHhSI/n6Yo/4BhoSM1RWulLnQR/NH392G8lMdnGJlFRmiML93NL
         V4zw==
X-Gm-Message-State: AJIora87dN5E5/AXDFeC8zvirqno5UhspTWdEjuKwcaGlrZxG4lwY1QI
        MJv4R4f3LrtkKn+8tfF0moWcjyvZ8R0cQ98vqYM2kQ==
X-Google-Smtp-Source: AGRyM1v4ah4+gXWYXcIXC8MgUfU+3eRgMMiQLvXxA7uAPfRkHkXhTADlxpW7PgeAZqEJ6DX2zQRsaGMAI78ydGtBtwM=
X-Received: by 2002:a17:907:60c6:b0:72f:4645:ead3 with SMTP id
 hv6-20020a17090760c600b0072f4645ead3mr6113608ejc.321.1658239751317; Tue, 19
 Jul 2022 07:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220630135747.26983-1-will@kernel.org> <20220630135747.26983-15-will@kernel.org>
 <Ytax6L2BUt5ON1Dp@google.com>
In-Reply-To: <Ytax6L2BUt5ON1Dp@google.com>
From:   Quentin Perret <qperret@google.com>
Date:   Tue, 19 Jul 2022 16:09:00 +0200
Message-ID: <CAPwzONn3oNqKo+OMJiF1+Bx0JRiKhHnMOjbkSCwTeHoT5pAyWg@mail.gmail.com>
Subject: Re: [PATCH v2 14/24] KVM: arm64: Add pcpu fixmap infrastructure at EL2
To:     Vincent Donnefort <vdonnefort@google.com>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 19, 2022 at 3:30 PM Vincent Donnefort <vdonnefort@google.com> wrote:
>
> >  static struct hyp_pool host_s2_pool;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > index d3a3b47181de..17d689483ec4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > @@ -14,6 +14,7 @@
> >  #include <nvhe/early_alloc.h>
> >  #include <nvhe/gfp.h>
> >  #include <nvhe/memory.h>
> > +#include <nvhe/mem_protect.h>
> >  #include <nvhe/mm.h>
> >  #include <nvhe/spinlock.h>
> >
> > @@ -24,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
> >  unsigned int hyp_memblock_nr;
> >
> >  static u64 __io_map_base;
> > +static DEFINE_PER_CPU(void *, hyp_fixmap_base);
> >
> >  static int __pkvm_create_mappings(unsigned long start, unsigned long size,
> >                                 unsigned long phys, enum kvm_pgtable_prot prot)
> > @@ -212,6 +214,76 @@ int hyp_map_vectors(void)
> >       return 0;
> >  }
> >
> > +void *hyp_fixmap_map(phys_addr_t phys)
> > +{
> > +     void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> > +     int ret = kvm_pgtable_hyp_map(&pkvm_pgtable, (u64)addr, PAGE_SIZE,
> > +                                   phys, PAGE_HYP);
> > +     return ret ? NULL : addr;
> > +}
> > +
> > +int hyp_fixmap_unmap(void)
> > +{
> > +     void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> > +     int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)addr, PAGE_SIZE);
> > +
> > +     return (ret != PAGE_SIZE) ? -EINVAL : 0;
> > +}
> > +
>
> I probably missed something but as the pagetable pages for this mapping are
> pined, it seems impossible (currently) for this call to fail. Maybe a WARN_ON
> would be more appropriate, especially the callers in the subsequent patches do
> not seem to check for this function return value?

Right, I think that wouldn't hurt. And while looking at this, I
actually think we could get rid of these calls to the map/unmap
functions entirely by keeping the pointers to the reserved PTEs
directly in addition to the VA to which they correspond in the percpu
table. That way we could manipulate the PTEs directly and avoid
unnecessary pgtable walks. Bits [63:1] can probably remain untouched,
and {un}mapping is then only a matter of flipping bit 0 in the PTE
(and TLBI on the unmap path). I'll have a go at it.

Cheers,
Quentin

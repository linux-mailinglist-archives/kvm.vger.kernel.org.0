Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEEF528C64
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 19:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiEPRx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 13:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiEPRx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 13:53:28 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE9837BC6
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 10:53:27 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id p8so14692481pfh.8
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 10:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xLnsVtH4IZZzftneP0mNRPOYa6ozJDfyL03w/I93FrE=;
        b=UmOjKYmNbbv2ZgPZOnanqKT3eODwwjPFhlGVD2Fl62+7VYXsBsL1kDTCNFsAnfIiif
         74EPi85SE0XeXotOMQ65be7GEzHKtmvZ7ZPf8eo4nZIO+U4QdY3O06aFDL2hGu8GVB/b
         hnwgkIJ2mp0Ex0P7BTkkgqFihDJ30MSFa5iuz+szd+++x0Fq8A/754L0B3EVRcQzfekw
         d0zMtehFrx7JiV/53hZXtrQq3nB0aMD/W5OjbzWzcYAL6vUfR7PIxpgiBY2x3CKdqXFv
         OithX7c4YgzfHCZySNbi9o33X1iIDUA0Y/IuLsXiRFGOYzWpjjgpmDnDTr7LY8ttlTvs
         rUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xLnsVtH4IZZzftneP0mNRPOYa6ozJDfyL03w/I93FrE=;
        b=6sa/SyI3NxzmwwZFE/W2DZCjTRwKTAUbED9H4HCRxaN3qD+XwmG8mjqihcdzml0BVe
         NjZvCFhrPzo8W1GWF30ui5r/ZQ9wbaNCK/gCEdCOcYYlDrtOvUpzq49nyM7+3biqTlc+
         qJoRcgWKO/Pm1DbeunEMmHC+71zOGZNuZVJrluA4muNgaHUhHlgPgAzLV+FVx80yxIYO
         slWGSW3iYZnqM8/8FbQX4IkOQU+djIUrfQkL1dQcYrHyAQJ2DPzPI21+0prZPAdzyYWd
         Z2cRrxb4UnD04Z324MXWq1vlksr1rV5ywMfpTPMWn9pBzQjpc4T5hltkETm7dZzTc7DP
         Bwqg==
X-Gm-Message-State: AOAM533dL351iE4dkgDCcPw3OwM/xQUBY7Hgzij/FOXdAPlllrj5v1YK
        7yMSCAPqOhc0aUdvpLz+gL1XsA==
X-Google-Smtp-Source: ABdhPJz+yvMx9liLrlz0QvwDhwSjd9tJARB/+WSjj0oadYZP/ffLyfTHTcZm4wo51GQdKL9Zfl9FbQ==
X-Received: by 2002:a62:1613:0:b0:510:82a9:e3bf with SMTP id 19-20020a621613000000b0051082a9e3bfmr18551283pfw.23.1652723607193;
        Mon, 16 May 2022 10:53:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h3-20020a170902b94300b0016178a7375csm2727975pls.197.2022.05.16.10.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 10:53:26 -0700 (PDT)
Date:   Mon, 16 May 2022 17:53:23 +0000
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
Subject: Re: [PATCH v5 20/21] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <YoKPk0HBl/7rXmNS@google.com>
References: <20220513202819.829591-1-dmatlack@google.com>
 <20220513202819.829591-21-dmatlack@google.com>
 <YoJkb7oMEz0v1dnp@google.com>
 <CALzav=d-O5KWDC356cdpoJAUvKSSNOMtn_n7G6Yc342-VQFJNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=d-O5KWDC356cdpoJAUvKSSNOMtn_n7G6Yc342-VQFJNQ@mail.gmail.com>
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

On Mon, May 16, 2022, David Matlack wrote:
> On Mon, May 16, 2022 at 7:49 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, May 13, 2022, David Matlack wrote:
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 53ae2c0640bc..2f2ef6b60ff4 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -764,7 +764,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> > >  {
> > >       phys_addr_t addr;
> > >       int ret = 0;
> > > -     struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> > > +     struct kvm_mmu_memory_cache cache = {
> > > +             .capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> > > +             .gfp_zero = __GFP_ZERO,
> >
> > I dislike requiring all users to specificy the capacity.  It largely defeats the
> > purpose of KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, and bleeds details into code that
> > really doesn't care all that much about the details.
> >
> > Rather than force the capacity to be set before topup, what about adding a custom
> > capacity topup helper?  That allows keeping a default capacity, better documents
> > the caches that are special, and provides an opportunity to sanity check that the
> > capacity isn't incorrectly changed by the user.
> 
> Even simpler: If mc->capacity is 0 in topup, set it to
> KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE.

I slightly prefer the explicit "custom" approach as it guards against topup being
called before the capacity is initialized, and against the capacity being changed
after the first topup call.  It's a somewhat contrived reason since we obviously
rely on gfp_zero to be initialized before topup, but I like being more explicit
nonetheless.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F404DE290
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 21:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240583AbiCRUej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 16:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbiCRUef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 16:34:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C0B2ECFB5
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:33:15 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so6794546pjb.4
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zNTmz5JVOVEGqxQfmkKH5ofnXJ8F9rxSfSnMnrjnpm4=;
        b=sDKjHCF2YiI5RwzthUN4Q7iTrVDi6S27oXMB5v1GCnRgY4pF3/LESD7rdMsfp+HoMJ
         GcgJtKyNHn10/X0NoKBpytT+QFyjWhf+BayR5vL6RUrXog/5/yo3l4VkZcFzbyU32Guc
         i6BepxBRjypw0vzPAAGj/rzm7VBEYYKCRAyqPUNw9UsLK6pFvIp/AschAojYD7ZCeIon
         Tby9YcnCwg+B/BKGcTK2yT2aNqWkGJWSmDGzksKoTeDyk8CKEQFFvoIxpkQp6F5x+v7E
         2vWyg+PgbTQtHl2PLOl3rjXgJAxttPyoL6Ka5r17rOwTE7vqatCKXzidY9tM7PFNRHJU
         93/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zNTmz5JVOVEGqxQfmkKH5ofnXJ8F9rxSfSnMnrjnpm4=;
        b=p9IrNk2GyFfHmBpCfk2V3zpXrPyBSIe7RpmvoISUmtuDLThyzoLb55mL0MQ8I6Rmak
         yYr0J5pC7WE/o+uYgmSzF1wNs8RUrmeYs96AaLzDyH4yRZHFokaAD9bbHD1DrT6LidAG
         TwddF6R0UuHhxUu0Ni8SUR6ewm7pC/zp82l5Ee5qdrQ4t4pd3IXx6EFf5YlAmloz9lIT
         M4r5gt6/GHlejXUgVnOzJ6GpYvaZzI6YYCp402FRQzVQ+RXmP8rI4IhrHpXNrNkyawWh
         T5SuhF3AogguNoGc2UbivTY32E6blnYVippJsNqoZaobPNiDoUjyTMLgzO9V4ZQS/3+A
         xZ+Q==
X-Gm-Message-State: AOAM5329uxWv82uq0uEWfKIwycBN0Khb6/cBir9suW5qlV2NHBl7uo6S
        bsT0mEP6kh4v7Mrctz8/iPootA==
X-Google-Smtp-Source: ABdhPJxtJX0OLWnA5Jkz12Gg7fL+PabeAp7W7uiK4hS5tDluCNTLaEa1So9I9jDCC1UmOFv4zjOA5w==
X-Received: by 2002:a17:90a:19d5:b0:1bc:a5db:b655 with SMTP id 21-20020a17090a19d500b001bca5dbb655mr23906080pjj.46.1647635594843;
        Fri, 18 Mar 2022 13:33:14 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090acd0500b001b9c05b075dsm12829958pju.44.2022.03.18.13.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:33:14 -0700 (PDT)
Date:   Fri, 18 Mar 2022 13:33:10 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH 04/11] KVM: selftests: Add vm_alloc_page_table_in_memslot
 library function
Message-ID: <YjTshgT6ByCPEubc@google.com>
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-5-ricarkol@google.com>
 <CANgfPd8u_K3cOpaUPY8+rU+4RFehj8J61gdzuDyOZv4dSDZ+xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8u_K3cOpaUPY8+rU+4RFehj8J61gdzuDyOZv4dSDZ+xQ@mail.gmail.com>
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

On Wed, Mar 16, 2022 at 12:07:21PM -0600, Ben Gardon wrote:
> On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a library function to allocate a page-table physical page in a
> > particular memslot.  The default behavior is to create new page-table
> > pages in memslot 0.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> 
> This is very similar to one of the patches in the NX hugepages control
> series I sent out last week, I guess we both had similar needs at the
> same time.
> Your solution introduces way less churn though, so it's probably
> better. I might use this commit or wait for it to be merged before I
> send out v2 of my NX control series.

Both options sound good to me. I'm glad it helps.

> 
> In any case,
> Reviewed-by: Ben Gardon <bgardon@google.com>
> 
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index d6acec0858c0..c8dce12a9a52 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -307,6 +307,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
> >  vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> >                               vm_paddr_t paddr_min, uint32_t memslot);
> >  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> > +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
> >
> >  /*
> >   * Create a VM with reasonable defaults
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 64ef245b73de..ae21564241c8 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2409,9 +2409,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
> >  /* Arbitrary minimum physical address used for virtual translation tables. */
> >  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
> >
> > +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
> > +{
> > +       return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> > +                       pt_memslot);
> > +}
> > +
> >  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
> >  {
> > -       return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> > +       return vm_alloc_page_table_in_memslot(vm, 0);
> >  }
> >
> >  /*
> > --
> > 2.35.1.723.g4982287a31-goog
> >

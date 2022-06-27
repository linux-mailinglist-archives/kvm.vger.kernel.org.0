Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1708655D2E8
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242738AbiF0WuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 18:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238642AbiF0WuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 18:50:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9DE215
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 15:50:15 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so10801017pjj.5
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 15:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7zL1TDH7VwdCezBjRhOqzaqCe5lZyZMVmoHZOpV7Cmc=;
        b=rjsO5C+1IaaqQBLfXoCoFrmOyck8dX2dTqxLBdeqWhMf6pZwohC2qEoU+sGdPQYPOU
         6ckWujrZfUQA/i+KZo0h2vJoT542bIuoWPJ23sq1o36v95oMhFqVo9ByAi+NJJAV+CuG
         D0Fxs9AZzNrnOv/09svdFX6Qcvpmikum6Qs+O/rQUN6zwOpEKnnzzc4MZkjtvki5n+Ih
         R5v9j4QYvMShcbo25jEP8FyRi2BPlDRNT8tUduIcsvyq/CkuqwEhFCtAggA/HPHy/IqS
         dfarLqF+XEMplrRuMMuiIZrOQFCPgm0R45oR0iyheZoj17R21nCZwhkLjHZgK2Y0LO7l
         Ry+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7zL1TDH7VwdCezBjRhOqzaqCe5lZyZMVmoHZOpV7Cmc=;
        b=Az1ZbBNQ18Rx0r6xgdKEaOjqnFHhcgY5HJV0aNg8PI0cw7LcdYpay7uDnakbwFDZno
         9Gu0aHeVJQTC/7YC2IhaWUm1PN9iXeiRx7+6X64/Iypxsgd9C3iidEyFBHIwbIar2YmF
         sje8ar+BGOCxiFQVDQL7Kz08AiM2xpE7WkmtUgK9FIROp1p4KuB3vBgJ/VygqtBYuBix
         +tBKxV4biv66eeSrlys7Gt8Yp7d2Wzbg5QjVq2m2Og5Re+ZBrzvQYjRjTV91Rh2cPUdD
         GXQP/luzhE6w7DrIM2FqNjPDyAXU0LVcHg+jBH5SiZT4988WWyrIlzMbkZmSW2cD5h+t
         15fA==
X-Gm-Message-State: AJIora8w/66F+qU3K1vf0qis8AvpQTgSEWOiSzCOCmP5bqdya836RduT
        eLoC6U1dyItUnP4bvbuzg7fUWw==
X-Google-Smtp-Source: AGRyM1v7GwvY6TMVeVDPpjNkA9kdGiDqeLa/4d3Ii2q3zIWwqkoFPNlHyt9SZUIQC0YyqvclYoEocg==
X-Received: by 2002:a17:902:cec9:b0:16a:644a:6019 with SMTP id d9-20020a170902cec900b0016a644a6019mr461279plg.82.1656370214406;
        Mon, 27 Jun 2022 15:50:14 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902714400b0015e8d4eb28fsm7780728plm.217.2022.06.27.15.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 15:50:13 -0700 (PDT)
Date:   Mon, 27 Jun 2022 22:50:09 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Defer "full" MMU setup until after
 vendor hardware_setup()
Message-ID: <Yro0Idtt7hKMqb75@google.com>
References: <20220624232735.3090056-1-seanjc@google.com>
 <20220624232735.3090056-3-seanjc@google.com>
 <YrZTxZm4kq0rXcKQ@google.com>
 <YrnPgZvgWDpb6+R1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrnPgZvgWDpb6+R1@google.com>
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

On Mon, Jun 27, 2022 at 03:40:49PM +0000, Sean Christopherson wrote:
> On Sat, Jun 25, 2022, David Matlack wrote:
> > On Fri, Jun 24, 2022 at 11:27:33PM +0000, Sean Christopherson wrote:
> > > Alternatively, the setup could be done in kvm_configure_mmu(), but that
> > > would require vendor code to call e.g. kvm_unconfigure_mmu() in teardown
> > > and error paths, i.e. doesn't actually save code and is arguably uglier.
> > [...]
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 17ac30b9e22c..ceb81e04aea3 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -6673,10 +6673,8 @@ void kvm_mmu_x86_module_init(void)
> > >   * loaded as many of the masks/values may be modified by VMX or SVM, i.e. need
> > >   * to be reset when a potentially different vendor module is loaded.
> > >   */
> > > -int kvm_mmu_vendor_module_init(void)
> > > +void kvm_mmu_vendor_module_init(void)
> > >  {
> > > -	int ret = -ENOMEM;
> > > -
> > >  	/*
> > >  	 * MMU roles use union aliasing which is, generally speaking, an
> > >  	 * undefined behavior. However, we supposedly know how compilers behave
> > > @@ -6687,7 +6685,13 @@ int kvm_mmu_vendor_module_init(void)
> > >  	BUILD_BUG_ON(sizeof(union kvm_mmu_extended_role) != sizeof(u32));
> > >  	BUILD_BUG_ON(sizeof(union kvm_cpu_role) != sizeof(u64));
> > >  
> > > +	/* Reset the PTE masks before the vendor module's hardware setup. */
> > >  	kvm_mmu_reset_all_pte_masks();
> > > +}
> > > +
> > > +int kvm_mmu_hardware_setup(void)
> > > +{
> > 
> > Instead of putting this code in a new function and calling it after
> > hardware_setup(), we could put it in kvm_configure_mmu().a
> 
> Ya, I noted that as an alternative in the changelog but obviously opted to not
> do the allocation in kvm_configure_mmu(). 

Doh! My mistake. The idea to use kvm_configure_mmu() came to me while
reviewing patch 3 and I totally forgot about that blurb in the commit
message when I came back here to leave the suggestion.

> I view kvm_configure_mmu() as a necessary
> evil.  Ideally vendor code wouldn't call into the MMU during initialization, and
> common x86 would fully dictate the order of calls so that MMU setup.  We could force
> that, but it'd require something gross like filling a struct passed into
> ops->hardware_setup(), and probably would be less robust (more likely to omit a
> "required" field).
> 
> In other words, I like the explicit kvm_mmu_hardware_setup() call from common x86,
> e.g. to show that vendor code needs to do setup before the MMU, and so that MMU
> setup isn't buried in a somewhat arbitrary location in vendor hardware setup. 

Agreed, but if we're not going to get rid of kvm_configure_mmu(), we're
stuck with vendor-specific code calling into the MMU code during
hardware setup either way.

> 
> I'm not dead set against handling this in kvm_configure_mmu() (though I'd probably
> vote to rename it to kvm_mmu_hardware_setup()) if anyone has a super strong opinion.

Your call. I'll put in a vote for using kvm_configure_mmu() and renaming
to kvm_mmu_hardware_setup().

>  
> > This will result in a larger patch diff, but has it eliminates a subtle
> > and non-trivial-to-verify dependency ordering between
> 
> Verification is "trivial" in that this WARN will fire if the order is swapped:
> 
> 	if (WARN_ON_ONCE(!nr_sptes_per_pte_list))
> 		return -EIO;

Ah I missed that, that's good. Although I was thinking more from a code
readability standpoint.

> 
> > kvm_configure_mmu() and kvm_mmu_hardware_setup() and it will co-locate
> > the initialization of nr_sptes_per_pte_list and the code that uses it to
> > create pte_list_desc_cache in a single function.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2983C55DEA1
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbiF0Pk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 11:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbiF0Pk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 11:40:56 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5494C1A041
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 08:40:55 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id i8-20020a17090aee8800b001ecc929d14dso10462870pjz.0
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 08:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TC6g15wrTkPeRuhsLCZ7RRPMHOeLkiW/5pErHta2paU=;
        b=L3FOzOKxk3TNWmFmjYZ+ZUbrkXftsVVvL32leyWauv4QcEh1LDKlGi+3pkzoFHlIyG
         9EVbwu/g82AiMv0MjQJkqHLta3sz34oDzDzrT6+4fcpIuJ2OMb7hv+qVzbBumMVYVUPJ
         +nLp22mUZLp6dnK6xHEyo+iPrzj85kBwGedcoIRjY0dOc2ZRafgwCe9ukZsatQIaHyNw
         DaLvbtUafqS4WJokje5gfu+bhdtX9gKG0HwcuguBYW+VuolH3zJ1wlGrm5UK3ZtsfFOI
         FDDxAz634m9LIEyQy/XVuwXlCgTcaskDgWGSBp0QynwjXGR8WuMnAmPktqkmwSLWrnLZ
         1xWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TC6g15wrTkPeRuhsLCZ7RRPMHOeLkiW/5pErHta2paU=;
        b=UY5YRzsy9b+Ygq+k7B5Ga+zcDtl/3bObDxIOVui6JX/euw4u1KTjbY1Hevio5/F+Bl
         T97Limvn8WlYwXxPnirmd6m0Lj3g8JFs4GXjMNSACIZRjzjG6GyhhIo44aJe6vZ8zP88
         WuSaP++nZo006GLXvJVGsOUf+UZMpIuloRVrlxWZQv9/tcrAi71NvMPPjEZN5aWrN1F/
         3inypXb94taY7Gh7vUpPxyY7bLvyUOeDNNIWr31iIQfh6xqe/Nf0daIRa6BUcznjmaJa
         HoORkYPLa+agkRGXNexA/No0PlgBsgzebmkLYVZ2OtYZu6CkEqmoEGrBPhocOYoN009F
         sXgQ==
X-Gm-Message-State: AJIora92ngs/NXfBx00YgXcapmgRM2VEgDQQTy9gXqZQmfpq1IgtpKg5
        Vvk79QFVPGZm8CsekM9pJoPu6w==
X-Google-Smtp-Source: AGRyM1tgnbhwcVzntaAEwlGuNaKkPLdLbi82rqgPr2nyG9p9ixwzklHaDG76MhcDO0rWHAUWID4Oow==
X-Received: by 2002:a17:902:f608:b0:168:e92b:47e8 with SMTP id n8-20020a170902f60800b00168e92b47e8mr61841plg.115.1656344454645;
        Mon, 27 Jun 2022 08:40:54 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z4-20020a1709027e8400b00163f3e91ea0sm2300546pla.238.2022.06.27.08.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 08:40:53 -0700 (PDT)
Date:   Mon, 27 Jun 2022 15:40:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Defer "full" MMU setup until after
 vendor hardware_setup()
Message-ID: <YrnPgZvgWDpb6+R1@google.com>
References: <20220624232735.3090056-1-seanjc@google.com>
 <20220624232735.3090056-3-seanjc@google.com>
 <YrZTxZm4kq0rXcKQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrZTxZm4kq0rXcKQ@google.com>
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

On Sat, Jun 25, 2022, David Matlack wrote:
> On Fri, Jun 24, 2022 at 11:27:33PM +0000, Sean Christopherson wrote:
> > Alternatively, the setup could be done in kvm_configure_mmu(), but that
> > would require vendor code to call e.g. kvm_unconfigure_mmu() in teardown
> > and error paths, i.e. doesn't actually save code and is arguably uglier.
> [...]
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 17ac30b9e22c..ceb81e04aea3 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6673,10 +6673,8 @@ void kvm_mmu_x86_module_init(void)
> >   * loaded as many of the masks/values may be modified by VMX or SVM, i.e. need
> >   * to be reset when a potentially different vendor module is loaded.
> >   */
> > -int kvm_mmu_vendor_module_init(void)
> > +void kvm_mmu_vendor_module_init(void)
> >  {
> > -	int ret = -ENOMEM;
> > -
> >  	/*
> >  	 * MMU roles use union aliasing which is, generally speaking, an
> >  	 * undefined behavior. However, we supposedly know how compilers behave
> > @@ -6687,7 +6685,13 @@ int kvm_mmu_vendor_module_init(void)
> >  	BUILD_BUG_ON(sizeof(union kvm_mmu_extended_role) != sizeof(u32));
> >  	BUILD_BUG_ON(sizeof(union kvm_cpu_role) != sizeof(u64));
> >  
> > +	/* Reset the PTE masks before the vendor module's hardware setup. */
> >  	kvm_mmu_reset_all_pte_masks();
> > +}
> > +
> > +int kvm_mmu_hardware_setup(void)
> > +{
> 
> Instead of putting this code in a new function and calling it after
> hardware_setup(), we could put it in kvm_configure_mmu().a

Ya, I noted that as an alternative in the changelog but obviously opted to not
do the allocation in kvm_configure_mmu().  I view kvm_configure_mmu() as a necessary
evil.  Ideally vendor code wouldn't call into the MMU during initialization, and
common x86 would fully dictate the order of calls so that MMU setup.  We could force
that, but it'd require something gross like filling a struct passed into
ops->hardware_setup(), and probably would be less robust (more likely to omit a
"required" field).

In other words, I like the explicit kvm_mmu_hardware_setup() call from common x86,
e.g. to show that vendor code needs to do setup before the MMU, and so that MMU
setup isn't buried in a somewhat arbitrary location in vendor hardware setup. 

I'm not dead set against handling this in kvm_configure_mmu() (though I'd probably
vote to rename it to kvm_mmu_hardware_setup()) if anyone has a super strong opinion.
 
> This will result in a larger patch diff, but has it eliminates a subtle
> and non-trivial-to-verify dependency ordering between

Verification is "trivial" in that this WARN will fire if the order is swapped:

	if (WARN_ON_ONCE(!nr_sptes_per_pte_list))
		return -EIO;

> kvm_configure_mmu() and kvm_mmu_hardware_setup() and it will co-locate
> the initialization of nr_sptes_per_pte_list and the code that uses it to
> create pte_list_desc_cache in a single function.

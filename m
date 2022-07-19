Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027EC579827
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 13:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbiGSLGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 07:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234221AbiGSLGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 07:06:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AC02E9FD;
        Tue, 19 Jul 2022 04:06:19 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q43-20020a17090a17ae00b001f1f67e053cso1888669pja.4;
        Tue, 19 Jul 2022 04:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=huRSeviwnb0VtSEsznFDpKhZhWfPsukoSZSiQCt+kKY=;
        b=mi9mv50xdswL/Qcx9EjjXT//VOC3q1jU5NtlM6TEnXN2D0vem6ssRUTgDzonKhwtF8
         2tvSntR08u1QrA08DuJiqOjhjIRoydaQHUZCsqmfOXAIKUfp19Jalvj9s3io6iMvToOn
         cYPMfC6AeIPNzWO3wgeizRoq5w0AQfkqtykX0aZnumVpzDFKfjCJzYJkv9bmy5G0n+0P
         LHXN7gFlGUU/lvoYUbBdz0B7G265oAmkBzA6M0+uL0m07rdQcpRrBagnUmSTPyOCrcF6
         /V2qMVLnSQWg4NscIwcKfDoElRUFKaBQDh3TgQAZ4WAtKc3ecDXgGCBsPbNgqc1b+2yA
         Se+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=huRSeviwnb0VtSEsznFDpKhZhWfPsukoSZSiQCt+kKY=;
        b=LGJA/fFcc3ZZ9zXug4A61FZ9Xjp54h6k+4RjKAQaR/pF4Z9aMN5ie2JXZZkr3bgRM3
         fDD1OJilnAT5jAj2VJbP/4WVhRRI/akYD+UfGmihLYxOfL7nEV8AXplRxeHssxC2NEzM
         thcSXxge5XpFHaiNNHlbCJQYtIQstYRiZkCxqkj/WcJcaH/GY+XLnVT1115VYKTl/Xy0
         4F++KDjqqZVEAd/SttRG5IwYuOwbY6K4l6nONHernveBujSgOrqQ43SHIfOEE3z5eh/9
         /dXiyycjVhZZqSgeRFGthYspRzTP35mGPXS44UX4MJdzkfujFAU1fvjd54abOtcXzZ7E
         4+Rw==
X-Gm-Message-State: AJIora95A8jvBtRiRtHySDVnVrrwga5Zsk+qlYtn0VmCUAdXhQ2ZytfT
        pKrjHuCTEv1l46/dfTMHjHvFyz5xs7Q=
X-Google-Smtp-Source: AGRyM1vdJKGuzivaW6yIbWcAN7b9ubdp7L1lZPh/6aOL226fiep19D3ESLBHc13UdOJZg8dzNn4LcQ==
X-Received: by 2002:a17:902:ecc2:b0:16c:5b89:fd0b with SMTP id a2-20020a170902ecc200b0016c5b89fd0bmr33141550plh.122.1658228778611;
        Tue, 19 Jul 2022 04:06:18 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id h3-20020a63c003000000b00416018b5bbbsm9839806pgg.76.2022.07.19.04.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 04:06:17 -0700 (PDT)
Date:   Tue, 19 Jul 2022 04:06:16 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 040/102] KVM: x86/mmu: Zap only leaf SPTEs for
 deleted/moved memslot for private mmu
Message-ID: <20220719110616.GW1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <27acc4b2957e1297640d1d8b2a43f7c08e3885d5.1656366338.git.isaku.yamahata@intel.com>
 <a0c4d1fdd132fa0767cd27b9c21d3e04857f7598.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0c4d1fdd132fa0767cd27b9c21d3e04857f7598.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022 at 10:41:08PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > For kvm mmu that has shared bit mask, zap only leaf SPTEs when
> > deleting/moving a memslot.  The existing kvm_mmu_zap_memslot() depends on
> 
> Unless I am mistaken, I don't see there's an 'existing' kvm_mmu_zap_memslot().

Oops. it should be kvm_tdp_mmu_invalidate_all_roots().


> > role.invalid with read lock of mmu_lock so that other vcpu can operate on
> > kvm mmu concurrently. 
> > 
> 
> > Mark the root page table invalid, unlink it from page
> > table pointer of CPU, process the page table.  
> > 
> 
> Are you talking about the behaviour of existing code, or the change you are
> going to make?  Looks like you mean the latter but I believe it's the former.


The existing code.  The should "It marks ...".


> > It doesn't work for private
> > page table to unlink the root page table because it requires all SPTE entry
> > to be non-present. 
> > 
> 
> I don't think we can truly *unlink* the private root page table from secure
> EPTP, right?  The EPTP (root table) is fixed (and hidden) during TD's runtime.
> 
> I guess you are trying to say: removing/unlinking one secure-EPT page requires
> removing/unlinking all its children first? 

That's right. I'll update it as follows.
                          

> So the reason to only zap leaf is we cannot truly unlink the private root page
> table, correct?  Sorry your changelog is not obvious to me.

The reason is, to unlink a page table from the parent's SPTE, all SPTEs of the
page table need to be non-present.

Here is the updated commit message.

KVM: x86/mmu: Zap only leaf SPTEs for deleted/moved memslot for private mmu|
For kvm mmu that has shared bit mask, zap only leaf SPTEs when             |
deleting/moving a memslot.  The existing kvm_tdp_mmu_invalidate_all_roots()|
depends on role.invalid with read lock of mmu_lock so that other vcpu can  |
operate on kvm mmu concurrently.  It marks the root page table invalid,    |
zaps SPTEs of the root page tables.                                        |
                                                                           |
It doesn't work to unlink a private page table from the parent's SPTE entry|
because it requires all SPTE entry of the page table to be non-present.    |
Instead, with write-lock of mmu_lock and zap only leaf SPTEs for kvm mmu   |
with shared bit mask.  

> > Instead, with write-lock of mmu_lock and zap only leaf
> > SPTEs for kvm mmu with shared bit mask.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 35 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 34 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 80d7c7709af3..c517c7bca105 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5854,11 +5854,44 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
> >  	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
> >  }
> >  
> > +static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> > +{
> > +	bool flush = false;
> > +
> > +	write_lock(&kvm->mmu_lock);
> > +
> > +	/*
> > +	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
> > +	 * case scenario we'll have unused shadow pages lying around until they
> > +	 * are recycled due to age or when the VM is destroyed.
> > +	 */
> > +	if (is_tdp_mmu_enabled(kvm)) {
> > +		struct kvm_gfn_range range = {
> > +		      .slot = slot,
> > +		      .start = slot->base_gfn,
> > +		      .end = slot->base_gfn + slot->npages,
> > +		      .may_block = false,
> > +		};
> > +
> > +		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush);
> 
> 
> It appears you only unmap private GFNs (because the base_gfn doesn't have shared
> bit)?  I think shared mapping in this slot must be zapped too?  
>
> How is this done?  Or the kvm_tdp_mmu_unmap_gfn_range() also zaps shared
> mappings?

kvm_tdp_mmu_unmap_gfn_range() handles both private gfn and shared gfn as
they are alias.  


> It's hard to review if one patch's behaviour/logic depends on further patches.

I'll add a comment on the call.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

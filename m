Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517C158E3E4
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 01:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiHIXw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 19:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiHIXw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 19:52:56 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E557FE49;
        Tue,  9 Aug 2022 16:52:56 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r22so10410241pgm.5;
        Tue, 09 Aug 2022 16:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=USyZqluqA43/rUeAlF5/qHhmGQX9P9xzVxOeyhsHrvo=;
        b=SblroUSOOLZI9EyIoCySuNHP1s7lQ4EB0GJBNMbxczzgvB6Cjx4iTILWJjVL1NIn10
         O3Kt8as6sruzWeO+AyaPM22TEB5loFFcRNAjTp2XY4+2d5nCFihsevc7W4PTK6GlqxuP
         8+/d1ysOzkY2RhADMhQj5ula+0F44kwZxBXlsRse7tmbr3E7r+0Oa3lZ2QqG4wXRmJJc
         JVzmRGPZ1V17YNkW3JfaCohkOrCNFZp2b8w0nkAIixNbaBW5HEDW3ebzfvvbAan0NyzY
         uxpL/YmR26UZh19qV71YN83zrNash1aLrYj9D1HWRX4WyTEWJnLWozWJj8HdkkGRpLWT
         vvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=USyZqluqA43/rUeAlF5/qHhmGQX9P9xzVxOeyhsHrvo=;
        b=5maIxL5WLiE+OwRSTATzU3+mYnIuh9fco0E7Xr4LSDw0OkZfsC1yvqlKvD5i36CItt
         gbS4I59CC5P39wj1p7KDCNhCOBDbozplbWHegxBpfw0M2CG+dqKF7Dlz/76awRQoXKUj
         sIQEDcWMiQBmx9HW1EsHAMT5N/Mb9/Z/HIPBJI7S/UGow3SM/1YD4tNQ/c/Uul2JpYA9
         YStVUUJd13bA50m/JJD4e8mBJgQwmD9rdFniFmr3A9F4LiETd8sDBaIDE89DJgm9lQex
         d03cGrkyWKDSkNSE0IXbV2MN71r5X2rDtZPjxsUBzGjho6VJg+mKBTfiGUd6tfnNBk8a
         ultA==
X-Gm-Message-State: ACgBeo1dK1HXcCb7rzwn5MS4s01gdsrYaZ5+nsgCseS6SZgPA1+1frPf
        qs2ogn6rN8EdUQ8XtPrL9LM=
X-Google-Smtp-Source: AA6agR4/36cbFq4wzIyIuGRtwDJNLqYFTUty6nCiqEwJxhLvnbLrAOBCp95pG3tuAq36Jcirste9BQ==
X-Received: by 2002:a05:6a00:1581:b0:52f:332d:9c98 with SMTP id u1-20020a056a00158100b0052f332d9c98mr12567697pfk.64.1660089175349;
        Tue, 09 Aug 2022 16:52:55 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902e89200b0016efa52d428sm11417479plg.218.2022.08.09.16.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 16:52:54 -0700 (PDT)
Date:   Tue, 9 Aug 2022 16:52:54 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 044/102] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
Message-ID: <20220809235254.GB515657@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <392839e09c48ff4e14a598ff6ed8bd56429bf17b.1656366338.git.isaku.yamahata@intel.com>
 <YuLmf+dovudTbjqh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YuLmf+dovudTbjqh@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 12:41:51PM -0700,
David Matlack <dmatlack@google.com> wrote:

> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f4d4ed41641b..bfc934dc9a33 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -716,6 +716,7 @@ struct kvm_vcpu_arch {
> >  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> >  	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
> >  	struct kvm_mmu_memory_cache mmu_page_header_cache;
> > +	struct kvm_mmu_memory_cache mmu_private_sp_cache;
> 
> I notice that mmu_private_sp_cache.gfp_zero is left unset so these pages
> may contain garbage. Is this by design because the TDX module can't rely
> on the contents being zero and has to take care of initializing the page
> itself? i.e. GFP_ZERO would be a waste of cycles?
> 
> If I'm correct please include a comment here in the next revision to
> explain why GFP_ZERO is not necessary.

Yes, exactly.  Here is the added comments.
 /*
  * This cache is to allocate pages used for Secure-EPT used by the TDX
  * module.  Because the TDX module doesn't trust VMM and initializes the
  * pages itself, KVM doesn't initialize them.  Allocate pages with
  * garbage and give them to the TDX module.
  */

> >  	/*
> >  	 * QEMU userspace and the guest each have their own FPU state.
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index c517c7bca105..a5bf3e40e209 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -691,6 +691,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> >  	int start, end, i, r;
> >  	bool is_tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
> >  
> > +	if (kvm_gfn_shared_mask(vcpu->kvm)) {
> > +		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_sp_cache,
> > +					       PT64_ROOT_MAX_LEVEL);
> > +		if (r)
> > +			return r;
> > +	}
> > +
> >  	if (is_tdp_mmu && shadow_nonpresent_value)
> >  		start = kvm_mmu_memory_cache_nr_free_objects(mc);
> >  
> > @@ -732,6 +739,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> >  {
> >  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> >  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> > +	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
> >  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
> >  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
> >  }
> > @@ -1736,6 +1744,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
> >  	if (!direct)
> >  		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> >  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > +	kvm_mmu_init_private_sp(sp, NULL);
> 
> This is unnecessary. kvm_mmu_page structs are zero-initialized so
> private_sp will already be NULL.

Ok. 


> >  
> >  	/*
> >  	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 44a04fad4bed..9f3a6bea60a3 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -55,6 +55,10 @@ struct kvm_mmu_page {
> >  	u64 *spt;
> >  	/* hold the gfn of each spte inside spt */
> >  	gfn_t *gfns;
> > +#ifdef CONFIG_KVM_MMU_PRIVATE
> > +	/* associated private shadow page, e.g. SEPT page. */
> 
> Can we use "Secure EPT" instead of SEPT in KVM code and comments? (i.e.
> also including variable names like sept_page -> secure_ept_page)
> 
> "SEPT" looks like a mispelling of SPTE, which is used all over KVM. It
> will be difficult to read code that contains both acronyms.

Makes sense. Will update it.


> > +	void *private_sp;
> 
> Please name this "private_spt" and move it up next to "spt".
> 
> sp" or "shadow page" is used to refer to kvm_mmu_page structs. For
> example, look at all the code in KVM that uses `struct kvm_mmu_page *sp`.
> 
> "spt" is "shadow page table", i.e. the actual page table memory. See
> kvm_mmu_page.spt. Calling this field "private_spt" makes it obvious that
> this pointer is pointing to a page table.
> 
> Also please update the language in the comment accordingly to "private
> shadow page table".

I'll rename as follows

private_sp => private_spt
spet_page => private_spt
mmu_private_sp_cache => mmu_private_spt_cache
kvm_mmu_init_private_sp => kvm_mmu_inite_private_spt
kvm_mmu_alloc_private_sp => kvm_mmu_alloc_private_spt
kvm_mmu_free_private_sp => kvm_mmu_free_private_spt
kvm_alloc_private_sp_for_split => kvm_alloc_private_spt_for_split

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

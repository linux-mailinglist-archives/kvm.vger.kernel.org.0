Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7E64B1AC2
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 01:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346573AbiBKAyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 19:54:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346528AbiBKAyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 19:54:37 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E33010B7
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 16:54:37 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id x15so10946971pfr.5
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 16:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gSx28UKeCMp/oRLOiqMvFzHyx/ZVhU1gpNBGY870w4s=;
        b=gTn6ZDScoBvH/pGmW3TK5xT8a9Hgez9llKDPunKEUTCGGGYm9Ke49V5aBzNJuSDL6j
         VKGUmJBdSr0LCili5IUypGaVbPqYt74yidh+hr07HSUI+/CfS3UIvZlipnxFOOi4g3Is
         i2V4lrazCctH1SCM/lsDxsSUz0fuTjH6Ctn9uzDMWkM3R/27da7zmgBfTSKwJdMhduwm
         aW6VMBM8bN3bLbB9GFLrn6ytXaxyAkRKB8RcF1n62aGANIyKMOna6IXJnEoXlNvN09uq
         0fXfqBl7W7iC6Gr987ZoMHEGJhDOf87jFBJSitXNyJWqlmEfWmyg8IfpRAoYkGrMjfaW
         mvRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gSx28UKeCMp/oRLOiqMvFzHyx/ZVhU1gpNBGY870w4s=;
        b=Yb7ZLq1J1Cc1s3b9LloN9Df6kv8oZY6GT9SRVHxhomAsgGkYuHdaeMX1Xnf90rjKrz
         MqvvXoELqV9rD0vlxTVmWuSR6cU7agkhmug8njFceOqyT/CN+411GDk/dKif5y6ZnZNE
         LSgu2r3NinGAANLQvuDQGj3OX7E2HT8H9fGUwdVoMNbUW5rIx0qsh7U3/pXkc/PNr4vd
         i2qQGaMX5Y12g13qlQWVXZxlhoGX+FgWtsDNtYAZCGFsqByr7HSnQTqaj+WNonMhSQkZ
         eXYJcVfK0nuK8Ndqs9H2axcsDt/HGLENhr3tC6Lg2bSmkvF5Rmy/DM1nACxWR9YYZ/BW
         xWqA==
X-Gm-Message-State: AOAM533PfZmTNOjvgrTTb9yYUEQBCPYbM+AKZIx+hoLDOv8c9zFVyyfd
        qZecnGvxPEV78IKXZ8k8rOG16Q==
X-Google-Smtp-Source: ABdhPJwMIqBDwfqoiGpu0MHaqps4fYrP/0DFsX46oK5L9gl0Z5pON7Wyrn1x5ew3ygjZ5M2UvVn6wA==
X-Received: by 2002:a63:1249:: with SMTP id 9mr8333712pgs.417.1644540876576;
        Thu, 10 Feb 2022 16:54:36 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nu15sm3625642pjb.5.2022.02.10.16.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 16:54:35 -0800 (PST)
Date:   Fri, 11 Feb 2022 00:54:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 08/12] KVM: MMU: do not consult levels when freeing roots
Message-ID: <YgWzyBbAZe89ljqO@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-9-pbonzini@redhat.com>
 <YgWwrG+EQgTwyt8v@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgWwrG+EQgTwyt8v@google.com>
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

On Fri, Feb 11, 2022, Sean Christopherson wrote:
> On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> > Right now, PGD caching requires a complicated dance of first computing
> > the MMU role and passing it to __kvm_mmu_new_pgd, and then separately calling
> 
> Nit, adding () after function names helps readers easily recognize when you're
> taking about a specific function, e.g. as opposed to a concept or whatever.
> 
> > kvm_init_mmu.
> > 
> > Part of this is due to kvm_mmu_free_roots using mmu->root_level and
> > mmu->shadow_root_level to distinguish whether the page table uses a single
> > root or 4 PAE roots.  Because kvm_init_mmu can overwrite mmu->root_level,
> > kvm_mmu_free_roots must be called before kvm_init_mmu.
> > 
> > However, even after kvm_init_mmu there is a way to detect whether the page table
> > has a single root or four, because the pae_root does not have an associated
> > struct kvm_mmu_page.
> 
> Suggest a reword on the final paragraph, because there's a discrepancy with the
> code (which handles 0, 1, or 4 "roots", versus just "single or four").
> 
>   However, even after kvm_init_mmu() there is a way to detect whether the
>   page table may hold PAE roots, as root.hpa isn't backed by a shadow when
>   it points at PAE roots.
> 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 3c3f597ea00d..95d0fa0bb876 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3219,12 +3219,15 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >  	struct kvm *kvm = vcpu->kvm;
> >  	int i;
> >  	LIST_HEAD(invalid_list);
> > -	bool free_active_root = roots_to_free & KVM_MMU_ROOT_CURRENT;
> > +	bool free_active_root;
> >  
> >  	BUILD_BUG_ON(KVM_MMU_NUM_PREV_ROOTS >= BITS_PER_LONG);
> >  
> >  	/* Before acquiring the MMU lock, see if we need to do any real work. */
> > -	if (!(free_active_root && VALID_PAGE(mmu->root.hpa))) {
> > +	free_active_root = (roots_to_free & KVM_MMU_ROOT_CURRENT)
> > +		&& VALID_PAGE(mmu->root.hpa);
> 
> 	free_active_root = (roots_to_free & KVM_MMU_ROOT_CURRENT) &&
> 			   VALID_PAGE(mmu->root.hpa);
> 
> Isn't this a separate bug fix?  E.g. call kvm_mmu_unload() without a valid current
> root, but with valid previous roots?  In which case we'd try to free garbage, no?
> 			   
> > +
> > +	if (!free_active_root) {
> >  		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> >  			if ((roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) &&
> >  			    VALID_PAGE(mmu->prev_roots[i].hpa))
> > @@ -3242,8 +3245,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >  					   &invalid_list);
> >  
> >  	if (free_active_root) {
> > -		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> > -		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> > +		if (to_shadow_page(mmu->root.hpa)) {
> >  			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
> >  		} else if (mmu->pae_root) {

Gah, this is technically wrong.  It shouldn't truly matter, but it's wrong.  root.hpa
will not be backed by shadow page if the root is pml4_root or pml5_root, in which
case freeing the PAE root is wrong.  They should obviously be invalid already, but
it's a little confusing because KVM wanders down a path that may not be relevant
to the current mode.

For clarity, I think it's worth doing:

		} else if (mmu->root.hpa == __pa(mmu->pae_root)) {


> >  			for (i = 0; i < 4; ++i) {
> > -- 
> > 2.31.1
> > 
> > 

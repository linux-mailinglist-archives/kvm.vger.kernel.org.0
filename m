Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAE84BBE6A
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238563AbiBRR2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:28:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbiBRR2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:28:12 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644D82AF939
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:27:55 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id n19-20020a17090ade9300b001b9892a7bf9so12934242pjv.5
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/t3SG5e2UzbrVHasx9SNleS+3lFpsgqmvZDXnUvzgQo=;
        b=Q8s/VU7jz2rbgZI1SOmrSjXqOrQVsYAw/xwu/uePGl2AhiYMXNdl/C+OmRWVUYPGtz
         rMp18KffJoqK0s8KXS3xCoaIv/Qq3Wmi8aJ7rKTwSWEVP4rTbO24fr3wDl7Q7n+xvYSD
         N8cEPLmd253gm4qBU/9LVsToAvfXpASjxU9NXbzae+P13yqAMQKhKVSulGSqKk3gSp/P
         B2XXPsGI9+XpsTebbZ6p7fSuQAbipxQPvbPgl7IsDWW8ySgTNpAH/jJCQ7HBQQ+bB6Zz
         D89TXPjjXbVwgKlhxwxIWii4+Qbg81feT23aG1Ub6F+2XjrmyIoZxjLrBwXt86hH9eCL
         CuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/t3SG5e2UzbrVHasx9SNleS+3lFpsgqmvZDXnUvzgQo=;
        b=Hd4fOHRmIE4lTD0gfWWvX4kdLdpz2TRHh6AJd5SKM4EB4VM8BD6awj20ypPIGB631h
         oLCu0dxREMzblvw1Qjl6iPEMVRo3aMU+MctDeYuWcDdy5GzuBWqtEr6SBY8t3vIwibUE
         v/Bhr2mmyB0TArCg6yDEGDUaFXoNORxWaoa0oZ8NNoPxwfXWPDsCTQlrhew18hdUqg7g
         H8DM6mBUt3DjDT2UyB9HrywMU5wDc451LVcrz/Re/arZ2By4tVaPpVejmd52cW+KDu0w
         wurotCqkC5KWeIMoCtCHiafkrNaYnjCpYj+EZTg9svbsjTGxRXtTBAXWs7/tIDHy8xiR
         +FOg==
X-Gm-Message-State: AOAM533dGNn4A8AHHRlK/Oyta4bSrZiV86Bz2daQzvPfe2tWWrj1ehnm
        ukicrx4/V7t9iRriWlbNwLCbzaoHzND9Sw==
X-Google-Smtp-Source: ABdhPJyVZlQUClYR9tuRl+TP+12xfhaorPEjMMrKolb4M8RD99xCw6DgyJn/90y0JYAaxnidUOF2gQ==
X-Received: by 2002:a17:90a:d58a:b0:1b9:fe1e:403c with SMTP id v10-20020a17090ad58a00b001b9fe1e403cmr9349995pju.124.1645205274670;
        Fri, 18 Feb 2022 09:27:54 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s24sm11598555pgq.51.2022.02.18.09.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 09:27:53 -0800 (PST)
Date:   Fri, 18 Feb 2022 17:27:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 06/18] KVM: x86/mmu: do not consult levels when
 freeing roots
Message-ID: <Yg/XFj//AH48rJL3@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-7-pbonzini@redhat.com>
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

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> Right now, PGD caching requires a complicated dance of first computing
> the MMU role and passing it to __kvm_mmu_new_pgd(), and then separately calling

Wrap at ~75 chars.  I'm starting to wonder if you role 5x d20 when deciding what
line number you wrap at :-)

> kvm_init_mmu().
> 
> Part of this is due to kvm_mmu_free_roots using mmu->root_level and
> mmu->shadow_root_level to distinguish whether the page table uses a single
> root or 4 PAE roots.  Because kvm_init_mmu() can overwrite mmu->root_level,
> kvm_mmu_free_roots() must be called before kvm_init_mmu().
> 
> However, even after kvm_init_mmu() there is a way to detect whether the
> page table may hold PAE roots, as root.hpa isn't backed by a shadow when
> it points at PAE roots.  Using this method results in simpler code, and
> is one less obstacle in moving all calls to __kvm_mmu_new_pgd() after the
> MMU has been initialized.

I think it's worth adding a blurb about 5-level nNPT.  Something like

  Note, this is technically wrong when KVM is using shadowing 4-level NPT
  in L1 with 5-level NPT in L0, as the PDPTEs are not used in that case
  and mmu->root.hpa will not be backed by a shadow page.  But the PDPTEs
  will be '0' so processing them does no harm, not too mention that that
  particular nNPT case is completely broken in KVM and this code will
  need to be reworked to correctly handle 5=>4-level nNPT no matter what.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a478667d7561..e1578f71feae 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3240,12 +3240,15 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	struct kvm *kvm = vcpu->kvm;
>  	int i;
>  	LIST_HEAD(invalid_list);
> -	bool free_active_root = roots_to_free & KVM_MMU_ROOT_CURRENT;
> +	bool free_active_root;
>  
>  	BUILD_BUG_ON(KVM_MMU_NUM_PREV_ROOTS >= BITS_PER_LONG);
>  
>  	/* Before acquiring the MMU lock, see if we need to do any real work. */
> -	if (!(free_active_root && VALID_PAGE(mmu->root.hpa))) {
> +	free_active_root = (roots_to_free & KVM_MMU_ROOT_CURRENT)
> +		&& VALID_PAGE(mmu->root.hpa);

Pretty please, put the && on the first line and align the indentation.

	free_active_root = (roots_to_free & KVM_MMU_ROOT_CURRENT) &&
			   VALID_PAGE(mmu->root.hpa);

With that,

Reviewed-by: Sean Christopherson <seanjc@google.com>

> +
> +	if (!free_active_root) {
>  		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>  			if ((roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) &&
>  			    VALID_PAGE(mmu->prev_roots[i].hpa))
> @@ -3263,8 +3266,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  					   &invalid_list);
>  
>  	if (free_active_root) {
> -		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> -		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> +		if (to_shadow_page(mmu->root.hpa)) {
>  			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
>  		} else if (mmu->pae_root) {
>  			for (i = 0; i < 4; ++i) {
> -- 
> 2.31.1
> 
> 

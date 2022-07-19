Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0214157A801
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 22:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239731AbiGSUIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 16:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiGSUIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 16:08:05 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283A5BF44
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:08:04 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f11so14471361pgj.7
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j8fpaezXRFwn4+Ho957RhCHI/1ApPqF3nvBcj0KrerQ=;
        b=mXe2UetShJT3mLzz/cur2NABcA9POjjC3PHbHtwqtzKNj0GDrdKlgyB97jfGh39iRH
         6fCgoLa0B3Jvn/8SpvXwTuxxvxjioNzdZZV5TYfVMMRh1YlQy6JZO6F+2So6YgVk79UX
         d0fjFavqFpt/MU5LVoTk2b9HAIWdpCv2ewrJaeC6uCycYpqwk/BDFK9UKWf92VI4IOBc
         ilA5sW/1Q/l4MiPFMUGJyLwQjQTXrH776VBkdu7l6vDD1hE28Eh8CGZcH4iMCXHrzDQe
         /UOosUdMpuh9TEvYBq+3SKHfECZXipfJF2GVDUTNLQ41+bxJ7gjPn8DekHN+QzfTj5Cw
         pPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j8fpaezXRFwn4+Ho957RhCHI/1ApPqF3nvBcj0KrerQ=;
        b=y1yY3ROpylxqVXxMaLsSzHVVwUNQiXr/ru9PlS3v4p/qItzH1C7GOWKyPfi4o6mhdX
         g5iZQAt2uUSvXvupWoECTlCN/0X57xgi8C0nPtu6g5T9x2rl1zT78NEpXD14Um3ufcNJ
         DWF6sucSXV69KBBZRz05NbxrD3EqXs+J22XRHMTRdWLch6xi7aK/f7RcRwUai0TE0Izm
         tRHMX58NyDr//F77QfR8Ir9E04dC4SYhibCcxywJBre3GrGHSpco/ls7oGDuLiTM6+lh
         RwY8CzZ82CdXsKUd9hJeqQdgt25uCDg7NrvUaqvsCbw+A5Kjg35L3F9Di8h6y58jRdK7
         55Qg==
X-Gm-Message-State: AJIora92uALqisWL3reY68px2/WocxrodBqPllP2kfxw/lLgJ6ZJnfOp
        5gyp9+6FJOacM9PUUMoEBewucg==
X-Google-Smtp-Source: AGRyM1tBBarePTaGuFBhqfkJWfot4ndavhAoqRJuXtfQV0dICOwiYsgUa1RnmwN/v5Vnr3ZzpSmCOg==
X-Received: by 2002:a63:5b45:0:b0:416:7867:4298 with SMTP id l5-20020a635b45000000b0041678674298mr31589221pgm.58.1658261283495;
        Tue, 19 Jul 2022 13:08:03 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id j31-20020a63fc1f000000b00419ab8f8d2csm10360858pgi.20.2022.07.19.13.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 13:08:02 -0700 (PDT)
Date:   Tue, 19 Jul 2022 20:07:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 06/12] KVM: X86/MMU: Rename mmu_unsync_walk() to
 mmu_unsync_walk_and_clear()
Message-ID: <YtcPHx3TYVJzdiN3@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-7-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605064342.309219-7-jiangshanlai@gmail.com>
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

On Sun, Jun 05, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> mmu_unsync_walk() and __mmu_unsync_walk() requires the caller to clear
> unsync for the shadow pages in the resulted pvec by synching them or
> zapping them.
> 
> All callers does so.
> 
> Otherwise mmu_unsync_walk() and __mmu_unsync_walk() can't work because
> they always walk from the beginning.
> 
> And mmu_unsync_walk() and __mmu_unsync_walk() directly clear unsync bits
> now, rename it.

What about mmu_gather_unsync_shadow_pages()?  I agree that "walk" isn't a great
name, but IMO that's true regardless of when it updates the unsync bitmap.  And
similar to a previous complaint about "clear" being ambiguous, I don't think it's
realistic that we'll be able to come up with a name the precisely and unambiguously
describes what exactly is being cleared.

Instead, regardless of what name we settle on, add a function comment.  Probably
in the patch that changes the clear_unsync_child_bit behavior.  That's a better
place to document the implementation detail.

> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2446ede0b7b9..a56d328365e4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1773,7 +1773,7 @@ static inline void clear_unsync_child_bit(struct kvm_mmu_page *sp, int idx)
>  	__clear_bit(idx, sp->unsync_child_bitmap);
>  }
>  
> -static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
> +static int __mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
>  			   struct kvm_mmu_pages *pvec)
>  {
>  	int i, ret, nr_unsync_leaf = 0;
> @@ -1793,7 +1793,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
>  			if (mmu_pages_add(pvec, child, i))
>  				return -ENOSPC;
>  
> -			ret = __mmu_unsync_walk(child, pvec);
> +			ret = __mmu_unsync_walk_and_clear(child, pvec);
>  			if (ret < 0)
>  				return ret;
>  			nr_unsync_leaf += ret;
> @@ -1818,7 +1818,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
>  
>  #define INVALID_INDEX (-1)
>  
> -static int mmu_unsync_walk(struct kvm_mmu_page *sp,
> +static int mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
>  			   struct kvm_mmu_pages *pvec)

Please align indentation.

>  {
>  	pvec->nr = 0;
> @@ -1826,7 +1826,7 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,
>  		return 0;
>  
>  	mmu_pages_add(pvec, sp, INVALID_INDEX);
> -	return __mmu_unsync_walk(sp, pvec);
> +	return __mmu_unsync_walk_and_clear(sp, pvec);
>  }
>  
>  static void kvm_mmu_page_clear_unsync(struct kvm *kvm, struct kvm_mmu_page *sp)
> @@ -1962,7 +1962,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
>  	LIST_HEAD(invalid_list);
>  	bool flush = false;
>  
> -	while (mmu_unsync_walk(parent, &pages)) {
> +	while (mmu_unsync_walk_and_clear(parent, &pages)) {
>  		bool protected = false;
>  
>  		for_each_sp(pages, sp, parents, i)
> @@ -2279,7 +2279,7 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
>  	if (parent->role.level == PG_LEVEL_4K)
>  		return 0;
>  
> -	while (mmu_unsync_walk(parent, &pages)) {
> +	while (mmu_unsync_walk_and_clear(parent, &pages)) {
>  		struct kvm_mmu_page *sp;
>  
>  		for_each_sp(pages, sp, parents, i) {
> -- 
> 2.19.1.6.gb485710b
> 

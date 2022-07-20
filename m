Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0679557AAD2
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbiGTAIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239085AbiGTAIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:08:04 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774B96172F
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:08:03 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e132so14936385pgc.5
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o/JfZNHyT+Imjqo0+3XkOqdvQkIxs9sukX+QyddTzj0=;
        b=UbNaDTl4AgMAQuHFjRXfs0Cw1Ig44aMdzayNcxQ/e01oEYblplP63A3ZEMxcINAIur
         yYlGUkaJ41yNlNwEIttkxlBFF5vP8X4Cvt6YHj4Otj7mec8ale2o2l/dZ9ENATV0Zhxv
         KAfHDAXeVtTmAroKDZ2tAoNCxQtuZqhlQ3XizLiuiGK/UQEvyChNO1JE6x0eavXFtqrt
         hv3yvoKm/lRSmazNkdVpmGikLSxvEr7/H4RB1ccU/TK28jw5oERTvo9S41DOaTjpMg+W
         6j96dKzZr2tjWlpE02qiT4dx6kYdLkRlTWTfbbY5XyUUplsd9FBBZ+sAZws5KBwFClwS
         DzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o/JfZNHyT+Imjqo0+3XkOqdvQkIxs9sukX+QyddTzj0=;
        b=ZKHq7Wblj2D4RIsdibxjg4TRQp2WsaTNhIBq2MIuX7G0+o/FSwa6InAhgj8Ib6Agey
         cZqUi+94+FAf3uCnUDTbZoNJjeK7p2lP5hI1tmbfkvSl+j5Uqb7hOpMvx4IAJMSuY7gG
         //WzLzjJfmTN1qitHXq6DIp+GglbkgKxx6foKYh4R4chYtpegodrQ8rJ6RZhBmGGQENM
         ZJwq+ALOj5PMIzgOIZXx9iVCwZG+ei7xIhJGjTzJ6n4UDvxY+fmWqKUc5GN4zPCuTEt2
         iWZ7CMTRBv6rbVCc96qTnrsHj+WK2G7HnrC9i5HQgCvWeUsaiKGd+LhRVpGEEnyAFZQq
         7VJQ==
X-Gm-Message-State: AJIora8GbfKzLhg0n5jX9OVSmmAt8Rbz/zTx7qBpkil5uJeH14oGIorA
        DFogi+E9s/g88QqVXeSAaYHxcA==
X-Google-Smtp-Source: AGRyM1tBteGnGQJ/e82HO7RBJA1FIoD8nGutEn93UHY3G/bZWBTb8YcJpA5XyEeysl8ks4tuF02fIw==
X-Received: by 2002:a63:5d52:0:b0:412:6eec:7f90 with SMTP id o18-20020a635d52000000b004126eec7f90mr31040524pgm.417.1658275682810;
        Tue, 19 Jul 2022 17:08:02 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p13-20020a170902a40d00b0016c3affe60esm12280719plq.46.2022.07.19.17.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 17:08:01 -0700 (PDT)
Date:   Wed, 20 Jul 2022 00:07:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 08/12] KVM: X86/MMU: Allocate mmu->pae_root for PAE
 paging on-demand
Message-ID: <YtdHXjFhxPXCvhf5@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-9-jiangshanlai@gmail.com>
 <Ytc5Zmer7sjkGAqV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytc5Zmer7sjkGAqV@google.com>
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

On Tue, Jul 19, 2022, Sean Christopherson wrote:
> On Sat, May 21, 2022, Lai Jiangshan wrote:
> > +	/*
> > +	 * Allocate a page to hold the four PDPTEs for PAE paging when emulating
> > +	 * 32-bit mode.  CR3 is only 32 bits even on x86_64 in this case.
> > +	 * Therefore we need to allocate the PDP table in the first 4GB of
> > +	 * memory, which happens to fit the DMA32 zone.
> > +	 */
> > +	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_DMA32);
> 
> Leave off __GFP_ZERO, it's unnecesary in both cases, and actively misleading in
> when TDP is disabled.  KVM _must_ write the page after making it decrypted.  And
> since I can't find any code that actually does initialize "pae_root", I suspect
> this series is buggy.
> 
> But if there is a bug, it was introduced earlier in this series, either by
> 
>   KVM: X86/MMU: Add local shadow pages
> 
> or by
> 
>   KVM: X86/MMU: Activate local shadow pages and remove old logic
> 
> depending on whether you want to blame the function that is buggy, or the patch
> that uses the buggy function..
> 
> The right place to initialize the root is kvm_mmu_alloc_local_shadow_page().
> KVM sets __GFP_ZERO for mmu_shadow_page_cache, i.e. relies on new sp->spt pages
> to be zeroed prior to "allocating" from the cache.
> 
> The PAE root backing page on the other hand is allocated once and then reused
> over and over.
> 
> 	if (role.level == PT32E_ROOT_LEVEL &&
> 	    !WARN_ON_ONCE(!vcpu->arch.mmu->pae_root)) {
> 		sp->spt = vcpu->arch.mmu->pae_root;
> 		kvm_mmu_initialize_pae_root(sp->spt): <==== something like this
> 	} else {
> 		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> 	}

Ah, I believe this is handled for the non-SME case in mmu_free_local_root_page().
But that won't play nice with the decryption path.  And either way, the PDPDTEs
should be explicitly initialized/zeroed when the shadow page is "allocated"

> > -	for (i = 0; i < 4; ++i)
> > -		mmu->pae_root[i] = INVALID_PAE_ROOT;
> 
> Please remove this code in a separate patch.  I don't care if it is removed before
> or after (I'm pretty sure the existing behavior is paranoia), but I don't want
> multiple potentially-functional changes in this patch.

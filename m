Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3B44B1A5F
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 01:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346257AbiBKAYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 19:24:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbiBKAYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 19:24:05 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80E72735
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 16:24:05 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso6043391pjj.1
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 16:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LrUyb0Wh6q+TWQdBAwHTHlIVx9+z8b9Fs7B5ywluypo=;
        b=byNY5Pw6n4O+A1Q3QFXWhgzmCWlIQeKjcQUWZJ+DB0iNn6tZK4MT+hS6YSspA+h6bs
         jQa8L7AoQ4gf7HiYdKT9kprrE3EEg2SozoFAdE6qCOgU4p/0vHsXRbay/qdPQRfSyE8c
         uoHZzTYhOGPFz+DVto+lcTWIDjTXeT8u1ckhRepZoJbX+yBc0h/qzWrXD3XNuktL30Pd
         uQDROctnatm8uQ2LT/yqgFQOe693BKBmpFVHStg1CYX1nse3bEoOVfETyM3b3sZHKx0X
         zou/jBtc5nB0F51EuGLQlbGzX66gCbBkBXBj4SUAMoY35zWFdMlxc5HuUWl2+oZKFDrK
         cxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LrUyb0Wh6q+TWQdBAwHTHlIVx9+z8b9Fs7B5ywluypo=;
        b=bRTyCjzPLTE6K101gm1+SBTDNPjqfsdpMiHp/b5qtLr12pQ3D4GCJPloRUSoVCk/ov
         3+nrFPfZPLYbkGPT3l0QjwRv6OrX7xwBW1I1Fk61Ei8Hjaz8hbDyUuv1wxH83kKMrk5t
         XyYdX/PjXJyJJEYRQ1KPU8QdUaeTn+L0PS0NJ1NEU4vDOu3m10mcar+thMdn6R1WJ+Nb
         tQPTf02mcXdtmg5PnlZM+ZedfbdVT5ory+VkQq5xE+Ebh7fOm12xEFJNSd8GI1eGXfBi
         d+gAyg7klbZAX2Muz6e9kg/D1IJYVmIGZCbTGSgV5UhhqGZI9iXjEPajMnnayGddWhER
         Dshg==
X-Gm-Message-State: AOAM531p6fFMdVjgrk6UI4o4bFQNdVAW7Krgb6Ts+90HwT4jCkM9S7PD
        l/54BFnw2fV9ClSLlMkQKKMO9A==
X-Google-Smtp-Source: ABdhPJy6NqoftN81+qGjPmSwA1HX60QzmRV7HaXy1H+bXAqKzrJoFkfKC5JwQ2PB4RaR/grvsdiu3g==
X-Received: by 2002:a17:902:ea06:: with SMTP id s6mr9827627plg.163.1644539045142;
        Thu, 10 Feb 2022 16:24:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id iy13sm3338563pjb.51.2022.02.10.16.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 16:24:04 -0800 (PST)
Date:   Fri, 11 Feb 2022 00:24:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 05/12] KVM: MMU: avoid NULL-pointer dereference on page
 freeing bugs
Message-ID: <YgWsoKskWnahgR8j@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-6-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170020.1775368-6-pbonzini@redhat.com>
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

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> If kvm_mmu_free_roots encounters a PAE page table where a 64-bit page
> table is expected, the result is a NULL pointer dereference.  Instead
> just WARN and exit.

This confused the heck out of me, because we obviously free PAE page tables.  What
we don't do is back the root that gets shoved into CR3 with a shadow page.  It'd
be especially confusing without the context that this WARN was helpful during
related development, as it's not super obvious why mmu_free_root_page() is a special
snowflake and deserves a WARN.

Something like this?

  WARN and bail if KVM attempts to free a root that isn't backed by a shadow
  page.  KVM allocates a bare page for "special" roots, e.g. when using PAE
  paging or shadowing 2/3/4-level page tables with 4/5-level, and so root_hpa
  will be valid but won't be backed by a shadow page.  It's all too easy to
  blindly call mmu_free_root_page() on root_hpa, be nice and WARN instead of
  crashing KVM and possibly the kernel.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7b5765ced928..d0f2077bd798 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3201,6 +3201,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  		return;
>  
>  	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> +	if (WARN_ON(!sp))

Should this be KVM_BUG_ON()?  I.e. when you triggered these, would continuing on
potentially corrupt guest data, or was it truly benign-ish?

> +		return;
>  
>  	if (is_tdp_mmu_page(sp))
>  		kvm_tdp_mmu_put_root(kvm, sp, false);
> -- 
> 2.31.1
> 
> 

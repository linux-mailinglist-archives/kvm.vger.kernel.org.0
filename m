Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC284FEA8A
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiDLX2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiDLX1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:27:47 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B371D113A
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:13:00 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id r8so196425oib.5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NowsSEuQJIZua7/716N+9P9bKTm9KkV6U8XDawgBVQE=;
        b=UIYv/D4877vchmD36c250N280pyX9NJSXwVvBFW2zFw637UNsQr8rbk54nJVwgG4/p
         gg74h6IyN74e+jRYpL84GkYVlNrDuk7ElKsUwYip7jQro1zQf5Zs+X+RHyLJrIIttoh2
         zXL9EALXQF/E2WvOoV5UG8/+CmzSYinIVC5crACR/XwGjB3ktu8OXSzd/YUhIaKIrfAD
         WQjFHFFWw3NP8zx7xIkWPmynyo/8esYZ31lr1NrVrEhpJ0vF2jGcrLi/9JVnjbShMHZH
         Q/NV5VR/vXBg3ToJX5l33KOml4OkRQunpzZ5vUjuOSbW/qIwqhr/ZWtKzXPu05auPYxq
         HAag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NowsSEuQJIZua7/716N+9P9bKTm9KkV6U8XDawgBVQE=;
        b=WxBUCq6LTlSck7uKcuL976thPGht9Q1JRRN15MKaYP6hiBTdCagTwsgh2qdy2KbhgO
         lfSjcnyqyHb2lgzaG98vYO8wwkQAAcd8hKWxh3cr74S6F72M2Tw2T51kSxqBLm9GUsHv
         XCNyfxvCxbDKZUErQf6JC++z/vqfzltwDUrCjqbdiR91ZHU/P8DDsf731zWVRrImpCL0
         rk6diETf9eTSdPZBjnvgcRWBP2bI8bpHvy8IqCqwnkw3RrQ67VnFSVr0DkfyGxhThnsu
         eBSNEQLpemLsqzNghi7d4Z08emP3gSoyQNgRIx+V63KOp5gsXGEpGQ4wAWgLtKWYS2Qh
         QlNw==
X-Gm-Message-State: AOAM531lK2ccoTU+fGQM/ibxxfTbmhLzCdQ5czgwnoGdKGo6Kf7Wfewu
        WuuRfqz33jAhjpKyiH3uTHf86VvMTarnMA==
X-Google-Smtp-Source: ABdhPJy3r+oVme8d4eH28hz36G3liW90OQkeDuh9SsuKbSxUpbmxkrB4M7+PMd1WrrNt1quENaPYxw==
X-Received: by 2002:a17:90a:4d0d:b0:1cb:9dac:7ed0 with SMTP id c13-20020a17090a4d0d00b001cb9dac7ed0mr7228521pjg.198.1649799097115;
        Tue, 12 Apr 2022 14:31:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm40502527pfo.155.2022.04.12.14.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 14:31:36 -0700 (PDT)
Date:   Tue, 12 Apr 2022 21:31:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH V3 2/4] KVM: X86: Introduce role.glevel for level
 expanded pagetable
Message-ID: <YlXvtMqWpyM9Bjox@google.com>
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
 <20220330132152.4568-3-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330132152.4568-3-jiangshanlai@gmail.com>
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

On Wed, Mar 30, 2022, Lai Jiangshan wrote:
> +  role.glevel:
> +    The level in guest pagetable if the sp is indirect.  Is 0 if the sp
> +    is direct without corresponding guest pagetable, like TDP or !CR0.PG.
> +    When role.level > guest paging level, indirect sp is created on the
> +    top with role.glevel = guest paging level and acks as passthrough sp

s/acks/acts

> +    and its contents are specially installed rather than the translations
> +    of the corresponding guest pagetable.
>    gfn:
>      Either the guest page table containing the translations shadowed by this
>      page, or the base page frame for linear translations.  See role.direct.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9694dd5e6ccc..67e1bccaf472 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -314,7 +314,7 @@ struct kvm_kernel_irq_routing_entry;
>   *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
>   *
>   * Therefore, the maximum number of possible upper-level shadow pages for a
> - * single gfn is a bit less than 2^13.
> + * single gfn is a bit less than 2^15.
>   */
>  union kvm_mmu_page_role {
>  	u32 word;
> @@ -331,7 +331,8 @@ union kvm_mmu_page_role {
>  		unsigned smap_andnot_wp:1;
>  		unsigned ad_disabled:1;
>  		unsigned guest_mode:1;
> -		unsigned :6;
> +		unsigned glevel:4;

We don't need 4 bits for this.  Crossing our fingers that we never had to shadow
a 2-level guest with a 6-level host, we can do:

		unsigned passthrough_delta:2;

Where the field is ignored if direct=1, '0' for non-passthrough, and 1-3 to handle
shadow_root_level - guest_root_level.  Basically the same idea as Paolo's smushing
of direct+passthrough into mapping_level, just dressed up differently.

Side topic, we should steal a bit back from "level", or at least document that we
can steal a bit if necessary.

> +		unsigned :2;
>  
>  		/*
>  		 * This is left at the top of the word so that
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 02eae110cbe1..d53037df8177 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -737,8 +737,12 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
>  
>  static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
>  {
> -	if (!sp->role.direct)
> +	if (!sp->role.direct) {
> +		if (unlikely(sp->role.glevel < sp->role.level))

Regardless of whatever magic we end up using, there should be an is_passthrough_sp()
helper to wrap the magic.

> +			return sp->gfn;
> +
>  		return sp->gfns[index];
> +	}
>  
>  	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
>  }

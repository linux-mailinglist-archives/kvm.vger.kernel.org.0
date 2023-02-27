Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272DB6A4DAD
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 23:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjB0WCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 17:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjB0WCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 17:02:12 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83392917B;
        Mon, 27 Feb 2023 14:02:11 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id h31so4475923pgl.6;
        Mon, 27 Feb 2023 14:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ai6zFC9uGuQAlCaHJ/4eqI5LFQoBaErq6+wpvdVxCqE=;
        b=i0v3AXRw5vzptsM4yZdGgFqhZeZcZ30wZQ3Y36b8usUpS1oSQuf0uhGWKLFuHYDpU8
         t0jG4j6yNo19zSROEW476StJowRctfEXuXqbjRaHVpRat470zTCFj33bctx32WPPj8YJ
         sgubfT0wR5gpC8geZtyIynZAw2FyaZVtcebv3/xF0vDrBPM++edZkqQOQlzXZrqHeFj3
         IPWrak6NtOVfw1yFfLGhbM2E4UBMi69RneRisL89ph49NKEQnwGuF+I8omX5ZspI8UCA
         /5BysVmXngCwl/heIhaLYttudkuphP3rxfgjuYOiV96316PacXyg4709EKm+3au28z7G
         oeuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ai6zFC9uGuQAlCaHJ/4eqI5LFQoBaErq6+wpvdVxCqE=;
        b=qxabpfv6RjO0+k2lO02hcAGsFs8lnvILjYLq+tm+Oz1xDcCvdjl3IldlaV3Zjx4XdG
         zlnW1dNQkAi/dGO6TvcBU0SZ2B9Lik8ZhFqNkkhPp0dbciPHuiOY4mvtAIDE2hVXYkR+
         562grV7X0Xt/XHTnUkENq9oZmOKuvIeNS95zRznX6ZBKjmZD+jkvRuoT8BdnyyuLRITO
         3MCX5R8MTEOF2axzwEWoVlO4rtWPbBKmZZ3ZtONrRgTcIV4Qw4f8a5kJPS8+0P1FMniN
         Cx//8TvrOkyGw2tKW1PcbS3IrKIERgWXxzby81JV/e95HYjy6lZpBWvRN3bF97xp9Xy2
         sGQA==
X-Gm-Message-State: AO0yUKVaJQ7/TKTVr2YwZ6fJS4VXIpycJFEOY7J7xvbuFOp633J0Q2Ea
        5Vt7i4dkWFDcvkL8SHQCvLE=
X-Google-Smtp-Source: AK7set8PnnaHY69gD2OKAL0ztcViyUrp2etiqfpbLNgRfywSwSZVAEWJ3lb7LBYA8pKHcI9G7WHLZg==
X-Received: by 2002:a62:5c5:0:b0:5a8:a82a:bd8b with SMTP id 188-20020a6205c5000000b005a8a82abd8bmr390442pff.20.1677535331278;
        Mon, 27 Feb 2023 14:02:11 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id p18-20020a62ab12000000b005ae02dc6285sm4643759pff.203.2023.02.27.14.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 14:02:10 -0800 (PST)
Date:   Mon, 27 Feb 2023 14:02:09 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 050/113] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Message-ID: <20230227220209.GP4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <7a0fb2a0dddc87fb8d34d5af8fc73b288dbcc63c.1673539699.git.isaku.yamahata@intel.com>
 <20230217102747.00001d7f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230217102747.00001d7f@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 10:27:47AM +0200,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Thu, 12 Jan 2023 08:31:58 -0800
> isaku.yamahata@intel.com wrote:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Some KVM MMU operations (dirty page logging, page migration, aging page)
> > aren't supported for private GFNs (yet) with the first generation of TDX.
> > Silently return on unsupported TDX KVM MMU operations.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     |  3 +++
> >  arch/x86/kvm/mmu/tdp_mmu.c | 50 ++++++++++++++++++++++++++++++++++----
> >  arch/x86/kvm/x86.c         |  3 +++
> >  3 files changed, 51 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 484e615196aa..ad0482a101a3 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6635,6 +6635,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >  	for_each_rmap_spte(rmap_head, &iter, sptep) {
> >  		sp = sptep_to_sp(sptep);
> >  
> > +		/* Private page dirty logging is not supported yet. */
> > +		KVM_BUG_ON(is_private_sptep(sptep), kvm);
> > +
> >  		/*
> >  		 * We cannot do huge page mapping for indirect shadow pages,
> >  		 * which are found on the last rmap (level = 1) when not using
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 5ce0328c71df..69e202bd1897 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1478,7 +1478,8 @@ typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
> >  
> >  static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
> >  						   struct kvm_gfn_range *range,
> > -						   tdp_handler_t handler)
> > +						   tdp_handler_t handler,
> > +						   bool only_shared)
> 
> What's the purpose of having only_shared while all the callers will set it as
> true?

I dropped only_shared argument.


> >  {
> >  	struct kvm_mmu_page *root;
> >  	struct tdp_iter iter;
> > @@ -1489,9 +1490,23 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
> >  	 * into this helper allow blocking; it'd be dead, wasteful code.
> >  	 */
> >  	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> > +		gfn_t start;
> > +		gfn_t end;
> > +
> > +		if (only_shared && is_private_sp(root))
> > +			continue;
> > +
> >  		rcu_read_lock();
> >  
> > -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> > +		/*
> > +		 * For TDX shared mapping, set GFN shared bit to the range,
> > +		 * so the handler() doesn't need to set it, to avoid duplicated
> > +		 * code in multiple handler()s.
> > +		 */
> > +		start = kvm_gfn_for_root(kvm, root, range->start);
> > +		end = kvm_gfn_for_root(kvm, root, range->end);
> > +
> 
> The coco implementation tends to treat the SHARED bit / C bit as a page_prot,
> an attribute, not a part of the GFN. From that prospective, the caller needs to
> be aware if it is operating on the private memory or shared memory, so does
> the handler. The page table walker should know the SHARED bit as a attribute.
> 
> I don't think it is a good idea to have two different understandings, which
> will cause conversion and confusion.

I think you're mixing how guest observes it (guest page table) with how
host/VMM manages it(EPT).
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

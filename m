Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E6C63442B
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 19:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiKVS7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 13:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiKVS7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 13:59:12 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC9B8CB92
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 10:59:11 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w23so14520220ply.12
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 10:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VHa41opwrJC6FJ5sKuBw1d9AehzKKRE2xeFqYr0uegs=;
        b=edp+9FcNkyEQH57ave0Jmk2dBwbTiM3HwQTM82Ec+AyJ8JFOphEmZp+Xrt8VVjYj51
         DBv1/veQmAXJ/EKUPSmtDsoIrqmcDBeeww4DA68i+LyGKnVY9pHc1xZtQS5E0sk5CNYe
         wHlDumnbRY79xtFGSHBHCbK8iQlpdGI4idWiYX/XZyYQXANuOo17UOAZcIzDHtFvzgW1
         QxfrPah8v0oupwDVlZcg/MtdjT3GXELkgfIIz9i55lxgWLRTL3NQwvl8KF13nxgmqf4s
         A/4K04/NxB8LhPMKuTyMJ+BjCcqTabKZMHYmMBLsSG+PbPIWflUOfZcHTOyp4QuxJhqN
         onzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VHa41opwrJC6FJ5sKuBw1d9AehzKKRE2xeFqYr0uegs=;
        b=rbdKCKgbZ+C03smlSo6clfNTUpkvHopvJxrUJ7P2RQDqwEcVpiCBquf7TdBU111pic
         QC7G9LllC1o1KMZfG/Pa7VanXmpoKEjQ8BTY/dAJYh+yLmMmR2Sk4h7+gPJRUIzVcAax
         PZvoupBVBlw9wFmUXETzMBsAt42+pg20KmXjpXaGEF9Z1fNav5Leo9vB9kDP71hesmUP
         OI0TMiuoWIYhPTnqm1LPzVo9hUhKp23Z6bOUGn6tTg+7WqA3C+9Lk0SYg16fNZzcL443
         Btnks+Mrazw845uwysQUcnqjlAzttwM2gO84bVEQmp0gxh4ABq05y/hxZDtppHyXxx2p
         qEbw==
X-Gm-Message-State: ANoB5pmgVpGfU+JMe1Y0QEI+QBo1eee6tf2e4hw31iIfQqZvy51xjsrt
        6Gw0RPvIUavjAM3RDLeQ+ulfNQ==
X-Google-Smtp-Source: AA0mqf6oyjVLrmVsUYNpXfHVezAKb6m7rGf4m9nuPaGYIB3qsGbzzfADVGYhkDkFKHBFgaP7K8O65A==
X-Received: by 2002:a17:903:40c4:b0:188:4f86:e4ea with SMTP id t4-20020a17090340c400b001884f86e4eamr5985754pld.59.1669143550737;
        Tue, 22 Nov 2022 10:59:10 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902d50200b00177faf558b5sm12399692plg.250.2022.11.22.10.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 10:59:10 -0800 (PST)
Date:   Tue, 22 Nov 2022 18:59:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH v2 07/16] KVM: Store gfn_to_pfn_cache length as an
 immutable property
Message-ID: <Y30b+sdz5OpcdCWj@google.com>
References: <20221013211234.1318131-1-seanjc@google.com>
 <20221013211234.1318131-8-seanjc@google.com>
 <f80338c90d90fcd2ae3c592c55a591b1d46e6678.camel@infradead.org>
 <Y3vNZ0Y3KUVsrFcM@google.com>
 <ac74694957b5f3af46e0668ca58388eb90ecda9e.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac74694957b5f3af46e0668ca58388eb90ecda9e.camel@infradead.org>
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

On Mon, Nov 21, 2022, David Woodhouse wrote:
> On Mon, 2022-11-21 at 19:11 +0000, Sean Christopherson wrote:
> > On Mon, Nov 21, 2022, David Woodhouse wrote:
> > > I won't fight for it, but I quite liked the idea that each user of a
> > > GPC would know how much space *it* is going to access, and provide that
> > > length as a required parameter. I do note you've added a WARN_ON to one
> > > such user, and that's great — but overall, this patch makes that
> > > checking *optional* instead of mandatory.
> > 
> > I honestly don't see a meaningful difference in this case.  The only practical
> > difference is that shoving @len into the cache makes the check a one-time thing.
> > The "mandatory" check at use time still relies on a human to not make a mistake.
> > If the check were derived from the actual access, a la get_user(), then I would
> > feel differently.
> >
> > Case in point, the mandatory check didn't prevent KVM from screwing up bounds
> > checking in kvm_xen_schedop_poll().  The PAGE_SIZE passed in for @len is in no
> > way tied to actual access that's being performed, the code is simply regurgitating
> > the size of the cache.
> 
> True, but that's a different class of bug, and the human needs to make
> a more *egregious* mistake.
> 
> If the function itself writes outside the size that *it* thinks *it's*
> going to write, right there and then in that function, that's utterly
> hosed (and the SCHEDOP_poll thing was indeed so hosed).

Yes, such mistakes are more egregious in the sense they are harder to find and
have more severe consequences, but I don't think the mistakes are necessarily
harder to make.  Bugs in simple usage patterns are easy to spot, but at the same
time they're also less likely to be buggy because they're simpler.

> The mandatory check *did* save us from configuring a 32-bit runstate
> area at the end of a page, then *writing* to it in 64-bit mode (where
> it's larger) and running off the end of the page.

Only because the length/capacity wasn't immutable, i.e. that particilar bug couldn't
have been introduced in the first place if kvm_gpc_activate() was the only "public"
API that allowed "changing" the length.

That's really what I dislike.  I have no objection to adding a sanity check, what
I think is broken and dangerous is allowing a gpc->gpa to effectively become valid
by refreshing with a smaller length.

The gfn_to_hva_cache APIs have the same problem, but they get away with it because
they don't support concurrent usage and don't have to deal with invalidation events.

Lastly, if we keep "length" then we also need to keep "gpa", otherwise the resulting
API is all kinds of funky.

E.g. I'd be totally ok with something like this that would allow users to opt-in
to sanity checking their usage.

int __kvm_gpc_lock(struct gfn_to_pfn_cache *gpc)
{
	int r;

	read_lock_irqsave(&gpc->lock, gpc->flags);

	while (kvm_gpc_check(gpc)) {
                 read_unlock_irqrestore(&gpc->lock, gpc->flags);

                 r = kvm_gpc_refresh(gpc);
		 if (r)
                         return r;

                 read_lock_irqsave(&gpc->lock, gpc->flags);
	}

	return 0;
}

int kvm_gpc_lock(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
{
	if (WARN_ON_ONCE(gpa < gpc->gpa || (gpa + len > PAGE_SIZE) ||
			 ((gpa & PAGE_MASK) != (gpc->gpa & PAGE_MASK)))
		return -EINVAL;	

	return __kvm_gpc_lock(gpc);
}


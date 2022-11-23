Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110F3636574
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbiKWQKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238964AbiKWQKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:10:14 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90876C8CAF
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:10:10 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 6so17136720pgm.6
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E1eI9brWjhX1/u8k57pO+IlEktaaWD7yWOq6SlDlLa0=;
        b=M4xCLGz/AgJ8qWpUQR3tTMs5C4GVoOOpZYfdefEfPEmWLUjGe5WxOfXqKdJuysyQL1
         Vond/Y3UbXCheqThAZKCn/6RPlBbiTyEJmvEZK1qRBtkTM84Ko6KobXE02BNeB/BdqDn
         HbEvoDrfv25iu2FsWah1p2yjXD8eytPxn3LYyPkAzr6o49NpPhlPc/AO77ZOJxU2rbk7
         tB4aWbBbuTfuiYxsah1SqVaQd1LjG2oh/HYtWxx0h0vMdD2ilbIbypOYhOrft2ReMMu0
         ou+bwxHYauqoFjKwJzHKy3lZmbXYo3gUW27NcCmhWc552GYv7+9O8/EgH1c+cYojRctc
         WL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E1eI9brWjhX1/u8k57pO+IlEktaaWD7yWOq6SlDlLa0=;
        b=Y72GKk8hlAw+DbtGJZspQnjKP0UXpk6kJrghgZLufgk8tb7ZyGeuVx8r3stAIDolzG
         WprmK/W1bj71/soOn6bp0qISpm0ZYCAxqJJlcZ5acxlCTjxLKvM3MVqyU1X1/hYwSIX3
         KLFyPOCV+qvRg9VwnZDeLclGIO6pB2fC7phkp50NAvJgFPtfn6pvKuUoFnn02G7mdMi3
         ZTIcg12ZF1kpWcTkQ0wOIJLNuO27UcYzhYDyME5CUCjRlMkx8KibRaj+Pqr6QFFGFXzB
         eKmFTzTb28U6+RV3uCMldJ1hY8xUGod2N9ccauWVk8TC7gfrv8cPC0PZRqGqQWm/NWGD
         c2xQ==
X-Gm-Message-State: ANoB5pnz6loIlVHBRNMXUpvAuYoiVkAPQ/bu+bM+7Xt3qWbkpSmlinPI
        +mzuP7xQWJ2R5sTc90Tx+oMDMWsblrc97g==
X-Google-Smtp-Source: AA0mqf7NjVc0qj+jRskVmjGyQFeUcRm3cT4v1RPHALqZGXfP0n5ksiShgQ1mcFW++YWZl3WELPXf/A==
X-Received: by 2002:a63:1f21:0:b0:46b:2bd4:f298 with SMTP id f33-20020a631f21000000b0046b2bd4f298mr10534858pgf.135.1669219809836;
        Wed, 23 Nov 2022 08:10:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t21-20020a17090ae51500b0021894e92f82sm1596297pjy.36.2022.11.23.08.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 08:10:09 -0800 (PST)
Date:   Wed, 23 Nov 2022 16:10:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: Update gfn_to_pfn_cache khva when it moves
 within the same page
Message-ID: <Y35F3avCeh4mfP/F@google.com>
References: <20221123002030.92716-1-dwmw2@infradead.org>
 <20221123002030.92716-3-dwmw2@infradead.org>
 <199eac0011241e68d7c42b713652861e924c4472.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <199eac0011241e68d7c42b713652861e924c4472.camel@infradead.org>
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

On Wed, Nov 23, 2022, David Woodhouse wrote:
> On Wed, 2022-11-23 at 00:20 +0000, David Woodhouse wrote:
> > From: David Woodhouse <dwmw@amazon.co.uk>
> > 
> > In the case where a GPC is refreshed to a different location within the
> > same page, we didn't bother to update it. Mostly we don't need to, but
> > since the ->khva field also includes the offset within the page, that
> > does have to be updated.
> > 
> > Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
> 
> Hm, wait. That commit wasn't actually broken because at that point the
> page offset was included in the uhva too, so the uhva *did* change and
> we'd (gratuitously) take the slower path through hva_to_pfn_retry()
> when the GPA moved within the same page.
> 
> So I think this should actually be:
> 
> Fixes: 3ba2c95ea180 ("KVM: Do not incorporate page offset into gfn=>pfn cache user address")

Ya.

> Which means it's only relevant back to v6.0 stable, not all the way
> back to v5.17.

Probably a moot point in the long run since that commit was tagged for stable@
too, in order to simplify the fixes that followed.

> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > Reviewed-by: Paul Durrant <paul@xen.org>
> > Cc: stable@kernel.org
> > 
> > ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> >  virt/kvm/pfncache.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> > index bd4a46aee384..5f83321bfd2a 100644
> > --- a/virt/kvm/pfncache.c
> > +++ b/virt/kvm/pfncache.c
> > @@ -297,7 +297,12 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
> >  	if (!gpc->valid || old_uhva != gpc->uhva) {
> >  		ret = hva_to_pfn_retry(kvm, gpc);
> >  	} else {
> > -		/* If the HVA→PFN mapping was already valid, don't unmap it. */
> > +		/*
> > +		 * If the HVA→PFN mapping was already valid, don't unmap it.
> > +		 * But do update gpc->khva because the offset within the page
> > +		 * may have changed.
> > +		 */
> > +		gpc->khva = old_khva + page_offset;

If/when we rework the APIs, another possible approach would be to store only the
the page aligned address, e.g. force the user to pass in offset+len by doing
something like:


	r = kvm_gpc_lock(...);
	if (r)
		return r;

	my_struct = kvm_gpc_kmap(..., offset, len);

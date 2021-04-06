Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A3B355F9A
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 01:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhDFXkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 19:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbhDFXiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 19:38:54 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C242C06174A
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 16:38:44 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t23so5572506pjy.3
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 16:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xKeokKE1kz1HEO0UnYt1mqZsLpF9x5qqu5MSWBkuwBA=;
        b=E6pWWfAN7lEHcTqU/cKkCPAQd2WXfKOq8bwVWhym88UzIeALEz8Yf3Y7Oj7iKZx8cz
         mdCwjxbwWwweuu3aqUkLU2XDnIUZlQ6BKYJeVF1c7P59fFrl/eN1tfQVceFi86iQFgyS
         2w9ylfPVhEblzLJRcuevzasIbUjpCXQVe/wKCLxhWuZPkjGsMkgcYHwIlW6xudV0i+jO
         BpCqZcuDOtNHydp+LWKF8N6olLadL/gHYjkMrvOz++ZKNJw83BU9/bno1ZMHUSx44RP3
         OREMWWcAMuKaw87Yf9OziLQ3MhXlQP+iErZEALQ+KuMc9IjYy2e38Kz3aakjZj0/CO88
         aAUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xKeokKE1kz1HEO0UnYt1mqZsLpF9x5qqu5MSWBkuwBA=;
        b=OK53sSjo1fGIin1jGpoDBgJ1jUZzmcOR42b7BSNrIQGFqTZTv3/9yaedJONgLHajJP
         Sz/38YGzRNSMhUzvch+AINTbEYdt0VdRG7t2BlooAm1M5PRfv0180NvDyfn7cOxfVCLN
         FbUu/IZf7qItnzAJt3mfP3UT9rT6hXhrNde2zF9I3Es2X+qS2dMonfw/KKQHKGgnSI4X
         7unAYlQMMiZv5x/m3XArGQJZZlhUvPTl/i+zQUZn5FMiJo33/ng3NNt9nJyhzjWguyVi
         wFhlk7OoM1PLgWvHNfRh6MFPrjzAoOuLkWDdS0iI7RcET9TpCjxJqSMLrgajUkmPwz5a
         U9aQ==
X-Gm-Message-State: AOAM532wJfeIrpdWk/uCnAFukS1YYVbfz3BI4CxxD8Cq/tRRkB3I4Kve
        OJaNqaNgnE0szjInuv/gSj1NZJEWYZZbpA==
X-Google-Smtp-Source: ABdhPJyv6iDzPjqW36UJoRENw1GDU+MFhkdND3HAlMFiNu7p5+XFnIQ1JzH767P4R342Bei5MQnsBg==
X-Received: by 2002:a17:902:ea10:b029:e8:e2e9:d9a5 with SMTP id s16-20020a170902ea10b02900e8e2e9d9a5mr487503plg.22.1617752324049;
        Tue, 06 Apr 2021 16:38:44 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id g3sm18664540pfk.186.2021.04.06.16.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 16:38:43 -0700 (PDT)
Date:   Tue, 6 Apr 2021 23:38:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: MMU: protect TDP MMU pages only down to required
 level
Message-ID: <YGzw/77+zCNri22Z@google.com>
References: <20210402121704.3424115-1-pbonzini@redhat.com>
 <8d9b028b-1e3a-b4eb-5d44-604ddab6560e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d9b028b-1e3a-b4eb-5d44-604ddab6560e@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021, Keqian Zhu wrote:
> Hi Paolo,
> 
> I'm just going to fix this issue, and found that you have done this ;-)

Ha, and meanwhile I'm having a serious case of deja vu[1].  It even received a
variant of the magic "Queued, thanks"[2].  Doesn't appear in either of the 5.12
pull requests though, must have gotten lost along the way.

[1] https://lkml.kernel.org/r/20210213005015.1651772-3-seanjc@google.com
[2] https://lkml.kernel.org/r/b5ab72f2-970f-64bd-891c-48f1c303548d@redhat.com

> Please feel free to add:
> 
> Reviewed-by: Keqian Zhu <zhukeqian1@huawei.com>
> 
> Thanks,
> Keqian
> 
> On 2021/4/2 20:17, Paolo Bonzini wrote:
> > When using manual protection of dirty pages, it is not necessary
> > to protect nested page tables down to the 4K level; instead KVM
> > can protect only hugepages in order to split them lazily, and
> > delay write protection at 4K-granularity until KVM_CLEAR_DIRTY_LOG.
> > This was overlooked in the TDP MMU, so do it there as well.
> > 
> > Fixes: a6a0b05da9f37 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
> > Cc: Ben Gardon <bgardon@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index efb41f31e80a..0d92a269c5fa 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5538,7 +5538,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> >  	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
> >  				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
> >  	if (is_tdp_mmu_enabled(kvm))
> > -		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
> > +		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
> >  	write_unlock(&kvm->mmu_lock);
> >  
> >  	/*
> > 

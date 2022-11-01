Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373F56153BD
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 22:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiKAVHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 17:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiKAVHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 17:07:35 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D798C1DA6C
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 14:07:34 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id p3so14713950pld.10
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 14:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFX3TjIuKKqYykGd6uzPpB/gicyMyYF9f2ih7JzKNRQ=;
        b=nBxrbawSkasV5OIFis4uRsM+ydVhwdbUYy7S1Z3udwJaID7FVoII4y3e2Y6NcN+RFh
         lZp3bFFxhaissiuG6SA1KtcxUPcOTyxEnfs3GW5mwTdPgGenTxv71EwIcLPnJ5aI0kQL
         dTkinmMWMPJlBd1h4MrEs6dFRGDXU5ZWycVzIeEZRmebSIxux39oV0pjFOaqEEMwW3PI
         mdWnXqnGBZe7Y4JMXHIAhJSV70YC2ZZS7M8HJAu/hH0IOh/jqS9KEtS1DxLpUlDaT2HB
         iwxcgPifN/nh2CZXcMCvRbDSp/gibhS85slcsL0bNnD/E/hPfgU1EdRvi82v6+YKObPV
         7Xzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oFX3TjIuKKqYykGd6uzPpB/gicyMyYF9f2ih7JzKNRQ=;
        b=ibGJ2QQnwKMZ9RjuBAdzsLHtpDdPkGcYA/2P5Fypxx1H6SmrC0y+XdvSuXe1++bZCa
         5IIufHxGw7x+K+d9GI6ZH2/elKVUaYHBj2vx78ZQZdXZ03h2YihebFXqpMxIyZMx71L6
         lz8FatLxqi/W6z41kghTf+IMlLOik8R2JxWuxO7/6QN8fEGeWrWFYzYgCsg/NAEECvxM
         HHLVPE8f/8UVZlujPTetwpESbppR9Q+3MMcYKms+fUFBQSuDZNOgwHTXByTkuLnj7bx5
         CDVkhwowPiB81ezlcFum2/chPYQR22bYb1VkVCjgk+a3ChcKu9H/bg9eM1zIWLMR/cL5
         0Lng==
X-Gm-Message-State: ACrzQf36Ce/pOKaPfMY/zQkJvq+wwWRRBcdMreeAJpVSIm2QbgVgSv6u
        JsI8WGs8b/ljclT/piho1A4AIg==
X-Google-Smtp-Source: AMsMyM7wcyEL7piFmVnE/Id8mKnk5QFETXWa137oLbYLhxqiM7qCfR6bO73L99JU47mjSsviqexCHw==
X-Received: by 2002:a17:90a:9bc7:b0:213:9d21:b0b0 with SMTP id b7-20020a17090a9bc700b002139d21b0b0mr22261185pjw.26.1667336854224;
        Tue, 01 Nov 2022 14:07:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q3-20020a635c03000000b00460d89df1f1sm6321288pgb.57.2022.11.01.14.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 14:07:33 -0700 (PDT)
Date:   Tue, 1 Nov 2022 21:07:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 09/15] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <Y2GKkvMWTHfuPf4Y@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-10-oliver.upton@linux.dev>
 <Y2GBVML5MWXZE9Na@google.com>
 <Y2GFliAVxui9VyK2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2GFliAVxui9VyK2@google.com>
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

On Tue, Nov 01, 2022, Oliver Upton wrote:
> On Tue, Nov 01, 2022 at 08:28:04PM +0000, Sean Christopherson wrote:
> > On Thu, Oct 27, 2022, Oliver Upton wrote:
> > > There is no real urgency to free a stage-2 subtree that was pruned.
> > > Nonetheless, KVM does the tear down in the stage-2 fault path while
> > > holding the MMU lock.
> > > 
> 
> [ copy ]
> 
> > This is _very_ misleading.  The above paints RCU as an optimization of sorts to
> > avoid doing work while holding mmu_lock.  Freeing page tables in an RCU callback
> > is _required_ for correctness when allowing parallel page faults to remove page
> > tables, as holding mmu_lock for read in that case doesn't ensure no other CPU is
> > accessing and/or holds a reference to the to-be-freed page table.
> 
> Agree, but it is still important to reason about what is changing here
> too. Moving work out of the vCPU fault path _is_ valuable, though
> ancillary to the correctness requirements.

Sure, but that's at best a footnote.  Similar to protecting freeing, RCU isn't
the only option for moving work out of the vCPU fault path.  In fact, it's probably
one of the worst options because RCU callbacks run with soft IRQs disabled, i.e.
doing _too_ much in a RCU callback is a real problem.  If RCU weren't being used
to protect readers, deferring freeing via a workqueue, kthread, etc... would work
just as well, if not better.

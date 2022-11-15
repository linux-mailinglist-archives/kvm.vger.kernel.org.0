Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8313C62A187
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 19:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiKOSro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 13:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiKOSrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 13:47:42 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C332E2F00F
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 10:47:41 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r18so14090111pgr.12
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 10:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AkKPIWHeRn4hniFMrnTGIvHiqEhhgn36keNoZHXH3oI=;
        b=hDLtK/CfhXpByl5cdJHj5fS6CRLCYmzHAAmcDFoAq0ZWMqmrPakIcZ7dyCKeczjCoU
         ijVNKn8k2kccZk6ZkpitihnY2qlj8f7j/fPfk2POgyWKHBUnkCSOh3kueO1ZX0g2IL30
         IAZEpHmHEfgTXiDQzQNlTqmTr/xibzlUqGu9uaxhaxHk8xDxgoeBTrvt0pL0N7vlKXdU
         3uAjS/AJ/zsByV84zOyxr3NkKiC6ze5xAjSZ2QbeaVlSdAW3PAoa6n0F287ykgDHtDS7
         AHuAbh6r6PuJ+clQieWCi5h1ryW4s/uVIwz//7XkCgod/d5XMjb1T6loNU4sDlNJDlsd
         wNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AkKPIWHeRn4hniFMrnTGIvHiqEhhgn36keNoZHXH3oI=;
        b=7dYwJEqM0NtT40MdoA69ReWow+wwTAS2tAILMg6+Jy5ZzrptdInYBugwR3t6MoYciL
         OaXoJVHhG/wXw8EIEdq1APZYOrrCCFxpAgKxupJGKP5o6isxKcWax+Iz8IPbkAA7tHU3
         Ml3tjZPMu7bK4MCDRd0pGqdFBqnwpdGWrGlLOgBhbgEhaSgi6U7ubSA/Ph4bo78mAKX+
         i/AOZ+acUKszftGp5NU6ILUYboXtT2hrOSxvESZZbPgmpLauT5jD+gGBfFKvHZdDSqr5
         JxA+ZfkYJpG4UxT4/rIiD4ybdcT75FIqy6qUTW0Jb1+bf7Sz2EqAqMtyHEZsJXCoigCn
         He9w==
X-Gm-Message-State: ANoB5pmnR9BAI4puFqI/m32YKNuB2GtGodZ+5thxyDu/3b6q6BfXkySv
        xpiWu7sdrAlVO9W/8/TpTsjd1w==
X-Google-Smtp-Source: AA0mqf5ewUFxFuYZmhYALZjNpcyEotKOZbibubDZGdomI5FE4JI3gXz3HN+ZL/JWRORbOZ+Q96LHew==
X-Received: by 2002:a62:bd19:0:b0:56e:a001:8cb0 with SMTP id a25-20020a62bd19000000b0056ea0018cb0mr19447236pff.60.1668538061122;
        Tue, 15 Nov 2022 10:47:41 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id o38-20020a634e66000000b004639c772878sm8147241pgl.48.2022.11.15.10.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 10:47:40 -0800 (PST)
Date:   Tue, 15 Nov 2022 10:47:37 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y3PeyV4KIjoBBYNV@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <Y2whaWo3SIOOMKOE@google.com>
 <Y2w98zPmtefJlNfa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2w98zPmtefJlNfa@google.com>
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

On Wed, Nov 09, 2022 at 11:55:31PM +0000, Oliver Upton wrote:
> On Wed, Nov 09, 2022 at 09:53:45PM +0000, Sean Christopherson wrote:
> > On Mon, Nov 07, 2022, Oliver Upton wrote:
> > > Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> > > release the RCU read lock when traversing the page tables. Defer the
> > > freeing of table memory to an RCU callback. Indirect the calls into RCU
> > > and provide stubs for hypervisor code, as RCU is not available in such a
> > > context.
> > > 
> > > The RCU protection doesn't amount to much at the moment, as readers are
> > > already protected by the read-write lock (all walkers that free table
> > > memory take the write lock). Nonetheless, a subsequent change will
> > > futher relax the locking requirements around the stage-2 MMU, thereby
> > > depending on RCU.
> > 
> > Two somewhat off-topic questions (because I'm curious):
> 
> Worth asking!
> 
> >  1. Are there plans to enable "fast" page faults on ARM?  E.g. to fixup access
> >     faults (handle_access_fault()) and/or write-protection faults without acquiring
> >     mmu_lock?
> 
> I don't have any plans personally.
> 
> OTOH, adding support for read-side access faults is trivial, I just
> didn't give it much thought as most large-scale implementations have
> FEAT_HAFDBS (hardware access flag management).

WDYT of permission relaxation (write-protection faults) on the fast
path?

The benefits won't be as good as in x86 due to the required TLBI, but
may be worth it due to not dealing with the mmu lock and avoiding some
of the context save/restore.  Note that unlike x86, in ARM the TLB entry
related to a protection fault needs to be flushed.

> 
> >  2. If the answer to (1) is "yes!", what's the plan to protect the lockless walks
> >     for the RCU-less hypervisor code?
> 
> If/when we are worried about fault serialization in the lowvisor I was
> thinking something along the lines of disabling interrupts and using
> IPIs as barriers before freeing removed table memory, crudely giving the
> same protection as RCU.
> 
> --
> Thanks,
> Oliver

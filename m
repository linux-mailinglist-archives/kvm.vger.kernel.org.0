Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DA64EFD5C
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 02:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352915AbiDBAKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 20:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349868AbiDBAKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 20:10:39 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8E22B240
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 17:08:48 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gb19so3741566pjb.1
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 17:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6QE4w2g5khQBnxb92HRg/q4BWRmfdIBuDEDmz4MpG6s=;
        b=cM4p44W+HpG7D1GTx2b7HSUtQsl0rwbFS2wlP6Q8cAes19TeMkZtSZWLDnl1wgvmQ+
         KXrQmOQtR7/xs6okhsM9XLjaVwMP+fUkkBDI9ErgbAv17IjjpKp/zoyHIVNX4cCEk7uR
         xHT5tWx8dygLZq4b3sVCa87rvou6b6ZUiEBmkikLgtDOT6gLK3Efa4TDuHYMbAyCzgSJ
         b4QHOrEX+WkTJ//pB21OtkskJs8Lz/5rtbucsHAtJsMc1k+cb9dMWtgEZbVfdVlSXtlq
         JTqR12aD1q7CFLUWEcYhOxQxPiMwkb9KaakkQ8TNBKxBCJugIJWvr8gXzpjue68tVMrk
         WfNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6QE4w2g5khQBnxb92HRg/q4BWRmfdIBuDEDmz4MpG6s=;
        b=RIwAd2tEdIPh36QBJtnL4kEbcrKn7JXN8KRsSs7cVyjGogvqIlJncfEjMAwJw+ArKn
         CUMEg+0J20SQFtyKwdsZKydJblpWtNSpdZGuL/MY3J5TOIx7PCnuOy1w4r3G1VjeBlLc
         4qLsY6KtWjILy+68eaSMFIZxOkm5Rbbw0BFZ8nSRDebcVIBkDfKcJ3N5MBVPHtLngL6n
         ETPeLp1FctsbtDMhhgetC0Xd5cfJjOHhHvAYIHsyRevy7QFY0ncgs3LWaGRpJRYDsMke
         RIWmYU6k6uiOgwNVXqWEwBp5dKDXWe1vOX4IVoL6utiKJh6B+7+GGN8T0VtTQxX0cf5T
         3+VA==
X-Gm-Message-State: AOAM533Em8nvWfYgPy50SWfong/srX28sgk/QaiTupVy2mhJ9HTwqJON
        jvRig9xTQ9YGNq5AxZoPYRQacA==
X-Google-Smtp-Source: ABdhPJzthtmq4iSAuF0g2nH0IfT9pVuq7f+MEOhY7gtmuECg++lc8OVxw4fj2pA0+NyBKk/NoUGDyg==
X-Received: by 2002:a17:903:1248:b0:151:9708:d586 with SMTP id u8-20020a170903124800b001519708d586mr13012969plh.15.1648858128229;
        Fri, 01 Apr 2022 17:08:48 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm4259169pfj.128.2022.04.01.17.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 17:08:47 -0700 (PDT)
Date:   Sat, 2 Apr 2022 00:08:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 038/104] KVM: x86/mmu: Allow per-VM override of
 the TDP max page level
Message-ID: <YkeUDJP1AWKU/ixG@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <5cc4b1c90d929b7f4f9829a42c0b63b52af0c1ed.1646422845.git.isaku.yamahata@intel.com>
 <c6fb151ced1675d1c93aa18ad8c57c2ffc4e9fcb.camel@intel.com>
 <YkcHZo3i+rki+9lK@google.com>
 <43098446667829fc592b7cc7d5fd463319d37562.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43098446667829fc592b7cc7d5fd463319d37562.camel@intel.com>
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

On Sat, Apr 02, 2022, Kai Huang wrote:
> On Fri, 2022-04-01 at 14:08 +0000, Sean Christopherson wrote:
> > On Fri, Apr 01, 2022, Kai Huang wrote:
> > > On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > 
> > > > In the existing x86 KVM MMU code, there is already max_level member in
> > > > struct kvm_page_fault with KVM_MAX_HUGEPAGE_LEVEL initial value.  The KVM
> > > > page fault handler denies page size larger than max_level.
> > > > 
> > > > Add per-VM member to indicate the allowed maximum page size with
> > > > KVM_MAX_HUGEPAGE_LEVEL as default value and initialize max_level in struct
> > > > kvm_page_fault with it.
> > > > 
> > > > For the guest TD, the set per-VM value for allows maximum page size to 4K
> > > > page size.  Then only allowed page size is 4K.  It means large page is
> > > > disabled.
> > > 
> > > Do not support large page for TD is the reason that you want this change, but
> > > not the result.  Please refine a little bit.
> > 
> > Not supporting huge pages was fine for the PoC, but I'd prefer not to merge TDX
> > without support for huge pages.  Has any work been put into enabling huge pages?
> > If so, what's the technical blocker?  If not...
> 
> Hi Sean,
> 
> Is there any reason large page support must be included in the initial merge of
> TDX?  Large page is more about performance improvement I think.  Given this
> series is already very big, perhaps we can do it later.

I'm ok punting 1gb for now, but I want to have a high level of confidence that 2mb
pages will work without requiring significant churn in KVM on top of the initial
TDX support.  I suspect gaining that level of confidence will mean getting 95%+ of
the way to a fully working code base.  IIRC, 2mb wasn't expected to be terrible, it
was 1gb support where things started to get messy.

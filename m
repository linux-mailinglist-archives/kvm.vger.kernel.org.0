Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062C4668A51
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjAMDnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbjAMDnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:43:01 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5A25792D
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:42:57 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id i1so228507pfk.3
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Xtd0yvioh58Ye+tRzyHugBT38/BBqw05Bz+SnnNowI=;
        b=fWNz1tk/5zycuFu/grWRS1t90X+SaGc2Wh3baOpYcrkSHE1YU41eznUDNBRKboV1km
         md12F8z0ly6VJR6bF9Gpt9EskoXK7vFBGa7uD05jIt2yv5sR7SixQ4+oVDZksLlM1H3h
         HCUOCS0+tmOCuULORoj/DUjpbt/5oT8evxJxM7/FErxdCHBJxFrOCctn4h+fe1eBNruo
         DLPj3UOZGWKAHtZcEm2wgLa0Xg/OAXrKTU+I8P39bt+UtBfKAdg3kQpgE3YkrRZquTij
         9RtwDUy5Kir0hlyko8SRJZZZ7re0qBB8zXJrsCd4oA8aD9RuMjLmH0xdIIU2IN9QkyIq
         mVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Xtd0yvioh58Ye+tRzyHugBT38/BBqw05Bz+SnnNowI=;
        b=k/+bFmFRh9y0P2gHHijKkxorAuiUmBd9Q9JSEhNn4cwBPXbGpPAgo67YftsN2ftIn4
         QALFvbwnS1AKoBVTLqGBQnp6+X4bVabEzeDhhxTUCWU2KletAevkMqvs/TMpRJVq5yr8
         hmrmnqQKXbDewxPqFFY8YyqC6HTh76xoUkJpC7MFNvVFT89W6I7HrzfH/QfS1to+Rsaj
         GGEry6w+jw8R0RSlFYZPfvBFf9th9kJEoKKyEdyObvqJIxwlm2enhhsbGFO6wAdRASWp
         DG4PNbF6/QjlMziJHf8cbWJh4GEaJAXGjcHLuU45hFK0QSU0s7r2AT1I8CnciGN3e+tZ
         MU8w==
X-Gm-Message-State: AFqh2kq0JBm1rplmPqtV2ufpy7zpD92j+XhF3/ntaYKBr5D2slOAadZD
        AriVG9XoFZ39aV958YI9Ppkbog==
X-Google-Smtp-Source: AMrXdXsfHWFCsnl0TlcNERzD11sqDYuTKKUnd2zMn16BJ2CGKBjt2rA+cp26y/YEl+NjxFfBekXwbg==
X-Received: by 2002:a05:6a00:a87:b0:582:13b5:d735 with SMTP id b7-20020a056a000a8700b0058213b5d735mr1168802pfl.0.1673581376966;
        Thu, 12 Jan 2023 19:42:56 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id u14-20020a63ef0e000000b0046feca0883fsm10777204pgh.64.2023.01.12.19.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 19:42:56 -0800 (PST)
Date:   Thu, 12 Jan 2023 19:42:52 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, kvmarm@lists.linux.dev,
        ricarkol@gmail.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] KVM: arm64: Eager huge-page splitting for
 dirty-logging
Message-ID: <Y8DTPPv+c7injA1b@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <Y3KMHGvIEuwhU1wS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3KMHGvIEuwhU1wS@google.com>
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

On Mon, Nov 14, 2022 at 06:42:36PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Sat, Nov 12, 2022 at 08:17:02AM +0000, Ricardo Koller wrote:
> > Hi,
> > 
> > I'm sending this RFC mainly to get some early feedback on the approach used
> > for implementing "Eager Page Splitting" on ARM.  "Eager Page Splitting"
> > improves the performance of dirty-logging (used in live migrations) when
> > guest memory is backed by huge-pages.  It's an optimization used in Google
> > Cloud since 2016 on x86, and for the last couple of months on ARM.
> > 
> > I tried multiple ways of implementing this optimization on ARM: from
> > completely reusing the stage2 mapper, to implementing a new walker from
> > scratch, and some versions in between. This RFC is one of those in
> > between. They all have similar performance benefits, based on some light
> > performance testing (mainly dirty_log_perf_test).
> > 
> > Background and motivation
> > =========================
> > Dirty logging is typically used for live-migration iterative copying.  KVM
> > implements dirty-logging at the PAGE_SIZE granularity (will refer to 4K
> > pages from now on).  It does it by faulting on write-protected 4K pages.
> > Therefore, enabling dirty-logging on a huge-page requires breaking it into
> > 4K pages in the first place.  KVM does this breaking on fault, and because
> > it's in the critical path it only maps the 4K page that faulted; every
> > other 4K page is left unmapped.  This is not great for performance on ARM
> > for a couple of reasons:
> > 
> > - Splitting on fault can halt vcpus for milliseconds in some
> >   implementations. Splitting a block PTE requires using a broadcasted TLB
> >   invalidation (TLBI) for every huge-page (due to the break-before-make
> >   requirement). Note that x86 doesn't need this. We observed some
> >   implementations that take millliseconds to complete broadcasted TLBIs
> >   when done in parallel from multiple vcpus.  And that's exactly what
> >   happens when doing it on fault: multiple vcpus fault at the same time
> >   triggering TLBIs in parallel.
> > 
> > - Read intensive guest workloads end up paying for dirty-logging.  Only
> >   mapping the faulting 4K page means that all the other pages that were
> >   part of the huge-page will now be unmapped. The effect is that any
> >   access, including reads, now has to fault.
> > 
> > Eager Page Splitting (on ARM)
> > =============================
> > Eager Page Splitting fixes the above two issues by eagerly splitting
> > huge-pages when enabling dirty logging. The goal is to avoid doing it while
> > faulting on write-protected pages. This is what the TDP MMU does for x86
> > [0], except that x86 does it for different reasons: to avoid grabbing the
> > MMU lock on fault. Note that taking care of write-protection faults still
> > requires grabbing the MMU lock on ARM, but not on x86 (with the
> > fast_page_fault path).
> > 
> > An additional benefit of eagerly splitting huge-pages is that it can be
> > done in a controlled way (e.g., via an IOCTL). This series provides two
> > knobs for doing it, just like its x86 counterpart: when enabling dirty
> > logging, and when using the KVM_CLEAR_DIRTY_LOG ioctl. The benefit of doing
> > it on KVM_CLEAR_DIRTY_LOG is that this ioctl takes ranges, and not complete
> > memslots like when enabling dirty logging. This means that the cost of
> > splitting (mainly broadcasted TLBIs) can be throttled: split a range, wait
> > for a bit, split another range, etc. The benefits of this approach were
> > presented by Oliver Upton at KVM Forum 2022 [1].
> > 
> > Implementation
> > ==============
> > Patches 1-4 add a pgtable utility function for splitting huge block PTEs:
> > kvm_pgtable_stage2_split(). Patches 5-6 add support for not doing
> > break-before-make on huge-page breaking when FEAT_BBM level 2 is supported.
> 
> I would suggest you split up FEAT_BBM=2 and eager page splitting into
> two separate series, if possible. IMO, the eager page split is easier to
> reason about if it follows the existing pattern of break-before-make.

Dropping these changes in v1.

> 
> --
> Thanks,
> Oliver

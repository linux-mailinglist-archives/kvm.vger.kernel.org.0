Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388D47B2B22
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 07:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjI2FT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 01:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjI2FT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 01:19:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5209F195;
        Thu, 28 Sep 2023 22:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cpgFGTRKol3innmX8XmdcZJuEeuKQeErqp+5XpFli3I=; b=pZRSf9RRi7urYT84dyvRo1E07p
        9Wt1WF30w0rXzjfZTLieIVe3eFpqBtsTSu2Ql4OhtHcNUIjjKH3R9+ATJu2QE6Zp8IUTna84VyPEr
        hQtPKtDmMDuQU4fQaQB5Bc+D/DYGbivWVOwmEy5Fwv3EcsUEvZpVD+b6TYBTWvBFZWu1atoGH3oRs
        ZqTMCE7dia+WFUlkgaSHUz0lNhhegd+CqjXIIe/kOgkAWWz6mkzWaZpxsv2CFOH7zK81EA54Dn1ak
        Blwoaw6RYZPjBpOgXO1woiytJ5gHmw5mRjMi0ECOthIPx0Vi5nCdigGSd9UmsueyCS+a6YSS1w4Xo
        Pq/6/oPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qm5ua-007A1z-2i;
        Fri, 29 Sep 2023 05:19:36 +0000
Date:   Thu, 28 Sep 2023 22:19:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
Message-ID: <ZRZeaP7W5SuereMX@infradead.org>
References: <20230911021637.1941096-1-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911021637.1941096-1-stevensd@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023 at 11:16:30AM +0900, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> that is backed by struct pages that aren't currently being refcounted
> (e.g. tail pages of non-compound higher order allocations) into the
> guest.
> 
> Our use case is virtio-gpu blob resources [1], which directly map host
> graphics buffers into the guest as "vram" for the virtio-gpu device.
> This feature currently does not work on systems using the amdgpu driver,
> as that driver allocates non-compound higher order pages via
> ttm_pool_alloc_page.
> 
> First, this series replaces the __gfn_to_pfn_memslot API with a more
> extensible __kvm_faultin_pfn API. The updated API rearranges
> __gfn_to_pfn_memslot's args into a struct and where possible packs the
> bool arguments into a FOLL_ flags argument. The refactoring changes do
> not change any behavior.

Instead of adding hacks to kvm you really should fix the driver / TTM
to not do weird memory allocations.


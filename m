Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3037B4B6B
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 08:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbjJBGZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 02:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjJBGZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 02:25:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A026CB4;
        Sun,  1 Oct 2023 23:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=InW3sf1bK5Wc2jmOSnsvmSrnjzk2Pzj04pfxMdYCcWw=; b=KeC8/ODHqVRyPLLWTzKg4B/RiX
        fPBt0w/lD4S8/QIqpD+hkjWXG/ZRlw2awKa7EeCDakGqfaUYsRpXLfLIdnX5ZdhHACB5v+HSFdHhy
        6SU/hpjWN+8azZT5kEBsea/MFxaP6zhO5asfb3UYYjJOIASgSWpozEbgmEg69rOgtS/MtbcK6hwY8
        9zXkZzVH3S1k4EE42GznSO6OYLokbZGqWmuEyYIJ/hhSAXHXxRhW+/ITDrnSwQ2JZk6zvwl8r09q/
        x42JUrQIjBGe7n/CXpq9oUwMZyaxAf93dytavaeVE5nDl7wbV8TVh7N39BOluX0nUYe8bEVnl2rGi
        q4KhlGZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qnCN4-00C1Xw-0I;
        Mon, 02 Oct 2023 06:25:34 +0000
Date:   Sun, 1 Oct 2023 23:25:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        David Stevens <stevensd@chromium.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
Message-ID: <ZRpiXsm7X6BFAU/y@infradead.org>
References: <20230911021637.1941096-1-stevensd@google.com>
 <ZRZeaP7W5SuereMX@infradead.org>
 <ZRb2CljPvHlUErwM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRb2CljPvHlUErwM@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023 at 09:06:34AM -0700, Sean Christopherson wrote:
> KVM needs to be aware of non-refcounted struct page memory no matter what; see
> CVE-2021-22543 and, commit f8be156be163 ("KVM: do not allow mapping valid but
> non-reference-counted pages").  I don't think it makes any sense whatsoever to
> remove that code and assume every driver in existence will do the right thing.

Agreed.

> 
> With the cleanups done, playing nice with non-refcounted paged instead of outright
> rejecting them is a wash in terms of lines of code, complexity, and ongoing
> maintenance cost.

I tend to strongly disagree with that, though.  We can't just let these
non-refcounted pages spread everywhere and instead need to fix their
usage.

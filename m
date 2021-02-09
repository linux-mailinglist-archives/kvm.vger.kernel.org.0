Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE40E314A27
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 09:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhBIIUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 03:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhBIIUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 03:20:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD3CC061786;
        Tue,  9 Feb 2021 00:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9uWgJ+v5vWmWbn6IhnIBEUxC12yK4PpumRt98hOKJT4=; b=NjRkMhTlaHLW2DlBW0VXVvVqFs
        s8gsPeTNHsrxlLhJnydn3X3PwN7K88jddVKA40VE9ydzrQb8KKVzNxRZIiGr9J21SEHRz3zIGG+O2
        9J+v/kVxeyfqX6S948ui/SsF1wOAYv1SgTdvGv/GKC8qDkaAERAnWdZ3AESrl5eEHqL5ARIMqZDNR
        FLrpmO4qu8mxq4VsSId5Lx18XIaAMX09mfM1XCv7W0xjT91KQ6LLjRscfJJMIWkix7xZyoUDlaNMs
        VjmBYmVK7mK6zlwnzh3hbUbpf9YokrCsW0zaP/B9JiWz8n1Cx2uNhhjs6fiw4gyYBT+30SaIpkpkS
        /cuOJdQA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9OFT-0079an-ER; Tue, 09 Feb 2021 08:19:51 +0000
Date:   Tue, 9 Feb 2021 08:19:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Peter Xu <peterx@redhat.com>, dan.j.williams@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] KVM: do not assume PTE is writable after follow_pfn
Message-ID: <20210209081951.GA1704636@infradead.org>
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205181411.GB3195@xz-x1>
 <20210208185133.GW4718@ziepe.ca>
 <20210208220259.GA71523@xz-x1>
 <20210208232625.GA4718@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208232625.GA4718@ziepe.ca>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021 at 07:26:25PM -0400, Jason Gunthorpe wrote:
> > > page_mkclean() has some technique to make the notifier have the right
> > > size without becoming entangled in the PTL locks..
> > 
> > Right.  I guess it's because dax doesn't have "struct page*" on the
> > back, so it
> 
> It doesn't? I thought DAX cases did?

File system DAX has a struct page, device DAX does not.  Which means
everything using iomap should have a page available, but i'm adding
Dan as he should know the details :)

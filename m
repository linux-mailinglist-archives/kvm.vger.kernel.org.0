Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177FE7A2574
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 20:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjIOSSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 14:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbjIOSSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 14:18:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C1E1FD7;
        Fri, 15 Sep 2023 11:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IZ/9ERMD1BXqY95VFvXjlfOuZqoMJEOwgTSIpzzRviw=; b=kXs/rKPpldhZt2Fy5p1oCe7PlF
        l/MgRT9cyliL8/TeECOPaIxyP9fFf4AGuQhw4Jp/bInA/rIaaZAa/uhdNc0gkBVpEVVsypd8ljkeo
        TR0z3xBskjfPSDiZzVsuBsAoxFiVdTk8nqU/Dq76azj5ikZdOe3sqF1wtjK+JrWI9elDIRy8aQMcn
        2XIOrnuP/MbNL1zopokoVyrw3HHMUoi2aPLl+BkfATkgtW8uzapQd3BLNSE55LoAWYKnblUTsIafk
        3cGFF8kYoaL6rEVWF3W7qLoNHK9yvzBv08ydcHs2lq4f9+Xmh0hRsPtlIdk14hrrykDXIXNRLZw6k
        LC57XZBg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qhDO3-00BGn6-Hc; Fri, 15 Sep 2023 18:17:51 +0000
Date:   Fri, 15 Sep 2023 19:17:51 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] Use arch_make_folio_accessible() everywhere
Message-ID: <ZQSfz1Kx9/QhN64E@casper.infradead.org>
References: <20230915172829.2632994-1-willy@infradead.org>
 <20230915195450.1fd35f48@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915195450.1fd35f48@p-imbrenda>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023 at 07:54:50PM +0200, Claudio Imbrenda wrote:
> On Fri, 15 Sep 2023 18:28:25 +0100
> "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:
> 
> > We introduced arch_make_folio_accessible() a couple of years
> > ago, and it's in use in the page writeback path.  GUP still uses
> > arch_make_page_accessible(), which means that we can succeed in making
> > a single page of a folio accessible, then fail to make the rest of the
> > folio accessible when it comes time to do writeback and it's too late
> > to do anything about it.  I'm not sure how much of a real problem this is.
> > 
> > Switching everything around to arch_make_folio_accessible() also lets
> > us switch the page flag to be per-folio instead of per-page, which is
> > a good step towards dynamically allocated folios.
> 
> if I understand correctly, this will as a matter of fact move the
> security property from pages to folios.

Correct.

> this means that trying to access a page will (try to) make the whole
> folio accessible, even though that might be counterproductive.... 
> 
> and there is no way to simply split a folio
> 
> I don't like this

As I said in the cover letter, we already make the entire folio
accessible in the writeback path.  I suppose if you never write the
folio back, this is new ...

Anyway, looking forward to a more substantial discussion on Monday.

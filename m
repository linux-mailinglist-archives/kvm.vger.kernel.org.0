Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D3929E829
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 11:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJ2KCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 06:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgJ2KCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 06:02:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4CCC0613CF;
        Thu, 29 Oct 2020 03:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bJJQrkz2DmvsLC/KQQtP+/G8oJcKg1SqkvfvGBG1Kis=; b=UIAwvXhE7HjAKmjqXHhRLl9xIu
        KdZK7e/fqvMm7rw2C3LqAZWCEoNoruvvPKUgUOyoKN58s/OwdGeINy+HwrgeVqArnWnrWryUY+jb2
        royGa8LcqCMYxcXyw6E3NTJ5qcor1MUKOfrLFe6lmKdBULXWQ/gsxFST+ILBM5vpMTfivLaMPZ0n+
        lwNr6d0yKwrW/JY6j7owx/oU7GPyKNkMlHL34diDPWpyASCTiVyUcN8P0tll8Al92jhTzzyoPZ7TQ
        SPduM45A4CaJpZqoSz2G8kug/654kfdn1ADp01H/bNB0YIohiOR0lAbAAi2em9I40rFtMfTVnxd9Z
        XBUKi7SQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4kn-0002hM-SZ; Thu, 29 Oct 2020 10:01:57 +0000
Date:   Thu, 29 Oct 2020 10:01:57 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Christoph Hellwig <hch@infradead.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v4 00/15] follow_pfn and other iomap races
Message-ID: <20201029100157.GA10041@infradead.org>
References: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
 <20201029085749.GB25658@infradead.org>
 <CAKMK7uEV7sQ48w1Dd=WCY1r6LrY+aEq3ASnouOebQoo=Zr=CTQ@mail.gmail.com>
 <20201029092800.GA494@infradead.org>
 <CAKMK7uG=R2372bVTK1Zh+P7uRd2QJSw5EgcJ6JJwVtNyJ7SJtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uG=R2372bVTK1Zh+P7uRd2QJSw5EgcJ6JJwVtNyJ7SJtQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29, 2020 at 10:38:16AM +0100, Daniel Vetter wrote:
> Hm so Jason and me discussed this, but e.g. the s390 is safe with with
> just the pagetable locks. So we'd need two versions.
> 
> The more practical problem is that I haven't found a reasonable way to
> check that a passed in mmu_notifier is registered against the mm we're
> working on, and without that check it feels a bit silly. But if you
> see how to do that I think we can do an EXPORT_SYMBOL_GPL follow_pfn
> which takes the notifier, and an __follow_pfn for s390 and similar
> internal code which isn't exported.

True, this is a bit of a mess.  So maybe just rename it to __follow_pfn,
proper documentation of the requirements and a switch to
EXPORT_SYMBOL_GPL.

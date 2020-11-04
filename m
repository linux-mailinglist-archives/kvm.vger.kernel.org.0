Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C740E2A6D94
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 20:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgKDTLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 14:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730505AbgKDTLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 14:11:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A75C0613D4;
        Wed,  4 Nov 2020 11:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tL7XJijJaQjwTxWIpvyG0Z04LWofXKLSq0OiO7y+/KA=; b=NPG7qtUMlTa1nWx/dCiRtjrzAm
        uvzvL11rz1BkIY9c3sFCvwoAyhFSgnKDU6wYsP4jtzxXvHAHRcThjSR0QdGNZxURF5/Mnv6jv9A6j
        rZFIt3dys+tq3zDRu9IWpCB3VIPl4XqTlerWjLqykkYXKSq/1Iwb8njh4S3bKbHlIkuajXoZqXzXN
        lxPIETsCwT6aD/XHXbgyolg4DLvnRF59IVxRmDyfMyBCPMkU+qPasSUP83dld7ZXkjefdZWM+3dht
        MLZq0SxVmAJ5A0wpbvSVKCeIY22GHZrGMo4GZpbiQ+DFONzc3IP3h9R5ozJwnoOhH5w3slCDvbMWC
        NV+PGvFQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kaOBQ-00074n-Ui; Wed, 04 Nov 2020 19:11:00 +0000
Date:   Wed, 4 Nov 2020 19:11:00 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        J??r??me Glisse <jglisse@redhat.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        KVM list <kvm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Linux MM <linux-mm@kvack.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH v5 05/15] mm/frame-vector: Use FOLL_LONGTERM
Message-ID: <20201104191100.GA25011@infradead.org>
References: <CAKMK7uEw701AWXNJbRNM8Z+FkyUB5FbWegmSzyWPy9cG4W7OLA@mail.gmail.com>
 <20201104140023.GQ36674@ziepe.ca>
 <CAKMK7uH69hsFjYUkjg1aTh5f=q_3eswMSS5feFs6+ovz586+0A@mail.gmail.com>
 <20201104162125.GA13007@infradead.org>
 <CAKMK7uH=0+3FSR4LxP7bJUB4BsCcnCzfK2=D+2Am9QNmfZEmfw@mail.gmail.com>
 <20201104163758.GA17425@infradead.org>
 <20201104164119.GA18218@infradead.org>
 <20201104181708.GU36674@ziepe.ca>
 <d3497583-2338-596e-c764-8c571b7d22cf@nvidia.com>
 <20201104190214.GW36674@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104190214.GW36674@ziepe.ca>
L:      linux-mips@vger.kernel.org
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 03:02:14PM -0400, Jason Gunthorpe wrote:
> I saw that once and I really couldn't make sense of it..
> What use is having futex's that only work on THP pages? Confused
> 
> CH said there was no case of HAVE_FAST_GUP !ARCH_HAS_PTE_SPECIAL, is
> one hidden someplace then?

ARCH_HAS_PTE_SPECIAL is selected by:

arc
arm		(if LPAE)
arm64
mips		(if !(32BIT && CPU_HAS_RIXI))
powerpc
riscv
s390
sh
sparc		(if SPARC64)
x86

HAVE_FAST_GUP is supported by:

arm		(if LPAE)
arm64
mips
powerpc
s390
sh
x86

so mips would be a candidate.  But I think only in theory, as
the options selecting CPU_HAS_RIXI do not select
CPU_SUPPORTS_HUGEPAGES.  Adding the mips maintainer to double check
my logic.

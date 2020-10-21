Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7697A295515
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 01:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507102AbgJUXU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 19:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507096AbgJUXU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 19:20:26 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95A0C0613D2
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 16:20:24 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id h19so3731544qtq.4
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 16:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b4cfx4QZgYz15NDTJwDbByQvqvRvpDxc8U181kXRfhk=;
        b=CZio0pvjUOAZVmGpPYnoIJZ3k0VTIRDxHgnxsmYuQhsz2jEdpX7JlzXAa5B1lHI4hj
         1dkeZm3vsuYQ0+al/4Q5F2/2IuJErhNsTuza+Audcu3R6UagNTTPFO2TOlLXvivwU2k/
         TKA9JSMlFjnoXG+A2LL1MAujxpBHcxjoID0aD31L+i9KzL1iVOVlTBMfml1ncQpAA1Ef
         K50QmLDH8932V/fZEd6cOcCwLbIUGXgj3Ry86gAn7SRneMoAL4zkD8ulKknh501sjbP8
         vU0trDw7S+JXN+4tdtkGwNszgrrA7N4l+RnFY0GZRBBOKZJ2H2dSIxQhc+QJQE2SJt1m
         cPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b4cfx4QZgYz15NDTJwDbByQvqvRvpDxc8U181kXRfhk=;
        b=GMsLmzMYpWif5BVNR07zcs+wVVZWx5dO6Z5knIs1p7omgyuTyArD5UZUY+PohY7l8p
         slhcgITuI1WOcSVRzgjaDpHGkdEK4Mk2rCn7tQkwnL9o2ECq/PtAhKPCdYDoNWgo5J8V
         6JB1CmRdAHx++VtaEUXJE83S+HaFbnXUqTPzE0kz8BMfgzsIR+HeCDa7zWvP9qh2T4FS
         oAlEC7ZKCQbLTYqZ+FXUzUqIueOaTRBWwvU/VEOlpLOj3e6R7v45xi8nJarxoHYtBvTb
         5EBTf3U86aMi0l0C6aOWGifEVwgqUJ7NHBu5Ssed69nrW1uLCrbQucfO2ToQ0IMwEFtL
         c0Jg==
X-Gm-Message-State: AOAM533yd+Dd7DFRYXVbzcn6NKChyj6M78r2RIylNLOe+w16U3sJK/y9
        S0gGr+MET3gXMyDnsObzeJ8OFw==
X-Google-Smtp-Source: ABdhPJylFppbCqYnSmCDnE4ueYGv0xNZzmWfiqeCGK69SNIht11gj1i8NPwvoXi//7kIPj5qPGxCVQ==
X-Received: by 2002:ac8:1c39:: with SMTP id a54mr5530504qtk.344.1603322423832;
        Wed, 21 Oct 2020 16:20:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id n63sm2410770qka.45.2020.10.21.16.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 16:20:23 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kVNP4-003k7m-9M; Wed, 21 Oct 2020 20:20:22 -0300
Date:   Wed, 21 Oct 2020 20:20:22 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.com>
Subject: Re: [PATCH v3 12/16] PCI: Obey iomem restrictions for procfs mmap
Message-ID: <20201021232022.GN36674@ziepe.ca>
References: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
 <20201021085655.1192025-13-daniel.vetter@ffwll.ch>
 <20201021125030.GK36674@ziepe.ca>
 <CAKMK7uEWe8CaT7zjcZ6dJAKHxtxtqzjVB35fCFviwhcnqksDfw@mail.gmail.com>
 <20201021151352.GL36674@ziepe.ca>
 <CAKMK7uGq0=ks7Zj1Et44k7x9FwE9u_ua4zANSqrLRri0v01V+Q@mail.gmail.com>
 <20201021163702.GM36674@ziepe.ca>
 <CAKMK7uEjE5sHUq0hV_bnYjPKRxYyBnty0sLre+owANGZjLJg9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEjE5sHUq0hV_bnYjPKRxYyBnty0sLre+owANGZjLJg9Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 09:24:08PM +0200, Daniel Vetter wrote:
> On Wed, Oct 21, 2020 at 6:37 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Wed, Oct 21, 2020 at 05:54:54PM +0200, Daniel Vetter wrote:
> >
> > > The trouble is that io_remap_pfn adjust vma->pgoff, so we'd need to
> > > split that. So ideally ->mmap would never set up any ptes.
> >
> > /dev/mem makes pgoff == pfn so it doesn't get changed by remap.
> >
> > pgoff doesn't get touched for MAP_SHARED either, so there are other
> > users that could work like this - eg anyone mmaping IO memory is
> > probably OK.
> 
> I was more generally thinking for io_remap_pfn_users because of the
> mkwrite use-case we might have in fbdev emulation in drm.

You have a use case for MAP_PRIVATE and io_remap_pfn_range()??

Jason

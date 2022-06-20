Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3156551070
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 08:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238605AbiFTGiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 02:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiFTGh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 02:37:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4BDE58;
        Sun, 19 Jun 2022 23:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dHzVAyfIa/3nUl03RRG8Cmy2hok3UdrVa+qW5Pr02mE=; b=yBNK9/iQ57Apbwe6zABDPWJp37
        E8Ny/XDv27hw5gPa1YKZtipXrzgP+LPGxmCNoEaUheLXIMLuaUIlyr0NVoGs+jdbuxZiuHAu7/g6I
        g6mkZOqpUFGMGjvrCqFRr115ypKBrOMSJeYUbkYKWCZ3ZSCA8vqmk2lSoBnknvsWL+DS45YPJoXFV
        sKBq5PwAzbPjE4F/WdFJr/NHRRm8ywRkc8wS5B/Wa3xynH5FpC2L/a5erXySws2U1s7PWrAe7Dlwc
        /8ykwpyAdHXI3jPjJ7gNwcYk6wriBBhiRewtRqKTgvtvXQqnypmijFGaRg7KFgdAPKUxbzJ3ekfnY
        UHO9EwvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o3B2h-00GSAz-PA; Mon, 20 Jun 2022 06:37:47 +0000
Date:   Sun, 19 Jun 2022 23:37:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Nicolin Chen <nicolinc@nvidia.com>, kwankhede@nvidia.com,
        corbet@lwn.net, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, jchrist@linux.ibm.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFT][PATCH v1 6/6] vfio: Replace phys_pfn with phys_page for
 vfio_pin_pages()
Message-ID: <YrAVuxMEkV4Wytci@infradead.org>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-7-nicolinc@nvidia.com>
 <YqxBLbu8yPJiwK6Z@infradead.org>
 <20220620030046.GB5219@nvidia.com>
 <YrAK87zjdOqUF6gB@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrAK87zjdOqUF6gB@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 19, 2022 at 10:51:47PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 20, 2022 at 12:00:46AM -0300, Jason Gunthorpe wrote:
> > On Fri, Jun 17, 2022 at 01:54:05AM -0700, Christoph Hellwig wrote:
> > > There is a bunch of code an comments in the iommu type1 code that
> > > suggest we can pin memory that is not page backed.  
> > 
> > AFAIK you can.. The whole follow_pte() mechanism allows raw PFNs to be
> > loaded into the type1 maps and the pin API will happily return
> > them. This happens in almost every qemu scenario because PCI MMIO BAR
> > memory ends up routed down this path.
> 
> Indeed, my read wasn't deep enough.  Which means that we can't change
> the ->pin_pages interface to return a struct pages array, as we don't
> have one for those.

Actually.  gvt requires a struct page, and both s390 seem to require
normal non-I/O, non-remapped kernel pointers.  So I think for the
vfio_pin_pages we can assume that we only want page backed memory and
remove the follow_fault_pfn case entirely.   But we'll probably have
to keep it for the vfio_iommu_replay case that is not tied to
emulated IOMMU drivers.

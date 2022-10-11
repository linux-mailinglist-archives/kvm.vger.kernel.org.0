Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78935FACD0
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 08:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiJKGav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 02:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJKGau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 02:30:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1281386
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 23:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cSHpEYfomW8D1TGDXTeyKuo2PzDyZM/hERxlr1gUIe8=; b=HYJV6serHijeG24lSjagjIYQGS
        zfw1F3pL+5ttHkZwriv90rYQI0lZPXWBimFAjve2F5ZM4d5IOdPlIEXHXOUwlt7XwjxfFlkwfywtV
        AnOPk4HDKExR7510GzjUTIe0jIw+2y9VDUElbr1FwYcZend47RsG0+W6CmNjj+x93QJ9kLqLtGLnS
        J34faOtc0TpisRgZWG/SL9TrSBzAZiKQDxsPiyldO4DHYtMRbAQbXebXsJLA63wBWPgZPylVv0+jc
        8LRW+XdbWAnQmEZDfsaiHH1JKMFoLuauxzOJBWyGiAvO4lLH3CtrxdIBp7V+oH6K5Au14T6cICxJt
        vJcCSvRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oi8ms-003S55-Hx; Tue, 11 Oct 2022 06:30:46 +0000
Date:   Mon, 10 Oct 2022 23:30:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/4] vfio/pci: Move all the SPAPR PCI specific logic
 to vfio_pci_core.ko
Message-ID: <Y0UNlqR9tEL/Su+2@infradead.org>
References: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <1-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <Y0PEo+K+Q7fkcMcB@infradead.org>
 <Y0RlPnLAoZgPd8u9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0RlPnLAoZgPd8u9@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 03:32:30PM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 10, 2022 at 12:07:15AM -0700, Christoph Hellwig wrote:
> > On Mon, Oct 03, 2022 at 12:39:30PM -0300, Jason Gunthorpe wrote:
> > > The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
> > > around an arch function. Just make them static inline and move them into
> > > vfio_pci_priv.h.
> > 
> > Please just kill them entirely - the vfio spapr code depends on EEH
> > anyway.  In fact I have an old patch to do that floating around
> > somewhere, but it's probably less work to just recreate it.
> 
> How do you mean? You want to put the #ifdef in the vfio_pci_core.c at
> the only call site?

Yes.

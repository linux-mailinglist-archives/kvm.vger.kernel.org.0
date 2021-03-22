Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9DC34490A
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 16:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhCVPR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 11:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbhCVPRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 11:17:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79A9C061574;
        Mon, 22 Mar 2021 08:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SrAKUzOaqBwovlqKQtlyoUcCMghh986HGolrQZ/Pulc=; b=H6iQmGiYxecjK0gBKShyAKS3yU
        4Vr3uIormgfA/pwMm7kawjYoj8mP+ohuzLQFIrHPzgUnXlEOQ/WmlLcIi2vBngEgv0xrf+Mb9Rj7r
        o8wa1TB5Ebe9wiPHdsvR4MJhUQcCiPTKBM62CqP+eHW5ImMAviZQQ0TwKYKiWiwcofObdt4VUxKMp
        JWwYv7kLkalXcCh8uortelaHgQZcphXNz8NXsECL7exXVoStPI16T361vCNi4Vu4bUGi0HTBKfWIK
        MD+ZXNAdtWAkcLD8TPLcCVj8A3ry593S4WOdJkmixRvUkqDXd3eu6xhrSOytnshLR/fzUohXDNe96
        0+LMQtPA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOMHw-008hV5-9d; Mon, 22 Mar 2021 15:16:25 +0000
Date:   Mon, 22 Mar 2021 15:16:16 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com,
        peterx@redhat.com
Subject: Re: [PATCH v1 07/14] vfio: Add a device notifier interface
Message-ID: <20210322151616.GA2072680@infradead.org>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524010999.3480.14282676267275402685.stgit@gimli.home>
 <20210310075639.GB662265@infradead.org>
 <20210319162540.0c5fe9dd@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319162540.0c5fe9dd@omen.home.shazbot.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 04:25:40PM -0600, Alex Williamson wrote:
> I've been trying to figure out how, but I think not.  A user can have
> multiple devices, each with entirely separate IOMMU contexts.  For each
> device, the user can create an mmap of memory to that device and add it
> to every other IOMMU context.  That enables peer to peer DMA between
> all the devices, across all the IOMMU contexts.  But each individual
> device has no direct reference to any IOMMU context other than its own.
> A callback on the IOMMU can't reach those other contexts either, there's
> no guarantee those other contexts are necessarily managed via the same
> vfio IOMMU backend driver.  A notifier is the best I can come up with,
> please suggest if you have other ideas.  Thanks,

Indeed, reviewing the set again it seems like we need the notifier
here.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FAC52E45A
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 07:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345594AbiETFc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 01:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243365AbiETFcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 01:32:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC4AF6880
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 22:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3ODmFF5avT53o//v469wF9ADWgGgzn9kRfni0v0nXIk=; b=xcfGVyYeIHH0EKZftIC2xWY0zC
        fgdQssYI1G+wfHbwl5YgDMWENI1iB21+D4w6NSlrIWEfzeSjnxl9GLiNMt5ztyxsPyGY3/upbv6PO
        B5QkJ86vZj2QMuG8MEhwiX/kT/Fm9/Igkyd4pNv4CNtyqvsUfDDcvlnhHyaThnvUe2CQC4NUQRstV
        pZksUFj0pZO/TGicFs+JhNNKIK7JQ55+wejCq8IJd0cKrRB13p+NEbcLZ5xpMnr39nUGU/x14apEO
        pvWWIk4yoEOD62ZPC/gv8GXAtDaKCwDZo8Ly/q7cFy806wc9Fz6eCASLF6XMpef1Fj6OI5g+iEbiA
        y90SkQIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrvFp-00AcYm-2N; Fri, 20 May 2022 05:32:49 +0000
Date:   Thu, 19 May 2022 22:32:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH] vfio: Do not manipulate iommu dma_owner for fake iommu
 groups
Message-ID: <YocoAbMlb+zx2F1z@infradead.org>
References: <0-v1-9cfc47edbcd4+13546-vfio_dma_owner_fix_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-9cfc47edbcd4+13546-vfio_dma_owner_fix_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 02:03:48PM -0300, Jason Gunthorpe via iommu wrote:
> Since asserting dma ownership now causes the group to have its DMA blocked
> the iommu layer requires a working iommu. This means the dma_owner APIs
> cannot be used on the fake groups that VFIO creates. Test for this and
> avoid calling them.
> 
> Otherwise asserting dma ownership will fail for VFIO mdev devices as a
> BLOCKING iommu_domain cannot be allocated due to the NULL iommu ops.

Fake iommu groups come back to bite again, part 42..

The patch looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

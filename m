Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F7254F33F
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 10:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380594AbiFQImy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 04:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380537AbiFQImx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 04:42:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4981E1146F;
        Fri, 17 Jun 2022 01:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0+txUdQ43jf+UIe9zCVUaGGeb7a9BrmjbJwClV7VdAQ=; b=PiIGLlDRnD4KR6sJKZqqRuNH4y
        A1WYA1tieOBnORXjxYl7vYwDNHafaUH7kYlCGCM7t1x+LNel94rwNqbGLhL4BlEC1MZI6OoXIujQ+
        vShzmh+5ZQkZyPwkWL4IeGPcVy3qPp0FVWp+1X3n5/wOKktGNoZ+yXqlvb1GolNq7m204U7ValNhe
        PkayypEKB6d3IiePr18juhMYL99/5gj5wb8bEduIdLVbW/pWQRg5bqTa0WI1L1c72qUazXmBQ3noN
        dvIC73wU5vA/zg4eIo53LFb51U5nQ1OmOZtia6HZ6P0IvRSnO212m0w+el6cH6nOpWbqjM0UR53we
        YsE01FbA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o27Yw-006PUX-Gk; Fri, 17 Jun 2022 08:42:42 +0000
Date:   Fri, 17 Jun 2022 01:42:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     kwankhede@nvidia.com, corbet@lwn.net, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, jchrist@linux.ibm.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFT][PATCH v1 3/6] vfio: Pass in starting IOVA to
 vfio_pin/unpin_pages API
Message-ID: <Yqw+goqTJwb0lrxy@infradead.org>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-4-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616235212.15185-4-nicolinc@nvidia.com>
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

On Thu, Jun 16, 2022 at 04:52:09PM -0700, Nicolin Chen wrote:
> +	ret = vfio_unpin_pages(&vgpu->vfio_device, gfn << PAGE_SHIFT, npage);
> +	drm_WARN_ON(&i915->drm, ret != npage);

The shifting of gfn seems to happen bother here and in the callers.

Also this is the only caller that does anything withthe vfio_unpin_pages
return value.  Given that you touch the API here we might as well
not return any value, and turn the debug checks that can return errors
into WARN_ON_ONCE calls the vfio/iommu_type1 code.

> +extern int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
>  			  int npage, int prot, unsigned long *phys_pfn);
> -extern int vfio_unpin_pages(struct vfio_device *device, unsigned long *user_pfn,
> +extern int vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova,
>  			    int npage);

This will clash with the extern removal patch that Alex has sent.

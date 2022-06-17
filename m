Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7140154F3AA
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 10:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381385AbiFQIyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 04:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381372AbiFQIyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 04:54:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886453B032;
        Fri, 17 Jun 2022 01:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8nZ1ta+BsGc00ew4rYHJjg70RdBuVGkJ01/aKd/F76M=; b=22UofexgYSmp52aMwe+HIOOhvH
        HYrP5hQF/Y99IdWt/OJ7frq9bDlj6D/Gp2E2LfXGLyDec9bdW3ElpSca05pMX63lDBDkaRyZilvm3
        s0jUbrt1CiiZKRQ7vdxJZ9yVK90jEAwy2ITMbKKpviGKsecKQDJYrt7hAOD3RKzBVjb7fHmOaLxxP
        cWKZd5500xnwfiechgxDSX2HIctMCobu1VuwMbdK3f6uiymnj2Jg8g0IZBPG77/wBQcXmkLcVlGR6
        ssra39uhQZxgkJ+zs68oXh47Qe6h+fzmWqqiKHEwunXSUDLK/l3ieRfYn9Q5bYSjpMZjludDm3YY1
        UaH6OBmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o27jx-006UvK-VQ; Fri, 17 Jun 2022 08:54:05 +0000
Date:   Fri, 17 Jun 2022 01:54:05 -0700
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
Subject: Re: [RFT][PATCH v1 6/6] vfio: Replace phys_pfn with phys_page for
 vfio_pin_pages()
Message-ID: <YqxBLbu8yPJiwK6Z@infradead.org>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-7-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616235212.15185-7-nicolinc@nvidia.com>
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

There is a bunch of code an comments in the iommu type1 code that
suggest we can pin memory that is not page backed.  

>  int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
> +		   int npage, int prot, struct page **phys_page)

I don't think phys_page makes much sense as an argument name.
I'd just call this pages.

> +			phys_page[i] = pfn_to_page(vpfn->pfn);

Please store the actual page pointer in the vfio_pfn structure.

>  		remote_vaddr = dma->vaddr + (iova - dma->iova);
> -		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
> +		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn,
>  					     do_accounting);

Please just return the actual page from vaddr_get_pfns through
vfio_pin_pages_remote and vfio_pin_page_external, maybe even as a prep
patch as that is a fair amount of churn.

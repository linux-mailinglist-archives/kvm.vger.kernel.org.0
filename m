Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89501567EFD
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 08:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiGFGzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 02:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGFGzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 02:55:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E21F1B79C;
        Tue,  5 Jul 2022 23:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ik/uJsE+zpdPuUdS11m0Q/X6NmB5A5tIeaLT1FExMqk=; b=HHs4PsCAW1BgdmGMF7lVwPZBlR
        WXelzySoHmOcfeyjYIDcxKxiSPrY3LgVkMWP06N+b1YMeIjqTQqibdKCLa3W3s6TISEEwPbYtz9hf
        BuIfwbhWwKLUHmKXNlqKTzZIYUbxhMSDKDYDdgAErXVCEYOpTmfAM4yMn9tEpniYFBvxBn76mxl2y
        bsyyRpfl1bgczxu9jW5/iSXW5sl1VvDaH7+wHUdC+IDz12TBfxUbxNt4TIWkoXcBraRCmAoI9xGPy
        vLhJBjwY9NsA2OjzsrT2pWrhwOn/GsnSIQUmBOpgVrLFDDuEAHUBsL2PiXUaquNnBt0KfA6OTgFvJ
        BQurlmbA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8yvy-006rFh-Ez; Wed, 06 Jul 2022 06:54:50 +0000
Date:   Tue, 5 Jul 2022 23:54:50 -0700
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
        kevin.tian@intel.com, hch@infradead.org, jchrist@linux.ibm.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFT][PATCH v2 1/9] vfio: Make vfio_unpin_pages() return void
Message-ID: <YsUxurAoglm7GmZP@infradead.org>
References: <20220706062759.24946-1-nicolinc@nvidia.com>
 <20220706062759.24946-2-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706062759.24946-2-nicolinc@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +void vfio_unpin_pages(struct vfio_device *device, unsigned long *user_pfn,
> +		      int npage)
>  {
>  	struct vfio_container *container;
>  	struct vfio_iommu_driver *driver;
> -	int ret;
>  
> -	if (!user_pfn || !npage || !vfio_assert_device_open(device))
> -		return -EINVAL;
> +	if (WARN_ON_ONCE(!user_pfn || !npage || !vfio_assert_device_open(device)))

This adds an overly long line.  Note that I think in general it is
better to have an individual WARN_ON per condition anyway, as that
allows to directly pinpoint what went wrong when it triggers.

> +	if (WARN_ON_ONCE(unlikely(!driver || !driver->ops->unpin_pages)))
> +		return;

I'd just skip this check an let it crash.  If someone calls unpin
on something totally random that wasn't even pinned we don't need to
handle that gracefully.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

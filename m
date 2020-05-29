Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B531E7D7C
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 14:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgE2Mpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 08:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgE2Mpa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 08:45:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9D5C03E969;
        Fri, 29 May 2020 05:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=hWDpNSmqqL4jiVuIX8+MfcVSYKD0Sr0CkGGlOnTksS8=; b=Mw3cOcpwT75KMypA7DbQN76n3K
        LmIujEvwcjqz8mB4DIQNPRDiJKYUham8VvC6rSnD6+3ba6I3VkRz3MaFsFNabdvTOT2j5AatU+Z7I
        o2P6if4RDFm1y5wwdk2idNMSaFbHSv9nUDIt/4zeeljrafN3UYBqYE+KqfQCvuFK6OcWyAc+raczK
        RK1oGDElglttDYT91kX4m02qQyIV6yN6hy+hALyRQRMTpe79Bv+Xx23bujAFJtHO/oMRx35Hz3zuD
        lD4co5ouUY7qPRY4OdLY/2HO+5AIT+8BT8rZU73mdGN5IlVfIzk0ihyFqydTRs7blGIxekQ3JxAc7
        R7D+WZjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeeO3-00062M-2L; Fri, 29 May 2020 12:45:23 +0000
Date:   Fri, 29 May 2020 05:45:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Tom Murphy <murphyt7@tcd.ie>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Julien Grall <julien.grall@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-rockchip@lists.infradead.org, Andy Gross <agross@kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: Re: [PATCH 0/8] Convert the intel iommu driver to the dma-iommu api
Message-ID: <20200529124523.GA11817@infradead.org>
References: <20191221150402.13868-1-murphyt7@tcd.ie>
 <465815ae-9292-f37a-59b9-03949cb68460@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <465815ae-9292-f37a-59b9-03949cb68460@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 28, 2020 at 06:00:44PM -0600, Logan Gunthorpe wrote:
> > This issue is most likely in the i915 driver and is most likely caused by the driver not respecting the return value of the dma_map_ops::map_sg function. You can see the driver ignoring the return value here:
> > https://github.com/torvalds/linux/blob/7e0165b2f1a912a06e381e91f0f4e495f4ac3736/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c#L51
> > 
> > Previously this didn’t cause issues because the intel map_sg always returned the same number of elements as the input scatter gather list but with the change to this dma-iommu api this is no longer the case. I wasn’t able to track the bug down to a specific line of code unfortunately.  

Mark did a big audit into the map_sg API abuse and initially had
some i915 patches, but then gave up on them with this comment:

"The biggest TODO is DRM/i915 driver and I don't feel brave enough to fix
 it fully. The driver creatively uses sg_table->orig_nents to store the
 size of the allocate scatterlist and ignores the number of the entries
 returned by dma_map_sg function. In this patchset I only fixed the
 sg_table objects exported by dmabuf related functions. I hope that I
 didn't break anything there."

it would be really nice if the i915 maintainers could help with sorting
that API abuse out.

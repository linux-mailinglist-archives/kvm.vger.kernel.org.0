Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9680602425
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 08:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiJRGIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 02:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJRGIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 02:08:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C7FA4856
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 23:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HIIqJurEb074qhwvVI9BKHwutRkdsD9nGqA3qOa/1t0=; b=NMsal1YijVUZQbS9PlVs3C2ko1
        Ph/ka7cZ/2Uk5CQ/xFzTjrL5G+mP5Q5JSctZEW8lZtBC0sfjp7YJIHXLDvbN46hTQNmoB4XpizT6u
        rzs4bEXGWAJBuhgSn3e6m1uVqgrBSY6UBJ1YquLYMOsyoAjtfPUTN8B/vLVQAwBB6HD3ww5tp9mO3
        3QRBle1s9AmExNdd4SA+ujfpY/IBpVVLGgT+X6mMMNnR8BFAwy/p8qE/WN4ybAwIHSXr9L0S6wP5h
        9Snkg1ne05X+JuOqTUYLummNMXL4cbYPaldh8MixI+0q25kgBi8+71To5y7wV6Q0eN5zcPbiORXy2
        R9xUmBCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okfmF-003DSd-IU; Tue, 18 Oct 2022 06:08:35 +0000
Date:   Mon, 17 Oct 2022 23:08:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Russell Currey <ruscur@russell.cc>,
        Oliver O'Halloran <oohall@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 4/5] vfio: Remove CONFIG_VFIO_SPAPR_EEH
Message-ID: <Y05C4xT7r+Tz9Jn3@infradead.org>
References: <0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
 <4-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +#if IS_ENABLED(CONFIG_EEH) && IS_ENABLED(CONFIG_VFIO_IOMMU_SPAPR_TCE)
>  #include <asm/eeh.h>
>  #endif
>  
> @@ -689,7 +689,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  		vdev->sriov_pf_core_dev->vf_token->users--;
>  		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
>  	}
> -#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
> +#if IS_ENABLED(CONFIG_EEH) && IS_ENABLED(CONFIG_VFIO_IOMMU_SPAPR_TCE)

So while this preserves the existing behavior, I wonder if checking
CONFIG_EEH only would make more sense here.


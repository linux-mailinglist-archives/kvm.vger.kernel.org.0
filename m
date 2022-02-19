Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B644BC6B7
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 08:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241202AbiBSHc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 02:32:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBSHc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 02:32:27 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF4046179;
        Fri, 18 Feb 2022 23:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sqAnJz8uVZ8Q/dp+lB46Xah1mFGaVnx8u72C4fMPl04=; b=rP4bE3sgbuBhtx1bYdIiik7xle
        rKcv/uKt73U/LsdlA6ROBkmJq+fXwMS6uHEC8qmvy9pyt1GeMS0eaZzkVYzOAJGgXTgydYWLpQ9xh
        HurXlTCgi/VzX9c7ZnTwLwXPRvSx+lAhnLjbn4JAkqTW0foCDvE2ZBJ40p3AE7tZtvO8K2TcRKduo
        gd1hGdBcsevj0xXkYK8dKa1LXMn1VuAaCEh+PldyPGvcs1THypyd1CM1btGGAy3qQZOwpn8wKBdVg
        oAJYM8fgMtO1fJLR0mgiyXnxCUuf4sCc9jW7yCKkusjUeHqpepsTWF8H7t9hundXbECdrLsDL/vda
        j1FYt9Kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nLKDi-00GMxk-09; Sat, 19 Feb 2022 07:31:54 +0000
Date:   Fri, 18 Feb 2022 23:31:53 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v6 01/11] iommu: Add dma ownership management interfaces
Message-ID: <YhCc6dKyojInJe7u@infradead.org>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-2-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218005521.172832-2-baolu.lu@linux.intel.com>
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

The overall API and patch looks fine, but:

> + * iommu_group_dma_owner_claimed() - Query group dma ownership status
> + * @group: The group.
> + *
> + * This provides status query on a given group. It is racey and only for
> + * non-binding status reporting.

s/racey/racy/

> + */
> +bool iommu_group_dma_owner_claimed(struct iommu_group *group)
> +{
> +	unsigned int user;
> +
> +	mutex_lock(&group->mutex);
> +	user = group->owner_cnt;
> +	mutex_unlock(&group->mutex);
> +
> +	return user;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);

Still no no need for the lock here.

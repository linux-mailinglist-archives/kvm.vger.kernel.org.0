Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3EF40F85F
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 14:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbhIQMy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 08:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244713AbhIQMyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 08:54:25 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972F7C061574
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 05:53:03 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id cf2so6292568qvb.10
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 05:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B/XE9/+nMx63N6p5krJuGrYz4zER4JFlZffxXWENH/g=;
        b=CRNHagOjlTsEP2vQgD3w021Zad+TLiBsvZZwBlZgu0ZVhhJWmKrVyXgBQDqQFcpmRk
         T0cZT+oKyZFuQWDcE90B4gyfcfOaiMnLkroyNQ+mB6vRh7P7KsBDBkHB1JdUEk9pQfhu
         su9H4NvvzSZCsEmV9j+JEYkTbQE9QOdULd9Y3FdHG2moqQjeXlPpjOCqv7LlN160EUli
         fzExr7bHx64kcLpTG3T1SUJZaCo2AvbsbUsyMFulcPE7qdUHKU8XqdXSJSeXJJcq+Wxe
         VHFzTQkyXHe5+KuNx1Xu5vrZOV0KwLaejVQMKJKceftZujzdz5bfSXAOXz3lvEDdZAZx
         1Lsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B/XE9/+nMx63N6p5krJuGrYz4zER4JFlZffxXWENH/g=;
        b=5UxS5e1TNH3pQACTFJOvoDNOKTnPfGtVCNZaQ7q6WxgqbLfFiwW8JxX46ifdICGgGE
         CRaFVjsFZxcCZsj93cEe9qvajb5E6TZJupF565cuC+mNMoHXwEsvHReS/oYIm+jFJbkJ
         JyDviKmPQoOXBGUcNssM1o5G4mNm6KTTxKiJ/geqMbcEV9gEBiW5mREHeIAheikhmwX+
         N4i20yoXA4XmbcSKoXM7gvjU+e9abSidxJ7ozEShLJze/KcIrxra6q3e83VkTgZPXzWi
         DQAxfmexK2VrzgLl//cuNJQ9STFDt76uMSAZJV6L5dvLUOy8XrN3RO/oYoDa28DccqwR
         Ftdg==
X-Gm-Message-State: AOAM531rIdA6CwulyciE9qxN3bWaPJFV/vU8ROn/SqLuHHyCODC99IMD
        hcr55FtQBiqk9Ixpa6dMU44YRw==
X-Google-Smtp-Source: ABdhPJy/TSkKEuHevpTEt6ivh3YlW2FhkKLpAFMuN3tmw0KylK5dJHReB+uXNarrWQAtVpdDZ4eEEw==
X-Received: by 2002:ad4:5541:: with SMTP id v1mr10738490qvy.49.1631883182740;
        Fri, 17 Sep 2021 05:53:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id x21sm4671473qkf.76.2021.09.17.05.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 05:53:02 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mRDMT-0024U6-DD; Fri, 17 Sep 2021 09:53:01 -0300
Date:   Fri, 17 Sep 2021 09:53:01 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Message-ID: <20210917125301.GU3544071@ziepe.ca>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-12-hch@lst.de>
 <c4ef0d8a-39f4-4834-f8f2-beffd2f2f8ae@nvidia.com>
 <20210916221854.GT3544071@ziepe.ca>
 <BN9PR11MB54333BE60F997D3A9183EDD38CDD9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210917050543.GA22003@lst.de>
 <8a5ff811-3bba-996a-a8e0-faafe619f193@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a5ff811-3bba-996a-a8e0-faafe619f193@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 17, 2021 at 12:21:07PM +0530, Kirti Wankhede wrote:
> 
> 
> On 9/17/2021 10:35 AM, Christoph Hellwig wrote:
> > On Fri, Sep 17, 2021 at 04:49:41AM +0000, Tian, Kevin wrote:
> > > > You just use the new style mdev API and directly call
> > > > vfio_register_group_dev and it will pick up the
> > > > parent->dev->iommu_group naturally like everything else using physical
> > > > iommu groups.
> > > > 
> > > 
> 
> Directly calling vfio_register_group_dev() doesn't work without linking
> mdev->dev->iommu_group to mdev->type->parent->dev->iommu_group.

You pass the PCI device, not the mdev to vfio_register_group_dev().

> > > For above usage (wrap pdev into mdev), isn't the right way to directly add
> > > vendor vfio-pci driver since vfio-pci-core has been split out now? It's not
> > > necessary to fake a mdev just for adding some mediation in the r/w path...
> > 
> > Exactly.
> 
> vfio-pci doesn't provide way to configure the device as mdev framework
> provide using mdev_types.

The linux standard is for a PCI PF driver to configure it's VFs, not a
mdev or vfio.

Jason

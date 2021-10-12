Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450E8429FFE
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbhJLIgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbhJLIgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 04:36:12 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD912C06161C
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 01:34:10 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id o20so64232566wro.3
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 01:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DEKNWFqxFUX2mkg60fATcZxk9uI6yAWQjBdwjDnLhnQ=;
        b=NsJs462uexyBDbU8Q4KAvcg0jiRb7CqhuB3C/ZZeC+cxldOsCvl4OG4doA6y2zEIGv
         ghj7++7W4e4F8SPkosTQzv2KQGLoeCuwW5hqcPbp/7ERsCOis2Ehtb29wRxmeXhssJgx
         3QI8n8NdevmclkIpIkSM7RyUXzfd2kcv1BESXapdgi3SqGefyqXi0d4GRJTsoF6qAjYf
         dMX/D9Rm9OUqub4KJFJCnqKU0BMfFmPZPEpuBwPlKeeSagiu7y74q6LoJNhi3880UNkW
         YCIjAMF4RQSI66FVB0XH8OaT4+x/dG8uq56QTR8655fXZt4NKCVOMd75F3pZVnWwEky3
         bXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DEKNWFqxFUX2mkg60fATcZxk9uI6yAWQjBdwjDnLhnQ=;
        b=Q3EoXgyJRF534DhRfMNFbXn2+/qWam75zTrydoQnJdA6BOBbWhV5CIA1avPLHPdAua
         hUxXnMLptkH0eXo1c8ZQcootRtK75wUz/Q/3I27w+nOXyGieQcyPCygGiZT+Xj34noZx
         GNgrrlkOWac3Jvr0FteYfVmJ3yuYJ7DSAm0ZvrWnHe1bshjB3jZqU5dw73KJrJN72V7S
         ko0Xuf89/Hm887MEwB2Xc7D9ugzdxp9eKzWeNj5x5XaDzwgY2xZnG0KpuFLfyvP8HG7Q
         Ri6enPNBQhMY68tE0d3i4dU5/NG7rUf8AJnl4eKrJkUdtejIak02y7GvghvQMigOvgJX
         uQ9Q==
X-Gm-Message-State: AOAM532HhhEMtdu6GzdmqeChQr08rORdMbu1DLT/L09IkVISgQDYtBTc
        5/FZmXdq0WkEtZ2L7vPbu+vAdw==
X-Google-Smtp-Source: ABdhPJwrOO2oLsiRUfbBsfVIcAOqTLRnOc34nZbsYYyoplLvQ1io3jT1A9zMiWh7kcAmkGaqUUSC3w==
X-Received: by 2002:adf:bd91:: with SMTP id l17mr30158885wrh.261.1634027649193;
        Tue, 12 Oct 2021 01:34:09 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id d7sm10098871wrh.13.2021.10.12.01.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 01:34:08 -0700 (PDT)
Date:   Tue, 12 Oct 2021 09:33:46 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        kevin.tian@intel.com, parav@mellanox.com, lkml@metux.net,
        pbonzini@redhat.com, lushenming@huawei.com, eric.auger@redhat.com,
        corbet@lwn.net, ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <YWVIagFiOtXTGMQ+@myrica>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <YVanJqG2pt6g+ROL@yekko>
 <20211001122225.GK964074@nvidia.com>
 <YWPTWdHhoI4k0Ksc@yekko>
 <YWP6tblC2+/2RQtN@myrica>
 <20211011233817.GS2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011233817.GS2744544@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021 at 08:38:17PM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 11, 2021 at 09:49:57AM +0100, Jean-Philippe Brucker wrote:
> 
> > Seems like we don't need the negotiation part?  The host kernel
> > communicates available IOVA ranges to userspace including holes (patch
> > 17), and userspace can check that the ranges it needs are within the IOVA
> > space boundaries. That part is necessary for DPDK as well since it needs
> > to know about holes in the IOVA space where DMA wouldn't work as expected
> > (MSI doorbells for example). 
> 
> I haven't looked super closely at DPDK, but the other simple VFIO app
> I am aware of struggled to properly implement this semantic (Indeed it
> wasn't even clear to the author this was even needed).
> 
> It requires interval tree logic inside the application which is not a
> trivial algorithm to implement in C.
> 
> I do wonder if the "simple" interface should have an option more like
> the DMA API where userspace just asks to DMA map some user memory and
> gets back the dma_addr_t to use. Kernel manages the allocation
> space/etc.

Agreed, it's tempting to use IOVA = VA but the two spaces aren't
necessarily compatible. An extension that plugs into the IOVA allocator
could be useful to userspace drivers.

Thanks,
Jean

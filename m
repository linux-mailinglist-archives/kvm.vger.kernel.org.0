Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0795E380A67
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 15:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbhENNc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 09:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbhENNc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 09:32:56 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ADEC061574
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 06:31:45 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id r13so15408003qvm.7
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 06:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oibZ2encQTXVcTS46xz1aln4vXwMiQRn+5Ve6HidmyY=;
        b=P01L9ipF0WXXprGU/TPHMse5/2JNa5KJigLzB+MgLrkiRFpKV1d2TmruEIRGE/O2rT
         iiF42kQ3dw4/Ch/XtfZOpwpxPBgVZKlZepQw/F1pT5ms+OVjo7ydBxwBFLOD4pFck3pX
         f/NebrrJv+SMBUTHk3L2av0vieMiDpXGBAKiDs5U2/zXF1qRjy2armYsx39Ght5EFKH2
         d91amYNGXarhYvHIiJ3JkLOljk4RqMqWPMXK+okMlwkVyKMoLFmm5GfL7XMQtlV2jACI
         37Vdw6Mcy5n9S1ZpNBhtDgbvyBrqIrFPqfhlZc44jM/ZWDIhGcb0mFlhmSHuVzBytMpF
         on1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oibZ2encQTXVcTS46xz1aln4vXwMiQRn+5Ve6HidmyY=;
        b=cxhaZVEtFWqF7ABIv7L0dOpOQHFBkbv2ZkNLKBXfpTh4NhbT3Og6A/ou0gFpmKrM2i
         VJlMu5O649BEikg6KlbOwJ8/lWr9cFQTu21eRZaaMDXh094lHfchZuUbq7QCTdbKhRY6
         5Zf4PC8QK2RGEkxHlreRjxD8ge66U7thJ/BwSW3Jd9a2PsX2WnEorzCT7rY4izNs+LuL
         e09kCGaR1egiSXhMbdKE27nm1uP1SgOE7z4UXsqTqLU+eAnhX9/DoaQPo9MoccgfKrJB
         YoP1A0KE4vknXJT0yKqyYGM71xIhB1pGCdr52C1nxn8YNrFE4plWH5oT5RXzxrmQo2Lk
         A/Iw==
X-Gm-Message-State: AOAM531F8/2AgEifHcWSdwnmjvrxTEje9EdKPDD3aiYqM5A+v1/18JFI
        fxzDiwY2oPA0lN1hO0H1iI3C85TWNP7IRf3X
X-Google-Smtp-Source: ABdhPJz/Gqut1q/aFEFJ4dhIoQHY99jUDAFFC+RcHlUQEp277wF1zYHdBA3LTZbkkjtOGNdQocIJpQ==
X-Received: by 2002:a0c:c488:: with SMTP id u8mr45442908qvi.47.1620999104308;
        Fri, 14 May 2021 06:31:44 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id y1sm4582720qkp.21.2021.05.14.06.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 06:31:43 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lhXup-007RZ1-4c; Fri, 14 May 2021 10:31:43 -0300
Date:   Fri, 14 May 2021 10:31:43 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Message-ID: <20210514133143.GK1096940@ziepe.ca>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de>
 <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514121925.GI1096940@ziepe.ca>
 <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 12:58:10PM +0000, Tian, Kevin wrote:

> This avoids changing every iommu ops to include a PASID and forcing
> the upper-layer drivers to do it differently between pdev and mdev.
> Actually this was a main motivation when working out aux domain
> proposal with Joerg two years ago.

Well, usually when people say stuff like that it means it is a hack..

Oh, this does look like a big hack, yes.

/dev/ioasid is focused on IOASIDs. As an API you have to be able to use
it to create all kinds of IOASID's *against a single HW struct
device*.

In this world you can't create domains for every struct device as hack
to pass in the PASID.

The IOASID itself must be an object that contains the HW struct device
and the PASID. IOASID must be a first class object in the entire API.

Remember, when a driver wants to connect to an IOASID it wants to make
some very simple calls like:

   iommu_attach_ioasid_rid(&pci_device->dev, ioasid_ptr);
   iommu_attach_ioasid_pasid(&pci_device->dev, ioasid_ptr);

Which is based *only* on what the PCI device does. If the device issues
TLPs without PASID then the driver must use the first. If the device
issues TLPs with a PASID then the driver must use the latter.

There is no place for "domain as a carrier of PASID"
there. mdev_device should NOT participate in the IOMMU layer because
it is NOT a HW device. Trying to warp mdev_device into an IOMMU
presence is already the source of a lot of this hacky code.

To juggle multiple IOASID per HW device the IOMMU API obviously has to
be made IOASID aware. It can't just blindly assume that a struct
device implies the single IOASID to use and hope for the best.

> The reason is that iommu domain represents an IOVA address
> space shareable by multiple devices. It should be created at the 
> point where the address space is managed. 

IOASID represents the IOVA address space.

Two concepts that represent the same thing is not great :)

Jason

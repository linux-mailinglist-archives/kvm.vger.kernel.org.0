Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0093214143
	for <lists+kvm@lfdr.de>; Sun,  5 May 2019 19:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfEERDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 13:03:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38555 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbfEERDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 13:03:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id k16so14226965wrn.5
        for <kvm@vger.kernel.org>; Sun, 05 May 2019 10:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S14+Saw50db8S99Z7u2shrBLJtQSP1RkJXIAVw5pLBQ=;
        b=jugLcBXRtPNuiKygehBn3dRh5gv2O3n+6CZdR9c0ZkktI0CvjyoksEeeH2FfA1Q8xH
         SqTElONPKWQBKsU0uJQu8/4wptVHk0j3GxZWG+CA0HjhrepIVFXHP29zNbjhuDeaonnN
         97d3CBboz5W+phNi8nRbOR+m5GoULw/MmeCEZ5EltfZbRHRsDTLjuCw4WWTkYy3yUqZI
         EIDwHmihhNOllL5cqFRBllZpxOUcacxfDAaI+HPZMWZaZhGbjI2/tay2jJLP/i4RqR4o
         vlUd0iNLLI5u8lL4HvT+QCdV2M59SHV6zxPaQcTE1z1/Kw5EFI5DZr9zemt+AgWD44KI
         OF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S14+Saw50db8S99Z7u2shrBLJtQSP1RkJXIAVw5pLBQ=;
        b=UZ7cGt/T7KHmXhxAC5P/1R7AlXWpVZ3kjLdHrEQymZVIIO3VWwn9w9H88Agvp+b+AD
         XmL2On4rTeursy1Wc5VD14MBr5763Y31qxZKa1zTvkyYSl+DyvjMWtxSksoFNxq3tdfa
         iFs5ESB8HRWtd5XOsw8qsSpKlvt3xj30mWuiaOKwsq6pwxyZPhznEUrGDAksUWjtHruc
         Oxni8i/tpicmImmmx47J6rNUBxsNYhYi8aDhGospd+xNtirGXSMB+l9RYqF26azPtetS
         ID68ToACWVO2vEH3o8vZk93iLF5m9K0sv0sK638ODJ2V6+jTkNw4VG8PQuJr/cZoSPT6
         VPPA==
X-Gm-Message-State: APjAAAVqWnw9d1FJGsaAAT7H48frgwzayX6qyrA8Xfa7ODbb4PcSsooO
        6DauFftyEPBGoFZLGCWs30KJrdCGgbcpRMK6JFwduw==
X-Google-Smtp-Source: APXvYqwrz/neemWb9vnz/FkpTRyXsq1RpflAc1+fcvk/jy/wtfTvsXtCkcfhMT+x+U7qMUUGE6g6BzjVgXI0vnlcixI=
X-Received: by 2002:a5d:4942:: with SMTP id r2mr14362363wrs.159.1557075793556;
 Sun, 05 May 2019 10:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190504132327.27041-1-tmurphy@arista.com> <20190504132327.27041-7-tmurphy@arista.com>
 <602b77a2-9c68-ad14-b64f-904a7ff27a15@linux.intel.com>
In-Reply-To: <602b77a2-9c68-ad14-b64f-904a7ff27a15@linux.intel.com>
From:   Tom Murphy <tmurphy@arista.com>
Date:   Sun, 5 May 2019 18:03:02 +0100
Message-ID: <CAPL0++57nyLYP1fq=-6zvNS0z_iCqjWLbQ1MsG5F60ODkmRCQQ@mail.gmail.com>
Subject: Re: [RFC 6/7] iommu/vt-d: convert the intel iommu driver to the
 dma-iommu ops api
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     iommu@lists.linux-foundation.org, Tom Murphy <murphyt7@tcd.ie>,
        Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 5, 2019 at 3:44 AM Lu Baolu <baolu.lu@linux.intel.com> wrote:
>
> Hi,
>
> On 5/4/19 9:23 PM, Tom Murphy wrote:
> > static int intel_iommu_add_device(struct device *dev)
> >   {
> > +     struct dmar_domain *dmar_domain;
> > +     struct iommu_domain *domain;
> >       struct intel_iommu *iommu;
> >       struct iommu_group *group;
> > -     struct iommu_domain *domain;
> > +     dma_addr_t base;
> >       u8 bus, devfn;
> >
> >       iommu = device_to_iommu(dev, &bus, &devfn);
> > @@ -4871,9 +4514,12 @@ static int intel_iommu_add_device(struct device *dev)
> >       if (IS_ERR(group))
> >               return PTR_ERR(group);
> >
> > +     base = IOVA_START_PFN << VTD_PAGE_SHIFT;
> >       domain = iommu_get_domain_for_dev(dev);
> > +     dmar_domain = to_dmar_domain(domain);
> >       if (domain->type == IOMMU_DOMAIN_DMA)
> > -             dev->dma_ops = &intel_dma_ops;
> > +             iommu_setup_dma_ops(dev, base,
> > +                             __DOMAIN_MAX_ADDR(dmar_domain->gaw) - base);
>
> I didn't find the implementation of iommu_setup_dma_ops() in this
> series. Will the iova resource be initialized in this function?

Ah sorry, I should've mentioned this is based on the
http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma-iommu-ops.3
branch with the "iommu/vt-d: Delegate DMA domain to generic iommu" and
"iommu/amd: Convert the AMD iommu driver to the dma-iommu api" patch
sets applied.

>
> If so, will this block iommu_group_create_direct_mappings() which
> reserves and maps the reserved iova ranges.

The reserved regions will be reserved by the
iova_reserve_iommu_regions function instead:
( https://github.com/torvalds/linux/blob/6203838dec05352bc357625b1e9ba0a10d3bca35/drivers/iommu/dma-iommu.c#L238
)
iommu_setup_dma_ops calls iommu_dma_init_domain which calls
iova_reserve_iommu_regions.
iommu_group_create_direct_mappings will still execute normally but it
won't be able to call the intel_iommu_apply_resv_region function
because it's been removed in this patchset.
This shouldn't change any behavior and the same regions should be reserved.

>
> >
> >       iommu_group_put(group);
> >       return 0;
> > @@ -5002,19 +4648,6 @@ int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct intel_svm_dev *sd
> >       return ret;
> >   }
> >
> > -static void intel_iommu_apply_resv_region(struct device *dev,
> > -                                       struct iommu_domain *domain,
> > -                                       struct iommu_resv_region *region)
> > -{
> > -     struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> > -     unsigned long start, end;
> > -
> > -     start = IOVA_PFN(region->start);
> > -     end   = IOVA_PFN(region->start + region->length - 1);
> > -
> > -     WARN_ON_ONCE(!reserve_iova(&dmar_domain->iovad, start, end));
> > -}
> > -
> >   struct intel_iommu *intel_svm_device_to_iommu(struct device *dev)
> >   {
> >       struct intel_iommu *iommu;
> > @@ -5050,13 +4683,13 @@ const struct iommu_ops intel_iommu_ops = {
> >       .detach_dev             = intel_iommu_detach_device,
> >       .map                    = intel_iommu_map,
> >       .unmap                  = intel_iommu_unmap,
> > +     .flush_iotlb_all        = iommu_flush_iova,
> >       .flush_iotlb_range      = intel_iommu_flush_iotlb_range,
> >       .iova_to_phys           = intel_iommu_iova_to_phys,
> >       .add_device             = intel_iommu_add_device,
> >       .remove_device          = intel_iommu_remove_device,
> >       .get_resv_regions       = intel_iommu_get_resv_regions,
> >       .put_resv_regions       = intel_iommu_put_resv_regions,
> > -     .apply_resv_region      = intel_iommu_apply_resv_region,
>
> With this removed, how will iommu_group_create_direct_mappings() work?
>
> Best regards,
> Lu Baolu

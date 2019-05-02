Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F8E12070
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 18:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfEBQni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 12:43:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:13781 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfEBQni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 12:43:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 09:43:37 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga002.jf.intel.com with ESMTP; 02 May 2019 09:43:37 -0700
Date:   Thu, 2 May 2019 09:46:24 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Robin Murphy <Robin.Murphy@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Vincent Stehle <Vincent.Stehle@arm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v7 05/23] iommu: Introduce cache_invalidate API
Message-ID: <20190502094624.43924be8@jacob-builder>
In-Reply-To: <6af5ddb7-75ad-7d3f-b303-f6f06adb1bf0@arm.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
        <20190408121911.24103-6-eric.auger@redhat.com>
        <a9745aef-8686-c761-e3d0-dd0e98a1f5b2@arm.com>
        <e5d2fdd6-4ce1-863e-5198-0b05d727a5b6@redhat.com>
        <6af5ddb7-75ad-7d3f-b303-f6f06adb1bf0@arm.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 May 2019 11:53:34 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> On 02/05/2019 07:58, Auger Eric wrote:
> > Hi Jean-Philippe,
> > 
> > On 5/1/19 12:38 PM, Jean-Philippe Brucker wrote:  
> >> On 08/04/2019 13:18, Eric Auger wrote:  
> >>> +int iommu_cache_invalidate(struct iommu_domain *domain, struct
> >>> device *dev,
> >>> +			   struct iommu_cache_invalidate_info
> >>> *inv_info) +{
> >>> +	int ret = 0;
> >>> +
> >>> +	if (unlikely(!domain->ops->cache_invalidate))
> >>> +		return -ENODEV;
> >>> +
> >>> +	ret = domain->ops->cache_invalidate(domain, dev,
> >>> inv_info); +
> >>> +	return ret;  
> >>
> >> Nit: you don't really need ret
> >>
> >> The UAPI looks good to me, so
> >>
> >> Reviewed-by: Jean-Philippe Brucker
> >> <jean-philippe.brucker@arm.com>  
> > Just to make sure, do you accept changes proposed by Jacob in
> > https://lkml.org/lkml/2019/4/29/659 ie.
> > - the addition of NR_IOMMU_INVAL_GRANU in enum
> > iommu_inv_granularity and
> > - the addition of NR_IOMMU_CACHE_TYPE  
> 
> Ah sorry, I forgot about that, I'll review the next version. Yes they
> can be useful (maybe call them IOMMU_INV_GRANU_NR and
> IOMMU_CACHE_INV_TYPE_NR?). I guess it's legal to export in UAPI values
> that will change over time, as VFIO also does it in its enums.
> 
I am fine with the names. Maybe you can put this patch in your sva/api
branch once you reviewed it? Having a common branch for common code
makes life so much easier.

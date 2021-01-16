Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCC12F8C46
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 09:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbhAPIjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Jan 2021 03:39:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbhAPIjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Jan 2021 03:39:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A2A323339;
        Sat, 16 Jan 2021 08:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610786347;
        bh=OTU/ZiHDfKKS3DGAIXMuHsKqoyF0ThtCMaNSJ7Psvjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jz5EIWi/XmKCHgceatEQXnZqkRblFMiPdEbfMUHCCMWeCbc7HTDuNmtG7y/uGuZ4H
         /5Tar/XvIMVLcKRvp6hYsy7+A/BoGdjcHmy8msunKBcPdOKI3PZksX7XfYizzNpwdv
         63ufhfOpjeHnFy5NO5rtDFQ/ZMIXeepbXj/3s4uN5rkVZ+bS8U5MafqvIB/cEH6Wbq
         Q3qkA3QMFFT0VVmln2VY432TGr1zPsXgGfEEGWI+T+/l1Httq+JDO8kGZ6UKgELrkp
         Y+bVljKtVkgF1FiycqJwUdOPzBXuws/uaPeejspDpp4ZdsABXBf4ITh/ctuppYpxTE
         k9uGQfCC4KYaw==
Date:   Sat, 16 Jan 2021 10:39:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     tglx@linutronix.de, ashok.raj@intel.com, kevin.tian@intel.com,
        dave.jiang@intel.com, megha.dey@intel.com, dwmw2@infradead.org,
        alex.williamson@redhat.com, bhelgaas@google.com,
        dan.j.williams@intel.com, will@kernel.org, joro@8bytes.org,
        dmaengine@vger.kernel.org, eric.auger@redhat.com,
        jacob.jun.pan@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH v3 1/2] iommu: Add capability IOMMU_CAP_VIOMMU
Message-ID: <20210116083904.GN944463@unreal>
References: <20210114013003.297050-1-baolu.lu@linux.intel.com>
 <20210114013003.297050-2-baolu.lu@linux.intel.com>
 <20210114132627.GA944463@unreal>
 <b0c8b260-8e23-a5bd-d2da-ca1d67cdfa8a@linux.intel.com>
 <20210115063108.GI944463@unreal>
 <c58adc13-306a-8df8-19e1-27f834b3a7c9@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c58adc13-306a-8df8-19e1-27f834b3a7c9@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 16, 2021 at 09:20:16AM +0800, Lu Baolu wrote:
> Hi,
>
> On 2021/1/15 14:31, Leon Romanovsky wrote:
> > On Fri, Jan 15, 2021 at 07:49:47AM +0800, Lu Baolu wrote:
> > > Hi Leon,
> > >
> > > On 1/14/21 9:26 PM, Leon Romanovsky wrote:
> > > > On Thu, Jan 14, 2021 at 09:30:02AM +0800, Lu Baolu wrote:
> > > > > Some vendor IOMMU drivers are able to declare that it is running in a VM
> > > > > context. This is very valuable for the features that only want to be
> > > > > supported on bare metal. Add a capability bit so that it could be used.
> > > >
> > > > And how is it used? Who and how will set it?
> > >
> > > Use the existing iommu_capable(). I should add more descriptions about
> > > who and how to use it.
> >
> > I want to see the code that sets this capability.
>
> Currently we have Intel VT-d and the virt-iommu setting this capability.
>
>  static bool intel_iommu_capable(enum iommu_cap cap)
>  {
>  	if (cap == IOMMU_CAP_CACHE_COHERENCY)
>  		return domain_update_iommu_snooping(NULL) == 1;
>  	if (cap == IOMMU_CAP_INTR_REMAP)
>  		return irq_remapping_enabled == 1;
> +	if (cap == IOMMU_CAP_VIOMMU)
> +		return caching_mode_enabled();
>
>  	return false;
>  }
>
> And,
>
> +static bool viommu_capable(enum iommu_cap cap)
> +{
> +	if (cap == IOMMU_CAP_VIOMMU)
> +		return true;
> +
> +	return false;
> +}

These two functions are reading this cap and not setting.
Where can I see code that does "cap = IOMMU_CAP_VIOMMU" and not "=="?

>
> Best regards,
> baolu

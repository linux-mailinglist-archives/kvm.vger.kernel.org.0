Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D0B269165
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 18:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgINQXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 12:23:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:22223 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgINQXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 12:23:09 -0400
IronPort-SDR: UDMsmDQLBbUMlqyPsZ0zy6S32IbOSX0ayeDzeEMhyl+V5xzVQAE8PyT0o7jWdr/EOEUWVto2Ci
 qIGJ1tL4mQbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="177167168"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="177167168"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:22:54 -0700
IronPort-SDR: 4I677f4bZnFVVaRmbJ3faRKKb7j7nuoM+KQ72oWzlmSaz0A6vgDfXMSeGD288ocFGD6IlUTyDz
 7iml14FbGuvg==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="482406971"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:22:54 -0700
Date:   Mon, 14 Sep 2020 09:22:47 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200914162247.GA63399@otc-nc-03>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
 <20200914133113.GB1375106@myrica>
 <20200914134738.GX904879@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914134738.GX904879@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Mon, Sep 14, 2020 at 10:47:38AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 14, 2020 at 03:31:13PM +0200, Jean-Philippe Brucker wrote:
> 
> > > Jason suggest something like /dev/sva. There will be a lot of other
> > > subsystems that could benefit from this (e.g vDPA).
> > 
> > Do you have a more precise idea of the interface /dev/sva would provide,
> > how it would interact with VFIO and others?  vDPA could transport the
> > generic iommu.h structures via its own uAPI, and call the IOMMU API
> > directly without going through an intermediate /dev/sva handle.
> 
> Prior to PASID IOMMU really only makes sense as part of vfio-pci
> because the iommu can only key on the BDF. That can't work unless the
> whole PCI function can be assigned. It is hard to see how a shared PCI
> device can work with IOMMU like this, so may as well use vfio.
> 
> SVA and various vIOMMU models change this, a shared PCI driver can
> absoultely work with a PASID that is assigned to a VM safely, and
> actually don't need to know if their PASID maps a mm_struct or
> something else.

Well, IOMMU does care if its a native mm_struct or something that belongs
to guest. Because you need ability to forward page-requests and pickup
page-responses from guest. Since there is just one PRQ on the IOMMU and
responses can't be sent directly. You have to depend on vIOMMU type
interface in guest to make all of this magic work right?

> 
> So, some /dev/sva is another way to allocate a PASID that is not 1:1
> with mm_struct, as the existing SVA stuff enforces. ie it is a way to
> program the DMA address map of the PASID.
> 
> This new PASID allocator would match the guest memory layout and

Not sure what you mean by "match guest memory layout"? 
Probably, meaning first level is gVA or gIOVA? 

Cheers,
Ashok

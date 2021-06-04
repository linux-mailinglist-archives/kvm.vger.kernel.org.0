Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58B039BE9C
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFDR0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:26:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:23285 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230398AbhFDR0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:26:52 -0400
IronPort-SDR: zjWDFz208ImDZht946Fuw0O9y11ztffPwMMSgviQXPFGbkdDtaJvMxn58T/FYJDCJiBA8GFosp
 Ivz8B0ndrF7Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="202475779"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="202475779"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 10:25:05 -0700
IronPort-SDR: dAFKNKjtmaL7yQnr3K/eB0SbWboMG8HyiCrjLVTN866KgoOVn5Xfj6lI+c9gQvaihlmzACMUqi
 AwFe9T7+EZTg==
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="401025402"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 10:25:05 -0700
Date:   Fri, 4 Jun 2021 10:27:43 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604102743.0bebc26a@jacob-builder>
In-Reply-To: <20210604120555.GH1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210528195839.GO1002214@nvidia.com>
        <YLcpw5Kx61L7TVmR@yekko>
        <20210602165838.GA1002214@nvidia.com>
        <YLhsZRc72aIMZajz@yekko>
        <YLn/SJtzuJopSO2x@myrica>
        <20210604120555.GH1002214@nvidia.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Fri, 4 Jun 2021 09:05:55 -0300, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Jun 04, 2021 at 12:24:08PM +0200, Jean-Philippe Brucker wrote:
> 
> > I think once it binds a device to an IOASID fd, QEMU will want to probe
> > what hardware features are available before going further with the
> > vIOMMU setup (is there PASID, PRI, which page table formats are
> > supported,  
> 
> I think David's point was that qemu should be told what vIOMMU it is
> emulating exactly (right down to what features it has) and then
> the goal is simply to match what the vIOMMU needs with direct HW
> support via /dev/ioasid and fall back to SW emulation when not
> possible.
> 
> If qemu wants to have some auto-configuration: 'pass host IOMMU
> capabilities' similar to the CPU flags then qemu should probe the
> /dev/ioasid - and maybe we should just return some highly rolled up
> "this is IOMMU HW ID ARM SMMU vXYZ" out of some query to guide qemu in
> doing this.
> 
There can be mixed types of physical IOMMUs on the host. So not until a
device is attached, we would not know if the vIOMMU can match the HW
support of the device's IOMMU. Perhaps, vIOMMU should check the
least common denominator features before commit.

Thanks,

Jacob

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA44F27F1A0
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgI3SvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:51:16 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2488 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgI3SvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:51:16 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f74d3700000>; Wed, 30 Sep 2020 11:50:24 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 18:51:09 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.51) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 30 Sep 2020 18:51:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+zxFYw91wL1/C4wFwbQEYm+7NHM8E1AZ8F6oadgIeyZctxyidXdmhETx7n1N0EiO3pYtj94pae7OWTrKogAguVTXTQDg8fmGMK2NDf44AuZP7D3If69DRC4Zx/91naEs13t9GudZO33wXGCEEL9FfYVBIueJLXVq3q3IKQDYjCbO+RHE6Et3qc90Pz6BoviDTWDU/tzfRCUQiUpHWhOWMOUfGTGlegf8zKcx+mv15cKpEMT0eH4h385XjVztyWC3hq9naKKE9btOcXmsmZF/PO4z0Y3eNzbsquvrNHapeD/mPiRdeNFk8OVSIKaSvsJnoRupRryte3oQfDKQIi5DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FOi6aT5JY7VhLnV3Z8NYw2z6y8P6KLonvyYhymTC9Jo=;
 b=I9gutspRKLsBhGPip37tV3WMcRd0f/ZVcWhcdJUc2byyeTyfPGQCJA/1QmED2kuI/s8GmAGJS2FMDgv4ia/PNPLRDB5WspKwh0s5ACGm94LLTHKMS2idPIiuHfK/fDED7T2cZnjNedEEqmF6IbzuieY2mQczPjfFUPK1KAuw/8gqysN1Oc7UMVpTUPyy4ovDRzsfHKVV+yVqPtZixdm8kVsF6Y94+z1BLhoPM8Np4/uVXLZvovUv3DSXtUiRhS9KudaXMF66ucX56Az9l82QvJKnwy4kd3r1rPX3yBiDXcwOCGfiL0XzDS+K9lNqzMFaMIlBXLUMGbrVGY7Egxp+dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4011.namprd12.prod.outlook.com (2603:10b6:5:1c5::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Wed, 30 Sep
 2020 18:51:05 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 18:51:05 +0000
Date:   Wed, 30 Sep 2020 15:51:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Dave Jiang <dave.jiang@intel.com>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <ashok.raj@intel.com>, <yi.l.liu@intel.com>, <baolu.lu@intel.com>,
        <kevin.tian@intel.com>, <sanjay.k.kumar@intel.com>,
        <tony.luck@intel.com>, <jing.lin@intel.com>,
        <dan.j.williams@intel.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <parav@mellanox.com>, <rafael@kernel.org>,
        <netanelg@mellanox.com>, <shahafs@mellanox.com>,
        <yan.y.zhao@linux.intel.com>, <pbonzini@redhat.com>,
        <samuel.ortiz@intel.com>, <mona.hossain@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/18] dmaengine: idxd: add IMS support in base driver
Message-ID: <20200930185103.GT816047@nvidia.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021248979.67751.3799965857372703876.stgit@djiang5-desk3.ch.intel.com>
 <87sgazgl0b.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87sgazgl0b.fsf@nanos.tec.linutronix.de>
X-ClientProxiedBy: MN2PR20CA0057.namprd20.prod.outlook.com
 (2603:10b6:208:235::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0057.namprd20.prod.outlook.com (2603:10b6:208:235::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Wed, 30 Sep 2020 18:51:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kNhBv-004KoW-EB; Wed, 30 Sep 2020 15:51:03 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601491824; bh=FOi6aT5JY7VhLnV3Z8NYw2z6y8P6KLonvyYhymTC9Jo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=dznN3RUUtbBT6eXa10zVADnFdgjMWwSpCg/elXgF33cvQGyUfzz1a+j/aGrAHwZh3
         Z/21CKUlJ01erPcQIVqXGc0RBsfnKx3Bit07565gV3YHbLwyk1xR16tYaH2+NJchUE
         8D0ETpzfYSHeEmGlnv0s6dgNAjhFmd4tZ8SZQNPLJkeR29ca7yRpPFs00WYg5B/Yj5
         YD6yIGZRB+NlmpnAj+QhM0Yjm6s7zs1OmSpZXZHPgpmineW2teGAMJGIufiAxkdve5
         Et0M+cEP9R8qI+FknqXPchTpkuOVfjYlbB4UvGDoVU3rwf4xlVKvydNuUnAU4s4kKq
         oUFLQB1Xl6oyw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30, 2020 at 08:47:00PM +0200, Thomas Gleixner wrote:

> > +	pci_read_config_dword(pdev, SIOVCAP(dvsec), &val32);
> > +	if ((val32 & 0x1) && idxd->hw.gen_cap.max_ims_mult) {
> > +		idxd->ims_size = idxd->hw.gen_cap.max_ims_mult * 256ULL;
> > +		dev_dbg(dev, "IMS size: %u\n", idxd->ims_size);
> > +		set_bit(IDXD_FLAG_SIOV_SUPPORTED, &idxd->flags);
> > +		dev_dbg(&pdev->dev, "IMS supported for device\n");
> > +		return;
> > +	}
> > +
> > +	dev_dbg(&pdev->dev, "SIOV unsupported for device\n");
> 
> It's really hard to find the code inside all of this dev_dbg()
> noise. But why is this capability check done in this driver? Is this
> capability stuff really IDXD specific or is the next device which
> supports this going to copy and pasta the above?

It is the weirdest thing, IMHO. Intel defined a dvsec cap in their
SIOV cookbook, but as far as I can see it serves no purpose at
all.

Last time I asked I got some unclear mumbling about "OEMs".

I expect you'll see all Intel drivers copying this code.

Jason

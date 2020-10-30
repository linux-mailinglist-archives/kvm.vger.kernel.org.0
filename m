Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AB02A111E
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 23:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgJ3Wpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 18:45:39 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17371 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgJ3Wpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 18:45:39 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9c979d0003>; Fri, 30 Oct 2020 15:45:49 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 30 Oct
 2020 22:45:38 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 30 Oct 2020 22:45:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJA5a8aJSXHiYElappV0oYLotkUg4a7kpOD7VJ5oaWQceetZ/xHbD0JHbyGb82uvZaYtIk5/KFZaEMEQcM0GQgUulnOgbFTxgIEw3vz35hy61z/QF9Dq78jTc+edAxGP3vQbLeHxTbKYoWuWhWUxQNqLyI/519XAktE0jX5vYYmuitnJF5ehI2p7OVErK0YtrFUJexG+2lqyfhVsVX259eSl0Pf3smMQmW2RM0c1w7tKZiXjW6abBrVKBTW61sHXygcDf3e3+PPPtTP8vwzNqylTVEug9Ly4OWBSEOjcCCTaURP+9UTV4YqbIgAMhCC82/RzHq0nz8QRJE7608q4Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWlteipI794HS77qTwl2/wgfEo/hD+xQwnjJFLbhffM=;
 b=LwFUPsl39nm8O6KpjVqxdkkx8d14wYidBZDuxWPmXDeMhn0SCyZiVmfZfSpQktpVD3VZLpoP+0LKijsfKB24OoAFPHtOkqZ6nhqiu66gsBWUJfatF5JmnPeyPZNWPDnDjotdkYB2F0+18OYfkFcWlL2H7rip1njP1CPCS7TVXjxdKg6L5JUY1I3NPJwgDhc1vFC0lR3RFha0im6skhqnhKI4awrZYvK8BtP0kqvSgMEw8yheJ+WjWkOuqRTiEhX6kWZkDGou+VfwHAZSCRCeilupY6zQZsrbQ1jfKlsIdX0G/bHJdJsx17tr9eLCEV9a81x90v4EGVg/dnPX90Fqfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3401.namprd12.prod.outlook.com (2603:10b6:5:39::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Fri, 30 Oct
 2020 22:45:36 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 22:45:36 +0000
Date:   Fri, 30 Oct 2020 19:45:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     Bjorn Helgaas <helgaas@kernel.org>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <tglx@linutronix.de>, <alex.williamson@redhat.com>,
        <jacob.jun.pan@intel.com>, <ashok.raj@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <jing.lin@intel.com>, <dan.j.williams@intel.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <rafael@kernel.org>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201030224534.GN2620339@nvidia.com>
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
X-ClientProxiedBy: BL0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:2d::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR03CA0011.namprd03.prod.outlook.com (2603:10b6:208:2d::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 22:45:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kYd9K-00E491-G2; Fri, 30 Oct 2020 19:45:34 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604097949; bh=JWlteipI794HS77qTwl2/wgfEo/hD+xQwnjJFLbhffM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=eqyjbqdfdUwt+1S29E22NY4Gx9RcTXghEb7lNOfmQe/gMJLgcIsHt/rqzUnf3dkz1
         ldrq3+jj2X5CZ43CR/XMn+5iLjFjOuJNA0Qwll3kWCkOR7x7LV0ciCoKp560meSsB+
         tqAmBuTLl4QOCu8frQKdRdrjNmzis859zoannIHB3bwPqueUjPOGd2wbC6Oo+haV96
         OLW3LGuMjgHzn9aJc6mLBZARM03ACMjQr9uGb2CuSfYpG7KOd52NtDQdy5B99DXUMh
         rluI/79vsPQgpi4mBffqNtXcDZjSbDjZ9KvgmJ67eVd87+tC5mCMcxzU2whjB0PGn5
         ZFIAjfqUIQMtg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 02:20:03PM -0700, Dave Jiang wrote:
> So the intel-iommu driver checks for the SIOV cap. And the idxd driver
> checks for SIOV and IMS cap. There will be other upcoming drivers that will
> check for such cap too. It is Intel vendor specific right now, but SIOV is
> public and other vendors may implement to the spec. Is there a good place to
> put the common capability check for that?

I'm still really unhappy with these SIOV caps. It was explained this
is just a hack to make up for pci_ims_array_create_msi_irq_domain()
succeeding in VM cases when it doesn't actually work.

Someday this is likely to get fixed, so tying platform behavior to PCI
caps is completely wrong.

This needs to be solved in the platform code,
pci_ims_array_create_msi_irq_domain() should not succeed in these
cases.

Jason

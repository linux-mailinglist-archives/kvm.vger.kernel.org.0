Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6B132A6CB
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 17:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351439AbhCBPr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:47:27 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7909 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbhCBAcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 19:32:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603d877e0000>; Mon, 01 Mar 2021 16:31:58 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 00:31:57 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 00:29:34 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 2 Mar 2021 00:29:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1jIlG7/CAIbUu9GgP7xhDXcLmVE3POkHesfEUynRDNS7mdJRwkeaJVdwT7Ojomk5RKScCey0tSEPAcRK+InGP8lm7sdWEMa8Itw7G0yT932VBlhgVW3e1VlHHuBCch7U1HmVXEHcZNJSGy/cB1AHbEnUoEO9kg4SY8UaVyaXq2ChbHHJgs90PdV2hcGteKfvLGCiCgBrkckJ5eRV0YPcHztX1grTiNGxzNA18yVwnPkEXJoZltHOdgVcETQDADja9UKKclrJrX7ZOv9iKdIaJmX+lTLcOE5lKiU7TPdfhwpF92sv49vffXXpICUWDSFjWiQVjFy3E9+PVPrvFVdCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5p3qz0d3MmM32z06z1ZhgLsmadjADEGju+fXyAYF0jQ=;
 b=FmELEzd3oiHAshDMBpGb1+K5r37Cl//abuaVm8DLU3huEItDbY2kHd081OZitI97UoSPa9oFLB9WiSlOR+mDrCmF78RrK4pgqos+GltLZs03+0KPikAXyOf+mlj8c0hxyiY788/OQ2yNLcLucyhORwR8G4pK9UrHCXU6fRiSRZdspPmMQ6aFrlcPq+1FRrnEA10s5noArIr9hocgsAxbhQzNXeiLAkMILP4bM4uMdcpTrDLTPGyqWzcdutPv7kzK7wER+cS/pR+4ckmUnets3LgkT5amMyaCdLr6MHkox8UrsOiKRAz1t4UpkjS1bzCPvhdt8lH12Gd4xtVFM1IL5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BY5PR12MB5014.namprd12.prod.outlook.com (2603:10b6:a03:1c4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 2 Mar
 2021 00:29:30 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::4c46:77c0:7d7:7e43]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::4c46:77c0:7d7:7e43%6]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 00:29:30 +0000
Date:   Mon, 1 Mar 2021 20:29:22 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     <alex.williamson@redhat.com>, <kwankhede@nvidia.com>,
        <tglx@linutronix.de>, <vkoul@kernel.org>, <megha.dey@intel.com>,
        <jacob.jun.pan@intel.com>, <ashok.raj@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <dan.j.williams@intel.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <pbonzini@redhat.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration
 and helper functions
Message-ID: <20210302002922.GC4247@nvidia.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
 <20210210235924.GJ4247@nvidia.com>
 <b41828e1-ab67-856b-f2c0-6215106ba813@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b41828e1-ab67-856b-f2c0-6215106ba813@intel.com>
X-ClientProxiedBy: BL1PR13CA0330.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::35) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0330.namprd13.prod.outlook.com (2603:10b6:208:2c1::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Tue, 2 Mar 2021 00:29:23 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lGsug-003KLs-80; Mon, 01 Mar 2021 20:29:22 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614645118; bh=5p3qz0d3MmM32z06z1ZhgLsmadjADEGju+fXyAYF0jQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=ECAT7rSeKWZpXxKauGsJ7OWBobvomeYljgx6VDE5RGuQaI1jmPwjbeg0+fs5ScZAZ
         w/KwS/0bcm40+l4hZmFXoEEhj3vhAw0X04/SS/24t86G3JAsWyrD1QYiseao8P+o8f
         TZxt7MGr6FgvUo/P/zT8TJLKmEklNX5DsGFeqFZi794zw7v+Kexhej6CWhwSQlWtpG
         Jfjbsb+hbdZ6sJY94O+y7fFNryYYLHIm5y6L97hTEYgN6kbXhcweY+08MN9zSMBbKu
         fprWyB2NUIdeZPREG3VIQ3Bh80izOzBgRIzdWQDo6stXNg5RSxejZtwKQNNZLF9Agj
         4tln+NjWhRZFw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021 at 05:23:47PM -0700, Dave Jiang wrote:
> 
> So after looking at the code in vfio_pci_intrs.c, I agree that the set_irqs
> code between VFIO_PCI and this driver can be made in common. Given that Alex
> doesn't want a vfio_pci device embedded in the driver, 

idxd isn't a vfio_pci so it would be improper to do something like
that here anyhow.

> I think we'll need some sort of generic VFIO device that can be used
> from the vfio_pci side and vfio_mdev side to pass down in order to
> have common support library functions. 

Why do you need more layers?

Just make some helper functions to manage this and build them into
their own struct and function family. All this needs is some callback
to for the end driver to hook in the raw device programming and some
entry points to direct the emulation access to the module.

It should be fully self contained and completely unrelated to vfio_pci

Jason

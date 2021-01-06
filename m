Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA41F2EC057
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 16:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbhAFPYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 10:24:33 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:64379 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbhAFPYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 10:24:32 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff5d6060000>; Wed, 06 Jan 2021 23:23:50 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 6 Jan
 2021 15:23:47 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 6 Jan 2021 15:23:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lt4sxGt3CO45GgMfRYvUWwml2cJ43BDEKCptGJRD7QJ01nE5revIRDy/yBiXDTgo77BCO+AwtT87CisCfuX3S0YwgBiY7PN4lz6L8/Sl0U+/9kd3l/2F+Q/pB4Bxif2Em/LjHdesWbB+B5OEL2N8YBy/u6DFM9N8SMFI4dmbgTUKggDW2xfaZjB8cukqM216KuoJM6catvTbjEdrr5QplXkKsA+rNXF6i0uRbRhU2HbFDZWj6wqdkhNEsDYMXmGU2M7GMzWg+mdcll09y4nLu7jXldYwPtc3v+qw6RrXPc9NzP7RM7dRbdfJTFOTl67Lmzek4nWwOqroiJX6PBKwpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chutKAOueKzJ42yHzRW86r8VwbDXBIwctf9qcU4AwVI=;
 b=nsZ9F16ZEwFAsg3529nloaL6sACatgV6FruXKEOfFuNo1fW2c9ySpoWi3NWmB02YOEacbBgDPS/bjN7/xYtr90zD4qreiTHqPh3JjtfB5RLzwOCI3gkG28b1MOw2s9KfYsmY4AXtFM9EEHGODFKhDYpfTxMve2QPp4wcLvFVfw47N1AMTSdKN+Yvo3awbXNqE/9ezyRKigeZOihDwB65+vIOrQlUCiU10VvIF4t1tYyXOznB3W3VqYW8SoVdU3yo5lXEHBvB12C6O9GsRmhfqP/jj4qhfNDojspDaL/6n5dRLDh5hWIbFNby5sJGvUsYatOlZkCPRkaSpaif8kKAkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2582.namprd12.prod.outlook.com (2603:10b6:4:b5::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Wed, 6 Jan
 2021 15:23:41 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3721.024; Wed, 6 Jan 2021
 15:23:41 +0000
Date:   Wed, 6 Jan 2021 11:23:39 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Lu Baolu <baolu.lu@linux.intel.com>, <tglx@linutronix.de>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <dave.jiang@intel.com>, <megha.dey@intel.com>,
        <dwmw2@infradead.org>, <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <eric.auger@redhat.com>,
        <jacob.jun.pan@intel.com>, <kvm@vger.kernel.org>,
        <kwankhede@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <maz@kernel.org>,
        <mona.hossain@intel.com>, <netanelg@mellanox.com>,
        <parav@mellanox.com>, <pbonzini@redhat.com>, <rafael@kernel.org>,
        <samuel.ortiz@intel.com>, <sanjay.k.kumar@intel.com>,
        <shahafs@mellanox.com>, <tony.luck@intel.com>, <vkoul@kernel.org>,
        <yan.y.zhao@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH v2 1/1] platform-msi: Add platform check for
 subdevice irq domain
Message-ID: <20210106152339.GA552508@nvidia.com>
References: <20210106022749.2769057-1-baolu.lu@linux.intel.com>
 <20210106060613.GU31158@unreal>
 <3d2620f9-bbd4-3dd0-8e29-0cfe492a109f@linux.intel.com>
 <20210106104017.GV31158@unreal>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210106104017.GV31158@unreal>
X-ClientProxiedBy: YTBPR01CA0003.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTBPR01CA0003.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 15:23:41 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kxAex-0031qq-RW; Wed, 06 Jan 2021 11:23:39 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609946630; bh=chutKAOueKzJ42yHzRW86r8VwbDXBIwctf9qcU4AwVI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=ekxcvTjtpm+oIk7R79mxZfS1daYa4M/bArofO6AFUxp7RVXywivBSuDah1hEIXKF7
         bm6zOaM2vaQtduMT4OgfdmLmVAD3FWQOiEO9yEVaVQxghDJT1IjTjOr0uSE9lq5I/w
         X8WcuQU4PYO6y97OEYFiVNX1+MYSROG0U3Ew6H7zeOFSRLoBVWterStyjKowZXkVUG
         ACTOAM7nMEN90RlZZp7TnrVMXrvMkoIPRiuVYYOgzJifUP0HeJcJrPiLqyg+MiSqKd
         JnL53LckrctGi6Jpib9X+0WBMdNjOURleR/jOpReeuiolmT5i5NTPNVR+d43xOwYYb
         nZ9SE+Omw2/YQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021 at 12:40:17PM +0200, Leon Romanovsky wrote:

> I asked what will you do when QEMU will gain needed functionality?
> Will you remove QEMU from this list? If yes, how such "new" kernel will
> work on old QEMU versions?

The needed functionality is some VMM hypercall, so presumably new
kernels that support calling this hypercall will be able to discover
if the VMM hypercall exists and if so superceed this entire check.

Jason

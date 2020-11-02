Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3952A2B57
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 14:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgKBNUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 08:20:44 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13172 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgKBNUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 08:20:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa007af0000>; Mon, 02 Nov 2020 05:20:47 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 2 Nov
 2020 13:20:40 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 2 Nov 2020 13:20:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obBG/vg4qh6Ngu/iY9HEmm/JmE9FC8/mEe8l3GRGdJXC5cyLmojrTR6PacWiLT4Wq8BtxEsnb2Wgs1THdFy68QY4uVv9Uw9s+aW7mF7c0Vh6P41c+AP7JVvZo9+8ZPn6Kpzyd/ejtg7vdTyy09z24/DwxnzmfBlsK6zZN9n4UUqwhFFk9xp43n6oj3kPIKJHPIRyQEiXPmKfmelrpkOmhAMLblzQf6JUGp8Kx2JP9VPr6RBaSS9Chirk0jx+8Obueek4fcK1tOAhHFyv9VDOt98IvEvjZrKRSwPoIjsximCRnmQvZab/B1Ro5F/ez3ih/AEM3XkNDKXZ+eOl290PdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CE6EA7NrZqctG4vMu3984r3VLejGChlS1r9sYWz4b1E=;
 b=AlcxsD4zHum/d6ngFVHb2+g115vdPE1cIOifMB9o4D+X1IHfsSNTotua/DWv54AFIZK8PPbGwCQDxP9HeUeK30ZffLiquWsvPzDtQlYd8u52+6kKERMJed0G3n6YoIemJMlut340HchxbnqlAYuM3kWeAs9JQHc9/bb06Q1ugfgvRoTiCQujc++gfSxVhqDPZ3kxi2H6dS5kB0LPR/J66jBISN7tYXOkMKdd3kMYu7jWzgJnjKzOA24K9cOZjAqvoDgbmI7JAQtg7TvwPAaECOES7CGVXUcJteNqkO8zkmdTw8DXiJEjPAYi9px7y72mDVAqMGvBG1LUewk/IOv53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4810.namprd12.prod.outlook.com (2603:10b6:5:1f7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Mon, 2 Nov
 2020 13:20:38 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 13:20:38 +0000
Date:   Mon, 2 Nov 2020 09:20:36 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Jiang <dave.jiang@intel.com>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <jing.lin@intel.com>, <dan.j.williams@intel.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <rafael@kernel.org>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, Megha Dey <megha.dey@linux.intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20201102132036.GX2620339@nvidia.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
 <20201030185858.GI2620339@nvidia.com>
 <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
 <20201030191706.GK2620339@nvidia.com> <20201030192325.GA105832@otc-nc-03>
 <20201030193045.GM2620339@nvidia.com> <20201030204307.GA683@otc-nc-03>
 <87h7qbkt18.fsf@nanos.tec.linutronix.de>
 <20201031235359.GA23878@araj-mobl1.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201031235359.GA23878@araj-mobl1.jf.intel.com>
X-ClientProxiedBy: BL1PR13CA0052.namprd13.prod.outlook.com
 (2603:10b6:208:257::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL1PR13CA0052.namprd13.prod.outlook.com (2603:10b6:208:257::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10 via Frontend Transport; Mon, 2 Nov 2020 13:20:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kZZlE-00F3f9-1s; Mon, 02 Nov 2020 09:20:36 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604323247; bh=CE6EA7NrZqctG4vMu3984r3VLejGChlS1r9sYWz4b1E=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=U5FU+9RwPzwwsNCjR7GMWT5xiVesCaLxDXwprLuhkfTBlK7DgK098WVz+nbIQEdwz
         Xfahi4xSeokx9cmQiYDDiZ8NSGoI35Ax3tPFzYGyITGqf7mAMaLlXK93fRwvTxGsd+
         tYatqB924tl41D1cQo6L6NpFsYhHGeZjlsiwrokQmXA4WFJ33ad2KGCMVnOTO/dXN/
         NthgO6q6x2Kn3Cjk8idyVskg4LAqLPat81Fsrrz2P6dQd8/xRFpyeGvOt1zmLGLUii
         8VGZ0V54aAn4leHtBdbqkZop9SKI8HtE+pVY68OXFaUNFBII7m4UwIJAky0EQJQudD
         Mr6eVBUfMpwxg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 31, 2020 at 04:53:59PM -0700, Raj, Ashok wrote:

> If we are doing this just to improve review effectiveness, Now we would need
> some parent driver, and these sub-drivers registering seemed like a bit of
> over-engineering when these sub-drivers actually are an extension of the
> base driver and offer nothing more than extending sub-device partitions
> of IDXD for guest drivers. These look and feel like IDXD, not another device 
> interface. In that sense if we move PF/VF mailboxes as
> separate drivers i thought it feels a bit odd.

You need this split anyhow, putting VFIO calls into the main idxd
module is not OK.

Plugging in a PCI device should not auto-load VFIO modules.

Jason

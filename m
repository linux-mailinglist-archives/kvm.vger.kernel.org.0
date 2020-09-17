Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3D26E064
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 18:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgIQQNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 12:13:05 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14651 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgIQPOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 11:14:39 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 11:13:04 EDT
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f637b320000>; Thu, 17 Sep 2020 08:05:22 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 08:06:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 17 Sep 2020 08:06:51 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 15:06:46 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Sep 2020 15:06:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaouiH4n4ErE8MgvABbxLCQ8NNZs8aSo4+tV8bhHZOaJB0s4LjB/570uBuE/fmfMxHH3ZmduM5khcoY31WjUMV1N44LjcCo9pYdfSHVK9Ln9y/k2MjZdNNr5jduPSWgU2/hqCw3B+mPQdeUOOOaZm/t2JVcPuojcYIrYHrlUSQ+DjA6R/1jhWThc6raOsaxiPli8lrIJkBX+yVupOO6SI0Qz37B6YdTojhUP73ou9wQwON1O4PzEShGxEqFm5OigcJhuI4GcB5Bep+GXu50v7An3T8T6zNTDkzWGVzFgkF60R8ni3yGkTG5pO6Xg3F0cDODOXC0MbrHIdn3VbJ+6wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=114Y2T88q57MBNudUVjmRHVj56PrRbxje7YL3eLOgpc=;
 b=itUv+b9inYpmbtDitHrXGJNyv/upb/FlC+5QezbRKFRPWKaqQeDZotU7rCyHYjjeAqgNVR2PmQzCzy62xIsreZKRM4IymrOraaRVHpV4Q1Vjr1zpyF4e+8CTx4P9+8+W/eHHjp7ufRwVSUHj3Mf6hjhJUrDGmLQ6VOGg/xdVlra8RZbPcJMNdTbd59ZrX24CPJ8lfuFnqx99Yju3Yq8OTGPJArstX4KDPWzFpXJ3DIUbM7a2NluG5jEl5fDTAUP/GaP0va0FphGUUOyJrN6EGBgOPiNnarQTvy9TASVV+44sthf6MrTVvOoPk2khdPa7ZsMb42DyJfHPjddELy9JUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2491.namprd12.prod.outlook.com (2603:10b6:3:eb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Thu, 17 Sep
 2020 15:06:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 15:06:43 +0000
Date:   Thu, 17 Sep 2020 12:06:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     <vkoul@kernel.org>, <megha.dey@intel.com>, <maz@kernel.org>,
        <bhelgaas@google.com>, <tglx@linutronix.de>,
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
Subject: Re: [PATCH v3 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20200917150641.GM3699@nvidia.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: MN2PR20CA0007.namprd20.prod.outlook.com
 (2603:10b6:208:e8::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0007.namprd20.prod.outlook.com (2603:10b6:208:e8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Thu, 17 Sep 2020 15:06:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIvUf-000Vd8-NX; Thu, 17 Sep 2020 12:06:41 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bccbaf2a-957d-4e09-50a0-08d85b1b49c8
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2491:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2491721156D926F5F4B89FB6C23E0@DM5PR1201MB2491.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6yAtT1XdRgC4Tr2yBdCiSdlwK98sT3HL/OctJNRgtMYihmDURcWZ4RNMrTxoNGaQoVdOgUPkgBvuLfE7bR5t3ixiNubzyesqalZF0YZKMKUIT4q6lCLl9yY3MMXooZefKcDP7/N4bUs62zdi2qETEoUzGhanFo9g6Jz1LQCLLXWgv8qCWg2y6JcePH7JQXKOvcj/CUkmE3Zny/nxQESZSyezdZVXK2LmmGC9mXPpReD7UMobrw7GV0cB+JDAGh/IYNeDRP0owMC+L5uQssMHOgsTDmA9fjMGNZjPuxRC8vFf7589r7zGVeIRI5PXCzV2ACwY4WI9Hn3XAfE9bEaouQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(2616005)(4326008)(26005)(478600001)(426003)(9746002)(8936002)(316002)(9786002)(66946007)(36756003)(66476007)(6916009)(66556008)(186003)(86362001)(5660300002)(2906002)(7416002)(1076003)(4744005)(8676002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wz44S5/4xKHMatAoEOzW6QLXSoBHGQ6KPpg1nZx2Pg357zehDRqnMSHCVsZJtW02/X6re0FFsXw1SNBnZlHV/PviCVoAAceZTfuGGipRRWTMjurYzbMN5J8inDJ1kMilri6rR+lPJXLLV+504aomDMhg/Mhsz7RVb7BpGL6NvR8MRbTLyPglkwdHeuzeyOMMk/ua9x/4EfO1Ru+ZZ3ksUVnD083nGihrXbGnzAyPOV/aNyhR9nzR+IDZbfLGmr+T0jpQm7BzvOY+KkeX+xzpbCm+Af/l6YMmyoCadYboe1Ps5oimKXld0jwRy76WtBAbnxu59ZbBL7oDdwMRM7c6Tp0zmP2lTi4gHU1sHo0xCng5Vp0PeazJ6zDB+PhJYkIu1VVoxy6H96ggsleOS7MBgLEuO5oWWtG/H39mRV9xHfy7qk8PKTdBIpopjiyovUiRxv7aED9BePZxnEFNNYefVpOXLbQbcJtzzPpOnrnWMiaEptg/yUq5PYV+6rxkbAytTLUMF5IJwS98cqvjrcweGUvsUrV1GaoWeYg+6dKJty/oa6jaOZo+rJnkjmyc41fycGEhI62jxzRi1p29acXYr69GUK9WE1cAPQQs+zZqWt8FoZOhaTt4Gsb68JZg6m4MR50f6iNusS84+5c0B4CINg==
X-MS-Exchange-CrossTenant-Network-Message-Id: bccbaf2a-957d-4e09-50a0-08d85b1b49c8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 15:06:43.5812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dlEWRP432d/DwfghM1HLQebsf3OoblkOq7294K2KiaIYQjAu7w1tX7oJD9P+3vI1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2491
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600355122; bh=114Y2T88q57MBNudUVjmRHVj56PrRbxje7YL3eLOgpc=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-LD-Processed:
         X-MS-Exchange-Transport-Forked:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=OK4zWo/8KihA2516nS+iwg45+PxYr80VnS+otJWUh0qRbJjkc2cJaMws8USTtE4NZ
         AveRUHeC+Dn3Luw444tLUUvGUr5sncuBRrzUfJa8woLOquO1gLA8vejIrRFfy61o2Q
         ZgR4SDH+NCBSRtSTNNPYOkJwTE7IvvmjwPHIV1d4ND3B3skMkWI+IQdo77BqOOP+Bx
         B5KUaIJfOrFTYWO7puimsDFAh+EXzDvz+cYzkqGhpbcM1mEW0p65vDMgRyE/GqGnHv
         W8zfDNztMIn3jTcVnBarHTMQG2KJ//KFkJikKYelyPAXIM69hB5WJ1V/FY9/yyV6Nc
         O5dSbo7ehvRLg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 04:27:35PM -0700, Dave Jiang wrote:
>  drivers/dma/idxd/idxd.h                            |   65 +
>  drivers/dma/idxd/init.c                            |  100 ++
>  drivers/dma/idxd/irq.c                             |    6 
>  drivers/dma/idxd/mdev.c                            | 1089 ++++++++++++++++++++
>  drivers/dma/idxd/mdev.h                            |  118 ++

It is common that drivers of a subsystem will be under that
subsystem's directory tree. This allows the subsystem community to
manage pages related to their subsystem and it's drivers.

Should the mdev parts be moved there?

Jason

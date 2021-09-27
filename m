Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03890419E4E
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 20:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbhI0ScI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 14:32:08 -0400
Received: from mail-dm6nam10on2076.outbound.protection.outlook.com ([40.107.93.76]:51681
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236025AbhI0ScH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 14:32:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTV+BPYuVQaeaKWbvq0J1IwDc1blu8+3EndRVfZa5qw+SXraeoWW16ecLneIPuFQ4EF50yxpufbSHOz00BmASuJgUtgJRWz4WGD/lrmru1N1cqfCd3QLe+EvSpXYkyR5Ioo8vlwedNfCVew/rdJehFWJo6bBOPvwiZx+qQbBgN2CtEOaCbznwvGtBdKfoUmUJbe8F6cfGY893ObcIKDPhIFvq/yfQFacVU9JnxsUjMa0/sgUbcQmFlHUYnsZGRyrBudVmcQXGlUs8SShiqixqjUcs44TGEtyRTa/9Yz8A6oY7djWk2bKlUp8UrNyW+GxKgrc6vh7lZsvcljn4W8GkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cEFlAnvi83+n+/BuHrauSB/IM49Av3NtVFJVQ/nbk0c=;
 b=RJf2cV7zbKLcfhzbSie3wiKppHc+TuFwwaup7Rrtyu1zILor4mf4v97NcP9ZrCl+YS+L7puXTWJS/TaovApoFdsDdEoL7kAM9SeriYSdO34sfbVBb7CtEo6rAwwN/iO4/RoPiCdOOweEOX6amIAUdf4LqiKbyemSyVFYXgCuy7LRmXGr8KRRfs4HshXSNQho3VwNB03319u5DPJcvblctPc1bnnaP5Eyeb3OBoNafsjjFTh0veY+v/eVZ59y0AlDc5ahdNa7ff1528+eeCKBpe642Aon2uk5rLNBAg15D0w7MxzjFgDKt65yjIpylBI0eP92L0UUV7t1AJ0a1PR5rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEFlAnvi83+n+/BuHrauSB/IM49Av3NtVFJVQ/nbk0c=;
 b=SU7C9sESGe7INHlyXRPlogiFuitoBfsJX57Yah2wWIJhxsaLHl8h1Mxwq8S5e8X6y/teBzJxRvGV7WboY4pNn5EIEkhtO9lsunk0LC8vW1olwIvB+q4omVO5kCFCGlvkCL3qxzlvfuGCCPJnhA0KpKSodXfDcgBsBjZDLvUVB08p2Q0dv5TTtnLX5Y1WE6lqy1N1CaobbO2PyKew/k1EkZscsyCFpuUNpGPd4ns58toR7ZbDNg8zN3EeSiTmw19O96krDzU22de6TT1UAwoP0rKQaYP167GdzFCH5AOA1D3c+KWZm0oYU/cBRN8DC8ImW8DPTV+kOq4yQ6TBCzBWew==
Received: from MWHPR13CA0007.namprd13.prod.outlook.com (2603:10b6:300:16::17)
 by DM5PR12MB2341.namprd12.prod.outlook.com (2603:10b6:4:b5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Mon, 27 Sep
 2021 18:30:28 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::1b) by MWHPR13CA0007.outlook.office365.com
 (2603:10b6:300:16::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.10 via Frontend
 Transport; Mon, 27 Sep 2021 18:30:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 18:30:27 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 18:30:27 +0000
Received: from localhost (172.20.187.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep 2021 18:30:26
 +0000
Date:   Mon, 27 Sep 2021 21:30:23 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <YVINv17OEHplrpeS@unreal>
References: <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
 <20210915130742.GJ4065468@nvidia.com>
 <fe5d6659e28244da82b7028b403e11ae@huawei.com>
 <20210916135833.GB327412@nvidia.com>
 <a440256250c14182b9eefc77d5d399b8@huawei.com>
 <20210927150119.GB964074@nvidia.com>
 <YVHqlzyIX3099Gtz@unreal>
 <20210927160627.GC964074@nvidia.com>
 <YVIKr48e8G1wSxYX@unreal>
 <20210927182224.GA1575668@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210927182224.GA1575668@nvidia.com>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 330f91ff-5be4-4427-25e5-08d981e4e119
X-MS-TrafficTypeDiagnostic: DM5PR12MB2341:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2341B07C027F5F885E66D1C8BDA79@DM5PR12MB2341.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zt57+lghO3S2D6UYjC2PT6VVNpAN9Uj7W5vDLHdctXhJyVXwekbeJS6xn8HrRCOP5iJNDT9LVRL4RvsPCqZg2JZp/82Silyp+KSRzUUbHWDB8gi5rMMEWmgxTHeLeo3PT1BGNf5Ewur14zZe6iy4VfwdaTd6HRpCcNsHm8Bxw3UMBYBxdEJfeNMV1XmSsqY7nQ1nFT4+qRXfIK4wjY0DC4yJJiAEQY/lt+0K9oZwWimZXxLK6a0ILU9shaVxJRuLsAF7m2isqb+HNHtc7zhvyM3T1oRMUwwbfX/jasy8HHFk1m6Hpgx1hiV2tOTTcKJau1+XigOdVX3OqrptZhf+E+JNI2YLhnG6x2n3hMmIjj5pKRKK83Cc7qdPZ7zWjXskKei6W1IOvuy9aSaVKe5eroMTVddazkQR1JSO1MVHe+pfM9MLY4CHgSQ5MsMxywjNEcN/bDOfCMnJoo6DzR//xF0kU2qRKhoWKcUy+yfHdctSDRl78eysD/m7S4KRI3m/lXwz/J/w4zFFYqvBewf3+N0P8WX1ICBmQf4lcB1FY+9TpuP+DxZZKCNeIkbSStOPmqkQdlNkgLnLr5kpaJDHRpvzJKXebunT5FtSKSuCCMcYttBAvI4UMjoR+UFmTgInmK+hvsAr4t/D47G9VGZt0jnk0SQu+Xayzc15yRjOsAaNKZeq4pYSK4+nn5t6mSG7HOZ3rk83dv/IIjiRWkWdng==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(36840700001)(46966006)(5660300002)(54906003)(36860700001)(47076005)(36906005)(316002)(356005)(82310400003)(7636003)(70206006)(70586007)(86362001)(9686003)(8676002)(186003)(16526019)(2906002)(508600001)(33716001)(26005)(4326008)(6636002)(6862004)(83380400001)(426003)(336012)(6666004)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 18:30:27.7674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 330f91ff-5be4-4427-25e5-08d981e4e119
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2341
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 03:22:24PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 27, 2021 at 09:17:19PM +0300, Leon Romanovsky wrote:
> 
> > > The point is to all out a different locking regime that relies on the
> > > sriov enable/disable removing the VF struct devices
> > 
> > You can't avoid trylock, because this pci_get_sriov_pf_devdata() will be
> > called in VF where it already holds lock, so attempt to take PF lock
> > will cause to deadlock.
> 
> My whole point is we cannot use the device_lock *at all* and a
> pci_get_sriov_pf_devdata() would not have it.

Right

> 
> Instead it would have some test to confirm that the 'current' struct
> device is a VF of the 'target' struct device and thus the drvdata
> must be valid so long as the 'current' struct device hasn't completed
> remove.

I'm curious to see how can you implement it without holding VF lock.

> 
> It is a completely different locking scheme than device lock. It also
> relies on the PF driver placing the sriov enable/disable 'locks' in
> the correct place relative to their drvdata's.
> 
> Jason

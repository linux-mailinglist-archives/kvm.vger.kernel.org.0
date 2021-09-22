Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AC54153B0
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 01:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238385AbhIVXCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 19:02:54 -0400
Received: from mail-bn8nam12on2049.outbound.protection.outlook.com ([40.107.237.49]:12896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238338AbhIVXCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 19:02:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfTrPP889tA3swqj6oCjY2ADDiaGXHfRfHkfHmkw+pR/fzzqjAqHgVN+LavenH0eTB4/lO+pY19pUKEmTjd/gAIhKpwW6ZnDTssK3esiuTjRweoUDKXMWXT2FIK/0/24CEdT4krY/C5glYPYNtitqpVXhpZL5alpWYDTxyCcWiX6toLSL0TEt2HM9QlHPfrO7jfT5Ci75GIBcJMPCIH0uYbxvl64GOZO2RvkejRvk5+act+WbQaY7XF6lexlM9rYexawVPDvkbBUJV3pcy6JHLCEOMmvqnz6g6EeB9JgtVO+b78D6bZ00Zkgg2jZaHTlAKUbMVOXh+TlWOFgnNTxmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XSvNzxnFrfmAuU25wGWIry7h3on/X/DT46n52EFvyD8=;
 b=oMqbN6lQAoV9BxrcaRMnJH4c0kO5GYEqT5FMPa+QTSrF+3dX3BBjkdDbSsdCI1aGML2yEkG8ZZd30uwioLUCj+lBUNtJ8QVL2dDp6pWzkus1e78CMal7JC/6kZVbgCMDi9bLzneli47rCOPiWqNX8A9MnvwjyE1ytS1wJjq4SzDcht/kJr0O0u73eDIy+Y3NPHIW6SAMTnZjbzV6QeD0SJjApG+pWJqOqngMSAsBuMwUCCNT/Qtk+SlUR8P8P8Sgs1sSv3BvTTFH5M3/V/Qv13krSj9uQgGnQbfnLb91jo1PW7tneA8ZPdi6NG42DjK/JLq3YYeXOLb8froYp/xoyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSvNzxnFrfmAuU25wGWIry7h3on/X/DT46n52EFvyD8=;
 b=GtQacnI/1NHrv37mmDHOXZN7Ndga7+n1FE01dt6WNs/CVpXy29Wz0MQaumzLvTDDWegM60/usyXNOHzUz4MlGCRQfJz6ZLJl6Wnr0oXRbEJtRoCRp1+AArZdRqcQ3aujf06jRG0BY6sBPkKmzXcEmPBXhExVmhz9O56jDZ/f8f8y4R8dLws172FS5SCMjYqH/ieenjYAhLXmoQ5Am8ex5AYiTFtTHM+05W5IJ6hlDklWVoT41Ovo3fWf+NXZuXSlCP/M7ZyPxhAxEOJXhnIfUsaJdxdFvrzaF7UhP5hHpBE65SxqxZ6waSNdqviBiLVJgtVAJd6u2ECAmEr/hnOBGA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 23:01:18 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 23:01:17 +0000
Date:   Wed, 22 Sep 2021 20:01:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 08/20] vfio/pci: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20210922230116.GA964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-9-yi.l.liu@intel.com>
 <20210921172939.GU327412@nvidia.com>
 <20210922150101.5548eb6f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922150101.5548eb6f.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:208:329::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0065.namprd03.prod.outlook.com (2603:10b6:208:329::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 23:01:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTBEq-004ArW-El; Wed, 22 Sep 2021 20:01:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd095552-8826-4d8b-c49e-08d97e1ce299
X-MS-TrafficTypeDiagnostic: BL1PR12MB5061:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50617340D7DD2009F402FA89C2A29@BL1PR12MB5061.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CPLBUweFaDXYRgfkuedxKkjfnhN3It16cc7jGl2HbVpmg3uwuf5Wl3vyEhGTv2U3zXlXIJq9aEofU1vxnD8hpAZJJ2s8Vln0TkrFTw/aOsG4yu6FbJxGls/CmDOosondIpJ73yHV1fSqwHBBOq4b4MgyUcSJyLozy1R+Tpy74oe9OHaseK+RXuwM2v83CynkgncEXFHxCgYXPP1Wm9GYf3bcbFQQXvXMmiJBQzwLCmNrvFfkaPi3m7C2vF3LIAVdfY04NH/j1ckpV8Rg6Rdz9pCwjF/hqo8BOgtWcCLXC8enP163ViAO5YrOdloWCc6vlprFS936xHKSq0+DIHC2qvoCkQYtH0iO/n22vjYqHyO0M400GnRBFqSTeatKbqW5nSzYVaQrb9xV52JRS6ZWAFceUjehyzSYC6gtwmqWS9JIsmGxLVOjSJrSKMxp5dRtbld557QV5qihFtyhIDOSsn5eUkUZkFLS3Sw7tV8R5u3FLturJEn5U+AQzA1wuSP6/k/IcWJEn6o/u7sFCY6QouTVh/ENts8qJtyOFtfHy6TiqkAxT8ZbEaha3ziBeG6X8kJ7iWG1C0BYl7LXIElNgTW7Hl2GmdVuFhGIQKcG7k/JuzCrMHg3wDgBUlkKhRDMAmVFKyrg7fwbXjsalJm/MnmBEtCrqFZI6DOCu2cFvxu3FewMZ6lKgdpMlNPDVGli
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(426003)(66946007)(9786002)(9746002)(83380400001)(86362001)(5660300002)(6916009)(38100700002)(4326008)(66556008)(26005)(316002)(8936002)(1076003)(107886003)(2616005)(186003)(4744005)(8676002)(7416002)(36756003)(2906002)(33656002)(66476007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hdULciXj+qVAATUtJaXP8S1nbGqjrwmDQiTE0KIQt06SwRe5oUS0AJJLz7Q9?=
 =?us-ascii?Q?cPrUqwN4AhLCVBwP6USuS/FGT3/Mi4FU1KFJk6Ae3F5/VlgL2W30PAG8x0+n?=
 =?us-ascii?Q?dDSh3Qs/UA12cVQECQkwWpMzB7xndwqJi2N88pemILD4YV1V7mKBls/nTzrk?=
 =?us-ascii?Q?0kRl7Y+fJ268JuwFE+nuhzBsyoYUZ3BKGEQs6ftPAD/VYizFV0mli04i5qbT?=
 =?us-ascii?Q?alzk7J3Ev1bVPf10qu65M3goGB37yzlmbpqVhhkqtevCLU2I7n+Be2/I1mBk?=
 =?us-ascii?Q?7r7jTmR6P0RykAwP6qL5OIWe5sAU8aCc+Yy+W6LJk8L7WP1IQTkxXzWEmSVT?=
 =?us-ascii?Q?A0Lh4/3iXRoq2qsmF7xCwHzYzrqncutibBDpPWlq3onMIfnVBA5/vmeeG1Ev?=
 =?us-ascii?Q?g5Agccwu7haTcnMy+eSPL4P8PPrSxOBe20COhDKJZh2vRlMobB77lHf9t/Lf?=
 =?us-ascii?Q?sX9uGu45pNbAEN45lpddXi8V0T3kj0U8wJekS/JscKvlXeNsqckh4Y+j7Itv?=
 =?us-ascii?Q?Lb+aOOND9f/p0iRoeIUaPWeKQGIgl4HDeCJgCUxHe8M9qxOBgFNg8GoimcQ0?=
 =?us-ascii?Q?6jVfIKsnRacTXpCxm03f74SShZyzdsuPl1jBrvqU/PMBVU76LIg57uxnTkBM?=
 =?us-ascii?Q?xKsTPzzAA0bVjFLM+5hXxgek0jgpD79qf/MrZ3H/7FFiOLc7kwJr6ylM/K9c?=
 =?us-ascii?Q?psrvAvRa0fGBUoYI5GA/wRV28TM+I4ilq6NaIU7dbKXN0MmBMEj9GcGcu5Hi?=
 =?us-ascii?Q?l2VaASc6On7XdgrMXch7nMxMN5DmROj1ewCxb46QX259bJyNLiyWL3Jo5eWu?=
 =?us-ascii?Q?rRjHxlf1nCX2uhknVLDhIaUtUnLZQoKOmrpnZiWhzyeE6T5+UmtoBfUqNVXr?=
 =?us-ascii?Q?sjzoG/60CGV+rotf+KcMKQBRwQ7gom1Rg1cMBnMtmT01+7InCzNsmvZnsueI?=
 =?us-ascii?Q?wdKAaDdKz1PBi3+URJp16ymHJuJaqlcrLbKEJRBzXujnaMTQsMoUieVyHcJd?=
 =?us-ascii?Q?wtffbV6wzEh5HbIxXRbRTtIyDoksIhEz1FfPlawEIG6OmhsiJ00ItIOg2Baa?=
 =?us-ascii?Q?HJvfT0lvYgojKgTdlMCJWxSmPl1W1FQh2w0aXV+Wjtsr0mmvMCbGAm29qH84?=
 =?us-ascii?Q?9CaWuLXc8UCrm4Ec3/+1QQIB67dVroC93PB3GDe2Gpv12JtW3hseqz3tmqig?=
 =?us-ascii?Q?0faEUSZCK2jJt4K+KXy7hoCXjAviMPw7O0xjbal/3fmL4N0a/7F1AeneeOK9?=
 =?us-ascii?Q?0wN1UydeP0zMHStB0rowhdlWf6isXdg9xrfWfcYlexePET3A4i06g9m0iCns?=
 =?us-ascii?Q?pzuLQtgW7HBhlzscA5xwZbBS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd095552-8826-4d8b-c49e-08d97e1ce299
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 23:01:17.9480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ma36RUgnXL/0h4/wE4HVYTW4IFJSm2q8gFhFOl6pC6I2wEC4VGprOC4FrnavgFw1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 03:01:01PM -0600, Alex Williamson wrote:
> On Tue, 21 Sep 2021 14:29:39 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Sun, Sep 19, 2021 at 02:38:36PM +0800, Liu Yi L wrote:
> > > +struct vfio_device_iommu_bind_data {
> > > +	__u32	argsz;
> > > +	__u32	flags;
> > > +	__s32	iommu_fd;
> > > +	__u64	dev_cookie;  
> > 
> > Missing explicit padding
> > 
> > Always use __aligned_u64 in uapi headers, fix all the patches.
> 
> We don't need padding or explicit alignment if we just swap the order
> of iommu_fd and dev_cookie.  Thanks,

Yes, the padding should all be checked and minimized

But it is always good practice to always use __aligned_u64 in the uapi
headers just in case someone messes it up someday - it prevents small
mistakes from becoming an ABI mess.

Jason

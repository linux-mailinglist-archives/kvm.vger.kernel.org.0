Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D7D46DB1D
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 19:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238933AbhLHSej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 13:34:39 -0500
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:26208
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S235141AbhLHSei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 13:34:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bzu7nzrRq2koojpkIesVMBIdB20CB2PxtLufxw2cMz797ljcAdgdFsQsXZrnYDPQOZTn3ydmb9nz/Ps/8sxqiZiVIFd+nUPsjWKs+5bCcbtCPdluIRA8k+hdNY8km32Q/eincxcEzGkCd+gSfz03MKhfO691MVluhHr4+5hOCjhzoQAg8sBL8gLk1OEzuQQq0VH4AwFBXcfmBXd2lqq1ymlg3vo2jta2HFtVN+ScjBcloVF0yEHO2E1a9JGD51y40nyzOsoEMXX/GjqPD0t2/79NskA+HSUVjjgyWE2FxcHI9ixlwHuAESwmGFTY529JjKD7MEnZ2NFpb97DIu5nZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5s4EtS6S2nZTEiIr45/f78dzWgKqtBd1A9Wx7UpxHE=;
 b=ZOVkT1C7tNgtmQ7vYNSLEan8/f4Z1VtkGAimD9LPLGb6AdEVPIsboLlEgAhgqXfVp/hhC9QmFvQc88E1evWRlMaxFhoxiomn9HfNFsM4WtmrM3+CZnoSxmzpU342vyp+T9Y3u3O6t/N3L0u+vJlh76hXPOrKSGzmkVykl92iQRMclgeZhSGCVfK7/D0Cnyig8NTAs2EePNh4Uk/nA9W31oxwZUpuZmq++E+wsSCgbkgP1NadFtT+R/fRL39Bh0ff1sEbhHRyuIDx0qR8+hy6Q3Q+aht4JM0/bFaeU0tK0XW39inu7Q95TDs4Zf6p3f1CggsvgMlaTm7yKwe6qXgM9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5s4EtS6S2nZTEiIr45/f78dzWgKqtBd1A9Wx7UpxHE=;
 b=XadHPGkhyd5zjXx1g82/SHNkyv31UL9XnBQ27sHWzfMhPBF/YwsPNNYENoxdUdpyfXFJa0HCIW7Q/Q9IUE/gGM/v1iv6IOrkXHgtKf+eGTID699mLFKHGuIvApBsC/IvRII6/nQKvoSKcVRpSeutUZbiVGaI+4X1vs21XoA5w5TNoe/MKBzcj78adaYvnP990iHooiXPIjHeWdt1xe6j7N8gx5hWUWuiYdQb520zVUSt7f5fAorZralhpmbDaWyZVzKIV0l0NhGB8ogAFkYUrUA71q67lahoziFC435dfHxpOn9+wp98o/N7mg7zfhuuTUJiglRYugiCEZLYQuLvIw==
Received: from BL1PR12MB5029.namprd12.prod.outlook.com (2603:10b6:208:310::24)
 by BL1PR12MB5206.namprd12.prod.outlook.com (2603:10b6:208:31c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 18:31:04 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5029.namprd12.prod.outlook.com (2603:10b6:208:310::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 18:31:04 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4778.013; Wed, 8 Dec 2021
 18:31:04 +0000
Date:   Wed, 8 Dec 2021 14:31:02 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, peter.maydell@linaro.org,
        kvm@vger.kernel.org, vivek.gautam@arm.com,
        kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com,
        ashok.raj@intel.com, maz@kernel.org, vsethi@nvidia.com,
        zhangfei.gao@linaro.org, kevin.tian@intel.com, will@kernel.org,
        alex.williamson@redhat.com, wangxingang5@huawei.com,
        linux-kernel@vger.kernel.org, lushenming@huawei.com,
        iommu@lists.linux-foundation.org, robin.murphy@arm.com
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Message-ID: <20211208183102.GD6385@nvidia.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com>
 <YbDpZ0pf7XeZcc7z@myrica>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbDpZ0pf7XeZcc7z@myrica>
X-ClientProxiedBy: YTXPR0101CA0068.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::45) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a61b233-78c8-4f26-4fd1-08d9ba78e433
X-MS-TrafficTypeDiagnostic: BL1PR12MB5029:EE_|BL1PR12MB5206:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB50299677FE40EBF18F5DC3A2C26F9@BL1PR12MB5029.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5f0iKkIy8tchyKgciaPxJE0A84e9Fp5H+KMuNUGOm/4zMlePSvUCQoG0jBTvdbW3y6Zw9Us8byrQqKDSdHzbo2i8o0Lh3SM5Scz/Y3e/lwMrVCfntRL45vzt9T2/k8ZjlEeJt/XNksMqhu+PImex1qKpjl5sountwpYPsLNebeGnF/RrTJ8gnwcz3ZwRoEY00P4AcT4+ZhTsM827K5HUCsWdFKZ/MMr8RPb0bS0q1ImCPyWKN3umNUHhGxCMIFhQ9cQVMvMBRsry/URgKJ6K4JEcZwJeeJ5hdVizgnFEI1BH9y/vCTpNOs+swHk8L91ZMK0gtMIZBp6bi0gQU0Ys9u7BIX3j8HMDXIPZ3zWLzhcBW/sPjdxVezvKCJnZAPbKJAH7eYDJQsJWYWyy6AxP9AKRJrnezm187zkRVCI25sY0o3pgKqpp81D1a8SKbq5VuqRQou1Ph55I2VTZ5dYLRdqjCXPGumsMNtM/MDB9xGQgIPb8c+YpO+XdJxXkWTOiI/UnIkkFVLITvn1d98Dxal3kD3mIdjJHttFAVxumWrZ5wux1o4O0ofIJgjxJT0cZyVzmDhVgH5gq/23Xnm9SI3Yc8S3AitYgwjrV9nuc5EgrpAJsNGlQTJ/28aFuh/3HlAhml8kPuo84WDCmNjTRI9aBCycfVqZTJOXpJCssh2nE2cIkQ6P+tJV3XcasH2Jk1q3Z5fjfTVGi5ntCOpWjBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5029.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(2906002)(6512007)(316002)(7416002)(26005)(186003)(66946007)(33656002)(54906003)(66556008)(508600001)(2616005)(66476007)(6486002)(5660300002)(8676002)(83380400001)(86362001)(4326008)(8936002)(36756003)(6916009)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0ZkvjLdJl0Vu4WoRcx2HVrCPQiqASS8KyHCJlY909l3MFep1xkeV3CNqBNoh?=
 =?us-ascii?Q?9n00Dm5xws79iZnT8oemfAGFxij0NBx0G71va3OcodikZh+RoGmwLthtDkBa?=
 =?us-ascii?Q?adpRKjFqUrDahOa/105vC3cOjuuhl0ZV5TjK3v70/xev55lrWwjeY5T9BAZC?=
 =?us-ascii?Q?58rsQQqcOWWpO+xnvcMGA93zA2WsTxwu1X0fNCpQ0jUrc96B1u0cHvFxd5Y9?=
 =?us-ascii?Q?K0iUNKfyCOG4a8lnr1r6fjubiPANWnXtGYBYO4O1T85U9Vh2ZfG7ivbLa2t4?=
 =?us-ascii?Q?mdyhZILzhwUL/Jn+ZBdxUyABGoJXF2pwKLg8WOzW4HpHg8KgpquBgMRO9JXW?=
 =?us-ascii?Q?/U7kU7zY0wUZyY4bge2VOx2GAjTSxboTBwFPd4JF7dmskJiEQQg/HIsFh5fF?=
 =?us-ascii?Q?tvWUsj5A1qk3wdZtDU/l/cUPsRyYuzHVFwRRR21+uCBdQf+BVCug/cK0Flxq?=
 =?us-ascii?Q?Yd4168mrq8BeGI+7WrJfLLs9VxvXHb+ZdWt+HDtGN+Z2GG/MiPWmrXH87UJr?=
 =?us-ascii?Q?MumkggE9+AHHj38ioEgHmq1nvrVFVQoGYyHWYbtdm3vbhf6P9y1b3WPHp7CW?=
 =?us-ascii?Q?m8UBcTSHOPX39Get0EgYMzSQhEVagcNDiipkfhXVhRvJVcsh9aLkBFJmrpkN?=
 =?us-ascii?Q?QaADpiOlUN7wKs/r2cIaTyWDH0hIp31IdlXE9EdjQA/ktFJ92GQ8lBTDjql7?=
 =?us-ascii?Q?laBNAlMycea76Jhkgzmb/A739l46lQnV501aKS0Z5UUJwdzzTzbn6gcjogv5?=
 =?us-ascii?Q?j8Pd1Djez3Qdrn43JzXzTMpqxfuRKD+i/MpuML36hdL0Etfjf4FM83NiLi0E?=
 =?us-ascii?Q?muuVtkibkTKI0C0SSTHAtP1w6whKLdmNIOMAln6juDD8dqIsEEvfK6Jh5CDn?=
 =?us-ascii?Q?/TV8qoijhHK6TRwE+7JZrA/dJaWqs4MYBYd2dugLqRYu7URYtW37imG9b/uC?=
 =?us-ascii?Q?Qm2xSBYTjjKs8BKkNOc099Qri3Y4doSPcfYtUlkcpgQ2ltoAoFKyKGiJfajm?=
 =?us-ascii?Q?IfgKeJ17QSn48VlYqBOpOQs0KXJUfTLHYVVBxAqXM8n4Q/DzBAC+6Dip5dRx?=
 =?us-ascii?Q?+yADjqMu2MKhsOfNGWb63+DTaLV5Q+KvxZkrmWQi5W4FJBPNnis7xVs0ZAo5?=
 =?us-ascii?Q?sNpjsQg1vwecBu3+kOJv5U4wLpLQdzdq2kRwIgsWQ7MyVw5gpbZnhkUUugo5?=
 =?us-ascii?Q?JeP1QMSguo5UGLpRWv6kMwdW2YolQGsUQlnWGXQEnnV3LKhT6FFNNinmRoG2?=
 =?us-ascii?Q?U8qEoFQYNnOW6vHKE1BOgJGZRC8YJ7R7sz74Jd2gt2fJDjjGUV3ioZRZmh21?=
 =?us-ascii?Q?S4FZslR+3neRTJSAj6N9CAHmof03gG05BN1EWcjGakXKHljVRYYXxcbHJcOk?=
 =?us-ascii?Q?KlqSZwcBGcJ7IsM4WY2/+z4YwWKMWI95b6pzLfy9oPN9BlcD4nmaNK9brja9?=
 =?us-ascii?Q?Rq2PBHzDum3oDVkb5FULe5nhdRPYOVHUBap1kRHYk0XU4aHCNhInorOeTNjV?=
 =?us-ascii?Q?NhNAycznuDk3VKXTo+T4pHVDj2OaZ/E+nZ0ActaWMVJ7MCDYtds9Xy9UhX/Y?=
 =?us-ascii?Q?+4oNxmOFCCn8gPhyYTI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a61b233-78c8-4f26-4fd1-08d9ba78e433
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 18:31:03.8139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fTRsiG1t7crbRhC7JwmmfuLWuVcxH+HwqSaGNukN7Wzm7dfGIE0CCBuFz5B/nzQ4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5206
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 08, 2021 at 05:20:39PM +0000, Jean-Philippe Brucker wrote:
> On Wed, Dec 08, 2021 at 08:56:16AM -0400, Jason Gunthorpe wrote:
> > From a progress perspective I would like to start with simple 'page
> > tables in userspace', ie no PASID in this step.
> > 
> > 'page tables in userspace' means an iommufd ioctl to create an
> > iommu_domain where the IOMMU HW is directly travesering a
> > device-specific page table structure in user space memory. All the HW
> > today implements this by using another iommu_domain to allow the IOMMU
> > HW DMA access to user memory - ie nesting or multi-stage or whatever.
> > 
> > This would come along with some ioctls to invalidate the IOTLB.
> > 
> > I'm imagining this step as a iommu_group->op->create_user_domain()
> > driver callback which will create a new kind of domain with
> > domain-unique ops. Ie map/unmap related should all be NULL as those
> > are impossible operations.
> > 
> > From there the usual struct device (ie RID) attach/detatch stuff needs
> > to take care of routing DMAs to this iommu_domain.
> > 
> > Step two would be to add the ability for an iommufd using driver to
> > request that a RID&PASID is connected to an iommu_domain. This
> > connection can be requested for any kind of iommu_domain, kernel owned
> > or user owned.
> > 
> > I don't quite have an answer how exactly the SMMUv3 vs Intel
> > difference in PASID routing should be resolved.
> 
> In SMMUv3 the user pgd is always stored in the PASID table (actually
> called "context descriptor table" but I want to avoid confusion with
> the VT-d "context table"). And to access the PASID table, the SMMUv3 first
> translate its GPA into a PA using the stage-2 page table. For userspace to
> pass individual pgds to the kernel, as opposed to passing whole PASID
> tables, the host kernel needs to reserve GPA space and map it in stage-2,
> so it can store the PASID table in there. Userspace manages GPA space.

It is what I thought.. So in the SMMUv3 spec the STE is completely in
kernel memory, but it points to an S1ContextPtr that must be an IPA if
the "stage 1 translation tables" are IPA. Only via S1ContextPtr can we
decode the substream?

So in SMMUv3 land we don't really ever talk about PASID, we have a
'user page table' that is bound to an entire RID and *all* PASIDs.

While Intel would have a 'user page table' that is only bound to a RID
& PASID

Certianly it is not a difference we can hide from userspace.
 
> This would be easy for a single pgd. In this case the PASID table has a
> single entry and userspace could just pass one GPA page during
> registration. However it isn't easily generalized to full PASID support,
> because managing a multi-level PASID table will require runtime GPA
> allocation, and that API is awkward. That's why we opted for "attach PASID
> table" operation rather than "attach page table" (back then the choice was
> easy since VT-d used the same concept).

I think the entire context descriptor table should be in userspace,
and filled in by userspace, as part of the userspace page table.

The kernel API should accept the S1ContextPtr IPA and all the parts of
the STE that relate to the defining the layout of what the S1Context
points to an thats it.

We should have another mode where the kernel owns everything, and the
S1ContexPtr is a PA with Stage 2 bypassed.

That part is fine, the more open question is what does the driver
interface look like when userspace tell something like vfio-pci to
connect to this thing. At some level the attaching device needs to
authorize iommufd to take the entire PASID table and RID.

Specifically we cannot use this thing with a mdev, while the Intel
version of a userspace page table can be.

Maybe that is just some 'allow whole device' flag in an API

Jason

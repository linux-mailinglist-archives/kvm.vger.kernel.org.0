Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E7B415DDD
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 14:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240904AbhIWMIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 08:08:31 -0400
Received: from mail-bn8nam11on2069.outbound.protection.outlook.com ([40.107.236.69]:51712
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240775AbhIWMI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 08:08:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aB7dtKfYuGF2JyscUSkjGwe5S9OBCqGFcn2xWF6uyq6J+qEAqH/yz7UQtwixf7GMINuBz/pu05SORfgaU8+xHe4458jvvixX9nBc6lIZv9VE5VgUz6cAPXHmHVVGx0beEyM+nOYG5+2f/eXzBrDgKP4xPVLftfx9b11PF0IX1+B2c3xZg6vChoX/50c+5th2VhqdWP/WLCYcq44L4YfOeIeJDHIyDKoblOlBiYLiwe/7Pr0z1idS00VmBHoJhVZu9LL1N4t4QcrL1ImqncPIp5gpWg/qLxbtRbXCDdhYjooJOvXcTXFhXkXf24ADd80U1w1vDwCcdV8VmWPjyl9cYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsFcC9EWB34JFYdXkLifX1E835iAI3p1qqX9ZRIqazQ=;
 b=lfXMbf1W/biGWdiEaia14x+ZfVqoqg8ebX9j1bJ7lmDTohgTN8hS+UNufCyZ03gqH4c4zxRpONAhForyvnU9qc+H7r8Q3r1wJaVKDjCEu7bLViiebvtaRg7ZVo2Idxr7Jhdo2IRRMgxqePLQ32L5uYozXU7bzKBXb8Tb3u0QXhHH/2jHK2bpv05LEDub4+SdDF+bidOMlDU4QAfI5w5Z9cdNul+dcybIM6kF0Qy/Z93wICiQDQMW6kIyYv64VdOKwJOZm1rexEOFzRWGKhqaefhaCfJaDo/Is8D8lGZOcuFi4JnGePYgLn+yc74fu05U5SBrgFFypIMVOd/TK3oYfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsFcC9EWB34JFYdXkLifX1E835iAI3p1qqX9ZRIqazQ=;
 b=dANKvskztSHR/f5dhXU3GftdWGQL+g2DOWZHYbDkNe+1GCvbvBIZaXA2bA3+OuN47XfE7w4vsYzfvIqtZ63cj87CRrOK2r9wn5bZxxovEqdPfP5NFg7SXxsvxuuoS1Hv5vd+TgEwzuFu55GCnXy2+GWi12V37NYGSpWzlxIOjj4dAoyJQQeN3Fi+d8n0DcjUqwTLGin/44DM6KT+bjRi3X86wcidmn8DlhMvUZGMywaRjUd7H3QXcSt4ealzQvdnVEP7daKN3ZoSx0JcyGiBPoe4e23lcU952N7GZ74H2Rbg5YsrLEcJRjn+D4lqzcew7K/W8FJtGonlxPx+g7dgsA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5377.namprd12.prod.outlook.com (2603:10b6:208:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18; Thu, 23 Sep
 2021 12:06:55 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 12:06:55 +0000
Date:   Thu, 23 Sep 2021 09:06:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <20210923120653.GK964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
 <BN9PR11MB5433A47FFA0A8C51643AA33C8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433A47FFA0A8C51643AA33C8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:208:d4::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR04CA0019.namprd04.prod.outlook.com (2603:10b6:208:d4::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 12:06:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTNV7-004Omo-Rw; Thu, 23 Sep 2021 09:06:53 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 475929cd-927f-4aab-a0ca-08d97e8aa2de
X-MS-TrafficTypeDiagnostic: BL1PR12MB5377:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53776429B3D0F5AFA624DC1AC2A39@BL1PR12MB5377.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: meFbjH/qilyeLglkC3uSpujxC84ql7LxEDXj98l733R2s2EgrdOd40sldg9GJhRydeyV2PAGq2B5pFY3eDyihBiQhnIu7dg+2YWW6CM4FFtfiuxa60q7NRYya3YtbZzn9+ot54HxLoOg8F9djuGaMMZkznaBwUU2inmhfEvle6xa996sguOyApcqwmj3p/MGQZ1zqhe9wouN4ma3eB5s7bCdysLjzF4TqkYVcl/rMM9Lwu8++Pesex4c8c1UmQtxtROdobVjCBRlPVhQ+qzCFV+/SjvFCcSv4mkjrXgV6+oq/dDDoksqp19a5I3zp1LgP4DundnbkKUCN0cuGRfQEdXYs8m7xIj5SP+WCCAxp/xK5gqj4DTTAiLYwbB78FGEpk7pyiu7l8hwwtMbMgsnrTvYpXij1DcfLnJp8UMic4RAt5I0YPeDTNIk3VtCygIZPTUiCAY1djLYWs5pSbvIBvXf1yTdl5yC5NLUI1wNXZ///a2lE0H4jr/WH4ESqI89Z08sXXkghf142mYSWB77keCcAOegekzCo2BZaZBHmHF9rFoaqYvpz1MrlCaPFQZjS3TGPQTEQCzAtQEBT4KpFpX7KlGQfHej1mXLc4zhp1WVDjarA75QlaGWQgCYWLoqKk0NBnDS+kqUlmyoVRrg5KeCou3sxXpCeObnHzbuhUuPmICRGlBU8yAFaI7Rk9gyGKtEsdEao48ubBUtWGJCoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(316002)(186003)(66476007)(86362001)(26005)(8936002)(426003)(9786002)(83380400001)(33656002)(7416002)(107886003)(66556008)(4326008)(8676002)(9746002)(2616005)(38100700002)(6916009)(54906003)(5660300002)(2906002)(508600001)(1076003)(36756003)(27376004)(84603001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6AOUcqE6LhdsZGt/XlQq8pbSlt0Tgx8Fh4CsfGPRieUVRvqyD1QcgE7SeVta?=
 =?us-ascii?Q?rF3k3UPpHrKoLlbeB24ACJId84BPyOWzO6Tp6hGifXSsYb5AcocDCT9rQPGo?=
 =?us-ascii?Q?EuUvojwpbo2CouG2ieYwAeUrusot3xJy5AV5N3JLlf8PjO6IM+NBQTAXGAHN?=
 =?us-ascii?Q?UYcmVuvh28+bybejGCMK345hUK6KWBUzWwhMgFan2Iaf3Jl7o1xTSpNd87CA?=
 =?us-ascii?Q?RiaqF1d9vd3LFJXZBD/n8KTUSTvysE+lQRVctB8HzlbJb6jUytxK1+tOL1CA?=
 =?us-ascii?Q?2efUDDwgKKB3GIXSAzHmzp8nxgJ0s+aCPD5wBZrNURw70P106jouNMmujqVO?=
 =?us-ascii?Q?zOT5ntxoF3xDIehXcX8awa0ND3n28ilYiqi78NSD3C6AHmpbN3CxK2ws8egg?=
 =?us-ascii?Q?m7pwnYN2Sn237tGvOZ97Q8CV+w9DMBEHVy6sV0P6csUPV8EGH2Byyyj2I5G7?=
 =?us-ascii?Q?KAWT/0Wa63JDMnk2n3z8MvyNGoS6AU319xZ646FJ+ob7839MRGD/ndDBfIZu?=
 =?us-ascii?Q?R/hobWVjKjq/xIrgaS+owb5/kginXkAcRMERcNwkTUU3+dwHGtL0LNQLUY+K?=
 =?us-ascii?Q?y3TSJoVg50UqF94pfJlYD4fW8PX9fEkO/QYnviokx3ot6aK7kxmPPLWQmze5?=
 =?us-ascii?Q?4rwWbGQa0J72ekVrt0WAQWYME2AnKqtvGCGtWEi979nY9qR6COiP4zg6feh+?=
 =?us-ascii?Q?CqbAtdcl9OP8mzydaVlMZT1CsdG+dz0ic76wKqPmLq7un0xv26w5tZO01hDg?=
 =?us-ascii?Q?y4auh/aitnOFfDsinZbqSmgxHlyjpViLH8AX3Mb3P2xbAOFjkp152bjl2Hkz?=
 =?us-ascii?Q?06USFvcl4/opBS7pboNKPwQ91Cxj9w93iApHUz/IynwyM/W0S4BaGU4qUM0E?=
 =?us-ascii?Q?ebzbgaXyYuXrLYfLi5Pc8mzAIvCOmuAF6Dw6HvoZdS0T/Bg93MZsfub++ai+?=
 =?us-ascii?Q?3NKYQyJlLuBBTtdiGPPc9mfxe6brev4t8FDeVHVBD8au3TmdCSPcIjN+KTgP?=
 =?us-ascii?Q?bKSfcYBukdKZxH1f8p1CLGO6PL2tr/k6AtwlJFi8Y2hTS7tgouWUgRFfxcdQ?=
 =?us-ascii?Q?QQPZBTsaHf4RhZdu26ExwLTjD9dywQhA3GGOxfNQIS/huOVNmcx+uLdxJ+ki?=
 =?us-ascii?Q?GXUTgv/GT5II7U4WOVbRg4h9gHGhyWH+KhYoOYBQ1zHn9MlYshMHV72ihr8I?=
 =?us-ascii?Q?Zxfwq8L7HWEegqnUBzeO/ndnVBCvHaBNMpB760Qb8WWK6vXQJroK/8xX1gGs?=
 =?us-ascii?Q?a3/AeKk6z3EUe5O8as8lu9R0zgskW8yhlLT1kpPa5twqckCgIUoutG3bw4kw?=
 =?us-ascii?Q?Pn+bHtlKS5bBMm296r/JrSdy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475929cd-927f-4aab-a0ca-08d97e8aa2de
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 12:06:55.5409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZjbxUdqQOLAzazZskAfSScTXOBOMGg/ds7wTyhJAW1HkzeNX+8AhtXiNsk1YI9E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5377
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 09:14:58AM +0000, Tian, Kevin wrote:

> currently the type is aimed to differentiate three usages:
> 
> - kernel-managed I/O page table
> - user-managed I/O page table
> - shared I/O page table (e.g. with mm, or ept)

Creating a shared ios is something that should probably be a different
command.

> we can remove 'type', but is FORMAT_KENREL/USER/SHARED a good
> indicator? their difference is not about format.

Format should be

FORMAT_KERNEL/FORMAT_INTEL_PTE_V1/FORMAT_INTEL_PTE_V2/etc

> Dave's links didn't answer one puzzle from me. Does PPC needs accurate
> range information or be ok with a large range including holes (then let
> the kernel to figure out where the holes locate)?

My impression was it only needed a way to select between the two
different cases as they are exclusive. I'd see this API as being a
hint and userspace should query the exact ranges to learn what was
actually created.
 
> > device-specific escape if more specific customization is needed and is
> > needed to specify user space page tables anyhow.
> 
> and I didn't understand the 2nd link. How does user-managed page
> table jump into this range claim problem? I'm getting confused...

PPC could also model it using a FORMAT_KERNEL_PPC_X, FORMAT_KERNEL_PPC_Y
though it is less nice..

> > Yes, ioas_id should always be the xarray index.
> > 
> > PASID needs to be called out as PASID or as a generic "hw description"
> > blob.
> 
> ARM doesn't use PASID. So we need a generic blob, e.g. ioas_hwid?

ARM *does* need PASID! PASID is the label of the DMA on the PCI bus,
and it MUST be exposed in that format to be programmed into the PCI
device itself.

All of this should be able to support a userspace, like DPDK, creating
a PASID on its own without any special VFIO drivers.

- Open iommufd
- Attach the vfio device FD
- Request a PASID device id
- Create an ios against the pasid device id
- Query the ios for the PCI PASID #
- Program the HW to issue TLPs with the PASID

> and still we have both ioas_id (iommufd) and ioasid (ioasid.c) in the
> kernel. Do we want to clear this confusion? Or possibly it's fine because
> ioas_id is never used outside of iommufd and iommufd doesn't directly
> call ioasid_alloc() from ioasid.c?

As long as it is ioas_id and ioasid it is probably fine..

> > kvm's API to program the vPASID translation table should probably take
> > in a (iommufd,ioas_id,device_id) tuple and extract the IOMMU side
> > information using an in-kernel API. Userspace shouldn't have to
> > shuttle it around.
> 
> the vPASID info is carried in VFIO_DEVICE_ATTACH_IOASID uAPI.
> when kvm calls iommufd with above tuple, vPASID->pPASID is
> returned to kvm. So we still need a generic blob to represent
> vPASID in the uAPI.

I think you have to be clear about what the value is being used
for. Is it an IOMMU page table handle or is it a PCI PASID value?

AFAICT I think it is the former in the Intel scheme as the "vPASID" is
really about presenting a consistent IOMMU handle to the guest across
migration, it is not the value that shows up on the PCI bus.

Jason

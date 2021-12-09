Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8074746EBF9
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbhLIPo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:44:26 -0500
Received: from mail-mw2nam12on2075.outbound.protection.outlook.com ([40.107.244.75]:14496
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236210AbhLIPoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 10:44:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/zet3GOPnPRegdMOWZWzJLRxBkH5SmCT3j6m2Ijcba0477ZMvJggdYmqurI4F3ivWJwb09EcvIIqNro2PIZq9moLhutl14OJwN9ZIVKM1psWy1seTsNvsrmm9Gw7M0CvaeGVArm7E9N20IPCeN6M/AYf+28AoqtYp5kMA+yF38R+alW54b/StUJCMBerQgxYs4KqrnkRc91S1M57CKv0Y8sF+fv7GfJFLa/C9HpREDC41/NtXyXDF02OvmGigLt4jk/LngPr78t4AUPJrgt3k+gjvBm1ICnNCJjLG4dEQQpmvQGTuh/GEFtQlVzu4aJy1SXxBBlKsKbfvKoEZfg9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4OibOndAozFWSriX3TG8msS7GN0/heSHM57NC0IrIw=;
 b=TQMkcM8GsyTY47bB/stQaK9pmwsKR6tHNqQiIYO3ifRGXuiUyOoINpqcDZmvxGjMDBsg6RL6PaibtI42KIuh7grhdPH7HuXwDq40Pl0uoY/tRZaE8wSnuLr1FaZD8PeV0xY5Xat2u4sANwY5p9ytFEUdPaELnNRJuc3/UjPPLG9dI2C4K3x/UteMEm+9MRwUdMUta2V6KXe0VZ5l6DCyLgPLL6aBbq8HJQ2CaPN50xZJ9v0hZdlPgm+18PPiK87vrZcoHM/a23dRG6F7hqNgQIWUybNzGVHMU8aETfSnCF9CptwgZkmBFL153XJ0zvOmdfwbKdA3Mlnq6l5QApxLUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4OibOndAozFWSriX3TG8msS7GN0/heSHM57NC0IrIw=;
 b=OZMtHfOQwIUsOdzyDrKTAlgUpHed98+JulZQGk4lG226lfhNmVDOj0HTa6hYPKIBqjUtKa39YhHQDdbmH1nR7tXGw8Sjo8EWROVvHpHoNgnGVTm7DLB7Lh9zfXiV1eaTU54w6zonpe93QflVIb5+HdiZ6fY1MKXrCz5I8FJn+Ce5zKVcL7be9qSmxmmmae3bnaJgaH7vs+7P6FNi2+m0ttH1y5liQxLp5ViwhA7/t/cuMzYmn1Ek+Fm4X7Vxd82HlVTd8YrdGmLFXBASRrbsMR75X2WvlJL/GOtmSuI6ADa2YuC2BrUKfkvZmhI0snsOHZpf5IK8XcQzxj+m3UzwcA==
Received: from BL1PR12MB5032.namprd12.prod.outlook.com (2603:10b6:208:30a::12)
 by BL1PR12MB5030.namprd12.prod.outlook.com (2603:10b6:208:313::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Thu, 9 Dec
 2021 15:40:48 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5032.namprd12.prod.outlook.com (2603:10b6:208:30a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 15:40:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4778.013; Thu, 9 Dec 2021
 15:40:47 +0000
Date:   Thu, 9 Dec 2021 11:40:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
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
Message-ID: <20211209154046.GQ6385@nvidia.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com>
 <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
 <b576084b-482f-bcb7-35a6-d786dbb305e1@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b576084b-482f-bcb7-35a6-d786dbb305e1@redhat.com>
X-ClientProxiedBy: BL0PR02CA0057.namprd02.prod.outlook.com
 (2603:10b6:207:3d::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4c0ec46-88a6-4a6e-6649-08d9bb2a4520
X-MS-TrafficTypeDiagnostic: BL1PR12MB5032:EE_|BL1PR12MB5030:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5032EBB5BF97DC3A07AD514EC2709@BL1PR12MB5032.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nf7G3ljSaezRtbMKY37DPkekSRoS6WxDrZttvz2Cd4B49YFSIFMD3kX3bxkgl1MFfnJvzsZP36m1shV2sAaBGnaG/gpyw8dBSMioupJ5s9Hk9stJ+2gC5qCB1lGQlXEM6FgDTjXVJ8amSdhyVpaHa+Ht0+Gbdt7OSG3LcXE0CpSU3nyGQXtZ65wwMH1OM1qTJKxNMZ2SLZ2WlO2S+0aBhWaXo2QWKP7IQxZ6Ju1yyS0nKv5ZnSnwVoykcC5mnN8bdjYJJU38H3g5GGbvbEPQnU8lY2hr518cWPaLZ0KyjGqD3yAYhE2qI9POPFvkFm3pjkfUSu+iq6KpeJucZjm2tdjer7Qh8vJ3/sZlq/7OgABhDQ7oOH7W7DuNIX6Kw6QH0Vvdtva4NXJxI0hluSvg7t3I0momJBH8f2xC9LYptmdtK2QF8ATif9j5lTU1h8rn3FjQyWLKkO0uGqSDFCl2H+bm/8mzxX+5fSkH67TCw/5gMP2s0laQlpVDXA0NobqLuz8IFO0YpY24s3AztH+dY3WU3PcJYYNkDM0jL8CtGBK7BNkzbi2NYHCv9Z4Xcsu15U2zVjgnl0Va1kRLkdjlsXmEjPXSmLOehqtECmBeIqRGY7Xix8SFTRohfxvxjmKAUq0wJzjMi+5MsoKUIllNJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5032.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(33656002)(186003)(26005)(66476007)(1076003)(508600001)(7416002)(6512007)(4326008)(36756003)(2616005)(4744005)(6506007)(66556008)(6486002)(83380400001)(38100700002)(2906002)(6916009)(86362001)(8676002)(8936002)(316002)(5660300002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AmWECveVl0khzBIjkYpqVgvDp6aacsV5FLTpnaK5yY7wpjN4KG/1skL71DrM?=
 =?us-ascii?Q?Se4PBknmKJ34u0r6qoa8OV+oBkE24nXyxNgEHctbrNrYz5ihJ313wSRbFGxg?=
 =?us-ascii?Q?+ZG3lNQXkmnJyTIVksChBoPM0qPQt9EXmd5DiyYFIZOpiX7tCsX85n7LmQRh?=
 =?us-ascii?Q?U8Dsj3QHgqZ5Wi7dij/Wwqz7Zr3hJAA3yM/I2M/ArW6fxSgCn0ojcUeNhJTK?=
 =?us-ascii?Q?zSQvAeeWML7fGJRIZITslkfBdxIXWlN9ENLr8josQxCnWyBIJpZLeOI/D1vK?=
 =?us-ascii?Q?xBskEdBfMOqPXkg/oWxYBXwVFrSIH72BswRyqwTzE8Peqqd8/cjjorUqk++n?=
 =?us-ascii?Q?4ZE2x9hqjiC+nUF8yKhW/VKOgUbw9varhsu20FTMujWQgZKDFWcuX+JRaBYs?=
 =?us-ascii?Q?PCCsaNHJW1RUr4qutymkNu93x4kbgn06O9fAXdcxc0cRmhqx2E+SkcF11kcq?=
 =?us-ascii?Q?ScWa9/5TcakLBno/1z0PDXaWXf0zVjvO9kqiuV9S6tLVmL5yo8Mb9+AQ0gNV?=
 =?us-ascii?Q?5JWfjc8ef1rLRXQSY2qppN7pHtnx9Y8E2TQDX3Favzq8e+FVc/55HpQtu7xO?=
 =?us-ascii?Q?brKXeBYgHO4LiFMVXG49ViWitOuJZ4f9BkgMc+2rOa21uwwoQEXNTel4lsha?=
 =?us-ascii?Q?3eSHMvFuNEb4W/dpcKzIo2eiKPaWH17UNQu1wV25btP+qxQTMGwemKCazB/i?=
 =?us-ascii?Q?8sTI7P03ObAbTvK+36AVhwHKDdnmRBWs15UlMdILHPdry9Zm76veQASED4OS?=
 =?us-ascii?Q?W1V1H/glVGSrugys2M5P8JbPFqUwSqTJCkO8pl+hspMZvIRJnMH0b1vpHfdt?=
 =?us-ascii?Q?E12/U6r8meBnRzcFuMJ8gLqJhWeGP5soC0mbZhPUW8ncBwmxQhR7+U97RmTT?=
 =?us-ascii?Q?3K94oiCI+QeHnnmvq5XRilXdpIZbi3bk4d5Zh0v/hm1U6VhaULCVpi7P0yM6?=
 =?us-ascii?Q?qzt4DtLxqz0/ss8AHwMm1EK3J0eYQHCzzSUMETJ4pQoIP9VZ4G/eR8AuVx3+?=
 =?us-ascii?Q?ORevJ/23BEj6UXQKHBu7X6XoDaTKQBPEbsdgRq0Pn4DE2i8Uac216urzZ11+?=
 =?us-ascii?Q?1RXeffuZy3+eaETxy7dgag5IBQFT2dHfoeC55/ziyahKs5W9aGTSV/lqD+ur?=
 =?us-ascii?Q?k2qaoUaUdMV11dR4O8jsv3/UmzkkL/5qBG/nnJBKXb/qBZaP1aQPiAdQTN2u?=
 =?us-ascii?Q?XRJYXZYzMowIrXithBgo/xjZmdzZC1HD6D70aztggQaNmVCoG9Xkg2PIxlWy?=
 =?us-ascii?Q?REmxZOOtnIYjTFWUJoV3LFOOFttuqJwi5DXZxjgKdtwoPp9tK37+2JwPJ2ts?=
 =?us-ascii?Q?nYzwK2Ov3Ocj+zVRerI4EZNYZQ2oDyNxpU/YBR5wsBNiYnJkqWg5MbkhfEhX?=
 =?us-ascii?Q?nnqHa8vB+JfIT514Tx7DY40v+kxGcNnWPISk4MnW7I4w3s0IxztxbjZvpPYb?=
 =?us-ascii?Q?ealwf3oOSsb0+X+bLZ1Oz3FUPhJgV1qFWwbyJmFXbayC8AWNIm/AKXaNdETW?=
 =?us-ascii?Q?DFaYlghbCJD3VIH4N0Bu7DIm1XJgWdT0Euca1wQ2Be4eRuIFRV7aOgEeKEYn?=
 =?us-ascii?Q?xXvHh9BEI4pde5RSXBk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c0ec46-88a6-4a6e-6649-08d9bb2a4520
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 15:40:47.4294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7hjE6hRRaHC6txDwQsYkggU8ETG1B/onPG84QW6DyTSaDTPkYQ8YZEWW8ogYMcYu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5030
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021 at 08:50:04AM +0100, Eric Auger wrote:

> > The kernel API should accept the S1ContextPtr IPA and all the parts of
> > the STE that relate to the defining the layout of what the S1Context
> > points to an thats it.

> Yes that's exactly what is done currently. At config time the host must
> trap guest STE changes (format and S1ContextPtr) and "incorporate" those
> changes into the stage2 related STE information. The STE is owned by the
> host kernel as it contains the stage2 information (S2TTB).

[..]

> Note this series only coped with a single CD in the Context Descriptor
> Table.

I'm confused, where does this limit arise?

The kernel accepts as input all the bits in the STE that describe the
layout of the CDT owned by userspace, shouldn't userspace be able to
construct all forms of CDT with any number of CDs in them?

Or do you mean this is some qemu limitation?

Jason

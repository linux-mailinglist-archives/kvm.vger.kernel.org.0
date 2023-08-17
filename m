Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FBB77FD6C
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354184AbjHQSB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354171AbjHQSBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:01:35 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36908FD;
        Thu, 17 Aug 2023 11:01:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1D7J676WTK/mIbUPoMtoboFJ06CftFnVPAX7vzJbC+o8IFA2kGbP8KIVaUgM+asVhbfTNjRXHWs4yc5TopBFxb0b17HFIh4SWjrC2ZaujJ+7R9/ZRQw4uWuRPO2BTu/RPgJr6B+kcRCiqHKdRRpU54wkaJWnpgA70nXGMM3utJpJuAnrPMLHIdkwczjHH0SDzDKnYgZgUMk7uwcd8WeDu6cl766VhAEJY1el8SA2YdiK6jUCfZj6t9WztDRjLWoK5eh6Lvuz5i4QHnZIU0jumhJcL0AUSjylflMw0wG1pzn47cZpW2E6cdqawiqFkgIsR5wa0hb072nOj7Q0kCB6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezh92LY7oJW8E5AHPSH8zKa8X0jwZ35+w5/6xX/Hi8Y=;
 b=fcEll3soF8KAtxe6m+YsalOKCAikbQ4Ilp/QFZz0ccOrWHwfPv8HZ5/Jc2Bqgc6vcrPVxL9SO5Ojhn37iMyBcl+qdf6oZzHGg+lb++3bgacEE3Xj3OhnEP8l76sf9DXlDS6bR9B0x3mznEFrtiYDIYHnX8Tjl4z46XQMTBd6HrUjxKDDN5kFVJAO404ZZu5utmsCFzlyTQwH86MieR8/RfnqFf8l95OJU1KKNuWet88juuabeshcQw7dyKMRDMkxtb7/50Gug7EEKQvbWS8wWY4xItnfxQ9+9xvSpMtceQaCzs6uZAiRv4vJtnxzF6UdGaJ+5h1dRn5xzVWHO+/flA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezh92LY7oJW8E5AHPSH8zKa8X0jwZ35+w5/6xX/Hi8Y=;
 b=M/dKqlr8eKWJLZXBDs0ExWElajJQhnOq2ZFQ6gPKP2ipqdepP8Oz9sJXsX4iYEIoczTkZRyB3ozba+dRQ17Jl9afNdivOIvMkwn1ycr6ViZDfuX0xVSg36IXG3LmVCOh4HiDszNunhP6SXUkQ5sOf+JDTGIt3xz/jSChn7Eb3kz/Mu0BLOVoTRWCRNjWjbvZfztHBwueIIeo67X9HKQfhLx1jlLXH/tpDNrfzrNaSvfyHa9xjKkuffCFRirPwwQlSIwQjhvL2tTPub1nk4nXmEK2/H3jMeT6souPbJ5+pIKogID45zwJTleWrAK4+7dRA+UTrU1UQpQJHf8SKGWQ2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 18:01:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6678.031; Thu, 17 Aug 2023
 18:01:31 +0000
Date:   Thu, 17 Aug 2023 15:01:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v3] vfio: align capability structures
Message-ID: <ZN5getPSq1stluMt@nvidia.com>
References: <20230809203144.2880050-1-stefanha@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809203144.2880050-1-stefanha@redhat.com>
X-ClientProxiedBy: BL0PR02CA0125.namprd02.prod.outlook.com
 (2603:10b6:208:35::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: d75f8875-49ae-437c-928e-08db9f4bfc6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L5L1XAWfWAH06jjNwN3O7n04TftaCeuIzrQBoiGoo3aaJUweYMZtm4rfYdZcZyQTsCfp6/lePFiuR74N535kBvgnbQaSfg1NaGlU5/ISk/I7fG9ErGWwrSOkJ69OwSifwWgWNWl8k+SDm4/3sgvLvLMB5FR4oYFdWWPaKw0wX8qBleg5Yztf59IpNjp5CQWTZm/pcJqwLrLMl/eosahJNmI46VDhH5lmiAJIAQV9IIsVzveOQCd3vpVml2M1KvNvl4hn85JhuIgZKFShPxaFTdhQbEO0DPGgm/fNlhLiPEwCr79AWZGps/KO3qpWljvzQARdu7k7P2tybYWf/r3ppI+gOLF7HuyTbz+y/+nVc+idZH6yEAWk2JrMQeRMkdTK1qhcgJ/k8BHto5hNQVo2rErTH3BnGR30YBokMpCQbxksj0RHPXXTCE3WwsQVh1gzg9FHQidXgvuoARyvceO9pmt27sJ/AY1E7+Qn5NHJU8mzL7gKeEGRHWcAKLOk9A1Z6FqQ/Ji7YOFOBsmcrMxdFY8ZOUIVtrEjdBYp6GjyEV234DhwUfp650JEfR25gsIV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(366004)(346002)(396003)(1800799009)(451199024)(186009)(83380400001)(66556008)(38100700002)(66476007)(6916009)(66946007)(316002)(478600001)(2906002)(41300700001)(8676002)(4326008)(8936002)(5660300002)(6512007)(6506007)(6486002)(26005)(2616005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IotqXTc+3cCayhGYcXhtoovD4BYVQbEy7dl8NsmvDZhK7dwnuRqTkATr4DkR?=
 =?us-ascii?Q?5nSNsSP7slarpeYswIRo/axUXBOkef6cBHnKwwJRVrUj0lyzEwgh1grfXB7K?=
 =?us-ascii?Q?oiBfGNmKu2+zNcUnZrB84rWtjr05PTSHpiVVL6188V7zgBWnGmvzcCYHdqOm?=
 =?us-ascii?Q?0AyhLgRM6uECHOa5AHJfKzRtEDxwdMjz68pQrNseH5D9lUkGmrSsh6qUKIzi?=
 =?us-ascii?Q?CXQMhMPogx7Amr8uGMxFa7lAbascsCt/gjpmlMUWv+2k8M6+ziz6jD+pkCXI?=
 =?us-ascii?Q?OTtZyQGDZTYpYcbp4kefsulF2NSPJTl0USYKiZyiKyFuE+NoYByDyqZSCm22?=
 =?us-ascii?Q?xdpDzuDAcsiyW9c5+e+eOqwuYC5sRLDFmeFWgJYcOBhhQKb2bVmjEntxSquz?=
 =?us-ascii?Q?XcLBqCmJ+izYjAbK3iCEvhFMwO1vUkhG3GRZh8rA5Yr/pGqY/DZlMWCmJRFk?=
 =?us-ascii?Q?bncik2liXvwH2VYRX7rIpmw6GAs9Sj22KIVojc01LOYvMRjexBRNNF4U/Iwz?=
 =?us-ascii?Q?EaPBpDFlA65cIkkkdg4+Wx13y8bEXx++5Jdfha7yAjclGcGyMpeE80zY2qDe?=
 =?us-ascii?Q?GeKoNi8NYkH8dvwxg+eXrrDOqWOln3leWlmxXZj71Df72xsHdq9wtAbRvsJ+?=
 =?us-ascii?Q?0KVXQnjvO/Yy0JxsVWwqiDP5Gh/ovLSh9ETFPpa3apCpGp0g6QM0ovxnqiBB?=
 =?us-ascii?Q?Iy3P8akDT6CHbcrDF1v0UczWzc6zeNj2FXvJjg1Ls5sycrT/tyewy/sjsgWj?=
 =?us-ascii?Q?QOa3wLIdbqSxDlCAmNTqhbPfeEvJ6H/IY2qZVgTp4r+8nuvxWhtd/jQMmiGv?=
 =?us-ascii?Q?Td+wqz9Gqgo8MoMsjnFfZPJJZJKzxUwY29LizhqAQWc5xh37ufYT64yWGMXU?=
 =?us-ascii?Q?uYCopYDQi6XSKEkupq49DJp+fhEyaRrOtAe95pCgFdLfot+DTtQmo99++wqu?=
 =?us-ascii?Q?B4JZxv9hnR92TDMx3APDPVdif/IVM/xInJgrODgdljBVDlsTTueXrDkecYOb?=
 =?us-ascii?Q?Sm/g39HmLRH/frHoxv2DfNQcpmiXzIlWPGvUsHAMyj1YS4PR5n3hmbUD1Y1g?=
 =?us-ascii?Q?jWIfDVEpN5Ne3Gr35vJxLqHP0VcFFxTAYtmeNX/HLn46iaEkEJRvcLBVm+RN?=
 =?us-ascii?Q?N24DUi44kn4YXIbeg70hTI+wtNJ6zLibMChbH0TFtKgv9d4oyQUdtVwlW1p2?=
 =?us-ascii?Q?yt6kh1Sbt8rAuNNku4KrVBpiQxL+vamYUFOEMvmsNTIq5Io3aIpQQKt6h8zS?=
 =?us-ascii?Q?/vZS+XnvELyPZNuhAAbrkZVcdSXWe2Jtr10r+rcCBo8l8XXJSQoR3GZIulsm?=
 =?us-ascii?Q?MrjRItqlpiB7GuURRyBOV8j5HfjO2vgdT7Juzk+ahQ4xPtQ75JJ5b5AzoXuv?=
 =?us-ascii?Q?Ucx58zPW26wIpg4Y4BCgPVSbhgDOR4LNDqaZ+rg1uxw1nI3YfwIfF13qj1Aa?=
 =?us-ascii?Q?RjlyGwgr56C9+Jf7DWwhNebVOpYZDXtTiFWo6hn9+k3y0KuwpMX1gWekJIYt?=
 =?us-ascii?Q?SOt0JgPlq9/NgwTTzfsNzZYYLicJXjH8SUFTfoLDKXSWtMTYZmPsImnxfBJp?=
 =?us-ascii?Q?PLEt+fiiSNhmMVZNeQ920+biZM7zELzjXfiFzu3w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d75f8875-49ae-437c-928e-08db9f4bfc6f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 18:01:31.3087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hv4YyTsAlkfTl3Jb/rc+ykf5q+xb5ZTkWLvVQZKfPGh7R4AFVqn+9gPhBfaa+8i/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 04:31:44PM -0400, Stefan Hajnoczi wrote:
> The VFIO_DEVICE_GET_INFO, VFIO_DEVICE_GET_REGION_INFO, and
> VFIO_IOMMU_GET_INFO ioctls fill in an info struct followed by capability
> structs:
> 
>   +------+---------+---------+-----+
>   | info | caps[0] | caps[1] | ... |
>   +------+---------+---------+-----+
> 
> Both the info and capability struct sizes are not always multiples of
> sizeof(u64), leaving u64 fields in later capability structs misaligned.
> 
> Userspace applications currently need to handle misalignment manually in
> order to support CPU architectures and programming languages with strict
> alignment requirements.
> 
> Make life easier for userspace by ensuring alignment in the kernel. This
> is done by padding info struct definitions and by copying out zeroes
> after capability structs that are not aligned.
> 
> The new layout is as follows:
> 
>   +------+---------+---+---------+-----+
>   | info | caps[0] | 0 | caps[1] | ... |
>   +------+---------+---+---------+-----+
> 
> In this example caps[0] has a size that is not multiples of sizeof(u64),
> so zero padding is added to align the subsequent structure.
> 
> Adding zero padding between structs does not break the uapi. The memory
> layout is specified by the info.cap_offset and caps[i].next fields
> filled in by the kernel. Applications use these field values to locate
> structs and are therefore unaffected by the addition of zero padding.
> 
> Note that code that copies out info structs with padding is updated to
> always zero the struct and copy out as many bytes as userspace
> requested. This makes the code shorter and avoids potential information
> leaks by ensuring padding is initialized.
> 
> Originally-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
> v3:
> - Also align capability structs in drivers/iommu/iommufd/vfio_compat.c
>   [Jason]
> 
>  include/uapi/linux/vfio.h           |  2 ++
>  drivers/iommu/iommufd/vfio_compat.c |  2 ++
>  drivers/vfio/pci/vfio_pci_core.c    | 11 ++---------
>  drivers/vfio/vfio_iommu_type1.c     | 11 ++---------
>  drivers/vfio/vfio_main.c            |  6 ++++++
>  5 files changed, 14 insertions(+), 18 deletions(-)

Acked-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

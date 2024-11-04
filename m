Return-Path: <kvm+bounces-30562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB8F9BBB9B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 18:19:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D5F11F2191C
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 17:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB8D13C827;
	Mon,  4 Nov 2024 17:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pq+nrTR8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B987117583;
	Mon,  4 Nov 2024 17:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730740779; cv=fail; b=JZwfBpm9XY86ySnhnuiOlE7su8nTPC1U2SqRXAjt+bDvV387xH8UmnJmG0RAsm9N71yYDLBVZEbm28dwdXzv1WZmMrMgEwKT3fvKC4l0kftK9GaS9+8jViX7wX6YasYDbOA6XJ1QiYwp2UmMBjCvQOYZaA78gRQfB7TdI75Un38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730740779; c=relaxed/simple;
	bh=we39yjYYVv+NU33nSWPruIN20Z4lWddW79T3+j2RUCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N31b5DVqqorxtcrsNLRJj5RFMldA1qmxZzA4/vKyr/CLyCpKOVTTBaDyG0kezu3jbFE+9HC8tw+mSAgjByjxVcwahwCLJmIq56zoFMq3PJhuutY2WO2Fi/NTRj7bcURiuYOvHOcJv4Re0whlKxvYgxjTt4OT8BF5dS0OJArO1yA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pq+nrTR8; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPHuG9G7e00xbD/4CjupCQGniFxQGbkA6QS40h6MBBiRGlvrs33ZoJDNj91uPQOam0AAeD54xQnBEMyCaUacnZ3i+wBossQxO3QtxVIGDIUB0hQwzq3DTGyZTBeg18ve3KuilxhNVeH0iGutuV6ENDr1G56L2Q/RnBtKU83UdGevLq5decZgPZWYs2Px20q3G+T48pr3bSbMv76F4lL7FU4UY7aTL4n7CDh6ZxcO2H7sm6g/C9bCcs58dMJPN6sicXcb3f4rlvuHtuT/9hYhFm/OZUQy7jE7Cs3IEv4XFIOvMAmLnd7oHFEYojzWPib2RaHouwYRrE7sSZRRK0uGVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LHXzcor6GjLh9WhzQGjATq7tg0klHr90ll+Q+kWGU0=;
 b=YYbkZuZu1BpBkC+Yuq2EbLIn47WHtrlV2+Y1+t4fGJ+QYZ1M9Q7UfyFJMe0Vq4RjmMEsi8GsEN3YDpnaO5qkuEFvhyCHyW1kR27ZW4Jd7/klaf7ZY1Uh3ZYvFMoWfC32NyEvkFXZHXAxd5x2Q4x0ZaoD4MwLEdll2L+IdTe7l8THXoK3wb6sFAgGFFqUbvNhy5/JQU6bMHfXSkQMSp9uwpwVtvVp1qQxcAOr1hTxFhJMGasQ4EHCThFb8XiHea2bROfGhzS1q+Lvx1BJYxXCJi+jcEqAkUKH6kLS/D90A48jtcQOG+x0ycy8WYP/TRsT5+akkQnVzoXtIgwSdzNZRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LHXzcor6GjLh9WhzQGjATq7tg0klHr90ll+Q+kWGU0=;
 b=Pq+nrTR84WiP4G2v36W4HPchJpR+F/2cum0+tXXkn6PUV0dg/FA/v0bQCXhDtQxLIHkNqUT6CKsmAqd/8WtVroCbhThCwe+oaxNuhwYx6setpDEtADQ4MyEjR7CcqQ0HQvB6yOSwyqsqf8BBOtXtJuZP2gUlbyuQ+qtG9BnehXhNc/7DOTg4ESsWxz/TJiJ/BjDBRIN4VYaKyTNEEidgfyCzj3v1MXYDUp1La9T+Y0BBvd85CGDJN+5hUhObmM5hegz9QzGv3jPb9mlvJ6/TopyOL7ZXoKtRcPgB1SxllGmN8PKG3xexe+bKbipdtcFJpRPhqvcTdyPTlAdOHW9qCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB8045.namprd12.prod.outlook.com (2603:10b6:806:31d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 17:19:33 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8114.015; Mon, 4 Nov 2024
 17:19:33 +0000
Date: Mon, 4 Nov 2024 13:19:31 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 09/12] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20241104171931.GB10193@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <9-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <CABQgh9HoGFGDTEqziQt6WrJ7Bm9d-0c259PYsms3nOVEidn5BA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQgh9HoGFGDTEqziQt6WrJ7Bm9d-0c259PYsms3nOVEidn5BA@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0526.namprd03.prod.outlook.com
 (2603:10b6:408:131::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB8045:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c51e531-b36a-49c3-9ec7-08dcfcf4d965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N+eqDIoaEadXhfwUFlipMmafnbuyWq4fu+NWF4AW8VX4YdT6iofL5dKpfv0G?=
 =?us-ascii?Q?yTIG47pgMD+dL21uK4OkMVEu5qpHlpcbsAAAmu8GIwxvw9z4NJ49fiIyaloR?=
 =?us-ascii?Q?5jDrcpVvj06gfuwqjaUuXaWduK8m1TIX7Xss6Kji15cq+ZtMR5TRjYs1LyEz?=
 =?us-ascii?Q?Bmndq3avYjBbGx4hx/Z+z2W9jC4ASMIROtRcxK1tZN1rZycA5fJvjViCkqgZ?=
 =?us-ascii?Q?CMjIv1QZO98X8R8DMfZIrB67FnMjNFGGsPUsorsCwwqc568ePZVjvvad4RYS?=
 =?us-ascii?Q?ObwXFK2vOCb6MPN+FWUrrNPKOW+H0uezZLRQX2RyKgwFNv0VoSZcHsKRO9Rt?=
 =?us-ascii?Q?ydjrhdRJDtXlfX2qEu+EKxf9OmpecaEzKHbNxlt/996K9ttUNZzauGJBzNWQ?=
 =?us-ascii?Q?nSHWlLiGcQhczwzg6GDUoqWPgqmLM0eaN/HRDX59TqU7FEUxbqX+MUsCBZYV?=
 =?us-ascii?Q?Nr9YVIYRAXtx78yeS2//q8u4zzMFyteU+CPptj8q5YlXG32LMrXd8SI9REcj?=
 =?us-ascii?Q?dNuZFVCvswtIK7KyvU2kd+Ly4yOEv9nbO2hhFc6HdzP8oCIIjFH49cMzqZUE?=
 =?us-ascii?Q?sDKDqahKX+G+bmR9X9D3vgyxnsWaJBIvJmhUSiLhb9zCnAoHeR2JwZjSkfq9?=
 =?us-ascii?Q?yQikMjN8CzS1NUbhUdkcqxGojenDV4Bw3LOoF3uIw38dpGdd8+50ZhC5/Anq?=
 =?us-ascii?Q?I+U41KvV2Yqg2ROtuQf3rvdRTCw1Y4xIwuCWyl/BxlYnL19k0QOZi5kmeLZX?=
 =?us-ascii?Q?1q8oCdhfJ+/8fOkFqHhFf4zb6VmgplAvZDul+sW5RvUo9mlhb6+cDUB/I43D?=
 =?us-ascii?Q?5KkZhVVWRU7+Ql/lnjilwyUXrrLXrYmP7a04S7Ki+5PxObxsK3Y/mIiS8cfo?=
 =?us-ascii?Q?itBEwLhYnGFtzkHjpCKTapVhwBeJNN/E/5Tja/OuJ04XVaH808uabDwKVEbH?=
 =?us-ascii?Q?dWSQNuJ9WlLQ4JO06mdtP/xas8mq5aDlp20KYPQoHLjuqVTp+YVm7w5pM8+Z?=
 =?us-ascii?Q?gLrSEJp3dtuVUm0KPc56pVsWbwRKRurX+OPc6SDiunXcNZQOY8+6jw6S9uNK?=
 =?us-ascii?Q?LtR2D27LTump+sKESnRFkNNLN3xaauu0BdTuKHvCye/jNN0L01Vu7sxvJtHv?=
 =?us-ascii?Q?67ZhZttm27DJhaitF6rMta9WMsAW3DspnIciC1WUx+A9nB4XUaGJ2txa3sI7?=
 =?us-ascii?Q?jrLSHVLHxjNC/yi+rgW6+U1xklum2eJ3SZlXGeNBSZkImz7Be00iKDSx9qo6?=
 =?us-ascii?Q?7Yg4UBnbEf9GcSYGMAxamg42X91cXLaog+GGBD78rP66AzZ2B2CNssay8f48?=
 =?us-ascii?Q?QdVysyD4RfGJmZrVBZm/R6IB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?radHqVYHyt91MS8NRF6/jTFywvLPzAXB9Ur/8q9V1eoDsODSuMuFlwiP31He?=
 =?us-ascii?Q?srCb26z/xD4igcrvJPv2w+dDXSnSGzfI/j//+VHbnKxL5OuQZSL9Cv1H0UTD?=
 =?us-ascii?Q?XExKbk+2AVmygu4TZgzCuoyFCtdISHWOZQ+bfkf+TCmmAXOKWv1tOIRXFwMf?=
 =?us-ascii?Q?/TwL+cZwKOE4viZ8nEyHkHMnE3Xp04Md6CLVDgO1rj+FvOYohD43qlNWMDu+?=
 =?us-ascii?Q?zz5+O1GLiDm69TL8aUm6U9B56K5tHw6Gia7VOi57VzQVvDKeHqNNnEiBcrmA?=
 =?us-ascii?Q?jYhsc12J0ooI1lPoELnbEdvkgWYgO9Dh99QMDmCnCU4yh8aNO4jLE8Dw71Lu?=
 =?us-ascii?Q?y/85HnLi/0r1EfFVcIk0L3xylPkG4nt9AK8Mm7MMop0ojypnMli8XcXOitf5?=
 =?us-ascii?Q?YKzv34Lt8mfRYSMVCb6YHXhDG4cFMeR1qzFp89dQdubZiU8QzsOUGcJ1hwH6?=
 =?us-ascii?Q?RBe5SBD9kkniYHjEiE2vUZCMppevFPQC5N1QCZqa2NKl+mneCUH/BxwynrM0?=
 =?us-ascii?Q?7Eo+UWT01amb7UbMP0HLgpSCaBTRzr0YG/FA0s8j37biHDHsJwnaRDFhZRID?=
 =?us-ascii?Q?gcEZQv1buxgXHfSKM00/ARtbrAmV8I+1TUNyl5Ofu7b6w1Knh0FCueTxMIFB?=
 =?us-ascii?Q?57niPBUQSAZHLCisYAij9SM40pe77E8rBL1A4X3GF8ic/BmAN0K3eUCDNnl/?=
 =?us-ascii?Q?7vUJajX8w/vM72tCSYsd9CSBzQ1ar+yNjJ0f6fTQ/2i2YmNhJqdvSjYL3j4l?=
 =?us-ascii?Q?FNQ8k64Bc7MTK+bBiKCk1A6ahpspIlciL17uEopar4L3CVhNYLOyauVNBdSf?=
 =?us-ascii?Q?N3ea5kkXOUzkLZCFkOdD85A36z6lN7veBnVCb0++RC31/F/x1KdYKf6wYRj0?=
 =?us-ascii?Q?NsDBwLRy9N8PzUZzHlBwJ32zI6OJu0bL6yS3No+PuoMSYr/HPlTv97J+g1FP?=
 =?us-ascii?Q?wMwJow59co/rfe3Bgge7gd4ZGMkDTEi2d2LjfjNTrLA0No6GseGg5TllfGts?=
 =?us-ascii?Q?e062c675ACTshXkL+wc4sa087ljzZU0065F2AU0HQm74LxlFOhqOmW4ISqgx?=
 =?us-ascii?Q?rJ6aEGKqlCUi6rZp0juKwWfIg8jK1OK8Egme5SwxcuANUK2l7KyQh8M3r8EZ?=
 =?us-ascii?Q?YWoRbPLWDgu3MmsRkf6jI7f2s3R002dP4ZPOqipuzFw+DOxPqTr+JlDLxQ2t?=
 =?us-ascii?Q?PgQ91qvkdHYYXa8U3ZfckWx+jUyIOc0OmIyrrqhRd52boj3Ifhli5k6bSPYK?=
 =?us-ascii?Q?MdLJFR6VLQkHiJu12sKPMBOktPRV2FEB7prSXLm95CRsgKpuOUK6XdMm9jcc?=
 =?us-ascii?Q?22pn4Sps1lMwiTBDrvCgTtKODOjk2jhTcAZW28nCysiyIxrlKYwoi1AS8H0f?=
 =?us-ascii?Q?EDfTMwU+4DwxUgVirlW3VLyGbPvx5tcwCU0QpHrIxZv7zS3wJlZlA5tv/xCF?=
 =?us-ascii?Q?YzHCVtXYaXBHURXMNBeRizIVTSmgkWRqi/Z1bUJVZRV7FRa+RfAlrO4KQZ02?=
 =?us-ascii?Q?7i7B+WtlvHhH2Qbe01fgJrzT4xPoALBlH508C5ubDRjGoyhp2xFFBRowRYCb?=
 =?us-ascii?Q?DoKACCZeSErPYFTSEds=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c51e531-b36a-49c3-9ec7-08dcfcf4d965
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 17:19:33.1748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /QRymVrKHSBtR2chYZtOH0i3f5gR7OhkF0Yq1kdm0YwXGSMBDyTrfQ90BtPrPJGf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8045

On Thu, Oct 31, 2024 at 02:21:11PM +0800, Zhangfei Gao wrote:

> > +static struct iommu_domain *
> > +arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
> > +                             const struct iommu_user_data *user_data)
> > +{
> > +       struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
> > +       struct arm_smmu_nested_domain *nested_domain;
> > +       struct iommu_hwpt_arm_smmuv3 arg;
> > +       int ret;
> > +
> > +       if (flags)
> > +               return ERR_PTR(-EOPNOTSUPP);
> 
> This check fails when using user page fault, with flags =
> IOMMU_HWPT_FAULT_ID_VALID (4)
> Strange, the check is not exist in last version?
> 
> iommufd_viommu_alloc_hwpt_nested ->
> viommu->ops->alloc_domain_nested(viommu, flags, user_data) ->
> arm_vsmmu_alloc_domain_nested

It should permit IOMMU_HWPT_FAULT_ID_VALID, I'll add this hunk:

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -178,12 +178,18 @@ arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
                              const struct iommu_user_data *user_data)
 {
        struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
+       const u32 SUPPORTED_FLAGS = IOMMU_HWPT_FAULT_ID_VALID;
        struct arm_smmu_nested_domain *nested_domain;
        struct iommu_hwpt_arm_smmuv3 arg;
        bool enable_ats = false;
        int ret;
 
-       if (flags)
+       /*
+        * Faults delivered to the nested domain are faults that originated by
+        * the S1 in the domain. The core code will match all PASIDs when
+        * delivering the fault due to user_pasid_table
+        */
+       if (flags & ~SUPPORTED_FLAGS)
                return ERR_PTR(-EOPNOTSUPP);
 
        ret = iommu_copy_struct_from_user(&arg, user_data,

Thanks,
Jason


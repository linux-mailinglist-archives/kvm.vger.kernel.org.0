Return-Path: <kvm+bounces-3401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A23A3803D2F
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 19:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D82828113C
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17782FC25;
	Mon,  4 Dec 2023 18:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iKYxUDiG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A8DD5;
	Mon,  4 Dec 2023 10:36:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjyeycUNlfLQZSSoU4TWYNLNKrOtkn9hv5J/Ulkcf8dHjji7RpB3ePZ9L9CxPOme9PtMHHhNSxy6zRTH/4tuWMqL+hfv4eTslAXz7yAE2dlYiK0Hqf3Z9zJ1XWuXspclDu/z3vvRQA7jQhA2oMFKollykGB426l5ny1eSP36ho4pSB3w+F+v5LvMVkyTWZ7+MNAlwgbU2oEJ0O6Kx83wk3ItkaB+UDgfP2opcnt5uBS+q44uhW1TIe8xaE0ehvWu9nHoc03dGVSPnycpMCylMhfRoKvbl9J/avQjEZ7PluPSmXzyPqMQP5Nc0Mzld9kbWl0d8mZxl1IGN/+bsvyK+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6sLzionsyGQUnudfBsnXfRnXvBx3t/jXAyTVww/0zRE=;
 b=Eec+wBr+ssJhnK+CXw4K+KVJYU1339EM95DNm3p4TFHFX5BxWUBWPY1RPEqpYvOnmK04RK3+40+Lpf1ga24p2os8cMkXOuWmeLwuEbPBhX0LpxsSzowyiVWlptX4uf1SGQVkMBDfgROQq13QwFgX67+IK84trbi5rqfrc5IYyx7azKp+9FXmpqso/4vA4OkXYCMX9WkDc9ssesVF3FeQnMKZSSHQYUeoMJttFfeuDWNS5gNBMnCsO9DkE2dCK3VftTt7RQq4Hkn8fwht+70ISsEWAZE5RpkeYWqHaUKvErV2ioQH2v4M+FwC9v7DAp9u+0CoV5uQi24MwcOLZlpJCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sLzionsyGQUnudfBsnXfRnXvBx3t/jXAyTVww/0zRE=;
 b=iKYxUDiGm45HJJsSGeHiaI7ek5h6wvnL9coITDqcJzZmryseAylHKSaPtJJdedlNhFUG2wpzvEnr57Qa6UuvDyJ5eD15pqasKNZ911bb8yVPhq8k2o8Qflpn1FO5/+aAlIpebnEjlWxRyMOI+tfhJQGTi1ZAgrSdx+CefPAXkzQU70Me5ApIFDujbJc/TKCuRp9ab2fyfHVH9R6MfM6skmzed2gwA+X/7mTaUVfEua1bE9f6UBep7yQVuKRFKQ/NBoXKmd13fu1w9AS497aqQMLTZd0RWJG4DAf0kANxESzVG2xRIjmPSSn1o+Av/5a+HGx9eEeOXCSJ/c7JAx3o5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7889.namprd12.prod.outlook.com (2603:10b6:510:27f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 18:36:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 18:36:04 +0000
Date: Mon, 4 Dec 2023 14:36:03 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
	pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 16/42] iommufd: Enable device feature IOPF during
 device attachment to KVM HWPT
Message-ID: <20231204183603.GN1493156@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092311.14392-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231202092311.14392-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: MN2PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:208:120::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7889:EE_
X-MS-Office365-Filtering-Correlation-Id: ab329631-4c02-413f-40df-08dbf4f7df2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mkOfwjS67ywdC5SLtsLV04xekg3NCdorZ9NQoJ2h3hbS/CcE42KaqK6flyINBhG1St8kt6TIgraOgLiglf8+YFntYyqlVzG2ITBYsm7IfmxqjCNn3JPieaLaICrpS9cx9o4OvHSR2VRELGtAu1icQ+O+3wjIiTg4YT68zFpKHHTybtIZeixNpcMFIXJ+1frPyUwUdp+cdfT/LmJbKwbOmO1gfFBiyPjATipmS3deOBURs8FxKnDwk8Omf5AohEgccCn/BIJwEPwjcj+VOb/AzmFl2ktq4uEiASAkLUm1OMs3zRsUSZAc8bodKWr3j9T9X6Po1e/VAeDIx7L0/MlwLgK6b+RDMVI8W/eRH8FZ8ap09KhVOU6Q6jxAujFeK/d7jRWSRYznE15s4Z62/aoERzZKMoV5FZ4O4NZRKGvvtBr0CXKipgTg62eae+xMVdZWXkGSrILuvSNWOiIaAfeGfhZoDxFtZ02Kc6JX4lCo0z8zklH5ir+niEq+wbq5+WR20oUiX++qAcNFNR1anam4S3PnJ8lMHq4fYL6sGzCClQ3wc5isw5CO0S7TlWH7aGWm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(376002)(136003)(396003)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(7416002)(2906002)(5660300002)(86362001)(6506007)(478600001)(2616005)(1076003)(26005)(6512007)(6486002)(66946007)(36756003)(33656002)(8936002)(8676002)(4326008)(66476007)(316002)(66556008)(38100700002)(6916009)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Arj2jwTItPyBpFshOQAe/tUKGWR6ymy6BGp4mhiFKTK65uRhZLdM1cHdtjcB?=
 =?us-ascii?Q?ofw9jDeoYy3g8TWM+L4/nZcF+h4B6ZnNdHCRvKbXIC23QsNGW+dzuqS9KYTV?=
 =?us-ascii?Q?Y8qbbpgsooI5nW97RAMhnmwgobCsuliz9RK+lIBBknhEyTOCH5gPwnRsoGon?=
 =?us-ascii?Q?phLp2ix1mlwV0vh+0C7EOlnNHwqcSISxr8q6O26og/Hk/ECSfss2kZFtv/tk?=
 =?us-ascii?Q?7uksJ7CuSsN5bF/0deDf0JrU5mMsyBKNwUut6nJEZaYzBk3BnugMEirBXvDt?=
 =?us-ascii?Q?vloPOM+KHyAlbMyP0RvwtWq/xzLggsN/LYaxh/Ziy5kur8I5YsXtmC2k6r6c?=
 =?us-ascii?Q?wUwjVBkwlvzRa1Z1zIDIa4qXWDTOsYzNnNwGtZWgptGqv4qpyotUifLyFj08?=
 =?us-ascii?Q?goyP1zA/VFAZwcyHYVhePkn4Tdwfd3f0OBCt4yvNuQolcdv1DjEtvZ2CK3wP?=
 =?us-ascii?Q?ZdDTBVlKE+w5cqnxSRWJrrDX7llJ0OMV/ruAXEMGgoI79dtoEZXJtHwNL9aI?=
 =?us-ascii?Q?IBVNkZ3cUEYl0oBbxS+ipaw+XUaEYW658U+JyFyYwdchyEYQvG3Xnzr/BzST?=
 =?us-ascii?Q?9YsHzBn5pI1QkMaMj5lx9f3/GSPC+wXv+esrwNXFdiO9buj1irUD5rhRuKo6?=
 =?us-ascii?Q?LXLDEcOH+P+iIIo6k056bzBaNrDNJIIgfQEoHdTR88PYIBtViLuHEvO9WWMC?=
 =?us-ascii?Q?aN8l0N0tgGdX1A+mj9VmWL0Jv9XDAIeSb2CjVl1K0++JQyCsxX6DgQGjkxNg?=
 =?us-ascii?Q?FLuLCfWYKYSopqoBvt+cFPboVlq8QHGMZJKU+7X0Arhh2xbbdy+p3kjGBOtv?=
 =?us-ascii?Q?9JAB6BLLxRMDdIxDYcp0eDZkkcH/dcTFICSCzS/2M5wlm8ELmKABRUMcNCnc?=
 =?us-ascii?Q?DSJd3d2M9bBUcM7eS6gA9cHqu/xnbqQ5WxcZYm6CflvW2pCYakRtkBloV1OG?=
 =?us-ascii?Q?VRfqo9HzOejASJp6+26am/PoqgUjWAeV2ZllaUQPLzG2zpC/jAjsqsb8JD47?=
 =?us-ascii?Q?wLvuj2ZWcGSfjXoxgcsmNqfbS076DOR894GbGxEGPrgGClxP+ICVKcGllJ0f?=
 =?us-ascii?Q?if9aHqZx5QeyjTvk+/zegSLJXfsnWu4JTQZiUJtbcimnB4Q0f/E7uGRcAKke?=
 =?us-ascii?Q?BFLjJIkeUYbKsMehTxAdLIbtqhVA8B9NAZZhChqxX2ir4f/mMQxEw0CWAszl?=
 =?us-ascii?Q?VEY6i5Pr40QAS1LIXLcZDEQK+qaBRAk2NIfh8UgWAvPvhcR/Wd91hnAfSN5c?=
 =?us-ascii?Q?S4s1WtWjuTWbNyAIxYPgAasuJT5wXav4IQkNRb9lgDCozoeKy/O4yaLbthzq?=
 =?us-ascii?Q?onvd/k7C0dIjQX69Btf5gN+Hrqq/foH/L8zTnxpHqpD0EXJ+FLmTcuBdEJ+1?=
 =?us-ascii?Q?HBHoE1/LGru0oDrYhA9Ga/eDB0Z4cMEpoH5+Oe04MeitAZ9ZhLFBT1b3FS8p?=
 =?us-ascii?Q?s2S0Sfn3QkmrSXFkwfE/Ue1Exv/FeTo7yIYwkWHlpYWwHjcGpZNQnD+NwIIw?=
 =?us-ascii?Q?6/PdUFuiCd7ffPUakbYo6BHLPuiiBSNn8UmbKXeQjcwtv3UdC39bQSCcA/5q?=
 =?us-ascii?Q?e6wH2dLAMobM7rzX+3a08Uq/0MA47K8sgFaQM6lk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab329631-4c02-413f-40df-08dbf4f7df2d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 18:36:04.2766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrdMLkCUXlEMDzz+PykNVxyTRo1fyF0insF3eRRHZhECTO/U1CJfpeaTEZU1Fh3w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7889

On Sat, Dec 02, 2023 at 05:23:11PM +0800, Yan Zhao wrote:
> Enable device feature IOPF during device attachment to KVM HWPT and abort
> the attachment if feature enabling is failed.
> 
> "pin" is not done by KVM HWPT. If VMM wants to create KVM HWPT, it must
> know that all devices attached to this HWPT support IOPF so that pin-all
> is skipped.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/iommu/iommufd/device.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index 83af6b7e2784b..4ea447e052ce1 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -381,10 +381,26 @@ int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
>  			goto err_unresv;
>  		idev->igroup->hwpt = hwpt;
>  	}
> +	if (hwpt_is_kvm(hwpt)) {
> +		/*
> +		 * Feature IOPF requires ats is enabled which is true only
> +		 * after device is attached to iommu domain.
> +		 * So enable dev feature IOPF after iommu_attach_group().
> +		 * -EBUSY will be returned if feature IOPF is already on.
> +		 */
> +		rc = iommu_dev_enable_feature(idev->dev, IOMMU_DEV_FEAT_IOPF);
> +		if (rc && rc != -EBUSY)
> +			goto err_detach;

I would like to remove IOMMU_DEV_FEAT_IOPF completely please

Jason


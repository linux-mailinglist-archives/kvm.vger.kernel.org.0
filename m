Return-Path: <kvm+bounces-16155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2B98B5AA0
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61FA11C20E7A
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 13:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E680574C08;
	Mon, 29 Apr 2024 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KR+ME3xE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E857745ED
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 13:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714398991; cv=fail; b=Q4OGzQbJlOoKH8u2hr16a8SaizhANe4hd+cCHQqdO7zPBrro6JLvlx/LZxoRzvdzUnKD2V/1Mzj18+rmY9L/bO+PPO096uN6128EKtZgXzfKqdQxhMKEEAwi8JcIT4URJcz3HrT6P9U5xaQeSAH99fNxr4uYKjcwU5s1LeJYYlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714398991; c=relaxed/simple;
	bh=PuIn01qu0vcyFF3p7Dt2gM5BrHV12RBy2d8hstO499c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ajd/HT2rNnE+7jv6LNUkRfL++gsmXLt6F4x9fvLN+n5DYqJ/8LjaVzhMxIi1T/zdRsb3HB4xc/owZ1D3RXEmPKSfH1STCTxCpoqZ5LrRfMoat4bT/rK4JeRyG/OHfbp7r5Zk0dJBuGzrDRBw9kuN5MvmWNlZjcnrtoEGc0tIfkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KR+ME3xE; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUJBb2Op2xyeFttLpDTn8evfZcvBi0tY0kWpCsgzTbG3nZeZLkaODEtv+hkAdocJpBcti73VYcoZP0Q5rO1/a/UlB1eTrsd+EPM1gt2bTmYBfiComKSCO5GWSoR8PspA/kj4aEJZIL6X22QdW/YwuxchtulgeC6x4LZIbeLEeSthQL/q7oGUIa0fOLDrWBlMCnE6E4hvvAdRUK7HXpYLcshP+Emv4vAsrDGCM7f4jUjtHmOXAEoWK03guBS+SAS/8vVDRROFHatixWoJAja/vKccgCw+ncyzuKXIrV6Of1BvvgF5Mqmrqy0PWRaBZNVkPdoL/waU+3IG4pkxce5azw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RiHynMKtHIoFD6+0zFcLlqJSOpuuQc1wA+Sl1bob0pc=;
 b=g4CptybeQM1Nhr/cOuEK5Dn5otNqha/1oHXbL+6BTb0DIS/jURwjAJengeCWmhLiiUMRbx8yhG/w+QgkGyUpRH4mTSsljqZUIrNvwxhDbMGlcPlkrPUVetOL1n1d1C86JQW6DCN3dgBRECLW/RiR08jq8SInGY2ALk4uxUCFjfEo8RCYt7kY8QIEA+lJf2izCK18w06Uszm4+s/bUbCyD8ZgNpKPd1DNj4j/dd+ukOw7QP2VF4geBdcgt7wVBuaaY4Gp8/BbvAO11YrO7zaXfOO84VvqbMpFD4DwJll+Fz3zD8SNWwAOfFdz9DyuwlDO9Yh5bAZ66CNv/c/fthD98Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RiHynMKtHIoFD6+0zFcLlqJSOpuuQc1wA+Sl1bob0pc=;
 b=KR+ME3xEpbd8rsbd6L31Dw2jDQcSQvl2/vYrChKC1tZr/0gxaJyMKszAQZ9/LmMjBtEtue++HhB+SAy293cFhA9z7swv1MSMBIQ2a42nsEyTcLLLxzD39WdcKphWeYEhm3yOGJUvGRP6Yxcd09+zlCtFOsxadTvShvxHyTsOP1p6J9Ve8RawgwSwWZB6bjAf7PaWfKEzGUfU+8IqqpEFuisrSrh2AqM/ILmQtHeQSFlXqryvuprYciQ00EL1InGqn3C86YEL1LY2+AHeshHtD52I5jz1Ly+9oS5/h7pnMwzDpSIWb+D2Kqy8oz2dJZHPyXWRKIrsDWj+1BY9QMat1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ0PR12MB7008.namprd12.prod.outlook.com (2603:10b6:a03:486::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 13:56:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 13:56:26 +0000
Date: Mon, 29 Apr 2024 10:56:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, robin.murphy@arm.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 04/12] iommufd: Support attach/replace hwpt per pasid
Message-ID: <20240429135625.GD941030@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412081516.31168-5-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR15CA0053.namprd15.prod.outlook.com
 (2603:10b6:208:237::22) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ0PR12MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b93d40c-74a6-4ab9-48bd-08dc68542997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N+r00bt6Ph/cTsUd2YoMJMhn7lx4k4+UGdtLkwoD7IiAw81ZD7lZEbq67chF?=
 =?us-ascii?Q?DCHUCJTpz4B3EvmFJW4lia6OfUcYpGWoR51A/A2mkMxriGSCywFgJf/jpDWQ?=
 =?us-ascii?Q?WoPbVW/l36k+9pQn8QfYEGVyZsYByvjqV+NwuGgGjfDzVNmGVdu6Il/2dkSC?=
 =?us-ascii?Q?KClBJsRrZXlJoHuYoASt3oQVr6ri8pzvV/ila67TxhJhbYX8Rs50lvBrQuEc?=
 =?us-ascii?Q?6VI/4cG44BLyohtT7HXQ0ZixrjgbZ55I3cJiQT/fmlym1b3dcB6Kf35p6aw7?=
 =?us-ascii?Q?iI5+9jFgj6zlnRhiNI8aQoZhymf7ntPa3y/vGFhsU1KYM+e2dNAw8GAJvboA?=
 =?us-ascii?Q?rx/aBlEEOKPhusV0WAs/z9W8XlavRXsSetvLjOv5mQegDGOxU+TMNJ3PfPke?=
 =?us-ascii?Q?ZVJ4ZA331CXObGI/O0AGejEFoDG04aE5hpnB/r4budvl4GGYXEDPBVAmoBHA?=
 =?us-ascii?Q?8mlkN34AXlWbGDiUi9IDzIX/ITXNMR6yk+vAQUzQ4iMwIOuuu5yVSfwS8DYh?=
 =?us-ascii?Q?MnvnIgesO3XD1CizPqljy6SRs5mtuHB5qv9YDdUPhnjiicX0BG8pFRgzZyNX?=
 =?us-ascii?Q?HSoHfB5jEoCW2INlNHwMn4yrMu33iV9eyLiXvkhjSc2dRlObGv971OsavC9N?=
 =?us-ascii?Q?zvP6NIbjWebp3XEzIVwE9aS1zjh195//9anWRVS6IFfq0CDbBmtF/hflKgCq?=
 =?us-ascii?Q?VBUHQBTVRp2cQWzcHD/508z1VpMeimTrbvXgmSX/Cw9kCG4vYA4GpeawUsUd?=
 =?us-ascii?Q?1o6TrAUbhfCFliDBPqZ4NhWdkBeNu9KyKawjTOGtPEdMVm/xYbB7L3UVYEkA?=
 =?us-ascii?Q?11fSp8pMI3KRwYv957vy991vge4hKfu9qgS0Hp+w66iqsl8oVbmyqmtnS1kH?=
 =?us-ascii?Q?shjYVHfEc73t5RfT0wRLbSOrSAG8J7TzPyOOGDAbPzAkkg6RRkJuSyx3ZfjU?=
 =?us-ascii?Q?1qTWckb9b6l0FVomJ+vKeucn/FBkehI3HP38tOSVBHVCKdVSruIcOMCPyUPF?=
 =?us-ascii?Q?tXUmnyG0QRKV4MqdQCPtWXVjaACxF5+wwdACHxEdbUKTmZQbj+6Dvep1SPIt?=
 =?us-ascii?Q?XD1FA/iZJz0/7aaFER+Z4t8Cqj3qyH9BJAhg9LuI8rFeCySvPnmI6WkjARqs?=
 =?us-ascii?Q?TT3mOYg+I78vXqotA+mvQqzQdUxVTVbaSpVPP4Orz5P8DfEnQ1TLJGbQRD6b?=
 =?us-ascii?Q?kJ7c55tE20Z46yVVQesuOvh1+YOvGFdYxjQRnMr0x2vBHp+pcYWGQQi/+h9v?=
 =?us-ascii?Q?bj5y5aYrTvlLRIkpSNprfcQrv61MGHYCOFDgYhB8yQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FUz5PoQPkZ40gGW36Z809LkZKAJFbUmZ25D9hvhD3/ytORo2MeFTYMCLsF7z?=
 =?us-ascii?Q?LlxYybxCHTeIPxSuHgtWZHselOOulWPTDYsWlvEzauU47+x/Gk3P9y8QC0M8?=
 =?us-ascii?Q?q/H5hMmX3DgywYiYaczE1YfcqSyXX9hZXlsiCVL9pAUOmdvlFjHItr6lHjJt?=
 =?us-ascii?Q?G70GiGx5rXzzqDQNSAy/viyGNPDcgdiP3LeMl0IGqik8TPzZgiUd0V3EH2AQ?=
 =?us-ascii?Q?UFpzGX9cOV/W1MayJ8IWQx8xhi++VjteXBESqI6Dayy+FQvNOfGdew4zW1Km?=
 =?us-ascii?Q?cz77TxI9mSxG+2CyRMxAihmk7UhIP4PWeOCA74ilQk0KpH37JYVZv2E6SByS?=
 =?us-ascii?Q?z8m/emv2OEJ0KVRHLp7q4cuFzpB0dyWIi7tgILBuQeeDOwUUVkLdCExyYOdK?=
 =?us-ascii?Q?pdBRDGWd/wxCOOoStQvs3BLy5e6mu6eafYsiW1aedn/fwxsO4khDcLPVlcrS?=
 =?us-ascii?Q?WbyRcfwLgWrqcL1fqtVzG3UBJ0MsnqxyQBcQDCeAJmc5c9gK0F79g1UxI3cp?=
 =?us-ascii?Q?dwA4++1tmJFFTR4F7L56pxlXgPitnuTUy/r7J7pKBlHnFphwWDjLyRv1iPUn?=
 =?us-ascii?Q?Ek7H57e4wrRaJ1h7ESdhAYEZ1BmrggI64X/qRoJEqVpfyg9FRt6VnE1tygwU?=
 =?us-ascii?Q?0uNRRL7/l0HgW4lIRw0nRXBh2kBxC1R4gYA3N4mI0AeeipIbYeJRjGk6dAoA?=
 =?us-ascii?Q?ZLacTURvUw5IW7fX3O+BT71VtARq6UUUljuKSsJUrE/mBxbOxyuCwjqCiNd3?=
 =?us-ascii?Q?5NQMV30ascnF0N4wCsEsHIrR4Av2KlzRxnN1W08zzvDuUFwAu/JujYmMx2le?=
 =?us-ascii?Q?qfCfUlrzhNFsiJfYpBjchvMlgd/NdNFhcwhDZW8KaGbSnNCOPpGZFm8ATKpu?=
 =?us-ascii?Q?is9m/RhcmaWJ8VQSkwkeQH6iFKwBeshYY2+hwIJJukV5uK+QD+pWtGU/4lHy?=
 =?us-ascii?Q?GUwKWgBg1wZZrTm93YVG4wDFdhD7pfBu+I6tlo3iHAS10ssyiGMewQh/cBJz?=
 =?us-ascii?Q?rAp/PqasOjS42/da/69P+1wTM4SYIKq+yMwrKsnUbma9JvAQA090rlDz1fIz?=
 =?us-ascii?Q?ZkVPH1KPQgpb8M1c1LVP5omfHoWi99SNez1k43CJx6qJfAR9VXNIUCd3C4A/?=
 =?us-ascii?Q?X+j7JPgMoWWJl+oBWF5S8Jh8cIazOKD8ay8l9IjGXRxdfyb0qa5tQPp9ToQa?=
 =?us-ascii?Q?LzeRsaEGeWVt75q9pBAwo+thhUc+6QZGNTBEVyzTpwjnXDsSii0JXK7UwL/d?=
 =?us-ascii?Q?dVe9XtEh4ePYQA28Vum3Rra7NMOnIbakO6WRQW6yLHNYssXZhb+2TTrLjn8w?=
 =?us-ascii?Q?fpPYrHHgVIwzcTopvBYAKaiHO3tgWV0p6mKX1rw8u1q895fOjxgqB/hE/QeY?=
 =?us-ascii?Q?OhkTHaW+oe+BLq4FGIKgFu0gTWLHPpWrUeWKLwJc9eaPPlgaIwcMccd29jpC?=
 =?us-ascii?Q?GjPjzTF3DAokdSXE7uGdH6TZc/mPSMjtVd+87TjSMPhUEFHLBd+RaQF8zIc1?=
 =?us-ascii?Q?H83otP7jRXQwwiNSZfBKRj7kuTVT0iGfxCYPHI5jPymIyV4jhKw6E36DP7/j?=
 =?us-ascii?Q?j9FPHNh1CD1grOCl0dvRZaR0OYJA/Otj+LhvkT4c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b93d40c-74a6-4ab9-48bd-08dc68542997
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 13:56:26.5468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJBs7Gmhaouq1x9SdS/eP8oYXVV0hnq3Ym4GVHHsPZK3Vsmch8IEQsZ9Iu08U0y4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7008

On Fri, Apr 12, 2024 at 01:15:08AM -0700, Yi Liu wrote:

> @@ -413,9 +414,23 @@ struct attach_data {
>  		struct iommufd_hw_pagetable *(*attach_fn)(
>  				struct iommufd_device *idev,
>  				struct iommufd_hw_pagetable *hwpt);
> +		struct iommufd_hw_pagetable *(*pasid_attach_fn)(
> +				struct iommufd_device *idev, u32 pasid,
> +				struct iommufd_hw_pagetable *hwpt);
>  	};
> +	u32 pasid;
>  };

I suggest you change this around to pass the attach_data to the
attach_fn and just pass the pasid through that way instead of having
to function pointers.

Jason


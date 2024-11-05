Return-Path: <kvm+bounces-30742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 127AA9BD0D4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:42:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B6E0B2188F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A79126C16;
	Tue,  5 Nov 2024 15:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="db2c3+Ru"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675707DA93
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 15:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821326; cv=fail; b=Lli0C01/aRxpTQvOWG1wyaQyDnSXRR9DfV2ZDTytVfFWawSTdvpDcym88uYfBMXjxhjOiQKnRpDwSDSnuG0mOpuRClOn+qHp/+zP95pN+Fc31WeTYHUpaz+bAEgmG69lN7QN+AMdR2m6aGNDI6A7/e1Aqz3Z1nxcbNyg4JQ/6O0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821326; c=relaxed/simple;
	bh=+hZM85wfMkuZhS3pw9z6g7iOw/8xo7b0IWw/93jh+lo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PKjKFZTLDXW/fg3NaH0Cc96NGTEgyzcO72NGANkITxyY+AGhy/qMwrboIOJWb368FTd5Phvh+CXP2iOFJ9NPFxbpAa8CEZUGlOyMsA8KoNSBgSbxr5uUjWvPlvyrPj+MdV1BRkZWuNtEidG5gHP9fG4mjKfYtJDDgRGgxaFjv7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=db2c3+Ru; arc=fail smtp.client-ip=40.107.93.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TNaLolNgN72HxEcBgL7Qr21dhQnDn8bmEOaHKtuHzBVXSyfgTm2PwViwXtjaQFTqK8/31E84Iv/1MccELuYpJp19uCaXz/6SC4p68SPWvyf+89txnksLS6ZFfrlfZe9b42I2ArttAEL1PDFvceL+a7ulpntnlyERJLHaUuUkHl5+eS34Q2AT6Dkk9sVJMGps5VGz+4TPJ2kyEzSckiptqqCYfXvtDlT83xayen5ISCW2sMYe5stf0Hc0kUrvbGvujt4OXESBhPdxYA6MLnFv1TE9XmMZHRSMk3mPgO4ioVHxXKbTY5JIjz7/Yu5ZfmXSX8SA7mgp0oekLFYAF1fHpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTvIuW1LIAVwpmAPMKTcPu5NFLp47ito3UewbpqP8+o=;
 b=g/UPTQqKJAvx6t9+8dOI8kXaZsP9RiuRhFDaU5SA6iBa1/igWyboLqpyZIHK7Xw7NmU11xS3eKfHwB7kjcY06moUAEQDbUdH9hkPBeiK4PqDDhZb4gNo3vVl/5kkJqeZXxEcJHei0zFEaG9UcDd4gozKXvHC5beFKrIZbfpaVBrNOaOEVtZ6F5S8y1FIJrdZ6Oew69rEoDmLCiwwEFCCnuK1aTlsHq3Vx9YLpgIqKxJQAVOZ1eZ3FGB4KLjGaPEyMARKChcUGtO1yPckeeuoR55CzBuyYoa6zh3JF6A61tLd6EDjgEihio2hGBnOJRVD1brIDJQVRS/G01Lo89JQFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTvIuW1LIAVwpmAPMKTcPu5NFLp47ito3UewbpqP8+o=;
 b=db2c3+RuOGEIvjETFqTCCmZA2PjC6g128O9C1rV7WvaL6KFpPWNXPZtstHW+ZOCJcFpI6xK3PDLZcmHqN5KY/cn5hsSsBOgU5rEMb28yFJoo6Wo1eRfMSUN1/sMA5GDIpHOZCxAqjILOgPFWL5Qp9TTdVgpmtt3WJHMUfyy0+ToA4QquBlZLPD0/8z0Vi1n7f4ZlngG6oSvWsJdfBg2IqjVno9bt+MjTrTNWDVclADrxarzcJNZ7Zi7764HsfLKhBho7WqQ2DsGiFcYmqsp8FN2B49O14MOy5zLtBldtbZDAM1jXAUCWtderf6WX+n1yP599IgcDJgAV1Wya6BDYLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB7675.namprd12.prod.outlook.com (2603:10b6:208:433::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Tue, 5 Nov
 2024 15:42:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 15:42:01 +0000
Date: Tue, 5 Nov 2024 11:42:00 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v3 1/7] iommu: Prevent pasid attach if no
 ops->remove_dev_pasid
Message-ID: <20241105154200.GF458827@nvidia.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104132033.14027-2-yi.l.liu@intel.com>
X-ClientProxiedBy: BN1PR12CA0022.namprd12.prod.outlook.com
 (2603:10b6:408:e1::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 88219735-ac30-4982-e0c2-08dcfdb06429
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j15I5X+MZGm9VrLvSMbInXqEXKCl2hOKJFg+iXxOUAwDvevIjyyhiQeDz+qF?=
 =?us-ascii?Q?bPOXHhoz48bwk+9F6ThgcLg7j8MrFMdJw04DuJqZtQbZgHXIViSkO5TjeRbF?=
 =?us-ascii?Q?H+gWaWo3IA3j4rG5j6uPh4anODTAxiQjro0VfR0UFwVgiGJ57Kh1Jw89+FgD?=
 =?us-ascii?Q?trt5OXDrTMrneZuhkh9KC3XwFqXnA+c2BHWK+BxnAmP5PCi87iNmw/K0UAZ+?=
 =?us-ascii?Q?+P/cG9QNC6hJufAGQKEu+BiPGxkz/Zc9JZiA0y+kWfanCkLF4T38JNIBGmdY?=
 =?us-ascii?Q?ELZ76sGYDSsH5Og/qXD2NlMDT6GdfvvyonyEiaR81tNzo3Tad7pY1oZZ2diL?=
 =?us-ascii?Q?ddweyly+g7ZTGHVzbLNu3Dx0FpWmbF8/ArOeZf6Vndo6oOLhukqdMIprbmvR?=
 =?us-ascii?Q?v9ENRP9uaPujTrWLkx45F4AoRlIhvDvxQJ+nVuSLQ4tdCL4ks9n7nsYr/fIl?=
 =?us-ascii?Q?c/vVLxn43o7MssZb+EzCn/JC8iqyvIAeFMP62kt8rEzOFtRx+5t5wF6+eUDC?=
 =?us-ascii?Q?inO83yiShuONthhwXPNkZjMjYL2vpAmZaTPr6+QUQ2cQ2vAWSR080A6V+GeC?=
 =?us-ascii?Q?67tMnVWGOReu39yKDkLcY6ZD7Q+FlJSmQTxncaExzgxrI42aRMR49TfuppPZ?=
 =?us-ascii?Q?hbxX5WQ7zFkmdb1schWGxDKNqpz7GSNmhOWAxeavrkqX62vt156ij6fr+A8G?=
 =?us-ascii?Q?NAJ5uE763SWReFx3eYuLTOLBy8Z1qpuxDrTvG15GsJiea5nnJu4RSp/ce7bJ?=
 =?us-ascii?Q?3nJz6UvozrppUPbZv/EpecqkvH51LkksEf3tkavE0mfBPIpyJsAfOE8TVBn4?=
 =?us-ascii?Q?AEE60HbK6mS+u9mpC7J6z9I0nWTzLgvjSrplfiU72rPfh1+J/Q2+1vVQeqvQ?=
 =?us-ascii?Q?RE9qgZPqLTqLSRry3KV80Qgs+4jqlTWtJ4ZwTu326EYOn81UB5HBEnmR5BBZ?=
 =?us-ascii?Q?dgCiIX7Ijg2xQ2ScrVRBCDUL6hs5jZgsjQSKKy35PDvh/CrjwLyF/d7zkaRS?=
 =?us-ascii?Q?jDEcpApVg3WlQi4CbEy//usbQU5h8Ux3Cu01BRf2wlxzUwh5Yyd4PcKRz8Ya?=
 =?us-ascii?Q?IwFAYefTAprPFW0Laf0S9FDoq7lPBc34Rr+gc2c6pIvQ/V1oglRzKf48TOSg?=
 =?us-ascii?Q?OCuph2uE9xkWanGk2VCQJgzhDtHEr9Hyln3AqkCxO436ouVTP2ulbnJ9dGDx?=
 =?us-ascii?Q?ojXow1/nV/VX4xLCi5Z8kmkWHq5ON4vMYdWLbsR5qZrBtF3Ux6/s3kisW2i1?=
 =?us-ascii?Q?i3bLyVVq4g06yQTNMxkrQp/+YeLVDhWRkfoT74EWJxl9Ul1nXumFCWWEpz7j?=
 =?us-ascii?Q?+f8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O2i1l7uK7BsTzLuoukhza1YfqWzn/+TWxkZAfAOH17naoV5irmOU2uU4Y/II?=
 =?us-ascii?Q?xb89fpeh/TXU9mMEAraLoHyYWMMRdp8Zt1QkLKzZEyWktzCfDllcFsTJEc66?=
 =?us-ascii?Q?lYKPDacgDSRtUromPtpjYLFMcb4Gd9EyBQQ6dY3BcF8Z40k13BDrZyz1Jo1Y?=
 =?us-ascii?Q?vZmn5P4Q36eIxgcS5bQIv3gROx9f7mQ9Q4YSC3p1l5ORhb6pCmQMYfRbytUv?=
 =?us-ascii?Q?LSaqy+ltg9+5rvsr0/bceO/qeCe9HNT/j+gb+bVEwJPwAvUKm2uBiyixhXtq?=
 =?us-ascii?Q?UH29zQZ1aGiEvRX8WpWKDF5bzMbY1Y8fIoBrGx/eMutqnYFF3/HFaQuPlsbt?=
 =?us-ascii?Q?ogsOjDCiDf0Fa3G5Hf1Y5tLKJmOG25QmWi0GpjtMo9ivfNleSuIwk3fmSysk?=
 =?us-ascii?Q?EqBrY0bAojd8z7ju3ythqxbjBOAzcJi7uIsV4ldBgE+kSV8xxl7ksQeBU7VS?=
 =?us-ascii?Q?T7Pn/3CK0AAm2bgYztKK38udlckduHIkReIS/iyR5dMHMgNNPBYid7nyH3ZQ?=
 =?us-ascii?Q?9wrmtliI+YZMYEf1HrTxnD4q7Xo1f9/zq1GsVvaYJwGIsIoFk0CXOTe0IVVO?=
 =?us-ascii?Q?iast/pilZSEiSegLXuEvC6TZNDXxJfFtlsptV3tlDUNZg4sWmwCz1MQaRXHt?=
 =?us-ascii?Q?Yw9lxHY5lbT16h5fQkzzJCsiVLrXtsR0wEPRkSoBM4NdeLjkZKcne4w9krl7?=
 =?us-ascii?Q?MSBdi70OckxTj7yLi6d6LEepoKQAVMVogedl9fEta78uvqqUaH9iSbFXPqre?=
 =?us-ascii?Q?6OA3ZAD1Q8/US3ccYEVgucCT4E0KjpNRsR7f2rTExhakzrdC0eTcDy95cOO+?=
 =?us-ascii?Q?yHtsBa4JSjoxWcXX07pgQfvE09L5c/9PZavptDqwV3r1ACg7xpgaVRJjE8bT?=
 =?us-ascii?Q?/st/ZWFyiVLok6exSqZ8FFpfkXr+NRnHhnw0HpFkgNp08zjiHEUKp9MC00IA?=
 =?us-ascii?Q?LRbk+syhB7qqXHl3Blb7OtQKjstDUoBTO7G7+rhOlhvC+BSdsiJTO06f3kiu?=
 =?us-ascii?Q?cjhTycXC9loZhZXrNEnDAtY4OskYRAgd+4N1ouFcx0crnEqCl5NudAeYL5xz?=
 =?us-ascii?Q?+QOQMn9kpJM5tmNrpRzS7OJR3cA2zN28xZk6TAdZ3lA1HhuSutNlhpxDxUbf?=
 =?us-ascii?Q?PRVciEUUQUo1NQHelGdc/88ranuRdXSsT/abisYSFAtZ5mBDcl+iwBoY/UKV?=
 =?us-ascii?Q?APjc8XQ8dTMqFmXHOZU1b7RcHTrWIw/h2lMSCibPsLLh5uKwP6DKrIHM+9wC?=
 =?us-ascii?Q?9nNEf3bwxG8n9amhr3yLKxdgr8ZioNDxge8co9UZAPcZVTi8gt+2vX39qauy?=
 =?us-ascii?Q?iKkH1QNWNLpbTlg6Fy1qTh/OYdS0zG1GQ2WAR4T2Mlwh5Q01qp1qR9janNO0?=
 =?us-ascii?Q?e3gZrcSBmbGohxfbTSZXGerk6Va/Gl5IO1zdHpBvlRxe5YzDADDjocjEsmvW?=
 =?us-ascii?Q?6mmPK/pbp2tXNn2E7GAOqhyeXkMtmqXpSTE3wJALvc3jACqKxPkrIyHpueV9?=
 =?us-ascii?Q?o8Monrj4VA2GnvXpATmyaYP3O4vKWt1RnX3G6MVPkXNKS4bfjGWJZevW7SDJ?=
 =?us-ascii?Q?kzPSG5oojqFaVWAeTl84xDdp3ZhzNgMjU241qs8s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88219735-ac30-4982-e0c2-08dcfdb06429
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 15:42:01.7928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdLN9/AH0W7CR6/Pcm4stIxSnY/9TUTiJ5k/nKGctDE1q7S8hpbv9EfvUKbFvytk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

On Mon, Nov 04, 2024 at 05:20:27AM -0800, Yi Liu wrote:
> driver should implement both set_dev_pasid and remove_dev_pasid op, otherwise
> it is a problem how to detach pasid. In reality, it is impossible that an
> iommu driver implements set_dev_pasid() but no remove_dev_pasid() op. However,
> it is better to check it.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

I was wondering if we really needed this, but it does make the patches
a bit easier to understand

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason


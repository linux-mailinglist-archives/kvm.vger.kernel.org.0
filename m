Return-Path: <kvm+bounces-58430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 810EDB938CD
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 01:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33E097AEC1D
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 23:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1FB5259CA5;
	Mon, 22 Sep 2025 23:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BDgmwrKZ"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013024.outbound.protection.outlook.com [40.93.201.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6970E1459FA;
	Mon, 22 Sep 2025 23:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758582951; cv=fail; b=ZleDN94dPWfXRQqUqq3fdlGqyRRdT2KRdKtNi0+gV1epG73EtS0GG4fvd7dWMwTwWAb7eueuSV1/QjdwN7t0aFEb8x39ykQXT/q3esDVJLtLyQAFwcFVunINJVOzouOpsDwvBe0Ei9GcDtUAmCVo3qOl+yn/4uZW67qHyXO1rvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758582951; c=relaxed/simple;
	bh=dNBSaRN3FMjsfLre0zyL84NTEIligSFCeLwRprSKBnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Wf57CcFECrfyw2CTBA3VzvlicEznLkYuYfGm7ckt6asaBjnxEcYiiRXfCHBUUmxwdGh/Lmt+oEPSz2+e/MxSVcCqmaOnQ71KaYwh3qdDXpMm6DlXMi7gUUg8ZsznWK/0yTrKmsQlYwxVYh3lqFbBmdCcG2fMFnidLL2DIaZt060=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BDgmwrKZ; arc=fail smtp.client-ip=40.93.201.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OPto9YCqSjBfjHWGT7ZVqUMVZR2AlTMsiqfbcO4+FoygPYNTd+Q8Kwqb4vWq4GkpJYEPHd3/h2MPYP8s9TFPHalya1KeT+H8AzQhvluQx15oxBwXiC895h6maNkcuXLY0cCCciT6Ghcjm8ESI+zOxRCpaqJcC3mzvh9BsjAZFxj5beyQ5NnXVk9LPEnwzDNVn2gTJzJIwe5MEx7OUm2IFSNOYIANuzmEH+ewRtFvwLBFQlBR1GsyB1avqq/XA5XTmfEKcO8WgsrUWv/t+o0S3xnmc/Yu+ujyzvqqcOLSm/3t9fqpklF0d7mkyhTPGLJelcK/K1kLVGeRipQAiIFQrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebiWfaBEGiomFRsEfxMwtGity2rzZRxfpyMkgbxIfPE=;
 b=QooGyhSMr7lBsKpgTL2L8crZ/LxRonY3e3jrfpCBQwk0gTB+dQLKWDUYXUNEkPICyJA65EMZj6TjYnYKT0+kEdIdaTh9p5BzcfkV8D34E7/plQaONr0l/OE/kvP9zA0xxBR76jFVTgv9WAEZyqrt9Tv4BM3oHYwn/W6rK8WzJiBPRtQkACTMpoHuIYcRebICQgnNv6Wi8uGRw4sIj0b4PibBYGJp15BOKsBROgfcO6Kntl/3iGrNU0JABqSw/5mI6DFsqiP9AnR+tc6+MFq7zdRnP20TgXlHbRfSX71OGGeZ+i97ocxVG4aW6xlIRm06TgFwCzBS6aZx21GiAMs5CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebiWfaBEGiomFRsEfxMwtGity2rzZRxfpyMkgbxIfPE=;
 b=BDgmwrKZFnBsdXzLUGerCkesBelqBxWb/LinD6xGBcvCk8DfcZ+eTdFbDFMEkGj8jfRDA97cx5w76bLcG87+EAFndwdfCjkoodBDaKQeIy4WGJvmR8AN2YEUj9sZ4UiSuY2CEyovAyijlcAjQ5wx9HR1QgMo9jS2WmIMbS1u6FIO+l+Op5KLB5WkMmBUTaUtS8JNY5pw3NCLsrSbm4f5+5rrQ7enrUn21bc1gIFLecWenyo4AkRffKtrnHo0PL73FqTCG42GveyA87WidGrtx6eOxYzJFt6OSIgKBh3kp2IbzBUxSUufBccgHPSEY0wzZJIPZOWQmlAhuNqsBKzOiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM4PR12MB5938.namprd12.prod.outlook.com (2603:10b6:8:69::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.19; Mon, 22 Sep 2025 23:15:45 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 23:15:43 +0000
Date: Mon, 22 Sep 2025 20:15:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Donald Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250922231541.GF1391379@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132905.67d29191.alex.williamson@redhat.com>
 <20250702010407.GB1051729@nvidia.com>
 <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
 <20250717202744.GA2250220@nvidia.com>
 <2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
 <20250718133259.GD2250220@nvidia.com>
 <20250922163200.14025a41.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922163200.14025a41.alex.williamson@redhat.com>
X-ClientProxiedBy: SN6PR08CA0017.namprd08.prod.outlook.com
 (2603:10b6:805:66::30) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM4PR12MB5938:EE_
X-MS-Office365-Filtering-Correlation-Id: 23d80818-ed89-47c2-11f5-08ddfa2df40c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8I0RvZR0cHcx8xZII1QWSvNFvfoISqvPU5Ti+iecKTrPLUIAUbwa8bciHWUv?=
 =?us-ascii?Q?AOkSabQAqFvzfrXR2nfDPhAiNeJ4OClrfaE+RwfCA7joEkWFMiZQ4I5dArH3?=
 =?us-ascii?Q?8pKv2+HUubu6AKBDZg5uSLo7jEqUCY+NiFOqx6ANIVX4cw3N3Bq39zvgILPV?=
 =?us-ascii?Q?2EQyuIAOBCfbfv3SaaTC/TKujycubQIoxTSCNbKa9A9kr9jtTfgd4/2ntMHE?=
 =?us-ascii?Q?TsFdb2QDCf5tZL+qhDHM0g++8grExmd6WUxOUqGZszTG7MxiztKjVVg1EoeO?=
 =?us-ascii?Q?IfBCM4W9BiP7FwMe+6VyLfe8Vn8qe5CAuxhEAs0LlSSWxRHxjAWUsw64aB5H?=
 =?us-ascii?Q?V2LlGdAQGLzc/tA/nvkL+USIEG4xFYBJHu1jDy6AZbHCjSn22tO60ed/T9/a?=
 =?us-ascii?Q?XutfJ1Y6aqxtotK+dEvKxoY3ouKUgZKQ1oxFbW203EMJxnVKCVljG6XisRG1?=
 =?us-ascii?Q?ilgq5FsCXdvOJ8XJNFUy/xpsfe07QHSCZlfeEBs3se1NbjMjfMuJLNBVWgAI?=
 =?us-ascii?Q?MFP7/WAVhqkxPDW7ZGIWk4/OWZIquaCjKPWxVdAr5+SXz0B0S4BHol5UzC06?=
 =?us-ascii?Q?n8PwEYgxrX/xv91D19edfnZtzTFyqYcbtlmOxJIfe+hQx4X2fpizqBgZGf/B?=
 =?us-ascii?Q?M3npdzn8x4hubqrH3BCx7Sm3YMcYpZPlXhJg89O5gLHfxIipYYuyPc2vrhXB?=
 =?us-ascii?Q?ElW53RZKsAQhEKTZ9efEUWoepulzCIbONl0Og2cbMlSXxdE1MD8OEzrDYIgL?=
 =?us-ascii?Q?mSXlIMCTMKk+SwETxa30UYPV8C0SjvZ6IlZJ7DDtgW8DKuslFEZAxgmzyial?=
 =?us-ascii?Q?6wiJ09oZk7NnURBSznu/sH1UlkrU9/+KxgO4y8YM9fXER1QxnYe6JtjBYupj?=
 =?us-ascii?Q?ELyxL/fcFOlpVY8XY7jpmrw2LC+yjK+X+tgPvhE5w6IHVkyMRrn7FycoJFpa?=
 =?us-ascii?Q?2YmNgckpvWhPtlqDUNhxdJfO4qg3QbC2P/V04iCtgARPup3C7amB2QdvpuZP?=
 =?us-ascii?Q?SIp77fvf5dnTDCSBO5wccV3rxUmo1Y3MfZ/th7r5pDuOdWtf12LjsbMb58rL?=
 =?us-ascii?Q?Q+c46biUl6PhUrak5RKUuQkrZVn3Btmv2tDfa2GqfPwrD4oT4ZG1cwnhTmca?=
 =?us-ascii?Q?eprq7MYM6xx6px5czdgpcTMeB7sMjFWDcI05vFCl8yxRoETIBoIdZSTQrSRv?=
 =?us-ascii?Q?Y0hj/FSinlO7OZA/+m9ScnqCl4NH78Ae+LPL7yvpMB6rGawPBT90mHZ8YXhm?=
 =?us-ascii?Q?M3MoW9197TW6Vq9x9FYvBK1IvNz6B4XnP+hG3qJOcdzf8K6UUfYKool8VoDj?=
 =?us-ascii?Q?lKvrVJXVG6d/157VCfLsU7trwbYAN5YDlsVSx/zUaH9pk4uVXMs5HN0d34dW?=
 =?us-ascii?Q?k7FtG6W9KeBav9p+kGrwxvqNTcJ3Z3ufsVSlzwZ1r2WKJynegGlpWTlO5Pnm?=
 =?us-ascii?Q?onSKmR1MH/U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AuqFQqa0WMz0/7fOIxuGh3n1WIoS96DME5Xb52BtK5CXt4MKER/rW+/Ts0WN?=
 =?us-ascii?Q?1XKY3m7gAASoD3hmkiKqNnPP6AWgWkpwoNcRwFtw6uCY/JffJcP+MIaEhsgd?=
 =?us-ascii?Q?Zhzz0OG8f8Egeyi91KmGtMtiCHaX7d8bCp/3AkPbov1vHd4OMtZkfv1Edl1E?=
 =?us-ascii?Q?arkEpVQxXaX1sNzrANWQWltH7Qt9gAm6mmfoDgR1o9E5jMjRFbQ+A43C6rQ/?=
 =?us-ascii?Q?Hi5UTwPHhxj+jhhfCxRon8UdnDQzYnWImCQPfo8UIePsLYQPAW+wCWPg1q4K?=
 =?us-ascii?Q?PKfrJ76HWH+0Kh63WjTe3wscDV6SAKlLFoKsxWJt62vlijeA10BKL6617nXZ?=
 =?us-ascii?Q?mJOfipXFciMDuQRWU7gmp4ILUAhm48ZFjRxIpIlsNJC+SQlpX6++yOmPimGA?=
 =?us-ascii?Q?n1i0n1D06/o7QxeTbC1V+hYGX9HGj9aMsJ/jypkM5eqSacwMkJilc54p3Yi4?=
 =?us-ascii?Q?euCGFFY/2vzL4lRwUdxjpx/9NOxZvQs0vIadS0+CZ1BEEHpRzpZmXDTWZSfc?=
 =?us-ascii?Q?KCbWJL2ukYV/x0u2KJa6INZi4Z6dJrZlvPtxXe04Vg1yLFWt5Xm9QE/lRB9w?=
 =?us-ascii?Q?2rG+xdOrlx/OpeFAZLIiEYF88b68IuZyc9QLC8UXncWvb+IYO6UhXs2Uiuu6?=
 =?us-ascii?Q?hEIyxlWqWrdxGgSGTJvulHpCuZ6gAAvkNkd/1yJhk+Llg9HU4SeYy8rC1UqM?=
 =?us-ascii?Q?u9nzxAF3hVflblDpow976GgMYxuM3+wmcv8mnTrSQMwlbTTnJAF2Cf8l/ZnS?=
 =?us-ascii?Q?45wYYu5el3oN6sOkwFofRbl7bwT7P3k7w21Ze3aS5lJMUIYXHo3Tr3O3a7yA?=
 =?us-ascii?Q?GrXDOUfInbx1b71Ye/7Q8Ji/FPNGnw2xwWYDk6tQZiSibCs2Z1Vcaa/UulEP?=
 =?us-ascii?Q?1qveP4eWpe+OFDrKf1bm/OI+gzxC4Kwa67vljG8NRY3Pf19y578FviLG4jte?=
 =?us-ascii?Q?UGStZq2egLnmfq0UdBNKP70XSz4MqTB8sS3+3IPsqWVLjBI/G7IEoVuUtY/C?=
 =?us-ascii?Q?KwhqVJmDe1Cl59HKPH7UBVaO1cSvnbqREs19yYGzZVVVrU6g85oqp11QL1+O?=
 =?us-ascii?Q?KNhXktKRVuSgaxJeHmWbCmB2qVx5+cb/C+uhtHI9EMXGZ+dI3JkE+OQch2Yx?=
 =?us-ascii?Q?1lWUxoa3cEwu8MX8nBtuHO3Jt5OpA/76KQqOpdekVaOIlwskNat75W6/5+ZA?=
 =?us-ascii?Q?NGTI+kDodiBSGFqwTC6IGSb7b06E4HjIRq4VYDlS3n7NQ0Z+AG/dFoHFz7fT?=
 =?us-ascii?Q?gPHZgUoPnKB3aZq1UzTpt1H3J31UtUQTpHeSjdnAmLHoqBStPBg1MzDSx59M?=
 =?us-ascii?Q?VEbo1Uo4ft7uFvzEIp9aSxiMJBAjlvmzrC1O4f9sM890uVztgRCn81sGrbH5?=
 =?us-ascii?Q?virVOwMk2KpyuR/yrZOJ93rvqzr+uMRax4m2ZXAaY51l4U5XqcrgqA8VHVpf?=
 =?us-ascii?Q?nJYkeMv2Wazemxm7i0b01tkUOGOiT3vTSTFmNNFdKRisDPpwSnBvRDvA/Xl9?=
 =?us-ascii?Q?4V9jXJjQx8M0ztMUd0Zw+3b4EIaPz5B+QggXVHKzJKgfoONhpXO606yE0QA0?=
 =?us-ascii?Q?jL4/B8jNudx9bmOui5IX7J9yYf3J2gH0gmV2jZKx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d80818-ed89-47c2-11f5-08ddfa2df40c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 23:15:43.3254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KH9hsMNIdKnoMQQFIm2yypWAQ1ivH1qNjddEGYKxNnpPJd/oCG7S93xJ9QNkyf2u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5938

On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:
> The ACS capability was only introduced in PCIe 2.0 and vendors have
> only become more diligent about implementing it as it's become
> important for device isolation and assignment.  

IDK about this, I have very new systems and they still not have ACS
flags according to this interpretation.

> IMO, we can't assume anything at all about a multifunction device
> that does not implement ACS.

Yeah this is all true. 

But we are already assuming. Today we assume MFDs without caps must
have internal loopback in some cases, and then in other cases we
assume they don't.

I've sent and people have tested various different rules - please tell
me what you can live with.

Assuming the MFD does not have internal loopback, while not entirely
satisfactory, is the one that gives the least practical breakage.

I think it most accurately reflects the majority of real hardware out
there.

We can quirk to fix the remainder.

This is the best plan I've got..

Jason


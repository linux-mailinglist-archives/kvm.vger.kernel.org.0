Return-Path: <kvm+bounces-61018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BAACC0623A
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 14:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4BB13AAC5A
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 11:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2976D2DC79B;
	Fri, 24 Oct 2025 11:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KHmmV2Wo"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013050.outbound.protection.outlook.com [40.107.201.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBF32D8384;
	Fri, 24 Oct 2025 11:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761306730; cv=fail; b=IVG/NS6BCR9jENoGlYF8ULSgDZSrJv93CqyfmyC9lwM8Bd6tIOuBHQeo+4463ampmQeu/Phej2u9pdLvtIjIQ8gr9jUJPrc14bWt36umRiM88Qfw1+9YlwnRpeTJE1H5mRSH4R0XxhlAIixEL6tyl8N7jtdYOKnJORbVwRNzCUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761306730; c=relaxed/simple;
	bh=ClmDcotZW06VAkriTkFeAbZNnZ9tsVsJVdhXfpHg4+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TGiUlThaOYDtu1Jh8WhvRYmbcGe2STYyVLb5BQESji5Sgs1MygWlpVKfzBrM55P9X95jQVZMmyP3/MDtMVSnalrv1xW/UfxwaGdNssrtVVGUkbEVEZwz6WlG8uKTW79TSEAPfu5hstzzzjIh/ZbxHTclDr4/5DIXKat8ASVy3iw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KHmmV2Wo; arc=fail smtp.client-ip=40.107.201.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJTx6AUMBNivtj9z3zfAF8SAjfdiFgeVV88mNeUzIF+cl2zi1eft7P9Yi6vjvCGJ0ctYXdZcwZAS6pEGkaTHuUHKb6ywUsiLtyJG7NGsHEX/qLu/nH6Vb6w1g/Cz5Qu4EX0FK7xuB4QCxk5GAd7S9fQrwC8yxw5DxfPBDBsBCSA+jEv2L8omQSRGfiQSWOr2A1vMKUvxU3/uEpB6PowkgYWRClUVi9QAHH0CWxBaS8JAWkeqG2k6q2WPfAUkNNgmszL6ExAWKUYIX2ZPQWh0zMrPbSNKZ3978l2FbHJUmof3BENjGe/RPMqhb4Mfqz6NjQafianTYUT7SHWVvnQRLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HJcx21eI0mb3GiqvuJwZJysHYApibNVwlxccmh3ClI=;
 b=sZZRSFNv2V+7+sbi9vSo0oKBdVumHJ4YCzDTkVcOTZ+3QAKrUGVL7T9GBZ4+9dZsRJHHUyKHMOAFTr7s5j/D3QTTD8u0xGqt6jBSuUMQhUBA+oSYfGfLlyJ7SccM6YSaixPGMhuwDV5Kw6wC/+335RACURqfUL8vGVfyAA+L5MdP2QbGKSSHdNiKoEsFNn9TUDURpyZCyaTHJhqK0lv1hjaQJsunXzQ5cydDTP9DiyfomOGYwLQIX19NO8hP0sAyRGHN2g9u+CUBKBMnJ30AaSzHB9LFCHVuK1gBXlF9gGczFS5FjwT+eepYrYuVcCM3JdnA7jcNOz30ALASd5wcnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HJcx21eI0mb3GiqvuJwZJysHYApibNVwlxccmh3ClI=;
 b=KHmmV2Wogw/HhZRi1/c0jHZzXcPK/RSG9DnWe1Xqt3+iTLeh/nFiBoPITOQct8yES4YRqhbE3+fwxYzwUJZ9FPnYBAofPbGa4pqjB/WU9GdcheCik53ZTC+WDelRdKH5S8jalzQVqYoVD52siAKt88/sk5khm+DDgracsIfQanXTzRYfoYiJf1T5s69fGPax9nTKyY3WG1YtaP9B25eD3L+M3nMq+JzW4DaBJzjDr6n3Nf+Qz9z18NmNKqgAddmLvmWGRrclHwBQSBSU2mdsiFbXox7xM2v2RhAy6rPrfhzxT+JCbhIkIUBOZ+K0+OLHDKmzOo9X9SmW7UjmOFaJcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SA1PR12MB8858.namprd12.prod.outlook.com (2603:10b6:806:385::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 11:52:04 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 11:52:04 +0000
Date: Fri, 24 Oct 2025 08:52:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: ankita@nvidia.com, aniketa@nvidia.com, vsethi@nvidia.com,
	mochs@nvidia.com, skolothumtho@nvidia.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, tony.luck@intel.com,
	bp@alien8.de, rafael@kernel.org, guohanjun@huawei.com,
	mchehab@kernel.org, lenb@kernel.org, kevin.tian@intel.com,
	alex@shazbot.org, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiw@nvidia.com, dnigam@nvidia.com,
	kjaju@nvidia.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-edac@vger.kernel.org, Jonathan.Cameron@huawei.com,
	ira.weiny@intel.com, Smita.KoralahalliChannabasappa@amd.com,
	u.kleine-koenig@baylibre.com, peterz@infradead.org,
	linux-acpi@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm: handle poisoning of pfn without struct pages
Message-ID: <20251024115201.GD847003@nvidia.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-2-ankita@nvidia.com>
 <d2550489-834c-4dcd-b41f-d22590880343@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2550489-834c-4dcd-b41f-d22590880343@linux.alibaba.com>
X-ClientProxiedBy: SA1P222CA0119.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::18) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SA1PR12MB8858:EE_
X-MS-Office365-Filtering-Correlation-Id: bffebe9d-b4d5-4ad5-4686-08de12f3bfcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4AuIL9XKc7JTn6YUra082sH1hW48psb9KTQ4ahlzNNV+GHSX+otG/ZqZbHly?=
 =?us-ascii?Q?0UDXQqm/Xp4HRiuNgV2SNfM/GpJLPK0n7MHkW/L/d6HX5NovoGOEmL2tPFYw?=
 =?us-ascii?Q?zzgUoq1JvZ/GjepVOX+KrEoE6eW3i7pB9mh2EA11ObDAO3gJuzAvu+4hn0zR?=
 =?us-ascii?Q?G7+Szv/SbWxW7bTPJM7y2U/VSYIIjdQyEml8mOBff6t6lOYdZwiLEAGgXyzK?=
 =?us-ascii?Q?LglYvR+NDMb0UnAhMGm2hZtZeLMZJ5K7LfEYc5yRXhCefLduq/B2cgfqPN4I?=
 =?us-ascii?Q?idccQ+6zeObH+Px3JRm1wNaaW3W+J9dDPrAtI1nUkP/DVjZZhR4nBkdvJsSg?=
 =?us-ascii?Q?NLc8YHfhFVfQWtYpf0NHxSvZIT8iz+CMEcmbOxnIM8guGU9g4fxCDgzitXlz?=
 =?us-ascii?Q?WTFW0qd8iSq6W5LHA0G4QO6FxpWcjzWe48oF7CtaRVaNJXhp5Ge7nzCCIhzG?=
 =?us-ascii?Q?PEHfnZs2UYcBLyoNW1AQvFP+Mcnfvd8a/XKkNNR9VvJ1z9pkB6t5z06334WZ?=
 =?us-ascii?Q?TSJKRTespLDlQrzBchNAufEON889GVrxb9epq8LOiZOdn/v6l7jZ/Hg2jsoQ?=
 =?us-ascii?Q?IhRZHxGc6ZTMAch8y7RlZvz99f9Z884TjDGPUUoqtyl+7G620XR4mxfhJ339?=
 =?us-ascii?Q?/1weQp0BRNtVPVvXDrxdXYnp1UgpRoj7on8kdANPPZ0QsxqRPWbFZ0MzEEw1?=
 =?us-ascii?Q?1Jp9c279AJTXPZX21QkWDx1yNsmh3m9v+wtZQ3pdtiR5wWy+2MuFnSfMZ3lM?=
 =?us-ascii?Q?SbGq+YXkdfp4xS5IDOskJGshiKSQJH9ErgU5tF7i6sZF9032zPHXrBNeWEyJ?=
 =?us-ascii?Q?XI9+OYZxBuB8XBA4/sKIcry+xM60/HPSYpGJq9eaeGXss2RnWIRj16UJL5YA?=
 =?us-ascii?Q?Y3OJM2L4n+5JtEMPJr/il/3eCw1KjajxaAQ3B2GKOWYWHGbc86rWtxJr/Gmr?=
 =?us-ascii?Q?1wm8HdjVc/OoWPUbPX4BIzGdRspzJdtGUAFnTXKgA+r1RUMTG+tGu32KF9Vh?=
 =?us-ascii?Q?xT2Ikxf49704GRBOAlRiPlXH/abBeRvLFwin9jVm1gmxUGDJo05k2vgwbAWn?=
 =?us-ascii?Q?XfVGqEt6ItF0R0TDTbMRZSSb6Isz4HsRoRV838PIAWplChctKgr0ng8MQLEQ?=
 =?us-ascii?Q?zKMFFqXuwT82mRtFmzsJNZ8B2low0vK2HMauyZ11d0BbOe6GII5R3crRhTDR?=
 =?us-ascii?Q?DVShkCTf3x6DWe//mAoIzRfgGGcQh4OfMTkTNIIxsy7z9GZ1N1ujWTLPfsue?=
 =?us-ascii?Q?L71jdA07wyQAupBgHMNxf448xmWqZAV3Hxczb9NNSyjB+SA+f+kMCpx3QVZ9?=
 =?us-ascii?Q?rmnp0Uo3Ig6b8PKiyP3wrSWknN2KB+gLwe3nZGSdrcBR1CHCLBQszkIvgiru?=
 =?us-ascii?Q?47ozoiNl8Pdp3d33B95xTFpOhxTIL+0kaFtWD/JOpoI1qgvlOkKvnd5F94ii?=
 =?us-ascii?Q?DV53tyXbdaG8sad0kQJrp8l+OAtiALRN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PWaFHkmRRKjQnHZNE/NxJPIPEa/ygEhePGdspVIO3cRHgyVapxw4Rpc1PExA?=
 =?us-ascii?Q?nV95xSY7K6Wa2LVe3fqwOfvzl4r7HEsNQpMKHyOenvK1Y9PGVRnTVXO9slma?=
 =?us-ascii?Q?Pf2PpX48UoxUWwAe/UGg/+WWllSvtDUJFA7wx2CyqDXWazZC6IVmGwwaGu5w?=
 =?us-ascii?Q?PO9KH7Qm8i7AGSNaSgmD9q/BuaIoGYMFxMfUjjofCTd6lQgLSrXRpBl07O29?=
 =?us-ascii?Q?nndwqI+EM3p1UvhzJxsqdIUM1gy7CGnqhOgxaznkrOB/mYpb9gXue+WHdA5z?=
 =?us-ascii?Q?SJlTWBP//vNAOjghKIZtlH4RMX7THQkUZ8LQucWIIhDC1HI/Kw5QEuzObsWw?=
 =?us-ascii?Q?2qAIHcArRhKO2yYuy7kYXsDYSjsOvZ5ue0OqbZQ8G4sgr8Q+aup0yjGbS9H6?=
 =?us-ascii?Q?jLXijnlFwIRRbjbwwclO91LfQi03ykUtosQ3XvfVNbuRabE5u0Gbs6FHQGbc?=
 =?us-ascii?Q?w6hNW82YgLCfLqYM9teDL8iiAYiaNaxlcvXBi9O4ra7lle5JNtwaJbWbxwlk?=
 =?us-ascii?Q?lOXHMco5dVlDOXJAX8qu/1JZFlyOrf6Km/5B0ib4DM2qZOCXE39j1GT1xvJD?=
 =?us-ascii?Q?Dgt1c4qkOD4FP8Qv+nY0ytqsuAygAx+VlGQ0x3YYXbpjTfzkttHFgKVN9e3d?=
 =?us-ascii?Q?VPy2H0e60lffZvvqYlkEHPnKaA2V0LLMz6w6t2orFL270xWL1ga/+kaUKT3u?=
 =?us-ascii?Q?MrNV0LXCPD/Un53dvBSciDkx/vx+aqhvv71BBOUJ6IVC7BzFvAt4AKPIdIZr?=
 =?us-ascii?Q?Xjrc5FdhmKw6U2GVDkYkMhQIcL/gkgvhGcLc/022268Y2e1ZUOCjE1cXbcn8?=
 =?us-ascii?Q?Fr6/JAQIYblXxzOnadCOJAeGt7FMv3yEdKRV6zfaQxa5qDTqmtmsPAdipKN4?=
 =?us-ascii?Q?BJC0OdIjOMYnf1bjn2xj76uhsBZJtVv1E2YMFdae8wBnKAzI+Uq+g4Glm9fn?=
 =?us-ascii?Q?h5DMdr/13yLjzIn575JYDPPMz0IhGZVZXW7vRVRPX+eulinC8Ss9l2Sn8MFX?=
 =?us-ascii?Q?Owyz/X/05Pj/Vf1eH4GzldRxaQ00v+RqpBdY6daudgaMdrsEA664qOKeS1PG?=
 =?us-ascii?Q?KEVKxGsQuA/yxgLWVclcmsuBTa1TnTsd+epV8wBj2Egb4ZfmR2b/Rbccj82B?=
 =?us-ascii?Q?JUgVO1RAsUw/iwMdeJl05pXWtbdH1IyNqvgBsn4nI84dFvYczumDAEccNKLh?=
 =?us-ascii?Q?eOpqC0x0Nzb4R9Rihwiosc+cK+CtfnNVi6PppNYgoRd9BZX4mGRwznHAvMet?=
 =?us-ascii?Q?u4iQSaKveP8VrUmXTm9fRIa1R16Y7nRS9IiaMgKAQBsEAEOXnULsLGWTJMzi?=
 =?us-ascii?Q?M6Lx0CXBk5O/bYI+Qx1GMmz/r1vX+hRehzga6Ae4HdfTrpyknfApIPjVtk1R?=
 =?us-ascii?Q?YiyR4iW1UQq5emivdu2olyq0ZkKRlEUSOGw2u2QaqDNovtWIOGOsgryFSFm+?=
 =?us-ascii?Q?vaIhXvUP52yCrmytQFSzVT5xsBfLXpXCjnODF7rQAVopbBkR1nKrzvdkmWI3?=
 =?us-ascii?Q?V+xDm2qNAfPpqId2OEbuDl91ImtBG4DV0eSZq9QurASVA1n1g1ZCNvlOoTK5?=
 =?us-ascii?Q?vItUFQLcwHZ8JRAJ0hCdmPv6NXkB2CkHl9mzw3YW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bffebe9d-b4d5-4ad5-4686-08de12f3bfcd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 11:52:04.0183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o7GsEMmAP5JWohndPcyuy+qTltojvken1uAmtkzeIxV8zmA1CsZmR22wfU3YKKaV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8858

On Fri, Oct 24, 2025 at 05:45:45PM +0800, Shuai Xue wrote:
> Rather than having MM maintain metadata about these PFNs, have you
> considered adding an operation callback similar to
> dev_pagemap_ops->memory_failure? 

I think someone could come with such a proposal on top of this, it
would not be hard to add some ops to pfn_address_space and have the
code call them instead of using the address_space.

This version just needs to link into the existing VMA machinery (ie
collect_procs_pfn), it doesn't make alot of sense to push that work
into drivers.

Jason


Return-Path: <kvm+bounces-60693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E73BABF7C26
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:45:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4C5FB4E8369
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1572369963;
	Tue, 21 Oct 2025 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G3OywV6G"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010019.outbound.protection.outlook.com [52.101.61.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5537F3570B0;
	Tue, 21 Oct 2025 16:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761065091; cv=fail; b=S9HvXGChqDZbwqyMm2xR7A+BV3s/u3bhPwYr09UN+0ciQYLB7JJ0uzr6XlgM3xDAUxigAyG3Pi0G6DbWyI/u+BMg/YCy4rRgf6m2DzhFtAZE14YfKsNk7c6Nuwrw4HH3SzAWNzmlASCu1QeaZGkMr4Ag1d0ejC4mr4oeILPO+xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761065091; c=relaxed/simple;
	bh=364s/98b2mkjYEar478BceVmN4c+6SZBanARZ9nPtvQ=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dFjpp8YQ1ESKOHkazbnB6dqUZ+1cY047JoCabGbLKo6l57BoZO4kKiUEIujP/SyxmsFlaVAsM4q3qltmYRz3RIzqTMOapbDBaBvMyGNXthT952MOfogBzvaWv81o9MVQNvTBBZEYi2uC4fOYvBuG1lP3ZjQDrre5Ci5f/pqJaVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G3OywV6G; arc=fail smtp.client-ip=52.101.61.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y3D5Od73+fUWcD39vK5Eipq4s6Dn3foI1PlXpp0OY5JVBXZerrkqzI+Qs+uRK/stYFYpVl+QZnMkOBb388B2lXYHYWBpziOeONS7uC1egOkrZAzAOaLe51zDZf3XhmjMt2YnmwYuzqgKbY8dUGkxGIuZPuT9te3//eKGhP5TKlVoeWfFmWVFY/M6HY+lry+gMx9im1BGl8cCzZh4/n/NLeiu2x/cascqlBN7W5Kf/X0AcJGI23wb4vbgqqUAIsapso3wpvpW+92I7izsuOYkiP6x8uFlecsFeo7iqJMItti60Mjs/Ms0SuYqSeJUG04kAZM3md62ET1fOf2FhJda3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmclFeSsQOy5huWmB7q+RdCdpXfVwwdw2drxxCT0Q6I=;
 b=ieX3JI02plriIKdTxamWBep7/Ch+MKamHxj2jvISlH6supKLfgWZouQdunfjkOWVSH7MC1rD5tzOhK7szHNt7eAxX5UDHND84uwDfnSIM1PEkNEkrRH5VGthGvUUITTQZxyHenrpZr1XTdNGKz90rRjgv9dGwneGG/Q3jpP9qbFTpq36l9aINsRzy7dHHMV377ScD/mD0iOcIVfe5HU9B07Zx36WOU8NnRPww9l+5o5aVjjcERTPhdEmN2m6D90mTnk61+L/NI/wLnVzSjHXXTsOurJZZ8tMixSDpy6MjI2grmRE1ftOA0hJmem9ZZ6+POvN+dWHgkHjlt4QuECupw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmclFeSsQOy5huWmB7q+RdCdpXfVwwdw2drxxCT0Q6I=;
 b=G3OywV6GSE0y4/oenDxdyNbtsWyprFmvqhfTVxI9cwzuSRiRzc39Tmdnx9Fy4PJxYEfY62PPLrSIE1vNgvm0ozr/ThquA+V8OJ9oFltev2jBGrFxOWpeRx1Vv+BYTnNXQmlHz8R/4bAM1xdgLZUDvxg4/YwT2wE5o5MW5lipPRMKyRZ0SyA7ES3HD6FYy4+5TiTIc/xWhP+F0X43hcZk2y1wPtOhYBphk76rpcHs0Y1DrfZEj+nxGRcSShpX4NYAbkERoo5VNnX1oOWIUOKRLpoqrMPVYBlRrO/ImJcjOlDgDS9FeeaJpYrMMjt5W+PZDNqyVs6/XCPy1v92OxHgyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN8PR12MB3604.namprd12.prod.outlook.com (2603:10b6:408:45::31)
 by LV3PR12MB9186.namprd12.prod.outlook.com (2603:10b6:408:197::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 16:44:47 +0000
Received: from BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f]) by BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f%5]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 16:44:46 +0000
Date: Tue, 21 Oct 2025 13:44:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, ankita@nvidia.com,
	aniketa@nvidia.com, vsethi@nvidia.com, mochs@nvidia.com,
	skolothumtho@nvidia.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	tony.luck@intel.com, bp@alien8.de, rafael@kernel.org,
	guohanjun@huawei.com, mchehab@kernel.org, lenb@kernel.org,
	kevin.tian@intel.com, alex@shazbot.org, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiw@nvidia.com,
	dnigam@nvidia.com, kjaju@nvidia.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-edac@vger.kernel.org,
	Jonathan.Cameron@huawei.com, ira.weiny@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	u.kleine-koenig@baylibre.com, peterz@infradead.org,
	linux-acpi@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mm: Implement ECC handling for pfn with no struct
 page
Message-ID: <20251021164444.GB699957@nvidia.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <hbk4hqrdaz7qipkpb5g2znhva63sghwsiqwlyf6pb6xccjtp47@vci5e4vbkjqo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hbk4hqrdaz7qipkpb5g2znhva63sghwsiqwlyf6pb6xccjtp47@vci5e4vbkjqo>
X-ClientProxiedBy: SA9PR13CA0162.namprd13.prod.outlook.com
 (2603:10b6:806:28::17) To BN8PR12MB3604.namprd12.prod.outlook.com
 (2603:10b6:408:45::31)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3604:EE_|LV3PR12MB9186:EE_
X-MS-Office365-Filtering-Correlation-Id: ec39f1cf-d737-4659-f96e-08de10c1247c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cB9wuZ/5OSJWpw7vlRvPmXMRLLhDPzAVxDFQiOAtJ9Bydw2ombw3nQAHnCNT?=
 =?us-ascii?Q?ZEHwGIYJ5Qb367lHLQCuMFVdBHck+qYR091fSQfO3DhGYIk6vIJD+4P5BVUN?=
 =?us-ascii?Q?DV/rYasFnMa0gOMhdvw2YsJWkAjSexGqi3aWMV7eipUfxB3tee23n+yjgZjE?=
 =?us-ascii?Q?7pmuux6mTjSkEmiHE07+aQCrq9h0aDQZdAOmXs/RXh1HfpXxhvyxl8wiw2OE?=
 =?us-ascii?Q?ySBDJj7LVTOY4kYhNVA7iI2VpvnVEsEQ+RIK3LdV0lYCh3hcraWHotjMYx6S?=
 =?us-ascii?Q?hSwHnSAOOANOBOTMZHF+VfEfPa0cxq1cn2eeLJfDyM3r6BDNqCBQSqcpfRzJ?=
 =?us-ascii?Q?YGt1Pu/OM7skExdy4dTVJV2IYgTKeLkqcw9qQYTwb7NbZP3OBzkMnjSxKjta?=
 =?us-ascii?Q?uv3tspkxM4cWTI9CbZiHRANDXOl8FTPMx25luQlKprWcxJK+o8NvuiOgOu59?=
 =?us-ascii?Q?61TVViMdnuWyS3tzp1K8kZR249o7V/Gem8Q2OIpQYQVq8CYiCKa/S54HPB5L?=
 =?us-ascii?Q?2LlNKOdlBwRRHqu6zJxn4RcfU/H6+Bt5W9lvwCoJcNBnXepcjiFkQiOSRnx4?=
 =?us-ascii?Q?2t4qv5A0E/VSc2uSnaMvoW4JSk/ur8f18WsLH4a4m8dkklfQf+HROsn5wpVS?=
 =?us-ascii?Q?Rer2mtEJmYMX3BXxHZDfXyUwPp5ELaWO4+ri0mdfEYVvQvB0jD2Bu6BAnP8K?=
 =?us-ascii?Q?DrfIiEqY+inT8fYPWp+9O1TTH+8w2zwaxD0uXpbwGGIiudI11CzEyXEJllUm?=
 =?us-ascii?Q?L+JeTNE/m5QrgSapKLwe/Bacjqinw4FvdEY727Xh4Faafxx03JLohbBehVQ/?=
 =?us-ascii?Q?G20PL+E+uYsdEcBukYFAga+pEhZ2kGpQJ28LAf3nXILq/df7XtBvfU7OPy73?=
 =?us-ascii?Q?VX84Nw79YAIhjw+Uc6EJoRGfBZWnidMqgE/9CTBX8i9qTRTye+pyzrBY2J+X?=
 =?us-ascii?Q?oUs1Ynq/Nwjvq1wiQyKDlCYX/rVKwE8vJYWagSk1FoiNwsSlhZtZDd7Drry0?=
 =?us-ascii?Q?0YCRQmW/z7RRHO8Iq3dFCx2JCQzYdJr5VaUzNt7fHUpidNzABGLWkdTNgrNf?=
 =?us-ascii?Q?VkLx+/I+DsJGtoJFC8jA7w2oOFjZCqo/5Boj4ktFcGdl6Gp9es/RxSqfkqnp?=
 =?us-ascii?Q?0BeN+wVt8Y5yrwBdx1rUEoUUzFYdZgAe2NIb4NIX3Lpai1kZiC1lKneB7FK0?=
 =?us-ascii?Q?oSXNdgNWQJuyH7Mge3MNLY3vocFGq3wWsjIb2QU5zLwbe++c8r0nLn59lJMy?=
 =?us-ascii?Q?4j5kCgfFR50Qlu77jDILtsc/qY8H71o5A0vfB2/9D72EJ7/XARmIWzHPHC7k?=
 =?us-ascii?Q?Lo7DL94sDED+KqCBV1Uzw4suCfYPnzRDgRkm5jufrxpo9N/2fqoRr4ukYWFw?=
 =?us-ascii?Q?vjGubwj7KFTeYikAlJUHnL8VLHFhcUQcyq7I4N+3SsY7Hce4XbmlsR8rKLED?=
 =?us-ascii?Q?6Yo6MRvCoxjwDL4KvnJrbmqR6pS9TSiZR64gFA+9o1/0bX1y12QwNJ8KL7hJ?=
 =?us-ascii?Q?jl47DgeOfwYzqlI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3604.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bg35q5ht5xmIkQ5LCgykjLrwvO7/lNW0ncsqvLtlixTLVODt2wUr83N78PhH?=
 =?us-ascii?Q?lnQ6RmEFrulglGRX+zuFcUnUPMf3Ll6X62daG1KsxR4Sl9VrE3mZe6wOdo0A?=
 =?us-ascii?Q?ZbYxvyeQ4sNOK4KHsm+EgVdkXpOBk9slrfm+7gQTKky39FGZLTsVV2aWso5R?=
 =?us-ascii?Q?Pyo3UjKgYuCRKIX0UG732hSunlCHyQ6G61Ei9EmhCVN8LCNIg+aPiFArMF1N?=
 =?us-ascii?Q?5iSithVBJ82cfbdIgQgztjD9cV0lvyLhZqbTDsjAqnbJM6AZpb4RbNYvysnX?=
 =?us-ascii?Q?AMn6YCR72JREyvdMZeaT3Qv1PDOJtlrVUw0fErPRPMd6OASK8N8I6b+Xpwx5?=
 =?us-ascii?Q?mni8vALq8I9nKMy+cYQFhktZ3OJZFPBI2JtbC7QKpiyyj8TtX+28XB81lbXQ?=
 =?us-ascii?Q?kQt6Q5dFeQRAWM4d+8fFYZmNG4SM+AzVjBwUDlXNmPZYrIywMbln3t0S9Mid?=
 =?us-ascii?Q?7XSoSjnuE0Xi0wI1XOUw8NS7CMDZ71umC7PMMcmnAANz3v9waRbjbawoOgz+?=
 =?us-ascii?Q?dwke91KRcf4OrkiyziEbny/sRfXyWyBgDEINPd1hMcEzKhIRs7R5UfP8p9/0?=
 =?us-ascii?Q?0ygsWeBtp+XWPTCKEAv9ryXAEZdTADij/mRCCM7EshMMLuY9kiaAkrpQKUEF?=
 =?us-ascii?Q?s1vCQ36jAtmjMWcijaf8pEjpzLqplguaov4L3Xs5lmSKntea6WGX1sYuf6pn?=
 =?us-ascii?Q?OcE/zdy4BzRKB6XTVgTPcM4DB6rKtcNllhQW2wQNJLWeBz5Yfx+rJCpc0qa7?=
 =?us-ascii?Q?yd626cznJB1iOUn4MGPcYIZJcUZpdGGuU3HKp94db2c4WKzBQ7zPgJxTju+6?=
 =?us-ascii?Q?RPAHXtxGZc/LRs2TEwzmowXv5pJwSxgP2mwbwWUfIMiIx7RU2XgfLePHIRXk?=
 =?us-ascii?Q?YBpoxvrD7pXD3Xp9po1A39xLliL6zTQ5/TdhgSCgyUz72JVuxIg9uicIDI4I?=
 =?us-ascii?Q?C1A7eVCO5lot4AMAMQgRxiSn+o/lH6mYWuGCR+myAv7AzTwp18Ub+lXMA3sI?=
 =?us-ascii?Q?a4PEfQMTnFWfKKkILSivoYSMUdso1RCK4x2nKlwQtoi4Fvp77z8Fkqz/1bPj?=
 =?us-ascii?Q?4NnywcVhf2csaUJK2x2O3rJtzfRm90rKeP05OIT4LdRWWwOU0yyuNu4p5uMV?=
 =?us-ascii?Q?48UrMrxemlsiZTizc93f3rzWixKYo8TFihERo8oIHcleaH9pDb27/YUSb+da?=
 =?us-ascii?Q?Q9j4zFCvOSSjAEAHmdXs89V0F6xsnUFHncwoqP0GV2RJvgeO31UIssZyG2e3?=
 =?us-ascii?Q?u7moPJwEFj5vcPOyagaXO7Jn92NZZGZtXiGJkvJI2wcOTAbJjGOfiKq52Un2?=
 =?us-ascii?Q?zVHLCq/lSzi7l7TyJtzpwbSbhcvNrhJp+C8dcqXNp5chqxBDIWo6TxA8b/AQ?=
 =?us-ascii?Q?WW2LBOyxU3tOBQEMHiBAhBkWO8ZWiw+bRIrvno81DK6vQN1HWVrv1FYk3WaP?=
 =?us-ascii?Q?D5AXtlnx6K8KCQ55grT1vrzySultB7O1lB49NscrdbGLOZ6EHxqAS5hfZ72z?=
 =?us-ascii?Q?FpWNhENG8lJ9bp2QRxIh2cvu/4nNWJCn/ByMLl2gDTacNLEBIZVh3wGQGx8A?=
 =?us-ascii?Q?kQOIfeGUWcxZ55/ZKP9IBpM8j+6tNs2UALFFMMCn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec39f1cf-d737-4659-f96e-08de10c1247c
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3604.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 16:44:46.5083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IOBvRI6DnFjZBK6F5IKzBoeGrEFnobBLU3/CRUbTCV2EKyi4NSVEl+0+CoBhvUoj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9186

On Tue, Oct 21, 2025 at 12:30:48PM -0400, Liam R. Howlett wrote:
> > enables VM_PFNMAP vmas to map at PMD level. Otherwise, a poison to a PFN
> > would need breaking the PMD mapping into PTEs to unmap only the poisoned
> > PFN. This can have a major performance impact.
> 
> Is the performance impact really a concern in the event of failed
> memory? 

Yes, something like the KVM S2 is very sensitive to page size for TLB
performace.

> Does this happen enough to warrant this special case?

If you have a 100k sized cluster it happens constantly :\

> Surely it's not failing hardware that may cause performance impacts, so
> is this triggered in some other way that I'm missing or a conversation
> pointer?

It is the splitting of a pgd/pmd level into PTEs that gets mirrored
into the S2 and then greatly increases the cost of table walks inside
a guest. The HW caches are sized for 1G S2 PTEs, not 4k.

Jason


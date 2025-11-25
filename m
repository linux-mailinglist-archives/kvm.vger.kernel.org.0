Return-Path: <kvm+bounces-64549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 925FEC86CF8
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:27:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 714944E1B96
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D89338900;
	Tue, 25 Nov 2025 19:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pvH/HIM0"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010045.outbound.protection.outlook.com [52.101.46.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1CE31A812;
	Tue, 25 Nov 2025 19:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098858; cv=fail; b=kL8IUSOZEFZnHu3RyCDGK0ixvKk32gyZaOaOOV4NgS65ks68e/crzSGWNitM1GER/HvPB1lV/4bo6R+hE2HJnNWur3yWaYJjXR2rqxyK8gkXS7oi/6e349sVUwfZO3hPkxDbEVbJtQQEMDRDEJjLhAdUb45P9ArunOHxULmZcMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098858; c=relaxed/simple;
	bh=UWszxDOJTPloGn4bF9aFAJtbvFnqEThBkbJKjsxcLTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CLDaKPGFEKDwFdkXHyTXRZw7yFxly3O/1HIQpBRhSWSYCLqXVPkTPubdIMbmHPWnat4VPHhcdi5jtLf0mA/qxI8k58urNh+fE3etFC6T6RO7RZ/IbeBctHQhzYZvfttej4b4HuZ6M6Ym2yoYiTO5hFrp2n0xzTyz1sk2Fj4f6ZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pvH/HIM0; arc=fail smtp.client-ip=52.101.46.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+6KgyvgOPf/dQf+AD/msoYbzYlCW1sAC+L4hLZjIa7AVceaMwW9uora8qMH+A+qHsIaopCQDavNFOOjoMqogXOypdBixvyxIUaAMfn3sPse2VKFiAb/Fuxf7y+HnRryO/69d1nejKhabioNpQGTvKmT96IBI3F9KJoog6B6ZIldX998zNHL4UO8dtE4/9lRlNctWASDS0gu5PdwJxNCFRn+biW7VXJSVvNVFxtNbsaUkZ9daJKg7Bj3tXWrWpGyBx4vp1bjNUIn9XjCUshHs8k23odhiwlSwr9JtpFJcmsT3NienG0867aWnebK0/tula2oU+MmbgaZUyJzQTjJgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilD8pVjfR05McCqfIOwbiQrxmhfJ3npLBQFRSxel7Tc=;
 b=s/diK6mbmyWx/9/OMx+r8cILknYt0xPlQKGg9PEPpUkAXFpaURJ5ItPEUvMwwaDoFSw3fIDAc232Mq07KGzA/qYPW0eGUn9SK2TwalNeFU4L8VT6cTA63DSnx93GJJqFRHlR0hdQstt8ZnxDXSpw5LoczM1pOKWd7iMftWsaxhI3F9MorkpE+sWimNygeHAXxA0MWBomlHymTS9UBEZKK6yqZnmQVH5g0EbwD5s9EoopUh61xPjulHhvXdqPg8OkIZxMHeL4iOyB098ihJuhjV99UunY8cGlQlWhNwnVzkHBMASz2JpKj0F/66eU/mPFkca3pkMXkNeaEOhkVWJk3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilD8pVjfR05McCqfIOwbiQrxmhfJ3npLBQFRSxel7Tc=;
 b=pvH/HIM02Gpe2i144+XHUr7vB/XbKpSI07XxfT+UbNWvXmUzBPnk4nHJKGtUQt3Bx0dhwj5BgFFksvLh0sCC3+g/cwGvEtl+pMxhXKO0A70fzVoiY4e4fiylXdCBznk7U85I+TAoNkbmno8X+d53Ip+bYy1q0klNnd3vdf/Ac8Bvzp2fXvxGMpthrgBp7cRFdEkTNVWjswmrs0GKN/MNWw+fRLUAODSFredK08jqIopOsaviJlP8IqlHGIcu1nqcfOHxynj4DIjlWxET+KqjQ5fUS9uV4gc9A/VLaT4EEdi+1NYN3qEr/QrNJNtY/CnMqfLoewMVdlXfQUnlrmc2xw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SA1PR12MB7221.namprd12.prod.outlook.com (2603:10b6:806:2bd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.16; Tue, 25 Nov
 2025 19:27:33 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Tue, 25 Nov 2025
 19:27:33 +0000
Date: Tue, 25 Nov 2025 15:27:32 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: joro@8bytes.org, afael@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, will@kernel.org, robin.murphy@arm.com,
	lenb@kernel.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
	helgaas@kernel.org, etzhao1900@gmail.com
Subject: Re: [PATCH v7 4/5] iommu: Introduce
 pci_dev_reset_iommu_prepare/done()
Message-ID: <20251125192732.GF520526@nvidia.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
 <31486e8017284e547b04d2be5110522a777d8379.1763775108.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31486e8017284e547b04d2be5110522a777d8379.1763775108.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BL0PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:208:91::28) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SA1PR12MB7221:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cac4db1-5a18-4c84-302d-08de2c58aec5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3XzHuTvlPy+11pW6x66TDNNvrh5hwMAWO1sHBfDt+TT90ULWZDVsEVGCVJ0l?=
 =?us-ascii?Q?7+Ua6lu/gikUzLMDCRHpMzqDhM039H+tNjyoNmGxVuQRDPKLXjBku+i8QZ+2?=
 =?us-ascii?Q?QV5y/pzlQFnSnVRmVUfQA0RXSPpZL4+PXiZ1w2weYfP2SaTL1GiiI+yDdsCn?=
 =?us-ascii?Q?DRykb03e27otdHzi9amteAb5NZr2c/XQQNnkNS5Gfdeg84+b/DkHU9KIygeP?=
 =?us-ascii?Q?JawZ4uoafQ5cUL0ljunPRYRK9mDC+YyRbCnaO09JFKPOdb2A37bbo3LDfwyI?=
 =?us-ascii?Q?iTEhvRX/ruRmZLYf6EcWGehSL6SK9sJIgi0M7DMbqZEKNJxt/qtNA3zTL0dI?=
 =?us-ascii?Q?KnjQdOVWj6Dfj9XpmspBEsSB5iMXk20JnSazHsoscSZhKZvOeD2vfb6H4+Nk?=
 =?us-ascii?Q?4rtSqmfuvYxmlIc9YGA46hhs4vXGFvuScidQKEM+FhuWhxn5AOpR2suaEWJo?=
 =?us-ascii?Q?WBohyjzDqNEuAVs929hdEj3Q+DQngnbL596C4LOuHImDiDXeIpRh99VQHoWB?=
 =?us-ascii?Q?NoMUL43HvheqLbsa4qAIKrwqYlbcsmsJIHML+RX//gt4V1Bw82VskKFblJiJ?=
 =?us-ascii?Q?sTBgNNdxuacOMzIJFvwvc9YiWqAcElFEE/FaZDTKHizcaiJjXUDGDEFG4wUA?=
 =?us-ascii?Q?QAnedfeyqqB2+taYWrb12zw/GUFbnOs6L9qXUAZJkLRfiujYPyg/nNeqSBvj?=
 =?us-ascii?Q?znw+7QzJ41Q3KqNZFIoz4DdQ1l7jXDxB+u3m+0y+hUMbPaVbHCfcqEuHMVwB?=
 =?us-ascii?Q?S8UCDf5MZH4LrVl55k9WWO5InQk8oB5uLeCIDh0bh/igLY1hsE1niLAf3buk?=
 =?us-ascii?Q?fTyso9nbiBwLjLhHBcAKKedh6Lo4lPktxtWjtlsfAGvBC7vMOu04RxxFCmGl?=
 =?us-ascii?Q?58GnIgSFbnSCx104KjPzZSBAV/C8LHlWaGrvI13NUVUCMEHeXO18JrpUTNF+?=
 =?us-ascii?Q?+VHmWyBU8XpXmB+WGDEPNTxvtyn72Tipn/Z8dIE1KVTrl9z7OWBoG4OI7wtY?=
 =?us-ascii?Q?2lH3V8Elfm8rRK2pzG3VpFqwf6V6eeiTgPo/j1SSCjX+kiIw0USGiTn9jPxk?=
 =?us-ascii?Q?4q9YkSAo6+IyAuxKNe3RXzihFohQ90fG96AR/2ZSey5H5WUSdwQS9Myee8jS?=
 =?us-ascii?Q?I4IR5GUH3AGE3yXOvZ1/GPq5WY3dL8s7tClH5g5D5oGLqXXytCkitG/jzSVq?=
 =?us-ascii?Q?WMWgbjpw6MhaDiaYsjOPcQluJlfMZJDD9ib1bORJ25JPLYHmZ58QeEIOJuMT?=
 =?us-ascii?Q?UHsCF52yCmUiEFPE9Q2+Uz0FrhQYeTX91fo73DSxyabpW6imqxbGJuC303k4?=
 =?us-ascii?Q?kS/oKi6rG4k2GpNTjqdb9/6DnQiHVymtX2dcA2stANcij9or6hz/a8rgc6JE?=
 =?us-ascii?Q?rAH7IaqThOs1tPxtYmjB587908ZedSDtEom6+r87hp3iaEMpXrld9oVq/hvy?=
 =?us-ascii?Q?TtA4redX54ra/2IbsSNxRcTWwL1WU/6m?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lyhT5BXhJblhZLymgYMEMrPQR/jhzj9/zvXI/+EUj1ivBCQZG9zPiF/ZGOUy?=
 =?us-ascii?Q?fcJWJq2t5eDJXLW2eJVxJEDFSI/COaQgtAtAQuTa8ntrV1fUj74G0qbMQuy6?=
 =?us-ascii?Q?G+fhlbXOqyNgDaTCY7BabjYzPQO6EsRr7sTwwk+frNyM2Ehz+LwjOxNOYMgj?=
 =?us-ascii?Q?5qW4CLe2cE9OejQRh83QlODOd7SzMGkHHZn5qQzuzxqQCthCHr0/voxA8irm?=
 =?us-ascii?Q?6n+7NaDFH5KWedwh9ZWl6tWwYiilRo4P/ZJEpHcDyc+XAZLSFhQjjds1yCDT?=
 =?us-ascii?Q?EIRF0XVUSWW8/Fud5nj7zt8jNuF3/EXx8Zh2OGQvOIc5wUwb/r0r0nRf4/br?=
 =?us-ascii?Q?lWscQqZXrTxRT80i//xiqxEYBxMo82kO4FBM8tcCod4+6/RMxP6ao4f+f8//?=
 =?us-ascii?Q?8XX+GRoHeq9ZzIAAXyVwOYDohqSJ2TtkIGZcjcv9ir7A1bIaSgEPwF/l9hP7?=
 =?us-ascii?Q?y2qy4zh355Ax65trThz4LHXkMbK+xC0zNOx9qjN+Owv8IN8/paih/2UhFgCb?=
 =?us-ascii?Q?SgOx3ANi/TJbctNXCWBKFcfrvoLsDSgDNd7BXOGhjcD2eHWzVwtM0fvFxXsM?=
 =?us-ascii?Q?2b+CeFyQQHS9B6A7yPaNdL6xgcu8Y0+KpFt8DsAKga49icJ4nF/HStmXs18P?=
 =?us-ascii?Q?QralaUJZLtocd5gFjFLE8rG4An5Gp3TFMA+xsJcxJqUPGUCt7iHRC6ZAtFGZ?=
 =?us-ascii?Q?uSzKjTyw3gkGtZ9YFkKTVpZo4s/K3de6hSFhbHWuq4/2hZ2gUfj99xltFvVv?=
 =?us-ascii?Q?OgLPMI5l155ecWPijelbVk3xhd4W2TZ9Bzi31c0rGKH1f39fjLQ7E5SE+ruI?=
 =?us-ascii?Q?F4ZOqjUQedRGxSOM853kzQpbbNI8WNs2NNxlHNtF1R32uymb6RMe/x5bOxwZ?=
 =?us-ascii?Q?wPA1ZWhvic0cws2GdA+0cMcRXECcDtmIacjXcKbOaQw5ROoEaRrggX4wfm4F?=
 =?us-ascii?Q?xEmsVv5+L6ptfmPai1ieLP0QsdDbMCjihaGwRHW+WMC43SFD079QXQjB3/DW?=
 =?us-ascii?Q?lEV26UUW5zPdQNU4B6UefzWhGDlGsOvEBMwvy3R4UK5MuHijms1XPka+cgEk?=
 =?us-ascii?Q?1B/Yc0+sQPkNzZn+6jE4NXKcivbe51M8Dv1qXXctIYPWePw4P45CBjfwaTQ4?=
 =?us-ascii?Q?99EbaWdLWtjGWv83BnXD2ETBZqT/soh6R0DmWK1YAU+IzOLqTNaTqSs2P4mX?=
 =?us-ascii?Q?Zo3mL51ams5jvALTe9SJDKup7wAbhLWmbBW70GiUCp+KbqijdTIX8sTILgx/?=
 =?us-ascii?Q?qzjpmygAuyt90eG0DdYu+m7oahAlzfLEwW2QNBdQ7z3fd7ZV7lIVxiK7guJg?=
 =?us-ascii?Q?/fqYusC2Sq3OVzgh4U2F6EAmU0pCwRlVINIjeiiFB2Kf3U3hZ8LVftaV2dNd?=
 =?us-ascii?Q?yGoLAUHWq0C5CcJaEWTBJPh8WPyArWKf9Mb4QRcgo0L1LrfwV3LTCD4CXdqc?=
 =?us-ascii?Q?UyKyImUGkcLx+Y4SJpuB0fiZOw8GOfOCfqPHD96QWRKwoKSknYu5RBin1MoN?=
 =?us-ascii?Q?dyfhSI8+G1R/hzvz0bG8rKnuo8jCttOqtEboU0HsrWl16NgmvodyKVHjixPW?=
 =?us-ascii?Q?rMn1imXgOPHe9onz+cM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cac4db1-5a18-4c84-302d-08de2c58aec5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 19:27:33.6031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEoCFwGApDJX1Sju/OgQdAlDgsQx4Z3lmhbjXPSRJMXQSA3B3t6gqxR1JjRMLYD6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7221

On Fri, Nov 21, 2025 at 05:57:31PM -0800, Nicolin Chen wrote:
> PCIe permits a device to ignore ATS invalidation TLPs while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out. E.g. an SVA domain will have no coordination with a
> reset event and can racily issue ATS invalidations to a resetting device.
> 
> The OS should do something to mitigate this as we do not want production
> systems to be reporting critical ATS failures, especially in a hypervisor
> environment. Broadly, OS could arrange to ignore the timeouts, block page
> table mutations to prevent invalidations, or disable and block ATS.
> 
> The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends SW to disable and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.
> 
> Provide a callback from the PCI subsystem that will enclose the reset and
> have the iommu core temporarily change all the attached RID/PASID domains
> group->blocking_domain so that the IOMMU hardware would fence any incoming
> ATS queries. And IOMMU drivers should also synchronously stop issuing new
> ATS invalidations and wait for all ATS invalidations to complete. This can
> avoid any ATS invaliation timeouts.
> 
> However, if there is a domain attachment/replacement happening during an
> ongoing reset, ATS routines may be re-activated between the two function
> calls. So, introduce a new resetting_domain in the iommu_group structure
> to reject any concurrent attach_dev/set_dev_pasid call during a reset for
> a concern of compatibility failure. Since this changes the behavior of an
> attach operation, update the uAPI accordingly.
> 
> Note that there are two corner cases:
>  1. Devices in the same iommu_group
>     Since an attachment is always per iommu_group, this means that any
>     sibling devices in the iommu_group cannot change domain, to prevent
>     race conditions.
>  2. An SR-IOV PF that is being reset while its VF is not
>     In such case, the VF itself is already broken. So, there is no point
>     in preventing PF from going through the iommu reset.
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommu.h     |  13 +++
>  include/uapi/linux/vfio.h |   4 +
>  drivers/iommu/iommu.c     | 173 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 190 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason


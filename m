Return-Path: <kvm+bounces-49770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46070ADDF50
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 01:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 695F67A5D74
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 22:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30993295533;
	Tue, 17 Jun 2025 23:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i9e6Hwkr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB822F5313;
	Tue, 17 Jun 2025 23:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750201238; cv=fail; b=g6og9zbURbFBOJu0YufILIGDLjC8bZHSINN7JKBMIE9ujNn6hCTtCKqvX6VKqY1Sqnp4dB2T7JYil31onR4NxnnCipekD4lS2X8+f6GlJxTlg0w9Yo4WkkYdrDNJJYD4C+aua4BVLp3TWN7h7I3C7Lt36SI05CHgvdzOrzMLrbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750201238; c=relaxed/simple;
	bh=rc5kAbBDy6+2YqtiWIO4AgFKx/k9WKBZZkt4yYRkVkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uyOuQtIJZOvzXvqg1VSAGiqgvgmap/ike3gXBRxFHNW8eUASrPZEvYkRP56UPFKSHsMrNwHmEhJggMB/RT/PGBYeUvqP9VT7CYxLUokmWpuNCiH9CuXWn6sPQc/nQ/cuyRXmZfwq7DEqbw2emz+DxqQjv6ja5ly9HKpB0hOvLj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i9e6Hwkr; arc=fail smtp.client-ip=40.107.92.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r81iyxEUf9F+/KnbPkPzDe1T2t1vAIZMy89FoWThTBPzZZ6GrE4rc59S3ZvXUc8GBlnoPAlUOM9pUVLPDqo3ZWqUx3u7vpZD1uAFKbJfs2sWRK2x7Tn6tsy6IcRd85f6jTaWbZ4LuY32czhF5JuK0XOg28jsvh5SAbPHN50I2hTm6pWFJ8bPJmrgu+SjWdeDc+O2EtLZprXKRwwJFg/vhME50/QV1bKssPiea4FMsUMN/QhuItvJFqtc3B0QAqddZ40t7/XlCJta/eU/0UgBj2B4UlDmLZ/+AazOBNy3tbFKU+BOH49A5HBEhkMg3BzbuEfLGpOaqS7i3xmRyv2RkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ht4AuKaIgdFSVW7tipFQLlmV/Fyh3enNKqP0dEytqUc=;
 b=Jb3JLGYIdfBwinYGsQ7BXMpG768W3z1iytkvNCgVMu2TZ2F08CW4CMXu3sVnAf6W87NkCLg/yOS4qfVjQNh/DN4YsGDtgzEZBwJGhPWPot7opAMYNGcmtip+/H/dfLtXgX6m7q3osfo7B/0tA8hrlmGmIarDpW45zFkjCcEUvMnGFuJmlyWufsts3MBGtW+dq0g3zHHZ6b3vquoV8rJAnvufflmfu5gQTISge7nlhMEZdwnDLBc6nHojmar3NUK70smDnzkmcxGfn/WP0bq1dkJKcAeV9o7gB3LoHBp8G9QB8jqZ3AsDNgY5dDr6qXXliHFvJsulhSdldAoky8HT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ht4AuKaIgdFSVW7tipFQLlmV/Fyh3enNKqP0dEytqUc=;
 b=i9e6Hwkrmn/FbIQnAgJP2dc+1SoasEZ5upPTEk/wHtwZxXP6qa2+1BHJORAZSltNNa5zzvQZAg4mYvATu8e7W0mDeKMmQA0tV5neMPCRKQUr3VigEYGlJHpo4XOA9EPEeZZgDvbC/oRs5570nEsqmEfGAhd8L4DbJBCdmW+IZ7hVwJpP27Cn5+SKH6vdV8zHUFRVHGbGyunc++Oks6MXLTid+UOftrsx6XNSJ6mgcMRMOKmxOTDTRUmDMse5gXyjaO/AyoJezSyTvFO0EPyZdz5/iqWyO7tvA6wh5vt4vq5G2boiM/Khq/aD8io7FQu69ZerH8aHCGd5Al1+uFD+WQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV3PR12MB9141.namprd12.prod.outlook.com (2603:10b6:408:1a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Tue, 17 Jun
 2025 23:00:32 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Tue, 17 Jun 2025
 23:00:32 +0000
Date: Tue, 17 Jun 2025 20:00:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area
 hook
Message-ID: <20250617230030.GB1575786@nvidia.com>
References: <20250613134111.469884-5-peterx@redhat.com>
 <202506142215.koMEU2rT-lkp@intel.com>
 <aFGMG3763eSv9l8b@x1.local>
 <20250617154157.GY1174925@nvidia.com>
 <aFGcJ-mjhZ1yT7Je@x1.local>
 <aFHEZw1ag6o0BkrS@x1.local>
 <20250617194621.GA1575786@nvidia.com>
 <aFHJh7sKO9CBaLHV@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFHJh7sKO9CBaLHV@x1.local>
X-ClientProxiedBy: YT4PR01CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV3PR12MB9141:EE_
X-MS-Office365-Filtering-Correlation-Id: f6cdcc11-9406-4619-649e-08ddadf2c2ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C1VR3Njr0mW6VL1NhOw3NIPxobof2bE5wNXzAIz+a1CmTxkVB5cLFsq/JqhA?=
 =?us-ascii?Q?0B2w1AHgsL9O1rPWPOMmBOGRVuvyB4557M3hs/C/TexAbQ84bnDVEYv2eH1T?=
 =?us-ascii?Q?EuHrmS2LekfTZt1psSot+3Xd3qqBu1GbWK5DyfjyfAlw67D9bK6SH2uGrE/w?=
 =?us-ascii?Q?L0hwUeVDuUDn1/1VFOQz7WbF1bVa5c76bAdvlHViDwVfqRT2eLn2uMrTfRv5?=
 =?us-ascii?Q?qAr0mcuYPh/Ncb+aGSAdAwPwhAB0Cnc/IoK0+Wof1wntkz6FcoNPPiJXGn/9?=
 =?us-ascii?Q?eOlPEZ3TyVhm3XnbQD5QW2KZtRT97uZNrfOw4tvB4WXwKZrekCn6nxPyGFw5?=
 =?us-ascii?Q?6pJTJgIRX56EjcFCsh9uSPrQMPJHM+N+xkTx7Inkbd0R+7nA/aVmNplc8gQ8?=
 =?us-ascii?Q?CNhxyKkaKtF83dRXhtFZr6zOhiBr3jNI6AT+Px+FWMYXSqekkr5cunbDP+y+?=
 =?us-ascii?Q?qFxEuLetYPWoUc1ijXQz1BN8EoFLe38fX860NoG9O8bUH9B5N/wojsuudOPl?=
 =?us-ascii?Q?MjJ8qUVafqdZ1+x8LMce2IQuTnFTfAFUKGB00NOotxn5avdaiHG5VWNbIuis?=
 =?us-ascii?Q?+piqiyClpZ8KcZVyXOBaPGZO061q0sEGSx4MppbwGmYCsmGzGjK1bVI42iA6?=
 =?us-ascii?Q?prMmOAHPAbuzMQJG4ybsGxY4Bf9T3Tm5/OwCl454qnLNwydLQyZLvmMRrcof?=
 =?us-ascii?Q?qia91fiyRsfCt6jXHYC7ofnqGbOsacy2PjEq/xi1NyQTQVKN4cP5phf8aTJa?=
 =?us-ascii?Q?CQb8SC+HnABPZH92wJ+2HQ4Td2WKktSoUZR1cz0F+MsinbVHLObyNTOnPkKc?=
 =?us-ascii?Q?TU8H5LNNLoxzQ2ZAXV8AKdZ0CXL7eHm61DYXj/HmRV01dKp27ELNQI3ymsnv?=
 =?us-ascii?Q?athu36j0JcnKVy6aottR8rFwU6IrLwg/OxDEzlll5q9MRyygX/ktKrgLNctn?=
 =?us-ascii?Q?qJ3TMiWdqsq4rOb37+ZPSt1QW7KZlQvhiTrd7I9vsElOIkWIjKXLWf3q3de5?=
 =?us-ascii?Q?O4lQTFMId5w8vfvZDfWz/r4J8kcyo9+4JrlhE9tV2z00cG/rKI/J2poxQDIZ?=
 =?us-ascii?Q?iz+HboCZqePCsHugpfdrjKd6YtsniugXU/TH0UczFhinFOF0eHTObNROrBCo?=
 =?us-ascii?Q?Vbk8NJBtmZDxbWEOzo3PdlBHl4EB4s1fiAf6LsTH9oYNmrP2eW9reEaJ6QA4?=
 =?us-ascii?Q?GcsXXNReXLJ1azv8CSsJdfY2HgEK1do0jA1o0Ib0PRuuZcFkObnw3psCGFav?=
 =?us-ascii?Q?w5IDwiCVv3X0f+Z/WFJVaXa9qau9bo1+JSe8mvXyI+kRJlghyzAAswdTlCYy?=
 =?us-ascii?Q?HMqBJ6ORTatIQnQ6i6pvDEbcHzTiHVnnoDRCqd8PTZ3XZM6gBvO+BzFsGD1B?=
 =?us-ascii?Q?a4JjaXCDqGUnvapdeji2P31nz/S6ZREzUopZNWjnCX23LWlEiIGjs5r3LtHR?=
 =?us-ascii?Q?q62sB5hcG44=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DV0vGqnLzUNeYbi9OjlbE2oaxkFxT9UjR3jYn6ExKfsC/Tis1Io9IMMWl5Bu?=
 =?us-ascii?Q?zP87SYuq3+qcuKf4znGOCaYXgoL8gyC0YcXq7pintJVk85NzfDFGYh8FeHvi?=
 =?us-ascii?Q?VZKuFzSTx3G14usvDD64Gr9OuMKRzo8IyNO9smSK02MfC9O6Mh+66Sxr+xHr?=
 =?us-ascii?Q?qMOv6nDOTnc4lslGTLv/2XQedNgcs/vtEz6+CX/qDzv8S5Iy7Nq/g2P2caNa?=
 =?us-ascii?Q?o69SM+HjxTiNHALvpgIgDO2ieos10XOJoqU1pM3TZCwtSUCe6WkimcVM7xwu?=
 =?us-ascii?Q?M/fV+V/KglUS2Iuhf681b+UDLCu7CrmJvBMEIKKx0m9x1/wFiIO5ktZvaqKc?=
 =?us-ascii?Q?dIlMWOKGCzmP4FE7rFiTpWuUs3TLqkHkBHmFLLQC+7sBLhIJJtbAmxMJ5P5J?=
 =?us-ascii?Q?s9o8vGYLPlJB3POljbvwhYrIPmEY+pfBUzMBulu9PJoeQW1G5xesRZIGGg0i?=
 =?us-ascii?Q?hsOc6AlwAXqMlIj/jUZ/BdXoX1KMiowGoHaLQh/I/CWVl/5g/RNeMRH55QbM?=
 =?us-ascii?Q?zAPp1IRi8Z2BYuag2LSofnJzwxKTEkFqHI861n4O6DHAeM5kAtgHlTfarM6v?=
 =?us-ascii?Q?8Jl4OQeh/vYZ5oVsK7Nop7rGUB/2+PP4T70ethJxAmmTOrx4pN7ohNQQ4uWJ?=
 =?us-ascii?Q?hlTnv3JiHHODyyuBXXltKK8D+RSSLQhHjN1DnxCrfogI7jawFhKpqPIkVkbJ?=
 =?us-ascii?Q?Dq20mN81d97E20y0injXBWMvqbDi8YzQ19jo/j+lXYpfC/h2Lxj/IxnbN+cp?=
 =?us-ascii?Q?XndGnpXVDC2gF0awP+J0eBQeYIJdX/atHhLRmuW8BPzoNuhnd99vgdKpB0NT?=
 =?us-ascii?Q?A1zyab4YDCp3cCjWdxu7cwDT7P5i5CqHcE91o/tqomU/FozjQgT2aOCp8Ij2?=
 =?us-ascii?Q?oEvSS9QHH5WX24SSacabsgKXC0/9V2ngS9GH7qwMx6UHMEdiWiBNm/wAoKyz?=
 =?us-ascii?Q?GYYeXWanShcL5W3zd1g1vOf8gVonltA8KcEOkPctr3a5DrpLGdFBn71ObxcV?=
 =?us-ascii?Q?ttivzQxNyR59PvH1hsL0ixXNfhjex0TbZupuZndwT8OzUijPtB/DZdu192pW?=
 =?us-ascii?Q?4ewD24V2lxRCPOieoDg0ESdWI/QU8QuYuFyN9eR53PwUMJD5rcaS3Y+4zcQT?=
 =?us-ascii?Q?QldV9d7gYtZnkB5n6qla9jvcD+SMFFqO44EmsWkBqzr4MT3Cp30Lr6UsN+6E?=
 =?us-ascii?Q?mZvxZA53BmWXUpAw9x+fv6Oi8/EZZJ3MmeQ0BGeYAaRv3fa7HCtcR38spG9F?=
 =?us-ascii?Q?t+nxHdg8bsfs3a7REuHhDZ57fDW+WMJjm0VjU90mbW7AUsMI6ymorC6GCCTS?=
 =?us-ascii?Q?VaUMOPzbpCaHKm7B4PrXR5qVIybUDMIbcMUoW3cfvA84QFCOmG5Hl8uQievf?=
 =?us-ascii?Q?wezcZmpeL9d5DsZ6/GdoCdLQUkZ9lHHYsEUfB8owlZEZi8EIW6XD5bE6Cs3v?=
 =?us-ascii?Q?Ik0N2Hnv34l7Ue4UEFGTrHvA2BVlvKisR2X8M4iFrwefA8H3t/EkJBrBrgGW?=
 =?us-ascii?Q?YQmsxXuce41cf5e7wfNjhm5o66bUFF08se21MagKHMithumDFSqIr8BDl4YH?=
 =?us-ascii?Q?wbvSy4EtTw5SQH13oBu13Da318eZ9qxM3dDp724I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6cdcc11-9406-4619-649e-08ddadf2c2ef
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 23:00:32.5218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kETUP2y0nRf7zJfOZ2CLePnCon65hwkSklraZXutB1OiQVmVeiKWIS8otbF3n+qE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9141

On Tue, Jun 17, 2025 at 04:01:11PM -0400, Peter Xu wrote:

> > So what is VFIO doing that requires CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP?
> 
> It's the fallback part for vfio device, not vfio_pci device.  vfio_pci
> device doesn't need this special treatment after moving to the new helper
> because that hides everything.  vfio_device still needs it.
> 
> So, we have two ops that need to be touched to support this:
> 
>         vfio_device_fops
>         vfio_pci_ops 
> 
> For the 1st one's vfio_device_fops.get_unmapped_area(), it'll need its own
> fallback which must be mm_get_unmapped_area() to keep the old behavior, and
> that was defined only if CONFIG_MMU.

OK, CONFIG_MMU makes a little bit of sense

> IOW, if one day file_operations.get_unmapped_area() would allow some other
> retval to be able to fallback to the default (mm_get_unmapped_area()), then
> we don't need this special ifdef.  But now it's not ready for that..

That can't be fixed with a config, the logic in vfio_device_fops has
to be 

if (!device->ops->get_unmapped_area()
   return .. do_default thing..

return device->ops->get_unmapped()

Has nothing to do with CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP, there are
more device->ops that just PCI.

If you do the API with an align/order argument then the default
behavior should happen when passing PAGE_SIZE.

Jason


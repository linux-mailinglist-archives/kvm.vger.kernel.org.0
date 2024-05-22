Return-Path: <kvm+bounces-17978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4E28CC655
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 20:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BC151C2133F
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 18:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1738B145B3E;
	Wed, 22 May 2024 18:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DUsXBXTN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E2F1BF2A;
	Wed, 22 May 2024 18:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716402655; cv=fail; b=VIp5NQO124u8I9v6YjlBtkmAVT/ZqWh1zduWstSu89hmTNuQnJ1stWrtAxMUnhBDmKAAs99P2BYQEaoQzIstlgzxC3rdvcxVRNk7sd7MBJJve7n/75iS0fuwGDb3aDTuzVb2VvSroHOuWG6Kwj4Zw4jWCYa6Bygm3TCuZ2qdPxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716402655; c=relaxed/simple;
	bh=uSouPcXTrL1XftcND51/1vAKBo3MO9C/Cle//tbl7x4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A0SFtH9C9oYKoTWpbOyz8rFdBKGbCIP/+IKPKWeNVxFx19mDF1ubqQ1mp9kC83C2SaoJ/eHpNj2cLYpRPe06WjuuHadjy7Mm7h5pa1e+05/mQnYDbeV5MslBpbnILypqZ3jIpJPoou+FRNeunVuAgI8P9Hn4bT8gY/IIl+XrD3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DUsXBXTN; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVR6yck6XCFcvfb33ohXaQkEfNe9cspK+Bo6NU0KkpUTnPIsUaqCJWw5ui9Er+OWAUqbrk3+87xVHp2OICAtR60lg+Ak21nd/QdcRPygwKpgcxaRdNzAmpIMX8+H+OOc6ClEa7WXm2aWeLvDbz/aQ6NpOS9bCV/urlY4jvv7gjsQ4BfugNiuLR/L1ZobFD7GhLM2UAtI5Ku41vyxlbS17Nyt+eUxUfgPmMX62DburL66o1Iu1j9EQqxafqYJlm99jwc4WDvs5Sp5sdMVyhOkYVoAh5DDBrs3x5a36txpcqXcmPIqK7glZ7Uu/jRgSRJwg072KjDDYQX104PoPQvBdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+NAT6Rw1Zm4BY2Y1xm9LCyTAA2TEYfg9nBxx/MFHd8=;
 b=Rf3OtxNA1deHki9Wni80jDvumR+AonqVamIICQ8VSCEric5BeIXjsGOALFkwcBOfOhF5PDRI4HhczfrL/+WSDwjI/eGQQozRBLL5s4Aj6j5wCBJ1WgQ84oTHBQdPu4y6CDIKpPS8VxM7xoEyeOCT5LoF6TW2dnUywi/hb3RFgnKI88lFdCijW2NHWd8md21B4C2tyNnX57bN6im/jvYN+adOc9aVpx7wDnuOwyI39TBy/6ChS8LSuCCKWeU8Mi6vqkgeeIW5LmH993y7+1+6JTJSsK6zGpxmBlvSnWisVdW3TXeGxO7GRetgLNZNsY4W6S4j1AEhF/hWgIBm5GhrYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+NAT6Rw1Zm4BY2Y1xm9LCyTAA2TEYfg9nBxx/MFHd8=;
 b=DUsXBXTNLaLAY+wIzKdrxoauthXhWUCjtJiBLGwbAwH280u7HoXhfOb14Z4nTluchumG7mQHDLIuxb7ILF7VcBZhuPcVHUIRGIu5+yJiY+0wRIUxqBz326QKKKL0Y0ZDrHPXAFzxYMRY9XVZqQpnLndfi+ATy5nOk0ab8YDOn1h5XLIcnXqzaOauGs78MO0VtjxhySaDMlSZjmmnvFFpxgXDgwO1WJkcD+kB5XAorkhhb11Kwe3fq20cNGC19Z6adNIKIbCzdF04Ltrsk9TYWasmwV/uDz78grSpeU7ua8KHeitJ6GIoFkjuQLnzUXO2MyGyCn29GKqaxbQ2H0PTyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ0PR12MB6757.namprd12.prod.outlook.com (2603:10b6:a03:449::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 18:30:48 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 18:30:48 +0000
Date: Wed, 22 May 2024 15:30:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrew Jones <ajones@ventanamicro.com>, Yan Zhao <yan.y.zhao@intel.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	kevin.tian@intel.com, yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <20240522183046.GG20229@nvidia.com>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
 <20240522-b1ef260c9d6944362c14c246@orel>
 <20240522115006.7746f8c8.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522115006.7746f8c8.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0340.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ0PR12MB6757:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aff4a2a-63e2-4bfb-ae09-08dc7a8d4d45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oCNXjhYHYXiOj/EVWExc5ChKmOhI4QFPusgIZ5nCbuWdICzSoEodsGvj33FA?=
 =?us-ascii?Q?hSnbxSanlS9P0gIAex8L5JklaUvWw5cPWiNdct5SAf9xf07pfXVIbYT33P/u?=
 =?us-ascii?Q?Nl1jlUcTY8m5PF8iU+bUPVcX0ik/cUQDulJvsurYYkOo9Dhc5t8p/j+bTMxg?=
 =?us-ascii?Q?vzOrXAjUBERzVyUyxF5t0hGnw6tpkiST+/x7OEEsqzXNHUfSs0O31H3fHnQ8?=
 =?us-ascii?Q?A7uwKqRkEQVFgX7y88YfHUYZwhxPevbRuReOjDr1qit0ZbnNxpTqBY1+QIe+?=
 =?us-ascii?Q?p5zFWhrtMTgf/WjmRS/NCkPIjT132ZRznXp7HyZYtnfgAE3dO5Gmg7I/mde7?=
 =?us-ascii?Q?f/jYJNqGfuj+4tyhpQ6Uw3Uug2IpKuaKujxYI0k8WTqLibL/wWe7OT4i5KIu?=
 =?us-ascii?Q?UUOri7W5eBzY6FrI9y1KrU6Z7CN28XeaKP75YPMIT7f+67zIAIQYkh3gtbpt?=
 =?us-ascii?Q?1/l4lDljcWFvvty3nFrVrg3RyMyB39DvzsVkOeWF4ajCWkhm0HT/kLUNzEIA?=
 =?us-ascii?Q?DmDaYY3vw7MB3ZQgdj80phX7AYO1+l9fa6lXVcMmZX4CoPFAvdwgsIM5/qU5?=
 =?us-ascii?Q?njJoo8GjH4L9T9Gq4axlhmDmUE2Ca7SdN3scRmrXC3DsV9C2RddUgWtH0hsa?=
 =?us-ascii?Q?j0+Z96ItaOhI4OI4vDBVWYQryHvLn7HU0lwvIsfWudnB7gv0d2aeg0jo6iDy?=
 =?us-ascii?Q?AmBSMvA9chbzuoabdg3Q1b0YT7TXL3GWLsJcn1CtbWE9UEcYJylWmenHpRLD?=
 =?us-ascii?Q?M5F/m06g4f5BGfqVJPV+OUH5BEfArJ4aM4WGcVJjn7pZHcHO/dGRVPxrpC/e?=
 =?us-ascii?Q?B5RtwyrMrZeWbefI1NOK4GKCMrCC3z9Avcn5UCQDVYS0mMf7xua/xkR5i4Ly?=
 =?us-ascii?Q?qN72nhs/z2aMYSKUfKQDYxPr6rg6/ppOozuSGZdQePHevGbJGApe7w/SNEtd?=
 =?us-ascii?Q?3bLUcTAjcDho3qk6WdViSCtU+nlrBXZe2TUUhBpRgJYa4b9ybIPUU/ISM6Qy?=
 =?us-ascii?Q?LwYtt353BhKz/lF6v1oXaPjyDWp4Dv0xQqjXZZOmLIeZSWxv4dEcQXBvyc1h?=
 =?us-ascii?Q?8vAjp63CR4NNClKlYbNpwjF8xu8iWF868cZ3ig1ML5u023hblx1C/HJx65L9?=
 =?us-ascii?Q?y8fyhf459Rrv6v7m39cnpV/KFCNhtBj5V6PggESO50Tni/miS58UINobuMtM?=
 =?us-ascii?Q?sGKPFuLYhAyMEATBwWqaR0O1EJSeAbDqLrYqnMwyCL/eiQg+GQuzY8yRpYHD?=
 =?us-ascii?Q?jIpovMnv3U+wRcrqijd+aLiEkajPA5JWiiJBLOrUjw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ts/je87qkGFkKqkpI/dgucj3P3dS7g14SVrK2kdpnXOFEvHKcjQj0sswP0L3?=
 =?us-ascii?Q?t1QzJPWxH+XycVULMChbF7r2alwF74dxWAvt1zR5ARJKumYO1BrpqhZMre8O?=
 =?us-ascii?Q?i2itjtPua23FmSDfntQHdMR2n0UE/63aL2a+I54mXac5PG6H85G+mkgbFr95?=
 =?us-ascii?Q?Dnu0UJfrkSwyM8ZB9Rjk6VcWGAFC8kuLbhuO0vddGDrkKWpxfDOiQ7zms1+E?=
 =?us-ascii?Q?8QUV2H6yK69Z2WL6reH09MjwYDuRWE+D2vl85hhGOi76TIU1Ekr8HIW618L6?=
 =?us-ascii?Q?Re/itWcNpNBgN0Kap17knm+JeUlr10o/iMGXO4V8OD5knDBC9G7PjNr6MtUM?=
 =?us-ascii?Q?Qwa9SJFJf35rLZC6Mu+bV2d8o5A+QlaShdH5R/Ve91HZ6x5qi6U0DSC+EjAx?=
 =?us-ascii?Q?M6mEtbGvXq5KyFlKbuK2kw6K1Cqepn77VzyfM5Y+SM0IPOTrNAdKUjbjfndd?=
 =?us-ascii?Q?QzEJa9C4LcyMD+kUEvnw1SmuG+8Z1Vp6X3UhIvniVyes2JSIc4fXUmYtuTZU?=
 =?us-ascii?Q?QjiZZs2u3h3kVfrozrtS1AJeVIVo9VYOijAqu+sAzyRAhKy1NWU+Ujo1wDP+?=
 =?us-ascii?Q?h8WONO4k7Y3CmUYdRmhA0sYecJNz4thAqgeGRTPInqUemjOINHZQH3F/saBP?=
 =?us-ascii?Q?xw29taDPPUPYp/UJUjY8oGUs3ZA+g8aex9vbTvR0EyKlziRpLwNNOeKs9m/D?=
 =?us-ascii?Q?5uXSHQm2z/wQOYeI1W7UbHzGsdsUoo75JUzO8VAx/itPgRd+1JCoqDgzmaN9?=
 =?us-ascii?Q?DmxbMh8+gT+S6auYxzAIPrDkqZnDkMLjiIg6PjisF9lhTGkxd9dbawhvaAQN?=
 =?us-ascii?Q?6CsDZsiwJ84GPKtOazlSBhFIPwU55fV8A4LBONDYWl8521eAD7ZIj9i2JbBP?=
 =?us-ascii?Q?4d4AQGkPLqRiptGUPrQWFxj7kEYsQNod5y0JaULfQN6KDrQHnX9mCMw/tLN+?=
 =?us-ascii?Q?1NGNhxcXTdIJkKLygJz5E7VTBYLVgG8R7HVbxREYLrJoCo1TPbsBHnuFMjnZ?=
 =?us-ascii?Q?rPdwBwvIvyeubxGardcmTc2SsaoHGPqhMLzC9qWIEwAy2TcNwRCTB8azqtdC?=
 =?us-ascii?Q?mLN4DajKn6s2gsosYsBAxYa8NxMBADOH/kA+0cb4exOXLOBWLhsI3n0GJZcb?=
 =?us-ascii?Q?ttAlRagqRNTRwWSYPNHhOGBUOJXO2Aueb5ssNGbIrYkeuTArKHoz5/4kpawF?=
 =?us-ascii?Q?6aXg91Ofn5I1m4qI1nngiPxe0T0mlFl1IqFXMQKUzGCfhRaHK9NI5yBuG9cX?=
 =?us-ascii?Q?23UYJQAFpMa/MC9XWHyGDBYKri8Pf0McZDVDCHQDo2DXh5MdVnZWcfhQ/M1E?=
 =?us-ascii?Q?+lWBc4AArU1pzQq8QLz+BL97t8KIr9T7lLnr1ky3WT+a51uVR4NtqoxHTO4j?=
 =?us-ascii?Q?k5QFArOUgDW2GZueU8Y0e3hJdNtuB03jmFcxgjoq5ISPZlwMuSbeFuvYbZKO?=
 =?us-ascii?Q?jLdwYcWV9bxEZkG2CRa3TOi/JX0gWup5cxqUqK1UkAyT81xMfzYuHbQAhueQ?=
 =?us-ascii?Q?ASI6FWLEUTdtJR2pZ7YiTIrRVRsYBs/HlFIVESvLd+u9MYKKXhGbtOy/WXC2?=
 =?us-ascii?Q?7VqTMa5HTviESOO8cWo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aff4a2a-63e2-4bfb-ae09-08dc7a8d4d45
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 18:30:48.6313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5muDwOhkRljfq0SVgd+3oqdgSKIkR5v/9hvmXLjAiGsXATF3o6U6fDMlEpvINZr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6757

On Wed, May 22, 2024 at 11:50:06AM -0600, Alex Williamson wrote:
> I'm not sure if there are any outstanding blockers on Peter's side, but
> this seems like a good route from the vfio side.  If we're seeing this
> now without lockdep, we might need to bite the bullet and take the hit
> with vmf_insert_pfn() while the pmd/pud path learn about pfnmaps.

There is another alternative...

Ideally we wouldn't use the fault handler.

Instead when the MMIO becomes available again we'd iterate over all
the VMA's and do remap_pfn_range(). When the MMIO becomes unavailable
we do unmap_mapping_range() and remove it. This whole thing is
synchronous and the fault handler should simply trigger SIGBUS if
userspace races things.

unmap_mapping_range() is easy, but the remap side doesn't have a
helper today..

Something grotesque like this perhaps?

	while (1) {
		struct mm_struct *cur_mm = NULL;

		i_mmap_lock_read(mapping);
		vma_interval_tree_foreach(vma, mapping->i_mmap, 0, ULONG_MAX) {
			if (vma_populated(vma))
				continue;

			cur_mm = vm->mm_struct;
			mmgrab(cur_mm);
		}
		i_mmap_unlock_read(mapping);

		if (!cur_mm)
			return;

		mmap_write_lock(cur_mm);
		i_mmap_lock_read(mapping);
		vma_interval_tree_foreach(vma, mapping->i_mmap, 0, ULONG_MAX) {
			if (vma->mm_struct == mm)
				vfio_remap_vma(vma);
		}
		i_mmap_unlock_read(mapping);
		mmap_write_unlock(cur_mm);
		mmdrop(cur_mm);
	}

I'm pretty sure we need to hold the mmap_write lock to do the
remap_pfn..

vma_populated() would have to do a RCU read of the page table to check
if the page 0 is present.

Also there is a race in mmap if you call remap_pfn_range() from the
mmap fops and also use unmap_mapping_range(). mmap_region() does
call_mmap() before it does vma_link_file() which gives a window where
the VMA is populated but invisible to unmap_mapping_range(). We'd need
to add another fop to call after vma_link_file() to populate the mmap
or rely exclusively on the fault handler to populate.

Jason


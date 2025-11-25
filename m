Return-Path: <kvm+bounces-64553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3FBC86E61
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:58:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 67ECD3525F3
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D52032C937;
	Tue, 25 Nov 2025 19:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DN+30kDR"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012057.outbound.protection.outlook.com [40.107.200.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929AF2E0B5B;
	Tue, 25 Nov 2025 19:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764100717; cv=fail; b=eqWYwwAovZJ6DSNVQqd6rtjotXFDX3sxVAW0wkcdNEz/0lfRTtcnSWmcHORfMOQfQyA/VRxKK4sacoJxyfo9AKFDx32uLtPiSFWsPTtICuvVDcdrzJ5xR0BdckRkxLUQg8h3V/BMHR9r8O/Y0hhbwG9OoMeFTXcNmQfnPZnLEsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764100717; c=relaxed/simple;
	bh=Yk2YJy6C+akA/8Oqh9NLJPU7XPVcO6c+3fotyU1/sbA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UqmrfeByDdfL9R4NCR2PNhz+CfjCmqRpfL7Km5fymnRjxrczgU6DBTlLTkI60kQcEISSTvCuLTEbC6z06ia2EY+GrUTRvw+oD+cRpInqu99lP8crVlyFpBP92uYXC9jGSyqrTyzKkUxEBPPsfUGMT3WT6jEf959BANrSPdX5SFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DN+30kDR; arc=fail smtp.client-ip=40.107.200.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tR0qZE6chxWheWqrA6D1MKLh+7ApRPhJyzRWBTC0+YX6P5uL8GSdkouH7eOoiJNgcuF3T9BBChYk5aQD8Cfvqp/BfS/4QE7r6KozOlxe4HTbn9A4TBFXaWWo8LhENXGOn+yx7jZjg+VIqwbg+9NbiSMMusQe9lTOojP2Sa1PZ0qWNCQ39M4znl4upVZzBR73XQrbSxlFvq+x6dA/8S8Z8Ntuq7xIR49uHJMxFe8CR4swN98Nk7JFipqpFYxbj1e3rL6ukVW8Ltgnn8JMve06rWPOerVhc6JvseKeDA6Byu126WApwrDp0Qvc/1FkBB/alfUBK2VDMh3oGgWGjpytsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofAUxJiOu+wdfgZc2Cwup6JFlExg3/nW79w2JietMSk=;
 b=pT8nCWLzImLav1bwzoHF3OEghC5LUeeNp25svD0xR8XzGiKYFI7oDMfTWRyFYGL6Rxt8xr0Z/3MOF6MIiktVUXB/MtQ7/1k9kx7DI2SLzQQ7F2RVTUrjLOoVIV4oLSajcG/OXZ7wDOgRQq05zXn/lmFbw1cYXRLKLUcb9q16/KxzcDFysdX7Ti5KmnMR9VuBOw+wFiRXOTmRwsqbou0oYrB5pPJB5VOYxZ7qKoiV8K2p11eKuOl3Ttq9oqgUTavoefup4fOp4Tah86SMPgio8361Jc2YZNyWJO9Zm4BQa2iArOG4wL9ThA6ZZknKPTVDsJnEKLO+uyB0P7yZrZSG3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofAUxJiOu+wdfgZc2Cwup6JFlExg3/nW79w2JietMSk=;
 b=DN+30kDRRcMsZ+faQxlOZ8S3K9Ar+Y+3tvdPWN2vjfEctkO/gKNjRNdbngYAtg8VsZpiXBFCj8ksAJ/Y4u5W5AnKoKk29iyMEC6ZvptWjMqGsAB9Y7aXlbyZqqDlpViGFxRhm6P9yGWAfqgTf4cdWDW5vKxCaJVqfny5j3v0ixM5+7baGP0MpU5yXo5jWFNrfoIMUn8WIV6PRwc088wZGeyX49xGXhvxHJ6U5iocHcVfaTlaMqqa24eUS/HM6QlLSq5Wl4HJoo7VPyQlfvAL7TWwxWy4yT4sb9b3vg2hubY0E4j9N+A+t49PMNsL5O6OAZxCGGCIvesKD6Gif34SoQ==
Received: from BL0PR02CA0031.namprd02.prod.outlook.com (2603:10b6:207:3c::44)
 by SJ0PR12MB8139.namprd12.prod.outlook.com (2603:10b6:a03:4e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 19:58:30 +0000
Received: from BL6PEPF0001AB51.namprd04.prod.outlook.com
 (2603:10b6:207:3c:cafe::52) by BL0PR02CA0031.outlook.office365.com
 (2603:10b6:207:3c::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Tue,
 25 Nov 2025 19:58:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB51.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 19:58:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 11:58:11 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 11:58:10 -0800
Received: from inno-thin-client (10.127.8.10) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 25 Nov 2025 11:58:02 -0800
Date: Tue, 25 Nov 2025 21:58:01 +0200
From: Zhi Wang <zhiw@nvidia.com>
To: <ankita@nvidia.com>
CC: <jgg@ziepe.ca>, <yishaih@nvidia.com>, <skolothumtho@nvidia.com>,
	<kevin.tian@intel.com>, <alex@shazbot.org>, <aniketa@nvidia.com>,
	<vsethi@nvidia.com>, <mochs@nvidia.com>, <Yunxiang.Li@amd.com>,
	<yi.l.liu@intel.com>, <zhangdongdong@eswincomputing.com>,
	<avihaih@nvidia.com>, <bhelgaas@google.com>, <peterx@redhat.com>,
	<pstanner@redhat.com>, <apopple@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <danw@nvidia.com>, <dnigam@nvidia.com>,
	<kjaju@nvidia.com>
Subject: Re: [PATCH v6 2/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Message-ID: <20251125215801.7149bb3c.zhiw@nvidia.com>
In-Reply-To: <20251125173013.39511-3-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-3-ankita@nvidia.com>
Organization: NVIDIA
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB51:EE_|SJ0PR12MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: a7688ca5-394b-49c6-b757-08de2c5d018f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+ufigFcD+Ol5BQ0MdpJpFqrcPFZIuwe1C2WwMsjdPwqD75Dvkd09DqMjm3Ne?=
 =?us-ascii?Q?IDkTaHaL5ddncEsZM/Oa4EcCXDXH33Xvy+l3v4xWCuvkVgQQdj+slv/5jQie?=
 =?us-ascii?Q?NeECNIM6/SAeKg7w34wBpE6XHphqqB4XZVCIaGnkeAOHP/6kvDzrDMiGWyVm?=
 =?us-ascii?Q?eG6MO1Xu6g27zrwuBeyL8ff+vP2XgFaWyklQyBlI3LbEP9xRypjmL4vHSf0B?=
 =?us-ascii?Q?Y8X8c3kO/IrASs3MI0yfdCDDVtRpi4V8gEVKZZd3O6Ncpo2VtbUeQWHnSgBU?=
 =?us-ascii?Q?3Tca9N8wF7c8cfit01X34ekGelKBkAneouCBB7l4+ONKHmFHKAkijkPEl07B?=
 =?us-ascii?Q?z+ksMMC1Y8pBTH9XKP2hf8QL7XwsL7j0jHwmQkxmBwxr4ot/wC6QDKv2qwj+?=
 =?us-ascii?Q?rEIQFLCGohBLlPm2hE5EIW46rCtVQV1aNtXcH4nN0n7kuSf0pJM1vDf6YEUk?=
 =?us-ascii?Q?vjBpk2SFj0Izey68TvIQzKl27J/UmAE9b6QgG35bktF0fvFqOSaxQsaU37xL?=
 =?us-ascii?Q?jh9dmjGj8TQnH9PIy39nP0ENcvHLu7nl0gyF2ad2EFAjqXs16eG4QAK7ewwt?=
 =?us-ascii?Q?cn24GuaW/gIGcRrqpLWL/M4Ri21mW/kzb9nWKJku3LOFjUV0D6PTW/7unJXa?=
 =?us-ascii?Q?7g4NSwpduY1Q1/NJOE26pD8iFGsyrkmid8qcpg0FyofcklTObiEugNbhqOgJ?=
 =?us-ascii?Q?/Z6FcDuYDhTloZ4Y+3QKjmyd33P30tRIHDMFw3aKJ4HP2EnihwBRntYXVfCb?=
 =?us-ascii?Q?f9OMu7h9RTaDVO2zeGa68pZCq2UEKWk6EUbO3t1VLWnTefZYqddpEn9WmZX9?=
 =?us-ascii?Q?gsKAZiRWl0UsHn3Ot6e2TkUDHm7MhsRTu9dbJ4JIZ4uAHsJvhukPuZFLuX+i?=
 =?us-ascii?Q?qWVfXKX3lJ2elJPgEGJt0cFopRwH3vonfLWmY0mMb5tTS7JROYjyavvA9xCz?=
 =?us-ascii?Q?ETXSiZOHa6gwF5YHW2H+StySkMEBNFhX0lDPXA9evR2j1d9dvFy5Lx2JnW+M?=
 =?us-ascii?Q?7yZCrJGddkO+Odu8x7kS2VyyL5XDt+8Jg+mmnDDqD14XFd7x8+oyMhAry1r7?=
 =?us-ascii?Q?plzCCEESXtV/nhbeLx+MiXGxDkqK+7ULF4K61hmqEDHQCQnsjLZQ9wJfAY5m?=
 =?us-ascii?Q?qztmkvM9OanqWvZLUUulIcoE+YNld82p33E+yj9zA3HGG5stb9/EP7md2ZyA?=
 =?us-ascii?Q?5kx4Btrq+vP+r8WABoQ7v/RbNFOvDytRtW1l9lWOdd8ZnH7VKsOKUZqzqCR3?=
 =?us-ascii?Q?etKX78SCVnIGyWXJQDwi73g0R5vKtcJK+vRNxp7MzotKyPo8zuJitDiRfEKK?=
 =?us-ascii?Q?82z675DXJbndkCFD5UqUnxdA/w0zWBRn6UBuLPAmNAARlI8+KH+IorOgdeQw?=
 =?us-ascii?Q?72KfwcTHLAsqUw1EVcN3V8ZN2bh00OrNSuNbC708aieKIS9kwSVeY0eI12+w?=
 =?us-ascii?Q?RYuw7nt+O5iqCn+scn9I24czzrDIAp3Uery3OTmL5fNqIo6bA552HVHRnbp0?=
 =?us-ascii?Q?oqZKkK66Jo6JQ8GLCaPO2G9NGAXCLU2u9LHP9huigqve8XTHXsUFrXCugnuD?=
 =?us-ascii?Q?llrr+4x1/5mJc/V+GTEA8xDOrkQGPby8/bpTNULJ?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 19:58:30.1162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7688ca5-394b-49c6-b757-08de2c5d018f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB51.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8139

On Tue, 25 Nov 2025 17:30:09 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's Grace based systems have large device memory. The device
> memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
> module could make use of the huge PFNMAP support added in mm [1].
> 
> To make use of the huge pfnmap support, fault/huge_fault ops
> based mapping mechanism needs to be implemented. Currently nvgrace-gpu
> module relies on remap_pfn_range to do the mapping during VM bootup.
> Replace it to instead rely on fault and use vfio_pci_vmf_insert_pfn
> to setup the mapping.
> 
> Moreover to enable huge pfnmap, nvgrace-gpu module is updated by
> adding huge_fault ops implementation. The implementation establishes
> mapping according to the order request. Note that if the PFN or the
> VMA address is unaligned to the order, the mapping fallbacks to
> the PTE level.
> 
> Link:
> https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/
> [1]
> 
> cc: Shameer Kolothum <skolothumtho@nvidia.com>
> cc: Alex Williamson <alex@shazbot.org>
> cc: Jason Gunthorpe <jgg@ziepe.ca>
> cc: Vikram Sethi <vsethi@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 84
> +++++++++++++++++++++-------- 1 file changed, 62 insertions(+), 22
> deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c
> b/drivers/vfio/pci/nvgrace-gpu/main.c index
> e346392b72f6..8a982310b188 100644 ---
> a/drivers/vfio/pci/nvgrace-gpu/main.c +++
> b/drivers/vfio/pci/nvgrace-gpu/main.c @@ -130,6 +130,62 @@ static
> void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
> vfio_pci_core_close_device(core_vdev); }
>  
> +static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
> +				   unsigned long addr)
> +{
> +	u64 pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +
> +	return ((addr - vma->vm_start) >> PAGE_SHIFT) + pgoff;
> +}
> +
> +static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault
> *vmf,
> +						  unsigned int order)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct nvgrace_gpu_pci_core_device *nvdev =
> vma->vm_private_data;
> +	struct vfio_pci_core_device *vdev = &nvdev->core_device;
> +	unsigned int index =
> +		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT -
> PAGE_SHIFT);
> +	vm_fault_t ret = VM_FAULT_SIGBUS;
> +	struct mem_region *memregion;
> +	unsigned long pfn, addr;
> +
> +	memregion = nvgrace_gpu_memregion(index, nvdev);
> +	if (!memregion)
> +		return ret;
> +
> +	addr = vmf->address & ~((PAGE_SIZE << order) - 1);

ALIGN_DOWN(vmf->address, PAGE_SIZE << order).

> +	pfn = PHYS_PFN(memregion->memphys) + addr_to_pgoff(vma,
> addr); +
> +	if (order && (addr < vma->vm_start ||
> +		      addr + (PAGE_SIZE << order) > vma->vm_end ||
> +		      pfn & ((1 << order) - 1)))

!IS_ALIGNED(pfn, 1 << order).

Other parts looks good to me.

Reviewed-by: Zhi Wang <zhiw@nvidia.com>


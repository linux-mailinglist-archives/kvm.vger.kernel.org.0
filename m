Return-Path: <kvm+bounces-64554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D2CCC86E8E
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 54ABC4E3A3E
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704AE33A70E;
	Tue, 25 Nov 2025 20:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KXo//4ZF"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010067.outbound.protection.outlook.com [52.101.56.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC1F23ED6A;
	Tue, 25 Nov 2025 20:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764101090; cv=fail; b=GEc9yPnvIcl9Z3nQn97yaW2lBlo8qeNZB8aaKWtxh/BvVWs9un0uFTv+mAOX674hhjzUfBMJng0V/5WwcfyrmIbSgXvFvAJ39IPNh7WVYJ+eEuzYy2D1JAPJZ7LX0QVDFfdGJ5gfllw63REgKisOaibwHMmOUjppttFqETZlBmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764101090; c=relaxed/simple;
	bh=T4nCnsYUnLrNNNIJnHHJZUjOppxu62uT0JRehbuW9zQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F4bRyOySfZPUGpnnkF2ttx/Xhgvx0NMHSgMSgBicvwWGjJkWDZMPyW4WRQfjOiz9g62BkFYOQuix5Q53OnLyyoyq1f+4E1km3IsiTpY2M+SIcmlyhgftdoCReErZIO847t/lrND5DQrhtgy12zzAls81x9DUaf7n7oKeHXnoMo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KXo//4ZF; arc=fail smtp.client-ip=52.101.56.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N08zQNE7hE/9DlN77vODs7LEB/6Tbgog9vU+RINr2jHk6+EXL6xLo8CA0Iu4Wx7wGuMYHyu2XwpNN44S55dxeE46rDaMY9bjJN2r7CYk7vfq5s9oZoCeCBXj6Hy2kb2NerrEgO42tgB+78MkEFx1TGIdEeCYN+v14/EsID3hjBmOWiYBwTBgxXT9BhR3z3eEl33LlWIiiG02sOdyoT7i0dAwJXK/OCz0FtJ49ERQ+XfPJS5l0hKhjgsTXLMyqEp0thDhDvgihkmsqI+awne2N0jCAY86x5lovVhO81v+SjkLQXTmt3LOsV2BuP8xa7yFucsDpl0lLG6VRFnbDtxASQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Gkai5vk8bw/HYof8iCR3NZPdBcM3Y9V5wi4A+VRDDw=;
 b=YXWKFfsEH/UQ60dqmJL9dXWZTXY03ej9i+fKZo343F1Wetyl2tKLc9vkwsEt8PzcGsjoOd4dhe0SVfN8qAcSZ+uVXGXVzixNeWz3QZTgXmLFq9Kg0J8aV4MSAP3Rp9KRY5nTdRozOgS0ZTmJ6re1c2eRjYmR3VHeTU5igN52kMXDj5leiNLUjrXs75qrWY/wizPgutHztUJWOV/tL0WVuTsRNIwlTFjKlHCpSU6/gj9YPXdjd07Oq4xnMhju/rbtIb2YBnZBt9blx8Pp2E+4BiVgnQICk8eWvdESUklGatPuzRdg4ZXtbQbS5GaHuIVknZo8sPTqyct8rJEFulwn+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Gkai5vk8bw/HYof8iCR3NZPdBcM3Y9V5wi4A+VRDDw=;
 b=KXo//4ZFzJCqGB7AWrQKIOLxFNV0zonSOHd1BqO+uBpK829Xu67op1lnkNsxdf+UATyxidRBkhL0sfiulp81Krq7PkM224IDclL5b2/8X4TM3lJVzk5QcLQYjODxa8DULg23+Lq5TR0PgAxnqQx1+EOAJQEukxBjIFCiKHRrYRffLAdAaAXcGgc7ziT7D+zNWIepugyU4DOuVWOF4KUf0rj7Y13AsJyBBA7o09o1izTqdKY9FcxMJAOmELf12wcq06DHknoewL+cVAlnYs4ECb06Vk8Pfugyh+R1DBRyj7PnXcTOZsC6UTRGtHE2fSP7Z5OhU0WAb1/1LLcPoMDlXQ==
Received: from PH0PR07CA0101.namprd07.prod.outlook.com (2603:10b6:510:4::16)
 by CYYPR12MB8892.namprd12.prod.outlook.com (2603:10b6:930:be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.18; Tue, 25 Nov
 2025 20:04:37 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:510:4:cafe::a8) by PH0PR07CA0101.outlook.office365.com
 (2603:10b6:510:4::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.17 via Frontend Transport; Tue,
 25 Nov 2025 20:04:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 20:04:37 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 12:04:15 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 12:04:15 -0800
Received: from inno-thin-client (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 25
 Nov 2025 12:04:08 -0800
Date: Tue, 25 Nov 2025 22:04:07 +0200
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
Subject: Re: [PATCH v6 1/6] vfio: export function to map the VMA
Message-ID: <20251125220407.5dba3173.zhiw@nvidia.com>
In-Reply-To: <20251125173013.39511-2-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|CYYPR12MB8892:EE_
X-MS-Office365-Filtering-Correlation-Id: 256be12e-3ae1-40c1-a836-08de2c5ddc48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g/6J7xxbCsSzlndQJHkd/WBUNqyiGqHAD54p5DfxyB3H5Y2tSJ1rUH+iBIDf?=
 =?us-ascii?Q?3fKc6FcyHUK8VmiVlrJP9kiU4JaHUT5ZPnOjrdGUJTxHa/I3gc3CXSQMkphW?=
 =?us-ascii?Q?Oou9H9C8zvR7VPBGLffc0vQApPtb4n5pIKYvLp06OwlTXxclzMy7v0Hk8h7h?=
 =?us-ascii?Q?GCT8ZrPmPkcTVDPP9XO0m541dLlGLMAVGMgBbnUDrznYVU1JkMeEhI5ss+hl?=
 =?us-ascii?Q?8nvlAtvjncI7Rq/Y27JrG2WyJzNnlqTxKmy5oKtruvLzIKP2L/UPqbgUmuhB?=
 =?us-ascii?Q?TV7cvbEhe5I6gtq9R8nCHCYhKfJBISYVWrKBsVS5Mkt5zHwtjPNjoMdfe8+Z?=
 =?us-ascii?Q?n6MOvNfHBPG5ji9swQA6KyPB3v4gJxDIu9T+AawmZaR9Wa3hgKZsJVvuAgSO?=
 =?us-ascii?Q?PL1DNgKYwAm+fG3DNw71I4MIpNAjY/w83a8s+vDg7qbyoAtySMRI62mpvLan?=
 =?us-ascii?Q?7y4PBCcTBMzyRdcsiva10gk118tmgyw11GngRzoAGAiBcc1mTL5081ku+tjL?=
 =?us-ascii?Q?WeUnS38jkxZCpMdoDcMHH4vjXVA/RoKNsCDSYEH/530N9dCWDttQRx8CP8UB?=
 =?us-ascii?Q?lWH7wMpMhd5xboRqXj0+C9PT+TcENn2b/xeb0Q5hV2gj1eG79MI/7KwlrxS4?=
 =?us-ascii?Q?CHtEHBTH5z3jD5QIp2w0RfXmtBTWy2YKBiYi1ijq/HBLP2xChmzsqMkb0g8K?=
 =?us-ascii?Q?eM9J9eomZglszpOwys8MlmFgVriVdpG10NT1nAC0ShqyLHa5n/1uY7jDwjak?=
 =?us-ascii?Q?m1U4c+XBc2nv5cLQCi6vrUE0j8Xbv40nxRafyCyA7TpuluMo4GBP58U9afi7?=
 =?us-ascii?Q?Fjx/CS6GrGrPIcTGkVREdFSKchqesUFTfG6uVyW93vW6nIi+8OupxZUbtoGJ?=
 =?us-ascii?Q?G5ya6dogS63d+wtTBf49FrPOsYvtjoE8O590P8vHzM+Wv50dNV48us5pRvwL?=
 =?us-ascii?Q?YMxgsmhX2WyogtKE9DNLZu79bOABWuIuBr9CVS4rCQMszqwm2p+GrWNj3kYj?=
 =?us-ascii?Q?StYRGewX8LcNiOjqx3jTCCxY7k0/CFkxoCNB13YsbAaYzRZsDz2XigsIyqCj?=
 =?us-ascii?Q?ac7zHyb2Y9A3MQ6dLPaWC5lgSrJdJU9bnubyBDRIr0b+bo0K+rsUcmQxhTn6?=
 =?us-ascii?Q?jOJuXJS1FvS9C958/4B+Megn4tvQSVKxsdN1Ya/bffSM4gOyypcva4EsLaQ0?=
 =?us-ascii?Q?k1wNab3P8c9h5InrwS2JIIBVac6V73MLWxhNzgkBq+2mfC9mGLvjwndmMu9M?=
 =?us-ascii?Q?4LX5lflnWQ6YyBVlnoriPPDmw8yLyReZJlkBxsBVxk1u8y93bv5M/XExsEi1?=
 =?us-ascii?Q?W0mbqGW4JMOKM51x0yvZoBD77JUZEzcK7cnicxJOipY+HWc2UK3/8BTGMeu2?=
 =?us-ascii?Q?hlmVFR8NJqMqNNAUorD1ylOsNfj+XEk+r6UWp7UkhRGV1F5gngmwRjQJqt08?=
 =?us-ascii?Q?zZs35cpRLuk8DSkAZ11UoQkKWn2S2SYK+GXoRGHtflc9JcfTtLRr433GmRMg?=
 =?us-ascii?Q?hyuJIud9EWNwDMsyyUVkDwBNsS+GkUblJqJ61MvCsiVbHIugnrlTCxlh1S0q?=
 =?us-ascii?Q?bB/GHmqcEpMeeNdeDew=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 20:04:37.0946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 256be12e-3ae1-40c1-a836-08de2c5ddc48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8892

On Tue, 25 Nov 2025 17:30:08 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Take out the implementation to map the VMA to the PTE/PMD/PUD
> as a separate function.
> 
> Export the function to be used by nvgrace-gpu module.
> 

This looks more like a re-factor than a simple symbol export. Let's add:

No functional change is intended. 

> cc: Shameer Kolothum <skolothumtho@nvidia.com>
> cc: Alex Williamson <alex@shazbot.org>
> cc: Jason Gunthorpe <jgg@ziepe.ca>

Nit: I saw "cc" tag is also used somewhere else in the git log. I was
suprised that checkpatch.pl doesn't complain about it. I did test it.

In VFIO, people tend to use "Cc:" according to a search of the git log.
Let's keep using "Cc:" in VFIO.

> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 50
> ++++++++++++++++++++------------ include/linux/vfio_pci_core.h    |
> 3 ++ 2 files changed, 34 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c
> b/drivers/vfio/pci/vfio_pci_core.c index 7dcf5439dedc..c445a53ee12e
> 100644 --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1640,31 +1640,21 @@ static unsigned long vma_to_pfn(struct
> vm_area_struct *vma) return (pci_resource_start(vdev->pdev, index) >>
> PAGE_SHIFT) + pgoff; }
>  
> -static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
> -					   unsigned int order)
> +vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
> +				   struct vm_fault *vmf,
> +				   unsigned long pfn,
> +				   unsigned int order)
>  {
> -	struct vm_area_struct *vma = vmf->vma;
> -	struct vfio_pci_core_device *vdev = vma->vm_private_data;
> -	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) -
> 1);
> -	unsigned long pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
> -	unsigned long pfn = vma_to_pfn(vma) + pgoff;
> -	vm_fault_t ret = VM_FAULT_SIGBUS;
> +	vm_fault_t ret;
>  
> -	if (order && (addr < vma->vm_start ||
> -		      addr + (PAGE_SIZE << order) > vma->vm_end ||
> -		      pfn & ((1 << order) - 1))) {
> -		ret = VM_FAULT_FALLBACK;
> -		goto out;
> -	}
> -
> -	down_read(&vdev->memory_lock);
> +	lockdep_assert_held_read(&vdev->memory_lock);
>  
>  	if (vdev->pm_runtime_engaged ||
> !__vfio_pci_memory_enabled(vdev))
> -		goto out_unlock;
> +		return VM_FAULT_SIGBUS;
>  
>  	switch (order) {
>  	case 0:
> -		ret = vmf_insert_pfn(vma, vmf->address, pfn);
> +		ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
>  		break;
>  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>  	case PMD_ORDER:
> @@ -1680,7 +1670,29 @@ static vm_fault_t
> vfio_pci_mmap_huge_fault(struct vm_fault *vmf, ret =
> VM_FAULT_FALLBACK; }
>  
> -out_unlock:
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
> +
> +static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
> +					   unsigned int order)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct vfio_pci_core_device *vdev = vma->vm_private_data;
> +	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) -
> 1);
> +	unsigned long pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
> +	unsigned long pfn = vma_to_pfn(vma) + pgoff;
> +	vm_fault_t ret = VM_FAULT_SIGBUS;
> +
> +	if (order && (addr < vma->vm_start ||
> +		      addr + (PAGE_SIZE << order) > vma->vm_end ||
> +		      pfn & ((1 << order) - 1))) {
> +		ret = VM_FAULT_FALLBACK;
> +		goto out;
> +	}
> +
> +	down_read(&vdev->memory_lock);
> +	ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
>  	up_read(&vdev->memory_lock);
>  out:
>  	dev_dbg_ratelimited(&vdev->pdev->dev,
> diff --git a/include/linux/vfio_pci_core.h
> b/include/linux/vfio_pci_core.h index f541044e42a2..6f7c6c0d4278
> 100644 --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -119,6 +119,9 @@ ssize_t vfio_pci_core_read(struct vfio_device
> *core_vdev, char __user *buf, size_t count, loff_t *ppos);
>  ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const
> char __user *buf, size_t count, loff_t *ppos);
> +vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
> +				   struct vm_fault *vmf, unsigned
> long pfn,
> +				   unsigned int order);
>  int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct
> vm_area_struct *vma); void vfio_pci_core_request(struct vfio_device
> *core_vdev, unsigned int count); int vfio_pci_core_match(struct
> vfio_device *core_vdev, char *buf);



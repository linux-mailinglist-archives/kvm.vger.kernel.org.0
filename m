Return-Path: <kvm+bounces-24141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3A8951BC6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D18E61C247BE
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B961B142B;
	Wed, 14 Aug 2024 13:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i2KeiFbR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2661879;
	Wed, 14 Aug 2024 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723641915; cv=fail; b=Zh8id4rkRvstQi0oTUhx8Yi1WkNSFLGcq+uPekvjcalTNEActs1cGSYYT8+PHFRica6hQD1NyfI0CKU80LGGptgR4DzeGNIXuxzw2zg9Kj/UiWqujKN7Ze1ed0kUmVJ3BZaXaN0B576bp4fM1Gx8AIzm/sZGJ9Nk1fyPWw85mTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723641915; c=relaxed/simple;
	bh=Va/kxmP31eZ9vrY/EI3FISSJ8OvqITfJy2P5pwOW0C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C2auQG3UFRjtR3fiRB/ty4bM146fMI9ZUJYdAx88igwcRBHdwjc+9dKmwWjZsDdyBBAAJxBP2JEwHYdjJ70yovC8eRnooknBBxdyR0vTUH7kxSrl3MKhhJ8vHKLWmT1YjkjjUFi+TvoZQ40QC9WKWaW1RBZF+WiJcxpOvsCGcJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i2KeiFbR; arc=fail smtp.client-ip=40.107.237.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oP+YKY1wGWNJ4zLArZ8QAM1SMWKEwH8zQInDSg93tL9A5mhURxropkDp1nu31w/JPy2GEs0ACGPtntJ7B+OJsGGQgAVFUQWSd/a6wTz5208EveRe74/2y9H0u4gCIEL8uoOOQhqtR0NlZqIwlD4XWQx7Wky8QVHlFbDjwuDPk2Ok2StNyq2tpIVX7PyokLyJ3PJ6KPmJEDDd6/tDgNRiNZBEotSXBXzRM296RnMX5+GmNt2OOTs6XgNEn92WHkZIRcq4pAmzeoz3+p+SamoGNOI9GEP6IoCXwOYfV7PNuFqFkayuNsrnQTcPvV2PkvzFSrvtE0+hFNPPPorad58EZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8dCAIxcq7s3M72bFICnte7XBmxKHB4NGJWRm0NKs97c=;
 b=P0TytG8aRps0VZkqfp22Mvnt5n59pdeB0Rw4ARnqXnUUnSa5OYM0a0jiVZ+9xeSyRLMFKqDCJrh4ornnmy2oMVGC1irc40nVjaZ4dreG//fC+N1lUG4qsa9G6+7HrI7A1h/AdmEN32KuWfzB3fsjphvYmkw6qKZNYfupJAhOiNxeauqMmp4YncOI0cvTj4uxl+eY5dwErBpNXSA1bzArl+dF/EaHTpTpp9TPtKRAihZ+Gf3JZGEoIP1cvn75E0YhTBlCwzH8gjusAfC2bsH8NO2ggSMJIhz4jTHDqUcqzYkgtFyGrHLlTZnDHzcodR/Qq3YS+Grmr23TMpEJQB/2cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dCAIxcq7s3M72bFICnte7XBmxKHB4NGJWRm0NKs97c=;
 b=i2KeiFbRxGB6JlWz5+I/JcS2DJahjj7lbjGhaKrRLKTX1WGMJjJg4BiMPANHIERu8Wzc1mgqO05M5UGCMgpuEpyHLAlSM2eARp9nr3t/QVxv8wQC2o2lWxLahsofsytZax0oTJ+OlFHncnIIfBZf52DBgoQSYeSLx2RS5dcLQGQTa87YNiyju+YgYtYsKQBnZJZEK8vTbUvl/OmpWcWi4PyJvU63mG/yf2vdd+FXHTN/GyWfk7QO5YNST7PqdXN4nzEv12RKs4M8s3KmOBGTrWkw6Q79b5/Z8ImWnfm1yz56MTL0CQDrS/vJJ1WQ2B4HN1L8rdbE9VsaZ0ZE/Drjew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by MN0PR12MB6030.namprd12.prod.outlook.com (2603:10b6:208:3ce::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Wed, 14 Aug
 2024 13:25:10 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 13:25:10 +0000
Date: Wed, 14 Aug 2024 10:25:08 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 19/19] vfio/pci: Implement huge_fault support
Message-ID: <20240814132508.GM2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-20-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809160909.1023470-20-peterx@redhat.com>
X-ClientProxiedBy: BN8PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:408:d4::27) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|MN0PR12MB6030:EE_
X-MS-Office365-Filtering-Correlation-Id: f81f447f-6369-4aa4-d204-08dcbc648554
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	iZ9UmTV6i+ywThIqGDIeZAtpsG10jiL6wUU2Bpgf3+wsqSJeOmanPSD/LAhaaXVd4wWhZ1tfTAWUh85tCRRsIqtJpMYTdSxG+7qCti394WD3qDxqhvZ0+ui67ELDn2Rj7eTWvnpGf4HGeIf2affRn8iYgT7lXjrayqTKbyjy0d2YyZAOnI87NrdWvJ4GpWq6or3/3w3tdQF73AAAED2T3RztBm1R9kRmHpxJxsymNNxTCqvtHAxhI+11YhTKPKYWQ0k/acaIyUJG54AKv7ZdiM16tg1LDhYf+yDagi/WBG8ORSmzTf1sfg4kyHClx6AfGqLBjm3c8vNfn1Ywz6DjjjkKMBXws2KyJh6ULvdWGC3XczmPiMsCxN4x9YBaqZUqYiCAKECZ2wra+9xrAluq8K3LcQezIwwjyIRTX19XSnONPqWR8I25s78C/AJ9+bwQRDSq3UJvo4wMCQuSjNzDzAXRZQwlt225vMRdIfAhE2JrG9QhgQZeKr33qoWPoZ05PDi1TdPdJpi3vCOq1f7RzgHmY0wqXXOdzC23TXuNI5+8eG4ehXANNZbBeQpgg77OxEL0XfpoOwq7zhsm4ZXD1Il2mpt9XyFD+JNSe2Brg6wsacPUpsOiAAeA6OTzoqfaoCUG5V7z77E2bhZs/zLXhfZfwDvbRz4DfJAm64M+r24=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lcEBDoWpN7iiZJVqx4D11y4GdiqwhsJuJ5berl81TqzknIlCikUQsriTB8ry?=
 =?us-ascii?Q?9ovQVscqCzuoxqdaRVQmj29X2HjpnxkodC+xD+rI/VJ2CRyxTaarGSCuX6II?=
 =?us-ascii?Q?t4FcUP5rTd9+x5dj64cNyrfVn3uLGPYgDa9bNdJxon6E91L0X2MTjEZ5rtbo?=
 =?us-ascii?Q?bEwFxcyMXlE1DZnY26FAqtyadSHk8Y9YWyFviiLReX2rwB1a1ju0lQ//cka2?=
 =?us-ascii?Q?YoOtSTa+1sJOMh6v3PbYW6WQhb/DPy4nbmCCTuiZdkxeqeefz0VCYhbDiSsv?=
 =?us-ascii?Q?P3rT/DSfPYc6EBJzp6nD4YDAMXHRFkvkw827ubu43CR4UlMeID23NUGIvqSB?=
 =?us-ascii?Q?eC/3oAOvnoSn58t9O+Xqx8GYzF9hJL5Yj8VZLoxV/ZUGJim+6Xqp0v4QEAVe?=
 =?us-ascii?Q?8/Taq1lWwichyRzR9askNqu9y9tsxhu8fYEpRNhYTukK5y7xDN/av51bh6uq?=
 =?us-ascii?Q?6feVLpoFxk3+RbZNNxgMX9UiArHJtS8ar2QcJ7vvZNey9TNqMaUzjxRDq+Zi?=
 =?us-ascii?Q?GX4MKd4KU1mXcam0VL073p+ws1Ze/3KCcEy3EP1szaSjCdU3B6lq/ohCLs8d?=
 =?us-ascii?Q?g7Ay3hN1dsa+wKaQEzgVYw28sWhhAQjDvrqDNy+4/FsKYjPF5Q6wcwpj8mF6?=
 =?us-ascii?Q?CmnW6uhDfzHUVHGTFbiNp2b7zBDvMOQNPSfH5HZuiEWaWVtFJbPnwyp078T6?=
 =?us-ascii?Q?2HztarxhaNYBhIiV27Ayjj3kpF8WjoC6a5Vto0YaCXcBYwdwMkzEP7y1Cz3x?=
 =?us-ascii?Q?iJTAxDxuMGXSTokM92NIHJzjzdB+ph6zh/3WSTN3rvCLx8uGc2gao0DGd0AQ?=
 =?us-ascii?Q?731HzPHf/jzI3OEvE/SD7glEsio1oz+gfY57rW0Duv/gkK2qclqpAfdfpbNZ?=
 =?us-ascii?Q?2Dn6jxnei8V5F1WjrGB5X8rQ1nMlakSZDpDN1laXmkCqf/uc31D15x0FUqpm?=
 =?us-ascii?Q?LJXs9s6I8I41Iw5UpZ7ZVfdThzs9lsf1MlYG7v0hfkHDVoqLygn4aTcc55vD?=
 =?us-ascii?Q?Cq9nQtwNofnUzaAhVekGwiHdDB9BfWh4JC80JW0spwViTJFGTnNtqlX9/y/R?=
 =?us-ascii?Q?FDueqHThV0epb+CFt2c7HlNzxp6B0h9mQCxubfnl3YE5UweXD73CW/+tcUnd?=
 =?us-ascii?Q?muVTQ8YC37sp9ypKNUVWAzwZxPbvnGC90ssa/V7qD+iSM0nfu0y6bZ2iWel+?=
 =?us-ascii?Q?RPOT3+XLPazvxDdTRSg5xhZNc1hJdJySN133/qR5fwsnhe/pPzQY/gRvKqE3?=
 =?us-ascii?Q?A5vJ1Nj87KnRqrNpYkE7gM4NY/jnTGrJqoisNaHpY7V0cV1j7wiPnfZX/RJe?=
 =?us-ascii?Q?J0h4b4SZK0aDfQvCfsYhC/J3gVUe8aDcvolp2rNcktLbaUXrB6UYqoDwYg1A?=
 =?us-ascii?Q?jj1fV4yJ9zks8ULDUMy42SfcXPsJWjT+gRs8Cj4NrFtLcuf71kXHlWX6LZVM?=
 =?us-ascii?Q?dZj8CNWogSi5+zc8I0Tz9N7EE49ROuLpwndFv9KN3VMsT5dzFZ83nnwjLUNJ?=
 =?us-ascii?Q?YbUfmEg+UYWFqSsWxrAVSU82dOgyg3olTB5RgOmXIoDmtnwMQxqvbw75Osk8?=
 =?us-ascii?Q?4hWcuIXDXhs+lrOCdEzEmTVJWW2zRna8k2jbvYBY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81f447f-6369-4aa4-d204-08dcbc648554
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 13:25:10.3255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vym4nCza321M4PkZnu5Fs7iu88brUzlG/0UnmAm3WR8DxMwMtOAVlhSAHkj6MoxE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6030

On Fri, Aug 09, 2024 at 12:09:09PM -0400, Peter Xu wrote:
> @@ -1672,30 +1679,49 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
>  		goto out_unlock;
>  
> -	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
> -	if (ret & VM_FAULT_ERROR)
> -		goto out_unlock;
> -
> -	/*
> -	 * Pre-fault the remainder of the vma, abort further insertions and
> -	 * supress error if fault is encountered during pre-fault.
> -	 */
> -	for (; addr < vma->vm_end; addr += PAGE_SIZE, pfn++) {
> -		if (addr == vmf->address)
> -			continue;
> -
> -		if (vmf_insert_pfn(vma, addr, pfn) & VM_FAULT_ERROR)
> -			break;
> +	switch (order) {
> +	case 0:
> +		ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
> +		break;
> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +	case PMD_ORDER:
> +		ret = vmf_insert_pfn_pmd(vmf, __pfn_to_pfn_t(pfn + pgoff,
> +							     PFN_DEV), false);
> +		break;
> +#endif
> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +	case PUD_ORDER:
> +		ret = vmf_insert_pfn_pud(vmf, __pfn_to_pfn_t(pfn + pgoff,
> +							     PFN_DEV), false);
> +		break;
> +#endif

I feel like this switch should be in some general function? 

vmf_insert_pfn_order(vmf, order, __pfn_to_pfn_t(pfn + pgoff, PFN_DEV), false);

No reason to expose every driver to this when you've already got a
nice contract to have the driver work on the passed in order.

What happens if the driver can't get a PFN that matches the requested
order?

Jason


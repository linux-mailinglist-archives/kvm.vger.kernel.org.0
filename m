Return-Path: <kvm+bounces-66662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45358CDB21F
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 03:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BBB18300527A
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 02:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E3829D297;
	Wed, 24 Dec 2025 02:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FqiBkmTk"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011001.outbound.protection.outlook.com [40.93.194.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726B129D26D
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 02:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766542260; cv=fail; b=pdnbfo2BTmBnoLMpcXs0Owv6GCqkeaCKwdeuJ0VX8FIyBklBI/AGT3XXiEwhl1eRvQgglC4Zz46Ry1aExmvzAf5BSnSYpjDWaZ0yckg3Le9tCOx2hoRPYbO1b6gBk0eXXuB8RlBaoIJhmzTbTZyp7n4NYKoX9X1jMaU+HAvj1l0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766542260; c=relaxed/simple;
	bh=6UH2ldVZjygopkxJiiOe3sMKKWIGPt1f4CJxEE+LNtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X44erMSH7JrmD5SknYp49fSLbcrhKYaMu9e9jPpZ0lhAQRP7+4YuUtTcvzwtVARvUpY2PAfIacVs6bw1aFOOvg+48XwWrsQ+8cy9fEoE7SFrjMP6CX6uofOG8JbgGP+pmGzDDkwMEJDCuOn2dKv99nxETjF7YDHYD9OCd9xYS0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FqiBkmTk; arc=fail smtp.client-ip=40.93.194.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WFRwpLOG7xJYQVV9Nap6szVLAQTP+6HNFieUD9Ca2lSuCysCY5YFA6yK0h2fnnOp+oBmiJBCiT2qNEiNDTQ1NRdaVOsMTWf5pLKFKrvbHnaDTD/4vbJeEGN9EfwNbLMCB5TpkHZH98SCWJLTSBRzuQsM8GxdPk8ELyGHp8k/6SB+2FN824VDkvInROAN7FJT8xwrSgH15GKN+IaPne2somuyZmn6/vXEUy4qKNuww/eEzoyau1qJffvEZh60xbfo/hjjW6IO8JDynYVnX1eawiRHlexLRhiOowkmJkwXsoikDILJmO5cySJQ8mazTLtVolZgxeJp5qwXYlheWEKAFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvnvF5SJMw4CP2gwWmxEfIdDMvuLDO6jTpGygTLUn+w=;
 b=YcCY8WA5YlemHirmgZLIL+v8yip/c/oeW5nKnH1o7L/1FvPVGX2sJENgwOLNcW6pWp6xbsHUTZ97HbQqLSNV6ty0t3WWlRei1ceQzl7nTmOzjnJwaSIRUENnFJfYm6w3Cn3ZxKjCI8xRc3xR+k4xtBqqBVsXVodFqQ5DrlBh0gAwjRVzJC92PXeJbuNm3nJ9neNl7th1npbtQKdLGOGQcHON4Pnk2L8XMQkWwMFPPH/oZazFfBxFdEmb88YLXEpYuDvaLHAeEmv0bAszcrlNtsNc7dK9ZKBm9IuX80HqoU5FVy3FLfI5qoOK2x6d+CxIzyLcjUXLPc5umf5cwKbtqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvnvF5SJMw4CP2gwWmxEfIdDMvuLDO6jTpGygTLUn+w=;
 b=FqiBkmTkui9x6Eav9zAN/p0elvzAwzuUIjIMnpWRmPKyQEvleNuAw3iNq0nUlgvKK5BYij2k1AC6VrRg7dkDYdhAwUqZSrukhy6mSxU3/vkOktQqlxuTxyWrIztQJqpq+mtnFiMPb3c8N2xvtCgahDCSp2lnXYWjw8jkqCycFEnBkv1DFrC0S/GwYcOiqkErBbp1NlLcM+Gh74LRbefM5Tb52mcubZ3VFqxvVMjByzzCbAL5l0vE6Eme8eik7ZmoF6KZr+aGAw38uujd/od3E5y1sovRs4tFybfbC84jK04fiZ0J9c9wphIhG+vIEqNaef9G5uNlEBTOxi98qOvbgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5656.namprd12.prod.outlook.com (2603:10b6:510:13b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 02:10:56 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9456.008; Wed, 24 Dec 2025
 02:10:56 +0000
Date: Tue, 23 Dec 2025 22:10:54 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: alex.williamson@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
	seanjc@google.com
Subject: Re: [RFC PATCH 1/2] vfio: Improve DMA mapping performance for huge
 pages
Message-ID: <aUtLrp2smpXZPpBO@nvidia.com>
References: <20251223230044.2617028-1-aaronlewis@google.com>
 <20251223230044.2617028-2-aaronlewis@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223230044.2617028-2-aaronlewis@google.com>
X-ClientProxiedBy: MW4PR04CA0288.namprd04.prod.outlook.com
 (2603:10b6:303:89::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5656:EE_
X-MS-Office365-Filtering-Correlation-Id: 944ea8d6-00be-47cb-7beb-08de4291ac5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o9GlE05cPCboGmuH2WubThxAqj5L90o++Dzuf90veQNMLPBPKIPEwcSzhgDU?=
 =?us-ascii?Q?BjwsDXhSqDGN1EoRutPu9vMKestXt+AN0t4xIa3qn1aRYCwzOKMSszXEsYkB?=
 =?us-ascii?Q?VxUjHVVsgj9mA4rtJXnwILt4g+snJCYNjT1aREjlWZhcZFbVt3YOqYdoSqMB?=
 =?us-ascii?Q?aebI8VkIQRtWTdYj8PmlPWv4xl6/46oZ7WEpPqWTc/eSQVFAKWOK3mCZQgV4?=
 =?us-ascii?Q?CZCqaDmGrB7k6K8AbO0Mg9NUjhm/hsrgUpUgUpfAOq4zDc2mVGqYCNXF2r0g?=
 =?us-ascii?Q?LV/rS8RcmHxGc6YIO4JVDaz5ZnpQ2EE1Ie/kKEdHqzgMbGbw+6HgggPX2e0+?=
 =?us-ascii?Q?mgA/4D5Q4omnIoxNwN/Mjbf+W/5tZE/ZKyC+x/BBTp4S3wf8H89QZIZIiSe5?=
 =?us-ascii?Q?SV8CS8oXw1Ln2YkDzPLU1zntmzEMce+E4b4PGF5wzQDRn7+bx8hROx0jT1rb?=
 =?us-ascii?Q?b7sMzrV4I1EJwpMxpnT71i7sea240XjZobjsk0mtrbGq0uMHzfwfSmDRU+pZ?=
 =?us-ascii?Q?dn6WQ5jfp9DdqBJMnOmT8u89ZU86tTh0gaMQdaPn9xkpvQutYXg2SsisSGsz?=
 =?us-ascii?Q?/kLk4urLkitVIWZLaau21Q/hbH/XNSlQaVMeKJaw3dUFnBdQ/SEzOohzc5IH?=
 =?us-ascii?Q?wIZRqOwAZ55SKkSQp8O2izi2ZkYFiYpe+NfKdkDKHRmN8IvlSkC/6SryGAvv?=
 =?us-ascii?Q?oAcH0Mb66XDY5vvU8DAny2lemgMnhNpQshcNO84SYBTb+uFlY1n3CUeb8sWC?=
 =?us-ascii?Q?vThEgOkxUI5OHSkQBph1ePKiyr34IacVIJ7vCySaU/NrYpFmHlumEawl7Jm0?=
 =?us-ascii?Q?gM0odjGbtDToIul2lEM5D11EY++3DHlSApjyUMfAeT0RI4InPTyGZql0TU3L?=
 =?us-ascii?Q?oxjs/dbCFpGkgwiuR3Q5SF9xNCcbK1cmO8Pzs/1CGWOKZ5zxz4Y4Rnn+WCM2?=
 =?us-ascii?Q?tquBbIFZrSdT6vJRSQYsN64ojazl7cUNM1robali2AsTXzJJ8nNjqIV8BA1W?=
 =?us-ascii?Q?Y5wIYH4Ag49G31+T3Cav7BMiYjSLyAT83eERULGjDWUStSG6MYPaCZ6ZIVc5?=
 =?us-ascii?Q?gnO9kVa9UtZj6VCpy23wGN1GAgsxbfm0BhLEzBO6F6AeyzlM7DxmLQtGKNbr?=
 =?us-ascii?Q?lfK87E2nXeoOFhDYW5jUzVRL+yMBOmZj0Hj3PhSmYHQqe1+MXbCASV5KaQQA?=
 =?us-ascii?Q?EcHEFPMav8c4EFOGpeq5usS1KzsEo7zlrRaL1wkPUK62F+z3igzvAeBzUB2v?=
 =?us-ascii?Q?ZB2gO0MdkAq5GFZPG+/nQ++u/XLQPQ/qZck6ckc3KL1oVGupwAGqk7ET04iA?=
 =?us-ascii?Q?k2cFM6gBxzegZKunpKRE4Q2eOLtXaf2/SgoneYvnw2t3OWZrp47e5VP2rH2b?=
 =?us-ascii?Q?r7cH76lT/P+YrhFsIuFnFIDcj36c0O3RLh0KyTllJHHB504xYdpfDD+GOICz?=
 =?us-ascii?Q?qcThmPWXj/YPaMN0sd5zchziw+BmVuig?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U6UE/Az3wtHibd6+2KlDgtUcnmFhRHq5LXcNUI1oP1Nkm+dxajOdSvgr9ac8?=
 =?us-ascii?Q?SdxLoC/ttZHRta9LonV7CbwkjRIsPrCdBNNvP/0R/mylEEMCFqpSsJALoxgf?=
 =?us-ascii?Q?Q/HHmLB7jUFP18d60c5kqFpSihM1xxBzohxmsvgH9FzIEPuqoTQXuLTCUlZL?=
 =?us-ascii?Q?xJ3Iu7u/lNo2RBOPdOyjDFJ6muwTE1qVeOJ7ipoT/jo++ugCYKOJp4Ztq+Kx?=
 =?us-ascii?Q?QHjtgSp9NumGhdoNK5nEnw5RpCla31lrJCAd5DYspezWoO92yefYOzSMH6q+?=
 =?us-ascii?Q?z5SQd/zJWcEUT2WcCI6j4GRSu6aDu6TEBzOWoT4mSUjOjRr/6+F+zaD03d1p?=
 =?us-ascii?Q?AognU3ALgS19j1d1LziQvJwpRv8piISOQnyH9/gZ7GHbwAnZ/6uKlb6wb8tv?=
 =?us-ascii?Q?C4/xrA5FYfbdrElyt1gUby52y4/vNp2+LsPXRXXbNRPQOBS95uMAZmVXaKEQ?=
 =?us-ascii?Q?UJOXhaZxTO4IVIC0jxNZGXUdKJozowoSjKgFzXHtEjIFWpsUy2wCDB4DZInS?=
 =?us-ascii?Q?L0lFXJy0/borKuyK+og8YEP0sqewMrt0nIxb1z65bZEseAy/+so02Wh0DUEV?=
 =?us-ascii?Q?suVDYkQgliqB5ZBKbQBFIKsXmxb7BH+6DnrILiFYQ1vpfgCcuYiatTnl7I55?=
 =?us-ascii?Q?kG9v0BbPZmsr4paAyav21iR1ImDfM1tq00SS0hNz46+Qo8ExVQACnWVnGDOI?=
 =?us-ascii?Q?LysmRUxTUqd8sQ0lC2gVP5baJCNxj+skley2XcAfj0/mcAAOZdHDkItoMpZS?=
 =?us-ascii?Q?P5/ykBnDzIY2eXsWSwMjVgNmuAP7/4vdoQC0TPunCMRFXl6oXOprKDPUxo/p?=
 =?us-ascii?Q?+sZlZj/924IyBdDHQuXqYmhGeorz1C52xlOg8MbQy3zVORjJaGzdcnaRzGcB?=
 =?us-ascii?Q?qAQhxuThPYYIJsD28DUHl+cCONBdVY16qj+OCdKFa0vIsYBjBheO6yDEGn8s?=
 =?us-ascii?Q?309UbqhAsIpRtzfO3FNo1vzBmQybv1OTaM5RZkohePMXbHc5972wWzAErMoe?=
 =?us-ascii?Q?A8qYf+kQP1yZHf0P8glHKk4ApbOuvdExXm5EA9Qnc94mr72/DEGWhOP4poq6?=
 =?us-ascii?Q?t3IlJQ3ZF0fKR4w03Y4FEtmkiUCantU3AwHBo3A1iyJHR5gU9liL7E5EZpfn?=
 =?us-ascii?Q?cFyyMQeLQXFW9SKuW6q3+Bd6ZylxNuKHCSOHVsZN/Oshj5I+bTR4OUofPw83?=
 =?us-ascii?Q?aMuSWTXIHheXrOWRwaqm/+3YCsdui4SBrxz5//5HNNuQerXEUjDMVCt7I9bn?=
 =?us-ascii?Q?4hVvvQH+1+OsPfUT8UWFsXzHnX3tWH+wWFbEi7l0LwOU9veRGGBnh8Dqg0NW?=
 =?us-ascii?Q?n8FQhy2The6OwY2mXrR8m39MK4fZAsHt++qV5RHW3FlvLCjbDmQYeVzB/xBf?=
 =?us-ascii?Q?KBCd+CJtlTDYOLrmvaDpQosQHfYfctMyQnFbMJDiFeCWxHSPsZqGlDqC6PbX?=
 =?us-ascii?Q?0h0rdQO3pFeySkpYqCizRbQrQWP2nzO1+vCJARFlFbXneMbdCCPv7mdSoOM7?=
 =?us-ascii?Q?j6OnsczDQh8MbnHxB+Bc6Qo6z5PxkGoirkCt1cmJ/Ap2kNPeSckPy9oSyCS5?=
 =?us-ascii?Q?G7QbgZfHHnDXFmfTmlewCVmfxgKXQVIIPObvIIHQ2AxQsPSmVpAUIMGlNWFc?=
 =?us-ascii?Q?ADjYO8fvjJTpQbSFeqxeSX8SU0sLseAatCFZq6nuOvt/gxFGRqoWk+hH6SKX?=
 =?us-ascii?Q?kcDVntR3dZQCsRDqXzF+YwhN9N2+0dYK+xE5t48IlXMuxWJf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944ea8d6-00be-47cb-7beb-08de4291ac5c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 02:10:56.4559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S75hk8ZdEm9/gvAUgdI+ojGNA7XJ09FgHrOi2ZwfgYZXcaDe8pv7aaixSWkRwq0B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5656

On Tue, Dec 23, 2025 at 11:00:43PM +0000, Aaron Lewis wrote:

> More effort will be needed to see what kind of speed ups can be achieved
> by optimizing iommufd.  Sample profiler results (below) show that it
> isn't the GUP calls that are slowing it down like they were in the
> "vfio_type1_iommu" case.  The majority of the slowdown is coming from
> batch_from_pages(), and the majority of that time is being spent in
> batch_add_pfn_num().

This is probably because vfio is now using num_pages_contiguous()
which seems to be a little bit faster than batch_add_pfn()

Since that is pretty new maybe it explains the discrepancy in reports.

> @@ -598,7 +600,18 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>  	ret = pin_user_pages_remote(mm, vaddr, pin_pages, flags | FOLL_LONGTERM,
>  				    batch->pages, NULL);
>  	if (ret > 0) {
> +		unsigned long nr_pages = compound_nr(batch->pages[0]);
> +		bool override_size = false;
> +
> +		if (PageHead(batch->pages[0]) && nr_pages > pin_pages &&
> +		    ret == pin_pages) {
> +			override_size = true;
> +			ret = nr_pages;
> +			page_ref_add(batch->pages[0], nr_pages - pin_pages);
> +		}

This isn't right, num_pages_contiguous() is the best we can do for
lists returns by pin_user_pages(). In a VMA context you cannot blindly
assume the whole folio was mapped contiguously. Indeed I seem to
recall this was already proposed and rejected and that is how we ended
up with num_pages_contiguous().

Again, use the memfd path which supports this optimization already.

Jason


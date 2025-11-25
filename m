Return-Path: <kvm+bounces-64562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 838F7C8710C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 23EAD4EC55D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D76286D40;
	Tue, 25 Nov 2025 20:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CTs/Y68m"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010063.outbound.protection.outlook.com [52.101.201.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D9636D4E6;
	Tue, 25 Nov 2025 20:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764102636; cv=fail; b=QrmY6O9mHFQrZgMEf/mN3gV0KamRE4ZdWYue5rTVFbhQx0zvvOIhvVvteP+mWpkw3HPCXWLUWl3yTy2FTwGbgkTdf7BEQhRv1fCG0JHsfvuqTnD2NoLl1tLHiKvwJ76FKkcN4XVzi12auRYeoA3Bo4mfW1Drn/F5R8VXdfGDJ4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764102636; c=relaxed/simple;
	bh=lHxiqkzvYWLm7bSAraenJvsv7WjTzlN8w57nl7CMZdE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fTN9yx0qYIqn/DqSJQm/lFbQKV1wxjQRTC6UnqK6AQdS4X71XXytKvLvjfd1KPDIlwjLPVTTrvL7wrqQ9XSZINPZHAbEdQtZVdow0shoGYxQp5G8R4KM7po/vUcZwleDr8aefCV9mM2Yhg87ZNsZ6pFc0a2oHSh3VMsqvAS1S5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CTs/Y68m; arc=fail smtp.client-ip=52.101.201.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TmACLkE9FxOC5Ev9AGvsEP7jpwQgHGzyj/J5lgPizk1Xyt0qvydUeouxox9232EWsc6P8IGLX0x+eX9hBxdXh886bBhru0vUR3qCJsD5x937BqfTSAAWOE6GRceZEmugMDuE8HI6FmW2Sw+/pQVTrZKJvDI9NJ+p4hG7N1KiijzWOG49OCmn4mNaiI3hRgJE6o5dJePxLotl8GDp7JuLOJSeRU90BfTZqya2jFlUDQD6wt3kggW/0LqtbSG4T3oSVKk7gc28yHIXTEltVQrzuw9kgBaInKfuZIo0uULzRhoRrLnt3nlzjcbto0oN1q3l82Y7xIH13pG+YypZGxM8Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Moluo+VZe+2GfWhppXHJhWMkFabX0VqIv25/Th7Y6K4=;
 b=R4OyxTXa91+LQteOGReAIeGKRNDCCLYvNmVARGFBV3s7IW+XszLdcZXOtblP3uckP3aIQgGqmhSp1EjvBdszjMH/FN/M/qYSZiEwSkvt9DqFB7+V5c7mWvQ0PQwy15xbk/cXdvkcDNwwjK1L/S/xUG/AIdTS70Z71fG9XcAPp0MI3vnZfvoQePQRf3EPZ8aMVEe5E0jakxhUoPTF0CvnQzIMoQ2HwoMLNIK9QKB8x8KejVS5wHtp8EBovkO2AbcqhXd3LU5v7TTDt4s4SIweDz8z5OyI3XE2NKJ6a8ok/P3BzDHVmJgRwQjIiGh5BPgDrv6bv3sFIPBYHuB9cnRfSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Moluo+VZe+2GfWhppXHJhWMkFabX0VqIv25/Th7Y6K4=;
 b=CTs/Y68mVJUDBtu1mK8oDFLhIhjFnZJrpHZaOfLMv1oGv4yI/nZI4owyQjoxwsgLvYx0DjyJEr4eJcgZ5GLCsOEgZ1T5Lc1AeGyzWeKqlhAT/SPk2zAABmVD5kFoPccQax1+X+vvQjoOERvUeqvk9p8/0Z5HgadvZqAZQntiecnmb0oZ4WQ/MlPykmpl1NeOoovr+LkxusVF5EZSIgcB/ze4qQ4674kaGkOkCQ1KmlUVVuIvWJvN3LHWX6Xn9CAI1XNcxVaZrK2Sds4R8sLj/Kfw0qUFODX10JByQKFJZKQt7ZEd+LxFShHnen3gyQfB+k8QUuY3eNw4tBPyEQNYjw==
Received: from DM6PR07CA0116.namprd07.prod.outlook.com (2603:10b6:5:330::13)
 by SA1PR12MB5657.namprd12.prod.outlook.com (2603:10b6:806:234::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 20:30:29 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:5:330:cafe::fe) by DM6PR07CA0116.outlook.office365.com
 (2603:10b6:5:330::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Tue,
 25 Nov 2025 20:30:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 20:30:29 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 12:30:09 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 12:30:08 -0800
Received: from inno-thin-client (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 25 Nov 2025 12:30:02 -0800
Date: Tue, 25 Nov 2025 22:30:01 +0200
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
Subject: Re: [PATCH v6 4/6] vfio/nvgrace-gpu: split the code to wait for GPU
 ready
Message-ID: <20251125223001.7d05d834.zhiw@nvidia.com>
In-Reply-To: <20251125173013.39511-5-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-5-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|SA1PR12MB5657:EE_
X-MS-Office365-Filtering-Correlation-Id: 0209bdb3-3e6f-4ee3-0ead-08de2c617968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Iw8t5MPEiNWbN56i3RrkGr4EQjKClX58k9JOiezhiHuN4E0YBaVpm7zeX21Y?=
 =?us-ascii?Q?+//S0nPPFNb0LnH/7BJGYgZJhE07PfEOtTT76RPIx9CmPSMpVqBWYW8dToTQ?=
 =?us-ascii?Q?rX7NawJCg5V+W4wG9rm8fl3IGYNqTyCIjyr2xk8l45g8vf1JpwBZTLbJcv4G?=
 =?us-ascii?Q?1G2cCF4sGXTMJrHk9qT6zd79+3qno3H9ki6YNEEQB5WGPNpvHMpx0Y7o3Nvs?=
 =?us-ascii?Q?1Qyr5omo7HS/tYVwWoGJLmXTqVQUxH7jaTIsoY8Cbs1sLQ43q68WdXFhjqUZ?=
 =?us-ascii?Q?P5O8HOTH/zJdroosCcj6iZMWP1M9bMDEHdjYEo7WVu8bUjBTgKbz0U7z+qcF?=
 =?us-ascii?Q?laUXShg7o8ukCtdt6vV1mMudf2Kxtr0sbklrNutAKI9cOPYKf8SGsUJzzjGD?=
 =?us-ascii?Q?OouHp6NzLXI+ou8HoPnW2SBtUZ3bInX7NpSF2q4p9N1+a5XzWfc4rCcPb4VM?=
 =?us-ascii?Q?kXVJaYFE2grihmHmno/8kI9FuizL7chk6P4yPn9RZTx+ngyonuM0JXd9tvkv?=
 =?us-ascii?Q?C2LsXah447wAm10LPKTU8qrZy2rz3Zz+fZdi7zjc7E+3k9YSLfQ40vQXqcc+?=
 =?us-ascii?Q?UtQSoPRT90BkMJJU+NX1m3JkyV+0EYBfvBlHcT1lKd3UvnpbzUv9D4Mm9zux?=
 =?us-ascii?Q?5A4Gqst/v5hNEfmfBao+BGUzBs5YS77yrJjrFJDWsNmbezlUvCTQJXul19Vj?=
 =?us-ascii?Q?GadHKxNDY2CxIB+E/6wZnlRoxMpcQ53HZ7oyYP7sqsHniIiKpyTwhBtRPWu9?=
 =?us-ascii?Q?LkuGCtV2LRbhdwCpVenwZti78gHZBIKIttWRptoAXjb9+2vs5kRTu19STfNt?=
 =?us-ascii?Q?GKBaYMRGlcL3Skk+L7DbZUP6U11GCd1xYnPZBd2sHHm2kq5t3+UgCBBUJ+Mc?=
 =?us-ascii?Q?duB2S1kTXr99BOUUSLzLerxiIjktAJE97wS/K29l8fsA5uubRIWuEotMsxKM?=
 =?us-ascii?Q?KAl40PT7Sz8sre3sv1RBaZbTwUwNpYdD74R5FMhVl9t0oBcE/Am/a5U7dRH3?=
 =?us-ascii?Q?ZIMMPGi8OOKv2jFdaihe8JNNv/s/I+/z7mDTfCA5i0D18vs+otU2x5sOZZ/s?=
 =?us-ascii?Q?m/B3jBrgaK/cY4ekjagsRlHWcaQ4DlCzlSHo1Te4ItFSU+bxqCi/3faub3Lu?=
 =?us-ascii?Q?1aC5wmP95EdzPOmvoA7uHDpyC70SLlZlPv7uT1J/VMmrbI1bZUU/4FguNEYk?=
 =?us-ascii?Q?94VrXc+R0ybC8mm+SMqJFQcUulqR4bHNEKHgnkp09nbJWMrPcqmixycTAMxW?=
 =?us-ascii?Q?AgB3ZacOJXEWprlP98oQ24ElKfN/UpzOdH1SzlHWZGUVheTEWkpOOZ4+5/od?=
 =?us-ascii?Q?o8sq9EGi3qFFcTazXUaW68Op91dIX5zHT5wTmihVWN38WmeUBg/EQHBDH0Nt?=
 =?us-ascii?Q?j1Zc3DY3+5gN2yYCc+uj4613udzmBGhIERgBGIDax07QEER+cl9OtfxeRm9Y?=
 =?us-ascii?Q?C957xJ+PmEmLYYcVFHu4cpTdH8SiLMQwaKoFEETjk+y3S8OLuCjF4qQ9TTfb?=
 =?us-ascii?Q?xgp07V0Auvsmzyf1JJpgqwFp6dLw5wMswHkMz4oQURkFJseE3+wIP0swEkwd?=
 =?us-ascii?Q?50xk0MxUGFdQN4gLFTw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 20:30:29.2236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0209bdb3-3e6f-4ee3-0ead-08de2c617968
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5657

On Tue, 25 Nov 2025 17:30:11 +0000
<ankita@nvidia.com> wrote:

Looking good to me.

Reviewed-by: Zhi Wang <zhiw@nvidia.com>

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Split the function that check for the GPU device being ready on
> the probe.
> 
> Move the code to wait for the GPU to be ready through BAR0 register
> reads to a separate function. This would help reuse the code.
> 
> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 29
> +++++++++++++++++------------ 1 file changed, 17 insertions(+), 12
> deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c
> b/drivers/vfio/pci/nvgrace-gpu/main.c index
> 8a982310b188..2b736cb82f38 100644 ---
> a/drivers/vfio/pci/nvgrace-gpu/main.c +++
> b/drivers/vfio/pci/nvgrace-gpu/main.c @@ -130,6 +130,20 @@ static
> void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
> vfio_pci_core_close_device(core_vdev); }
>  
> +static int nvgrace_gpu_wait_device_ready(void __iomem *io)
> +{
> +	unsigned long timeout = jiffies +
> msecs_to_jiffies(POLL_TIMEOUT_MS); +
> +	do {
> +		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) ==
> STATUS_READY) &&
> +		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) ==
> STATUS_READY))
> +			return 0;
> +		msleep(POLL_QUANTUM_MS);
> +	} while (!time_after(jiffies, timeout));
> +
> +	return -ETIME;
> +}
> +
>  static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
>  				   unsigned long addr)
>  {
> @@ -933,9 +947,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct
> pci_dev *pdev)
>   * Ensure that the BAR0 region is enabled before accessing the
>   * registers.
>   */
> -static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
> +static int nvgrace_gpu_probe_check_device_ready(struct pci_dev *pdev)
>  {
> -	unsigned long timeout = jiffies +
> msecs_to_jiffies(POLL_TIMEOUT_MS); void __iomem *io;
>  	int ret = -ETIME;
>  
> @@ -953,16 +966,8 @@ static int nvgrace_gpu_wait_device_ready(struct
> pci_dev *pdev) goto iomap_exit;
>  	}
>  
> -	do {
> -		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) ==
> STATUS_READY) &&
> -		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) ==
> STATUS_READY)) {
> -			ret = 0;
> -			goto reg_check_exit;
> -		}
> -		msleep(POLL_QUANTUM_MS);
> -	} while (!time_after(jiffies, timeout));
> +	ret = nvgrace_gpu_wait_device_ready(io);
>  
> -reg_check_exit:
>  	pci_iounmap(pdev, io);
>  iomap_exit:
>  	pci_release_selected_regions(pdev, 1 << 0);
> @@ -979,7 +984,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  	u64 memphys, memlength;
>  	int ret;
>  
> -	ret = nvgrace_gpu_wait_device_ready(pdev);
> +	ret = nvgrace_gpu_probe_check_device_ready(pdev);
>  	if (ret)
>  		return ret;
>  



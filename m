Return-Path: <kvm+bounces-64555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0272DC86E94
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 723DE4E97A0
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCDC337B9A;
	Tue, 25 Nov 2025 20:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V0uiwL7v"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012055.outbound.protection.outlook.com [52.101.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE7227991E;
	Tue, 25 Nov 2025 20:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764101118; cv=fail; b=QWMDd2MnrRmpL5ZXwESLnqGoK8cBhfflxsDPi+Y4p7qeHagzgMVfKTxK14nM4+/x238LV9uPPzcZAmsOEFNLI3ONOFiEn6peb+iAPB+z9jGIUA/meMazzUcYq53nipnyvF7fhdkdfYdvMWuONNosGkj18nsFYtPbeqaGi3x9jMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764101118; c=relaxed/simple;
	bh=2wtD6JQ4Y4fMeOSqv+S3O3zwdjhgI2nFQcn4jj3+lOw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IH/zQOM2d9fr8np9C/MlDAxqc4GS97MOMQZe9xoFSgpDsv/z0gKEwkr/+41c38ATX9GTbVdzSy41EjxoCKQoGhif0o5ey+6lkQD0X5PMgecb29e09BBjHeGmuoLFjFcQShpQlP+6OYtuVWGNOpRZOnDB9qHxhNdFx1wOc1a1R1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V0uiwL7v; arc=fail smtp.client-ip=52.101.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hzE4994bRgCdQRfM0XyEqo1YwW+VHie7YRpHiWSP1Hu0KQrFpF7mcN/3sfOtI6nj+2R+MW9hK/rkdAIQYDbPiOARO1lBhu6T5h0jXaZ1fx41EK6QT5ttbp88i/z+OOeGFHphVZNdP02ptmWwiHO2rjwz8tc41pdpo7QP0gAfK6UYVdi5dIuMQcsTaARY/jp6YCnRU5peu5qDzl5yHcY52f/DjmkMjm9DRlNGO0dQuvj25qAewNFoQB4EGUgUF8vv+O90RR77vD0cCjSVOlLCnTtyPPkQMCNXNYemugyxq9Q3/65muu6NsJEiWcdf/dV6k/Cj2scDeWGQ3vwG+hidsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgg3Xw3lgWoqcisv9Y0Z34eSL9XxDYU9M+X0flyd61Q=;
 b=kSuzeh/XP9BR+GVsH9wS+0Hkq8SbDfkW4kSEkghfKSrTXjSAG2HTD4XVErYdnzxJfW7Kz6yDqHsD79toZ1GqRlzYCZ8QcxdyJB/8cqB4oCX8XeokC1MnpoqqW1aykz56ohpwkCdjPMyWUnqsTV/8bILMOdi5HH4lORvaXpYFd5mGAv0yIGKloEjwJvDZAjYNFs53VePAw/gS9578lwC51IhuQVJbj7agdLLYgVB6sqj1PUs2v3/LG3ROSf0GSGQ7QgspkfzVHO0teS9R4dP1cwtohacQnd0XMzphF+dfZ7xq5DTE42qwOAHvKUpMwkZjcEGBqjzZQ5qjYgNxo5bKxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgg3Xw3lgWoqcisv9Y0Z34eSL9XxDYU9M+X0flyd61Q=;
 b=V0uiwL7vucVzo34jH3BppC0vNzYWUy8QaA2JsIweTEQOn37Blger42wLiKbNKX5eEew8wz6vmxDif2mI5wKegdTuHLXrucssFOrqDgmaQHbZ4AN6V5ryMJRjSzW1ZBRPFhhH3k8kbkaCvitM89reXC9Y1qwu2eSyGA6ynNymOr8cqOi52z4pRNRbUb7gA2wjEEp0PonfST4bTtdA64Ri6g+i+ZGBpPOa40Ious1VI6/sb7gW5VwohaSTPkWQQVvhpdN2tmBbsLMYdsb4MJXeLTOHAGDkX6e4Rr3juROF5MM4ssBXlWRif3L/kLJvs3M6j8opHvjIm7jN/ofIGZcZOw==
Received: from PH7P221CA0062.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:328::6)
 by DM4PR12MB6469.namprd12.prod.outlook.com (2603:10b6:8:b6::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.11; Tue, 25 Nov 2025 20:05:13 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:510:328:cafe::d9) by PH7P221CA0062.outlook.office365.com
 (2603:10b6:510:328::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Tue,
 25 Nov 2025 20:05:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 20:05:13 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 12:04:54 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 12:04:54 -0800
Received: from inno-thin-client (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 25
 Nov 2025 12:04:46 -0800
Date: Tue, 25 Nov 2025 22:04:45 +0200
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
Subject: Re: [PATCH v6 3/6] vfio: use vfio_pci_core_setup_barmap to map bar
 in mmap
Message-ID: <20251125220445.02a72453.zhiw@nvidia.com>
In-Reply-To: <20251125173013.39511-4-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-4-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|DM4PR12MB6469:EE_
X-MS-Office365-Filtering-Correlation-Id: bc2273ef-5132-4b20-f6ae-08de2c5df202
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DoYSdK7gKGY2vGhdP1Of5DZz8ZDRadgGDl9MhYcw1RbPzH5kIHFXbt9xPdV/?=
 =?us-ascii?Q?xYvuIBoh8nbWAwbBnrnN1W096EZ9Iel7dW+zguans26gOcMM5EAXZ60ORu58?=
 =?us-ascii?Q?w1jk1d/JN1A3yczBVuPbQ7PNFE/lUm6NuG67k1tY2h2Z/NV62zN28k5FOzfh?=
 =?us-ascii?Q?8tt7puMlpnHH2qRLGH5QXkB3Pqc5XBXacZWCcNTfHwOsztCfBXB0T0mcA42f?=
 =?us-ascii?Q?AekSaaI468cltKrcXLYZHF9CSWA8P9ZY+7dEMc4R3bmMgFJthLXKfS/kG9N7?=
 =?us-ascii?Q?+/10GjAy/VnNe0yTdVj54YIpYLFP5Sx5EY6l2SQ8Jv7HBzB6sjq7kvspLLdZ?=
 =?us-ascii?Q?8uaM4idu8+rbICiELAcX/4UH9WsGo/jRc38KoIkADvP6xQs8I9MzL+Lw+1Rx?=
 =?us-ascii?Q?pL5WSwOAunxVa0Tb/wpw3O7l4EC33L4GIIqKtJgemehF6mKjh0hCbSkKgT0X?=
 =?us-ascii?Q?qfxC+liAYvd6w424PMxfj+urrkaLNKshWfDwYKOSycFK8qrGT302sh27m/9V?=
 =?us-ascii?Q?AS0Caiupuv6moprxFi7Iqv2sxv0VDP6rw1eIFA0Xzy8NUCaGZWjo6yUgogjy?=
 =?us-ascii?Q?+3KYip1dDSIViohYwZ9LmHgG/sVdiC/9z6pFzcK/mcZLMFOr/+3PugZSHOJ+?=
 =?us-ascii?Q?P3AZI7VENxDGaAkCWwI/s1tkAl2NlvZOEr8D2Eopu7XW9f9V6ZnmjM4JRayi?=
 =?us-ascii?Q?UyKzq0FgJ7TaORuaBGnqZ/MEgdJ5OfxJxWWr4gISdxAFAjvivSwdTuR2+ixb?=
 =?us-ascii?Q?itcxGdCAHpFMiGiSylUP8zjRNOODoqPmJ47akbwX/xnLdG5HUtA3qYQkZ+Ut?=
 =?us-ascii?Q?Tm3meLpxQXwdQJ2Pt363eEfWgjpmXuAMLsqkdFBIbYvWlMb4BRvN3w8Rzyz2?=
 =?us-ascii?Q?jV8M59dVGf/LHAj1GLbZP8sNB5Jdl8MSbS1fcKC5rfHKM5lqAQ6KvBl1V3jY?=
 =?us-ascii?Q?FNfOoVJXB95YSgUiHwSUL5joq3SdS3j/2+2YO35MMHdsq+7kLoIXCfJTHm/J?=
 =?us-ascii?Q?amH1MDpxrUXzTwDHist4xy/IscP4kxqJ/IfkJisCvHJM2HVo6XTLWEcgEgn4?=
 =?us-ascii?Q?GnlvAg4IdTPgr7sDb0/cQILtN/8vozszVJmi3LhMBMBhSLUUHScoDMzMRlYC?=
 =?us-ascii?Q?EX/zDGiHxOx0lWFSXETTfssYHgO87G7yhWtbOuP4FxFXWyQjLuIKBYVCLPgr?=
 =?us-ascii?Q?r2lnE+63BBdbw6yroX2F9OeRiUl23GJuQUk6VVMFxCgZr4Pfb2DV2c0EI5bo?=
 =?us-ascii?Q?7OvDEd7Iu65rqPIdolqeCj4FKdhRPYI23+7HKBOvEm9SK7ILQdh81DycoLxZ?=
 =?us-ascii?Q?jD59zpFx8uCLf6TQHnHKjdcFaEGThWrAJzzOwlX6kGDugn5Gp6OmTvf7vj8n?=
 =?us-ascii?Q?8O086he7qKT7VvFFjAXhnjt/9NcMJKSn399pJxvTLUwm0jYz9HHsai50wTzI?=
 =?us-ascii?Q?3uzTD0Lttr/WsSE2BFa4L6MjTJlGIug/zYNM1CImrccPjqha7EFwca3UTeTj?=
 =?us-ascii?Q?iMpvEpljASh24aTtg5A760gPqBQMB3bhiebi1SPQpLTQx5YC5BkKk5A8cDpt?=
 =?us-ascii?Q?UQoJ5p9LVqx2rboeYq0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 20:05:13.6187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2273ef-5132-4b20-f6ae-08de2c5df202
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6469

On Tue, 25 Nov 2025 17:30:10 +0000
<ankita@nvidia.com> wrote:

LGTM.

Reviewed-by: Zhi Wang <zhiw@nvidia.com>

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Remove code duplication in vfio_pci_core_mmap by calling
> vfio_pci_core_setup_barmap to perform the bar mapping.
> 
> cc: Donald Dutile <ddutile@redhat.com>
> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c
> b/drivers/vfio/pci/vfio_pci_core.c index c445a53ee12e..3cc799eb75ea
> 100644 --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1761,18 +1761,9 @@ int vfio_pci_core_mmap(struct vfio_device
> *core_vdev, struct vm_area_struct *vma
>  	 * Even though we don't make use of the barmap for the mmap,
>  	 * we need to request the region and the barmap tracks that.
>  	 */
> -	if (!vdev->barmap[index]) {
> -		ret = pci_request_selected_regions(pdev,
> -						   1 << index,
> "vfio-pci");
> -		if (ret)
> -			return ret;
> -
> -		vdev->barmap[index] = pci_iomap(pdev, index, 0);
> -		if (!vdev->barmap[index]) {
> -			pci_release_selected_regions(pdev, 1 <<
> index);
> -			return -ENOMEM;
> -		}
> -	}
> +	ret = vfio_pci_core_setup_barmap(vdev, index);
> +	if (ret)
> +		return ret;
>  
>  	vma->vm_private_data = vdev;
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);



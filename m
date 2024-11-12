Return-Path: <kvm+bounces-31678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B2A79C63DA
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:55:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E03802862E8
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4270B21A4D4;
	Tue, 12 Nov 2024 21:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ff1vJKgV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABAF1531C4;
	Tue, 12 Nov 2024 21:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731448514; cv=fail; b=TA0SEfEMpk5DTTwLQgl0zelZYnvrbUDHhfLAukn8WLVREuLOFVWn1u0urR4BqlwStRucgRxPh1DSYGZ1XtF09OW5Q5z10AOek0VnWZrfbhwNEG4Z7lcqe27g5O6HxLjBDuVsfEFpNqem2t3BoFJ2HoAliLH2f3WsLhuKfMtPPsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731448514; c=relaxed/simple;
	bh=ryDd73zOQZtSkk99Ud9+cYwJUQfDAuIpuDeOhPcKHaQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+Smn6xiiOVKloCHsqimOWeCCgd6ZPencUFy4pMPk0LTD+zbBqkb94JAqPZUO0MAqhsWq8WUVYDSz/FhYaoVNJLs5oz4RDUdnLsVaQue5CkEPmoneXse4NXgUvDstMartDN5c+JESSoP4Tke1ZlaX/UfRlFwonXPjjcsk6kZWtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ff1vJKgV; arc=fail smtp.client-ip=40.107.94.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0C0ly4PaU6yRrAfDdWn5kgKpMrSe5ruArhmKcnFjzu33AcanOAobvq/EOriMZocDVCY8EGfoc4CwgnjYmcmoY5lOpcCycG1Sb5Qj6B6xSqiJi2U0nwK5zBKS9lp+tjyGPw0IH+opXtS3e7EOVGWXT8o59nVDTcYKm9PEELMIzwbb9i1lYLtXtbzkmb/rzmg6RoNARE23sd9D9XSjkPqIbyaS+jqmJv0Pckehck1tJR7t+mKaB3XlzfaB3zIz+R+FJk0c5PT00hsx9wsMGPcL2uIg6LFozGTXTsW3uQnjssQSVTGBme03yl2qLNgpu2ZONHMHa9n8Le9wnLmChhmDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BN9DpUb1p/C8Taze62acJebdHZiIr1mHnH7MHwbR3EA=;
 b=RjqkHEGlNbgrad/W4v95UgLpu3SXo7DK65ZtgVOb2zQZk2PQh0lmXS5F+z8eMgCnGkvCk29cwxM00D9WBvZyCkQUtGVFfH3XVixKBszFGqmKhDlkkZRHZgHdwzMFwcM/dLV7mSGEZOFSiktNW1zWdXfuKjPfWz1D6eVBL+MZ/ppu+r2UIum51YC4Qr7nPxwnpryWZt4GV95Z2s4BwU3HGHzj5YtvNQ1ccQKdVKc19ifrYV6Numi3B0WeVUB5dfPZVEZgft4E9xk+N19A0/bgSdx8kBoigevBtlay0VoRch937sM9uRSlFi2/S5BUWiZaRHYnr5wSZDqJ318wW00HZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BN9DpUb1p/C8Taze62acJebdHZiIr1mHnH7MHwbR3EA=;
 b=Ff1vJKgVzYy9bhnVRWYsWcEMchWECx03LZj/bAYVmBa0EHJKgd5u6+ENvFHJHxLYC91tiPQ0hKGHUl7b7DQrt0Rx+D7sCBdHgmtNaQpxhHTroeS2ZiSvidQnl5ogeNSNNcdUo4DcH7fhpTGO6fPVFmyu5/0HehjPUAEUDg5qzox0Dq848Vwnku5SKjVSOzr8JskGdASPH+77eQPLTwyvEgVv9cQEXmSWQnHJL7xPn+zs7kjdGmmddI6wIaQOes0qXsf7wCbOYhMuHWZiVdAqNUd6UZc61eL6lPCUKNqL16eyQHFcFToY/1FbW/PKzS7SkxejgUn1MNd+ljKbtYL4zg==
Received: from SJ0PR03CA0163.namprd03.prod.outlook.com (2603:10b6:a03:338::18)
 by CY5PR12MB6429.namprd12.prod.outlook.com (2603:10b6:930:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Tue, 12 Nov
 2024 21:55:09 +0000
Received: from SJ1PEPF00002319.namprd03.prod.outlook.com
 (2603:10b6:a03:338:cafe::27) by SJ0PR03CA0163.outlook.office365.com
 (2603:10b6:a03:338::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Tue, 12 Nov 2024 21:55:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00002319.mail.protection.outlook.com (10.167.242.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Tue, 12 Nov 2024 21:55:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 13:55:02 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 13:55:01 -0800
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 12 Nov 2024 13:55:00 -0800
Date: Tue, 12 Nov 2024 13:54:58 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
CC: <maz@kernel.org>, <tglx@linutronix.de>, <bhelgaas@google.com>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>, <leonro@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <dlemoal@kernel.org>,
	<kevin.tian@intel.com>, <smostafa@google.com>,
	<andriy.shevchenko@linux.intel.com>, <reinette.chatre@intel.com>,
	<eric.auger@redhat.com>, <ddutile@redhat.com>, <yebin10@huawei.com>,
	<brauner@kernel.org>, <apatel@ventanamicro.com>,
	<shivamurthy.shastri@linutronix.de>, <anna-maria@linutronix.de>,
	<nipun.gupta@amd.com>, <marek.vasut+renesas@mailbox.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH RFCv1 0/7] vfio: Allow userspace to specify the address
 for each MSI vector
Message-ID: <ZzPOsrbkmztWZ4U/@Asurada-Nvidia>
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <a63e7c3b-ce96-47a5-b462-d5de3a2edb56@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a63e7c3b-ce96-47a5-b462-d5de3a2edb56@arm.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002319:EE_|CY5PR12MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: ab79cad2-5814-4857-3739-08dd0364ad53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6kOEMKY4KwO7xqVRobHnuZ+C0KtYNYid76AGXR+wqEn/o557vpz2RAuCjzjL?=
 =?us-ascii?Q?PHQxF5bRXRh0jn8vshrid5A7wx3wGsvN5E2+FAKGtv/zuu/Wtuu6Hw4PCVCs?=
 =?us-ascii?Q?BsnJ2Yd7yw4eNZuBwK9op51sYzzWvmadx4GP1qnXL/fmLPD36e00Ret3ZU4D?=
 =?us-ascii?Q?UL+tmPZEqdsVZUbRMV9IgWmphHhAVm1isbnLjUMyFSSf8B0X1r4s6LEM5rMU?=
 =?us-ascii?Q?sZz4geaw3GH2RnZH0QF9GT46i9rfwdzEXwu9HHy0G9CPEqnstdl1IbwRgcDR?=
 =?us-ascii?Q?Cd2dO2A2QuPvhm6K1xnn/TO0fcMvPGgi5r38fvocM1HQZncVXRx36sC/lcft?=
 =?us-ascii?Q?npJikIYyc6xR/s0e6VPYmBd/eNBmb/jNQy3JbEiuubAyqZmWOgXDl2flbloL?=
 =?us-ascii?Q?X+gxP/Ln66skLafiPLEUokL+d5FT9JBp4G8omtPTuefWPsdsfpBhXHUP5sjn?=
 =?us-ascii?Q?aPKCzYvtjMh6n5hLgAQD5s2mkL89KJFncc7B/nHgqPUsgItglZFNbnhS4h/u?=
 =?us-ascii?Q?ouB+WeE/UMQcaLAFbexaoSt1fLMehvZcSpv1ZZ/ko0EnmrQBnbI8NCtwyfHX?=
 =?us-ascii?Q?3APrc4hLEnUEncRujH9WuuSrcn8TZfWJlbTACzZiQnRfTyFjm/u+yQ+X0wyX?=
 =?us-ascii?Q?fhLsrwKKb7gtrZ3ci/j2SHoPKbfo5mAumWaqJDkvE4spJhitl0Rdp4LBArna?=
 =?us-ascii?Q?IhLXR7ojSvHxo1lIvoi34qQqjmHQvyeUfTw52mHk7hAzo4G1GdGS8CzWe50X?=
 =?us-ascii?Q?i7LTB6UR37XIkp9uyf4swKY7Yx4ykeqjSBhjhdmFOb+4JAkZFKF5q+72Oefm?=
 =?us-ascii?Q?smEKBz32VQE34WrSXGBttzgpc1d32nRS9vHfNDRyirayKYb7bTlo0+4eK+pr?=
 =?us-ascii?Q?P7JzNa4rvt83RoRTHyr72XIV3/4Spn7zcNzLXwqwAs6r3JQD+OzwzuHy9aFf?=
 =?us-ascii?Q?E2HO9fN0UeXCUESWkF7foKOT38ySWvgs4JXEo553ZbYRAd7958fulXgzvilV?=
 =?us-ascii?Q?jF4HTf9a4vD8WYl+kyo0H6Fusihx4Z6Jbj2/0mRWlAzeb1PD3OEkzGkhIMhk?=
 =?us-ascii?Q?da4d3aVAGKfsuYgNsdOzXQ/fobj/0sxTDHR6q1Lhgq5zy8xG9hYGLEWDq5EU?=
 =?us-ascii?Q?4kvZX1b04YaxIvqsmBhGoCuMKvUzdK48yH35JUOfBGCqd+MXV5vSbQjid4Yx?=
 =?us-ascii?Q?mHOD+ItkX/7qJ0wKHzPTnnjeYSqxDrc5gWPdfhIiThJO6oWZhN10X/Cuzklh?=
 =?us-ascii?Q?Ps/PWajNgcE48TsmCHoxmvAttkm7UkDNbAM/Rx/mAGdbe2hQ6gIhJxhbfsio?=
 =?us-ascii?Q?HgGZzAngtBrByHoHc1oGVjilbCTta9qLspuYWaWckT4kPXhUmT0Yz78XJod/?=
 =?us-ascii?Q?BTcauasfWckLBiXSXUUhtqEzzGKuBDiObM/5DhqFsfhAxBHtQg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 21:55:09.5690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab79cad2-5814-4857-3739-08dd0364ad53
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002319.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6429

On Mon, Nov 11, 2024 at 01:09:20PM +0000, Robin Murphy wrote:
> On 2024-11-09 5:48 am, Nicolin Chen wrote:
> > To solve this problem the VMM should capture the MSI IOVA allocated by the
> > guest kernel and relay it to the GIC driver in the host kernel, to program
> > the correct MSI IOVA. And this requires a new ioctl via VFIO.
> 
> Once VFIO has that information from userspace, though, do we really need
> the whole complicated dance to push it right down into the irqchip layer
> just so it can be passed back up again? AFAICS
> vfio_msi_set_vector_signal() via VFIO_DEVICE_SET_IRQS already explicitly
> rewrites MSI-X vectors, so it seems like it should be pretty
> straightforward to override the message address in general at that
> level, without the lower layers having to be aware at all, no?

Didn't see that clearly!! It works with a simple following override:
--------------------------------------------------------------------
@@ -497,6 +497,10 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
                struct msi_msg msg;

                get_cached_msi_msg(irq, &msg);
+               if (vdev->msi_iovas) {
+                       msg.address_lo = lower_32_bits(vdev->msi_iovas[vector]);
+                       msg.address_hi = upper_32_bits(vdev->msi_iovas[vector]);
+               }
                pci_write_msi_msg(irq, &msg);
        }
 
--------------------------------------------------------------------

With that, I think we only need one VFIO change for this part :)

Thanks!
Nicolin


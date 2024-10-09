Return-Path: <kvm+bounces-28295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 815739973B2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:49:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A52EE1C24B9B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCCF1DFD80;
	Wed,  9 Oct 2024 17:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EiKYDkWE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E331DFDBD;
	Wed,  9 Oct 2024 17:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496000; cv=fail; b=hVklZizPEA2//GDts9YeYb0mMPKE2T8PDheQ+3Qx01l30XtRLeVZKAE2gwh0TZKsjz+MPxSSDoC+e1tnWiYj5Sf2iPnppnd0WmF+bSkLLPpvezjjr9CmyzQ1k9Hvcz3G/MYYixCVAP/fxJu3BQblGxpa6P5hthwgM9exXUfYEEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496000; c=relaxed/simple;
	bh=WGblWyWNTpTUde2dh1c1rrA+31G42Co4U6Gur0A36vA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dh1C6YxTyuGfSRCXxDUhbDvVYwkdHUjCoEj3VoL47zCgUmlxYQ7H26mDAWWw9vIxxkac9R5i9R/SM+tlSRXqovW3GYSFE3ugEHdGHpIZXFD9+nMHOZ5ilByStnPQnCjVCsc/LQ9NElDZEUEJ/hgrdpmbmamuLNtRHUAA4qavC0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EiKYDkWE; arc=fail smtp.client-ip=40.107.100.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m5KLlH6dQoDdAF4Zgye39y97DmGaMWOK0K+3A1je6/kX8jwd/aSBKyumm86CoQ7I1zXciRy7XJoAIWJusB1jXowFMHQJL7oxdbaGMBBVAXb/PgEpR6u0dz7EjvpMO03I7JYeGnlwPa5fUarhXQgscwNKJLifXEy7kNhG7yvAa1Ch1ePyZWylsmKnMChLiJHecs3JyQbb03YgIVn+T+yW+HrsnwTlKF3erNnPjLUriAIPOFtGkLU1aWP9FvOcYbO8BmyuTXgcnvgsK2/Q8Zcq7ayQb2ItB6bsO1qmOT3ACe7FwM2TAiL1clLc3QgzcCtek6qj7M1R6NvRh6TjtkrGQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krMlBhAhsm1Hc0bqmbzzu+Mtc5SWHgaPAWG0vZdQJtw=;
 b=iMIjT3jTxpHfzUBvcA5/OTTX2GRFQHdxq2YSZKhZoSxKm93kyk45QmgT2gbEv7TfrmRj0TUhqCID/gkPovW8h4ekWbzCuWtBXnNnH/+rQFZ1EQxwe5gesjnKCHSd5pZefOO4hdjVCFv/Xyenx6uENJwAqFZDdJfV8rXNXA2ky93cCpV3ESZ4SDBKtFZxA5cZfYWMPKDepBJCAwk8RNvlH4j9S32YkWvPdPuOP8XBONCgNh/Pxv2rAdQrjVRipeRfP+kru4D4FJ26PmUl2LUgIE+BYkM3CQsPRVmY+m+9CnTiDtfW/UW9m17jsi4jDUjoxNeym+bhRlVcaVSyqIifPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krMlBhAhsm1Hc0bqmbzzu+Mtc5SWHgaPAWG0vZdQJtw=;
 b=EiKYDkWE2elRely/NalC8doOkXNJuLOpWRlT0BkMWrs71JYr/HG+DjcHh8+/i0Am8GaxDL+c/ZdWkXpVUpzzay6Yi2Wq8Mo3sxt43YutIGsIHPBhZaHT1kpPqpzp+gUoen2fYU0kaBBzCyO2h/iEBrrtcurcXGhL8VrczvUWOeuBHYT3t8mSqEqJwqnh/o4zJN/3tWUZfWHLDCUk/5Q/BkduCmpfs4eY4vbgjx8UlvN7MyrpSy5tB61uRISU6iTx2/KlwxnzrEXn/9POf8X8WJVHgJh+sp0/qpa5nxUsWZ6A27+CZmMVvksaH8QhhSe3NkCuOP1yvsVjxNMmSNgzNg==
Received: from BN8PR15CA0072.namprd15.prod.outlook.com (2603:10b6:408:80::49)
 by SA1PR12MB7126.namprd12.prod.outlook.com (2603:10b6:806:2b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 17:46:29 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:408:80:cafe::43) by BN8PR15CA0072.outlook.office365.com
 (2603:10b6:408:80::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23 via Frontend
 Transport; Wed, 9 Oct 2024 17:46:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 17:46:29 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 10:46:09 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 10:46:09 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 9 Oct 2024 10:46:07 -0700
Date: Wed, 9 Oct 2024 10:46:05 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	"Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Robert Moore <robert.moore@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, Will Deacon
	<will@kernel.org>, "Alex Williamson" <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Mostafa
 Saleh" <smostafa@google.com>
Subject: Re: [PATCH v3 0/9] Initial support for SMMUv3 nested translation
Message-ID: <ZwbBXWwL+pkMR/j1@Asurada-Nvidia>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|SA1PR12MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d057c26-4f91-41cf-e7ce-08dce88a4e25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cl5pRHwypI5GwG9V5pPrUgg0Hh574siWUBMnGJuW6JUessuAbg8dj5in7SjI?=
 =?us-ascii?Q?Rmg1iy361bW0U9sLBLvx4hcvoJG8uTVMTrmkaMu9iBpnBu84M3SzbiALBQEh?=
 =?us-ascii?Q?cxP8/hgsj8UhPW9AD1dxwV2O+JxhDRCX9PxiTgDTh4jK6KfZZ6BKUpnjCF1/?=
 =?us-ascii?Q?yPm1KN1Affhb4e/p1G2TguBiVT4Jp8H4Z7g4/4x88SBGhQGqb3xrp/kUknMN?=
 =?us-ascii?Q?dq7RAObfZMJ7ljC77+WQLQTSgMxwY0bO91W3H5Fw1hrQgjALSWmVuayKFfXW?=
 =?us-ascii?Q?d+9A6ocuL39E7SJ6SLkxeFOpVsN9yFLTIUmW+7CKr334gEaGaQTdoSraNswg?=
 =?us-ascii?Q?1CrEtBLhf7pIKBubZar8sV3RMcxKseftTYLXuupn2AyXPPeWl2aJOqYQF4V5?=
 =?us-ascii?Q?P/9AfEi4uUvaeG/EHdc+HcrQE5E/ckSbQIbW4bLjaw3PqWIMrST8cM3p5E5L?=
 =?us-ascii?Q?Av/25v6xUtidoO0+4DkvNcRDIrLiV0ncVRGJ8gVUZ3e7oyA39SbpX/PU0KZ+?=
 =?us-ascii?Q?kI1XzKRYnJoW2HNn6NTgl50qSOtHcwYrj3+9mKGK4itLIdh0YHUU511kFQqt?=
 =?us-ascii?Q?TwJHvNJhAbgggJwDKMJVObQ8qosYCxjcjBTLH8nYcuQmKYdq2GV3fNfmS5cp?=
 =?us-ascii?Q?vbtlYlXbtwirYbraX7jCxZMURsFlH/k75pFSQ1p4v9GBRSg1R7XIXbb3wBau?=
 =?us-ascii?Q?+I5s1acApZetW9GMRSUcHEfTiMOvrzmxYiZNvS77dzzuCDgjICYC7UR5xtpI?=
 =?us-ascii?Q?ovNIjIih88GLTaQIYcay2rTnOuTrGCnI0AgE+XvEvq/6e+13cIudRyXjWgHB?=
 =?us-ascii?Q?I1h7wk5x+G9Vwjxa4Y5ub5KU7LdhgOmUIaa0uZuTHWX4lJZ7euhawOSdDzpz?=
 =?us-ascii?Q?+G1eJ2J7FH2vvtmovp9ipZ5Y+4dEbA/hRtTiU9xt/kyPDGOpk0i6VvXBlqsY?=
 =?us-ascii?Q?29YdLQ3pbY3ryvUVk+n1KXQMe1eTtpeUzkRdaoSAL/Du/7ECpR0IlShMREpc?=
 =?us-ascii?Q?TeToOtCvcWJeoQJAGOiCWw02/iCSrYavJha+EugUofZKeHMqW8fJ4ZsPlkJi?=
 =?us-ascii?Q?FVpyUj7syfTT9w5qkuSCuTJAnDuTOCMUPM/+sorAvmkIu5rp3TG/0EUkJFN6?=
 =?us-ascii?Q?75lTqG9xom7NcLWtLsO2er+VcIvyRJiex4rZpIUAg/fcHTd53ne5nZHueddu?=
 =?us-ascii?Q?TkDONFy7uRlQ0d375zEB3ApQ/RgEWAtWZk8UJNilplJ12id5HtUmNSddicD2?=
 =?us-ascii?Q?bKXyPJwreGXCHYF9hMZyfNYqq0OcYjSPTYpjGh2102RZUqUX33y2cMWYL1xO?=
 =?us-ascii?Q?Z2PpA7Ypr7Ip1Dcz81jtVwX1W9kZl5YTTIXY6gQpEK41P2kVZNiDFW3rAwEr?=
 =?us-ascii?Q?Hz+e+o+aOiAFnLQP7Zkwzruz/fMD?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 17:46:29.2599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d057c26-4f91-41cf-e7ce-08dce88a4e25
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7126

On Wed, Oct 09, 2024 at 01:23:06PM -0300, Jason Gunthorpe wrote:

> The vIOMMU series is essential to allow the invalidations to be processed
> for the CD as well.
> 
> It is enough to allow qemu work to progress.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
> 
> v3:
>  - Rebase on v6.12-rc2
>  - Revise commit messages
>  - Consolidate CANWB checks into arm_smmu_master_canwbs()
>  - Add CONFIG_ARM_SMMU_V3_IOMMUFD to compile out iommufd only features
>    like nesting
>  - Shift code into arm-smmu-v3-iommufd.c
>  - Add missed IS_ERR check
>  - Add S2FWB to arm_smmu_get_ste_used()
>  - Fixup quirks checks
>  - Drop ARM_SMMU_FEAT_COHERENCY checks for S2FWB
>  - Limit S2FWB to S2 Nesting Parent domains "just in case"

Verified SVA feature in a guest VM, with the vIOMMU part-1&2 series
applied on top and the pairing QEMU branch mentioned in the part-2
cover-letter:
https://lore.kernel.org/linux-iommu/cover.1728491532.git.nicolinc@nvidia.com/

Tested-by: Nicolin Chen <nicolinc@nvidia.com>


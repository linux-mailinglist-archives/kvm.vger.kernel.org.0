Return-Path: <kvm+bounces-30139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3259B7165
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:54:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFFE62825DA
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B953C463;
	Thu, 31 Oct 2024 00:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k7gzQqAg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2082.outbound.protection.outlook.com [40.107.236.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4288F2BCFF;
	Thu, 31 Oct 2024 00:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730336047; cv=fail; b=o9lLG5CSkQ/PzwA9+Vrm8qiZL5amz3PMu8R247C4FR2iLXCJpT8d9N3L/M0SiXvzD0jLbEe7An3nbzzJlBCTRThJ4C0LPsO/90efplOdeuxZ3S4y6YzGrOzZpjm9itKrP2a5T3l5UOFRSamf8PkhozmF40EEJBWxgnuRhhTiDT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730336047; c=relaxed/simple;
	bh=CtR0EaMDtVCg4CeSFpPae4RKuSXFrAC3LmV59izicM4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QbKaa928j9qseoh5yurEWz80wofo0P40cky2YyXjM2rwsubkPnMMmn3uonOu+Kh3YvcG4mEreoByknLvOCvtIHqv4ny0RLdMCuGE8sraqOidqGEpyINs7pfjn+K/UjSCn86ZRd7hLAMhDlVHopLBAHcfLivD3BhPw8cObQxgQtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k7gzQqAg; arc=fail smtp.client-ip=40.107.236.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PBPHyZtDKislEnHMCIWmlsoTEiXgY5ZuX/5qg05CTbsB/n4OgCuee9MXeGJmaWh2ddOW6Y1zD1H95RWVG9H2OCGb2zaKCAfKHcSw61GoDJg50RA+DDCdHEAoOOBs0aOq6ARYAzkFIxhEJMoLTs17FJMXTqlmfGfgrNofqX5XdX7yyd0nw+k/hYcNj2WdrQ4M+UwUqeNgV3PbCVNC2i1fXFqVo45OOJr7sgZRHV2ckQVHe+sZ6Uq+R2nao7btHuvrJpQgFgZAz/KfFzrsCD4jf8F7D9d/OwRTCo3KcIZMZ1ds/kU/hfSGbMJRjqDptVnhUW3DGpWZD2W7SgDqET1JiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbMwvRZzjL44UmEhp1l0xqLqz08sOyb4plzwS5EPWMQ=;
 b=Lzge6Lm3gQmW9cv6kGUxcVizAZvrPHREy2IAm89UyiU9rqIHgMrU9+u9M2AXyYKyDDVqY9ITF52a5CoyxgPxk7J9oVHGIBLaio/prA7DdVcWCoAtCxlQVWmcajG75ouNbM0jjo8iZ1fVFkzh6khUMk3cgLLRCMB5O5ZEiE2UCNHa/492Z/YQp8ITm5RAaQO9M+kRjWxbD3LFPdQogJrpCUpLW9wC3R0JpUSczO+sOlNrLfPCoGLu6WGr9bEsUqYRShhEj0svKXndyzO9gbPYsGgzSkiilPMfntTDOEhdFdoS6vaxM9bM3MYbY+GCX8fpP1UrzzkWmkVa7YucU3vVdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbMwvRZzjL44UmEhp1l0xqLqz08sOyb4plzwS5EPWMQ=;
 b=k7gzQqAgotxK2Zc0GVFsnKxS2WX75+npSFT57WT9+9rHZJOrhLbmKEeqanCMj3+jz2DkHcNu027yghMVsbS7oI+1APPRfgkpY7uvcpUv9buqDgy8d293isVNskMwdZOjUD6F+s/St2MglEEf0kkE6HkSVmmTmLmByXc0Yz6wwnBALifPQnA1LXDJtShyGSETDK+ROHFHt8g9RFVEsa9TA4BGnuFjhFsuZLHzFRsL/tRWYesi3hEZhjkZz2lI8U4ma2Wr0d2KZql5R+6FCPVkg0y3sEwCnco310AInrfe7LODSPVEtDLTkCmuWPgI6+z8+IYIetC2fLrQyB8InruYUg==
Received: from MN2PR11CA0018.namprd11.prod.outlook.com (2603:10b6:208:23b::23)
 by CY8PR12MB8299.namprd12.prod.outlook.com (2603:10b6:930:6c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Thu, 31 Oct
 2024 00:54:00 +0000
Received: from BL6PEPF0001AB50.namprd04.prod.outlook.com
 (2603:10b6:208:23b:cafe::e4) by MN2PR11CA0018.outlook.office365.com
 (2603:10b6:208:23b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.34 via Frontend
 Transport; Thu, 31 Oct 2024 00:54:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB50.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.16 via Frontend Transport; Thu, 31 Oct 2024 00:54:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Oct
 2024 17:53:46 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Oct
 2024 17:53:46 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 30 Oct 2024 17:53:44 -0700
Date: Wed, 30 Oct 2024 17:53:42 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <acpica-devel@lists.linux.dev>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Donald Dutile <ddutile@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Mostafa
 Saleh" <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <ZyLVFkbFffHa3OKM@Asurada-Nvidia>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB50:EE_|CY8PR12MB8299:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b51caf6-0092-4b83-5a1f-08dcf9468209
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QgR0pKDIXtSzLI5UyEJGpML0BJ+MrHG4MfklBpS9mj4EwBn5DP4u56JhiyJs?=
 =?us-ascii?Q?mMUAXQo+CqUuQw7Mz+9S3w35p/zU5DvI7eNhs4Fb7YFNQBSXcc8n5nRshzud?=
 =?us-ascii?Q?T4wh3+EU8OcB6FD0blKIse5aB6FSlGmQZOBbNvNmcWImepdNSyNIYvjlBoLW?=
 =?us-ascii?Q?bfJRrggRb7n2hJJR9ADTUkdrWE3tQU4crfJy/fqA+y/kT8dMZSagvY0uuEq5?=
 =?us-ascii?Q?ATr65gQGzT78L+gqeq2h948j77nx7DOsCM6uZ1FDFo+63E0qusx8m5gD+Yx9?=
 =?us-ascii?Q?ToEc8uDp69MKCnxGwu8PVfcUc02Jensmm2mZ85gzg+5JP4vCE0iqfw1wp5+9?=
 =?us-ascii?Q?Ze5kCNseCVgmyZq+8wIX1Pmbi3JTx90qrw4bluOoBe72TaOVsehGx76YXHrl?=
 =?us-ascii?Q?VFGqIv107HNieEZQyZ84WNcOxU/7kz5vPEqmGeT8HxrqlQzc/AsVB4484HU1?=
 =?us-ascii?Q?91Rgwjs/EobmeydqrmuD8WWG0EfcL6Q/Cs4jz5gxw72dOOR8oJPi65U8BQs0?=
 =?us-ascii?Q?lVNRuzFmw9sLd0m4sTpTUrbB97K1aOx1yaLc1pB6xjPrcUz3SZJQJ5BMWHRC?=
 =?us-ascii?Q?9d5cRlp4/ClxBguGoaq/8/qPofA6vrvCgYV6ZOv6moX8osb9MoINB8S/gExg?=
 =?us-ascii?Q?rC/bRBPzjspLKuNH6fYE2AtOx8ZtF6nveKgG9iFRNIIkxZvVdOIGtcWZg75l?=
 =?us-ascii?Q?s9T+ewIbI7p5yKkjQ9m7XjXnL7nSeB7zmqe6/xLBOQ5vEh9H41I+az2SJwmn?=
 =?us-ascii?Q?prQfB/v8G4Ud+s8yNnkfnqz3FBAIz58T/RaCklX32qdebvryApMIXdbN9NqL?=
 =?us-ascii?Q?DBKivNjAFUERdh3hAAEZWtxIGMSVdF9SkK8QjPeCYQhfQKZyQTR3AR6Z+DPA?=
 =?us-ascii?Q?TQkEaz0rX06UwORa8dNIhLjKWpunTlDUgsPXas2Gsq5XQqrGwwWcGArGtDHp?=
 =?us-ascii?Q?dyMNEMksO1ME4jQ3yogZeSrr9jLiRCRNFzk5sMOiQS4M+7821r2ljAtvbPth?=
 =?us-ascii?Q?hgaoxGlzoyrQKPIoZTZWpolxDOhQKIV0SCk6XyDeGn2CAseSNlbmWdRh/CNs?=
 =?us-ascii?Q?okECr6p4UvFn+DBi1u55O+tntTmO/6V8aRuxWUNjN0il5XBBrzHsqXberGmV?=
 =?us-ascii?Q?o/Eq0uoDvuhhvzxn3qHilOsvmwdaiCOvjwAjEwrFoLN9P9L17v5poGDmbnQF?=
 =?us-ascii?Q?+MVZXxYm9GHxo6m3iG+8Fng7XMpQzEhiTKGJsojZ7LRSeGRqubAuxBheBmCU?=
 =?us-ascii?Q?wT+llBqAAQOyOn1qFFmaswbP5s7rGtRiTzTxUs+3lDq10mReidHGOXpaHKjZ?=
 =?us-ascii?Q?uOQ7U4hq52SDcUDVtvWU5TzwgpiydJlII/fQBUUzgWxhjcV/kVGV8s7XnEuG?=
 =?us-ascii?Q?K4rP0LJhHfy4+cbLDRc+60Buu0GMtwveR41bi0wYZpbYrrq5u1YQolqw3ahl?=
 =?us-ascii?Q?7YQzCG5hWIE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:54:00.1945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b51caf6-0092-4b83-5a1f-08dcf9468209
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB50.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8299

On Wed, Oct 30, 2024 at 09:20:44PM -0300, Jason Gunthorpe wrote:
> The vIOMMU series is essential to allow the invalidations to be processed
> for the CD as well.
> 
> It is enough to allow qemu work to progress.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting

Tested-by: Nicolin Chen <nicolinc@nvidia.com>

With a branch adding RMR changes on top of this smmuv3_nesting:
https://github.com/nicolinc/iommufd/commits/smmuv3_nesting-with-rmr
and with an *updated* paring QEMU branch:
https://github.com/nicolinc/qemu/commits/wip/for_smmuv3_nesting-v4

For folks who are interested in testing, please use this QEMU
branch, as there are uAPI changes against previous verions.

Thanks
Nicolin


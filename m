Return-Path: <kvm+bounces-51318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0370FAF5EE0
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82E324A7A3A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A4E52F5082;
	Wed,  2 Jul 2025 16:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NWsZxgqh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED71A2F5081;
	Wed,  2 Jul 2025 16:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751474283; cv=fail; b=HYW6NKs0Z8qOdkyFozBUeyXzLsml0JLGl7qDpayiNi6TLXX9MMXLrQmm+pUf5mghpgIl3a0zA2DKAkAvN/IrbMfZQFYP31d0IFIK/CIEG9WkVnZNkRouV0CjBUUL2xm/C66jnXPB+uVfI8e5MBGqLYI56RMOheHwBukqzyRRddg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751474283; c=relaxed/simple;
	bh=QvO9KDgrGCTFTrUq/8Ak4IkxUF+Hti5WqRABg/ZKnKI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=om2L5/qP2/m/WwXXssUHNYk0YjYhLumB24JDM2XHyIMpKmojl6MrpDLjpTg9rq+uOA8iXrW/3hfmqCkZYrqLFQjD8nP2KHeXGDdj1pCTPKEDmZUi0DmhsxC9nVmRwPKTkhokOYEMJOKsfDVJlKYI9+DOS7c1oAVGgddD5Sb54QQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NWsZxgqh; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oPn0G7KJc2mzfYGo+b45YLRt0YR060AOszjEdBnIDcHe2Zi+TA+CkWeycUHwAu5kI8xMYdvkmvQ27u+SedTf0LcPb64eDO+3/9wXAr4qS9zbjNuiS8MrpVpZVr8yMPel+UqlodDrB3z8Jh+I0Gt31/7tToZaca503bm8ItoXGNK0tDyXQ5HBJDFQJD2hPMt/y4X33+aCFArQ93E10kn0IZAuVQ1OdAP152v0LoUfJ2Ci+JeL8OGROEzzWotUjEtjVOIgWDq2A2J20A3lIX7g7BM+v4nc6rQ5cXbRm5s8SqCzxhfKhYfvC+/B4zhVv3qp/wsQ6AXjsLYtkaK4JhN4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBGIPN8mOmT6tjgjmzzkd4RO7hW82cAQ7iOGOCJv3mU=;
 b=L62LfD76yfP95eYwh8XPMqUTCHpQTKH0hSw6b28kmLsl8fb6lfw/r+MMqEVSrxAYMWQtnA4ljIIfBySlWblacJ0RlOuPLFRRrgL1G9wst0ZObdtqbf8v+F8DAq7ZnWmqiCCHYckmBrPb1pAT9NswdAy0NJxgMASyv9a7aeNx1laB1VKgqdYd2iSljg4MlKWmUHrqLDPpZtj1kInWMVsKE0DRvcINkgW+co5FzNVGTz9ia1wQaPT2sSCBxybaG5IZFCWxzNzuzDMwHkeHSo2o9VIFZW34Va69KF/u3mvcYrl/VRIupCh/qII0P1SMvmY+AHFlVN/QZ6upCef+l8POxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBGIPN8mOmT6tjgjmzzkd4RO7hW82cAQ7iOGOCJv3mU=;
 b=NWsZxgqhiuu3qnmhZew22+p07i+Ymi4LuLH+SbCZgjN4hPczBTOrjARQfBNzgdWOrGuSlkLpe6WD6f8wnyACp52SIiammcOq5/maY2I3sJ0BNpfmE00ewp8eHWKajwTHlYo+dvWv6eyYItuoD2O8Doj/sIMvkFrekl01ws69ey8=
Received: from BN9PR03CA0903.namprd03.prod.outlook.com (2603:10b6:408:107::8)
 by BY5PR12MB4291.namprd12.prod.outlook.com (2603:10b6:a03:20c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.21; Wed, 2 Jul
 2025 16:37:55 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:408:107:cafe::20) by BN9PR03CA0903.outlook.office365.com
 (2603:10b6:408:107::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.32 via Frontend Transport; Wed,
 2 Jul 2025 16:37:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 2 Jul 2025 16:37:55 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 2 Jul
 2025 11:37:54 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <brett.creeley@amd.com>
Subject: [PATCH] vfio/pds: Fix missing detach_ioas op
Date: Wed, 2 Jul 2025 09:37:44 -0700
Message-ID: <20250702163744.69767-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|BY5PR12MB4291:EE_
X-MS-Office365-Filtering-Correlation-Id: f18ff39a-c16c-4774-faa9-08ddb986cbbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vDnx6NR1ldHOcTV7VFPg+hgeWQ/sir6Lh/gJOI29RBdvnNcxruCosS24Oe6C?=
 =?us-ascii?Q?cjexFh4WaTO4VtmqqxzbhMPktmlX4bCAf3KRQRgyaQE8YBYFaQTsRV42w2j3?=
 =?us-ascii?Q?mH3o0NFav0mbKq/ikbCw/OxXQIfaz0TWzIsCRFOZEAI5fwrMUEc+Mx73aplS?=
 =?us-ascii?Q?aLm+A53iN46V8iXcBxs2d61lrEOyQdVZPQIlinir2l2QDNeXZ+SFnOSiAQx6?=
 =?us-ascii?Q?R4vMhwsc4Fsmm08sb0c1E0gvYZKAvSe6s+o2b/JsgLQvPOLLywM4KpCpN2QM?=
 =?us-ascii?Q?dV2c9TJuvge+QjPjiRrvs+Qqj1ngLaDLqHUP13WuHrESlWVO97JkSINFcbIk?=
 =?us-ascii?Q?FmxhG9VTohi+Q27Bt5Ig+7yrmVrX2djthhg5rOiyYdkyBgNz91C3eE4+MOMP?=
 =?us-ascii?Q?hHOxz3labZ5Dc0UyyZk6uG9+biCjuFJ6iQ7kvQ4Zqq8fGkOkftD7Hbfi2Ubr?=
 =?us-ascii?Q?o8thajf2k68UDo2rJtwgPV1tnAWnT/+KQEjlZvsy25LYYqMN2cmILlpF6YHv?=
 =?us-ascii?Q?eiSTfbys3HAaesrYJ8HK6ZbPWVSWdgTpSCyRgyrU2I/uu6UtDwEstLAxn4VR?=
 =?us-ascii?Q?rhoVzIshmRZrKYSWI7CzFxNwunbb/rqO1b10Kgp4eszzTNjvZSy8+XBepbDg?=
 =?us-ascii?Q?RGX0bYVOm5m2ESQnABBask6ku5kqGVket6U8b8ELGDCXLe/skBi6r+WSVtnL?=
 =?us-ascii?Q?cgfXiMU/JiIMS6jEMX2jZvx9/gMbgnUN12CvBM/QzwF660FAWIBFunhJD7HC?=
 =?us-ascii?Q?xVX5ReqkEtE+QhrQ4upK5IxABW1vP6fsaSedvQW4fKYKZUJXhOXfwBbn1pCd?=
 =?us-ascii?Q?iONk84ICaJf/aBCZz2VDkddYhTK/jHKmL7kxu+LV3eWU6mSG4x8MRm107ZoI?=
 =?us-ascii?Q?PmtaaXUEF4jIlZT7dVrpMDKyh1CAUmgNzwV54qgoM29MZPzOAC5qawNdH0Vu?=
 =?us-ascii?Q?A04RdQk4Lrlzs0gquknOTy9/p0UtLRFGginkj4AvYgBv1t23NlDA0cFB8RV0?=
 =?us-ascii?Q?I5uGuxe1rBqhI1tK+wyzt8G7G1F7RvVnzosE4Q0MRLXxjjcfx69AA63ZFyGe?=
 =?us-ascii?Q?WFCxDvkl4JeFjhb3uGnU8Q7APIu++rP4dLE4yDPi1WW4KH5EYtB32gTD68Rr?=
 =?us-ascii?Q?RhxRkX3cFAJts2DTnmys2pZyLzQaJ/6QfSWVaqSr6mQV0J2crOkUzPNQytrr?=
 =?us-ascii?Q?CsL7z3AwZoyiFcOuhslfK7nalKKxXydEmenOXx/2VHa2wOhFqaowwE99d+cl?=
 =?us-ascii?Q?qYvFMr3Lk0YeU026tpT+yJuo4RRjle4UxmXadWRfAbARJSxws7yvcMebxec4?=
 =?us-ascii?Q?GwC4gLmGGJWPECLghW6orPVY8c6PQGPk687AjiycCyEFfaXjMktjGADmwT92?=
 =?us-ascii?Q?97zEv3yFd29MFVNEZQw0OvHUEIrSVzA0UwVGOb/KwtohUy7Vwml/rv0GLq7J?=
 =?us-ascii?Q?79unDxqhPRcREuh6GjI5VT4Wf2+Dq3JeY2KvCietz4gY1Wv0IEDar001V4Ar?=
 =?us-ascii?Q?6NIQmC15OvzezjC6k/2zntBjrIpcw0N13Z2S?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 16:37:55.1036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f18ff39a-c16c-4774-faa9-08ddb986cbbd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4291

When CONFIG_IOMMUFD is enabled and a device is bound to the pds_vfio_pci
driver, the following WARN_ON() trace is seen and probe fails:

WARNING: CPU: 0 PID: 5040 at drivers/vfio/vfio_main.c:317 __vfio_register_dev+0x130/0x140 [vfio]
<...>
pds_vfio_pci 0000:08:00.1: probe with driver pds_vfio_pci failed with error -22

This is because the driver's vfio_device_ops.detach_ioas isn't set.

Fix this by using the generic vfio_iommufd_physical_detach_ioas
function.

Fixes: 38fe3975b4c2 ("vfio/pds: Initial support for pds VFIO driver")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/vfio/pci/pds/vfio_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 76a80ae7087b..f6e0253a8a14 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -204,6 +204,7 @@ static const struct vfio_device_ops pds_vfio_ops = {
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+	.detach_ioas = vfio_iommufd_physical_detach_ioas,
 };
 
 const struct vfio_device_ops *pds_vfio_ops_info(void)
-- 
2.17.1



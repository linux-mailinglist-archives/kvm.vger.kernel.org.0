Return-Path: <kvm+bounces-52045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE6AB006AB
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 17:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB5B17BB20D
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 15:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB4FF2749D1;
	Thu, 10 Jul 2025 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AcHw7KCX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DC423DEAD
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752161437; cv=fail; b=b1ibPgkb3XT3n7Tshfd2LXZOR01GoQl7Odag/PlasULWSDQ0d7tJTvNXcWv5ZKThgLjZfUH8Qsj8YxgqGSrOkVMTjmvHk3+0KbeJKk00slq8D0ugmcFoo3c9TfS5h2YJp2NF0Axqsoz7FNgfW6nnWgI0XMlPXkwRQ6tROtjLu+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752161437; c=relaxed/simple;
	bh=LY5nV7buFzCYz5uBr8KM+NPvdQOGFKPB5UlIM6DIPbM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Kymt4W2lQityGNY7C1WBJG0YRAln0FEwaf4cs+kHUovDHI5U756P1rD7gStl29EcwxnEbf+O246OLa4n9KUxOOwYtDcAmGHj7ScnNbEV2VjJn4kAYO9HoVQRd2ZejejNjf3L+eaQCbo5vNI4g3XS0kFY/zhydQToBOTZ/VJc/n8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AcHw7KCX; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IzQXKrUajii9H31DI3kJos1OWw4Io4GgpT8ZSrFaEaIh88XO/K+2EU9AsBwxUpVwdM5W49R9hDfSwgkrzVccqSXnpGTUXRGLLQ+4i5lEMABl0CpToKwrs74PtnFTYsrNEMvdlIenOhVYrtrzCwIyYHYgDN0PhBwpYG6AMSq/GG0+S1RVAabUnz7DFbTA+DxpGpjc8Msb1TvG6Cgx+vs2CBCfMl1OtVb2r5qFq/dQOkSRfdt9Yr5nZQPBiJucSDbFfJrCxN2qU3pjHUFTMtS6cFgNzkDcc+6TSUhljEovxNRqkmckZJt2Org4yW/OIUqsmrPvIEhO+c2OlarDWkEBhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IseRY/K5/+6ODt/WfdMvZR00wTSTSFUN89leb3eLCI8=;
 b=wwzlq2mhkYbt2ueQ4+Y+JqdTOi6Qdy3CJluWoJt9VvQ324pEY1km1hyriAuG0SseG5NkCJdu7z7HrRWJq21xM3yBEOR5oLviz0esar4GD2FsM0+yHxbP3fdd0soNYLiRZ5/nVjzahfgy7sRuW1bBs5wf5GeBB917yd0M8Ge4BlEiDh475bfA3NNBm+tPv86TbT118HQbeThfp+jQF/b/vhoPGImqgSARRJplJwb/fiuPtfCi/UKZP9kFjGyG+PzNCGd5lRvuFKWGuVmBBeMQin2+ORSmgPn8Cmnnx7ZC6HANsmbc5C2sHXsq7MAcuayKQ10ur6M+r2bHCH/4s8JFUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IseRY/K5/+6ODt/WfdMvZR00wTSTSFUN89leb3eLCI8=;
 b=AcHw7KCX00jf9FBJZsorYSzivyYW6BqJlG4Q3KYFDlVm3oZJpIdQARjY7KFD2CW0GCpRCa+8esB6MFNChMkz2uATYIcm/bJDVB4/HF2VxnEz4AirUU8HtkEkR6fPssgpfqoHf/CDKrUo92KYgmAnWNsG4VIvADGhyuEG3MMddmcT7naSy35ouHzEbk6UaIiU8ZbOmfN5VMPu8UAlH85en6YnVZZYe0QYA7UMVa3V8WKj9XkIkMPL3VQpiEIln/puiFcpcbgFi08cPCtVk1GK42ZGm0WmuDe8c2wdk4O42AJlaS1MLMUYlXfYfGwJhm79+3iRqaoq1Zw02ZDakeBcNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6058.namprd12.prod.outlook.com (2603:10b6:930:2d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.32; Thu, 10 Jul
 2025 15:30:28 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Thu, 10 Jul 2025
 15:30:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	qat-linux@intel.com,
	virtualization@lists.linux.dev,
	Xin Zeng <xin.zeng@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Terrence Xu <terrence.xu@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>
Subject: [PATCH v2] vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD
Date: Thu, 10 Jul 2025 12:30:24 -0300
Message-ID: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6058:EE_
X-MS-Office365-Filtering-Correlation-Id: ff416f52-6678-48f9-b8de-08ddbfc6b22a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yQ+uhmAZ9pvk+UCfeVRVmoPAfTBW2DH19Qbbyu5gNacEUjPI3tzYQ8/fZ0oG?=
 =?us-ascii?Q?45gWxRqZQLYgwbFyvsSUjmBFN/4wbWKPI3h4Y/MzHJRI4Ys/DHTPf+2rqT6d?=
 =?us-ascii?Q?CRzqEcm4sNi1Aj4x4GkWuVQpBn/Yd8rN4+UPuibhJfvCsTS+Xu7o9t855M5l?=
 =?us-ascii?Q?ooLesne7iBS5kdi7uVvyecv7HZJ0aOtPzBPmblCPQM5XYyS4D4GeO9nOSIvy?=
 =?us-ascii?Q?U2pTvNzlPiKn0lBupQMLsvLjgSfxrWcDBrMlty5Uw9LY/2iU+ktT+P31BQrY?=
 =?us-ascii?Q?QExo6fnAbPWcmHdomfpCsJ+wmM18TbO99jl/FmFdKeMge2Hgthgi02VehP+R?=
 =?us-ascii?Q?WnrUjaswzISlUMVGmaOODHQdiEQaeaCWq1bQWb3j8zKjK/GeqIpXdo/f607t?=
 =?us-ascii?Q?i4zEXkEq1Ev2OzqxsxWBo4iffSEhMVFoU0b4KSgZHO5bFB/ap8YdUFM1Xgs/?=
 =?us-ascii?Q?eyLLd5KTd2Pvfeib6rnFes+6YA+KfSKbLoH3ZZgCPuE+5agrQf3Hi6ag+OsX?=
 =?us-ascii?Q?4FnCge3nMi2H6dn06gw/klGTfBcqGxCnxjihcNpALLCm05tIGRwoH8PVdJuP?=
 =?us-ascii?Q?nxJbqZBWJXeVUbUyNbH+4wqc8IcGZMfs9oKCE13V6w49av50SgJIpeyre34K?=
 =?us-ascii?Q?3/kkw7RpVpB0P1jR/pinYJyjzAPbPvKXokeBt1Jz3YSyvutziNFI39rECWpy?=
 =?us-ascii?Q?hrsQHEsASa8KgqFnkJ0mE2ikK0vsp3knQsK+mwa8/rEv2XKzLcSD8/f8/Eke?=
 =?us-ascii?Q?ufDQOMAnJ+K74kUYNWbdEjEgpkNTnTp/+YtN8APKRqY3dRvog+sa1yGlMiJs?=
 =?us-ascii?Q?Odqivf52EHRyLRYRAO1OA+cGPxKzycHyBjRT7CMJPRLyS8Y4eg0jU8C156nE?=
 =?us-ascii?Q?CSPeYld4IRiodnP8Nv8G0c4k8YKL5nem9BjeuT5D4xRlM3awhfkVaS7WasJf?=
 =?us-ascii?Q?iyJ2vW6KVxeeOKjTp4V4wosrA4yn0Fldzc58hKCxh+6/RRF0emqwzxHaTFYJ?=
 =?us-ascii?Q?dYW30r0St72tx9aEqDRxtSsoCPFCltbg5Fvpv4ZBkTSkwVOdYZwVfz9A7IbJ?=
 =?us-ascii?Q?+eer/NYKXt+qsYVS137mxdwtesNhD1wk7U9qO0rAubvudzTNaK8s7UYB9apT?=
 =?us-ascii?Q?9lS7Pcw8rnbx2Fkc9EtAHBakrBThpJJaxHM+mRub5QNRRKhbDTLBUyxWmQSa?=
 =?us-ascii?Q?1oyvdo3/W1+Ja679L9/gDZsw/G28CU5BJSy5GC4wVgDMkluCR9/iCXc1W2yz?=
 =?us-ascii?Q?dtURIF7+TFiWhkqIhUZFAP1vuvRtSVMRMAPjOda5npJ9mFbXENBdvrUh9Yb+?=
 =?us-ascii?Q?650U8DYQg6wzz/yTz16X+0RK7EVfaTsn/IVUcBbFqNeuM2eOkQfx6xrUfYCl?=
 =?us-ascii?Q?hVLFjSIuhUnwEsCNLSlMQQ+ioaKLcOzSdz2vZ3gBfnf3/kK/O2DV91E4dCbU?=
 =?us-ascii?Q?rOCjRDnDaEgjUZH5R3T4brho1vbOYjs2AOVf+qATmBdKa6ID7tXYXQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SrwtBCne3UWdG6GBwh51TTHcxiq7dCEeBm03ngkmJ4qHPvByWu1aARDBphiP?=
 =?us-ascii?Q?nkBdKDV9omOz9AlM4hYp/7Gqt91UNJ/GS9zUBla9uKfFoxZSf1G7+8SforIw?=
 =?us-ascii?Q?ZCCjf0+HNGism2BXCMRzfJjJ2OhtHautIbZDnbgKoHv4dItytdAsXqOO2zQ6?=
 =?us-ascii?Q?wbjm30qVxO8cKtSRoCoJZe/zQpH527J7cdzSKKSHHYQXW7ZHXw+pl8o2V1ui?=
 =?us-ascii?Q?Kt0J1UKqgdoE6bVm/C53Gtd9NqFRgDsBowrQdGP4IEUUbDTXTcZzoT+27Z9i?=
 =?us-ascii?Q?lq92eBvA55IYSW+OQo4+UTVmVtpxRvr4V8Dbo9rmguDsVLWOEfiKpX3RW+k2?=
 =?us-ascii?Q?yBIz4e3N0GTMZ/X1KdxkxqamLBFxy6jYjc7XOEqhXMAyGnE47O8tzEk8oFBW?=
 =?us-ascii?Q?JSPt3a7gEOYtQoUv+dYTlDT/ZT/gDegO9+HbltizC1aONECwzmriZ21HEm+u?=
 =?us-ascii?Q?8Ov9O5UEomygZDoNnjIMAzGiy4RnFSxMlUusIZXvssadzbD0mSABQGn55MvJ?=
 =?us-ascii?Q?aw8VfdHKyj//vsI/zNWTCANdN/ez/CHvKb4p5G7j5KEiiSp9cbhFGfDoH5Kx?=
 =?us-ascii?Q?bZBans3QMsHQMuUdlAv8mEmY6nc6TNGVkxeUh9dkse7gFUOfPoVbhJaALJ5L?=
 =?us-ascii?Q?GDb8x17RyCy74LR1ujVK3kuI4+yUWKKk3BEyJvl89tNgqoHtvHAmegLpJ3Cu?=
 =?us-ascii?Q?iaAcPL2inb5eXcD5xv+O75SwrkgrGKCDVBgHX5su+LSR6yef7Q29BEGotnC3?=
 =?us-ascii?Q?Y3OTMeIt78p+R41VIqSfwSd+njgMRgX+Ip9rlAlDZ4LVYZMOd+KtPJV6v8J1?=
 =?us-ascii?Q?AYVEW+fv8ncfSqSAGJtARNqBF8paSByNOeUkO+ItgLQUQGbGcE1VzjFHNnQB?=
 =?us-ascii?Q?sjZCXJDcf7/rRfUxS5zD6u1UqeX9ifOSlbXbQe47i8FzQY2XIwq0bw+zSrcF?=
 =?us-ascii?Q?Z+v5CTappu1Ovx36Hur5/ia8XGKB3vYX+2g1akI7sbwv8WzpCiWXfhPpJZ6t?=
 =?us-ascii?Q?VHSudHEXP6Y68FRTp7OQcO1G8xLWZLijIW62hC+CwaLCgUOjwQkYO7e8zID2?=
 =?us-ascii?Q?r5ZhBjn2T3sgGlB5WAabquOSGak3Nvih+gjQv/1fTFQTbs66RRQKc7syk5Zl?=
 =?us-ascii?Q?wjRVSGxeCWEV2om6TG46cOCOS85XAczEFO9KPMrE47gQDDR97v/0ghnzC7q8?=
 =?us-ascii?Q?euFQC6KDghYMQOHPN3Q2rppVud1YK8tb9jwXDyWTkB0O2VnVPhOsXWAqO4Mp?=
 =?us-ascii?Q?SZOe3mnqcFguHI0xjzUtjLeZXLe0wsTBARUvHDeWC7qPGRmrvnkq2FHToNW2?=
 =?us-ascii?Q?lAvEiPzdQzqMdzh9bjES+BYdg1LxaTHwWBkBDDAgvbGrI33s8CkW3tfY1/gI?=
 =?us-ascii?Q?LfPBv2vL7HpA3lNJIAxR+EtlL3OCIH3QSULThZWFS2fTcJC7JPdpA7KQKFqZ?=
 =?us-ascii?Q?9HTjKnTeA7p64/LAzgqPC7JgDtfpABjiCAojS9X+0wN85eT7RlO7hcRBNU3r?=
 =?us-ascii?Q?/s+8WPH4GYWGgqM1t2Ueo0nTapXY9eJqCTxx6vmSLIwjlKfPD5oWJSB1kNF1?=
 =?us-ascii?Q?IvuGVqn2WZsCFbaqXUxkkpf63FgEj5Gvg/BZ6rlp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff416f52-6678-48f9-b8de-08ddbfc6b22a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 15:30:27.4772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgT84tQDnaWg02WB/PLOlUH3GA8gDkKBzeDMi6/y9ijIjKlPlzdPZyS397I9MHi9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6058

This was missed during the initial implementation. The VFIO PCI encodes
the vf_token inside the device name when opening the device from the group
FD, something like:

  "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"

This is used to control access to a VF unless there is co-ordination with
the owner of the PF.

Since we no longer have a device name, pass the token directly through
VFIO_DEVICE_BIND_IOMMUFD using an optional field indicated by
VFIO_DEVICE_BIND_TOKEN.

Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/device_cdev.c                    | 38 +++++++++++++++++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  1 +
 drivers/vfio/pci/mlx5/main.c                  |  1 +
 drivers/vfio/pci/nvgrace-gpu/main.c           |  2 +
 drivers/vfio/pci/pds/vfio_dev.c               |  1 +
 drivers/vfio/pci/qat/main.c                   |  1 +
 drivers/vfio/pci/vfio_pci.c                   |  1 +
 drivers/vfio/pci/vfio_pci_core.c              | 22 +++++++----
 drivers/vfio/pci/virtio/main.c                |  3 ++
 include/linux/vfio.h                          |  4 ++
 include/linux/vfio_pci_core.h                 |  2 +
 include/uapi/linux/vfio.h                     | 12 +++++-
 12 files changed, 76 insertions(+), 12 deletions(-)

v2:
 - Revise VFIO_DEVICE_BIND_TOKEN -> VFIO_DEVICE_BIND_FLAG_TOKEN
 - Call the match_token_uuid through ops instead of directly
 - update comments/style
v1: https://patch.msgid.link/r/0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 281a8dc3ed4974..1c96d3627be24b 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -60,22 +60,50 @@ static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
 	spin_unlock(&df->kvm_ref_lock);
 }
 
+static int vfio_df_check_token(struct vfio_device *device,
+			       const struct vfio_device_bind_iommufd *bind)
+{
+	uuid_t uuid;
+
+	if (!device->ops->match_token_uuid) {
+		if (bind->flags & VFIO_DEVICE_BIND_FLAG_TOKEN)
+			return -EINVAL;
+		return 0;
+	}
+
+	if (!(bind->flags & VFIO_DEVICE_BIND_FLAG_TOKEN))
+		return device->ops->match_token_uuid(device, NULL);
+
+	if (copy_from_user(&uuid, u64_to_user_ptr(bind->token_uuid_ptr),
+			   sizeof(uuid)))
+		return -EFAULT;
+	return device->ops->match_token_uuid(device, &uuid);
+}
+
 long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 				struct vfio_device_bind_iommufd __user *arg)
 {
+	const u32 VALID_FLAGS = VFIO_DEVICE_BIND_FLAG_TOKEN;
 	struct vfio_device *device = df->device;
 	struct vfio_device_bind_iommufd bind;
 	unsigned long minsz;
+	u32 user_size;
 	int ret;
 
 	static_assert(__same_type(arg->out_devid, df->devid));
 
 	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
 
-	if (copy_from_user(&bind, arg, minsz))
-		return -EFAULT;
+	ret = get_user(user_size, &arg->argsz);
+	if (ret)
+		return ret;
+	if (bind.argsz < minsz)
+		return -EINVAL;
+	ret = copy_struct_from_user(&bind, minsz, arg, user_size);
+	if (ret)
+		return ret;
 
-	if (bind.argsz < minsz || bind.flags || bind.iommufd < 0)
+	if (bind.iommufd < 0 || bind.flags & ~VALID_FLAGS)
 		return -EINVAL;
 
 	/* BIND_IOMMUFD only allowed for cdev fds */
@@ -93,6 +121,10 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 		goto out_unlock;
 	}
 
+	ret = vfio_df_check_token(device, &bind);
+	if (ret)
+		return ret;
+
 	df->iommufd = iommufd_ctx_from_fd(bind.iommufd);
 	if (IS_ERR(df->iommufd)) {
 		ret = PTR_ERR(df->iommufd);
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 2149f49aeec7f8..397f5e44513639 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1583,6 +1583,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 93f894fe60d221..7ec47e736a8e5a 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -1372,6 +1372,7 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e5ac39c4cc6b6f..d95761dcdd58c4 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -696,6 +696,7 @@ static const struct vfio_device_ops nvgrace_gpu_pci_ops = {
 	.mmap		= nvgrace_gpu_mmap,
 	.request	= vfio_pci_core_request,
 	.match		= vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd	= vfio_iommufd_physical_bind,
 	.unbind_iommufd	= vfio_iommufd_physical_unbind,
 	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
@@ -715,6 +716,7 @@ static const struct vfio_device_ops nvgrace_gpu_pci_core_ops = {
 	.mmap		= vfio_pci_core_mmap,
 	.request	= vfio_pci_core_request,
 	.match		= vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd	= vfio_iommufd_physical_bind,
 	.unbind_iommufd	= vfio_iommufd_physical_unbind,
 	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 76a80ae7087b51..5731e6856deaf1 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -201,6 +201,7 @@ static const struct vfio_device_ops pds_vfio_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
index 845ed15b67718c..5cce6b0b8d2f3e 100644
--- a/drivers/vfio/pci/qat/main.c
+++ b/drivers/vfio/pci/qat/main.c
@@ -614,6 +614,7 @@ static const struct vfio_device_ops qat_vf_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 5ba39f7623bb76..ac10f14417f2f3 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -138,6 +138,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.mmap		= vfio_pci_core_mmap,
 	.request	= vfio_pci_core_request,
 	.match		= vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd	= vfio_iommufd_physical_bind,
 	.unbind_iommufd	= vfio_iommufd_physical_unbind,
 	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6328c3a05bcdd4..d39b0201d910fd 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1821,9 +1821,13 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_request);
 
-static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
-				      bool vf_token, uuid_t *uuid)
+int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
+				   const uuid_t *uuid)
+
 {
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
 	/*
 	 * There's always some degree of trust or collaboration between SR-IOV
 	 * PF and VFs, even if just that the PF hosts the SR-IOV capability and
@@ -1854,7 +1858,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 		bool match;
 
 		if (!pf_vdev) {
-			if (!vf_token)
+			if (!uuid)
 				return 0; /* PF is not vfio-pci, no VF token */
 
 			pci_info_ratelimited(vdev->pdev,
@@ -1862,7 +1866,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 			return -EINVAL;
 		}
 
-		if (!vf_token) {
+		if (!uuid) {
 			pci_info_ratelimited(vdev->pdev,
 				"VF token required to access device\n");
 			return -EACCES;
@@ -1880,7 +1884,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 	} else if (vdev->vf_token) {
 		mutex_lock(&vdev->vf_token->lock);
 		if (vdev->vf_token->users) {
-			if (!vf_token) {
+			if (!uuid) {
 				mutex_unlock(&vdev->vf_token->lock);
 				pci_info_ratelimited(vdev->pdev,
 					"VF token required to access device\n");
@@ -1893,12 +1897,12 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 					"Incorrect VF token provided for device\n");
 				return -EACCES;
 			}
-		} else if (vf_token) {
+		} else if (uuid) {
 			uuid_copy(&vdev->vf_token->uuid, uuid);
 		}
 
 		mutex_unlock(&vdev->vf_token->lock);
-	} else if (vf_token) {
+	} else if (uuid) {
 		pci_info_ratelimited(vdev->pdev,
 			"VF token incorrectly provided, not a PF or VF\n");
 		return -EINVAL;
@@ -1906,6 +1910,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_match_token_uuid);
 
 #define VF_TOKEN_ARG "vf_token="
 
@@ -1952,7 +1957,8 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 		}
 	}
 
-	ret = vfio_pci_validate_vf_token(vdev, vf_token, &uuid);
+	ret = core_vdev->ops->match_token_uuid(core_vdev,
+					       vf_token ? &uuid : NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
index 515fe1b9f94d80..8084f3e36a9f70 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -94,6 +94,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_lm_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
@@ -114,6 +115,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_tran_lm_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
@@ -134,6 +136,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 707b00772ce1ff..eb563f538dee51 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -105,6 +105,9 @@ struct vfio_device {
  * @match: Optional device name match callback (return: 0 for no-match, >0 for
  *         match, -errno for abort (ex. match with insufficient or incorrect
  *         additional args)
+ * @match_token_uuid: Optional device token match/validation. Return 0
+ *         if the uuid is valid for the device, -errno otherwise. uuid is NULL
+ *         if none was provided.
  * @dma_unmap: Called when userspace unmaps IOVA from the container
  *             this device is attached to.
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
@@ -132,6 +135,7 @@ struct vfio_device_ops {
 	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
 	void	(*request)(struct vfio_device *vdev, unsigned int count);
 	int	(*match)(struct vfio_device *vdev, char *buf);
+	int	(*match_token_uuid)(struct vfio_device *vdev, const uuid_t *uuid);
 	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
 	int	(*device_feature)(struct vfio_device *device, u32 flags,
 				  void __user *arg, size_t argsz);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index fbb472dd99b361..f541044e42a2ad 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -122,6 +122,8 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
+int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
+				   const uuid_t *uuid);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 5764f315137f99..75100bf009baf5 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -905,10 +905,12 @@ struct vfio_device_feature {
  * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
  *				   struct vfio_device_bind_iommufd)
  * @argsz:	 User filled size of this data.
- * @flags:	 Must be 0.
+ * @flags:	 Must be 0 or a bit flags of VFIO_DEVICE_BIND_*
  * @iommufd:	 iommufd to bind.
  * @out_devid:	 The device id generated by this bind. devid is a handle for
  *		 this device/iommufd bond and can be used in IOMMUFD commands.
+ * @token_uuid_ptr: Valid if VFIO_DEVICE_BIND_FLAG_TOKEN. Points to a 16 byte
+ *                  UUID in the same format as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN.
  *
  * Bind a vfio_device to the specified iommufd.
  *
@@ -917,13 +919,21 @@ struct vfio_device_feature {
  *
  * Unbind is automatically conducted when device fd is closed.
  *
+ * A token is sometimes required to open the device, unless this is known to be
+ * needed VFIO_DEVICE_BIND_FLAG_TOKEN should not be set and token_uuid_ptr is
+ * ignored. The only case today is a PF/VF relationship where the VF bind must
+ * be provided the same token as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN provided to
+ * the PF.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_device_bind_iommufd {
 	__u32		argsz;
 	__u32		flags;
+#define VFIO_DEVICE_BIND_FLAG_TOKEN (1 << 0)
 	__s32		iommufd;
 	__u32		out_devid;
+	__aligned_u64	token_uuid_ptr;
 };
 
 #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)

base-commit: 3e2a9811f6a9cefd310cc33cab73d5435b4a4caa
-- 
2.43.0



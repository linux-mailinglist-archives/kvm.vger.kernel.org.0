Return-Path: <kvm+bounces-50531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 918CFAE6EAB
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:34:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CF041BC23DF
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EAAD2E613A;
	Tue, 24 Jun 2025 18:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ru5c7SIH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2069.outbound.protection.outlook.com [40.107.100.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998B62E62BE
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750790089; cv=fail; b=UNZqWO5ucfkSaqcDkPXHAGQ4SWLEh4qjYdEcOjRSYiGGQtzkuJpR+Qm3GG6k6qCNYCFybAd+Xwg0HGOSq0VI7zbchZtDcqTclXky2ryrIlbmxGbuVq/qDo2oEApvcDFNzk/hEjGMi7u1msOzOjM5kiEma1W3SEzwPmFlYmvJvss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750790089; c=relaxed/simple;
	bh=wf9BSCjjcDhA71B/ZQWGacpsh+tX1oyTL5XXS0Lm8oY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bJnEFksrauRKTmTwi0HrCmEEo7VZV5lrQXBLXc087vpdlmcEDSihUKgCNlsVOUMjG4cyllFg4qMwUpq63+J1Unj2FmjjAwv+lNoIP7AYLOj9BPk7QUohEjfZZxk0d2bSLUSrgMeSfyff/enYVjEOGpdPHRdUMcqYh0orCJkI01Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ru5c7SIH; arc=fail smtp.client-ip=40.107.100.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iTd0Inv6992XFNo0U3flB+YaouciTVdrJMreeH0i51jCEMmA1t3E/XteWEFneCmtlbhoiH27Mjyose/nYqvhRiXucLZaB+b5ELBvDRsB92LUCWbh9jUyKOtczJ6Bf0oCGAOxxR2l+dGKbUXJOCvWxUF0vUCEZfSBxU/5Lepw+UvcdYgUygK+yfB+gSgPT8SppmryEZPJ/Gi/S5zDMrH/b2Ivw3DX8etnQqQbrPRbl5qIj0jGNpGqdU85fW/axoHAWScsVR/1dKCv3PegcnESFuWJfHURrVpfTB6VHp16hCA/CG0AZmctAzucxri6EtUGmw5oiB7JxqOyw8C8E6sZfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPCHZbCnO9HjGjxeoBf04p4/lO6XDtgE26DP/mwR9Fo=;
 b=jB9N6NnWwUlq1jAYsSrvyJJeSwQuTZPWr7X31FaKS3/klvfaqHDlvnYjYY603W9T83xoS1B5T5pTvJOR4yLzAjxDHLfRk62OHuiOCu7cJPg1VKVzzohw88vvgb26cq2OBwWodtmuu5z3C2vUjOEbImPw9S7aQJKguqQQkj18JMAseeZlKFNXJO91lnUC1wjzVZMxNFBxkGgUOUxs5Pbv1c7QsJIDkEaLfTYbIE32nUsoWvT4o6SC96AUKSqkeAsV2jaGkwMo6TQG0u88O5riueXlb8FiPDf7w+Uhtihq6Q/bu/nt0Pr1jD645zWLaNhdmfY2uxhpxB1lHv1/mK1yzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPCHZbCnO9HjGjxeoBf04p4/lO6XDtgE26DP/mwR9Fo=;
 b=Ru5c7SIH/pQ5MwBEHsczzIzUMmjqOGidswjAqXcbOWTkPJFmsV7xQppPcr6/Vptdp+e1G7RN9pbKN5s6VtO1j48MZTKCWitlCx6ZxGIPLMtUKPVBVjPpZBxsuWRs9bTsXdcEJeDOd2v0CK7PWzJLrWukoqULTq0Ur25NFxkh0w/88TMyPzX9ZSX/4mwwPKadg876M78Ilgwg0yFKJarwAQORIpWIdJJpxCiGDV+kgFeNXd1GpzRuDBBz/AoXTnVrCqR3S/jnHuUNtir9rYOh0rCKFBGnVt++IhA/mooO0dK57xE2m6JzGnEzoK5xdF7P8cK9+ZsIXaEDak7S5Tjs5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Tue, 24 Jun
 2025 18:34:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Tue, 24 Jun 2025
 18:34:42 +0000
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
Subject: [PATCH] vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD
Date: Tue, 24 Jun 2025 15:34:40 -0300
Message-ID: <0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB5712:EE_
X-MS-Office365-Filtering-Correlation-Id: 24dc4a47-1d3b-4de2-7bdc-08ddb34dc887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JiDgSdMlC3yZFzIUXIRuzF+tVb07xxUQaypgZGmmj7mPFDlN+vim6/jKx/xi?=
 =?us-ascii?Q?Gv10q6tqz+BPQwsSZ7vMoLNDxD3DpuVZiUNZS2yKXy/PjTSjZ80jW+GzpCzt?=
 =?us-ascii?Q?XiIUXCJ6D/Y5JNlKnM+ybbH24Qn1NZYLAvIttWsOyYlCld3iVkoCO8JsZ9Yp?=
 =?us-ascii?Q?4wyaAyz822v5UpiVmKjuiKfBsQOP1s/nUNqvqMBw6SE9Tk+Mzis/tJOgsA4l?=
 =?us-ascii?Q?MrckoIb04EtX2RV6Pcf/wwyEH2ouDaie/lTUwV4SOthgWLZ73+6D/9AoDXeg?=
 =?us-ascii?Q?gOCWP4J5QxXM6BfMdc71CG15smtd/cgFVa1wXGClUUp1BTbJ34oA4ZaDT/Az?=
 =?us-ascii?Q?bSTaoQ6SU65fYHTayH2L84TaWGKmX7pYDGLbCDHo9ts2D5n6iA4vXdHKtSs9?=
 =?us-ascii?Q?dkPyRKOY3jroS9zTEGRcc9PgDDl3i7k/fLozc47bwqWxFYu1tSJffkg5K8ro?=
 =?us-ascii?Q?GUDvSQgkw4MOlPwycrCFqmJtoN2k/iSt2DO6LbyAeDzeEJmbPtjyLiB/9qq/?=
 =?us-ascii?Q?dAatg8N+zdQhq4J/Jx3qv1j/6aJFPLbUUW97TnKp3sc+Dopd2SCCqEQ7rHjf?=
 =?us-ascii?Q?ZECZCVa/466/hrLJvNd7YUJUbGmaCrm+Fo6hB3JKtcP/SLviwIsorJBIj1UI?=
 =?us-ascii?Q?zMM1Zcke1YhcEzM4OwffJN5zFImx5iqx++3oDLmLYVO8PCCKwnbjlYpdeltO?=
 =?us-ascii?Q?WPxp6RHYDylizsEufKh3+MsoDhu+kcIKjlC/E83cVl1rcRpk0oM7x4g4j8Jt?=
 =?us-ascii?Q?6D8dHl0WONt8URs6gsHdEH+X8fdT0nWu3pslfxT99gUxHBdkrCxG7413dA6B?=
 =?us-ascii?Q?8iT+dyTv1tsXYXrH3B/yUcG9PSREulNhtAcsisStsGqqQ8gs6zxOFrisLGPT?=
 =?us-ascii?Q?k03cNWxDAaFWKTNMO7niejbl1mZqZS1EE2kDFBG/cFvs/N+UEbTR//itZ2CB?=
 =?us-ascii?Q?2uvxfG1LKmdg1yTLZiy+W5M4zjSuMKL+K3k67CjCM2LGAOE8/oJ1xMhxGKHJ?=
 =?us-ascii?Q?yUckPIVgPeokqgQnBOBAqKBkWGWOa0p9EvWiY2kEMxcHjJCtMDNGCtptkls1?=
 =?us-ascii?Q?OtccqMxqI+031COtzM/MDARSSHqIPaZVu+OzpJNov0eDyWXbdanrr3hgR93c?=
 =?us-ascii?Q?Kaltijfavg7pJ0lVPnFXeGUtOU2agfv8nd4x0mKcpsDY3v8gTY8ZEYpP5ryI?=
 =?us-ascii?Q?u6x4KOgD0bwoMhZi0nyHrnJWap+F6suooDp/FfXu9LdI8GAf+kEzpPnWt1WT?=
 =?us-ascii?Q?dm3h4P9JRJCe/zpjn19inFZCkHldXaST9SNVZwU0PJT85eBE2Zwm2LPPRznV?=
 =?us-ascii?Q?RX3XhDEQ5RiJW324uFI7P/oA+Klw6jj96769lpbM7DRHTJoryYWBNnw5Rt4l?=
 =?us-ascii?Q?Z3j7QId87nh4RcSNEP90rmKm7CRvW2aBQyK1Pl95DJkDoCXhTzbZJLPcb4bm?=
 =?us-ascii?Q?EY34XdtKlx6GEigt9TfqpZWwrWkcHORwAOKXydVjd5ZqApg22DKUOA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z6iR7Q4paXzVJLXfNFd0YKbjtxQEEf/pTtbcm9kkvVxnqOMbtGS4kp5gS8FB?=
 =?us-ascii?Q?2jBp9W4sMtSNfShKusGd3GVaX8uPRICpOhqWYjKI57dGFaO3ah5ax3S2rhJJ?=
 =?us-ascii?Q?ZZ3YqODz34zhbSan51SxOjaF5nauHAeGtgdtLg2Zph/UXN8YkwjVDBWNpRgj?=
 =?us-ascii?Q?yU0hTuaRmVWhzsGfHkI6/gvlWJ3n7RmgA3/Q6LzCyYWk1QGiuP2UtOStQKna?=
 =?us-ascii?Q?Y3FHx74gc3MDOl/RDSLPiaTgO1pVOjdhsKe4LvPH2YiSTkVYVVNw5Aenr3tc?=
 =?us-ascii?Q?abvi+8tC6wBXWnSGGqdshRZIBNc2VBefFRIJTRNvf8Y6CeeEP5OETkgsIxcA?=
 =?us-ascii?Q?rQwMM5J4bA+OJhFOT7JVn8Y9yWmlrVifHHMjDBt+ROEJ2IO6lgtg+ReRQZwy?=
 =?us-ascii?Q?zcS7yBNeXaSXxHVGVQLoI6sFQPQEx/bhL/18z0BfSIIwuSbRpBiyluI6RGYM?=
 =?us-ascii?Q?xR6cLxLoXdXcngkX3ilxfH5S2NWHDNqFFHC7h1t7et/ElLZ5brAj/9qAGXTY?=
 =?us-ascii?Q?pWSMctRT4Gie39wLvMJOArlVEkJwj5EPsULRJFMWc8CmqES3WQmQE3wpQQbt?=
 =?us-ascii?Q?3I+Fmyv3Ki4Zks22T3ar+Z7M/bht1WMwdRBilHLAsJ/dk8hqjTDsdEBRAUoP?=
 =?us-ascii?Q?Ie3YfMoh+GLqqCTUU6w2q5vxPJ82pgKhOTL9YCCGRVr6PH06EKKwZgnL40oA?=
 =?us-ascii?Q?RY3tenDqyKP+qsO32vT1Uw+7Ytx9Nk8Pi8p77iz8MyhatnrcMqIWzPymhpdD?=
 =?us-ascii?Q?e7cuU9/EqlRMqvwwoThX1wFcHR9zJ+4t3vz6njBRZyWfGUCLHeRWA5koZnO1?=
 =?us-ascii?Q?3QnuAJNg8fDc+X1Hcdh5EIymZprdT4T6Gmn5rJf5+nkBvkiadXa5neUxZ7DO?=
 =?us-ascii?Q?hhvv0Ogo1/jhmNNqwdwZ+M7g93Q1d5c6BFIg1nB3cBvxHNHEstXac83sTjCQ?=
 =?us-ascii?Q?LfPiajej0jhy6iKDvRrVpgD5Uq5M6rQFcBhqsxNBz8Q247jDBrCLZlvLGYQN?=
 =?us-ascii?Q?8OhzjlugncYNVXWaSgHGkclBuamtgtl4HcSwPRzXGgFUjuRe7toTO2bQQMig?=
 =?us-ascii?Q?QtLSTw3QZyGY92JzYXlOEznjHAWAea5jqGYjdwaocw1VPngwrq1mlD+3u604?=
 =?us-ascii?Q?8YXbxgM6nrplAiWdN5Bgn2Dm/PC7jubHQRpsguMgXyyX2VIE59S7x3OmY7GU?=
 =?us-ascii?Q?j6uK8AZccdSeDQ9pqiETB+1QD96He+rWiDZj5I73eS11QYWmtk4qpfa2Nxij?=
 =?us-ascii?Q?/JgCEWrDLewshNUX2thZwG6uTUFly0MaK111sGVw0vo0Y1pfQWlDudw5lIwL?=
 =?us-ascii?Q?jLDdDcMkSFcDqIhq/ZML+K0f/+/IBKOpqCqh3RxagUpK4b8SPXxGYUm25jY6?=
 =?us-ascii?Q?eCiaodSFBLKr/OEMQph+oYXq1U6ZxxmHG8Y5C5/WXEIt8DOhsFoZSzvBuMFt?=
 =?us-ascii?Q?g1BDHrCHO75UiIaTchdrf1R0ry21nkD8dX07FLBnTrST6W843winb88XwSyy?=
 =?us-ascii?Q?mCFbdzFxgYaevj4AcNLccRM+ggDS3ngPVVP8iH38wWn47rgD8uIUJDB9mUKM?=
 =?us-ascii?Q?AT7iQ2kwOfWzNX9k0chICoYYZE+rxwocTYDIJktY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24dc4a47-1d3b-4de2-7bdc-08ddb34dc887
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 18:34:41.9683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQybfqJQKV2jQRfcHOQZuuK2TaZV8fTZPDkIEERfxTeKfkHoWZRwarF8B5JzSX1u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5712

This was missed during the initial implementation. The VFIO PCI encodes
the vf_token inside the device name when opening the device from the group
FD, something like:

  "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"

This is used to control access to a VF unless there is co-ordination with
the owner of the PF.

Since we no longer have a device name pass the token directly though
VFIO_DEVICE_BIND_IOMMUFD with an optional field indicated by
VFIO_DEVICE_BIND_TOKEN. Only users using a PCI SRIOV VF will need to
provide this. This is done in the usual backwards compatible way.

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
 include/linux/vfio.h                          |  1 +
 include/linux/vfio_pci_core.h                 |  2 +
 include/uapi/linux/vfio.h                     | 13 ++++++-
 12 files changed, 74 insertions(+), 12 deletions(-)

I wrote this quickly and don't have an environment available to check it out
on.. Since it feels like a significant miss I felt we should start looking at
it.

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 281a8dc3ed4974..c5d74c7e71f585 100644
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
+		if (bind->flags & VFIO_DEVICE_BIND_TOKEN)
+			return -EINVAL;
+		return 0;
+	}
+
+	if (!(bind->flags & VFIO_DEVICE_BIND_TOKEN))
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
+	const u32 VALID_FLAGS = VFIO_DEVICE_BIND_TOKEN;
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
index 6328c3a05bcdd4..086aa37a60a2b5 100644
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
+	ret = vfio_pci_core_match_token_uuid(core_vdev,
+					     vf_token ? &uuid : NULL);
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
index 707b00772ce1ff..b2cca540a6b4bf 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -132,6 +132,7 @@ struct vfio_device_ops {
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
index 5764f315137f99..48233ec4daf7b4 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -901,14 +901,18 @@ struct vfio_device_feature {
 
 #define VFIO_DEVICE_FEATURE		_IO(VFIO_TYPE, VFIO_BASE + 17)
 
+#define VFIO_DEVICE_BIND_TOKEN (1 << 0)
+
 /*
  * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
  *				   struct vfio_device_bind_iommufd)
  * @argsz:	 User filled size of this data.
- * @flags:	 Must be 0.
+ * @flags:	 Must be 0 or a bit flags of VFIO_DEVICE_BIND_*
  * @iommufd:	 iommufd to bind.
  * @out_devid:	 The device id generated by this bind. devid is a handle for
  *		 this device/iommufd bond and can be used in IOMMUFD commands.
+ * @token_uuid_ptr: Valid if VFIO_DEVICE_BIND_TOKEN. Points to a 16 byte UUID
+ *                  in the same format as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN.
  *
  * Bind a vfio_device to the specified iommufd.
  *
@@ -917,6 +921,12 @@ struct vfio_device_feature {
  *
  * Unbind is automatically conducted when device fd is closed.
  *
+ * A token is sometimes required to open the device, unless this is known to be
+ * needed VFIO_DEVICE_BIND_TOKEN should not be set and token_uuid_ptr is
+ * ignored. The only case today is a PF/VF relationship where the VF bind must
+ * be provided the same token as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN provided to
+ * the PF.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_device_bind_iommufd {
@@ -924,6 +934,7 @@ struct vfio_device_bind_iommufd {
 	__u32		flags;
 	__s32		iommufd;
 	__u32		out_devid;
+	__aligned_u64	token_uuid_ptr;
 };
 
 #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)

base-commit: 3e2a9811f6a9cefd310cc33cab73d5435b4a4caa
-- 
2.43.0



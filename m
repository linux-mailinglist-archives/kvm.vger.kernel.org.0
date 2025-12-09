Return-Path: <kvm+bounces-65559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F22CB0A19
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 91B9F3022818
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9279D329E53;
	Tue,  9 Dec 2025 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UsB9SiP/"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010065.outbound.protection.outlook.com [52.101.201.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2029827815D;
	Tue,  9 Dec 2025 16:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299090; cv=fail; b=FNmCESsUdtRdBMXoJeij5fBC7gObzShqNGDJMjOAi8E5Vt/IcYGjfvYYQQDpBAUF7l4S0FJEjzarSnO63/cz4JWzvhgW9Usyh0iZ9Jg5d+wDKCozOCR2z99Db3wpy59FYsxKcQ5tBTB0zorOz/hz3nUOBDB9h72mNB6IrhbCVGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299090; c=relaxed/simple;
	bh=BSv2jL6FThmkCnFMNsussK9NCtrQZwxpl5QMypDAfR0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gOH5X19KD4ETEljFG8IBWjwIj69mtR6xvuVmmc1twFPsMsIPjF396mDGv7nJcLd6iyExD7clLR/IA9yVrF5BPJD3U41OMCiaeD9dnUROpgeJ1ZpajgRmJHwGRoYIgQnNSEOnIRWIOEUe2NhDbdlI0BQ9bA6NDSqwH8woKof8SzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UsB9SiP/; arc=fail smtp.client-ip=52.101.201.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fAiqsLGrgEUrRT19qmHIMftiHlq9h2QXs6nCYvfFaYax5DjwJIr1P9AEXyypEz2vl+xMt/f3ZvplJK4w1Pj1v0wUAMV6OzOVRCgbLKAGHCHxVLX6DFTI6x8oCClwb4LQfCapJ5y5yUzSYxdPF3aM/LX706w2DiA7zqetd1WrhM0YxV+IAS09/GW5Hen3qJEHIDEFUNRQM+ar4zoTMsFsKkeKBgOcPZuAoTbwGv8TWdxhc9TjMT7h4DHWwbjBDlBoOWWq0HA2nDtD8nfLqfIiR9MANltiSX2WF7gBjBv47V6XWh0TLQa7i9i6XQ95XI4koLddOkJHiPyTZm2ZmcEh6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vk4lSlXl49u7nTsi+pmSg/faOO08TRbUKKX+vWGY9Is=;
 b=oHfReoDNJJUUwMVFXMOjDc6LImlkYI+rSALseTmDdUmTcXcgxcNAkZyKAzflFR4rIMgl4Mca5t12cWr1LFJ2/3kZsSpX7DYpk+UM2Uo8nGwG7fjKQQdXNLsEquk6vSQPvcBctFsIpwGgiNLOOaBFrmcdHg/vIKzpjxIjWL5Ums4YkJ0wSrmKeY2PGyrYZHNQIjf7bzGWAL9/nVa4S9uS6aUzR7l16+efxZYXuV4X0vZRVisMF//rPwgscLYrpg7Kh90dmadqQyHfNZssdc9eXRVq6cB11Y2aUgYXb6GNtYZO3mwsTwUuPCkwvr1miQ1X0wQcoK2j+/NnHPVZ4wxd/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vk4lSlXl49u7nTsi+pmSg/faOO08TRbUKKX+vWGY9Is=;
 b=UsB9SiP/tQ99v7ivgNauO9wE5VSfC/WuVxkFmM77wXci6gR5KOnXyMB/23I2ce45eaAwEMH17ju3FNc1s/RxnXby7qw6twycVBiutaWLPl2oIC4UYa7Yap5Eb0vaV8xG4QCNKnVbJ08fzs3m2EcTiVk74+raCZ7m/fWjJ20AvbN7BAmN462y4W+vKNp7wIIn0YRXwKzZbNaZPtw1YP+WAwkOMjQ0povJOjRRED8ICfff8aso4LFVWisJamd8TJTB0zRI6nhKaQIZVOtahW7i9bUXLF8ZyyXL+i2D+Lb6mfXWbqQ7sWc5zAHtZlDz2yuh1ti7mSA9dpYdnySx62Gbow==
Received: from SJ0PR03CA0246.namprd03.prod.outlook.com (2603:10b6:a03:3a0::11)
 by MW6PR12MB8835.namprd12.prod.outlook.com (2603:10b6:303:240::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 16:51:18 +0000
Received: from SJ1PEPF00002311.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::45) by SJ0PR03CA0246.outlook.office365.com
 (2603:10b6:a03:3a0::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:50:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002311.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:51:18 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:50:57 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:50:56 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:50:49 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>, "Li
 Ming" <ming.li@zohomail.com>
Subject: [RFC v2 01/15] cxl: factor out cxl_await_range_active() and cxl_media_ready()
Date: Tue, 9 Dec 2025 22:20:05 +0530
Message-ID: <20251209165019.2643142-2-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002311:EE_|MW6PR12MB8835:EE_
X-MS-Office365-Filtering-Correlation-Id: 3270ddf5-e6c2-4273-783c-08de37432cd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zPjue+UyZ/+MR3ts9D/fxyr+twyqgIRhGD9myG7PNbcClqTL6FlzW/ovGfPb?=
 =?us-ascii?Q?orUauXNN9BgHh+r/DJmS/FbBxVrOGjcQJ7ErnqZmbvM53pzbV/Veu1iFSiK6?=
 =?us-ascii?Q?yo3BTtHJbJl9IMlGcXeQI76PI7BO1HNL+GX4oRwSCUw/+pewjUsieFX0eXwX?=
 =?us-ascii?Q?2BRp1RcvCRho4Ws9Svthbd4lgmxDOqbsIIvjOVqQ0Lfe/Dl6kYxKJ+lDoAWw?=
 =?us-ascii?Q?PAGv1L0F1WuZl0DeP236s9abFpovBQ1HErwUT9zhoS/8OXI+Da3gmzAc0Mwt?=
 =?us-ascii?Q?QITUBUdBwW1nPohBd2C56z3/KK1z/bTF2kSfPd9nYd6p+8LbZ/foelJ1JMPR?=
 =?us-ascii?Q?t+yNrEbZqte6odaWKiT4PanJLLkJ1wrurOWXAb+7NVSo4yOAtzZDflI/0SOI?=
 =?us-ascii?Q?8ndeJMofRoD/lXqYVjwESfNKTP54JcjledDFQmci4px8tTBAhKEwQGB885wp?=
 =?us-ascii?Q?6R2jwejcdb8uTDblwc29H+8zWjdrVifhxg//KjoIHZw2/o5KCQfVem+Nkfvb?=
 =?us-ascii?Q?kU3OZZo2AL/YsSRwj9lYh5gZHnGEmPKoy0Zv5vN1PNKCaSY3Gh3mGS6SRw9A?=
 =?us-ascii?Q?Oelpktuf/kLdktkhq9T2Nied4B3IKGsgUPEmrbpVRkifzHSQ81dYmZu95/ES?=
 =?us-ascii?Q?kHrGKu05uEjT7G1OZ3w+fQ/zTrwDfaFPhA1wMc9hKPS9clt4+1aKBsTtaQNJ?=
 =?us-ascii?Q?+LTjrpJpp7KOKhrErywQUmmxtJwRzgD5Ufrhgvp5r3bfuSansAUFqyudBG6g?=
 =?us-ascii?Q?ZRkoxcq6h1Ossmm92+Iz395nHC7aMKVemIAIvZR4d/jdFxak+xrw18MJs8SG?=
 =?us-ascii?Q?TFwPXqsS8P2r/cndF5Z0gzGCjB1I+SJFg+n2i7+pY9q9dRfTEEbZqgtKCirJ?=
 =?us-ascii?Q?IlNTpjZF0t8kn0MwA8VBen0jaGfkk7tphG+6qiDAAiyJSOVI45YFVg5wJejM?=
 =?us-ascii?Q?v3id/xRTzGHlnTPi5YZzvyv1ANzg04wMZXu4Dvd04Zg7AU+8ttqXclhMSg6S?=
 =?us-ascii?Q?OWLvTbo6jg8DQhJ3RrLMBKRSWgtCO7OgOL3OyfgCjcyv4Q6u9r5SJb+UZv0c?=
 =?us-ascii?Q?/dSPswOhZdAoPg9edFMlSsYI0iM9LDXVX4wjwDOZUFCAK6IKssphJC/bftvM?=
 =?us-ascii?Q?CLIJWHmaHOBIrIw910wd5lKUyU43tHy29YHPboHBYmBBtifrYf5FpEkELxnA?=
 =?us-ascii?Q?mA1GGb2BTf+HZCPHrlYYW249LTxuc+4FZg0lyk82wsALi0skbBNYGEIcRodb?=
 =?us-ascii?Q?h9F+x639y7S3zNuaacsWPcpej6KeriCqIOoHx4uRGvoWHA4jc3dgCtZhWe58?=
 =?us-ascii?Q?umq47Fy3mZxXK9c6RzJ677HX/pZ/LluP1wGBirH9H4v27k2hbZxkaxgS3456?=
 =?us-ascii?Q?C11I2p3srUVbEE7HlL6nIr6nGLylgWUzAVRaWLi8Av990yf3CCfMgMAGj592?=
 =?us-ascii?Q?0rROXGaJq4CqHP1SLMQeW73VzmhGOVt6zBgKBeytduZf7h/PjFpvvewD18oX?=
 =?us-ascii?Q?vvTysTsce3qPavUGD1Jhf3b6Nbgrb1TG3qTJI469/6JedareffF3tNpgWcIU?=
 =?us-ascii?Q?hFRxeWFJlAZzgU3EcQcZd8evueOzum/oGOEqrUG5?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:51:18.6665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3270ddf5-e6c2-4273-783c-08de37432cd9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002311.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8835

From: Zhi Wang <zhiw@nvidia.com>

Before accessing the CXL device memory after reset/power-on, the driver
needs to ensure the device memory media is ready.

However, not every CXL device implements the CXL memory device register
groups. E.g. a CXL type-2 device. Thus calling cxl_await_media_ready()
on these device will lead to a kernel panic. This problem was found when
testing the emulated CXL type-2 device without a CXL memory device
register.

[   97.662720] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   97.663963] #PF: supervisor read access in kernel mode
[   97.664860] #PF: error_code(0x0000) - not-present page
[   97.665753] PGD 0 P4D 0
[   97.666198] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
[   97.667053] CPU: 8 UID: 0 PID: 7340 Comm: qemu-system-x86 Tainted: G            E      6.11.0-rc2+ #52
[   97.668656] Tainted: [E]=UNSIGNED_MODULE
[   97.669340] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   97.671243] RIP: 0010:cxl_await_media_ready+0x1ac/0x1d0
[   97.672157] Code: e9 03 ff ff ff 0f b7 1d d6 80 31 01 48 8b 7d b8 89 da 48 c7 c6 60 52 c6 b0 e8 00 46 f6 ff e9 27 ff ff ff 49 8b 86 a0 00 00 00 <48> 8b 00 83 e0 0c 48 83 f8 04 0f 94 c0 0f b6 c0 8d 44 80 fb e9 0c
[   97.675391] RSP: 0018:ffffb5bac7627c20 EFLAGS: 00010246
[   97.676298] RAX: 0000000000000000 RBX: 000000000000003c RCX: 0000000000000000
[   97.677527] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   97.678733] RBP: ffffb5bac7627c70 R08: 0000000000000000 R09: 0000000000000000
[   97.679951] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   97.681144] R13: ffff9ef9028a8000 R14: ffff9ef90c1d1a28 R15: 0000000000000000
[   97.682370] FS:  00007386aa4f3d40(0000) GS:ffff9efa77200000(0000) knlGS:0000000000000000
[   97.683721] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   97.684703] CR2: 0000000000000000 CR3: 0000000169a14003 CR4: 0000000000770ef0
[   97.685909] PKRU: 55555554
[   97.686397] Call Trace:
[   97.686819]  <TASK>
[   97.687243]  ? show_regs+0x6c/0x80
[   97.687840]  ? __die+0x24/0x80
[   97.688391]  ? page_fault_oops+0x155/0x570
[   97.689090]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.689973]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.690848]  ? __vunmap_range_noflush+0x420/0x4e0
[   97.691700]  ? do_user_addr_fault+0x4b2/0x870
[   97.692606]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.693502]  ? exc_page_fault+0x82/0x1b0
[   97.694200]  ? asm_exc_page_fault+0x27/0x30
[   97.694975]  ? cxl_await_media_ready+0x1ac/0x1d0
[   97.695816]  vfio_cxl_core_enable+0x386/0x800 [vfio_cxl_core]
[   97.696829]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.697685]  cxl_open_device+0xa6/0xd0 [cxl_accel_vfio_pci]
[   97.698673]  vfio_df_open+0xcb/0xf0
[   97.699313]  vfio_group_fops_unl_ioctl+0x294/0x720
[   97.700149]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.701011]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.701858]  __x64_sys_ioctl+0xa3/0xf0
[   97.702536]  x64_sys_call+0x11ad/0x25f0
[   97.703214]  do_syscall_64+0x7e/0x170
[   97.703878]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.704726]  ? do_syscall_64+0x8a/0x170
[   97.705425]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.706282]  ? kvm_device_ioctl+0xae/0x130 [kvm]
[   97.707135]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.708001]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.708853]  ? syscall_exit_to_user_mode+0x4e/0x250
[   97.709724]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.710609]  ? do_syscall_64+0x8a/0x170
[   97.711300]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.712132]  ? exc_page_fault+0x93/0x1b0
[   97.712839]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   97.713735] RIP: 0033:0x7386ab124ded
[   97.714382] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
[   97.717664] RSP: 002b:00007ffcda2a6480 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   97.718965] RAX: ffffffffffffffda RBX: 00006293226d9f20 RCX: 00007386ab124ded
[   97.720222] RDX: 00006293226db730 RSI: 0000000000003b6a RDI: 0000000000000009
[   97.721522] RBP: 00007ffcda2a64d0 R08: 00006293214e9010 R09: 0000000000000007
[   97.722858] R10: 00006293226db730 R11: 0000000000000246 R12: 00006293226e0880
[   97.724193] R13: 00006293226db730 R14: 00007ffcda2a7740 R15: 00006293226d94f0
[   97.725491]  </TASK>
[   97.725883] Modules linked in: cxl_accel_vfio_pci(E) vfio_cxl_core(E) vfio_pci_core(E) snd_seq_dummy(E) snd_hrtimer(E) snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E) qrtr(E) intel_rapl_msr(E) intel_rapl_common(E) kvm_amd(E) ccp(E) binfmt_misc(E) kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) polyval_clmulni(E) polyval_generic(E) ghash_clmulni_intel(E) sha256_ssse3(E) sha1_ssse3(E) aesni_intel(E) i2c_i801(E) crypto_simd(E) cryptd(E) i2c_smbus(E) lpc_ich(E) joydev(E) input_leds(E) mac_hid(E) serio_raw(E) msr(E) parport_pc(E) ppdev(E) lp(E) parport(E) efi_pstore(E) dmi_sysfs(E) qemu_fw_cfg(E) autofs4(E) bochs(E) e1000e(E) drm_vram_helper(E) psmouse(E) drm_ttm_helper(E) ahci(E) ttm(E) libahci(E)
[   97.736690] CR2: 0000000000000000
[   97.737285] ---[ end trace 0000000000000000 ]---

Factor out cxl_await_range_active() and cxl_media_ready(). Type-3 device
should call both for ensuring media ready while type-2 device should only
call cxl_await_range_active().

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Li Ming <ming.li@zohomail.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/cxl/core/pci.c        | 18 +++++++++++-------
 drivers/cxl/core/pci_drv.c    |  3 +--
 drivers/cxl/cxlmem.h          |  3 ++-
 include/cxl/cxl.h             |  1 +
 tools/testing/cxl/Kbuild      |  3 ++-
 tools/testing/cxl/test/mock.c | 21 ++++++++++++++++++---
 6 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 90a0763e72c4..a0cda2a8fdba 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -225,12 +225,11 @@ static int cxl_dvsec_mem_range_active(struct cxl_dev_state *cxlds, int id)
  * Wait up to @media_ready_timeout for the device to report memory
  * active.
  */
-int cxl_await_media_ready(struct cxl_dev_state *cxlds)
+int cxl_await_range_active(struct cxl_dev_state *cxlds)
 {
 	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
 	int d = cxlds->cxl_dvsec;
 	int rc, i, hdm_count;
-	u64 md_status;
 	u16 cap;
 
 	rc = pci_read_config_word(pdev,
@@ -251,13 +250,18 @@ int cxl_await_media_ready(struct cxl_dev_state *cxlds)
 			return rc;
 	}
 
-	md_status = readq(cxlds->regs.memdev + CXLMDEV_STATUS_OFFSET);
-	if (!CXLMDEV_READY(md_status))
-		return -EIO;
-
 	return 0;
 }
-EXPORT_SYMBOL_NS_GPL(cxl_await_media_ready, "CXL");
+EXPORT_SYMBOL_NS_GPL(cxl_await_range_active, "CXL");
+
+int cxl_media_ready(struct cxl_dev_state *cxlds)
+{
+	u64 md_status;
+
+	md_status = readq(cxlds->regs.memdev + CXLMDEV_STATUS_OFFSET);
+	return CXLMDEV_READY(md_status) ? 0 : -EIO;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_media_ready, "CXL");
 
 static int cxl_set_mem_enable(struct cxl_dev_state *cxlds, u16 val)
 {
diff --git a/drivers/cxl/core/pci_drv.c b/drivers/cxl/core/pci_drv.c
index 4c767e2471b8..6e519b197f0d 100644
--- a/drivers/cxl/core/pci_drv.c
+++ b/drivers/cxl/core/pci_drv.c
@@ -899,8 +899,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	rc = cxl_await_media_ready(cxlds);
-	if (rc == 0)
+	if (!cxl_await_range_active(cxlds) && !cxl_media_ready(cxlds))
 		cxlds->media_ready = true;
 	else
 		dev_warn(&pdev->dev, "Media not active (%d)\n", rc);
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 918784edd23c..62ace404d681 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -767,7 +767,8 @@ enum {
 int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
 			  struct cxl_mbox_cmd *cmd);
 int cxl_dev_state_identify(struct cxl_memdev_state *mds);
-int cxl_await_media_ready(struct cxl_dev_state *cxlds);
+int cxl_await_range_active(struct cxl_dev_state *cxlds);
+int cxl_media_ready(struct cxl_dev_state *cxlds);
 int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
 int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
 struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index e5d1e5a20e06..f18194b9e3e2 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -262,6 +262,7 @@ int cxl_map_component_regs(const struct cxl_register_map *map,
 			   struct cxl_component_regs *regs,
 			   unsigned long map_mask);
 int cxl_set_capacity(struct cxl_dev_state *cxlds, u64 capacity);
+int cxl_await_range_active(struct cxl_dev_state *cxlds);
 struct cxl_memdev *devm_cxl_add_memdev(struct device *host,
 				       struct cxl_dev_state *cxlds,
 				       const struct cxl_memdev_ops *ops);
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index d422c81cefa3..4b05b21083ad 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -5,7 +5,8 @@ ldflags-y += --wrap=acpi_evaluate_integer
 ldflags-y += --wrap=acpi_pci_find_root
 ldflags-y += --wrap=nvdimm_bus_register
 ldflags-y += --wrap=devm_cxl_port_enumerate_dports
-ldflags-y += --wrap=cxl_await_media_ready
+ldflags-y += --wrap=cxl_await_range_active
+ldflags-y += --wrap=cxl_media_ready
 ldflags-y += --wrap=devm_cxl_add_rch_dport
 ldflags-y += --wrap=cxl_endpoint_parse_cdat
 ldflags-y += --wrap=cxl_dport_init_ras_reporting
diff --git a/tools/testing/cxl/test/mock.c b/tools/testing/cxl/test/mock.c
index 92fd5c69bef3..4f1f65e50e87 100644
--- a/tools/testing/cxl/test/mock.c
+++ b/tools/testing/cxl/test/mock.c
@@ -187,7 +187,7 @@ int __wrap_devm_cxl_port_enumerate_dports(struct cxl_port *port)
 }
 EXPORT_SYMBOL_NS_GPL(__wrap_devm_cxl_port_enumerate_dports, "CXL");
 
-int __wrap_cxl_await_media_ready(struct cxl_dev_state *cxlds)
+int __wrap_cxl_await_range_active(struct cxl_dev_state *cxlds)
 {
 	int rc, index;
 	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
@@ -195,12 +195,27 @@ int __wrap_cxl_await_media_ready(struct cxl_dev_state *cxlds)
 	if (ops && ops->is_mock_dev(cxlds->dev))
 		rc = 0;
 	else
-		rc = cxl_await_media_ready(cxlds);
+		rc = cxl_await_range_active(cxlds);
 	put_cxl_mock_ops(index);
 
 	return rc;
 }
-EXPORT_SYMBOL_NS_GPL(__wrap_cxl_await_media_ready, "CXL");
+EXPORT_SYMBOL_NS_GPL(__wrap_cxl_await_range_active, "CXL");
+
+int __wrap_cxl_media_ready(struct cxl_dev_state *cxlds)
+{
+	int rc, index;
+	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
+
+	if (ops && ops->is_mock_dev(cxlds->dev))
+		rc = 0;
+	else
+		rc = cxl_media_ready(cxlds);
+	put_cxl_mock_ops(index);
+
+	return rc;
+}
+EXPORT_SYMBOL_NS_GPL(__wrap_cxl_media_ready, "CXL");
 
 struct cxl_dport *__wrap_devm_cxl_add_rch_dport(struct cxl_port *port,
 						struct device *dport_dev,
-- 
2.25.1



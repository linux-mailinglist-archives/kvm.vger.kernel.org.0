Return-Path: <kvm+bounces-53875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B0DB19189
	for <lists+kvm@lfdr.de>; Sun,  3 Aug 2025 04:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 826BF174410
	for <lists+kvm@lfdr.de>; Sun,  3 Aug 2025 02:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A18914A09C;
	Sun,  3 Aug 2025 02:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m1I1g8Qt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAE52566
	for <kvm@vger.kernel.org>; Sun,  3 Aug 2025 02:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754189302; cv=fail; b=dvZeJqZG/09T83GDQ0efI4srJV4sK5ZY3njm8YaLjuS099lHwrl/i2Cgvrsl+OIGZ1H6WKVq41/F+5T8hFoNMs0ZvsI8Acc6p7EqIBmBqZj0Lcci6XwEZzDuY2S3E+q0/wxRKAnkemB0OwhvJAtPvr+voeDTuYT/iZ5UzZPWIGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754189302; c=relaxed/simple;
	bh=Uufb7BFoQMVVb5XIK4DPuv5iwFxyrEZUrPH0kdM9d4A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PjkxWKOqYHZSR2YltQqxXjuOr4HWjDNJMdz5cj202Avet25Jmy7dISZx2Pjtrz/Z9FEhCnd2TPLUKN6Lu0HpqWxeFkyvPzXkNQewwlMlcDYvj21bfJ6yLnkVE/2LVtmCZoGUl93K1uxNCXoqSFgItlYBZOGobbMA1BC0U1ZI+Zw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m1I1g8Qt; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ermjAO08bbCJ5P2y5JoSjhdwLvfnLKkBec/ct2J1ItI88BkOTPAObRZ9BlT58SzBffSzPMFNXBFaH+qTfsstanR2BQ2upB3FNnn/iGttGaBsNZ5WJloxIuB0NgOxM1dcAHA0JFevb0hjpeivVHrTIxCklSnNPx6vkCSHWcSGaK2aSYpiTKIhP548YUUtb6bN1VUXZpWa2aSOydOBYCRomtM4VvLfu6AoLthMQlXZjdFMBex1M1aVB3DkBbe4aqwkIBaK6MlOPjZzScJsTJbSasoK+m9/36I/jDfGD+VGBc9MZLLyt2VoDZ95mfbxiSaHeUoxunPsBfv+WmTPrIOzaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/VhMyVClCHk08Q59Sac2vCJKpqOvPbfiClTlA0COUZw=;
 b=nIG8IjBvhhgKT9VtTwtPrQSDiqu/RwG6M/zn61C9gTQku7AS7bTf5qzqfs3yiNXJZVyOQyHtB58Vi7hV5hds8qX3Xekl3HSDY9N9Z0Nxq1qaPUExom+r4ngd0WzX2v65kYuJIlJg6f7gteduHgAnhCXOj03J+CxMWxjZYGt1R0P2L5jjlmQhmW00/qpa5QMBl1FnQWVdxXcuun+MVx1Q03ftj3ANi3TSvIPBbCxQtNBXOoQNTUZ+TlvrPamG0OFinmEX0SGOFMORRnSBXbzt46EGCrDA9D93ZtFHaaBfczrjxAWQqhFYe5O626ukE2JWxuKgW9hmZhDhbVx9XfWa2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VhMyVClCHk08Q59Sac2vCJKpqOvPbfiClTlA0COUZw=;
 b=m1I1g8QtSEiMfiWRhtpdQ/Hell/P8R8ZI/O3kcXDTiYoxcFQoYWN4+0Zxy+DgNRQcEet+o8SqtJqk8RKsO0Yt+mrfLHoQSARQ0BItmXY5oPwW1fL1CVjGtkhtVbaKf1MNBIQTdrF0y/4yUt56F5zU4fWgQhcRKZeara5KOTFcVCDX6JKT6u7S83b9g85LJ7JfiVEEJoqxIHRS+WOFwzmunkxsuz2703krVGsfhHuGKlOg4krF9DR9usXePQHd1K4EwYKJvCL5MRxi4H4WyaCyXx2ucNqqyvm5ZizEo2Aj6Ou5BMye7FBd5j3mkjKVZrFMBrMYRg9n6Qao1JEZScXGw==
Received: from CH0PR07CA0023.namprd07.prod.outlook.com (2603:10b6:610:32::28)
 by IA0PR12MB8278.namprd12.prod.outlook.com (2603:10b6:208:3dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Sun, 3 Aug
 2025 02:48:14 +0000
Received: from CH1PEPF0000A34A.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::39) by CH0PR07CA0023.outlook.office365.com
 (2603:10b6:610:32::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.18 via Frontend Transport; Sun,
 3 Aug 2025 02:48:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000A34A.mail.protection.outlook.com (10.167.244.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.8 via Frontend Transport; Sun, 3 Aug 2025 02:48:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 2 Aug
 2025 19:47:36 -0700
Received: from dev.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 2 Aug
 2025 19:47:12 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <kbusch@kernel.org>, <axboe@fb.com>, <hch@lst.de>, <sagi@grimberg.me>,
	<alex.williamson@redhat.com>, <cohuck@redhat.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <mjrosato@linux.ibm.com>, <mgurtovoy@nvidia.com>
CC: <linux-nvme@lists.infradead.org>, <kvm@vger.kernel.org>,
	<Konrad.wilk@oracle.com>, <martin.petersen@oracle.com>,
	<jmeneghi@redhat.com>, <arnd@arndb.de>, <schnelle@linux.ibm.com>,
	<bhelgaas@google.com>, <joao.m.martins@oracle.com>, Chaitanya Kulkarni
	<kch@nvidia.com>
Subject: [RFC PATCH 0/4] Add new VFIO PCI driver for NVMe devices
Date: Sat, 2 Aug 2025 19:47:01 -0700
Message-ID: <20250803024705.10256-1-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34A:EE_|IA0PR12MB8278:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a16ba9f-96cf-4c9d-3c8f-08ddd2383177
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWs4ZDErSDlyZ2JsaDU2TE8xVTVNVWFSVGNLZXlZdmFGQTAxWHZ5Q3N0Nnlv?=
 =?utf-8?B?NFhoZ2hwc2NuaStCaUtJUUQveEQza0JFYmVDK3FlM1YxSVZ0dTMyRjk0NUxo?=
 =?utf-8?B?QVd6a201WmxlZzVjOXp3OU1Xa2JyRXFLSEswN2lqUzJXbGJ3SVhWblBVSXBl?=
 =?utf-8?B?Mi9HdzhRN1lMeEk0cE52QUE2S0xrRmhhV3Q5ZE9SWU43ODZ2NEovWmx4Qkhz?=
 =?utf-8?B?dXcySUlobHhidStZQkxDdUk0SXIvaVI4blZPSk9tSU54QVB3RlR4NWVqay8r?=
 =?utf-8?B?QzhaSUF1RHkxMDE2WkpsT1QxSSt0anYzVC94TXhBUUdINThIZHVaWEp2dWdC?=
 =?utf-8?B?dWYrdXNwY0ZtT1VUSGtlNG92YzhaekxTK0VTb3JDTTkzeVZRTEJZVGFEV0hi?=
 =?utf-8?B?ZUxoRWNxSFNBMWFmaHNxSkY1ZmFzTGtZUGhQNmJubm02Q1pYTmVmaGo5WU1M?=
 =?utf-8?B?U1IvYjFDZHpQem1iWUhXWXVkZnZDN2NvTHZra25HTWRLUDdhKzFaSHRFTkNN?=
 =?utf-8?B?dThPMGcxaXVBZEdKTGVnbmhGV3N6cXozVFFvRStFL0U2NzVadVlMb0IrSWdp?=
 =?utf-8?B?MlNiVWFmdjF4L1VCbVozWmRiTWQrREVuZ2E4eXBJZFFHR2s2VUVDRTlla2Jn?=
 =?utf-8?B?RW15MzhZOU5tcGFFNHlNRlI2SFVnd2g2TVlrNWZGdmxYVk9KeG83N1FSTEdF?=
 =?utf-8?B?L3ppbUo2YzBpbUY0L1luVnZGWkozcWMyOWl0NGNONjVTVVJ4WEFFOE43ZGsx?=
 =?utf-8?B?emlRSVNTWG13L3I4VS85bjdRaEVhVU85RzVZZWhUNCt6bXh4cTNjcXpCV3I3?=
 =?utf-8?B?alVwVW93WGJ2d3NZV2t1M0Ntb1ZOTExrNHE4SVpIN1FYM0p3MzdjNEVQb3Zk?=
 =?utf-8?B?dWxJdWpwRFYreXphSDRFYTc3dk54NW5QWnBnVmJGQXhEWDQza1NaWTU2Mm1o?=
 =?utf-8?B?YXByY1ExQjEyc0owWG9DTlFkY0ZZWEkxak9oNFNIaERZeGgzbnhEQVREemcx?=
 =?utf-8?B?SDZsL3hKdWtHMi9vY050ZVppMDRSNXg4VzFWNUdBUmFFUndMWEhUMnZ6NXBL?=
 =?utf-8?B?RlhCOGExRDByRldSRTV3VER0Z0VTanNRMkExcGxrZzB1MnpaYlIxakp5c2xU?=
 =?utf-8?B?YzdUNTViTmhzNUxhWW5PcllYWlpGbWZxUWlXa1U2alZDNTdEaHh5UlFlRnJV?=
 =?utf-8?B?NkN3RDd1R0VHaVUyUnpLV2ZscUhjbFlzNlo1VXl4N2o5NTFFUThHQUwzRDJZ?=
 =?utf-8?B?OVVrclJPNzRrWHg1QVhrRmVLVUJJSWxiY3VraExoazhZOHpEVnZLaXBLM2Ex?=
 =?utf-8?B?SDZXNUtrSXIyYlRpTXl5aTVXR0lKQnVEWEVIRWk0anNXbDRKOTdFNG9KU0xW?=
 =?utf-8?B?VVpFcW5JditHdjBzZ0Ztdm1oYWVJSzNFdENoQW9uSlcrYXVhc3pQV0lNVHhy?=
 =?utf-8?B?Y0JLcmlJdnFtN3hISStNdmJ5cy8zVWhRbFphVXVlKzRSdU5kcUo0TWk3V3FO?=
 =?utf-8?B?NDh5dCtTUitnczJNQWxkRVlYRU9HSnkxTjl0SnRQVmtFUCtIa2hTdVBnYWxE?=
 =?utf-8?B?NUl2QTlrMnZmdmZKVEF0Q0FweGxUZ0dyWHZYVDJ3KzZaaU5CU3dWeGdPRFlZ?=
 =?utf-8?B?NVN0OXNwUEZXOWtpSUFhVVFLcG5zbFBxWjRSSGVQbVVKR1BRMVNVcFZ1Z1BK?=
 =?utf-8?B?dU1QbElLdmFVd2F3eVladnVMaTBHSlNmY2RWemxQb1BndnA2Q3RIb09MbFRa?=
 =?utf-8?B?a2dkejdzdTVreXBjUE0rNTFoSzRTYUtOK0h0WkRaNEhLakk0M0R0eEtKcmtn?=
 =?utf-8?B?S2tudTJTLys2TTN0Z2hoVVpzYjN2M3o5eWh6UEtaSjJtY1dpMU9VRXBlQ29B?=
 =?utf-8?B?YnI0UUxGZmpNeFdJeWNza3FDZW9jSXpOREU5R3FWSEsvZGc5Z2NJaW9lTUFx?=
 =?utf-8?B?cG5DVDJyV1FwTzdvcjMveFdENFdEbzZyVm5yNkR2SWdRVzVFd2lVQW81QlQx?=
 =?utf-8?B?YlRMZGtGVUE2UHNHNnU0WXZXclJET01EMXozdXZqbnBDa0ZJTlJ0MUUrOVVN?=
 =?utf-8?B?NVZ2UlZ0S1JqeEdMTFE1RTlsSHkrMjlSTFJVdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2025 02:48:11.7171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a16ba9f-96cf-4c9d-3c8f-08ddd2383177
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8278

Hi,

Some devices, such as Infrastructure Processing Units (IPUs),
Data Processing Units (DPUs), and  SSDs expose SR-IOV-capable NVMe
devices to the host. These virtual function (VF) devices support live 
migration via specific NVMe admin commands issued through the parent
PF's admin queue.

NVMe TP4159 defines support for basic live migration operations,
including Suspend, Resume, Get Controller State, and Set Controller
State. While TP4159 standardizes the command interface, it does not
yet define a fixed layout for controller state, NVIDIA and others
in NVMe TWG is actively working on defining this layout.

This series introduces a vfio-pci driver to enable live migration of
SR-IOV NVMe devices. It also adds interface hooks to the core NVMe
driver to allow VF command submission through the PF's admin queue.
Adding support for migration of non SR-IOV devices can be added
incrementally.

This RFC complies with the TP4159 specification and is derived from
initial submission of Intel and NVIDIA’s vendor-specific
implementation.

Objective for this RFC
----------------------

Our initial submission received feedback encouraging standardization
of live migration support for NVMe. In response, NVIDIA and Intel
collaborated to merge architectural elements from TP4173 into TP4159.

Now that TP4159 has been ratified with core live migration commands,
we aim to resume discussion with the upstream community and solicit
feedback on what remains to support NVMe live migration in mainline.

What is implemented in this RFC?
--------------------------------

1. Patch 0001 introduces the core vfio-nvme driver infrastructure
   including helper routines and basic driver registration.

2. Patch 0002 adds TP4159-specific command definitions and updates
   existing NVMe data structures, such as `nvme_id_ctrl`.

3. Patch 0003 exports helpers from pci. (Needs a discussion)

4. Patch 0004 implements the TP4159 commands: Suspend, Resume,
   Get Controller State, and Set Controller State. It also includes
   debug helpers and command parsing logic.

Open Issues and Discussion Points
---------------------------------

1. This RFC exposes two new interfaces from the nvme-pci driver to
   submit admin commands for VF devices through the PF. We welcome
   input on the correct or preferred upstream approach for this.

2. Are there any gaps between the current VFIO live migration
   architecture and what is required to fully support NVMe VF
   migration?

3. TP4193 is under development in NVMe TWG, it will define subsystem 
   state and missing configuration functionality. Are there additional
   capabilities or architecture changes needed beyond what TP4193 will
   cover to upstream the VFIO NVMe Live Migration support from spec or 
   from linux kernel point of view ?

NVIDIA and Intel has started the NVMe Live Migration upstreaming work
and fully committed to upstreaming NVMe live migration support, we are
also eager to align ongoing development with community expectations and
bring the feedback to the standards representing the kernel community.

This RFC is compiles and generated on linux-nvme tree branch nvme-6.17
HEAD :-

commit 70d12a283303b1241884b04f77dc1b07fdbbc90e (origin/nvme-6.17)
Author: Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed Jul 2 16:06:29 2025 +0200

    nvme-tcp: log TLS handshake failures at error level

We greatly appreciate your feedback and comments on this work.

-ck

Chaitanya Kulkarni (4):
  vfio-nvme: add vfio-nvme lm driver infrastructure
  nvme: add live migration TP 4159 definitions
  nvme: export helpers to implement vfio-nvme lm
  vfio-nvme: implement TP4159 live migration cmds

 drivers/nvme/host/core.c       |    5 +-
 drivers/nvme/host/nvme.h       |    5 +
 drivers/nvme/host/pci.c        |   34 ++
 drivers/vfio/pci/Kconfig       |    2 +
 drivers/vfio/pci/Makefile      |    2 +
 drivers/vfio/pci/nvme/Kconfig  |   10 +
 drivers/vfio/pci/nvme/Makefile |    6 +
 drivers/vfio/pci/nvme/nvme.c   | 1036 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/nvme/nvme.h   |   39 ++
 include/linux/nvme.h           |  334 +++++++++-
 10 files changed, 1471 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/pci/nvme/Kconfig
 create mode 100644 drivers/vfio/pci/nvme/Makefile
 create mode 100644 drivers/vfio/pci/nvme/nvme.c
 create mode 100644 drivers/vfio/pci/nvme/nvme.h

-- 
2.40.0



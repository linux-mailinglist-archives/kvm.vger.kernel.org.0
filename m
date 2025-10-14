Return-Path: <kvm+bounces-60025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B4CBBDB19B
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 21:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7E41A4F4F6F
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 19:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308BD2D46B2;
	Tue, 14 Oct 2025 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kvWvC9yH"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011054.outbound.protection.outlook.com [52.101.62.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2B92D24B9;
	Tue, 14 Oct 2025 19:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760471061; cv=fail; b=nqeL7/Rxqq7H1g8Xv4meSJEzqOahX7svKdfskB5b/wDgVkOfoH+m79ag73SLoZpK2M1KLyOAsmq5Xn2H6teZcRzuk2PwPjFrC+vMCS9RgT0gWZVlFaK73ZOwgbQJD2cZK1iX5PFDR573TQetVaku1/yTotYMvDtblfcPSopoODw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760471061; c=relaxed/simple;
	bh=5fuMNxJNuKWNcx1hfxPmymZmPKtEAfuWRgBikLNmvHY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qGydcTaA6ZHmUge0lF/9FHNN+eYgevENToHSouaYt0zVcfPqYXd9lJUSh+7VH/Su3+igjlF9u9b+z5JTq/k55W/OlZHOebbzTt7GOjYuY1DDeFmdG00Qw6FYNKxZKz84BI2elKb4vmO4oJPZKagZnGdS4BcTOYBg776ZIupPmk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kvWvC9yH; arc=fail smtp.client-ip=52.101.62.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mCyo1MzZfZJaLXUwnVKR8+RTa81teNVsPMKBmgDQxz3CU17iFhVGIrSknpFd07OM9q8z+EIMfO9hDvAL5G3flSbw/v9+jpXumtOQ89XThKIaSOD4pECoZWR7D2ifBeidVmTN9F4SpuqTGl2wWiCpSD4NZNGUzuMXlfxsMEmTl6ZvYrczaaEKlzb+XRZo2VR8zL9hLGN/tTpvWjbsgRak6R8f9OwQhai4kMWXIxwFdeWSGhGqMX/11ikrKit3ZZ5RIwT89afvO5IfpG29cDgyKMHTPoKhgc9MVIrQ/JKWBuEfsKqRmLZTS85w5OWIF/hhRCpGNnoYXb/LNGArDIXflA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OE3xfK6Q6IKlbE6aLJku8utulslQc1EfgL0E3qe0cZ0=;
 b=y5c9PgPDcqnKbOUhL8WHkBBMNzSi+VwqpgYc+QdO4yZ3hrvGa0nbL1+x+EmlU6lPRpANPRonxAaBPN42jDeKawpKWJSWeeqd0UZyT3oBYS4ksB4yYYzqCCk681b/hAbc9FyfwEYOnkYDqa6BIZmZvKpSCEnmhboS7MKi5TdGi9q16yv22+Vv0N6VU9tOKMKgD2mwQJw1NOl3SJslxX1Zy0XyNnWCI02ybkyrPeTaxCHsnMSZc8/UvJbVfw1Q7tcmMZLe7tMCRqDX8J3ZIpDnPScgs63UJ+0GVSLbzNNqr2SNBdyEQrVPcRNKLLuCB8YmP+g30wpsOHhWKJJEaMOnHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OE3xfK6Q6IKlbE6aLJku8utulslQc1EfgL0E3qe0cZ0=;
 b=kvWvC9yHG4H3ox7BMNVZdMUVoJkUypBn6Ubr1xKqJOFvKLFCQrGNhHdkLCxp64IL5tNiauNGdu1gwhSC+0zTKAM+TMqQL40X2Zygc731wkFhM/pnurFUNxUxWVHT3/ZP/2UbEXn1wpHGpB2N9a2qJhTLRVA3hCbEcMtkbntTr68=
Received: from SN7PR04CA0197.namprd04.prod.outlook.com (2603:10b6:806:126::22)
 by LV8PR12MB9205.namprd12.prod.outlook.com (2603:10b6:408:191::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 19:44:13 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:806:126:cafe::31) by SN7PR04CA0197.outlook.office365.com
 (2603:10b6:806:126::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.10 via Frontend Transport; Tue,
 14 Oct 2025 19:44:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Tue, 14 Oct 2025 19:44:13 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 14 Oct
 2025 12:44:12 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v4 0/2] Support for SEV-ES guest shadow stack
Date: Tue, 14 Oct 2025 19:43:45 +0000
Message-ID: <20251014194347.2374-1-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|LV8PR12MB9205:EE_
X-MS-Office365-Filtering-Correlation-Id: c60697ca-b574-4b2b-094e-08de0b5a0d68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y3lsOcfkPaop41dHnPYj+HAQ16No49JH9CG1KC1AkUl0EAWIKBrHJD2FtfnF?=
 =?us-ascii?Q?PWMwrGv84NERrop2oPZZ4ZqDjeKzYE/KmHhqs1uSPlmDXsS/5S/HG8aXiGR8?=
 =?us-ascii?Q?dQ90Iu+RbzHVNrRhv+9OimsKPNXuzoqnDQG7OUyP3DROd025JmGxykcg+v/a?=
 =?us-ascii?Q?eORhsUfW7PFerxr+nYiCJHOF/wEdfU9kXU+ARQoEfBtRD7VOymoYc80d02Zo?=
 =?us-ascii?Q?hbuCzRvoVsIknJk9w7KnxHVwAG1RXBREU+uXFcOn8ay7kfRudLc86fYu7UL6?=
 =?us-ascii?Q?v0Oo7EGe5om0klAe/RzoEv+cV0UrItKiLVAIaB4ycwhV6eR4FFBBP5IH6IxR?=
 =?us-ascii?Q?x3omM2vtnY5osgAHcZ2OXoCDgX4VPMefEFvp7x/k7v5IoejyvCtFJPXkbxCj?=
 =?us-ascii?Q?A2mdTuDtNLKd3klclzhXEXeZ6yGE6tvHcPKEN4UIEOHDQ4+JHCdRDLznIOZp?=
 =?us-ascii?Q?t0DNQikgSx7s/22CzVn3facqfkoLXa/3KVjAKEj3vnaR+9IbC+F1hbU1j3fR?=
 =?us-ascii?Q?s4tP/bSEq55MpSvCUO/mxPrmw6oaPniZWUTNyQ0fKtgHUh5lioF6inWVEidw?=
 =?us-ascii?Q?tc1fgHXI61LfBNVpHQ3AMyMj/pwjO1X5F97ej524EjhpEB7sWTw581RfpT5A?=
 =?us-ascii?Q?WnMMo0XSwWRt+AZN+LNxspvkN5W00MHSg/np6LzfpR/2wv8+6eUfoBDQ2e8R?=
 =?us-ascii?Q?Vq7dXh5AHoWd8uIv0LVhYExUkTHvZup9H0bh1YH2iLPF3C/kbmjUQxc/vkbf?=
 =?us-ascii?Q?5oUpy6uBb4VwE16kz8OmpwbX7+/+xumcT8ljVy9J8YAtlBfgVdp7Plo/L/8e?=
 =?us-ascii?Q?1SRgurgHtzKc31jr9BpvoL4SWZ4ITVuvl8eOKrFwp3hxdeBM94CFsCGfAYxs?=
 =?us-ascii?Q?nwn7HnnwoEgbjX5oic7+dJxyHtzJAjKIAHHsSuXzVAjWZvzxkZiqRSvq4JIU?=
 =?us-ascii?Q?B5bv/UancJ3+LdS4MYIXIyTbN5q9CAjJhU3Zgoc4foA515BNIyN/wUv9yOac?=
 =?us-ascii?Q?WneFJmjZLnAQvjAoy1FN84FDDCx8keiEcfrQFFOB72mVTA+aVJj3h9zFSZiN?=
 =?us-ascii?Q?fkt03k9KEHaex0aI2OqZkDYcBmPSQvCHoPMNEyGbJE8cb8ZTinw0Kmaho7lE?=
 =?us-ascii?Q?fsSVuhgta2FzSmDOs6y42Z0XvkQ15THITEpPuNbO8JztJBMry5kcRl1lmqUk?=
 =?us-ascii?Q?FEwvc5lEhqxVynSYR0XlygXxkjzX1SlI48EjLw9sAkeBU4NHQ82Xq7bSFOXX?=
 =?us-ascii?Q?aBguQe6Ja1YjG0dCxiLOz5v9nbbat4iOek7gChmErsLmvSaMbr9mh5qlhBfJ?=
 =?us-ascii?Q?XIysbEpPiENoMrbd2zuoPBMwLvWtFfmECja5yMbWuIl5uONj3YpUbs5pSK81?=
 =?us-ascii?Q?1coLEqUgZwevZc9TzgYL7lA3BWZPATfz54/FhZcJEj63aBXDKmVnYFiFGB+l?=
 =?us-ascii?Q?8ywbq7OOkXX78kCTU1NoUdqIzLrneIbBnx7BCFwOMk8eEoZdf9sjoauD/uK8?=
 =?us-ascii?Q?88X9pbJBOF8x+xet8WrZQS4y+veVKeK9QjYsLjjJpSFZkBqMBvJ2eVsqEgh5?=
 =?us-ascii?Q?KCVCIjmcfQOj370qnjc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 19:44:13.2469
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c60697ca-b574-4b2b-094e-08de0b5a0d68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9205

For shadow stack support in SVM when using SEV-ES, the guest kernel
needs to save XSS to the GHCB in order for the hypervisor to determine
the XSAVES save area size.
---
v4:
  - Use CPUID_LEAF_XSTATE instead of open coding 0xd.
v3:
  - Only CPUID.0xD.1 consumes XSS. Limit including XSS in GHCB for this
    case.
v2:
  - Update changelog for patch 2/2

John Allen (2):
  x86/boot: Move boot_*msr helpers to asm/shared/msr.h
  x86/sev-es: Include XSS value in GHCB CPUID request

 arch/x86/boot/compressed/sev.c    |  7 ++++---
 arch/x86/boot/compressed/sev.h    |  6 +++---
 arch/x86/boot/cpucheck.c          | 16 ++++++++--------
 arch/x86/boot/msr.h               | 26 --------------------------
 arch/x86/coco/sev/vc-shared.c     | 13 +++++++++++++
 arch/x86/include/asm/shared/msr.h | 15 +++++++++++++++
 arch/x86/include/asm/svm.h        |  1 +
 7 files changed, 44 insertions(+), 40 deletions(-)
 delete mode 100644 arch/x86/boot/msr.h

-- 
2.47.3



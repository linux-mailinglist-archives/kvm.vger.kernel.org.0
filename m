Return-Path: <kvm+bounces-71492-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +MS6N2l5nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71492-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:59:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F758179389
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C72B43032D4D
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECF65322527;
	Mon, 23 Feb 2026 15:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y3yOkCpv"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012054.outbound.protection.outlook.com [40.107.200.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C63315D3E;
	Mon, 23 Feb 2026 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862154; cv=fail; b=Vp1r81pI0VfgBSwWpFwTzbyFJWdHMijNPyAfgwedfHBjejnVgUcV8vFQbV8Rd4HfVc8mP6C0TOuRxs5PgK3vGDVIky1Mze5SkUQxcaXDdwB6ZaR7Pvm2wKN9xauQCR8kWTcyNdx+R85/ygwA/ZoWgktWini34VLkZ/KfSZHSSVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862154; c=relaxed/simple;
	bh=s5xQ52f8j1WAQKXX7vPkyUFMqYYAgVuwyoO9SDf9STs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WULK/ZQ56Y9U7j/hgvQa+K9m8N9MZpdpid8sf/HaTTF/xkSUra795LX2FI/cRrFk3TKydpTJx7whdiIGpJsUqmx78YotPRW/xnD/zI9GgMnqU5pp41WmkM1JZqeOrTvEq4aHXuijFSAmzESNZRTdcazjE9u2xqFvagENWzKbmSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y3yOkCpv; arc=fail smtp.client-ip=40.107.200.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JBu6Znpoc6GGGJt4fZoR2cJsKo5j+mjahVWY543vlHyIv//LZSrEzAY20Qmh2XVmbUmCMPzF1x4njxGb83fNj/y6w1vBhMFuI1N5HexqZ7E9UhIYuZbUVDm/weY+DXmoT18sa4iIJlpc3vonemH++goU+gEWnDLNv7EQz+rEC6uGMqDbzlS74g2ROOnxceaeZLVtPfs3Sa9vbkrW3H75xQRTOfcuzoNvTimxtAgO+UXUf2hpci7dWAuJwTHSCl1x8dk8GiDOiVQ2F+Q9Dpv/ToUgAH85w5bRCRydTCTiwyPcZM89MSEZUf2FBTZm7YcC8gTwPyAj/yDLv5Fy4TQVSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4iqXniX24XY64FcqMsmliuq2LgQIqSAQMBweKNbvJA=;
 b=YGTNKdjzBeLud7PrHnEfGQXlRXRdjeZ/P7pjFnJDiVDpvCvS/xqs5oOKaFTOiLG3MF+FEUwQouZwLVYZOLHCbcXPb+vbPuPIMYx9mIA1j/nmYB+TxkMXfkRiL4D1jNcPQcyyj/z3T/pRBHZK/0FVjMw/OGehSu0bz+4zNopwJbUryCGsd5yCOYgQhSmuyp1yf+3ZAB/J/TSujDOjEQdhB6ivhdR2ktiSB2Qc09wmBEYFlNAnXHyBBoHv1OZz5d2pTaoTvvOcQG7Yfj/wFBC/ee7vAhAkfDt3Jm11j2CpoBCkcMpdhhyuJmSZ4z40KC9JQrqdlJnz712G4NjlcFssyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4iqXniX24XY64FcqMsmliuq2LgQIqSAQMBweKNbvJA=;
 b=Y3yOkCpvxydxaBWn+xmYn/8ZJ07JGYgdy2xFo2auk+B410pxG2JIU/yIwb6CczU61mRyqHdvj5xPVehWDXDH76ObeiSzkkYIjkRgAXV2Di0/99/2v/Rn48KLW2RGDOOkAX+wWqsAg6ahWenPA+zlxWFoTN0WpcCEtcna/+Z7KzlglV+cXM6gAo+dE1ZubmYF7MRvZ5LfeD/I7IVepAk49+soKIZvReFZj0oMOYxHoPfXG5xy+1TQuy5YX/GBG/Q5dPg+hOXUz+9et1VC88qPZBDxzBIvIYeb4MrhiKZ4nK2VmAJAuDvvZ3COkPqGUA2C8XLInNAaLBhNDBsf/YdtPw==
Received: from DM6PR14CA0059.namprd14.prod.outlook.com (2603:10b6:5:18f::36)
 by CY5PR12MB6227.namprd12.prod.outlook.com (2603:10b6:930:21::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:34 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:5:18f:cafe::2c) by DM6PR14CA0059.outlook.office365.com
 (2603:10b6:5:18f::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:17 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:16 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:16 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 05/15] vfio/nvgrace-egm: Introduce module to manage EGM
Date: Mon, 23 Feb 2026 15:55:04 +0000
Message-ID: <20260223155514.152435-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223155514.152435-1-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|CY5PR12MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: cee8bfdd-ca34-4780-d7cd-08de72f3fada
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PnVo0pkMk0tfUulQNWgd1CH+WWnWFJprNqyS27WM3Y4PfD4AVoNqJC3LZZJZ?=
 =?us-ascii?Q?81znRJyfdDqUQjFatX4m3snDSiGqv1D99Tr74KUtx78NKAVZXXwsOZx6w020?=
 =?us-ascii?Q?4IpyXufnbnH0WqfuoSrif3yyWXXBR/Th56nYBP/GusugdsjFyLK4lh5kHii8?=
 =?us-ascii?Q?mrlfv6ih4+xscYkq4oGkIoNIiKZwi4vD/smXikM+R4likEIjwU403UqCaSY6?=
 =?us-ascii?Q?Xc1Xi2KIWZ4R+y2eBhu7BysgiUq+MSXxsSgqAWdRx4AjrrhYbwNE+WebYpL9?=
 =?us-ascii?Q?exq/2O4vJ28+Tx2P/fOiIK3dUANEUUwSFX6+9HWn/tFHGAE/abPHMfRpF9g8?=
 =?us-ascii?Q?vtVUAHCt7L7RkKvGyevTIqyI1F4lWgJO12DDnP0sJF+wqrA80xsYVdhPndyd?=
 =?us-ascii?Q?GzH5nD2vonSCR82cRCWszZgZk/s/i8WLyt9qpnuFBVAjZeM1JUHNLzuGxSIf?=
 =?us-ascii?Q?1W2coCdPOVH0LJXWQRqq/2/WmoC5kDJDhTlROroZRLdpPy7NT7bFxTX3rB2i?=
 =?us-ascii?Q?FLcnXta9zM7Sn1NK4n1dAJ557SsctoxZkbyuyc20KPfoQ4KWw8pfyNeuHRcZ?=
 =?us-ascii?Q?7RRYMD2RNBhSOZZOGzl8J3qIj+qwONAV4epc0GcvLURjtCW0uO/ew578irEN?=
 =?us-ascii?Q?MdWd/pQJCijQOb5GT+HHum38kJnj90G8iICmWysj3XSc/u9BosQXmmuEFOdy?=
 =?us-ascii?Q?3BS0hrWbdWRbOcBAHg98hLTZrM2IjDXP2bN9sBmMM2ybfSnfSIvHooCSd1kT?=
 =?us-ascii?Q?PhbqaigXe7Rl0O+knBXH6K+jLMKRatsGEWVsurbDFx76g03yN1Zdv6WRf2vR?=
 =?us-ascii?Q?bfmi6Ci00ahlHleq7GYZc9m1I0rvLllgG2gvXl96c/jXTE9kqdgOQe8J7ksf?=
 =?us-ascii?Q?uKNJqry8NRAayvYmZ75Uyj2W5ydNYYH1Erbqa2NV3yKYpcK3cxPiEsaOdhe1?=
 =?us-ascii?Q?H8kL4S90kYi3Ssu4wIb1PwgkROM1PXR28qQjqf1zwOP5fMkM9RJuEaBJTx5H?=
 =?us-ascii?Q?3IeveFRFB3jlNsnfO0QhQKjwmcBl45gc8Q5/DkLfGgVx400QlitwNDHhsAOL?=
 =?us-ascii?Q?qy67NzeZyvEr39aa31y+vjEf2rJJlvnnc+icPS1RV0ogsY5QPaJ2exBUPW53?=
 =?us-ascii?Q?kxsMmzVwyI8Pcw1YpZgD+83PZ9ZeWi5Wo49D/PLisfXbuAGquArWP8xSxEKA?=
 =?us-ascii?Q?QDJgyw6Ki7gBqF1H/G3H7dl7P6Rzj05peFOQs7tNovy5VWtuEBO0Zvd+XKF1?=
 =?us-ascii?Q?PKk2eMSwR3+pilKu2MhkavuvcXUoIYQjpzgY9CP8ZFKyQ+jkbVStzfwKNLhC?=
 =?us-ascii?Q?RCHk5PI4e4XRQr6kmpFKxAThogLx36s81AiSDa3N1rnWlxqQB5DIR9xMy2K6?=
 =?us-ascii?Q?JgnMmk3KVF/vJqSmdmgowcg3umSJjaHnXrdhM97k/yzIVowf6uL5cgJ5ZALM?=
 =?us-ascii?Q?dxiD19gsnQ7R2z+IxO0uf2ni8Z/za9Uq6sItWvNLa5tQXv9/2CJqxgqz69jU?=
 =?us-ascii?Q?2/rOgGNcwOeXX86RkWlMt49Wr4nYCytrOd8FC6XQmaPXNyFZLrbcsuCVn9Rw?=
 =?us-ascii?Q?xxIyMl1V5UUcoxK+kkxTJPkXUSwp3CnfnnT+PtCH3tI60+2lnBbZtpnpLlUF?=
 =?us-ascii?Q?o0vDX6JfCUMyQTPLd+moNOrQdrbwAMFAbNHCCLYsvlKq/NrUwcJZ8A5llf0a?=
 =?us-ascii?Q?Ga/nJA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	x5KOabRb5mNhkpxiKEhWboeG7Jo2EcsdAyUfyxKltGp1q+i3Bu8mv5JRyp/mh38Gr+RjLCaa47TnQhUo0Bqiqf7I/uXdWd/9Ll2imAAWoVE3bVaABILa7x7HBS9DF5Hx4tzYQGnbvwh5aUSFaA0lMhbY8HIkAfTMow+WR/mqflvAnfFBmyzTAMFu1HsOdvKSPJrrivQGm7cCpRnwraZMUWm9nFxNVNPl7J9BK3kQQxUjQM0XomTLVsH/grk40/rNPJsshJV/Ct6sbXd0hDU2Eda/6caiKneGrommfhCpQD/Zm05EX6lCOSqdHEXznWDET/JzjJjmJXW5VcaoGoIlJFiaOX7JM0WNxPvmGQ8/qQZbNSjjn0IxaB05jQXh/umNoePGXTyF4fn07GFWP+BTIengUCSGK0g/mdoQEolYr89L/k2fMLUPdLvkkQtOP3ws
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:34.2998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cee8bfdd-ca34-4780-d7cd-08de72f3fada
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6227
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71492-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 0F758179389
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

The Extended GPU Memory (EGM) feature that enables the GPU to access
the system memory allocations within and across nodes through high
bandwidth path on Grace Based systems. The GPU can utilize the
system memory located on the same socket or from a different socket
or even on a different node in a multi-node system [1].

When the EGM mode is enabled through SBIOS, the host system memory is
partitioned into 2 parts: One partition for the Host OS usage
called Hypervisor region, and a second Hypervisor-Invisible (HI) region
for the VM. Only the hypervisor region is part of the host EFI map
and is thus visible to the host OS on bootup. Since the entire VM
sysmem is eligible for EGM allocations within the VM, the HI partition
is interchangeably called as EGM region in the series. This HI/EGM region
range base SPA and size is exposed through the ACPI DSDT properties.

Whilst the EGM region is accessible on the host, it is not added to
the kernel. The HI region is assigned to a VM by mapping the QEMU VMA
to the SPA using remap_pfn_range().

The following figure shows the memory map in the virtualization
environment.

|---- Sysmem ----|                  |--- GPU mem ---|  VM Memory
|                |                  |               |
|IPA <-> SPA map |                  |IPA <-> SPA map|
|                |                  |               |
|--- HI / EGM ---|-- Host Mem --|   |--- GPU mem ---|  Host Memory

Introduce a new nvgrace-egm auxiliary driver module to manage and
map the HI/EGM region in the Grace Blackwell systems. This binds to
the auxiliary device created by the parent nvgrace-gpu (in-tree
module for device assignment) / nvidia-vgpu-vfio (out-of-tree open
source module for SRIOV vGPU) to manage the EGM region for the VM.
Note that there is a unique EGM region per socket and the auxiliary
device gets created for every region. The parent module fetches the
EGM region information from the ACPI tables and populate to the data
structures shared with the auxiliary nvgrace-egm module.

nvgrace-egm module handles the following:
1. Fetch the EGM memory properties (base HPA, length, proximity domain)
from the parent device shared EGM region structure.
2. Create a char device that can be used as memory-backend-file by Qemu
for the VM and implement file operations. The char device is /dev/egmX,
where X is the PXM node ID of the EGM being mapped fetched in 1.
3. Zero the EGM memory on first device open().
4. Map the QEMU VMA to the EGM region using remap_pfn_range.
5. Cleaning up state and destroying the chardev on device unbind.
6. Handle presence of retired ECC pages on the EGM region.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                           |  6 ++++++
 drivers/vfio/pci/nvgrace-gpu/Kconfig  | 12 ++++++++++++
 drivers/vfio/pci/nvgrace-gpu/Makefile |  3 +++
 drivers/vfio/pci/nvgrace-gpu/egm.c    | 22 ++++++++++++++++++++++
 drivers/vfio/pci/nvgrace-gpu/main.c   |  1 +
 5 files changed, 44 insertions(+)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b3d86de9ec0..1fc551d7d667 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27384,6 +27384,12 @@ F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.h
 F:	drivers/vfio/pci/nvgrace-gpu/main.c
 F:	include/linux/nvgrace-egm.h
 
+VFIO NVIDIA GRACE EGM DRIVER
+M:	Ankit Agrawal <ankita@nvidia.com>
+L:	kvm@vger.kernel.org
+S:	Supported
+F:	drivers/vfio/pci/nvgrace-gpu/egm.c
+
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	Yishai Hadas <yishaih@nvidia.com>
diff --git a/drivers/vfio/pci/nvgrace-gpu/Kconfig b/drivers/vfio/pci/nvgrace-gpu/Kconfig
index a7f624b37e41..7989d8d1c377 100644
--- a/drivers/vfio/pci/nvgrace-gpu/Kconfig
+++ b/drivers/vfio/pci/nvgrace-gpu/Kconfig
@@ -1,8 +1,20 @@
 # SPDX-License-Identifier: GPL-2.0-only
+config NVGRACE_EGM
+	tristate "EGM driver for NVIDIA Grace Hopper and Blackwell Superchip"
+	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	depends on NVGRACE_GPU_VFIO_PCI
+	help
+	  Extended GPU Memory (EGM) support for the GPU in the NVIDIA Grace
+	  based chips required to avail the CPU memory as additional
+	  cross-node/cross-socket memory for GPU using KVM/qemu.
+
+	  If you don't know what to do here, say N.
+
 config NVGRACE_GPU_VFIO_PCI
 	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
 	select VFIO_PCI_CORE
+	select NVGRACE_EGM
 	help
 	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
 	  required to assign the GPU device to userspace using KVM/qemu/etc.
diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
index e72cc6739ef8..d0d191be56b9 100644
--- a/drivers/vfio/pci/nvgrace-gpu/Makefile
+++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
 nvgrace-gpu-vfio-pci-y := main.o egm_dev.o
+
+obj-$(CONFIG_NVGRACE_EGM) += nvgrace-egm.o
+nvgrace-egm-y := egm.o
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
new file mode 100644
index 000000000000..999808807019
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/vfio_pci_core.h>
+
+static int __init nvgrace_egm_init(void)
+{
+	return 0;
+}
+
+static void __exit nvgrace_egm_cleanup(void)
+{
+}
+
+module_init(nvgrace_egm_init);
+module_exit(nvgrace_egm_cleanup);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
+MODULE_DESCRIPTION("NVGRACE EGM - Module to support Extended GPU Memory on NVIDIA Grace Based systems");
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index b356e941340a..0bb427cca31f 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -1410,3 +1410,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
 MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
 MODULE_DESCRIPTION("VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");
+MODULE_SOFTDEP("pre: nvgrace-egm");
-- 
2.34.1



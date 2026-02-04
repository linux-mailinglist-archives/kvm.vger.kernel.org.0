Return-Path: <kvm+bounces-70145-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aCoZOxj5gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70145-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:45:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 53ABEE2C80
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:45:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF8B7303605E
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C51389E14;
	Wed,  4 Feb 2026 07:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vqi4jAhM"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013062.outbound.protection.outlook.com [40.107.201.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F9F2192FA
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 07:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191122; cv=fail; b=gko+koHNIkQiXtjSnG/t2AkfZsDl0NEBcpKCkFtiLbrfkWxx2sDSxYIl1dGCzMI7D+FuN+JAF4jrIDbay/ZKca7lNAkkqoztMVKAc25RmziEFwVqHCUNAXa0oUTuxa5wI+31u5HzW5f//v54xVmdYAhFCraYgCwPUoNDtw2wVb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191122; c=relaxed/simple;
	bh=DrDXcv1wq0bZ51Znu2nbMdkwXOv0va2N9DJZEDdZ+GU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T3eIUXET+xlgBa9pFjN9Ch0U0iMA6CBCtChbjKenYqi2z7ZY7aIiVGIvk8bXRlQJUHhv1zeUdNLUaM5DnXlR49fmPlag+qc6YS6naPixaQfm+0sMP+4Q16FNkdyTUDR1HLiLWHCkr9aT7Wy2ljC5Cf20RIhfYn8GJpd30EyQASk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vqi4jAhM; arc=fail smtp.client-ip=40.107.201.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbXvpm4NUUnr57EH7X5aejubjbxlvpXSk/M9kGwGLkBxmmj3zDWOlJdm5Ne2dCjM3WCYMb7aM306fbueLY/YlPOst0QFYVnnBV5oDBpszRAo7MEgety/RP4s9MtTnDWjyu0PuRk7t5Hed/K7lWgDjO2F/gSaWufdXQnq3OjUMj9kmmOpXZ+oMmGaX4yJ0ZonDzdYmqxIzq6alhyf86c49UQ/mQtdtWLXgvpzHDonxbXaXVcd7Vb8VQuuuIWrpUARBjx8AeCrT7DeFMNrlFHbg9KoiEmdlVbG4NVz1Gr2ZJUxquteVAtMHgiV2rG2yf2y/ph1xv2ozSf8rdg46w6cYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1Esl4KA7WOGfqazbDbENMhC7myXCtwUr+y+hwQSrow=;
 b=Zd7Wxb17KDXDTDALxfoEYVYhdMZ5kqx8MJ8/5mBKMYmjkhx4FPjjxJJTK2rfpVwoJy8aZbjjIIJD0F09PTlM3ZxVlKjvVvoHIPxf4xQbi5qjHlDMvHRvTb7j0tmVpB+N8KcbDdsaBePZ8SPBvIAcJBr9RSXAgH8d+wPNfFvIFl76zjF/HhR9IoGw0cRv7gUMI7AYeOlVIdMokzoBPV1rlnEEMWEq7B200We3RrZXalv8fbSkf31G77JpSLZEaPEISWJCxk5rfL17l2y4cmXCKBLxMdGKqiAriwVBxisJNoWzSK9GBsJFGoK35dwai/ZxpHzF1Lgo3u1FKLeRxMe5Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1Esl4KA7WOGfqazbDbENMhC7myXCtwUr+y+hwQSrow=;
 b=Vqi4jAhMaTQdvOhcUP3CPPg1p6FgPbKEvV7UcZG9iCc98Hd+i4wNjCDyPsCzGsTow+BCUS/lbAHd9aA7HPd2dYEbr710+ENY7buXNWcPYBUBf5+VqR6ROM6frxgj3el8inyjG6LcKodtLsM/HZrYpfiIjE9wB7zso2JkAm+C3CU=
Received: from SA1P222CA0144.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c2::22)
 by DS0PR12MB8786.namprd12.prod.outlook.com (2603:10b6:8:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 07:45:17 +0000
Received: from SN1PEPF0002636E.namprd02.prod.outlook.com
 (2603:10b6:806:3c2:cafe::47) by SA1P222CA0144.outlook.office365.com
 (2603:10b6:806:3c2::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.12 via Frontend Transport; Wed,
 4 Feb 2026 07:45:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636E.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 07:45:17 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 01:45:08 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <Naveen.Rao@amd.com>,
	<dapeng1.mi@linux.intel.com>, <manali.shukla@amd.com>
Subject: [PATCH v1 0/9] KVM: x86: Add support for AMD Extended APIC registers
Date: Wed, 4 Feb 2026 07:44:43 +0000
Message-ID: <20260204074452.55453-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636E:EE_|DS0PR12MB8786:EE_
X-MS-Office365-Filtering-Correlation-Id: a89ede12-ea6a-45b0-5fae-08de63c156fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cYQ81HUTSVhHNSUGHyi+cBnfuiILuEKm1sctmKO8Zbtusmcs8ZyWbAzSYtx2?=
 =?us-ascii?Q?HEtITYqW+qkXjjIpDU6cOVfW1OwSVqp2rbKfoMaH9otF5lt1N4mgAjGg9yzJ?=
 =?us-ascii?Q?l+KEn09l9n3TYCA1x1DfUl8tZLz0Hv9CoGTArE1J9dbm0ekXZqELIgHWlmXq?=
 =?us-ascii?Q?M/wJKsVN7/3K4qHeyZ4uXcaqu0FnbhmemxibOyI9eaGgSB7GJSkoBiXdhRpT?=
 =?us-ascii?Q?jDT1oqXlhiruZSzOiF1zgboQ1N4MSPKlcTUQbPNYV/1Batw+tirQA46mLY8T?=
 =?us-ascii?Q?t9IY8nPPHvA0pE4Ge9ELBPVmrmQRpNsyp6c2LvnqmYgK1h/HtBKmWpUx5dpi?=
 =?us-ascii?Q?+0RvEbV5qDDPZdDy6BDe31saQbkbm5iSK+odDf4Wc/snvmX5xPpYzl/GPHla?=
 =?us-ascii?Q?OnEudW7VguEs+TioZ42rQtB3xsPF3KgjZrpNtVDRy2ZEOQIjr9CqVIVqRmdj?=
 =?us-ascii?Q?//n5ObDLmRtdwVKSCwzZ0VVPasvMdeVAEAL0TJi7aVhb914LNxQxeqSpiGMe?=
 =?us-ascii?Q?LGEn3IiNEiqUjmPLrg5BWPBc2SGUqWj9ffNQCTxIOCWmuzY8wD3JcR6qypjO?=
 =?us-ascii?Q?MPrZcPSUcsQpIzqqjpyDjXeJyRBIUC7aijepYUf+Q0LY0dmQgvhpHev8+/Sk?=
 =?us-ascii?Q?JjVsrsngEfeeE/GAUStqCRnFBqelW2HqOlJJBRGbg02lvKjcMWtAk3o3zKmb?=
 =?us-ascii?Q?pzGuucxTZrZuVU+Zcw+Fo0yDzvhkPZn0ZfhRnQ2a2lgm0s9EI6KoBYNKNHdE?=
 =?us-ascii?Q?yckJgmll/vNVj3vefhNhGsrbHLIl4XhzARVqJCywwnv9HZwZlfTpdYWifV7C?=
 =?us-ascii?Q?E/a7Gv3ny0yNvtavH69iD4k9it1xdolbjuZ+lhAF5T+O8f1Lle1hdhYvxR5z?=
 =?us-ascii?Q?r7RU3XwnmgNd5yMsScFvz49CUCV40bSN/vtCVirSpESceyFFJtsEnuyg2tBk?=
 =?us-ascii?Q?SErAgBPapsHCWX5zU7qZ5RFLvi5+Hcd8zmAYpSXJtCyUumKsLyANya2pwVLk?=
 =?us-ascii?Q?cI2j2Y3pNKsgQZXUHPhJGz7OxVZ4Lw1gZEmvUJxWeOyXUjjU7vmIngnonGqV?=
 =?us-ascii?Q?VZAtoRq3x+SVsmw1Loc5wThFFcaec2PkdLJR79EJsStx4Nv4QKLR1JM5WpwL?=
 =?us-ascii?Q?n3jMmBqnA9An5qfawDXR1PSQUTvDZelGLRTy55asiwRsOuDpjI4QMl7NibXk?=
 =?us-ascii?Q?Fa9Y077QiqRwjDbZtUZKRzLa0ESxfl1BI6PTzuRU3eERtlU8KCh0EkIGeo9v?=
 =?us-ascii?Q?yiqF4wNqMTNz6WbuBapRsQkkwVYvO2nn/htnBlmLBM1uNm1OaAPia/b2gC5M?=
 =?us-ascii?Q?f8CYu0M33YmBqlTJSBWRgt/uLve3w676EPl+2RhkcDyWZijvCcTBnmq9iQOO?=
 =?us-ascii?Q?48XCkwUVGruB+g38CoMyOsx2F1pmMzPBRN+Of6Es+gK594AX+zRAfxduTj2h?=
 =?us-ascii?Q?mqDktYwDfPyvxDcvhNfwqqu/+CMAwRD3LTVCL+T+dku3VnR+2vrDoDGgX+nS?=
 =?us-ascii?Q?qDfLRmc/9UNRs2DmrwjLiyqNwPmGkOrgN64UKkbcwEnocVVXXmsz/Zy/bTg/?=
 =?us-ascii?Q?5yMkUEMf+o2eBq5DWvwFi+IgYebw4IFi+j2/KjKrMYEW5aJR94Gwh5AzOHhA?=
 =?us-ascii?Q?f0qIhLQBAGoH5XuGvNQV22cwyYhQjjBUTelYmhHVZrbGJYhZEXfdYan5bflm?=
 =?us-ascii?Q?QOQJcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MuSBeoRjJEKZ2xn0M4ILzOh/vdHSPfWUCo/IVU+FFmjo21rLOgF4fg7tENhTGWD3/ZRWdFlgbf7SjspZL6XC2pL8ggv/dDNh4fMjrv2SzTiQQ58E5VQi4J26/8bcEIoArJiTinTWeZZP3uo+hFbzlKPoO5AITxSMOAnZrLdtUf/F+hlCEbgx1zXStT6/9dehL519S8FzNdo54xV97HED8h4DwqasQQrS04Lpx2tAtBWFwoxdLMWuvh1oolTihRKwDmOa6bD0NrYxGM3OKogKmzGiYg2L+yB4KA+J9iSGfKqaH2HMYtCuhhD4G2rnATBO3Co1ZvxgMYqeLJNEfaMH4cQms8nr2fTiYYA9bkLQs4S3VV4zGJkIp4pvL0WNT8NSI5OTfXrRGKrBUB+XW9YNwSBKMdb9/BlozZdBTtyWRzkWmRx3hgtO/LO8SYpyiTW5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:45:17.2149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a89ede12-ea6a-45b0-5fae-08de63c156fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8786
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70145-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 53ABEE2C80
X-Rspamd-Action: no action

Add support for AMD's Extended APIC registers, which reside in a 4KB
APIC page instead of the legacy 1KB APIC register space.  Extended LVT
registers (offsets 0x500-0x530) provide additional interrupt vectors
for features like Instruction Based Sampling (IBS).

Introduce KVM_CAP_LAPIC2 to allow userspace to opt into the full 4KB
APIC register space. The capability uses a bitmask to support different
APIC extensions:

  KVM_LAPIC2_DEFAULT: 4KB APIC register space (common foundation)
  KVM_LAPIC2_AMD_DEFAULT: Extended LVT registers (AMD-specific)

Add KVM_GET/SET_LAPIC2 ioctls that operate on a 4KB APIC register space
accommodate extended registers.  Legacy KVM_GET/SET_LAPIC continue to
work for backward compatibility.

Emulate extended APIC registers (APIC_EFEAT, APIC_ECTRL, APIC_EILVTn)
when the guest has X86_FEATURE_EXTAPIC and userspace enables
KVM_CAP_LAPIC2.  Current AMD processors support four extended LVT
entries, future processors may support up to 255.

Integrate with AVIC to accelerate extended LVT MSR access when
AVIC_EXTLVT is supported.  Reads are accelerated without VM-exits;
writes trigger trap-style VM-exits.

Tested on AMD hardware with Extapic support:
- Extended APIC register read/write emulation and AVIC acceleration
  with IBS driver running on the guest
- VM migration with extended APIC state and without extended APIC state
- Backward compatibility check:
  Fallback to legacy IOCTLs when KVM_CAP_LAPIC2 capability is not enabled

Equivalent Qemu changes can be found at:
https://github.com/AMDESE/qemu/tree/extlvt_v1

Patches are prepared on kvm-x86/next (003f68c79227).

Manali Shukla (7):
  KVM: x86: Refactor APIC register mask handling to support extended
    APIC registers
  x86/apic: Add helper to get maximum number of Extended LVT registers
  KVM: SVM: Set kvm_caps.has_extapic when CPU supports Extended APIC
  KVM: x86: Introduce KVM_CAP_LAPIC2 for 4KB APIC register space support
  KVM: x86: Refactor APIC state get/set to accept variable-sized buffers
  KVM: Add KVM_GET_LAPIC2 and KVM_SET_LAPIC2 for extended APIC
  KVM: SVM: Add AVIC support for extended LVT MSRs

Santosh Shukla (2):
  KVM: x86: Emulate Extended LVT registers for AMD guests
  x86/cpufeatures: Add CPUID feature bit for Extended LVT AVIC
    acceleration

 Documentation/virt/kvm/api.rst     |  75 +++++++++++++
 arch/x86/include/asm/apic.h        |   1 +
 arch/x86/include/asm/apicdef.h     |  18 +++
 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/kvm_host.h    |  12 ++
 arch/x86/include/uapi/asm/kvm.h    |   5 +
 arch/x86/kernel/apic/apic.c        |  17 +++
 arch/x86/kvm/cpuid.c               |  10 +-
 arch/x86/kvm/lapic.c               | 169 ++++++++++++++++++++---------
 arch/x86/kvm/lapic.h               |  14 ++-
 arch/x86/kvm/svm/avic.c            |  14 +++
 arch/x86/kvm/svm/svm.c             |   3 +
 arch/x86/kvm/vmx/vmx.c             |  10 +-
 arch/x86/kvm/x86.c                 |  93 +++++++++++++++-
 arch/x86/kvm/x86.h                 |   2 +
 include/uapi/linux/kvm.h           |   7 ++
 16 files changed, 390 insertions(+), 61 deletions(-)

-- 
2.43.0



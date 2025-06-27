Return-Path: <kvm+bounces-51012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DADA3AEBD34
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:26:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 597B73BDBB9
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61CD2EA491;
	Fri, 27 Jun 2025 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R/4r7ixU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424832E1C78;
	Fri, 27 Jun 2025 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041583; cv=fail; b=uI0p/u3q9FghWQKIrzDOwba6F9RRF0gwrBw5+77Sqct5xillxvy9Qq60/0iqFRi8M/GwBWN92I6OmNAjdDtogvzpGg7NFFON46y7BkjzLyG3sB5e+vDYwcNZEgbufi/8oJaAIpghhR+hAqPubEBLHqG/1FP4EXEm64+spfyFd6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041583; c=relaxed/simple;
	bh=hIcXdpJxEsPXpZSgJ1hmsaMbiv0RJ6hpsCTqCdMaUCU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5zAEVjHCiAYsX/8XVmVrjQb8tKxMKexfmmAcqSvDXHv3ioaBuR5yU8vxM91SbF8nJ6UmcS1GsEAuAH2D4p9pnGDAm/2qXFEESpiZx84Lenu9eFjK39VB83hY2kipmCSYW/YsyRgfwN3vAZaz87yPtLGpSY/lpQvRduVJIuv6L8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R/4r7ixU; arc=fail smtp.client-ip=40.107.223.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tBNc5N+3qmP44sk34UHWaETcw2/S9ZlnHHtpJYfDxBnmHT2ccA+eMkKQ0U+JaaL4Q4QYpEkRu9rzJFnOuXvyjdlvCI3Pkz3Fy48SsJgEPdIXc3sobAk9G1XZM++4IRWJ25zJqm9LxjVJ2QGtU24dl0aEujh1mu+tsIkb0HcKrVEpI19gS7beONWd6a+lJM+Xh3p7CNShPceYZjama0pbPk6mYeMpXLYnzXnrPr4NFOkVrQ6UXWaL3OvY+MvZsycGQ0rRkp2akG+wpfYGbSB3T/fAghpj2fuzZ7HHrlotxN6cO2RhkUP3kk8DgmWuqVgdt8Q0avofGmOna1WdCC6DCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xNnpewKRvqywo29Y2eBbiwivicfBMBYCY5MZRWC678=;
 b=J2dSmcdMo9tPttcrvO/17HQxl6Q/Qlucd5UvDuaNfm81XfDuby3VKev+3sun7MQTTbn5t7OfEvHw5gIan9yHfRSON6w7VmfaPFOr7jl4XkzEQI4uhxCtZl4trG+JGkNToYZGe74rZ+ODDteY+KCN+62zLcdyMQNvU6GMr8OHHODvVa0LFUrRMWdSM0HqknN+UrR5bXYrkSyAtOefNMlRv4hR2oSk83d8XuMAjzojuUpzRGoJokJCcKFaYhhY4Q8aj7XQGtcoPCUAsOsjELHgK9SgG0k1Ur7Az9UQpFlwAg5Ezrt531657iHba9jO5cePY16J1paVnVbXlWCZM1OQag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xNnpewKRvqywo29Y2eBbiwivicfBMBYCY5MZRWC678=;
 b=R/4r7ixUwjq21c9VU7Lb/3Mfds7BkpVjyEQMPbVwC+6z6MhOvhmqvJJxgv7IoAP5Ld18PcbApc/8JR6gYvP3IvEbM5+SGnqf4wV9zzmNtToqMgSqca9WdoUQ156KxVvQl6UaWoRFkpPqzN6U5TMeVFQmKA8FikWH2geeBxmrVxQ=
Received: from PH5P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::14)
 by DM4PR12MB6398.namprd12.prod.outlook.com (2603:10b6:8:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 27 Jun
 2025 16:26:19 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:510:34b:cafe::d8) by PH5P222CA0009.outlook.office365.com
 (2603:10b6:510:34b::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.23 via Frontend Transport; Fri,
 27 Jun 2025 16:26:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:18 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:13 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 01/11] perf/amd/ibs: Fix race condition in IBS
Date: Fri, 27 Jun 2025 16:25:29 +0000
Message-ID: <20250627162550.14197-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|DM4PR12MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: ba3ce3b1-9d28-4861-1797-08ddb5975866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XqTHEPbuTnKe0503WcVUKEBwM7Lp15/kWmWWzgMgr324VTTSzUJ3Rx9+yqwS?=
 =?us-ascii?Q?4Q0Zg8/0sye6jgf/+xSjSugGRrWmsVLqAF2ZmXTcpo+yRVk+9m3Y9NcjRXex?=
 =?us-ascii?Q?8biHXpLnDI7bG9hmlBixC1Y1Q9Jm5Ancts0CQSDxkVWvvjA1uQKxKaqwiQVv?=
 =?us-ascii?Q?MvcxqUxXaxXJHqKJyKCvkKFlaRy5H0h61TTr4aOMb6dZxF/Z+lNBABrXWeHT?=
 =?us-ascii?Q?UYh0vbIwdGvCtw2IAWj8clnD6pNmru+SMceA/yPlfooN9ZHI/uBQM9EQavOz?=
 =?us-ascii?Q?rgDRilSxKYIJzXtfgGJiaqiNEbHFzugZX26OkTHLh8KUgNtqhuMaREPJX2eZ?=
 =?us-ascii?Q?IveuiItz1Q7E6Pf5Kkx4Sc0djeFl6dcklQVd44N3hHZIpAIa83yDch/JsgPJ?=
 =?us-ascii?Q?h4ObreOBxjjw+r7LDBVRc4LLs6RD3KTtu4C0AhWQ6++nwckKc90OMVwC6pQO?=
 =?us-ascii?Q?9SoYhjVjotSrOuPmHPHEC8bEPBWW748qtuShFQ0P0Y9fTA8V+FStioxyl60g?=
 =?us-ascii?Q?mAScVgxxItQAJKMfH/BxJ8p+YtLIAjlQo6/jDkNgWM8k10+5RunuajihQXJH?=
 =?us-ascii?Q?wa9ZYdHtMrr/QlJIhjwGP+74OagZtcWFow012iqJatGIDrIl0W6LdODeAtMq?=
 =?us-ascii?Q?HwdwKpUnUdZh1w0hLb3OvgCacQBItvpNuoV0yvthtx90Y7xFggVaWWfu4Mb8?=
 =?us-ascii?Q?TYq5iQL0JkeTuhkPWpTuhXdKaifElBNZXegTOJqVaLOsy23UYfqYi6RU6Ssj?=
 =?us-ascii?Q?tf8n1901sPexipi+Y4Mvg1XV7LytogH71aC9p/Ua494aTMQuCYb09TUJwbj5?=
 =?us-ascii?Q?OxWbKS3Es3KvFGFxucHC5/uiKw3j8GTOQNT0MkuttSOFaB5oyWs2Hw6dyJyS?=
 =?us-ascii?Q?fflGhGi7Dol1FRCgmvigWCPnqg+Hn76pib1amkBt4z0bJ+JpxI6emO2aVTTY?=
 =?us-ascii?Q?H+cdiT/S2aNvmXogallljrNYJlxpm4zZTK18orG09/D59SJnwKhXe9G8Kix9?=
 =?us-ascii?Q?v3GBzOJayGonB8QzpwDn4PRDq2dTtMFY7vS4/IWt7B6Uvy/CO08tPvVFyEK6?=
 =?us-ascii?Q?ITD/uUcexO20f1f3m+sp2Vb501Y/zM0owo80L04yRQke6qmIn0lg0O2H2J6o?=
 =?us-ascii?Q?46GZnVHXmA5JAuj8rS6N8CO3A6Pvac+TidcJy/KBRkeXIneB+QbQY5vKaXM0?=
 =?us-ascii?Q?ShB+QySZrW7bcKGKZn7VdGauNasZQak+zgoW5qZ8iTSt9EQmMjAsh5MnK+tW?=
 =?us-ascii?Q?t2qceQ5sy2oBTr8hNnox0jtWqa0Xsunju4O2AhzItJc7jZUP0rDkDHQctEln?=
 =?us-ascii?Q?+1pQE6KchwI+dtUo30HfXR1oJZMght0ID92JQTZR/Cs6T+22k6Wsfa6FvDMP?=
 =?us-ascii?Q?56gST0mx8ry1/u0zadxzk19wpBzfjd1WzP33nhERRjfSiZxoGCCUKORlb8i5?=
 =?us-ascii?Q?1WVf8V4GvZB/MhNRb24iWrKNiMhtAe3V1Tv7Mr6kvU0RyAtvOVe6bnzICYOR?=
 =?us-ascii?Q?owqQdgnncWjJIemFKvQpcLhh644YEFb/916m?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:18.3576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3ce3b1-9d28-4861-1797-08ddb5975866
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6398

Consider the following scenario,

While scheduling out an IBS event from perf's core scheduling path,
event_sched_out() disables the IBS event by clearing the IBS enable
bit in perf_ibs_disable_event(). However, if a delayed IBS NMI is
delivered after the IBS enable bit is cleared, the IBS NMI handler
may still observe the valid bit set and incorrectly treat the sample
as valid. As a result, it re-enables IBS by setting the enable bit,
even though the event has already been scheduled out.

This leads to a situation where IBS is re-enabled after being
explicitly disabled, which is incorrect. Although this race does not
have visible side effects, it violates the expected behavior of the
perf subsystem.

The race is particularly noticeable when userspace repeatedly disables
and re-enables IBS using PERF_EVENT_IOC_DISABLE and
PERF_EVENT_IOC_ENABLE ioctls in a loop.

Fix this by checking the IBS_STOPPED bit in the IBS NMI handler before
re-enabling the IBS event. If the IBS_STOPPED bit is set, it indicates
that the event is either disabled or in the process of being disabled,
and the NMI handler should not re-enable it.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/events/amd/ibs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 0252b7ea8bca..c998f68eeddc 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1386,7 +1386,8 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 		}
 		new_config |= period >> 4;
 
-		perf_ibs_enable_event(perf_ibs, hwc, new_config);
+		if (!test_bit(IBS_STOPPING, pcpu->state))
+			perf_ibs_enable_event(perf_ibs, hwc, new_config);
 	}
 
 	perf_event_update_userpage(event);

base-commit: 61374cc145f4a56377eaf87c7409a97ec7a34041
prerequisite-patch-id: 0094bc7b958de1caba7b779c1c2dc96b3e1bcac1
prerequisite-patch-id: 58a6a462207dd7ec06998d6ff6a418f373f25d43
prerequisite-patch-id: 42d94622dfc4ccc786ce9bd6be186dbc5d32ed5b
prerequisite-patch-id: d93658ba28ece72eb6b9e2bb2a2a6188c4654216
prerequisite-patch-id: 669a4b410b39f4f34b9bcc4748a277ad2ac3b24c
prerequisite-patch-id: 89161a3395ead9159840634b594b973eee4728e0
prerequisite-patch-id: 58860afef836e3429817055807502201dd914602
prerequisite-patch-id: 9de4d874201da2dcec388e8fe4b3750ba3afc563
prerequisite-patch-id: b1d44b6a3ed8124ce9bd71474e367c8143baad41
prerequisite-patch-id: b7d50d21fe0f1c6d3b63d31d8cf573ad4bd06d33
prerequisite-patch-id: 526f07d6a60996b4839a170bacead2eeacf953bf
prerequisite-patch-id: 602259a8d1ac84dd95ad56463ebabc55e612400b
prerequisite-patch-id: ae0e84487c58d976362fbef7eaec565b14162d3e
prerequisite-patch-id: 78ba19a866d65e36352ec8f5bbd039bc2108e54c
prerequisite-patch-id: 973787b7d310a4cbe45836921402c6708bf3f67a
prerequisite-patch-id: cb2f413bf916cb895c26a27bd6415396c56b3e63
prerequisite-patch-id: 7546a92ef58aa9e40b1389650f5c7ffc28de40e5
prerequisite-patch-id: 0750ebfe9b7d25e9b6bdf838a179190c958aff97
prerequisite-patch-id: bd71d326c645eff74bf3f203ebde1739ad2eaa64
prerequisite-patch-id: 1937d5112d9a975009d3b75cebd16fabd7e595e0
prerequisite-patch-id: c3e3bac41574713b413d6ef13e373953080d26c9
prerequisite-patch-id: ebf87b381105b90d89670f3f0e123de8bc4e2086
prerequisite-patch-id: d450df9a0e717374c4a73355ef438e8b012e2ab7
prerequisite-patch-id: 91d5d4adfd44253424016b3132de587328f4d1f6
prerequisite-patch-id: 5743f22d48a3e410ab28ce6d81d6213e9854128d
prerequisite-patch-id: 0f8c5fff2d0ae8eb84446439bbb1792e078acac8
prerequisite-patch-id: 9ead85c0f9cd7a0a5448e2aff7e2d94fab9fa106
prerequisite-patch-id: 4ea3a56935fd4a23c2c1101738002bb3c89c8723
prerequisite-patch-id: 303869f48baa0d36f8a894bea87ba9283314efa1
prerequisite-patch-id: d774d5ff6a124c32c86a6db6bd5d97285591294c
prerequisite-patch-id: 9708b3ac43c53623fe553e88cf42d06940af1d43
prerequisite-patch-id: 5d890648afbf86e18eff47520a10a8f6eefb5f6c
prerequisite-patch-id: ddba6b9f04901285c77f3af1ea5ab50fe063b015
prerequisite-patch-id: 2fafac2db57921b28591ff0bf1e38f911870ef05
prerequisite-patch-id: 16cd8c4d184fd1e4217835aa43c38d2986bb30f3
prerequisite-patch-id: 1536075a6bd45c6c2484e9045e6f0173dfb4fbc2
prerequisite-patch-id: 3dcc0186dd0c08353bb3ba50c384085fc6ded721
prerequisite-patch-id: 6c2e2cd3416fba38621f75286283b452765ee3bc
prerequisite-patch-id: 4cdd5b8e215224a7dd8224914cf1dfacc4f52a96
prerequisite-patch-id: bce24d584bfaf81b23ba88aea97187387791e8fc
prerequisite-patch-id: 3981227aa4d106f583a9ac07ca08e416b60ea52e
prerequisite-patch-id: 9b56c12722196db1ed0ab3a5aaf3d5c5b26e8814
prerequisite-patch-id: 9f3c7f29d4142a13b919356c458059aac4732082
prerequisite-patch-id: 218445b88281283066b23a1844f51098fe670f49
prerequisite-patch-id: 5d92b7d25437e3d3e5e3a5a08e779bb23b10d5ad
prerequisite-patch-id: 1d1a5aee655b9adc11daa0b24e5a6a44dd2b55eb
prerequisite-patch-id: 94adf0a619adcc857014fd1b5b52d2bc6a920aca
prerequisite-patch-id: 5317018cfb51d5aa27bab2ca259fa6a36aad6303
prerequisite-patch-id: 083070d1b008b9396f64ff3ea1998e624db058ca
prerequisite-patch-id: d69b8afdc062ad10cc8dc2aad1759dbe70fc666c
prerequisite-patch-id: 1f1045ecce2d127cbfc0a382adba9c4bb711dd30
prerequisite-patch-id: a7a8a308c1b0eca850bc140019066a52a9aaf64a
prerequisite-patch-id: 1891c0fec1d1f2ba2dd26e79a8207b0e13a0f8bf
prerequisite-patch-id: f4027ba53a2e69f12fd22697dbf1f97951323d6a
prerequisite-patch-id: 8ca87584eaaa9fda7ffe7bfac4684af9e82988f5
prerequisite-patch-id: 0000000000000000000000000000000000000000
prerequisite-patch-id: 4537a12ab34d9c9a40d5602b51e8ddc968d6ff83
prerequisite-patch-id: bc8ece4d02f8b541d5fcf731059c35861be5eefe
prerequisite-patch-id: 1759acbd0b0f8e8b974e22c0627ea81a0b1cb431
prerequisite-patch-id: 2876c944ff6ef5ad1e146cf04674cafd08023369
prerequisite-patch-id: d7245aeede10610be8545ae9344ae0a4ce5c4227
prerequisite-patch-id: efad6c0b30a629d976fce1ca63005b064029354c
prerequisite-patch-id: 68e90423c6d9ddecf4262234c0791b807885f7cd
prerequisite-patch-id: b8015065a77b10b3d27cc0277ccc4d8cbb476008
prerequisite-patch-id: 76180001a4e5e51fcb68e08403a82edca008e8af
prerequisite-patch-id: 647937e4716b773c813aa2de6cf689c518db8459
prerequisite-patch-id: 61e0acf355c7cbbe888f03ae3ebe5fa3df83176e
prerequisite-patch-id: 32eb0a230627e45739d15b1ffbad9e897144fcca
prerequisite-patch-id: a0f10d6af86558cb3752f32111ebee4e6ad0887b
prerequisite-patch-id: 219266326bb1c41c441d92a82d5e38c9ca8a066f
-- 
2.43.0



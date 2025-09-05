Return-Path: <kvm+bounces-56933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E93A5B465E2
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59697AC1293
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF33F3019DE;
	Fri,  5 Sep 2025 21:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Rc3ARACK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C122FC019;
	Fri,  5 Sep 2025 21:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108306; cv=fail; b=HSUVwRxbsJSmY/bsmzxi5DqGQ0N3ZyGjiP+MiNNuuQIcDocHrc45AZnc5W3Cy/u33oPKTnAO1QTLLyJElMyPFeEWtdn/Q5GTlY61MfMBuLtZHdLQAhkzM0/WlSZcja+c31yIP/vX1pKruV31BPOJCnyg/zjR6sDAk46ss4cFI+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108306; c=relaxed/simple;
	bh=XLdqyNLnGFdiQKqUVr5QJjNKgZ+PJCYwRQPkhjDMeGk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HHvg/AdC/xAzGhkN6uiM0UwC/UdtHKCnnWpTxixkl3VCuoQWu+gIzocq0awxFzYbNlCwYUY7keSSJYL9Z1IVRWTkE/Dequa14emf2MLzzyKDtb2PxEa18btHE2E6H403DpXt6d+VE3Ge2Z9pAtB59Dc5ObfecORMAkxwXjJrwKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Rc3ARACK; arc=fail smtp.client-ip=40.107.244.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ru4uWsuTcVkyUTI9Q2cpYcoBQJb1Rn34VSV+trrN8tVNFl48g7jGW1FOgf33jgmHpF7I28V5S7Exhu3pU97ZYRWqSyk4ehX/Vlu6uVbZrn0z+AjwXmQ2s3Z5O+5vd8usngFTgNvPbzCA8+Jo0a9k7xYoKfgOOTqhs90QmMx9o6C4hAxCG835Yn5UTBODH8/iE2JFKdL6GPOZzfViFYRvGSjQICwqWMKYc/PD6pSgTaoA9WwYQN82QD+EdGSxV5AjA4Hjh5G7mw59hXZsrIU/xFF4rqiZvrYzNjcITxXfYiZXbshrjoSaj0y9PKfoZTlpKmP7M0UUcoNEjEofrxGxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fS1NaGHfxaDghH476s1MJ67hV6gyO/axeUkpAGT6FaY=;
 b=iVPQ/WBf4Wt9WVfAIfC/PGFMjMT0N0tdgAngCSzPWQ0tITsKhaRezLa7n5BfD5SGvSSNqiHWYu5V2bsnCYfKKzQ0EcONXrNWf0idpWxrC64DqeuMHnwiST6lpBMT6J/FQSMrVA4AsxR++YKDNhIRbxJNJSzUztWd+X6r92fd6uw6vYGYLXMMYNphzek+C7aypYNdVTvUZqsJfv2jziBQlyS8/1HiMl6O2YZB1fk9im0IC8zUQdXrtRqueFbfsy1/SqtX9HAGjUIlgE04ws7KCfPbMr6G/PHTQikbYryzahsyZ5Q2rEsz5HlIuGgl3athZy4vrvaxTTCPocDHbpswrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fS1NaGHfxaDghH476s1MJ67hV6gyO/axeUkpAGT6FaY=;
 b=Rc3ARACKUmk+rXm/EVUyvZGJP60PGnkOeUdlaOAWFJIhg0upOnXxb6iNcCBJ6Tl5MEeHuRmBer8ixt6tqqack9cnKteaopgvsisxHiGrKb4CUEaWuIqzOXPhdh8OtRMYjQc6XQoORFcWeB7LIIH6fNNgjoHmxaSOv4GRZs/g8Z8=
Received: from DS7P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::11) by
 CH3PR12MB8259.namprd12.prod.outlook.com (2603:10b6:610:124::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 21:38:18 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:8:2e:cafe::54) by DS7P222CA0009.outlook.office365.com
 (2603:10b6:8:2e::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.20 via Frontend Transport; Fri,
 5 Sep 2025 21:38:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:38:18 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:38:16 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:38:14 -0700
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <babu.moger@amd.com>, <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
Subject: [PATCH v18 21/33] x86/resctrl: Refactor resctrl_arch_rmid_read()
Date: Fri, 5 Sep 2025 16:34:20 -0500
Message-ID: <42b6175169d36c2816cbdb3f31e53a98210ff501.1757108044.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1757108044.git.babu.moger@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|CH3PR12MB8259:EE_
X-MS-Office365-Filtering-Correlation-Id: 65251ca1-9b0b-4a93-6c9d-08ddecc4871d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9EI9W89pKW9ijlvT7l1P8h+oXvI+EYFu3wDOCimS8VKTYl9Z9SYrR9VafTpY?=
 =?us-ascii?Q?QEd5v9k0l48BIq+W2a1IZQew71OoCyReDhbIXCBgCGhAN3sKPa5rDr1Qa9yV?=
 =?us-ascii?Q?R3u6U6GY5NHK5So5eu7zrZZT4jp3dFWbT+vFgt8EGWbroQ8/xGGikzlMCPyY?=
 =?us-ascii?Q?brEoViMRcJI6DbJfuN+wm58L2k3Yx4sozL43bwB5dcr8wWQN9xweBR6fmvVE?=
 =?us-ascii?Q?EG0v+NtWhUuuFSKFEhDawv4QZc0T1/PuG4W82Ye70lhUsS97VhUFc3Ao0zEX?=
 =?us-ascii?Q?UKPGk1TfVt7L26yX4kZlk+wWkrqZjRPwjBukGSWY1ZsMp11ajGfR5v54ZnQ3?=
 =?us-ascii?Q?LSUTuXTnKqzSos4oKB0SQp0dnz/9j/+2c/UVU3oYx3jTc/CKEOEcpv2poc96?=
 =?us-ascii?Q?d2egI6GZsnxOfncItzSKnYxROX8t1NgrfMBji57JTQTaU+zVo6zlGDYRkRwk?=
 =?us-ascii?Q?6imTV5cOtx9G94BUjl80gn8fPpTQJpJIgFBsbq6aew9GRDuGdQ7u3K0wLTh+?=
 =?us-ascii?Q?rCmUinH1R7iWBGl7OwlSL44mT/QOFy1T4uXKigO549+nItNqSj6CQLZ9mv4C?=
 =?us-ascii?Q?P1U/t762whd0nu9MM7GNpvW16HIrQKWSoCHs4t+I1S7LLUAPGJINj/l9ByzY?=
 =?us-ascii?Q?Wp50JRiJocXMEk+TP7VY8KwOLarb62cSTqVCAZCVTRJsMJjVKSiTqq3C7Olj?=
 =?us-ascii?Q?MJpq7Y1lnYePtO3BkE0Ga9BCSg5qzTVDBCcaI8D5VKCM/2k7H8dFAFcLLSw0?=
 =?us-ascii?Q?Rwxv0sszYg9RqLqGG0LPcj0X/UGGxi1tDswC5asKye6SD6ZFsLG3z0UvvExY?=
 =?us-ascii?Q?cqzckPN9WeLxe3Qa0kXbKPPQR/IfaTTI0a/P3BWlhCjyLgBoTm9JShIMIgta?=
 =?us-ascii?Q?HJXqdKLohebvEjOGsHXC7jliF2pRwXf+etC+uWp7D0py/J6AWosGtb+Fukso?=
 =?us-ascii?Q?hB15tvVZfaglMROFE+UQGOXnDvmhUwC98G/1dI2nmHn+ACHtgGhTpHNiSKRm?=
 =?us-ascii?Q?A3Phs1VoGLwmATGUB3+bFTZkFL5EtnuJssNeDsb0t7QX+cCZ/QwUJwSFkUE5?=
 =?us-ascii?Q?ywR0GQS+10FPsLIuLRaTBsGORGLunN8oAC0bRTbkYdL5JjK6IaXKtP8GH/Hs?=
 =?us-ascii?Q?YKN3GtLUL/I5EzmI8mZaH6UiUbi0KhjpKGhfT5x1G+YVlUidcvBFFNdPNc9+?=
 =?us-ascii?Q?/+4JWc2APhAO+bufVdXd2ds+lNfVevATrfOtK4QoOUnBSD+5wdOqp0nfQNvo?=
 =?us-ascii?Q?tjF6LakxhNDCNHveV8AJD4Uhidyv+89jQ2PjXxwNfZYGIF8FOE6DRm66CR/L?=
 =?us-ascii?Q?5nVNkovX40IJ2iE/ebpZLZJvYTMJ5OAgWhXIY9IdiO8Y8R8G5QQx6wqQlOFE?=
 =?us-ascii?Q?PP6QRGoIukuQj2hna4CEebZqMGjwG4uzooiKsW4OtA5Fd2hli8NKBRBswdQx?=
 =?us-ascii?Q?ieInf9h6oRPz+O36HvD1oyxiWjR85wdwGi09Muwq3UV36x/eKFNcXKEVZLKR?=
 =?us-ascii?Q?FEYnszn3vnRbLXtuvRWf1rS8IK3XPuGfiKEcSPRUGL5Tx3u7Z9iPHyvnzw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:38:18.0268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65251ca1-9b0b-4a93-6c9d-08ddecc4871d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8259

resctrl_arch_rmid_read() adjusts the value obtained from MSR_IA32_QM_CTR to
account for the overflow for MBM events and apply counter scaling for all
the events. This logic is common to both reading an RMID and reading a
hardware counter directly.

Refactor the hardware value adjustment logic into get_corrected_val() to
prepare for support of reading a hardware counter.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: No changes.

v17: Added Reviewed-by tag.

v16: Rephrased the changelog.
     Fixed allignment.
     Renamed mbm_corrected_val() -> get_corrected_val().

v15: New patch to add arch calls resctrl_arch_cntr_read() and resctrl_arch_reset_cntr()
     with mbm_event mode.
     https://lore.kernel.org/lkml/b4b14670-9cb0-4f65-abd5-39db996e8da9@intel.com/
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 38 ++++++++++++++++-----------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index ed295a6c5e66..1f77fd58e707 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -217,24 +217,13 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
 	return chunks >> shift;
 }
 
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
-			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *ignored)
+static u64 get_corrected_val(struct rdt_resource *r, struct rdt_mon_domain *d,
+			     u32 rmid, enum resctrl_event_id eventid, u64 msr_val)
 {
 	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
-	int cpu = cpumask_any(&d->hdr.cpu_mask);
 	struct arch_mbm_state *am;
-	u64 msr_val, chunks;
-	u32 prmid;
-	int ret;
-
-	resctrl_arch_rmid_read_context_check();
-
-	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
-	ret = __rmid_read_phys(prmid, eventid, &msr_val);
-	if (ret)
-		return ret;
+	u64 chunks;
 
 	am = get_arch_mbm_state(hw_dom, rmid, eventid);
 	if (am) {
@@ -246,7 +235,26 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 		chunks = msr_val;
 	}
 
-	*val = chunks * hw_res->mon_scale;
+	return chunks * hw_res->mon_scale;
+}
+
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
+			   u64 *val, void *ignored)
+{
+	int cpu = cpumask_any(&d->hdr.cpu_mask);
+	u64 msr_val;
+	u32 prmid;
+	int ret;
+
+	resctrl_arch_rmid_read_context_check();
+
+	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
+	ret = __rmid_read_phys(prmid, eventid, &msr_val);
+	if (ret)
+		return ret;
+
+	*val = get_corrected_val(r, d, rmid, eventid, msr_val);
 
 	return 0;
 }
-- 
2.34.1



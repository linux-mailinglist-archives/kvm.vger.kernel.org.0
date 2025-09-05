Return-Path: <kvm+bounces-56932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 963D1B465E0
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:42:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E6FE1D20FA8
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17752FCBFC;
	Fri,  5 Sep 2025 21:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Fr0KAinQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCA02F3C02;
	Fri,  5 Sep 2025 21:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108305; cv=fail; b=a8aFm0VJYKJOAGF23YzeT9HVpobvQv9L1M2DNlT5mpproOOb0wzSK9vZuC1UT4u+RR5kSO+7HUpwjXgoMFOPPshFNL7uPCVt5j+1nDr3PLMe4Zh4zKdrJtZUVqlMO9gAXX269iEzJEJwMAziyPWxrNf806fXFWn6JCF0rp103ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108305; c=relaxed/simple;
	bh=YY84v8YuVOOxpkIeodE7nMBezDcH2wfNQtUJwtf1418=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mxBexMQO/a5J4zb6ZuUK2+omU4P8t0YPVc9ZgKkZ3I9v0LFojuzMOS/XGQUFVWD9VRl9eIGi8gohfgTXibgXqp0UuL5CeiNLePQN9BdfAHMh749eRlPNvsAhOtQBii0sN357RglCzCy7/0FkCoA5DUfM35net9UN1Z5mAlzBZ74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Fr0KAinQ; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c+KsXbTl3xPedXk+O1J8T2Cqcp0DnbhWs1R4E/lfN3Rmpd2sVt2AoWSOgh2tnZ1vgHoY+VvJunNR1IQ20qI2JwU/Q4odirx6o09Wxj319+EglzPMZ/vPSXdMrKll0rI9wuKq8Ui3ix8lyn/MmC4R8HrM/4kml6r1Dhh0NrvbcyugJkoZ84hLmbUyeHbLO1M4yGkzBk3Y2iWDqFT91Fod5LPyG3mXitxUf50dKzIjognLZD8JDwelPFAZHO93G4viMLWgdDpf42EkKwBKlhGJWBaJveDKzMMgPkjnSE0W6dfkYBq+JpVecmXUBkQ7108kS09WYDRYNv3S3OWcYE637Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Thycru3oudQXSaPA+1fKGrrLlOiNrZVUI08SJnNSZDk=;
 b=x5xT8usEmUYfBHoirCutm+Sd7kH7saIa1F9ou7p17bI8K1GLGJoRM6xKOU7Vos2OGBBuWB1RREwFui/OSbaOkydmvvsgIhtcHcMDdJLw0tdGImnFQTbiJLWLOYoOlbrOjtMz4eII6pTq+V18MRmsO9DJXKcxIXSLvlRY9O+k/O37gqclGZ7pFYgVUhGF8oTn0ml5blpj7kOI4jtVPDmY3Lxn8Ku4WWb/j9zjBtX38wG6xLXxDYCY/8B3iSSrAwdh2T4E9AqJbhzlxiwvxwVX3lTvDD9XSmYeibXJTeQf1+BTbJ+w1hI+MD8PintzX069bSIyS5tQdN9qUlXvgy+tyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Thycru3oudQXSaPA+1fKGrrLlOiNrZVUI08SJnNSZDk=;
 b=Fr0KAinQE/+NlR9vwTDWY1hP4HRojK4e7Q8D7+zCq8UBHSpm2gS3A8LlKKerSt9zKWyYWKGa/Cs/LKThsRkgfEr2jMprWA8PnI3b3FkyljKccrpZCrYbjYK0oKiabztPS7g1CeyFdrQp/oAse/CmUi7F5eP2GPmWi4GKDsdJeWw=
Received: from SJ0PR03CA0043.namprd03.prod.outlook.com (2603:10b6:a03:33e::18)
 by DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 21:38:14 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:a03:33e:cafe::df) by SJ0PR03CA0043.outlook.office365.com
 (2603:10b6:a03:33e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.18 via Frontend Transport; Fri,
 5 Sep 2025 21:38:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:38:13 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:38:03 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:38:00 -0700
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
Subject: [PATCH v18 20/33] fs/resctrl: Introduce counter ID read, reset calls in mbm_event mode
Date: Fri, 5 Sep 2025 16:34:19 -0500
Message-ID: <7ffd07b6ce5f4f0c4719d9997b4580043c29176c.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|DM6PR12MB4058:EE_
X-MS-Office365-Filtering-Correlation-Id: b2732118-b264-4bef-eb04-08ddecc484b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cmlTQVHmWOejt4NPAtFzolpkqirXW3sumfdHB7ZrOStoQp8w3LSvMiAHAb1J?=
 =?us-ascii?Q?7yPPAAbrTBR0o3VivZm6HeiDolr+BUAMhqPEvCMGovdEN9ja5xPNMd4TyQc3?=
 =?us-ascii?Q?Fv+m70MUEK4a5X41uaIHWnE/zd2Sxew8btZXA4X3rWkiJE19Owg7ffYUoK12?=
 =?us-ascii?Q?PTzSP3y1H91KDcNC/0EEkKeGatC1u7u4wNrSB4H9539764TinrZLcwNK/ooC?=
 =?us-ascii?Q?QXPjCUatU1cB5OXmJO4v5/vy2RpDp89PSbopxc4G0yLsa9TsN/WrTmxH+6GR?=
 =?us-ascii?Q?TtUV1br0zeYZ01vbwjwhwWxjQT6zoQ9Er3BDkVzgo0CSohZaOFKIKdVloTfE?=
 =?us-ascii?Q?Bn/WLVVKEiBbPczaQXONWW+SsXf6gOQXXt3mXdhGTL9fKOreVro5VDfbXvQ7?=
 =?us-ascii?Q?c/hJAhS71QQUJHk//SckpNt3f1UGk+MH/UAMeuDS9n//5YB9CARFzCFzlh6y?=
 =?us-ascii?Q?XZgo+KBRAaR9sl11myVTsJQKuuAuo/lJnPFzNYFf+WWrvdyRC0dnNI8J7Apu?=
 =?us-ascii?Q?JSqMaQ+OUIFZ7sFp3twrNkny5Wqo0NPmpD3blkfQDky4yHP/VAS9FhWJshHP?=
 =?us-ascii?Q?H2tcw0Um6/ZV6itEUtGAB4HOSZkH5wA0T/n9HGXqE8bxFsb4yEA4ixPc+kVs?=
 =?us-ascii?Q?URIPVl2nOVkdvJQDS3hATqVPS0wMhIVZbCHy75RQ1JIAHrEyDkxD8alasMoE?=
 =?us-ascii?Q?J67eM8IxWc3BuOXLUB03RXj3rJ2fwfs9+jBZVH9mBFNZt05Q7f2WU3aJVSiL?=
 =?us-ascii?Q?gBQEwBYzs/h2uFRFb+DTx2vX+xi2qQBpLxYBU7Iv8NOjy9cRs1eUGWe9Vv/H?=
 =?us-ascii?Q?NRWRWOWa3tTnWbP4bBsi1HkZz3153cvaZeacFE6igGappznFvK3rqRgcpKyZ?=
 =?us-ascii?Q?ZxHN+KL8wHHeB16q26qUnZYbsh1BZCe/AJP+SkS6YsdYXHDkLxbVGvJDjhjf?=
 =?us-ascii?Q?J0SQWkCLRB+gtJaOhyeS4r5tfLchqi7+XplIIoRR14zrC3u3NzHTvLx+2prd?=
 =?us-ascii?Q?TzPUkgyylMoOaol0Bp6sIJG1oOt8BGp4Lb6LGeCr5vJRqmQQ6ky/zx8nGDIN?=
 =?us-ascii?Q?/6T0gUtiRZy9VzgkLkvYBNP6FPvukTPYq2zPNWoOcDV+DH/YflewrczaqdEh?=
 =?us-ascii?Q?WSVb07MXw4u1uMuf+ofwB8cYQcP/xhxCmrCMKwdObswAPcTX9U/b7b/FlLiO?=
 =?us-ascii?Q?tnIUQoTQvKZzlN1DElQGrc1jfDKF06pI1wbmtnZcN9uWuJMbXR7yXMhimZ7n?=
 =?us-ascii?Q?ZAEqPUjhbvp3T+EoR7VDP8qKqokhWHG9nmOTg3OCAThz/lLYixXUBPW0F2hx?=
 =?us-ascii?Q?1slMeDqVVvxy4cMkl61zFQrur6iVceZ2xIKEtcLiEA4RYjd3QIQdlgBFPQFd?=
 =?us-ascii?Q?1oacKZ7CoTG/dVGK4GFcdkszqTYw55kodvOqpZSj8J4fz+YesTpizyHFFbuD?=
 =?us-ascii?Q?FV4SAPU2YJTu9SURyjpo7+h4IzbE0UY7oaGRo80cMaXYHmOgwAiZlXNRKGSB?=
 =?us-ascii?Q?pFt3SM1KMuNW2+U3AOLEsOQlOevjrSJNuHppONjj9hkLMK+d5gZC+Ib3Bg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:38:13.9731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2732118-b264-4bef-eb04-08ddecc484b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058

When supported, "mbm_event" counter assignment mode allows users to assign
a hardware counter to an RMID, event pair and monitor the bandwidth usage
as long as it is assigned. The hardware continues to track the assigned
counter until it is explicitly unassigned by the user.

Introduce the architecture calls resctrl_arch_cntr_read() and
resctrl_arch_reset_cntr() to read and reset event counters when "mbm_event"
mode is supported. Function names match existing resctrl_arch_rmid_read()
and resctrl_arch_reset_rmid().

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Updated the changelog.
     Updated kernel API doc.

v16: Updated the changelog.
     Removed lots of copied and unnecessary text from resctrl.h.
     Also removed references to LLC occupancy.
     Removed arch_mon_ctx from resctrl_arch_cntr_read().

v15: New patch to add arch calls resctrl_arch_cntr_read() and resctrl_arch_reset_cntr()
     with mbm_event mode.
     https://lore.kernel.org/lkml/b4b14670-9cb0-4f65-abd5-39db996e8da9@intel.com/
---
 include/linux/resctrl.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 50e38445183a..04152654827d 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -613,6 +613,44 @@ void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
 			      enum resctrl_event_id evtid, u32 rmid, u32 closid,
 			      u32 cntr_id, bool assign);
 
+/**
+ * resctrl_arch_cntr_read() - Read the event data corresponding to the counter ID
+ *			      assigned to the RMID, event pair for this resource
+ *			      and domain.
+ * @r:		Resource that the counter should be read from.
+ * @d:		Domain that the counter should be read from.
+ * @closid:	CLOSID that matches the RMID.
+ * @rmid:	The RMID to which @cntr_id is assigned.
+ * @cntr_id:	The counter to read.
+ * @eventid:	The MBM event to which @cntr_id is assigned.
+ * @val:	Result of the counter read in bytes.
+ *
+ * Called on a CPU that belongs to domain @d when "mbm_event" mode is enabled.
+ * Called from a non-migrateable process context via smp_call_on_cpu() unless all
+ * CPUs are nohz_full, in which case it is called via IPI (smp_call_function_any()).
+ *
+ * Return:
+ * 0 on success, or -EIO, -EINVAL etc on error.
+ */
+int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+			   u32 closid, u32 rmid, int cntr_id,
+			   enum resctrl_event_id eventid, u64 *val);
+
+/**
+ * resctrl_arch_reset_cntr() - Reset any private state associated with counter ID.
+ * @r:		The domain's resource.
+ * @d:		The counter ID's domain.
+ * @closid:	CLOSID that matches the RMID.
+ * @rmid:	The RMID to which @cntr_id is assigned.
+ * @cntr_id:	The counter to reset.
+ * @eventid:	The MBM event to which @cntr_id is assigned.
+ *
+ * This can be called from any CPU.
+ */
+void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+			     u32 closid, u32 rmid, int cntr_id,
+			     enum resctrl_event_id eventid);
+
 extern unsigned int resctrl_rmid_realloc_threshold;
 extern unsigned int resctrl_rmid_realloc_limit;
 
-- 
2.34.1



Return-Path: <kvm+bounces-56944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86940B46603
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D847D5C0521
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4BD2F659A;
	Fri,  5 Sep 2025 21:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GtpNJUy3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1228427AC3D;
	Fri,  5 Sep 2025 21:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108423; cv=fail; b=apq3Y8U/5RuisQu85VD/EgwKciwUDYMEBWAYWbTiEpTbCJkMHRIA7p3S4XwHv0lnqLvASe6FiRfkzhT64Oe8OIBaxmk0XmuVAKRH/bT2i3EI3a6g5kNNYfFHlSlnAWH6H10O9845AcnIMAeTKI4ThZeEy/qkEGuQ25cecEm1RXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108423; c=relaxed/simple;
	bh=G40ZqCG8h1T6ZnIz8fxn5UgrLGegEpx2gFvH+owDsps=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/YYS2IWvZ2cao0h/AYvohj/H5EI5ww6M/x7ue+rg8XwZ8jLmLJWdEYXmQDBZZgZ0ol7J6a0LZeNeYbyrFT/v+J2PehpMkgYZ2Tk3l5sO6ZRee/UueAx2gGeH4IcNVJiuNjYVl2UEMKlevnsLoYetHUevKuIcOMnWMeb+qp7FA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GtpNJUy3; arc=fail smtp.client-ip=40.107.220.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SbrqrCTcSwICnVaN7LsPyf0TBisSOMIDJosLjZBp5RfFZCdiDgwBbtMJFsc742/TAYERfWBPj4oYVZUvsHQ43j31XS3kyDcyb25/h2B/FoyRVhM2dCA9k6Ix0aMWxjguw2trmTRdyFymtcoQULaA5XARMRcliPp5j1OH0pm6X9uYPayzbgZEyy9KT3pt2p4sBHwY5LmFK3L0RaRc4jztsl8hLGcI6Lf69jZcMJzvZCwcSs1hMLP9rI95U5eCxblmk8x4pcxyuEVUb0V5P2ECjiKrFHzphFWdMvmYc45CJcMo1eJWRpoE0akjbYmenYASvSiKMP79XFHQjRPwzx9SDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCVMXcpYUggKCajOLxqi/QTPDGUFzRTGazH905QRaEM=;
 b=mDpeHmwU7jD5BJ3G/GyPlmp9/rePSybpXor9QfvNi+BJkGyr5G+5LP3T0/wx08l4d5FQ2odMmunbtROV3m5PtOioOJl8sYLrAJWzJHFzjngxJRQrrP737PCVvjva5MIXu+kAfWZJ/kpaFRSspmb9ZwgTB7LTv4anSWlU723PABjThopyJ4CYPrFDrtwwtYuRi/Z0mXyk8H/zdjkCtJry0n2bqR24zBO8kOcdH6LX+FpffXu0xZ1gjaLd2lbiw+pizSnvlpQoRpfFU7cPw+keDBbnjjLSusyfI4HKI6u08hl7TquMcOmgPbdDNxCYTJd3GjGAayx5/LHmH48XbDDWJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCVMXcpYUggKCajOLxqi/QTPDGUFzRTGazH905QRaEM=;
 b=GtpNJUy3Bwdmpf4RJUxOodTXrcK/mxkHzxEUqbSZh4riOh4OQ/yqy7p4WWU+toFh8hoQRl/mFKeMUKkjkrUCpB2Za9SEvB763ojKYFV+gjsnBkIvq1M8zzXQTxJZWVQUCgXZQ9qf5G1oXB88Z/vwGH3syyndL72dZxq4/rGzDBI=
Received: from DM6PR02CA0099.namprd02.prod.outlook.com (2603:10b6:5:1f4::40)
 by DM4PR12MB5961.namprd12.prod.outlook.com (2603:10b6:8:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 21:40:13 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:5:1f4:cafe::65) by DM6PR02CA0099.outlook.office365.com
 (2603:10b6:5:1f4::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Fri,
 5 Sep 2025 21:40:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:40:13 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:40:04 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:40:02 -0700
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
Subject: [PATCH v18 32/33] x86/resctrl: Configure mbm_event mode if supported
Date: Fri, 5 Sep 2025 16:34:31 -0500
Message-ID: <e37577c1c0bb22c2e1e5e28f36f831623d56221a.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|DM4PR12MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 10458d92-e604-4fd0-940a-08ddecc4cbd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IoCdsztBN/U/pfIiGW0ENtYs3AMWGAX0tnKROOIeNkqUQIfjGy65FtmNBJaG?=
 =?us-ascii?Q?lbI3/ax9R3aG2VlfgrDFtn39+t7hROdXynjC8D+brLjtXd9eemcX+Ie8F8Yc?=
 =?us-ascii?Q?KackQSTLa7ld69IGoLUp0/5azRC4/NHEfoMKjLw3F4WHmyC0RSA6t38abZNh?=
 =?us-ascii?Q?BSE7IfjfdOoC7VQ3odNnoimJYZgFe8X80KYcx7PPJQJx8V1ocVTHqL5FZK06?=
 =?us-ascii?Q?mGh5ti+XS1d3IGUzjU9uexOvGtlyG5d+Jv9eYcomPtRw5xok6B8yoYzHKYqp?=
 =?us-ascii?Q?bqvn2Bnrsux8B8042Rl0e9FyfN3SYWOrKRtpzbSwRQv0iCjrocjxlYP7gVVB?=
 =?us-ascii?Q?FKjH8l1Dwyl4TAcEBaEVliKM/2CoQBDK+JWx+iKdHRUmJlRGvuJcRafVRYm4?=
 =?us-ascii?Q?mc8X8RzfChhZ9SVEcY+l2znG2Oqxblr0fLPusUm2auNH3gXUgfBffBGkeKE0?=
 =?us-ascii?Q?VwN8kYIBcxFDrYE7Mn4iciTOiYPllaDNogXXPIYn30iPTlkZCAiCPFypp+fq?=
 =?us-ascii?Q?jrlhhPZ+CW7gVuGFKccy/6uhopabkHCIJCgDhVENanywFbcMr0c6zxQYTb9g?=
 =?us-ascii?Q?/+4QyO9IVe3Z7Gkdt26Zo07OUUruC5QoR7Dtf1dkSJE110gtxNxaV5tdHE9s?=
 =?us-ascii?Q?doYaaEi3LcySuGSEyRDxlnMWe7FddawT8lcRebgjb5Pnx4N8TjqxtoP8Anki?=
 =?us-ascii?Q?68d+LAFrOMjKkGZLBUqO1WejM620FO44zVbZRR8of7yWkCSWhU8JNeZ+Jxfs?=
 =?us-ascii?Q?Wh97NmeB5JS0tmktGQAcadR8puxJYyjZCWeqxfP2S1JaA1bV+Tpe0FnmXnEi?=
 =?us-ascii?Q?nFMaX9dtUDf2NlPAfEpJ9msjDqGXpadpjVgsOCPRwH8VcqGlaenO2HlHzmj0?=
 =?us-ascii?Q?jUIRGA1FrfWDhC45xkOT2vpKLWjg0YHvPUh09rRTu2CgS41pbyb+xy45qNDc?=
 =?us-ascii?Q?RpSkGYCAjdrpS+35WjtPPb0tFNkOw2B5yRWq+QxWmKecri3bD40G4JV5S4y+?=
 =?us-ascii?Q?AHTzbWqSQd085RHY9286qpbLqEAwhWzZGMUZrsM3jLDFSs344eydAYOC/CQL?=
 =?us-ascii?Q?TmtX9KClzqg8xnXmMOOCDT3XAm2A/bpJlJtWqCGIYy1qwZu3/l+Kp+CC7wuj?=
 =?us-ascii?Q?rA+9ecOYcEJJu0ZYKDmrLUf8BAMfpsFHog5w+HKZeqjv8Kvlj3BjYiPFqpOx?=
 =?us-ascii?Q?Suipe7V64HejcuOH1qtAJx31M8DNsTqL5Jqn2AG3FZ3KwjZ+7BlltGbfnGJT?=
 =?us-ascii?Q?muquE+u6jOFJMrgVtRFxEAzjXToHWzuC+DUN0e8rFWCX98E98CNmk7v4to7V?=
 =?us-ascii?Q?4eXvFu2yOrLTon3NV41kATH53feP+MVqscWYmWfKPJOtVV5QvlxYRUWaqMpf?=
 =?us-ascii?Q?1131oRzhlgW6cEL0kEttFbJY9jUlgdJHm/Kz5oDNG8/iM5RfzQ4boYMq/w75?=
 =?us-ascii?Q?N5X0v1zoS+78WFodnswuDWoWNod/zgCTYbD6SVTL4c7XiqMuvRYtQ6oVnnOy?=
 =?us-ascii?Q?+z0m7XBEzSshLoDwOYi4P5ceSmF4gmEPW/Vt?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:40:13.3300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10458d92-e604-4fd0-940a-08ddecc4cbd7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961

Configure mbm_event mode on AMD platforms. On AMD platforms, it is
recommended to use the mbm_event mode, if supported, to prevent the
hardware from resetting counters between reads. This can result in
misleading values or display "Unavailable" if no counter is assigned
to the event.

Enable mbm_event mode, known as ABMC (Assignable Bandwidth Monitoring
Counters) on AMD, by default if the system supports it.

Update ABMC across all logical processors within the resctrl domain to
ensure proper functionality.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Updated the changelog to imperative mode.

v16: Fixed a minor conflict in arch/x86/kernel/cpu/resctrl/monitor.c.

v15: Minor comment update.

v14: Updated the changelog to reflect the change in name of the monitor mode
     to mbm_event.

v13 : Added the call resctrl_init_evt_configuration() to setup the event
      configuration during init.
      Resolved conflicts caused by the recent FS/ARCH code restructure.

v12: Moved the resctrl_arch_mbm_cntr_assign_set_one to domain_add_cpu_mon().
     Updated the commit log.

v11: Commit text in imperative tone. Added few more details.
     Moved resctrl_arch_mbm_cntr_assign_set_one() to monitor.c.

v10: Commit text in imperative tone.

v9: Minor code change due to merge. Actual code did not change.

v8: Renamed resctrl_arch_mbm_cntr_assign_configure to
        resctrl_arch_mbm_cntr_assign_set_one.
    Adde r->mon_capable check.
    Commit message update.

v7: Introduced resctrl_arch_mbm_cntr_assign_configure() to configure.
    Moved the default settings to rdt_get_mon_l3_config(). It should be
    done before the hotplug handler is called. It cannot be done at
    rdtgroup_init().

v6: Keeping the default enablement in arch init code for now.
     This may need some discussion.
     Renamed resctrl_arch_configure_abmc to resctrl_arch_mbm_cntr_assign_configure.

v5: New patch to enable ABMC by default.
---
 arch/x86/kernel/cpu/resctrl/core.c     | 7 +++++++
 arch/x86/kernel/cpu/resctrl/internal.h | 1 +
 arch/x86/kernel/cpu/resctrl/monitor.c  | 8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2e68aa02ad3f..06ca5a30140c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -520,6 +520,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
 
 		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
+		/* Update the mbm_assign_mode state for the CPU if supported */
+		if (r->mon.mbm_cntr_assignable)
+			resctrl_arch_mbm_cntr_assign_set_one(r);
 		return;
 	}
 
@@ -539,6 +542,10 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d->ci_id = ci->id;
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
+	/* Update the mbm_assign_mode state for the CPU if supported */
+	if (r->mon.mbm_cntr_assignable)
+		resctrl_arch_mbm_cntr_assign_set_one(r);
+
 	arch_mon_domain_online(r, d);
 
 	if (arch_domain_mbm_alloc(r->mon.num_rmid, hw_dom)) {
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index ae4003d44df4..ee81c2d3f058 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -215,5 +215,6 @@ bool rdt_cpu_has(int flag);
 void __init intel_rdt_mbm_apply_quirk(void);
 
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
+void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 0b3c199e9e01..c8945610d455 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -456,6 +456,7 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 		r->mon.mbm_cntr_assignable = true;
 		cpuid_count(0x80000020, 5, &eax, &ebx, &ecx, &edx);
 		r->mon.num_mbm_cntrs = (ebx & GENMASK(15, 0)) + 1;
+		hw_res->mbm_cntr_assign_enabled = true;
 	}
 
 	r->mon_capable = true;
@@ -557,3 +558,10 @@ void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
 	if (am)
 		memset(am, 0, sizeof(*am));
 }
+
+void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r)
+{
+	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
+
+	resctrl_abmc_set_one_amd(&hw_res->mbm_cntr_assign_enabled);
+}
-- 
2.34.1



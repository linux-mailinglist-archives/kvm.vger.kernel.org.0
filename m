Return-Path: <kvm+bounces-56917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A45ACB465B2
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91FE85A7AE0
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB982F6587;
	Fri,  5 Sep 2025 21:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q4Qy8PA6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0092D2F6170;
	Fri,  5 Sep 2025 21:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108153; cv=fail; b=H5Vu9iUsOUQmFEDbjwl864TYwdcdt1P78IhAaX2bFiDrvHxbasiBmHvoZaDc4nSgmOh5MLSgpF/JeCzEgJ9F+T9VkkmfuxEZ5tO2JTDkASDSlR8tdOZkx/vfNm4TiNXDRD3EZnohGiZh1U66EBXlCsE01a+Qw33eBmuey4O2x5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108153; c=relaxed/simple;
	bh=BHuMU4Fd5bFOdIDUt9+9LGgw95sLbh57obi4Tg4h+yc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTqWTQo+4E9D0PIU+74S6qL+ZTDafm62LOzhUExcDMwmVZ1rbIGhZXEfksK1oDPGqod5AZqsVzMpq4x+Nx/hNYm4vkEFAEj9omoUwCU/0cQCyQXvwkoTbefZwhwnYd68y1ug2q0hJuYE+4z3Ezab0sC4gbKJiO8GD1p6Xo+xHy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q4Qy8PA6; arc=fail smtp.client-ip=40.107.236.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mt+iqGKGW8oVYjNvzx9dacg6i9RP0tf+0WI3GQxTH774kSZH6LSV9oqhozSPS42ddATqqemCLuPyFLCbE29Rfv87KwK1nt3cIjo+YB3wrJN9atLR3HpuqRu+nfr4BQxTvEWBi0ZDuKNYHJ+AQASn25YdNAvng3bNZS+DtjxA56FPRjCv0iLU9AcZe/chzvveU5jI4w/+bh8rTruzwbS/j9Yrgv3jlzSpXCjGr/eI+skU3rUA2n11lpOMXC7A5Bi0kAtfy0N8S1pvnY8RMFSldBeRoyaB0BQu1ELSZR5k2jEQMgv5qzFbTSf+C6OmK3dwNDZN5qWsJW0JWi+hQS4zpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c36IUuuCgjPQP2sddU/1Tg4TWxHXfSbLxe0ZQM1//to=;
 b=R5YcI9r4EEASqK7pPoZn4Mopy4N5noANeukuuZelSn7fHUHVOLBDblyTK0I9Nb3/hMUWmMuK8tXzSshntOTMi87AfmptG9UlErJJkhX3L8idpyVhPw3jM9Jk8wr0edJeaKcs2AOulMnFqWK0Bdj5Kxhub+EKp3g9L1err3NqPGFJjA3k+tZDq+kFa5bO+492bDq6VOyCyfS12RW7uHpXt5mhirTOiHo9FIPa78kaKLbSlyNvu53ZuuVERoWTfJmRFIPi/GXegxNe+n/r/VsnLqi+S2YbJxK6SOAh5NOFO0oRlsdLKj5zx4fd3NzdO/GFIulvpK0GKPsm5JOduzkNcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c36IUuuCgjPQP2sddU/1Tg4TWxHXfSbLxe0ZQM1//to=;
 b=q4Qy8PA6qWJwgtsmbV6jDE6uUVowGmeUIZYan4kJXFlq1oWbu4tb7vD4ens8zEjg6ZUiHTNUV+GKlItBWw+WyiveBrsvb5VcmzeJhLD4A1jg6dl0LmtpO8OZmC6GW1wAIyd7KWnWx1Q02SLXwpAgbcIu9SNAB9AJKuOCHuGnbiM=
Received: from BY1P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::16)
 by LV8PR12MB9083.namprd12.prod.outlook.com (2603:10b6:408:18c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 21:35:42 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::d8) by BY1P220CA0021.outlook.office365.com
 (2603:10b6:a03:5c3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Fri,
 5 Sep 2025 21:35:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:35:41 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:35:40 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:35:38 -0700
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
Subject: [PATCH v18 05/33] x86/cpufeatures: Add support for Assignable Bandwidth Monitoring Counters (ABMC)
Date: Fri, 5 Sep 2025 16:34:04 -0500
Message-ID: <08c0ad5eb21ab2b9a4378f43e59a095572e468d0.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|LV8PR12MB9083:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca46091-11c9-4932-b49e-08ddecc429c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0mlHd6RBpdy8kB7mE9aLvXZsIJQrsnRJItNcnK/kq1o4f5P2HmY+iRTVpuCQ?=
 =?us-ascii?Q?1nabBF14PqKJ2Kxh8aIN3pHE0dEKJjr9MBEWCUytTG0wYfMXfKj/+o3g1CkE?=
 =?us-ascii?Q?K0mOsy9vE+obVwcYxSTvNcAJFvaMNjqbM0ecZudDS7cv2/uiHauUHX4mRLno?=
 =?us-ascii?Q?r43EWtobtyNAr+sDfR6520ZTvY79O/oQ4sqWvIQikcn4JqHKbu6Bdf1rNcOw?=
 =?us-ascii?Q?6cyXIfPt21iVM0bPRETW+jBUGJGi4BN4qJU4DkpIGh44PMqJYbDNfCyFoaKH?=
 =?us-ascii?Q?OEQXwOSjQqMFiA7foiaxVt9/wiSqINLfcqS5hiIIu8+Z3k2zPgTxyUR8DHUS?=
 =?us-ascii?Q?yTR0dYgC9K7ZwYlWHzy4q7E/MPZ54f+uoMLrY5qpkTPPlpc+YusKICPDtUXp?=
 =?us-ascii?Q?vWXlQ2V+8KmMqElasPLdAEVxUi6Z0aLe4c0JrY0aXZnsf3RvvWlj1V/6frYj?=
 =?us-ascii?Q?R4rBjCSL4b7O1c38e/BArKOjEoCvPk5RoDf2WNneaD8Vn4XajpuKjZbNrIdJ?=
 =?us-ascii?Q?45LV919W1mxqC+mK1qseKjQq67i21k4hzFNJMq9QsgLLo1JZtsVdYttPIeYY?=
 =?us-ascii?Q?w5qy+Kz+EpettFdjRCh2NRNFyDzwrkcmd9Y1d9rAAsXxtNZQpT+1Tt7UThQ3?=
 =?us-ascii?Q?UPVymg/uaAYQjhDaYoRey192sY35lkXwALN/up4G/Nczo0rJZrR2HCRbSC85?=
 =?us-ascii?Q?zqTaZc6sri85Ag9gCM+Pit4HrH+/bxxDrE9fVzhyMz2vktqw/sP1IKX21HvS?=
 =?us-ascii?Q?aYuVTBdT41/Qi+/U2jINTcZGsZeyBu+2w+b8UI66ab4+URHSMRn/Vt+aZ/9V?=
 =?us-ascii?Q?erW968ZR4/5W4hWw+46X/kMQs3qrfMDUjapRL8ouyYC3OdkRCgqcfeS8P6MP?=
 =?us-ascii?Q?lRVxILlD0UFrr4iqwovdjUfw7MDPZYSO/hm0csi0ec1kKEctQBhzD0v7c6eZ?=
 =?us-ascii?Q?8aeZZDJFLizTUtWLAdB583EyLr/snyi4qUnlKmFQFUEYM3mVEIsYyzvtFFXJ?=
 =?us-ascii?Q?+9Hrstgy9noC9zA/ARezyqaGjyJ7lv6gThvOfIuOVcDm/ckczJfUttEouL1z?=
 =?us-ascii?Q?dXHcoaR6ont9B9nGYpSuQVtDTguBydXQYN+jTDZELs5jEdxS1QYVQzQCYX7g?=
 =?us-ascii?Q?MziqxMuu0t0t/U0kyDC6TJZ8pVDyiLf39E6fV+3Be7Z5Bsz0a5sMYetWZpbG?=
 =?us-ascii?Q?4Bnn5OSiprVz8zuQsAuoMSq1gtPBO9Wi74ZqYvuQbK+EYFacA/2lV17uK01C?=
 =?us-ascii?Q?L12yGUbuss6ADXchitSKjrCQ/jbddB3tbwvSTZJnNDPTRCkLKQquG/0435ln?=
 =?us-ascii?Q?ndUFEoQxlIW2TZ9nyX9cFLVPStDCOfHsESbc5Ak3TSN/URHSIbOE4AZWcWFs?=
 =?us-ascii?Q?lrr1EwO4OKBXrQJcKJZNWLrlUrBEx7lxswegyIprhCyeFv91yc/xEpljvw0W?=
 =?us-ascii?Q?7RgTHRphsCo/lomnbZl0OgJbYt2HtFsJHkHCNjIBT6BZgbNzi+k0+M5SCpFo?=
 =?us-ascii?Q?4GmMIz+OkfxwYmo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:35:41.3635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca46091-11c9-4932-b49e-08ddecc429c4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9083

Users can create as many monitor groups as RMIDs supported by the hardware.
However, bandwidth monitoring feature on AMD system only guarantees that
RMIDs currently assigned to a processor will be tracked by hardware. The
counters of any other RMIDs which are no longer being tracked will be reset
to zero. The MBM event counters return "Unavailable" for the RMIDs that are
not tracked by hardware. So, there can be only limited number of groups
that can give guaranteed monitoring numbers. With ever changing
configurations there is no way to definitely know which of these groups are
being tracked during a particular time. Users do not have the option to
monitor a group or set of groups for a certain period of time without
worrying about RMID being reset in between.

The ABMC feature allows users to assign a hardware counter to an RMID,
event pair and monitor bandwidth usage as long as it is assigned. The
hardware continues to track the assigned counter until it is explicitly
unassigned by the user. There is no need to worry about counters being
reset during this period. Additionally, the user can specify the type of
memory transactions (e.g., reads, writes) for the counter to track.

Without ABMC enabled, monitoring will work in current mode without
assignment option.

The Linux resctrl subsystem provides an interface that allows monitoring of
up to two memory bandwidth events per group, selected from a combination of
available total and local events. When ABMC is enabled, two events will be
assigned to each group by default, in line with the current interface
design. Users will also have the option to configure which types of memory
transactions are counted by these events.

Due to the limited number of available counters (32), users may quickly
exhaust the available counters. If the system runs out of assignable ABMC
counters, the kernel will report an error. In such cases, users will need
to unassign one or more active counters to free up counters for new
assignments. resctrl will provide options to assign or unassign events
through the group-specific interface file.

The feature is detected via CPUID_Fn80000020_EBX_x00 bit 5.
Bits Description
5    ABMC (Assignable Bandwidth Monitoring Counters)

The ABMC feature details are documented in APM [1] available from [2].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41 section 19.3.3.3 Assignable Bandwidth
Monitoring (ABMC).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
Note: Checkpatch checks/warnings are ignored to maintain coding style.

v18: No code changes. Updated text about Link.

v17: Added Reviewed-by tag.

v16: Fixed the conflicts with latest cpufeatures.h and scattered.c files.

v15: Minor changelog update.

v14: Removed the dependancy on X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL.
     as discussed in https://lore.kernel.org/lkml/5f8b21c6-5166-46a6-be14-0c7c9bfb7cde@intel.com/
     Need to re-work on ABMC enumeration during the init.
     Updated changelog with few text update.

v13: Updated the commit log with Linux interface details.

v12: Removed the dependancy on X86_FEATURE_BMEC.
     Removed the Reviewed-by tag as patch has changed.

v11: No changes.

v10: No changes.

v9: Took care of couple of minor merge conflicts. No other changes.

v8: No changes.

v7: Removed "" from feature flags. Not required anymore.
    https://lore.kernel.org/lkml/20240817145058.GCZsC40neU4wkPXeVR@fat_crate.local/

v6: Added Reinette's Reviewed-by. Moved the Checkpatch note below ---.

v5: Minor rebase change and subject line update.

v4: Changes because of rebase. Feature word 21 has few more additions now.
    Changed the text to "tracked by hardware" instead of active.

v3: Change because of rebase. Actual patch did not change.

v2: Added dependency on X86_FEATURE_BMEC.
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 06fc0479a23f..9a3bbd61f885 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -495,6 +495,7 @@
 #define X86_FEATURE_TSA_SQ_NO		(21*32+11) /* AMD CPU not vulnerable to TSA-SQ */
 #define X86_FEATURE_TSA_L1_NO		(21*32+12) /* AMD CPU not vulnerable to TSA-L1 */
 #define X86_FEATURE_CLEAR_CPU_BUF_VM	(21*32+13) /* Clear CPU buffers using VERW before VMRUN */
+#define X86_FEATURE_ABMC		(21*32+14) /* Assignable Bandwidth Monitoring Counters */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 6b868afb26c3..4cee6213d667 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -51,6 +51,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_COHERENCY_SFW_NO,		CPUID_EBX, 31, 0x8000001f, 0 },
 	{ X86_FEATURE_SMBA,			CPUID_EBX,  2, 0x80000020, 0 },
 	{ X86_FEATURE_BMEC,			CPUID_EBX,  3, 0x80000020, 0 },
+	{ X86_FEATURE_ABMC,			CPUID_EBX,  5, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },
 	{ X86_FEATURE_TSA_L1_NO,		CPUID_ECX,  2, 0x80000021, 0 },
 	{ X86_FEATURE_AMD_WORKLOAD_CLASS,	CPUID_EAX, 22, 0x80000021, 0 },
-- 
2.34.1



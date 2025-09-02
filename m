Return-Path: <kvm+bounces-56641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 915BEB4102A
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88E9D5E64C6
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D044B27A461;
	Tue,  2 Sep 2025 22:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z7c8orw6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6D3277CA4;
	Tue,  2 Sep 2025 22:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852943; cv=fail; b=jEXTsgDKqFNJRkFWuT0dKTC6o2BLpWDA/CaZrO/LOUp9Ft4cQiCbb+RYO6Yuw4A6B+xVUmtp9Je4sv77xV2ZvfKH3PhXKiZ19somEsHuVyGdo42ISipnN0i3Twzv26hejAqUxHWjjaEuwW3qncwnWLeZ/N9qFSIYHXs7qS7K3WI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852943; c=relaxed/simple;
	bh=twyfaqZr2vAgFWDrhK+twKv9qO7OM3ypyZTEM9h/dmY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=blKFGhISDd/sJt7q3M5f2nkieZrXHS+KuyMxBUaVKHCIytBlemzRNu5KenSuDJLfr8dnbmv1T7ujET0heRIZzXJjPc069LyUSSFmzECYj/Iy8UFU9xgca1tVNfGGwA4NEwTN8zixvjsgewztf4V/o4t/I01rbJ0kZ0SqIzS0Gv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z7c8orw6; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zu7OcCdRQngWRiXDY8m273C4Z+BmjkMmcTKSQnPNrnNesvXxg5GeFAy3PCyGYz8/c5aSn7RGHZ8PZBs6RyoRCUllFqG5z2K5TICFxJJeQxo/sT7oLHrMd+6IyuRuetSU/yx48rBn1Av0s+0Las2kS7J3HwWapNlhp3be5BRgJifxofR25S9j7gnLiSv7djThGGXGMpir0sECj4UeAQYbuXM+iJ1rlJ5cPzBqEEnHD9AmdCa9F7lG9+WBF6vq429Reu8G+ahL1MsswAfofK0pvTBFbQmQHeavdKTpA93TgkItg1ZI1nxHK2zw7O+C6mSIljQenbLs5jN0g5MoW3r1Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+PkaAoAV6w+3MBZ6FI0hT2ht1A+zN7S/Up9M4AIRWbE=;
 b=Ao1V60tDmilGJomiD6CRaWKlsqtHYWLJBIyrbjYp5lcbiAyev4vuzt3sWiOX3zQ3KHkEEffvZP2W/LvjGZvuFxjykdh62ZpJNebQ//u7ijbyDxyiz4QA8UF2rJZJ0L750ndMLCqHOZQ3LJj7zYsZwZ547GJTd5xBKHvLnyHn6gWbT6t8+gzVoRHR2rY351kEiCP4we2U1gIGzjCzdINndgoewfvcgS+5Ri2CmKpbyQOucuDdZsLZo1Tru5ZaW/ZsvXyna2lTcdfvvfLvXXrlxJBzg+1qhvj5WpnKpg4JFnodKZsWt+AhK0JvvyuJ0oXO1SopLVSkEUXU/2NehK6mCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PkaAoAV6w+3MBZ6FI0hT2ht1A+zN7S/Up9M4AIRWbE=;
 b=z7c8orw6wcvIoARRDJovMZXMT0Pan4+K39xCkJG66WXD/z6hJ8YL/j3Ko6preRFL5OT1ew5YfKYkRAAm3ar7A+hG38OgTLs9xKe+Jt82qJcf1xUowDB52GJLc5c30iCHC8T3BiqhjWNbBQ65itiv9fkAEH8BaQGOnE7O51FJtb4=
Received: from SJ0PR05CA0014.namprd05.prod.outlook.com (2603:10b6:a03:33b::19)
 by SJ1PR12MB6098.namprd12.prod.outlook.com (2603:10b6:a03:45f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Tue, 2 Sep
 2025 22:42:09 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:33b:cafe::6e) by SJ0PR05CA0014.outlook.office365.com
 (2603:10b6:a03:33b::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.15 via Frontend Transport; Tue,
 2 Sep 2025 22:42:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:42:09 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:42:06 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:42:04 -0700
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<babu.moger@amd.com>, <dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
Subject: [PATCH v9 03/10] x86,fs/resctrl: Detect io_alloc feature
Date: Tue, 2 Sep 2025 17:41:25 -0500
Message-ID: <c9c594dddd02b53498a184db0fda4377bcef5e89.1756851697.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1756851697.git.babu.moger@amd.com>
References: <cover.1756851697.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|SJ1PR12MB6098:EE_
X-MS-Office365-Filtering-Correlation-Id: d32e8ea5-7444-4f40-28f1-08ddea71f3a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nzsgc42g7HzIWChS8DzAbN9iVlRCKBJ2bw6nMYz2zPVxTRr4UG4d5+Z5XTP4?=
 =?us-ascii?Q?m8jehSmzPLmuTjq/wJZdI0KiAX6ppA96u+o+iMmWh1F3R/VI6FsUXAMklNF6?=
 =?us-ascii?Q?JobkJH/2ZqE1E0OhHwAyVMIuApaP+RfSPSDnHGvDrCcte/8+usZ2+0b7PIP2?=
 =?us-ascii?Q?Z47vy6m7WdGFExXfWnc2Ou6KupXQnpXCp12cfVMwbPkcsYYhrm8NkMvInvgJ?=
 =?us-ascii?Q?ANv8EJ/KicPAfqAmu7inXoOFkmZUEsgsOhqmZQ7ozImfYQ0N1G+z7DUj7+L5?=
 =?us-ascii?Q?XH9fBy7DXxIf4OwNhPZBy9EW1B3Du6SVaXsI/cJfB/tLZkD7I3/ui5rju0G8?=
 =?us-ascii?Q?sDN2EmLNmmei+Hd5h13Bi0QyDAUbz8u50+G3N2P3lTvsEA/siqGrTGCEZWW4?=
 =?us-ascii?Q?MTlw43P2sLm/zYkrHoYorAqNvFbgbJEWv4WoxUb4ON1qMeKNxozbKRjMcxT7?=
 =?us-ascii?Q?GrMHOss2VXXKeOgsgAM3WLC22q0d+w6QKMY5i528JcVXsfxLlCTO4lKKcFB8?=
 =?us-ascii?Q?NF59fulP63rVjXKimnsFT0qci99QaFhM/zHAuxAY8KcUgU5cGedGf0PxKWEv?=
 =?us-ascii?Q?wV4II+1rZLI0I2yzEv/71bhMWC6N7arvkGcwEEMr0Q/gVK1fbyMV1ehcOAdE?=
 =?us-ascii?Q?puFagocpp3bounwtzdZoEHGrQPc14GwXJQ8F0X7XFKoNcBgClqpiGS+HElCO?=
 =?us-ascii?Q?eWRl9qwUk8aPRFhOsWYHityHZeY7SNgvc7lJtop5saBrm0WjujmryO52fHlx?=
 =?us-ascii?Q?dflMoZLVqp/P+ntB3kK/2n3U2XIPlHnc3BHWz7bQf8JGbfV/9zoSpkBhO1gl?=
 =?us-ascii?Q?j147ToV2mcX0+FuXPdv1+3Jb1xAiaNIqexKJAX5df7wCWtykYbhPZURumnNz?=
 =?us-ascii?Q?KmexKTWPvEAAyVF3mQPs4xrYMa/HSTvogoG7UgwhM3tKEDKxFA1rXq31oJ3s?=
 =?us-ascii?Q?mKcLTZ3QMK9W4UmG0tB9CK74xQSIWLMxwIH+vctJ0KrSFUUwIB48vVZexXn4?=
 =?us-ascii?Q?8mc8sAEZJKTviiMnbifF9ZGB9VN/AKwfRTWWRbUUQHtKW9OaFoYPrt/XqvhP?=
 =?us-ascii?Q?Iv3eigZKH808+Fz6waV4P9qNY9vLj5QtrV7Dr6Nud8T4buqASSjoX0tlKzIa?=
 =?us-ascii?Q?kvsLFY65T+wcCzYesdmcQ2r+iVkfo5pveFj6T3Wh5v8hWLsWgaJ/Q873/HxY?=
 =?us-ascii?Q?6OO5zFDLjc8pP2eN/gWdMYgOr3ingyYdmRWkumz7KC8E31pCISdUjhEWJZWh?=
 =?us-ascii?Q?wmHCtTRniWuDsaUytLjU3OuA+ytApnRyjfQP2XlZZmTtu3VE2aq7kcmr1fhd?=
 =?us-ascii?Q?kEFaz7j3LhMySifya2Gd9/p/zzWObKq6MXgIYJLNK7WV4gZWkMjI/eJWd9LH?=
 =?us-ascii?Q?pl4f2Vs6F1M0FOD5S9KiK4dYssOtCA6w/q5SwCxQCKgMQNp2Piqf6jJpZYs1?=
 =?us-ascii?Q?+rzTg55Ro6IabiUkRnIrv+Tsk045nAcZX35MvUiKj+CkpxVrXxfr1egk4Jit?=
 =?us-ascii?Q?NVSd8UcvE0JxvCbmVzz12PddBwdQUnpx+pWs?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:42:09.4925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d32e8ea5-7444-4f40-28f1-08ddea71f3a8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6098

Smart Data Cache Injection (SDCI) is a mechanism that enables direct
insertion of data from I/O devices into the L3 cache. It can reduce the
demands on DRAM bandwidth and reduces latency to the processor consuming
the I/O data.

Introduce cache resource property "io_alloc_capable" that an architecture
can set if a portion of the cache can be allocated for I/O traffic.

Set this property on x86 systems that support SDCIAE (L3 Smart Data Cache
Injection Allocation Enforcement). This property is set only for the L3
cache resource on systems that support SDCIAE.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v9: No changes.

v8: Added Reviewed-by tag.

v7: Few text updates in changelog and resctrl.h.

v6: No changes.

v5: No changes.

v4: Updated the commit message and code comment based on feedback.

v3: Rewrote commit log. Changed the text to bit generic than the AMD specific.
    Renamed the rdt_get_sdciae_alloc_cfg() to rdt_set_io_alloc_capable().
    Removed leftover comment from v2.

v2: Changed sdciae_capable to io_alloc_capable to make it generic feature.
    Also moved the io_alloc_capable in struct resctrl_cache.
---
 arch/x86/kernel/cpu/resctrl/core.c | 7 +++++++
 include/linux/resctrl.h            | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f6d84882cc4e..1d1002526745 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -274,6 +274,11 @@ static void rdt_get_cdp_config(int level)
 	rdt_resources_all[level].r_resctrl.cdp_capable = true;
 }
 
+static void rdt_set_io_alloc_capable(struct rdt_resource *r)
+{
+	r->cache.io_alloc_capable = true;
+}
+
 static void rdt_get_cdp_l3_config(void)
 {
 	rdt_get_cdp_config(RDT_RESOURCE_L3);
@@ -842,6 +847,8 @@ static __init bool get_rdt_alloc_resources(void)
 		rdt_get_cache_alloc_cfg(1, r);
 		if (rdt_cpu_has(X86_FEATURE_CDP_L3))
 			rdt_get_cdp_l3_config();
+		if (rdt_cpu_has(X86_FEATURE_SDCIAE))
+			rdt_set_io_alloc_capable(r);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CAT_L2)) {
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 6fb4894b8cfd..010f238843b2 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -191,6 +191,8 @@ struct rdt_mon_domain {
  * @arch_has_sparse_bitmasks:	True if a bitmask like f00f is valid.
  * @arch_has_per_cpu_cfg:	True if QOS_CFG register for this cache
  *				level has CPU scope.
+ * @io_alloc_capable:	True if portion of the cache can be configured
+ *			for I/O traffic.
  */
 struct resctrl_cache {
 	unsigned int	cbm_len;
@@ -198,6 +200,7 @@ struct resctrl_cache {
 	unsigned int	shareable_bits;
 	bool		arch_has_sparse_bitmasks;
 	bool		arch_has_per_cpu_cfg;
+	bool		io_alloc_capable;
 };
 
 /**
-- 
2.34.1



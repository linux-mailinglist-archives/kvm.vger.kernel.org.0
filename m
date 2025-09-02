Return-Path: <kvm+bounces-56644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 542F9B41033
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F2277A3991
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11AB727CCF2;
	Tue,  2 Sep 2025 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CmGCWm5o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDB3277CB6;
	Tue,  2 Sep 2025 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852961; cv=fail; b=IwufJb3V16kWGaejKAVRTRnF+cO13DztAOGf6GdTcBNgmKp2yXWldRTjk6X9mIMWF9AMqVuEZ1R899PT7n5U20zDN6YOr200WeGZ59MRNtzV8byYEJgBXWobVTCv5himBHGZyX7KuNTN4LtgPxxCRChK0BHmpo2PDC4cO1MFyYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852961; c=relaxed/simple;
	bh=tmaVM5rawqjX8CJS3CCLV1OwqVfT2ByqhgI24AX2Xlk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KqtSiVG7gvvebypRuPRiIzTxKTkHKVL6wDgUYJ2zubw05Qs4+yru+OTQrMRPTfdVI5EjKpDcAqVXwBfKu4CrR7oxDZplI6ZuyuxF2fFDHroCCpHRrj94K5NsLp9YydaRQhOuCDUlZ/3MInqgmjXX/0jw62ZUKOadI+R9NJehbSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CmGCWm5o; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D1QrypmPAvC4Ub7nPQa5kc/w4mtvBOxJMPhpZhhlTefL//nZyGXCxPNlvH/UDxp0aUSrfRZT3P6LO3Na0UYX2trtbDBXqdl5Kl9ZJznZqCw+qgTRfz7xCNIQ5dCYpMUOGcM91EQDIw6rUECuh3ARTV8hd7HGy9gjR0zVwqUpEgJJI1jYApJ+/DdACGTEiStw827aP9YRBDWl6VfngZXlDoYuN0osEbgCUZO+QT/ZMpHQ5MdQgi1CLHQtKXTNk2ta3+rh46PDuvLMBxIAw0WT5UPc24Ivf9rrcjLyfAgs9uu5E2r4fHorGMir7I/+LxYm5tBHOeolsRk0fZmQZvZtMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXkTc4iTYebE37y/4VO2U6bV9I+LAbmPJyj5dOXLUBc=;
 b=FaKTjBcgyudj+uXN2jIi0yvtoxYpS1umiUKad7K0EqfSuGLPtqCpXEKUHUf4rUPVrLaeQNWTjEjUCw6PrlZto2wHbtR56CFHBc/Ks2voTt5RW9fTCGT/i98dnAvOQckruUAD4HByBz/Nf+SpfBYVKY/CmoA7U0xwDBFOc5NDjMbieMflfWvmBLy6y8g7L85Dj8XSPLuQNBPs4yAPulWBYyxzW4Btvbz03k/r26ociatcARc+vblViqtUZIfGUhSZuwHxunj+i/83e4E6zwCewjw7Q8QpVX6L+fABBxvaLIdgB9JXwj2V0J+VN04xcZ6BHcgDOjghH7uO3b4bLlskew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXkTc4iTYebE37y/4VO2U6bV9I+LAbmPJyj5dOXLUBc=;
 b=CmGCWm5oYNK+5jAjvkj0kobxO7WaSubxGFz2RRX8x28MWXFMawTd8px96ZCW3RWsCg53PuuM0GSjsKsTF8lFcghHGMFds+xqOmjjaaghyZu5fmN/+XCIvTM7PcrA8zbPq3qLzaXyLaxhI8fpFFSnsWDFZjPAm9XNqYRmdFVzsVI=
Received: from MW4P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::26)
 by SA3PR12MB9107.namprd12.prod.outlook.com (2603:10b6:806:381::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 22:42:33 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:303:115:cafe::c5) by MW4P220CA0021.outlook.office365.com
 (2603:10b6:303:115::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.25 via Frontend Transport; Tue,
 2 Sep 2025 22:42:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:42:32 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:42:32 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:42:30 -0700
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
Subject: [PATCH v9 06/10] fs/resctrl: Add user interface to enable/disable io_alloc feature
Date: Tue, 2 Sep 2025 17:41:28 -0500
Message-ID: <2cc1e83ba1b232ff9e763111241863672b45d3ea.1756851697.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|SA3PR12MB9107:EE_
X-MS-Office365-Filtering-Correlation-Id: 96ba9f5c-667d-4146-ca23-08ddea720183
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2bWKh0/3Hq0WinQe9Z2V8b/7Wz1WOAN3m06SpWxLTrIC0px7bi2ye88Tty2e?=
 =?us-ascii?Q?WkT2XOucFodsQ3F8POr+H2ccop0sQ1P/AXu9bR2RRMeNeLx4O3+ozqaa+OL4?=
 =?us-ascii?Q?tuJvPCjKcx06PoHSwvsMGP+euiPCYTjB3s8OWWRv8DODFP4jBXhqfjrA2nn+?=
 =?us-ascii?Q?0CTI6Fyyi6XS9Na/kW1gzw37+wifcF3RIv9BaiW+OM+WSftEU2R/g780aQ+0?=
 =?us-ascii?Q?MXJKI2LNwwTmIJcnjSUtllq2Gpj1hfYsY3i85yvh/Cc54SfMQHr+jbMzTFsC?=
 =?us-ascii?Q?4fdma2epC147pBg35sap//V1NWcInpCx57JU2C7A776qvVbMfbqN5MTyiHut?=
 =?us-ascii?Q?gd4TdCBJ/OQsOMIPFEIC1ja83PyhlA4k/sCXtvWtsrvbOwJc6bUVyipRngON?=
 =?us-ascii?Q?ubHNxrKoLKTx3ooY6oP+Ot2cB6N3/UYmJ6kQgaGdQRBp2w6AD5vhmHABVGUQ?=
 =?us-ascii?Q?XkY+ffIEzozcnKJU/jBqJtxDRCumkO9hnFF0ryKnAB7JxWko3KIdbJYX4+dg?=
 =?us-ascii?Q?eea90lm4MLY4g8bdThdwFpDEPz8O4hs152cinuP8DEzKuuRr/9Tfl/0UJ+8l?=
 =?us-ascii?Q?pStcD0KLnC6VO0fWI8d80MX8vXZ0u6G6ifRXfgHoGJf4tAHcJsHX20Y8os6t?=
 =?us-ascii?Q?YkulFqt32DMjb8qhsIN0e6/lYBdC0jzbV7nL7cj1EaOTPE2+mYSeX2lY/DfY?=
 =?us-ascii?Q?UHroDY3aHQQ6pkexIc3GpLyLyS331+M//bHtqefhm3Hv8lQDqXl16u/DKJyn?=
 =?us-ascii?Q?DzW9paTDdWJLMWOUkDWW++ZwBBNID/oW1Hap5GpQoc1YKvMARxUpeXa05qqi?=
 =?us-ascii?Q?wKUSCeLXVGdjKbTQ8VWWHLbRJKXL0pdO9irf1JXKQPGY2qSKiBvLVvdHlU4M?=
 =?us-ascii?Q?lWdd/GIG3hKe8NM0vQfB5ZF1PRuBOaD7Jw5/j4U9oQr0BS+kgpxGu0bP7BxI?=
 =?us-ascii?Q?gPLlgZ0MeeqtBTsOBzskeKxt3hXT0/9NntH/buRn1XJQ+kAWIXkZNSAOLE28?=
 =?us-ascii?Q?GWX2FOd8xzA98FVLxsiEOEeo37S7OhkVFUdGIL5eEAIjjaIaJBDJ2I7EV1bf?=
 =?us-ascii?Q?Lo4/6qc4pCoSSq2DVOucr17hn3YNfeqMd49pGaXlOXRyLVTrQfrv71jLcW0b?=
 =?us-ascii?Q?BmW2yHHztQaoKnFpwYISFD2N++x3O7JFI384eDIqbexH3ZoYk3rIrkmowQ7C?=
 =?us-ascii?Q?18mP8TwyDLMPcWWr7t7oKm7xcyjgSJvOFHqssBY3+QRA8G65LfIxGb9VjeXo?=
 =?us-ascii?Q?uYgu42AxS4rRNpidTBNjQqdQc804t1HUCLjoW1sJ8VaiySsyvahuSK2EHiOV?=
 =?us-ascii?Q?1uJNajQRf2BTG61gdnD3AgYTN5o2xnp5jspAE5cz/L9t75JlU51m0PNTYaOM?=
 =?us-ascii?Q?Y84nmde4D8IDIpzt2vxaHGtqL4bMJlrLbq3iRVtu38Ouckq9pN/yBx6o+XRp?=
 =?us-ascii?Q?h95OPOwNHW6D2ID8rDGCPjchWDPG7uaXd+oNBG60zR1ha67DWZKAmA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:42:32.7710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ba9f5c-667d-4146-ca23-08ddea720183
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9107

"io_alloc" feature in resctrl enables direct insertion of data from I/O
devices into the cache.

On AMD systems, when io_alloc is enabled, the highest CLOSID is reserved
exclusively for I/O allocation traffic and is no longer available for
general CPU cache allocation. Users are encouraged to enable it only when
running workloads that can benefit from this functionality.

Since CLOSIDs are managed by resctrl fs, it is least invasive to make the
"io_alloc is supported by maximum supported CLOSID" part of the initial
resctrl fs support for io_alloc. Take care not to expose this use of CLOSID
for io_alloc to user space so that this is not required from other
architectures that may support io_alloc differently in the future.

Introduce user interface to enable/disable io_alloc feature. Check to
verify the availability of CLOSID reserved for io_alloc, and initialize
the CLOSID with a usable CBMs across all the domains.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v9: Updated the changelog.
    Moved resctrl_arch_get_io_alloc_enabled() check earlier in the
    Removed resctrl_get_schema().
    Copied staged_config from peer when CDP is enabled.

v8: Updated the changelog.
    Renamed resctrl_io_alloc_init_cat() to resctrl_io_alloc_init_cbm().
    Moved resctrl_io_alloc_write() and all its dependancies to fs/resctrl/ctrlmondata.c.
    Added prototypes for all the functions in fs/resctrl/internal.h.

v7: Separated resctrl_io_alloc_show and bit_usage changes in two separate
    patches.
    Added resctrl_io_alloc_closid_supported() to verify io_alloc CLOSID.
    Initialized the schema for both CDP_DATA and CDP_CODE when CDP is enabled.

v6: Changed the subject to fs/resctrl:

v5: Resolved conflicts due to recent resctrl FS/ARCH code restructure.
    Used rdt_kn_name to get the rdtgroup name instead of accesssing it directly
    while printing group name used by the io_alloc_closid.

    Updated bit_usage to reflect the io_alloc CBM as discussed in the thread:
    https://lore.kernel.org/lkml/3ca0a5dc-ad9c-4767-9011-b79d986e1e8d@intel.com/
    Modified rdt_bit_usage_show() to read io_alloc_cbm in hw_shareable, ensuring
    that bit_usage accurately represents the CBMs.

    Updated the code to modify io_alloc either with L3CODE or L3DATA.
    https://lore.kernel.org/lkml/c00c00ea-a9ac-4c56-961c-dc5bf633476b@intel.com/

v4: Updated the change log.
    Updated the user doc.
    The "io_alloc" interface will report "enabled/disabled/not supported".
    Updated resctrl_io_alloc_closid_get() to verify the max closid availability.
    Updated the documentation for "shareable_bits" and "bit_usage".
    Introduced io_alloc_init() to initialize fflags.
    Printed the group name when io_alloc enablement fails.

    NOTE: io_alloc is about specific CLOS. rdt_bit_usage_show() is not designed
    handle bit_usage for specific CLOS. Its about overall system. So, we cannot
    really tell the user which CLOS is shared across both hardware and software.
    We need to discuss this.

v3: Rewrote the change to make it generic.
    Rewrote the documentation in resctrl.rst to be generic and added
    AMD feature details in the end.
    Added the check to verify if MAX CLOSID availability on the system.
    Added CDP check to make sure io_alloc is configured in CDP_CODE.
    Added resctrl_io_alloc_closid_free() to free the io_alloc CLOSID.
    Added errors in few cases when CLOSID allocation fails.
    Fixes splat reported when info/L3/bit_usage is accesed when io_alloc
    is enabled.
    https://lore.kernel.org/lkml/SJ1PR11MB60837B532254E7B23BC27E84FC052@SJ1PR11MB6083.namprd11.prod.outlook.com/

v2: Renamed the feature to "io_alloc".
    Added generic texts for the feature in commit log and resctrl.rst doc.
    Added resctrl_io_alloc_init_cat() to initialize io_alloc to default
    values when enabled.
    Fixed io_alloc show functinality to display only on L3 resource.
---
 Documentation/filesystems/resctrl.rst |   8 ++
 fs/resctrl/ctrlmondata.c              | 122 ++++++++++++++++++++++++++
 fs/resctrl/internal.h                 |  11 +++
 fs/resctrl/rdtgroup.c                 |  24 ++++-
 4 files changed, 162 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 89aab17b00cb..55e35db0c6de 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -151,6 +151,14 @@ related to allocation:
 			"not supported":
 			      Support not available for this resource.
 
+		The feature can be modified by writing to the interface, for example:
+
+		To enable:
+			# echo 1 > /sys/fs/resctrl/info/L3/io_alloc
+
+		To disable:
+			# echo 0 > /sys/fs/resctrl/info/L3/io_alloc
+
 		The underlying implementation may reduce resources available to
 		general (CPU) cache allocation. See architecture specific notes
 		below. Depending on usage requirements the feature can be enabled
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index d495a5d5c9d5..1f714301f79f 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -685,3 +685,125 @@ int resctrl_io_alloc_show(struct kernfs_open_file *of, struct seq_file *seq, voi
 
 	return 0;
 }
+
+/*
+ * resctrl_io_alloc_closid_supported() - io_alloc feature utilizes the
+ * highest CLOSID value to direct I/O traffic. Ensure that io_alloc_closid
+ * is in the supported range.
+ */
+static bool resctrl_io_alloc_closid_supported(u32 io_alloc_closid)
+{
+	return io_alloc_closid < closids_supported();
+}
+
+/*
+ * Initialize io_alloc CLOSID cache resource CBM with all usable (shared
+ * and unused) cache portions.
+ */
+static int resctrl_io_alloc_init_cbm(struct resctrl_schema *s, u32 closid)
+{
+	enum resctrl_conf_type peer_type;
+	struct rdt_resource *r = s->res;
+	struct rdt_ctrl_domain *d;
+	int ret;
+
+	rdt_staged_configs_clear();
+
+	ret = rdtgroup_init_cat(s, closid);
+	if (ret < 0)
+		goto out;
+
+	/* Keep CDP_CODE and CDP_DATA of io_alloc CLOSID's CBM in sync. */
+	if (resctrl_arch_get_cdp_enabled(r->rid)) {
+		peer_type = resctrl_peer_type(s->conf_type);
+		list_for_each_entry(d, &s->res->ctrl_domains, hdr.list)
+			memcpy(&d->staged_config[peer_type],
+			       &d->staged_config[s->conf_type],
+			       sizeof(d->staged_config[0]));
+	}
+
+	ret = resctrl_arch_update_domains(r, closid);
+out:
+	rdt_staged_configs_clear();
+	return ret;
+}
+
+/*
+ * resctrl_io_alloc_closid() - io_alloc feature routes I/O traffic using
+ * the highest available CLOSID. Retrieve the maximum CLOSID supported by the
+ * resource. Note that if Code Data Prioritization (CDP) is enabled, the number
+ * of available CLOSIDs is reduced by half.
+ */
+static u32 resctrl_io_alloc_closid(struct rdt_resource *r)
+{
+	if (resctrl_arch_get_cdp_enabled(r->rid))
+		return resctrl_arch_get_num_closid(r) / 2  - 1;
+	else
+		return resctrl_arch_get_num_closid(r) - 1;
+}
+
+ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
+			       size_t nbytes, loff_t off)
+{
+	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
+	struct rdt_resource *r = s->res;
+	char const *grp_name;
+	u32 io_alloc_closid;
+	bool enable;
+	int ret;
+
+	ret = kstrtobool(buf, &enable);
+	if (ret)
+		return ret;
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
+	rdt_last_cmd_clear();
+
+	if (!r->cache.io_alloc_capable) {
+		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	/* If the feature is already up to date, no action is needed. */
+	if (resctrl_arch_get_io_alloc_enabled(r) == enable)
+		goto out_unlock;
+
+	io_alloc_closid = resctrl_io_alloc_closid(r);
+	if (!resctrl_io_alloc_closid_supported(io_alloc_closid)) {
+		rdt_last_cmd_printf("io_alloc CLOSID (ctrl_hw_id) %d is not available\n",
+				    io_alloc_closid);
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (enable) {
+		if (!closid_alloc_fixed(io_alloc_closid)) {
+			grp_name = rdtgroup_name_by_closid(io_alloc_closid);
+			WARN_ON_ONCE(!grp_name);
+			rdt_last_cmd_printf("CLOSID (ctrl_hw_id) %d for io_alloc is used by %s group\n",
+					    io_alloc_closid, grp_name ? grp_name : "another");
+			ret = -ENOSPC;
+			goto out_unlock;
+		}
+
+		ret = resctrl_io_alloc_init_cbm(s, io_alloc_closid);
+		if (ret) {
+			rdt_last_cmd_puts("Failed to initialize io_alloc allocations\n");
+			closid_free(io_alloc_closid);
+			goto out_unlock;
+		}
+	} else {
+		closid_free(io_alloc_closid);
+	}
+
+	ret = resctrl_arch_io_alloc_enable(r, enable);
+
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+
+	return ret ?: nbytes;
+}
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 1a4543c2b988..335def7af1f6 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -373,6 +373,8 @@ void rdt_staged_configs_clear(void);
 
 bool closid_allocated(unsigned int closid);
 
+bool closid_alloc_fixed(u32 closid);
+
 int resctrl_find_cleanest_closid(void);
 
 int resctrl_io_alloc_show(struct kernfs_open_file *of, struct seq_file *seq,
@@ -380,6 +382,15 @@ int resctrl_io_alloc_show(struct kernfs_open_file *of, struct seq_file *seq,
 
 void *rdt_kn_parent_priv(struct kernfs_node *kn);
 
+int rdtgroup_init_cat(struct resctrl_schema *s, u32 closid);
+
+enum resctrl_conf_type resctrl_peer_type(enum resctrl_conf_type my_type);
+
+ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
+			       size_t nbytes, loff_t off);
+
+const char *rdtgroup_name_by_closid(int closid);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 41ce2be4b2cb..ebf56782ed63 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -232,6 +232,11 @@ bool closid_allocated(unsigned int closid)
 	return !test_bit(closid, closid_free_map);
 }
 
+bool closid_alloc_fixed(u32 closid)
+{
+	return __test_and_clear_bit(closid, closid_free_map);
+}
+
 /**
  * rdtgroup_mode_by_closid - Return mode of resource group with closid
  * @closid: closid if the resource group
@@ -1250,7 +1255,7 @@ static int rdtgroup_mode_show(struct kernfs_open_file *of,
 	return 0;
 }
 
-static enum resctrl_conf_type resctrl_peer_type(enum resctrl_conf_type my_type)
+enum resctrl_conf_type resctrl_peer_type(enum resctrl_conf_type my_type)
 {
 	switch (my_type) {
 	case CDP_CODE:
@@ -1803,6 +1808,18 @@ static ssize_t mbm_local_bytes_config_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
+const char *rdtgroup_name_by_closid(int closid)
+{
+	struct rdtgroup *rdtgrp;
+
+	list_for_each_entry(rdtgrp, &rdt_all_groups, rdtgroup_list) {
+		if (rdtgrp->closid == closid)
+			return rdt_kn_name(rdtgrp->kn);
+	}
+
+	return NULL;
+}
+
 /* rdtgroup information files for one cache resource. */
 static struct rftype res_common_files[] = {
 	{
@@ -1895,9 +1912,10 @@ static struct rftype res_common_files[] = {
 	},
 	{
 		.name		= "io_alloc",
-		.mode		= 0444,
+		.mode		= 0644,
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.seq_show	= resctrl_io_alloc_show,
+		.write          = resctrl_io_alloc_write,
 	},
 	{
 		.name		= "max_threshold_occupancy",
@@ -3362,7 +3380,7 @@ static int __init_one_rdt_domain(struct rdt_ctrl_domain *d, struct resctrl_schem
  * If there are no more shareable bits available on any domain then
  * the entire allocation will fail.
  */
-static int rdtgroup_init_cat(struct resctrl_schema *s, u32 closid)
+int rdtgroup_init_cat(struct resctrl_schema *s, u32 closid)
 {
 	struct rdt_ctrl_domain *d;
 	int ret;
-- 
2.34.1



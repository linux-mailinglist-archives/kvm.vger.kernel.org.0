Return-Path: <kvm+bounces-56647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B010B4103C
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:44:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 728A2172A1C
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61712EA470;
	Tue,  2 Sep 2025 22:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XXIZQnOl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBC827A135;
	Tue,  2 Sep 2025 22:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852984; cv=fail; b=k1u/lZ/3YK/Fv1JGZJ1Du8LAiAFwmoRV9JWof/smWROFoSGPUKy+KtOjZUKOkd6dg5AARUbKXzzZ2wmJJU7KScEkcmQeRiw04jG+wS4JtIJlMx0iHBT3dNhhQhY+zznyrLUaYvPAZOeOMC4ihoGR2wwWI/zRw+eVF2Jg2LV10Zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852984; c=relaxed/simple;
	bh=J2eXSnjLIySn9SuQb2RutG84feFlOQfiJ9dJ8PJYAxc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2wNN6kGMHe8d+fBvDJXj2mSIPEKogoNXVW17wuorOUxQpCRn88f2H+yMBhmXePu5faw1Bu389eN6aDz5tffGMzfYcy9Mu8zzyZtVi6LImDkBQ/P1l3p19OqwATGvATtBMd010HoIx/FLe9L5ATBseKnjDRX+y8zbGXeYnp9eNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XXIZQnOl; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xjr58SbU3kN4A00WA67Shb0ixJRFiHsUNgSzMWpcREGiapcagPNd7mJddV7wY0Zt61n3MW7GuCuZ8sqY9KOMCHjn2EZ801X7Nau/bAJ4g7xKjiLtFYRydSEU1ocUG+cKpCGhRlTz3UBEl9erD/3jfWCXsOXgvu6wOKQUFKkQo0ObnCygXArkzqJw127kqT48fa9YUV4WJ1rH3jNPXPiscsvmgsrZQauiqvW05AnCeZlxL6DvYBNXEIppRnC7L4iH6dikXVbOhGdui6AMXcxPUJIslXDbg2Ng3scB1ITdLMOyqIPOVBqOLzE76XzMxJQgvHS15WaVqfEWH2C1jrOy5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0CVHBh5bue446ld7nzzW5m+mjaAPDQj42iRiJF2UmA=;
 b=aLSqWjrSD10990nWVWYiCReMtFbD/syJErX0JPRepsdi8z22D5p4mgTxecEvNnqRSPsEVY5jkJMPsk3LysU/yYFBpgRQFRzJeMJERlh5981IqM9KGAKZzPugxI3TNPs0n/jTUMlsfyBoIk9t4UQ8zbXLUl09dpZOUfb6NbhfrWENNSEaNLKmf9YGpokC0q5te0pPqfXgl+pmhOpkeAxZiQ65eH88bD378qUdBxgwW1WKi6SxCSXZQl9g8B6n3mSUJ3X3+Qtp7YSUoqKLpbVfRqsyyasMPUlaL5mRtD/kx+T0gk2c8gKa9OCblYODLVZw+7h1JHbHZV8nBdn8B0Jnzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0CVHBh5bue446ld7nzzW5m+mjaAPDQj42iRiJF2UmA=;
 b=XXIZQnOl/WuIRGXZpd70KezHI0J2nLIDLAab9CGhDUyIehuLvZwppZ2s+7oJJUkkzmlV6+amabWXRtTrv8y282yAYtIfTtwxy/iznoa8PKiwqHfTswkteFEW8ua7JP4GLXAnIsAud9o/olKbu6nASCF3t50jVJTF8DmQeSRGIj8=
Received: from BN9PR03CA0095.namprd03.prod.outlook.com (2603:10b6:408:fd::10)
 by BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 22:42:59 +0000
Received: from BN2PEPF00004FBF.namprd04.prod.outlook.com
 (2603:10b6:408:fd:cafe::a6) by BN9PR03CA0095.outlook.office365.com
 (2603:10b6:408:fd::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Tue,
 2 Sep 2025 22:42:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBF.mail.protection.outlook.com (10.167.243.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:42:58 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:42:57 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:42:56 -0700
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
Subject: [PATCH v9 09/10] fs/resctrl: Introduce interface to modify io_alloc Capacity Bit Masks
Date: Tue, 2 Sep 2025 17:41:31 -0500
Message-ID: <ef9e7effe30f292109ecedb49c2d8209a8020cd0.1756851697.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBF:EE_|BY5PR12MB4116:EE_
X-MS-Office365-Filtering-Correlation-Id: ae0aa2dd-0a3a-4468-005a-08ddea72109e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ggjMkiKFJSlqD5oTq901TKaQgw/Sd+vYlu/PTQU/SD4n2H61nNaWZ7ga9up4?=
 =?us-ascii?Q?XOWG/NSr3VJx2VDt9xZOLkLwP68LJs4wqFtPXB/08lfpLIRRYSpkyrqMgn03?=
 =?us-ascii?Q?NWfpdbQAOyMnK78Y8bAiW6ST77VNYF/kw85QnhPG/fLNamlMf+/b2JSAuIHo?=
 =?us-ascii?Q?YipX1tYcKJT/6NyH9QTn+OmLrW0MeICd2MPWf8thuOBd35X3XH5KApHcDnRD?=
 =?us-ascii?Q?fdwuHhykJ2G5VE3cMo1+M2adrXMwhLMnNMKdlepOfCH8Wg9l6BLqyh6TlTvt?=
 =?us-ascii?Q?1rq7snhRQJkm9PHnnDuvoquf26migBuB3W+JXZn9QiBGB7iNPqF/VlUHKffJ?=
 =?us-ascii?Q?JcurXvsIhnhgCX/SIo5ME1FQ43cUUXvvzFAZaBQPiOX1u1V23NQBrXtMvnqL?=
 =?us-ascii?Q?UNV8aA9Qbj2xknxgytVIXxQPTwcoFlLL8F0efEINiptpQOygAhjx5zmF+J8T?=
 =?us-ascii?Q?HCuVAEgQMgq287WAilQwz/XrOAKm9g9shlAD0l+TheCkLa42mr4ba2tBmjUD?=
 =?us-ascii?Q?Gfrq8WJUZ62FRJdACI2KcwHF+pFZMlGt+vne6CAYOQ0GptChL23qbP6Q4/yD?=
 =?us-ascii?Q?pibT76UL0Gl4b1r75oBH1YQko3M4kpuzxpEYYAa77mgRjoLhV/B1LbRYVvzO?=
 =?us-ascii?Q?LYg+s9BxXgFAlbS3deHWtBqluNKfhKw3cXBnwK0N/a0T8c3qN3oc9iS/5sgH?=
 =?us-ascii?Q?tlv/WMgSdMqUcAt3NNomgnrvO+puD9t++OkhuE4v8NRMLAkF2QNICRnu44Ad?=
 =?us-ascii?Q?NQRnVPTgVPDvPHE8f/uOqM80MZsO7fyHYPayc9/3iDSkXvg9asDSDLkdUEFG?=
 =?us-ascii?Q?QTKjYMQeii73ANLVmwsGtQUv0mtCfHtnYixu2DI1YWucxvMJk8I6DDZFVDyv?=
 =?us-ascii?Q?2t4WfSJjcMPsAYnbdfWKCFYNBg8e5Rm04k8nkKpJY2O3tpZRQWicc7+legXq?=
 =?us-ascii?Q?AOEwopTWtIfArjU7CbCOByHkWo1zc+s01YadBzqJl7TJgU/82Mmq//UbtGAz?=
 =?us-ascii?Q?eZwoVI1hqIQL1M4NtDXDXEJYqaV0E/OA1w8hY/x6852+n4jF34nUAi9qWOHy?=
 =?us-ascii?Q?5rrb43nzJhKK9ZdH0uBAAfdGI1TjcWFD+765XW5aypJc6NdXgwVSizx5NOuE?=
 =?us-ascii?Q?myFagzTiKBSf0XLoMymAkcEeNaNHSdYZBLK22l7uV2uxJsh+e9oEh+ObGWyL?=
 =?us-ascii?Q?Lg8/zeFe6hOEyErVXY70F5xcDB/P2KuGiUKLyUvssrJdzfTxNRhfd0Dy5UFz?=
 =?us-ascii?Q?11rrDZxk7AgRZHtJzc35FDqShUDg3Us4McfFqoTBKwR/b9LuaIbHv1APgmAO?=
 =?us-ascii?Q?dC6n3HGyUIazLrEYFXYxd2EHq8+PUXKYLQNpz3647LVpYxsId5vEbaR451ex?=
 =?us-ascii?Q?ipDi6emmPjiiklSMufllX5uc4+FmqZI1MqdICRX10DHqnX9hiC09YatyqzI0?=
 =?us-ascii?Q?IYxlxp3N3Z0QAVntc3cLmQXBKH+U8hOLAb1A6+kSf4YpiKuUPqAkPnqNuzCN?=
 =?us-ascii?Q?okndTcnCdLnifehhwy9h444PWOMCqnnVYvrQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:42:58.1983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae0aa2dd-0a3a-4468-005a-08ddea72109e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4116

The io_alloc feature in resctrl enables system software to configure the
portion of the cache allocated for I/O traffic. When supported, the
io_alloc_cbm file in resctrl provides access to Capacity Bit Masks (CBMs)
reserved for I/O devices.

Enable users to modify io_alloc CBMs (Capacity Bit Masks) via the
io_alloc_cbm resctrl file when io_alloc is enabled.

To ensure consistent cache allocation when CDP is enabled, the CBMs
written to either L3CODE or L3DATA are mirrored to the other, keeping both
resource types synchronized.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v9: Rewrote the changelog.
    Removed duplicated rdt_last_cmd_clear().
    Corrected rdt_staged_configs_clear() placement.
    Added one more example to update the schemata with multiple domains.
    Copied staged_config from peer when CDP is enabled.

v8: Updated changelog.
    Moved resctrl_io_alloc_parse_line() and resctrl_io_alloc_cbm_write() to
    fs/resctrl/ctrlmondata.c.
    Added resctrl_arch_get_cdp_enabled() check inside resctrl_io_alloc_parse_line().
    Made parse_cbm() static again as everything moved to ctrlmondata.c.

v7: Updated changelog.
    Updated CBMs for both CDP_DATA and CDP_CODE when CDP is enabled.

v6: Updated the user doc restctr.doc for minor texts.
    Changed the subject to fs/resctrl.

v5: Changes due to FS/ARCH code restructure. The files monitor.c/rdtgroup.c
    have been split between FS and ARCH directories.
    Changed the code to access the CBMs via either L3CODE or L3DATA resources.

v4: Removed resctrl_io_alloc_parse_cbm and called parse_cbm() directly.

v3: Minor changes due to changes in resctrl_arch_get_io_alloc_enabled()
    and resctrl_io_alloc_closid_get().
    Taken care of handling the CBM update when CDP is enabled.
    Updated the commit log to make it generic.

v2: Added more generic text in documentation.
---
 Documentation/filesystems/resctrl.rst | 11 ++++
 fs/resctrl/ctrlmondata.c              | 93 +++++++++++++++++++++++++++
 fs/resctrl/internal.h                 |  3 +
 fs/resctrl/rdtgroup.c                 |  3 +-
 4 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 15e3a4abf90e..7e3eda324de5 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -188,6 +188,17 @@ related to allocation:
 			# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
 			0=ffff;1=ffff
 
+		CBMs can be configured by writing to the interface.
+
+		Example::
+
+			# echo 1=ff > /sys/fs/resctrl/info/L3/io_alloc_cbm
+			# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
+			0=ffff;1=00ff
+			# echo 0=ff;1=f > /sys/fs/resctrl/info/L3/io_alloc_cbm
+			# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
+			0=00ff;1=000f
+
 		When CDP is enabled "io_alloc_cbm" associated with the DATA and CODE
 		resources may reflect the same values. For example, values read from and
 		written to /sys/fs/resctrl/info/L3DATA/io_alloc_cbm may be reflected by
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index a4e861733a95..791ecb559b50 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -848,3 +848,96 @@ int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq,
 	cpus_read_unlock();
 	return ret;
 }
+
+static int resctrl_io_alloc_parse_line(char *line,  struct rdt_resource *r,
+				       struct resctrl_schema *s, u32 closid)
+{
+	enum resctrl_conf_type peer_type;
+	struct rdt_parse_data data;
+	struct rdt_ctrl_domain *d;
+	char *dom = NULL, *id;
+	unsigned long dom_id;
+
+next:
+	if (!line || line[0] == '\0')
+		return 0;
+
+	dom = strsep(&line, ";");
+	id = strsep(&dom, "=");
+	if (!dom || kstrtoul(id, 10, &dom_id)) {
+		rdt_last_cmd_puts("Missing '=' or non-numeric domain\n");
+		return -EINVAL;
+	}
+
+	dom = strim(dom);
+	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+		if (d->hdr.id == dom_id) {
+			data.buf = dom;
+			data.mode = RDT_MODE_SHAREABLE;
+			data.closid = closid;
+			if (parse_cbm(&data, s, d))
+				return -EINVAL;
+			/*
+			 * When CDP is enabled, update the schema for both CDP_DATA
+			 * and CDP_CODE.
+			 */
+			if (resctrl_arch_get_cdp_enabled(r->rid)) {
+				peer_type = resctrl_peer_type(s->conf_type);
+				memcpy(&d->staged_config[peer_type],
+				       &d->staged_config[s->conf_type],
+				       sizeof(d->staged_config[0]));
+			}
+			goto next;
+		}
+	}
+
+	return -EINVAL;
+}
+
+ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
+				   size_t nbytes, loff_t off)
+{
+	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
+	struct rdt_resource *r = s->res;
+	u32 io_alloc_closid;
+	int ret = 0;
+
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n')
+		return -EINVAL;
+
+	buf[nbytes - 1] = '\0';
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+	rdt_last_cmd_clear();
+
+	if (!r->cache.io_alloc_capable) {
+		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	if (!resctrl_arch_get_io_alloc_enabled(r)) {
+		rdt_last_cmd_printf("io_alloc is not enabled on %s\n", s->name);
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	io_alloc_closid = resctrl_io_alloc_closid(r);
+
+	rdt_staged_configs_clear();
+	ret = resctrl_io_alloc_parse_line(buf, r, s, io_alloc_closid);
+	if (ret)
+		goto out_clear_configs;
+
+	ret = resctrl_arch_update_domains(r, io_alloc_closid);
+
+out_clear_configs:
+	rdt_staged_configs_clear();
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+
+	return ret ?: nbytes;
+}
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 49934cd3dc40..5467c3ad1b6d 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -392,6 +392,9 @@ ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
 int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq,
 			      void *v);
 
+ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
+				   size_t nbytes, loff_t off);
+
 const char *rdtgroup_name_by_closid(int closid);
 
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 71003328fdda..ddac021c02d8 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1919,9 +1919,10 @@ static struct rftype res_common_files[] = {
 	},
 	{
 		.name		= "io_alloc_cbm",
-		.mode		= 0444,
+		.mode		= 0644,
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.seq_show	= resctrl_io_alloc_cbm_show,
+		.write		= resctrl_io_alloc_cbm_write,
 	},
 	{
 		.name		= "max_threshold_occupancy",
-- 
2.34.1



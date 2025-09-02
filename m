Return-Path: <kvm+bounces-56646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C329FB41039
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C26E05421C6
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97AA72E972E;
	Tue,  2 Sep 2025 22:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pI4GsclA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFB227A10F;
	Tue,  2 Sep 2025 22:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852976; cv=fail; b=IgikW5udrHOd8VxZhmkI26Oqr5YxNggmkoQyD2Lqn7CyLyp1zCA5BPbBta6r+4WRoAlodQlAPulNPfbUPtb/8QUThony6j68TmRLg7qieJzgBTy5lOrAY2A7pBCqii27bs+uFM+CKiDmsthHzuUhz9weDZ0fRsWykG9819I0xC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852976; c=relaxed/simple;
	bh=gONb+nM3Wp9LPxFBOjeWbIVLMMkG8euD+mhjsrESiFg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XdwNm72FMFUQt86Dw4ZR+l1TN83TUbpl067HBMjYeNQGM3sshLYRbcSuehgY59jBBu+sTYfNe3FqMTVf/Ufca0VhIoj8v8l1vP20k6SIK94pkhincCKAXZwvFWg4n/LOXDUEsX5fFpGzOwxhwoeZAiPPe0BFfKa2tVobkXz/5Dc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pI4GsclA; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uuRb1ffqZzJuzGQ1kToSsWC8TW+HEZW1r++KWhrwY7iyIMfi2ITvoQKsiNK8Jubk3rhg1VwjbhzIUsnHg3kvQVjhMeTFsl8lNAsrl3sFXf/ueufccw15yXjMfu/suU6NdV1ygCql4nzDqP7HH0FqAbnZtJFMJcQUTSoeAG1ZG92RcjvMnt+WsUdjbLOpz6caRKlzhcxRN2kC6l1rhjHd0AmmCK8umMhxhUY+iiPnIsofgORirt/AcoQxaLxvtiy1LmJpb5Qs4LK3aDzmNtJ22U+IIcrBnUKByvYl1yPEayvx/PnWPYorZDkqphbKb1r6MHlFicpGKgzdO8vQR1TQCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGsoGIABqfMncQ7rMt21WzYVrPWJn39+1sA4Y/uy5vM=;
 b=qSY98kKhXCJ5OOqzzg9EvADrKsPV3e70eBQ9zuqSSPq3BpPvGfxu+lJzUUdowrSkoactJy4KbVnZwc6EXo0I6cRjnYGF8YOUIAGqTQ31vpMuZ1Fe78FU5+3sEBvC72PXeixnkplcD4dXily/Y+URodluMJFriZntSOwXcgWrw+XntdO83vUFQck8MIkYJG0Xh8QDMKPlPZ+yEOSL0/uElHVj8LjmU6pUAfUy7N4u0kPlvJYxREniJtk8MEAuKlsquTNUMl/00C8I5B+lNi4W0698LfG/isAQFUxIz0BUwHkPpIVlT26qp9ftMTPKOhMUuQDlwaiu/xPTmKqvthx4kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGsoGIABqfMncQ7rMt21WzYVrPWJn39+1sA4Y/uy5vM=;
 b=pI4GsclAslEFcfYNRCZ9bTey5NGa1d4NjWDsc1zh8CZQmI1sWcWM3PvKLo3teaHApXxkKPbazn524IouAhUeK2AvcD/lon5Aadz9EVoOH1Di01yapqeKrFEZe5aseZ7xnaoNJOB3gL/Shi9kmD+294KiGiUFMZ3uVClHZKTKN2c=
Received: from SJ0PR03CA0149.namprd03.prod.outlook.com (2603:10b6:a03:33c::34)
 by CY8PR12MB8409.namprd12.prod.outlook.com (2603:10b6:930:7f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 22:42:50 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:a03:33c:cafe::2) by SJ0PR03CA0149.outlook.office365.com
 (2603:10b6:a03:33c::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Tue,
 2 Sep 2025 22:42:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:42:49 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:42:49 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:42:47 -0700
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
Subject: [PATCH v9 08/10] fs/resctrl: Modify rdt_parse_data to pass mode and CLOSID
Date: Tue, 2 Sep 2025 17:41:30 -0500
Message-ID: <9200fb7d50964548ef6321214af9967975cd9321.1756851697.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|CY8PR12MB8409:EE_
X-MS-Office365-Filtering-Correlation-Id: af47c2d5-250d-49b9-60e2-08ddea720bc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LQ34SecaF93hR58kSjM8zV+4/WLt6Puuc6EEXgcW/8FYGQVK3JLNTSzS+nrV?=
 =?us-ascii?Q?BTnNNswbb/nJiUmNv5SbSimotm1NaMhKSyjWJa6PLSE3mx2linhGK2Ap/Rs2?=
 =?us-ascii?Q?3HQXfRHe4qSxBGfgVcNoEvq6H/XNaAZc+plpcwnE6f2FO3X5dHWLFUKDor6B?=
 =?us-ascii?Q?zfc8+pjtTp05LXsSFu20jXl3CRMkWl0uzLSC2OcrO1REFH7PwkOaKNCJgPEN?=
 =?us-ascii?Q?4hedSIAa+sLJnELxm94ASCVLdV9ndSraiipN6ovsFjLExPoD/snfgfCRyoPS?=
 =?us-ascii?Q?mJpMUN48F1mPVsBjplJWlK+YezicIQ1F7sMcNSkhnWBFMmyWy1sKukZgtRPo?=
 =?us-ascii?Q?Fzg+yviQHB4I6hzMlUcn6gCCX73IeYACgCw91ej+2LxlEyXgy4fvzOeNFsgK?=
 =?us-ascii?Q?AhhB0RgmaymQYCjcbFursKXhN2y8EbgyGHcMB9+nSInXlkMoMjWH8e8DtTnc?=
 =?us-ascii?Q?oh56zwEQcO682644jHd+Ap0WW2Cr+fDJOblh6ocLt0MwAXQjDFX1cl6+OOfJ?=
 =?us-ascii?Q?m0QrV+EnWWFlXpS2UkQnONFwiKspwuB9wnVGG78+/u3cwHElIPo4Z/GDtXi9?=
 =?us-ascii?Q?Ug4HsONxUdtlCGOx2X9n7eZd+h0BxsEshIqk6qxaI3SBmScWkcddpaHRHbhR?=
 =?us-ascii?Q?VqkKT5jEkRONAtazvMD/KtQgvk/MfZISYKXpEzikasQz6I+ghrewSLJ/aM2j?=
 =?us-ascii?Q?pHh1FSD11uN/89Zxbrdh2OndfzNA32PROs1ymjpodra76pjIxzkwuSrvkp06?=
 =?us-ascii?Q?3frfyLLePlihxV38CXE+U/Cta9MPiRTZlpAe+AQ8smGdRuOgrfBj5/VHL9+F?=
 =?us-ascii?Q?3QcUB3o/jbDvxpWnEWdYT4QOv5JFlbTk497S5uzbnm+Lgr2GlfK6TOtofKQO?=
 =?us-ascii?Q?2SiiVPeltW8c33x4bG1jhzjx9fGXWR+61V8kPGxvAwD7pxhFDut20dJm07RK?=
 =?us-ascii?Q?QunwC7tbM2sJg33e2eDWDqLQ1qxcxGAuOkQP250XJHRFSQ3lqMLeiUzadnzv?=
 =?us-ascii?Q?42cGfUIjUCQUt0yvgi1Wr0gRGQ7RmbKh36i9FiS3SqFnp+6vscntLC1eXT+3?=
 =?us-ascii?Q?tt0TCqubeeBdb0CsGIf4wn0QhLXYDC04oGcDwb0LqOQNIEW0sHf14raPsFLs?=
 =?us-ascii?Q?nbWQOIuG9KdIOTStgISPDGmSWhrwXK9k0SoZ2QZJgoVjnRfJQZLrTtJ+XNey?=
 =?us-ascii?Q?U8dnJUxZuoOe0X+FtCQzojYhKwoge42lcMwE46r0VPiol6vWL1Imn8QZn6tj?=
 =?us-ascii?Q?m4/jCV7RjYVoIsKujbWnNGWY5oBPUZKedg7JMmkasQoIfBczH44VSYm3JIkA?=
 =?us-ascii?Q?k4QUjf4pVxfbpY6qV1j+n//751+H3l1XOSHUJ2poFd+cne4vQIWNlzIDMj06?=
 =?us-ascii?Q?OQcePdX0hx5LPT2X3Ef3b25l2vILXUEigSCNnahxRnhqiHE+z9YDZzOmt0hh?=
 =?us-ascii?Q?dF1i3KuGfH3jb4WI1eF7XnzKBgR/xTPvblOXg18SB/6W4VaWmVUeYvUdiJaL?=
 =?us-ascii?Q?LHfXogkpcKuGKo2NGEdQJoHCZ9FdRTCOj43p?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:42:49.9662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af47c2d5-250d-49b9-60e2-08ddea720bc3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8409

parse_cbm() require resource group mode and CLOSID to validate the Capacity
Bit Mask (CBM). It is passed via struct rdtgroup in struct rdt_parse_data.

The io_alloc feature also uses CBMs to indicate which portions of cache are
allocated for I/O traffic. The CBMs are provided by user space and need to
be validated the same as CBMs provided for general (CPU) cache allocation.
parse_cbm() cannot be used as-is since io_alloc does not have rdtgroup
context.

Pass the resource group mode and CLOSID directly to parse_cbm() via struct
rdt_parse_data, instead of through the rdtgroup struct, to facilitate
calling parse_cbm() to verify the CBM of the io_alloc feature.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v9: Rephrase of changelog.
    Minor code syntax update.

v8: Rephrase of changelog.

v7: Rephrase of changelog.

v6: Changed the subject line to fs/resctrl.

v5: Resolved conflicts due to recent resctrl FS/ARCH code restructure.

v4: New patch to call parse_cbm() directly to avoid code duplication.
---
 fs/resctrl/ctrlmondata.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index d1a54f6c4876..a4e861733a95 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -24,7 +24,8 @@
 #include "internal.h"
 
 struct rdt_parse_data {
-	struct rdtgroup		*rdtgrp;
+	u32			closid;
+	enum rdtgrp_mode	mode;
 	char			*buf;
 };
 
@@ -77,8 +78,8 @@ static int parse_bw(struct rdt_parse_data *data, struct resctrl_schema *s,
 		    struct rdt_ctrl_domain *d)
 {
 	struct resctrl_staged_config *cfg;
-	u32 closid = data->rdtgrp->closid;
 	struct rdt_resource *r = s->res;
+	u32 closid = data->closid;
 	u32 bw_val;
 
 	cfg = &d->staged_config[s->conf_type];
@@ -156,9 +157,10 @@ static bool cbm_validate(char *buf, u32 *data, struct rdt_resource *r)
 static int parse_cbm(struct rdt_parse_data *data, struct resctrl_schema *s,
 		     struct rdt_ctrl_domain *d)
 {
-	struct rdtgroup *rdtgrp = data->rdtgrp;
+	enum rdtgrp_mode mode = data->mode;
 	struct resctrl_staged_config *cfg;
 	struct rdt_resource *r = s->res;
+	u32 closid = data->closid;
 	u32 cbm_val;
 
 	cfg = &d->staged_config[s->conf_type];
@@ -171,7 +173,7 @@ static int parse_cbm(struct rdt_parse_data *data, struct resctrl_schema *s,
 	 * Cannot set up more than one pseudo-locked region in a cache
 	 * hierarchy.
 	 */
-	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP &&
+	if (mode == RDT_MODE_PSEUDO_LOCKSETUP &&
 	    rdtgroup_pseudo_locked_in_hierarchy(d)) {
 		rdt_last_cmd_puts("Pseudo-locked region in hierarchy\n");
 		return -EINVAL;
@@ -180,8 +182,7 @@ static int parse_cbm(struct rdt_parse_data *data, struct resctrl_schema *s,
 	if (!cbm_validate(data->buf, &cbm_val, r))
 		return -EINVAL;
 
-	if ((rdtgrp->mode == RDT_MODE_EXCLUSIVE ||
-	     rdtgrp->mode == RDT_MODE_SHAREABLE) &&
+	if ((mode == RDT_MODE_EXCLUSIVE || mode == RDT_MODE_SHAREABLE) &&
 	    rdtgroup_cbm_overlaps_pseudo_locked(d, cbm_val)) {
 		rdt_last_cmd_puts("CBM overlaps with pseudo-locked region\n");
 		return -EINVAL;
@@ -191,14 +192,14 @@ static int parse_cbm(struct rdt_parse_data *data, struct resctrl_schema *s,
 	 * The CBM may not overlap with the CBM of another closid if
 	 * either is exclusive.
 	 */
-	if (rdtgroup_cbm_overlaps(s, d, cbm_val, rdtgrp->closid, true)) {
+	if (rdtgroup_cbm_overlaps(s, d, cbm_val, closid, true)) {
 		rdt_last_cmd_puts("Overlaps with exclusive group\n");
 		return -EINVAL;
 	}
 
-	if (rdtgroup_cbm_overlaps(s, d, cbm_val, rdtgrp->closid, false)) {
-		if (rdtgrp->mode == RDT_MODE_EXCLUSIVE ||
-		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP) {
+	if (rdtgroup_cbm_overlaps(s, d, cbm_val, closid, false)) {
+		if (mode == RDT_MODE_EXCLUSIVE ||
+		    mode == RDT_MODE_PSEUDO_LOCKSETUP) {
 			rdt_last_cmd_puts("Overlaps with other group\n");
 			return -EINVAL;
 		}
@@ -262,7 +263,8 @@ static int parse_line(char *line, struct resctrl_schema *s,
 	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
 		if (d->hdr.id == dom_id) {
 			data.buf = dom;
-			data.rdtgrp = rdtgrp;
+			data.closid = rdtgrp->closid;
+			data.mode = rdtgrp->mode;
 			if (parse_ctrlval(&data, s, d))
 				return -EINVAL;
 			if (rdtgrp->mode ==  RDT_MODE_PSEUDO_LOCKSETUP) {
-- 
2.34.1



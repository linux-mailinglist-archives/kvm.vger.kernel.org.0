Return-Path: <kvm+bounces-53877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E727DB1918B
	for <lists+kvm@lfdr.de>; Sun,  3 Aug 2025 04:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 121301744E9
	for <lists+kvm@lfdr.de>; Sun,  3 Aug 2025 02:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6AE165F1A;
	Sun,  3 Aug 2025 02:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZdA//yEK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1111C2566
	for <kvm@vger.kernel.org>; Sun,  3 Aug 2025 02:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754189325; cv=fail; b=uJDxoA97B0zPOoQ7o5fHtpg8r1RXJvr9Xd16j3btw38EfxE/eG3TvtFKkP+btBJq08qEmh6qLWPnG8Xum10IziAhJla3e3ziNKBcE6ZbSkxK0tzcc7bzeLMT5pHmMMLT5DdPPMBpKNtd2Z3sejkUkYfwmCjo4OSnrpnUacUkNZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754189325; c=relaxed/simple;
	bh=MEH4HRrci4xYPdf5no2vWsqisb1ndZmITyNOvIIrl7A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXLh2NYoWSOXFeHqZjvTNnvW450jZbiBoQlP5zPgEkPl0eHT/3NxunMJGZC3Ai9V/KE2+0oM027X1TKHjvNdBBx7T+QcCvwWd/MQ2bJo+yoQx5BGb6wzO97yPPE05RzV4sRQclLK1rRCGH8TQcuW+cDKaIN+Jp+d0Fbb/Cezpow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZdA//yEK; arc=fail smtp.client-ip=40.107.243.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YeZRMnAKWIk4dPXNp0vTEbzNFOsOyzpxw7JlKjK0t07JevNQdXrCEOKr7uMALtC8rY91NFpVd6MskLoYnHrXeBEAKRqEMWrhAazEJcHQQOrqMdFCHO8T5szCY9yqfgehWTsqXuw64m7TcHHfSnnMMho7+k7tvKx0IZoTOid2acqgJ6Jfneu99667S97hQJhjB4lbW3wwdRtm1VUmcT/tmzcIkoQ3HJvAT4EDfOKArlCEOfGYhDf1pINZeW26w8IPulTjLDRVasKh0suMjb8J7G72saaV9+Pw8q/pBet/voE3DvnqHNsAikNA01Simi3YsBgWNligtj+1Sln9NJQD0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+S40YqQdjbx0wpmIRfr3wv8DHUxn4+Ekon+S7qMTH0s=;
 b=aECYZoLbma11JnTQ0hCkjhHpo6VqCV+o12MXjAIn904BFcCC/JeTQJ+ugCbPBSjbS8CBb0G4VwaY4Nr2EE1/oAhsAZJ3mHHOQdEHTwsdKEdAW5G8YWQhdFGTr/oFyeQoJOmcJ3EVQNHFEJvw1C3z5NuvB5Bv6Sx3Jgt4BKAT6PTYcfd0iBIo2sJUEp75d8eq1ky4E4udroibd45Mp7TAim76Nl+gkDf/Ar4J48swjU2Le/5JU5BLMG3pfchvfO4I4vIEhAlRI3Lbay1qypUuyRJ6/Fdg7iZbbLVGZHZ4Jq6cGTen3kZs5TqqfzwnByjgA/fAbJrt6RhBEc/WqoH6Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+S40YqQdjbx0wpmIRfr3wv8DHUxn4+Ekon+S7qMTH0s=;
 b=ZdA//yEKHwEc2EsqorqAI/M670KuT9w1/mU4ofCTLyv+4EQ82OXh+CkdY1E0kqqQiQb7n18xXj4uTYAKa6ToZsEbwcbUlQ3AoYR1gquutIuXz7dMWDywzqq4yJcm78kTcp53qjOjxC1nq3IcNOjHIncYzM1vQfPnKwgEwRrZhXyj/dYzJGcTN8I+kn3pfAkyFlqRHPDtf+9FsMwkC1EMNR8yiWC+dWRRNKQaLVnWFDl7hk9IR1g5Ca+oRdUIENdSf09vj+cciOuY432CVb2sB+7SLts1xguXVbQuVlVC/Q4csDtQWnheGnQNzaJVMfwMiu+FcCyqqfUlbdzK4oBm5g==
Received: from CH5PR04CA0015.namprd04.prod.outlook.com (2603:10b6:610:1f4::16)
 by SA3PR12MB8809.namprd12.prod.outlook.com (2603:10b6:806:31f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Sun, 3 Aug
 2025 02:48:34 +0000
Received: from CH1PEPF0000A34C.namprd04.prod.outlook.com
 (2603:10b6:610:1f4:cafe::8a) by CH5PR04CA0015.outlook.office365.com
 (2603:10b6:610:1f4::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.18 via Frontend Transport; Sun,
 3 Aug 2025 02:48:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000A34C.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.8 via Frontend Transport; Sun, 3 Aug 2025 02:48:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 2 Aug
 2025 19:47:55 -0700
Received: from dev.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 2 Aug
 2025 19:47:35 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <kbusch@kernel.org>, <axboe@fb.com>, <hch@lst.de>, <sagi@grimberg.me>,
	<alex.williamson@redhat.com>, <cohuck@redhat.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <mjrosato@linux.ibm.com>, <mgurtovoy@nvidia.com>
CC: <linux-nvme@lists.infradead.org>, <kvm@vger.kernel.org>,
	<Konrad.wilk@oracle.com>, <martin.petersen@oracle.com>,
	<jmeneghi@redhat.com>, <arnd@arndb.de>, <schnelle@linux.ibm.com>,
	<bhelgaas@google.com>, <joao.m.martins@oracle.com>, Chaitanya Kulkarni
	<kch@nvidia.com>, Lei Rao <lei.rao@intel.com>
Subject: [RFC PATCH 2/4] nvme: add live migration TP 4159 definitions
Date: Sat, 2 Aug 2025 19:47:03 -0700
Message-ID: <20250803024705.10256-3-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20250803024705.10256-1-kch@nvidia.com>
References: <20250803024705.10256-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34C:EE_|SA3PR12MB8809:EE_
X-MS-Office365-Filtering-Correlation-Id: 63f80a1a-4d7c-49f1-9c55-08ddd2383cd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s6Ejx3aSW7B2AzsWBJ91a3swQFUWc7Zq/jAzEXKpLUAmiWMR4oLZ5koPbKwW?=
 =?us-ascii?Q?9YPAB7yBvrrgk9be+WQ8n/HkpbZvaI4v8mpi6Gnu2t32Md6oojjxmhiXnmQ7?=
 =?us-ascii?Q?Ir6Sc3+AbhCbrfULU9T8qzsUhuBSxR88VSxvJG0gSjdM0hU4aMFDBLq/ysrg?=
 =?us-ascii?Q?W62kcN06TBerP3OTSZw4C/Yl9IkLZyB9JIQGsvMmnFJ3lfwqHeUL10G5q3Ae?=
 =?us-ascii?Q?k7zdECnCz32y5Z4wQ8vdr5ajjRJsxEuAeWtMXqqXQIqBmp/gGQHGM1MQoUer?=
 =?us-ascii?Q?ZeZRzkdMOlr6uUDHkyZb0IqeKbRXcY8g8sfftIXVF8iJZ7oVLguksE2qEQJI?=
 =?us-ascii?Q?JOpzu2aOR9wU0onG6Ty6Uu8oRjsqCvdZlk1Teztge4EoHi9cNnjHQ+Vu6jgT?=
 =?us-ascii?Q?lb8nc+IAPlHdUaf3DWEqC+A1BtorEU+7bUdcDwxw8HGubm8H57/GQJGLNwoS?=
 =?us-ascii?Q?BRQDf5g3Lbe/Evb5+LXs1mvCCEsUYnhEGxxtQIck0urZpp7feZ9Zxnp4FDBb?=
 =?us-ascii?Q?nJVCxsGASL7aHM1dWiS18wOKCC8ABPgisx1/SrC+zwcfYFfZRMPEZOwDw1to?=
 =?us-ascii?Q?aMFTXaM0i9L6aGE9KP83CMrdU75mR9J7TzgQLUQ+EqEG1ANFTFMEOBKoIK+X?=
 =?us-ascii?Q?hOHUD+qG39JzlvJl9C4S0vOTtCNM74/hbVR0vHKdp+4RRd2tQVBH8KIwKHSW?=
 =?us-ascii?Q?NwU4Z4bfEYmR6/RuOL3u36D7N2p9SxCalOsHsDEupHrFa/aq12Fund6y/eTR?=
 =?us-ascii?Q?pFXciWrqbDbo4O8ynlNwVXYSTDg33RuB/jL7rUFtoYGTfhNPA725pV2zLJrP?=
 =?us-ascii?Q?32/vjdcs5q+Z9uWE/DhlcaroRkXMfb6WMkFxvllXfgqg4EE/atnyoNYEvcZ3?=
 =?us-ascii?Q?5FQPdB/JdQADIurV4DcLPQOCxDxYpWWTbz6jLBF4H+23XkbH2LAtaGgmn5oO?=
 =?us-ascii?Q?Istakm1wj19UuiiI1unT5A+XC3MyOE4EvW+jgLLa88ZSJmPsCsED1Jkh1wUL?=
 =?us-ascii?Q?CF4UaQL386Gj5sN79oXMzCUkY2nzGsT0B/RuQLiYE7BH1wSpZrUrPaSoIf4t?=
 =?us-ascii?Q?KCarJ6kOm+zzVs9nohnfJ1gzzq1CFFJfLt3C83TTYcegZH6Oyo17BBwrC1Ws?=
 =?us-ascii?Q?bfXx5NW8fvdJttTvZnhWL+yZbztwvTborQ0cUFssKYkNk4GqWeuMLLesC612?=
 =?us-ascii?Q?5GLTQpPx2oc4w5qXVDu4fUXv4FSMhuA5UwTiRsLOoK1ZmqbpgDiI4JNDs1e7?=
 =?us-ascii?Q?rj+tHP5Dc+TeZR2aX9kfMVGmwXPieQETKFZGOWtmOlI0cBPA1UE14eQXwdaf?=
 =?us-ascii?Q?tBNM/94hpo+UM1FGaCR9h0Iz4LQZb29hmbXrLqNM/i1Ksqrl26nxx+FUNSV9?=
 =?us-ascii?Q?pTXCVjVyfjlRSkpBYBEX2Z54VqCawYCZrefXmHCtLYhEcJEWj1YBC46ysiK1?=
 =?us-ascii?Q?EZWO92jpN3GTWmzy2dzyIYwq91g4bt7UT33DcdF+pM8GPaPaIVIPfFPiYKgV?=
 =?us-ascii?Q?+ecie+MG96uIuBOfZKhQNRzHR/zts3rfRB4htb9E6iWv6VLwWK89eMFCjA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2025 02:48:33.0808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f80a1a-4d7c-49f1-9c55-08ddd2383cd3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8809

nvme: add TP4159 live migration definitions and command support

Introduce core definitions and data structures required to support
Live Migration operations as described in TP4159. These updates
enable controller state extraction, transfer, and restoration.

Key changes:

- Extend nvme_id_ctrl with TP4159 migration capability fields:
  - CMMRTD/NMMRTD: Migration tracking granularity
  - MCUDMQ/MNSUDMQ: Migration controller suspend queue depth
  - TRATTR: Tracking attribute bitfield (e.g., THMCS, TUDCS)

- Define controller state format discovery (CNS=0x20):
  - struct nvme_lm_supported_ctrl_state_fmts: layout for reporting
    NVMe-defined and vendor-defined controller state formats
  - struct nvme_lm_ctrl_state_fmts_info: internal parsing view

- Add live migration controller state format v0 support:
  - struct nvme_lm_nvme_cs_v0_state: encapsulates suspendable state
    including I/O submission and completion queues
  - struct nvme_lm_iosq_state / iocq_state: PRP, QID, head/tail, etc.

- Introduce Migration Send (Opcode 0x43) and Receive (0x42):
  - struct nvme_lm_send_cmd: supports suspend, resume, set state
  - struct nvme_lm_recv_cmd: supports get controller state

- Support for sequence indicators (SEQIND) to allow multi-part
  transfer of controller state buffers during suspend/resume

- Add new admin opcodes to enum nvme_admin_opcode:
  - nvme_admin_lm_send = 0x41
  - nvme_admin_lm_recv = 0x42

- Extend union nvme_command to include struct nvme_lm_command,
  enabling transport of send/receive commands through common paths

- Add new status code definitions for migration error handling:
  - NVME_SC_NOT_ENOUGH_RESOURCE
  - NVME_SC_CTRL_SUSPENDED
  - NVME_SC_CTRL_NOT_SUSPENDED
  - NVME_SC_CTRL_DATA_QUEUE_FAIL

- Include migration-related size checks in _nvme_check_size() to
  ensure live migration command structures align to spec (64 bytes)

These additions form the low-level protocol and data contract
supporting live migration of NVMe controllers, and are a prerequisite
for implementing suspend/resume and controller state transfer flows.

Signed-off-by: Lei Rao <lei.rao@intel.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/core.c |   2 +
 include/linux/nvme.h     | 334 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 335 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5d8638086cba..2445862ac7d4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5314,6 +5314,8 @@ static inline void _nvme_check_size(void)
 	BUILD_BUG_ON(sizeof(struct nvme_rotational_media_log) != 512);
 	BUILD_BUG_ON(sizeof(struct nvme_dbbuf) != 64);
 	BUILD_BUG_ON(sizeof(struct nvme_directive_cmd) != 64);
+	BUILD_BUG_ON(sizeof(struct nvme_lm_send_cmd) != 64);
+	BUILD_BUG_ON(sizeof(struct nvme_lm_recv_cmd) != 64);
 	BUILD_BUG_ON(sizeof(struct nvme_feat_host_behavior) != 512);
 }
 
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 655d194f8e72..69a8c48faa6c 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -362,7 +362,19 @@ struct nvme_id_ctrl {
 	__u8			anacap;
 	__le32			anagrpmax;
 	__le32			nanagrpid;
-	__u8			rsvd352[160];
+	/* --- Live Migration support (TP4159 additions) --- */
+	__le16			cmmrtd;
+	__le16			nmmrtd;
+	__u8			minmrtg;
+	__u8			maxmrtg;
+	__u8			trattr;
+	__u8			rsvd577;
+	__le16			mcudmq;
+	__le16			mnsudmq;
+	__le16			mcmr;
+	__le16			nmcmr;
+	__le16			mcdqpc;
+	__u8			rsvd352[160 - 20]; /* pad to offset 512 */
 	__u8			sqes;
 	__u8			cqes;
 	__le16			maxcmd;
@@ -394,6 +406,14 @@ struct nvme_id_ctrl {
 	__u8			vs[1024];
 };
 
+/* Tracking Attributes (TRATTR) Bit Definitions */
+/* Track Host Memory Changes Support */
+#define NVME_TRATTR_THMCS         (1 << 0)
+/* Track User Data Changes Support */
+#define NVME_TRATTR_TUDCS         (1 << 1)
+ /* Memory Range Tracking Length Limit */
+#define NVME_TRATTR_MRTLL         (1 << 2)
+
 enum {
 	NVME_CTRL_CMIC_MULTI_PORT		= 1 << 0,
 	NVME_CTRL_CMIC_MULTI_CTRL		= 1 << 1,
@@ -409,6 +429,7 @@ enum {
 	NVME_CTRL_OACS_NS_MNGT_SUPP		= 1 << 3,
 	NVME_CTRL_OACS_DIRECTIVES		= 1 << 5,
 	NVME_CTRL_OACS_DBBUF_SUPP		= 1 << 8,
+	NVME_CTRL_OACS_HMLMS			= 1 << 11,
 	NVME_CTRL_LPA_CMD_EFFECTS_LOG		= 1 << 1,
 	NVME_CTRL_CTRATT_128_ID			= 1 << 0,
 	NVME_CTRL_CTRATT_NON_OP_PSP		= 1 << 1,
@@ -567,6 +588,7 @@ enum {
 	NVME_ID_CNS_NS_GRANULARITY	= 0x16,
 	NVME_ID_CNS_UUID_LIST		= 0x17,
 	NVME_ID_CNS_ENDGRP_LIST		= 0x19,
+	NVME_ID_CNS_LM_CTRL_STATE_FMT	= 0x20,
 };
 
 enum {
@@ -1290,6 +1312,300 @@ enum {
 	NVME_ENABLE_LBAFEE	= 1,
 };
 
+/* Figure SCSF-FIG1: Supported Controller State Formats Data Structure */
+/**
+ * Supported Controller State Formats (SCSF-FIG1)
+ *
+ * This describes the Identify CNS=0x20 response layout, which contains:
+ *  - NV    : Number of NVMe-defined controller state format versions
+ *  - NUUID : Number of vendor-specific format UUIDs
+ *  - VERS[NV]  : Array of 2-byte version IDs
+ *  - UUID[NUUID] : Array of 16-byte UUIDs
+ *
+ * Memory layout (variable-sized structure):
+ *
+ *  +------------------+-------------------------------+
+ *  | Offset (Bytes)   | Field                         |
+ *  +------------------+-------------------------------+
+ *  | 0                | NV (Number of Versions)       |
+ *  | 1                | NUUID (Number of UUIDs)       |
+ *  +------------------+-------------------------------+
+ *  | 2                | VERS[0] (2 bytes)             |
+ *  | 4                | VERS[1] (2 bytes)             |
+ *  | ..               | ...                           |
+ *  | 2 + NV*2 - 2     | VERS[NV-1] (2 bytes)          |
+ *  +------------------+-------------------------------+
+ *  | ...              | UUID[0] (16 bytes)            |
+ *  | ...              | UUID[1] (16 bytes)            |
+ *  | ..               | ...                           |
+ *  | ...              | UUID[NUUID-1] (16 bytes)      |
+ *  +------------------+-------------------------------+
+ *
+ * Total size = 2 + NV * 2 + NUUID * 16 bytes.
+ */
+
+#define NVME_LM_CTRL_STATE_HDR_SIZE	2
+#define NVME_LM_VERSION_ENTRY_SIZE	2
+#define NVME_LM_UUID_ENTRY_SIZE		16
+
+struct nvme_lm_supported_ctrl_state_fmts {
+	__u8		nv;
+	__u8		nuuid;
+	__le16		vers[]; /* Followed by uuid[NUUID][16] */
+} __packed;
+
+struct nvme_lm_ctrl_state_fmts_info {
+	__u8		nv;
+	__u8		nuuid;
+	const __le16	*vers;
+	const __u8	(*uuids)[16];
+	void		*ctrl_state_raw_buf;
+	size_t		raw_len;
+};
+
+/**
+ * Controller State Buffer (SCS-FIG5)
+ *
+ * This describes the Migration Receive (Opcode = 0x42, Select = 0h)
+ * response layout, which contains:
+ *
+ *  - version : Structure version (e.g. 0x0000)
+ *  - csattr  : Controller state attributes
+ *  - nvmecss : Length of NVMECS block (in DWORDs)
+ *  - vss     : Length of VSD block (in DWORDs)
+ *  - data[]  : Contiguous NVMECS + VSD blocks
+ *
+ * Memory layout (variable-sized structure):
+ *
+ *  +------------------+-------------------------------------------+
+ *  | Offset (Bytes)   | Field                                     |
+ *  +------------------+-------------------------------------------+
+ *  | 0x00             | version (2 bytes)                         |
+ *  | 0x02             | csattr (1 byte)                           |
+ *  | 0x03             | rsvd[13] (13 bytes)                       |
+ *  | 0x10             | nvmecss (2 bytes)                         |
+ *  | 0x12             | vss (2 bytes)                             |
+ *  +------------------+-------------------------------------------+
+ *  | 0x14             | NVMECS[0] (nvmecss * 4 bytes)             |
+ *  | ...              |                                           |
+ *  | 0x14 + NVMECS    | VSD[0] (vss * 4 bytes)                    |
+ *  +------------------+-------------------------------------------+
+ *
+ * Total size = 0x14 + (nvmecss + vss) * 4 bytes.
+ */
+
+struct nvme_lm_ctrl_state {
+	__le16	version;
+	__u8	csattr;
+	__u8	rsvd[13];
+	__le16	nvmecss;
+	__le16	vss;
+	__u8	data[]; /* NVMECS + VSD */
+} __packed;
+
+struct nvme_lm_ctrl_state_info {
+	struct nvme_lm_ctrl_state *raw;
+	size_t total_len;
+
+	const __u8 *nvme_cs;
+	const __u8 *vsd;
+
+	__le16 version;
+	__u8   csattr;
+	__le16 nvmecss;
+	__le16 vss;
+};
+
+/**
+ * struct nvme_lm_iosq_state - I/O Submission Queue State (SCS-FIG7)
+ */
+struct nvme_lm_iosq_state {
+	__le64 prp1;
+	__le16 qsize;
+	__le16 qid;
+	__le16 cqid;
+	__le16 attr;
+	__le16 head;
+	__le16 tail;
+	__u8   rsvd[4];
+} __packed;
+
+/**
+ * struct nvme_lm_iocq_state - I/O Completion Queue State (SCS-FIG8)
+ */
+struct nvme_lm_iocq_state {
+	__le64 prp1;
+	__le16 qsize;
+	__le16 qid;
+	__le16 head;
+	__le16 tail;
+	__le16 attr;
+	__u8   rsvd[4];
+} __packed;
+
+/**
+ * struct nvme_lm_nvme_cs_v0_state - NVMe Controller State v0 (SCS-FIG6)
+ *
+ * Memory layout:
+ *
+ *  +---------+--------+-----------------------------------------+
+ *  | Offset  | Size   | Field                                   |
+ *  +---------+--------+-----------------------------------------+
+ *  | 0x00    | 2 B    | VER - version of NVMECS block           |
+ *  | 0x02    | 2 B    | NIOSQ - number of I/O submission queues |
+ *  | 0x04    | 2 B    | NIOCQ - number of I/O completion queues |
+ *  | 0x06    | 2 B    | Reserved                                |
+ *  | 0x08    | ...    | IOSQ[NIOSQ] (24 bytes each)             |
+ *  | ...     | ...    | IOCQ[NIOCQ] (24 bytes each)             |
+ *  +---------+--------+-----------------------------------------+
+ */
+struct nvme_lm_nvme_cs_v0_state {
+	__le16 ver;
+	__le16 niosq;
+	__le16 niocq;
+	__u8   rsvd[2];
+	struct nvme_lm_iosq_state iosq[]; /* Followed by IOCQ */
+} __packed;
+
+
+/* Suspend Type field (cdw11[17:16]) per SUSPEND-FIG1 */
+enum nvme_lm_suspend_type {
+	NVME_LM_SUSPEND_TYPE_NOTIFY	= 0x00,
+	NVME_LM_SUSPEND_TYPE_SUSPEND	= 0x01,
+};
+
+/* Migration Send Select field values (cdw10[7:0]) */
+enum nvme_lm_send_select {
+	NVME_LM_SEND_SEL_SUSPEND	= 0x00,
+	NVME_LM_SEND_SEL_RESUME		= 0x02,
+	NVME_LM_SEND_SEL_SET_CTRL_STATE	= 0x03,
+};
+
+/* Migration Send Sequence Indicator (SEQIND) field values (cdw11[17:16]) */
+enum nvme_lm_send_seqind {
+	NVME_LM_SEQIND_MIDDLE = 0x00,
+	NVME_LM_SEQIND_FIRST  = 0x01,
+	NVME_LM_SEQIND_LAST   = 0x02,
+	NVME_LM_SEQIND_ONLY   = 0x03,
+};
+
+/**
+ * struct nvme_lm_send_cmd - Migration Send Command (Opcode 0x43)
+ *
+ * Command fields correspond to:
+ * - MSC-FIG1: Command Dword 10
+ * - SUSPEND-FIG1: Command Dword 11
+ * - MSC-FIG2: Command Dword 14 and 15
+ *
+ * Layout:
+ * @opcode:     Opcode = 0x43 (Migration Send)
+ * @flags:      Command flags
+ * @command_id: Unique command identifier
+ * @nsid:       Namespace ID (typically 0)
+ * @cdw2:       Reserved (CDW2–CDW3)
+ * @metadata:   Metadata pointer (unused)
+ * @dptr:       PRP/SGL pointer to controller state buffer
+ * @cdw10:      CDW10:
+ *              - [07:00] Select (SEL): migration operation (e.g., 0x01 = Suspend)
+ *              - [15:08] Reserved
+ *              - [31:16] Management Operation Specific (MOS)
+ * @cdw11:      CDW11:
+ *              - [15:00] Controller Identifier (CNTLID)
+ *              - [17:16] Sequence Indicator (SEQIND):
+ *                  01b = First, 00b = Middle, 10b = Last, 11b = Only
+ *              - [31:18] Reserved
+ * @cdw12:      Reserved or vendor-specific
+ * @cdw13:      CDW13:
+ *              - [07:00] UUID Index
+ *              - [15:08] UUID Parameter
+ *              - [31:16] Reserved
+ * @cdw14:      Offset Lower (used with Send Controller State)
+ * @cdw15:      Offset Upper
+ */
+struct nvme_lm_send_cmd {
+	__u8			opcode;
+	__u8			flags;
+	__u16			command_id;
+	__le32			nsid;
+	__le32			cdw2[2];
+	__le64			metadata;
+	union nvme_data_ptr	dptr;
+	__le32			cdw10;
+	__le32			cdw11;
+	__le32			cdw12;
+	__le32			cdw13;
+	__le32			cdw14;
+	__le32			cdw15;
+} __packed;
+
+
+enum nvme_lm_recv_sel {
+	NVME_LM_RECV_GET_CTRL_STATE	= 0x00,
+};
+
+enum nvme_lm_recv_mos {
+	/* NVMe-defined Controller State Format v1 */
+	 NVME_LM_RECV_CSVI_NVME_V1	= 0x0000,
+	/* Additional indices may be defined by future specs or vendors */
+};
+
+#define NVME_LM_CTRL_STATE_VER   0x0000  /** Expected version value */
+
+/**
+ * struct nvme_lm_recv_cmd - NVMe Migration Receive Command
+ *
+ * This structure defines the NVMe admin command used to receive
+ * controller state or resume a controller as part of a live migration
+ * operation (Opcode 0x42), as described in TP4159.
+ *
+ * Fields:
+ * @opcode:     Opcode for Migration Receive command (0x42).
+ * @flags:      Command flags (e.g., fused operations, SGLs).
+ * @command_id: Unique identifier for this command issued by the host.
+ * @nsid:       Namespace ID (typically 0 for admin commands).
+ * @cdw2:       Reserved (Command Dwords 2–3).
+ * @metadata:   Metadata pointer (typically unused for this command).
+ * @dptr:       PRP/SGL pointer to the host buffer receiving the controller
+ *              state.
+ * @cdw10:      Command Dword 10:
+ *              - [07:00] Select (operation: e.g., Get Controller State,
+ *                Resume Controller).
+ *              - [31:08] Management Operation Specific (MOS) —
+ *                defined per Select operation.
+ * @cdw11:      Command Dword 11:
+ *              - [15:00] Controller Identifier (CNTLID) — identifies the
+ *                target controller.
+ *              - [17:16] Sequence Indicator (SEQIND) — position in
+ *                multi-part transfer sequence:
+ *                01b = First, 00b = Middle, 10b = Last, 11b = Only.
+ * @cdw12:       Offset into the controller state data (in dwords).
+ * @cdw13:       Number of dwords to transfer (0-based).
+ * @cdw14:       Reserved or vendor-specific.
+ * @cdw15:       Optional UUID Index (if vendor-specific controller state
+ *               format is used), or reserved.
+ */
+struct nvme_lm_recv_cmd {
+	__u8			opcode;
+	__u8			flags;
+	__u16			command_id;
+	__le32			nsid;
+	__le32			rsvd2[2];
+	__le64			metadata;
+	union nvme_data_ptr	dptr;
+	__u8			sel;
+	__u8			rsvd10_1;
+	__le16			mos;
+	__le16			cntlid;
+	__u8			csuuidi;
+	__u8			csuidxp;
+	__le32			offset_lower;
+	__le32			offset_upper;
+	__u8			uuid_index;
+	__u8			rsvd14[3];
+	__le32			numd;
+};
+
+
 /* Admin commands */
 
 enum nvme_admin_opcode {
@@ -1314,6 +1630,8 @@ enum nvme_admin_opcode {
 	nvme_admin_virtual_mgmt		= 0x1c,
 	nvme_admin_nvme_mi_send		= 0x1d,
 	nvme_admin_nvme_mi_recv		= 0x1e,
+	nvme_admin_lm_send		= 0x41,
+	nvme_admin_lm_recv		= 0x42,
 	nvme_admin_dbbuf		= 0x7C,
 	nvme_admin_format_nvm		= 0x80,
 	nvme_admin_security_send	= 0x81,
@@ -1347,6 +1665,8 @@ enum nvme_admin_opcode {
 		nvme_admin_opcode_name(nvme_admin_virtual_mgmt),	\
 		nvme_admin_opcode_name(nvme_admin_nvme_mi_send),	\
 		nvme_admin_opcode_name(nvme_admin_nvme_mi_recv),	\
+		nvme_admin_opcode_name(nvme_admin_lm_send),	\
+		nvme_admin_opcode_name(nvme_admin_lm_recv),	\
 		nvme_admin_opcode_name(nvme_admin_dbbuf),		\
 		nvme_admin_opcode_name(nvme_admin_format_nvm),		\
 		nvme_admin_opcode_name(nvme_admin_security_send),	\
@@ -1973,6 +2293,13 @@ struct streams_directive_params {
 	__u8	rsvd2[6];
 };
 
+struct nvme_lm_command {
+	union {
+		struct nvme_lm_recv_cmd		recv;
+		struct nvme_lm_send_cmd		send;
+	};
+};
+
 struct nvme_command {
 	union {
 		struct nvme_common_command common;
@@ -1999,6 +2326,7 @@ struct nvme_command {
 		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
+		struct nvme_lm_command lm;
 		struct nvme_io_mgmt_recv_cmd imr;
 	};
 };
@@ -2116,6 +2444,10 @@ enum {
 	NVME_SC_TRANSIENT_TR_ERR	= 0x22,
 	NVME_SC_ADMIN_COMMAND_MEDIA_NOT_READY = 0x24,
 	NVME_SC_INVALID_IO_CMD_SET	= 0x2C,
+	NVME_SC_NOT_ENOUGH_RESOURCE	= 0x38,
+	NVME_SC_CTRL_SUSPENDED		= 0x39,
+	NVME_SC_CTRL_NOT_SUSPENDED	= 0x3A,
+	NVME_SC_CTRL_DATA_QUEUE_FAIL	= 0x3B,
 
 	NVME_SC_LBA_RANGE		= 0x80,
 	NVME_SC_CAP_EXCEEDED		= 0x81,
-- 
2.40.0



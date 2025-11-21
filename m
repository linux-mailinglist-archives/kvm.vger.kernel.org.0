Return-Path: <kvm+bounces-64085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 986B7C77F2A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 16A244E6E28
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02EB2156230;
	Fri, 21 Nov 2025 08:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="btDpi+w/"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C5413777E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 08:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763714303; cv=fail; b=aQttPrYjBqrjtYoNv9N0evWYATSXfV0D6Kn6q6l67kGYj2RmiCR3qfLU9epUi0TnFuhpGe8UYt5pKqqtBf0xfDwd5pNwiVZHNbIPTVcp7HSPgM4zHo7Tm2c688+HA8lyzqZxuNZb3pmtZ1svS7LXd4oAebwXXgKcvg61rctab+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763714303; c=relaxed/simple;
	bh=J9SoHKIBdO8aUr0JRmRo4dBGqLobI5X4yCZAvFVg/W8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YI4RrUC1mj48x9FVT1TRizQpGofe54MPSBHaLRyLIM4P4xciZcBzC5ViSv9DJI7ZSsngo0kPpGlyQEwaA8lODPNO2y4KzOzDjtj5lG+WYh6mOhtLAMU2E8As2DL2W4rbv4ATmDUbywshv2/kXkQ3Lti90ZS494Z3hUAq0rCIMGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=btDpi+w/; arc=fail smtp.client-ip=52.101.56.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S7uEReaKxx63FitKjU9U50Dus6ikMffz4cZkNRqhtcybzVqwHrbiEZ46afXJp+CYx6GY5Hwrnpo4c4uQYSa8AViibzmIxrUWUtk3PbxSWHCCsJ9xeyvBHMe+iDNxzt8pyH1DSE0IcdGKpqNJejFKCF39FGiADpORzhNhXFpKaZ1sb7Nx4b25vcBn5f+ZHYVqRZ1GfqZ0kfhxvcnP5oEsPhN1/UWIfyv6GtjoypkYDSVfO0wPxHIqUlVIVDA5S1DKxEI7NQVzDmZsZ6KMENmQrOFAeNxXxEKrekUTgu/aK/tPO0Ql5cdIL0sH83guTm/h1/ilHJ8lx2JQdVXHVSRB+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+boKxpjIoxJc+KhooMJtnUsReY9o0+wonKYSweLuoQY=;
 b=c4DmpPVUx3OU7v+Rz5/D/eZxNDZnLCUyny8gnDGPzuT2d1ePfTK4ZBIN13qWb7rNM3ud3cDZg6uCsp1rYp2FJ+3Aa4NnoSKL+UEzb8mRIazqE0j047I59cGnPlMgzVTVYGkKhXzSB9ZsAtcq8dnXrUgy/OYucaOywZ5NhWn8862s5WHMxAFzciDScSDxoCzzlsZzd6ug/0P0r/GYIFolyjOf2zDI0wj7+pSt9uADjJum4Ff4vT/3D0matx7CfIPkJmOOxnUZykZYStOjWAfnRTDyWjexRX7sSWWSDwuoypkkY6KQzX/bXjqe25k5mh0VKLNcpNr07sdqgmoAVlbd5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+boKxpjIoxJc+KhooMJtnUsReY9o0+wonKYSweLuoQY=;
 b=btDpi+w/CR2ZwksTiOQba0uIGa0IrhyD47Dxa36QmrtGy/EFDU9JjGoklYeGWmBBIbIES1sEmcv9x2Uz+jwhTR0J7tk/ABffYOvPTp1i3ctB7t8L/80HQQf2hTcs8haJ/Xcl1g82zrDlgsvEKAPkMLkFqqn0bBZd8aF3vERo5j0=
Received: from BN9PR03CA0904.namprd03.prod.outlook.com (2603:10b6:408:107::9)
 by BN5PR12MB9510.namprd12.prod.outlook.com (2603:10b6:408:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 08:38:18 +0000
Received: from BN2PEPF000044A9.namprd04.prod.outlook.com
 (2603:10b6:408:107:cafe::8b) by BN9PR03CA0904.outlook.office365.com
 (2603:10b6:408:107::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.12 via Frontend Transport; Fri,
 21 Nov 2025 08:38:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A9.mail.protection.outlook.com (10.167.243.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:38:18 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:38:15 -0800
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <pbonzini@redhat.com>, <zhao1.liu@intel.com>, <mtosatti@redhat.com>,
	<kvm@vger.kernel.org>
CC: <qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>,
	<shivansh.dhiman@amd.com>
Subject: [PATCH 5/5] i386: Add Bus Lock Detect support for EPYC-Turin-v2 model
Date: Fri, 21 Nov 2025 08:34:52 +0000
Message-ID: <20251121083452.429261-6-shivansh.dhiman@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251121083452.429261-1-shivansh.dhiman@amd.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A9:EE_|BN5PR12MB9510:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bd28d36-d5a2-4819-c28c-08de28d9522b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sbu+7SzW0BSgJCxW7c7IG/wPasYc5Wt//1wL0gAn9JCXpry2hI0NUV5Ld7tN?=
 =?us-ascii?Q?on1VO/eXe+jmMSLS44Ztq2L4lIOLDa0OYs/dfmnum+JIlfh6FEiQUiEQDp0W?=
 =?us-ascii?Q?KYVkTg1jKnHAa1b5z5QMdSS0Mn5S9UJCNkvASa9FvV3n0bgDpojQe/Rw+375?=
 =?us-ascii?Q?TI3jpMW2m/6D1ZSmmFHQY1MaJRcF6OqQcro0n2/0UsGExeWJ66ynUSiVwJqd?=
 =?us-ascii?Q?EIXFFUnrQqeHi1GE++MhjNnXE25yWtYuIN/eRH63Hdvr0uNjJecNxA3ub3sn?=
 =?us-ascii?Q?+hnmXuC2GdYO8A40DMtbfxgPiJs5g8yRaRVsykpXOLbL328hX3nFRxFu0NCE?=
 =?us-ascii?Q?/DAs8dq4ivyIK8F4HkRDlkV2uTszvp7H/ZePJe4yIYnxyK19KT0kcwKYUDhF?=
 =?us-ascii?Q?uBpNOqfw5/aDsD7B7b3HEGVdNFBHqGrNEkbl+ZziMbgfMpgYYwCMaL0+zBjZ?=
 =?us-ascii?Q?JeLS2asGYsVOxyk4M6m1N4/RSwSvGeKVak0NX98Yxs+3Vbt81Sy4FFpfb7/9?=
 =?us-ascii?Q?0yvkO/nf+kkJVbSgA5ZMPARCb1u/ZXlpqZXFL046HR1hUUmDSPYB9UaAoeVT?=
 =?us-ascii?Q?lqLbORK2Zozk2KBoG6/vCAuVIPDuA+pIADLZRPRLoEUp8rjoCxVj0/f6Q44v?=
 =?us-ascii?Q?+CzA5eGClsGY/Kz/d+hwnCGUgf40xM8/e1CPUSDCJj9gqIV3baglEjA/BMEN?=
 =?us-ascii?Q?owNpBfTSyMjmegzBhR4jX8aW8D4xaNtQG1DTUD9lV2gFEM65hb9a83FLLmZs?=
 =?us-ascii?Q?j0c5OkILsBkF+s3G9dXGzSv70oKMoHKvvnyyUVvpa7CDEj3A4JHt0Rh4d6Lu?=
 =?us-ascii?Q?+Nk3PsmGwfruUFJGhoKPzi6rgNTuWIeXAoWQQPSoIyi/sJCI7FnZ6qOoidUT?=
 =?us-ascii?Q?ekHw0TERVi9tbx+sA2EkBfFBZzssR4u6F+S9DzfaMxKbB2GlJhM0LRrKDAab?=
 =?us-ascii?Q?CO3cR7CBDpel4dDaG3nmxx0BiXPA9GxPNAYA0+Oc2Rrp4iiRLtll/GZr2/AP?=
 =?us-ascii?Q?1RXCp0qRMTBzZsbm2bk+IU8vFTETORF3FoE+cZ4Hpa/y/C8U7/rQMwYGDcYF?=
 =?us-ascii?Q?5I0qs0wjJCXQGDHyspEDIStareeT7ENbOaVCa+ZyeU9dRp/Qm4swS0OIJwQ5?=
 =?us-ascii?Q?akeqo1nNX0iZDqq/h7eQg7DZ4RhrD4JpCKf8nic3sFIErajbIhRAzQVbxhM6?=
 =?us-ascii?Q?s+4qf1lq6i85ctNo2qE0yJ1QKESlwtCA201eG6k3Hd8UYuZSTcTJBROr8IA/?=
 =?us-ascii?Q?hPaPfG/PKp1GxBnqa2ba9578vY2+hyeSjT8BdcrzDt1HNhomli+a9zMc3OdO?=
 =?us-ascii?Q?DYuU1z6IyKDPKVmKpgLkPbFSFnyAXAnJsamveP795IpHet+Fba8hPoalc5gQ?=
 =?us-ascii?Q?NJ1hQiUBrgC/prTxjd15NiYZWICJSNkx3mgXQnDQ/mvG/JEH+q2DmmbWPEwP?=
 =?us-ascii?Q?cpfyyoiQysvVDdmOAc41+rVWWIldwHuQJwK8MuuIZnL6Ina1RPmw0EMv+VXg?=
 =?us-ascii?Q?ncryY7nBiccZ3pT5iojmRDEjRgzBQOtoEE/591mxLW2kOc0UTdQnqdjPMK5F?=
 =?us-ascii?Q?8rhcKbs9SCSuha6MUEk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:38:18.4383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd28d36-d5a2-4819-c28c-08de28d9522b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9510

Enable the Bus Lock Detect feature for the EPYC-Turin-v2 CPU model to
match the hardware capabilities of AMD Turin processors. This feature
allows detection of split locks and bus locks, which can cause
performance degradation in multi-core systems.

The bus-lock-detect feature is part of the architectural capabilities
exposed through CPUID and should be enabled by default for Turin v2
and later CPU models.

Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
 target/i386/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 12500d6b7bed..660b9c2a98b6 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6748,6 +6748,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                 .version = 2,
                 .props = (PropValue[]) {
                     { "x-force-cpuid-0x80000026", "on" },
+                    { "bus-lock-detect", "on" },
                     { /* end of list */ }
                 }
             },
-- 
2.43.0



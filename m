Return-Path: <kvm+bounces-19499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE53905BBF
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:13:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AEABB25D40
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB499381AF;
	Wed, 12 Jun 2024 19:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3TGHPA6f"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C18B823AC
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 19:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718219573; cv=fail; b=tWfiInLXQJkkMJYTGYTtMfDLI97v4RGojv6K53ibeA4V0MxYUhbxT+dNwYWRV4K2OsGMg6Ev6ZorhkdpUOmPTY6bwigl/eO6WvU11ACl0C81lRZJ1a5BeGVnHQyQuQUsmp4zFzRWFQ6zLONiIVC1av1udihuoHTZhTE4uWsjjuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718219573; c=relaxed/simple;
	bh=B4tksD8cZqqOOWr8eCN6k9+YCpwIbfTgZXu+o9N0nY0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fAlejrRK7NcQuP0yNlaYFNK5clnj2NjBghhDPdvjOV9bCaOPjHNolNxsnBcVKcAGbFqmkmFu+4if8/LC04QFHEwi+z002HW1CcVafdHlkXq3qIXYgedqWyHlDoUVw67vcgxO8sMb1eRMy3Lh7XKhyv4FCNViafWC06kM/Se2fEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3TGHPA6f; arc=fail smtp.client-ip=40.107.244.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaRJ+aUJJbbcOlZkG7m+xTU8O1fUtLYzS8reCGnJ96J46lO20OVgz3zmX2CW4L0VHBq4w+wCm+yHz1anC7gIEvSWdOVutubIkrhImtjrzp/kPiSHHkv/bD1rm6dXLVFqC2aKLZCGw6oBLBI8aCCrsGPdZx4uyIlqky8Y9LnhfbtrnVqItSfD+FRm8HVWgUOvIc53s2csnV+QvJHw4tr1v8UAhNCXvbDmSi5jbztqc9bq1U/8//7XUIoHrYOVHkRdqEf4Gw8nooYyrJkkd6fE0Re9OQx9n4ZnV1w8Nx0C1BF1BD11JtFr5TIHn+LCjwC5LPpyCAqbu/hFCdUeT95agQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykuErh925Bawa9JzeJNSiMPO045peBhyieAwIUdC7Nc=;
 b=KYNrLUHYBvNTLpa8dVHhyKoB/CASWdmHvPZJd7tieim6UVjcq91vvjzFhrEpqt5gmCueDTgCjdUgsi3JJZZTqxoCQhJIWC1K7cfDYqJheu7j6vHc3J4td+T1ZzU6VCFwbo+H16mgQqVM5tjeJeYvxl1rehmM+TCnPfuASxy9yaoQml+Dq0YPy7JLXoynC1a3yTqDbaDg7fEMtA8QaQKJVzC9h9oNq7OPtLnluMHrIjtgOG3v5Ro5ECjF0cKa1jcnVt//N9TtLRQ9fV3rejbXCyGvMgxKdppS6tvbbSKJS7rQffDTR8DpIEYIex+rOoOS5HGQFtf7Mi7WDD4Uyacq5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykuErh925Bawa9JzeJNSiMPO045peBhyieAwIUdC7Nc=;
 b=3TGHPA6f8Cv4162tRDdN5zyaSlvZkxWlICHNjDXGnL94wd36Yk3BrWQOhhgrhMgil9UFzqpWfveAGe1bs/qKmtsF+Sz5kg8uet1fVH45bhZJT0VnDpmkSz3rsHCfCT84jEGPsoghF4Yeohn/zrEee+B3g1RhYJ6No8sgVsv3RC4=
Received: from MW2PR16CA0009.namprd16.prod.outlook.com (2603:10b6:907::22) by
 MW4PR12MB5602.namprd12.prod.outlook.com (2603:10b6:303:169::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Wed, 12 Jun
 2024 19:12:48 +0000
Received: from SJ1PEPF00002314.namprd03.prod.outlook.com
 (2603:10b6:907:0:cafe::20) by MW2PR16CA0009.outlook.office365.com
 (2603:10b6:907::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20 via Frontend
 Transport; Wed, 12 Jun 2024 19:12:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002314.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Wed, 12 Jun 2024 19:12:48 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 12 Jun
 2024 14:12:46 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <babu.moger@amd.com>, <kvm@vger.kernel.org>
Subject: [PATCH 3/4] i386/cpu: Enable perfmon-v2 and RAS feature bits on EPYC-Genoa
Date: Wed, 12 Jun 2024 14:12:19 -0500
Message-ID: <1dc29da3f04b4639a3f0b36d0e97d391da9802a0.1718218999.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1718218999.git.babu.moger@amd.com>
References: <cover.1718218999.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002314:EE_|MW4PR12MB5602:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b2f0d76-0f96-4b07-29e1-08dc8b13a5f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230034|376008|1800799018|82310400020|36860700007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DydfD9/YMEwV5DQvmXw+yi2ViOy9KdbKopBz2oGzVni3cjmzDiKnmJomBsFx?=
 =?us-ascii?Q?cQSUS6XvglyU23Rb3ZfM8gUjsEnpoRCBRKD+BU5F0Ixz8bpvIOCOyYzZE2BF?=
 =?us-ascii?Q?1oYJECpRfuTj7tP078klkmzVhhPnpR26+jtilYfADXVx8W7vlsBMYltKUE9w?=
 =?us-ascii?Q?ppSMp1cT7wexE9a6hASPfzhs+QRfcbP9VGSWMRBlA0hvGD927qBLNyOXiyFf?=
 =?us-ascii?Q?h/Xqz/GT6BkDGdN0wsEAXgisv/ikbmOHCTQ/9eYxUOr3+qWY5OHWjk3ka8Az?=
 =?us-ascii?Q?DZYj/I0uQxQo7VRjAavdrHL4Y4Sx9I5oagBX6MMv7knmsRMXFnocKbq+HHmr?=
 =?us-ascii?Q?GrwzKT2jfP7WpdXDZq7ljlRVNLpE84bZisjpG4AE9Vj/uEXB+wdEExW5HfMU?=
 =?us-ascii?Q?+IV5WjuFJKTYBmxbboNMNoCJyisNDy45Y2hc4TdPaorcP725mim+Arieu6ET?=
 =?us-ascii?Q?3It5Yn/AaalkJjW0WoW15xmAHjqyqKUofSegT+savOeC+emwuljN32Gpqiwh?=
 =?us-ascii?Q?yJMy8tTBsUNsMj5rDJYJxmZE3sQriP2jpEU8v5SwsYrpumEwtU32BiSNiiaE?=
 =?us-ascii?Q?/Vq6/KzDe+Kvwf7zRlwjnPb/lZOmYQcNm6SpuAceIcLXJpNeIEPM73gRrfqX?=
 =?us-ascii?Q?mAC4cGC6cXpsvztK7Ts0/dDl6DwKBOjwd/5VkdEfoDMplrL2lwc5SHQll0Dh?=
 =?us-ascii?Q?NP/M0G4ZDDfOWOFnQELbxMhq0tmu1GMUqQYcKRzWadAseGTtTB16BDjQITuy?=
 =?us-ascii?Q?Yc3z2arE4qkkT4V9wQoxPOIApZMAL3z1380NUdma5Tfv7v1G7mr/27cP35wC?=
 =?us-ascii?Q?vLy7I0mBWwgCPvC+mHGzDWc9xdDe64NWtEZC2oJCHPx6v38jIBOWYaVtq2xK?=
 =?us-ascii?Q?kWM21n34GDH2ddf7ReEPHDYYFno8/JdzPorHY0WVuyntGdKdoJ/qiLvqtkH/?=
 =?us-ascii?Q?BhChceLXNOpt5+uokoRTVFwTz0TKreaqORecZNU7ENwp0eAZ6BXh8f3PwoZ+?=
 =?us-ascii?Q?S0hWm/xPU4eGxXYfeX1g4S1FVQFAjJ6fZ/MJXDO612yXV3ZIHD9L+abdGJwb?=
 =?us-ascii?Q?P1WQ9E4j4mIrt2nnAFo+XWYvUyo0njzBtosyyeuKz4XtzL7ui/G7cYck1G9/?=
 =?us-ascii?Q?2jUBjZurJ1USYDDs2z9S9oqNIfSsm3BUfC0yCvVielOQEH2bhXD+xCSLaHUv?=
 =?us-ascii?Q?PnbJJr715L1R/iaHT9WRVko5fnde8xmW85wG6jtdADWRYVItUVYF++TeOuDa?=
 =?us-ascii?Q?qjdRw4DftQNM2wPqjhYCBPnCgwMCdLfcE96aUzoDR0N2Tzgr4MouP+0aN3/u?=
 =?us-ascii?Q?TYUw1UzXTuh7U5kPKh6fxgyU/xHXu48Nlfh4qFSGQiFIq07+D6kRyDza1pI3?=
 =?us-ascii?Q?lpiM//A=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230034)(376008)(1800799018)(82310400020)(36860700007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 19:12:48.1080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2f0d76-0f96-4b07-29e1-08dc8b13a5f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002314.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5602

Following feature bits are added on EPYC-Genoa-v2 model.

perfmon-v2: Allows guests to make use of the PerfMonV2 features.

SUCCOR: Software uncorrectable error containment and recovery capability.
            The processor supports software containment of uncorrectable errors
            through context synchronizing data poisoning and deferred error
            interrupts.

McaOverflowRecov: MCA overflow recovery support.

The feature details are available in APM listed below [1].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
---
 target/i386/cpu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 7f1837cdc9..64e6dc62e2 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5272,6 +5272,21 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .xlevel = 0x80000022,
         .model_id = "AMD EPYC-Genoa Processor",
         .cache_info = &epyc_genoa_cache_info,
+        .versions = (X86CPUVersionDefinition[]) {
+            { .version = 1 },
+            {
+                .version = 2,
+                .props = (PropValue[]) {
+                    { "overflow-recov", "on" },
+                    { "succor", "on" },
+                    { "perfmon-v2", "on" },
+                    { "model-id",
+                      "AMD EPYC-Genoa-v2 Processor" },
+                    { /* end of list */ }
+                },
+            },
+            { /* end of list */ }
+        }
     },
 };
 
-- 
2.34.1



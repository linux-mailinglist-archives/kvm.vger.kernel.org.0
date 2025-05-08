Return-Path: <kvm+bounces-45975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4A8AB0430
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 21:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21267504038
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 19:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F09228B7EA;
	Thu,  8 May 2025 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0S86tBJm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA77521D5B6
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 19:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734300; cv=fail; b=hDiBc9fnU+wszQYfYeBaF5Ihuje1TD1a8HzJDMWUVzAHY6LcbO5y1/w0zzocIqzPxrrPwUxpyoaEFEyqFhoCIJUzSlJI4RdUSXU5flRIfX8nu4pjvZ6CCEGeDNPoKXApRot8+WUzA9W58PJLCQTBbKG9K0utwAvggI1Gs8kCUu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734300; c=relaxed/simple;
	bh=EtbdPgxHjLRKMeIzJIxZ1bcmM2fYDYf/UMxhc/T2aN4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hPFzdIn9yT2gtjw1SEJqCWZrw9DVTivNk9MnlEShSzO8kwD8XeurlkqD2k2k+FpGW9Qxzm0CXKmlknjZSDXS7afvGqLNrthkxG/kBDYAiAMiH/Z6kLv+Kb1kwGnftD2svSYpT1iGlsFwjDThm6YzMRupnMWM2ADyyteoSvbeAR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0S86tBJm; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gWFnlR5Ii3ZOtv0i1nSD7/oSCkzmgBrz7Cp6CqpUW3JDJ3Y8V9NZ57XzxvL3+cJvGwilAJo+l4ROMdRtxD+l1ISb9BXvR3WZqH1yLeHLfs7Wc+VmB9yP51LA+L6Cy+l4GhG4tRZ6pQhzYrExIj0yzKTP9fVSIKUvpTzUQQ4Xwk4uOYU3dx1LRY5vrnuTzNlHwKcwIs7tjCiWvmZE4n72tP1ydE1p34jfB2mzKFSxHM8pHyNysST4JZkpw6YCBtalg2C3WqYPPW6APZaT9+XoTikiUPrjCEsQWfFu2yQWZCPkLrkxGS4vLIRWvvvPeboTAf5swu92ZoCrqQ60LG344A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTArx6Mys2RVs23mpZD3+xGaMla9YOvxmvCJPZFOwj0=;
 b=EDfHQ4X6ew+Ct2qHdhG0NWp13RSNxfjLfFuLlnC3mGQcVddjpVqpe8YUS5/78wSNyp0Wb1G9N0ztx23PgJ/CA9Xz0Iz63c4h5HsDiq1URSXj/NAZDQ1YgnogtgebEOlwoxKpuFB+NuvwG8FBboQE/BmjiehN5DxL+GQTjQvWYQPt/camk2dGiKFv88pIUXBSL0YlaYZ9av48s2GPKfR+JmX7VLCLJSYYqfIukpRrPLtPEYUBRkG7IfUuXY8bQOeKho1NExJibZju0no90ZR8iIFph52dbuJ/iqEVhr6P0+6SEXhKylnip5fCUC381vp4ftX6IU4mG0prSOSlbZZyAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTArx6Mys2RVs23mpZD3+xGaMla9YOvxmvCJPZFOwj0=;
 b=0S86tBJmnUc+OUfqaUg7Ceh6ggVUUmRPu3To6Z3lUkAO+FR7tY9NfMd9Ncwziqj3AcTsx3BRVovN+3VVRFGvfC9qxkJhSYYfJGY3N0PhuuFIIovOyiQudutMq/u3h3TG/ke7lretAmjmS8lZwT5UWmYq4MVGUa1PlIpk5PXPiqQ=
Received: from CH5PR02CA0002.namprd02.prod.outlook.com (2603:10b6:610:1ed::14)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Thu, 8 May
 2025 19:58:11 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:610:1ed:cafe::49) by CH5PR02CA0002.outlook.office365.com
 (2603:10b6:610:1ed::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.23 via Frontend Transport; Thu,
 8 May 2025 19:58:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Thu, 8 May 2025 19:58:10 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 May
 2025 14:58:09 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v7 0/6] target/i386: Update EPYC CPU models for Cache property, RAS, SVM feature and add EPYC-Turin CPU model
Date: Thu, 8 May 2025 14:57:58 -0500
Message-ID: <cover.1746734284.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: 42a16802-5aa4-4d41-7862-08dd8e6aa8f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MOfmwmnMSjAyDONvI5nr42aNxD+5q4tLhj/IJD61o/ETaUaqFEoEIHWTyuOY?=
 =?us-ascii?Q?Bkw7N93d3CBxw2VJUZD8dYIm0cYKa8Qgg1y30gtxwTZSFFF5oMVZpnNmad6r?=
 =?us-ascii?Q?ifQmzxGLd3pR/Y0BRdjsXm6w5BjaHvuhgDaUe90QBZOdI4grLwPU8iSz7ozV?=
 =?us-ascii?Q?NRkroCGozaKzXsMdiQb9FIB+Oalo/kBJ9QtAifrIYvTNSIxCe33NDgLQ+vcK?=
 =?us-ascii?Q?hwl7zEV7V7HVP1Og4zC+Mjai/ONPCT00IMrZw882IHMqnE9J7daJ5B21mca9?=
 =?us-ascii?Q?Z02aybm/P0ZztSN62xpDFSmg6EWnJ0QcWHU6jff2N1BKWmczIXskOzOzMPV8?=
 =?us-ascii?Q?iN9KBDS268TjAI+w9duGUDqDVxbu/3BgDCFw61xjkIn/fn9yIjCGIzHRIXHg?=
 =?us-ascii?Q?I9spe7m+H1+e3JUtasG2gvaV5L3cmaN38mzrLqoY1kYV5aCVNcRVuIucZY/Z?=
 =?us-ascii?Q?OU5e9HS5tLqutjVSEQAGcZfR48rEg5Y8IOOmCUvzLOQLk5tnxe2YYTyHkpcZ?=
 =?us-ascii?Q?/NbRIp0K+WQE+cERA3klQQI/nFjvKLNqBK0EtjOaO5OBb+MW5hplAjt+eZd6?=
 =?us-ascii?Q?eBotZLz4OmZ7njfqVy52lqW1Xtw84nNXjMu+aI4bkfqX8h0EJLXq4CuvM+7m?=
 =?us-ascii?Q?mWvcYHg2IUZrBz91IBypDXDM2q5jW6R/tW5URmuOX+ZHYC+1Zhmj5y23WBK8?=
 =?us-ascii?Q?8qkQNfkgVrlCoHFRZhvmDzUgqWglx9PXSjDwbKPn0bKJVYSD3dyW6rTrrt2W?=
 =?us-ascii?Q?BjllD4NDoyzPJiXBrQzwRCjiqd4pUIFh3j54Zq5X2bLmLy6r3gsOpHwq5bLB?=
 =?us-ascii?Q?FvzR4TXw7W3ipuZcbWrfhFTtpN3kvfKdILF2Rqh/r5laWdZ4NJuDjI9pG2qA?=
 =?us-ascii?Q?+N0hFRn2nu0jPpHsWASoLdJAREhtL91MD7K0DOyaVrmRqmxhGMR8BPK+u2TT?=
 =?us-ascii?Q?q6uuswMX3OvgqtGIkiZA/jCUZ9GM1lWNliZFyDk5Zos5TAH0MnUdBS7iEl8F?=
 =?us-ascii?Q?so+ytRrddkL+IExtCnOc2JyXGgsIcnWBkg0fpn8ItvkByAoJfzLuUtizCe2a?=
 =?us-ascii?Q?Gh22u0yitLqJodfcRqDYXJM+HS1bJGWW8H3Hkin4qqJ2AaH61x650dmxs6Fo?=
 =?us-ascii?Q?4oUcYifo4GFExZ1OcSnFxHcnquUm2XfewO4OGgeOilhCR5MWI817RNiQFlFe?=
 =?us-ascii?Q?xTGH0M2WEKDEV0W6ESCHE46FP6Kjnu3d7Siqpc9vScATAmlTAOtqBaq3mi75?=
 =?us-ascii?Q?wEx6e/5sRJxicnaeVoyR0YCCSF1roSmY9MdBdC5LfAvukGCBoUzMogjjDZ3r?=
 =?us-ascii?Q?aipl1J7/qusL0rHu7d06+SUKT+0eRigBN6IT4LZf3a0AFMG3cytWIbaM9pzj?=
 =?us-ascii?Q?BTsC1WUcqpqRo00CtEcz+qi3cfefDp2eerSjdZxBTgYRh2Jkf9/BQC/RALnS?=
 =?us-ascii?Q?Rjy7Hk7SxFS/Uo4+1I8nJSsUKD6tMjQfw5qRKGwWNvPq/LF66Iu010tx2p73?=
 =?us-ascii?Q?qCPvZTwXXVVFyc4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 19:58:10.7708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a16802-5aa4-4d41-7862-08dd8e6aa8f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790


Following changes are implemented in this series.

1. Fixed the cache(L2,L3) property details in all the EPYC models.
2. Add RAS feature bits (SUCCOR, McaOverflowRecov) on all EPYC models
3. Add missing SVM feature bits required for nested guests on all EPYC models
4. Add the missing feature bit fs-gs-base-ns(WRMSR to {FS,GS,KERNEL_G}S_BASE is
   non-serializing). This bit is added in EPYC-Genoa and EPYC-Turin models.
5. Add RAS, SVM, fs-gs-base-ns and perfmon-v2 on EPYC-Genoa and EPYC-Turin models.
6. Add support for EPYC-Turin. 
   (Add all the above feature bits and few additional bits movdiri, movdir64b,
    avx512-vp2intersect, avx-vnni, prefetchi, sbpb, ibpb-brtype, srso-user-kernel-no).

Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
---
v7: Rebased on top latest 57b6f8d07f14 (upstream/master) Merge tag 'pull-target-arm-20250506'
    Added new feature bit PREFETCHI. KVM support for the bit is added recently.
    https://github.com/kvm-x86/linux/commit/d88bb2ded2ef
    Paolo, These patches have been pending for a while. Please consider merging when you get a chance.

v6: Initialized the boolean feature bits to true where applicable.
    Added Reviewed-by tag from Zhao.

v5: Add EPYC-Turin CPU model
    Dropped ERAPS and RAPSIZE bits from EPYC-Turin models as kernel support for
    these bits are not done yet. Users can still use the options +eraps,+rapsize
    to test these featers.
    Add Reviewed-by tag from Maksim for the patches already reviewed.

v4: Some of the patches in v3 are already merged. Posting the rest of the patches.
    Dropped EPYC-Turin model for now. Will post them later.
    Added SVM feature bit as discussed in
    https://lore.kernel.org/kvm/b4b7abae-669a-4a86-81d3-d1f677a82929@redhat.com/
    Fixed the cache property details as discussed in
    https://lore.kernel.org/kvm/20230504205313.225073-8-babu.moger@amd.com/
    Thanks to Maksim and Paolo for their feedback.

v3: Added SBPB, IBPB_BRTYPE, SRSO_USER_KERNEL_NO, ERAPS and RAPSIZE bits
    to EPYC-Turin.
    Added new patch(1) to fix a minor typo.

v2: Fixed couple of typos.
    Added Reviewed-by tag from Zhao.
    Rebased on top of 6d00c6f98256 ("Merge tag 'for-upstream' of https://repo.or.cz/qemu/kevin into staging")

Previous revisions:
v6: https://lore.kernel.org/kvm/cover.1740766026.git.babu.moger@amd.com/
v5: https://lore.kernel.org/kvm/cover.1738869208.git.babu.moger@amd.com/
v4: https://lore.kernel.org/kvm/cover.1731616198.git.babu.moger@amd.com/
v3: https://lore.kernel.org/kvm/cover.1729807947.git.babu.moger@amd.com/
v2: https://lore.kernel.org/kvm/cover.1723068946.git.babu.moger@amd.com/
v1: https://lore.kernel.org/qemu-devel/cover.1718218999.git.babu.moger@amd.com/

Babu Moger (6):
  target/i386: Update EPYC CPU model for Cache property, RAS, SVM
    feature bits
  target/i386: Update EPYC-Rome CPU model for Cache property, RAS, SVM
    feature bits
  target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM
    feature bits
  target/i386: Add couple of feature bits in CPUID_Fn80000021_EAX
  target/i386: Update EPYC-Genoa for Cache property, perfmon-v2, RAS and
    SVM feature bits
  target/i386: Add support for EPYC-Turin model

 target/i386/cpu.c | 439 +++++++++++++++++++++++++++++++++++++++++++++-
 target/i386/cpu.h |   4 +
 2 files changed, 441 insertions(+), 2 deletions(-)

-- 
2.34.1



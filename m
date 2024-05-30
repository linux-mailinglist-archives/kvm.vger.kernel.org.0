Return-Path: <kvm+bounces-18419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46ABD8D4A4E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:20:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1CBB2826AB
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DD9183A83;
	Thu, 30 May 2024 11:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wLeSwyiJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113691761B5
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067834; cv=fail; b=KmFF81kOAIVUx5f23VCGMDln48VrEib1fO4wwOM1V5VFPRK4gjsVzeT2PU/enjmcElk4TnKy9xYWXAiTrN2yNFTe7n22ZwffTUuHL7YtCID8QJSDip/VbhkkbHi5JNWXZiuUfyyS4NPHiS6UhJ1aCG7Vw2yfDir/PndN6keSqxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067834; c=relaxed/simple;
	bh=9jfMN3s5bvjUBXFdYLCJGS6KPMm7ep5+iB1uVWumy9o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NEPkQv4AX2tI0CokClk/2RP6zMzlxauoQQDVTOXr0B7nDTTmeaZ2N2ChfF8U4c3xDyZ2OFW9bwd7W7c/vjekLnIkjKeX39+fGvTnDVHE5WudZMZY0EUsalgCk7G8ExdIYX1rogMukvGWmIAaky5qjaX2drvZ3xPJU557Ja/oc50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wLeSwyiJ; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRTqGNfZsv/yiaSCx8CamY+5hcv+ObNtLHdFUKRwBO575RfKBZxDdGHaMt4A7U6FKgnOf8kPsSW+vkW0YIgBY5kyez7znxoM6LUMrIRS541IdtDcKpbtopP2Ua+fHqOdQsMx9S8gdlAcc58xu8OntICcdCq4vymq5DUIcfukRcjBHbNcdz/tam2/Ud7XkZGj9zD75UCLqv2z0Lv6y8OKtxHamvuSqirsAHW8YipPGDc0XyQxwk6RJg2LBC6gAvxcv/vwfDElwc/8weCYzJByrNMY3VyJBCh2U+bz0Z+X+jfLVXXDym3WBYlJidx52lobf8BcpC3A/qUMzY8murjWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30NN+Noba7skJcAXk9WnPHE7RGKVP305PPHVASSr+ys=;
 b=FupDqEpbOUHr0trDtWnoXUKLyTi+qG3d1s/vdBthPV67lEbrueGdQIJ9mkgqmYTI5zoifsw/l2zwsg+YFn1tgIMk955bGpgMVx7SCdulxQwkehPfcLbcEtB1WaxzlLKiwvQmhhYNSeBn/Y/27Xv1XEOIqkuzmayULWG4mN1cbxJGauJ9+mIH1K1JI/pdYc/5QfC1B2gfbyck/hiEOXwbzPkESjpKj5YyzSk6nCtxw964PwxR+1Xyoyp6Lop3sAJPjGAaja7T9b8NIXLEDDRr7iF7iBGL3EqDD4Thp3ry4XJY50gU3dk/mJwMWkFGpb2Ix4E+hQUOVi3KnhmHLtgT3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30NN+Noba7skJcAXk9WnPHE7RGKVP305PPHVASSr+ys=;
 b=wLeSwyiJIUXkezFTuPwxNV1qz6k7jhNd07Lm2s93w7gkbYrQA8I0cMLOOqVOagQgh6qaJ799j4XnvwyZ/1nqhynEKG3V04CZXfWBlYZDKwu7gPwWFGnPlAlw0sa4hLLYyTV8qEW/jJBluUD4TO7HA632ceJeP6gj6qch59oGm74=
Received: from BN9PR03CA0566.namprd03.prod.outlook.com (2603:10b6:408:138::31)
 by MN0PR12MB5809.namprd12.prod.outlook.com (2603:10b6:208:375::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 11:17:09 +0000
Received: from BN3PEPF0000B076.namprd04.prod.outlook.com
 (2603:10b6:408:138:cafe::96) by BN9PR03CA0566.outlook.office365.com
 (2603:10b6:408:138::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Thu, 30 May 2024 11:17:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B076.mail.protection.outlook.com (10.167.243.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:17:09 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:17:03 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:17:03 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 31/31] i386/sev: Enable KVM_HC_MAP_GPA_RANGE hcall for SNP guests
Date: Thu, 30 May 2024 06:16:43 -0500
Message-ID: <20240530111643.1091816-32-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B076:EE_|MN0PR12MB5809:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c85b27c-01a2-4ceb-83b8-08dc809a0bf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xtgjdDYCcJBhveDNUVV25tdKaoAVxQkKpUS3VWn5V7AbPW9SRx14iV/vcm9W?=
 =?us-ascii?Q?vM+sWBELdPR73TIIM/MyuvaELO10wSV5PjTovQTaqX8PpDpV/+Lb063+caZP?=
 =?us-ascii?Q?Wx3ZqIMkwWPAAm716js1JAcBcXXWJ2u+cizl8NVkFW2OT56jzFt2ZUqPS8Ts?=
 =?us-ascii?Q?RKqU5GYjts/WPPv2jxPnXpVQ5WRUscGN/QaHOUvKoCbmS4oMFpBW2Eh/ZCrD?=
 =?us-ascii?Q?/OF+YGKBPSAX4menWOyzDHgOHm9kiV/zOGgTXjTbZ33mvKSRByVdbyTs2p38?=
 =?us-ascii?Q?MfRCt4ags1oRmEQCgq94HkIZ9KnMr8Iy8mDcOaPalzIQVwhy4Umwd8wuoCiQ?=
 =?us-ascii?Q?E7SC0DC3L/l5xJqAj6PdOaatRhwl9eyLGyLsYgn6+9G2d0xcbPUsp/xo3J+D?=
 =?us-ascii?Q?rSs69X3yK86yMonFCARap2fDGpSpyvJYocYsiwsyueCG0JvX6yBsPOX/uAYL?=
 =?us-ascii?Q?aXvkKErcBMChLwRD1iSEyH6KcaDxGsWqaD4ARlPAzLXC6VMvQNLpjuHFN+ra?=
 =?us-ascii?Q?GduYfycfEEjUyAdJuK+CFRL0Uw9jIl9tcuRzsxt3d80z+u2+I57GxNglou0E?=
 =?us-ascii?Q?5HGJc5cGIEWixrZw9+8cL+qL+aP85W0m0h0aT3EbdI24Rt6Ht7LuHrL9ioVG?=
 =?us-ascii?Q?vUdRdERSh5Dq8FoO6kZONgzGhh1vPnjiSUDZsNvbGVVaKtgOtSOs08SJv1eB?=
 =?us-ascii?Q?EqEpgZAMaMCsSkJhqFn96YL5ryYEEEjzrPmdONEBb8/dVGsLu3SuQOr+4loU?=
 =?us-ascii?Q?XnDqgfUlpSdmzf0PnQwH0c1OJZUix1cuj4aN8Ihr9Iw+3UgdzCUnIcukGmas?=
 =?us-ascii?Q?uV8kmC4s8Zudn5HdLMdQumynxy3vtS9KmUQZrgid8aDWY/RHp5QGwLDxFdz5?=
 =?us-ascii?Q?UkI4ggNLN0OCoPuq9Usre+LWOTTcR0ow4Hhd38MeDQ9kjeLubXE/Atct9upw?=
 =?us-ascii?Q?3pgjWUc6gBjOnd89Ubenkx1kxp4tdJSIAg02+cnrHlWKZ4tXLRZk7IFQ9dXo?=
 =?us-ascii?Q?+Bb79AsYKL3w7ZcOAHKEFCFg4JIdRjianEQHZx7f436Z6QGjIEjD0snLbs1m?=
 =?us-ascii?Q?JJVc1qnxyiy0iEZl8O8ZzS1VBvXM18DGSlQ/j1WDZ+YDmW1qqf85qf6yWUbT?=
 =?us-ascii?Q?RLS8iYrqm26nBrqhoYi9yrSKg80DEUJVDDtoMvynwOfqR84MFzq1xCi4hp97?=
 =?us-ascii?Q?nC5qpFDbR2ZoUfZCw0hzbTsc/crC6VstXLmqdazVEsERishjOvKiKIrjBwwZ?=
 =?us-ascii?Q?/NLIW/jRMA2DSsjAgMevcNLwPCrwzdocOzfD8o6uzh2PvAsSRh2G2AnSFWiK?=
 =?us-ascii?Q?nhiDKej6W3BpAWeEhyTRsXQ+BqV7JjL3/vu0QhU8nK4RWqxO7KF7chYJoYoq?=
 =?us-ascii?Q?ieH20tFXep21Awr+M1YQuztYpQbd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:17:09.3322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c85b27c-01a2-4ceb-83b8-08dc809a0bf6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B076.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5809

From: Michael Roth <michael.roth@amd.com>

KVM will forward GHCB page-state change requests to userspace in the
form of KVM_HC_MAP_GPA_RANGE, so make sure the hypercall handling is
enabled for SNP guests.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 7d2f67e2f3..c1872ce3a4 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -14,6 +14,7 @@
 #include "qemu/osdep.h"
 
 #include <linux/kvm.h>
+#include <linux/kvm_para.h>
 #include <linux/psp-sev.h>
 
 #include <sys/ioctl.h>
@@ -774,6 +775,10 @@ sev_snp_launch_start(SevCommonState *sev_common)
     trace_kvm_sev_snp_launch_start(start->policy,
                                    sev_snp_guest->guest_visible_workarounds);
 
+    if (!kvm_enable_hypercall(BIT_ULL(KVM_HC_MAP_GPA_RANGE))) {
+            return 1;
+    }
+
     rc = sev_ioctl(sev_common->sev_fd, KVM_SEV_SNP_LAUNCH_START,
                    start, &fw_error);
     if (rc < 0) {
-- 
2.34.1



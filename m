Return-Path: <kvm+bounces-13023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FCD28902EB
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 16:22:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C60EB22DF5
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 15:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC23012F59C;
	Thu, 28 Mar 2024 15:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ndHp3OVR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5955C2C6AD
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 15:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711639309; cv=fail; b=pkO0lgNtQUszkD5LPYPKjrOsax2VIcbXgFq5ZTgCYJP+mhO8kchbnX4Nfxngpi1IoehdcbK6gX04AbsUvzT5HQeQqBrVXEpoB4Pdi9hRPfM6NClScCavTrQlhoGGQ8+cj5Ym5xh/na9enR3clKnQQKj2FCckUVibbjrhl67OmhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711639309; c=relaxed/simple;
	bh=foaezEub8w3w4KRjUpDjY3MwvtuJonm19FbkVaFMylk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=snSkWp2y+rNrFsI38QlK8FSUrGlNyCCYND+/E0mXAJYMzAdo5Oiu75PlRdiuvtumPS1HN7gkq8h99MeukzrdKdY64qc229VmcKcDnC96DSjglRAhQu6DAsQh9SPKAwgRMg9bx6y6x2QNBuTzXQVJjzqAIOQecWZTktQfrVKRZcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ndHp3OVR; arc=fail smtp.client-ip=40.107.94.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlLZD/zL3LstQj3Q/z4etcoDPSMnG7OsBp5vva8rQEbhTayyYbJlXDgnKrNVRbXPAtJDhd7ij3tgwRwMNHA2lrQt3jTHAZx9d/sCcj8SMEZn+qqnAWNKQ/iSrE8MBA5A7H4FlcqkeULgvBBAOVXPiGl6lUzEvcVVOBFwrdD+AW274mjqtPCmqqeZphz2RYH5mGHUvGpDg0mTFLb5ZRMVdH7TLz/7VlVDq561EA+NuuIhSTxoWE2dIjqlOqgzIgsLNnS5DTUl0Ys2tBzzNTE8VycvGeaJDr+xXiGWVTxa9gxo5tJ39sjJsCp1Jj5WNC4GAOL8CO98JB1LNAGO8g9Cqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnlPEo1cI5ksYjx05NMY6ADOjb6SbbZErbEm1jgDg98=;
 b=ZxHT+mb7RBJ8Yhi5YpAADSNnQSo5UMqJHOkOLnKOwATPVbLL+TZ09x4Y3bEqApr38ZZFtElYq3XTLylQOLKxAyt70P8X+LWlhzyfTOul5QToOn137rZM6amgsAx4panzGL86Xcab4+U2Yf6Gi8fMsBMUuk3wW/ZihuJ26yPbEgr3PsGk+eLoOwr6ABMOWAggKf9YAl9O8KFSLVLk/0Hnp6txXI4+pJr0taLAMvr8m2uWZerQuLFbJy7CHyVteeb2UhHbilVdZt5YgTsbqt22Ols+DwsjDAoJtCMqMHoLhUI+7Ed1DUxm24MkCRLX2M+CM0D4zGX4uv9BZpC4hSZgQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnlPEo1cI5ksYjx05NMY6ADOjb6SbbZErbEm1jgDg98=;
 b=ndHp3OVRT2D/hxEDX80sdlPgilvuyeD6yXahQi66EpFq5v0t+7vtWABw7dHI5L+Qj4zUamGhThhx1sB3B5i8sflbxBttwZvUTPITxGmTVaUG3IZFh13zS5eZ9oRKdoiMOedz2OUkoqV3ycjlfnnrO5chbBruTn9DpQw7djCqRsk=
Received: from CH0PR03CA0095.namprd03.prod.outlook.com (2603:10b6:610:cd::10)
 by SA1PR12MB8885.namprd12.prod.outlook.com (2603:10b6:806:376::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Thu, 28 Mar
 2024 15:21:44 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::36) by CH0PR03CA0095.outlook.office365.com
 (2603:10b6:610:cd::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Thu, 28 Mar 2024 15:21:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Thu, 28 Mar 2024 15:21:43 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 28 Mar
 2024 10:21:41 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, Pavan Kumar Paluri
	<papaluri@amd.com>
Subject: [kvm-unit-tests PATCH v3 3/4] x86 AMD SEV-ES: Set GHCB page attributes for a new page table
Date: Thu, 28 Mar 2024 10:21:11 -0500
Message-ID: <20240328152112.800177-3-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240328152112.800177-1-papaluri@amd.com>
References: <20240328152112.800177-1-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|SA1PR12MB8885:EE_
X-MS-Office365-Filtering-Correlation-Id: ef3c2055-f5fe-4ff6-3fd5-08dc4f3ac6ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Kix4FbbmL7qaoy76RnYVcbLOlZz+VbAncYj2id46iSPmizYnbmqeI8iYhtpnx+hxifgG2pZ7maZg8Ge67cvN+s7sCQ3l9OKORCXtLUysN1zTpcCdQc4+bIECcQeiWmJGaWL1M8CHp9PUxlPh9K9eXjZMJZ2/uEhngFzbWNkLgYyPmf42fMWWBwuvmcOObBytaRpoRe9w2hZa6NkLSBCWisVvpYJGaDrLbpHdc6o/7CT6YSnu//Btf1KFh6ugnWccjxnmOTAlWE6nXAXdGkDOiwhhbRB8qtCAhHI5ARgkQQY6morX2dpusURyJGeF9+FUBznYXAv+/b9vi2XzVxgExt+eaAFqblpNW92nNWhEuuERwxkj5f3QMGzv9mFRFDKj4cjFsxSSUHXt0jlW043mlqdlMqMui3Q4EfSpwq/YtbB1RkVulM3Lu2ioDyyuxQMfv5Qz5u9VVFTzBfb2MR1WPxuwcFogicrWGe8Lsl/XIhc30+NZ+fU/aEA5tvo1Yk2j7TzNBwgQbPO/ahxkYK+sqlFuFqzsdp6OHaKbwq6+oalfEkxl2CpadPovMEF89ltAwLd9Gt6GpSZ/Q2IhKEuWD3KzmGHw63o5hXRZ5BtISC/jjKTq0+/XgFKbH+DWu/YuhzZJXx8WK/EGYtQ6B2bigVNRf+8QtDsjZ6Kx1uwDcB6hX/jV2HLJpzFA00VIkGJtmO5Dc2Gf0d1N63juVSL5yYklnujY9kr5UTyHSEdv3kf5BcIXnF8naXiw+X8XOH5q
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 15:21:43.9935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef3c2055-f5fe-4ff6-3fd5-08dc4f3ac6ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8885

SEV-ES/SNP guest uses GHCB page to communicate with the host. Such a
page should remain unencrypted (its c-bit should be unset). Therefore,
call setup_ghcb_pte() in the path of setup_vm() to make sure c-bit of
GHCB's pte is unset, for a new page table that will be setup as a part
of page allocation for SEV-ES/SNP tests later on.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/vm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 90f73fbb2dfd..ce2063aee75d 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -3,6 +3,7 @@
 #include "vmalloc.h"
 #include "alloc_page.h"
 #include "smp.h"
+#include "amd_sev.h"
 
 static pteval_t pte_opt_mask;
 
@@ -197,6 +198,11 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
     init_alloc_vpage((void*)(3ul << 30));
 #endif
 
+#ifdef CONFIG_EFI
+	if (amd_sev_es_enabled())
+		setup_ghcb_pte(cr3);
+#endif
+
     write_cr3(virt_to_phys(cr3));
 #ifndef __x86_64__
     write_cr4(X86_CR4_PSE);
-- 
2.34.1



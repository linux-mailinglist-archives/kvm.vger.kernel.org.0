Return-Path: <kvm+bounces-12713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D9B88CB0E
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 18:35:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7B743237DF
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 17:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3378C71749;
	Tue, 26 Mar 2024 17:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TUrTeuFL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D094C1CD32
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 17:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711474498; cv=fail; b=q6cRrBNedJjoxc+HDU0rX3ubbjYZq3s6A2VKLHLhJ0/emznhgXnWvEhVt4mwNqZIYreJ7vf6PYXmjpjK489bm6UQvu48YJw1k6kulyg2KhwZVF9kcKu4rC1/Fzz5VRiGxgL5KuH6ExUtzhb4Chd79Oqj9jSvGdK+C65h6wy6EzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711474498; c=relaxed/simple;
	bh=FoilVzfWr4MAehofgksYR0krpj8svqHfS8SNRCVDmnk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JvBCR18ZzsLgMOKwFd9BkWUOlp57JzJZSbjk4it/wDhcqUETdrpIp90dYi+UjxGJ/5w6bu+AEUXU/n+NN9zHgdCZJbiXl2nQ2sFxO5ByKyIvS8xN8DA8fIGCmBKvLnnx8RHvpvi3IuoAq4QrmC8GBqZnxYv3RG45Ka+F27yyd8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TUrTeuFL; arc=fail smtp.client-ip=40.107.237.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/1kAZjDUvvUi3hE8cFgODa1jLW9ukP7/Hq6nPC3ilEPFoL4tNfCmnUzocAxrXgizrdVD97cZfZFc+pCVQVZr7QFTnYACHpBYCRz9Qye71LsGHfh2iJ4MpOl8nKeNT58VduZtQfNYAWb3d8E4fmh/xsWOR2HThK3T8N8ivt6dImPbAtQlMBfVWyORPGheGBrMyIxHu0SuhQ8tNWVcre0Bx8hBu6nj+PXyMqoZWZ0fpUL8Zn3PuN/wVGbZHCKnWVxzEemMChNZe6AclT7I0Auyhis5HCZ5XticL1i7Pdorg1QQxzNx3e29UmoViaC2UJpoLIAiVo1rusKoJX6QdB7Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38GtvsUbergKtNwWt8qv6uxU2WvNf8p6l32I3typL9U=;
 b=mXovD25tfCd9f1XwKKS8S9g04TP5IqSynEnpFd71yliw2D7an/A2TnSbsbw40M3A3jYLCrGaNF27KQjWDUKBX77V5UdvaheHp+iyHkUkqoWDHQiMWWGGrLJbfY0zrfFB01z4vd3vUgho2uVG9BZ1SItj2ZJIgYIEF3rhJ5g8wAngxJipzSgtdquOuA7Mok+ASfKJxg/S2efg7xc22kK2vNJg90R7uOswqUInkC5xzSykBmgQhrjHTN9uoMWZtKoSUp2aPTu/1Ym/JyuP/P4EYOkEH72RqzOipSwi3jSRz8oVVHpDjy7XkmMGe/7Nd18FXjQC29gAsWKDtM8HTMzPqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38GtvsUbergKtNwWt8qv6uxU2WvNf8p6l32I3typL9U=;
 b=TUrTeuFL/g4pB6fpRwc0eHlXREY/m07+e3tnqn4QqR1wpXnK/0CNKKdh2NhfZqzq0O3uJcopMv9UV5rjrbV0PKjXj0M2qZYAMXWGczcXd0hWTFK5XIbb76mFq5PkPo1xbI4U/ee2kMunfvyQbSTUrzcjCYajg+dThnOr/08mACU=
Received: from DS7PR03CA0256.namprd03.prod.outlook.com (2603:10b6:5:3b3::21)
 by DM4PR12MB8557.namprd12.prod.outlook.com (2603:10b6:8:18b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Tue, 26 Mar
 2024 17:34:54 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com
 (2603:10b6:5:3b3:cafe::2c) by DS7PR03CA0256.outlook.office365.com
 (2603:10b6:5:3b3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Tue, 26 Mar 2024 17:34:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Tue, 26 Mar 2024 17:34:50 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 26 Mar
 2024 12:34:46 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <thomas.lendacky@amd.com>,
	<michael.roth@amd.com>, <papaluri@amd.com>, <amit.shah@amd.com>
Subject: [kvm-unit-tests PATCH v2 4/4] x86 AMD SEV-ES: Setup a new page table and install level-1 PTEs
Date: Tue, 26 Mar 2024 12:34:00 -0500
Message-ID: <20240326173400.773733-4-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240326173400.773733-1-papaluri@amd.com>
References: <20240326173400.773733-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|DM4PR12MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: 16ff3f74-7020-44b3-31ae-08dc4dbb0b76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vWg48bSWZ6UTq1Y8rpTiLfYxRZiubGWfpMe+8F3jfYDQAcpDIF5urYq3BAKAdgnYn+wl9v5Ca/86oTekp1xKF6v5M/y2azhrUcdZhF9VeciBt2hKKC3dz6Bhcwx64e+nPCN34WGdLHYu8cGKrKM81ir0onSpAdeqrzrFvcDGGyJtfmwEdjn+uoKXOM4nSiOsvz4ikN+LzbLTf6SdOUin5eS6eaGSH1OyIsYoQhjrtI+RYhH64zbFaFsb8uxaQBHpLME2clG6v65Tk3cxK61o1oN48af1T+X8AEjZmDpxlpCsdhNwC9vcUNBQgGic7gwbECBwb1ezgE0ty2KcYsOW5DYd99v6d4TccgR4UOfuNWvC26q+aYYzC3yWCsnHEwHcr+fgqVDf1WdZEbiaasNTjhexB0odztq4SzFbm+ScyOKXnYdZL16RaNbNHBJ6bZ0laEmpr/PVvw/xUyYxwIXserMg7Awg+dQlnij3z8zWSLRFr8dgHQb/ZHLtspifJ9haXN1H+g8gVreMKPJ8BVlB8l28NhTxDWhpJHsWKBD0Fybd6MMGb897vAv5u+lHbPvFVQvI1YtsHcEef87olmNa8x2UNBCsfZJFKa77vfpI/v1RK8TZ7dhvFYWtAEigwD4MAJIZz+d89atlanxf4R/ilhN/ypZuVO4mcZA0SroiRBvgW/IAv2a1FnNxyz5l2WsJZ2uWngPNyTBNUAP6IEN+ZaD9UOLlicVdEJFWli/YdlqwLMJZQN0HsIPrkDPHC8px
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 17:34:50.9098
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ff3f74-7020-44b3-31ae-08dc4dbb0b76
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8557

KUT's UEFI tests don't currently have support for page allocation.
SEV-ES/SNP tests will need this later, so the support for page
allocation is provided via setup_vm().

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 x86/amd_sev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 7757d4f85b7a..bdf14055e46a 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -14,6 +14,8 @@
 #include "x86/processor.h"
 #include "x86/amd_sev.h"
 #include "msr.h"
+#include "x86/vm.h"
+#include "alloc_page.h"
 
 #define EXIT_SUCCESS 0
 #define EXIT_FAILURE 1
@@ -89,9 +91,14 @@ static void test_stringio(void)
 int main(void)
 {
 	int rtn;
+	unsigned long *vaddr;
 	rtn = test_sev_activation();
 	report(rtn == EXIT_SUCCESS, "SEV activation test.");
 	test_sev_es_activation();
 	test_stringio();
+	setup_vm();
+	vaddr = alloc_page();
+	if (!vaddr)
+		assert_msg(vaddr, "Page allocation failure");
 	return report_summary();
 }
-- 
2.34.1



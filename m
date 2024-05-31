Return-Path: <kvm+bounces-18473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA61C8D5967
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:33:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC9D31C2345D
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1045E7D3E0;
	Fri, 31 May 2024 04:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fw62SfCM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3137C6DF;
	Fri, 31 May 2024 04:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129947; cv=fail; b=U87kEg+JP/+hNsROvyqRYUgykMMuaQMfPAm+s0Qtb2hUZSQ5m4sTRlqh/mF5g6H9C2SvuIgRL78jlp4JvDpmdvK2m5ls34FopWeRC/JylEe4Yp/jYy7ifm+4WWvOrO4c9R72y2YFR19Nnbs7oUMQoMP4KvvCkKF5L3UEfBATbBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129947; c=relaxed/simple;
	bh=1zhiSjGSs7jsDZI4Psh4cnFP+IZk2ta1QszzXwa977U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V47NSRCCejzV5fkJ9hYtfu1NfnDTCXT9LWk5GoHsy8VKMFuHuEPAWrL3quUqKmlNhkv8aP3HrHmegmV58VBEl6+wvrJGIvwoksrWTOl5MkK/wegW0qE5l0u8STTuwndT811b8V7McQQ8Tk57UGypHCGkAFc9qfhdxaYreEDvjVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fw62SfCM; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvIOBrYwryOUkwhfDs1EDdYES4tS6gthIMnKCXxVb3xENcnbatFZft2DVlbfBzrbqT8fYABO5BExVV+zW0TZfiIdel73B6fBl2ZA3uXdqkvKaPpgnRAi9MPL7o/SnYrXK8k6VLS6NuNZofK+tQdljs/Tc9ZGx3NV+3WfhWl+Q6ZR+57pi2nJ4mIfqrn9n8TMSBeNMWoYc4ekAVBnM/BAquzuOQpPlJ14NQbPn6suArOGd6LoB1mrzqMNp9Q51ZXj5nwkP+g6YDY/SVRxXfRUAmEsXOBdh9GNNSc0kZTNy2/hd2g36p4pW98nNq1Hf70HwqUKRjzq06uODMdWiugSEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HnSZtY2O9qHXtbbZoTLYC+uZpaV6FkJ1XiyN1FPbFc=;
 b=UmVy6BQDpEYjKInElzoU8dWe70BxS6qYOIs9oy5oOp3hqwm+H7/6fkCOHyu26HzBtHVGIRkhB/SYvMbcWWq7bgly6MA3FwLrFXqdx+qFzfBoRWKnW4CDoLYB/eq5iBZ1snIkhKVrUO4sfEOmJDM+MEy0vBC97Qa9yK5IbPuKMnqA44dGEZVRhniQIEPhq4bvB5R95BPNbzN6XtXqQLhmF75Pv4hkJm9XTg7n6vCtkWhU+bB6ypOd8ahwdF40U8pIwLpDD5K8/Z5DLoV8XlXvMlrk8EWN8W1uEqkHkPx6mAm3Yu2q02NQj+9hbbzOI1xGQgfNNkiIpQjmwe7IHg8caA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HnSZtY2O9qHXtbbZoTLYC+uZpaV6FkJ1XiyN1FPbFc=;
 b=fw62SfCMLgWQrgFefc7rozrqk/YNW74fx1cgHURr6dxHXCIUrxqSWeAyd1P4V/rLZ62wPKzU/1aEV/4TBBSBbvc5aUqCjKDE8hAWJaE6GbjmIiDsk6vJzwA8wtcgqJC36YDkaohYCYzg5c6lm5Kl4LOLDmkLCyB5dS7ONRcT4uw=
Received: from BYAPR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:c0::39)
 by CYYPR12MB8749.namprd12.prod.outlook.com (2603:10b6:930:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 04:32:22 +0000
Received: from SJ1PEPF00002321.namprd03.prod.outlook.com
 (2603:10b6:a03:c0:cafe::f9) by BYAPR05CA0026.outlook.office365.com
 (2603:10b6:a03:c0::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.9 via Frontend
 Transport; Fri, 31 May 2024 04:32:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002321.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:32:22 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:32:16 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 05/24] virt: sev-guest: Fix user-visible strings
Date: Fri, 31 May 2024 10:00:19 +0530
Message-ID: <20240531043038.3370793-6-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002321:EE_|CYYPR12MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: 18ed6612-80b6-456b-0b6a-08dc812aaa51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3of65TlsTTS7fHt92R0FJ8OuZlFJ8o1zhFPPmHvGoAi7VfPwGkEeysFzQlr1?=
 =?us-ascii?Q?vNsoY0u5yezX18hU9+8W/3G7RW2GAXch+WEkGx7/PwzlK5xR0iaD5EyRKb1M?=
 =?us-ascii?Q?JVb9X9Dw3n81i8L2uHfRprBPB9DrRvAiWysewmr65DEGguYtNMVqfzfetskJ?=
 =?us-ascii?Q?14Ar4urrJAHRT6c8PDlDhpnOSp8unmuGW0XfKDRVUfQNI+GDwe0zW78YGYuJ?=
 =?us-ascii?Q?y576wVJAT3JOJe3e+8CH8SGNuuus2d/zFhBUE7m0IIF5XezRh/X7i8SeNn3/?=
 =?us-ascii?Q?DHlzLJoS+tAVL/f4F7xmN7gkn5tp+6lpDYpZ3yZHwdwRLfc/XRzuXQ0wZuZl?=
 =?us-ascii?Q?jzgiVvkdcJFGEMHUY4yokH/whPqkcuxOX8Lg3rScbXzQroHWtlcezXqpERXR?=
 =?us-ascii?Q?DQrhHMfYtZQUO1ORjGeUL6qCDyg3hbZDwXsrYyIbgVvWqHyLWrBxcWU64wIO?=
 =?us-ascii?Q?BS+eGCIKSMgvtAYXpt5yYjJqXnkxdbvz+E13uGCiX3xBSFhjShgZNO1fS+1V?=
 =?us-ascii?Q?czCg0UCXPaDMKAncx9xAGUlb1jxCEDbqvN/E+/jMqyRc3hk7JQiOCTWskujy?=
 =?us-ascii?Q?Fkm2eYkYpeHJB58A/lr8xZtPl59D35hj8qttF8SQgsOfEj9pojKFpxQzCtkJ?=
 =?us-ascii?Q?m3FEE5t90hBBFd8LLEi94fAWJ2tUQefbSXQOqfJKC1yRtqHmgq3zC8JbZw2F?=
 =?us-ascii?Q?lJ9dMD0LKr4EncRgGTtu5UMktf/kmt/ygYDfuClVk42CAQoaEKWjN8v0ZyYA?=
 =?us-ascii?Q?uA3R0aFs6TVgmf6esCIByTQpohu1PUrxiXR3tsjTopmq1uXKY58lLUvg3F5F?=
 =?us-ascii?Q?paXbfUrZbwDbUE56J763/q9v+pEwil5pYbKPG9sjuQllN+VTEVtcn/u+k/47?=
 =?us-ascii?Q?5+oex2vV2jpomo1NeBRg+MuM6d6Iy5vCOUybRYVP4b2InBlSpu2rFHXj407R?=
 =?us-ascii?Q?Oyf8CeRz324klGuVk9A5s57Wv8BCuJOky6KjwHPkrlLiFwra9jG+/A30Sn8u?=
 =?us-ascii?Q?ayu8xfcoTsk+vFdp4FvRetcH3VrBgZZImQVl0D3sdykdfZPTWa3/NCoZE0DO?=
 =?us-ascii?Q?m7Ie0JEJ6i5hBMYqwnUx5p9y3LAJklMZ5g4SXlYfjLXWzJSa2mIXkmtXPtiT?=
 =?us-ascii?Q?t7sPD674Z0ZwMJeaGi4FlbucdydhqlFAIUIjDEg2RDUHeTkm7v0ovZo2PxcY?=
 =?us-ascii?Q?x7ECQ5DMKo1xCtUoygTFFvX4kjSS3g9ARYf3DNyKUopviua/2TTX1YHfywdo?=
 =?us-ascii?Q?aDGoMtWPYp8QuWh/0DCAeQRchpuasfnxV+jDgbP//Zyeu+dDMnuHHpx24P6H?=
 =?us-ascii?Q?YvDsToc1K88+S0v31ebpGxcOdUf7RZ2fx0r8IigV7jCLzf5Rmy2W9jWS+6jC?=
 =?us-ascii?Q?gCkKXEQDWzr1TawxC90uj4d6Dc0/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:32:22.4565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ed6612-80b6-456b-0b6a-08dc812aaa51
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002321.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8749

User-visible abbreviations should be in capitals, ensure messages are
readable and clear.

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index b6be676f82be..5c0cbdad9fa2 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -95,7 +95,7 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
  */
 static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
-	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
+	dev_alert(snp_dev->dev, "Disabling VMPCK%d to prevent IV reuse.\n",
 		  vmpck_id);
 	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
 	snp_dev->vmpck = NULL;
@@ -849,13 +849,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	ret = -EINVAL;
 	snp_dev->vmpck = get_vmpck(vmpck_id, secrets, &snp_dev->os_area_msg_seqno);
 	if (!snp_dev->vmpck) {
-		dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
+		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	/* Verify that VMPCK is not zero. */
 	if (is_vmpck_empty(snp_dev)) {
-		dev_err(dev, "vmpck id %d is null\n", vmpck_id);
+		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
@@ -911,7 +911,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (ret)
 		goto e_free_ctx;
 
-	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
+	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n", vmpck_id);
 	return 0;
 
 e_free_ctx:
-- 
2.34.1



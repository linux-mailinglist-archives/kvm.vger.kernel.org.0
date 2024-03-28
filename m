Return-Path: <kvm+bounces-13024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D408902EC
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 16:22:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9B76B2324D
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 15:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD0F12F385;
	Thu, 28 Mar 2024 15:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4hDyOK25"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBAC2C6AD
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711639317; cv=fail; b=h/dv8DKzzY0zlFxTzdOyFVbBWLLumFN1AROez3SqKyDmMwd1whzsXarxEQR5oeKVpZ3WGc0345q6aKiNG28qwpb8kpiygoD6Hln59y1W025s0PqJ2gSiIcnxIU8UdTpij1gzCfuvKo1MoPQYXv/hkLwW5pPElWGTSJuF8k712JE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711639317; c=relaxed/simple;
	bh=FoilVzfWr4MAehofgksYR0krpj8svqHfS8SNRCVDmnk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QazJ8NfDiCH1oG7UgkYTdkpJ79G651yCjGhtoNwoz3kyksRxJRrrM2ghzwQ1JWWlkYVj8AmDCtHE2fIVcVOVqdFtPzX7Lp2eBjGrJg6pRWjHb6z157G1j36wBoywSMCMej0Mkof1KVmeLpOZfvsaV3Tammw8SWnSprgS0NWmpjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4hDyOK25; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fjfb4S/SxOFZL4rxK6UOKYz/5XrqSSO5RGtriCZoGtTPT0KEKEubwKm4T7gWg2T/aFH1YVic1S5OthYpAcKh2/MW3I/KYKljyiz8sPB9XLd58z6QET9QlfAyP5D6gZepEXxx48ITdPxaG/nRg0HY07vxYLNrfHt0EKWb1D6P5aHcl7SV66jrgK7ewkMfDalsr34KpzhxYgOFkiksaphUiE0oH8eiMh3bj2A8VPJ3IjxBUivpkU3Q4OTKDI6TOXG2w7SDaAYGXvgy3XBWkqwPr76h3HCcK3uxyGrpH9y5ipV9J2PcN7jUO4ZD/jggUvvU9frZT0MXlAw8IDalTzzzpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38GtvsUbergKtNwWt8qv6uxU2WvNf8p6l32I3typL9U=;
 b=X4BhR8kPnabwcI3aLKBYElDY8OShjD50ChjkEAACqj8viiCaNaeoqyTN6BCsbVTRf9gyNrlqg9IwhVz4eoQtQHnAK4uwSHjiVbp65Wd1+7D7Yt6v54Vj2gnhqO08e03XjX+dzy1pOYNDbdwjfIQx6riW6dwpxwCOs/+kmxhQBFkDAy+uHrepWdggcxA9NFUBgHFn76BS87Rw8ZUGrZjtdzeSL6JJrl2xjXDQPwuTlrpBCaw8yxKbyxc8jcmEw2eLl0Z1mOJDm3iByewnMVxO6r8M1wLrmj24dFeX+nUHFBFMCewNj7wIcDup/RDn78674Lxo8z/fbbbyTvuRaIhMgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38GtvsUbergKtNwWt8qv6uxU2WvNf8p6l32I3typL9U=;
 b=4hDyOK25z7myWyoUtjoxhL7qN6859Be7LWot7x1IPquhvecjLxJPkRr7MlupQ3Dp0uKmrzjzD293Y1A4cBdaN/tx5TOy6Ym3ilWbVQ9uyJ59IRHnMSopqMPTwY6SMNl6gI0P5VKb5IkCMDUn1n4WAkhb7mpjNQRmUPcExqrucYo=
Received: from CH0PR03CA0025.namprd03.prod.outlook.com (2603:10b6:610:b0::30)
 by CY5PR12MB6081.namprd12.prod.outlook.com (2603:10b6:930:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 15:21:52 +0000
Received: from CH1PEPF0000AD7A.namprd04.prod.outlook.com
 (2603:10b6:610:b0:cafe::39) by CH0PR03CA0025.outlook.office365.com
 (2603:10b6:610:b0::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Thu, 28 Mar 2024 15:21:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7A.mail.protection.outlook.com (10.167.244.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Thu, 28 Mar 2024 15:21:52 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 28 Mar
 2024 10:21:51 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, Pavan Kumar Paluri
	<papaluri@amd.com>
Subject: [kvm-unit-tests PATCH v3 4/4] x86 AMD SEV-ES: Setup a new page table and install level-1 PTEs
Date: Thu, 28 Mar 2024 10:21:12 -0500
Message-ID: <20240328152112.800177-4-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7A:EE_|CY5PR12MB6081:EE_
X-MS-Office365-Filtering-Correlation-Id: 90dc30ed-052a-4ca4-622d-08dc4f3acbd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ls/XAHzmxNNkL6yhG0aI0l4erIrLrn45p1vyDSAAV8s1V66sCdUiWnV7HCrq8nNRxVOar8mHPsIZ7qy3GVmT7knfboPs0tb74IuPHGrSY/fCKDfJbdLzk3JLNGpLH6jgGv0F9DwV6F8pd+DZoX7uJjyoloQFqR8vLPhy6aOTYOaSv1QI4NPpQx3N0afRGobrCS5QOkrt12QdILVXnjCMBL7fZ0QtzhWZBNmPaOY71psZh4F8gzY07BJ8ujvkTsVcDyXUPrz0Y1NncCAj4OjkGWApe7YiUJSP40B5WkCQC+xHOIm4vj0F9e/T8mmmaKyPodjtGwqZN05a15OQrR9FSLwRNwNBKnb9H6f4BPeptUSJg/sYzMOvF/paRQoS3F7BKOOaonTnRhUBB/odVVUaoIQnVnbFme0TdVReShk4IkkPZGe+zqjbJOX6luntTqQ0QwRDjq5JQbL5nKt6Md09CH3I3+95+eaFKEQM/yuovf+1VftpSEQilJZkdnyx6J/rCQrqrQXHVKgiB654+A/kqFUqT0FnXcNdQci2ELsGKPvzpQwCTK9JaMo+JKpX+E5Mx4jp/N9o8pJjsOJ43C53LqBkC+GinORq1x7+mDmj7RtIohEBBwvuN22uY3XQYc4uMkg+rQSSB86ySjT3Rtc5VGT3blVZtQWFxtex5gx4LYVKamDLWlSojUWskr8NC/Ua6igA7k21WCIInXM5812ljYQzkBaxmMrZ0rpmGzWG4UIlHByHrRJfHR1rOn6W/9eb
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 15:21:52.5796
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90dc30ed-052a-4ca4-622d-08dc4f3acbd8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6081

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



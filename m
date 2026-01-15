Return-Path: <kvm+bounces-68199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2C3D25D07
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:45:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3B37F3025A76
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 16:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794F61C5D59;
	Thu, 15 Jan 2026 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t2M8kvxL"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012067.outbound.protection.outlook.com [40.107.200.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC8B3BC4F2
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 16:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495516; cv=fail; b=XZbzSIBA4Kwdba4YQalqIF6xMPA4XVoMW2bYaymIq+QYi4xqdg2+eOnWYnqS99am0vgjjkk/TIykIO2UR5qzKUfRX3i9jC9RAtso2gqEa3nKOKTByrKkQJy6fM7+wAKP2M0YoZbL7qFTVq3+3axI16fFTcA+ov+KN3FgwFU33uM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495516; c=relaxed/simple;
	bh=qYoSkiM9QLiAJiVfPSSa2jZ0IFnsXgdZdZpV4z/4K5k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gb2hgly51/xoU4XH8f7mvKTR3soYswx4Y1RuTjWU1WCF/hfzETcUYyotYJMJwstkr4NwOlq5oGHbyuwkO1gJg+UX0/Rl3c7PoR7sP4e5X2VNI61SE7yp2Uk+BN339JtYRvgTnWia86JlwKMpn2+ziNMgXIqABIzWUiUUdku6IeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t2M8kvxL; arc=fail smtp.client-ip=40.107.200.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=otr58ogOC5gIrSSxYm37iBQkcBlkIpTBDFmHSDp/TBzjL/+Bvnq7IQRX1YW4ZmS4uXKh2zVyhXd023IaM6D1yQ9mQa3qMk4qsCdK2tkN1duAZ6j3wlK3UI0O+j/ZymYZ+2NkaRtJoNojTaPxM+CARHDovTolRDuipqdXDJ97sVfp8f6N7FKPhizNSIonGknN3njP79fHBNfdMMz9x33BK6WB60Ijrnt5b2tJv/APCpEstQz/smZo7GCJkkoOaEqo/t+c95v4IcYnH/rCtjUK4pWwBTBadLgsAxNRt/PDMk5sGgEab6O5FNP+vKOnTKh2NVFrwgwrSyK128OCcC9+IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRysJpDIArzjEpYuE4F+Cus2EumrW7cX8I5K06PmSPE=;
 b=apTEyxaJbb1oQ1sOKS5pafa94nFtgP/YMksaVthrliMsJvChPu1dcSPPq8V8H41n14eLazcHVAiN8gOrMlFyC5Hby2mn2CjMxoNCEoLw0y/NK2ZPwEnx1nv3ld9J5AiNbskfwnqSV1ARrzKtfT31sOiumNBWzc6wMxIzcvnUnq+i7Yrx171MUrg5fk/F5mq0ZOv0FVqIoCTqt9zo4l1HefYGdowxLmsWY5qnqkFCxyUYhTK05/JuKigsxk+ZRv6Xa0MSpTi/mcjjIlf5DhyE2vMlZhQDgVIwt1VLNBpRMGVaPIchw/8h35D/yZrh88L4CJQ7Mp2JNnL5k+bVeXTaVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRysJpDIArzjEpYuE4F+Cus2EumrW7cX8I5K06PmSPE=;
 b=t2M8kvxLjDJ+ghbdUlqENbqK4zcCIx3J9FAeHoC/Y3A3DSK2NYQ2PdLUMJPYDoJIS+QAX7S+E+mxFXzs6I0HKCY9fUDoXD++IN2pcVd0WcnbDiYEq9Z4X5wOSuUCnKZSm4xAW5ailNNjVeb7DVK/gmHlItWvfz9lGXuIdty2O1w=
Received: from CH2PR11CA0029.namprd11.prod.outlook.com (2603:10b6:610:54::39)
 by BL3PR12MB6619.namprd12.prod.outlook.com (2603:10b6:208:38e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Thu, 15 Jan
 2026 16:44:07 +0000
Received: from CH1PEPF0000A345.namprd04.prod.outlook.com
 (2603:10b6:610:54:cafe::37) by CH2PR11CA0029.outlook.office365.com
 (2603:10b6:610:54::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Thu,
 15 Jan 2026 16:44:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000A345.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 15 Jan 2026 16:44:07 +0000
Received: from xcbagarciav01.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 15 Jan
 2026 10:44:05 -0600
From: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
To: <kvm@vger.kernel.org>
CC: Alejandro Vallejo <alejandro.garciavallejo@amd.com>, Paolo Bonzini
	<pbonzini@redhat.com>
Subject: [kvm-unit-tests] x86: Add #PF test case for the SVM DecodeAssists feature
Date: Thu, 15 Jan 2026 17:43:32 +0100
Message-ID: <20260115164342.27736-1-alejandro.garciavallejo@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260115131739.25362-1-alejandro.garciavallejo@amd.com>
References: <20260115131739.25362-1-alejandro.garciavallejo@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A345:EE_|BL3PR12MB6619:EE_
X-MS-Office365-Filtering-Correlation-Id: bd66a704-b0e7-41eb-af08-08de54554d15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dZb2TnuT2/jCe8OoujtG3BOqa6gs6BrSK6YAEdoc9JUekx8oaCfjac9t5xQ8?=
 =?us-ascii?Q?gvjJzpjCx1G/UPjD3ghBrdkFnWkx3BH1FAbuMcI2RoBjieVe5Hn1/YHKiaj4?=
 =?us-ascii?Q?rzkqZzjDUnt8RFi7bectxrDaIReHyHSHoxhCgt88g62gwiaq7ywkH1+HJmi3?=
 =?us-ascii?Q?sBtcu2og9TxY/e6ZCJdDBbXyUPTm8YaVcBlvKnZ9JIFsKZJiAVtvUTa8mVc8?=
 =?us-ascii?Q?Q4LrBmWBM5Xnc8Gog/n5nvUsLPWBa9BjlyseVdkUC5q+T8pkqBY+PyZKANQx?=
 =?us-ascii?Q?Ul+iW6WjlMK24TXHYQazayINWxSpJNxvj1CqLUS3h95hn2aRqKaA7YQ8BQ7C?=
 =?us-ascii?Q?t6VyjhOMSVMVJZIO1IjrQO0S/8laom8q9wsUEatpHLaqUmLbSXJanXXL+j7V?=
 =?us-ascii?Q?bRoORNfzUASgjsaT1fA8uDMj3ahMBev0QW+tHkFuNJElO0vwrbZ3htiEcE5J?=
 =?us-ascii?Q?KoQni8GpxrSsZVRcFjae1xyCZWySjImzYT47Yx9tzDHktu9dLuxFAi0P1bwI?=
 =?us-ascii?Q?1Lz1gL7a4LQ0Ax+g32LTUPIb44pdds0f9a97aY0UxpYV9pOWr2NPlXpTmSLi?=
 =?us-ascii?Q?FkFw1I9l81LP+MxKQpSJJb10olRaIrQcP+XBKn3hUwMyqNKdgPx0SYQtSvTg?=
 =?us-ascii?Q?OG1gcZLTG7v3Pgc+CH2fulXJCKYDyDLV9tzbgi499c61IbVpQXXlC9ShVLtn?=
 =?us-ascii?Q?PirCsZHA1ytCJcHlOHjYmhb+zt+F1UWr6MTU1ul9C4XVTV1n54NE4jRvYBHT?=
 =?us-ascii?Q?RH3vPP9re0Wo86SXRyiA7bA/E78lCVDqzB1S5NYgojdZl+6Fa5FQr+AY9yat?=
 =?us-ascii?Q?q6ME0GsCiPr+BRH8n5hom0msTtB8c459L0kJYolsGgR1a3VtF9+962MCXSfG?=
 =?us-ascii?Q?ymIMdswQ7ZRwk7Hf34Wng1jQhheurSzWQC7twVSVkz5iwTFtbR1AeqEGj8n2?=
 =?us-ascii?Q?t+3EYfAgU0Rbn8YDCOBbwwOIuytSs33zRKLJqH3xRaxujuIIEWMOnIGXdg1u?=
 =?us-ascii?Q?C0ByZqXrzwj0q5Hra/CQFoZqduzZjHxwfkm04sevBrYpnROBpKAbR2LHKKGu?=
 =?us-ascii?Q?GFgM6CFFMLkxQadWBLwixPBlJHXTV8ZWfUiRlLQVmMY1IZ5ZWUyTkKmD1aBX?=
 =?us-ascii?Q?1T3JNqfeyFB289NTQdOwfV24u2k0L/T8vVxgFSp9w/7zeE0cpK0mSeryt4c0?=
 =?us-ascii?Q?+ebEbQYscc+cIuBS6j8HQW6j0hckrH6oPy2b0Q2Jq8dTfvagZ4Jpac0KH9ZC?=
 =?us-ascii?Q?duc04xGXxJSWIYTTJ8NBKlHclDX/9hqqVmFPLswuVNqnv69bhKv+HG4RZMTS?=
 =?us-ascii?Q?6APExbgkBpWa8XYH9r27s0aun+jpbjtU0d9J88RVsspZkARpqSXqtjQ+Ad3Z?=
 =?us-ascii?Q?8u4BGBkjOCIN7w2tgWAwh4SIBD3l9/dICZLiQVGk2jDgmdUgmNdj+y/fW1Hg?=
 =?us-ascii?Q?P4a27hcgUoT64TfZy3ADdsPT6BYLNiFqDvduVmXg5H1DINRJX/zcFAV+Hxb8?=
 =?us-ascii?Q?uM6BWLNBtWTlUrmn4Pc6EFb8lPzZdc83EPBnCbeeTXOYQ1PCYT8zY0eLZgBI?=
 =?us-ascii?Q?dJfYgir0jA74nSvPRARZ2Hr80ssGVEyqF5g0as8bulHTTzp//oWf6vzQRPOD?=
 =?us-ascii?Q?dNl6wVPg8C8KJ/trTElK6lGDuwE0Ax/0HCKvMEIj6b51fwnSrEW0gwkcOfeY?=
 =?us-ascii?Q?uHUMOQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 16:44:07.4866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd66a704-b0e7-41eb-af08-08de54554d15
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A345.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6619

Tests an intercepted #PF accesing the last (unmapped) qword of the
virtual address space. The assist ought provides a prefetched
code stream starting at the offending instruction.

This is little more than a smoke test. There's more cases not covered.
Namely, CR/DR MOVs, INTn, INVLPG, nested PFs, and fault-on-fetch.

Signed-off-by: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
---
I'm not a big fan of using a literal -8ULL as "unbacked va", but I'm not
sure how to instruct the harness to give me a hole. Likewise, some cases remain
untested, with the interesting one (fault-on-fetch) requiring some cumbersome
setup (put the codestream in the 14 bytes leading to a non-present NPT page.
Happy to add such a case, but I'm not sure how.

As for all other cases, KVM copies ext_info_1 unconditionally, which is where
the decoded info goes. It's highly unlikely they would ever provide much value.
Happy to add them too if they're deemed useful.
---
 lib/x86/processor.h |  1 +
 x86/svm_tests.c     | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 42dd2d2a..32ffd015 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -374,6 +374,7 @@ struct x86_cpu_feature {
 #define X86_FEATURE_LBRV		X86_CPU_FEATURE(0x8000000A, 0, EDX, 1)
 #define X86_FEATURE_NRIPS		X86_CPU_FEATURE(0x8000000A, 0, EDX, 3)
 #define X86_FEATURE_TSCRATEMSR		X86_CPU_FEATURE(0x8000000A, 0, EDX, 4)
+#define X86_FEATURE_DECODE_ASSISTS		X86_CPU_FEATURE(0x8000000A, 0, EDX, 7)
 #define X86_FEATURE_PAUSEFILTER		X86_CPU_FEATURE(0x8000000A, 0, EDX, 10)
 #define X86_FEATURE_PFTHRESHOLD		X86_CPU_FEATURE(0x8000000A, 0, EDX, 12)
 #define X86_FEATURE_VGIF		X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 37616476..5c93d738 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -409,6 +409,36 @@ static bool check_next_rip(struct svm_test *test)
 	return address == vmcb->control.next_rip;
 }
 
+static bool decode_assists_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_DECODE_ASSISTS);
+}
+
+static void prepare_decode_assists(struct svm_test *test)
+{
+	vmcb->control.intercept_exceptions |= (1ULL << PF_VECTOR);
+}
+
+static void test_decode_assists(struct svm_test *test)
+{
+	asm volatile (".globl opcode_pre\n\t"
+		      "opcode_pre:\n\t"
+		      "mov %0, (%0)\n\t" /* #PF */
+		      ".globl opcode_post\n\t"
+		      "opcode_post:\n\t" :: "r"(-8ULL));
+}
+
+static bool check_decode_assists(struct svm_test *test)
+{
+	extern unsigned char opcode_pre[], opcode_post[];
+	unsigned len = (unsigned)(opcode_post - opcode_pre);
+
+	return vmcb->control.exit_code == (SVM_EXIT_EXCP_BASE + PF_VECTOR)) &&
+		!memcmp(vmcb->control.insn_bytes, opcode_pre, len)          &&
+		vmcb->control.insn_len >= len                               &&
+		vmcb->control.insn_len <= ARRAY_SIZE(vmcb->control.insn_bytes);
+}
+
 extern u8 *msr_bitmap;
 
 static bool is_x2apic;
@@ -3628,6 +3658,9 @@ struct svm_test svm_tests[] = {
 	{ "next_rip", next_rip_supported, prepare_next_rip,
 	  default_prepare_gif_clear, test_next_rip,
 	  default_finished, check_next_rip },
+	{ "decode_assists", decode_assists_supported, prepare_decode_assists,
+	  default_prepare_gif_clear, test_decode_assists,
+	  default_finished, check_decode_assists },
 	{ "msr intercept check", default_supported, prepare_msr_intercept,
 	  default_prepare_gif_clear, test_msr_intercept,
 	  msr_intercept_finished, check_msr_intercept },

base-commit: 31d91f5c9b7546471b729491664b05c933d64a7a
-- 
2.43.0



Return-Path: <kvm+bounces-55539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD3AB32452
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E2591CE1BFF
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A19A34A32F;
	Fri, 22 Aug 2025 21:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dgj89S1i"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A173469E7;
	Fri, 22 Aug 2025 21:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897985; cv=fail; b=LBwkUGX9wnriItHHf+aZ8adQ4NhTvE1eJL/V2B24TXhUdq4/utpM1bYqjOHg6ddlCARbGh/SEP8JIDzJj2orJnjPQ26Jkp08mm7rL4KXcD5/2+L72yGnUlv/lUl1ZyXsixpTdCsAuBTvAJ5FwmkXstHYgrEEgtElkmuhB5k8V4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897985; c=relaxed/simple;
	bh=D/Da2L9k545ht07y5O8slAkUbjS9ahxqM+RMRLspyMQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DQLUXN1EcglQLrkec4PRNyHtvAWRyK6fipEzUKUsZDV7GiGVXhlmBR0OA5lJwfLgZW6Xc30OnQ7Y+wxUuD/7469sKpYSG1Nnie3tROrod1RdwoK98h7Pkwg0J86Ity3kG7scYExVyrzvsDdDep5ucLzKdVkll5Dxz5l75vaSrfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dgj89S1i; arc=fail smtp.client-ip=40.107.92.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gDJfCV6TSp+N7WVLzCxRxGxKNgijpm+1HXZB3VPVgoQOEQBgCVislChnLQ95fSINq0NuZiMlveGlStOMESDGiXSQEIYmIa1l4KxiulmohfmNXFCfZv1RceV7hIQarzFJpdhJMI4NMS9kYI74Xa5njWr70e+7uY8+jLtMaRdoRJCjFcv1k/ggP7EyRpVesLuz9sU1YbWuT1h9TOPwOrzXTEalGHoqUAatLZpSRJkuIIDTL1VOjf1bMimfFzULNab9UHBLGaD5CmLH+vXspUriZkagMe97LB8Yao6/SOiMErwZAw3ZuPHs2IsPhoG1ONLkHkRM3JB8PkW8PA1paiDmcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WYaHXib+H5FygCqFC1uD7sz5f9LPGurVbnL56zzEfc=;
 b=uDHQStTkjNHbFubb1I287zJ2BPX2AJ1ioMyYhILRv+ZpDSEWzFrnljU5Z6iazjO51IGIX4hSpdK+jM+eOX+MmB88PnXTrpGFjB5296yIHKwEALJ9E0SUGn4UTzXOpZvp24drEfc76Sb5nfq9u8Ilzq5Ess4G/AOaGcsvig0qHKLCKYgg2EVfnPTNrlToXhpWYnFHqTTml/24v+AfSOQz+vpQUYZuFNHOE5F4NoIUnsaWThsemzOFw13kE836caibFQv3/iedLPhR38cn5umWzWrAIyEfFSVcYK0zPngwC+Shl40qphCYol6DFMGi6rX2Xj0zJXeyrtcssR2JGK+dBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WYaHXib+H5FygCqFC1uD7sz5f9LPGurVbnL56zzEfc=;
 b=Dgj89S1ixkGfYcKdOabt9t4QVZzpCC36AiYtANDAKav0A63JGHiVU0PV44iABbPfgnnc+gpEN4FoXYHAHtjuLXeLFnih3MeCaaluneJOHAAyaH/o0ynrl9GPO0IzkfQJ92q12K6Hffwrh7BmlYGQWfUWwA66lL+oyVYmTnB/Be0=
Received: from BYAPR01CA0010.prod.exchangelabs.com (2603:10b6:a02:80::23) by
 CY5PR12MB6227.namprd12.prod.outlook.com (2603:10b6:930:21::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.15; Fri, 22 Aug 2025 21:26:19 +0000
Received: from CY4PEPF0000EE3E.namprd03.prod.outlook.com
 (2603:10b6:a02:80:cafe::44) by BYAPR01CA0010.outlook.office365.com
 (2603:10b6:a02:80::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.17 via Frontend Transport; Fri,
 22 Aug 2025 21:27:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3E.mail.protection.outlook.com (10.167.242.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Fri, 22 Aug 2025 21:26:19 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 22 Aug
 2025 16:26:17 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [RFC PATCH 4/4] KVM: SEV: Add known supported SEV-SNP policy bits
Date: Fri, 22 Aug 2025 16:25:34 -0500
Message-ID: <7ce170febab3eeb2a591ff9e71fac8871f1aff60.1755897933.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1755897933.git.thomas.lendacky@amd.com>
References: <cover.1755897933.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3E:EE_|CY5PR12MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: 821dcf67-5697-458d-9b70-08dde1c288d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/HfTnoDy6PPkO2yuchQlluroA/DbrSkVQj4UKjqMuxLK9xOjVJEX635lAEhR?=
 =?us-ascii?Q?0RJPUj+ESNfXi+22WgFIr4bUza/YSA7HhYRxDE0QJtIndWSHSLZDlR2FCbuC?=
 =?us-ascii?Q?qlWew1UpCC7vKPDLE5fNazMcBsvPjsjTDnNhoxBp6Ckdq1OH/t/N5URUogxV?=
 =?us-ascii?Q?8KFro/7WHTfJhMLUSzsnHmzlG+zuojtmGgF1hTqJwNh0FMogari6M6pjsFNH?=
 =?us-ascii?Q?jpgeJphJOv1TyJAXh+CNp9ouVSH1iH+bj0lCOOVmU6TnMiqUS5hsfrLgY/S5?=
 =?us-ascii?Q?1ea/LOxdg5ZLFLO0Mif6GM6NrPsdjP8E1oIbndN7vm5q0DLm681ANMaLjuXf?=
 =?us-ascii?Q?utEC4KfSod/Zr5MTPzlyFme7bWpbHWgiGbdcKdbNygx+B8zu8zmR0GUlW1pN?=
 =?us-ascii?Q?44+NP6Sk3mdnx+KpMW3MbsgHtMbkKBJuiv4gvLto2aeappv1HB9tTazWOlkq?=
 =?us-ascii?Q?WsDYUOGAJpxl28Fsv/OJRn2TF22sIm8GR4+KncUhzMDe4+N7BWdYof5txhey?=
 =?us-ascii?Q?KP7Gb98lEe9CBLUgp3rBh3AR2yKSO9BTvhp8LEVa4qBLvlpXZVThH53G/Y8/?=
 =?us-ascii?Q?SixHR+R8F8T8k4obIBR8j7CY5Ni1t8uQboojwKGh7OaWTr58UYLuF3tENz65?=
 =?us-ascii?Q?iuTYImisMgga6jqO3XFXW3pJvM5Caam9hnFZ3v48C7B1b1z3ZsNJySpiZha9?=
 =?us-ascii?Q?/UwZGuLWQqW+iYqj5C7fadtESLbbPAnZTRhbSefDCWIZ8xO69K1JORMvDbYI?=
 =?us-ascii?Q?cKOahAqg2s6aKXUklxV1aMP3QJ1OufnIE8Z2qSypeJVJYi8vWb2yMwar51Pv?=
 =?us-ascii?Q?Q/EKXHa43OB9idGR7b3hmxYJdtS90fCQNdlBwq8+qpLVCy6s9z0Aa5s1iF97?=
 =?us-ascii?Q?tkbYV7zl321+9zruo+GNMkHok0cmqcKf+v1JyzIxceUwL9OQbyveYsJl/aIh?=
 =?us-ascii?Q?lRkDbMns0xhOEEBWK4YVpdTHl/ZhttsCi6YYwG2Y1RukMOM3V8n4+kfjAVLV?=
 =?us-ascii?Q?2CpkXAu4UFM99Vp0JDS97lXHzQwzVL9+Bav+7GFvPvuKLHcmI2FR11TTSoNx?=
 =?us-ascii?Q?DJdJlvSINh57itbg7XJZ+/SCQ/xAxsqD8WcbbNuGuVbeYWdoDOvfk+jqDHK+?=
 =?us-ascii?Q?M8o/U0gDNTNBlddpelDetGGWkME8GqY93dcN5xT54S6rSwvpQB2CHfAPT3lM?=
 =?us-ascii?Q?yeBQxKK7Rx+skcGYZ/lngKLSruNziFSYESp1P2d4F/pB8RSzLiBaNg8TQIPN?=
 =?us-ascii?Q?/5+pdlFgKeCyRdxtPKAvhh2EX7LdPpHfmmlGKUFsmMUp8nVDuryefdI+6Rbt?=
 =?us-ascii?Q?HUgRqX1Z3acPeKP9e8EfQklhdfkEGEGcw2jXPai15vQvgfuDO/Obld5jkrKV?=
 =?us-ascii?Q?QDcT4Ny8tuc7jj+YnwMIZuhwkK3DS7U4PJjuo2ptguE1qlnaXNNY0lq09Nie?=
 =?us-ascii?Q?LP9dhGG9HomlQEY+MzA9klByVXXAvjUIZZhpVCpXJk44/sk049y7mSKk0Y32?=
 =?us-ascii?Q?mjpqCb/g+xRJYG/VmuHuFck+UvJUiS5+GvA8?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 21:26:19.1334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 821dcf67-5697-458d-9b70-08dde1c288d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6227

Add to the known supported SEV-SNP policy bits that don't require any
implementation support from KVM in order to successfully use them.

At this time, this includes:
  - CXL_ALLOW
  - MEM_AES_256_XTS
  - RAPL_DIS
  - CIPHERTEXT_HIDING_DRAM
  - PAGE_SWAP_DISABLE

Arguably, RAPL_DIS and CIPHERTEXT_HIDING_DRAM require KVM and the CCP
driver to enable these features in order for the setting of the policy
bits to be successfully handled. But, a guest owner may not wish their
guest to run on a system that doesn't provide support for those features,
so allowing the specification of these bits accomplishes that. Whether
or not the bit is supported by SEV firmware, a system that doesn't support
these features will either fail during the KVM validation of supported
policy bits before issuing the LAUNCH_START or fail during the
LAUNCH_START.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index acdea463dd4f..4f1564a52feb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -63,12 +63,22 @@ static u64 sev_supported_vmsa_features;
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
 
-#define KVM_SNP_POLICY_MASK_VALID	(SNP_POLICY_MASK_API_MINOR	| \
-					 SNP_POLICY_MASK_API_MAJOR	| \
-					 SNP_POLICY_MASK_SMT		| \
-					 SNP_POLICY_MASK_RSVD_MBO	| \
-					 SNP_POLICY_MASK_DEBUG		| \
-					 SNP_POLICY_MASK_SINGLE_SOCKET)
+/*
+ * SEV-SNP policy bits that can be supported by KVM. These include policy bits
+ * that have implementation support within KVM or policy bits that do not rely
+ * on any implementation support within KVM.
+ */
+#define KVM_SNP_POLICY_MASK_VALID	(SNP_POLICY_MASK_API_MINOR		| \
+					 SNP_POLICY_MASK_API_MAJOR		| \
+					 SNP_POLICY_MASK_SMT			| \
+					 SNP_POLICY_MASK_RSVD_MBO		| \
+					 SNP_POLICY_MASK_DEBUG			| \
+					 SNP_POLICY_MASK_SINGLE_SOCKET		| \
+					 SNP_POLICY_MASK_CXL_ALLOW		| \
+					 SNP_POLICY_MASK_MEM_AES_256_XTS	| \
+					 SNP_POLICY_MASK_RAPL_DIS		| \
+					 SNP_POLICY_MASK_CIPHERTEXT_HIDING_DRAM	| \
+					 SNP_POLICY_MASK_PAGE_SWAP_DISABLE)
 
 static u64 snp_supported_policy_bits;
 
-- 
2.46.2



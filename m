Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E106372B711
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbjFLFAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 01:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbjFLE7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:59:38 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B702129;
        Sun, 11 Jun 2023 21:58:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVNDhns2qWnC7dzNxhUGXl+LjT5/fEx9dW22kTcOdQssl70bqljhrSc5lYccP1O0z6ip6IJ1RO+TqpOpmTCAtKXd/YONOuiafsT4mD7zNuiv8Z7ueEj2RNZmpG3fj7kIbbqgP5n3J/3uWJ932XjeDR0k8KWasDsHD+6+swsAAOZ3K49t8H/p0tv39Wgvih9+/RAqSZESCL4fsYazbOjE+cGFZ8+duMHPLvoIDaCUW/9KJxKxMzKJ6JnqqOSkK/b6cWX10AKECHrzqNQmN/mh60rlFRJYphBd33fJ48XPzVzCPQKVRnkggIkNpCDnFCj/BYE88LTF2vpX4ymW38xvUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glZy7PdWi8qJOsWcUCj2WROa6to0Lr5SQ7LImMDzPlQ=;
 b=HRHBUmpUhJ1fumTaD8y19u61lCsV2HCxMYtiAMwwm4y846ZPD+S5NbF46ejNncykKmPSFQ+kexPLQ+OOvjfzLmgPwpasaeAnehgyaNeyCR4kjZNpgoSXorTwbHsoQc4O4D0QObEcEuUWKwm/LOHStvBIfTrQiS9QjnpLnHW8bYLYvlwjYWRS+JOCy2zLv5zFN8G+wHxL++2JrigtS71LOuFIa3fVm3gy1AYEeRtGcXTpiPjxBjMSnX56TcQMICOrEau+eQAA8b6tJocloMv59frl6BPGlYeV4dLT7/yPAv4EVUVMlwBJ5BecNtYDulDI5zmOj4QhNAYGfUHHBqefHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glZy7PdWi8qJOsWcUCj2WROa6to0Lr5SQ7LImMDzPlQ=;
 b=QgHULNBnG/IH8Z9FXbOkHKmxdeFTWaIvKi77Sxd4xq5Xa/vQZVHCVpDFzdN0dDN3L9+zHMYFTMa9o+jLVnVCpR/BLrwhYFMC36b9OQCVhNU4jXCyycFOUxF9zDefnciz2pzMJGLvqOGgUjobh8AdzA+BR6bw9jUWqefEdGbtpaE=
Received: from MW4PR04CA0107.namprd04.prod.outlook.com (2603:10b6:303:83::22)
 by SA3PR12MB7829.namprd12.prod.outlook.com (2603:10b6:806:316::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 04:58:53 +0000
Received: from CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::56) by MW4PR04CA0107.outlook.office365.com
 (2603:10b6:303:83::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:58:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT078.mail.protection.outlook.com (10.13.175.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.23 via Frontend Transport; Mon, 12 Jun 2023 04:58:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:58:49 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Subject: [PATCH RFC v9 06/51] x86/cpufeatures: Add SEV-SNP CPU feature
Date:   Sun, 11 Jun 2023 23:25:14 -0500
Message-ID: <20230612042559.375660-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT078:EE_|SA3PR12MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: fc23a14d-6efd-4d36-2bca-08db6b01b86a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yhydRVHiUiYjT4p746BxUSPDAhj9l1dvJ9tTzkkIf2g2kydVfOY/iqTEi5/xlWpnsVRsNw5u6DUF6wxByPLCo0vmhMQz3xkjoNF5lXGJoPzk6j81PFa/XbqfBh7oxEZg7bkFyW6XQbLCnn2/JLd66Gbx238SmF0gbWMBHteor56NWW4F6XnkUdf7Fb54vk2rtYOPv3lcO2recETGHATvAiQeo1yNF1wzcL68XcT1cvrdO5kph8IAntVHhTNElwaOvDvB70Ry5Di2mqTQHcgc95vXJGbthzB/WX1yxUbTHT438a+YN+f4l/uKS722f0DUAeN2igRsAar4RVw0taRnWoJpqjD1pT5AFpNRdJRFNz3eJzdHFP1CBPDmyoNUeu8Su+gGPZUfL1/dGJmHSbiBCQ4UQY0Jyoi0z06sXePp/kb7orfB5P3r3IQL7DH4Z6BRqLfAEBOWvaRknrKDhvHQtcI2MT9wQofqc4xJ4tGyZwTyEG6QzuMdtXlWKwzpLqIFOwAPCmuPtVrlPWVALb95UMk9t6ZyirgmKLOaZj9bSzlGOEqn2sqHzaQvSKQHiL36gpkQxvPmVSIiPcFONml6J/yGQ2YuGDnR4nNWiVf/H2iQ41coXh9Sk3MoOQ5uoR0s7PWgEr2Z+bFEkZMWET0b+HAojMx3rUAzkEjwB9Py2Zxrz/ma5pjPiJf3IouAp9FWYww/8nYa/hlJ97h3qQswoTDn8RkE5lnfb4OFcdkLVKUsqaZXb8sx2Q18QRiimZO+nhyOnnZ3zXRbWO9nvCeLLQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199021)(36840700001)(40470700004)(46966006)(336012)(426003)(2616005)(47076005)(83380400001)(36860700001)(82740400003)(356005)(40480700001)(86362001)(82310400005)(81166007)(36756003)(40460700003)(478600001)(54906003)(44832011)(4326008)(6666004)(8936002)(8676002)(2906002)(5660300002)(7416002)(7406005)(70206006)(70586007)(6916009)(41300700001)(316002)(16526019)(186003)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:58:53.4756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc23a14d-6efd-4d36-2bca-08db6b01b86a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7829
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Add CPU feature detection for Secure Encrypted Virtualization with
Secure Nested Paging. This feature adds a strong memory integrity
protection to help prevent malicious hypervisor-based attacks like
data replay, memory re-mapping, and more.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off-by: Ashish Kalra <Ashish.Kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 arch/x86/kernel/cpu/amd.c                | 5 +++--
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 97327a1e3aff..b60b32f47884 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -431,6 +431,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 95cdd08c4cbb..a79774181f22 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -558,8 +558,8 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 	 *	      SME feature (set in scattered.c).
 	 *	      If the kernel has not enabled SME via any means then
 	 *	      don't advertise the SME feature.
-	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
-	 *            SEV and SEV_ES feature (set in scattered.c).
+	 *   For SEV: If BIOS has not enabled SEV then don't advertise SEV and
+	 *	      any additional functionality based on it.
 	 *
 	 *   In all cases, since support for SME and SEV requires long mode,
 	 *   don't advertise the feature under CONFIG_X86_32.
@@ -594,6 +594,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 clear_sev:
 		setup_clear_cpu_cap(X86_FEATURE_SEV);
 		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
 	}
 }
 
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index b89005819cd5..b4f11a500470 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -424,6 +424,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
-- 
2.25.1


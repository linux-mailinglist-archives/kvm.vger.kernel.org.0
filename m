Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AB469D2D6
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbjBTSjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjBTSjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:39:53 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631321D93F;
        Mon, 20 Feb 2023 10:39:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arEPh193fPXgsvYvBEQCLQgNx6y5jXTpTzjQ3xLLXWbGK385s851WtndRuXxGTpYylDtSUZAyUB7x7yjlfDuUOR3MXAjeXY7DdT96V7sLH7pywSGSuGcYJF/70uJWPLhMVG1w8jo6Djri0A7nxA8oANuoInYTURqvKLzkT9U9eKdaQMjFn/MRJPYYz/yDx2+mP7vKPg1+Ie96lyoW2jdb8w6Rull+va2PjiHmr/ZlhiZFv1/IlYKVcYe06tjQ74coxeJcFCXKfUuipwAJl1c9BLVSUqtpoHoNCiy4W0mvthwj/SVW6UdELpi95aBT2EWWFYQWOEJjLeaYCaRDoIcjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ra8CnUkw+2suxZchTpOORUA7BAGVGNIxYd/fXKIHi3M=;
 b=E1V0m2GIURU1EofIgTVerTrM6ffangeTXlFKto94R1Ie8dLkGFOjH5pniN44uHb6S9Um+YdCAXaG8PvyVv9YBHj3XW7uJfOrafnRG56jI4kcACD5CgZdY+wv8L9E66sm88GvVYANHyULp5lH2U5K6ao0OQcwKPMxUwyzSkjkyKYCLlZWvBoADrllBQDVyYVz2V+O0IY+1W8YvvO1IJCUPS0GuBqvftZl0aKW9vnGN8lhyMO/Xx6zpAZxRMAJ052E4bmwWsZllneE5os3N13cp67E4fkgxsySpIzw2v+wIrg/M+awpbmX6A3h+aFFie+jWu86KSQzovbtxt0/aOHQJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ra8CnUkw+2suxZchTpOORUA7BAGVGNIxYd/fXKIHi3M=;
 b=cWbCDjzMeSDN/M3kpbS0RSgePhAOFIc2NfhJWtfsxhLXvVmeLtSuihWsY9BlKi/ti5Xn+pKlu8kBFaWB1yZDhZGGPXQ1HYUnue85EnmH+MQPWwm343M5U2ujhAEB21f+MyN7UBK1yJZ8KgmiVTG9VWb7JwhTloVgO/VV/m2Uwp4=
Received: from DM6PR06CA0022.namprd06.prod.outlook.com (2603:10b6:5:120::35)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Mon, 20 Feb
 2023 18:39:41 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::45) by DM6PR06CA0022.outlook.office365.com
 (2603:10b6:5:120::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:39:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.20 via Frontend Transport; Mon, 20 Feb 2023 18:39:40 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:39:39 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>,
        "Jarkko Sakkinen" <jarkko@profian.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Subject: [PATCH RFC v8 10/56] x86/cpufeatures: Add SEV-SNP CPU feature
Date:   Mon, 20 Feb 2023 12:38:01 -0600
Message-ID: <20230220183847.59159-11-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT061:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f594371-5424-413e-0ee1-08db1371d3a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oF9pCQMVF1Lr0k7eEiVoJ6GePUsqeDRJfyU7UIQ5u5yVNUWKxc8z3O2KCYb9qAXpPorpqIqd/WsfgWKMX1B/TU4C367WmaO0XhPHmQpqmgxeu09P5p8uXUxNs6A/B/SaN5/J49BPKNKkeWhU+YJWO6E/cK+cOJCuxOpoUEqVV0jowDma0XRqQC3s4SlhLjvZ4okAYaYUq38JG6WC3YhDMIJAGTr2LN5kXxPSevALhW8UpzplWKE5sDSoNrpCEMMmgHlqD1G/qNkqhFbmP51M75g6MZ65EnPqfb0UpimyPLwfDxogS0YuebeIBxgns3j7DlJJJkN8mcY9VpO+Ix7sJaMheF6ZAWxwf7o5nLCZj2gR/BCo9Y779gSZpbDlTf8FvJAX/B+1Lt/xWuoAE6b8Hc1sINw8p3bMwMeKkE19+9tDYsEqNpoZ/KwuJ2vpD+nfGwW71wXIApx3EX4y7T4HhUmoWr3c7FI9M3OGDt4pXjWp2VNhS2jsSO/ks/YeuzJY/zT0yeIKg4Tfpx5bF/btktJsv5a1gB8sJ8bvmA7mqYk/tMFyZKtPZDd0hjS9BKJkWNPGKgVi0AKgvsjjhaQUmg4by4LdmyWb4wTLXkqXS5l/jvEbKzJwjUQ9HKdbnm4ca1U6IriMqglOE2XIskcg2nTXVult301WkXEJSXg++AwKoas5ZkfhqUyj1NxAbSUkUC9IDh0x6R5c5u8odSkGDZfvudY/NC8i2FeXujqNnZw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199018)(46966006)(40470700004)(36840700001)(356005)(82310400005)(40480700001)(40460700003)(36756003)(86362001)(83380400001)(478600001)(47076005)(54906003)(316002)(426003)(26005)(6666004)(186003)(16526019)(2616005)(36860700001)(44832011)(5660300002)(7406005)(7416002)(1076003)(82740400003)(336012)(2906002)(70206006)(81166007)(8676002)(6916009)(41300700001)(4326008)(70586007)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:39:40.5186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f594371-5424-413e-0ee1-08db1371d3a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 1419c4e04d45..480b4eaef310 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -420,6 +420,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 860b60273df3..c7884198ad5b 100644
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
index b71f4f2ecdd5..e81606fcd2ab 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -417,6 +417,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
-- 
2.25.1


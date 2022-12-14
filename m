Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2063D64D047
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239215AbiLNTtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238998AbiLNTsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:48:51 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17D22BB29;
        Wed, 14 Dec 2022 11:48:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCm9YrXcX3m9lNJ5FWuxRXQ1gER2NxhsNqYdtjTBq4F6DiYUlIO8X9TJmJJYb+FNdiirQCHBh8SOAQ0ie3LKyc6lGPB96Z0Hj3Mc77T8rQ28BIsqW173Rm+0q5TMx2/kaVs7fbIjnNa47Kc1j6MC0a4S/Srq5sGUXCaHGia9K5Ut94uFJaSOi3Xv8xH4qH4DjOzNv9vGJyyITdqP+d9aoBjg1ICg9GDvzvu5y9paGTBUvPsoaLG6LUGYwy1JkQO8aMlm1ZJqu8YakF0Ihst1bL4v128+IScS7TaL2zrxh39iJcvXgbZ8dXYuG9Ldtcju0/BMzW7HPVfUjjo6JyQXJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=983qr7kV4HVkhdJdw8Aarr87tNHNQaHp+YAL3C1s1I4=;
 b=AcqpnMPy+gINK4owICMtVRjvYReCf0nWoNIOxVrujL4pjnkW4SpuRlJktbZdvJFppVT7Z28OLgvjGZNx4foWARXRmSlhLtbMOJgB2mbdX3JdUlvq3KGlHTWdTQPOw790czWSM7trNI5rbLAdYkp0Shd/o0ZjH+ywOGJtl1gSQKlG6V3us9zFRDluZsNEuzw5IjloGwIqY4ta/DMK3KMJkbSdhj83GYn0WLo2trBxV+kio3m+KU6qycN7cKG1oDuWED173YPP6lqp9u9eD/IMPt7h05uIL/0qTB3eFkwqHeTEQbwpxyoVJ3VQYI44yT7POflvHD4I9ZR2YfBzUkLfGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=983qr7kV4HVkhdJdw8Aarr87tNHNQaHp+YAL3C1s1I4=;
 b=E47+Jt7q/qDwLoOGWYV3iRNujtqrIj0YCSPevpHVoaU3OYN1TgVjmhJ1apmFHzm2XneNejJJGhsM7XNUfVLCrHh0vuvYaSjJaes15ntRRZBohGf6g4V3Z3Z5CutCG5a/VgNLsxYMPD3Q01wiq9CqRnzeRiT+jY/zcJB+5Of5DxE=
Received: from BL1PR13CA0101.namprd13.prod.outlook.com (2603:10b6:208:2b9::16)
 by DS0PR12MB8344.namprd12.prod.outlook.com (2603:10b6:8:fe::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 19:48:31 +0000
Received: from BL02EPF0000EE3D.namprd05.prod.outlook.com
 (2603:10b6:208:2b9:cafe::87) by BL1PR13CA0101.outlook.office365.com
 (2603:10b6:208:2b9::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:48:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3D.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 14 Dec 2022 19:48:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:48:28 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Subject: [PATCH RFC v7 13/64] x86/cpufeatures: Add SEV-SNP CPU feature
Date:   Wed, 14 Dec 2022 13:40:05 -0600
Message-ID: <20221214194056.161492-14-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3D:EE_|DS0PR12MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: a99d12b9-a925-4ca9-300f-08dade0c2c9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HElM6bhJpfNO3PYjnq1Wd2gUmXVIfRnKJj1Lnq0YvdVxc1tCHG+GDXM/5HGZpfO11wXSo97QWbuUsvgyXGffsVh8V2uluz3sZsO6M2HjVNwHEPR3hlnhWGv5ydsLgIT5q5Tws5GUR6uafV4Be1cDNyqS8TOAGdfV6l0nT/KREJh4Wt0G1fpiKrGRZo80P3WbpXZLQcvM3PHGsNWJl2sQUWUAOUmQjC4X6FYKcYVrbOaUodMVPk7Poz2PGQ52aXRYqc/TNVPWavTtvV1yfhy9RY2NuPVEbqPMxPyx6s/FHX7E9h6Y4zhMnIp5lYmavleSIaxWCxHm9HVnzVPme/72Bnz3M9jJonOEcpRU+DDN3FtT5xFkl9S/kUIppKBZovyguFkZCNMnG/CdrFNny840gzHGagpOZhKgevMm9DRcAa5WCqkTU5AufDGGq4mWXtOhVhMjnzzv+hHpcyPLMc15R7W4DQhAwt9dTMY3RCV8fEoSMGYTd/UgHoRF1pmt5pEQb6IP3YG8ZIPfaq9/ZFwaeU/4hnA/ZWQLf9tivYN/FymXr+D2nUgQX62q40TmQaj6VNMTBYB79Z4aP5z8dSanisBdKkBU3mt3oCrnDwxgGhkEgT5jgZ9Lt6N5df2Dbx+d17rSZYwTXDdr3IX7ybqvBLp/60zNTDeqr+eRjWY4ggHyTW1RdfSfNw1i2SW8CaSTcINQWOHQgeqBz3iK9hasUqiQ5oZZwsLjVFjgcPQm7/0e9512X1WGu1ITPah/OkTGOfV6pRcXFSIfgi5tyNP6ig==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199015)(40470700004)(46966006)(36840700001)(82310400005)(478600001)(44832011)(8936002)(83380400001)(81166007)(16526019)(2616005)(7406005)(41300700001)(86362001)(8676002)(40460700003)(70206006)(70586007)(1076003)(26005)(426003)(36756003)(5660300002)(47076005)(4326008)(356005)(82740400003)(186003)(336012)(7416002)(36860700001)(6666004)(966005)(40480700001)(6916009)(316002)(2906002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:48:29.5126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a99d12b9-a925-4ca9-300f-08dade0c2c9c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8344
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Link: https://lore.kernel.org/all/YrGINaPc3cojG6%2F3@zn.tnic/
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74EA7CAA60
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbjJPNtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjJPNsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:48:51 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F32C110;
        Mon, 16 Oct 2023 06:48:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W75ayojfAnzWRfgUMl3zW5Bj4u94ap7WkL1hQ09KNwfwWlRBNKCmwPr0l9Nlh7LlqJhKBwhJqFgJppW3R8GwUjtRrbZihTUbDD6XV8PsABLXEt135Xv8V2l6QBiX+ayj1jDI+nGNw1KywkFitsHrk13z+VGAlBo6eKxVhQrIb6u+UU8IlMKtUOs676pWkrtH5XcvtbxrfYdVYvkXfFfW3avsUYy5cLMnEkGtvDaqPO2kvMq7UGbmHUw5SNv4LCz17WLPKy/9916TJEtF+kiArcdj9Rjq3ZUS7S2S4bv8wq2v4aBHxpmovM4LQ1HrFHeDQWJ/QKtWwQqR6SnwbwAWsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+JCtj3ASOKkhljKB2Eu8gzmxNkQyvn/YzFk7ZCXbFg=;
 b=jsN2yZAhdxr1PylZJusjfSMHD5hQ7qbE1toJucjTIVomXZs6mjkdKXPQWP5ORth58DqaoX0swj8QE2G5yuJcZ/MYO78nd/8w+wiDwbCqs3cRSwZU/PGchPxY3gbqS3o7Fu2WGarZrgiBLGLbrdynff2h8jANqjZSFMhBDfGQvuCkkxm4Hnw2slzHPlr5aXadrKTv/1X37i3Ar4o19vvZECuIITcsZY9rLffU+x6f/iYBZ5l688mQwFWgbls0Z1h0QNohCpo5/AjRXg0n6kppJQtRboMsgOSSW6l2B+rY3FOXl+T9BM+/4lOMeulQBn9+84TPmN3aA1jZq8hwvDD2lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+JCtj3ASOKkhljKB2Eu8gzmxNkQyvn/YzFk7ZCXbFg=;
 b=nMrUdFpayLVy4ZnqWFNDDa3eloJV/yURxbuR0pwbNwOZW6+QUVm5KyKyZd3aaoM1N1RGlEWxFg92EU7KTb1tW7fvDzxEuLEjC4h/93AAJEGltZKJwwRBrp4TRdyWgMEl0NdhHnb1pS6xXbEH9Va1ATcXoPd8YgplPnqnQpmxHUY=
Received: from BL1PR13CA0139.namprd13.prod.outlook.com (2603:10b6:208:2bb::24)
 by BY5PR12MB4275.namprd12.prod.outlook.com (2603:10b6:a03:20a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Mon, 16 Oct
 2023 13:48:18 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:2bb:cafe::e8) by BL1PR13CA0139.outlook.office365.com
 (2603:10b6:208:2bb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.17 via Frontend
 Transport; Mon, 16 Oct 2023 13:48:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:48:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:48:04 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Subject: [PATCH v10 04/50] x86/cpufeatures: Add SEV-SNP CPU feature
Date:   Mon, 16 Oct 2023 08:27:33 -0500
Message-ID: <20231016132819.1002933-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|BY5PR12MB4275:EE_
X-MS-Office365-Filtering-Correlation-Id: d5ef2022-c8c3-4c22-d16c-08dbce4e8dc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ioBpLAic7HOUAApfm9MZ5s/sFi4mzT0X4C3CElX2lWX2Dy5ynnyXstwdc+5gvz0nfzSNVPXV+afsBtFysPmlerxPuU7THUGNaH+g/3fUrs/A36G+cOhv9p1kmTVRtksvXy1cBAxI4/e9gKmKlXmyLW3GsIDzdtiA7Ycy5BAAnmFVrotuGqKGVow7JYZ75lGSYxi4fsyfxc4JSaodM4MhU2u/I/rlS8f2qJ5pvS1SOQfM34Uzvmilyz2WUiDKiIRS7i1nXeptcdfecUX5sxKDEX5L+EMJiK4Fkq37mUJT1eD5KaHI7aCPBs49DCsc3NExO8KWf5GqusE2OTR4XpVUyclO6UrG/DeOuMhdkQV8FannJA6ZVt/76X8gM8/lw1E4I3KmRNMv0WqqCWb3/Gm7JYNn9cgheOel45ttoQ20F4Sq0Vy/NnjyQ70bWwmRA9geTbTOB3L/hGJko8PLrbN66hYAs4YvXUUz6CLICQTshD4f/FM1yTJ/aS6u4S6bBhf5iq7I3iA0r/AV8c+Xl0UXOYM9Uudfd4IOhkS8rbfxFY7Ue/p6ZjXtDTrzPhh62psmaeuyX5xXe3nnsJ+Q0zMa19VAHQN9OMPz2Iwzzp0AqPCnU8UGIXWQomGDOQyuFGBJfdZeMLsjBo+berP0oF5AIrH3A5IjCLMFVC8FkKgJMVNEOT9a233Q5GE++ysn5kv1pmGR6eRQH0z0NMnHCFzH0I7EW5EVnUM6hesikXVuQZzmFSqzaiaFuK60CzKBy+zwwpIKWW/J8Qj4AE3oEGJfcQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(39860400002)(136003)(230922051799003)(186009)(82310400011)(451199024)(1800799009)(64100799003)(36840700001)(40470700004)(46966006)(5660300002)(41300700001)(1076003)(16526019)(426003)(2616005)(26005)(336012)(83380400001)(6666004)(8936002)(47076005)(70206006)(316002)(8676002)(478600001)(7416002)(44832011)(7406005)(6916009)(4326008)(54906003)(70586007)(40480700001)(36756003)(86362001)(81166007)(82740400003)(2906002)(40460700003)(356005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:48:18.3689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ef2022-c8c3-4c22-d16c-08dbce4e8dc4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4275
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
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
index 58cb9495e40f..1640cedd77f1 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -437,6 +437,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index dd8379d84445..14ee7f750cc7 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -630,8 +630,8 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
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
@@ -666,6 +666,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 clear_sev:
 		setup_clear_cpu_cap(X86_FEATURE_SEV);
 		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
 	}
 }
 
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 798e60b5454b..669f45eefa0c 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -432,6 +432,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
-- 
2.25.1


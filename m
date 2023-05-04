Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510886F7782
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjEDUyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjEDUyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:54:33 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26194120B7
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2PHR816A81/dNtyT5gY+LhSfdySIQjG76wak+HrX1PPrgZ+CwGVqzENP0LO4gdZiM0wJToKWqYfjupMkz4SCs7XGOURI071nMy7dtF3SBkjTLSljWaJV+PLTLxpDVpVFEVQ7oTcrY/6RLbGPDDJ48bkX6fVj1HGLJzhr6VgFmxSVbuEZGPu8JiAccCHviwaj5lyMT5TjAMABxUnLMmFd4ZezxhTrAeChL8/KvATgBwLg1bFL8R3sm+zhICDur11Ya3I5h/X6Hr4PT5P0aH6HIDAcSZ5iuZLDusxhkkpI6miKBBOdSE1SzHRtQ/UeZSV6OBeIMIWk/WECHomUBDKKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDSW8af148/ffO20p+wYRn7eBomWU7Qujvr+JkFP0Uc=;
 b=boFU1hJCGQdn2WE+dizRzUOUJUbVgcQtiiaAHji7LIOyUccWwRfEWuacJbl2ynuYwP8PNlLooe9gWGV32HUKAb9h73fGqoTQw4fTxd+3nmZU4QFJ9TnGmNMzSn3txGq2iLkJAH9F6xSaQEW3su373JzvagGJe76d95gJUftux7pr0ed6iW2j47lnLCioBMQ4SpbTLM8TsOronRACC+rXxTNRaYMdLhfelFxeVgCGEW9SyuhXUtA2yjrpM06z5tIG5vM/RI9C/D9q6wI9vCdnp6gTIBXNMQ0w2Wzy+7RLk/vxRjAw0pif/PW/pXKfdGN5iyvjFIZg49kyNYB2BjkFcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDSW8af148/ffO20p+wYRn7eBomWU7Qujvr+JkFP0Uc=;
 b=iek9BOfM3Uzgv2ReOOWAfH2BjAmdyCr5pQrPHs8m97u55RctcOp4zvHE/VOYPB5Pko7lzfN7l3aruYZLZ4hkhhvQZdLsfpjeQI4XiN5y6YV04kSGa8gHfy993iB7w8Ri6mMEBkVlnGnE9Ilv/J01M7vHcVERoVEg3KCaosQjOo4=
Received: from MW4P222CA0014.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::19)
 by BL0PR12MB4963.namprd12.prod.outlook.com (2603:10b6:208:17d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 20:53:30 +0000
Received: from CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::da) by MW4P222CA0014.outlook.office365.com
 (2603:10b6:303:114::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 20:53:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT098.mail.protection.outlook.com (10.13.174.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.26 via Frontend Transport; Thu, 4 May 2023 20:53:29 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 4 May
 2023 15:53:25 -0500
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>, <richard.henderson@linaro.org>
CC:     <weijiang.yang@intel.com>, <philmd@linaro.org>,
        <dwmw@amazon.co.uk>, <paul@xen.org>, <joao.m.martins@oracle.com>,
        <qemu-devel@nongnu.org>, <mtosatti@redhat.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>,
        <berrange@redhat.com>, <babu.moger@amd.com>, <bdas@redhat.com>
Subject: [PATCH v4 3/7] target/i386: Add a couple of feature bits in  8000_0008_EBX
Date:   Thu, 4 May 2023 15:53:08 -0500
Message-ID: <20230504205313.225073-4-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230504205313.225073-1-babu.moger@amd.com>
References: <20230504205313.225073-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT098:EE_|BL0PR12MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: cbcee338-9d71-4370-bff2-08db4ce19dbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w3uWVqA8w0ImeiIf3uI60WdSP19Zagi+Y2T17R0cyT2+hkMsXy2i0rtnt4YgG/YfgUT+TVfdr5KTW9RnGTLILoaoYGBhyRoUNatQhxo4yMUEGX7laak4JcRK0qfvsV7/aYmoE+BGa4pMV96BvmgQc2oPBmQdHnmLC9SdFe2eJlwKrzAEHpc21CThYoIoudZoDvIc80ZgGuiOUbN7hDnbS61+3Ao3XfCnKRjbvGfmoGcRhJjpYiJ7/w/6CW9KVjL1JAft32vyO4ouw+HTg4mZcItJ0yNNn+BJ/90oDJjCXVLT9luH0wDMUqhGxJ9JGRmwCqCcW+AIOtdd/aGUjFLW42KqMhBZKSPRSj2B9iIIPdRJ/lDZiRls2QNTNXpEv0ui4kU8Uq+IfcT80fMBDssIZfGmjz/j2qfUY4jxdHMzuICahcUGo9xKXNe/9ArRZHZGk3SzX4tZtVs9RneLn3SqazN+TbpnyRiA/gxu4BPN4JMbJZt2mPmiuhFeeZWyuHEFJYTkGeNTC+ciWJHQL6vmWW4CNsOoDWyPeuVFHeCeITHU7eyJVbrTyVi4135ZSJkSA/D+vKMDu5DNPmdYNzkDdt3sGH4YtFpDVW8Jm2ZsHNNRtbA+K4U3DvFaDE4ZEL96BBDQwX5c7cAHzeGWhpte6UvfTxteKsRR0jBIudaww2GKuF680NOug7oWL3AN3mG5APYekDw8NhyX6H7d+IZq/8etq2NV7Kwpu7gWZ1O7ePEtX3xTrI6lhHblPevLM5/xPXVVxxRSuZIim6mKQt1T6g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(478600001)(4326008)(70206006)(7696005)(70586007)(6666004)(966005)(54906003)(316002)(110136005)(86362001)(36756003)(426003)(47076005)(336012)(26005)(36860700001)(1076003)(8676002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(2906002)(82310400005)(40480700001)(356005)(81166007)(16526019)(186003)(83380400001)(2616005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:53:29.8927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbcee338-9d71-4370-bff2-08db4ce19dbc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4963
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the following feature bits.

amd-psfd : Predictive Store Forwarding Disable:
           PSF is a hardware-based micro-architectural optimization
           designed to improve the performance of code execution by
           predicting address dependencies between loads and stores.
           While SSBD (Speculative Store Bypass Disable) disables both
           PSF and speculative store bypass, PSFD only disables PSF.
           PSFD may be desirable for the software which is concerned
           with the speculative behavior of PSF but desires a smaller
           performance impact than setting SSBD.
	   Depends on the following kernel commit:
           b73a54321ad8 ("KVM: x86: Expose Predictive Store Forwarding Disable")

stibp-always-on :
           Single Thread Indirect Branch Prediction mode has enhanced
           performance and may be left always on.

The documentation for the features are available in the links below.
a. Processor Programming Reference (PPR) for AMD Family 19h Model 01h,
   Revision B1 Processors
b. SECURITY ANALYSIS OF AMD PREDICTIVE STORE FORWARDING

Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://www.amd.com/system/files/documents/security-analysis-predictive-store-forwarding.pdf
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
---
 target/i386/cpu.c | 4 ++--
 target/i386/cpu.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6c20ce86d1..1a79d224da 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -911,10 +911,10 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, NULL, NULL, NULL,
             NULL, "wbnoinvd", NULL, NULL,
             "ibpb", NULL, "ibrs", "amd-stibp",
-            NULL, NULL, NULL, NULL,
+            NULL, "stibp-always-on", NULL, NULL,
             NULL, NULL, NULL, NULL,
             "amd-ssbd", "virt-ssbd", "amd-no-ssb", NULL,
-            NULL, NULL, NULL, NULL,
+            "amd-psfd", NULL, NULL, NULL,
         },
         .cpuid = { .eax = 0x80000008, .reg = R_EBX, },
         .tcg_features = 0,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d243e290d3..14645e3cb8 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -932,8 +932,12 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_8000_0008_EBX_IBRS        (1U << 14)
 /* Single Thread Indirect Branch Predictors */
 #define CPUID_8000_0008_EBX_STIBP       (1U << 15)
+/* STIBP mode has enhanced performance and may be left always on */
+#define CPUID_8000_0008_EBX_STIBP_ALWAYS_ON    (1U << 17)
 /* Speculative Store Bypass Disable */
 #define CPUID_8000_0008_EBX_AMD_SSBD    (1U << 24)
+/* Predictive Store Forwarding Disable */
+#define CPUID_8000_0008_EBX_AMD_PSFD    (1U << 28)
 
 #define CPUID_XSAVE_XSAVEOPT   (1U << 0)
 #define CPUID_XSAVE_XSAVEC     (1U << 1)
-- 
2.34.1


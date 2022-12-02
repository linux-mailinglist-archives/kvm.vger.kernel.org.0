Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550A3640EB6
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiLBTrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbiLBTra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:47:30 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2088.outbound.protection.outlook.com [40.107.96.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5D9F4E98
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:47:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alOQLQB3NPznu27QMrmOcyPgVVXrCWmsyCZ6y9fgbVGhPZNIiNMwmiZazC9cEwK/TGZxEmUQdrIn3t/tNT+d1JEejYgSlp+7gw2XECNW+Wib2EHPTuXqXChkLpDgt4rhF70+V+o5ePMcjExnJVHd5TGd/hKX0N9dnSF11D+fjtPI5gu1cMdRMTf/WtSgHk71GPed2CH3e6NSiMs3eaj4cawNDY1ayA32ytaYSQLiyzgwZR8K8JpgYq48GHYJ2oadC4+lNRVJ23uap1eqUmuVmVP3hFJXXNjiZC5BXZKGNRiret12pd612Ow4EeCXg16JYe+Zgm4iIzHll/2UljWyFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ra76mJdJvlqF6BtyOSVF08uSks0mwrHq+/j4roEpHck=;
 b=IM3vOvx56B3xZZYTMX5UBR6zmcrrFJomyK3j7xP/Enj/SAZ3BvpyNqPFaL68v5zL84AOKrbpt1WBHYDwDVzvS24MMxYQ5wHsLGQZZYanHA4OmzO3+2XN/QbEZAIPPuH8bHbNANIWtdsM6PjIEoSV8D6WIRYXsWsIoniQQEmL8PGpnZRPBD2oGl/U8TAXKgJopYbbwMxXoS3S5DRUtaWdfl4d1qdO0KQmo3dIMx8MqPQ+A6y/Yd9FYOjal2sIky7gG0m646bI9JBuy+D0jNWlDto9KhsUSlMLv8pBcKmxKc6ZfAlI/S6dfwypfrr1br9VkfNc/kn7nu1C1hBnyIUdtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ra76mJdJvlqF6BtyOSVF08uSks0mwrHq+/j4roEpHck=;
 b=3YlzLbZwD8QhC/I4bC4fWrWAo8hQl0GF84R1IuPhtMylxv2ZHSW01qx9OTQOBexvCSgINIoEm5IQVq6GIdpzXdv3ojxuvQeq8mmQcLjgtYjKvGtsgw46gF3FTStIAXWvtWUi1wEHvhp4vXUe4qjH2zTsV5/OWkt200CDtXbm6zQ=
Received: from DM6PR03CA0080.namprd03.prod.outlook.com (2603:10b6:5:333::13)
 by PH7PR12MB7163.namprd12.prod.outlook.com (2603:10b6:510:202::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 19:47:27 +0000
Received: from CY4PEPF0000B8EA.namprd05.prod.outlook.com
 (2603:10b6:5:333:cafe::c0) by DM6PR03CA0080.outlook.office365.com
 (2603:10b6:5:333::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 19:47:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8EA.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.11 via Frontend Transport; Fri, 2 Dec 2022 19:47:27 +0000
Received: from [127.0.1.1] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 13:47:25 -0600
Subject: [PATCH 3/5] target/i386: Add a couple of feature bits in
 8000_0008_EBX
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>
CC:     <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <imammedo@redhat.com>,
        <richard.henderson@linaro.org>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <qemu-devel@nongnu.org>, <michael.roth@amd.com>
Date:   Fri, 2 Dec 2022 13:47:24 -0600
Message-ID: <167001044478.62456.9456560184804378623.stgit@bmoger-ubuntu>
In-Reply-To: <167001034454.62456.7111414518087569436.stgit@bmoger-ubuntu>
References: <167001034454.62456.7111414518087569436.stgit@bmoger-ubuntu>
User-Agent: StGit/1.1.dev103+g5369f4c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EA:EE_|PH7PR12MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a6a4a5c-cd51-487d-7a35-08dad49e0aa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EiQZjdLwJLIOPtpCe/s76gSkMzh4JOlUaRHMgjqaU+Pqi6LYes6HP+4he4hu9oX36fSK47aGJhnjtxZkOZjI+ji+grYXdRSPWGh+KK88l0P4ymTZQyyDLqxTT1GKDAsjKnSdChCbOZLZ+z8mufqt+N8kEfLHvwZ4q+d1fF0B8jvCroNpve10nb7NYIdgAz1I6E9fvkfc5e0T9Rt6QHi3aZ7Q3sPGdR49tSX8e0UrSWNWJXhKX9tiuSjuwampp4HV2jScrBD5P4irXbuxhpV3jbgoB8b8TBz2sWIDML3nPcm7LOKpbAoaMH+8ygJmqrVU976/epMF809LqTU42lJEx2PzW8079Z8YslofWAeMnqaNCIOB5OpgsecRVWRaJyia1+nmJufYPNO6qgyDHRjWm2ey49pkmzsHwu8Z/N+hSSxvsqa2CkP6oSggI+ASkFBE6sZq95rTm3k9F0zAwX0VVXU429/vaSqwJHnCYbLzinqEa3viKEAUSWBOpT47D32NobYjJFu3N7QSgMHRM79lCkGE3R6Ul0abAeeBelSoxtvaCibyyn+VcUSTsuptjoMTgw/z2631WUKlxlnuv6PUExZNSf4YukRSfD7Uljl+Q8uO2G1uz9V3uPcVIp7bv975++BUC/HIslXd68rI9gksPJOJ0YG+t91YtyyEcyeZlR1xtTtpuH8qaAb8ZBRA5whf3d2x36Z8lnoKaPD+3pXHyPLVdEMdLQa3eVOOlJ2Mpttl+QBPSdg7FG8EBopNwe/PIfB14nC0MyBSfHldtRuufyHSyEG3aepoGh8jL4J+vOYApj3NukuE4Egm+vMZ7iWRTw0URbryRYdIJ3eFFhm2Jw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199015)(40470700004)(46966006)(36840700001)(2906002)(16576012)(478600001)(70586007)(70206006)(316002)(81166007)(356005)(103116003)(40460700003)(54906003)(47076005)(426003)(26005)(82310400005)(33716001)(336012)(36860700001)(82740400003)(9686003)(7416002)(16526019)(186003)(40480700001)(86362001)(83380400001)(966005)(44832011)(5660300002)(41300700001)(8676002)(6916009)(8936002)(4326008)(71626007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 19:47:27.3921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a6a4a5c-cd51-487d-7a35-08dad49e0aa7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the following feature bits.=0A=
=0A=
amd-psfd : Predictive Store Forwarding Disable:=0A=
           PSF is a hardware-based micro-architectural optimization=0A=
           designed to improve the performance of code execution by=0A=
           predicting address dependencies between loads and stores.=0A=
           While SSBD (Speculative Store Bypass Disable) disables both=0A=
           PSF and speculative store bypass, PSFD only disables PSF.=0A=
           PSFD may be desirable for the software which is concerned=0A=
           with the speculative behavior of PSF but desires a smaller=0A=
           performance impact than setting SSBD.=0A=
	   Depends on the following kernel commit:=0A=
           b73a54321ad8 ("KVM: x86: Expose Predictive Store Forwarding Disa=
ble")=0A=
=0A=
stibp-always-on :=0A=
           Single Thread Indirect Branch Prediction mode has enhanced=0A=
           performance and may be left always on.=0A=
=0A=
The documentation for the features are available in the links below.=0A=
a. Processor Programming Reference (PPR) for AMD Family 19h Model 01h,=0A=
   Revision B1 Processors=0A=
b. SECURITY ANALYSIS OF AMD PREDICTIVE STORE FORWARDING=0A=
=0A=
Link: https://www.amd.com/system/files/documents/security-analysis-predicti=
ve-store-forwarding.pdf=0A=
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip=0A=
Signed-off-by: Babu Moger <babu.moger@amd.com>=0A=
---=0A=
 target/i386/cpu.c |    4 ++--=0A=
 target/i386/cpu.h |    4 ++++=0A=
 2 files changed, 6 insertions(+), 2 deletions(-)=0A=
=0A=
diff --git a/target/i386/cpu.c b/target/i386/cpu.c=0A=
index 81918e10ba..b20e422b2e 100644=0A=
--- a/target/i386/cpu.c=0A=
+++ b/target/i386/cpu.c=0A=
@@ -909,10 +909,10 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] =3D =
{=0A=
             NULL, NULL, NULL, NULL,=0A=
             NULL, "wbnoinvd", NULL, NULL,=0A=
             "ibpb", NULL, "ibrs", "amd-stibp",=0A=
-            NULL, NULL, NULL, NULL,=0A=
+            NULL, "stibp-always-on", NULL, NULL,=0A=
             NULL, NULL, NULL, NULL,=0A=
             "amd-ssbd", "virt-ssbd", "amd-no-ssb", NULL,=0A=
-            NULL, NULL, NULL, NULL,=0A=
+            "amd-psfd", NULL, NULL, NULL,=0A=
         },=0A=
         .cpuid =3D { .eax =3D 0x80000008, .reg =3D R_EBX, },=0A=
         .tcg_features =3D 0,=0A=
diff --git a/target/i386/cpu.h b/target/i386/cpu.h=0A=
index d4bc19577a..8c65c92131 100644=0A=
--- a/target/i386/cpu.h=0A=
+++ b/target/i386/cpu.h=0A=
@@ -918,8 +918,12 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWor=
d w,=0A=
 #define CPUID_8000_0008_EBX_IBRS        (1U << 14)=0A=
 /* Single Thread Indirect Branch Predictors */=0A=
 #define CPUID_8000_0008_EBX_STIBP       (1U << 15)=0A=
+/* STIBP mode has enhanced performance and may be left always on */=0A=
+#define CPUID_8000_0008_EBX_STIBP_ALWAYS_ON    (1U << 17)=0A=
 /* Speculative Store Bypass Disable */=0A=
 #define CPUID_8000_0008_EBX_AMD_SSBD    (1U << 24)=0A=
+/* Predictive Store Forwarding Disable */=0A=
+#define CPUID_8000_0008_EBX_AMD_PSFD    (1U << 28)=0A=
 =0A=
 #define CPUID_XSAVE_XSAVEOPT   (1U << 0)=0A=
 #define CPUID_XSAVE_XSAVEC     (1U << 1)=0A=
=0A=


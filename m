Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A657C408F
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343602AbjJJUDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343574AbjJJUD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:03:27 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23AFEA;
        Tue, 10 Oct 2023 13:03:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRC3ikJzuYtfHews5lSHSrKUFzz9UcBcuwudTd586hNvWJxica/YEr2tS0XnG0aHRuqC6LilaUiu8Zpa9oHukkSUJs8MPim4iNBph3XkUAQf38+OXKneUdYQbEXvzegbkstqUxaz1z5UpeXS3YsogHWacy4I8BN52AFcV1UIQn+cdm+6f/GtjLaYcEjnIxi5WixmgkRlS0jvxoJeVcugK0Gg/pDfLLIxDSVCVgxV/Ewv3evHU/yKxHPo1iLRzO2ilypX72RBTS9MsOYtrtWH7PCnkc+1X8l00mOiHNpOwyP9ZO8RLQVrRAI5gk/0zG/qwsKPFgHzdXJFc6Tsp18jmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jm/5N+PjkLaWgeUtJx/+Qz8BnEFaa5kYMsLajDPIox0=;
 b=aBthhHnuQsvcIe/TtBL44oHWrGpFZpqVNXvufuiwp1YTDMwZ/jhghu3Q5epnkiLlVovy4mWntfA9uGzRd5JZMnTyTaAtNCRlnsLh/YwTjGoxESWFwYG8IiUhhmShckTjY1CC8R6TP0ugQhasCefLvZo/HJU9AxAFfA9Ny07P5tlTVV8bLMiMq2RKfH0c62K84huFc7EVVP+vROwjGp837Q999R0oOmroSbpNXAjvSETezekJi9uAlXpRbWPDCzJK8WrL+r3rjXxqbqKWH2Tu4o4x8wuyNV86kMVGRVumT/6QMn/QM4tPyvLb8MCNtpaLPEDWbqIMJMlPYK+Kz4bBUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jm/5N+PjkLaWgeUtJx/+Qz8BnEFaa5kYMsLajDPIox0=;
 b=tlJOHzoYpD/5BZ3bFzgw+ZieqUC8bXcfG6NQ4+/bZHDEbL5m2EAp9BQ9QHKAUj3d4WmUqpAb/BXkNwvaMmXmFpopdguTwl4m6v0LUZn+j2FJ+2vw0rwFqPuHm7W6K3IGwFLzplYT3kxGjBiLrh8XzgZM63wG4MJFfj5c82FPa6A=
Received: from DM6PR05CA0052.namprd05.prod.outlook.com (2603:10b6:5:335::21)
 by DM4PR12MB7527.namprd12.prod.outlook.com (2603:10b6:8:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Tue, 10 Oct
 2023 20:03:15 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:5:335:cafe::b2) by DM6PR05CA0052.outlook.office365.com
 (2603:10b6:5:335::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.20 via Frontend
 Transport; Tue, 10 Oct 2023 20:03:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 20:03:15 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 10 Oct
 2023 15:03:14 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [PATCH 4/9] KVM: SVM: Rename vmplX_ssp -> plX_ssp
Date:   Tue, 10 Oct 2023 20:02:15 +0000
Message-ID: <20231010200220.897953-5-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231010200220.897953-1-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|DM4PR12MB7527:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e29df9c-3b88-4327-b44f-08dbc9cbf058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FEYsxGbe/y+puNGPycwv5hZL7bxSisBjUEKwWYegpJ+63+a0FCkeaJCTNEPWAmwr2cNAjcjqYXiRDrq6QgWITQp4bI7iSnxCe7byunMP0jXXf8JQN7jlqn183QAefhgOZuFszVvZjvtJATBCZKkgj15guJxfyIKmnztaTzV12EolMer54nfqRkadqJQnbcuBwoIhfMELgRwGzgqqMZtcxFjNfN0YlOJdmv3iLPRkCA4jgBzX9AQvNykrpatRtf2QcWwHv8xxlzAEbjAB8JYkAH1PtlLEVvSjnr2K9JI+TnSmnN4qoz0vJJUd554fYX+grh9rmJZ7VbXvEto7eho2OtAnOM7H/khHfVpGoQJGf/fk1QWblQdHy+A9i+vJKk8KSZmFxBe6fw4AEYoMTzzP2kFGJfwvk/XjuzZ3jmnAgttCnJfCk/4n64sQC2l0NU/AjPNjeYikpNBj7bo0w/A4f1J83fPqjU+k+CcElatk68C9yJRL9X/2N1GZGU8bhR5vlKF2av0NHEt7lkCDSyCf6PJVVMbQlCdISMiRFGT74bhyLcXgrI4dFZ4s6NiIpLbZrhrJj+6yzTjfjIPQ4wI1fKTuKFPdEVUT8aPKzrQkwJAtq0Sp80jrjf4LZRVv2mXWGK24AB6nF/BYtWrD6Ocn8fh9vVtcH8wmuQJ5IWsIto6jWGgJiQy1F0qnNrZXD5Edq5Ok5qDus59PHjyLRStqbkDxHlIp6NVMRbyNbHPY7pM0K0D9rsqY79IYSA9qK6JTCnWzAlq7McS3K4LngrLuqQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(136003)(396003)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(82310400011)(451199024)(36840700001)(46966006)(40470700004)(7696005)(2616005)(1076003)(82740400003)(36756003)(40460700003)(86362001)(81166007)(356005)(36860700001)(83380400001)(40480700001)(4744005)(336012)(2906002)(47076005)(44832011)(426003)(41300700001)(316002)(478600001)(8676002)(70206006)(6916009)(4326008)(8936002)(16526019)(26005)(5660300002)(54906003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 20:03:15.0165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e29df9c-3b88-4327-b44f-08dbc9cbf058
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7527
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename SEV-ES save area SSP fields to be consistent with the APM.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/include/asm/svm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 19bf955b67e0..568d97084e44 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -361,10 +361,10 @@ struct sev_es_save_area {
 	struct vmcb_seg ldtr;
 	struct vmcb_seg idtr;
 	struct vmcb_seg tr;
-	u64 vmpl0_ssp;
-	u64 vmpl1_ssp;
-	u64 vmpl2_ssp;
-	u64 vmpl3_ssp;
+	u64 pl0_ssp;
+	u64 pl1_ssp;
+	u64 pl2_ssp;
+	u64 pl3_ssp;
 	u64 u_cet;
 	u8 reserved_0xc8[2];
 	u8 vmpl;
-- 
2.40.1


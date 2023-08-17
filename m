Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6465377FDA7
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354281AbjHQST4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354239AbjHQSTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:19:22 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA252D73;
        Thu, 17 Aug 2023 11:19:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7A958xGjyMwAllEP7BA5JmVsfvgFly1PvIyCY10K2Ll2a/seRljaVwxYdBgEmS5yrHc+GV9xE/7MXfgPwC/W5wtVNzGzI+zbBHqKFsnJs+/9e/Qc041WgUdE2SdbjjVkzosSYQHsyCaXxPQ3JWLf1giuopDCIQlw8hiUqNxTFeGKOIQJEmV7BMqdvY3m2ol38ApxjHNSKV8u7vgRDEzP8O3vIXNG6fnPzjA2+ZDvMZQ2pbbnPKtYdcOjcefN1OMdlgTVxKAPMujIroWMbxZSUSOsdCLCasojdhk53aoVyi76Q5HtfYngDrn0FM1v5RQeV9QtCrkc2HS4JoHslv/sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8Cm8jYRmlV/YjOV5FO2vnlowfSTltbLVYrJbNi3xNk=;
 b=gsZPOGgfvi5IjzDHZfIKkEb3Z5kmPpBWfRZLKcRIjW/qdPQ+1X+1lSxQqG1tvNB/fjT8UmZ2/ss1Ipnb4kxPEkuTLeF7m/KXeYRPicQRfYD5birFj3IOlaNjpeUc5r1y6jTVX5rlMsu86oJ5xeiiqSKxfH8nTvIb6cFmaOgtM+B8Ms67JJREz2bpuNSCCQmRg5zy1f3QyTgp1vCEgV7C1PieeSlgu0Snhvt1uyLpcJi6FgMHvZfi3dQMu2yDEMSj3Qns0qSIZWpBMjeenOnkI9ipmSylL0M4MhJdFCpx3tVqUgwQINYhD/FSlHWwyb0MFDKvSNbR6MX99EGcpoQtWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8Cm8jYRmlV/YjOV5FO2vnlowfSTltbLVYrJbNi3xNk=;
 b=UoC2mc2nA2gu7oYs+YuygDPiHgLO0qjg1YjpZB7rxEfPIK+p+Od0baGqa6Gq2tKgkVu2NdjOib0gzP97cmIc5EV+qC2z3GtvIvPwXCdBPzBHXWA+96BzUcTMcGL83U1csLT5Gjy+eXV8eE8JxeffQTr+d+p7a2Iz7ddNvVyNW4A=
Received: from SA0PR11CA0183.namprd11.prod.outlook.com (2603:10b6:806:1bc::8)
 by PH7PR12MB6785.namprd12.prod.outlook.com (2603:10b6:510:1ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.29; Thu, 17 Aug
 2023 18:19:17 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:1bc:cafe::21) by SA0PR11CA0183.outlook.office365.com
 (2603:10b6:806:1bc::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.17 via Frontend
 Transport; Thu, 17 Aug 2023 18:19:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.15 via Frontend Transport; Thu, 17 Aug 2023 18:19:17 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 17 Aug
 2023 13:19:02 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v3 4/8] KVM: SVM: Rename vmplX_ssp -> plX_ssp
Date:   Thu, 17 Aug 2023 18:18:16 +0000
Message-ID: <20230817181820.15315-5-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230817181820.15315-1-john.allen@amd.com>
References: <20230817181820.15315-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|PH7PR12MB6785:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e58c2dc-ab8b-448a-101d-08db9f4e77e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hfcjSUDePj1QmXBkEAtTp6P8ZhkTDI8bmnEQmlefw69dKwGjNL6fcYgRpFVl0gTsj25mQascpV7rHe5FB5iHcFu5A92PElcnlDCm2ftTH8sVHsy+4r2/Gm6OF4+FIfA1AD7BWelN6cm8nH1r37dB/q0Gj/lzy29eC90ZmjOW/aXzkGsBbLnh9NResZY1RBJdK3i4nUxPJA+/SHt0qreOQiPIWjLUez+e3wz7v59DztuMtcxTMJug1QX4s0jr/TA/xzZkupwMkb/YhrAIY5GAq0zXWE3RnPUN7Wpj081+wC0rruSzMcNNQ85Nw0apJXRJ4fOZEBljAYhN5lu4kDtkuII0O7K7d31ft2kWt2cthOh5ZjLtCeTBdHkNA8W1jEabavt9DQWZjmFmDvli5lqeVZqRasNLoaM/NezKMwkQElft+62ji4wsSZVfR3+acc5Yt1b9nfRokkA6DUWFdwJ4x/LrhfYDmyeKArXYNN9+UBGXbLKTEmO10yc6JfObX++LEsmEJx09NDqSB40sCybJg/8w8wjYvFaZkfOmSfdOVOJDO9bSsaPzG0TDuaQbEgUwuzFLtUfs5OvD4gT4/5YbXWxto6B8fTE8tTbxLOuDyauqFU621/jeYG+0YAdgt+EHF6VDQqySRjKvkgT8TECaksRX/lZse2hWtakVdkshnIlfRhX1StbMix3Dm6WGQcFZJTEPKiZr4RXFTIftFbo2HM6NhC1/e93i+kCj1mr18GqjAS7mPkfQgvfPpoQFXLm7A/NkAfZ1SICrY6zTPIFWIQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199024)(186009)(1800799009)(82310400011)(46966006)(40470700004)(36840700001)(316002)(54906003)(82740400003)(356005)(81166007)(70206006)(70586007)(6916009)(5660300002)(41300700001)(36860700001)(44832011)(47076005)(8676002)(8936002)(4326008)(26005)(40460700003)(2906002)(4744005)(83380400001)(16526019)(478600001)(40480700001)(336012)(426003)(86362001)(36756003)(6666004)(7696005)(1076003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 18:19:17.0419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e58c2dc-ab8b-448a-101d-08db9f4e77e6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6785
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename SEV-ES save area SSP fields to be consistent with the APM.

Signed-off-by: John Allen <john.allen@amd.com>
---
v3:
  - New in v3.
---
 arch/x86/include/asm/svm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 72ebd5e4e975..d14536761309 100644
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
2.39.1


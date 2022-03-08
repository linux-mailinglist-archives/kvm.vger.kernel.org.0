Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC384D1D76
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348439AbiCHQkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiCHQkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:43 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B765132E;
        Tue,  8 Mar 2022 08:39:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mh1eJ/wSwG3MLz6JsTt6n4xhlp+jxWdfBMMgH+Xr6/gXw5XYhgtWN/+91k/+JCuxkUjubcgqs9bwMu+7pfdVNEc3/rRPse/JyB5p7I4xrXdT1Wa6uVxmie/KDR2/We7G+XqkAFGlZek+KkkxOd6bDtdpOmN6KSd9RtLYPYgp2UVh7cIO6F2tC9ufyO9Na1lgy+V6RcODcicTlYNEOdd6xjzQtOIaoSZeIjhnDOydZekOwI5mmIWJ2gWv65VV2o2xJ5rHMs/s9Cm3mTKC96n6SXeD7z2onbJIUGfflLdHnWx2fwSLEFExlOPoGllJxK3WzVVFE6bn4Eh6iCDjeqeqUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0AXjzDuHAe47koGh93akBEs2wdiSPWJgoaKBjnwP8QQ=;
 b=J7pPJRviRYQgcyrA2UqFa/cwH71lsdnUSjH4btD0DQwhvZbDoSzMe6WqOrxCCjlxdB8xU8I2pB0YmvUzNrkQaJ5GwlrnwmsJmHlG8sXvy7GixzKnMG3YmtAK5UzG3CRyhTA4N6ejjiXy53vOSL5DYfRdT1T7KDOjMHWOEqopg8ZCrVXP14sSuflzWIom1UyLNmRO9Oq2bKAsTMBEh5IB6acz+49aUuOVj5F3WkYMsgVvjjmNfZLe0VUMwDTnWS13sYxSG3ah8/aVUyQz6KdhuYm7p4nMgshpdIJFIW3avCqZ93bCQsfXM5LiE3ckjyw40Up5F7l5FUu2HtDaxqqcjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0AXjzDuHAe47koGh93akBEs2wdiSPWJgoaKBjnwP8QQ=;
 b=iCIfbVoAXe/C6bVA1xxdNvc/x9pijZ10ii3n77QrNNybWIX/RHQ1RbOhEKgeR+VIAOVYZOJ65+z7PmsKZKasHL7M/msbTj5JQ4QF+kcS0RrEOjoPAiNL53BdMytsPpxQxiRlhpe2RizuexEtgY1kNz9GtZCUHeQNppG9fS+OQ5Q=
Received: from BN9PR03CA0305.namprd03.prod.outlook.com (2603:10b6:408:112::10)
 by BYAPR12MB2742.namprd12.prod.outlook.com (2603:10b6:a03:6a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 16:39:44 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::dc) by BN9PR03CA0305.outlook.office365.com
 (2603:10b6:408:112::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:43 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:41 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 01/12] x86/cpufeatures: Introduce x2AVIC CPUID bit
Date:   Tue, 8 Mar 2022 10:39:15 -0600
Message-ID: <20220308163926.563994-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8141c20d-ef1f-4d72-7155-08da01223fc2
X-MS-TrafficTypeDiagnostic: BYAPR12MB2742:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB274278905513A1E79D985069F3099@BYAPR12MB2742.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8cAnqpjiZlwssSfItGE8YB24dNsOkm+Enkrixei4nJgZ6yxu8dvmuaqcE3/TOYjlL3Uyo6tjWo5GUMwB6rHspKq89zrDNXSHVohWO5WyMdbN+/jVVkcnYktbG65ghat3R9KtWrfzoWiuBZP/KKlVMv2CPVukbI6JH4ckGoOZLfB4QNeXwA41l8NtVy0ixpscexdKGAOlFsSnqdTY38l8dm67i/p4r9DEmHuqJICbklG9Q3tJ+iTvy+1SMaS9kgefwQgRW7CFui7ww4dW3Igv2Sbq9HYr/PM/m1PPCjNxpIyzHYxw6etkJZjcQ1JojfZpsUtt/l2+CsRcSumokP5ASFHiroVk4zruN3G8mXSuQqSavpH08p9802PmOTbAKyzfxOdxg8YfuOX0HID7WUwQF5xpg2leXtd18E+z2iI3DSOQpUpI3vzLZcoy4W67zh3Nz3bAGzbDSX/2+CO9YqA8KuvTpdPfpz5ytY5zBoxZa2aqOPK0M+atozN4DPhd0+qk0z+0kbdTlO2K6cC1op+wMAirD8ji0i/qONVNiLJWIGir/1j/BUCCHErGKdhd+1+twFVKiSdD7bLv8MTnIHSCNt58vhmQYBY6hqpgqUgNJ0OxWsCQBEacGcUjePbpLdLY+PKkWSF0ZvA/TdKiMoSzMCuh+9J5DEaWhtvZCKRarOEGhXTDol3mP3KM+qaOoiT8T4mLJyo4zLFqPIrVdb/fw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(4326008)(44832011)(81166007)(8676002)(70206006)(70586007)(5660300002)(2906002)(356005)(36756003)(8936002)(82310400004)(54906003)(36860700001)(110136005)(316002)(4744005)(186003)(40460700003)(508600001)(86362001)(47076005)(6666004)(7696005)(16526019)(2616005)(426003)(1076003)(26005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:43.5632
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8141c20d-ef1f-4d72-7155-08da01223fc2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2742
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new feature bit for virtualized x2APIC (x2AVIC) in
CPUID_Fn8000000A_EDX [SVM Revision and Feature Identification].

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 6db4e2932b3d..8c91a313668e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -345,6 +345,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
-- 
2.25.1


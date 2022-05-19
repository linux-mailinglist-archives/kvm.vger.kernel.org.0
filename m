Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DD552D085
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbiESK1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236658AbiESK1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:32 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4758A7E19;
        Thu, 19 May 2022 03:27:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Etd7DPaYAk2hJPVcpyTkYM7sfps49ApHANR4i45IAwZ3lf3drXM4FM4kwHiiK8SKV3oH56dXSF1tn9UbH1UsiFVjtUyNFhclju+bxGfT5yjSfs8ww5BhyFuHjGMUT6Hy7qvtCzhBdrUfzDuDctp4n+rLlWrX8b3G2ck5RRMFvjSBCUARWXzboXEiX7uShZ//R7BWFjiPl2afPERlP4whfqduW182I3NPA0yBgbE2f/391Qv2OmntUiHTiAdfaSFN1UCgapNqbRXj9AYAUyIINDa8sX2sPwJmCEeLKAfQa3TpCUDYXR3NxsoAjhVBeowl8ho76jP4Qg317yQcaaL0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIxqo7TXYYl0T+tYZvoLGn2rk3JMESoQytRIcfR+RbQ=;
 b=GwhZjKSWwtOweitWD+ndrvhxkQD3POo4YkrNq9m9t9PvxDPgQX94xusjnMVcNjP2UDDIa7KWhR2/TtUzyvSldIe2s4WWtyEr4WlFTW0V5Rd3hGsy2AVYjPl+zfQgmapjmlnCfxnl1DEqe5/BITrISoTc7wZYF01wotg8haFcOiwx8cQG718i0kgqFZY4Hjf8TNslMRBRFnr4/vVzMHW1VkOq13qIZDoVGWHI58WCpYBu35LaSnJlGsUMAbk0AA7ZtKaPwONSmq4FnEhEfcj7QqAujKmEfLAauvaDTUc18NL9E9YKBiecRqh4n2p3nXKMOSGORTjxSH0Qrssl3ALNNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIxqo7TXYYl0T+tYZvoLGn2rk3JMESoQytRIcfR+RbQ=;
 b=BCpcZOKyIdCoQxU3Vf8+bAzHemUB2UspGTK56SKaj+jLzI9a73Pjlbq9nN3FLmwJ/xdcZvaX/h61DYdgbpgBocQwj+yxQlitXiOlNsMzgJfk5i1xDdT5rxHVJ8P+toXSsd6nr2EuEtk6gMRf+18QKLYyvRQHPdG6hmgLAExzhes=
Received: from DM5PR18CA0061.namprd18.prod.outlook.com (2603:10b6:3:22::23) by
 DM6PR12MB3545.namprd12.prod.outlook.com (2603:10b6:5:18b::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.17; Thu, 19 May 2022 10:27:28 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:22:cafe::ed) by DM5PR18CA0061.outlook.office365.com
 (2603:10b6:3:22::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26 via Frontend
 Transport; Thu, 19 May 2022 10:27:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:27 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:26 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 01/17] x86/cpufeatures: Introduce x2AVIC CPUID bit
Date:   Thu, 19 May 2022 05:26:53 -0500
Message-ID: <20220519102709.24125-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4390e5d7-25a1-47a4-1ec4-08da39822c6f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3545:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB354586694F0500FF6384A7F2F3D09@DM6PR12MB3545.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wAr+1Ts0pifmrAF+MAZws9B2YhM0BsEnViCr0Oui3atCeIlg7MC1uAMsniNEdBNBg6zR+R4G3vF4ZJ7fFYe3ZcHaIBQXKz9K4P1YdmEScK5GG1I1w5aX6OMFkp/vIBFJTLciYWymbFMIJR3MwD+XC4xkCssWs1hYAWX4yqtBkyzeZ70u/p4OcikTQYc7QdVfp/c57TRUSihbB6qlUK3oEc0ZL/xeur0fgH06AjY6mT8enweXFB0CUK9qTWNC2+WozUCcGfMExNVFkp/isRDhYSppFnUCEiF4dNoTj+LnrnshZ2DYOuJtqnQKARFg2qiDMuIv52eLFYWxgUrEEmLTYBxRDf1cmBpjrTpDB4xCLcdW3Tl5CgtpJnX3xMP69f7CIIIpzIer4v0ajnQSLteY1GyfwQBBo/0wVm1KJjwbu2B0WlKvzRpum1TmDK6SryNdwMc1BbU9r7lwGSyHX/xmSlc2l5rtd/dBs1IFz11m/SJQ96ykR6s+1uuoxyzvoDcpZ+VQ9KF2OQMMcVHsoTB+l0HSQgnBk4k9Uq5L9uFPARJjp6sIfTodF6tkm8UnKj8gsqhxG+vrg+nvVLUmldXETGIeeN0Lq2yDFEeqx3Oqu5IodN7H+h2XyjZSdhLQqFTauqp0zkyxSLTMXBnqszrp1Ha1w2wmIDRseUG0+6jCTw74Eu9puqC7ELRJ8DX+4iXAREFf1bcyhfAQ2cFGEe/Ytw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(70586007)(70206006)(8676002)(4744005)(81166007)(54906003)(47076005)(36860700001)(2906002)(26005)(40460700003)(110136005)(316002)(1076003)(336012)(186003)(16526019)(356005)(8936002)(86362001)(6666004)(5660300002)(44832011)(426003)(36756003)(82310400005)(7696005)(2616005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:27.9420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4390e5d7-25a1-47a4-1ec4-08da39822c6f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3545
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
index 1d6826eac3e6..2721bd1e8e1e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -343,6 +343,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
-- 
2.25.1


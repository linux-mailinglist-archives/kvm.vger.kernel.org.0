Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72A351EAFD
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447097AbiEHCn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiEHCnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AF511146;
        Sat,  7 May 2022 19:39:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxFwKeSMxyzID0JNRuLWXSHagtODZlRfbfKlyRMF83orMYFXXw4ABrgxu/qSIzXro1UDK3uoSDX94aetaVvMaOhm3Zk5/mNVs2X+ShpK/clAlQ3qfNnxvuJCowRG4wEGC2NDHGigxtd+2xvV/gGB3i2BdciQsGv5Lc6zFhMUy7rfVEJgmEvS6NQq5nn8tRN+933JJPfMV/Lm+3ON8CAFjHgXt3JSnnKpeitN6QDXbQc2/trVBExGSHBIXiF5JfSC6jwSpc5BCzglwxmmwh4UJduAZbMZJ6kZJKii8J4V820Qqzu4p6fNhfrRoneXAMzXBnH6F2xJ04Y5DvaH3Smoeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ZQZ/G9VZWwOJsrOFDLMWmHrVmDY7UkjThl0FR9EOyE=;
 b=j2mxSLfOPzJDSXrMUkVe0E5h33y+udnU5bc5CfBjcjx8ExvO64WPTcSaRQCh2jQmBag3ViWz9DAPgiGT1XVo2PBq6XKLxHhpDfAyIfiIR+ijJc9Y1vwm/s3UjQCTnm2l8sxRE62gnAQ1F6gW4p6q/OKh0pY4Br3RNT2r265nFaGM63PplWPJ9CvAayPAxpWQLwqinztdLkILPjX0OpCRlX2A3ZA1/1hNU1U0HhTrj55gv6XCdeIMxqSaIA8hVXxDuwT9Y2Sc6iXvmP7IdsBzgvZwtIoAPoV3BVM6b9Txl4htFDn1p4R1RwtdAe8X0/F8THeNddH7+vR6+WXYcNl3nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZQZ/G9VZWwOJsrOFDLMWmHrVmDY7UkjThl0FR9EOyE=;
 b=yuKrUHzX4Sp8NtjVRBVnvMIF18Sc6JYYYG19O4GZx2mftAtACqrq0egcc2M02LlUIijx7ONmPWYNlgNmVVP4fHbfb3u8yokeO4jAqPTDrZMBbK2S8FbIhjVM+mV0RjIQeby0O88rBGOCuRmGfYkhaACAQshkoO+EfUbol/ktKkc=
Received: from MW4PR04CA0052.namprd04.prod.outlook.com (2603:10b6:303:6a::27)
 by BL0PR12MB2466.namprd12.prod.outlook.com (2603:10b6:207:4e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 02:39:54 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::22) by MW4PR04CA0052.outlook.office365.com
 (2603:10b6:303:6a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Sun, 8 May 2022 02:39:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:53 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:49 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 05/15] KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
Date:   Sat, 7 May 2022 21:39:20 -0500
Message-ID: <20220508023930.12881-6-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 959f60b3-e718-4787-d7d9-08da309c080e
X-MS-TrafficTypeDiagnostic: BL0PR12MB2466:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB246608081692D593A39D1CA3F3C79@BL0PR12MB2466.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tI4QgdmSbksDOTxgdOvy/ed6LMQPnx8yYHeQreyhN/oADuNmfcGmHXCIle2iDEN4aqbcDXeFIZYHmjt1vP7unzSGDooob7Ci9LjbIm0jKdnXzqHUPGXUL0RRS5//kf0NdXnPjpZ7M9BFAT2sBbfWXR6XMyNzZWdH/trSvlBI0Q/QNq26ZgWhQkwX79AwCyW5ZWnpi5/BhiSsS0Sd7OKsbQ3zCFT2hx6vkZ6S2VUyou1crkbyZIkFmqKRddYvVfabqeXlVi0soN6jBdERGOMMN5f9yZZpqWhVeHOhpSYAV/Qa4o8Q0CwTSK3ywHLGwlDIb7MVLM3Wjx4HWY66PX9XuWSvrS/G7qijF997RnShTVavSh0wfgi9EihycDkYA+l5zanwOlLpJR+6C5jxZvK9K4+MQhm0ClmhqRX2Yeg3aOPc1c9e2YVU1PeGHVUM39xlPbawNDk9VH6/fBevFqY+qCUlpF34KKN7UPymoKdljQh8NddzvyMIvbc1EGFc8R6g0NSZF3ppaV+QKUkjfNYvOAKnOP4CLutIqJyA9WOCsCMGfJwABb4QbYh3zsHgEKdQ3ciUIZNp8EMxZC3BRrx6EOIhgyw1/zrbQx6jFBLkw1y8223ADv8JsCHrfGQYpa2J8GpimG29drGlschPbgsZDEkBRe5x6/PT4a0jZA4cys6el7aAxslOhvUMo7pTYu95EcHYlfsItGRuClCfUqunOg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36756003)(336012)(47076005)(426003)(70206006)(16526019)(186003)(8936002)(44832011)(36860700001)(5660300002)(83380400001)(40460700003)(26005)(2616005)(8676002)(4326008)(1076003)(508600001)(86362001)(70586007)(54906003)(110136005)(7696005)(15650500001)(81166007)(2906002)(6666004)(356005)(316002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:53.2693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 959f60b3-e718-4787-d7d9-08da309c080e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2466
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In x2APIC mode, ICRH contains 32-bit destination APIC ID.
So, update the avic_kick_target_vcpus() accordingly.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 29665b3e4e4e..7f820cf45173 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -375,9 +375,15 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 * since entered the guest will have processed pending IRQs at VMRUN.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
+		u32 dest;
+
+		if (apic_x2apic_mode(vcpu->arch.apic))
+			dest = icrh;
+		else
+			dest = GET_XAPIC_DEST_FIELD(icrh);
+
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					GET_XAPIC_DEST_FIELD(icrh),
-					icrl & APIC_DEST_MASK)) {
+					dest, icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
 			svm_complete_interrupt_delivery(vcpu,
 							icrl & APIC_MODE_MASK,
-- 
2.25.1


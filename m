Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B1951EB07
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447152AbiEHCoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387723AbiEHCnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE817101DA;
        Sat,  7 May 2022 19:40:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsJ+2Ldoqe0UFvgBULuTrdagTqLDrUUDii61fKm6X71WNB74MbK9pfWCanGBMHe22XsX3lSl/ylbYNkxCYOxXVrDbCyV3/mOIKLyOy94RGL+p/w+wwMpBAh6CTR+Ac3NKiO0OANQ/IfstzTRKuLLDbDZIOizdRdAeSbiBcy7IM2iabVW1rVNsobURK2CQkBwlS3ewdEg1IrADyGvHfpXHaxBUTyDDXUySps+ynOZOolEDP3B2KGwdKSZWt/3fTkELe4t1+zME01RuTagJPmb8r1cRY/hkj+0loCM7iW3HZEnWu7unMowEcA6NRlyz9sKzZFHvW3x9RkgTCKKwPNK1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=An59Audd9Wb4f9DlFPkPLOYObyXGIgmHhDYd1Z0I8EI=;
 b=Y+ZshlGANQ/KPuxcx+KSzz4TKxnc0C/anFMjlmZo1nYkJR79lPY53N5YnXsxOhwOWFCpZGeKl9RVqzQEbbbeSNEQaP3IXiczLWBiK9Ak6DR4ZQudiZZtVU6gj1PXpxqi96yTYAGZFWqtZSiDb56QFJIbM34zSCHyKniqTyrcSvN5x/aHHNp4zzb+AqgVamvygvV8sQL5txh7NG/Nmp5QY7JBgKE4nSBxWrP3Mbc0u8XObuCLJWH2seuTJY1sLWtchHX6smu4l8DCSjLNbVwydhqzSoj6cZ/cDWXtQ3rESIygr0c0Vmtc1NZKnUptvEwZrE3uGbaqJdlPOaqSepX6sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=An59Audd9Wb4f9DlFPkPLOYObyXGIgmHhDYd1Z0I8EI=;
 b=4R3TZZq7aMpwF2coPErtsmcBfYaABJ7tMpb5NTq/9CqEM7edf6r6AnQIKGAG9YePPkP0ptZDf/yAsYASU6fS/LZOmbOLxdIWguPsaMllSxx02XCA3sV5krL8vOCFyUCNdatX9Jl/2x6b0JgFbmTDybQtpwzmLIWbazpPjLabTpY=
Received: from MW4PR04CA0042.namprd04.prod.outlook.com (2603:10b6:303:6a::17)
 by DM5PR12MB2391.namprd12.prod.outlook.com (2603:10b6:4:b3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sun, 8 May
 2022 02:39:58 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::a5) by MW4PR04CA0042.outlook.office365.com
 (2603:10b6:303:6a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Sun, 8 May 2022 02:39:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:58 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:55 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 13/15] KVM: x86: Warning APICv inconsistency only when vcpu APIC mode is valid
Date:   Sat, 7 May 2022 21:39:28 -0500
Message-ID: <20220508023930.12881-14-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3bce7e82-12bb-4d60-1e87-08da309c0b0c
X-MS-TrafficTypeDiagnostic: DM5PR12MB2391:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2391A64BB7A687135E893602F3C79@DM5PR12MB2391.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ywp2MOGJXSEnMeriTa7aYjjJIkmfpa2SKVWjgXvBKqnU1+R0+9tRYs2bhkjDMEAjQAEi6Gf9LVIqktikHTFg0quxeKUwlIpiFmZqlgKc08uWVLjnz7XFwHSmBUlthdEFCTrpod3MUaeECRjQgp6zykRGFJEGFksROUS4zYCbFAuyqHKvfOrRskvJ/lTP5gBGS4fDlx3fbWQCYcc9kFnypkTPQTJ/eAqbgr4DtDh7iEXKndslbpISLHjdIaN2W+GYXeKuOx5JL+aPPsjxpSnLUE025l5rYIlqhgh0UguZD1eo4Y/K0FRcB+ePifD1BLtzu4sZ67D7nB3rtU1gerqY9Tz8dthc0gLx6cneh2+OuFdbhtxnYr6B2t+THEIohsS+T58R4R51nyoBE/9OUEC3LHUPeOWi/J8pJKkzTIlYE5VsBejXjHw0PLfE0Qj8YuiTHanFd1+3cFz+1WOrmSJXSIFMVccB0iWmb0/vX+NLeOT0TImoWlaqPOsBwTzugl3U8Dt7ilz5PW5uVbmVchL5oppdIQqalqkj56Vnp92HoVKfqodZ39IvTfZ/rwK/kJskQ7n8bIuxPPrWuRAKSBNKgZANVlLwu1/9oC95QtevJTDejp7nNoFLfnxBO1ebNkVgmVY87QA/6MdP5D/n4S5acyxIhHKLohBBpAsNq0lcamWV54r1+qidnAcyeivte/VKIZaizAHJsPOPlUIExCaLMQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(86362001)(336012)(16526019)(40460700003)(8936002)(508600001)(186003)(426003)(36756003)(47076005)(70206006)(8676002)(4326008)(5660300002)(44832011)(356005)(2906002)(36860700001)(70586007)(83380400001)(6666004)(81166007)(316002)(7696005)(1076003)(26005)(110136005)(54906003)(2616005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:58.2846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bce7e82-12bb-4d60-1e87-08da309c0b0c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2391
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When launching a VM with x2APIC and specify more than 255 vCPUs,
the guest kernel can disable x2APIC (e.g. specify nox2apic kernel option).
The VM fallbacks to xAPIC mode, and disable the vCPU ID 255 and greater.

In this case, APICV is deactivated for the disabled vCPUs.
However, the current APICv consistency warning does not account for
this case, which results in a warning.

Therefore, modify warning logic to report only when vCPU APIC mode
is valid.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77e49892dea1..0febaca80feb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10242,7 +10242,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 * per-VM state, and responsing vCPUs must wait for the update
 		 * to complete before servicing KVM_REQ_APICV_UPDATE.
 		 */
-		WARN_ON_ONCE(kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu));
+		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
+			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
 		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
-- 
2.25.1


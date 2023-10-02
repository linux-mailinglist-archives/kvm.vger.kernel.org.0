Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921CB7B5A3A
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 20:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238725AbjJBS3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 14:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjJBS3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 14:29:18 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF511AB;
        Mon,  2 Oct 2023 11:29:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnzoT0lpK/hgHiYt4AWTlDAE3TillHek6XzKgHNGHjYg8h0tlRI/powPz/dmvRNTwuoYt9htK9Q4ORZYx5S97WMFCu22l8v18YyKN1c3DVIpVPD1icfBxaNS8GIpunv4MSsvGUK0DA+lx3Om2xy0+yLfM/PdBR5M3eVpPGvWYs+zRnGmFf6n/QC+h19vIkKOrmQV2Vp2FQ6xopWW3kFHHeBvwSBuuQLioQkjCqCI+ABnt9RoO/6s30/QnOJK+ISgmHK4TaBPjluiPRvN64fBcAPAriVt7KjVuwq+jbPlfHta38ntC8MLr9UJTq6m3X4HTQl8l5Sr69ppZq15W9dHgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QS1TYuvO7jMxlCBmhMisG6uAYoxhO8OElCqBDKdW08=;
 b=eXPiacC0MFISqWTk0oit7BkfK6/Hea/0omefw5YBIPZwJ7BXeu/WsUESAj45Fd1RHCKciArPSZpBSkAfUXmc71W0tX4Trl9DU5LvfKRCNsB24uDF1hgx5fAyZlmW+vC/ZpUKbJPOAJGtL5U8VGJ4d6/xOrYX4PhOgb9whGJFSJyyPwS2noHTooUoVOnNdL7APvrmug2WmjZquvxWXTP1vU6nOdtHGp+ypu8OBXk+qjYs4YudQEB5NLmZEp7PZ9woTKs7LnGfELM5hHPGNuGGjXBikTX9AC5yxd2h3zXnxnrvQQCHRmIL65VyC/qlZpzP9pGHUCnZwVu+Fd+20i8+Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QS1TYuvO7jMxlCBmhMisG6uAYoxhO8OElCqBDKdW08=;
 b=D9jnXHLxshEpwIYfn6jACNUjccIiO98WRadKmSU3iPWfvFz5v9NButgecSE2SRn7QSMYR1MQe2LxP57YEX5VOt3xBJyAeq9ETVvQPcutkLguep6ULY/42DDWQvagWaTJYdbW60PyYAm6UQqvlIz7Jv1IZuQIOu6vrn5WRMULakQ=
Received: from BL1PR13CA0350.namprd13.prod.outlook.com (2603:10b6:208:2c6::25)
 by SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.29; Mon, 2 Oct
 2023 18:29:08 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:2c6:cafe::71) by BL1PR13CA0350.outlook.office365.com
 (2603:10b6:208:2c6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.21 via Frontend
 Transport; Mon, 2 Oct 2023 18:29:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.14 via Frontend Transport; Mon, 2 Oct 2023 18:29:07 +0000
Received: from tlendack-t1.amdoffice.net (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 2 Oct 2023 13:29:06 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] KVM: SVM: Fix build error when using -Werror=unused-but-set-variable
Date:   Mon, 2 Oct 2023 13:28:54 -0500
Message-ID: <0da9874b6e9fcbaaa5edeb345d7e2a7c859fc818.1696271334.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|SJ0PR12MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fa65c8e-5421-4adc-2c07-08dbc375771f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e8hTOSoF7/WjE3W2jDQU4yIlR9b6c2jzxMVA5Gl7Fs3KxANnXNWL0GpBXHv+hqsPY/5BXIJHzzsZBAfY+OQQQzmQaHJIevJ72GCOxtIcySMgJN2wPUyhB1KResNc+GvkaibQOba2FUqBAK02+0C/iT1n326H14CrPt1x0hF5Gz9W+8OGK8iicfvyvIpoRjs77jW1t4z64M2a9RVx9TpyBoRlriEAiLrBPs15s4ERTMvpkTnT89fy0jLc8sn4cSMPStlPKqL5T8utDfcEsTJsvqPXF4CMULjtNSXQTkRtDwlnBbDRlpV506Q8daU1ujO81U/VM4iyUr/zS73BYbeUjRwJLdTWTxtbc0+hnAySeKM3N9KmbNKTHvQ6PppvXUYVfj6Efoxor8t7e+FdQhFf5DLMixSAdx9th74pI6Tb5CGPWg0zGctsExbN2+izEzVYI3Q0kTKlRH400kV9KqCql4/UqaUAARW5viW08LxNWEZM2nIZ195Nd4eyOwuQ+1N1lXC2guPtdSNLKR67DhzXI6r7W1k/nGEarF1XXP80l8mPC2Vf+QFOE9FMGh9T88GPTTMnD/dW5VI1wRiCFyoisObPBm7lDfpu8+H0ZIvNWZr38DV2R/cOeT3FhnrKncWPu5Oxx0rt1vXc5dYuM7A8K9I8ufzVjhHn7sQ0+5KLN5wNb6xOcu5mBubVXqfVWp9NZfhuvyW5IcrQCUBvSMiCidmqYobDcfxAzxoZ+9Bypl4jYVonSWV86wY/gzFoZXYaVICGNYufRhALDY2SzWvGxA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(136003)(376002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(82310400011)(36840700001)(40470700004)(46966006)(86362001)(2906002)(5660300002)(36860700001)(8936002)(83380400001)(8676002)(4326008)(47076005)(110136005)(41300700001)(36756003)(336012)(26005)(16526019)(70206006)(2616005)(426003)(81166007)(40480700001)(356005)(82740400003)(70586007)(316002)(54906003)(40460700003)(478600001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 18:29:07.7678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fa65c8e-5421-4adc-2c07-08dbc375771f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7458
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support for
virtualized TSC_AUX") introduced a local variable used for the rdmsr()
function for the high 32-bits of the MSR value. This variable is not used
after being set and triggers a warning or error, when treating warnings
as errors, when the unused-but-set-variable flag is set. Mark this
variable as __maybe_unused to fix this.

Fixes: 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9507df93f410..4c917c74a4d3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -691,7 +691,7 @@ static int svm_hardware_enable(void)
 	 */
 	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
 		struct sev_es_save_area *hostsa;
-		u32 msr_hi;
+		u32 __maybe_unused msr_hi;
 
 		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
 
-- 
2.41.0


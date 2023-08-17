Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77BC77FDA8
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354323AbjHQSUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354262AbjHQSTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:19:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870D02D59;
        Thu, 17 Aug 2023 11:19:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNyef8qIEJm3wKLob8tXe/Cn+nVQXszAKv8H+fhgjSXiM+HJCMbNHXNHyltpfEsAtWwWDedKgO7uYtUvn9TNZAMuC046/38ytxKjb+vHfmG0QFpErjr5KkhBIv7NgDOday5Xp4vMFQa8bbXY0Cd2rwCqNTC2MdK/InBP7xCcj/o8Ty3DlvIn6c2+/7OPIV2Cm+aoA9UKjuH+Y8kUN315tkVbZ1cC5RtrP6OKZDB0rSV2A5VkqEkoc5T1z+eJCKXjImCwtUBwYL730RKQhNMOYOdF666iMos1700+0mZqaBnPsy3lS09gAZ0D9d7qvgbGUiJTIUqgvr0bmOIeJJMGaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zz6O1fNahd5V0Ha9xhmSWOpUvgB48Xx9L4msBIbs8ok=;
 b=kEjnlJzEiEISYPqnhMoxbFYrXq4mylpFMjfXTQpe+H7ljDk/1ifrecPCBjzS3zB1Z1K3TGPrfwTAE0rs30nj0wf/0XHum46FkIWn1XP+RdxAoq6Pdp4sM9jMjOWgvj0KJS8pRFnzjBvS5scN0l92eXzTWAqei90WQjOdxQ3t1nXG3YO0YH2w5ihyNy7fWfmLa4flrm/fvgYy2tJivqIAv+D2e5t47xkwWRM+5nNqfP5CwfIFMDegUX3FcKpfOylhDSU4HGXxXSR6OzWwOJSzVqQETkaqunVWCdcx0mfF3J5e9qyvjUmuwP4jNXh4S8HcBSeEETvbRwViVCdpzBjRMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zz6O1fNahd5V0Ha9xhmSWOpUvgB48Xx9L4msBIbs8ok=;
 b=rmN0nJiU/A65ks/BDxVYp3eEcafmrNpDLKEtUuT0JgCcS3bpkJppNCUm1p4dUcxB91pq2gpJTQv1CLylX5e7RRsf8N47i5mBjzE7mM8OJHfxEq7AcASyqZKIA063TSOZkRvY32dzv5ZfN+ilWkOrCnnNECKilZJDmnFALzDejzM=
Received: from SN4PR0501CA0120.namprd05.prod.outlook.com
 (2603:10b6:803:42::37) by IA1PR12MB8538.namprd12.prod.outlook.com
 (2603:10b6:208:455::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 18:19:41 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:803:42:cafe::a2) by SN4PR0501CA0120.outlook.office365.com
 (2603:10b6:803:42::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6723.6 via Frontend
 Transport; Thu, 17 Aug 2023 18:19:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.15 via Frontend Transport; Thu, 17 Aug 2023 18:19:40 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 17 Aug
 2023 13:19:23 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v3 8/8] KVM: SVM: Add CET features to supported_xss
Date:   Thu, 17 Aug 2023 18:18:20 +0000
Message-ID: <20230817181820.15315-9-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|IA1PR12MB8538:EE_
X-MS-Office365-Filtering-Correlation-Id: e165db64-cabe-4191-c347-08db9f4e8600
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WeL2jEBPBii3PjZL6VmwBwa4AxIrzUUOMgnNsuCfT+k+pu5uVkCFXdURW7cUGKk/TFU+nvwFkfaQ08HAYekc0d0ARoW6e66SVL9eiLtjrf0MmOAieHmdtCVOB+Jquo+iYLZsf9LpGFO1UWT30q7mP7Yl4TH/yHEtTeFQd9zn+HhF0F/r0ckHzuVV8zA1hhiNtvPmtZtHl5vuxWOZ8/wVmEkwSpeEZVhkfslv504hJdXONFoC30W48GVwJeVA86i15Y+M7x4YbEkOVYD1OnxWQ/xQpOeXUZ2Bb8UjrL94tlyYkNY/qKH/XbPdvgVrRBzhQuqFw2sY+t0454qQ4PoCFEbR0j8TvAbRCyYzJo/JgJQjsyfH93h7pXnCaHd26MjyfYmyLggpAK61OmvU8IHM3U3xDF41IfDSzu3Dsn8DKZDAftM5m88HbZxljJ1r2iNiB+xBu0kTTTkvaIeWarD7G0iRZTLaYHrUj7pbCyHi9QaTfudGv7ZITg10piGqC8j5Hs0EV5Rk2oeDpknuSdxX31TcC2ThFNOl4O6PKkTtt8VIASDpalOiO9v4tqux1lJ5Sxfl0QXlh2FFrl/LzdT2nUeJ16zZ9UYi+xjOPdLvItVGvkzRGi7oe+ZKcGxZcxuX7y6MsEdvIf0de5hfBYd1zWaTbVn4Jkr4pE6c/JkR8x6rQwysgQ63SaDdVpJrIxZ1H30+t1MAdG/CuPQCK//rILzESGQB5clJMvE6KmkHVvKlZ4n0qrphHR/w9A2T2Tm2qkhjmfF1RuVTGtE0mQOrOA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(376002)(346002)(82310400011)(1800799009)(451199024)(186009)(46966006)(40470700004)(36840700001)(40480700001)(40460700003)(54906003)(316002)(6916009)(70206006)(70586007)(478600001)(356005)(82740400003)(81166007)(4744005)(2906002)(41300700001)(5660300002)(8676002)(4326008)(8936002)(36860700001)(47076005)(426003)(7696005)(1076003)(26005)(336012)(16526019)(2616005)(44832011)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 18:19:40.6894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e165db64-cabe-4191-c347-08db9f4e8600
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8538
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the CPU supports CET, add CET XSAVES feature bits to the
supported_xss mask.

Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  - Remove curly braces around if statement
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 683bf18b965d..685f8715a716 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5105,6 +5105,10 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+		kvm_caps.supported_xss |= XFEATURE_MASK_CET_USER |
+					  XFEATURE_MASK_CET_KERNEL;
+
 	if (enable_pmu) {
 		/*
 		 * Enumerate support for PERFCTR_CORE if and only if KVM has
-- 
2.39.1


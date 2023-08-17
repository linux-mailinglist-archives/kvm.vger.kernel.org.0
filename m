Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38DE77FDAC
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354294AbjHQST5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354236AbjHQSTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:19:22 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96822D58;
        Thu, 17 Aug 2023 11:19:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRW93ECiCSDgbwEkPjDKH/LXG/Hf57D9z8Mouv1Mgapz4bkTgeyDbJpVjmZ5IOfjX1bj0PYTca1gEIKwWcmuxvBZRe7tIbqwNn+4d7B152OP7Du45Pc0uCwomVBJwl6bhBAyFRQcAaZP0ct4Nla7QPVw4uXAPDyyqB+H+REwuD5Acsk9RZk2/u9oWm3u6mh5AceQpaxFkVkRzANw5apnVdjL2M7+iSM3G78pXOdENdZ8h+esOjH3ghwK6FZ2gEUxQonDsJgMds7WOhbLNw7RrRpDQU2v4WZgGgnMULU1c8YqAe7WT/trMIhcApgVzO4MxXuXAYCBlpfVhD/PeizrPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIr75Neepd2qt+7JJ3WDANWh1fjDpvkb16EW7Zo1BAo=;
 b=F3kanseTjdGFoHfxpJQn2Y85JbupJQOHK9VFgyB2KAorrrSruEJUfmKJNvcCUYCl5bCtELA+561s8KqLlHL0MBELK73nl5BQxlgfzIuw3ZPWZUfvaHjS8qFFdE7OD1Jomyk7o5nmyzol93yCTP90p+m5OYc4aq0xbvVTG3bKTfYvdrkfYTnTddAWVMI/AAFYnWqV87qB+egiW9NqMaaVs1vTlzwFO0yGXcf1Mu9AWnVgJb/9+khQ5krZ15ThBHsO6lhB39z9OMmj+hJe63ylJWnRcszG2otv9VLOc3K1eu5LUlGYz1qAL/yCukMUIKtcoVyeqByT/83SrZyxKNAz/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIr75Neepd2qt+7JJ3WDANWh1fjDpvkb16EW7Zo1BAo=;
 b=jQKdXEwMXwpTWS0hyNcY40EKU6AypXZv7hudWATfeXGI767bD6Fa8teJtTQn+ifO0/QZagPVxyq2q4Y0ttjyMA/cqIKsegZ1kEWnbIpFrLwDG3+3Yt4tfANlQ9FiqSBgIH334Lak5PmnsEWAANHzymyXnS6JRSt49l5UihNddSE=
Received: from SA1P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::19)
 by CH3PR12MB9025.namprd12.prod.outlook.com (2603:10b6:610:129::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.29; Thu, 17 Aug
 2023 18:19:17 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:806:22c:cafe::6d) by SA1P222CA0022.outlook.office365.com
 (2603:10b6:806:22c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.33 via Frontend
 Transport; Thu, 17 Aug 2023 18:19:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.14 via Frontend Transport; Thu, 17 Aug 2023 18:19:17 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 17 Aug
 2023 13:19:15 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v3 5/8] KVM: SVM: Save shadow stack host state on VMRUN
Date:   Thu, 17 Aug 2023 18:18:17 +0000
Message-ID: <20230817181820.15315-6-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|CH3PR12MB9025:EE_
X-MS-Office365-Filtering-Correlation-Id: f7ac313c-f854-480e-c157-08db9f4e7833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L8OqGzgmaM3+0aMmEjLAbLpVrj4N5znN1pbbxhSYS/+WzNLAcC/CtkNNtqWr9/FIL/cna0phSFB6i70sF33iJzjwYNSNX73m88MFCsoFbBGcaxgUBJX1e7JOfVOA+niWdEsItUpzfW/kAbRMFNlGH3+aYJdTgSCldtLvoHDW7HbgwkXEk4Kgm7/pHcTc51CqvI14rApY0AUrYNCt+jB0ot9gZi53VgZbuddCCtgd4NADpcnEUoUOu7QcrdKa8/O7fy4X7UGVSCD5NtWO+M/9GGafZXQCiwq0Mrnp/qar73a5GQUMnoG4DzratssiSb1cbYIfvCOFqLBu25XIVcCuC8J6LbelAfK73g3cAbAgQh0m5fQ7KobwH/STaE6hL5v+2sGqsdKIjwr/L2vr4QfX/FoiNytr4za6MTxJZbmclUeZ846pzMbVL+AlLf7RKiq58lKWCbr98C+MlEci3W02yPZPqd0aRxqD6MLClR0ujs1sAm6CmOeqwt5BEZsXiDRJjV+rM1OgED7o5XdThRW+cWX26u5M5Jf5tW/jJ6HC4nvdr8aGldDIJstKU2exOvFNViapujpIe4E7tYG8dPNBQsnM6EV2qTAwClgbAW3BsMfGVK4C6LKNovBm59cp2fvAAoN6EFKRUu9oSqa7J7RzOuBp94kI1184Q4R0y/lKI4RUBp1fIXuaj5vUjZx4+M337TEbwWr110USz+JFdEWF/RJ+x4NiMaMMucQedRD+SeIyTZq5wFKGeqKlGDPPfOOhKazveQ6XdqVyQqh0gpkrqQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199024)(186009)(1800799009)(82310400011)(46966006)(40470700004)(36840700001)(316002)(54906003)(82740400003)(356005)(81166007)(70206006)(70586007)(6916009)(5660300002)(41300700001)(36860700001)(44832011)(47076005)(8676002)(8936002)(4326008)(26005)(40460700003)(2906002)(83380400001)(16526019)(478600001)(40480700001)(336012)(426003)(86362001)(36756003)(7696005)(1076003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 18:19:17.5355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ac313c-f854-480e-c157-08db9f4e7833
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9025
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running as an SEV-ES guest, the PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP,
and U_CET fields in the VMCB save area are type B, meaning the host
state is automatically loaded on a VMEXIT, but is not saved on a VMRUN.
The other shadow stack MSRs, S_CET, SSP, and ISST_ADDR are type A,
meaning they are loaded on VMEXIT and saved on VMRUN. PL0_SSP, PL1_SSP,
and PL2_SSP are currently unused. Manually save the other type B host
MSR values before VMRUN.

Signed-off-by: John Allen <john.allen@amd.com>
---
v3:
  - Don't save unused PL0_SSP, PL1_SSP, and PL2_SSP MSRs.
---
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2cd15783dfb9..021ead4dd201 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3097,6 +3097,15 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
 		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
 	}
+
+	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
+		/*
+		 * MSR_IA32_U_CET and MSR_IA32_PL3_SSP are restored on VMEXIT,
+		 * save the current host values.
+		 */
+		rdmsrl(MSR_IA32_U_CET, hostsa->u_cet);
+		rdmsrl(MSR_IA32_PL3_SSP, hostsa->pl3_ssp);
+	}
 }
 
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
-- 
2.39.1


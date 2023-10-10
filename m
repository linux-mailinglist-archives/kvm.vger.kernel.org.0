Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2237F7C4091
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbjJJUDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbjJJUDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:03:36 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51C8ED;
        Tue, 10 Oct 2023 13:03:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwd/PvTVXWI6+NIxK4bO8Ix3CdE/w3ZgbMakKbZjtufwdkFr8G4solQ37/lw8QcVqlm3h5OQwrIXohDLXqIoW5l0vPTg2jfRlacZCM8nJkEX0DY5Zx/5tFc1haCoTVo2QMBX8ujMrEp0FvRePVu2PWudlkZdrF97+kAq2clSvOj+Zni6c3ymGpawx+miS2cHygW6dn5Z4Ln9YLInvXSVchdmFH++usUHiNccSdwxhKOMEwhBfU96oeLJzx1LREpe8O2YiwMMr0GonSMk3SjwL0hRUGCxfnUKylI1koMEj2njT2mwYDYKt92rNFVaQ2UFa+JHXM3+gHHyRlYU9lXgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AebH29OH5xeknYQdHx8m0v5SBb8y6zsXqPcWlCxf44U=;
 b=U/VHO1dg5tCxDGZOnprVwrm4BDYMFNMCntzU75c7ZocyDv4gyyKrJQedxP4y6b6EI3RHGnuv+YaHeDIom1G2HKfESYCYVMkJ6gm2k/Qt0wC/8/oRnWPLqIRKtQdIOA7EoCsPv8W0vZuNk/Sd0og5h8iLhRkClFFngVPom7/ruucGevF7FcpD3jpmFUbtezRHC+FjaUJqD7IjkCyRYXCZnu3iJH6N5nn62UtqxFHGPXvolunHXWMe/LQPqhCtcbf5xn+foJ6iftBTGJ/TY6BpaZGQJEu/GWi6nSY7Svig063DII4qAiPJ51hd1Lu7y09wk9h+rCnczHUXm4Yfv0rfUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AebH29OH5xeknYQdHx8m0v5SBb8y6zsXqPcWlCxf44U=;
 b=PYbvPluCWRNw6iFm9b5Phq+ZSn6hKUegTeOrCSwgigal6E1HV0QYI3r6yzqCudoQa0fm+p7VRkuoNyj2aCGEv2WJolgTSW2WX3bsboEwihI+JZdhlDw11o8Fa/Mxpb81ZBuCUHXGpGYLv3U1h6gAcumWFR4FLWW+LvoSu5tPlWk=
Received: from DM6PR03CA0086.namprd03.prod.outlook.com (2603:10b6:5:333::19)
 by BY1PR12MB8447.namprd12.prod.outlook.com (2603:10b6:a03:525::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Tue, 10 Oct
 2023 20:03:26 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:5:333:cafe::70) by DM6PR03CA0086.outlook.office365.com
 (2603:10b6:5:333::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38 via Frontend
 Transport; Tue, 10 Oct 2023 20:03:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 20:03:26 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 10 Oct
 2023 15:03:25 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [PATCH 5/9] KVM: SVM: Save shadow stack host state on VMRUN
Date:   Tue, 10 Oct 2023 20:02:16 +0000
Message-ID: <20231010200220.897953-6-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|BY1PR12MB8447:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a24d432-8c11-4c1a-194b-08dbc9cbf6fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuspEkZLMHUbe4nhaK1wtMuiT88z9+HdFdlEK32RIHUvxGZZ5tAWgjJRYehEaNfcfotkGL656mfcv7GIuS18zbGhh8A8PbQ+eartDDv5z8G+x0NVliFZiA5Y7MZs3CB5XsGWvsSVjZ19CQcqPSzmS86XSgtJxkQC96w6nNV+N2RBen9WsPyesGF4wjHInRRHJ+T4CGekuCKcStA/g4YVvrenG3jcREdpKKR7SpSubxwi23wSq7pmJg/5LK08wz62wsiXtAdaAhYCBXhBZeuOYvFUwmyMm5sYxU7cLZ+ZB/rSHRif54vk2806eQ9D3sxul9pXBXszulqmqGuPaR3Xjyhh73kvEI2L7SO46pcuv2dHZ6a66qy0pqYCIwmq2/6s28evkKhohKFZsw3A/jqVtgiFpcXMW8wD8cJy0rG2ST5fcOYl1TCOf68A36RSve8zv4uohQXA1e+Xc4zNOqU7OxhwhjV0fnXCP8a/RK6HYfuFaLmnHYlbW1p0EL0WQToPA3biVpteGbnO5Mdn/I0fGWS/sHPUVZFY+tgU9AjFQ89jFDsM4VTI9BoSMyIJ8GCoSsh/m8ykWj12B85nXbj37quCCUvX4gKQ637UD/+ad4c1Nt/vX42QpVUYkzfhr/mBuGoswbuV3HboxISRHHmuCQFvBt+76GKS9ElSOb/lXpkRQaX5I52uCPd6qV653CgkW6y+3jJ9+l5oURZTVYsK2G+kF4zJkO/PoPzw05Zy8+PEIcVB2bGkAU/VReyaJJmK6oRf9pq0GoM/2im1bKGKwg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(39860400002)(376002)(230922051799003)(82310400011)(451199024)(1800799009)(64100799003)(186009)(46966006)(40470700004)(36840700001)(81166007)(86362001)(356005)(36756003)(7696005)(40480700001)(6916009)(2906002)(82740400003)(478600001)(8936002)(41300700001)(4326008)(44832011)(5660300002)(8676002)(6666004)(1076003)(336012)(2616005)(83380400001)(426003)(40460700003)(70206006)(54906003)(70586007)(16526019)(36860700001)(26005)(47076005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 20:03:26.1667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a24d432-8c11-4c1a-194b-08dbc9cbf6fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8447
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b9a0a939d59f..bb4b18baa6f7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3098,6 +3098,15 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
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
2.40.1


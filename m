Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9A370FAE1
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 17:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbjEXPyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 11:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237559AbjEXPyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 11:54:40 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227E8123;
        Wed, 24 May 2023 08:54:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcqegUALGSMSe1JrUaqq2iHxD+vko1qVMaLH97QLz4/swUnKY+mLVIlnJFOEilt4NkYa7eLAhtsPSvSVGW32XwFN6IgFNgu6NuxEVN6BfH7+foynQGUi3xRTZT2+hNzwzwG18Zobtxg9A6yPdFSxlRAigFYOqLIjNaPPmP4uYUdxFz/nB5Az9QQ+3E8afiyWWvleSEUj3hZSoJr6UxI36JI2IHQDwVGXICEac/EhfJXuQlYUwcBLR3Blldep1+paq/6FyUYHOzPAsqFoDl3J3CBnE4EEUMn82hmKBOiY/5SJFoTrHlqCbcHdYpisiOGoPLUwvt4rIyUkljUDaWVc+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tMnY52pgZAV7LxEzaa5TurP4B844esvfFWyoXxyzGrY=;
 b=WmvI+zLqaa+vHtLOW9QTtg1MBqjGgAKzJnB6Q3cTAZ3RwHrF/6KipL3D/M6jTRChPexX644afwDrvbqI287NTSXURahgqQqCaivIXD5ZkjOtfHD6apj/Nhdi1eO/xsWHtVtmJ1nQhz0VKrHFi1X9p00XaUG1cU8NyBCWYH1ffFaOki5qeAYlIKP2btX3YGYZbkQobxFdUClL0f6TcfBQv5+D4rqh/uAUvpnJsHx72syFB1Ye26ThQ+rozBzvOccz8Cdk/DAQiDNWwrhehlv0nNg6IIWEW+ybv1mE7ZZJ8xDn0FM6ptXVqfRslpFGR6cOXgBxfOBDLxyFGCqAMM4kBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tMnY52pgZAV7LxEzaa5TurP4B844esvfFWyoXxyzGrY=;
 b=FflzG1NIhGllM/6saZ3fYIejiuUf/NFIb5CuzPM3g0OPX7uhovRBACM9rm1VGnQnFNdrKK+7X6nyY9XGJIqvz82iGFU/BkF625t7wXxlqyAObnagr+MUZrthSoLmtX7zHJxlg03I+tkr4Zd8XDzJ9CaLcxfIM2hrmRyFqP/Y4Mg=
Received: from BN0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:408:e6::19)
 by SJ2PR12MB8739.namprd12.prod.outlook.com (2603:10b6:a03:549::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 15:54:36 +0000
Received: from BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::94) by BN0PR03CA0014.outlook.office365.com
 (2603:10b6:408:e6::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15 via Frontend
 Transport; Wed, 24 May 2023 15:54:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT077.mail.protection.outlook.com (10.13.177.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.30 via Frontend Transport; Wed, 24 May 2023 15:54:36 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 10:54:35 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v2 4/6] KVM: SVM: Save shadow stack host state on VMRUN
Date:   Wed, 24 May 2023 15:53:37 +0000
Message-ID: <20230524155339.415820-5-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230524155339.415820-1-john.allen@amd.com>
References: <20230524155339.415820-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT077:EE_|SJ2PR12MB8739:EE_
X-MS-Office365-Filtering-Correlation-Id: 436d93b4-7e98-4f71-fce4-08db5c6f2cc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6r+uBJ8XUUE5T1wpPmEVoVQjXls9ES2RWV/UyDDTulzmNSiVnbk5LGiEi9CN6XX4s0LhqbxhHGDxqxGvc2UCIZCAA5AUdpgKgX9t1Bct5r5vCrIZNINP2AIKSdAMDXoTXz0Bzd6glxk2byULhMtVf/kG+cCdsKlbfX93rvfvVe7De16Tdsj920OIlryGW8qY7vTntPwGrFdxJ0W1gDmpaddkI+JIj2mimc5v8epHwpoMQQiqQHFRoFl4UndUUw968CDBTldhVRsFdIMEaCyfgZ5bbODIUB0Vkku0QSdWAGIUsQ9DQKQEftiPpyxZABC/wrPYSN9Wj2Y1Vb2IBF4nDlqaTXnKOBUILN2Nwv1iM9VdHMSAbZiJO5ktD+LkE3MV1lA2f9Iyg7xNgQFDT8mLpKjQed5XoRd2BS1r2IlXfRYf3xVuHKCv+YJ23IOsNrloYhBSTBIWTq3OY1fEU1pyvE8cjWh4M2ZG9r+1rnYADwdBwEpFvmYPiUHKsB9r20AlvNe7A4LgonAmobX9SVA0DYmaMWGBkC9RSVeCipaY03jAQ1I1Ryu7Jeav10Ms+X5aynyGU8lUHCG0DhZdLmLWkao7khl0R4XyiEqbzLqH+Ca0osGnzgtuMxLK0i7jCxtQ52nNER7Cns81Z9P6GJfFqXC4bHigUxNTI676jfCwiv/D5CZjWqYhfRWl9ExRECLknd6CDApNYK7LOvp6S8nkfHc/HlmGbCz0q6x2Ibji4UkoNv9tCryvoX4oBfGm+9NU9MZqCxvcZ2yaOxh5DAyg5g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(70586007)(4326008)(70206006)(478600001)(316002)(6916009)(54906003)(36756003)(83380400001)(47076005)(5660300002)(26005)(426003)(2616005)(336012)(16526019)(186003)(36860700001)(1076003)(41300700001)(8676002)(8936002)(44832011)(2906002)(7696005)(82310400005)(40480700001)(86362001)(81166007)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 15:54:36.4886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 436d93b4-7e98-4f71-fce4-08db5c6f2cc5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8739
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running as an SEV-ES guest, the PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP,
and U_CET fields in the VMCB save area are type B, meaning the host
state is automatically loaded on a VMEXIT, but is not saved on a VMRUN.
The other shadow stack MSRs, S_CET, SSP, and ISST_ADDR are type A,
meaning they are loaded on VMEXIT and saved on VMRUN. Manually save the
type B host MSR values before VMRUN.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/sev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c25aeb550cd9..03dd68bddd51 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3028,6 +3028,19 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 
 	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
 	hostsa->xss = host_xss;
+
+	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
+		/*
+		 * MSR_IA32_U_CET, MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP,
+		 * MSR_IA32_PL2_SSP, and MSR_IA32_PL3_SSP are restored on
+		 * VMEXIT, save the current host values.
+		 */
+		rdmsrl(MSR_IA32_U_CET, hostsa->u_cet);
+		rdmsrl(MSR_IA32_PL0_SSP, hostsa->vmpl0_ssp);
+		rdmsrl(MSR_IA32_PL1_SSP, hostsa->vmpl1_ssp);
+		rdmsrl(MSR_IA32_PL2_SSP, hostsa->vmpl2_ssp);
+		rdmsrl(MSR_IA32_PL3_SSP, hostsa->vmpl3_ssp);
+	}
 }
 
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
-- 
2.39.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910715FCC2D
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJLUkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJLUkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:40:03 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDCA558DA;
        Wed, 12 Oct 2022 13:39:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3MC7Hu6iKeyYFpMgUbGcpCm9w+/Zwg6NPJgKLTl2ZoEMzLhaR8Iir07O9vT7VDRRdvQw83cN9MdR40Fpz5JzPq4bDjYTa5AuVZl9W6QUJJ5Pah9HwBgFzmCjN9PtnYvtbY27vdEdBjcK0PXPSJ6ORlw48JxyA3ecdxxGw3XmPMfN541GCqX1TiWENtI6foDN5loL7a/v9OYogQ4R6Lu0ltp2Hzr05FYt9QtBIojguD3ZJ7ACnnN9g40uL2Eb7BZEId5B+Y+v7hbhLE0orNnwevhVvvR7oY4FoTrlQyeYclPN/Y+pda/wDRzVfMaR9P6HoxnbhCza/BtEHRn/6S1dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjtLWaNLnIOShtJrHhAGGg3GAh42EkK0x9T227Jn98c=;
 b=iEuIEDAmoTC3wwXveO+OAA6GmUBVOJowmFbzZbsfN3uP39OvbKboQohoCryPMQghHtLQ7EikqcK7y2PNxg3Avf6b0NogSXsrLrSB6Dq62J0HL0DzIIPcldg1/SuvikiExrnKz7O6zN0fKxrTFmFdJ99pdGgcawzYSMps38pZT/p9N6zyGSnd7hCvX2m3t9pe/UQ+hjJjuSlpCB8DhKa2ZK/SH9lfzrF/TxU9L6EV5/rZ/62scHhVvUX5B0LSVvgfOpXsRAm33aGH06hguQGjUACzLABxa1kp5TZjcerajaHdUUjZT1jPk1s5tfziRx7s1r4PWmA+2ZbSY2kxNgurAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjtLWaNLnIOShtJrHhAGGg3GAh42EkK0x9T227Jn98c=;
 b=JtLvy3/UMMifNgG1yYBtskJhlSS6J98uuLitoxtcDDN8cfBCxdz2M0RL6x8BYflsmCS7EvPRyP5dQPO59OnJ1Skddd/W+DS89Yg+cYKbwkSdt2ad0FAr8R58ihr1iPdloFC/0O9Q5x/QwwyAB16kmniiycAUXg3daTqwN5oVrpo=
Received: from DM6PR02CA0041.namprd02.prod.outlook.com (2603:10b6:5:177::18)
 by CH0PR12MB5217.namprd12.prod.outlook.com (2603:10b6:610:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22; Wed, 12 Oct
 2022 20:39:55 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::5) by DM6PR02CA0041.outlook.office365.com
 (2603:10b6:5:177::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21 via Frontend
 Transport; Wed, 12 Oct 2022 20:39:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 20:39:55 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 12 Oct
 2022 15:39:54 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Subject: [RFC PATCH 5/7] KVM: SVM: Save shadow stack host state on VMRUN
Date:   Wed, 12 Oct 2022 20:39:08 +0000
Message-ID: <20221012203910.204793-6-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221012203910.204793-1-john.allen@amd.com>
References: <20221012203910.204793-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT057:EE_|CH0PR12MB5217:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a96f081-4bd4-459f-90f5-08daac91ebdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nHTwF3oqJth2FzgpnOWhvq7aVZ9GlRYMzBqYk1qi8BuAAp0LjTMrxvk5Wi4DpmeJzA18wz4lQMEHJFA/6fLxsSjYixWkdsOPEtKwTCFbx2Swv0KKtkQ/8vVQG0qvPok2so7r63MdhJJDgS6rR9abQVsoPHH3uRVbUzlv8XUIgAEIRk82BLwKj2pRinZlBLfte4bFDQMDcqcKCDWAHQCNZIR4EnbbjMmom+/vrr7HsYsy2lVcaIHP5u7G88cPDRiQiwY/fjujTbBNeClSMmmsR8lZNeddApOmV3mHRuLgFYjqNUGICMrQNb0FBhf6TarWA/HjBuLKlIY0yP69oq2xO1giHoXjeQx2JNM+Hgs9U1SEiFfYDXsgDDZEo6xdPaxfc6l0dXAPTYB2kCohqkpm84Togci+81jnfR1pYT/HLlCa0jIpdFDaL93S2aP1MABn6kYbLF4SqmnNIaoothgskalLOHEsidtE+N7jEONvgZn4k9yqV8I2HmI/e7d4SlhzVHuislLYCWbVDdiD833a/3ySTzXlDsHYGJssGHf9bnwrbpOKQf5XiMKEix5ZIWGHTwB/FPQiNJgVgnnNlOVp/0q+qJU7f5u2EC8YeNJqdHVg9YjgLiPfzFH07CuKEpE7LYkCksGSBuXifC/7upkuVuG1WtTkXw7PDV722/4mBxOXx1mfqynVxczYT3LA6VikW+bLlfPcI1rv1xXF7q5yC+3lnKCbrQf1ENOK7GE06Z857RbpyA8Gbj8jLnhe4YRPQnVyRThBkp0oU2FpnxZ/nnbACtg1UANkR3heAMhGWJE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(36756003)(36860700001)(44832011)(5660300002)(356005)(2906002)(2616005)(83380400001)(86362001)(81166007)(82740400003)(426003)(186003)(1076003)(16526019)(47076005)(336012)(4326008)(7696005)(8676002)(478600001)(316002)(54906003)(6916009)(70586007)(70206006)(82310400005)(26005)(40480700001)(8936002)(41300700001)(40460700003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 20:39:55.3254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a96f081-4bd4-459f-90f5-08daac91ebdf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5217
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 28064060413a..a5e72b2c94aa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3027,6 +3027,19 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 
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
2.34.3


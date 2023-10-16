Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0E57CA996
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbjJPNel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbjJPNea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:34:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFFF12E;
        Mon, 16 Oct 2023 06:34:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgg0JJo1eAjfpGKpHa1gAsdQvAlLERM5u/aq9JuOf5FRiqON8E5PptIsLENq/Xn5uq3sy7jlHsLOkNlpr5RURuC4BsJ+nuag/KOUnRKUcSgCMdp0xbuL4HLhPwpO+CCU09V3VJZjQUuJyVCr1EgKhBc/qUoshqsIQlFSYAnXJ+2SS0/FHCZt1vwKYKz9jd/x7uDHpHoWPhk20Gz1zd8aeeuelIy5rhmmfbDSfWot9Xb7rIO4D0B1nZ39tmCI/UjhPnBSU6hkVgqi+o7PLxLgOySWeuo8IlQiu6sWMmCMbRenDTWTLirpDqXVJjQxzsQWmzM6OdkE93ulr4qwa5tqsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9C/ZG3T7++Fj+seA9VNp4Z7hIxro7PtZW0AauElUUI=;
 b=fdLBcV1MVUK2jxqyFw67/MdIKg27+NZ5p41T+w5lVySHo2/MxsEW2RGTl8eA9G/UT8lUnz176ZfoRE2Qhrhw6IQobWkycdQCBLO+t4D2PHZO5925bB7sEtyahdnihDrQf8tR2pyUIJLpDhHUkjQtHYZ5ujST/bqlmIbburlTQEQs38g/RZ5QzT+mTAIRsxNe3e8jI1fS+1EiqDDurpVZkMbDcWs51VSqO9ehbWez2gZNjQgK5huZu0kP6x/Cv5CAWKnLLyDnzmZfZG5F6YyHZ2G9+2VvMC0WDb/pU3T9O6jgtuNl63kan1iKNaujYIcJmCX0Yyi1owRycpGRPwuBqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9C/ZG3T7++Fj+seA9VNp4Z7hIxro7PtZW0AauElUUI=;
 b=D3xU2YMX3W25qrFRp4X6jA/99+Id9hDSa7Yal51Yn3khOyRDszCe5EouC324yjgHDIrXbvHe2zIUqk7u7rJnHFD8YAFpSjJIDAYSoP2W3FsLE4Gjb5uz7AmifzQwWYVTiPgEawHRAxG9ayxJD4Q+QjpU56EMyRm1Hx/856iQgOc=
Received: from MW2PR16CA0041.namprd16.prod.outlook.com (2603:10b6:907:1::18)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Mon, 16 Oct
 2023 13:34:22 +0000
Received: from MWH0EPF000989EB.namprd02.prod.outlook.com
 (2603:10b6:907:1:cafe::71) by MW2PR16CA0041.outlook.office365.com
 (2603:10b6:907:1::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:34:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EB.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:34:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:34:21 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v10 01/50] KVM: SVM: INTERCEPT_RDTSCP is never intercepted anyway
Date:   Mon, 16 Oct 2023 08:27:30 -0500
Message-ID: <20231016132819.1002933-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EB:EE_|DM6PR12MB4106:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a4cc97a-60de-4128-5476-08dbce4c9b79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bceig7A/dbpt4tNnp4S0Edoa7UxGXuz+cGZDU13JlD2OXce5z7TjMKTWcTUt3Gd1Juyxhf+cIkR8XHXIbunyJrmmsyRAfKR3Qj3o7yBBASwqUJGcE6fRTddu2bQFqq1rlqAtT8snNsRvtUU2//l3PJetI2Driy2fOBCVssZhBFx87VibPVT3RO+39IdfRDdYli02ujcQTKxxU4iDDRjpziHUzeSLdlCjuEe9eW456jKtM5/3IvxqiUCo3T4gE3YeIUvvVHVGhQH1dExDOlP+fCM7yGbXHnL8h0OhJNqb5x3hL78WHYl1DS83s5bJsDcT1/h7Q359+aMgyII/+xLnXaeGNW1UjX1QZUr10mIxQEs2hiGKguRjLsKMXKyA7WnqLfM8AvZGf/EzzFoCT9GKre3fv2a9rNxAKRm/VoolyHruY0IXtsnVcQwhsIuNfy1q+uZ8uTCOqt0ze8LR5TgRyPjGeSeL2BuWlfNVe3ilTDsp1f2uCccg4IhXxAv6Kf5+zbFQ4Gwzo11Qvc0AAgcPOAAGhrxkOIgKZSWK5kIfrk5x9kK/nm0rKG9F4v+waRTRW/1/l5+YUBZqWmcDtcOlQulMRm7XDORzUGKa06H1pXHCDhtAHlQQyJBkrmwCqIVOeAHrrPXHMz1Hj8UGxKX2XN0fenURBtOpCRDcesWeaFW3eA1SVsvIcvMNkBsoDxB51s2VY+hnMpvWiuX3p8nA7LR0q5ZcYPBHCLzD0lbLU5YthIafV30iVAGohuMi8LefeWBumt/88++5PWEtzmkZaw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(136003)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(82310400011)(451199024)(46966006)(40470700004)(36840700001)(6666004)(1076003)(2616005)(82740400003)(356005)(36860700001)(86362001)(81166007)(36756003)(40460700003)(47076005)(44832011)(7416002)(6916009)(316002)(478600001)(41300700001)(336012)(70586007)(2906002)(426003)(7406005)(83380400001)(5660300002)(26005)(8936002)(16526019)(4326008)(8676002)(40480700001)(70206006)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:34:22.2594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a4cc97a-60de-4128-5476-08dbce4c9b79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989EB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

svm_recalc_instruction_intercepts() is always called at least once
before the vCPU is started, so the setting or clearing of the RDTSCP
intercept can be dropped from the TSC_AUX virtualization support.

Extracted from a patch by Tom Lendacky.

Cc: stable@vger.kernel.org
Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
(cherry picked from commit e8d93d5d93f85949e7299be289c6e7e1154b2f78)
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b9a0a939d59f..fa1fb81323b5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3027,11 +3027,8 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 
 	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
 	    (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP) ||
-	     guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDPID))) {
+	     guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDPID)))
 		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
-		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
-			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
-	}
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
-- 
2.25.1


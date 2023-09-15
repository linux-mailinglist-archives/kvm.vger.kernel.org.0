Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE87A28CD
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 22:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbjIOU6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 16:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237812AbjIOU5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 16:57:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25A13C0A;
        Fri, 15 Sep 2023 13:55:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acmRCGWK/TCMphp0mlFKSdWyHaimnbyuUogOznMdMm+8ZP5uZFrhOcYqZ9i7brOnlvBbC8YHfDr7W8eIWTC2r2/1cXgphK/Teu3YHLSXfOewNPXaIoEXoxGibkYkmI8UGf+FXir7aoB6lGSFuq3jfXTCRf840eThjHhO47vdtPuBFn6h4QHLXt23h4t61/IDMJ1jDht+PjXgrYRTZTwJy6C13woSg1A9FBUd9DwT49Q4uCOoZ6qjIKaUMQXmfVeKqq5WBG0V+ec8hUAvFZWf8T88WANPeAWTxYk2bIdihsDE7+Ypn5WuD28QT66Ke7d2q7n1wjRX6zHZt0OcGdGfgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucpoGINesSx39GPFnSjaQchwE+50SZes64Zaz4ovz98=;
 b=csDp8mEHR5t2hZUENeXwyWk2pKllmfDoR54r11uv3Xtn/Y7bjTLfPzfHZLGk6tFz8+hsPpIp1BCriOj2WShS+eYZopbnKgxXfgCwhDudUozdbsTzgiq/atESHY68iD9qwkh8+JLbJgVDAO8hY65ktapEV1ik11RSILH6YMDdd/+1M7hQLOmwhMDkt9aVf1DNNQYeOeJVmSJpZwTBMtO2yrFHzVgDkCeVWh64PUm4XmCj/N8OPBhCjYSvweUTO9CGpFd2AnhfbpvRjxWnwv+Ykui3ARosIUwr9eeGACABkQitkWwc2bQTzcL1BjHACXSUGaToYGOy8OCVy9tLd7k3uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucpoGINesSx39GPFnSjaQchwE+50SZes64Zaz4ovz98=;
 b=Tedf1pi/D0s/+tmwlF93LG0/35p43mqjP5QEZGJLaeZ8P/J4wPltcwE+BOP5jc8Or+JTuxEQG2Pj7vowxzH+qS49FQ+J/zRXvqWs8+WYaf7mNFnFox8X/dRbkVXjYOO9exPfJaTSbrONDo7buLMYuVT5cI/baD+E5OkBEYfFXnA=
Received: from CY5P221CA0157.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:6a::29)
 by LV8PR12MB9181.namprd12.prod.outlook.com (2603:10b6:408:18d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Fri, 15 Sep
 2023 20:55:02 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:930:6a:cafe::fb) by CY5P221CA0157.outlook.office365.com
 (2603:10b6:930:6a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21 via Frontend
 Transport; Fri, 15 Sep 2023 20:55:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Fri, 15 Sep 2023 20:55:01 +0000
Received: from tlendack-t1.amdoffice.net (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 15 Sep 2023 15:55:00 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Subject: [PATCH v2 2/3] KVM: SVM: Fix TSC_AUX virtualization intercept update logic
Date:   Fri, 15 Sep 2023 15:54:31 -0500
Message-ID: <aa46606f21303d5b45544ed2043966c2b3d7f69a.1694811272.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694811272.git.thomas.lendacky@amd.com>
References: <cover.1694811272.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|LV8PR12MB9181:EE_
X-MS-Office365-Filtering-Correlation-Id: f7798f41-e4e4-4561-576f-08dbb62e07da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4wNvwGFyEOetf+uuGh8gmSq6TxC/RoAdmKYvVZj8tmYh5RjW2ayJWCDlRoFbjZKSIqkSaQE1RNhJijxVMzAAkknhB/UNsccQQCLNoMZsDfNUpU8t0FoIfvub/KRmlK7xdBIqXwJz+QRsk2goCcoo1qjAgeFyPhVZhCbfypR5VwN9ck8R81XGinUzY3L//YQgUbQ6hwiiGKJ2k6+A6Vk+A6PjiuiKYnh2Gii3jVVWhQwWMfLHgtj6UeX7dIoZ4WcAMTS2bMBvbcwgPNKmH8q9B3oKYPlUgNiKydcLX+kJwe+3qmGTnfJHsTiNBxSPeGeFE2Pxfa8+Kn2IVZ78EVgre0mVQiUAZ3ySCM+f1ZCsKsnfjJOmPbzS1mo33mCVUAx7Aeagd6XBHGgXLF07qTPGvDw8nUgc4ONJHVT4KsJgwcexwyGg9KCddzeaboPXMgCUj21N07je1IGdlEmiDNjpBKVB0h9+/rax6VRhuLckjawBjgXhJSlx6Sz/Lmw99fNlEBqOrkYJ5MwKae7vtAgORc1o2AKKxG2d7DfLD/KLGMpW5yXc548dDrhMHIcQR+jmv3d9P4L0HYNavbyMhJPkHzYii+Vki66mNHRnOlfKJIvTwWfQOrDzbwOpEnDBpLId9qBuBX0Lr4To8RaAyh5L+asM8pnU7eR2hn33SHbbNS8JP3+5Cg9o7HzCacVBHkg1+FHqWGfXB44R8hnv0jpSvSkMZXr9cvXBE1FgItdVW5ptvH6wFwuu/um14u3op85AGo6YLj24AXILDLXWljGZEw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199024)(82310400011)(1800799009)(186009)(46966006)(36840700001)(40470700004)(5660300002)(2616005)(8676002)(478600001)(36860700001)(6666004)(40460700003)(47076005)(426003)(83380400001)(16526019)(336012)(26005)(70206006)(54906003)(8936002)(4326008)(70586007)(110136005)(40480700001)(316002)(15650500001)(2906002)(86362001)(41300700001)(36756003)(81166007)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 20:55:01.8463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7798f41-e4e4-4561-576f-08dbb62e07da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9181
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the TSC_AUX virtualization support now in the vcpu_set_after_cpuid()
path, the intercepts must be either cleared or set based on the guest
CPUID input. Currently the support only clears the intercepts.

Also, vcpu_set_after_cpuid() calls svm_recalc_instruction_intercepts() as
part of the processing, so the setting or clearing of the RDTSCP intercept
can be dropped from the TSC_AUX virtualization support.

Update the support to always set or clear the TSC_AUX MSR intercept based
on the virtualization requirements.

Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4ac01f338903..4900c078045a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2966,12 +2966,11 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
-	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
-	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
-		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
-		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
-			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
+	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
+		bool v_tsc_aux = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
+				 guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
+
+		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
 	}
 }
 
-- 
2.41.0


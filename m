Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298AD678B55
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 00:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjAWXAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 18:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbjAWXAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 18:00:05 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A897939B89;
        Mon, 23 Jan 2023 14:59:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDj1HHNS5kOrmbDS+OVRT4mu5FY6TPmI+6DPjKgfZvhu2UyUiVolCFAUdOtI61Ma/Bv6lZ7wMx5Zeb6grRJUbpU/LaWdDGJcrNRG57gULhaW3LXLqAR6iA8kmh+FFkXlBI3DoWmIBf0z/yfB+dI1mGes/8ZoMNKEzrhrqZkle/0qnBFhaHuZG67sGYK0dm/N40Wro5ypHoyBRUG04q+ohWGcJpyDQR50INfjsk125kG3wDJHpvxbuw6IIVd6i5/PpF/9HFMRgXorJiPiQilRoKGJq9QE5pGspj3bM1DS8fwZntBzC4himqBfSYQAOz717U7ddsJIMCVDVkoxY3T0fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPP217NhloKDoLSAeUYTREqWvKmuIsqoh8yDbZ4jU3I=;
 b=kzfinTU1Vnmh1MdJgJz+HyL/OSSpFisWdDCDRFtYk8ESj4VQ7BqJRoQrlGzootAJNnXG0n6CPddmvoc2EiGA4IKh4khHRV7oNdcFvKlG4Gin4xC3hE7D++7Ndmsu/pm/uYJ1cdp5buBjosezCw4+9q0GZ1WxqC5lrAABEpIzZRS7e/BJ+rLil2gqbxetb3gHVUj1OO9L/MRP9Yqz12KAuON2gk9ZzuWzOyEb4XKGaRhKxswviYwdxU16dmrO9YKGGGiRyCX+2nu4Utti8qfGU/QIVppbLc2VRsZ2hIGYPrqwOnjAS1Mg93282bTEP9NxnVe/nQwajzeh1rpkN5YFWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPP217NhloKDoLSAeUYTREqWvKmuIsqoh8yDbZ4jU3I=;
 b=sSZfaoIHIcSxDrrFMgVHcVazgREtsiCPPNYnl6taRszRx1cEKrcicc7d0r/ArhUkoy0CmOUnyR1+Co7JAl2TET/Re5znqpD+ued6zGvBdupWNzwWxDiw6YVddW3lgoL6zYOBmETaQh3EMLc67iCeiDMpljfE4nwU0tUvN1HRit4=
Received: from BN9P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::31)
 by SA1PR12MB7038.namprd12.prod.outlook.com (2603:10b6:806:24d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 22:58:50 +0000
Received: from BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::be) by BN9P222CA0026.outlook.office365.com
 (2603:10b6:408:10c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 22:58:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT078.mail.protection.outlook.com (10.13.176.251) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 22:58:50 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 16:58:49 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Alexey Kardashevskiy" <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 8/8] x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest
Date:   Mon, 23 Jan 2023 16:57:00 -0600
Message-ID: <20230123225700.2224063-9-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230123225700.2224063-1-kim.phillips@amd.com>
References: <20230123225700.2224063-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT078:EE_|SA1PR12MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: 21fd28f6-104e-409b-0785-08dafd956498
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qHbdLWIsWQ3644MFjExlADefMb2+oVsK7NM+ygu+StdvUxQtcnErJPy1ycTHW4xayffOjdYUHSCJrZMx7yxjsTERQs7gzgTC3/S5kUfeJzjkahCNgEjapMzic5AZ1/Vu+hc4rQhRfTq3B7KTEtH7XFlBE0ITX2H8aE/sPCtfbUhrJ8CVzmGrScJoaW1Mu97o+wIHCQu1boE67s9fHqKhwutNUTmqQWXWRF6wTM4UXQo6zaqolwtpxENIf/t/rEikXGR61X3LWeElZ+hB89JmVv0yqVbtYM62lwOh45rLpZpAlD2YIQHZQ09vDBaAXD4c2traOLbHbJn7Gks7ZVA587zrSxArIVccx+/ORa6HO+hw4b/IjI83P0ZKld3eQqz0VwVa6jNFcQa+5HgSP2Za+QXElezzTcguyHEsA1w7fqgyJwoNdMjCihHlEof/8oPJF/61UoVhGqRofI5W0f8SRO3+4ErxZOOQgpR3JUZL+dKLt6ilHZ6doBjRz0q14PXeUFb3uO2OGCs4gjPfeBbdQb+frt0vthiHT0YK3tIIy+lsSwL6Pd3Qo/rjXZEeW7MTyAfZHg8gexPSfQhJOivuIdIC4ZB3a4TRKrB1mrfRQnhXbKMtWSyxHquFNWOJBDnrXA5C7gFHk+YqGpmaC3II/ftDaepAzaNn/JXomVZFcUG8TS3wA+bZlufag+wxnN7yLy+XjOhPMmHQsi3BHGGWNhrm7Um2K5lsi1zNG/fRkDU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(36840700001)(46966006)(40470700004)(36756003)(86362001)(81166007)(2906002)(5660300002)(356005)(82310400005)(82740400003)(83380400001)(8936002)(7416002)(4326008)(44832011)(41300700001)(36860700001)(478600001)(7696005)(6916009)(16526019)(8676002)(186003)(40460700003)(40480700001)(26005)(2616005)(70586007)(316002)(70206006)(336012)(6666004)(54906003)(1076003)(47076005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:58:50.5517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fd28f6-104e-409b-0785-08dafd956498
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7038
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the AMD Automatic IBRS feature bit to those being propagated to the guest,
and enable the guest EFER bit.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c   | 2 +-
 arch/x86/kvm/svm/svm.c | 3 +++
 arch/x86/kvm/x86.c     | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9ba75ad9d976..293ef07b34c3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -743,7 +743,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
-		F(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
+		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9a194aa1a75a..60c7c880266b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4969,6 +4969,9 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
+	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
+		kvm_enable_efer_bits(EFER_AUTOIBRS);
+
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..8dd0cb230ef5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1685,6 +1685,9 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	if (efer & EFER_AUTOIBRS && !guest_cpuid_has(vcpu, X86_FEATURE_AUTOIBRS))
+		return false;
+
 	if (efer & EFER_FFXSR && !guest_cpuid_has(vcpu, X86_FEATURE_FXSR_OPT))
 		return false;
 
-- 
2.34.1


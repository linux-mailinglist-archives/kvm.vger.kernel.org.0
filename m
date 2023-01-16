Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B16066D285
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 00:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbjAPXFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 18:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjAPXE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 18:04:29 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2847C2A9A3;
        Mon, 16 Jan 2023 15:03:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2lAfnwtHPahxX9Y3zSrdeIcOFDMEpdYih/KYNVinzsJfl+cdOZfROyJIhp4UzqnTO7tChRamV/ImQCu4lrnRKcmPWtTy6aL4mXEsLNpUZtR3LEsWf91hHIKQS5QwicO7SfB4bMwxcDExQDsQVnzUhSKNzIf9jYvGXK2mG5kZi0ImTW8tRJmINfPQtMRCHRdislpd1DYt2D17mpuDVS8N5+jhUPvOd1wXUWZT1hb71KgyLY82v8eAwey77Lam1RKNbpoYv2cudlbS8wWsQCQiR+fbYLWnryrzUcNippe4FYOritqfcOq5Y2v0ZhKuQ4MkIXexOUH+45XEgm1BeD/mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QDdp4FWNCH5ZBi1okqkM/sQPm7Bh/OPFczx9KULuMM=;
 b=f/tWhq0DXwcmY8iB4vtxR9BymomBDUVu1UQsuEfrQEwX7CULyCuQlImXhTwTbXn12KedhcwsFHn2nmJdSn9UwfQZXLpwyOhD2At7gJzSbJkhJvtXXRWal8qx3oE+XVjOc5yak2mgoZcNRDVV1qUO5gtnUjTiz+dbwt04VO+0qVdxdQ5xi5br2lN4jMV4GRvpLwkyMwNiDEhCof3hSWts0llOFyy/lUOGQzIMEpBIo40ZBb7yVjBJG8hQlDXPDBWBnvKnb1aW0GvWzOanECTH+HGh+IVWQKAOAw4moR/8MuRlj2mowd5Gp3Nw2TvC7Uu1wavYtZqYEUX5dT1IRbEEYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QDdp4FWNCH5ZBi1okqkM/sQPm7Bh/OPFczx9KULuMM=;
 b=mWsVsrdYqYoxx0BrNxSrFBBCSTLeSI6XcfJeOaRatC0rCmfgumaiLJy1j8xxnBiPUhzTsIGezZRs+VWGOK304WMeXaq+H2vve7T6bRb0K21uaXtNvkyIel5BNaEp6losWsdzGc/a3tX5LI61SJRJVISkM62j2/t5caPe7ky8wRE=
Received: from DS7PR03CA0010.namprd03.prod.outlook.com (2603:10b6:5:3b8::15)
 by DS0PR12MB7510.namprd12.prod.outlook.com (2603:10b6:8:132::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 23:03:41 +0000
Received: from DS1PEPF0000B074.namprd05.prod.outlook.com
 (2603:10b6:5:3b8:cafe::2e) by DS7PR03CA0010.outlook.office365.com
 (2603:10b6:5:3b8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Mon, 16 Jan 2023 23:03:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000B074.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Mon, 16 Jan 2023 23:03:41 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 17:03:40 -0600
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
Subject: [PATCH v7 7/7] x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest
Date:   Mon, 16 Jan 2023 17:01:59 -0600
Message-ID: <20230116230159.1511393-8-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230116230159.1511393-1-kim.phillips@amd.com>
References: <20230116230159.1511393-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B074:EE_|DS0PR12MB7510:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b655dbb-7406-4d11-0278-08daf815e955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Va/F70FyosLkAyJ4xjDoL/GcR7+WMyBr9lp9PXaVA8dZ1SOet238HRkMHGGKa2jhS8aAGOYq87QdgIU7Ba9bo3apRL6kV7oDPLu2PMYBf5k/vj5N+Gq3c746g0TuAWhETIcr4as9m13QRSQqDF+jwUJ5IYO3OwXwqC8vwlk0bclFvMQ7j8av52lzDmmRgtRf+PWZjn6hC4+HDXXW+57+gFIs56lIgwX9HrynQ1E1CbRlVO9viRB8WJ71LTfavTEoK+v/rPklG3UWO7UTQqgxVGwgXOg4Q9DdSIbjLmvnNccPtUnUbfmgFYezj+DhmDVUZVw7uRjzXAQs14j1mRUP+w9/ZE0kDHj0G5Bu0hP2BHEsVhuYBoJy+cCrC/myggXZ/KlBo6jlkhZp1IuDJGq/6v/IWKFxfNtRHt2BPo5uutyzgqtIhEOMRb2CvDZbFxJhb5svHg60PF6ShUEGKvpq7zG80PMcX72POGFTr1dVqtYNSl+xXUDDdUfy6Tm27Gs4IX6mefKTmE6Wjvh/jGK9IGF0LJDGI8Z+858+oI2JEh1GsTr2GPCenzAz+SRMPjxih27MWiO0CHdsZRjyZxIFBTbheQPXcz23+0Dw3az+8A+a7OlcbiAiLIQUhmj6I415Je/J0fTGtAInZm5JoWCr4JlcsGlJiEzrEqz9qc0OawLA3H3J0O7O+dfsLh2WfCWLjajd+KSCDD7RoNZPKL0qUuLM6ItM1wEIDqLzjx2YYug=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(36840700001)(40470700004)(46966006)(36756003)(6916009)(356005)(86362001)(8936002)(44832011)(70586007)(8676002)(70206006)(4326008)(2906002)(7416002)(81166007)(82740400003)(36860700001)(83380400001)(5660300002)(7696005)(40460700003)(316002)(6666004)(54906003)(41300700001)(40480700001)(82310400005)(478600001)(426003)(47076005)(2616005)(336012)(16526019)(1076003)(26005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 23:03:41.8228
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b655dbb-7406-4d11-0278-08daf815e955
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B074.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7510
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the AMD Automatic IBRS feature bit to those being
propagated to the guest, and enable the guest EFER bit.

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


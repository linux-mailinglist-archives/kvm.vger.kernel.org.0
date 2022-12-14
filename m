Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E6864D0A9
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiLNUFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiLNUE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:04:59 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725B9303E8;
        Wed, 14 Dec 2022 11:59:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiDCMfWK3Ylu5L+ixmIx1+2Ikpjwz6A+HX2IxCbxq2TMRFTrGYYG1+U3BPdHgJ4Z4jvS6MqIXlR4Xa3yVdkTfnOl/zga8wNuGAIXcd/0XuUpAP7ucCdA4X4CiiPBVqiDnJYrtxKT2WzdiCefIsmIKOQGPfemrz+n33lJflMDKzSLrOzvJhdy2MhW0VHFhHcO9pX6E9wBFLATD5d0gu4wHJ/aYjNcF3Q/B967skH5BAiIkewJ+XzIMU3wkGoT4sx72lOrWQszHDFcvOM+B806OaZWV9wNsL3Y/1uuKIbr3QH9hnbRosOazWDVApNDxzwFzf0zU9wE9+Rq+pq7++/19w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIkJ9ONvV/9ix4xqluzIRXKLZEkOKPUvKC22i1Q56YE=;
 b=YpRMT8ew1IzBRsvBHFi3FI9G/tncC/nBo66gJ2cMpmzzmEasChceOY4xIS2aN8QS6pI3pw2/Rg2ixyAHVUuklI3vr9+KxjaNZzoEeejZRk2psK6HcbxnILBEQybu33ywhvQ/1G6JoWHpKdtBLydibne9MHPefxn35CT3z2PFluE6TuTQDY0HCZYLXKtu9eflzgqcWwPj/9jM+bqAnoh0I256I+U6MgZ8rqYoeRV8OoOybGmO8hqFUlRduYBeeBJ2CE13JG778upa2vI+suciQ7Qt9knUKLslaWrAQx1VKOvrzDNef+DGvKsJ+DwTbqgb3E1CRNCWnTrlaoaiYgD0TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIkJ9ONvV/9ix4xqluzIRXKLZEkOKPUvKC22i1Q56YE=;
 b=pPBGszfS1mUrMvR4o6IwiWOlmeufLnSqk1bQvngvcG7qHCj9b6SOnesrQ8ADx9OlRIxWbxPt3oj5cHPuXFJOl08WOkV9ihN20PHEvGf7UGX26VftPJtiM5TuJS1zwfE50NKB21ADUIXTY+GWbxFYK8LxPCUt+uOyH9L4dwW7Tww=
Received: from DS7PR05CA0089.namprd05.prod.outlook.com (2603:10b6:8:56::6) by
 SJ2PR12MB7919.namprd12.prod.outlook.com (2603:10b6:a03:4cc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:59:41 +0000
Received: from CY4PEPF0000C971.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::c2) by DS7PR05CA0089.outlook.office365.com
 (2603:10b6:8:56::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.5 via Frontend
 Transport; Wed, 14 Dec 2022 19:59:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C971.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:59:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:59:40 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 42/64] KVM: x86: Define RMP page fault error bits for #NPF
Date:   Wed, 14 Dec 2022 13:40:34 -0600
Message-ID: <20221214194056.161492-43-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C971:EE_|SJ2PR12MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aae1591-435f-454f-afa6-08dade0dbd19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2YJqlKfiI2M6lO95CKZKW6KVBGS0SIHcZEH/cy8JuCeH7/VhGgGfsa1AuhtM3H3ivQ6t+SmQgPhp0ZjfGVFrFuwrr54OGebui+SORxFpH/5CziZ7/E/++26B9Nf3wGyuFFnhevqcbwerPG8tCU1kHlujnWB9VC3UxbK1uzZrugRVYnUZs4aQzdzyzcf60nYNQeTgHj3k4He0VAif+LK6GxCC6SuF9yc22n9peBuCjfhL7447gNmPbatZazsboIvHAWUZT7A0SLH0tT3Sr1GXsUUYS9Ah0TYNeVcJTUyPE/CJpK7KADLMa6rYZNmF5XXYiBoxN4DtRhCF7IFtfy8m9yggqMCFKI7R5wfnfX8OWIxJ4gG96TT0p0GG9LqyJ3tniH4UiiIOtFIjxLlHQlWknzKAF+VZE6CYkfXepLdCDUq4rn+xyut4LdMsBMlWv/CpEeEGj/kduvS8tlcvC8rm9BQ3v35WCsCO1gotC+SKyRmi8Ph7DReJ+9428MzzW5eFTlPFJzXBmBvECkrYt5Cc3NKzv9EwaJu1e4Bj3mm57eAnLvAPBbuoYi4vJdtZw6QLO0j3VOf6sgiwycEvM2wYh+tb3bLwlTmsAuUK+ZaR8KKqfQQtcip4NxbIsGh5i2JYbChwCJMN4i0ESHW+8/hGZq6MD/DD8pP96nqRBkVuJrHonkDe50SfKV4PJ+FSPrQQwK6t6/EyNk71EtSL3zkIrNqnifmgupafbDNk7e9/gyA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(40480700001)(356005)(8936002)(36860700001)(47076005)(82740400003)(83380400001)(70206006)(8676002)(40460700003)(41300700001)(70586007)(4326008)(86362001)(81166007)(5660300002)(336012)(316002)(7416002)(26005)(2906002)(44832011)(186003)(6666004)(1076003)(6916009)(426003)(7406005)(16526019)(2616005)(54906003)(82310400005)(478600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:59:41.3926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aae1591-435f-454f-afa6-08dade0dbd19
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C971.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7919
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled globally, the hardware places restrictions on all
memory accesses based on the RMP entry, whether the hypervisor or a VM,
performs the accesses. When hardware encounters an RMP access violation
during a guest access, it will cause a #VMEXIT(NPF).

See APM2 section 16.36.10 for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b126c6ac7ce4..f4bb0821757e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -257,9 +257,13 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_GUEST_RMP_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_IMPLICIT_ACCESS_BIT 48
+#define PFERR_GUEST_ENC_BIT 34
+#define PFERR_GUEST_SIZEM_BIT 35
+#define PFERR_GUEST_VMPL_BIT 36
 
 #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
 #define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
@@ -271,6 +275,10 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
+#define PFERR_GUEST_RMP_MASK	BIT_ULL(PFERR_GUEST_RMP_BIT)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
+#define PFERR_GUEST_SIZEM_MASK	BIT_ULL(PFERR_GUEST_SIZEM_BIT)
+#define PFERR_GUEST_VMPL_MASK	BIT_ULL(PFERR_GUEST_VMPL_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC58270FAFF
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 17:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238057AbjEXP66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 11:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbjEXP6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 11:58:25 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2063.outbound.protection.outlook.com [40.107.212.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC13E6E;
        Wed, 24 May 2023 08:57:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaJG0/+tXqStc4XF5mKfuzLluMkgKkLaaaucUHG/0G1BOlaVr+kfeom21TH9rjd/Y04eTJdxKTM3vHxrjK6DhAU16HIctAtq1BnUA9ZTiZT4wEM6q3USUnpzPWZ+V0wYe/gkaYuz0GHvwmfDHlCcvvqXHHwUl+u7vStL5/G+gto76YDY9GJAW4YCB+E5EvCEMnCQX782pX69455eBVvTIDUgvdOqaE3k57Fp3o5jkiEIPnwrkLUdSZtcBTZNmdg+OfgpXou7tNfY0UKzSjNwRG/yeqbd5q8TSERIEhI7KM/0wkkYErDL865sqWLPBWer024z1sySAjWdP/2otW7DEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ks+UuaSv5KNQnArNIVH0E99Z78VHH3K53r/X3CDMvc0=;
 b=DzmsBy771kUriH2DZxjzpfd6K70jHuSsL0/G1CAEu/7/PZdQIBGD4iU43/rUHFtel49OQICedzJTPCU8c5+zyJBrq053xHgi3vhAQYyW2ykz3ChNnuu+bIdmUiv8r8VOWEBSnEifoS1XoTOXi8PNP9zrIkh7VP6IZQeLzZ7Vuv6tjqSQSECRZXF/RDvGTRrThnkX5/PijOiaqoD2t0i4iPpgxkVDCabmH79OR36R7h3PiY/z9kHN1knveIhDe7ggQp7UoMWQyPxl9LuFMlvjQDVpBadSUFcIabik/tlP5gIMK/svpm6w1zg7xRWuCK7eVEWJLHro5PjvKI5Q6Y5SiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ks+UuaSv5KNQnArNIVH0E99Z78VHH3K53r/X3CDMvc0=;
 b=tNT6oXRQRyQwCyF4aUktcH/4vfi+U1WHnubisP1rDWbB5oDEvYHt8CC7xPa6NKzduDXdVnVBiwaG9rq9uu+atSuIniIGY0iFsmarMySp81NRBpLgwdOQcvUcBiEkv7cXo93MZA3FbEl6HAVtiGzhzNnhnlstbnsyLdKicKgKQPE=
Received: from DM6PR02CA0054.namprd02.prod.outlook.com (2603:10b6:5:177::31)
 by DM4PR12MB6279.namprd12.prod.outlook.com (2603:10b6:8:a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 15:56:49 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::de) by DM6PR02CA0054.outlook.office365.com
 (2603:10b6:5:177::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29 via Frontend
 Transport; Wed, 24 May 2023 15:56:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.30 via Frontend Transport; Wed, 24 May 2023 15:56:49 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 10:56:44 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v2] x86/sev-es: Include XSS value in GHCB CPUID request
Date:   Wed, 24 May 2023 15:56:19 +0000
Message-ID: <20230524155619.415961-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT064:EE_|DM4PR12MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: 41250b9d-e6ec-4a34-d076-08db5c6f7c13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 51d4D6CjgREMNgnFPzhqTpdBzsxCUAI4bf1RFq1D5H/oOj5PdGSiFFIxkZ1h4N6XJEcmdys2IKLMSDLi7n+2n0M16f+WoHztQthZDzuytiDaawa8VcSCdVsjLP5oNK9jDStd9NiWcNzaB+fEzE0ukGhhjeOsCwBxGx3/SUVlpPgIuWeY2hqHQRJskIszT+C59iEvUksDwLP/DkZK0gubaMYpdcD7CLiAQj7Vbt4L2Iyow4V+3PyyY1EHLIbLbNd0mJfjFkQFIN6hZJE8fj8VJDW5xBLKL44Irq1ZqSm8EzCbLKsAIokCIrK71KhoTdzWMxdBTveSLYWG0jgs9oKg37rYxhKhalAPkN+ifBQcFJaKQQRbg7/X7unguKU0WFKP3PnGxFdgP7ZmxWLJeFGGMRo0+bu5UYZGjxJOL379M4HXUSaPFffXz248p4EO7GXp1bM+BlzyyNC0rr6DXnUu5eb02xmj4anjJxWAUyrUQ6GXr9ldosAJ37WeKzTSqgHM+HizRNvPLD9dN9/WLwQsMUub7bGXS9rDSSnlPBSpP6IYpq6mrowizsz67pq9eQFkiFh9NIM+V1ipw+hiqTQ6/d0RZVzcOFVcfa0y8KuenfQUkNj0IuzbMkIxagnzZPKq4DYFoMF4UF7UEWDCwns9kyhPGaNQDLe/iX5pFMBqAKnFGZGT9tF/NSN+q6d2ZuIkpLoYiTwqoSg/FKmp+CS8QZ433ZR70sugFfekNac5RpO9PYtoGOUjze8nXK6yuBZ5I1q1upmFcHnT7wo7791fmQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199021)(36840700001)(46966006)(40470700004)(54906003)(7696005)(41300700001)(82310400005)(316002)(6666004)(70206006)(4326008)(6916009)(70586007)(8936002)(5660300002)(8676002)(478600001)(86362001)(44832011)(82740400003)(40460700003)(356005)(81166007)(26005)(1076003)(186003)(16526019)(40480700001)(2906002)(2616005)(36756003)(83380400001)(426003)(36860700001)(336012)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 15:56:49.4918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41250b9d-e6ec-4a34-d076-08db5c6f7c13
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6279
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest issues a cpuid instruction for Fn0000000D_x0B (CetUserOffset), the
hypervisor may intercept and access the guest XSS value. For SEV-ES, this is
encrypted and needs to be included in the GHCB to be visible to the hypervisor.
The rdmsr instruction needs to be called directly as the code may be used in
early boot in which case the rdmsr wrappers should be avoided as they are
incompatible with the decompression boot phase. 

Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  - Do not expose XSS state for ECX > 1
  - Direct MSR read was left as is for now. Using __rdmsr produces a warning
    during kernel build as the __ex_table section used by __rdmsr isn't used
    during decompression boot. Additionally, we can see other code
    performing a similar direct msr read in this file in commit
    ee0bfa08a3453.
---
 arch/x86/kernel/sev-shared.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 3a5b0c9c4fcc..fc4109cc2e67 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -887,6 +887,21 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 		/* xgetbv will cause #GP - use reset value for xcr0 */
 		ghcb_set_xcr0(ghcb, 1);
 
+	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx <= 1) {
+		unsigned long lo, hi;
+		u64 xss;
+
+		/*
+		 * Since vc_handle_cpuid may be used during early boot, the
+		 * rdmsr wrappers are incompatible and should not be used.
+		 * Invoke the instruction directly.
+		 */
+		asm volatile("rdmsr" : "=a" (lo), "=d" (hi)
+			     : "c" (MSR_IA32_XSS));
+		xss = (hi << 32) | lo;
+		ghcb_set_xss(ghcb, xss);
+	}
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.39.1


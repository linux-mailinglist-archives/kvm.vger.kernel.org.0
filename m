Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C34577FDB3
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354310AbjHQST7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353884AbjHQSTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:19:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA55F2D59;
        Thu, 17 Aug 2023 11:19:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMoSWxydUrH9eOI+jTMr8hvf7LdVJwDTqEr5VVTFdUi25N9HuxgHnDabrQiLTTWck5ISbwtMvDty2XTNZZoy8WnYlhvwGME55d/xhLgMbjHKXoqXBKTwjdEjWPlKefEc1upg+4H8cDvNi4vlZhuMOJgT22/VKi+EmRcbkUTz08jWzG/f4m6i5kOrePXYLF4lnxjTNguOPKpyFGqaHldC6jG6twLa3SUwAocSMappS62SgvcSkLaL/M0iUXtgZyaxuOocF5S0i0RHACExsuG1QFBfaLya4keOniYGz4kggYnmYVrW1F7H9RynPZIkRXPAzoSRESpMRYZkAAZa3ZUBGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+zNrQYSmD/VbVxG31O35vdjsp1BsfF56x/uNwLdBsg=;
 b=ASw48bPQFSVNvU4zbnqFNdiFwEt5QxpajVLLxRDrnNEj1ht5GQ2XbXCXi7V5CA/+dpgkvGq+/IzV/VDMGv1W3rBtGZxDqm+LoofEv7tvSKPL1qucoUjJgEhtKBDsVIBedIGl18B/fyqApUeOIhsugfJVCW+jPjQQ4Sn2FJQc8Rkzi+kXknMBXLq5F7Mpc1aC1EBhZYKLUUh28rj2jswkvqeyGQks0AzVP3aKm9iyygYSwZbsmYJnhaAwZjUaMxF9BKblck5/3HoE/sPdzd4uMjQp3Vyav7GaWgWzuGNpuCLG3blVs2eV6Va4O84xCPox0pOD8CkNK/MzTUiz03cnIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+zNrQYSmD/VbVxG31O35vdjsp1BsfF56x/uNwLdBsg=;
 b=XOx9+YnV9bfArJ5ubwhX4qtiG2zrQH9e86At0R60UvHg3OQ8oEgYCyS41Q13qFV05C3oGpf1+oJz+hvH3KYVN6nwzj/uchFEXVQnlqqtQ/sI3+dGMV1i5QcbGOTp6NM1yhZN+CWUbLeOqqSgPB/LXfGekdzst500+iofoOZhfdY=
Received: from SA1P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::29)
 by CYYPR12MB8704.namprd12.prod.outlook.com (2603:10b6:930:c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.30; Thu, 17 Aug
 2023 18:19:21 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:806:22c:cafe::95) by SA1P222CA0013.outlook.office365.com
 (2603:10b6:806:22c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.33 via Frontend
 Transport; Thu, 17 Aug 2023 18:19:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.14 via Frontend Transport; Thu, 17 Aug 2023 18:19:21 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 17 Aug
 2023 13:19:20 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v3 7/8] x86/sev-es: Include XSS value in GHCB CPUID request
Date:   Thu, 17 Aug 2023 18:18:19 +0000
Message-ID: <20230817181820.15315-8-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|CYYPR12MB8704:EE_
X-MS-Office365-Filtering-Correlation-Id: 891f227a-2fd4-4557-ce3b-08db9f4e7aa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7021PuxzS4eQQj/4OobPzlDQeYxwIvq4HjCsVqtb4keGHNzPD5nUJoUuuxU3PLxsM3rpw94aeY9pMmhX4kd/GGtpL9vi3TMLx3rdpCSqkH0WdjA8nohCiyAVD2uGEIAneX0C+nGrd7Z0fzipbNQjxyJfUTIbXkdYkozeXiJurxmg0qBFgf9mnw8a71evHE5kk8zt9R+Q4gjqXvtfbxbDB9L22l6K7rz+tmPYr9+iXjfnhJ8wrCeY/psYDxNjkUSv+VtP3ClZx+sHdT8ah6uCEUopud/VKle31nhRXb4bzjTzBCU+HY1ynMSyr8l3Cte+jfOyK9VWLze+/f2hhXaIpxT/GSV6Q5XwAwTyBn6TdxHDWbq1aX0oD+Chr/JrnFuNbsrzJgnn+3lPChqI51+EEmdgvrl2zFoE3foHovDDXD+9BPpGAEPMUyOYppp5ZKpcWudGtaA34S2v4XXHWkkQLfiUZV7ivnV0Wdlx2hjK9WUa2ASiYWMmU7nJYy3KQ3tak9XUusSlz8qVKAGk7gNcGZpGJkXMqTn7J56d6l90KpAh2KNGMRuq0SoAUB1zTwaEJLVktzZvQJDt91Lp/V23w3zfTDxKM53CD+wi38FqTY9s1bOwVwmwub2EfQBGeMaSoTaahmcW+vkOZAcIPID6933aMrKY/tcq8js/2pDNTYjv0OL8U+h16qz1/6L/kBVs4QZNj2gHz+IMfeBHMpOixbLRJWxJGvUKVfZTd2WrpDCzFlH6O0NAmMaxe9GH+J8oRnaDgqGefkyIoNPWGeOPbQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199024)(186009)(1800799009)(82310400011)(46966006)(40470700004)(36840700001)(316002)(54906003)(82740400003)(356005)(81166007)(70206006)(70586007)(6916009)(5660300002)(41300700001)(36860700001)(44832011)(47076005)(8676002)(8936002)(4326008)(26005)(40460700003)(2906002)(83380400001)(16526019)(478600001)(40480700001)(336012)(426003)(86362001)(36756003)(7696005)(1076003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 18:19:21.6449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 891f227a-2fd4-4557-ce3b-08db9f4e7aa6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8704
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
v3:
  - New in v3. Merged KVM support series and this single patch for guest
    kernel support.
---
 arch/x86/kernel/sev-shared.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 2eabccde94fb..e38a1d049bc1 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -890,6 +890,21 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1DE5FCC60
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiJLUrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiJLUrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:47:46 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2076.outbound.protection.outlook.com [40.107.96.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432ED10451E;
        Wed, 12 Oct 2022 13:47:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9QXQENBn83+oClavEp6GS726H2vb9MTYIBD748GHHD0MtFk5qaLFFuz0Wv/07aXk8WFHgARWjsOK15Hq6b0JOKCRi4Hl8B93UQK7sM99gLHkNzHnn5twin98zVsElz0vRm0kKSEQb2+BGRUCC51LJh1YorJcwblmwReyLwZY7SeyLwEsRuIJEdqNQUzlWp7/THK/HHpoJ2aDbx8uN24N0O4Zj/Pfe2cugOFtPwF1mFxu5Xga0NXpzPSnlxByDYWbNBFPA5kKhXmMtKhZVjMtkNPYPVVyW2c8D7BPJEfsxJRnfx5eX0obNSsxFIvJtBpfvV7rMIXfZ14BcTmk/31GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zneJ5fZCjZR7/nFg6DFVGj0ARhnW+a2kJsiHSKfetOE=;
 b=kVQUepoAIYMAm34zQEkBx1h6xfG6SVNtB1KZNnRioByS32reSRHy46h8lXpXPHAC18zNQAP4rAhFISOwf9rkErID4gNhlBegQBJEio6Ob+eV0bcjz+vq2iN4pIypQFn/hQ+p9SJsHsRWGS1Yq+r9M8gaoU4v9zM4LaryRZNEjSpVucXrZXBwFXCwin4RpGuiM4bz8ckpNR+KoEpzJH0SG29VgY6oo0VcvGUemiRlpB84j77DkfhGRFuyqalRoYmu29pf1D8j5FHa3aNGqKRCRCpA2PsPfE3FoIfJH8G7HtUslJqYiVDitjVYZpysNTmK003/H6eOKCKvcIMnU6gSWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zneJ5fZCjZR7/nFg6DFVGj0ARhnW+a2kJsiHSKfetOE=;
 b=BuNRUffftAZU8nPdAmLBCcb8OLzwEtu0EvHkvbtJ/f4/YADRXqIOBEPIwx1v6XYH5qTBWySI7saLIPBvyqK/S4g/K0I74MXNsQo7S71yk4jaITNLAZt+VkU4HW1fDRy3KTtaE77qE6PZ/DbT640mUK+4x6/mrIo/14KPRnEBOrc=
Received: from MW4PR04CA0060.namprd04.prod.outlook.com (2603:10b6:303:6a::35)
 by IA1PR12MB7592.namprd12.prod.outlook.com (2603:10b6:208:428::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Wed, 12 Oct
 2022 20:47:35 +0000
Received: from CO1NAM11FT116.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::98) by MW4PR04CA0060.outlook.office365.com
 (2603:10b6:303:6a::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21 via Frontend
 Transport; Wed, 12 Oct 2022 20:47:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT116.mail.protection.outlook.com (10.13.174.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 20:47:35 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 12 Oct
 2022 15:47:34 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Subject: [RFC PATCH] x86/sev-es: Include XSS value in GHCB CPUID request
Date:   Wed, 12 Oct 2022 20:47:16 +0000
Message-ID: <20221012204716.204904-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT116:EE_|IA1PR12MB7592:EE_
X-MS-Office365-Filtering-Correlation-Id: 22632eab-c48f-4d90-cfb0-08daac92fe2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oh/464wYXFk8Q5oc9NvNmnFtiZrTNmg2Uq8lneTIijWuwI80z5KdqX8HnaAhG/pBK3x79762srcihFFrHkrZQoeKeVOS9bGMD3hZ9E4LFHUjwV7PMunpequD5RG5L03WZ/q0ZgV0XeYImelXYEpCEVY7EwUyRkw/flIVpKAuXb3P3rH8diKIt0YXvM7Xebt6rOGWofM7y95TS4zojk3QOgOyXeK2ZxH8Oihbyo/xOkC8eezTQed0Og4FwVU6CU0GbxfrAWKxueGs3XUayA2V3OXEVZcShs+MsY8GYF9eLr+EpLemYIUZkw3Z/CVmsCjeZM4p+pFpEJxpRFGIRyHMnZuHl2OxGsaBgalRhVq7Y4YGV+yACseEN5cS5i8XcpR++I2Cw4/MGHy2NvOBbH1NdSThyDGUPiIVt1qAroJHcWKwrTJsXKeNm7hK6/Adn56sd1gHByygJYCxJQ2FKs5+ZcZJwQ0vkn1RD3Ggu6ySRJ4FeTTgK+FfctPga1nus7IMNayJWhrE/VJEXWmgPqV5qLxvcXtXpCDgQzdzX48GzV++H1Byxsps3nm3iYnEHLCkrGAgph96WTKkEyZadTEzLgS+r1CzKmdvLy0llWfRbvDIdQjodegJYBwv3rbvwF4dx6OlS8p2MNmFPDtha388UtqWTx5yaAcdAVPDw14VRp73qYjzRvrUkhIRR6hVmOS5TBUiRrgMDOgHiGbu2DvBjJP4ivWYGu9jU8eTKMOXC//WaPOZ8Rp+Kp/9TCzfZ5ytnDQOK8/hLjwhAQR6R4XPQPDb/60QxsTnShMYVGdrlyLQ2/msx5fJtSZym4EFO8xrHL7sy4lDzne7GMimcQHZzw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(46966006)(36840700001)(40470700004)(36860700001)(36756003)(81166007)(40460700003)(356005)(6916009)(54906003)(86362001)(8676002)(82310400005)(2906002)(8936002)(44832011)(316002)(966005)(70206006)(336012)(70586007)(4326008)(2616005)(6666004)(7696005)(83380400001)(47076005)(426003)(41300700001)(5660300002)(478600001)(16526019)(186003)(1076003)(82740400003)(40480700001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 20:47:35.4049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22632eab-c48f-4d90-cfb0-08daac92fe2a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT116.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7592
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest issues a cpuid instruction for Fn0000000D_x0B
(CetUserOffset), KVM will intercept and need to access the guest
XSS value. For SEV-ES, this is encrypted and needs to be
included in the GHCB to be visible to the hypervisor. The rdmsr
instruction needs to be called directly as the code may be used in early
boot in which case the rdmsr wrappers should be avoided as they are
incompatible with the decompression boot phase.

Signed-off-by: John Allen <john.allen@amd.com>
---
This patch is logically part of the SVM guest shadow stack support series seen
here:
https://lore.kernel.org/all/20221012203910.204793-1-john.allen@amd.com/

Sending this patch separately from the main series as it should apply to the
tip tree as opposed to the kvm tree as this patch is related to guest kernel
support.
---
 arch/x86/kernel/sev-shared.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 3a5b0c9c4fcc..34469fac03f0 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -887,6 +887,21 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 		/* xgetbv will cause #GP - use reset value for xcr0 */
 		ghcb_set_xcr0(ghcb, 1);
 
+	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd) {
+		unsigned long lo, hi;
+		u64 xss;
+
+		/*
+		 * Since vc_handle_cpuid may be used during early boot, the
+		 * rdmsr wrappers are incompatible and should not be used.
+		 * Invoke the instruction directly.
+		 */
+		asm volatile("rdmsr" : "=a" (lo), "=d" (hi)
+				    : "c" (MSR_IA32_XSS));
+		xss = (hi << 32) | lo;
+		ghcb_set_xss(ghcb, xss);
+	}
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.34.3


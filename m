Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2787C41A2
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbjJJUlz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343698AbjJJUDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:03:54 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607E911F;
        Tue, 10 Oct 2023 13:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtcLyxtqk6a9U1RNObnPWaocqCRIFnOkOLLXAC/AzCWHuEGtBId0EiThnU+VJzesSDvYgk4UEw/z5dcY1H8mUDAgFkb0xbLroTjRZYQqO9J22qad/T0P1W5vmpHvLorATDqATCDXfqnc2BmzRvmUmq7qMd3f5GG9N7qTLdGtJYTKyhQYKN7a6FgZB9Tjmnxjb6qQyeYj8wL0B5aVRDLU/I3Z4yoUgORss/SA/5xSLv7WTDIFJTLLvm7wQLycv4590lMOUaD5oCGhCkgQKQhANKteb4zwpQ/kXkUYKNE9GX2xhqJddgJzE8qsycGeHoULlb/TGtOUz+XGy64LIE4BXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7MMo2qNGd1TSpoYke/QjPNh9TxFsE4MZ1BqsHzUXqOA=;
 b=DyoVdAhPKmtDtE1HEMo0atjlWdswmLW0su8P3q/tCH4uos7nxCT8EbQZC7aCGUk7hPrS1XncGrlOrbAhLbl4EL5tCGaauXmb7i+KJ+wfJQPI9iIgBY3gCClSqxaXcBo2IPWovZMGn9cIrwnDhz3oA2zQv4Ji65zIAQc6sDD19kQ7fuiujAqc0XUUR2UkWmgoxu/Kk9J5pfV0y3iiB37PzjjX1D2qYXL6faQaChrsnRb+kBniAFCWMJHrxuX9TSF7Cc7VjjkfF5zr94gheffhvYvM6hvBext80/AH28tqmk9TPCsjzp2tvYVhJNAr7O1PChz+gCs67yoxYhYzqsB4FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MMo2qNGd1TSpoYke/QjPNh9TxFsE4MZ1BqsHzUXqOA=;
 b=SfA6A6PqOulTKIKJj3K9IsVnUPgHgpML4n5ckQYE72cthwJ+BZ/BsD8KQtTHa55cbMRqZ7+2LpJlMzZUcoBoLZbWf3ZxG5+b6FuRcbU2EtFSsmWlOLDGkOOJm0ndY0fL7xxsF5GCnsrYLOdojyW5PuNmx5G+ZqAdLwOnJlmDiE4=
Received: from DS7PR05CA0005.namprd05.prod.outlook.com (2603:10b6:5:3b9::10)
 by CH3PR12MB9252.namprd12.prod.outlook.com (2603:10b6:610:1ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.41; Tue, 10 Oct
 2023 20:03:38 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:3b9:cafe::f7) by DS7PR05CA0005.outlook.office365.com
 (2603:10b6:5:3b9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.23 via Frontend
 Transport; Tue, 10 Oct 2023 20:03:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 20:03:37 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 10 Oct
 2023 15:03:36 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [PATCH 7/9] x86/sev-es: Include XSS value in GHCB CPUID request
Date:   Tue, 10 Oct 2023 20:02:18 +0000
Message-ID: <20231010200220.897953-8-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231010200220.897953-1-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|CH3PR12MB9252:EE_
X-MS-Office365-Filtering-Correlation-Id: 678a93af-2740-44c5-23de-08dbc9cbfe00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CVRxH+Le6wKjekmAA0nXDYfFja1PF8YXFsxeN/KlInGFFFPF/vCcujWrAWCzh9re2KW16rNkY2xRit5TLxjRF7wBBBujA6lMBVE8zc2LVXYC2q12+Mdup5QnzWJQwRw4pNZv1RzRvRuBjKtGyshtCJHuIUJJgxi7tn8gQM6RYZIsCKaTmcJbm+CNSiuQOG5sSqoh81fjYYLp2TnRki7OYg7QfgRWPY6ZB14LMN2A5lPuauo3LC+cw2qgqhfiwHj8UeF2GwYqcxyL4Ie8LBXWaKrKA1LBnc7Gm1uzRen5lmn4tkQsseTGddtgt7ZsmT4G6ksh1w0ZAj7LqWHnaLePn19A5kal0ZuWyNzK93pRjxvQSkV1A/hRtEXrkaTKdIMeYkPxtOPf4f2ZFrmKZvRLKe7F+1Qs9yHDHRMbitv49KYHuUGf/JNdkoRtxoOLEahxtOmf9Kt/dZ4TDxiLqbxVTlQ+wr5OQehlmbJuJij4gBJ+sX3dPLNwOQhXDX0aZkNLQ5fT9cmlxhgpzJ95cB6lJHXLBc3qGLrSHJnIDd/gYB4WUykfwz3hEHwWQHNbf5cYF66Ql9xfHwQ3zukHFbiZxkydX9xMeG/nK8Wi2LdwpJPg8nJuZIZ2dyDxaB+qX9zfKfXSj4xKcHhNrJrjx7Z1fUYPAvgc6nzVBc2GfG2lTu/XJB1INm/i6bt9n2MpKOhTusBOM1e6vkRhFMwBeoNfyNy22J9F4anVfUi/Bm5yae3Y1i29x2tNSetrI52OfVMIW8GmGfAukyLG1oG/XvbCAA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(346002)(376002)(39860400002)(230922051799003)(82310400011)(1800799009)(451199024)(186009)(64100799003)(40470700004)(36840700001)(46966006)(40460700003)(16526019)(356005)(86362001)(1076003)(2616005)(26005)(426003)(7696005)(36860700001)(478600001)(6666004)(36756003)(336012)(82740400003)(2906002)(47076005)(81166007)(83380400001)(40480700001)(316002)(6916009)(54906003)(70206006)(8676002)(4326008)(8936002)(41300700001)(5660300002)(70586007)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 20:03:37.9242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 678a93af-2740-44c5-23de-08dbc9cbfe00
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9252
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
2.40.1


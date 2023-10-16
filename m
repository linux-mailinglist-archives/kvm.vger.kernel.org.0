Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E24B7CAA6D
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbjJPNuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbjJPNt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:49:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F6D10D4;
        Mon, 16 Oct 2023 06:49:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7Jh2FyYiWbDm77vWQfKp/3OGov0pRFGDZlP+jgTcejUGbAWOFuwlhG/ejjVr3c+CmUT5JT2bl2HOboHMB2vcbFXCBoUvK7vbT5XKK3R0uEA0UNz/AH0je0D8nk6bruyhS0rS0bq4axiQ9UIH5SD/qJaHkliEsRM24o5dyU3MyqIJ6XuGF5ZhwzGJ8Le5TSZcQJEgD/X+kRBSIoSE3VN3sNvscnhpSnKRuuabWq8weQLSExN8f9Fy+7W8qm7VMsHnqxJvNInKj6tVz5XqLcI6GFTyiXg2QDYitLx4Nk0uLEWhNXWPZfFGWuWH3QtMqdc5lGetUPaEFs0GDx2ILe6WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70mqkiCj04QYAqaioqMmcv5wp7tH073pBX3KBUuoK/8=;
 b=eWcw49WlSht7JrUX5nkBiZ0DDfe9aI1ElbvuJNOOYLsBSLzkNcWPzQ8mP3ELSzlgR0nq046idjj7IOEfZicu2OPAJHy+6FxaZJoG6jSlDN2Sc30ZSe2zqEChUJEn4G1bVs11yiPW1G0NJs6TUaZBtD+D2x1O7KSkfbp+XDn6R/fxpDbBUwQnQg25x2cy2gfqS9+FfdDyd9Ux42F1ZhXrI2G/I4Tq69jFR2E0VC/4W1rEKn4/zqxtxIy5HvR/TTuihRoBj7IBOUZXo/X+RwNUJ71pBtteIh6RPGYjcbnVbbSmZVsFTfu2UFt9TLWm1ukXveoaj1ikrsVxvTqCgVI0pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70mqkiCj04QYAqaioqMmcv5wp7tH073pBX3KBUuoK/8=;
 b=lIuD16s/Tk5Jy45POllgVh3kdtMjxp6tcZD7JuOKucqbbTfiOMvRS/7UTuddQbbsnOVphR64SAIIsS7mi4ZXPUHVcPw5BGPWRUt4coODXcc/OSkPSqfNyDcQBD4Mli+Wr8ixyb4VeZWlN/Ogw8LATP2GHAJ8LwTDHjmDC3IIs78=
Received: from BL1PR13CA0399.namprd13.prod.outlook.com (2603:10b6:208:2c2::14)
 by CH3PR12MB7521.namprd12.prod.outlook.com (2603:10b6:610:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:49:25 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2c2:cafe::c0) by BL1PR13CA0399.outlook.office365.com
 (2603:10b6:208:2c2::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.17 via Frontend
 Transport; Mon, 16 Oct 2023 13:49:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:49:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:48:56 -0500
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
        Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH v10 05/50] x86/speculation: Do not enable Automatic IBRS if SEV SNP is enabled
Date:   Mon, 16 Oct 2023 08:27:34 -0500
Message-ID: <20231016132819.1002933-6-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|CH3PR12MB7521:EE_
X-MS-Office365-Filtering-Correlation-Id: f336c685-3899-4420-41de-08dbce4eb560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aU/qkVmNuf514+nCEYgHmKIUkCsZhGPuIPrIPQXM5GHs/1Rv2Kgq4dV6rY3TEYTk3JL+0G/7O7GZpzFqzbzk8xxjSj3JVwNpgBJQ7qk8IlQKXFE9oWo6AZAvrAiM+BeM1yspL+qFm3xMIDKnHqQjTyGKg8YPJzKcjKGODM5s4hmE7HGQF8q1hX2ktv6YSWgJMs8keFYnvlJQ8z+F3lCZysqfRY6Kbm5U28RBhc5VU8JHINiwYSCjipg1jrW+VFAth/zkwDvc7CYX48qLsjIkwtI2bYuY+Ln2xQTpYu6zetWZd83qxdMpLbqVxw0jvCQMgRHVH7QrPJdI59VnPXLgq2NDHRbQU62d4qQJ5Di320iuFfR4+2vH1j46j0s3uQCMP4aXIWOyYKWZIYLRY4Fb+/lQ0WtgPrxXadEEt3W1sLkt3uovQFCs4gIVqII/PwkSiatc3WrVFjhbi0aZZJzAtnCRNSjwv+Ukh3tm/H/ckBE96soRZbvEO6jnnKQdjztRSonwW1EfXT39sLs+1xSdu4DFrSqd91LlYN+5yxoUKy/4fViEfu3a66wQdORpk3pXq3Y7CITI4VSuC/l0yiQK/qalSE4N6vGKD+HWYLs5U/yaQsdbFU3SA7iGZW9epjiBgOEf9OAnxu7LR0luwU9c23ecjX1l/+UaHf8+dzp0u/v+Dx59/c2fwBBqXidBm5/S5CuuWNNa9xTLMt8MyRhDqK3d2/T6AnBuQ50aTNmD8n4lOq+GZdebdTgZAN2DEo0TvZnElHDaizsc/2YwLdrplg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(64100799003)(1800799009)(186009)(82310400011)(451199024)(46966006)(36840700001)(40470700004)(478600001)(54906003)(70206006)(70586007)(6666004)(6916009)(47076005)(16526019)(26005)(1076003)(41300700001)(336012)(2616005)(316002)(426003)(7416002)(8676002)(8936002)(4326008)(2906002)(7406005)(5660300002)(44832011)(36756003)(81166007)(86362001)(36860700001)(83380400001)(82740400003)(356005)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:49:02.1467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f336c685-3899-4420-41de-08dbce4eb560
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7521
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

Without SEV-SNP, Automatic IBRS protects only the kernel. But when
SEV-SNP is enabled, the Automatic IBRS protection umbrella widens to all
host-side code, including userspace. This protection comes at a cost:
reduced userspace indirect branch performance.

To avoid this performance loss, don't use Automatic IBRS on SEV-SNP
hosts. Fall back to retpolines instead.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
[mdr: squash in changes from review discussion]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/cpu/common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 382d4e6b848d..11fae89b799e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1357,8 +1357,13 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	/*
 	 * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel feature
 	 * flag and protect from vendor-specific bugs via the whitelist.
+	 *
+	 * Don't use AutoIBRS when SNP is enabled because it degrades host
+	 * userspace indirect branch performance.
 	 */
-	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || cpu_has(c, X86_FEATURE_AUTOIBRS)) {
+	if ((ia32_cap & ARCH_CAP_IBRS_ALL) ||
+	    (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
+	     !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 		if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
 		    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-- 
2.25.1


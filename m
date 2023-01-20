Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2E66749CA
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 04:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjATDN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 22:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjATDN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 22:13:26 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF558AEDA2;
        Thu, 19 Jan 2023 19:13:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPQL3Ug7Z5R7pj76EMFPQOXfs2qZyZRUwVBtMWZod2hQr6vlSyGu1/qsWGbBzU+l3KAMxdkWYz5/qfq1uVPy1aTL2zuvtLwAhk6UyM18yNjyMcj0pgGo+RteMM7CxJqpj3Wmiv6vk1LF3Q0CdUTOFqyFaNI+A13IHMpyRP27aCHl1k83VKzGN8ZHyTDhpbTIunEZBQ+R58ajlqJfCj5E1Up5Plt4i3i5odYVnHUxcKfBebMAH4luOzBwc4cLOOsc/0sxtKChV0Ytpb84TSvJnJNq6PqdUyAH+B2XVP2KR9gaTPeGU4hNAxWPLI4BF2qU9q7nEyqGay915wwBW5TZPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r55GGCszmmGL2c3WK5rvEb3vBVGxF2/mrici6yBv4V4=;
 b=dKuTlnZ+m6yYOZJKPdl2YKQNmDzxTJD/94T5BT6MejiKsjWZFxxstiO0YqOzSO8aOE0JI6zUvAXi8mCpA04epsGiLocb5pvJwe9YyHfE7sWkSf8VPdQKx9RsSdH1PQkZdkLgqsVHHSjz7wJWg2Dr5dmLyQTlAaY/QsqTMeavVx9oWRs3hEssq72ALgJX/R1u42YTA6IkGDJjafrDcCD23V7O0FqWyXNGcBfVYMHtkDkWNnFKXWEElMYJhiSdRAvUN1UD3/BSTp/vSoqmKLh9vCwjGLaSctYhWCYjQZ6L+JDfibJzFn4yv80ru0oI5r5m3T2KfogVMgGUFWUAQ/Tb5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r55GGCszmmGL2c3WK5rvEb3vBVGxF2/mrici6yBv4V4=;
 b=34AQ5sE3mVfzt07tCR9ff+mpGz3hqL9u+/BJGmD4n2CrKzqkKcGaBcNIs6En60KvtwqF3y4VO3+AW1QZ5gf8k8QMY8IdveG9XeC9TSJWjsbGNHGfAlhfZZPE8Rl+Z2TdBB/1pINAwwXOio0+NekFFOIuq7X88OdyjxkXpeahJfM=
Received: from DS7PR03CA0303.namprd03.prod.outlook.com (2603:10b6:8:2b::19) by
 DM4PR12MB7622.namprd12.prod.outlook.com (2603:10b6:8:109::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Fri, 20 Jan 2023 03:13:20 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::9d) by DS7PR03CA0303.outlook.office365.com
 (2603:10b6:8:2b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Fri, 20 Jan 2023 03:13:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Fri, 20 Jan 2023 03:13:20 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 21:13:07 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sean Christopherson" <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH kernel v3 3/3] x86/sev: Do not handle #VC for DR7 read/write
Date:   Fri, 20 Jan 2023 14:10:47 +1100
Message-ID: <20230120031047.628097-4-aik@amd.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230120031047.628097-1-aik@amd.com>
References: <20230120031047.628097-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT035:EE_|DM4PR12MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d553487-8014-4529-f8c2-08dafa944890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3JO53eyfBJpXDk7B8dWVFm02xOS6WpdG8jCcw9o+t7UZtdYNnTRQcqi/VusWuL4tpS8pG0BWsIvZeVIaHYo4ZI2k4CSSA8YOZJ3gUnFdyWvWCPTs7SC3UlVFMTw9TBhnWTPwLT1zcSZtarYyOozT9XsRd/lk077kAvK/BgBKE8hK6iarPQdc9TUjCqqzzB7nD6LIyBXk/Hl5p8VFnGdyHVjPMAfuxu8Wiy1hYUG4+4VZ+fgE2LG7U2o2hV2aOY0Ddsoh/KKwGxOMZ8lfoqLkIAx02HpJrnVwdFH0Dm7ComEoIplHCZdsRnhBQepFZYVrAnucbsQRRi6s6aHrU3o9HWOGgffAmUPP8BJcJ/4C45WzQDlu8c0ghiq2rwzRCo8ZU0hlUD9D8ploR54YXw0yzmmIdfBIeTCi+jekPpBh7DbND565jknAq0uMiYqmhml/FIDsn/GqRazrAU/VZOhe4o2bBPs6MQPolP5VcoBdM/IVLKs3Hptlvsr+O9UxmY1nNDItSlf7/3s7+7PF1QHOWct7rSwIbgcaqAy3gJZSMp8OI04VEk2xDLMX7LcRoAOSper30/naHknMFKZowsrFNaGZyMsqPzd7qNCEutsYlQHGfpD3HIg05wAhNh/wZ8JgNBTiDHxEMoUxQ8HEZDhTlFV9KVB719PrpCwPis6PTME8lzGg+NGcnyfSr9M7qP96bXh4zNSh7EV4xpVNLlJ68B6yNYGnUosMD1NXDJIa9s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199015)(40470700004)(36840700001)(46966006)(82740400003)(81166007)(36860700001)(7049001)(5660300002)(356005)(2906002)(8676002)(4326008)(7416002)(6862004)(8936002)(70586007)(70206006)(426003)(40480700001)(2616005)(6200100001)(82310400005)(478600001)(47076005)(16526019)(186003)(26005)(336012)(1076003)(316002)(54906003)(41300700001)(40460700003)(6666004)(37006003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 03:13:20.5129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d553487-8014-4529-f8c2-08dafa944890
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7622
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With MSR_AMD64_SEV_DEBUG_SWAP enabled, the VM should not get #VC
events for DR7 read/write which it rather avoided.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
---
Changes:
v2:
* use new bit definition
---
 arch/x86/include/asm/msr-index.h       | 1 +
 tools/arch/x86/include/asm/msr-index.h | 1 +
 arch/x86/kernel/sev.c                  | 6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index cb3d0f6e6ac2..e15afe3500ff 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -574,6 +574,7 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_SEV_DEBUG_SWAP	BIT_ULL(7)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index 37ff47552bcb..27c1c349e49b 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -565,6 +565,7 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_SEV_DEBUG_SWAP	BIT_ULL(7)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 679026a640ef..8184f8ba4edc 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1618,6 +1618,9 @@ static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
 	long val, *reg = vc_insn_get_rm(ctxt);
 	enum es_result ret;
 
+	if (sev_status & MSR_AMD64_SEV_DEBUG_SWAP)
+		return ES_VMM_ERROR;
+
 	if (!reg)
 		return ES_DECODE_FAILED;
 
@@ -1655,6 +1658,9 @@ static enum es_result vc_handle_dr7_read(struct ghcb *ghcb,
 	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
 	long *reg = vc_insn_get_rm(ctxt);
 
+	if (sev_status & MSR_AMD64_SEV_DEBUG_SWAP)
+		return ES_VMM_ERROR;
+
 	if (!reg)
 		return ES_DECODE_FAILED;
 
-- 
2.38.1


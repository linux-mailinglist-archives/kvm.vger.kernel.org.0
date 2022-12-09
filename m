Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E571F647CFD
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiLIEk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLIEkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:40:21 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2057.outbound.protection.outlook.com [40.107.212.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0447C7A1BC;
        Thu,  8 Dec 2022 20:40:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOXr9ZHipX2mTBM7OFc6EXMmR/QeG6iLHdcbjEn1A5S/ClqJG4rvMnGyX5T2G+UdPueqonl4kWl148N4mEohab7xBuRihzECoT2ZBduZ/5UhQSMpDFAnrmTelbk6zBy6WMzTBdTp7o939PMIOl0ug+ylSNgTVl3ZcozldTy+7GyOJ3u0VFXWfUU3UviKXDoZty0dLD1YhlCvdTjBxFOukxNsJwlGwZOgNEPZTT8TVp88+IuVQAEJ18vGNE3nxcVv+Yu8MgEMJHCaAmNEYjd767K0+os+1HCEECGQ20zmyPezrKRED6ZicvIonHVrmOV5PeqpoJkLxCBcJki+nSqJog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lngX00Who+nqpDD9WgcDOCvd3yZUYH0gDvFiyMgJv4=;
 b=ZEwFmR8/aEDxjg62qyVqE42zg9LyC+smyntFwULHzc25zgmDqZWaO0W3pVvcsfRZ2US+3ne/QI+oqwircK5yejC74vOgtZ+HeJto1r+9+xW6p1VBmbiKPPRIW6AlZ2He14cYVZT0fO+l5gL9lkR3qS4mXIcy6Qlq/VY1JtfveaXDVT+pgwIDdXBeL+ALeg5c1szUYuk2jneKMcrvkdc0t3F2poRFhjtMNDYE+Um2ztPFNyi/Tx8/cr8LAOti6Esz5r7t0H0kkuddxUJipzM4beSJeU34PCqAwQyB57rmJ4Z/zX2lg5FNNjyNKZ6ojXX8VUamW82KtXE9WnxuqCnW2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lngX00Who+nqpDD9WgcDOCvd3yZUYH0gDvFiyMgJv4=;
 b=i2sY1b/Vz/m2xbcHiFPiZe3WkguP1R+fgj2PKWqOTw72HQrLacK5NTrjiDzmdZZeKuiBEi+72SntOiqYm7ZR5+GleSGEPXAb8oVks00M+JBKulBznZ5cEIXttpaz/RwA8tnT32yxkOBL+3ViMfM6tl/EzvXxmdy6tKs024UDVl4=
Received: from MW3PR06CA0024.namprd06.prod.outlook.com (2603:10b6:303:2a::29)
 by SA1PR12MB5614.namprd12.prod.outlook.com (2603:10b6:806:228::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 04:40:18 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::3a) by MW3PR06CA0024.outlook.office365.com
 (2603:10b6:303:2a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Fri, 9 Dec 2022 04:40:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.17 via Frontend Transport; Fri, 9 Dec 2022 04:40:04 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Dec
 2022 22:39:48 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sean Christopherson" <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v2 3/3] x86/sev: Do not handle #VC for DR7 read/write
Date:   Fri, 9 Dec 2022 15:38:04 +1100
Message-ID: <20221209043804.942352-4-aik@amd.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209043804.942352-1-aik@amd.com>
References: <20221209043804.942352-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT046:EE_|SA1PR12MB5614:EE_
X-MS-Office365-Filtering-Correlation-Id: 053b0ce6-40e1-4184-ff14-08dad99f796f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CiYYGB2mnN4NrnYa9ipzSwt799X2Geo0ftBZRfnBWH5BSoViPCOLEQJK1nHK2fzdWtZO0KHUckn9mVWjal5ixPsHuZEkAYdmpj8dZ+kdgZcSq4/KGoShz9g12YORbTFB75vB+/RHkOyd8x2hbGD5pseXoB4LQ54JfDfvt+mkb4Y9z3g/oAMUpjwxYzOOOmr7RVtS2LGs4GFNycpspxMpiIvNT5JQ/TsNF3Za0wPkvP6fOnvQMH7upcCYV+uqjHOFJaXujN+rtmRGY7UPdHJXAUB1gTg2GXb8/WxX6ty47Hd7wmpVzupj+4+GRnZ5id5wkLYhpNxwhyYdM+f580q3LnR7K1e2mjT19fHX0Vvi45RDkqLx7Aed/nq4hn9oxH7HA4lg4PkxdGHJYm4dQb02e6y/33l0Kv6Md+u7OUE6uSh5V1p5PUSOSnihsy0b/Ral9h9PT6UeI6IM0AgVKzDlRZLqPf6QkF0ttxy88I66FTJKSUrTSQPHlc6KjSeKULdBSW/wOJ0T1epP10xsqF3lSdRyifz513USC+dnxI5Yc1S5wBTPxchphRudezuPRR9Q8x3ZShBG6te6FPTLbi7boSiuc8WmRUDpKpVqeKr0BGZC0h46CUH/m2DJxCm/i9MA4prBjEDM6yCFHKuUDaClQuzwE7BTR2ZpgjJWd/1xgVttdvETDNOVzNNcjikiWHNIIt5tx3QSCVxINorVbB29tsjtk7uvVdwdvSfksDxq0WI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(40470700004)(36840700001)(46966006)(6916009)(426003)(81166007)(54906003)(356005)(316002)(4326008)(336012)(40480700001)(47076005)(36860700001)(26005)(2616005)(16526019)(1076003)(70586007)(6666004)(70206006)(186003)(36756003)(478600001)(82310400005)(8676002)(82740400003)(41300700001)(7416002)(5660300002)(8936002)(40460700003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 04:40:04.5048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 053b0ce6-40e1-4184-ff14-08dad99f796f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5614
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
index 4a2af82553e4..979ea2dd3845 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -570,6 +570,7 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_SEV_DEBUG_SWAP	BIT_ULL(7)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index f17ade084720..2264ada2e26a 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -570,6 +570,7 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_SEV_DEBUG_SWAP	BIT_ULL(7)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a428c62330d3..6141c789e3d5 100644
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


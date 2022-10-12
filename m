Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7126F5FCC33
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiJLUkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiJLUkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:40:21 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85A74057E;
        Wed, 12 Oct 2022 13:40:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGdLmBeiHQuUTU5Fq0Ya2vUQlR/bAzfc8NijdQzXamV/VBsPLDoYjTGYZml2QubMeqCj9NryOSb7CZLQJjOMg+4jCEyM7liBlrfgcDkT6/LgiSFuUZi0PzNhW0YHLgHDekA3+gggp/XsrFNbz6cTUzT9gqk9DkBCfKQHnwEo6qZmSoKzZFj918HpDjlvcieXrcCE0uyTj+dJdz3cFsdy6WmUWKOjHImBzfwivfR+EYU5tfKsIpZtroZ6gU9ojb0W3TfY/3YdKpOEfCAzRlm9on00WMPoT59QNMNg9iI6m9iDX6rzq4i6/p5ZQtJ6H0CGsVPf1/Jw0psqHydt1oT0Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yykaEUDx4k4btdvcxxhughkIR/ZXY/PQ+ERv5MKUim0=;
 b=AzCjOg73YYM47KReOuXIKdSMtNSU2REv1fs6K54e8GsezxoBNPpYoMkLwDgv5XeOk7pzcEwHNSNxvtTUc+SaLMBG6WwcV7rV8g5T/Jhm+5dCJaCunJCEx7Ds6l/ZA4C7Xpn0d3c5lH4qDCp8lxSG4JSmbb8BdKQlHZpcGrlGQ76s0Rsgcb5rPz3FLGI046P4/zDXOhr4pR2mGxU6g1e+1ITi4E+3mG46Ti1PzSMUeg2N1eeRwpYzpl3ulUAKIJAFFNc/N1KBGSPxXl3gW+ICFMp1gJYxoG9IcQsgPoZvu7qyosgR78egP1wUUsRx2SmM8lAljHak/iJIof6VLc+/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yykaEUDx4k4btdvcxxhughkIR/ZXY/PQ+ERv5MKUim0=;
 b=g4h4zw/zVHRqecCijOLJuuVEGfbWuZh5kDz/tpPfyyK+an9kH0ioEZ1vifkhuWMfgYXTQV8K6LveDsQboXnOqCQEVXcMIi2b7ptxGbEWIz5Ts332vlMMM/gJXZXm+O5hhEDYxOqV4vfnWswjHwI+QGAvEwQ7GaOSgDmPv0HtCDQ=
Received: from DM6PR05CA0059.namprd05.prod.outlook.com (2603:10b6:5:335::28)
 by SA1PR12MB7296.namprd12.prod.outlook.com (2603:10b6:806:2ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 20:40:02 +0000
Received: from DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::1d) by DM6PR05CA0059.outlook.office365.com
 (2603:10b6:5:335::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.10 via Frontend
 Transport; Wed, 12 Oct 2022 20:40:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT104.mail.protection.outlook.com (10.13.173.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 20:40:01 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 12 Oct
 2022 15:40:00 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Subject: [RFC PATCH 7/7] KVM: SVM: Add CET features to supported_xss
Date:   Wed, 12 Oct 2022 20:39:10 +0000
Message-ID: <20221012203910.204793-8-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221012203910.204793-1-john.allen@amd.com>
References: <20221012203910.204793-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT104:EE_|SA1PR12MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: bc92e5dc-91ca-4def-fbd5-08daac91efba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GK/F6oBJPiaktMd7+hopSpjJP7jU1bUd1NCmonryS0IhBV4A7XEBiLWr7k0qaqKXblMxVhB7phSCzi1ZismCfK695skRClHZ44t/XVQdikV3ckg+QifJ+MN6gOdXTh5hHQZGVQg2T8euxNwKyuiFzc0+5yfCx+VHdin7HaDZW+BINZhBdjQnMjMBbRnP5DzE8K0nAMTPsy4xBUqaFUuS795O1vmie67rjxdxG5X+7rg4y+mCyP7Di6XhcxCp0qyWMIlUxhNfkHNrzhVs1L8aOylk/6Aqq+0/tN2PFhSJYHAZuTOsgonZBZZLI7iGZ0HurJyj4oqqzGfSWDAegZvU/O8OssmeE4QJNdyol63LPfjV1AAYUZdW+TpPhEbr3qbGE4arsm8TlFowW96UhdiESaCoSl8BEtJoNyTxBdzv3lQxSIg616jkQ699FVu9IY5zbNobKVlfgc4iHds4FFmnzgvVDSsPqR/+YxN0huS8tPpMkEjGKKoru/mkzulCbmOnKkCNKNlqzNZCngJ1sW6j9HZFUxGJYsfxy5YmkxuKtTlJF8xGhdYkW+53GXaaOoAf7R8nrAlwF6PYiFUcdXTuYYradxHfCIcl9WxK8bjthD3/mlGIv0jsPMbIs+6UpcrBEzkAwOTLgmC7Qt+0EB9acJ28/a2qb3esz26qYg3MwrBlDI237CsVMcXLgUJCABOGiLG6ucIcCk0LLBAuAzGPTXJ30zf1QBtf8upNYNyCX6KJBJIesY/76bAhXuC7c6BvkLXF6XkgqGsQIEhyjJBlYpqiw3IvFFCjPG91ErqnJK7dOVs2/7cdFqSgCq5PyEal
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(70586007)(356005)(8676002)(82310400005)(4326008)(81166007)(70206006)(54906003)(40460700003)(40480700001)(36860700001)(44832011)(86362001)(82740400003)(6916009)(36756003)(316002)(186003)(16526019)(8936002)(26005)(426003)(47076005)(7696005)(478600001)(336012)(2616005)(6666004)(1076003)(41300700001)(4744005)(2906002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 20:40:01.7809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc92e5dc-91ca-4def-fbd5-08daac91efba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7296
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the CPU supports CET, add CET XSAVES feature bits to the
supported_xss mask.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b474c7e57139..b815865ad0fb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5026,6 +5026,11 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		kvm_caps.supported_xss |= XFEATURE_MASK_CET_USER |
+					  XFEATURE_MASK_CET_KERNEL;
+	}
+
 	/* AMD PMU PERFCTR_CORE CPUID */
 	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
 		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
-- 
2.34.3


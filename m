Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF177C4096
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjJJUED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343861AbjJJUD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:03:59 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2078.outbound.protection.outlook.com [40.107.101.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFAC181;
        Tue, 10 Oct 2023 13:03:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8J0F3V7CxQUp5SXQfPbTGcwu4M0xjEtTS2y6clCua1WCoiReIpdTR1Dr7yWnbZ9OQ5699gqmNGoRreqwLaqJJxwvNxo97VRHh/XXhFno9CDfOa1va+5EZS43anxv50dFqE+2LFw/a6XhkOP857DqUPML5lkG9iss6/rzrHSBwqkX4BCCbkBBS8EWBlGz5lwETLfJhgE4DeKTsj2CCZvyupRfSLviu5qp5hazvm5pSTzznmh/yCWZ9WhdTMcHd/6MBm8lImXb+UkWAcyBFs+appw51oD/fnjhXMQ017/nwy6kTBHL2gS2eK0tfVsgfrPKy4bLB2XtXtqcWiKc+FeIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zak2dgjUMS5qUipDaDvV8QVbeVAnVRyna3C8IIn4zyU=;
 b=mktNG3A2jeXqPKFFcT0M2MC2PiDJQJs3shJ4vOQBMviaHmCNSf4aVPhyP/S5Y0+2ekiGcRFiC+5Fsw4+2ndwWTUHKy0PZUcUWDOfc+Mrb+wmpRtB00PdxWVyFNxmAGtVuhchxCVJigyiOSuFG/PpXK3k5gStsnJtwA33D6nrgu4+Xd0VT5f5xDXMhgrlJfJjRbZVZNeXn17Kzl4Tpz8oEgkd4cBMQhojjwGOdvGbEoSiDs+g+2qlNbDb9yq+7b5tRRpLgWhH1hFmvYL7gO1Fw8KgHsMMZA7Cj+0C1i/GrZQq+vXy5FZVJvygYkAbkMQTFIX7pGbzjX1IIIMVbbS7Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zak2dgjUMS5qUipDaDvV8QVbeVAnVRyna3C8IIn4zyU=;
 b=mus+ZOh0Ivn36R22PMipDfswunF2adyNAY9ngnJZm3Uw2PWVhVZ+Snj30w0c6OtMd2jRCInSo2hvlLVP8De4jsCxncuHufQw0UCIWDR568N8Fljcn6bCZIxfMZZytN5/P2YpDfohjzCijpBlJksvIC4zOCO8JJ8W7dG1Mt2ZU+g=
Received: from DM6PR05CA0047.namprd05.prod.outlook.com (2603:10b6:5:335::16)
 by DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Tue, 10 Oct
 2023 20:03:45 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:5:335:cafe::cb) by DM6PR05CA0047.outlook.office365.com
 (2603:10b6:5:335::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.21 via Frontend
 Transport; Tue, 10 Oct 2023 20:03:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 20:03:45 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 10 Oct
 2023 15:03:43 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [PATCH 8/9] KVM: SVM: Use KVM-governed features to track SHSTK
Date:   Tue, 10 Oct 2023 20:02:19 +0000
Message-ID: <20231010200220.897953-9-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|DM6PR12MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: 833f4a0c-3326-4d60-1199-08dbc9cc02a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KCcvyWojtGGezGkYqfZTrnoB4KWLLInYTpyYc4sDe48dVMEIbMCGf2aVklSE35Osc3TQyFrVmNgrxc/2J0nz6dV575BSoQyvLm5zAHCcmNJqXab9dc6bjkZNihLQLeVo5ck84md1n1XR3i9dM6AksmkBqQ5uvvyIbubQP9YIR6mYBhLSNJdlFTaSMw/hQxhZYRD9IglkHzR0yOxUKt5q2HKzMO7zCkGhQi4j15C++NPmpEalxLw82SiPUsDotrXVNMspXIYmBPeivf17opk6zQIr/p2UkaBIUOJ2R2TXmJhqtGRkIzfDNtEs1XNYa6maRLi72dZBHNYflnTKZgSmedIydh09mMIr4Ss3ppZmMY2jeTZsSTLSVh8/h0lll6dl0jidzJhV1At1OpmKdl7eC6d9q6h040evOdE7BdqqHuJ1sJ/nhOk6PTOdIP6dSvt3tsnUgBoxV/BxOHL7CCyP4uIiud9ProeAA3KB0D8TbZd/dnMTfLEpwEhPxgV0qbvTHdgZAUTIQFj2A7g4wLaI18DfhiGmzLr1qzyzsP06Z4RRFiP7eJy31b1Xhr5gWHvqi/litUWESVAOz5wLYRsXmsGZAq3f90Cu79f3U/JQ1BE2YIKa8wM+rtL2S6w4ic7am2FTkSABFiB60XJlrMQ6PbZLMqmIdNY35IYxP1gHlW7nSaRbyGFO7NBqMEgoqHaQe+scxPr0MmcRwiJDjW+7d+d2sKL9mUW2quS1ohhotCKIKYnT6nytgVGe2jeu0lOEDx6QyMmrYTxmWjQWcd07tg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(136003)(376002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(82310400011)(46966006)(40470700004)(36840700001)(40480700001)(40460700003)(5660300002)(16526019)(26005)(1076003)(82740400003)(2616005)(356005)(81166007)(36756003)(426003)(336012)(41300700001)(316002)(6916009)(8676002)(54906003)(70206006)(8936002)(4326008)(70586007)(86362001)(7696005)(6666004)(478600001)(2906002)(4744005)(44832011)(36860700001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 20:03:45.7356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 833f4a0c-3326-4d60-1199-08dbc9cc02a8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4170
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the KVM-governed features framework to track whether SHSTK can be by
both userspace and guest for SVM.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ee7c7d0a09ab..00a8cef3cbb8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4366,6 +4366,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VNMI);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
-- 
2.40.1


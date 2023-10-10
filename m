Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7D57C409B
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbjJJUEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjJJUEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:04:07 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F426E3;
        Tue, 10 Oct 2023 13:03:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hf6EC+t+HMmP1YYO6BlnCqQ7y2cv99febT6/pJqZ+R9qFhcOAQLvXevrUSsfideOQfYpd/1o/Gjg/LV/oEl0ECK7EVMivTD24C0UweH2I50AEKxbMKMitUlUEq3cYprDguhnt8peBs7FpcqG1qC0MWgr8YxXQE7nPrpnSLbAbe5Sx2LdibjJI152B6cGtp404uiLFkuICCs2aIirRsvL3y0ak7aGWq3dy8O02MZN//ixPgXE3BMzQLG04L+PmE+1H/ysCEZ9NuP+ddX47zV3skQ9sO0CHD4bdr2io4W6c9sEXr7V3eD6dtjiqztlIeDtiiuUav7nz1Fg4jVgrYqUYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkoCrVKmGDI9hJ00SrCItoojV1MeeJLDkvk0tWwF/lk=;
 b=FPUv3kwbSeUE//5Uk8XbEes3j3KK8IlgwxlwioRiYAba9JBM2+njIdPzzDzPBUDoK0VDd+NxqEOI7Y0Jvik7ADGt0l22iMCNjmeK/tsEhQ0FrG5iNS8foIj8n8tpllK8H4uxdOo+FLDMOMTjzCXVN66KbN+RXXVylxngeUZmb/zxkbvdrlDTeHs3v6qePOqI7apbr6/yW+J+131WrIXqb3B0c4fUhLoJ6lHjA2hIiaGaIwObOgdrVXrQCF4vExp1MXAqFDkSixlb8Xq/P0JxTwTcsGuBSComLQvbfmMEyPd099h2l8D66ug9Jy51dA/1FDTH+IMlrEUIk5+n2zdvXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkoCrVKmGDI9hJ00SrCItoojV1MeeJLDkvk0tWwF/lk=;
 b=M6CgHlt2Ni6yddWzxxEfbxIZAHqIyJJwAT+tkxTrHmqHgIzEtAifAHVLjFQJLIWCn1S9W20onhgfBJBsRRqjKjjErVdUZE3AbAuxGXxi4xiWr8nIayEyulNXHlYA/SSlFMkOn5FnBbBV0mblPMVSmGz3d0jGnRZqjT3tICCcaQs=
Received: from DM6PR05CA0046.namprd05.prod.outlook.com (2603:10b6:5:335::15)
 by SJ1PR12MB6122.namprd12.prod.outlook.com (2603:10b6:a03:45b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 20:03:51 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:5:335:cafe::9b) by DM6PR05CA0046.outlook.office365.com
 (2603:10b6:5:335::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.21 via Frontend
 Transport; Tue, 10 Oct 2023 20:03:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 20:03:51 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 10 Oct
 2023 15:03:50 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [PATCH 9/9] KVM: SVM: Add CET features to supported_xss
Date:   Tue, 10 Oct 2023 20:02:20 +0000
Message-ID: <20231010200220.897953-10-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|SJ1PR12MB6122:EE_
X-MS-Office365-Filtering-Correlation-Id: 0df1a071-ed1f-4a8e-4ff8-08dbc9cc05ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbLkg8i3y5A1XduNTcHfRYwk9gZ8hC3y1SJU6d94eEbKPHwxxc4mLeymm7gHG2vBX9tr0+W/3P96cVL6LmxAiOVIQe1HcEhhBXRhs+aGCIjeiDhr43dvVyCZJzP82CKSPHWxxUU+rT1xqyYYmjYLHQZyvB8gr/ug+D62Dqj0X2amRfwExq26uGhklUJOhc/rY0wO1FEiafmlHaBs259f3Q3zpBhVYXXJplbowZz1FTHgMIuDqGTb9YS0bTDhW8O5VBK3DQFh9J/1D68bwZgQ8byxcGYYVZKQEEEjjsAfa9NyUrgiBinASnEyMi+goQqGVQu3XMHAPXfbzwvFUlMjzHJZKSgqQlyLVJIAEW0KfdtS8YJdn0kkE22bq7vOyyzLQkZHTxHcta0orx0Modh8pN7PlPWTRwqb0Gi+QI8zj0y/mqVAcGR1RMVcc4n9v217VLIDM8oCUZtw2NcS4Cp3BuEGcRKMakBf4NzGq0LoQUXdyEFSOpEvcuDbUXSqzXf5kCNortY8SjR6PZhZWZU1yxcitmU5Mmw1htJPOY+8YI9A3l6btwMhosmjCPvE+sx3Om4nhr5gk5DytZ5vJqaG+yIHU1WW1CtPogggjxFNNBUgz1wU4gALtkyJ7I6CsXGw1jQuFrkFH7JyM+qaZ6ySx5jqynzlR81xLhh9jvRY9N9PG9nFEISgVN3nfbSwl14gqJKFstuSTfHGSrDQZPTo2pf65Ee/QXFje+vSrOxcUVZd9tRMzuh+LM1+EV8f7TyJBJKDyIggVvIunrd8AhCK7Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(82310400011)(36840700001)(46966006)(40470700004)(40460700003)(1076003)(7696005)(2616005)(478600001)(6666004)(426003)(47076005)(70586007)(336012)(16526019)(26005)(44832011)(4744005)(2906002)(5660300002)(54906003)(70206006)(4326008)(8676002)(6916009)(8936002)(41300700001)(316002)(82740400003)(356005)(81166007)(36860700001)(36756003)(86362001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 20:03:51.1419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df1a071-ed1f-4a8e-4ff8-08dbc9cc05ef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6122
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the CPU supports CET, add CET XSAVES feature bits to the
supported_xss mask.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 00a8cef3cbb8..f63b2bbac542 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5151,6 +5151,10 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+		kvm_caps.supported_xss |= XFEATURE_MASK_CET_USER |
+					  XFEATURE_MASK_CET_KERNEL;
+
 	if (enable_pmu) {
 		/*
 		 * Enumerate support for PERFCTR_CORE if and only if KVM has
-- 
2.40.1


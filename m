Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5F070FADA
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 17:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237529AbjEXPyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 11:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236127AbjEXPyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 11:54:33 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A304119;
        Wed, 24 May 2023 08:54:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ryi5QxoI2NKF1NXJ50wi9tdle25147LCutwsTNnu3pRWdSznMg/OoKXuQ5dWPgLj0RwRhh8dgl8pTOC9Ot3CxeF6Ipg+qYeQ7qmNNWwwQA/q6y9UFZwQa8sSYb7vK+NHNcYdUEBmEk825lnVwlzi079O+J4EYT9YCNbq8bCPbWUnMGgi6YMbtEIaTR+igTItxx4/TAkENmZi7vuBwKQM/tlSEexNl5h6B6NV00jBxqhDLchwN83+y1C0inXCG21c0TalePwuDDDyi2jLZDWo9+beYnV2W4KyVFZlyqHPtjfBsK+OKJqjINmc3JQZe5R6FkUS0C9Lo56A/yE7FsEx9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q6zIH168ovFtPh3MqZF5O+JOgyVJkebtffL5YDCpYbY=;
 b=f98FAm5ecvqezP1jO0T2nymnsDP0Wd/eFUDROxNn5cdrzTi1vouNjLo9cWcnoTv8fU2rWLuI/M5XOgvqpMrXm677PDyGdQZ3uMCzgf2UWuO9FWTwXjFo8lu8qWrG+T4h6/ul5/9Hb5DsGxcz/qtOVTNnWZtffByLYB2I677mczuyYOtm6/4RXJYWsZ5d8a2rP2HTr2CcFIX2X1FN+EXIBTCmTpM7Gcgmcudqg2i3b7TPZuWYxmzdLbXEu/C1ArGS032+keKGY67Fxu5XZ6NREb93sAYOwCEd6/LAWmnEShqFEOtwefhlOaBsIgum4ISDDYzxvdvsYIIaR0051ilnPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6zIH168ovFtPh3MqZF5O+JOgyVJkebtffL5YDCpYbY=;
 b=zdvB45dOJ7AK5PS8SJSXuNVctF5CzmxhuVHyq75LXqI8edE9UUqVU4+Y+yYZhptc2UY/BBwyL17mEaJp69zBtKLGE0A4xWymqMhy95EMp0PDOEyh3fuDChvUG5oJE25kZ/qIubcCGTAD/fE40KKohKiwkvIn+WrLaDIRpPUSAVU=
Received: from BN9PR03CA0883.namprd03.prod.outlook.com (2603:10b6:408:13c::18)
 by BL0PR12MB4913.namprd12.prod.outlook.com (2603:10b6:208:1c7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Wed, 24 May
 2023 15:54:26 +0000
Received: from BN8NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::19) by BN9PR03CA0883.outlook.office365.com
 (2603:10b6:408:13c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29 via Frontend
 Transport; Wed, 24 May 2023 15:54:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT079.mail.protection.outlook.com (10.13.177.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.30 via Frontend Transport; Wed, 24 May 2023 15:54:26 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 10:54:25 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v2 2/6] KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
Date:   Wed, 24 May 2023 15:53:35 +0000
Message-ID: <20230524155339.415820-3-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230524155339.415820-1-john.allen@amd.com>
References: <20230524155339.415820-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT079:EE_|BL0PR12MB4913:EE_
X-MS-Office365-Filtering-Correlation-Id: df79e489-4fd1-463e-be61-08db5c6f2708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y4vj+o+d6PXxIb++2EPjxdturEJaC1Azt40vPIumiW7iYoG2V2Y74aKBABsrwyCejZr7ejxUSOS61u63y6D9zdRw/qE4Bp1zfS0XMl0uIo8Q92ptJesiXYGQ+uvT1IjcAgOuqwd338+Hsf6m4ycmhWkViHYE11QnHJCewC3AzzmAZXJo2YDhFelwVXSZqVYrRAruDIMkQg4VDTsy6UDKpxYwri3kfhlBaDcm+4tZtOjEKv/yLOUJzpm6MzjgvSn/55MhsASAeKZux4VN99j95Oag4c2cHGFZanLwEj9N6j1vud9CEManWG3E+odVbKAw98Hqj1OrGI/2ddpf+aYrGdyIrTJRcv/3NSsKUYrisfuLQcAkzcj3a0UyKy+R/k2SbSf/NdCCTz0c5rtyZwcqVlWPXh8fU/ai/qzBmDfmAbe8C9MrwqsT5CBr19N9wzaASTn/RbYKB6Lb1PjdYeR3y315vZsQmbmO8W5EYctlaZsNsOxY3wIIkg9OOvTczDnMNHZvr4IhCZwxRov/mzKjGY1N3JaerH8dSQbgx7xaxM1wcZXjmuHYu5wswftfzT90SAUzEI4nkNQH3p/IRDHtmyTwYLCjBCDRjjzh0YveIEoms+F/Wm2ZG1oESIJ+u5TmudkNHcwZaDQeGfa+r0Ef6M7yVJFol4XkBckeO5ENTdXUg3+PI5zmWjdlUX0T3uAMam8gGfJOXzpMHRZe8JGK78dboJsyUoqfQEh/jKKLssUj2/i1jY+oPAmU4SKYXgGgvBuj+MCLuFWJSCjDNLqDvQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(46966006)(40470700004)(36840700001)(186003)(81166007)(356005)(82740400003)(40460700003)(26005)(1076003)(44832011)(2616005)(47076005)(36860700001)(36756003)(336012)(2906002)(16526019)(40480700001)(316002)(6666004)(70206006)(4326008)(6916009)(70586007)(7696005)(41300700001)(426003)(54906003)(82310400005)(86362001)(478600001)(8676002)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 15:54:26.8754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df79e489-4fd1-463e-be61-08db5c6f2708
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4913
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add shadow stack VMCB save area fields to dump_vmcb. Only include S_CET,
SSP, and ISST_ADDR. Since there currently isn't support to decrypt and
dump the SEV-ES save area, exclude PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP, and
U_CET which are only inlcuded in the SEV-ES save area.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 822d7a65e92a..6df486bb1ac4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3392,6 +3392,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "rip:", save->rip, "rflags:", save->rflags);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "rsp:", save->rsp, "rax:", save->rax);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "s_cet:", save->s_cet, "ssp:", save->ssp);
+	pr_err("%-15s %016llx\n",
+	       "isst_addr:", save->isst_addr);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "star:", save01->star, "lstar:", save01->lstar);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-- 
2.39.1


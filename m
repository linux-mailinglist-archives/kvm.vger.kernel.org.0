Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1B955282D
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347590AbiFTXUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348740AbiFTXTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:19:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6AE28994;
        Mon, 20 Jun 2022 16:15:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TI4jTXVvxsFPh3i0Wo+pfh5JClWS8tCA1O4X3+7v/oz94dyURCqMQhTK5QbyOD6tGj18ivcKZnVre25E2xUE1kH3jloaJIYwy/xElLm3OfemiCcbNirWT8hC4w3xEachhEeXwU5eBy8hUpTqbYpYz7rWsfFdTzOB+W/sFFFjNiGPyeCOKjBqzgQa2xirTz+/b2IUV8R1wOZJcA9VJRyM6Ont9kzCRq92pG1x2rOv6UmsZZOR446sOTQXxeG6RUcndAjM+A/sEnUJ+4iOWwf5yWhlA7neZWH0FdVDste0TEvd+B9shIh8iQN7VruCr1rXD1c1jW/+z3tVZGNXwj9dIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/J8G0bfp4LWOx/OjRjyKoVZ4QH5t7Fdin9D8BEx40LM=;
 b=aeNJ25ZmrtWes2oTtmFCedfSrPdG5MQTZaIK1uVSjNdPm552Wt8PjL7gAdqpcJDjs/Xdu3DLyPIrz1Q1Sf2FScehgXuVSG3G1D7sioVtMdZle+INn30vgXB4I1AlVgK9XEB/5omNQNuga96oLWuRv6+sLLF6gEckhFoffHlzSbZc9j40ZfY8qi22tiScNPbVT21ZJGAXHAf7kTZDZ0CAynzAtZK/rTIZ5Y/uLjepOEMoaCHnxO34BF2Ee0Mg2ziNb840K5Sj8+J6A7Xy7GEP/OQKeKAhEgRB8g+WMsoy08oq5Na/2Ba3peWciOTzuMaohEZ4Flwo9DwK5toiE8YGkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J8G0bfp4LWOx/OjRjyKoVZ4QH5t7Fdin9D8BEx40LM=;
 b=xqnZltMtPBGwZ+Vxj8/QMQRFOAXN+XX0JwVtmXf0Dy8qc1h0ndtr+ogehTXp6cbIkX2mvvvQtES3JVB8MQWmKJzw4aGRcWtzNpYxAekiFKhO7tFyOdXthVbSpwoypoK77CuAxP6tBwXf5xQcuS/AEEHrbS7xsAoQVKdMh64Kxb4=
Received: from DM6PR21CA0029.namprd21.prod.outlook.com (2603:10b6:5:174::39)
 by MN2PR12MB3549.namprd12.prod.outlook.com (2603:10b6:208:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 23:15:09 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::75) by DM6PR21CA0029.outlook.office365.com
 (2603:10b6:5:174::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.3 via Frontend
 Transport; Mon, 20 Jun 2022 23:15:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:15:09 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:15:06 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 47/49] *fix for stale per-cpu pointer due to cond_resched  during ghcb mapping
Date:   Mon, 20 Jun 2022 23:14:58 +0000
Message-ID: <1dbc14735bbc336c171ef8fefd4aef39ddf95816.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e5c9583-bab6-42fc-d8bd-08da5312b83c
X-MS-TrafficTypeDiagnostic: MN2PR12MB3549:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3549217766D2DB48F527167F8EB09@MN2PR12MB3549.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5zr4TgVMeWsk1I9Qnj0sKNbkr7XPFZMOGSTvhqSeCFcLdF9IAp3LeYLY33HInXu+A6Go4PLy9hg38KqQ5je16LUM3Cmfk3vKQ+U5FxLLRcPWdCySilpnWWezZCyayVVnW3UyTIpUmFd0Yu7NEB1cH0AxOKGSTpS56xw20oE6e2EBfq4IfLp/ozGJstNGXrxwz9opnMAQ18qfF+lcOxvIFQbzTDsiL9TjgsjyMmHNd7GqnV/l7K1+MwxkrLnnPQqPsvYudfW3CGbJhoznS8xc9z41/fOyP0+s7M+4jyyMVF9UeK0rAvqe2K4H+f3qgOW2jOZ37fkW2fXdV4a8Fbb7+A5clQ7JHCCOFI7xhyb5RYFwFdZh3U+1zqKnjOaqTcL2gnGtcbD980dViyj3Wh04oNSvGzmaRPc6zBHCJ4qEuO+wW5+OE63sV93OJZHQTfh7xUK4o2ggo1Pm168CqWr2ShuvpPRYb6z8NbLddHTF25OrRpAG98m2eKQqb/co6DxYGHU6mPN7NSxDO7bWV2oWF2dscj+5Pmzykdl0Jh8clsSyaQI3n34Ngi+QaPPHnWCHIiK3YponlHnHoXzgs2XnpwW6bQ9Bg1GCP3kUEE5J+ff76NS5ViAhfXSu9SrA5X5lDvlXBWNCRbmwmGUAuLMa3hUjFkrVoaY8EuDJxGqhBUMGo5KFsu2d2VHPQh5dYJbz9Z3TAnMyb6Vnwj/bFMnTjGJd0CupFdMROfpPvZg1/zFhtXuBJ3tPSeURCHHo1q9f/WwJc/FgIEZ1/Cby/Vh7JA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(376002)(346002)(46966006)(36840700001)(40470700004)(4326008)(7696005)(54906003)(47076005)(110136005)(86362001)(40460700003)(26005)(2906002)(70206006)(8676002)(356005)(70586007)(82740400003)(7416002)(186003)(426003)(316002)(5660300002)(8936002)(478600001)(7406005)(16526019)(36860700001)(83380400001)(2616005)(41300700001)(81166007)(40480700001)(336012)(82310400005)(36756003)(6666004)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:15:09.0921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e5c9583-bab6-42fc-d8bd-08da5312b83c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3549
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/svm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fced6ea423ad..f78e3b1bde0e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1352,7 +1352,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd;
 
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_unmap_ghcb(svm);
@@ -1360,6 +1360,10 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (svm->guest_state_loaded)
 		return;
 
+	/* sev_es_unmap_ghcb() can resched, so grab per-cpu pointer afterward. */
+	barrier();
+	sd = per_cpu(svm_data, vcpu->cpu);
+
 	/*
 	 * Save additional host state that will be restored on VMEXIT (sev-es)
 	 * or subsequent vmload of host save area.
-- 
2.25.1


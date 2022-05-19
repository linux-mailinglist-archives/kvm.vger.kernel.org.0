Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7605A52D071
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236758AbiESK2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236807AbiESK1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:55 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD489A88B3;
        Thu, 19 May 2022 03:27:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOX8n5mdEoJ8B/rJKZXyFdFypyzomVqse6yJfC0TeH1dQKKRNoveTo6JrOxzrMh/Xi4UQ0PAkbFimSfHTBUaVTVtGqUVnCQjjslufUgyqVqHccg7SksMuwCzy+cEbIt81a6vNaYbyLLc0gzOyLImKclBUApOxv3BZI0oJCWosTRMnTzYLKsqZOD7adpmkqWGbth8C/FwNjv0uG4nKHtYQA85/diyD8gG4Z5+fKbN8HtsoUz0yaGIs0ZbwvxKN2YvKiBg66eFsGgexFcT3f6MVKZCsgHeMXqfTMjN0XvB53SxfcJ2HRRrP99ZFCZ9WS7yE7MFbtPGIb8+azMY9M0WaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/bvutB7S+dp6/W0J0zqVf2Gzw00JZ9rk2oPU8jUQCs=;
 b=EENsA6MifkuYZvjBYcqDkCJ/1V52kuoQwGrtotoGT2z6zuiIttgWrmBWIczNxlgIHZz0Ma4RKkHfGEIP778xKcxa9rBzXSeYeIxocH6xALEpWcXKqw5j92OoaWtIFN+2uyWP3KbLw4GjscbiOHuj7wFbT+D+MZE4JlDXHKFYAHH28/CgjEx4AkSF314XCwdT8XdWCnaAbeQwHXDVuE7nVDbA3u5sfaQb5JJxNsNXTDpBradKgX0P9nvCHRNKmG+Wi9IPhkTktmecnj0uVNVCCzrhX8XM5oY1Rlj1gsFBwFXLqXjQym//Ba5LuLxX+27qHChHM176ZiZungjsg7AWWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/bvutB7S+dp6/W0J0zqVf2Gzw00JZ9rk2oPU8jUQCs=;
 b=XYISegQ9noTbQVFBrIm45kt1vXBfKJowu3CSeC23aHqCKQhm51RaeZWlrssME3KilJTzR20Y3qRZIh+irnYXVm7ZEQmsKBXNzsQ5RXPDBJf95LsbPTNHg1SKvsDbtGTlptEUFfgZJ/WHLsVg0ZpTn0NyUxDweN1oCw23ZKPFMNw=
Received: from DM5PR11CA0003.namprd11.prod.outlook.com (2603:10b6:3:115::13)
 by BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Thu, 19 May
 2022 10:27:38 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::be) by DM5PR11CA0003.outlook.office365.com
 (2603:10b6:3:115::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27 via Frontend
 Transport; Thu, 19 May 2022 10:27:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:38 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:37 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 16/17] KVM: SVM: Add AVIC doorbell tracepoint
Date:   Thu, 19 May 2022 05:27:08 -0500
Message-ID: <20220519102709.24125-17-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 647492a6-2e2c-4970-1a5e-08da39823290
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5825E15C8DC7B7EF3CFF0998F3D09@BL1PR12MB5825.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iXxRvbKKdT44F20+t8s8hgjrjYU6j8wpgOuL/lYRL4E/nCREpBpKTef18ghy2v+LcC/5J2zwSMcyA0zmOoR2nfHsmKaXr3Y7Eer9Wwykc5XC7GxO+ShRN9QPie6vGMO7HgEUUypB0JCf/rfW8tSWBUpCNrZuSWIw8qMCBhRCfIobdYmbRt9twGYXTrZYD3eq/gkU/YHdkCmU3nKtLDfj4HSJ/pa/IEeO5H/0lkhx3srvwDvrL/NjKRfMSxgYT1FNQa7Y/MesN94//c9mcCqOtPIKbFD+BQ4LzTWh2yiE5z0LTq3ASut8thLJdPvBfprmtY0GBrzRJEweJeKmT1t8f0yr/GvxSViPe47/icTAg9B37ZXCNxYgRunzk/Qsqx88mCN2ENAiD27O7bUsz9o0axGatUHqozH2sLGRFKMLYK4+jav6PQPa4OBrmg0fkg4z53VJrfPKc8UJUtSlQSmJsEp013Y02T7MpfjWAyOZdzf76NGkXveSQNxVEish9PrVo5lrch38qlwrDpNZzMA9w/Im55+73/H1SJWHD1ox25hVqAcpTbiwWj2C/DR7QFSH5ltruwfLBjYmJSHDlp8DNZIweB9MTZ77TEi/WcNvHHzdPK8O5X2EiQRVGape0Ekyv28JeE0QUYYW4dWfS8UytSbHhxi62jHnBpRJFHEMzD4OTf+atDozn7x9c/tK+dun2RRCLN6HkJ5JX00CsKcBQg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(81166007)(356005)(508600001)(5660300002)(70586007)(40460700003)(110136005)(8936002)(82310400005)(44832011)(1076003)(186003)(16526019)(26005)(54906003)(36756003)(336012)(2616005)(4326008)(8676002)(316002)(83380400001)(2906002)(6666004)(47076005)(426003)(36860700001)(7696005)(70206006)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:38.2089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 647492a6-2e2c-4970-1a5e-08da39823290
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5825
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a tracepoint to track number of doorbells being sent
to signal a running vCPU to process IRQ after being injected.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c |  4 +++-
 arch/x86/kvm/trace.h    | 18 ++++++++++++++++++
 arch/x86/kvm/x86.c      |  1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 9c439a32c343..2a9eb419bdb9 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -324,8 +324,10 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
 	 */
 	int cpu = READ_ONCE(vcpu->cpu);
 
-	if (cpu != get_cpu())
+	if (cpu != get_cpu()) {
 		wrmsrl(MSR_AMD64_SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
+		trace_kvm_avic_doorbell(vcpu->vcpu_id, kvm_cpu_get_apicid(cpu));
+	}
 	put_cpu();
 }
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index de4762517569..a47bb0fdea70 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1479,6 +1479,24 @@ TRACE_EVENT(kvm_avic_kick_vcpu_slowpath,
 		  __entry->icrh, __entry->icrl, __entry->index)
 );
 
+TRACE_EVENT(kvm_avic_doorbell,
+	    TP_PROTO(u32 vcpuid, u32 apicid),
+	    TP_ARGS(vcpuid, apicid),
+
+	TP_STRUCT__entry(
+		__field(u32, vcpuid)
+		__field(u32, apicid)
+	),
+
+	TP_fast_assign(
+		__entry->vcpuid = vcpuid;
+		__entry->apicid = apicid;
+	),
+
+	TP_printk("vcpuid=%u, apicid=%u",
+		  __entry->vcpuid, __entry->apicid)
+);
+
 TRACE_EVENT(kvm_hv_timer_state,
 		TP_PROTO(unsigned int vcpu_id, unsigned int hv_timer_in_use),
 		TP_ARGS(vcpu_id, hv_timer_in_use),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0febaca80feb..d013f6fc2e33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13095,6 +13095,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_kick_vcpu_slowpath);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_doorbell);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_accept_irq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.25.1


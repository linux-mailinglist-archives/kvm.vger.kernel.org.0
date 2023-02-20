Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0E169D37A
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbjBTS4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbjBTS4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:56:34 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2044.outbound.protection.outlook.com [40.107.100.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86DF22019;
        Mon, 20 Feb 2023 10:56:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vqw3cl05T87AbQHDyU17PUrnQ8gByS7Msj8yjTjLfmlnEwfwzYPpdk+hYyyfPANzCkitMYlL84Jwi98E651vJj8hYfubhhjvCpkwuFgz2nIf0O7bd4ucrh8uUvkZRspzZJsqusFRoT5HIKVmXK9FTMckcedU9SIrXS037NnB0/2SUlGyDQIXX+T0wPZuGrO6YsrEYNy+ujq70auXAvq9TDuQ76bZT1g1Sk0z3UsLOHMRynUFlugz2lkEpbZpGXmZmk8JLxhwBSX5JTI0zCn4aaj8MS/kYM3sSQJwN7Mn7RXSNSbQaQsjtLI36HlgyEtndY49Z0k1CICSGQ0I4OX47w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMuiftp5hLD4XlVZp8/8ZxOwpPrSyoxlNaZIJkx8b7M=;
 b=kTdcdVIHFG9oZhLcMVhkG39KVVpywKm655eGbJ+BqsNWtNwst0kz+xDf8wSfm4EyFLnNbYsOMNon+C/RWJ30QBHDdBO0XSTpne8Xb4SmAOnHn2jcFc2jWBTggd0rxG3TRUE3QQFgp0HaQ+2x8iRZcT07Xp4L6oxOGSvIFFGb1kpXBtsMoIiVx6DzQLaaUV/ELw94+VFXrX8EFEb9ER8VA32OmF9vTl6TGTiN62wr2PcbkqZcWbGdmcWvLtgnZ2+y5xO8nmBy7/g+vxsuNHIu4j8aXfJbdrYJKYKzLODwmc0eWWS6hG3CECdWyBYEVOfPct3R2dX9N4gTIZLe8a5J2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMuiftp5hLD4XlVZp8/8ZxOwpPrSyoxlNaZIJkx8b7M=;
 b=hRjW2oR+acSQFeXz3mjy4950jU8Y0MeCTw47n5OMKVOtYV+FNfEB/c7QwYdTwDB5t7faQf8yyAWX6W2ZGG1fExkWyU+FISJQTPo1M4M+TcoT5pg9rbT6PrRDFpiZJQYHoszxzL1QqyMeK50VjugNJcEBxRf53u86u8baIUppeJw=
Received: from DS7PR03CA0107.namprd03.prod.outlook.com (2603:10b6:5:3b7::22)
 by DM8PR12MB5448.namprd12.prod.outlook.com (2603:10b6:8:27::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:55:05 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::54) by DS7PR03CA0107.outlook.office365.com
 (2603:10b6:5:3b7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:55:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 18:55:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:55:04 -0600
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
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 40/56] KVM: SVM: Add KVM_EXIT_VMGEXIT
Date:   Mon, 20 Feb 2023 12:38:31 -0600
Message-ID: <20230220183847.59159-41-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT011:EE_|DM8PR12MB5448:EE_
X-MS-Office365-Filtering-Correlation-Id: 05a551da-a106-4f5f-910a-08db1373faea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VxR3T1TC5MHjMIrUsQ5/xuem8nkUHTZce9t568ha7mvcTv+iX+FmWSheWdcg6fDbcCYxQ5kVHvse5fMsCfryrgyYT28XZmLEgNIhxjFcei2NSke36zqeheCN5j6q5FAFDJUls5UuCeRtxTNfy2f1dFdA5ZoMEYTDVvSruVDWJQ8bdMKUQfRGCZPXEORIkHQF+KEmMhfu+9S5PxmsFHzGt2++T5N0SJw9uvp/+G34e7OUfijvBep/BSYmBDKQE8enJR1JxtF+yhBueEcv6LQgaMMy64mrXiK7Jgpnf8z0Vsv4u5DYV6Yh5KKKta1iAXRLlDxX7bjp4cAb7Gz560BZjzEb87iWEVw6UtJespzCrGy/rReL9sgCLBrU/P+j0mMiceQ7oug6+GhRrengZxx5IqUZe5abBbnc929AItSrTge7VkNKlSCLcZcqaxKmseXhSo0BGgt5acdN4eYb2u02vrbEbVsIdy1CVtwTsn+E4Q4vw2nYE/aagRNG7b/GQk6A5+uUbQea3zpc06mMUNc5BMSniBOcSY9iXdxpuVpSGXpLTZOImdNM7v29zjQ8Jr3F/l1H6eKyEZAQqoAfAFiuz1Dmy995KyGEnMj90L2XtbNonGuOTaGVONSgHXUSaHAxtOdPaLHzfpOOOdHWb/86DG2iVShLfXz+8Lw9c4DUnETaaVlY5eOn4oq4Y5s6tGkYvQ+rhCyMv/Ux6A5/kyTc6ICa5myBPPz2KTJB7kufoPA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199018)(46966006)(36840700001)(40470700004)(7406005)(4744005)(2906002)(44832011)(7416002)(8936002)(36860700001)(5660300002)(47076005)(83380400001)(426003)(36756003)(6666004)(16526019)(1076003)(2616005)(70206006)(186003)(26005)(81166007)(356005)(86362001)(40480700001)(40460700003)(4326008)(82740400003)(6916009)(70586007)(8676002)(41300700001)(316002)(478600001)(336012)(54906003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:55:05.4119
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a551da-a106-4f5f-910a-08db1373faea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5448
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For private memslots, GHCB page state change requests will be forwarded
to userspace for processing. Define a new KVM_EXIT_VMGEXIT for exits of
this type.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/uapi/linux/kvm.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2bab08a5b5d7..6e684bf5f723 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -279,6 +279,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_MEMORY_FAULT     38
+#define KVM_EXIT_VMGEXIT          50
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -527,6 +528,11 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory;
+		/* KVM_EXIT_VMGEXIT */
+		struct {
+			__u64 ghcb_msr; /* GHCB MSR contents */
+			__u8 error; /* user -> kernel */
+		} vmgexit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1


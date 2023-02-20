Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89F769D372
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbjBTS4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbjBTSz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:55:59 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECD21043A;
        Mon, 20 Feb 2023 10:55:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ghx3ehWB0js2VmZn44l8QVK0yA9+j02fLt8jafMYm639tJyLQe7aWQkbFkU3XMbB8V34lP1uyatkS55MRhrhaQvrdr//dsTO8jTUjiKjBHbe4dVJjoF7ApILe7BZEs8+BG4T0SJyimuaw/8tVbN/rzRqhrAiJBrN4h7l0BLT+pH8cBKCQC1jkmhR21po7u/q5pr9Z4io9HtO9M4Qsj+8cy8tyEcjuBTz2CYV9E0UG39sDpqntkF+Ryb7RPIu9+wGBksKBeuVNhCUlCmmWHGz7QhrZm0MqTqPe0f2HI05n5liaR9bu30AsQTTLkUmmglzlhas9YAMldI5GvvJlgtMbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lm86L9ncTBUZoZWM3MdpTq8/bCwf/O3ttdk7LmSABfU=;
 b=C8frD0rVUfRPlVOo96bVIMrLQb7XZ4c7D44LbWFeWQ9aOFL6YsXGJspz0C6apMrlsN6ToJBOWHEOPJd2gaqbF2Em1LGIulYbxIcFgz9fkHm5iQaSHMwJnr5P7if5UreMYCY81XAO6/jGjnXSwStWcI4DtEt7G73A58JkDGg9UrdxHkjiskzDdlhsJucZ6vI+knzi+rLJ3hyvZFn1srf4LzIJYXSm/41B0m8p3oSAGUZaLPVJuNVVdrX/3l4CJ8qjaHnXn8L/m6hNV8Owm+rTOph3g75dpXahN+4Z8uXHEEWLlfeWEsAaHZ6dXYknbCVZpX9xRk1oVJnnjT4zVoPmGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lm86L9ncTBUZoZWM3MdpTq8/bCwf/O3ttdk7LmSABfU=;
 b=HUL/97eOJp6I02r5BGkZCQjDAeZilxQ1rv4WAdKboU8ixWcYMnOPmJsXzC8xchSt05UDJHIEa3DbjJFWdhMrmdrW1QmPZ5E7XbgHcmhbx42l1Id/hwPLgPZL36aTggFtZZxpcZ2XpTVKP/qIIjEKPvTp2VQ4wUETHM1ZOPcGpeM=
Received: from DM6PR02CA0085.namprd02.prod.outlook.com (2603:10b6:5:1f4::26)
 by SA1PR12MB8697.namprd12.prod.outlook.com (2603:10b6:806:385::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:54:23 +0000
Received: from DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::36) by DM6PR02CA0085.outlook.office365.com
 (2603:10b6:5:1f4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:54:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT077.mail.protection.outlook.com (10.13.173.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.21 via Frontend Transport; Mon, 20 Feb 2023 18:54:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:54:22 -0600
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 38/56] KVM: x86: Define RMP page fault error bits for #NPF
Date:   Mon, 20 Feb 2023 12:38:29 -0600
Message-ID: <20230220183847.59159-39-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT077:EE_|SA1PR12MB8697:EE_
X-MS-Office365-Filtering-Correlation-Id: f66167d1-0096-492f-6c1b-08db1373e1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kM6mydxn8sLFOK4VAscqKWOkdc6mbPhyJKPAuwm+LYGkfwKB9AdYQlnC8ZbXCuc0GkK7RmTUvIJc66QZ6rGj728hO+sKauU0PTd2ruGIBtzhPubxkJ+5iWlhIImvBpw98uIMhrlXrgA7q82QoY/j8C6u7GWeMdR79ABRRwaTlyRezQIfaoZY37LT9l/7At1YFckcNAIFxidCtjLpCzmthbfnEavKDfuJkYfdaZtF99dsOm3HtlMBiOyorx0/GgEYDCGBisJG2gt+Uc/pKO/iZQvJ5HF87Ax1K1k14aLUfHgptSgXVftJ+1NDXDvBusoIBi+oBGb4LWijg/BYFbt9ork2XTo48lklcJgVBxXXym3cjRKfgny7WsUS83bcKzApyFw5VldupU12sc5Ty75d/IH2nuN70w0Us5hV91AfR50QFF0Vf6Umb506RTV8QGXqdCmWUBL/aIIYxIvBHgSwmD7f0rCVSp407vqz+TRGqEOR3Mukn7Ou61Kb6eM6kQhSUg4dr9vDtCTpGRIv2uE2V91vL2FEM7zXynW6Q1lovCuR87vcv9zCb8Psat42BhMl5ypBb1q86YwLVTx2sS/WC9C/gwMqlZGIRBS09dY47LmDTPeircLTKlNqMcA9nFkCExE3FLJonFdDzEfq40XZbOj3nKd5Lwzg1VFtZioKS7RfAy7AjoTMlvpPZL/I99WMqPiJikRhIFXGJJtoArUc8cDmvvrzdJLp8aX9i3X+4Zo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199018)(46966006)(40470700004)(36840700001)(356005)(36860700001)(82740400003)(81166007)(8676002)(36756003)(86362001)(7416002)(5660300002)(7406005)(44832011)(70586007)(4326008)(2906002)(70206006)(8936002)(6916009)(40480700001)(1076003)(82310400005)(40460700003)(186003)(2616005)(26005)(83380400001)(16526019)(47076005)(426003)(336012)(54906003)(316002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:54:23.1876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f66167d1-0096-492f-6c1b-08db1373e1c4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8697
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled globally, the hardware places restrictions on all
memory accesses based on the RMP entry, whether the hypervisor or a VM,
performs the accesses. When hardware encounters an RMP access violation
during a guest access, it will cause a #VMEXIT(NPF).

See APM2 section 16.36.10 for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 456b42cb167b..d2e1c109dde5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -253,9 +253,13 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_GUEST_RMP_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_IMPLICIT_ACCESS_BIT 48
+#define PFERR_GUEST_ENC_BIT 34
+#define PFERR_GUEST_SIZEM_BIT 35
+#define PFERR_GUEST_VMPL_BIT 36
 
 #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
 #define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
@@ -267,6 +271,10 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
+#define PFERR_GUEST_RMP_MASK	BIT_ULL(PFERR_GUEST_RMP_BIT)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
+#define PFERR_GUEST_SIZEM_MASK	BIT_ULL(PFERR_GUEST_SIZEM_BIT)
+#define PFERR_GUEST_VMPL_MASK	BIT_ULL(PFERR_GUEST_VMPL_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.25.1


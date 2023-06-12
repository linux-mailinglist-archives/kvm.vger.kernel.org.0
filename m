Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A63A72B6BE
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbjFLEqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbjFLEoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:44:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518B910C0;
        Sun, 11 Jun 2023 21:44:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoQiZSZJ3evbsB4MiGembIQ7pv8R7U/436c8hr7YAvDO789SmV8AUynOdBah55yBydVju8QIg9Nwibi+WVNrDELrx1dvrWSM+4V5gZcY0A3qhvhpdEATK2A+lzcsyJf2N9Y1o509P+mu5RQ08ybW/vC/3YwM0andkNXQrVwGIt66HMsaRczXs7WzJpYmADjB683HNuS2KQRpIR1BgtmNUdglrGrKZjQXMQeqPUmiOP8s/idnP2dzl12H+4CFJg+gUAJ8sIrh8jPh+yjapmrdwMO5qhjC77JeIJdJ6bKJaSR7oO8YrJkAtfCmaFw/dnza7/lhUynvA9k9KOJs8O6KfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWai5t1V65lb7xUaoMrw0zZrJ8os1/1Uqdh6BDEyZfA=;
 b=bnENNvoCuZ/PBvT8LNOfdIxi8coiDRoNatr7wmXXr07a/NJDqYQXFwNLIBQhMxozTDum44CzfIAtmM2BqAzJPX3hQW/MI/1OzIiW/FY/waAobABIWJxFkZycS15XEk8GMRy+IG3IS4W1xeSUIXJ/D5KejN9F+Wg/vOga49fDzVuFMUZmyedwsSTxGT7p84v2MY3btwnliIrBWcI42lZCOt29lgMCGVUtyO+GyCOjamSIAmVGiOGall7JTanYNt+cloTURfQp8Bdk14GLJYxly5n8ErNBCGNdlrVd5iOaCUAGDqkgfNGvB0GwvawewYW90S6m76Wu5rHzCTP3Nftm9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWai5t1V65lb7xUaoMrw0zZrJ8os1/1Uqdh6BDEyZfA=;
 b=K8tMeCgFyBOgP4/qhbuVKWfPNXd0OfLuZJUOqYzqac/HGZqjVamSEMmgdE/XpDdCN4GpEYBwRGm80YX4KmUEe1/TdU+TJVoj4kcfnWZtAek6gThR1IGx8t8+EChwCWoM8WxZL3doVHfEfaRIwC43xyQ+mlPcsrxGMUfpjXmPUnI=
Received: from DS7PR03CA0238.namprd03.prod.outlook.com (2603:10b6:5:3ba::33)
 by CY8PR12MB7241.namprd12.prod.outlook.com (2603:10b6:930:5a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 04:44:18 +0000
Received: from DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::39) by DS7PR03CA0238.outlook.office365.com
 (2603:10b6:5:3ba::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:44:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT092.mail.protection.outlook.com (10.13.173.44) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.34 via Frontend Transport; Mon, 12 Jun 2023 04:44:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:43:56 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 35/51] KVM: SVM: Add KVM_EXIT_VMGEXIT
Date:   Sun, 11 Jun 2023 23:25:43 -0500
Message-ID: <20230612042559.375660-36-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT092:EE_|CY8PR12MB7241:EE_
X-MS-Office365-Filtering-Correlation-Id: eb2150d7-2116-484d-f9f4-08db6affae20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b98vSCAvPfVoSDdb4x4k8fKxjgS4WnROpmXnLYSppgfc1XsG7iGt3BP5JsWgnMa3HwjjHhgPfpCvRrTBZOo2tpu7bjFx5xAgFans2DQCuDz4ZCW74W3DZjBp8JcGKaeYhGix0SEs7ugNXjF8rylL+I4aag6pP/rLOtm5cpQ0SfW476D5mZ52GyX+gbcoKJ6pIOFW+qVClK84wJgTHUhziVA3NjqgnkeQRbTuc36TxQK84nuVAfyF4SxpPL56+9XR9sglYudQQA3vOtePlIjYMRatAIV/IkZG+LsSuNgI6P9O18/GwxUnnrokhyQNUMUSrnKbd3T/uYzlTBag9ZhMeww9OpryX9kPDNjb85a2gg4Xnb3glNsTHHtZV8N1WVT0L6mM2BScqnSx2ozaQfMdnRmJW715IVCA3qYII7cXGNi4aSZeJgEKeA9ZTFWwZyXCo9FnSAic4ZHDPdWf1tcRqFmrfJIjq981xnA2GrCyZf8YuheCSsRvTZUetkz6s0yTJ6IX7m3BXxm6ERNyrvwGUMge+rXcCOWSnUIZJQ6Z0SIk3GSTNr4zbPojguEH7/vueyA9CZ5PfH3P6Tqcx7VfhNjNZUQT1/ZJ7hi4ZKBVx04LjhRGRLf8+WgXlIH4mbLu9y7jrD3OtFyFrBZsgPTjeRRnI4IrmsHwRoKl0wnxW4PYhp+DQXqNOB+GzFWsjdwIeaP9yU+rPIvHIaGSMOjqVLRWHV0WDtRBAGm3/25CUnOI6kKcux+5Wxfq/qcuyaW3LikerNZxWFd7pXAofze/yw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199021)(36840700001)(46966006)(40470700004)(426003)(336012)(2616005)(47076005)(83380400001)(36860700001)(356005)(82740400003)(40480700001)(36756003)(86362001)(82310400005)(81166007)(40460700003)(478600001)(54906003)(44832011)(6666004)(8936002)(8676002)(2906002)(5660300002)(7416002)(7406005)(70206006)(70586007)(4326008)(6916009)(41300700001)(316002)(186003)(16526019)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:44:02.6940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb2150d7-2116-484d-f9f4-08db6affae20
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7241
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For private memslots, GHCB page state change requests will be forwarded
to userspace for processing. Define a new KVM_EXIT_VMGEXIT for exits of
this type, as well as other potential userspace handling for VMGEXITs in
the future.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst | 34 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  6 ++++++
 2 files changed, 40 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index df37aa11512d..028fd3fa50a7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6780,6 +6780,40 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+		/* KVM_EXIT_VMGEXIT */
+		struct {
+			__u64 ghcb_msr; /* GHCB MSR contents */
+			__u64 ret;      /* user -> kernel return value */
+		} memory;
+
+If exit reason is KVM_EXIT_VMGEXIT then it indicates that an SEV-SNP guest has
+issued a VMGEXIT instruction (as documented by the AMD Architecture
+Programmer's Manual (APM)) to the hypervisor that needs to be serviced by
+userspace. This is generally handled via the Guest-Hypervisor Communication
+Block (GHCB) specification. The value of 'ghcb_msr' will be the contents of
+the GHCB MSR register at the time of the VMGEXIT, which can either be the GPA
+of the GHCB page for page-based GHCB requests, or an encoding of an MSR-based
+GHCB request. The mechanism to distinguish between these two and determine the
+type of request is the same as what is documented in the GHCB specification.
+
+Not all VMGEXITs or GHCB requests will be forwarded to userspace. Currently
+this will only be the case for "SNP Page State Change" requests (PSCs), and
+only for the subset of these which involve actual shared <-> private
+transition. Userspace is expected to process these requests in accordance
+with the GHCB specification and issue KVM_SET_MEMORY_ATTRIBUTE ioctls to
+perform the shared/private transitions.
+
+GHCB page-based PSC requests require returning a 64-bit return value to the
+guest via the SW_EXITINFO2 field of the vCPU's VMCB structure, as documented
+in the GHCB. Userspace must set 'ret' to what the GHCB specification documents
+the SW_EXITINFO2 VMCB field should be set to after processing a PSC request.
+
+For MSR-based PSC requests, userspace must set the value of 'ghcb_msr' to be
+the same as what the GHCB specification documents the actual GHCB MSR register
+should be set to after processing a PSC request.
+
 
 6. Capabilities that can be enabled on vCPUs
 ============================================
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1fb6a6615d09..175b958f103f 100644
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
+			__u64 ret; /* user -> kernel */
+		} vmgexit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1


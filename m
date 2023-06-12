Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3827B72B6EA
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbjFLEvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbjFLEvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:51:19 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F249D1985;
        Sun, 11 Jun 2023 21:51:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gABl3st8+RPuXnOTJ5AIdQuX+inGNFxwqxAYTsWwSisK+Qpo2wMopsUbYyl1UvUUElKefA5rw1mTbLFWhprrfFuH/lFV4qkbG0d/0CsEpIPb6AviqCiZQqeTBwmsbcqOYw8VKwgUGZ6pxZAom3OS77+DA/nE4J31eg1rwhisJ6gFGYkt/111Cx9Q7knlCXzt4yY3LWJ6cSL1fZKgxBIhwLu+LoYtz9r/5AzsT7gDXrz6U+gNmc7fvxAa9mjtJkuUofqJHx2foA4mBnbeklI6zqLx6q4dAtTWZDQi5rHG2v2Z3hQWvG16QNBzOajAiAWt2juaBG2h/Mf3RyVc11Cdsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwFcoomX4hZVadAOtXXAh+HWWkMbGG/uK/b829NNo8E=;
 b=g1mDykJccu9gR+8B7TqgE9ubiSFrNCPn2fBYOGaWZxRqHCRFWQSPsGZ5E/4dn7x/fPq1cVeqG+kNnaxmw3+DwHqNT20J9tJUV0BJgHpQV24klsDhNYowhXhBoNoU+hlpTZpsfAVjxjOqdwR6bsbetMB6fIwWhBBeS4ZsR9sb5wt+GTyyeSn5sYZrEPllVjmOZVqpxU8pi1BG0FXreq8GzUZDm8vNQtLdLlulBe6isiL3B2Y4e2ghGQTOqJ+6vz2Pv8SagytJJQaQIENd1masa8THDgCqvM+u4+Uwglr7g3ClOlYF7AIRmzRpY6B9kAwKVNz6poEzVJEVtafD43c6ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwFcoomX4hZVadAOtXXAh+HWWkMbGG/uK/b829NNo8E=;
 b=3GEJ5IexLSvILwWbJ7mTwJpWT9Ef30Bum61UHRfIk7xkhMGR2sweQTWTtqSK5tGGDx4PdD0Oj//3z/gxHYJ50EpkshYiT215VFvDDpis1GhysvvcwqJQ+kWdxMKRi8TOyGrVPZLSkMD43iqS3ajQIwbTsIrM04icHstBY4nNJyg=
Received: from SA1P222CA0078.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::25)
 by IA1PR12MB6604.namprd12.prod.outlook.com (2603:10b6:208:3a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 04:51:09 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:806:2c1:cafe::4f) by SA1P222CA0078.outlook.office365.com
 (2603:10b6:806:2c1::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:51:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.24 via Frontend Transport; Mon, 12 Jun 2023 04:51:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:51:04 -0500
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
Subject: [PATCH RFC v9 41/51] KVM: SVM: Use a VMSA physical address variable for populating VMCB
Date:   Sun, 11 Jun 2023 23:25:49 -0500
Message-ID: <20230612042559.375660-42-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|IA1PR12MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e9a3f11-ad05-4d53-ba08-08db6b00a378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2S3+ttjoDMZZfxFdU6K9nG5tsU3Pw56v06hAPztdBntfzCtMRLhG4bcnqUZv+hDcoU3FB2h8pclhW+3E2OaYTbBNeApqgeBgoyZ0AuFYzW5CyCINGE7Yf1uOuDaTJRAvJTvOK0ydIweVkOMMMO297gHBXbrk27sj/Fmw8oO27QIUuVj8baKVfMis9I4v5xcs5DzW4msIMK/m5U/9cXtbfCyQipj0FnsxmdFSzv1AzYm9JPGqxIwUk2/nrLHWLVRcAR2OMwjlvgp6juYvHfiLgRwkMuPLudbHpPIj24gOs134WJ7j/CZHszwFQMUQSA7IMwZRbtgDpGB8ty7AeXsR2xnY4c1+Skg4cwdHJHl6JXFJLDCnQYmaQzwcV4UnfGsN1VX+6PbZchd6a/5clj4sKrKzWr4Z5J34BGJ8Ouhsscn9SnVFpoWC8aIJO9Hbp/IzhTACFcY0hU4wTcT2MoUh5IOyG2+Q+voPrnZ94ihSeiz0TQfAfu9G7i8Onq3+qk/siHiWg/l6GZ4dmDwiOyJBeIytV7bR6n2zBPXA9M6LiqfDrj+0bZO+Bd7+WVuq3JvwYrXyRkS9aXBNjWXqDx+TnSrSFfO1xVC2OfEaxAzqm52Gger7FD3RMPpfV/qHFNKObp4+UwioyA3GjvXfgAOd3P/bfOx1BWafi5TF1XFkqfHKZ2hYl1f4JS4yCJxLoU/S0/BRWjnBp2o75w2vVYk7yRpTifQKstKqClrBP16HWPmgDSGKZn+Om7CceXf+0opNGl/Qw8C0YR5aHuRoPWPJ7Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(36840700001)(40470700004)(46966006)(86362001)(40480700001)(36756003)(82310400005)(81166007)(356005)(82740400003)(40460700003)(478600001)(6666004)(54906003)(8676002)(8936002)(44832011)(5660300002)(7416002)(7406005)(6916009)(4326008)(70586007)(316002)(70206006)(2906002)(41300700001)(36860700001)(16526019)(426003)(2616005)(336012)(1076003)(186003)(83380400001)(26005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:51:08.9202
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9a3f11-ad05-4d53-ba08-08db6b00a378
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6604
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation to support SEV-SNP AP Creation, use a variable that holds
the VMSA physical address rather than converting the virtual address.
This will allow SEV-SNP AP Creation to set the new physical address that
will be used should the vCPU reset path be taken.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 5 ++---
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1ba49c5ebaed..111e43eede15 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3551,10 +3551,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 
 	/*
 	 * An SEV-ES guest requires a VMSA area that is a separate from the
-	 * VMCB page. Do not include the encryption mask on the VMSA physical
-	 * address since hardware will access it using the guest key.
+	 * VMCB page.
 	 */
-	svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
+	svm->vmcb->control.vmsa_pa = svm->sev_es.vmsa_pa;
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0cff050bf5bb..77195d8c1aa3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1419,9 +1419,16 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (vmsa_page)
+	if (vmsa_page) {
 		svm->sev_es.vmsa = page_address(vmsa_page);
 
+		/*
+		 * Do not include the encryption mask on the VMSA physical
+		 * address since hardware will access it using the guest key.
+		 */
+		svm->sev_es.vmsa_pa = __pa(svm->sev_es.vmsa);
+	}
+
 	svm->guest_state_loaded = false;
 
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4cf9dbc442e9..8dc7946ab634 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -197,6 +197,7 @@ struct vcpu_sev_es_state {
 	struct sev_es_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
+	hpa_t vmsa_pa;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
 
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789A064D0D5
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiLNUMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiLNUL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:11:56 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF332E6B4;
        Wed, 14 Dec 2022 12:03:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVpk/LqB3g85UGBxU/mRebJTj6ICc35mS+OiGYM0ffm/GztYZac9ykKMeKg41rQbJFQ9RF9J6vrGAOXuRCEezjabtyihSGBCU+3+9gfI8g4XyACC1136nSn01hL3RkbfGKHgo5MPMTqiZHEWIytiCtwDmRR+tp+tQ23EBKVDPIl7X+Xe7koAqbw/qwSCTkeGrT0B09ok93oNb9P5BvwHL7vaKzTnd/3k+qzBd+6l6Htw6QpiLgVbhr8SCaTBCguvBxR7MGzONiNdyaUZt5ymSVrrveLdCaN0XEq4q1nFRmPBwdMrnawGz/drPVn4qPBeQwSi2o9OQnhGtDKNZXFnuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SO5f6YuudHhXpf/qz3ENT7uZjSyAEhvUiU7bzgVCfHg=;
 b=SINVei6ujc7W9/n97LiBZujDblPUku3ctbqgr3u90CzFLBZPGTx0jZepidKnv3mNRUgP7Y01xaNSxcf/kI8yKmV29vjyzgu1kbsXFkJN9fT3mTvnXNDFkozYA8bkXSXWx4AQqaCjglsqFbtO/8a51ALzk+kdjojjGpMJNwe8OIaG2dQDQd3FYDE3we0BQ/8se3LI8WetijeRxpGUzIt8M2R/lDZVdE0ND/mslI5aSzI+IZV/0bOQSI321e09IGlmTo7tvvHhOoDYM5bURZ4W43jgT0Kyx4ncVPT/+USqWO5GT8Ymt3e+xJ3APtYsDBFkj9KcjT9HID+f9Xbeg2sWbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SO5f6YuudHhXpf/qz3ENT7uZjSyAEhvUiU7bzgVCfHg=;
 b=MXr0u5Fy+g+RC9iDkjoFbGzkAu0L00R2qIj90lUMXUvAd3wc353WIfBNyOqZELyh5OjgsXe4GiBtt2MKT8mHVKXNnp6Y4Z9NY8XuQ+VBQY2hfp007LZO6n05+P21WFi68/3OyVKfybYFl1ZAwq7UI3Oo3kdi/G5zJNKbnJtgjjw=
Received: from MW4PR04CA0114.namprd04.prod.outlook.com (2603:10b6:303:83::29)
 by MN0PR12MB6029.namprd12.prod.outlook.com (2603:10b6:208:3cf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:03:54 +0000
Received: from CO1NAM11FT081.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::95) by MW4PR04CA0114.outlook.office365.com
 (2603:10b6:303:83::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:03:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT081.mail.protection.outlook.com (10.13.174.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:03:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:03:52 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 53/64] KVM: SVM: Use a VMSA physical address variable for populating VMCB
Date:   Wed, 14 Dec 2022 13:40:45 -0600
Message-ID: <20221214194056.161492-54-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT081:EE_|MN0PR12MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: d73c9c9a-2fbf-49bc-e434-08dade0e537a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fck6FJC740/KMecRB/nOVbRYYvX7TJ5BSHujgj9KhlPSC1qcoLQVjgfj7h5o/svo4W3RmL34h/ortWC15/9DPrEwuPnnynryqLQyhUzIziU8Z0cQQbPfvcN4CSWMBV6HSsQ5XBGjIK776OmhIOU0/H/ma2/L3jbncEhEbn3L74WIUQY1jKvWmphZgygtrsnheumnLz4KBPR3A4Xj7OhJBzdag8KmcfbegUT//zufaekN91MKZ46aPqAY55pQgXxbXvK72aE+ohm9C2VfrIUjiZ+352kh0IDm/x0ascT27MHcwGIIwCcj+pnuyfnpEmxc40+6BcNu8fAME0k/PUjkL1h0uTCKzAcdjMvH/JXyPY4cKPCvq7/WWnKZlvHBCLSeKVjuOwz5TZHjYgSEnxxRNKZt0mNR8QdL0BVc6uXih7CcjlGqSKk/yinvK7NCFOupwVeKbM0fSGrhVx1sFduTcSRe4A0lbcaNUJt1I6hJqQW6ySr/w1Uy2Ox2lCVUU2AIYAU7/6vWk8OcrpOPHR7qdg+JgP9Jim4JlqW85nMqbu+p3GaFuMKxuSeMQEAsf//YGI+vOa8z9Wow5hlHj7tQD6ZItWJv/tQCIQ+t/i0k8qI1dZ1unYoE0P8tWfwCCjdU40i9qFSlUI+ifkUkmwqRFHUAS9CXrxqBFAgv/jXBMPqPsHZ+ISYljm207ucCoeBcZcwFZ0Y3XeNvaWbRmc7n7Bk/Im7HXghApD4H+4SzqMM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(41300700001)(36860700001)(36756003)(5660300002)(8936002)(82310400005)(86362001)(7416002)(7406005)(478600001)(54906003)(70206006)(70586007)(4326008)(8676002)(316002)(426003)(47076005)(6666004)(6916009)(26005)(356005)(81166007)(83380400001)(40480700001)(336012)(44832011)(82740400003)(1076003)(2906002)(16526019)(2616005)(186003)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:03:53.6255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d73c9c9a-2fbf-49bc-e434-08dade0e537a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT081.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6029
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 18efa70553c2..36c312143d12 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3845,10 +3845,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 
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
index 43f04fc95a0a..e9317d27a01d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1398,9 +1398,16 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
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
index 7c0f9d00950f..284902e22dce 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -204,6 +204,7 @@ struct svm_nested_state {
 struct vcpu_sev_es_state {
 	/* SEV-ES support */
 	struct sev_es_save_area *vmsa;
+	hpa_t vmsa_pa;
 	bool ghcb_in_use;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
-- 
2.25.1


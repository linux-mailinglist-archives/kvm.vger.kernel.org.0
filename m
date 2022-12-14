Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F246364D0B4
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiLNUIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiLNUHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:07:24 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2072.outbound.protection.outlook.com [40.107.96.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E838517AA0;
        Wed, 14 Dec 2022 12:00:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nc2tc8jiyeXPud6Mh8oX/izEEiaGOmmRY/4oN3NsCeTTbe5E8Fe1tmU4s68uN6wU4Tp0b+brhbBxj4qB9MgTualU20kCXVTLwVuYpcHzRjToqeZ9qQtVezYEF6ArpYjxeBQUPYgHrpqVXttZmhj/hwJyymMP17E7Ug7OYpOVq8eOjg70TyNBwu6UOpxbD314cw95oF4gkK7rzN3WSlXSd0lrTx8WtGXWDK+3K3ci5bO3tZ9B2ug7kMUz3CFShUDstFMw1I+UNQNB/h8PZQuyzcqiX7J6gh2iH9zwRfhRSVg6j72q3BXWaYh7C1QNimbVxvVbalEem7Bxo7Md8LhJKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87+dXM0XJY3uTF69sg7L6q8yRudG+raaIDTkuVaDBt4=;
 b=MCJcm7NO3WgsIQSshtYSAXbsjFS3YkQOQUqtfEJ2DN7qwi+RI4f6Uqe4gTotPmeRUcLnrHYzLw2qYAMHJ5Gx2WRjCOgCWAWYsMhZ/fhhiZU5vUTKFJCSiKhPB+kNWJJXysIrQ966yOurr7bBwDge7DuRLmsBOWvU8rZt9vFTzo0HCv6ReOxAVrUdAm5hsX0/lmJTFZv9vvn0V5/1qOB3Zg0Ufvr0wfNriUC8hrnkbdn9XEqjHfkDBuCldXsth+++xXr+KUL6k/pOOzLXti250z5mIiDVpe27pun9NZv1ZAO7W1yFTTQKdv59/0px7jlbqiqxo14+DdvRaCUPrScp/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87+dXM0XJY3uTF69sg7L6q8yRudG+raaIDTkuVaDBt4=;
 b=nm2ZYbZKneyIj3uL8wt1xkoWQ5m0iNXOFLRKN7QPu2JfRsr96y0vfucHs7WoMudmphDbFi6Oo4047C8Tu5DEamOczWNq1rDj12WzVFW74+lpZTK9fbWyyW5NKCX2nnyVqHyjNOOO+dU8LYS1QW9zzahlGx+k1pw9MIi+EyAR+i4=
Received: from CY5PR22CA0066.namprd22.prod.outlook.com (2603:10b6:930:80::13)
 by LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:00:45 +0000
Received: from CY4PEPF0000C96D.namprd02.prod.outlook.com
 (2603:10b6:930:80:cafe::21) by CY5PR22CA0066.outlook.office365.com
 (2603:10b6:930:80::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:00:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96D.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.9 via Frontend Transport; Wed, 14 Dec 2022 20:00:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:00:43 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 45/64] KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
Date:   Wed, 14 Dec 2022 13:40:37 -0600
Message-ID: <20221214194056.161492-46-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96D:EE_|LV2PR12MB5797:EE_
X-MS-Office365-Filtering-Correlation-Id: 49d796b4-a364-49ae-6882-08dade0de320
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1vz/LsYYJY7rhJtSVVQROwtXNMjatmhIrasHecNs6Hjpf1OVcn3ibv24TgEIMq0Fm7PVd7yjLRHIv74p3iaz/uI48HdXsZ/34QHB/DrWLvaP5zhYY2528y3bmjubEHNF4LEGRnLPbHPkm+VpmAt46Ca85yzNh5PqpJT68An7dZhG530qqum4JBbKMOlq+XTD8YjBT6TxIBDTYKQ/SN5FhwKODOjUoDjazFn0xuAQRSAHrqESDLr0unFBMKkZgDsm0gShO66jvRUGZ0ZMfu6F3EfpcT5bFxSzWaD98MUVT5YJCop0Zm5fdUy9l1RiHAwog1Hc426UBW/ZH/a/tJipIthnn+LWigLctp0+vMW5g5ArOOfe0KBl/b8ymYraKJpiM8UNiovceT5dW49jOCGcHMYvKC9IVvryfqtxaC6StsYNOfwsoOEK85a/HLJ2cdBbnZpe8Jr+xVuMmRKqW208BHe9cmirBQHYbe+PiDCMIp7pvWwwRZo3RJQwun2JZfk9r8lK9OEO1FsrPazoLEFjr+x6n93gD9Ry0PVaSg2ll39dj5VSN6RLEzlvvaXz/z1Gi7C066RNaHjhpTnAeElEDSkOFGnt9G7ywjIYcdRRAvvT8qfcKBb336YshpWoCm5i4hlz2Xp8bWZifHgkeeY7WTzN+jIcWJ1EGpC+1UocUpRI2I5Ond1Ny5/rE+jPv+wJXOYpueeDTYBbWVEDzZI46DS2KQSX78zUYxuV+Odg3Wg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(36756003)(26005)(41300700001)(83380400001)(36860700001)(186003)(7416002)(478600001)(6666004)(54906003)(6916009)(316002)(7406005)(5660300002)(8936002)(86362001)(82310400005)(70586007)(8676002)(70206006)(4326008)(426003)(47076005)(44832011)(356005)(81166007)(336012)(40480700001)(82740400003)(1076003)(2906002)(16526019)(40460700003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:00:45.1433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d796b4-a364-49ae-6882-08dade0de320
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP guests are required to perform a GHCB GPA registration. Before
using a GHCB GPA for a vCPU the first time, a guest must register the
vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
it must respond back with the same GPA otherwise return -1.

On VMEXIT, Verify that GHCB GPA matches with the registered value. If a
mismatch is detected then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++++
 arch/x86/kvm/svm/sev.c            | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  7 +++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 539de6b93420..0a9055cdfae2 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -59,6 +59,14 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
+/* Preferred GHCB GPA Request */
+#define GHCB_MSR_PREF_GPA_REQ		0x010
+#define GHCB_MSR_GPA_VALUE_POS		12
+#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_PREF_GPA_RESP		0x011
+#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
+
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
 #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6ac0cb6e3484..d7b467b620aa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3429,6 +3429,27 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PREF_GPA_REQ: {
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
+	case GHCB_MSR_REG_GPA_REQ: {
+		u64 gfn;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
+					GHCB_MSR_GPA_VALUE_POS);
+
+		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3478,6 +3499,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret = sev_es_validate_vmgexit(svm, &exit_code);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c462dfac0a0d..a4d48c3e0f89 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -218,6 +218,8 @@ struct vcpu_sev_es_state {
 	 */
 	u64 ghcb_sw_exit_info_1;
 	u64 ghcb_sw_exit_info_2;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct vcpu_svm {
@@ -350,6 +352,11 @@ static inline bool sev_snp_guest(struct kvm *kvm)
 	return sev_es_guest(kvm) && sev->snp_active;
 }
 
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->sev_es.ghcb_registered_gpa == val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1


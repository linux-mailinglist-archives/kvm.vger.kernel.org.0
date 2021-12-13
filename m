Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33C24732FE
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 18:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241364AbhLMRek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 12:34:40 -0500
Received: from mail-dm6nam10on2087.outbound.protection.outlook.com ([40.107.93.87]:52864
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235736AbhLMRei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 12:34:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAW5wSFUf62jPmiLrMN0gUI5UYIrjHB6wD+l4bmJv+8NyTm8PniN9pNUbO8URGasn1+4NaO2GZd0iV2Ug9OJ9nRZ74F9L9tRIa+kIxGGOiULGlyyJRa36EKdkcXBx2a9RJHKlHeSepb2oy3jmB/yLsxG+WrVnYvyA7fF4cogGFc6/D++EkzKI7d+tksIGZgKNrbD3prFGAYFvoe9GiJdtB8S70iP8qNEjU8HLgghTHisGWfqQFElHAS33iwykwipXcbv/3R6FaWojz/TR9EbDmwg4K0Ck/McomavMZpHWnqibhjedMK63qzkpIyAubpr+WGT+wdnMg2si6x0bgrh3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaH7YlHQEbNRCtT2xWBnDxe2GbR3iPgmIpIDLW9LG0I=;
 b=ZTkAv3vT+Nzu0rlUmLo3CgMqFJYXNtuIfLAiZ+hjcCPQF7/RW8kgDjqUJ6RPNHYMUkNxoAiyrJ65mHs77f+g0rqK8LOjJ9fOYpcOr7l9uz9SkajqmWSPO+R08OvMjMFCJhH+P1OZqOnfmzlrODD1boq+EO6QvxVgm0n6u8ZOeizWvd9oXlSPAQAJe4OV1hRMUWW3fhEa5lPVMuFsnnz4IRPqQ01zF01M3IzRiBXS9otfdMe1QO3/IQiGQZVSMbeMMYjMLBnpjeke/dL8gsF54NjGRMWZIg+x2wMwrxqEWVfrjdGRQojyNLlZr+QOzLEev0x1t2EHVdzgnMAuj+fRIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaH7YlHQEbNRCtT2xWBnDxe2GbR3iPgmIpIDLW9LG0I=;
 b=Z0wpv3bQml0GhpqdkV9DOLeXTRumrRXCBSpEgqvDxp+ZRVj5lZaDv1HLGe1+5AIjJBRhUrzfWanblf/RASpi+YSw6/PJe6KrbJg1phrfvctXwtZUSnfUm/iShzGJFGh/aZN/u7rd3nfMyg3LhwxxE1RMqLpu3UXiXPTglQ/OFc4=
Received: from BN6PR17CA0028.namprd17.prod.outlook.com (2603:10b6:405:75::17)
 by SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 17:34:34 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::68) by BN6PR17CA0028.outlook.office365.com
 (2603:10b6:405:75::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13 via Frontend
 Transport; Mon, 13 Dec 2021 17:34:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 17:34:34 +0000
Received: from sbrijesh-desktop.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 13 Dec
 2021 11:34:26 -0600
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>,
        Borislav Petkov <bp@alien8.de>, <hpa@zytor.com>,
        <marcorr@google.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 2/4] KVM: SVM: Create a separate mapping for the SEV-ES save area
Date:   Mon, 13 Dec 2021 11:33:54 -0600
Message-ID: <20211213173356.138726-3-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213173356.138726-1-brijesh.singh@amd.com>
References: <20211213173356.138726-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2151fe4c-3541-4837-2fe5-08d9be5ed426
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5456:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5456737B4E5B6CDB4AE21FAAE5749@SJ0PR12MB5456.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3WZvcoduvxempN0wdyKobUZPk8ZAOFCRCy1xw5/G+zbIOmBlYfWC+VTNOKwdnB+iqOKs7P1Xkgh+ToC8eESoSos0cZirvyS2TPxDly50jN0aBHjOmiIyIRApaZZgU18BG+k4TnlaHrZhNpupuNpU2N7UDGR3LqIx8Qw5YFfY2C5M/MIdJia7Na5FkicI2Z0uewozjcWHuMONFtIruWwf9wu+2EAcoxfG3sWOA3TA4deEqaz0c92VxExOuRGeRhfoextwQ8SXD86MbvSFYYpLi2xEsXvxCxzNLFtv0gJJ1gSSv5sAKFWiM5JmYrxqvbQjN8lor4Lgo/d+vylZjuAC+rtP1Ewd9NLi/i8epElVvJtSglxD68YhqVMGijtv6vCaVPim/ClwUHpoQ7rHNEQmfPze9yqkwbE8qyXU3+97Y0w+ugTu1vPlPZEB+YwcaRKu2mMCYBBZILHJrTcCdj6CIBRNqIlz6bfphF8zOKGxfdNlCfVolelOIPsmG5/3czRBW9QurJe0s4wxx7lYL0SQxSwCz3gHPMF0+9jj9YGtqHrcu/jczOtos7p3SZzufOLlYWAw+lfrTbyO0f8mb+WZ+pADGJD1h+TdQg42l1brDfCO1XxpR8P4gCGVJFGym09aRrw8eK0Tq0iJrouJYCc4Jub8dhEtls1y0CCh26upzy9qiNIPwXY6BFk6JBwh2Ey1A+ZSs3OtaJ10YmO6IYw0tjzKOdkNcY0SloYIDWp+eCmnh8QqCmNxVuwMvpxQFxq2N6zDZbB/pRzVzbI/o3e8OMH3qfTv3aAp+xHKMXj8Vgc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(16526019)(2616005)(186003)(86362001)(82310400004)(54906003)(336012)(81166007)(83380400001)(6916009)(8676002)(426003)(47076005)(508600001)(8936002)(356005)(26005)(6666004)(7696005)(70206006)(70586007)(5660300002)(36860700001)(316002)(40460700001)(2906002)(36756003)(44832011)(4326008)(1076003)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 17:34:34.4667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2151fe4c-3541-4837-2fe5-08d9be5ed426
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The save area for SEV-ES/SEV-SNP guests, as used by the hardware, is
different from the save area of a non SEV-ES/SEV-SNP guest.

This is the first step in defining the multiple save areas to keep them
separate and ensuring proper operation amongst the different types of
guests. Create an SEV-ES/SEV-SNP save area and adjust usage to the new
save area definition where needed.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/svm.h | 87 +++++++++++++++++++++++++++++---------
 arch/x86/kvm/svm/sev.c     | 24 +++++------
 arch/x86/kvm/svm/svm.h     |  2 +-
 3 files changed, 80 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 7c9cf4f3c164..3ce2e575a2de 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -227,6 +227,7 @@ struct vmcb_seg {
 	u64 base;
 } __packed;
 
+/* Save area definition for legacy and SEV-MEM guests */
 struct vmcb_save_area {
 	struct vmcb_seg es;
 	struct vmcb_seg cs;
@@ -243,8 +244,58 @@ struct vmcb_save_area {
 	u8 cpl;
 	u8 reserved_2[4];
 	u64 efer;
+	u8 reserved_3[112];
+	u64 cr4;
+	u64 cr3;
+	u64 cr0;
+	u64 dr7;
+	u64 dr6;
+	u64 rflags;
+	u64 rip;
+	u8 reserved_4[88];
+	u64 rsp;
+	u64 s_cet;
+	u64 ssp;
+	u64 isst_addr;
+	u64 rax;
+	u64 star;
+	u64 lstar;
+	u64 cstar;
+	u64 sfmask;
+	u64 kernel_gs_base;
+	u64 sysenter_cs;
+	u64 sysenter_esp;
+	u64 sysenter_eip;
+	u64 cr2;
+	u8 reserved_5[32];
+	u64 g_pat;
+	u64 dbgctl;
+	u64 br_from;
+	u64 br_to;
+	u64 last_excp_from;
+	u64 last_excp_to;
+	u8 reserved_6[72];
+	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
+} __packed;
+
+/* Save area definition for SEV-ES and SEV-SNP guests */
+struct sev_es_save_area {
+	struct vmcb_seg es;
+	struct vmcb_seg cs;
+	struct vmcb_seg ss;
+	struct vmcb_seg ds;
+	struct vmcb_seg fs;
+	struct vmcb_seg gs;
+	struct vmcb_seg gdtr;
+	struct vmcb_seg ldtr;
+	struct vmcb_seg idtr;
+	struct vmcb_seg tr;
+	u8 reserved_1[43];
+	u8 cpl;
+	u8 reserved_2[4];
+	u64 efer;
 	u8 reserved_3[104];
-	u64 xss;		/* Valid for SEV-ES only */
+	u64 xss;
 	u64 cr4;
 	u64 cr3;
 	u64 cr0;
@@ -272,22 +323,14 @@ struct vmcb_save_area {
 	u64 br_to;
 	u64 last_excp_from;
 	u64 last_excp_to;
-
-	/*
-	 * The following part of the save area is valid only for
-	 * SEV-ES guests when referenced through the GHCB or for
-	 * saving to the host save area.
-	 */
-	u8 reserved_7[72];
-	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
-	u8 reserved_7b[4];
+	u8 reserved_7[80];
 	u32 pkru;
-	u8 reserved_7a[20];
-	u64 reserved_8;		/* rax already available at 0x01f8 */
+	u8 reserved_9[20];
+	u64 reserved_10;	/* rax already available at 0x01f8 */
 	u64 rcx;
 	u64 rdx;
 	u64 rbx;
-	u64 reserved_9;		/* rsp already available at 0x01d8 */
+	u64 reserved_11;	/* rsp already available at 0x01d8 */
 	u64 rbp;
 	u64 rsi;
 	u64 rdi;
@@ -299,23 +342,25 @@ struct vmcb_save_area {
 	u64 r13;
 	u64 r14;
 	u64 r15;
-	u8 reserved_10[16];
+	u8 reserved_12[16];
 	u64 sw_exit_code;
 	u64 sw_exit_info_1;
 	u64 sw_exit_info_2;
 	u64 sw_scratch;
 	u64 sev_features;
-	u8 reserved_11[48];
+	u8 reserved_13[48];
 	u64 xcr0;
 	u8 valid_bitmap[16];
 	u64 x87_state_gpa;
 } __packed;
 
+#define GHCB_SHARED_BUF_SIZE	2032
+
 struct ghcb {
-	struct vmcb_save_area save;
-	u8 reserved_save[2048 - sizeof(struct vmcb_save_area)];
+	struct sev_es_save_area save;
+	u8 reserved_save[2048 - sizeof(struct sev_es_save_area)];
 
-	u8 shared_buffer[2032];
+	u8 shared_buffer[GHCB_SHARED_BUF_SIZE];
 
 	u8 reserved_1[10];
 	u16 protocol_version;	/* negotiated SEV-ES/GHCB protocol version */
@@ -323,13 +368,15 @@ struct ghcb {
 } __packed;
 
 
-#define EXPECTED_VMCB_SAVE_AREA_SIZE		1032
+#define EXPECTED_VMCB_SAVE_AREA_SIZE		740
+#define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1032
 #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
 #define EXPECTED_GHCB_SIZE			PAGE_SIZE
 
 static inline void __unused_size_checks(void)
 {
 	BUILD_BUG_ON(sizeof(struct vmcb_save_area)	!= EXPECTED_VMCB_SAVE_AREA_SIZE);
+	BUILD_BUG_ON(sizeof(struct sev_es_save_area)	!= EXPECTED_SEV_ES_SAVE_AREA_SIZE);
 	BUILD_BUG_ON(sizeof(struct vmcb_control_area)	!= EXPECTED_VMCB_CONTROL_AREA_SIZE);
 	BUILD_BUG_ON(sizeof(struct ghcb)		!= EXPECTED_GHCB_SIZE);
 }
@@ -399,7 +446,7 @@ struct vmcb {
 /* GHCB Accessor functions */
 
 #define GHCB_BITMAP_IDX(field)							\
-	(offsetof(struct vmcb_save_area, field) / sizeof(u64))
+	(offsetof(struct sev_es_save_area, field) / sizeof(u64))
 
 #define DEFINE_GHCB_ACCESSORS(field)						\
 	static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)	\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 322553322202..c79da6af40b6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -558,12 +558,20 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
-	struct vmcb_save_area *save = &svm->vmcb->save;
+	struct sev_es_save_area *save = svm->sev_es.vmsa;
 
 	/* Check some debug related fields before encrypting the VMSA */
-	if (svm->vcpu.guest_debug || (save->dr7 & ~DR7_FIXED_1))
+	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
 		return -EINVAL;
 
+	/*
+	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
+	 * the traditional VMSA that is part of the VMCB. Copy the
+	 * traditional VMSA as it has been built so far (in prep
+	 * for LAUNCH_UPDATE_VMSA) to be the initial SEV-ES state.
+	 */
+	memcpy(save, &svm->vmcb->save, sizeof(svm->vmcb->save));
+
 	/* Sync registgers */
 	save->rax = svm->vcpu.arch.regs[VCPU_REGS_RAX];
 	save->rbx = svm->vcpu.arch.regs[VCPU_REGS_RBX];
@@ -591,14 +599,6 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	/*
-	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
-	 * the traditional VMSA that is part of the VMCB. Copy the
-	 * traditional VMSA as it has been built so far (in prep
-	 * for LAUNCH_UPDATE_VMSA) to be the initial SEV-ES state.
-	 */
-	memcpy(svm->sev_es.vmsa, save, sizeof(*save));
-
 	return 0;
 }
 
@@ -2905,7 +2905,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
-	struct vmcb_save_area *hostsa;
+	struct sev_es_save_area *hostsa;
 
 	/*
 	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
@@ -2915,7 +2915,7 @@ void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
 	vmsave(__sme_page_pa(sd->save_area));
 
 	/* XCR0 is restored on VMEXIT, save the current host value */
-	hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
+	hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
 	hostsa->xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 
 	/* PKRU is restored on VMEXIT, save the current host value */
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index daa8ca84afcc..d383d477bb29 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -168,7 +168,7 @@ struct svm_nested_state {
 
 struct vcpu_sev_es_state {
 	/* SEV-ES support */
-	struct vmcb_save_area *vmsa;
+	struct sev_es_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
-- 
2.25.1


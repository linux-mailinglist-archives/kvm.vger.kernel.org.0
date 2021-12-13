Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80243473301
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 18:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241379AbhLMRen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 12:34:43 -0500
Received: from mail-sn1anam02on2087.outbound.protection.outlook.com ([40.107.96.87]:6090
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241342AbhLMRei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 12:34:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaFOvLHoi5WIzJ8NL4cnCC6nev3azZa3lWYV48Idq7Co3JlFe3chlEknZRXed9h1uIzzFrfahfXRDmKJzzFIEZwdxe05U6euaDcuGH6FFawpuqoklzJmCV95sEx0Wj+o+CmOPgeu9B6fxRr+58PcdsI4SL+tnsIxqPm7Dd7NINM7lrAngh5Gk0PNxCSW6nc942taVaH2582lkOZfM/RJYJVkw082A8ulvBO2qznRmjCNGYmDoTGTnuBp1eRFNuOGBaRLLMeRYgIQn53Mm6Dz2xWc/dTal+v3vDt7JQ9knqDnc+auRP0ue4Zgi8aST0PL4utj8+qSpa7rna+AH/Scbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yYGZkXYbkKsCZF4e6t1+n+SfDJC4kr8FCySTr9HpfQ=;
 b=mgOltfLtcoIs10aIEeIxoJ6xlcpaSo9Znei3BHhokLlAkkHJ2HdGIk5/OeWeljZEyr7QkH0kAQExuUBIWZRKtD74s5/p0H1u2JZmE6qSTzMbuOcKzHzSVXdaZM+BZ7l/vsBC5E9tiLU5SpnlLxdOCALGYsi080kh+6DlkAkUgkzmjqM0Zzvzv6/axJ3PcLefDD5jR6Zrh6GuNi4/3UZd7n8kZIteJKGfW1uNOa/DofOo2Pml0oUr188axDUc1+WsB5DZmxG5rs9Rr6KoP9AxXhvKNAoYPqrrOdpcsA7aioBylAeFyos0zOT9RMhVM3SGEHVZCVapr/przSo4B9QKgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yYGZkXYbkKsCZF4e6t1+n+SfDJC4kr8FCySTr9HpfQ=;
 b=riFp3xe0HbusN6MBMfJvxiLP8gDVQb11HGZhifOQgGjw0no6pf1sqT+LMtmkkslNPoOkFy+TgWhex62ztb/EZ738/ZgQ39XUHG7UuS+5KbgFVUMAYg8Dd3eWEmKWi6UbUaULxO63aIygahwZd7jDo+zwKkcbhDPNVRtnMPOg7WY=
Received: from BN6PR17CA0030.namprd17.prod.outlook.com (2603:10b6:405:75::19)
 by MWHPR12MB1661.namprd12.prod.outlook.com (2603:10b6:301:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Mon, 13 Dec
 2021 17:34:35 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::ae) by BN6PR17CA0030.outlook.office365.com
 (2603:10b6:405:75::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14 via Frontend
 Transport; Mon, 13 Dec 2021 17:34:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 17:34:35 +0000
Received: from sbrijesh-desktop.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 13 Dec
 2021 11:34:28 -0600
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
Subject: [PATCH 4/4] KVM: SVM: Update the SEV-ES save area mapping
Date:   Mon, 13 Dec 2021 11:33:56 -0600
Message-ID: <20211213173356.138726-5-brijesh.singh@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 65c8d692-2b9b-4801-1a78-08d9be5ed4e5
X-MS-TrafficTypeDiagnostic: MWHPR12MB1661:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB16619031DC40B5D87E4BFD57E5749@MWHPR12MB1661.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h/7LWDso+8jowsHRrFDgVXtmOxyRbHUyzVe/5ANWTiCiKTFAMGeKR6J60MfxGJ0+XaN2R1jtQTmuwAWzEVBlxvgWXGbNLfDeAiCNJeprSy1p8cUNlh/ERPD9lxQVzuZJjHLKwCR1FPdCTxz9gNZ1EsJ780x7MX7r0fxdLt/4gRQpAMDvw32iBihILALmOmZ5y/W7PsbRoa4GZLU+9yaUb/C5FYyuf3gZ/OVezsPR2/Ol2byhK5drY183ILVR0prCsB6AWTdttex+cLoxfPgIII8vknVoY8kDv8U0+rGTp7ygmdSyUPhxIp0bU2nZmQBhZwx7Fz+Sn/+laxv4uPFvGEuLoPZAMJ9Gg+dTzz1JvBPMrz+VS/bVltxy9HSEiQiwldbnbpycbvojjtsjZVH82d7cLSgNpCD6c4kG+jsDUNrIya9j8+PzOhQALO6kYNaniK5Vh81F9EgXFTkH+FFRsm1I2wHZAMnY+tFsVKGilIpj5R8LYhkBP+hDIJI8TPkBuslKyyzOJ+NAk6L9PMlMOhfAKW0QbvgGuMNDYKOIhrEKNuUTos4VwYdxLfGaybwhVNGgi8eE18W31UcQRgbG3ABiU+1BUKDcALyLwxVGdohsQLy4CRhUURQagh8xhitzL+K8lOwRIxgZrly72ClSzjEndmYr3Bv3DIQ5oh07hzYoWhJsvBWJKtx3Artrfvryq69iTfcxRZWJyvMF5s0Yzv1anFl6Hst6JBSmLjPX7F8bxZ1TZRztakYtaUHuDEd5xrzYFZVmhSsNS8rWKs7sDuP+pvQ4yPZIPMy6t4A64QE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(186003)(508600001)(2616005)(54906003)(8676002)(44832011)(47076005)(5660300002)(2906002)(26005)(15650500001)(356005)(70586007)(8936002)(7416002)(16526019)(83380400001)(4326008)(6666004)(40460700001)(7696005)(81166007)(316002)(6916009)(82310400004)(1076003)(36860700001)(86362001)(426003)(36756003)(70206006)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 17:34:35.7194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c8d692-2b9b-4801-1a78-08d9be5ed4e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1661
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This is the final step in defining the multiple save areas to keep them
separate and ensuring proper operation amongst the different types of
guests. Update the SEV-ES/SEV-SNP save area to match the APM. This save
area will be used for the upcoming SEV-SNP AP Creation NAE event support.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/svm.h | 66 +++++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 5ff1fa364a31..7d90321e7775 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -290,7 +290,13 @@ struct sev_es_save_area {
 	struct vmcb_seg ldtr;
 	struct vmcb_seg idtr;
 	struct vmcb_seg tr;
-	u8 reserved_1[43];
+	u64 vmpl0_ssp;
+	u64 vmpl1_ssp;
+	u64 vmpl2_ssp;
+	u64 vmpl3_ssp;
+	u64 u_cet;
+	u8 reserved_1[2];
+	u8 vmpl;
 	u8 cpl;
 	u8 reserved_2[4];
 	u64 efer;
@@ -303,9 +309,19 @@ struct sev_es_save_area {
 	u64 dr6;
 	u64 rflags;
 	u64 rip;
-	u8 reserved_4[88];
+	u64 dr0;
+	u64 dr1;
+	u64 dr2;
+	u64 dr3;
+	u64 dr0_addr_mask;
+	u64 dr1_addr_mask;
+	u64 dr2_addr_mask;
+	u64 dr3_addr_mask;
+	u8 reserved_4[24];
 	u64 rsp;
-	u8 reserved_5[24];
+	u64 s_cet;
+	u64 ssp;
+	u64 isst_addr;
 	u64 rax;
 	u64 star;
 	u64 lstar;
@@ -316,7 +332,7 @@ struct sev_es_save_area {
 	u64 sysenter_esp;
 	u64 sysenter_eip;
 	u64 cr2;
-	u8 reserved_6[32];
+	u8 reserved_5[32];
 	u64 g_pat;
 	u64 dbgctl;
 	u64 br_from;
@@ -325,12 +341,12 @@ struct sev_es_save_area {
 	u64 last_excp_to;
 	u8 reserved_7[80];
 	u32 pkru;
-	u8 reserved_9[20];
-	u64 reserved_10;	/* rax already available at 0x01f8 */
+	u8 reserved_8[20];
+	u64 reserved_9;		/* rax already available at 0x01f8 */
 	u64 rcx;
 	u64 rdx;
 	u64 rbx;
-	u64 reserved_11;	/* rsp already available at 0x01d8 */
+	u64 reserved_10;	/* rsp already available at 0x01d8 */
 	u64 rbp;
 	u64 rsi;
 	u64 rdi;
@@ -342,16 +358,34 @@ struct sev_es_save_area {
 	u64 r13;
 	u64 r14;
 	u64 r15;
-	u8 reserved_12[16];
-	u64 sw_exit_code;
-	u64 sw_exit_info_1;
-	u64 sw_exit_info_2;
-	u64 sw_scratch;
+	u8 reserved_11[16];
+	u64 guest_exit_info_1;
+	u64 guest_exit_info_2;
+	u64 guest_exit_int_info;
+	u64 guest_nrip;
 	u64 sev_features;
-	u8 reserved_13[48];
+	u64 vintr_ctrl;
+	u64 guest_exit_code;
+	u64 virtual_tom;
+	u64 tlb_id;
+	u64 pcpu_id;
+	u64 event_inj;
 	u64 xcr0;
-	u8 valid_bitmap[16];
-	u64 x87_state_gpa;
+	u8 reserved_12[16];
+
+	/* Floating point area */
+	u64 x87_dp;
+	u32 mxcsr;
+	u16 x87_ftw;
+	u16 x87_fsw;
+	u16 x87_fcw;
+	u16 x87_fop;
+	u16 x87_ds;
+	u16 x87_cs;
+	u64 x87_rip;
+	u8 fpreg_x87[80];
+	u8 fpreg_xmm[256];
+	u8 fpreg_ymm[256];
 } __packed;
 
 struct ghcb_save_area {
@@ -410,7 +444,7 @@ struct ghcb {
 
 #define EXPECTED_VMCB_SAVE_AREA_SIZE		740
 #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
-#define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1032
+#define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
 #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
 #define EXPECTED_GHCB_SIZE			PAGE_SIZE
 
-- 
2.25.1


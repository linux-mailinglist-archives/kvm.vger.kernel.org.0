Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4DF60B591
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 20:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiJXScl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 14:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJXScM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 14:32:12 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4EC9F35F;
        Mon, 24 Oct 2022 10:13:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKGnDe4vMRojKAqiTxYCdWqsAR+EimfWA0AixKokXULfiAgkOu2Uo3xGcnhhF/nyJDVpsCnoW71SK7ZdmjQ9F9Q1Nni6Nz9JrWEc18txX8K1Uzu359zvL2m/cvFTHt+04rMjHdz2dJGtRBoxhdHglMepNN0ETLtaY/Urqm+amx2DQczQB/kSq7FM1k8Zsp/Y2UXdrxzUw14tVdAwjjdGwbVPIXvIHi+n6a9GpsDdyS55lzlZ6ZUAoB+weqVSnNT9p2jrysamI0EoG4JWNXpYmcnGuPkk/bHqthQFrN899BE2SUpcVzjrovc67uyucCjoy5L2VcKq5E0638gAlDGB9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9iKsBUGwR+SgYQ/lkBvTga3ZX3tnXfl9X7OStOl4po=;
 b=g6kCaEu5DAOcr8Hg+6X5LAuofIc/RH0TTePTdoXTSh1Pfb1J8zdy7qapBgp/3Me5g8Djl+VciD2wLB5kgqAy8exz2fU6JTDbcn6TeV242XSRWxr4kCFPYyBCIAXAi7IS1yegcBJ7buf6DO1C5kKBMAkuVZWtmZ0LBgFDI0b1g6r5VUM9gerlz18OqCSPHAbnbgNRpV+tnSWu5bYHJUC/YwsSjlJjLH1BOJSfNotYFTEfKsxCX8i1rQ042FARqWixYMdRsVpxIfDSgq4QMDzCSIlXT7CLzqUGdWFH8Qfyrc+ZY7p0BSlDz3NalLm+wRvrGeRciVVWhBW3ZmaksAhlSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9iKsBUGwR+SgYQ/lkBvTga3ZX3tnXfl9X7OStOl4po=;
 b=brj9CfbUZkiENHdjoV4HD83JSLEGSj96wTow3Mc5FTI1vEZJTBk2ZYSAM5pOTn+Sx2ein1w3B9tva9+eZYDqMDNi9uMRbMh82lEAG9302CGq5LldCnn/CitfihG4RI9C/+QehG/IugEXPYXZLyx4pZlJuBO2WVoWaoAbVYTPyA0=
Received: from MW2PR2101CA0014.namprd21.prod.outlook.com (2603:10b6:302:1::27)
 by CY5PR12MB6348.namprd12.prod.outlook.com (2603:10b6:930:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Mon, 24 Oct
 2022 16:44:50 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::68) by MW2PR2101CA0014.outlook.office365.com
 (2603:10b6:302:1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.0 via Frontend
 Transport; Mon, 24 Oct 2022 16:44:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Mon, 24 Oct 2022 16:44:50 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 11:44:49 -0500
Received: from iron-maiden.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Mon, 24 Oct 2022 11:44:48 -0500
From:   Carlos Bilbao <carlos.bilbao@amd.com>
To:     <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <bp@alien8.de>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
        <x86@kernel.org>, <hpa@zytor.com>, <venu.busireddy@oracle.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Thomas.Lendacky@amd.com>, <bilbao@vt.edu>,
        Carlos Bilbao <carlos.bilbao@amd.com>
Subject: [PATCH] KVM: SVM: Name and check reserved fields with structs offset
Date:   Mon, 24 Oct 2022 11:44:48 -0500
Message-ID: <20221024164448.203351-1-carlos.bilbao@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT036:EE_|CY5PR12MB6348:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b89306f-608e-4254-80ac-08dab5df117a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GIFj4rwN2RRZhUMe48LIN1SwwypcSUXoVVxdcKzL+7YYc5zptuTXXpB4xKD3XJxNjISjzkz4XUvERstnLEc+5JqN+RFPME+yrhVP3nBth3kpoHOQw0P7jk/XS8Nm1wOCwimJl5jhdkuXNA0lUw+DQ68LV47hryfDxnZU8ETA6kU6q+dGnEjkjLyEhVY5G3uvKmxJ6nP6qlnVpdgxVnrWWFue+8cxf8MzuPnNUTPGXx4sQ0W30NNgiEC51klpApCvgK3YrrfMwSN3WS9fWp89Fi0ahrYXx0r4EiMCxaZ/lluamAk0frybcJS8f0F4NQTVuF2K+R9NuWrA3dwxXUNZoSZXqLEKwN3FfOH0GSe46VP4mjA+TogvBvhSBPpDMOp9E7MavhgGGJZBh7rRfPKyz+VK4yqlpkyxu1CJkJP5W+1jzcPAzdvH1xCOpl9xRtnmarKQl8ZeK0IpwCb5cvh7ZYeO9MyWPn4e8kb/2/I+IaZ7Wrbm6CK7/bFzvrPXIhDczwjZkg0obHuDILbO8v9347+hobLqH9LKjOCSKCLTMBIt1vWs0wYqZ0YCe2Igi3yIQMSsgoRav74GXRUOoO9n+T1OMKZvoRj+QRBVC97fUtl8waGVnAkMSZRZ89HvFusUDnCUomAHPolJdqvgMvulxZUXhEH1e6v2LCtX63SQEDEZspEQJCwQ46QP/Jd+kEEdYao0xAehM7CMIHKliaJcSS6k/ga6l8DJteENQyoWUuBVfCL4uOMVGdELZDwov2JIt7zgvJ+vQWnW3cSZiihUlAB2wS7ypxaDy5JzTqMw3UxvJqGp7mHa85dm4oSf3y+efbqgX1s23q8Jk9DqYeuXQQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(41300700001)(8936002)(336012)(81166007)(2906002)(186003)(1076003)(356005)(82310400005)(7696005)(966005)(316002)(36756003)(478600001)(6916009)(40460700003)(86362001)(54906003)(36860700001)(4326008)(70586007)(8676002)(70206006)(2616005)(7416002)(26005)(40480700001)(83380400001)(82740400003)(5660300002)(44832011)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:44:50.0047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b89306f-608e-4254-80ac-08dab5df117a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6348
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename reserved fields on all structs in arch/x86/include/asm/svm.h
following their offset within the structs. Include compile time checks for
this in the same place where other BUILD_BUG_ON for the structs are.

This also solves that fields of struct sev_es_save_area are named by their
order of appearance, but right now they jump from reserved_5 to reserved_7.

Link: https://lkml.org/lkml/2022/10/22/376
Signed-off-by: Carlos Bilbao <carlos.bilbao@amd.com>
---
 arch/x86/include/asm/svm.h | 94 ++++++++++++++++++++++++++------------
 1 file changed, 66 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..41d5188bf91a 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -293,12 +293,13 @@ struct vmcb_save_area {
 	struct vmcb_seg ldtr;
 	struct vmcb_seg idtr;
 	struct vmcb_seg tr;
-	u8 reserved_1[42];
+	/* Reserved fields are named following their struct offset */
+	u8 reserved_0xa0[42];
 	u8 vmpl;
 	u8 cpl;
-	u8 reserved_2[4];
+	u8 reserved_0xcc[4];
 	u64 efer;
-	u8 reserved_3[112];
+	u8 reserved_0xd8[112];
 	u64 cr4;
 	u64 cr3;
 	u64 cr0;
@@ -306,7 +307,7 @@ struct vmcb_save_area {
 	u64 dr6;
 	u64 rflags;
 	u64 rip;
-	u8 reserved_4[88];
+	u8 reserved_0x180[88];
 	u64 rsp;
 	u64 s_cet;
 	u64 ssp;
@@ -321,14 +322,14 @@ struct vmcb_save_area {
 	u64 sysenter_esp;
 	u64 sysenter_eip;
 	u64 cr2;
-	u8 reserved_5[32];
+	u8 reserved_0x248[32];
 	u64 g_pat;
 	u64 dbgctl;
 	u64 br_from;
 	u64 br_to;
 	u64 last_excp_from;
 	u64 last_excp_to;
-	u8 reserved_6[72];
+	u8 reserved_0x298[72];
 	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
 } __packed;
 
@@ -349,12 +350,12 @@ struct sev_es_save_area {
 	u64 vmpl2_ssp;
 	u64 vmpl3_ssp;
 	u64 u_cet;
-	u8 reserved_1[2];
+	u8 reserved_0xc8[2];
 	u8 vmpl;
 	u8 cpl;
-	u8 reserved_2[4];
+	u8 reserved_0xcc[4];
 	u64 efer;
-	u8 reserved_3[104];
+	u8 reserved_0xd8[104];
 	u64 xss;
 	u64 cr4;
 	u64 cr3;
@@ -371,7 +372,7 @@ struct sev_es_save_area {
 	u64 dr1_addr_mask;
 	u64 dr2_addr_mask;
 	u64 dr3_addr_mask;
-	u8 reserved_4[24];
+	u8 reserved_0x1c0[24];
 	u64 rsp;
 	u64 s_cet;
 	u64 ssp;
@@ -386,21 +387,21 @@ struct sev_es_save_area {
 	u64 sysenter_esp;
 	u64 sysenter_eip;
 	u64 cr2;
-	u8 reserved_5[32];
+	u8 reserved_0x248[32];
 	u64 g_pat;
 	u64 dbgctl;
 	u64 br_from;
 	u64 br_to;
 	u64 last_excp_from;
 	u64 last_excp_to;
-	u8 reserved_7[80];
+	u8 reserved_0x2e4[80];
 	u32 pkru;
-	u8 reserved_8[20];
-	u64 reserved_9;		/* rax already available at 0x01f8 */
+	u8 reserved_0x2ec[20];
+	u64 reserved_0x300;	/* rax already available at 0x01f8 */
 	u64 rcx;
 	u64 rdx;
 	u64 rbx;
-	u64 reserved_10;	/* rsp already available at 0x01d8 */
+	u64 reserved_0x320;	/* rsp already available at 0x01d8 */
 	u64 rbp;
 	u64 rsi;
 	u64 rdi;
@@ -412,7 +413,7 @@ struct sev_es_save_area {
 	u64 r13;
 	u64 r14;
 	u64 r15;
-	u8 reserved_11[16];
+	u8 reserved_0x380[16];
 	u64 guest_exit_info_1;
 	u64 guest_exit_info_2;
 	u64 guest_exit_int_info;
@@ -425,7 +426,7 @@ struct sev_es_save_area {
 	u64 pcpu_id;
 	u64 event_inj;
 	u64 xcr0;
-	u8 reserved_12[16];
+	u8 reserved_0x3f0[16];
 
 	/* Floating point area */
 	u64 x87_dp;
@@ -443,23 +444,23 @@ struct sev_es_save_area {
 } __packed;
 
 struct ghcb_save_area {
-	u8 reserved_1[203];
+	u8 reserved_0x0[203];
 	u8 cpl;
-	u8 reserved_2[116];
+	u8 reserved_0xcc[116];
 	u64 xss;
-	u8 reserved_3[24];
+	u8 reserved_0x148[24];
 	u64 dr7;
-	u8 reserved_4[16];
+	u8 reserved_0x168[16];
 	u64 rip;
-	u8 reserved_5[88];
+	u8 reserved_0x180[88];
 	u64 rsp;
-	u8 reserved_6[24];
+	u8 reserved_0x1e0[24];
 	u64 rax;
-	u8 reserved_7[264];
+	u8 reserved_0x200[264];
 	u64 rcx;
 	u64 rdx;
 	u64 rbx;
-	u8 reserved_8[8];
+	u8 reserved_0x320[8];
 	u64 rbp;
 	u64 rsi;
 	u64 rdi;
@@ -471,12 +472,12 @@ struct ghcb_save_area {
 	u64 r13;
 	u64 r14;
 	u64 r15;
-	u8 reserved_9[16];
+	u8 reserved_0x380[16];
 	u64 sw_exit_code;
 	u64 sw_exit_info_1;
 	u64 sw_exit_info_2;
 	u64 sw_scratch;
-	u8 reserved_10[56];
+	u8 reserved_0x3b0[56];
 	u64 xcr0;
 	u8 valid_bitmap[16];
 	u64 x87_state_gpa;
@@ -490,7 +491,7 @@ struct ghcb {
 
 	u8 shared_buffer[GHCB_SHARED_BUF_SIZE];
 
-	u8 reserved_1[10];
+	u8 reserved_0xff0[10];
 	u16 protocol_version;	/* negotiated SEV-ES/GHCB protocol version */
 	u32 ghcb_usage;
 } __packed;
@@ -502,6 +503,9 @@ struct ghcb {
 #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
 #define EXPECTED_GHCB_SIZE			PAGE_SIZE
 
+#define BUILD_BUG_RESERVED_OFFSET(x, y) \
+	BUILD_BUG_ON(offsetof(struct x, reserved ## _ ## y) != y)
+
 static inline void __unused_size_checks(void)
 {
 	BUILD_BUG_ON(sizeof(struct vmcb_save_area)	!= EXPECTED_VMCB_SAVE_AREA_SIZE);
@@ -509,6 +513,40 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_ON(sizeof(struct sev_es_save_area)	!= EXPECTED_SEV_ES_SAVE_AREA_SIZE);
 	BUILD_BUG_ON(sizeof(struct vmcb_control_area)	!= EXPECTED_VMCB_CONTROL_AREA_SIZE);
 	BUILD_BUG_ON(sizeof(struct ghcb)		!= EXPECTED_GHCB_SIZE);
+
+	/* Check offsets of reserved fields */
+
+	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0xa0);
+	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0xcc);
+	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0xd8);
+	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x180);
+	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x248);
+	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x298);
+
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xc8);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xcc);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xd8);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2e4);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2ec);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
+
+	BUILD_BUG_RESERVED_OFFSET(ghcb_save_area, 0x0);
+	BUILD_BUG_RESERVED_OFFSET(ghcb_save_area, 0xcc);
+	BUILD_BUG_RESERVED_OFFSET(ghcb_save_area, 0x148);
+	BUILD_BUG_RESERVED_OFFSET(ghcb_save_area, 0x168);
+	BUILD_BUG_RESERVED_OFFSET(ghcb_save_area, 0x180);
+	BUILD_BUG_RESERVED_OFFSET(ghcb_save_area, 0x1e0);
+	BUILD_BUG_RESERVED_OFFSET(ghcb_save_area, 0x200);
+	BUILD_BUG_RESERVED_OFFSET(ghcb_save_area, 0x320);
+	BUILD_BUG_RESERVED_OFFSET(ghcb_save_area, 0x380);
+	BUILD_BUG_RESERVED_OFFSET(ghcb_save_area, 0x3b0);
+
+	BUILD_BUG_RESERVED_OFFSET(ghcb, 0xff0);
 }
 
 struct vmcb {
-- 
2.34.1


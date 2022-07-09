Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D553556C99E
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 15:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiGINoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 09:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiGINnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 09:43:46 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05F2D8C;
        Sat,  9 Jul 2022 06:43:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhWAXkwU0R5lj9ILRKLNKOo/g7T9tSf1S8/zXIf9exfW1w2UcYBSG8FHET7RvbnH4mT0DtcSUxWjG2AsY1GPMytZyt5kI8kfmtL1C+7om+Y4RxpRGeNo2+/B1UvzOeo+8HlJrF79mDzCNRRG8tbZjIHzogIwypgxnzVbRBFPbq09THu8CSmpO1GSzPvZDPwnnW2uYfFZsS0HiRk99D3P5jH04CVSuhQC5Y1Od1kBVSa09UMnQzvnpV2olgZFyEFEM/iZb09sDH9VhEEd9ZXIXZx2M4sJPIzrom+JEaNOoui1Ha/vkEhp13Z1M56o85vgkr/13p3AatM7VAgHy0fISQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7S3r0zTkTDWhSLMNu+3rW64b4ABCCXubWAIx76XI9gM=;
 b=ACiC6WMC+yA5yKmkKdLzjLVPKS738GwNzIYFo+HhmlXVyagK/vc+0wSAuR2+PHPj5NjSz6iO/Y1cSWL7cdy/nJbWKEwaYZ3wdua7oALuloApXS2lWTJ8VjQNQNWrWqyGUsLpNrCvfll0cOx6HLAGx2ccgT2NpZktXFX2PmhRaAKFEsG4/by2TURgbvJChepUNcNkgG4tzTOCwf7Mo8aSNaImxcZMBlIiVVhTI+1adoPKBZr/wusrtnMN69D2aVbHp/5FQUXEq8Q76pD2RNc66JFzjoFB79UWEEpfxi/hww0udKV3LVBAFfpf/xWl7TBw0HzUcpOjfPuBGvAgYlVl3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7S3r0zTkTDWhSLMNu+3rW64b4ABCCXubWAIx76XI9gM=;
 b=3+Tmw7lpO8DzGYK5P4fXarj3kmtYZFEmNLNMCBzli1/33apTM5k3O5r+BKqcicnEKXNYCHMlPHNW1WPIplAfc9VJ60QMbAQkjERy7+6/nThtA/JwV3SkDxDQYiMu6DRni2xR4pfKdIoQej/xLxWL9gWX926VZXoNHTE3fV8MZjU=
Received: from DM6PR02CA0065.namprd02.prod.outlook.com (2603:10b6:5:177::42)
 by MW4PR12MB5628.namprd12.prod.outlook.com (2603:10b6:303:185::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 13:43:43 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::7b) by DM6PR02CA0065.outlook.office365.com
 (2603:10b6:5:177::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17 via Frontend
 Transport; Sat, 9 Jul 2022 13:43:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Sat, 9 Jul 2022 13:43:43 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Sat, 9 Jul
 2022 08:43:39 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCHv2 3/7] KVM: SVM: Add VNMI support in get/set_nmi_mask
Date:   Sat, 9 Jul 2022 19:12:26 +0530
Message-ID: <20220709134230.2397-4-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220709134230.2397-1-santosh.shukla@amd.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82f605ea-feef-42c2-d268-08da61b10a51
X-MS-TrafficTypeDiagnostic: MW4PR12MB5628:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZHqn1em/qwsrcV7Ib9LZB9KHL1i6v4zCXDKwxup+Df6hjoylwD9/W5hnFzcID2lXPxSlYafqk5KoFjCUrmIyo8QwdvK1axPOMCQhxdQk0AhXIMf5yjKtE0ndfvETpD+D9R/tfdTorXvjHylIRVVqaG0jQY3oPON/gu42SYU9cOISsqAHL4YWQZj8+2/xYX6JUHbDgu3KXPstEaJM2Jd7WRRsyxM1CZ476YpKnGdQ0JwREyoJnadc7o+t/Qp5ffUv828r809cBgkQ8T91sHmy7FBo5Ufv401tPnbSlpDh6Ewg6dN1UVe73vnyOuTUwbWMrWp6Ai8O5hQgICjAul2T+upTnpoHqmK7fJ2m8DvjV0vaC1Cc8Jzw7LbrLCWHc8lDOaYoeTKv2qVdOBuW78Nwxxj/o9FVW0UxLIh6zqd3SFnGfOJCht7u2MGj42YWs7x3QT6iUdsarrjwWzpZx2tiwEb/hMZhug4e3EIyRxy8rM0FAZOD+xFwyCAn0iPxwmJ7zWkO63LQOETAnnRil+aFtgfwMqilfdDgzG99ljYCOYS+YQmnquNs6/wRnOoOzYXqDIE2wVdGmP4gh7wO6xVaDOHj5sD/hMZJwjUcz42/f/oIQU7nGRRY77MyevBNTiVEAXuN6lM0+D4aQfdwKwj2VHufAj+6sSIDoeTc1mqFOkM7ec1R4f7ksA1TSf3CYlQ7i4tMofcnPSmRa0bcQAxZw3y8ByAG0mepnZ5/4lvBUJpokGUzbuX79nfesFCyRzND/Mw2SXzVHpW2CqB/fi++V2OoD0M5akQ/sbrLH9KWt6xZQkKmD4d/hOrEgVRBrSt+0M8ANaNqWBkjDa05MZH5hq0ABXat7OOuii7pcCV33rG8PIrXvTLRfj9YXiX5OHj
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(39860400002)(40470700004)(46966006)(36840700001)(47076005)(336012)(54906003)(81166007)(16526019)(426003)(6916009)(70586007)(83380400001)(356005)(186003)(40480700001)(8676002)(4326008)(5660300002)(36756003)(36860700001)(82740400003)(70206006)(34020700004)(2616005)(26005)(478600001)(316002)(6666004)(8936002)(86362001)(2906002)(41300700001)(40460700003)(44832011)(1076003)(7696005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 13:43:43.5492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f605ea-feef-42c2-d268-08da61b10a51
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5628
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
read-only in the hypervisor and do not populate set accessors.

Adding API(get_vnmi_vmcb) in order to return the correct vmcb for L1 or
L2.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v2:
- Added get_vnmi_vmcb API to return vmcb for l1 and l2.
- Use get_vnmi_vmcb to get correct vmcb in func -
  is_vnmi_enabled/_mask_set()
- removed vnmi check from is_vnmi_enabled() func.

 arch/x86/kvm/svm/svm.c | 12 ++++++++++--
 arch/x86/kvm/svm/svm.h | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index baaf35be36e5..3574e804d757 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -198,7 +198,7 @@ module_param(dump_invalid_vmcb, bool, 0644);
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
-static bool vnmi;
+bool vnmi = true;
 module_param(vnmi, bool, 0444);
 
 static bool svm_gp_erratum_intercept = true;
@@ -3503,13 +3503,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
 static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
 {
-	return !!(vcpu->arch.hflags & HF_NMI_MASK);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (is_vnmi_enabled(svm))
+		return is_vnmi_mask_set(svm);
+	else
+		return !!(vcpu->arch.hflags & HF_NMI_MASK);
 }
 
 static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_vnmi_enabled(svm))
+		return;
+
 	if (masked) {
 		vcpu->arch.hflags |= HF_NMI_MASK;
 		if (!sev_es_guest(vcpu->kvm))
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9223ac100ef5..f36e30df6202 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern int vgif;
 extern bool intercept_smi;
+extern bool vnmi;
 
 /*
  * Clean bits in VMCB.
@@ -509,6 +510,37 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
 }
 
+static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
+{
+	if (!vnmi)
+		return NULL;
+
+	if (is_guest_mode(&svm->vcpu))
+		return svm->nested.vmcb02.ptr;
+	else
+		return svm->vmcb01.ptr;
+}
+
+static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
+	else
+		return false;
+}
+
+static inline bool is_vnmi_mask_set(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_NMI_MASK);
+	else
+		return false;
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-- 
2.25.1


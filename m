Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B272E5527FE
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347315AbiFTXR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347008AbiFTXRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:17:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFCE275E5;
        Mon, 20 Jun 2022 16:13:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGLwACDdeZWXZ+XE6TLMs+CBuaUdaKJZLX6saaexEoIF46mrv9mpVS+5NFdkxphu1WesEcwhuoZDfqa8sO2XNRk4Ku5V+/+0rBqeQgs6P7C66F5JsL1Ti2SezHhnGETwc3OxYLwjbQThKsP7YVeOJxqeHo6Ea1RmqxUU+IdgizuUvnFtdoVr5ODZTvg6QL6l3ED0u+9PoNHKOqO81zmqHOLx0TQmrCu07DAa8ipWfxnVLKffyaL0/3Bp+t7QQZS2GYiNeJhxO4myZ5iCsM2XqIos6z3JTCVkeaANEamKKyfU4bO5BLdHEq9RQ2SKwJvQLLn6yKY8VanGs20Z09ooBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jsm3uott7xgIoS87z1RyCceHURhx/sUib4D69GFXddU=;
 b=PM/kVgY+l+ofcUtnWagnjdJ2NuKZjvxE8EbbDmLY+Q7lixnsDSjrJDZpNMo11txYl89tQDJFDX2lMsIQFXUAVaI1i3unAccSUGgzaqyT2cnQZ8kej7RoQtZerPC63ARYIfXgLBonkMTBXsiyTD0u1rq1zyo1a5L2+JK56AcO9TkF3SzUv5YMIuGiHNg8j3WzODy49vcL2s+jOLpJ1lHFbI1TaRU/H9zMY9dMr6g0ws7hZre6U+kUgAtUNVSQVrBnFkmgF3GgbGmdMYIAIzCnhTzBq8U/3PEoWvEgE4giHj86S4FLYGYBdZnytoihoDr4BYy5xriXwHQtrr7sbZ47Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jsm3uott7xgIoS87z1RyCceHURhx/sUib4D69GFXddU=;
 b=oJJ1QQYWIVKdmk6leZMwhcpAPJv61WQMFwAUeVHliFFjohP/zNhAOHm2DNCc3Engvttt242iVBtip+/6oWCmIKaGlufVZyBfKxmSLU+pN/J3kNVVmXYx8AblEnGn0Jek+bDUtuXaYipN8RUxxoy1jVHvpiveI+NNHe0FwLKrILA=
Received: from DM6PR17CA0012.namprd17.prod.outlook.com (2603:10b6:5:1b3::25)
 by DM6PR12MB3195.namprd12.prod.outlook.com (2603:10b6:5:183::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Mon, 20 Jun
 2022 23:13:15 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::7b) by DM6PR17CA0012.outlook.office365.com
 (2603:10b6:5:1b3::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Mon, 20 Jun 2022 23:13:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:13:15 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:13:12 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 41/49] KVM: SVM: Add support to handle the RMP nested page fault
Date:   Mon, 20 Jun 2022 23:13:03 +0000
Message-ID: <d7decd3cb48d962da086afb65feb94a124e5c537.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8954586f-09d6-4770-90a4-08da53127495
X-MS-TrafficTypeDiagnostic: DM6PR12MB3195:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3195858644103256D7E2D25C8EB09@DM6PR12MB3195.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HJ2dqskW40bbszIh8dko8lb2idCHIfqKgl5cLRI++yAXxT9nzErz0kE3j6ucE+U2a1Z0v/mZbkDK4iUU4x4WMIw9corLPKX//7HH2SC6d9yRzMhquXOeUjBOoq6Uzc9aoTOjqzi3qFGfqYn6X1Vir0wmPb1cufLtHqhlvQ3n45cAh/b10QfikbYeOV7E4YKxFg0g3unMdTM1oamBJwTHoCyMToQ6APdP0Cqezfif2ZqQzyl0oBEWQ+L0qFgQ71kDeMiBwMBKf2RsPk8HxJ2DC6ImdjZPklqls8y0wN2Yzqd3jhYz5U5w7/+Aww9eCcHYyqQd3P7FJIuquZdH8Q6o6DukoPjNR0oS7PIGsvoXxXs22cXYlOGLYa6klfEPULTrm5DgE22Nyskleo4fGi5E+oTfRm0C1v/K7ikbrlcxDF5w8/qsF2QVKyunYt6ZL8mC21pKr2Oc+xdaam1oSmo6SHAZphwxLSZYo14vqj9VpPEMud6v9zPzQZbYpJcMLw4TTyBe7rM00jEaiYcxfe2xJ2UIfPonFJ9GJO6TtXypt23QRfzdN4xwjouHIh/Xfeu3dgXpJMd+9VGKJT12V53NW1OJt0xEvUy4UVyW2jFW7BRF7vTJeyvgDpFDyt/QaS2wbY/hYllkjOoh98RgYaQZOl9tSHycvYRVTXuEFb64NsblMElL3edBnhbhfBIKMNpDWBMBMNBYvoU3mJfxw6tRn6syUUy5aa1KxmnCr1BBVPFyuuQgGk4K54ZbB56vMo8mxk6AQwCpmwA6Faob145yZw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(40470700004)(46966006)(36840700001)(110136005)(7406005)(478600001)(54906003)(6666004)(2616005)(2906002)(70586007)(82310400005)(7416002)(5660300002)(4326008)(40480700001)(70206006)(316002)(8936002)(83380400001)(40460700003)(8676002)(36756003)(86362001)(81166007)(82740400003)(356005)(41300700001)(186003)(47076005)(426003)(336012)(26005)(7696005)(16526019)(36860700001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:13:15.5884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8954586f-09d6-4770-90a4-08da53127495
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3195
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled in the guest, the hardware places restrictions on
all memory accesses based on the contents of the RMP table. When hardware
encounters RMP check failure caused by the guest memory access it raises
the #NPF. The error code contains additional information on the access
type. See the APM volume 2 for additional information.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c | 14 +++++---
 2 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4ed90331bca0..7fc0fad87054 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4009,3 +4009,79 @@ void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
 
 	spin_unlock(&sev->psc_lock);
 }
+
+void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
+{
+	int rmp_level, npt_level, rc, assigned;
+	struct kvm *kvm = vcpu->kvm;
+	gfn_t gfn = gpa_to_gfn(gpa);
+	bool need_psc = false;
+	enum psc_op psc_op;
+	kvm_pfn_t pfn;
+	bool private;
+
+	write_lock(&kvm->mmu_lock);
+
+	if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level)))
+		goto unlock;
+
+	assigned = snp_lookup_rmpentry(pfn, &rmp_level);
+	if (unlikely(assigned < 0))
+		goto unlock;
+
+	private = !!(error_code & PFERR_GUEST_ENC_MASK);
+
+	/*
+	 * If the fault was due to size mismatch, or NPT and RMP page level's
+	 * are not in sync, then use PSMASH to split the RMP entry into 4K.
+	 */
+	if ((error_code & PFERR_GUEST_SIZEM_MASK) ||
+	    (npt_level == PG_LEVEL_4K && rmp_level == PG_LEVEL_2M && private)) {
+		rc = snp_rmptable_psmash(kvm, pfn);
+		if (rc)
+			pr_err_ratelimited("psmash failed, gpa 0x%llx pfn 0x%llx rc %d\n",
+					   gpa, pfn, rc);
+		goto out;
+	}
+
+	/*
+	 * If it's a private access, and the page is not assigned in the
+	 * RMP table, create a new private RMP entry. This can happen if
+	 * guest did not use the PSC VMGEXIT to transition the page state
+	 * before the access.
+	 */
+	if (!assigned && private) {
+		need_psc = 1;
+		psc_op = SNP_PAGE_STATE_PRIVATE;
+		goto out;
+	}
+
+	/*
+	 * If it's a shared access, but the page is private in the RMP table
+	 * then make the page shared in the RMP table. This can happen if
+	 * the guest did not use the PSC VMGEXIT to transition the page
+	 * state before the access.
+	 */
+	if (assigned && !private) {
+		need_psc = 1;
+		psc_op = SNP_PAGE_STATE_SHARED;
+	}
+
+out:
+	write_unlock(&kvm->mmu_lock);
+
+	if (need_psc)
+		rc = __snp_handle_page_state_change(vcpu, psc_op, gpa, PG_LEVEL_4K);
+
+	/*
+	 * The fault handler has updated the RMP pagesize, zap the existing
+	 * rmaps for large entry ranges so that nested page table gets rebuilt
+	 * with the updated RMP pagesize.
+	 */
+	gfn = gpa_to_gfn(gpa) & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
+	return;
+
+unlock:
+	write_unlock(&kvm->mmu_lock);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1c8e035ba011..7742bc986afc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1866,15 +1866,21 @@ static int pf_interception(struct kvm_vcpu *vcpu)
 static int npf_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	int rc;
 
 	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	trace_kvm_page_fault(fault_address, error_code);
-	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
-			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
-			svm->vmcb->control.insn_bytes : NULL,
-			svm->vmcb->control.insn_len);
+	rc = kvm_mmu_page_fault(vcpu, fault_address, error_code,
+				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
+				svm->vmcb->control.insn_bytes : NULL,
+				svm->vmcb->control.insn_len);
+
+	if (error_code & PFERR_GUEST_RMP_MASK)
+		handle_rmp_page_fault(vcpu, fault_address, error_code);
+
+	return rc;
 }
 
 static int db_interception(struct kvm_vcpu *vcpu)
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0808A7CA9F6
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbjJPNmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbjJPNl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:41:59 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C79D40;
        Mon, 16 Oct 2023 06:41:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WD4c+sBx+urkYoAuC+8sPksXT/tj/doHWB+DZ/zsd6XtvRLy0hoYa2lS81+pkFOeK1KhfKs0UzRL/zY59qbZwcZOL3WBV6ghe3De4ZLfU0PpuMRdsBZTdeJ6RXlIX37KTg99rv7HOrzxDYP+J1vBBflOP4BYHWE83aipMJk1Nk/aFRwCP6CEXfAOAcPmQC0e0FFzE5b8Py4c2/bjHtZUOkoesB0nONklGf5rE5+uq9IDePhKHggd6H/RpmX1YIm9Qt3GbffjaxHfgjTMhfPx+C4JytVYqxPWbFmm07gKKDAqjGWVXwvu6iH53GjBMlX0keDZzdmzV+IxYuXEQtu4OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOBrlc6modSCEOxUvub452YGuS7hs3qlfXqRI5nxIlw=;
 b=R6c7ff3EEhMbmFmzP898SuIjfQp/G27fQHwPCDJP7qxYVuvMKHSBZH4fcL1hOvmMiWTHNbj2vGyC4w6HR326d2XHgnF7hkX6iYqSx0quebdziAhkD6yDafcwF3U9fRkf7LLXV7+7crE70w6wRlo60tQx0RCkKcmBpfcJnFnalfbm7B/zYNQdrLFNqlki5/qfFk4aQHnE3i5o7HRPXu3DXfKVXMZSfZJXf+JMozv4VhKzHa7k4mL2GS3frNjm9cNMAr3iK1Lk94R2D9yqdLz9CbFkT9ZUZ3Ac6GHq5oyr0MWDRd+eHSH7jZr2BYdg1IA8+8M3VgscCaT9c//a1H9tQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOBrlc6modSCEOxUvub452YGuS7hs3qlfXqRI5nxIlw=;
 b=DXSQnPfZVRbFTA7miX6g88lbjwx93bZXMrNlhV02XBk1CwELoHeYVJ6cTh+wcPSc+HlNlQB1cgqR+SmIhSb6TQJ8LMt5Ye+eixyFQjL2/cI9l3JGOYeczIxiVzH4PJCBDjOtgZav3mMqnbwiTwBIS4jjD28DL785kda0n5y95/I=
Received: from BY5PR13CA0019.namprd13.prod.outlook.com (2603:10b6:a03:180::32)
 by MW4PR12MB7384.namprd12.prod.outlook.com (2603:10b6:303:22b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:41:52 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:a03:180:cafe::51) by BY5PR13CA0019.outlook.office365.com
 (2603:10b6:a03:180::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18 via Frontend
 Transport; Mon, 16 Oct 2023 13:41:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:41:51 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:41:51 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 36/50] KVM: SEV: Use a VMSA physical address variable for populating VMCB
Date:   Mon, 16 Oct 2023 08:28:05 -0500
Message-ID: <20231016132819.1002933-37-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|MW4PR12MB7384:EE_
X-MS-Office365-Filtering-Correlation-Id: 14f8e783-901e-4b93-2796-08dbce4da767
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XuuqGVj7aOhV5LUtlMxfEqkE+ttbRAdBltxfVx/uob/xe/in/p5sNOjzU8s4eyctdqD4kU6pQyd8+HyMQxITGxSDIndkNtC+5NcmOUdJEdJ+qoWBvQHkymvqB2hedypaNSUf1690MiYHtEa89g5SNxGMYztNYzi/8RgjChBksotYRh08NsESysMe5Cvm9Fk2MBPcotKqyzN75Ma8qxAv7lTHLKUzvqdF10SKdGWR3GwZdgoaL0ryBB/s7y2f3/j031GYQeylyIvs6NA+8RPy+0l8lB9iwa1Saz4fEwh/6TRx5DydEFj1xTdMEvJKqBb0/A9bzkx1k/awy5y0/pcSsh0vXBn3M+72iy4NLbwPpgHtqwxtZGxvzPxbL4d4TD/9sysPqOYJj3f2+mTlf1kelVncZ5KxJz57gLUi5QCMBgeMgqTRQ8IfCl6KVSJzph5KepKgpS2dPc/yznhMX6XvldwV2SQdWizsBprXO4myo4UuhfEZ6AGn2dlmc86TKlA8Zy9YAw6zVZ6JyT6U9M7bxmNZORNcUHau9YXAYv8JRE8y8O8pBGOThYchpO3HY6ySmHELV2c4HSie4hp/j/wvBOk35p34yLzReB6d2xLJx8iyLJ6SuqUA+iNqVOXchRf5Ajf5jw1qABLriqXdFxqz4Z+c4EE7D/QZE4XziTjpuzLxui9lle9BEZR8BcWZTVnXJ4wsDjfYBUyUIYfvgBGOxY2jxOXxI6JdVQe9JmPDeZvCaWokc+C4b1/EFZ8N2XL6EO/6FF9f2Wp7E1pAJF4ubw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(186009)(64100799003)(82310400011)(1800799009)(451199024)(46966006)(40470700004)(36840700001)(6916009)(478600001)(70586007)(54906003)(70206006)(6666004)(26005)(1076003)(316002)(426003)(336012)(2616005)(16526019)(7406005)(7416002)(4326008)(8676002)(8936002)(2906002)(44832011)(5660300002)(41300700001)(36756003)(81166007)(86362001)(356005)(47076005)(36860700001)(83380400001)(82740400003)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:41:51.8635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f8e783-901e-4b93-2796-08dbce4da767
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7384
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
---
 arch/x86/kvm/svm/sev.c | 3 +--
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0a45031386c2..f36d72ca2cf7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3639,8 +3639,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	 * the VMSA will be NULL if this vCPU is the destination for intrahost
 	 * migration, and will be copied later.
 	 */
-	if (svm->sev_es.vmsa)
-		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
+	svm->vmcb->control.vmsa_pa = svm->sev_es.vmsa_pa;
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 563c9839428d..c04c554e5675 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1463,9 +1463,16 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
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
index c3a37136fa30..0ad76ed4d625 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -200,6 +200,7 @@ struct vcpu_sev_es_state {
 	struct ghcb *ghcb;
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
+	hpa_t vmsa_pa;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
 
-- 
2.25.1


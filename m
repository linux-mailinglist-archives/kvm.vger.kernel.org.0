Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80D672B717
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbjFLEyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbjFLExi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:53:38 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02E21B8;
        Sun, 11 Jun 2023 21:53:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsKC+Tj6vv9K6MyEmihXturAIvX2cRP14OEt/ylsvYSlcrHxSXwfCTnkMpiKea1bAY9oWxnsiw7wmpge0vIVjGD+srUnCCxACy2zlrtMKFYzuUdvBCmB/DbLYVF16GGpUFmKw3cMUlK1DgH4FprQorTONXYu3I9ZF/sbvjRipOpli7y3x/kKEGeiICooqNGKMC9LjehqA1Q4ODjjXjYAk+/VIaYC6SQ79OYDYd8Z7eJ8VKfupt/ZiqCpR5vrIYd06DbcvKQTLElMDznoE0Nh5HVjIT0BVdlGIPxfUwJizI5D9N7Miw3PWfPyT9p1zMzb6bwLobIPnqrFQbVWsBD0yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCqcVUonepiEjlzgOGv6GcVfSdkI7MUY7xviMc0Iq1o=;
 b=DVzLFdxVG8FYtW6qhAb1qxIcDQfI9abm5VKdLdhOVyxAaTiny5PlNB3A1n1Pdmj0NZDMhOPNc9sETaIwsay5LqRixU+8l//WMdPBAJZevWF2ohr7mSl9Lgb2fXtRqlSIVImIGatTU/hQ3zTaefc6K0KglxwNFMzIhcfdfksZvQl1cfA2p+6wmjxFap/Uwj56HjpMrt96e0uZ/aph2agopveKej9lus0e6nZVOOD5Nv2D6OrC/LNq0+bG+ho7tqp0UaF8lFUkqnZRIBBxeWXu60Iphtu0sQymoQodxLfkJIyHcmZu0iHGXFftGGHoYHdo5VS5EAXSBH2ver5c1rs4Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCqcVUonepiEjlzgOGv6GcVfSdkI7MUY7xviMc0Iq1o=;
 b=bB+ToZTHqjgjvUENeAZzDmvV9kQFy8vk+QhA0ogyshgqRzLxPqtJMsPN5qb1Q5f23xtyIp8sbphWG48X6kHvzLF42831z1BOnsy23mp3R1Ft+vBSmVDd8J8//sSw8TyhBNVeIkSGa0qhJ5Ol/0DcPaDvS+s4Ud8HULGtSojEgTc=
Received: from DM6PR06CA0051.namprd06.prod.outlook.com (2603:10b6:5:54::28) by
 BY5PR12MB4033.namprd12.prod.outlook.com (2603:10b6:a03:213::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Mon, 12 Jun
 2023 04:53:33 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com
 (2603:10b6:5:54:cafe::a4) by DM6PR06CA0051.outlook.office365.com
 (2603:10b6:5:54::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:53:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:53:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:53:32 -0500
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
Subject: [PATCH RFC v9 45/51] KVM: SEV: Implement gmem hook for invalidating private pages
Date:   Sun, 11 Jun 2023 23:25:53 -0500
Message-ID: <20230612042559.375660-46-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|BY5PR12MB4033:EE_
X-MS-Office365-Filtering-Correlation-Id: e5dfa6b3-63fc-4e73-ad9b-08db6b00f95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CcduQt2Zpch0HP3FPh+ToWmsS9MZaye7g2VwFR3+IEo864sV4H0DUKFBuJHsf1RGkzjwo/umEnCy0OnfsojR2Q/c4wES/YOj3o4du7n6b2tLNMkeEaByJz9pYbphkQfHHEAfqa6cLmTPZ+MFtEGKVPvOtLfy3O+/5h58w0+CiyLSFk1BdRBYGn5yktMltMVdFe+THcBkIos1s4u8A4wQ91RJgiKzuFBol1fqxFcrdgc3cEEizrNZGbVCkGsONU8AyLOrqijW35vycipghflrWR4NAxmpw5uYbb30G1yUfjM/3k6Mk+7p8hc62aM0QMZ+qfKPquZpndjGmnpK/ALYodPaQz0bSruT+WOPlfIV+bWMuER97u4K0r0+7VnMz49nC8BnAiC3pLgbi87zv63mmKQdjEbuAEL5Mp5r85IbUe7iy5YwJQAjEjnoN9o6HJSnqGy5CmOwpRgjIVrESAIm7l6KD1j+k6tqMe45tUno9VuoMTtSf/TIZj5iexNWzfLgRvb0XPp5XSkrUbx/rq8VllAKmPPAMbSSkMDDX7oyxEcpgCVXAbjXmqo00Q0kTH6Gr383tBS9lC7rTxSw9svZQYXZYau+DXOzEqx62egIamfi7mcIsO/LmlHBpEJHPc9AdFk3FoJd9qu29aAPhQrpw+tFHIOwumOTrJh64Esl4TxvvdSVw9AIRUvFZ7EBvjyOBDeBQ7T355eKAql+igUNTKNsQYu5tjwcS3TGlfvtbDsI4uAQSDSICB6QoNVU0zeANazb8badDm/qNpone7txuA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39850400004)(346002)(451199021)(40470700004)(46966006)(36840700001)(36756003)(2906002)(44832011)(82310400005)(5660300002)(7416002)(7406005)(86362001)(40460700003)(83380400001)(40480700001)(6666004)(47076005)(426003)(1076003)(186003)(36860700001)(16526019)(336012)(26005)(356005)(478600001)(82740400003)(81166007)(54906003)(70206006)(6916009)(316002)(2616005)(41300700001)(4326008)(8936002)(70586007)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:53:32.9292
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5dfa6b3-63fc-4e73-ad9b-08db6b00f95a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4033
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement a platform hook to do the work of restoring the direct map
entries of gmem-managed pages and transitioning the corresponding RMP
table entries back to the default shared/hypervisor-owned state.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 45 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c5a1706387bf..543926fa3200 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4117,3 +4117,46 @@ int sev_gmem_prepare(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	return rc;
 }
+
+void sev_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end)
+{
+	kvm_pfn_t pfn;
+
+	if (!sev_snp_guest(kvm))
+		return;
+
+	pr_debug("%s: kvm %p pfn 0x%llx pfn_end 0x%llx\n",
+		 __func__, kvm, start, end);
+
+	for (pfn = start; pfn < end; pfn++) {
+		int rc, rmp_level;
+		bool assigned;
+
+		rc = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+		if (rc) {
+			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry for PFN 0x%llx error %d\n",
+					    pfn, rc);
+			continue;
+		}
+
+		if (!assigned)
+			continue;
+
+		/*
+		 * If PFN is currently assigned as a 2M page, PSMASH it into
+		 * individual 4K RMP entries before attempting to convert a
+		 * 4K sub-page.
+		 */
+		if (rmp_level > PG_LEVEL_4K) {
+			rc = snp_rmptable_psmash(kvm, pfn);
+			if (rc)
+				pr_warn_ratelimited("SEV: Failed to PSMASH RMP entry for PFN 0x%llx error %d\n",
+						    pfn, rc);
+		}
+
+		rc = rmp_make_shared(pfn, PG_LEVEL_4K);
+		if (rc)
+			pr_warn_ratelimited("SEV: Failed to update RMP entry for PFN 0x%llx error %d\n",
+					    pfn, rc);
+	}
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9085a122907c..1390e47d0aa5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4936,6 +4936,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0438f52e4396..0d4c29a4300a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -772,6 +772,7 @@ void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
+void sev_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 
 /* vmenter.S */
 
-- 
2.25.1


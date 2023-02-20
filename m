Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA67C69D39F
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbjBTTA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjBTTA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:00:26 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3113E448E;
        Mon, 20 Feb 2023 11:00:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bx/oVMYN50rwy3n67GbfW0YlvimcydZ7aJJLylq1zAnU0fCFuqutyFn7EM34bT2z3bP0M/5y1RCDtbQK1CJ0uRYNoNF1F12zsL9nIxTjZXHyMm9r8cpI2rcfOr2hXI5iYG7KXDN0xY6l/Uxzl4aOzHhceoZ2Py0axp19HyGgMYNkAUAoG34Cm+sq8GguQOeFKVeKFm47qPJYoeUh+k0DHo8PXCWm1yz3Omqw1iKLmzxLF2msp98jwXTGmSYN6hqTb6nO34VjmMoQQZclDuswI6JUxSxADBSEnfc1fqgCWCSPm0npSBkdi32NAlZjoVh4dTkNsBwKXEABAoGOXowmXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnSphTWBNbwGmWsTY+YjMyKJE+TqSxm46nIWpnun/yg=;
 b=gq9IIMntuMVcdGcvKHW/WnpqXmniggtgmlNqcRkoZNF58usVdSWeqHQwrVGYothUjWuImuqpN0bPnts4IlF2A12TCT38WvjOgQLWn0oJ9pHFlMyiLU/+XVLxGlhqxm8gQZ6YMKN8BJunYyIBrU27kxj9VxNyPq6f4n6KnwWDkV9qjvNu7u7tUVBBoaGnZJYwo0l6+D7yRMqjbDexs0f0nDg+l+Ahg35biTLAyDmTckt185ImJBUefmsJJlDn3YKMTehrmyZoceCumVE7sbIvLZQmDRLDsX55qh++gk6iMMI0T8beDU0gThyRvdWtE++d3ivVnUuQm5JGgQwG7xk3TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnSphTWBNbwGmWsTY+YjMyKJE+TqSxm46nIWpnun/yg=;
 b=PjZObEk981RiCaSHEjid0Bo4fifOIg4o1ZlsQ9aK+4RFjEvhnSMsbEvM2ldcOHwkhDWCtINK52Y1vwtLa4scdMNPb8emWi0GQM0PSWGDpJahfiGjA7b8vpt/r+MxliDjlp0wpXfVPEjop/fP4AnW43is0p4UcsbSml+6OEJ2R3E=
Received: from MW4PR04CA0135.namprd04.prod.outlook.com (2603:10b6:303:84::20)
 by BN9PR12MB5036.namprd12.prod.outlook.com (2603:10b6:408:135::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:58:57 +0000
Received: from CO1NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::61) by MW4PR04CA0135.outlook.office365.com
 (2603:10b6:303:84::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:58:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT086.mail.protection.outlook.com (10.13.175.73) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.20 via Frontend Transport; Mon, 20 Feb 2023 18:58:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:58:55 -0600
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 50/56] KVM: SEV: Handle restricted memory invalidations for SNP
Date:   Mon, 20 Feb 2023 12:38:41 -0600
Message-ID: <20230220183847.59159-51-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT086:EE_|BN9PR12MB5036:EE_
X-MS-Office365-Filtering-Correlation-Id: 2077a6bc-7a03-445b-49e1-08db13748497
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tciTx6DkaeYjeG1TlzwJW1Ucx4P+B9OZk3Kq7MbMYnhNfXViEKkZT/wGz/LwFgjB/vZvZ8LuKOU91vFqBBZfz1eFIQkKfcTsnGTOcWHZvJ/Jtgo6aoJJRq0S468GJN+YwwGApRoeSfPo9K6OlXmiHzHAgyirNJeS4gb97MBi0QsfzqhNTWhVhX+lrw30kWXBiGXrg6+e7mSKnJ6CiOw9V8w7d0fM3hkADuNZgHnhhqYgLDE/nf+2Aow8sp1XnFiU1YE1mYNlG8rcN6/eU8UbqNmpiMQZr/BfjSIcFSx2ZGNplhAoYF3fpDZnUPRoTUUB2vc1VwtTCRJXNOtZnBXRQbWOWY56LHiYOeznHE2Z9g67kpWv4+9GdJiimf1IcJCKjXn+LkpgphNPANq4NKtojuaLA00AU/UMoftWR+H8Yyc7m6uqKQOnagWC8heNISNMF6LtXT/mUixCwSTI6IRlw9DpOKB8ESMbHmoRdnTq+7o39xfPhueqtsw9RxopMv51sTPevOrgt4cRsqX1wRV8Bh6FgdSohMc5VMmH0Po22GZFzL67i+3+vkzyGRq66kO9+30afs4sA5pXycg9dTwhgAPF5sFz7nduY+12QE85oNvky4QgDw37N7lHcMRn5HdSEK+EZHlNsXL8ganRRy2Airw9k9OZNHd6KsTRgyM4CNWB/CskurNJRe6M0qKTHw/+cJ2QnoE2BtAgDhejfLAxVw3WpCm3IPwBvNZ/ildkIf8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199018)(40470700004)(36840700001)(46966006)(8936002)(2616005)(36860700001)(7406005)(7416002)(5660300002)(336012)(4326008)(47076005)(82310400005)(8676002)(86362001)(70586007)(70206006)(6916009)(83380400001)(36756003)(54906003)(426003)(40480700001)(478600001)(316002)(40460700003)(41300700001)(26005)(186003)(16526019)(82740400003)(356005)(2906002)(81166007)(6666004)(44832011)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:58:56.3136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2077a6bc-7a03-445b-49e1-08db13748497
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5036
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement a platform hook to do the work of restoring the direct map
entries and cleaning up RMP table entries for restricted memory that is
being freed back to the host.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 62 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 64 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7a74a92cb39a..bedec90d034f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4509,3 +4509,65 @@ bool sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *priv
 
 	return true;
 }
+
+void sev_invalidate_private_range(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	gfn_t gfn = start;
+
+	if (!sev_snp_guest(slot->kvm))
+		return;
+
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_warn_ratelimited("SEV: Memslot for GFN: 0x%llx is not private.\n",
+				    gfn);
+		return;
+	}
+
+	while (gfn <= end) {
+		gpa_t gpa = gfn_to_gpa(gfn);
+		int level = PG_LEVEL_4K;
+		int order, rc;
+		kvm_pfn_t pfn;
+
+		rc = kvm_restrictedmem_get_pfn(slot, gfn, &pfn, &order);
+		if (rc) {
+			pr_warn_ratelimited("SEV: Failed to retrieve restricted PFN for GFN 0x%llx, rc: %d\n",
+					    gfn, rc);
+			gfn++;
+			continue;
+		}
+
+		if (order) {
+			int rmp_level;
+
+			if (IS_ALIGNED(gpa, page_level_size(PG_LEVEL_2M)) &&
+			    gpa + page_level_size(PG_LEVEL_2M) <= gfn_to_gpa(end))
+				level = PG_LEVEL_2M;
+			else
+				pr_debug("%s: GPA 0x%llx is not aligned to 2M, skipping 2M directmap restoration\n",
+					 __func__, gpa);
+
+			/*
+			 * TODO: It may still be possible to restore 2M mapping here,
+			 * but keep it simple for now.
+			 */
+			if (level == PG_LEVEL_2M &&
+			    (!snp_lookup_rmpentry(pfn, &rmp_level) || rmp_level == PG_LEVEL_4K)) {
+				pr_debug("%s: PFN 0x%llx is not mapped as 2M private range, skipping 2M directmap restoration\n",
+					 __func__, pfn);
+				level = PG_LEVEL_4K;
+			}
+		}
+
+		pr_debug("%s: GPA %llx PFN %llx order %d level %d\n",
+			 __func__, gpa, pfn, order, level);
+		rc = snp_make_page_shared(slot->kvm, gpa, pfn, level);
+		if (rc)
+			pr_err("SEV: Failed to restore page to shared, GPA: 0x%llx PFN: 0x%llx order: %d rc: %d\n",
+			       gpa, pfn, order, rc);
+
+		gfn += page_level_size(level) >> PAGE_SHIFT;
+		put_page(pfn_to_page(pfn));
+		cond_resched();
+	}
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 18e4a6c17d11..3fe5f13b5f3a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4862,6 +4862,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.adjust_mapping_level = sev_adjust_mapping_level,
 	.update_mem_attr = sev_update_mem_attr,
 	.fault_is_private = sev_fault_is_private,
+	.invalidate_restricted_mem = sev_invalidate_private_range,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 97038afa8020..857b674e68f0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -727,6 +727,7 @@ void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_update_mem_attr(struct kvm_memory_slot *slot, unsigned int attr,
 			gfn_t start, gfn_t end);
+void sev_invalidate_private_range(struct kvm_memory_slot *slot, gfn_t start, gfn_t end);
 
 bool sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 
-- 
2.25.1


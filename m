Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA31464D0E3
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiLNUPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiLNUOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:14:19 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB9F43875;
        Wed, 14 Dec 2022 12:05:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gigt4+OIWss4F3sckjVWigrt72JQJotc74gOljeW0gQqoP/hLGdGdqKPm/rrU0TaHEerlL1Z58Xq9BrUqu5RnyvgXTc5dNFix0CdLx4CRZuXpO4i382qYPudoa8OokSUOKSspzDNHuO4SS9TYOVEjs/lQXcDdGNn7Gc13qQ3CGJeVEMgY/RdK+IMZhhfrWb/JvtVWbG9aQj+ddSvQEMNlSTaos5GVhpORhR7CFgzBrNgat+dkDOVWzt19N+wy9dnVwKcvJuCm7goGk52C7hG3UGshKct/u5Py4oTsjgw4iG0WPlzkDyVdZWbZ97OWM7cNh5O5DpiqtX37oMLMzFXcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/OzKsfTHOxu0vZX+JKMUe8Rr1JlYN051/tKqUBDz3IY=;
 b=NGGL5/JQwESKhM2HneSqME7bmqQE3CkV1Xx6XRKhgavrM5GMofC09RGToOQMQQ6gqyXF4Cstgi0RhkPAA8JpSca9ZHzH4A/t8Gd6pm8lQkz7XXbrmdu3/W5+qNacEjXtmaVGG4gpcVSMK5563k0XWAuIRMQcwb3qGyyJZYhDawkroIzbmvszphgBKYfDeWCYiIVRYLeCWXMtn87pcSUtW53H6JeWp5FsR5UaiwiG14JezjSZfDBCcGkBMf+HnXwBpdOAPsbUJKPigegCTyoxkEbsu8bqTuxr7ZIubTQTYLnzdWbf1LMh4bRox3wTZO1UXxrSL5P1baYZYxcaXMiR8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/OzKsfTHOxu0vZX+JKMUe8Rr1JlYN051/tKqUBDz3IY=;
 b=zy7KyVxWzEu86uKX/u6TQ0jcyLO2kfojrlVWBMOod2JBV226AQ0ITemRBgFRUYE8F2WFq8rEOw5d2/KIsnbVT5+QYIBXceLM2G5YQjfCFslF/zpNNvlD6hEc1Xns8nx4z96Xpm03415vaIi1IShIkcR6RBQ05fCW4nZ1IPgAMuI=
Received: from MW4PR03CA0113.namprd03.prod.outlook.com (2603:10b6:303:b7::28)
 by MN0PR12MB5810.namprd12.prod.outlook.com (2603:10b6:208:376::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:05:18 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::99) by MW4PR03CA0113.outlook.office365.com
 (2603:10b6:303:b7::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:05:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:05:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:05:16 -0600
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
Subject: [PATCH RFC v7 57/64] KVM: SEV: Handle restricted memory invalidations for SNP
Date:   Wed, 14 Dec 2022 13:40:49 -0600
Message-ID: <20221214194056.161492-58-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT061:EE_|MN0PR12MB5810:EE_
X-MS-Office365-Filtering-Correlation-Id: cf9aa6fd-dbca-4888-59ac-08dade0e85a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lSuHogvfbQhYnoZB0cs2NqUtiSUv8xndLHEOwrbfFJMuPdA700rGJsuWEVb/2n89tEdYoxpVHbepcF2HFXd6EGJ11/3MSsW6XSMcROjGZlCv80uJTz4AoGZBw7TUpnPBXylGruXNE/piQa1SAFyRV2iNbB2pkl9IIxpYBEBbcoQvc8GA1NtRPR/Xp+4FklAhKF3/h+HaOdh4SFQL7CVjlDY4b+j12JfxCmV2QVyxx3NZgX7UiPeiJ188mEHDJp3Tq43SpxmebIRErYzFGjejd+pXQCxLZSvZ9VUlBxf5Mkw97IV8Wcaw4TmzSoVsBclSPdeqAmLGx6Y8G4yetI1ztALDGxTxmZkelifFD128J/KWZbV9g5l12nTUwp2KjhejgFzf1Wul4p1ZUolw6X+IHprLMv0IelrwzXZIRWrqFMj6r+/11EBp4a2R0R1Ty5EqBSoRXFcYDfIXBQDf/DtT0wtQElkqazF5wRla7OcwGhvQWDs+bV9MVnXXtCvRx+hxSH/ZjGt7w/PPFN19Vj68oPNiz8v3E440zweh+5GtDEE3SMWRWPwneJ/tZDj0YG990YNC+Dm3fD0CgzyZ2ayW9lm3A1xE5YNRzDS5KQd792sYnXNCL3kOZ6Pmf+4uBjsc7n0HataOO/1kT2jbeFwkY0/S/YhWaI4NvkrM+hEwOIy/mpi3sn+4PTUs59TILHHHGQa0NMb9en6PBJcZFYdt4qo9iR/gyl7ktRc/9LDQfRw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(36756003)(6666004)(40460700003)(6916009)(54906003)(316002)(81166007)(8936002)(478600001)(82740400003)(82310400005)(356005)(1076003)(336012)(186003)(2616005)(26005)(40480700001)(16526019)(83380400001)(5660300002)(70586007)(86362001)(44832011)(7406005)(70206006)(4326008)(2906002)(426003)(7416002)(8676002)(47076005)(36860700001)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:05:17.7989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9aa6fd-dbca-4888-59ac-08dade0e85a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5810
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/svm/sev.c | 64 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 66 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0dd3d9debe48..8783b64557e5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4557,3 +4557,67 @@ int sev_update_mem_attr(struct kvm_memory_slot *slot, unsigned int attr,
 
 	return 0;
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
+	while (gfn < end) {
+		gpa_t gpa = gfn_to_gpa(gfn);
+		int level = PG_LEVEL_4K;
+		int order, rc;
+		kvm_pfn_t pfn;
+
+		if (!kvm_mem_is_private(slot->kvm, gfn)) {
+			gfn++;
+			continue;
+		}
+
+		rc = kvm_restricted_mem_get_pfn(slot, gfn, &pfn, &order);
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
+			/* TODO: It may still be possible to restore 2M mapping here, but keep it simple for now. */
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
index 6cf5b73f74c1..543261c87eb3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4873,6 +4873,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.rmp_page_level_adjust = sev_rmp_page_level_adjust,
 	.update_mem_attr = sev_update_mem_attr,
+	.invalidate_restricted_mem = sev_invalidate_private_range,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5f315225ae4d..277f53c903c2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -743,6 +743,7 @@ void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_update_mem_attr(struct kvm_memory_slot *slot, unsigned int attr,
 			gfn_t start, gfn_t end);
+void sev_invalidate_private_range(struct kvm_memory_slot *slot, gfn_t start, gfn_t end);
 
 int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 
-- 
2.25.1


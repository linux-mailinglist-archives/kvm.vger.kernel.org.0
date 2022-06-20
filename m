Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA94D5527D6
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346332AbiFTXMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345657AbiFTXMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:12:03 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561DB2656B;
        Mon, 20 Jun 2022 16:10:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWVSNR/V6XvJTAR1uyLyoTEMLGCb7xbku7zL9xTXqKaqE1g4nVeirMAIq6CDd6p/pGbwHqnfZqXFgstSaaM3Qeb25SvKkffJaO7d1wxfaLRiyi7pGRNz69TZdi/M5iIO9z0X7VpsB8zSmnqGmznYS/WP+pjgLS7AiArjnrln6GQomCTJWJx6jbIdk6SvRwNWJcV+RGVwZXo6ImHYWCYGsaxhssnG75A5tbLrXD0AdqHj70AB1E++6I8wGu7V7gfZljO+FxVOzd1VC4fH5r7SrrKnfkdFoNYnxgDrb4EAWvPW86BPujZnJgVQfbr3vUAqjYpUN0+Bw7Wpj11BUlOsMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JMLgkVDvhzMk7w43N7Ul4IJDstTk91YQUuH7g0xi1A=;
 b=NGt/nKPxz9aoghB7GGIBFIDNNgNSR0oSd6/z0BODxdFMd7+QYKLTNCaUCBNhygFWCVQIpNDu5sHFJgZza4+6o4H7DL5x/kdlxTNMBFCU4/ak2CuChpBXg5jahjE9AzR3O4kDSSXbRZIgAtPDFR9rS1C/WLZZ6h12kdAtxZOxidT9ihBZ7ixJru0B/eOlNHnQHdb8LCRema+GwbBRUtNNdERr/SsnK2Jmjv8d/hlKuRILhCXcvUn/ZTd9yLBFto+a1fKbEWZT6VEIlO5sx53UKI4LzBHct+c/Z0mylhIEZwxvHfDB0t1BOamTXpcEfHlI5tiTP3zMzgikZORbgCoVvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JMLgkVDvhzMk7w43N7Ul4IJDstTk91YQUuH7g0xi1A=;
 b=OHLs2+nP6m0DLt1SDuWdeemHeGHHbWVOIzGYODqbKUIP9peYHLH9WJ6uOm6Fyh5Oj0WNdT+ulWiK4ft8ZR8O7vEkFJ7Uf3x5ZnFI1eHTiVkCMZcm6Us59tOk6Ds5bwXZ8nm/WnQom1KRcZi+vK0tSxjpH+3b0y3cznA2J7fKmPg=
Received: from DS7PR03CA0105.namprd03.prod.outlook.com (2603:10b6:5:3b7::20)
 by BN8PR12MB3380.namprd12.prod.outlook.com (2603:10b6:408:43::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 23:10:38 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::ae) by DS7PR03CA0105.outlook.office365.com
 (2603:10b6:5:3b7::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:10:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:10:38 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:10:35 -0500
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
Subject: [PATCH Part2 v6 34/49] KVM: SVM: Do not use long-lived GHCB map while setting scratch area
Date:   Mon, 20 Jun 2022 23:10:26 +0000
Message-ID: <c5125b9135bfbb0ddd113bdf4a1efd74e8c91c59.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 08acb551-e3b5-411a-1edf-08da5312170e
X-MS-TrafficTypeDiagnostic: BN8PR12MB3380:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB33805418BC3557781746BDEB8EB09@BN8PR12MB3380.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dXh+Uj4QoD+bereIe9VZH4MUltN/lzUaxh3YqNXbXM8tTbVb+Gah3pY/mKt2GC6vLhBSGPqlAaRxnBZxL8N5zTLqyO/t/LoUBU5l7VgpJYN5fFyeFxSGx8Rv+EfJ/p7hQKMQD3gIBS2MyKS489KVIfL5GwjJUYtuxfNrQj5ySnHJOhAKYtIZxQYwKrmoBcjGQrE3qZoQZG/UvakVup4aV2MZdgfQfJPTmwYOILtIBJ/45MaUQsTKBNwgwu8vm2J3jMtAiUOKn2vmuAzDqcWbn0fxUuf5n4cpwHjLMzQzjfveubgP+ylVbMThGOi/Hf88jRL2XGNcpmBf3y2yi37duhNZS7OR6KNLjvxqy5ryyoeqzSi29SxhYC/lWsmum101dNGi8yzq8yVt7JgFnLjU+LHxN6NSGVKO6yDmn3SLIHTTnDkIKhCt5heRcf3TowhpgCdYwrYDYOLSKBdfPQ1fO8ah4QujkgVEb73XLJUwadaZZ/z5XXEiiMJ8HmdainGt/+ZnpVPmicnVMWIWf5ttxtlsXKtQTa8AbS56vdl6uxzCtX4jHPF/MJvFbKtAZGJdnSrFwIBNq18H1CuNbXW8NimNTwEkZuQiJo3noxoyidrZD8qGzCR7Zx5jb+ZTLTlORsQWZmgUq5NR5X+dX1p0Mrwhz0WnzXXFB0LdXdlXMxpqCF6K4vkSdWlLWSAmsCwsFARTfTtltdPggqmLc8ugINPjIxadA/3SWHxqEabZmf6q4OuzhcZJyBkTQHZhkLCgvoNKv0QF0SFqxag8o+j7tA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(376002)(346002)(36840700001)(46966006)(40470700004)(186003)(41300700001)(26005)(36860700001)(2906002)(6666004)(40460700003)(36756003)(7696005)(478600001)(81166007)(82310400005)(8676002)(110136005)(54906003)(316002)(5660300002)(8936002)(7406005)(7416002)(47076005)(70206006)(40480700001)(70586007)(4326008)(356005)(16526019)(82740400003)(336012)(86362001)(83380400001)(2616005)(426003)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:10:38.6727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08acb551-e3b5-411a-1edf-08da5312170e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3380
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The setup_vmgexit_scratch() function may rely on a long-lived GHCB
mapping if the GHCB shared buffer area was used for the scratch area.
In preparation for eliminating the long-lived GHCB mapping, always
allocate a buffer for the scratch area so it can be accessed without
the GHCB mapping.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 74 +++++++++++++++++++-----------------------
 arch/x86/kvm/svm/svm.h |  3 +-
 2 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 91d3d24e60d2..01ea257e17d6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2820,8 +2820,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_page(virt_to_page(svm->sev_es.vmsa));
 
 skip_vmsa_free:
-	if (svm->sev_es.ghcb_sa_free)
-		kvfree(svm->sev_es.ghcb_sa);
+	kvfree(svm->sev_es.ghcb_sa);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
@@ -2909,6 +2908,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
 	control->exit_info_2 = ghcb_get_sw_exit_info_2(ghcb);
 
+	/* Copy the GHCB scratch area GPA */
+	svm->sev_es.ghcb_sa_gpa = ghcb_get_sw_scratch(ghcb);
+
 	/* Clear the valid entries fields */
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
@@ -3054,23 +3056,12 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 	if (!svm->sev_es.ghcb)
 		return;
 
-	if (svm->sev_es.ghcb_sa_free) {
-		/*
-		 * The scratch area lives outside the GHCB, so there is a
-		 * buffer that, depending on the operation performed, may
-		 * need to be synced, then freed.
-		 */
-		if (svm->sev_es.ghcb_sa_sync) {
-			kvm_write_guest(svm->vcpu.kvm,
-					ghcb_get_sw_scratch(svm->sev_es.ghcb),
-					svm->sev_es.ghcb_sa,
-					svm->sev_es.ghcb_sa_len);
-			svm->sev_es.ghcb_sa_sync = false;
-		}
-
-		kvfree(svm->sev_es.ghcb_sa);
-		svm->sev_es.ghcb_sa = NULL;
-		svm->sev_es.ghcb_sa_free = false;
+	 /* Sync the scratch buffer area. */
+	if (svm->sev_es.ghcb_sa_sync) {
+		kvm_write_guest(svm->vcpu.kvm,
+				ghcb_get_sw_scratch(svm->sev_es.ghcb),
+				svm->sev_es.ghcb_sa, svm->sev_es.ghcb_sa_len);
+		svm->sev_es.ghcb_sa_sync = false;
 	}
 
 	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->sev_es.ghcb);
@@ -3111,9 +3102,8 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	struct ghcb *ghcb = svm->sev_es.ghcb;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
 	u64 scratch_gpa_beg, scratch_gpa_end;
-	void *scratch_va;
 
-	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
+	scratch_gpa_beg = svm->sev_es.ghcb_sa_gpa;
 	if (!scratch_gpa_beg) {
 		pr_err("vmgexit: scratch gpa not provided\n");
 		goto e_scratch;
@@ -3143,9 +3133,6 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       scratch_gpa_beg, scratch_gpa_end);
 			goto e_scratch;
 		}
-
-		scratch_va = (void *)svm->sev_es.ghcb;
-		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
 	} else {
 		/*
 		 * The guest memory must be read into a kernel buffer, so
@@ -3156,29 +3143,36 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       len, GHCB_SCRATCH_AREA_LIMIT);
 			goto e_scratch;
 		}
-		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
-		if (!scratch_va)
-			return -ENOMEM;
+	}
 
-		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
-			/* Unable to copy scratch area from guest */
-			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
+	if (svm->sev_es.ghcb_sa_alloc_len < len) {
+		void *scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
 
-			kvfree(scratch_va);
-			return -EFAULT;
-		}
+		if (!scratch_va)
+			return -ENOMEM;
 
 		/*
-		 * The scratch area is outside the GHCB. The operation will
-		 * dictate whether the buffer needs to be synced before running
-		 * the vCPU next time (i.e. a read was requested so the data
-		 * must be written back to the guest memory).
+		 * Free the old scratch area and switch to using newly
+		 * allocated.
 		 */
-		svm->sev_es.ghcb_sa_sync = sync;
-		svm->sev_es.ghcb_sa_free = true;
+		kvfree(svm->sev_es.ghcb_sa);
+
+		svm->sev_es.ghcb_sa_alloc_len = len;
+		svm->sev_es.ghcb_sa = scratch_va;
 	}
 
-	svm->sev_es.ghcb_sa = scratch_va;
+	if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, svm->sev_es.ghcb_sa, len)) {
+		/* Unable to copy scratch area from guest */
+		pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
+		return -EFAULT;
+	}
+
+	/*
+	 * The operation will dictate whether the buffer needs to be synced
+	 * before running the vCPU next time (i.e. a read was requested so
+	 * the data must be written back to the guest memory).
+	 */
+	svm->sev_es.ghcb_sa_sync = sync;
 	svm->sev_es.ghcb_sa_len = len;
 
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7782312a1cda..bd0db4d4a61e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -197,8 +197,9 @@ struct vcpu_sev_es_state {
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
 	u32 ghcb_sa_len;
+	u64 ghcb_sa_gpa;
+	u32 ghcb_sa_alloc_len;
 	bool ghcb_sa_sync;
-	bool ghcb_sa_free;
 };
 
 struct vcpu_svm {
-- 
2.25.1


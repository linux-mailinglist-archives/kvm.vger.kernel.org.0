Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF8464D0AB
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiLNUF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLNUE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:04:59 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A173057F;
        Wed, 14 Dec 2022 12:00:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9jkOBj5cr1cVto/bdHE+v3hmjA9Mu5jyV+GJr6D7zw7dSqVO1UqpMngts226gCy2WkljSMmPjHx2Np+l962b7Tvs/4oDxmV/ihtZIc2iRGbqk9BVsWWCgEnXcTCt+RsLawCWexF4vxev3AItbygNanZJJ0VriQvUKmKeaN6kL67cX3O45xmoUVI6GwlKYZgH3DUlpXr8rmQPTtcqIVYAZ0gl7fGcbsZnsPSx4KEdL45s98ovRt2p331vpRba1iT08yl/1C4mfjiLHVHKvCkPYXb1POT/CS53Z0HmrWgMUJKaeSXN9wjubbo/xh3O9iArMCMys8869aE4gKjAEnfbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCxIbVtnyduFHme2CiqX7FQyEIL4D6z/zq075hUxUxc=;
 b=FKYNKftZ1TpaMUTUrVuNE6Ta+z1LhbNmZv3E/Wvd7z4L5KNDYNRipKttXsry+9m4bCeeZJkGJz/DKWbubJDigLOQ8qkcZyM1C5k4yBoJnOJ+RRqgrfZfqsLDaCZAfxjCoYmDEXYKGmLtdr5zsTkYYe5QcgVoxNnHEMvftkWaENBlpnzNpDI7zzs1848QEFP7KXeKQzWm2i/fmmFLkSIF0kI/nbS8eE6g1gNWNnq3nZsA7t4i1PErBXpNdoqhESfCgmkjTQfE2YB0+289uGF0rzlNShlRA5ek3tEYcjRzmeoTI/yHLGuRpUpeGG3umijdkoVwbS9xsGeLqWR9ugGG6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCxIbVtnyduFHme2CiqX7FQyEIL4D6z/zq075hUxUxc=;
 b=t126Cxc5Xu/k1oljfLZI7BCc3Fmsd7zBTZM1xJsC7RKWF9Bd5KBKejeT1SMUtcT870u+KL2Ya/WM9yhlT1JK1cPwPOeuck4g4sobWw4esPzPBoUAdAc5LNJf+X+IiSLZGzKvNsoAXXd8mZTIeYDV31XeyKSBxlpapkWti+LeACY=
Received: from CY8PR12CA0012.namprd12.prod.outlook.com (2603:10b6:930:4e::10)
 by CH3PR12MB8403.namprd12.prod.outlook.com (2603:10b6:610:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 20:00:05 +0000
Received: from CY4PEPF0000C96C.namprd02.prod.outlook.com (2603:10b6:930:4e::4)
 by CY8PR12CA0012.outlook.office365.com (2603:10b6:930:4e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:00:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96C.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 20:00:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:00:01 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 43/64] KVM: SVM: Do not use long-lived GHCB map while setting scratch area
Date:   Wed, 14 Dec 2022 13:40:35 -0600
Message-ID: <20221214194056.161492-44-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96C:EE_|CH3PR12MB8403:EE_
X-MS-Office365-Filtering-Correlation-Id: a7c49e37-5d7a-42fd-8f35-08dade0dcb00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VY6oyxhYEyUZlZRtOO5CzC46Fhsku/C6FTmY5afWzVsL/93v7MJ5SSrPvPVFfQMPB7H11nsQb4hB8MGLvNTGbNzUxd9ZJhLAt8S8Lext1Yt1RUu+tyxdcVhwOjlVUAk1aYCn54XN8x3DiEBRfhToJXQpp+fUSKXpLFaIGgid06nBpybERr1n0K5fe7aw5zaxyas18k7DsT3ifS6BedmyHehxx8IpFiYThJx+kSApMoHjyYdRN79gR0niZ1QWOr8PJlEUtfNt39XJIIvw3xyQY1Z/or+ytH0DMWNo+SHqgbLE3E0DctGRtelAbo/i5CYOZSQSCvkDBpPHtO7x1MXCUwMnAbbCBhsw6mZcQXNRkUhjtnWRKRSyHpfaBHkDIg0+qQM5iUmTv+bQ5IKlT+xCir7hAJr82Cgj3BwS6bKxIsL+LiFYcKeLUu2l+mhAvtntjfWZcbr402U+lELmVhKPF8e+k9rjeAzx8y6qgP1kM53RWcUy6NonGkKIZPu3o5zo4QB7IvCKdzJ+I0JyIjoTQshbGQoQGJkQXY2gm6Fw8dxD3eua2nPHUPJukzmENwiW4vUUajqt725wP6PR0xxSe1go4zZt0xt892gjmY3CCwu5R9n1bqXHjLPJ2tt2xFbPpoGBDQ2tiKcInTsOs/LTvduFyghid5ZoYYsGThNYOfRfGfsbzd2PK9R2x0JWEiLqEeu1JAbi3rQgAzS+Vru5EJ+g5gWXtUK4h6dnKtgfoHE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199015)(36840700001)(40470700004)(46966006)(6666004)(478600001)(82310400005)(82740400003)(86362001)(186003)(26005)(356005)(81166007)(54906003)(47076005)(36756003)(8936002)(6916009)(2906002)(426003)(316002)(41300700001)(336012)(16526019)(36860700001)(1076003)(83380400001)(7406005)(44832011)(5660300002)(40460700003)(7416002)(2616005)(4326008)(8676002)(70206006)(70586007)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:00:04.7004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c49e37-5d7a-42fd-8f35-08dade0dcb00
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8403
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 74 +++++++++++++++++++-----------------------
 arch/x86/kvm/svm/svm.h |  3 +-
 2 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 443c5c8aaaf3..d5c6e48055fb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2918,8 +2918,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_page(virt_to_page(svm->sev_es.vmsa));
 
 skip_vmsa_free:
-	if (svm->sev_es.ghcb_sa_free)
-		kvfree(svm->sev_es.ghcb_sa);
+	kvfree(svm->sev_es.ghcb_sa);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
@@ -3007,6 +3006,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
 	control->exit_info_2 = ghcb_get_sw_exit_info_2(ghcb);
 
+	/* Copy the GHCB scratch area GPA */
+	svm->sev_es.ghcb_sa_gpa = ghcb_get_sw_scratch(ghcb);
+
 	/* Clear the valid entries fields */
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
@@ -3152,23 +3154,12 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
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
@@ -3209,9 +3200,8 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	struct ghcb *ghcb = svm->sev_es.ghcb;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
 	u64 scratch_gpa_beg, scratch_gpa_end;
-	void *scratch_va;
 
-	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
+	scratch_gpa_beg = svm->sev_es.ghcb_sa_gpa;
 	if (!scratch_gpa_beg) {
 		pr_err("vmgexit: scratch gpa not provided\n");
 		goto e_scratch;
@@ -3241,9 +3231,6 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       scratch_gpa_beg, scratch_gpa_end);
 			goto e_scratch;
 		}
-
-		scratch_va = (void *)svm->sev_es.ghcb;
-		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
 	} else {
 		/*
 		 * The guest memory must be read into a kernel buffer, so
@@ -3254,29 +3241,36 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
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
index ae733188cf87..f53a41e13033 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -209,8 +209,9 @@ struct vcpu_sev_es_state {
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


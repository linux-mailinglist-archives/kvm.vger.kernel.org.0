Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E58E64D0B1
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiLNUHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLNUGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:06:32 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AE831EDC;
        Wed, 14 Dec 2022 12:00:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmaElLjjiAwlNCrghI81tY5yGxUhBH4Z9zzacvVykyMncHxnAgq7+NC9Ov5BMVtce/AZNyD0hTKopqphIx4cGujotOdhNv0R2Vhuj3Xx5W/irl56o0N22mGWu7jZVEolW//kDsua41yIwUwAt7GphGf62NeRaTskzRzqvZJWlDx3qrXdPjInEsPr71Tib6olilIpa/RU3jKoFnrOA1Nsy8NAupbiHZ47Yt698gD4ePCEQupVyiS8j2gnfUyt1cFnB6G5+Yzd45rwT5mRbtT5QeQAm64P2xofAD7ZtnX5C4LAzyf0E7eAh7XO2DpSl9x6cBPpLIUlRW4t9AIPviEAqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZPzzzS3Y+e+/+jr7Ajwo0zlhoYfxqq2qCs0alPROMw=;
 b=mSZdRHkewFcTwbiURQCYcgNEkFiOlHlnJrPHVcZOUKWp28YtKeb75ExhDB31sYd+C5TXOzTHQlUwV874E1XzaOyJ/eOnWn8aMfQ0P0mt8uAlstDnmh+sZZegojMQfoENGov5e11r5OssBlwBSiZLByMDeP8PMXVAGYhO1AOO215uTsGGLcqaAMLHRLpJCAaNMCY+xqU23fp6tP0hs9i7L7kyyOKHdZG6xGt+Siwd2sBcEbXjEMipWtxqZr7++5i142HXltF84gbeqtVExP4MLiP4JMygbH3DWpzjP6+33uSKneANRD4fGXsMLt+fyPHHIgYeiv2ii2es6ndUMnyy4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZPzzzS3Y+e+/+jr7Ajwo0zlhoYfxqq2qCs0alPROMw=;
 b=uNFYN/azD3N6h3VjCo+2iEvfNaY3p1HIEfPBLDn79YvJNBdAWObtgXM1HFeF4Y+hgzC2v5rohxLClSK4VTzB8tzTcECXXp8rdhnR7ufXy59mU6nfhEXTAWibrNQK6FsvJ5iTXf4o8EHIAp2dDniDbYp+O5ePyKwJFeqpSYLQ5nc=
Received: from CY5PR22CA0066.namprd22.prod.outlook.com (2603:10b6:930:80::13)
 by IA1PR12MB7640.namprd12.prod.outlook.com (2603:10b6:208:424::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:00:24 +0000
Received: from CY4PEPF0000C96D.namprd02.prod.outlook.com
 (2603:10b6:930:80:cafe::f) by CY5PR22CA0066.outlook.office365.com
 (2603:10b6:930:80::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:00:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96D.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.9 via Frontend Transport; Wed, 14 Dec 2022 20:00:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:00:22 -0600
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
Subject: [PATCH RFC v7 44/64] KVM: SVM: Remove the long-lived GHCB host map
Date:   Wed, 14 Dec 2022 13:40:36 -0600
Message-ID: <20221214194056.161492-45-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96D:EE_|IA1PR12MB7640:EE_
X-MS-Office365-Filtering-Correlation-Id: f221bda5-9c6c-4199-5cfe-08dade0dd654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qAcdgR5OShZQBebAPOzf50AorePaDhHuB9OglEEfy75jMexxbIFoXGBj2iGbHpgcaOC9aGyCHV7+xbMiH9YhUjDB0CEfbtFb03o+NOyGmzlj4TUx8Z3Lf5+xsqCA9BlIEip21HF8zRUbrymXY8bLdPzMjLbFD93lRhmxV1QqFLywTZc0pGvoI/294BWu3C6e0dfWXQp1yfO0Kb4DhI3lZeY9yoVe0mM09qDonwtTaA6hD8gsPh8lRUvkDybHVkKfo+mfT4BlrOP268+/SA9VtKrvHrgi0C5t8zcwYTtRxsMUjsa4nRJeQOYtsW6QsTr8b+JI1cBc2Pg3UeWmZAFwlCh7I1lv+8bHyIRXd1io4JATzBBKaZDFKKnOrSiu9aHwGsNoYGcAM0XUDj58P6iQmKoPGn0E0yx3bA+Uvsjur12xeWOxPNd0/4KrBb30jn+Dtfmrh8kNeipDi//RHY3kvwbeWRYOkj7f1xHhejyzQiBxBRVz9VU3eI4ytqnWd6DPgStARU7S/3kHLbrQ9kun9LGMQOyam1jDSBFI23fjFWqLs/gbTeF6spWRyrI5F+850xctvTZoeSc1HeaoPufENVSqOj/dHlq1kBqkMfAAvcU/RleFFfNDZldJqrGWbd3rnXVjPUzaxXANAgBmhVv1j0sy17IpNIXt8KuVQhUx+YOToZrnLSTNKy+0WW5zjiAourC7k3EdmtZzWvrMu5EHFmqpJTNQDAmgzzq9ocghuApYlM92QV/9GaR64xueNh42Wp3DtDpQg32J/fVijj1YLw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(81166007)(82740400003)(36860700001)(356005)(86362001)(316002)(40460700003)(4326008)(8676002)(70586007)(2616005)(6916009)(6666004)(7416002)(16526019)(5660300002)(8936002)(41300700001)(44832011)(47076005)(2906002)(336012)(1076003)(478600001)(186003)(54906003)(26005)(426003)(70206006)(83380400001)(30864003)(7406005)(40480700001)(82310400005)(36756003)(21314003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:00:23.6890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f221bda5-9c6c-4199-5cfe-08dade0dd654
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7640
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

On VMGEXIT, sev_handle_vmgexit() creates a host mapping for the GHCB GPA,
and unmaps it just before VM-entry. This long-lived GHCB map is used by
the VMGEXIT handler through accessors such as ghcb_{set_get}_xxx().

A long-lived GHCB map can cause issue when SEV-SNP is enabled. When
SEV-SNP is enabled the mapped GPA needs to be protected against a page
state change.

To eliminate the long-lived GHCB mapping, update the GHCB sync operations
to explicitly map the GHCB before access and unmap it after access is
complete. This requires that the setting of the GHCBs sw_exit_info_{1,2}
fields be done during sev_es_sync_to_ghcb(), so create two new fields in
the vcpu_svm struct to hold these values when required to be set outside
of the GHCB mapping.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: defer per_cpu() assignment and order it with barrier() to fix case
      where kvm_vcpu_map() causes reschedule on different CPU]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 131 ++++++++++++++++++++++++++---------------
 arch/x86/kvm/svm/svm.c |  18 +++---
 arch/x86/kvm/svm/svm.h |  24 +++++++-
 3 files changed, 116 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d5c6e48055fb..6ac0cb6e3484 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2921,15 +2921,40 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	kvfree(svm->sev_es.ghcb_sa);
 }
 
+static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
+{
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	u64 gfn = gpa_to_gfn(control->ghcb_gpa);
+
+	if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
+		/* Unable to map GHCB from guest */
+		pr_err("error mapping GHCB GFN [%#llx] from guest\n", gfn);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static inline void svm_unmap_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
+{
+	kvm_vcpu_unmap(&svm->vcpu, map, true);
+}
+
 static void dump_ghcb(struct vcpu_svm *svm)
 {
-	struct ghcb *ghcb = svm->sev_es.ghcb;
+	struct kvm_host_map map;
 	unsigned int nbits;
+	struct ghcb *ghcb;
+
+	if (svm_map_ghcb(svm, &map))
+		return;
+
+	ghcb = map.hva;
 
 	/* Re-use the dump_invalid_vmcb module parameter */
 	if (!dump_invalid_vmcb) {
 		pr_warn_ratelimited("set kvm_amd.dump_invalid_vmcb=1 to dump internal KVM state.\n");
-		return;
+		goto e_unmap;
 	}
 
 	nbits = sizeof(ghcb->save.valid_bitmap) * 8;
@@ -2944,12 +2969,21 @@ static void dump_ghcb(struct vcpu_svm *svm)
 	pr_err("%-20s%016llx is_valid: %u\n", "sw_scratch",
 	       ghcb->save.sw_scratch, ghcb_sw_scratch_is_valid(ghcb));
 	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, ghcb->save.valid_bitmap);
+
+e_unmap:
+	svm_unmap_ghcb(svm, &map);
 }
 
-static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
+static bool sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct ghcb *ghcb = svm->sev_es.ghcb;
+	struct kvm_host_map map;
+	struct ghcb *ghcb;
+
+	if (svm_map_ghcb(svm, &map))
+		return false;
+
+	ghcb = map.hva;
 
 	/*
 	 * The GHCB protocol so far allows for the following data
@@ -2963,13 +2997,24 @@ static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 	ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
 	ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
 	ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
+
+	/*
+	 * Copy the return values from the exit_info_{1,2}.
+	 */
+	ghcb_set_sw_exit_info_1(ghcb, svm->sev_es.ghcb_sw_exit_info_1);
+	ghcb_set_sw_exit_info_2(ghcb, svm->sev_es.ghcb_sw_exit_info_2);
+
+	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, ghcb);
+
+	svm_unmap_ghcb(svm, &map);
+
+	return true;
 }
 
-static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
+static void sev_es_sync_from_ghcb(struct vcpu_svm *svm, struct ghcb *ghcb)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct ghcb *ghcb = svm->sev_es.ghcb;
 	u64 exit_code;
 
 	/*
@@ -3013,20 +3058,25 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
-static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
+static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_host_map map;
 	struct ghcb *ghcb;
-	u64 exit_code;
 	u64 reason;
 
-	ghcb = svm->sev_es.ghcb;
+	if (svm_map_ghcb(svm, &map))
+		return -EFAULT;
+
+	ghcb = map.hva;
+
+	trace_kvm_vmgexit_enter(vcpu->vcpu_id, ghcb);
 
 	/*
 	 * Retrieve the exit code now even though it may not be marked valid
 	 * as it could help with debugging.
 	 */
-	exit_code = ghcb_get_sw_exit_code(ghcb);
+	*exit_code = ghcb_get_sw_exit_code(ghcb);
 
 	/* Only GHCB Usage code 0 is supported */
 	if (ghcb->ghcb_usage) {
@@ -3119,6 +3169,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		goto vmgexit_err;
 	}
 
+	sev_es_sync_from_ghcb(svm, ghcb);
+
+	svm_unmap_ghcb(svm, &map);
 	return 0;
 
 vmgexit_err:
@@ -3129,10 +3182,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			    ghcb->ghcb_usage);
 	} else if (reason == GHCB_ERR_INVALID_EVENT) {
 		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx is not valid\n",
-			    exit_code);
+			    *exit_code);
 	} else {
 		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx input is not valid\n",
-			    exit_code);
+			    *exit_code);
 		dump_ghcb(svm);
 	}
 
@@ -3142,6 +3195,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	ghcb_set_sw_exit_info_1(ghcb, 2);
 	ghcb_set_sw_exit_info_2(ghcb, reason);
 
+	svm_unmap_ghcb(svm, &map);
+
 	/* Resume the guest to "return" the error code. */
 	return 1;
 }
@@ -3151,23 +3206,20 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
 	svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NONE;
 
-	if (!svm->sev_es.ghcb)
+	if (!svm->sev_es.ghcb_in_use)
 		return;
 
 	 /* Sync the scratch buffer area. */
 	if (svm->sev_es.ghcb_sa_sync) {
 		kvm_write_guest(svm->vcpu.kvm,
-				ghcb_get_sw_scratch(svm->sev_es.ghcb),
+				svm->sev_es.ghcb_sa_gpa,
 				svm->sev_es.ghcb_sa, svm->sev_es.ghcb_sa_len);
 		svm->sev_es.ghcb_sa_sync = false;
 	}
 
-	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->sev_es.ghcb);
-
 	sev_es_sync_to_ghcb(svm);
 
-	kvm_vcpu_unmap(&svm->vcpu, &svm->sev_es.ghcb_map, true);
-	svm->sev_es.ghcb = NULL;
+	svm->sev_es.ghcb_in_use = false;
 }
 
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
@@ -3197,7 +3249,6 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
-	struct ghcb *ghcb = svm->sev_es.ghcb;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
 	u64 scratch_gpa_beg, scratch_gpa_end;
 
@@ -3276,8 +3327,8 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return 0;
 
 e_scratch:
-	ghcb_set_sw_exit_info_1(ghcb, 2);
-	ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
+	svm_set_ghcb_sw_exit_info_1(&svm->vcpu, 2);
+	svm_set_ghcb_sw_exit_info_2(&svm->vcpu, GHCB_ERR_INVALID_SCRATCH_AREA);
 
 	return 1;
 }
@@ -3413,7 +3464,6 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 ghcb_gpa, exit_code;
-	struct ghcb *ghcb;
 	int ret;
 
 	/* Validate the GHCB */
@@ -3428,29 +3478,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
-	if (kvm_vcpu_map(vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->sev_es.ghcb_map)) {
-		/* Unable to map GHCB from guest */
-		vcpu_unimpl(vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
-			    ghcb_gpa);
-
-		/* Without a GHCB, just return right back to the guest */
-		return 1;
-	}
-
-	svm->sev_es.ghcb = svm->sev_es.ghcb_map.hva;
-	ghcb = svm->sev_es.ghcb_map.hva;
-
-	trace_kvm_vmgexit_enter(vcpu->vcpu_id, ghcb);
-
-	exit_code = ghcb_get_sw_exit_code(ghcb);
-
-	ret = sev_es_validate_vmgexit(svm);
+	ret = sev_es_validate_vmgexit(svm, &exit_code);
 	if (ret)
 		return ret;
 
-	sev_es_sync_from_ghcb(svm);
-	ghcb_set_sw_exit_info_1(ghcb, 0);
-	ghcb_set_sw_exit_info_2(ghcb, 0);
+	svm->sev_es.ghcb_in_use = true;
+
+	svm_set_ghcb_sw_exit_info_1(vcpu, 0);
+	svm_set_ghcb_sw_exit_info_2(vcpu, 0);
 
 	switch (exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
@@ -3490,20 +3525,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			break;
 		case 1:
 			/* Get AP jump table address */
-			ghcb_set_sw_exit_info_2(ghcb, sev->ap_jump_table);
+			svm_set_ghcb_sw_exit_info_2(vcpu, sev->ap_jump_table);
 			break;
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(ghcb, 2);
-			ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_INPUT);
+			svm_set_ghcb_sw_exit_info_1(vcpu, 2);
+			svm_set_ghcb_sw_exit_info_2(vcpu, GHCB_ERR_INVALID_INPUT);
 		}
 
 		ret = 1;
 		break;
 	}
 	case SVM_VMGEXIT_HV_FEATURES: {
-		ghcb_set_sw_exit_info_2(ghcb, GHCB_HV_FT_SUPPORTED);
+		svm_set_ghcb_sw_exit_info_2(vcpu, GHCB_HV_FT_SUPPORTED);
 
 		ret = 1;
 		break;
@@ -3651,7 +3686,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		 * Return from an AP Reset Hold VMGEXIT, where the guest will
 		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
 		 */
-		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		svm_set_ghcb_sw_exit_info_2(vcpu, 1);
 		break;
 	case AP_RESET_HOLD_MSR_PROTO:
 		/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2dfa150bcb09..1826946a2f43 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1445,7 +1445,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd;
 
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_unmap_ghcb(svm);
@@ -1453,6 +1453,10 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (svm->guest_state_loaded)
 		return;
 
+	/* sev_es_unmap_ghcb() can resched, so grab per-cpu pointer afterward. */
+	barrier();
+	sd = per_cpu_ptr(&svm_data, vcpu->cpu);
+
 	/*
 	 * Save additional host state that will be restored on VMEXIT (sev-es)
 	 * or subsequent vmload of host save area.
@@ -2818,14 +2822,14 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
+	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb_in_use))
 		return kvm_complete_insn_gp(vcpu, err);
 
-	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 1);
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
-				X86_TRAP_GP |
-				SVM_EVTINJ_TYPE_EXEPT |
-				SVM_EVTINJ_VALID);
+	svm_set_ghcb_sw_exit_info_1(vcpu, 1);
+	svm_set_ghcb_sw_exit_info_2(vcpu,
+				    X86_TRAP_GP |
+				    SVM_EVTINJ_TYPE_EXEPT |
+				    SVM_EVTINJ_VALID);
 	return 1;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f53a41e13033..c462dfac0a0d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -201,8 +201,7 @@ struct svm_nested_state {
 struct vcpu_sev_es_state {
 	/* SEV-ES support */
 	struct sev_es_save_area *vmsa;
-	struct ghcb *ghcb;
-	struct kvm_host_map ghcb_map;
+	bool ghcb_in_use;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
 
@@ -212,6 +211,13 @@ struct vcpu_sev_es_state {
 	u64 ghcb_sa_gpa;
 	u32 ghcb_sa_alloc_len;
 	bool ghcb_sa_sync;
+
+	/*
+	 * SEV-ES support to hold the sw_exit_info return values to be
+	 * sync'ed to the GHCB when mapped.
+	 */
+	u64 ghcb_sw_exit_info_1;
+	u64 ghcb_sw_exit_info_2;
 };
 
 struct vcpu_svm {
@@ -640,6 +646,20 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
+static inline void svm_set_ghcb_sw_exit_info_1(struct kvm_vcpu *vcpu, u64 val)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->sev_es.ghcb_sw_exit_info_1 = val;
+}
+
+static inline void svm_set_ghcb_sw_exit_info_2(struct kvm_vcpu *vcpu, u64 val)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->sev_es.ghcb_sw_exit_info_2 = val;
+}
+
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E95552808
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245590AbiFTXOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347353AbiFTXNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:13:40 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0697824942;
        Mon, 20 Jun 2022 16:11:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TARkcapS/ynK3/cksZquPlLcdiTW2hFeZg055VfsiGXQCU4LerGl6Roa95HHBq2QQFa2CUH6SrgwJxBX/I5S5bWeDi1EACgXANKM9a48Gk3LNtynZdOkMcBmV7+CXVuaooerry9MixbNzZcLK7shD0V9s6Ve7fNXuaZYN6AG4P9kLDKbm8oETDjnRYWdDQSGZXuK6zJkBX8e3Ry6POCgkQm5i2ijcIYj+BuYIF4ELfsDgYseoXafGuxnDwrXqjO7hPGsDk4eV4nE+5LFaKHEt/pjL4sdItZF8UTWfNbUsi9NpiZxhm9F5BUlffdROa9nd4uLGQqGCoIiCDpPnNonnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CsgEkup9AqrfF/173CI8KPT29LyqA5Q5OPjsVf+LGsw=;
 b=UOU8sK78XRvYfjXPTFCNN1i97S193FCqMU3ncz8Kb+DlRmhU75BXdPe1tjVBPA5ZYBXixh+7WYDHMhez3/15YsV6aknHHem9KsZco6zekEebos8tuCI+s2n+QjLRozmW0TwG1gWCl2B83018WtTBbNX5CbY8YuC0Gsf/9EXeB+Vk/c3FdYQdJJoA2rl/1Nypd/jnY9SHmiNVhcgjI58heG+RZ2XqvtFMRBKaCqBVBLIYtj+rWXhIQyl2TS0SoWBH7hCw/NVmL1N+KtG6P0UwwCbwLtqwubogmK0QEkYDieWNR0VLduKYHJ1itkGZ3Weg4sNmZynXHmDpRHXyeo7/TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsgEkup9AqrfF/173CI8KPT29LyqA5Q5OPjsVf+LGsw=;
 b=GNXWDcNfdF2yCUPopkj0MiYRmR1Ruyq8Y3puhIPKLE5v1u1u4HtnaBy4T+iZU39LljkFN/yopUHdYUXYQdLOZUd3ZpD1A1PsCJ3SfGFi2/cy5GHnClcTqw4GwLqjNrSSkD/fRYZ/RBPqGvUX5neZsbKUqT+PU4Wnz+yohc7R4ds=
Received: from MWHPR12CA0041.namprd12.prod.outlook.com (2603:10b6:301:2::27)
 by BN8PR12MB3635.namprd12.prod.outlook.com (2603:10b6:408:46::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 23:11:10 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:2:cafe::27) by MWHPR12CA0041.outlook.office365.com
 (2603:10b6:301:2::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:11:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:11:09 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:11:06 -0500
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
Subject: [PATCH Part2 v6 35/49] KVM: SVM: Remove the long-lived GHCB host map
Date:   Mon, 20 Jun 2022 23:10:58 +0000
Message-ID: <7845d453af6344d0b156493eb4555399aad78615.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: f589dc7b-48b7-4254-b075-08da5312293d
X-MS-TrafficTypeDiagnostic: BN8PR12MB3635:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB363593145FA2619F0E9E1B9F8EB09@BN8PR12MB3635.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AQXN8Pvqn3pulanNtcdh8CaL5djU0YRnyI/l8kYbQL2D/Ff9RLp/t4VkMzkAlgx+OOVr8g1QyuAKSnooUBA5cAyMdOOlw8OnLkzJwyeCYnrOKGcm0BbOg5PCEGNy8PJ9pdQqEcwSGHdQkq9ylx0LJ1msyQW+bgVUl4C4HmsPOO4tNnrJO62lTg6MWZ8x5fucKQHbaGQjsf96cY16rgDAqVzlwxh7HbUpZxtCVjMhItCB5t+x6wrc4GJnEXHM+vdhmr/bld5uQs3fJq9o5jgRvyMbollDwgeVYicpEpGVo3Si3RJkYgea2VUX63rMLiLr8kaEZph1VszSgj+pEbV2Gea1gDdvwgPAxTN7kNpgS9eQcK2KYJcdSEiJkW+48mB4ftw78IQXw5jQKSEwLKfMvfwmmGwHXbJpi5adINeTpzx1xuz8eKJE4kUwu+JLNV77rpmTZmataMYiScnRXFYdwRA5aT2c+ISeaPqE0WudlKBY32W5nS+b9ElKzvLKqijNP2kcyvI4pHFZtw++UkSh0IIs5bhww0ki36ndmsOChv20cWEMyKVVj2cgLbG73Aro+/dIXcEEYEeirRJLNCS4DD5M2jIfu24pugYkMc5L/+DhtCpiWh9JKlQ7oDiiaISR+KuKAqLWcNUc6X/TYOCHYZhir9mJIrta8Q6UKkDG/6CmNo24uXeMLSAZ6PlLgb1i0lAUP7tqF9QG2Fcs+PBIim2rUf9DVtGzJIeK2UJpiJ6pFsgjEyz5x7DHgjVh+8aaB6F68yGA/OHQVkeqIykA/InUxvr7B9t/oI8kGgkdpAo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(346002)(40470700004)(46966006)(36840700001)(81166007)(6666004)(26005)(16526019)(2616005)(83380400001)(7696005)(36756003)(82310400005)(40460700003)(2906002)(186003)(30864003)(5660300002)(40480700001)(7416002)(7406005)(4326008)(70586007)(356005)(70206006)(8676002)(86362001)(47076005)(478600001)(36860700001)(426003)(316002)(41300700001)(54906003)(8936002)(82740400003)(110136005)(336012)(21314003)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:11:09.1834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f589dc7b-48b7-4254-b075-08da5312293d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3635
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
---
 arch/x86/kvm/svm/sev.c | 131 ++++++++++++++++++++++++++---------------
 arch/x86/kvm/svm/svm.c |  12 ++--
 arch/x86/kvm/svm/svm.h |  24 +++++++-
 3 files changed, 111 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 01ea257e17d6..c70f3f7e06a8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2823,15 +2823,40 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
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
@@ -2846,12 +2871,21 @@ static void dump_ghcb(struct vcpu_svm *svm)
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
@@ -2865,13 +2899,24 @@ static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
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
@@ -2915,20 +2960,25 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
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
@@ -3021,6 +3071,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		goto vmgexit_err;
 	}
 
+	sev_es_sync_from_ghcb(svm, ghcb);
+
+	svm_unmap_ghcb(svm, &map);
 	return 0;
 
 vmgexit_err:
@@ -3031,10 +3084,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
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
 
@@ -3044,6 +3097,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	ghcb_set_sw_exit_info_1(ghcb, 2);
 	ghcb_set_sw_exit_info_2(ghcb, reason);
 
+	svm_unmap_ghcb(svm, &map);
+
 	/* Resume the guest to "return" the error code. */
 	return 1;
 }
@@ -3053,23 +3108,20 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
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
@@ -3099,7 +3151,6 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
-	struct ghcb *ghcb = svm->sev_es.ghcb;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
 	u64 scratch_gpa_beg, scratch_gpa_end;
 
@@ -3178,8 +3229,8 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return 0;
 
 e_scratch:
-	ghcb_set_sw_exit_info_1(ghcb, 2);
-	ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
+	svm_set_ghcb_sw_exit_info_1(&svm->vcpu, 2);
+	svm_set_ghcb_sw_exit_info_2(&svm->vcpu, GHCB_ERR_INVALID_SCRATCH_AREA);
 
 	return 1;
 }
@@ -3316,7 +3367,6 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 ghcb_gpa, exit_code;
-	struct ghcb *ghcb;
 	int ret;
 
 	/* Validate the GHCB */
@@ -3331,29 +3381,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
@@ -3393,20 +3428,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
@@ -3537,7 +3572,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		 * Return from an AP Reset Hold VMGEXIT, where the guest will
 		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
 		 */
-		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		svm_set_ghcb_sw_exit_info_2(vcpu, 1);
 		break;
 	case AP_RESET_HOLD_MSR_PROTO:
 		/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 18e2cd4d9559..b24e0171cbf2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2720,14 +2720,14 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index bd0db4d4a61e..c80352c9c0d6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -189,8 +189,7 @@ struct svm_nested_state {
 struct vcpu_sev_es_state {
 	/* SEV-ES support */
 	struct sev_es_save_area *vmsa;
-	struct ghcb *ghcb;
-	struct kvm_host_map ghcb_map;
+	bool ghcb_in_use;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
 
@@ -200,6 +199,13 @@ struct vcpu_sev_es_state {
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
@@ -614,6 +620,20 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
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


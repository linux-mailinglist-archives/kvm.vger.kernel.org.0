Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EAD64D0C1
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiLNUK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLNUJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:09:51 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0399C2C640;
        Wed, 14 Dec 2022 12:02:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzGJ0T7GRKgPB/i1vX3rYSXrEUvyIz/BTQdHdVV0G45Id5RqBtjKeaSOuHApDvvfzkCokcNAUjlIHKjZ5rGF7HbKVdHFLx7AwgzmzsVMEgUVHM1szbcRzHAkHTFmJ9//31+Quc0GoqX1jgCknFiLas003k4ywRMKca3ufx1zVhgPFATExzojWeAm/6EIBaYnswF3tUqig0e/Ep4Y7So6BtZXKAi2DJrKBW5A+ssQQuPXaM+7tD4tIT/ebWiTfo/ryRN1GmloA05PR71vomIFBLr0k71+fqrA5sMPiWSy072dIkWpExWaeOyPKsQLoYjIcEpztq2OovWpnPpCRcT23g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iI52L3YVAxI6dNkrnUQzy49EWWUwko1VEEKryV9QQEA=;
 b=AmU2+RL9nACRyGJf7APnTs5iOfN3gix9JD/TP0cZPlJgM0IYoTBCTqqQKbOlL7zVlbNyThzfEKl+Gc8GlqIhpNgxGTxn28Lgwt7k8TXeEKYceDd8daqI5swCFttLxXVQFDfq2kj5V76Esv4z/RuF8B8Yvc2GudfVKFz38KFMdBWlZ/Puu5d4RxucnvMngmoGTYT3QkwPOeF+kPIfTT/4H7dn3zUEE/LTuYLYjnEsvjPYr5lIxew7a0ozLILTPwKE8a6Rj8sfE+KMc5Dg6o7kpctNdail+x0LNLDP16g7Fw8jFdw4126yIyxHIEreF2/d4K578NoVQBfC2v/wNa2T8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iI52L3YVAxI6dNkrnUQzy49EWWUwko1VEEKryV9QQEA=;
 b=ITt3SqFPXwh7S5SEutMLIgWUHoIK70+kmCotvD0liKrcdXZFXpkhwiWBTsqJaTDF6Q5jn66phuND7LGwQ1UhHCdvuMw8yW3ZKuiZnFdJjdu/T8RAFSfQ4pNhYbtKY0TBGKmCUCTcfVSO/j8zONtyKpfxFYoWwwcTb+dpWHBYT3w=
Received: from CY5PR18CA0053.namprd18.prod.outlook.com (2603:10b6:930:13::29)
 by SA3PR12MB7879.namprd12.prod.outlook.com (2603:10b6:806:306::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:02:11 +0000
Received: from CY4PEPF0000C96E.namprd02.prod.outlook.com
 (2603:10b6:930:13:cafe::2a) by CY5PR18CA0053.outlook.office365.com
 (2603:10b6:930:13::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:02:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96E.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 20:02:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:02:07 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>
Subject: [PATCH RFC v7 49/64] KVM: SVM: Introduce ops for the post gfn map and unmap
Date:   Wed, 14 Dec 2022 13:40:41 -0600
Message-ID: <20221214194056.161492-50-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96E:EE_|SA3PR12MB7879:EE_
X-MS-Office365-Filtering-Correlation-Id: 92d0b10f-74ce-49a8-5f0a-08dade0e1623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJLySv4lX4OdfArM4C8JCtj66cKwiGvv85XtGzM56m7Le/Nrwu0b4z+kB3JKjPHIqxiz7I+LJ0+6gG+BtMf2RkiQS1yj/fGzICEaBrf1GEO4raTkvfwm/WZG3uuovESwc5CV9KO6jDdanyVG+MWugU5rq6W9AcVJE4t5vcOnHr3h0qiC/FNjebEaWT88giQ8HJVJbGupJUlrS0K81nJui0pzJeAqdTaNIhJ2VBnwhr9xK6nGsOJYrwqDN4qpsb5IQLcl0dSwgXRoTmokzE9Q3B8jS4jocZ5lr49vBFGKKvAxLVaz3SqywPy/aQlp2PkkSo04s8knS6jPse/CQpQy6c3E9nyxGx90Z+lJvsWOCGG0jk2myZe121NJugxX6x/eM9dEwIKgAkNMTBoZcpfwFLY6pT0cDLSIR7jGoE3VPKiRjf6zCZHKP7OzepmUqwXVIUIRbvHADqIaytXnKR2bs3SLV7pbIKLbC2Eycmrq2k5TsPiCasqsfRIId+56WN3z+pYbXxzT6RzXhh0ZCjJAFsCAk8yZ3/7CYgoUrBT4m++MZxdisPyuFjMMpLdVW0JrZD8kaZBpNPeTee+DrSdIMq1vBZAklZr3txYztd4hhwhpF01jD/T2sSKSGcTiRGOnNPfUF2iDvyF2ty3Bp9G2aN+AGrVpft1eBnMVd/VgzZEipcbPaFVDl8jS7FJUUFDGnO7nF8HjulWHkT+zKzW1x7LYzvsTkDDY0zBOHKFLjygK5qmKZokUjayrh8UHZcbynpEMm6dOE5KyUcwbuq6iGQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(46966006)(36840700001)(40470700004)(966005)(478600001)(26005)(6666004)(54906003)(316002)(8936002)(40460700003)(8676002)(41300700001)(4326008)(70206006)(7406005)(36756003)(7416002)(70586007)(44832011)(336012)(5660300002)(47076005)(16526019)(86362001)(426003)(2906002)(40480700001)(2616005)(186003)(36860700001)(1076003)(81166007)(6916009)(83380400001)(82310400005)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:02:10.7578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d0b10f-74ce-49a8-5f0a-08dade0e1623
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7879
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

When SEV-SNP is enabled in the guest VM, the guest memory pages can
either be a private or shared. A write from the hypervisor goes through
the RMP checks. If the CPU sees that hypervisor is attempting to write
to a guest private page, then it will trigger an RMP violation #PF.

To avoid the RMP violation with GHCB pages, added new
post_{map,unmap}_gfn functions to verify if its safe to map GHCB pages.
Use kvm->mmu_lock to guard the GHCB against invalidations while being
accessed.

Need to add generic post_{map,unmap}_gfn() ops that can be used to
verify that it's safe to map a given guest page in the hypervisor.

Link: https://lore.kernel.org/all/CABpDEukAEGwb9w12enO=fhSbHbchypsOdO2dkR4Jei3wDW6NWg@mail.gmail.com/
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: use kvm->mmu_lock instead of a new spinlock, this should guard
      GHCB page against invalidations]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 40 ++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h |  3 +++
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index abe6444bf5d4..90b509fe1826 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2926,19 +2926,28 @@ static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 gfn = gpa_to_gfn(control->ghcb_gpa);
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
+	if (kvm_vcpu_map(vcpu, gfn, map)) {
 		/* Unable to map GHCB from guest */
 		pr_err("error mapping GHCB GFN [%#llx] from guest\n", gfn);
 		return -EFAULT;
 	}
 
+	if (sev_post_map_gfn(vcpu->kvm, map->gfn, map->pfn)) {
+		kvm_vcpu_unmap(vcpu, map, false);
+		return -EBUSY;
+	}
+
 	return 0;
 }
 
 static inline void svm_unmap_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
 {
-	kvm_vcpu_unmap(&svm->vcpu, map, true);
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	kvm_vcpu_unmap(vcpu, map, true);
+	sev_post_unmap_gfn(vcpu->kvm, map->gfn, map->pfn);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
@@ -3875,6 +3884,33 @@ void sev_rmp_page_level_adjust(struct kvm *kvm, gfn_t gfn, int *level)
 		 __func__, gfn, *level, rmp_level, ret);
 }
 
+int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
+{
+	int level;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	read_lock(&(kvm)->mmu_lock);
+
+	/* If pfn is not added as private then fail */
+	if (snp_lookup_rmpentry(pfn, &level) == 1) {
+		read_unlock(&(kvm)->mmu_lock);
+		pr_err_ratelimited("failed to map private gfn 0x%llx pfn 0x%llx\n", gfn, pfn);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
+{
+	if (!sev_snp_guest(kvm))
+		return;
+
+	read_unlock(&(kvm)->mmu_lock);
+}
+
 int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault)
 {
 	gfn_t gfn = gpa_to_gfn(gpa);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a4d48c3e0f89..aef13c120f2d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -100,6 +100,7 @@ struct kvm_sev_info {
 	atomic_t migration_in_progress;
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
+	spinlock_t psc_lock;
 };
 
 struct kvm_svm {
@@ -727,6 +728,8 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_rmp_page_level_adjust(struct kvm *kvm, gfn_t gfn, int *level);
+int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
+void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
 
 int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 
-- 
2.25.1


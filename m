Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FE74D0EC2
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 05:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbiCHElc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 23:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245415AbiCHElZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 23:41:25 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3016D3BBCE;
        Mon,  7 Mar 2022 20:40:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXhIZflxipEgfh6UDXqcxFqgsLc3305bKE5nwh1lfbu5L5NgNXwAMqWC9RvcQSRvvVi/p3aNx5d69xqttfr58+qXDjcTcHldui2p64In4+OwWZ0+q7DlnWuJR2coIms50iusPq8dcGLJT2/Ka3t29CV8EnwU/GS0i3v/uYlR5GrJ8gQAH9EgOiSCwbm0kqzgUqU3VzHs7UFuKkPPDDLxZbYFJ1OJsxN7Q+WibahPlPPJnPAdBRgfCUeTYNOChcwNVigV9wPDl4IvvtoChEfYnpbpljHlifL4clSQXsbB05UefazZG9GvUCwC5OvwPnmlWUVSbU8eIxNfSFiVswRhpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYtVtx3Zm2oBUMFae3DZxhD+8teRR1GNGqNCvIbmrFE=;
 b=ErjQfdBHTJDFlAkUhacj2AcXHdYXWVj8bJSD43K9YL9YcMShEH7jADnqHEXfpL3vhyy4aaYSDgjE/gvUfeFkPZRtAFnQQX3EaXM4K/cw7vx9H27bBYOlZXUWeiaWm2Q6ONYN7xV4ieQYGFESKYD4dy3EhAah1AWzqFFpfOrZHRtKwOHozZAhMR3kk5lbaS29Uqn+Yori1SkAKgDibLP/eso+PZ70/Jiymfy9BAM19cCDwpSUws6LDYHgeU5uXJQHk4BMsgikf5TfQhIzfS9geD5ozn3fAftkIxUlTI9CEvKaSIZRunTZx1fAG+Xb7Sy0AZlKrhogDZGTDgoSeepNeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYtVtx3Zm2oBUMFae3DZxhD+8teRR1GNGqNCvIbmrFE=;
 b=flZmzu5nu1a6gRu2hSG0iwufEsOtjpswaaaPA9CctpTXzyDOgQB3gNV4yFpCw9pqRty2sF9L6ej+fy3ZX6Az9agk2BK5Q9hmrBe/C/VLoBsCXWzf/trXmLd9Szx/IHoWG0+TQB9u8Ne6oy7QMFByJhYHl4eP09W4DdmEx4+IWFo=
Received: from DM6PR02CA0062.namprd02.prod.outlook.com (2603:10b6:5:177::39)
 by CH0PR12MB5331.namprd12.prod.outlook.com (2603:10b6:610:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Tue, 8 Mar
 2022 04:40:23 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::91) by DM6PR02CA0062.outlook.office365.com
 (2603:10b6:5:177::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13 via Frontend
 Transport; Tue, 8 Mar 2022 04:40:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 04:40:22 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 22:40:16 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        "David Hildenbrand" <david@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v1 4/9] KVM: SVM: Add pinning metadata in the arch memslot
Date:   Tue, 8 Mar 2022 10:08:52 +0530
Message-ID: <20220308043857.13652-5-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220308043857.13652-1-nikunj@amd.com>
References: <20220308043857.13652-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae454688-23f7-4347-f81a-08da00bdc1c7
X-MS-TrafficTypeDiagnostic: CH0PR12MB5331:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5331957BE7B5EFEFCD90FD7AE2099@CH0PR12MB5331.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U5MfQZjYB4K7xhWBQxyCPwRp6WFpCA/v3HuFlaQ/+VCxwyE8102QT2LfBzq+7uKJtOE1zdXB0s409kACJrqnIW0OxloFexgZltR77NrOSm/e9w0HSZzOUmNkqNuAPILwi7oHFebDgrMdNhFlVHBrDndZ4MEwlfrEfdHkfgV/r6KeesLkVK6MAWlYQQ4aAmY+kCzdJnkmMbczNdpHZtW7L8x/TErLgUGBkobL6mgsVfG9nE9NxhrdnAk10RtxUCQvzpx1XlznND0hPqgQiN5wYZzRXRPfiQbKuQWd76XjmfYdCS4ykxp2JNnAvZCOutBG19oYMmlX+OSL+/Xs+y4v8AbHezlaREsxXGNReYXnQtnXAKyOC0GGMsvzhignBSXAyutzYSgydqXUmc8Da0g2Gpw3aGRoIQ2bQg/mhWdqd25ZIVxX0V0XqZVmK5AYUr8zp77OTJTCvce5Tews5k93FiwIuQfkcPZbCEWQJLslAwFZK+9HnSDNEYCdH8SFt6OazXrGuDTwBkDGK2cC5MqdH+C1xRMczIeFJvikUQuO+fLYinT1mXFmU+XB8ba1YYP0c4WLIZwL9ukzWvczj/cY/gaNKmg4pPPruosUyH+AqnLQ6YKv06GdORGm2NKv3DM0MQpBdKvvZacujYZtV8Cs3vPoVkWJ09nb2iGOsYhBCL2+aThfENCz8xHIt+2j0PHJ60CNvOG7xcJjkmb6AYXZYQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(26005)(36860700001)(2906002)(47076005)(4326008)(36756003)(6666004)(316002)(6916009)(508600001)(7696005)(356005)(1076003)(186003)(2616005)(426003)(81166007)(336012)(16526019)(7416002)(82310400004)(8676002)(70206006)(70586007)(8936002)(83380400001)(40460700003)(5660300002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 04:40:22.5335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae454688-23f7-4347-f81a-08da00bdc1c7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5331
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV guest requires the guest's pages to be pinned in host
physical memory. The memory encryption scheme uses the physical
address of the memory being encrypted. If guest pages are moved,
content decrypted would be incorrect, corrupting guest's memory.

For SEV/SEV-ES guests, the hypervisor doesn't know which pages are
encrypted and when the guest is done using those pages. Hypervisor
should treat all the guest pages as encrypted until they are
deallocated or the guest is destroyed.

The KVM MMU needs to track the pages that are pinned and the
corresponding pfns for unpinning them during the guest destroy path
and deallocation path.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  7 +++++
 arch/x86/kvm/svm/sev.c             | 49 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  3 ++
 arch/x86/kvm/svm/svm.h             |  6 ++++
 arch/x86/kvm/x86.c                 | 11 ++++++-
 6 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8efb43d92eef..61ff8a636db6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -89,6 +89,8 @@ KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP(pin_pfn)
+KVM_X86_OP(alloc_memslot_metadata)
+KVM_X86_OP(free_memslot)
 KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index df11f1fb76de..eeb2c799b59f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -926,6 +926,8 @@ struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
 	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
+	unsigned long *pinned_bitmap;
+	kvm_pfn_t *pfns;
 };
 
 /*
@@ -1421,6 +1423,11 @@ struct kvm_x86_ops {
 	bool (*pin_pfn)(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			kvm_pfn_t pfn, hva_t hva, bool write,
 			enum pg_level level);
+	int (*alloc_memslot_metadata)(struct kvm *kvm,
+				      const struct kvm_memory_slot *old,
+				      struct kvm_memory_slot *new);
+	void (*free_memslot)(struct kvm *kvm,
+			     struct kvm_memory_slot *slot);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 17b53457d866..bd7572517c99 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2950,3 +2950,52 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
 }
+
+void sev_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct kvm_arch_memory_slot *aslot = &slot->arch;
+
+	if (!sev_guest(kvm))
+		return;
+
+	if (aslot->pinned_bitmap) {
+		kvfree(aslot->pinned_bitmap);
+		aslot->pinned_bitmap = NULL;
+	}
+
+	if (aslot->pfns) {
+		kvfree(aslot->pfns);
+		aslot->pfns = NULL;
+	}
+}
+
+int sev_alloc_memslot_metadata(struct kvm *kvm,
+			       const struct kvm_memory_slot *old,
+			       struct kvm_memory_slot *new)
+{
+	struct kvm_arch_memory_slot *aslot = &new->arch;
+	unsigned long pinned_bytes = new->npages * sizeof(kvm_pfn_t);
+
+	if (!sev_guest(kvm))
+		return 0;
+
+	if (old && old->arch.pinned_bitmap && old->arch.pfns) {
+		WARN_ON(old->npages != new->npages);
+		aslot->pinned_bitmap = old->arch.pinned_bitmap;
+		aslot->pfns = old->arch.pfns;
+		return 0;
+	}
+
+	aslot->pfns = kvcalloc(new->npages, sizeof(*aslot->pfns),
+			      GFP_KERNEL_ACCOUNT);
+	if (!aslot->pfns)
+		return -ENOMEM;
+
+	aslot->pinned_bitmap = kvzalloc(pinned_bytes, GFP_KERNEL_ACCOUNT);
+	if (!aslot->pinned_bitmap) {
+		kvfree(aslot->pfns);
+		aslot->pfns = NULL;
+		return -ENOMEM;
+	}
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fd3a00c892c7..ec06421cb532 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4658,6 +4658,9 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
+	.alloc_memslot_metadata = sev_alloc_memslot_metadata,
+	.free_memslot = sev_free_memslot,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fa98d6844728..f00364020d7e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -616,4 +616,10 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
 void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 
+int sev_alloc_memslot_metadata(struct kvm *kvm,
+			       const struct kvm_memory_slot *old,
+			       struct kvm_memory_slot *new);
+void sev_free_memslot(struct kvm *kvm,
+		      struct kvm_memory_slot *slot);
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 82a9dcd8c67f..95070aaa1636 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11796,6 +11796,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	}
 
 	kvm_page_track_free_memslot(slot);
+	static_call_cond(kvm_x86_free_memslot)(kvm, slot);
 }
 
 int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
@@ -11821,6 +11822,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
 }
 
 static int kvm_alloc_memslot_metadata(struct kvm *kvm,
+				      const struct kvm_memory_slot *old,
 				      struct kvm_memory_slot *slot)
 {
 	unsigned long npages = slot->npages;
@@ -11873,8 +11875,15 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 	if (kvm_page_track_create_memslot(kvm, slot, npages))
 		goto out_free;
 
+	if (kvm_x86_ops.alloc_memslot_metadata &&
+	    static_call(kvm_x86_alloc_memslot_metadata)(kvm, old, slot))
+		goto out_free_page_track;
+
 	return 0;
 
+out_free_page_track:
+	kvm_page_track_free_memslot(slot);
+
 out_free:
 	memslot_rmap_free(slot);
 
@@ -11907,7 +11916,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(kvm, new);
+		return kvm_alloc_memslot_metadata(kvm, old, new);
 
 	if (change == KVM_MR_FLAGS_ONLY)
 		memcpy(&new->arch, &old->arch, sizeof(old->arch));
-- 
2.32.0


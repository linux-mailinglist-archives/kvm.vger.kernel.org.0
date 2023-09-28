Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9E27B2401
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 19:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjI1RfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 13:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjI1RfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 13:35:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B621A8
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 10:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695922458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bXvR8P30J13RoiFY6oQnabnLblTIM5XWqXhOKK4pnys=;
        b=GNVoOK68fxuwRpWEU0gGVssNSe7YrBBahM4wQ8iGCi9zDi0tvfhemYUHhHlhWoigcxV5ub
        bplwDOix2JPAfB1MPKgmgEWLLJQgzoHqYf/4Ot/j7QIF9b7qvmTnJraTb4s+ZdsEUtWVJR
        Jb1k/MwPfkLSzJy9u8OR7p6hU/Z+dUE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-dV2krgcqMdaXISgjC_sr8Q-1; Thu, 28 Sep 2023 13:34:15 -0400
X-MC-Unique: dV2krgcqMdaXISgjC_sr8Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8A308015AB;
        Thu, 28 Sep 2023 17:34:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 710B814171B6;
        Thu, 28 Sep 2023 17:34:11 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     iommu@lists.linux.dev, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 4/4] x86: KVM: SVM: workaround for AVIC's errata #1235
Date:   Thu, 28 Sep 2023 20:33:54 +0300
Message-Id: <20230928173354.217464-5-mlevitsk@redhat.com>
In-Reply-To: <20230928173354.217464-1-mlevitsk@redhat.com>
References: <20230928173354.217464-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Zen2 (and likely on Zen1 as well), AVIC doesn't reliably detect a change
in the 'is_running' bit during ICR write emulation and might skip a
VM exit, if that bit was recently cleared.

The absence of the VM exit, leads to the KVM not waking up / triggering
nested vm exit on the target(s) of the IPI which can, in some cases,
lead to an unbounded delays in the guest execution.

As I recently discovered, a reasonable workaround exists: make the KVM
never set the is_running bit.

This workaround ensures that (*) all ICR writes always cause a VM exit
and therefore correctly emulated, in expense of never enjoying VM exit-less
ICR emulation.

This workaround does carry a performance penalty but according to my
benchmarks is still much better than not using AVIC at all,
because AVIC is still used for the receiving end of the IPIs, and for the
posted interrupts.

If the user is aware of the errata and it doesn't affect his workload,
the user can disable the workaround with 'avic_zen2_errata_workaround=0'

(*) More correctly all ICR writes except when 'Self' shorthand is used:

In this case AVIC skips reading physid table and just sets bits in IRR
of local APIC. Thankfully in this case, the errata is not possible,
therefore an extra workaround for this case is not needed.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 63 +++++++++++++++++++++++++++++------------
 arch/x86/kvm/svm/svm.h  |  1 +
 2 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b74ea91f4e6bb6..28bb0e6b321660d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -62,6 +62,9 @@ static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
 static bool force_avic;
 module_param_unsafe(force_avic, bool, 0444);
 
+static int avic_zen2_errata_workaround = -1;
+module_param(avic_zen2_errata_workaround, int, 0444);
+
 /* Note:
  * This hash table is used to map VM_ID to a struct kvm_svm,
  * when handling AMD IOMMU GALOG notification to schedule in
@@ -276,7 +279,7 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 
 static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 {
-	u64 *entry, new_entry;
+	u64 *entry;
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -308,10 +311,10 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	if (!entry)
 		return -EINVAL;
 
-	new_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
-			      AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
-			      AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
-	WRITE_ONCE(*entry, new_entry);
+	svm->avic_physical_id_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
+						 AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
+						 AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
+	WRITE_ONCE(*entry, svm->avic_physical_id_entry);
 
 	svm->avic_physical_id_cache = entry;
 
@@ -835,7 +838,7 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
 	 * See also avic_vcpu_load().
 	 */
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	entry = READ_ONCE(svm->avic_physical_id_entry);
 	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
 		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
 				    true, pi->ir_data);
@@ -1027,7 +1030,6 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	u64 entry;
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
@@ -1056,14 +1058,23 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
-	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+	WARN_ON_ONCE(svm->avic_physical_id_entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
+
+	svm->avic_physical_id_entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+	svm->avic_physical_id_entry |=
+		(h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
+
+	svm->avic_physical_id_entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+
+	/*
+	 * Do not update the actual physical id table entry if workaround
+	 * for #1235 - the physical ID entry is_running is never set when
+	 * the workaround is activated
+	 */
+	if (!avic_zen2_errata_workaround)
+		WRITE_ONCE(*(svm->avic_physical_id_cache), svm->avic_physical_id_entry);
 
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
@@ -1071,7 +1082,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
 
@@ -1084,10 +1094,9 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
 	 * recursively.
 	 */
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 
 	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
-	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
+	if (!(svm->avic_physical_id_entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
 		return;
 
 	/*
@@ -1102,8 +1111,14 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 
 	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	svm->avic_physical_id_entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+
+	/*
+	 * Do not update the actual physical id table entry
+	 * See explanation in avic_vcpu_load
+	 */
+	if (!avic_zen2_errata_workaround)
+		WRITE_ONCE(*(svm->avic_physical_id_cache), svm->avic_physical_id_entry);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 
@@ -1217,5 +1232,17 @@ bool avic_hardware_setup(void)
 
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 
+	if (avic_zen2_errata_workaround == -1) {
+
+		/* Assume that Zen1 and Zen2 have errata #1235 */
+		if (boot_cpu_data.x86 == 0x17)
+			avic_zen2_errata_workaround = 1;
+		else
+			avic_zen2_errata_workaround = 0;
+	}
+
+	if (avic_zen2_errata_workaround)
+		pr_info("Workaround for AVIC errata #1235 is enabled\n");
+
 	return true;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be67ab7fdd104e3..98dc45b9c194d2e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -265,6 +265,7 @@ struct vcpu_svm {
 	u32 ldr_reg;
 	u32 dfr_reg;
 	struct page *avic_backing_page;
+	u64 avic_physical_id_entry;
 	u64 *avic_physical_id_cache;
 
 	/*
-- 
2.26.3


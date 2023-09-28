Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EE47B2076
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 17:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjI1PGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 11:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbjI1PGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 11:06:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40391B4
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 08:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695913520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BNW1QOOJZvi4+G5BXUnncgpsE3RlMF02WmB0kRHObXg=;
        b=gy1IeaU6C5+swcBiYoJklGwsalsl8KYtL94826stvQp5t65A9mcEXu2QL3jzEY0T3n6Ew8
        N5IvEKiHWvWPBYRXiWrL9P/R/JGHBic9GDSvpK8JUcsK3b636J3fz6ZJgA3uEBYd2DThAB
        YgxzVIx6pwpSBHbOtPK8UkSP9Vc7Ypc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-HDbD2tdKM2KB0zSaX0me8w-1; Thu, 28 Sep 2023 11:04:53 -0400
X-MC-Unique: HDbD2tdKM2KB0zSaX0me8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B7C2101A550;
        Thu, 28 Sep 2023 15:04:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7DEB40C6E76;
        Thu, 28 Sep 2023 15:04:48 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5/5] x86: KVM: SVM: workaround for AVIC's errata #1235
Date:   Thu, 28 Sep 2023 18:04:28 +0300
Message-Id: <20230928150428.199929-6-mlevitsk@redhat.com>
In-Reply-To: <20230928150428.199929-1-mlevitsk@redhat.com>
References: <20230928150428.199929-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 arch/x86/kvm/svm/avic.c | 50 +++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index c44b65af494e3ff..df9efa428f86aa9 100644
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
@@ -1027,7 +1030,6 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	u64 entry;
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
@@ -1056,14 +1058,18 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
+	if (!avic_zen2_errata_workaround) {
+		u64 entry = READ_ONCE(*(svm->avic_physical_id_cache));
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
-	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+		WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
+
+		entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+		entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
+		entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+
+		WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	}
 
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
@@ -1071,7 +1077,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	u64 entry;
+	u64 entry = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
 
@@ -1084,11 +1090,13 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
 	 * recursively.
 	 */
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 
-	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
-	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
-		return;
+	if (!avic_zen2_errata_workaround) {
+		/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
+		entry = READ_ONCE(*(svm->avic_physical_id_cache));
+		if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
+			return;
+	}
 
 	/*
 	 * Take and hold the per-vCPU interrupt remapping lock while updating
@@ -1102,8 +1110,10 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 
 	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	if (!avic_zen2_errata_workaround) {
+		entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+		WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	}
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 
@@ -1217,5 +1227,17 @@ bool avic_hardware_setup(void)
 
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
-- 
2.26.3


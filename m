Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E3C7B5210
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 14:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbjJBMDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 08:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236843AbjJBMDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 08:03:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E74610E4
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 05:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696248168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KRNcUMO/3qZE3ezJDf3zkvX+ebI+kEjoeR2cSJmrJs8=;
        b=TGp0jq5Z6vST0lSeu+78/MRe5b3+1gkR910JbEohCCKIe8Moe3hE/Q+MtKogFX1YfiqLDJ
        U9M4V2LVaFBqlYX+wz8E9tzYG8NrUNpNKAy73AjQyJoUfDPefIePMNGUfpujZcM0YdZZ4X
        8o9K9V3r2kyllEFQ8T9kqxwJ5ebbVmc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-gLzkORjIPI-dG0TowIN7Kw-1; Mon, 02 Oct 2023 08:02:45 -0400
X-MC-Unique: gLzkORjIPI-dG0TowIN7Kw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 958F8811E7B;
        Mon,  2 Oct 2023 11:57:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5446C140E953;
        Mon,  2 Oct 2023 11:57:40 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 4/4] x86: KVM: SVM: allow optionally to disable AVIC's IPI virtualization
Date:   Mon,  2 Oct 2023 14:57:23 +0300
Message-Id: <20231002115723.175344-5-mlevitsk@redhat.com>
In-Reply-To: <20231002115723.175344-1-mlevitsk@redhat.com>
References: <20231002115723.175344-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Zen2 (and likely on Zen1 as well), AVIC doesn't reliably detect a change
in the 'is_running' bit during ICR write emulation and might skip a
VM exit, if that bit was recently cleared.

The absence of the VM exit, leads to the KVM not waking up / triggering
nested vm exit on the target(s) of the IPI, which can, in some cases,
lead to unbounded delays in the guest execution.

As I recently discovered, a reasonable workaround exists: make the KVM
never set the is_running bit, which in essence disables the
IPI virtualization portion of AVIC making it equal to APICv without IPI
virtualization.

This workaround ensures that (*) all ICR writes always cause a VM exit
and therefore correctly emulated, in expense of never enjoying VM exit-less
ICR write emulation.

To let the user control the workaround, a new kvm_amd module parameter was
added: 'enable_ipiv', using the same name as IPI virtualization of VMX.

However unlike VMX, this parameter is tri-state: 0, 1, -1.
-1 is the default value which instructs KVM to choose the default based
on the CPU model.

(*) More correctly all ICR writes except when the 'Self' shorthand is used:

In this case AVIC skips reading physid table and just sets bits in IRR
of local APIC. Thankfully in this case, the errata is not possible,
therefore an extra workaround is not needed.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 51 +++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bdab28005ad3405..b3ec693083cc883 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -62,6 +62,9 @@ static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
 static bool force_avic;
 module_param_unsafe(force_avic, bool, 0444);
 
+static int enable_ipiv = -1;
+module_param(enable_ipiv, int, 0444);
+
 /* Note:
  * This hash table is used to map VM_ID to a struct kvm_svm,
  * when handling AMD IOMMU GALOG notification to schedule in
@@ -1024,7 +1027,6 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	u64 entry;
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
@@ -1053,14 +1055,22 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
+	/*
+	 * Do not update the actual physical id table entry, if the IPI
+	 * virtualization portion of AVIC is not enabled.
+	 * In this case all ICR writes except Self IPIs will be intercepted.
+	 */
+
+	if (enable_ipiv) {
+		u64 entry = READ_ONCE(*svm->avic_physical_id_cache);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
-	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+		WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
+		entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+		entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
+		entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+		WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	}
 
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
@@ -1068,7 +1078,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
 
@@ -1093,11 +1102,17 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 
 	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
 
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON_ONCE(!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK));
+	/*
+	 * Do not update the actual physical id table entry if the IPI
+	 * virtualization is disabled. See explanation in avic_vcpu_load().
+	 */
+	if (enable_ipiv) {
+		u64 entry = READ_ONCE(*svm->avic_physical_id_cache);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+		WARN_ON_ONCE(!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK));
+		entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+		WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	}
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 
@@ -1211,5 +1226,17 @@ bool avic_hardware_setup(void)
 
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 
+	if (enable_ipiv == -1) {
+		enable_ipiv = 1;
+		/* Assume that Zen1 and Zen2 have errata #1235 */
+		if (boot_cpu_data.x86 == 0x17) {
+			pr_info("AVIC's IPI virtualization disabled due to errata #1235\n");
+			enable_ipiv = 0;
+		}
+	}
+
+	if (enable_ipiv)
+		pr_info("AVIC's IPI virtualization enabled\n");
+
 	return true;
 }
-- 
2.26.3


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBD24C9341
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbiCAS3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbiCAS3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:29:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A2696620A
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 10:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646159331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cLntVg1A2GtP5Mk+abzswn9NBODKG9gpF8Mfluysqbk=;
        b=egaBVInCYuhgUC2jyhzGPRkYEmwBTlXEXb3P+dZOBAfF/YumYXgGXUV3BfSdLncXMI3QY9
        7UgS3Mz4r7mn/Ds3MnjzCKuIDCIbiF5lzlUDuqYAvacyqRdWK7hCWjaGlBMD06Q4OjQxmI
        GoplzgivmlQitzNL1QHPNNBnBYSLhk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-QlxQAoN2PdyIiLAMBUF16g-1; Tue, 01 Mar 2022 13:28:48 -0500
X-MC-Unique: QlxQAoN2PdyIiLAMBUF16g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4792B1854E21;
        Tue,  1 Mar 2022 18:28:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E207286C41;
        Tue,  1 Mar 2022 18:28:38 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        x86@kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Joerg Roedel <joro@8bytes.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        dri-devel@lists.freedesktop.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 11/11] KVM: SVM: allow to avoid not needed updates to is_running
Date:   Tue,  1 Mar 2022 20:26:39 +0200
Message-Id: <20220301182639.559568-12-mlevitsk@redhat.com>
In-Reply-To: <20220301182639.559568-1-mlevitsk@redhat.com>
References: <20220301182639.559568-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow optionally to make KVM not update is_running unless it is
functionally needed which is only when a vCPU halts,
or is in the guest mode.

This means security wise that if a vCPU is scheduled out,
other vCPUs could still send doorbell messages to the
last physical CPU where this vCPU was last running.

This in theory can be considered less secure, thus
this option is not enabled by default.

The option is avic_doorbell_strict and is true by
default, setting it to false allows this relaxed
non strict mode.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 39 +++++++++++++++++++++++++++------------
 arch/x86/kvm/svm/svm.c  |  7 +++++--
 arch/x86/kvm/svm/svm.h  |  1 +
 virt/kvm/kvm_main.c     |  3 ++-
 4 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index dd13fd3588e2b..1d690a9d3952e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -166,10 +166,13 @@ void avic_physid_shadow_table_update_vcpu_location(struct kvm_vcpu *vcpu, int cp
 	raw_spin_lock_irqsave(&kvm_svm->avic.table_entries_lock, flags);
 
 	list_for_each_entry(e, &vcpu_svm->nested.physid_ref_entries, link) {
-		u64 sentry = READ_ONCE(*e->sentry);
+		u64 old_sentry = READ_ONCE(*e->sentry);
+		u64 new_sentry = old_sentry;
 
-		physid_entry_set_apicid(&sentry, cpu);
-		WRITE_ONCE(*e->sentry, sentry);
+		physid_entry_set_apicid(&new_sentry, cpu);
+
+		if (new_sentry != old_sentry)
+			WRITE_ONCE(*e->sentry, new_sentry);
 		nentries++;
 	}
 
@@ -1507,7 +1510,7 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	u64 entry;
+	u64 old_entry, new_entry;
 	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1531,14 +1534,16 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_vcpu_is_blocking(vcpu))
 		return;
 
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
+	old_entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	new_entry = old_entry;
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
-	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+	new_entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+	new_entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
+	new_entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+
+	if (old_entry != new_entry)
+		WRITE_ONCE(*(svm->avic_physical_id_cache), new_entry);
 
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 }
 
@@ -1549,14 +1554,24 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_preemption_disabled();
 
+	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
+
+	/*
+	 * It is only meaningful to intercept IPIs from the guest
+	 * when either vCPU is blocked, or in guest mode.
+	 * In all other cases (e.g userspace vmexit, or preemption
+	 * by other task, the vCPU is guaranteed to return to guest mode
+	 * as soon as it can
+	 */
+	if (!avic_doorbell_strict && !kvm_vcpu_is_blocking(vcpu) && !is_guest_mode(vcpu))
+		return;
+
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 
 	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
 		return;
 
-	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
-
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0d6b715375a69..463b756f665ae 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -202,6 +202,9 @@ module_param(tsc_scaling, int, 0444);
 static bool avic;
 module_param(avic, bool, 0444);
 
+bool avic_doorbell_strict = true;
+module_param(avic_doorbell_strict, bool, 0444);
+
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -1340,7 +1343,8 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	svm->loaded = false;
 
 	if (svm->nested.initialized && svm->avic_enabled)
-		avic_physid_shadow_table_update_vcpu_location(vcpu, -1);
+		if (!avic_doorbell_strict || kvm_vcpu_is_blocking(vcpu))
+			avic_physid_shadow_table_update_vcpu_location(vcpu, -1);
 
 	svm_prepare_host_switch(vcpu);
 
@@ -4707,7 +4711,6 @@ static __init void svm_set_cpu_caps(void)
 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
 	if (nested) {
 		kvm_cpu_cap_set(X86_FEATURE_SVM);
-		kvm_cpu_cap_set(X86_FEATURE_VMCBCLEAN);
 
 		if (nrips)
 			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ebda12995abe..d0108bae2cdac 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -33,6 +33,7 @@
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern bool intercept_smi;
+extern bool avic_doorbell_strict;
 
 /*
  * Clean bits in VMCB.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cdf1fa3c60ae2..67a29233e216b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3291,9 +3291,10 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.generic.blocking = 1;
 
+	prepare_to_rcuwait(wait);
+
 	kvm_arch_vcpu_blocking(vcpu);
 
-	prepare_to_rcuwait(wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
-- 
2.26.3


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B935123A3
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbiD0ULW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236010AbiD0ULC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:11:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 371FB88B35
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651089919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+9l7/nYYuUFlKjIqI70hEfPt9KC0Picpboy6nUK0n3w=;
        b=FvNgvtAbX4u9R5jzSek1uJFA93YaRnLNAlImNs8ulp+bRtSpM6hMeMcvNvROLhh8vVbtYu
        y8Xw4BER5msjqYlFX2pVcQ3ubY+SdR+1++0Oo76i9YJkcXj6Ud9DRa+aPOpwf2jA5UYAw8
        K5gF6cTn8wV3rYhZ9iGaZ27UmTU+BmY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-5GoJeysdOquCIPBUL9jxLg-1; Wed, 27 Apr 2022 16:05:09 -0400
X-MC-Unique: 5GoJeysdOquCIPBUL9jxLg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B611785A5BC;
        Wed, 27 Apr 2022 20:05:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 477759E74;
        Wed, 27 Apr 2022 20:05:02 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org,
        Sean Christopherson <seanjc@google.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [RFC PATCH v3 16/19] KVM: x86: nSVM: implement support for nested AVIC vmexits
Date:   Wed, 27 Apr 2022 23:03:11 +0300
Message-Id: <20220427200314.276673-17-mlevitsk@redhat.com>
In-Reply-To: <20220427200314.276673-1-mlevitsk@redhat.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* SVM_EXIT_AVIC_UNACCELERATED_ACCESS is always forwarded to the L1

* SVM_EXIT_AVIC_INCOMPLETE_IPI is hidden from the guest if:

   - is_running was false in shadow physid page because L1's vCPU
     was scheduled out - in this case, the vCPU is waken up,
     and it will process nested AVIC on next VM entry

  - invalid physical address of avic backing page was present
    in the guest's physid page, which KVM translates to
    valid physical address of a dummy page and is_running=false.

    If this condition happens,
    the AVIC_IPI_FAILURE_INVALID_BACKING_PAGE VM exit is injected to
    the nested hypervisor.

* Note that it is possible to have SVM_EXIT_AVIC_INCOMPLETE_IPI
  VM exit happen both due to host and guest related reason
  at the same time:

  For example if a broadcast IPI was attempted and some shadow
  physid entries had 'is_running=false' set by the guest,
  and some had it set to false due to scheduled out L1 vCPUs.

  To support this case, all relevant entries of guest's physical
  and logical id tables are checked, and both host related actions
  (e.g wakeup) and guest vm exit reflection are done.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c   | 204 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/nested.c |  14 +++
 2 files changed, 216 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f13ca1e7b2845..e8c53fd77f0b1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -917,6 +917,164 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	}
 }
 
+static void
+avic_kick_target_vcpu_nested_physical(struct vcpu_svm *svm,
+				      int target_l2_apic_id,
+				      int *index,
+				      bool *invalid_page)
+{
+	u64 gentry, sentry;
+	int target_l1_apicid;
+	struct avic_physid_table *t = svm->nested.l2_physical_id_table;
+
+	if (WARN_ON_ONCE(!t))
+		return;
+
+	/*
+	 * This shouldn't normally happen because this condition
+	 * should cause AVIC_IPI_FAILURE_INVALID_TARGET vmexit,
+	 * however the guest can change the page and trigger this.
+	 */
+	if (target_l2_apic_id >= t->nentries)
+		return;
+
+	gentry = t->entries[target_l2_apic_id].gentry;
+	sentry = *t->entries[target_l2_apic_id].sentry;
+
+	/* Same reasoning as above  */
+	if (!(gentry & AVIC_PHYSICAL_ID_ENTRY_VALID_MASK))
+		return;
+
+	/*
+	 * This races against the guest updating is_running bit.
+	 *
+	 * Race itself happens on real hardware as well, and the guest
+	 * must use the correct means to avoid it.
+	 *
+	 * AVIC hardware already set IRR and should have done memory
+	 * barrier, and then found out that is_running is false
+	 * in shadow physid table.
+	 *
+	 * We are doing another is_running check (in the guest physid table),
+	 * completing it, thus don't need additional memory barrier.
+	 */
+
+	target_l1_apicid = physid_entry_get_apicid(gentry);
+
+	if (target_l1_apicid == -1) {
+
+		/* is_running is false, need to vmexit to the guest */
+		if (*index == -1) {
+			u64 backing_page_phys = physid_entry_get_backing_table(sentry);
+
+			*index = target_l2_apic_id;
+			if (backing_page_phys == t->dummy_page_hpa)
+				*invalid_page = true;
+		}
+	} else {
+		/* Wake up the target vCPU and hide the VM exit from the guest */
+		struct kvm_vcpu *target = avic_vcpu_by_l1_apicid(svm->vcpu.kvm, target_l1_apicid);
+
+		if (target && target != &svm->vcpu)
+			kvm_vcpu_wake_up(target);
+	}
+
+	trace_kvm_avic_nested_kick_vcpu(svm->vcpu.vcpu_id,
+					target_l2_apic_id,
+					target_l1_apicid);
+}
+
+static void
+avic_kick_target_vcpus_nested_logical(struct vcpu_svm *svm, unsigned long dest,
+				      int *index, bool *invalid_page)
+{
+	int logical_id;
+	u8 cluster = 0;
+	u64 *logical_id_table = (u64 *)svm->nested.l2_logical_id_table.hva;
+	int physical_index = -1;
+
+	if (WARN_ON_ONCE(!logical_id_table))
+		return;
+
+	if (nested_avic_get_reg(&svm->vcpu, APIC_DFR) == APIC_DFR_CLUSTER) {
+		if (dest >= 0x40)
+			return;
+		cluster = dest & 0x3C;
+		dest &= 0x3;
+	}
+
+	for_each_set_bit(logical_id, &dest, 8) {
+		int logical_index = cluster | logical_id;
+		u64 log_gentry = logical_id_table[logical_index];
+		int l2_apicid = logid_get_physid(log_gentry);
+
+		/* Should not happen as in this case AVIC should VM exit
+		 * with 'invalid target'
+
+		 * However the guest can change the entry under KVM's back,
+		 * thus ignore this case.
+		 */
+		if (l2_apicid == -1)
+			continue;
+
+		avic_kick_target_vcpu_nested_physical(svm, l2_apicid,
+						      &physical_index,
+						      invalid_page);
+
+		/* Reported index is the index of the logical entry in this case */
+		if (physical_index != -1)
+			*index = logical_index;
+	}
+}
+
+static void
+avic_kick_target_vcpus_nested_broadcast(struct vcpu_svm *svm,
+					int *index, bool *invalid_page)
+{
+	struct avic_physid_table *t = svm->nested.l2_physical_id_table;
+	int l2_apicid;
+
+	/*
+	 * This races against the guest changing the valid bit in the physid
+	 * table and/or increasing number of entries of the table.
+	 *
+	 * In both cases the race would happen on real hardware as well,
+	 * thus this code can avoid synchronization vs write tracking.
+	 */
+	for_each_set_bit(l2_apicid, t->valid_entires, AVIC_MAX_PHYSICAL_ID_COUNT)
+		avic_kick_target_vcpu_nested_physical(svm, l2_apicid,
+						      index, invalid_page);
+}
+
+static void avic_kick_target_vcpus_nested(struct kvm_vcpu *vcpu,
+					struct kvm_lapic *source,
+					u32 icrl, u32 icrh,
+					int *index, bool *invalid_page)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int dest = GET_APIC_DEST_FIELD(icrh);
+
+	switch (icrl & APIC_SHORT_MASK) {
+	case APIC_DEST_NOSHORT:
+		if (dest == 0xFF)
+			avic_kick_target_vcpus_nested_broadcast(svm,
+					index, invalid_page);
+		else if (icrl & APIC_DEST_MASK)
+			avic_kick_target_vcpus_nested_logical(svm, dest,
+					index, invalid_page);
+		else
+			avic_kick_target_vcpu_nested_physical(svm, dest,
+					index, invalid_page);
+		break;
+	case APIC_DEST_ALLINC:
+	case APIC_DEST_ALLBUT:
+		avic_kick_target_vcpus_nested_broadcast(svm, index, invalid_page);
+		break;
+	case APIC_DEST_SELF:
+		break;
+	}
+}
+
 int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -924,10 +1082,20 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	u32 icrl = svm->vmcb->control.exit_info_1;
 	u32 id = svm->vmcb->control.exit_info_2 >> 32;
 	u32 index = svm->vmcb->control.exit_info_2 & 0x1FF;
+	int nindex = -1;
+	bool invalid_page = false;
+
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
 
+	if (is_guest_mode(&svm->vcpu)) {
+		if (WARN_ON_ONCE(!nested_avic_in_use(vcpu)))
+			return 1;
+		if (WARN_ON_ONCE(!svm->nested.l2_physical_id_table))
+			return 1;
+	}
+
 	switch (id) {
 	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
 		/*
@@ -939,23 +1107,49 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 * which case KVM needs to emulate the ICR write as well in
 		 * order to clear the BUSY flag.
 		 */
+		if (is_guest_mode(&svm->vcpu)) {
+			nested_svm_vmexit(svm);
+			break;
+		}
+
 		if (icrl & APIC_ICR_BUSY)
 			kvm_apic_write_nodecode(vcpu, APIC_ICR);
 		else
 			kvm_apic_send_ipi(apic, icrl, icrh);
+
 		break;
 	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
 		/*
 		 * At this point, we expect that the AVIC HW has already
 		 * set the appropriate IRR bits on the valid target
 		 * vcpus. So, we just need to kick the appropriate vcpu.
+		 *
+		 * If nested KVM might also need to reflect the VM exit to
+		 * the guest.
 		 */
-		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
+		if (!is_guest_mode(&svm->vcpu)) {
+			avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
+			break;
+		}
+
+		avic_kick_target_vcpus_nested(vcpu, apic, icrl, icrh,
+					      &nindex, &invalid_page);
+		if (nindex != -1) {
+			if (invalid_page)
+				id = AVIC_IPI_FAILURE_INVALID_BACKING_PAGE;
+
+			svm->vmcb->control.exit_info_2 =  ((u64)id << 32) | nindex;
+			nested_svm_vmexit(svm);
+		}
 		break;
 	case AVIC_IPI_FAILURE_INVALID_TARGET:
+		if (is_guest_mode(&svm->vcpu))
+			nested_svm_vmexit(svm);
+		else
+			WARN_ON_ONCE(1);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
-		WARN_ONCE(1, "Invalid backing page\n");
+		WARN_ON_ONCE(1);
 		break;
 	default:
 		pr_err("Unknown IPI interception\n");
@@ -1064,9 +1258,13 @@ static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
 
 static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 offset = to_svm(vcpu)->vmcb->control.exit_info_1 &
 				AVIC_UNACCEL_ACCESS_OFFSET_MASK;
 
+	if (WARN_ON_ONCE(is_guest_mode(&svm->vcpu)))
+		return 0;
+
 	switch (offset) {
 	case APIC_LDR:
 		if (avic_handle_ldr_update(vcpu))
@@ -1124,6 +1322,8 @@ int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu)
 		     AVIC_UNACCEL_ACCESS_WRITE_MASK;
 	bool trap = is_avic_unaccelerated_access_trap(offset);
 
+	WARN_ON_ONCE(is_guest_mode(&svm->vcpu));
+
 	trace_kvm_avic_unaccelerated_access(vcpu->vcpu_id, offset,
 					    trap, write, vector);
 	if (trap) {
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index eb5e9b600e052..decc665d7cc69 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1320,6 +1320,20 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		vmexit = NESTED_EXIT_DONE;
 		break;
 	}
+	case SVM_EXIT_AVIC_UNACCELERATED_ACCESS: {
+		/*
+		 * Unaccelerated AVIC access is always reflected.
+		 * Also there is no intercept bit for it.
+		 */
+		vmexit = NESTED_EXIT_DONE;
+		break;
+	}
+	case SVM_EXIT_AVIC_INCOMPLETE_IPI:
+		/*
+		 * Doesn't have an intercept bit, host needs to check
+		 * if to reflect it to the guest or handle it by itself.
+		 */
+		break;
 	default: {
 		if (vmcb12_is_intercept(&svm->nested.ctl, exit_code))
 			vmexit = NESTED_EXIT_DONE;
-- 
2.26.3


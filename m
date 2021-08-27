Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A973F96E8
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244797AbhH0J0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 05:26:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244771AbhH0J0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 05:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630056356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nEdDz4lJvfVQmKns+107BOpFRlx3QH8ZfZRuj0/cXvY=;
        b=eLjvkooAmQwb0KrYikU32XouwZWI69qNhFOIrC2gcOYixkXN8Ezp7PZ4QXEC0G1sm9PV0y
        G6JA3m8p6O3LjI2w4oKrtPGv0urfOXYk+XIH3JOF94HUkwtZvTr874M+MmgBGH6KJdejS+
        w2r+aFX+gUTlLy9vUqTwpHFr7jbgZII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-TotXXjUjPba4DS2jT4yxzQ-1; Fri, 27 Aug 2021 05:25:54 -0400
X-MC-Unique: TotXXjUjPba4DS2jT4yxzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5C21800493;
        Fri, 27 Aug 2021 09:25:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42F8160C04;
        Fri, 27 Aug 2021 09:25:51 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 8/8] KVM: Make kvm_make_vcpus_request_mask() use pre-allocated cpu_kick_mask
Date:   Fri, 27 Aug 2021 11:25:16 +0200
Message-Id: <20210827092516.1027264-9-vkuznets@redhat.com>
In-Reply-To: <20210827092516.1027264-1-vkuznets@redhat.com>
References: <20210827092516.1027264-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_make_vcpus_request_mask() already disables preemption so just like
kvm_make_all_cpus_request_except() it can be switched to using
pre-allocated per-cpu cpumasks. This allows for improvements for both
users of the function: in Hyper-V emulation code 'tlb_flush' can now be
dropped from 'struct kvm_vcpu_hv' and kvm_make_scan_ioapic_request_mask()
gets rid of dynamic allocation.

cpumask_available() check in kvm_make_vcpu_request() can now be dropped as
it checks for an impossible condition: kvm_init() makes sure per-cpu masks
are allocated.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/hyperv.c           |  5 +----
 arch/x86/kvm/x86.c              |  8 +-------
 include/linux/kvm_host.h        |  2 +-
 virt/kvm/kvm_main.c             | 18 +++++++-----------
 5 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09b256db394a..846552fa2012 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -569,7 +569,6 @@ struct kvm_vcpu_hv {
 	struct kvm_hyperv_exit exit;
 	struct kvm_vcpu_hv_stimer stimer[HV_SYNIC_STIMER_COUNT];
 	DECLARE_BITMAP(stimer_pending_bitmap, HV_SYNIC_STIMER_COUNT);
-	cpumask_t tlb_flush;
 	bool enforce_cpuid;
 	struct {
 		u32 features_eax; /* HYPERV_CPUID_FEATURES.EAX */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 5704bfe53ee0..f76e7228f687 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1755,7 +1755,6 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	int i;
 	gpa_t gpa;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
 	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
@@ -1837,8 +1836,6 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 		}
 	}
 
-	cpumask_clear(&hv_vcpu->tlb_flush);
-
 	/*
 	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
 	 * analyze it here, flush TLB regardless of the specified address space.
@@ -1850,7 +1847,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 						    vp_bitmap, vcpu_bitmap);
 
 		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
-					    vcpu_mask, &hv_vcpu->tlb_flush);
+					    vcpu_mask);
 	}
 
 ret_success:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a4752dcc2a75..91c1e6c98b0f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9224,14 +9224,8 @@ static void process_smi(struct kvm_vcpu *vcpu)
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap)
 {
-	cpumask_var_t cpus;
-
-	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
-
 	kvm_make_vcpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC,
-				    vcpu_bitmap, cpus);
-
-	free_cpumask_var(cpus);
+				    vcpu_bitmap);
 }
 
 void kvm_make_scan_ioapic_request(struct kvm *kvm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2f149ed140f7..1ee85de0bf74 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -160,7 +160,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_ARCH_REQ(nr)           KVM_ARCH_REQ_FLAGS(nr, 0)
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
-				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
+				 unsigned long *vcpu_bitmap);
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2f5fe4f54a51..dc52a04f0586 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -274,14 +274,6 @@ static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
 		return;
 
-	/*
-	 * tmp can be "unavailable" if cpumasks are allocated off stack as
-	 * allocation of the mask is deliberately not fatal and is handled by
-	 * falling back to kicking all online CPUs.
-	 */
-	if (!cpumask_available(tmp))
-		return;
-
 	/*
 	 * Note, the vCPU could get migrated to a different pCPU at any point
 	 * after kvm_request_needs_ipi(), which could result in sending an IPI
@@ -300,22 +292,26 @@ static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
 }
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
-				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
+				 unsigned long *vcpu_bitmap)
 {
 	struct kvm_vcpu *vcpu;
+	struct cpumask *cpus;
 	int i, me;
 	bool called;
 
 	me = get_cpu();
 
+	cpus = this_cpu_cpumask_var_ptr(cpu_kick_mask);
+	cpumask_clear(cpus);
+
 	for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
 		vcpu = kvm_get_vcpu(kvm, i);
 		if (!vcpu)
 			continue;
-		kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
+		kvm_make_vcpu_request(kvm, vcpu, req, cpus, me);
 	}
 
-	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
+	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
 	put_cpu();
 
 	return called;
-- 
2.31.1


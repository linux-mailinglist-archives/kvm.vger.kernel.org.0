Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D69303F68
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405587AbhAZNzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:55:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405411AbhAZNuM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:50:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ftrHr91rXNBSoapKb4hVUlryRwpGoCgFbG1u/qTrV04=;
        b=O7nBBy4a+qsyAEPpM62VnCkNZlvrioYsoy5OvVAMiMrphCy9FIuJj0l6ubAMD3CqTyvPL6
        VlWgxjHBTcec9BBEKwRnCzuG1vNH1G6C6zZaoJA0xQ8Lfcwk8oAX7tKn0G/yiTh45Cmxhe
        /iEoycDUnjmQqYGScPbvCVK6Q3QxHGQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-BjLbsjitPXydrLo3GMiDew-1; Tue, 26 Jan 2021 08:48:43 -0500
X-MC-Unique: BjLbsjitPXydrLo3GMiDew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B74C4192CC40;
        Tue, 26 Jan 2021 13:48:42 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 590C55D9DC;
        Tue, 26 Jan 2021 13:48:41 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 12/15] KVM: x86: hyper-v: Allocate 'struct kvm_vcpu_hv' dynamically
Date:   Tue, 26 Jan 2021 14:48:13 +0100
Message-Id: <20210126134816.1880136-13-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V context is only needed for guests which use Hyper-V emulation in
KVM (e.g. Windows/Hyper-V guests). 'struct kvm_vcpu_hv' is, however, quite
big, it accounts for more than 1/4 of the total 'struct kvm_vcpu_arch'
which is also quite big already. This all looks like a waste.

Allocate 'struct kvm_vcpu_hv' dynamically. This patch does not bring any
(intentional) functional change as we still allocate the context
unconditionally but it paves the way to doing that only when needed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/hyperv.c           | 16 ++++++++++++++--
 arch/x86/kvm/hyperv.h           | 13 ++++++-------
 arch/x86/kvm/x86.c              |  7 +++++--
 4 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d6616f6f6ef..a1dda14bdf4b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -510,6 +510,7 @@ struct kvm_vcpu_hv_synic {
 
 /* Hyper-V per vcpu emulation context */
 struct kvm_vcpu_hv {
+	struct kvm_vcpu *vcpu;
 	u32 vp_index;
 	u64 hv_vapic;
 	s64 runtime_offset;
@@ -717,7 +718,7 @@ struct kvm_vcpu_arch {
 	/* used for guest single stepping over the given code position */
 	unsigned long singlestep_rip;
 
-	struct kvm_vcpu_hv hyperv;
+	struct kvm_vcpu_hv *hyperv;
 
 	cpumask_var_t wbinvd_dirty_mask;
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2823473c84a2..8fcd1dfed998 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -836,6 +836,9 @@ void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
 		stimer_cleanup(&hv_vcpu->stimer[i]);
+
+	kfree(hv_vcpu);
+	vcpu->arch.hyperv = NULL;
 }
 
 bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
@@ -885,16 +888,25 @@ static void stimer_init(struct kvm_vcpu_hv_stimer *stimer, int timer_index)
 	stimer_prepare_msg(stimer);
 }
 
-void kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
+int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	struct kvm_vcpu_hv *hv_vcpu;
 	int i;
 
+	hv_vcpu = kzalloc(sizeof(struct kvm_vcpu_hv), GFP_KERNEL_ACCOUNT);
+	if (!hv_vcpu)
+		return -ENOMEM;
+
+	vcpu->arch.hyperv = hv_vcpu;
+	hv_vcpu->vcpu = vcpu;
+
 	synic_init(&hv_vcpu->synic);
 
 	bitmap_zero(hv_vcpu->stimer_pending_bitmap, HV_SYNIC_STIMER_COUNT);
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
 		stimer_init(&hv_vcpu->stimer[i], i);
+
+	return 0;
 }
 
 void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 2258bcc34ada..51d0d61a515c 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -57,20 +57,19 @@ static inline struct kvm_hv *to_kvm_hv(struct kvm *kvm)
 
 static inline struct kvm_vcpu_hv *to_hv_vcpu(struct kvm_vcpu *vcpu)
 {
-	return &vcpu->arch.hyperv;
+	return vcpu->arch.hyperv;
 }
 
 static inline struct kvm_vcpu *hv_vcpu_to_vcpu(struct kvm_vcpu_hv *hv_vcpu)
 {
-	struct kvm_vcpu_arch *arch;
-
-	arch = container_of(hv_vcpu, struct kvm_vcpu_arch, hyperv);
-	return container_of(arch, struct kvm_vcpu, arch);
+	return hv_vcpu->vcpu;
 }
 
 static inline struct kvm_vcpu_hv_synic *to_hv_synic(struct kvm_vcpu *vcpu)
 {
-	return &vcpu->arch.hyperv.synic;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	return &hv_vcpu->synic;
 }
 
 static inline struct kvm_vcpu *hv_synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
@@ -101,7 +100,7 @@ int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
 
-void kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
+int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d5d36134093..e612bde18e99 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10007,11 +10007,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
 
-	kvm_hv_vcpu_init(vcpu);
+	if (kvm_hv_vcpu_init(vcpu))
+		goto free_guest_fpu;
 
 	r = kvm_x86_ops.vcpu_create(vcpu);
 	if (r)
-		goto free_guest_fpu;
+		goto free_hv_vcpu;
 
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
@@ -10022,6 +10023,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 	return 0;
 
+free_hv_vcpu:
+	kvm_hv_vcpu_uninit(vcpu);
 free_guest_fpu:
 	kvm_free_guest_fpu(vcpu);
 free_user_fpu:
-- 
2.29.2


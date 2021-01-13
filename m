Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA2C2F4D53
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbhAMOjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:39:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726868AbhAMOjF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:39:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610548658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0W8OW81Y0YZvDnYJ8uNeryDJKzNsrknOXDICtVsMuw=;
        b=fZDYeksoJWqxItkYstB0ED/F4r4Li5eldYuOIsKumaLwiozV3aP0thGqSBgMB+IvXLb/Ma
        tLVtyRoqn+Bz/0Seq8xtN0MLPo2kox6d71WW6tNBRWhtl6K2JEceMqAyxHmj1huh/QfD/y
        lR4Rz/n2NkGcNNv5vn4D/E7fuT9Fqoo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-IUUfH3PaNe-Vkv3klOdY7Q-1; Wed, 13 Jan 2021 09:37:36 -0500
X-MC-Unique: IUUfH3PaNe-Vkv3klOdY7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25742107ACFE;
        Wed, 13 Jan 2021 14:37:35 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24A345F708;
        Wed, 13 Jan 2021 14:37:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 5/7] KVM: x86: hyper-v: Allocate 'struct kvm_vcpu_hv' dynamically
Date:   Wed, 13 Jan 2021 15:37:19 +0100
Message-Id: <20210113143721.328594-6-vkuznets@redhat.com>
In-Reply-To: <20210113143721.328594-1-vkuznets@redhat.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 3ab7b46087b7..94d00926b7ad 100644
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
index 77deaadb8575..df7101b721e7 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -838,6 +838,9 @@ void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
 		stimer_cleanup(&hv_vcpu->stimer[i]);
+
+	kfree(hv_vcpu);
+	vcpu->arch.hyperv = NULL;
 }
 
 bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
@@ -887,16 +890,25 @@ static void stimer_init(struct kvm_vcpu_hv_stimer *stimer, int timer_index)
 	stimer_prepare_msg(stimer);
 }
 
-void kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
+int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
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
index 9ec7d686145a..a19e298463d0 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -52,20 +52,19 @@
 
 static inline struct kvm_vcpu_hv *vcpu_to_hv_vcpu(struct kvm_vcpu *vcpu)
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
 
 static inline struct kvm_vcpu_hv_synic *vcpu_to_synic(struct kvm_vcpu *vcpu)
 {
-	return &vcpu->arch.hyperv.synic;
+	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+
+	return &hv_vcpu->synic;
 }
 
 static inline struct kvm_vcpu *synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
@@ -96,7 +95,7 @@ int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
 
-void kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
+int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fa077b47c0ed..e08209f570f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9990,11 +9990,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
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
@@ -10005,6 +10006,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 	return 0;
 
+free_hv_vcpu:
+	kvm_hv_vcpu_uninit(vcpu);
 free_guest_fpu:
 	kvm_free_guest_fpu(vcpu);
 free_user_fpu:
-- 
2.29.2


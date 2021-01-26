Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E3C303F48
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405429AbhAZNu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:50:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404751AbhAZNuR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:50:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHw7/+DvB90lmusTEx4KGIFjfnrXEX2fTzakjErsjAI=;
        b=dDZD40nvHjt8R8rU1qH2f4Qx4fcIEebXEqu5UVACexlg9VKYNi1fzEtMKoYt+lTXYL1D1S
        9l8+oifocG7XXUO0FOKACDzkr1x42DlsprPIksmFpjFmwe6XOIvhfYFa/r+y0r9EQbFTYt
        drOFkmf8kuG1funzi04UMT9IAatvDzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-3dSevzzsOq-XWR-0XqhvGg-1; Tue, 26 Jan 2021 08:48:47 -0500
X-MC-Unique: 3dSevzzsOq-XWR-0XqhvGg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43C95801FD6;
        Tue, 26 Jan 2021 13:48:46 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C09EE5D9DC;
        Tue, 26 Jan 2021 13:48:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 14/15] KVM: x86: hyper-v: Allocate Hyper-V context lazily
Date:   Tue, 26 Jan 2021 14:48:15 +0100
Message-Id: <20210126134816.1880136-15-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V context is only needed for guests which use Hyper-V emulation in
KVM (e.g. Windows/Hyper-V guests) so we don't actually need to allocate
it in kvm_arch_vcpu_create(), we can postpone the action until Hyper-V
specific MSRs are accessed or SynIC is enabled.

Once allocated, let's keep the context alive for the lifetime of the vCPU
as an attempt to free it would require additional synchronization with
other vCPUs and normally it is not supposed to happen.

Note, Hyper-V style hypercall enablement is done by writing to
HV_X64_MSR_GUEST_OS_ID so we don't need to worry about allocating Hyper-V
context from kvm_hv_hypercall().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 33 +++++++++++++++++++++++++--------
 arch/x86/kvm/hyperv.h |  2 --
 arch/x86/kvm/x86.c    |  9 +--------
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ce7dab132d04..a6785176e0e7 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -837,6 +837,9 @@ void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	int i;
 
+	if (!hv_vcpu)
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
 		stimer_cleanup(&hv_vcpu->stimer[i]);
 
@@ -891,7 +894,7 @@ static void stimer_init(struct kvm_vcpu_hv_stimer *stimer, int timer_index)
 	stimer_prepare_msg(stimer);
 }
 
-int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
+static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu;
 	int i;
@@ -909,19 +912,23 @@ int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
 		stimer_init(&hv_vcpu->stimer[i], i);
 
+	hv_vcpu->vp_index = kvm_vcpu_get_idx(vcpu);
+
 	return 0;
 }
 
-void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu)
+int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 {
-	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	struct kvm_vcpu_hv_synic *synic;
+	int r;
 
-	hv_vcpu->vp_index = kvm_vcpu_get_idx(vcpu);
-}
+	if (!to_hv_vcpu(vcpu)) {
+		r = kvm_hv_vcpu_init(vcpu);
+		if (r)
+			return r;
+	}
 
-int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
-{
-	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
+	synic = to_hv_synic(vcpu);
 
 	/*
 	 * Hyper-V SynIC auto EOI SINT's are
@@ -1461,6 +1468,11 @@ int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	if (!host && !vcpu->arch.hyperv_enabled)
 		return 1;
 
+	if (!to_hv_vcpu(vcpu)) {
+		if (kvm_hv_vcpu_init(vcpu))
+			return 1;
+	}
+
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
 
@@ -1479,6 +1491,11 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	if (!host && !vcpu->arch.hyperv_enabled)
 		return 1;
 
+	if (!to_hv_vcpu(vcpu)) {
+		if (kvm_hv_vcpu_init(vcpu))
+			return 1;
+	}
+
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
 
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 2d50c8df9355..a0926125495a 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -100,8 +100,6 @@ int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
 
-int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu);
 
 bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e97f4eeed897..4c3e47b8a5c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10007,12 +10007,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
 
-	if (kvm_hv_vcpu_init(vcpu))
-		goto free_guest_fpu;
-
 	r = kvm_x86_ops.vcpu_create(vcpu);
 	if (r)
-		goto free_hv_vcpu;
+		goto free_guest_fpu;
 
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
@@ -10023,8 +10020,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 	return 0;
 
-free_hv_vcpu:
-	kvm_hv_vcpu_uninit(vcpu);
 free_guest_fpu:
 	kvm_free_guest_fpu(vcpu);
 free_user_fpu:
@@ -10048,8 +10043,6 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	kvm_hv_vcpu_postcreate(vcpu);
-
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-- 
2.29.2


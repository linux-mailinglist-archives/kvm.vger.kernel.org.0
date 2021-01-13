Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657FB2F4D55
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbhAMOjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:39:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbhAMOjI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:39:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610548661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TkxVqwHz7SysghG9KVwLIy5r2NtnzWW/e+IgUngK7Dc=;
        b=PIOvlFwsAmZ6ENEbtfCHD73F2j3ZVIKDEkGXLj/1/1O5kxCCOi6GxyQMXn13phwuGYPoVf
        I13N4vd3Y5pwS+wob1eUzZWvFPjVv5DXTaxuUy0N3HsXpw2heAPxnqHCqhNKcreE6oBaIM
        jHyJYa4Uj6pZgkzAMpYBfHoDVngtQ0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-Xl1XzafENLCuk2S3QgEbTA-1; Wed, 13 Jan 2021 09:37:40 -0500
X-MC-Unique: Xl1XzafENLCuk2S3QgEbTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E25A8107ACF8;
        Wed, 13 Jan 2021 14:37:38 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76D115C3E4;
        Wed, 13 Jan 2021 14:37:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 7/7] KVM: x86: hyper-v: Allocate Hyper-V context lazily
Date:   Wed, 13 Jan 2021 15:37:21 +0100
Message-Id: <20210113143721.328594-8-vkuznets@redhat.com>
In-Reply-To: <20210113143721.328594-1-vkuznets@redhat.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 81166401c353..9d52669409c5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -839,6 +839,9 @@ void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
 	int i;
 
+	if (!hv_vcpu)
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
 		stimer_cleanup(&hv_vcpu->stimer[i]);
 
@@ -893,7 +896,7 @@ static void stimer_init(struct kvm_vcpu_hv_stimer *stimer, int timer_index)
 	stimer_prepare_msg(stimer);
 }
 
-int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
+static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu;
 	int i;
@@ -911,19 +914,23 @@ int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
 		stimer_init(&hv_vcpu->stimer[i], i);
 
+	hv_vcpu->vp_index = kvm_vcpu_get_idx(vcpu);
+
 	return 0;
 }
 
-void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu)
+int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 {
-	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+	struct kvm_vcpu_hv_synic *synic;
+	int r;
 
-	hv_vcpu->vp_index = kvm_vcpu_get_idx(vcpu);
-}
+	if (!vcpu_to_hv_vcpu(vcpu)) {
+		r = kvm_hv_vcpu_init(vcpu);
+		if (r)
+			return r;
+	}
 
-int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
-{
-	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+	synic = vcpu_to_synic(vcpu);
 
 	/*
 	 * Hyper-V SynIC auto EOI SINT's are
@@ -1463,6 +1470,11 @@ int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	if (!host && !vcpu->arch.hyperv_enabled)
 		return 1;
 
+	if (!vcpu_to_hv_vcpu(vcpu)) {
+		if (kvm_hv_vcpu_init(vcpu))
+			return 1;
+	}
+
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
 
@@ -1479,6 +1491,11 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	if (!host && !vcpu->arch.hyperv_enabled)
 		return 1;
 
+	if (!vcpu_to_hv_vcpu(vcpu)) {
+		if (kvm_hv_vcpu_init(vcpu))
+			return 1;
+	}
+
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
 
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 070a301738ec..4352d3164636 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -95,8 +95,6 @@ int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
 
-int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu);
 
 bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58dd98b3c95c..73243cc7d029 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9990,12 +9990,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
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
@@ -10006,8 +10003,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 	return 0;
 
-free_hv_vcpu:
-	kvm_hv_vcpu_uninit(vcpu);
 free_guest_fpu:
 	kvm_free_guest_fpu(vcpu);
 free_user_fpu:
@@ -10031,8 +10026,6 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	kvm_hv_vcpu_postcreate(vcpu);
-
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-- 
2.29.2


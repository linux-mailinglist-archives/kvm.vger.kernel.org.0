Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B09303F6C
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405560AbhAZNzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:55:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405391AbhAZNuH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:50:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=80bGmTQgNqT9Gk9zFVD7gMG584iILJ+eyaj0kOWHEtw=;
        b=BB+5FwNPUTdfeKjHkIwJWmQ4PJ60K4okdO595IJSWDVoSv1iOrjAY5NCbIjvJCM/tNwa1d
        NSQs/X2Wp7uwiBsqlTJZmaA2um7hpP5OIs8ZOaMpdi9PWNj6ccbOgU5TcnXt1HsAB55YT5
        Bbea51eCtzX++zWcWaBJnOwfiqDo4+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-tRoKna1yNsOcvJ_GtIfY9g-1; Tue, 26 Jan 2021 08:48:37 -0500
X-MC-Unique: tRoKna1yNsOcvJ_GtIfY9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8ACD192CC40;
        Tue, 26 Jan 2021 13:48:35 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8D9D5D9C2;
        Tue, 26 Jan 2021 13:48:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 08/15] KVM: x86: hyper-v: Introduce to_kvm_hv() helper
Date:   Tue, 26 Jan 2021 14:48:09 +0100
Message-Id: <20210126134816.1880136-9-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Spelling '&kvm->arch.hyperv' correctly is hard. Also, this makes the code
more consistent with vmx/svm where to_kvm_vmx()/to_kvm_svm() are already
being used.

Opportunistically change kvm_hv_msr_{get,set}_crash_{data,ctl}() and
kvm_hv_msr_set_crash_data() to take 'kvm' instead of 'vcpu' as these
MSRs are partition wide.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c  | 107 +++++++++++++++++++++--------------------
 arch/x86/kvm/hyperv.h  |   5 ++
 arch/x86/kvm/vmx/vmx.c |   3 +-
 arch/x86/kvm/x86.c     |   2 +-
 4 files changed, 64 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 83748e016b4d..d60f60ac53f1 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -282,8 +282,7 @@ static bool kvm_hv_is_syndbg_enabled(struct kvm_vcpu *vcpu)
 
 static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = vcpu->kvm;
-	struct kvm_hv *hv = &kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
 
 	if (vcpu->run->hyperv.u.syndbg.msr == HV_X64_MSR_SYNDBG_CONTROL)
 		hv->hv_syndbg.control.status =
@@ -514,7 +513,7 @@ static void synic_init(struct kvm_vcpu_hv_synic *synic)
 
 static u64 get_time_ref_counter(struct kvm *kvm)
 {
-	struct kvm_hv *hv = &kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 	struct kvm_vcpu *vcpu;
 	u64 tsc;
 
@@ -939,10 +938,9 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
 	return r;
 }
 
-static int kvm_hv_msr_get_crash_data(struct kvm_vcpu *vcpu,
-				     u32 index, u64 *pdata)
+static int kvm_hv_msr_get_crash_data(struct kvm *kvm, u32 index, u64 *pdata)
 {
-	struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 	size_t size = ARRAY_SIZE(hv->hv_crash_param);
 
 	if (WARN_ON_ONCE(index >= size))
@@ -952,41 +950,26 @@ static int kvm_hv_msr_get_crash_data(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int kvm_hv_msr_get_crash_ctl(struct kvm_vcpu *vcpu, u64 *pdata)
+static int kvm_hv_msr_get_crash_ctl(struct kvm *kvm, u64 *pdata)
 {
-	struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 
 	*pdata = hv->hv_crash_ctl;
 	return 0;
 }
 
-static int kvm_hv_msr_set_crash_ctl(struct kvm_vcpu *vcpu, u64 data, bool host)
+static int kvm_hv_msr_set_crash_ctl(struct kvm *kvm, u64 data)
 {
-	struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
-
-	if (host)
-		hv->hv_crash_ctl = data & HV_CRASH_CTL_CRASH_NOTIFY;
-
-	if (!host && (data & HV_CRASH_CTL_CRASH_NOTIFY)) {
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 
-		vcpu_debug(vcpu, "hv crash (0x%llx 0x%llx 0x%llx 0x%llx 0x%llx)\n",
-			  hv->hv_crash_param[0],
-			  hv->hv_crash_param[1],
-			  hv->hv_crash_param[2],
-			  hv->hv_crash_param[3],
-			  hv->hv_crash_param[4]);
-
-		/* Send notification about crash to user space */
-		kvm_make_request(KVM_REQ_HV_CRASH, vcpu);
-	}
+	hv->hv_crash_ctl = data & HV_CRASH_CTL_CRASH_NOTIFY;
 
 	return 0;
 }
 
-static int kvm_hv_msr_set_crash_data(struct kvm_vcpu *vcpu,
-				     u32 index, u64 data)
+static int kvm_hv_msr_set_crash_data(struct kvm *kvm, u32 index, u64 data)
 {
-	struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 	size_t size = ARRAY_SIZE(hv->hv_crash_param);
 
 	if (WARN_ON_ONCE(index >= size))
@@ -1068,7 +1051,7 @@ static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
 void kvm_hv_setup_tsc_page(struct kvm *kvm,
 			   struct pvclock_vcpu_time_info *hv_clock)
 {
-	struct kvm_hv *hv = &kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 	u32 tsc_seq;
 	u64 gfn;
 
@@ -1078,7 +1061,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 		return;
 
-	mutex_lock(&kvm->arch.hyperv.hv_lock);
+	mutex_lock(&hv->hv_lock);
 	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 		goto out_unlock;
 
@@ -1122,14 +1105,14 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	kvm_write_guest(kvm, gfn_to_gpa(gfn),
 			&hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence));
 out_unlock:
-	mutex_unlock(&kvm->arch.hyperv.hv_lock);
+	mutex_unlock(&hv->hv_lock);
 }
 
 static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 			     bool host)
 {
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_hv *hv = &kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 
 	switch (msr) {
 	case HV_X64_MSR_GUEST_OS_ID:
@@ -1168,11 +1151,25 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 		break;
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
-		return kvm_hv_msr_set_crash_data(vcpu,
+		return kvm_hv_msr_set_crash_data(kvm,
 						 msr - HV_X64_MSR_CRASH_P0,
 						 data);
 	case HV_X64_MSR_CRASH_CTL:
-		return kvm_hv_msr_set_crash_ctl(vcpu, data, host);
+		if (host)
+			return kvm_hv_msr_set_crash_ctl(kvm, data);
+
+		if (data & HV_CRASH_CTL_CRASH_NOTIFY) {
+			vcpu_debug(vcpu, "hv crash (0x%llx 0x%llx 0x%llx 0x%llx 0x%llx)\n",
+				   hv->hv_crash_param[0],
+				   hv->hv_crash_param[1],
+				   hv->hv_crash_param[2],
+				   hv->hv_crash_param[3],
+				   hv->hv_crash_param[4]);
+
+			/* Send notification about crash to user space */
+			kvm_make_request(KVM_REQ_HV_CRASH, vcpu);
+		}
+		break;
 	case HV_X64_MSR_RESET:
 		if (data == 1) {
 			vcpu_debug(vcpu, "hyper-v reset requested\n");
@@ -1220,7 +1217,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX: {
-		struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
+		struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
 		int vcpu_idx = kvm_vcpu_get_idx(vcpu);
 		u32 new_vp_index = (u32)data;
 
@@ -1330,7 +1327,7 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 {
 	u64 data = 0;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_hv *hv = &kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 
 	switch (msr) {
 	case HV_X64_MSR_GUEST_OS_ID:
@@ -1346,11 +1343,11 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = hv->hv_tsc_page;
 		break;
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
-		return kvm_hv_msr_get_crash_data(vcpu,
+		return kvm_hv_msr_get_crash_data(kvm,
 						 msr - HV_X64_MSR_CRASH_P0,
 						 pdata);
 	case HV_X64_MSR_CRASH_CTL:
-		return kvm_hv_msr_get_crash_ctl(vcpu, pdata);
+		return kvm_hv_msr_get_crash_ctl(kvm, pdata);
 	case HV_X64_MSR_RESET:
 		data = 0;
 		break;
@@ -1438,12 +1435,14 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 
 int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 {
+	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
+
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
 
-		mutex_lock(&vcpu->kvm->arch.hyperv.hv_lock);
+		mutex_lock(&hv->hv_lock);
 		r = kvm_hv_set_msr_pw(vcpu, msr, data, host);
-		mutex_unlock(&vcpu->kvm->arch.hyperv.hv_lock);
+		mutex_unlock(&hv->hv_lock);
 		return r;
 	} else
 		return kvm_hv_set_msr(vcpu, msr, data, host);
@@ -1451,12 +1450,14 @@ int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 
 int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 {
+	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
+
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
 
-		mutex_lock(&vcpu->kvm->arch.hyperv.hv_lock);
+		mutex_lock(&hv->hv_lock);
 		r = kvm_hv_get_msr_pw(vcpu, msr, pdata, host);
-		mutex_unlock(&vcpu->kvm->arch.hyperv.hv_lock);
+		mutex_unlock(&hv->hv_lock);
 		return r;
 	} else
 		return kvm_hv_get_msr(vcpu, msr, pdata, host);
@@ -1466,7 +1467,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 	struct kvm *kvm, u64 *sparse_banks, u64 valid_bank_mask,
 	u64 *vp_bitmap, unsigned long *vcpu_bitmap)
 {
-	struct kvm_hv *hv = &kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 	struct kvm_vcpu *vcpu;
 	int i, bank, sbank = 0;
 
@@ -1668,7 +1669,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
 bool kvm_hv_hypercall_enabled(struct kvm *kvm)
 {
-	return READ_ONCE(kvm->arch.hyperv.hv_guest_os_id) != 0;
+	return to_kvm_hv(kvm)->hv_guest_os_id != 0;
 }
 
 static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
@@ -1698,6 +1699,7 @@ static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 
 static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
 {
+	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
 	struct eventfd_ctx *eventfd;
 
 	if (unlikely(!fast)) {
@@ -1726,7 +1728,7 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
 
 	/* the eventfd is protected by vcpu->kvm->srcu, but conn_to_evt isn't */
 	rcu_read_lock();
-	eventfd = idr_find(&vcpu->kvm->arch.hyperv.conn_to_evt, param);
+	eventfd = idr_find(&hv->conn_to_evt, param);
 	rcu_read_unlock();
 	if (!eventfd)
 		return HV_STATUS_INVALID_PORT_ID;
@@ -1885,23 +1887,26 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 
 void kvm_hv_init_vm(struct kvm *kvm)
 {
-	mutex_init(&kvm->arch.hyperv.hv_lock);
-	idr_init(&kvm->arch.hyperv.conn_to_evt);
+	struct kvm_hv *hv = to_kvm_hv(kvm);
+
+	mutex_init(&hv->hv_lock);
+	idr_init(&hv->conn_to_evt);
 }
 
 void kvm_hv_destroy_vm(struct kvm *kvm)
 {
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 	struct eventfd_ctx *eventfd;
 	int i;
 
-	idr_for_each_entry(&kvm->arch.hyperv.conn_to_evt, eventfd, i)
+	idr_for_each_entry(&hv->conn_to_evt, eventfd, i)
 		eventfd_ctx_put(eventfd);
-	idr_destroy(&kvm->arch.hyperv.conn_to_evt);
+	idr_destroy(&hv->conn_to_evt);
 }
 
 static int kvm_hv_eventfd_assign(struct kvm *kvm, u32 conn_id, int fd)
 {
-	struct kvm_hv *hv = &kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 	struct eventfd_ctx *eventfd;
 	int ret;
 
@@ -1925,7 +1930,7 @@ static int kvm_hv_eventfd_assign(struct kvm *kvm, u32 conn_id, int fd)
 
 static int kvm_hv_eventfd_deassign(struct kvm *kvm, u32 conn_id)
 {
-	struct kvm_hv *hv = &kvm->arch.hyperv;
+	struct kvm_hv *hv = to_kvm_hv(kvm);
 	struct eventfd_ctx *eventfd;
 
 	mutex_lock(&hv->hv_lock);
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 220849cc12e5..fdb321ba9c3f 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -50,6 +50,11 @@
 /* Hyper-V HV_X64_MSR_SYNDBG_OPTIONS bits */
 #define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
 
+static inline struct kvm_hv *to_kvm_hv(struct kvm *kvm)
+{
+	return &kvm->arch.hyperv;
+}
+
 static inline struct kvm_vcpu_hv *to_hv_vcpu(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.hyperv;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2af05d3b0590..9db84508aa0b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -50,6 +50,7 @@
 #include "capabilities.h"
 #include "cpuid.h"
 #include "evmcs.h"
+#include "hyperv.h"
 #include "irq.h"
 #include "kvm_cache_regs.h"
 #include "lapic.h"
@@ -552,7 +553,7 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 {
 	struct hv_enlightened_vmcs *evmcs;
 	struct hv_partition_assist_pg **p_hv_pa_pg =
-			&vcpu->kvm->arch.hyperv.hv_pa_pg;
+			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
 	/*
 	 * Synthetic VM-Exit is not enabled in current code and so All
 	 * evmcs in singe VM shares same assist page.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0bf0672d4811..868d2bf8fb95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10356,7 +10356,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 
 void kvm_arch_free_vm(struct kvm *kvm)
 {
-	kfree(kvm->arch.hyperv.hv_pa_pg);
+	kfree(to_kvm_hv(kvm)->hv_pa_pg);
 	vfree(kvm);
 }
 
-- 
2.29.2


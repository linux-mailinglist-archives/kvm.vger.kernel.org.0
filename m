Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F8F303F60
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405412AbhAZNyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:54:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33770 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405351AbhAZNt7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:49:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k74OBV9H/qBDcINN1Kbe75ZRcU7YQEQbKUtCT/JkxGY=;
        b=L1UH8+i6vsUrWIP/W/ruDK7vUnPn4MKSWWDLOGlQeycGI+1MEVwU010dBYSMjLqsFcBE86
        awcQp1JnDs2HRtavbWAyqPcrlQARAeAqmoQ500YhBWc6Yc3CsYEsKsY+Kmmu6auH68ZR8s
        NWjPBwxBF5+XGynvEbadhMHLUz/BNNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-zV2AN6BAOHWpBnK4mFdu9A-1; Tue, 26 Jan 2021 08:48:28 -0500
X-MC-Unique: zV2AN6BAOHWpBnK4mFdu9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46EE9802B42;
        Tue, 26 Jan 2021 13:48:27 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF3125D9C2;
        Tue, 26 Jan 2021 13:48:25 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 04/15] KVM: x86: hyper-v: Rename vcpu_to_hv_vcpu() to to_hv_vcpu()
Date:   Tue, 26 Jan 2021 14:48:05 +0100
Message-Id: <20210126134816.1880136-5-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu_to_hv_vcpu()'s argument is almost always 'vcpu' so there's
no need to have an additional prefix. Also, this makes the code
more consistent with vmx/svm where to_vmx()/to_svm() are being
used.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 24 ++++++++++++------------
 arch/x86/kvm/hyperv.h |  4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 922c69dcca4d..1a3bac5de897 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -141,10 +141,10 @@ static struct kvm_vcpu *get_vcpu_by_vpidx(struct kvm *kvm, u32 vpidx)
 		return NULL;
 
 	vcpu = kvm_get_vcpu(kvm, vpidx);
-	if (vcpu && vcpu_to_hv_vcpu(vcpu)->vp_index == vpidx)
+	if (vcpu && to_hv_vcpu(vcpu)->vp_index == vpidx)
 		return vcpu;
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		if (vcpu_to_hv_vcpu(vcpu)->vp_index == vpidx)
+		if (to_hv_vcpu(vcpu)->vp_index == vpidx)
 			return vcpu;
 	return NULL;
 }
@@ -165,7 +165,7 @@ static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
-	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_vcpu_hv_stimer *stimer;
 	int gsi, idx;
 
@@ -316,7 +316,7 @@ static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 		return 1;
 
 	trace_kvm_hv_syndbg_set_msr(vcpu->vcpu_id,
-				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr, data);
+				    to_hv_vcpu(vcpu)->vp_index, msr, data);
 	switch (msr) {
 	case HV_X64_MSR_SYNDBG_CONTROL:
 		syndbg->control.control = data;
@@ -378,7 +378,7 @@ static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	}
 
 	trace_kvm_hv_syndbg_get_msr(vcpu->vcpu_id,
-				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr,
+				    to_hv_vcpu(vcpu)->vp_index, msr,
 				    *pdata);
 
 	return 0;
@@ -537,7 +537,7 @@ static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
 	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
 
 	set_bit(stimer->index,
-		vcpu_to_hv_vcpu(vcpu)->stimer_pending_bitmap);
+		to_hv_vcpu(vcpu)->stimer_pending_bitmap);
 	kvm_make_request(KVM_REQ_HV_STIMER, vcpu);
 	if (vcpu_kick)
 		kvm_vcpu_kick(vcpu);
@@ -552,7 +552,7 @@ static void stimer_cleanup(struct kvm_vcpu_hv_stimer *stimer)
 
 	hrtimer_cancel(&stimer->timer);
 	clear_bit(stimer->index,
-		  vcpu_to_hv_vcpu(vcpu)->stimer_pending_bitmap);
+		  to_hv_vcpu(vcpu)->stimer_pending_bitmap);
 	stimer->msg_pending = false;
 	stimer->exp_time = 0;
 }
@@ -801,7 +801,7 @@ static void stimer_expiration(struct kvm_vcpu_hv_stimer *stimer)
 
 void kvm_hv_process_stimers(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_vcpu_hv_stimer *stimer;
 	u64 time_now, exp_time;
 	int i;
@@ -831,7 +831,7 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu)
 
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
@@ -882,7 +882,7 @@ static void stimer_init(struct kvm_vcpu_hv_stimer *stimer, int timer_index)
 
 void kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	int i;
 
 	synic_init(&hv_vcpu->synic);
@@ -894,7 +894,7 @@ void kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 
 void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	hv_vcpu->vp_index = kvm_vcpu_get_idx(vcpu);
 }
@@ -1483,7 +1483,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 
 	bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (test_bit(vcpu_to_hv_vcpu(vcpu)->vp_index,
+		if (test_bit(to_hv_vcpu(vcpu)->vp_index,
 			     (unsigned long *)vp_bitmap))
 			__set_bit(i, vcpu_bitmap);
 	}
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 6d7def2b0aad..f5e0d3d1d54a 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -50,7 +50,7 @@
 /* Hyper-V HV_X64_MSR_SYNDBG_OPTIONS bits */
 #define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
 
-static inline struct kvm_vcpu_hv *vcpu_to_hv_vcpu(struct kvm_vcpu *vcpu)
+static inline struct kvm_vcpu_hv *to_hv_vcpu(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.hyperv;
 }
@@ -100,7 +100,7 @@ bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
 static inline struct kvm_vcpu_hv_stimer *vcpu_to_stimer(struct kvm_vcpu *vcpu,
 							int timer_index)
 {
-	return &vcpu_to_hv_vcpu(vcpu)->stimer[timer_index];
+	return &to_hv_vcpu(vcpu)->stimer[timer_index];
 }
 
 static inline struct kvm_vcpu *stimer_to_vcpu(struct kvm_vcpu_hv_stimer *stimer)
-- 
2.29.2


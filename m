Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B0B303F61
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405524AbhAZNyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:54:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405362AbhAZNuA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:50:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5G4Ta544I7OAANKUxNur+k+HBciB1++BXUMdDTvPZm8=;
        b=KpfNeI1KVVKu0gKwWhaypL7eNgIFR7RMWbbP3m4iqJ8RX7JMWsW6nKWyLFXEEp6BMdFwzN
        CM8K6R0Yt2nT7v5weheR+vOsQqymo3P1+veZXjUUa4btcAZmxUYQao3RmTEBBLuh1jdXDD
        +6wtf5mSrJfEmeJyDfW5U6eYMNm8Ek4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-ksQq-21ZPNuENyaBpMwvQw-1; Tue, 26 Jan 2021 08:48:31 -0500
X-MC-Unique: ksQq-21ZPNuENyaBpMwvQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B08861005513;
        Tue, 26 Jan 2021 13:48:30 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 535FE5D9C2;
        Tue, 26 Jan 2021 13:48:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 06/15] KVM: x86: hyper-v: Rename vcpu_to_stimer()/stimer_to_vcpu()
Date:   Tue, 26 Jan 2021 14:48:07 +0100
Message-Id: <20210126134816.1880136-7-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu_to_stimers()'s argument is almost always 'vcpu' so there's no need to
have an additional prefix. Also, this makes the naming more consistent with
to_hv_vcpu()/to_hv_synic().

Rename stimer_to_vcpu() to hv_stimer_to_vcpu() for consitency.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 36 ++++++++++++++++++------------------
 arch/x86/kvm/hyperv.h |  6 +++---
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 5679dca610a5..840628a21282 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -534,7 +534,7 @@ static u64 get_time_ref_counter(struct kvm *kvm)
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
 				bool vcpu_kick)
 {
-	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 
 	set_bit(stimer->index,
 		to_hv_vcpu(vcpu)->stimer_pending_bitmap);
@@ -545,9 +545,9 @@ static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
 
 static void stimer_cleanup(struct kvm_vcpu_hv_stimer *stimer)
 {
-	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 
-	trace_kvm_hv_stimer_cleanup(stimer_to_vcpu(stimer)->vcpu_id,
+	trace_kvm_hv_stimer_cleanup(hv_stimer_to_vcpu(stimer)->vcpu_id,
 				    stimer->index);
 
 	hrtimer_cancel(&stimer->timer);
@@ -562,7 +562,7 @@ static enum hrtimer_restart stimer_timer_callback(struct hrtimer *timer)
 	struct kvm_vcpu_hv_stimer *stimer;
 
 	stimer = container_of(timer, struct kvm_vcpu_hv_stimer, timer);
-	trace_kvm_hv_stimer_callback(stimer_to_vcpu(stimer)->vcpu_id,
+	trace_kvm_hv_stimer_callback(hv_stimer_to_vcpu(stimer)->vcpu_id,
 				     stimer->index);
 	stimer_mark_pending(stimer, true);
 
@@ -579,7 +579,7 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
 	u64 time_now;
 	ktime_t ktime_now;
 
-	time_now = get_time_ref_counter(stimer_to_vcpu(stimer)->kvm);
+	time_now = get_time_ref_counter(hv_stimer_to_vcpu(stimer)->kvm);
 	ktime_now = ktime_get();
 
 	if (stimer->config.periodic) {
@@ -596,7 +596,7 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
 			stimer->exp_time = time_now + stimer->count;
 
 		trace_kvm_hv_stimer_start_periodic(
-					stimer_to_vcpu(stimer)->vcpu_id,
+					hv_stimer_to_vcpu(stimer)->vcpu_id,
 					stimer->index,
 					time_now, stimer->exp_time);
 
@@ -618,7 +618,7 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
 		return 0;
 	}
 
-	trace_kvm_hv_stimer_start_one_shot(stimer_to_vcpu(stimer)->vcpu_id,
+	trace_kvm_hv_stimer_start_one_shot(hv_stimer_to_vcpu(stimer)->vcpu_id,
 					   stimer->index,
 					   time_now, stimer->count);
 
@@ -633,13 +633,13 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 {
 	union hv_stimer_config new_config = {.as_uint64 = config},
 		old_config = {.as_uint64 = stimer->config.as_uint64};
-	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
 	if (!synic->active && !host)
 		return 1;
 
-	trace_kvm_hv_stimer_set_config(stimer_to_vcpu(stimer)->vcpu_id,
+	trace_kvm_hv_stimer_set_config(hv_stimer_to_vcpu(stimer)->vcpu_id,
 				       stimer->index, config, host);
 
 	stimer_cleanup(stimer);
@@ -657,13 +657,13 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 			    bool host)
 {
-	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
 	if (!synic->active && !host)
 		return 1;
 
-	trace_kvm_hv_stimer_set_count(stimer_to_vcpu(stimer)->vcpu_id,
+	trace_kvm_hv_stimer_set_count(hv_stimer_to_vcpu(stimer)->vcpu_id,
 				      stimer->index, count, host);
 
 	stimer_cleanup(stimer);
@@ -750,7 +750,7 @@ static int synic_deliver_msg(struct kvm_vcpu_hv_synic *synic, u32 sint,
 
 static int stimer_send_msg(struct kvm_vcpu_hv_stimer *stimer)
 {
-	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 	struct hv_message *msg = &stimer->msg;
 	struct hv_timer_message_payload *payload =
 			(struct hv_timer_message_payload *)&msg->u.payload;
@@ -770,7 +770,7 @@ static int stimer_send_msg(struct kvm_vcpu_hv_stimer *stimer)
 
 static int stimer_notify_direct(struct kvm_vcpu_hv_stimer *stimer)
 {
-	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 	struct kvm_lapic_irq irq = {
 		.delivery_mode = APIC_DM_FIXED,
 		.vector = stimer->config.apic_vector
@@ -790,7 +790,7 @@ static void stimer_expiration(struct kvm_vcpu_hv_stimer *stimer)
 		r = stimer_send_msg(stimer);
 	else
 		r = stimer_notify_direct(stimer);
-	trace_kvm_hv_stimer_expiration(stimer_to_vcpu(stimer)->vcpu_id,
+	trace_kvm_hv_stimer_expiration(hv_stimer_to_vcpu(stimer)->vcpu_id,
 				       stimer->index, direct, r);
 	if (!r) {
 		stimer->msg_pending = false;
@@ -1298,7 +1298,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	case HV_X64_MSR_STIMER3_CONFIG: {
 		int timer_index = (msr - HV_X64_MSR_STIMER0_CONFIG)/2;
 
-		return stimer_set_config(vcpu_to_stimer(vcpu, timer_index),
+		return stimer_set_config(to_hv_stimer(vcpu, timer_index),
 					 data, host);
 	}
 	case HV_X64_MSR_STIMER0_COUNT:
@@ -1307,7 +1307,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	case HV_X64_MSR_STIMER3_COUNT: {
 		int timer_index = (msr - HV_X64_MSR_STIMER0_COUNT)/2;
 
-		return stimer_set_count(vcpu_to_stimer(vcpu, timer_index),
+		return stimer_set_count(to_hv_stimer(vcpu, timer_index),
 					data, host);
 	}
 	case HV_X64_MSR_TSC_FREQUENCY:
@@ -1410,7 +1410,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	case HV_X64_MSR_STIMER3_CONFIG: {
 		int timer_index = (msr - HV_X64_MSR_STIMER0_CONFIG)/2;
 
-		return stimer_get_config(vcpu_to_stimer(vcpu, timer_index),
+		return stimer_get_config(to_hv_stimer(vcpu, timer_index),
 					 pdata);
 	}
 	case HV_X64_MSR_STIMER0_COUNT:
@@ -1419,7 +1419,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	case HV_X64_MSR_STIMER3_COUNT: {
 		int timer_index = (msr - HV_X64_MSR_STIMER0_COUNT)/2;
 
-		return stimer_get_count(vcpu_to_stimer(vcpu, timer_index),
+		return stimer_get_count(to_hv_stimer(vcpu, timer_index),
 					pdata);
 	}
 	case HV_X64_MSR_TSC_FREQUENCY:
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index d47b3f045a25..48fcabacd339 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -97,13 +97,13 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu);
 bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
 			    struct hv_vp_assist_page *assist_page);
 
-static inline struct kvm_vcpu_hv_stimer *vcpu_to_stimer(struct kvm_vcpu *vcpu,
-							int timer_index)
+static inline struct kvm_vcpu_hv_stimer *to_hv_stimer(struct kvm_vcpu *vcpu,
+						      int timer_index)
 {
 	return &to_hv_vcpu(vcpu)->stimer[timer_index];
 }
 
-static inline struct kvm_vcpu *stimer_to_vcpu(struct kvm_vcpu_hv_stimer *stimer)
+static inline struct kvm_vcpu *hv_stimer_to_vcpu(struct kvm_vcpu_hv_stimer *stimer)
 {
 	struct kvm_vcpu_hv *hv_vcpu;
 
-- 
2.29.2


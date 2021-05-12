Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA3137C31F
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhELPRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:31 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:52922 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbhELPOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832382; x=1652368382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OwNSwH+TaVkRKL3rLBLITgVEcNInQsK25TDaYcBoxUY=;
  b=evRULVYRoQLF+asSaZx3o93EuTmHhs9lrWVHA4DCS0/HiJNsy8Lbrj2B
   EVBqDl8RjxRlSXzREsq1NlUjrdmuUeZQQj5OJ6jC1GltzRo39J/zeFxMd
   s+QB2yI5pupXaZ7rInnBj6jKZwajNVdLPFg8U8XpciaHv8phppz/gg9CD
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="125400032"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2c-76e0922c.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 12 May 2021 15:12:55 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-76e0922c.us-west-2.amazon.com (Postfix) with ESMTPS id 5C8E2A1C8F;
        Wed, 12 May 2021 15:12:51 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:09 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:10 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:12:08 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 03/10] KVM: X86: Add kvm_scale_tsc_l1() and kvm_compute_tsc_offset_l1()
Date:   Wed, 12 May 2021 16:09:38 +0100
Message-ID: <20210512150945.4591-4-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512150945.4591-1-ilstam@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing kvm_scale_tsc() scales the TSC using the current TSC
scaling ratio. That used to be the same as L1's scaling ratio but now
with nested TSC scaling support it is no longer the case.

This patch adds a new kvm_scale_tsc_l1() function that scales the TSC
using L1's scaling ratio. The existing kvm_scale_tsc() can still be used
for scaling L2 TSC values.

Additionally, this patch renames the kvm_compute_tsc_offset() function
to kvm_compute_tsc_offset_l1() and has the function treat its TSC
argument as an L1 TSC value. All existing code uses this function
passing L1 values to it.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 41 ++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7dfc609eacd6..be59197e5eb7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1789,6 +1789,7 @@ static inline bool kvm_is_supported_user_return_msr(u32 msr)
 }
 
 u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
+u64 kvm_scale_tsc_l1(struct kvm_vcpu *vcpu, u64 tsc);
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 07cf5d7ece38..84af1af7a2cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2319,18 +2319,30 @@ u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
 }
 EXPORT_SYMBOL_GPL(kvm_scale_tsc);
 
-static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
+u64 kvm_scale_tsc_l1(struct kvm_vcpu *vcpu, u64 tsc)
+{
+	u64 _tsc = tsc;
+	u64 ratio = vcpu->arch.l1_tsc_scaling_ratio;
+
+	if (ratio != kvm_default_tsc_scaling_ratio)
+		_tsc = __scale_tsc(ratio, tsc);
+
+	return _tsc;
+}
+EXPORT_SYMBOL_GPL(kvm_scale_tsc_l1);
+
+static u64 kvm_compute_tsc_offset_l1(struct kvm_vcpu *vcpu, u64 target_tsc)
 {
 	u64 tsc;
 
-	tsc = kvm_scale_tsc(vcpu, rdtsc());
+	tsc = kvm_scale_tsc_l1(vcpu, rdtsc());
 
 	return target_tsc - tsc;
 }
 
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 {
-	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
+	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc_l1(vcpu, host_tsc);
 }
 EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
@@ -2363,7 +2375,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	bool synchronizing = false;
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
-	offset = kvm_compute_tsc_offset(vcpu, data);
+	offset = kvm_compute_tsc_offset_l1(vcpu, data);
 	ns = get_kvmclock_base_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
@@ -2402,7 +2414,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 		} else {
 			u64 delta = nsec_to_cycles(vcpu, elapsed);
 			data += delta;
-			offset = kvm_compute_tsc_offset(vcpu, data);
+			offset = kvm_compute_tsc_offset_l1(vcpu, data);
 		}
 		matched = true;
 		already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
@@ -2463,7 +2475,7 @@ static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
 {
 	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
 		WARN_ON(adjustment < 0);
-	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment);
+	adjustment = kvm_scale_tsc_l1(vcpu, (u64) adjustment);
 	adjust_tsc_offset_guest(vcpu, adjustment);
 }
 
@@ -2846,7 +2858,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	/* With all the info we got, fill in the values */
 
 	if (kvm_has_tsc_control)
-		tgt_tsc_khz = kvm_scale_tsc(v, tgt_tsc_khz);
+		tgt_tsc_khz = kvm_scale_tsc_l1(v, tgt_tsc_khz);
 
 	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
 		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
@@ -3235,7 +3247,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (msr_info->host_initiated) {
 			kvm_synchronize_tsc(vcpu, data);
 		} else {
-			u64 adj = kvm_compute_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
+			u64 adj = kvm_compute_tsc_offset_l1(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
 			vcpu->arch.ia32_tsc_adjust_msr += adj;
 		}
@@ -3537,10 +3549,13 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * return L1's TSC value to ensure backwards-compatible
 		 * behavior for migration.
 		 */
-		u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
-							    vcpu->arch.tsc_offset;
-
-		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
+		if (msr_info->host_initiated) {
+			msr_info->data = kvm_scale_tsc_l1(vcpu, rdtsc()) +
+					 vcpu->arch.l1_tsc_offset;
+		} else {
+			msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) +
+					 vcpu->arch.tsc_offset;
+		}
 		break;
 	}
 	case MSR_MTRRcap:
@@ -4123,7 +4138,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			mark_tsc_unstable("KVM discovered backwards TSC");
 
 		if (kvm_check_tsc_unstable()) {
-			u64 offset = kvm_compute_tsc_offset(vcpu,
+			u64 offset = kvm_compute_tsc_offset_l1(vcpu,
 						vcpu->arch.last_guest_tsc);
 			kvm_vcpu_write_tsc_offset(vcpu, offset);
 			vcpu->arch.tsc_catchup = 1;
-- 
2.17.1


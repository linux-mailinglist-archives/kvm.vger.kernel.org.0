Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D941C391F78
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 20:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbhEZSsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 14:48:06 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:26336 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbhEZSsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 14:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622054795; x=1653590795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=rb1HQsZyo9y1qTolJIh4btDusli8UDipXMsp/fyUpI4=;
  b=ib6sRQZcUsgMhFljY/P4FYtvrpTPR96LiZwL5bKsbrpn8F+n/QTKisF6
   XjZMEcBSwsCpSMitLx+PmwKD/UVogv/WFZ6j9WbbfMDqIk86xjZpCrQQh
   QKX1raNFADPvWCNRjfonHFDixTFXxbGkBkyqP564VNe5ELfvFmW9E8Nhl
   w=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="111926872"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 26 May 2021 18:46:27 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id E98ABA215A;
        Wed, 26 May 2021 18:46:24 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:46:04 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:46:04 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 26 May 2021 18:46:03 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v4 04/11] KVM: X86: Add a ratio parameter to kvm_scale_tsc()
Date:   Wed, 26 May 2021 19:44:11 +0100
Message-ID: <20210526184418.28881-5-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210526184418.28881-1-ilstam@amazon.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes kvm_scale_tsc() needs to use the current scaling ratio and
other times (like when reading the TSC from user space) it needs to use
L1's scaling ratio. Have the caller specify this by passing the ratio as
a parameter.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/x86.c              | 27 ++++++++++++++++++---------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7dfc609eacd6..b14c2b2b2e21 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1788,7 +1788,7 @@ static inline bool kvm_is_supported_user_return_msr(u32 msr)
 	return kvm_find_user_return_msr(msr) >= 0;
 }
 
-u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
+u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, u64 ratio);
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7359da170a5f..8cf0dfb6264d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2307,10 +2307,9 @@ static inline u64 __scale_tsc(u64 ratio, u64 tsc)
 	return mul_u64_u64_shr(tsc, ratio, kvm_tsc_scaling_ratio_frac_bits);
 }
 
-u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
+u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, u64 ratio)
 {
 	u64 _tsc = tsc;
-	u64 ratio = vcpu->arch.tsc_scaling_ratio;
 
 	if (ratio != kvm_default_tsc_scaling_ratio)
 		_tsc = __scale_tsc(ratio, tsc);
@@ -2323,14 +2322,15 @@ static u64 kvm_compute_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 {
 	u64 tsc;
 
-	tsc = kvm_scale_tsc(vcpu, rdtsc());
+	tsc = kvm_scale_tsc(vcpu, rdtsc(), vcpu->arch.l1_tsc_scaling_ratio);
 
 	return target_tsc - tsc;
 }
 
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 {
-	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
+	return vcpu->arch.l1_tsc_offset +
+		kvm_scale_tsc(vcpu, host_tsc, vcpu->arch.l1_tsc_scaling_ratio);
 }
 EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
@@ -2463,7 +2463,8 @@ static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
 {
 	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
 		WARN_ON(adjustment < 0);
-	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment);
+	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment,
+				   vcpu->arch.l1_tsc_scaling_ratio);
 	adjust_tsc_offset_guest(vcpu, adjustment);
 }
 
@@ -2846,7 +2847,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	/* With all the info we got, fill in the values */
 
 	if (kvm_has_tsc_control)
-		tgt_tsc_khz = kvm_scale_tsc(v, tgt_tsc_khz);
+		tgt_tsc_khz = kvm_scale_tsc(v, tgt_tsc_khz,
+					    v->arch.l1_tsc_scaling_ratio);
 
 	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
 		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
@@ -3537,10 +3539,17 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * return L1's TSC value to ensure backwards-compatible
 		 * behavior for migration.
 		 */
-		u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
-							    vcpu->arch.tsc_offset;
+		u64 offset, ratio;
 
-		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
+		if (msr_info->host_initiated) {
+			offset = vcpu->arch.l1_tsc_offset;
+			ratio = vcpu->arch.l1_tsc_scaling_ratio;
+		} else {
+			offset = vcpu->arch.tsc_offset;
+			ratio = vcpu->arch.tsc_scaling_ratio;
+		}
+
+		msr_info->data = kvm_scale_tsc(vcpu, rdtsc(), ratio) + offset;
 		break;
 	}
 	case MSR_MTRRcap:
-- 
2.17.1


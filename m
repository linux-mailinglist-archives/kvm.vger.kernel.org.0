Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A90D38C4C0
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 12:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhEUK3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 06:29:16 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:26865 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbhEUK23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 06:28:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621592827; x=1653128827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=jJZ1VPvv3+11wtd/3xdNBOXiOiWNKLZckUNGFCtR2v8=;
  b=i50NLkx7svQP++13IPZfLqluiYRoToaHxEfLRF1APAoQWRicLxKqfzzV
   /4NlSe+u4Td0U9H2VtJ8iAx7s0lHsp68LwaQ4bXMpVskHsh8lsillx5Th
   /GzI+Qm6f+CIUp9xZ43LySwMjIHaxxoBoRMPulz7H1nyiJi5a8rBSkrZD
   o=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="126971158"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 21 May 2021 10:26:59 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id E26CDA1F5E;
        Fri, 21 May 2021 10:26:54 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:26:54 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:26:54 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.83.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Fri, 21 May 2021 10:26:52 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v3 07/12] KVM: X86: Add functions that calculate L2's TSC offset and multiplier
Date:   Fri, 21 May 2021 11:24:44 +0100
Message-ID: <20210521102449.21505-8-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521102449.21505-1-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When L2 is entered we need to "merge" the TSC multiplier and TSC offset
values of 01 and 12 together.

The merging is done using the following equations:
  offset_02 = ((offset_01 * mult_12) >> shift_bits) + offset_12
  mult_02 = (mult_01 * mult_12) >> shift_bits

Where shift_bits is kvm_tsc_scaling_ratio_frac_bits.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0f2cf5d1240c..aaf756442ed1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1792,6 +1792,8 @@ static inline bool kvm_is_supported_user_return_msr(u32 msr)
 
 u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, u64 ratio);
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
+u64 kvm_calc_nested_tsc_offset(u64 l1_offset, u64 l2_offset, u64 l2_multiplier);
+u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier);
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fdcb4f46a003..04abaacb9cfc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2334,6 +2334,31 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 }
 EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
+u64 kvm_calc_nested_tsc_offset(u64 l1_offset, u64 l2_offset, u64 l2_multiplier)
+{
+	u64 nested_offset;
+
+	if (l2_multiplier == kvm_default_tsc_scaling_ratio)
+		nested_offset = l1_offset;
+	else
+		nested_offset = mul_s64_u64_shr((s64) l1_offset, l2_multiplier,
+						kvm_tsc_scaling_ratio_frac_bits);
+
+	nested_offset += l2_offset;
+	return nested_offset;
+}
+EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_offset);
+
+u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier)
+{
+	if (l2_multiplier != kvm_default_tsc_scaling_ratio)
+		return mul_u64_u64_shr(l1_multiplier, l2_multiplier,
+				       kvm_tsc_scaling_ratio_frac_bits);
+
+	return l1_multiplier;
+}
+EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_multiplier);
+
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	vcpu->arch.l1_tsc_offset = offset;
-- 
2.17.1


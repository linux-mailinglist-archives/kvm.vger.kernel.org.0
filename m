Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3F137C322
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhELPRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:35 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:50864 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbhELPOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:14:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832387; x=1652368387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OYeZ+yRdHpDkHcQ3lGwth3XxHtNx/6enPUD/fAb7PFE=;
  b=n/x++liXBBasste4ewoEpwAvQG5yn79zIKlOp11ZJpN0e7icW31O6XyB
   t3+50HbOmStjDwMZeJPOg6PLydXIt5AE26zGT9u81CZV+rAROvZr89C/Q
   mvT7Rw9guf6er7rtvNfjaZiwiKZIwyD5gqtqH8oSCPBS4isf1+h+lRigM
   s=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="111783658"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 12 May 2021 15:13:06 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 1253AA06D9;
        Wed, 12 May 2021 15:13:05 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:41 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:41 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:12:39 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 06/10] KVM: X86: Add functions that calculate the 02 TSC offset and multiplier
Date:   Wed, 12 May 2021 16:09:41 +0100
Message-ID: <20210512150945.4591-7-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512150945.4591-1-ilstam@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
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
 arch/x86/kvm/x86.c              | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4c4a3fefff57..57a25d8e8b0f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1793,6 +1793,8 @@ static inline bool kvm_is_supported_user_return_msr(u32 msr)
 u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
 u64 kvm_scale_tsc_l1(struct kvm_vcpu *vcpu, u64 tsc);
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
+void kvm_set_02_tsc_offset(struct kvm_vcpu *vcpu);
+void kvm_set_02_tsc_multiplier(struct kvm_vcpu *vcpu);
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 84af1af7a2cc..1db6cfc2079f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2346,6 +2346,35 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 }
 EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
+void kvm_set_02_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	u64 l2_offset = static_call(kvm_x86_get_l2_tsc_offset)(vcpu);
+	u64 l2_multiplier = static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu);
+
+	if (l2_multiplier != kvm_default_tsc_scaling_ratio) {
+		vcpu->arch.tsc_offset = mul_s64_u64_shr(
+				(s64) vcpu->arch.l1_tsc_offset,
+				l2_multiplier,
+				kvm_tsc_scaling_ratio_frac_bits);
+	}
+
+	vcpu->arch.tsc_offset += l2_offset;
+}
+EXPORT_SYMBOL_GPL(kvm_set_02_tsc_offset);
+
+void kvm_set_02_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	u64 l2_multiplier = static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu);
+
+	if (l2_multiplier != kvm_default_tsc_scaling_ratio) {
+		vcpu->arch.tsc_scaling_ratio = mul_u64_u64_shr(
+				vcpu->arch.l1_tsc_scaling_ratio,
+				l2_multiplier,
+				kvm_tsc_scaling_ratio_frac_bits);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_set_02_tsc_multiplier);
+
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	vcpu->arch.l1_tsc_offset = offset;
-- 
2.17.1


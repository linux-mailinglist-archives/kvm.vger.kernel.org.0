Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878FC391F72
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhEZSri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 14:47:38 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:9430 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbhEZSrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 14:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622054766; x=1653590766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=SaW74m+cDtjvwFR4fFABw6GdCGYDpVddxRJwYp96Tuo=;
  b=nacwuaG757aWg0tMLEj8jcYliMXohuy+22K9VUtUYXArjJHqEu1wN+Bj
   LYPbiA4/MZZkWOO7utn1gE6IkyZ5k9SBhHQvog/ntmOS2fWO78rhEC6Mq
   Jyi+Lq4AmX5HiOppebDRzYYExKjtA2i7worsWO/c9tQlLMs+glPlE/xrQ
   k=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="3483935"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 26 May 2021 18:45:59 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 8E48AA2102;
        Wed, 26 May 2021 18:45:54 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:45:52 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:45:51 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 26 May 2021 18:45:50 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v4 03/11] KVM: X86: Rename kvm_compute_tsc_offset() to kvm_compute_l1_tsc_offset()
Date:   Wed, 26 May 2021 19:44:10 +0100
Message-ID: <20210526184418.28881-4-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210526184418.28881-1-ilstam@amazon.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All existing code uses kvm_compute_tsc_offset() passing L1 TSC values to
it. Let's document this by renaming it to kvm_compute_l1_tsc_offset().

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ab95ac188a5..7359da170a5f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2319,7 +2319,7 @@ u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
 }
 EXPORT_SYMBOL_GPL(kvm_scale_tsc);
 
-static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
+static u64 kvm_compute_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 {
 	u64 tsc;
 
@@ -2363,7 +2363,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	bool synchronizing = false;
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
-	offset = kvm_compute_tsc_offset(vcpu, data);
+	offset = kvm_compute_l1_tsc_offset(vcpu, data);
 	ns = get_kvmclock_base_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
@@ -2402,7 +2402,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 		} else {
 			u64 delta = nsec_to_cycles(vcpu, elapsed);
 			data += delta;
-			offset = kvm_compute_tsc_offset(vcpu, data);
+			offset = kvm_compute_l1_tsc_offset(vcpu, data);
 		}
 		matched = true;
 		already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
@@ -3235,7 +3235,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (msr_info->host_initiated) {
 			kvm_synchronize_tsc(vcpu, data);
 		} else {
-			u64 adj = kvm_compute_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
+			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
 			vcpu->arch.ia32_tsc_adjust_msr += adj;
 		}
@@ -4123,7 +4123,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			mark_tsc_unstable("KVM discovered backwards TSC");
 
 		if (kvm_check_tsc_unstable()) {
-			u64 offset = kvm_compute_tsc_offset(vcpu,
+			u64 offset = kvm_compute_l1_tsc_offset(vcpu,
 						vcpu->arch.last_guest_tsc);
 			kvm_vcpu_write_tsc_offset(vcpu, offset);
 			vcpu->arch.tsc_catchup = 1;
-- 
2.17.1


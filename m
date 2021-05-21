Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E7F38C4B3
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 12:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhEUK2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 06:28:19 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:57770 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhEUK1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 06:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621592791; x=1653128791;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GcZ7Jyk8YnE2X4juh/CF8jrtP+C9yi6hi6p0Lqf17wM=;
  b=Qj9MD8IDpsMUeJnFeJQNVZCqyeJP22Rrf2ASzi4nS3FJkKIYfd3dyoZM
   0yKrPMfJ9uUdGImiPIjVwRkVu39i3vG2sS4vScGzuBtuqqKW9wjI25XdA
   Un3LfMCTSB0vN1HGvulepBGCZRcBHnHzwh+lPbOkjrVn28RSxCz5u0EAP
   w=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="109312077"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 21 May 2021 10:26:30 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 6B9B91A5460;
        Fri, 21 May 2021 10:26:28 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:26:20 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:26:19 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.83.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Fri, 21 May 2021 10:26:18 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v3 03/12] KVM: X86: Rename kvm_compute_tsc_offset() to kvm_compute_tsc_offset_l1()
Date:   Fri, 21 May 2021 11:24:40 +0100
Message-ID: <20210521102449.21505-4-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521102449.21505-1-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All existing code uses kvm_compute_tsc_offset() passing L1 TSC values to
it. Let's document this by renaming it to kvm_compute_tsc_offset_l1().

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/kvm/x86.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ab95ac188a5..ac644a1c3285 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2319,7 +2319,7 @@ u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
 }
 EXPORT_SYMBOL_GPL(kvm_scale_tsc);
 
-static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
+static u64 kvm_compute_tsc_offset_l1(struct kvm_vcpu *vcpu, u64 target_tsc)
 {
 	u64 tsc;
 
@@ -2363,7 +2363,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	bool synchronizing = false;
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
-	offset = kvm_compute_tsc_offset(vcpu, data);
+	offset = kvm_compute_tsc_offset_l1(vcpu, data);
 	ns = get_kvmclock_base_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
@@ -2402,7 +2402,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 		} else {
 			u64 delta = nsec_to_cycles(vcpu, elapsed);
 			data += delta;
-			offset = kvm_compute_tsc_offset(vcpu, data);
+			offset = kvm_compute_tsc_offset_l1(vcpu, data);
 		}
 		matched = true;
 		already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
@@ -3235,7 +3235,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (msr_info->host_initiated) {
 			kvm_synchronize_tsc(vcpu, data);
 		} else {
-			u64 adj = kvm_compute_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
+			u64 adj = kvm_compute_tsc_offset_l1(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
 			vcpu->arch.ia32_tsc_adjust_msr += adj;
 		}
@@ -4123,7 +4123,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			mark_tsc_unstable("KVM discovered backwards TSC");
 
 		if (kvm_check_tsc_unstable()) {
-			u64 offset = kvm_compute_tsc_offset(vcpu,
+			u64 offset = kvm_compute_tsc_offset_l1(vcpu,
 						vcpu->arch.last_guest_tsc);
 			kvm_vcpu_write_tsc_offset(vcpu, offset);
 			vcpu->arch.tsc_catchup = 1;
-- 
2.17.1


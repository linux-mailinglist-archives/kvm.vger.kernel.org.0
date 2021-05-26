Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB79391F70
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 20:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhEZSr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 14:47:26 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:23063 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhEZSrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 14:47:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622054755; x=1653590755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=c/NsOwxjY+zWnrjxjNItJhfZdreVjS9DQ+D8vvqrTaU=;
  b=sHzp0d4zLKKuXuqeneimPiqqyzKiZ3r0La2W+VDUhQLUghtI2UHqi7UN
   PNP4MpP8S4/3MGbk/aWPuGXitrzlSsZrg0ADJyUAIawBNbcuGW6ovxqOU
   Ft6bvcs90BtXcK3mOoSwvnP4pygyzmuywIUV97TUYNlxT5Ok1bMPh/zaj
   I=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="114842703"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 26 May 2021 18:45:53 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 91B6CA00CA;
        Wed, 26 May 2021 18:45:51 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:45:39 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:45:39 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 26 May 2021 18:45:37 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v4 02/11] KVM: X86: Store L1's TSC scaling ratio in 'struct kvm_vcpu_arch'
Date:   Wed, 26 May 2021 19:44:09 +0100
Message-ID: <20210526184418.28881-3-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210526184418.28881-1-ilstam@amazon.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Store L1's scaling ratio in the kvm_vcpu_arch struct like we already do
for L1's TSC offset. This allows for easy save/restore when we enter and
then exit the nested guest.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++--
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 arch/x86/kvm/x86.c              | 6 ++++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..7dfc609eacd6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -707,7 +707,7 @@ struct kvm_vcpu_arch {
 	} st;
 
 	u64 l1_tsc_offset;
-	u64 tsc_offset;
+	u64 tsc_offset; /* current tsc offset */
 	u64 last_guest_tsc;
 	u64 last_host_tsc;
 	u64 tsc_offset_adjustment;
@@ -721,7 +721,8 @@ struct kvm_vcpu_arch {
 	u32 virtual_tsc_khz;
 	s64 ia32_tsc_adjust_msr;
 	u64 msr_ia32_power_ctl;
-	u64 tsc_scaling_ratio;
+	u64 l1_tsc_scaling_ratio;
+	u64 tsc_scaling_ratio; /* current scaling ratio */
 
 	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
 	unsigned nmi_pending; /* NMI queued after currently running handler */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bceb5ca3a89..3e4dda8177bb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7453,10 +7453,10 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 		delta_tsc = 0;
 
 	/* Convert to host delta tsc if tsc scaling is enabled */
-	if (vcpu->arch.tsc_scaling_ratio != kvm_default_tsc_scaling_ratio &&
+	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio &&
 	    delta_tsc && u64_shl_div_u64(delta_tsc,
 				kvm_tsc_scaling_ratio_frac_bits,
-				vcpu->arch.tsc_scaling_ratio, &delta_tsc))
+				vcpu->arch.l1_tsc_scaling_ratio, &delta_tsc))
 		return -ERANGE;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04e67ad..6ab95ac188a5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2185,6 +2185,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 
 	/* Guest TSC same frequency as host TSC? */
 	if (!scale) {
+		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
 		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
 		return 0;
 	}
@@ -2211,7 +2212,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 		return -1;
 	}
 
-	vcpu->arch.tsc_scaling_ratio = ratio;
+	vcpu->arch.l1_tsc_scaling_ratio = vcpu->arch.tsc_scaling_ratio = ratio;
 	return 0;
 }
 
@@ -2223,6 +2224,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 	/* tsc_khz can be zero if TSC calibration fails */
 	if (user_tsc_khz == 0) {
 		/* set tsc_scaling_ratio to a safe value */
+		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
 		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
 		return -1;
 	}
@@ -2459,7 +2461,7 @@ static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
 
 static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
 {
-	if (vcpu->arch.tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
+	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
 		WARN_ON(adjustment < 0);
 	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment);
 	adjust_tsc_offset_guest(vcpu, adjustment);
-- 
2.17.1


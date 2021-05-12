Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8AE37C313
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhELPRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:15 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:48021 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhELPN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:13:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832340; x=1652368340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=VXa53pCFVR+35FCWlxUGm51ip9sDTKeMhg2XuHjq7BY=;
  b=uSKiY2S8JGY2JP8pzKo1EUbzhO84ZjEvAYUevVqhiifIfvkgA5MAEVl/
   Dl/1j6ZnvhulOZAPL4hL8WizhDcEEwiLW95iaH6CwDLmYKWTNULr3/qYX
   GfBVHzdUh6QUaTwPs9IlCTT2SPw3KIWMoo6/9hhq4mo1qtKnDFxgf8hWc
   g=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="932812873"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 12 May 2021 15:12:12 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id A028DA1861;
        Wed, 12 May 2021 15:12:11 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:00 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:00 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:11:57 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 02/10] KVM: X86: Store L1's TSC scaling ratio in 'struct kvm_vcpu_arch'
Date:   Wed, 12 May 2021 16:09:37 +0100
Message-ID: <20210512150945.4591-3-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512150945.4591-1-ilstam@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Store L1's scaling ratio in that struct like we already do for L1's TSC
offset. This allows for easy save/restore when we enter and then exit
the nested guest.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++--
 arch/x86/kvm/x86.c              | 6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..07cf5d7ece38 100644
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


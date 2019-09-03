Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6532FA6B83
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 16:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfICOaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 10:30:39 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:30282 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbfICOai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 10:30:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1567521037; x=1599057037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=TsVQ4YmQUOxpHUFBpHr6G7zfIEU+Q8EKLJiiqblwGRM=;
  b=vfmCkPa9b2A9Jz4PsTGp2yQ+T2ucJ4f6CmAb7GiZkUhXOI8Zqv6YTXne
   RFUQIXq/ToQiRX/KcQHY31bPy8QLBIGsGWGfQOjmZ8Yafg2NGltqn1vbk
   3GPpnhYiVsUx2sQDKpQYUAPF0bCg0Q5UXMhk+VEyR8hOJgK6H0IP6ogNu
   o=;
X-IronPort-AV: E=Sophos;i="5.64,463,1559520000"; 
   d="scan'208";a="748773588"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 03 Sep 2019 14:30:35 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 3294EA2DEE;
        Tue,  3 Sep 2019 14:30:34 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 3 Sep 2019 14:30:11 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.242) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 3 Sep 2019 14:30:08 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/2] KVM: SVM: Disable posted interrupts for odd IRQs
Date:   Tue, 3 Sep 2019 16:29:54 +0200
Message-ID: <20190903142954.3429-3-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903142954.3429-1-graf@amazon.com>
References: <20190903142954.3429-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.242]
X-ClientProxiedBy: EX13D27UWA002.ant.amazon.com (10.43.160.30) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can easily route hardware interrupts directly into VM context when
they target the "Fixed" or "LowPriority" delivery modes.

However, on modes such as "SMI" or "Init", we need to go via KVM code
to actually put the vCPU into a different mode of operation, so we can
not post the interrupt

Add code in the SVM PI logic to explicitly refuse to establish posted
mappings for advanced IRQ deliver modes.

This fixes a bug I have with code which configures real hardware to
inject virtual SMIs into my guest.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arch/x86/kvm/svm.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f220a85514f..9a6ea78c3239 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5266,6 +5266,21 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 		return -1;
 	}
 
+	switch (irq.delivery_mode) {
+	case dest_Fixed:
+	case dest_LowestPrio:
+		break;
+	default:
+		/*
+		 * For non-trivial interrupt events, we need to go
+		 * through the full KVM IRQ code, so refuse to take
+		 * any direct PI assignments here.
+		 */
+		pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
+			 __func__, irq.vector);
+		return -1;
+	}
+
 	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
 		 irq.vector);
 	*svm = to_svm(vcpu);
@@ -5314,6 +5329,7 @@ static int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		 * 1. When cannot target interrupt to a specific vcpu.
 		 * 2. Unsetting posted interrupt.
 		 * 3. APIC virtialization is disabled for the vcpu.
+		 * 4. IRQ has extended delivery mode (SMI, INIT, etc)
 		 */
 		if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




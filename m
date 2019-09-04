Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D8AA8498
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 15:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbfIDNfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 09:35:55 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:41964 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730142AbfIDNfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 09:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1567604153; x=1599140153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DvXyQ/caPYxtunrlbeZWX70rlOc+ISFPg6+8zaGxv5U=;
  b=ekzGnjDVP7ivdpkxGC1jeSbxe2eE/JwHFydSJked49i4iZeraubOdmh/
   FGaQ2JrPJwks87464YApw80gEV+I6coNR4KuT1mYEDaAuzegkhcdR5x3E
   b4ODJtAkHZR/ZAqx0ySx88q5RQi8nupSh8enKJQWh0guKHeLvcanAkjNx
   g=;
X-IronPort-AV: E=Sophos;i="5.64,467,1559520000"; 
   d="scan'208";a="827208758"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Sep 2019 13:35:34 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 77910A25E5;
        Wed,  4 Sep 2019 13:35:29 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 13:35:29 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.160.160) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 13:35:25 +0000
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
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 2/2] KVM: SVM: Disable posted interrupts for odd IRQs
Date:   Wed, 4 Sep 2019 15:35:11 +0200
Message-ID: <20190904133511.17540-3-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190904133511.17540-1-graf@amazon.com>
References: <20190904133511.17540-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.160]
X-ClientProxiedBy: EX13D31UWA002.ant.amazon.com (10.43.160.82) To
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
mappings for advanced IRQ deliver modes. This reflects the logic in
__apic_accept_irq() which also only ever passes Fixed and LowPriority
interrupts as posted interrupts into the guest.

This fixes a bug I have with code which configures real hardware to
inject virtual SMIs into my guest.

Signed-off-by: Alexander Graf <graf@amazon.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>

---

v1 -> v2:

  - Make error message more unique
  - Update commit message to point to __apic_accept_irq()
---
 arch/x86/kvm/svm.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f220a85514f..b86b45b85da8 100644
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
+		pr_debug("SVM: %s: use legacy intr mode for non-std irq %u\n",
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




Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A7A8494
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 15:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfIDNfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 09:35:41 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:44345 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730305AbfIDNfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 09:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1567604140; x=1599140140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=mUNv+h5rrlVGn2rMgfV6t92732DDqeR20nTWrFkl9Dk=;
  b=B/nMyvkoBHRitUPBJg9qQNUTEYDtY3zWAWfBKFIlI3knrIdcuZUbZCof
   s6JRX//O34yhwaYKbgZ/118uzkFZCG1XRntp/grKggE7CxlCjcDG8SBdV
   0Vp81hMyuV9MiIQiXZKhx0c/+V11escmIV/STfjJDN/NX9fqXJkybZTDF
   8=;
X-IronPort-AV: E=Sophos;i="5.64,467,1559520000"; 
   d="scan'208";a="700665228"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 04 Sep 2019 13:35:31 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 0E709A2B09;
        Wed,  4 Sep 2019 13:35:26 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 13:35:25 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.160.160) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 13:35:22 +0000
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
Subject: [PATCH v2 1/2] KVM: VMX: Disable posted interrupts for odd IRQs
Date:   Wed, 4 Sep 2019 15:35:10 +0200
Message-ID: <20190904133511.17540-2-graf@amazon.com>
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

Add code in the VMX PI logic to explicitly refuse to establish posted
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
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 570a233e272b..8029fe658c30 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7401,6 +7401,28 @@ static int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 			continue;
 		}
 
+		switch (irq.delivery_mode) {
+		case dest_Fixed:
+		case dest_LowestPrio:
+			break;
+		default:
+			/*
+			 * For non-trivial interrupt events, we need to go
+			 * through the full KVM IRQ code, so refuse to take
+			 * any direct PI assignments here.
+			 */
+
+			ret = irq_set_vcpu_affinity(host_irq, NULL);
+			if (ret < 0) {
+				printk(KERN_INFO
+				    "non-std IRQ failed to recover, irq: %u\n",
+				    host_irq);
+				goto out;
+			}
+
+			continue;
+		}
+
 		vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
 		vcpu_info.vector = irq.vector;
 
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3D5645642
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 10:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiLGJQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 04:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiLGJPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 04:15:42 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C117BE3D;
        Wed,  7 Dec 2022 01:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1670404475; x=1701940475;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dnC7qpCHASmrXC97dBxl9v/ZAUIjb1dSWjszt07oeWs=;
  b=eUQTUTtR0mBEuxiQ6iImLFzmWDtVjy5n64IkfUeL73IIMq7KIvHsiVAo
   xi/yJA8CIxbFIa5aAaI/RmM6js9RObB1nHNxRDazd3zoladOy0QkK5gad
   uR9Do37eU36FCBctY57W5Aqqfieq0CVHZb2JsWuOS3gjS/jqLAfbVJTcy
   E=;
X-IronPort-AV: E=Sophos;i="5.96,223,1665446400"; 
   d="scan'208";a="287898875"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 09:14:29 +0000
Received: from EX13D42EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com (Postfix) with ESMTPS id 0582D609D1;
        Wed,  7 Dec 2022 09:14:27 +0000 (UTC)
Received: from EX19D039EUA004.ant.amazon.com (10.252.50.95) by
 EX13D42EUA004.ant.amazon.com (10.43.165.34) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 7 Dec 2022 09:14:26 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX19D039EUA004.ant.amazon.com (10.252.50.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 7 Dec 2022 09:14:26 +0000
Received: from dev-dsk-attofari-1c-9e00ebdc.eu-west-1.amazon.com
 (10.13.242.123) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server (TLS) id 15.0.1497.42 via Frontend Transport; Wed, 7 Dec 2022 09:14:24
 +0000
From:   Adamos Ttofari <attofari@amazon.de>
CC:     <attofari@amazon.de>, Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: x86: ioapic: Fix level-triggered EOI and userspace IOAPIC reconfigure race
Date:   Wed, 7 Dec 2022 09:13:24 +0000
Message-ID: <20221207091324.89619-1-attofari@amazon.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When split-irqchip is used KVM uses ioapic_handled_vectors to identify
which vectors require an exit to userspace IOAPIC. Unfortunately, when the
IOAPIC is reconfigured while the interrupt is being handled, it will use
the newest configuration; therefore, the EOI will not be delivered to
IOAPIC.

A previous commit 0fc5a36dd6b3
("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC reconfigure race")
fixed the race for kernel ioapic, but the issue still persists for
userspace IOAPIC:

1) Userspace IOAPIC sends a level triggered interrupt to VCPU0.
2) VCPU0's handler reconfigures the IOAPIC to route the interrupts to
   VCPU1. (This can cause userspace IOAPIC to commit a new routing table,
   eventually leading KVM to unset the vector in ioapic_handled_vectors)
3) VCPU0 triggers an EOI, and it's not delivered to userspace IOAPIC
   because the vector bit is not set in ioapic_handled_vectors.
4) The loss of EOI, leaves remote_irr in IOAPIC set. Eventually blocking
   new interrupts.

To avoid the above scenario, we should apply a similar fix like
commit 0fc5a36dd6b3 ("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC
reconfigure race") Which is to add all pending and running vectors to
ioapic_handled_vectors.

Fixes: 0fc5a36dd6b3 ("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC reconfigure race")

Signed-off-by: Adamos Ttofari <attofari@amazon.de>
---
 arch/x86/kvm/irq_comm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 0687162c4f22..36d65997a212 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -426,8 +426,8 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
 
 			if (irq.trig_mode &&
-			    kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
-						irq.dest_id, irq.dest_mode))
+			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT, irq.dest_id,
+				 irq.dest_mode) || kvm_apic_pending_eoi(vcpu, irq.vector)))
 				__set_bit(irq.vector, ioapic_handled_vectors);
 		}
 	}
-- 
2.38.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




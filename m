Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541AB646C29
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 10:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiLHJqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 04:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiLHJpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 04:45:07 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BB76E57B;
        Thu,  8 Dec 2022 01:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1670492707; x=1702028707;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7wbNfUuo0gjVZMzLaxaF+nBToHh3AnEBb4hQSLoqur0=;
  b=IWNXBn7F56NR0HqP1/DnjfCESKFf1WhOEJKMEBhX1ts44iIy4NV2YS1w
   qBaTIR4MuMd5RZ9jOM1Ji3B/fqKZMqNZrAV3h0UA1advKBfT9tvsWIGWg
   ds8wMqZXnqqAFLEpcMhtFBcp22c2N0+3rpmRo5LZ/poX7Qd8syCJnwFHt
   s=;
X-IronPort-AV: E=Sophos;i="5.96,227,1665446400"; 
   d="scan'208";a="159200994"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 09:45:03 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com (Postfix) with ESMTPS id C2E3282149;
        Thu,  8 Dec 2022 09:44:57 +0000 (UTC)
Received: from EX19D008UEC004.ant.amazon.com (10.252.135.170) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 8 Dec 2022 09:44:56 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX19D008UEC004.ant.amazon.com (10.252.135.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 8 Dec 2022 09:44:56 +0000
Received: from dev-dsk-attofari-1c-9e00ebdc.eu-west-1.amazon.com
 (10.13.242.123) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server (TLS) id 15.0.1497.42 via Frontend Transport; Thu, 8 Dec 2022 09:44:55
 +0000
From:   Adamos Ttofari <attofari@amazon.de>
CC:     <attofari@amazon.de>, <dwmw@amazon.co.uk>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] KVM: x86: ioapic: Fix level-triggered EOI and userspace I/OAPIC reconfigure race
Date:   Thu, 8 Dec 2022 09:44:14 +0000
Message-ID: <20221208094415.12723-1-attofari@amazon.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221207091324.89619-1-attofari@amazon.de>
References: <20221207091324.89619-1-attofari@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When scanning userspace I/OAPIC entries, intercept EOI for level-triggered
IRQs if the current vCPU has a pending and/or in-service IRQ for the
vector in its local API, even if the vCPU doesn't match the new entry's
destination.  This fixes a race between userspace I/OAPIC reconfiguration
and IRQ delivery that results in the vector's bit being left set in the
remote IRR due to the eventual EOI not being forwarded to the userspace
I/OAPIC.

Commit 0fc5a36dd6b3 ("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC
reconfigure race") fixed the in-kernel IOAPIC, but not the userspace
IOAPIC configuration, which has a similar race.

Fixes: 0fc5a36dd6b3 ("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC reconfigure race")

Signed-off-by: Adamos Ttofari <attofari@amazon.de>
---
 arch/x86/kvm/irq_comm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 0687162c4f22..3742d9adacfc 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -426,8 +426,9 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
 
 			if (irq.trig_mode &&
-			    kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
-						irq.dest_id, irq.dest_mode))
+			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
+						 irq.dest_id, irq.dest_mode) ||
+			     kvm_apic_pending_eoi(vcpu, irq.vector)))
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




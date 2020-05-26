Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523321C3FD2
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbgEDQ3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:29:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54661 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729590AbgEDQ3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:29:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588609739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=vyYYYfDE98dZ74NRX6gFiGAARZEAda2ko5w/z7U1TOY=;
        b=Esnrn88KsElsfJxD8Dn6pk1Cca7jpfOPsFAUv15nAzf5BVB3R6aHtNDIiqfqRT7dDHInw8
        wxtXHwC3DSR3o/BMdKv1qanOOdLqUqD4VcAhaM0gzCFa590ya9NN+UYoJxbHfRIBtecxtG
        CM0hcoHH7dtayFyy4sED4xAoyS0zW5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-desGePx4MY68frG5i3_GMQ-1; Mon, 04 May 2020 12:28:55 -0400
X-MC-Unique: desGePx4MY68frG5i3_GMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23F818014D5;
        Mon,  4 May 2020 16:28:54 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1FDA60C81;
        Mon,  4 May 2020 16:28:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] kvm: ioapic: Restrict lazy EOI update to edge-triggered interrupts
Date:   Mon,  4 May 2020 12:28:52 -0400
Message-Id: <20200504162852.404422-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI") introduces
the following infinite loop:

BUG: stack guard page was hit at 000000008f595917 \
(stack is 00000000bdefe5a4..00000000ae2b06f5)
kernel stack overflow (double-fault): 0000 [#1] SMP NOPTI
RIP: 0010:kvm_set_irq+0x51/0x160 [kvm]
Call Trace:
 irqfd_resampler_ack+0x32/0x90 [kvm]
 kvm_notify_acked_irq+0x62/0xd0 [kvm]
 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kvm]
 ioapic_set_irq+0x20e/0x240 [kvm]
 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
 kvm_set_irq+0xbb/0x160 [kvm]
 ? kvm_hv_set_sint+0x20/0x20 [kvm]
 irqfd_resampler_ack+0x32/0x90 [kvm]
 kvm_notify_acked_irq+0x62/0xd0 [kvm]
 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kvm]
 ioapic_set_irq+0x20e/0x240 [kvm]
 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
 kvm_set_irq+0xbb/0x160 [kvm]
 ? kvm_hv_set_sint+0x20/0x20 [kvm]
....

The re-entrancy happens because the irq state is the OR of
the interrupt state and the resamplefd state.  That is, we don't
want to show the state as 0 until we've had a chance to set the
resamplefd.  But if the interrupt has _not_ gone low then
ioapic_set_irq is invoked again, causing an infinite loop.

This can only happen for a level-triggered interrupt, otherwise
irqfd_inject would immediately set the KVM_USERSPACE_IRQ_SOURCE_ID high
and then low.  Fortunately, in the case of level-triggered interrupts the VMEXIT already happens because
TMR is set.  Thus, fix the bug by restricting the lazy invocation
of the ack notifier to edge-triggered interrupts, the only ones that
need it.

Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reported-by: borisvk@bstnet.org
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://www.spinics.net/lists/kvm/msg213512.html
Fixes: f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207489
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/ioapic.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 750ff0b29404..d057376bd3d3 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -225,12 +225,12 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
 	}
 
 	/*
-	 * AMD SVM AVIC accelerate EOI write and do not trap,
-	 * in-kernel IOAPIC will not be able to receive the EOI.
-	 * In this case, we do lazy update of the pending EOI when
-	 * trying to set IOAPIC irq.
+	 * AMD SVM AVIC accelerate EOI write iff the interrupt is edge
+	 * triggered, in which case the in-kernel IOAPIC will not be able
+	 * to receive the EOI.  In this case, we do a lazy update of the
+	 * pending EOI when trying to set IOAPIC irq.
 	 */
-	if (kvm_apicv_activated(ioapic->kvm))
+	if (edge && kvm_apicv_activated(ioapic->kvm))
 		ioapic_lazy_update_eoi(ioapic, irq);
 
 	/*
-- 
2.18.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EA1297B70
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 10:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760013AbgJXIRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 04:17:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755393AbgJXIRc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 24 Oct 2020 04:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603527451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NnkQ/HnGwhFyFBjodi9ogghF5+/5xJZIfgVYIwXmUTg=;
        b=h2JcgShCFpwz+n9UvuGz4QWmbMqwIeeiHvfATPfmlwYoiKS2fy4kWrYWYoYvGezO3+A52Y
        5kQQVssmkNHAbAuGUkSfBLGJSgLwrxeJy0Q1cmu4YeLOysV6Q170SeE1c/5urnG9kdZ33m
        0+rJI/XJ+IHMT8rILhKPVGFM6Ui+bYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-4TJLjx1CP72pHzZhqzXkRw-1; Sat, 24 Oct 2020 04:17:28 -0400
X-MC-Unique: 4TJLjx1CP72pHzZhqzXkRw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF25F805F0D;
        Sat, 24 Oct 2020 08:17:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95F1A5C1C4;
        Sat, 24 Oct 2020 08:17:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] KVM: ioapic: break infinite recursion on lazy EOI
Date:   Sat, 24 Oct 2020 04:17:24 -0400
Message-Id: <20201024081724.2799401-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

During shutdown the IOAPIC trigger mode is reset to edge triggered
while the vfio-pci INTx is still registered with a resampler.
This allows us to get into an infinite loop:

ioapic_set_irq
  -> ioapic_lazy_update_eoi
  -> kvm_ioapic_update_eoi_one
  -> kvm_notify_acked_irq
  -> kvm_notify_acked_gsi
  -> (via irq_acked fn ptr) irqfd_resampler_ack
  -> kvm_set_irq
  -> (via set fn ptr) kvm_set_ioapic_irq
  -> kvm_ioapic_set_irq
  -> ioapic_set_irq

Commit 7faab2faca0c acknowledges that this recursion loop exists
and tries to avoid it at the call to ioapic_lazy_update_eoi, but at
this point the scenario is already set, we have an edge interrupt with
resampler on the same gsi.

Fortunately, the only user of irq ack notifiers (in addition to resamplefd)
is i8254 timer interrupt reinjection.  These are edge-triggered, so in
principle they would need the call to kvm_ioapic_update_eoi_one from
ioapic_lazy_update_eoi, but they already disable AVIC(*), so they don't
need the lazy EOI behavior.  Therefore, remove the call to
kvm_ioapic_update_eoi_one from ioapic_lazy_update_eoi.

This fixes CVE-2020-27152.  Note that this issue cannot happen with
SR-IOV assigned devices because virtual functions do not have INTx,
only MSI.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/ioapic.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index d057376bd3d3..698969e18fe3 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -197,12 +197,9 @@ static void ioapic_lazy_update_eoi(struct kvm_ioapic *ioapic, int irq)
 
 		/*
 		 * If no longer has pending EOI in LAPICs, update
-		 * EOI for this vetor.
+		 * EOI for this vector.
 		 */
 		rtc_irq_eoi(ioapic, vcpu, entry->fields.vector);
-		kvm_ioapic_update_eoi_one(vcpu, ioapic,
-					  entry->fields.trig_mode,
-					  irq);
 		break;
 	}
 }
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46501847CD
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 14:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgCMNQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 09:16:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41566 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgCMNQd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 09:16:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584105392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=7LrEVfZqSzW5l9b4ZSlHX3dnPgc63h+ofdKggf3vssA=;
        b=OdP/QA25McLc9wy1q4vKWQpLn4vKENsFxeNKWYTqkS01/Wx7/lfVlVSxI8Z/JK28OsuYDC
        Ep0/7L72u2ZOQLDI8MSlx86KNLRIOAOi5aFeaPSqglOd3JHa3h2nvdZfOZc/8EPngS5bla
        VlYzOLmAGliLlJ2yAYJfaPn+q478Pes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-T1yMoNLHMxSWIvn3GkXIxw-1; Fri, 13 Mar 2020 09:16:30 -0400
X-MC-Unique: T1yMoNLHMxSWIvn3GkXIxw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37BFD8017CC;
        Fri, 13 Mar 2020 13:16:29 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C96B492D47;
        Fri, 13 Mar 2020 13:16:24 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, pbonzini@redhat.com,
        peterx@redhat.com
Subject: [Patch v2] KVM: x86: Initializing all kvm_lapic_irq fields in ioapic_write_indirect
Date:   Fri, 13 Mar 2020 09:16:24 -0400
Message-Id: <1584105384-4864-1-git-send-email-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously all fields of structure kvm_lapic_irq were not initialized
before it was passed to kvm_bitmap_or_dest_vcpus(). Which will cause
an issue when any of those fields are used for processing a request.
For example not initializing the msi_redir_hint field before passing
to the kvm_bitmap_or_dest_vcpus(), may lead to a misbehavior of
kvm_apic_map_get_dest_lapic(). This will specifically happen when the
kvm_lowest_prio_delivery() returns TRUE due to a non-zero garbage
value of msi_redir_hint, which should not happen as the request belongs
to APIC fixed delivery mode and we do not want to deliver the
interrupt only to the lowest priority candidate.

This patch initializes all the fields of kvm_lapic_irq based on the
values of ioapic redirect_entry object before passing it on to
kvm_bitmap_or_dest_vcpus().

Fixes: 7ee30bc132c6("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 arch/x86/kvm/ioapic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 7668fed..3a8467d 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -378,12 +378,15 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 		if (e->fields.delivery_mode == APIC_DM_FIXED) {
 			struct kvm_lapic_irq irq;
 
-			irq.shorthand = APIC_DEST_NOSHORT;
 			irq.vector = e->fields.vector;
 			irq.delivery_mode = e->fields.delivery_mode << 8;
-			irq.dest_id = e->fields.dest_id;
 			irq.dest_mode =
 			    kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
+			irq.level = 1;
+			irq.trig_mode = e->fields.trig_mode;
+			irq.shorthand = APIC_DEST_NOSHORT;
+			irq.dest_id = e->fields.dest_id;
+			irq.msi_redir_hint = false;
 			bitmap_zero(&vcpu_bitmap, 16);
 			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
 						 &vcpu_bitmap);
-- 
1.8.3.1


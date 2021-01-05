Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695A02EB379
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 20:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbhAETaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 14:30:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728230AbhAETaS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 14:30:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609874932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Hugo6ZEFcgLqAbh5AX1tterJDrXPcf7pVF8nJ3VeGds=;
        b=IGeZ4KXY3hCxt6CDTXhcfTd8SFNpDn2tOdNkQ4iAo62kbpH9xUPM6TgEoz9mfKjnuw6ppM
        FtMhsE2wny07jy3Gu1RPHYh/WZEmWNmWi6ONkebGsVB30qVILjLIKCjCu4mrSCK2SQneXH
        P8Dfef5sB25rt0wq2XE6z3x8ZTydPdo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-cyKzp4EYOGi4vuaXDDFyug-1; Tue, 05 Jan 2021 14:28:50 -0500
X-MC-Unique: cyKzp4EYOGi4vuaXDDFyug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3166800D53;
        Tue,  5 Jan 2021 19:28:48 +0000 (UTC)
Received: from virtlab500.virt.lab.eng.bos.redhat.com (virtlab500.virt.lab.eng.bos.redhat.com [10.19.152.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A92D53C9F;
        Tue,  5 Jan 2021 19:28:45 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, w90p710@gmail.com, pbonzini@redhat.com,
        vkuznets@redhat.com, nitesh@redhat.com
Subject: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest context"
Date:   Tue,  5 Jan 2021 14:28:44 -0500
Message-Id: <20210105192844.296277-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit d7a08882a0a4b4e176691331ee3f492996579534.

After the introduction of the patch:

	87fa7f3e9: x86/kvm: Move context tracking where it belongs

since we have moved guest_exit_irqoff closer to the VM-Exit, explicit
enabling of irqs to process pending interrupts should not be required
within vcpu_enter_guest anymore.

Conflicts:
	arch/x86/kvm/svm.c

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 arch/x86/kvm/svm/svm.c |  9 +++++++++
 arch/x86/kvm/x86.c     | 11 -----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cce0143a6f80..c9b2fbb32484 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4187,6 +4187,15 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 
 static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
+	kvm_before_interrupt(vcpu);
+	local_irq_enable();
+	/*
+	 * We must have an instruction with interrupts enabled, so
+	 * the timer interrupt isn't delayed by the interrupt shadow.
+	 */
+	asm("nop");
+	local_irq_disable();
+	kvm_after_interrupt(vcpu);
 }
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc7a3ce..3e17c9ffcad8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9023,18 +9023,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	kvm_x86_ops.handle_exit_irqoff(vcpu);
 
-	/*
-	 * Consume any pending interrupts, including the possible source of
-	 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
-	 * An instruction is required after local_irq_enable() to fully unblock
-	 * interrupts on processors that implement an interrupt shadow, the
-	 * stat.exits increment will do nicely.
-	 */
-	kvm_before_interrupt(vcpu);
-	local_irq_enable();
 	++vcpu->stat.exits;
-	local_irq_disable();
-	kvm_after_interrupt(vcpu);
 
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
-- 
2.27.0


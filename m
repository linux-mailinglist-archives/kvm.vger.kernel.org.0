Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6ED274A30
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 22:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgIVUgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 16:36:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbgIVUgV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 16:36:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600806979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/uq1ydAD3WSjGkI4P2e9ZsRKctZ5UuVc07zSVeRW7bI=;
        b=EdgZOUofMcIb4zblp0tXorwxw6qZNEzAbqbzgx2vVEAZCL+BX4A5HD3Xveb4DGnpp08GON
        9wzQds/XZS3JhaSJwuRb8o8VAzQ6EHmf/x263xi9l2zztb7f8/4egkULUKykOgHlmm4Z91
        Vpz55HtahnpeMdvmzuJbkh2tnadJOU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-stfvHO0ZOfqDt8Ev0brejQ-1; Tue, 22 Sep 2020 16:36:17 -0400
X-MC-Unique: stfvHO0ZOfqDt8Ev0brejQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7645C64086;
        Tue, 22 Sep 2020 20:36:16 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B35767367E;
        Tue, 22 Sep 2020 20:36:12 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] kvm: Correct documentation of kvm_irqchip_*()
Date:   Tue, 22 Sep 2020 16:36:12 -0400
Message-Id: <20200922203612.2178370-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When split irqchip support was introduced, the meaning of
kvm_irqchip_in_kernel() changed: now it only means the LAPIC is
in kernel.  The PIC, IOAPIC, and PIT might be in userspace if
irqchip=split was set.  Update the doc comment to reflect that.

While at it, remove the "the user asked us" part in
kvm_irqchip_is_split() doc comment.  That macro has nothing to do
with existence of explicit user-provided options.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 include/sysemu/kvm.h | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 5bbea538830..23fce48b0be 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -51,23 +51,22 @@ extern bool kvm_msi_use_devid;
 /**
  * kvm_irqchip_in_kernel:
  *
- * Returns: true if the user asked us to create an in-kernel
- * irqchip via the "kernel_irqchip=on" machine option.
+ * Returns: true if an in-kernel irqchip was created.
  * What this actually means is architecture and machine model
- * specific: on PC, for instance, it means that the LAPIC,
- * IOAPIC and PIT are all in kernel. This function should never
- * be used from generic target-independent code: use one of the
- * following functions or some other specific check instead.
+ * specific: on PC, for instance, it means that the LAPIC
+ * is in kernel.  This function should never be used from generic
+ * target-independent code: use one of the following functions or
+ * some other specific check instead.
  */
 #define kvm_irqchip_in_kernel() (kvm_kernel_irqchip)
 
 /**
  * kvm_irqchip_is_split:
  *
- * Returns: true if the user asked us to split the irqchip
- * implementation between user and kernel space. The details are
- * architecture and machine specific. On PC, it means that the PIC,
- * IOAPIC, and PIT are in user space while the LAPIC is in the kernel.
+ * Returns: true if the irqchip implementation is split between
+ * user and kernel space.  The details are architecture and
+ * machine specific.  On PC, it means that the PIC, IOAPIC, and
+ * PIT are in user space while the LAPIC is in the kernel.
  */
 #define kvm_irqchip_is_split() (kvm_split_irqchip)
 
-- 
2.26.2


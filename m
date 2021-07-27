Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E11E3D8452
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 01:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhG0XxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 19:53:07 -0400
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:48920 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232786AbhG0XxG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 19:53:06 -0400
Received: from MTA-07-3.privateemail.com (mta-07-1.privateemail.com [198.54.122.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id 9BCA5800AA
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 19:53:05 -0400 (EDT)
Received: from mta-07.privateemail.com (localhost [127.0.0.1])
        by mta-07.privateemail.com (Postfix) with ESMTP id 3EC15180022F;
        Tue, 27 Jul 2021 19:53:04 -0400 (EDT)
Received: from hal-station.. (unknown [10.20.151.235])
        by mta-07.privateemail.com (Postfix) with ESMTPA id 75B38180021B;
        Tue, 27 Jul 2021 19:53:03 -0400 (EDT)
From:   Hamza Mahfooz <someguy@effective-light.com>
To:     qemu-devel@nongnu.org
Cc:     Hamza Mahfooz <someguy@effective-light.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH] target/arm: kvm: use RCU_READ_LOCK_GUARD() in kvm_arch_fixup_msi_route()
Date:   Tue, 27 Jul 2021 19:52:01 -0400
Message-Id: <20210727235201.11491-1-someguy@effective-light.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As per commit 5626f8c6d468 ("rcu: Add automatically released rcu_read_lock
variants"), RCU_READ_LOCK_GUARD() should be used instead of
rcu_read_{un}lock().

Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>
---
 target/arm/kvm.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index d8381ba224..5d55de1a49 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -998,7 +998,6 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
     hwaddr xlat, len, doorbell_gpa;
     MemoryRegionSection mrs;
     MemoryRegion *mr;
-    int ret = 1;
 
     if (as == &address_space_memory) {
         return 0;
@@ -1006,15 +1005,19 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
 
     /* MSI doorbell address is translated by an IOMMU */
 
-    rcu_read_lock();
+    RCU_READ_LOCK_GUARD();
+
     mr = address_space_translate(as, address, &xlat, &len, true,
                                  MEMTXATTRS_UNSPECIFIED);
+
     if (!mr) {
-        goto unlock;
+        return 1;
     }
+
     mrs = memory_region_find(mr, xlat, 1);
+
     if (!mrs.mr) {
-        goto unlock;
+        return 1;
     }
 
     doorbell_gpa = mrs.offset_within_address_space;
@@ -1025,11 +1028,7 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
 
     trace_kvm_arm_fixup_msi_route(address, doorbell_gpa);
 
-    ret = 0;
-
-unlock:
-    rcu_read_unlock();
-    return ret;
+    return 0;
 }
 
 int kvm_arch_add_msi_route_post(struct kvm_irq_routing_entry *route,
-- 
2.32.0


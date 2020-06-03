Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B2F1ED28A
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 16:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgFCOt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 10:49:59 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56808 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726210AbgFCOtz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Jun 2020 10:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591195794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x99DmWF3z8IQZtSAxCYmvGKbKwRwjaKEkyPdWwMZNhI=;
        b=WtBUkSg55+2G5zUEv0vB9zo/o8OZ+nH8UtBYZqI96f9AYmW4StXdXzu1v118b99xdkBXgc
        Ye6f7JwTaddeARgvISmqNGdQpcfnSuWihLr53AUyb5c+AxHYY/5oKyIpa0naYkSY9XzoBx
        kv9re1imBVc2TPZcFuPcSq8bHah/4oI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-FB3pGUkyPzWQeO8883Fu0g-1; Wed, 03 Jun 2020 10:49:50 -0400
X-MC-Unique: FB3pGUkyPzWQeO8883Fu0g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C344835B42;
        Wed,  3 Jun 2020 14:49:49 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-192.ams2.redhat.com [10.36.113.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C24BB5D9CD;
        Wed,  3 Jun 2020 14:49:46 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v3 04/20] s390x/pv: Convert to ram_block_discard_disable()
Date:   Wed,  3 Jun 2020 16:48:58 +0200
Message-Id: <20200603144914.41645-5-david@redhat.com>
In-Reply-To: <20200603144914.41645-1-david@redhat.com>
References: <20200603144914.41645-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Discarding RAM does not work as expected with protected VMs. Let's
switch to ram_block_discard_disable() for now, as we want to get rid
of qemu_balloon_inhibit(). Note that it will currently never fail, but
might fail in the future with new technologies (e.g., virtio-mem).

Cc: Richard Henderson <rth@twiddle.net>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/s390x/s390-virtio-ccw.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 67ae2e02ff..e82129e874 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -43,7 +43,6 @@
 #include "hw/qdev-properties.h"
 #include "hw/s390x/tod.h"
 #include "sysemu/sysemu.h"
-#include "sysemu/balloon.h"
 #include "hw/s390x/pv.h"
 #include "migration/blocker.h"
 
@@ -329,7 +328,7 @@ static void s390_machine_unprotect(S390CcwMachineState *ms)
     ms->pv = false;
     migrate_del_blocker(pv_mig_blocker);
     error_free_or_abort(&pv_mig_blocker);
-    qemu_balloon_inhibit(false);
+    ram_block_discard_disable(false);
 }
 
 static int s390_machine_protect(S390CcwMachineState *ms)
@@ -338,17 +337,22 @@ static int s390_machine_protect(S390CcwMachineState *ms)
     int rc;
 
    /*
-    * Ballooning on protected VMs needs support in the guest for
-    * sharing and unsharing balloon pages. Block ballooning for
-    * now, until we have a solution to make at least Linux guests
-    * either support it or fail gracefully.
+    * Discarding of memory in RAM blocks does not work as expected with
+    * protected VMs. Sharing and unsharing pages would be required. Disable
+    * it for now, until until we have a solution to make at least Linux
+    * guests either support it (e.g., virtio-balloon) or fail gracefully.
     */
-    qemu_balloon_inhibit(true);
+    rc = ram_block_discard_disable(true);
+    if (rc) {
+        error_report("protected VMs: cannot disable RAM discard");
+        return rc;
+    }
+
     error_setg(&pv_mig_blocker,
                "protected VMs are currently not migrateable.");
     rc = migrate_add_blocker(pv_mig_blocker, &local_err);
     if (rc) {
-        qemu_balloon_inhibit(false);
+        ram_block_discard_disable(false);
         error_report_err(local_err);
         error_free_or_abort(&pv_mig_blocker);
         return rc;
@@ -357,7 +361,7 @@ static int s390_machine_protect(S390CcwMachineState *ms)
     /* Create SE VM */
     rc = s390_pv_vm_enable();
     if (rc) {
-        qemu_balloon_inhibit(false);
+        ram_block_discard_disable(false);
         migrate_del_blocker(pv_mig_blocker);
         error_free_or_abort(&pv_mig_blocker);
         return rc;
-- 
2.25.4


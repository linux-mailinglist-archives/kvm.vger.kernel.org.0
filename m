Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBBC20ACF8
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgFZHX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:23:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20562 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727872AbgFZHX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 03:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593156237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YT2Lfd7O+QVGQ8xv+hC3jhPD0m++9YaFVSyLU3va45M=;
        b=TYXF4brb5Bj9C9DocIbtvzLFdaZplKMQfMkUYCuGg1/M/bhfwNpCN71ismKZyKdWulPSdt
        Hp6/qPJvN5x93GuMiPU6x6G8OUj8NSgtv+azokmjQNsmpbc6R6hPTVwHCsBfzFfw061Sx0
        J0vA1b13imHO5If6seurWJ8kbQu1UVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-6vavMERPOVWwO-N-eZlSlg-1; Fri, 26 Jun 2020 03:23:53 -0400
X-MC-Unique: 6vavMERPOVWwO-N-eZlSlg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73C0EA0BD7;
        Fri, 26 Jun 2020 07:23:52 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-35.ams2.redhat.com [10.36.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDEB41C8;
        Fri, 26 Jun 2020 07:23:49 +0000 (UTC)
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
Subject: [PATCH v5 05/21] s390x/pv: Convert to ram_block_discard_disable()
Date:   Fri, 26 Jun 2020 09:22:32 +0200
Message-Id: <20200626072248.78761-6-david@redhat.com>
In-Reply-To: <20200626072248.78761-1-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Discarding RAM does not work as expected with protected VMs. Let's
switch to ram_block_discard_disable() for now, as we want to get rid
of qemu_balloon_inhibit(). Note that it will currently never fail, but
might fail in the future with new technologies (e.g., virtio-mem).

Acked-by: Cornelia Huck <cohuck@redhat.com>
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
index b111406d56..023fd25f2b 100644
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
2.26.2


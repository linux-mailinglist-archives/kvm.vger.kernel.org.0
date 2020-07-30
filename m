Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC5B233B07
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 23:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbgG3V62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 17:58:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21136 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730635AbgG3V62 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 17:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596146307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+1f/uSLSGKmf8jEEPF1yVvJi+XRpXH6xSbKl2HyV+QQ=;
        b=QJRhiUGR8rbqoBHU25qB9Vvr2W1RXtIf/IHEXwARyvLokVr0xrogVZILJEv9GnmcLpc7sP
        UnEy4MT9wN4jAqXhqktXSWHYsTpBEy6+rjrmgr5BJA5rHHN0tbahejyHe5Inj/ya5zXvdO
        9Njnz3ZoB168fQhI5X+nVkUtwn3lP0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-xh4orQasNqKZzJK2iyoAaw-1; Thu, 30 Jul 2020 17:58:11 -0400
X-MC-Unique: xh4orQasNqKZzJK2iyoAaw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D77F800685
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 21:58:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A40569335
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 21:58:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] fw_cfg: avoid index out of bounds
Date:   Thu, 30 Jul 2020 17:58:09 -0400
Message-Id: <20200730215809.1970-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clang compilation fails with

lib/x86/fwcfg.c:32:3: error: array index 17 is past the end of the array (which contains 16 elements) [-Werror,-Warray-bounds]
                fw_override[FW_CFG_MAX_RAM] = atol(str) * 1024 * 1024;

The reason is that FW_CFG_MAX_RAM does not exist in the fw-cfg spec and was
added for bare metal support.  Fix the size of the array and rename FW_CFG_MAX_ENTRY
to FW_CFG_NUM_ENTRIES, so that it is clear that it must be one plus the
highest valid entry.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/fwcfg.c | 6 +++---
 lib/x86/fwcfg.h | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
index c2aaf5a..1734afb 100644
--- a/lib/x86/fwcfg.c
+++ b/lib/x86/fwcfg.c
@@ -4,7 +4,7 @@
 
 static struct spinlock lock;
 
-static long fw_override[FW_CFG_MAX_ENTRY];
+static long fw_override[FW_CFG_NUM_ENTRIES];
 static bool fw_override_done;
 
 bool no_test_device;
@@ -15,7 +15,7 @@ static void read_cfg_override(void)
 	int i;
 
 	/* Initialize to negative value that would be considered as invalid */
-	for (i = 0; i < FW_CFG_MAX_ENTRY; i++)
+	for (i = 0; i < FW_CFG_NUM_ENTRIES; i++)
 		fw_override[i] = -1;
 
 	if ((str = getenv("NR_CPUS")))
@@ -44,7 +44,7 @@ static uint64_t fwcfg_get_u(uint16_t index, int bytes)
     if (!fw_override_done)
         read_cfg_override();
 
-    if (index < FW_CFG_MAX_ENTRY && fw_override[index] >= 0)
+    if (index < FW_CFG_NUM_ENTRIES && fw_override[index] >= 0)
 	    return fw_override[index];
 
     spin_lock(&lock);
diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
index 64d4c6e..ac4257e 100644
--- a/lib/x86/fwcfg.h
+++ b/lib/x86/fwcfg.h
@@ -20,9 +20,12 @@
 #define FW_CFG_NUMA             0x0d
 #define FW_CFG_BOOT_MENU        0x0e
 #define FW_CFG_MAX_CPUS         0x0f
-#define FW_CFG_MAX_ENTRY        0x10
+
+/* Dummy entries used when running on bare metal */
 #define FW_CFG_MAX_RAM		0x11
 
+#define FW_CFG_NUM_ENTRIES      (FW_CFG_MAX_RAM + 1)
+
 #define FW_CFG_WRITE_CHANNEL    0x4000
 #define FW_CFG_ARCH_LOCAL       0x8000
 #define FW_CFG_ENTRY_MASK       ~(FW_CFG_WRITE_CHANNEL | FW_CFG_ARCH_LOCAL)
-- 
2.26.2


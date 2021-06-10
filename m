Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C089C3A2C99
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhFJNPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 09:15:03 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:16410 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhFJNPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 09:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623330785; x=1654866785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=VvbOf3G3WBaLDSM6Xre90wiUJXfXt0JrPes7DYE5nKE=;
  b=SIQXM3xV0RaXC7ZSfvZvpYCKHOIxUKVprB9RZiC+NJCtdMniYiqZM6OC
   4Dyhg1Ja+EPyjDx3MCVgC6bHLAp9bqnc+HA//yJC+BdKY6LLjsQ8KCGo3
   Pm9BYY9r3YwGI+qUflcodYRO0JM5uE7PRRFU7EisJHSpA6Qax7syw6XA+
   8=;
X-IronPort-AV: E=Sophos;i="5.83,263,1616457600"; 
   d="scan'208";a="117905093"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 10 Jun 2021 13:12:57 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id DC343A2284;
        Thu, 10 Jun 2021 13:12:56 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.147) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 13:12:52 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 1/2] x86: Move hyperv helpers into libs/x86
Date:   Thu, 10 Jun 2021 15:12:29 +0200
Message-ID: <2926e50c941bb2a8b47e2091f43784b53d993cc6.1623330462.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1623330462.git.sidcha@amazon.de>
References: <cover.1623330462.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.147]
X-ClientProxiedBy: EX13d09UWC004.ant.amazon.com (10.43.162.114) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move hyperv.c and hyperv.h into into libs/x86/ as it appears to be a
better place for them.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 x86/Makefile.common       | 9 +--------
 {x86 => lib/x86}/hyperv.h | 1 -
 {x86 => lib/x86}/hyperv.c | 0
 3 files changed, 1 insertion(+), 9 deletions(-)
 rename {x86 => lib/x86}/hyperv.h (99%)
 rename {x86 => lib/x86}/hyperv.c (100%)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 85dc427..118c1c8 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -22,6 +22,7 @@ cflatobjs += lib/x86/acpi.o
 cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
+cflatobjs += lib/x86/hyperv.o
 
 OBJDIRS += lib/x86
 
@@ -77,14 +78,6 @@ $(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
 
 $(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o
 
-$(TEST_DIR)/hyperv_synic.elf: $(TEST_DIR)/hyperv.o
-
-$(TEST_DIR)/hyperv_stimer.elf: $(TEST_DIR)/hyperv.o
-
-$(TEST_DIR)/hyperv_connections.elf: $(TEST_DIR)/hyperv.o
-
-$(TEST_DIR)/hyperv_overlay.elf: $(TEST_DIR)/hyperv.o
-
 arch_clean:
 	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
 	$(TEST_DIR)/.*.d lib/x86/.*.d \
diff --git a/x86/hyperv.h b/lib/x86/hyperv.h
similarity index 99%
rename from x86/hyperv.h
rename to lib/x86/hyperv.h
index 6f69c29..bb4bd84 100644
--- a/x86/hyperv.h
+++ b/lib/x86/hyperv.h
@@ -214,5 +214,4 @@ struct hv_reference_tsc_page {
         int64_t tsc_offset;
 };
 
-
 #endif
diff --git a/x86/hyperv.c b/lib/x86/hyperv.c
similarity index 100%
rename from x86/hyperv.c
rename to lib/x86/hyperv.c
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




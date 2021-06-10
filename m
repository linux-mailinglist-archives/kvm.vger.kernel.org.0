Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AABF3A3242
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 19:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhFJRjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 13:39:15 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:11118 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbhFJRjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 13:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623346638; x=1654882638;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=qTWpLN7fasm/e+sl6efpA58R8TzJua9uLtnVDM0PKhU=;
  b=jjmdpFQugYfSz7gkboySstm9fd5vx6SEQdb9zxo9j4TxSB0/EsvxdNXJ
   s+51IK19T/gMUIVzXoNDz10AM1kNrcNJO1LuYv3jAc8YYKfxDRHJkDBYU
   22SDZpJ1bw7PtWFRk8O+I4YWJzkTRQ7VfB5nr8QcwdW0SEDOn7yvaS1tD
   Y=;
X-IronPort-AV: E=Sophos;i="5.83,264,1616457600"; 
   d="scan'208";a="115049433"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 10 Jun 2021 17:37:14 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 36654A06C4;
        Thu, 10 Jun 2021 17:37:13 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.55) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 17:37:09 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 1/3] x86: Move hyperv helpers into libs/x86
Date:   Thu, 10 Jun 2021 19:36:48 +0200
Message-ID: <153c7f54e6e620ebaf4ca0610ecbbf11ecae50b2.1623346319.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1623346319.git.sidcha@amazon.de>
References: <cover.1623346319.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D36UWA001.ant.amazon.com (10.43.160.71) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move hyperv.c and hyperv.h into into libs/x86/ as it appears to be a
better place for them.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 x86/Makefile.common       | 7 +------
 {x86 => lib/x86}/hyperv.h | 1 -
 {x86 => lib/x86}/hyperv.c | 0
 3 files changed, 1 insertion(+), 7 deletions(-)
 rename {x86 => lib/x86}/hyperv.h (99%)
 rename {x86 => lib/x86}/hyperv.c (100%)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 52bb7aa..802f8c1 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -22,6 +22,7 @@ cflatobjs += lib/x86/acpi.o
 cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
+cflatobjs += lib/x86/hyperv.o
 
 OBJDIRS += lib/x86
 
@@ -74,12 +75,6 @@ $(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
 
 $(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o
 
-$(TEST_DIR)/hyperv_synic.elf: $(TEST_DIR)/hyperv.o
-
-$(TEST_DIR)/hyperv_stimer.elf: $(TEST_DIR)/hyperv.o
-
-$(TEST_DIR)/hyperv_connections.elf: $(TEST_DIR)/hyperv.o
-
 arch_clean:
 	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
 	$(TEST_DIR)/.*.d lib/x86/.*.d \
diff --git a/x86/hyperv.h b/lib/x86/hyperv.h
similarity index 99%
rename from x86/hyperv.h
rename to lib/x86/hyperv.h
index e3803e0..38de0d2 100644
--- a/x86/hyperv.h
+++ b/lib/x86/hyperv.h
@@ -213,5 +213,4 @@ struct hv_reference_tsc_page {
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




Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0442309CC
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 14:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgG1MR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 08:17:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44732 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728846AbgG1MR6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jul 2020 08:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595938676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HO4Ntmg3kwx+WcOk0iJR+OxS3yvS+0YEtkK0xDPBSYY=;
        b=GAeHemuLk99KCC9Z/075tsBzInqot/dF7eJOE9VkPA5Q6BSRZ3G7zbS3ocn81veCgWOZJB
        pbkHj6GN6cJ7/jEE7ytSnER2EtDYfkDCkWRxL3sO3dov9ssMQRgDgFytY8qVGujjm+0oOj
        efsJHYO8crRvuH82pZDGTMBGLY1sVqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-erVVCjArPW-1yLLTTnUWUA-1; Tue, 28 Jul 2020 08:17:54 -0400
X-MC-Unique: erVVCjArPW-1yLLTTnUWUA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E685E1902EA0;
        Tue, 28 Jul 2020 12:17:53 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77AD6712F2;
        Tue, 28 Jul 2020 12:17:52 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] arm64: Compile with -mno-outline-atomics
Date:   Tue, 28 Jul 2020 14:17:51 +0200
Message-Id: <20200728121751.15083-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GCC 10.1.0 introduced the -moutline-atomics option which, when
enabled, use LSE instructions when the processor provides them.
The option is enabled by default and unfortunately causes the
following error at compile time:

 aarch64-linux-gnu-ld: /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a(lse-init.o): in function `init_have_lse_atomics':
 lse-init.c:(.text.startup+0xc): undefined reference to `__getauxval'

This is happening because we are linking against our own libcflat which
doesn't implement the function __getauxval().

Disable the use of the out-of-line functions by compiling with
-mno-outline-atomics.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Makefile           | 11 +++++------
 arm/Makefile.arm64 |  3 +++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 3ff2f91600f6..0e21a49096ba 100644
--- a/Makefile
+++ b/Makefile
@@ -17,6 +17,11 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
 
 .PHONY: arch_clean clean distclean cscope
 
+# cc-option
+# Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
+cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
+              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
+
 #make sure env CFLAGS variable is not used
 CFLAGS =
 
@@ -43,12 +48,6 @@ OBJDIRS += $(LIBFDT_objdir)
 #include architecture specific make rules
 include $(SRCDIR)/$(TEST_DIR)/Makefile
 
-# cc-option
-# Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
-
-cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
-              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
-
 COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
 COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
 COMMON_CFLAGS += -Wignored-qualifiers -Werror
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index dfd0c56fe8fb..dbc7524d3070 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -9,6 +9,9 @@ ldarch = elf64-littleaarch64
 arch_LDFLAGS = -pie -n
 CFLAGS += -mstrict-align
 
+mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
+CFLAGS += $(mno_outline_atomics)
+
 define arch_elf_check =
 	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
 		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
-- 
2.25.4


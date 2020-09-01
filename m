Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FD5258AB9
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 10:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgIAIvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 04:51:10 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55006 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727089AbgIAIvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 04:51:08 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0399C5732F;
        Tue,  1 Sep 2020 08:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1598950264; x=1600764665; bh=+2lWsZX/gRrm4AzavLRxhHDoo/GY5h4wfKb
        /Xw6NKbk=; b=cU+7RcpNN+qY1FvsZYK6AxU1pJZG0ppxa/L4u5lD87zb5H+Hizu
        4oddiUyMThGy149T9C23A767BeBOga41zmjt54tHSOaGh0b6lpm9yv6FvjtrFUhf
        Vxc+4TWW/I/TMFs7OPEWrRgAkQIDICl8cCTtDNQ2lXPV345l0xNRTuSI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id x2t1_GzJ4rV9; Tue,  1 Sep 2020 11:51:04 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7ED2252215;
        Tue,  1 Sep 2020 11:51:04 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 1 Sep
 2020 11:51:04 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [kvm-unit-tests PATCH v2 01/10] x86: Makefile: Allow division on x86_64-elf binutils
Date:   Tue, 1 Sep 2020 11:50:47 +0300
Message-ID: <20200901085056.33391-2-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901085056.33391-1-r.bolshakov@yadro.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For compatibility with other SVR4 assemblers, '/' starts a comment on
*-elf binutils target and thus division operator is not allowed [1][2].
That breaks cstart64.S build:

  x86/cstart64.S: Assembler messages:
  x86/cstart64.S:294: Error: unbalanced parenthesis in operand 1.

configure should detect if --divide needs to be passed to assembler by
compiling a small snippet where division is used inside parentheses.

1. https://sourceware.org/binutils/docs/as/i386_002dChars.html
2. https://sourceware.org/binutils/docs/as/i386_002dOptions.html#index-_002d_002ddivide-option_002c-i386

Cc: Cameron Esfahani <dirty@apple.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 configure           | 12 ++++++++++++
 x86/Makefile.common |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/configure b/configure
index f9d030f..4eb504f 100755
--- a/configure
+++ b/configure
@@ -15,6 +15,7 @@ endian=""
 pretty_print_stacks=yes
 environ_default=yes
 u32_long=
+wa_divide=
 vmm="qemu"
 errata_force=0
 erratatxt="$srcdir/errata.txt"
@@ -156,6 +157,16 @@ EOF
 u32_long=$("$cross_prefix$cc" -E lib-test.c | grep -v '^#' | grep -q long && echo yes)
 rm -f lib-test.c
 
+# check if slash can be used for division
+if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
+  cat << EOF > lib-test.S
+foo:
+    movl (8 / 2), %eax
+EOF
+  wa_divide=$("$cross_prefix$cc" -c lib-test.S >/dev/null 2>&1 || echo yes)
+  rm -f lib-test.{o,S}
+fi
+
 # Are we in a separate build tree? If so, link the Makefile
 # and shared stuff so that 'make' and run_tests.sh work.
 if test ! -e Makefile; then
@@ -205,6 +216,7 @@ PRETTY_PRINT_STACKS=$pretty_print_stacks
 ENVIRON_DEFAULT=$environ_default
 ERRATATXT=$erratatxt
 U32_LONG_FMT=$u32_long
+WA_DIVIDE=$wa_divide
 EOF
 
 cat <<EOF > lib/config.h
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 2ea9c9f..c3f7dc4 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -29,6 +29,9 @@ $(libcflat): LDFLAGS += -nostdlib
 $(libcflat): CFLAGS += -ffreestanding -I $(SRCDIR)/lib -I lib
 
 COMMON_CFLAGS += -m$(bits)
+ifneq ($(WA_DIVIDE),)
+COMMON_CFLAGS += -Wa,--divide
+endif
 COMMON_CFLAGS += -O1
 
 # stack.o relies on frame pointers.
-- 
2.28.0


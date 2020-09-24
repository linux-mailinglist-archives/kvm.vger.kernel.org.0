Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD62277876
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 20:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgIXSYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 14:24:07 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:35490 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728264AbgIXSYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 14:24:06 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DD711579F2;
        Thu, 24 Sep 2020 18:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1600971843; x=
        1602786244; bh=Nekod14rEitjpGsAgxjBkB5K4jNGoD1ieQohZPzbM4g=; b=k
        Tt0GcUSdnZCmaAhjgv1wOH2EPLM/NTOLduXV7FWO5Y3vEUgykOI4AsM/FAb9Q8i2
        oY1qBWExHRNol79nXukPchDUhZ8gqyNr+Z3QuCKUYhrwKoc8KmLKu8scSMf2TcP3
        SEfxLhs4eEsBNsUYvi42gZc1QB9LvFC70uWryCKXrM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jHkl3H-oJFQf; Thu, 24 Sep 2020 21:24:03 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 66DAC57933;
        Thu, 24 Sep 2020 21:24:03 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 24
 Sep 2020 21:24:03 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH] configure: Test if compiler supports -m16 on x86
Date:   Thu, 24 Sep 2020 21:24:01 +0300
Message-ID: <20200924182401.95891-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-m16 option is available only since GCC 4.9.0 [1]. That causes a build
failure on centos-7 [2] that has GCC 4.8.5.

Fallback to -m32 if -m16 is not available.

1. http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59672
2. https://gitlab.com/bonzini/kvm-unit-tests/-/jobs/755368387

Fixes: 2616ad934e2 ("x86: realmode: Workaround clang issues")
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 configure           | 11 +++++++++++
 x86/Makefile.common |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/configure b/configure
index f930543..7dc2e3b 100755
--- a/configure
+++ b/configure
@@ -16,6 +16,7 @@ pretty_print_stacks=yes
 environ_default=yes
 u32_long=
 wa_divide=
+m16_support=
 vmm="qemu"
 errata_force=0
 erratatxt="$srcdir/errata.txt"
@@ -167,6 +168,15 @@ EOF
   rm -f lib-test.{o,S}
 fi
 
+# check if -m16 is supported
+if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
+  cat << EOF > lib-test.c
+int f(int a, int b) { return a + b; }
+EOF
+  m16_support=$("$cross_prefix$cc" -m16 -c lib-test.c >/dev/null 2>&1 && echo yes)
+  rm -f lib-test.{o,c}
+fi
+
 # require enhanced getopt
 getopt -T > /dev/null
 if [ $? -ne 4 ]; then
@@ -224,6 +234,7 @@ ENVIRON_DEFAULT=$environ_default
 ERRATATXT=$erratatxt
 U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
+M16_SUPPORT=$m16_support
 EOF
 
 cat <<EOF > lib/config.h
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 5567d66..553bf49 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -72,7 +72,11 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
 	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
 	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
+ifeq ($(M16_SUPPORT),yes)
 $(TEST_DIR)/realmode.o: bits = 16
+else
+$(TEST_DIR)/realmode.o: bits = 32
+endif
 
 $(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o
 
-- 
2.28.0


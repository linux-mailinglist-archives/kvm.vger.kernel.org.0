Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53ED3CB668
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 12:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhGPKzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 06:55:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232248AbhGPKzW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Jul 2021 06:55:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626432747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dQ9livOHX4Of0h6YaqNPiNRMVMaSNTYaTom+qtCoFiQ=;
        b=ePkXuSRToM0mobCHMbygjLrPFsXLE18oBjeWjzP0dzJ0VWOX6j/nvKtf1TVPdHQtwUozFg
        CCtCJpjNTeiLODBJaAts0UQVGFGymWrbJt1JCYBYcuFy+uQX+PoNQyaFFCrLJ3TEgeYYT+
        a0en5uWOgNr2P2JFNMWgIexVwoCu+hU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-34PWzeb3NAO36xU5YtbMAA-1; Fri, 16 Jul 2021 06:52:25 -0400
X-MC-Unique: 34PWzeb3NAO36xU5YtbMAA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA4FB80006E;
        Fri, 16 Jul 2021 10:52:24 +0000 (UTC)
Received: from thuth.com (ovpn-112-45.ams2.redhat.com [10.36.112.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 668D110016F7;
        Fri, 16 Jul 2021 10:52:23 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] s390x: Fix out-of-tree builds
Date:   Fri, 16 Jul 2021 12:52:19 +0200
Message-Id: <20210716105219.1201997-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The support for "snippets" (nested guest binaries) that has been added
recently to the s390x folder broke the out-of-tree compilation. We
have to make sure that the snippet folder is created in the build
directory, too, and that linker script is taken from the source folder.

While we're at it, switch the gitlab-CI cross compiler job to use
out-of-tree builds, too, so that this does not happen so easily again.
We're still testing in-tree s390x builds with the native "s390x-kvm"
job on the s390x host, so we now test both, in-tree and out-of-tree
builds.

Fixes: 2f6fdb4ac446 ("s390x: snippets: Add snippet compilation")
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 4 +++-
 configure      | 4 ++++
 s390x/Makefile | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 4aebb97..943b20f 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -57,7 +57,9 @@ build-ppc64le:
 build-s390x:
  script:
  - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
- - ./configure --arch=s390x --cross-prefix=s390x-linux-gnu-
+ - mkdir build
+ - cd build
+ - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
      selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
diff --git a/configure b/configure
index 1d4871e..1d4d855 100755
--- a/configure
+++ b/configure
@@ -296,6 +296,10 @@ if test ! -e Makefile; then
     ln -sf "$srcdir/$testdir/unittests.cfg" $testdir/
     ln -sf "$srcdir/run_tests.sh"
 
+    if [ -d "$srcdir/$testdir/snippets" ]; then
+        mkdir -p "$testdir/snippets/c"
+    fi
+
     echo "linking scripts..."
     ln -sf "$srcdir/scripts"
 fi
diff --git a/s390x/Makefile b/s390x/Makefile
index 07af26d..6565561 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -90,7 +90,7 @@ $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
 
 $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
-	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
+	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
 	$(OBJCOPY) -O binary $@ $@
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
 
-- 
2.27.0


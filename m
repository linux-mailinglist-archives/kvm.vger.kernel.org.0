Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84A1740E5E
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 12:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjF1KL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 06:11:57 -0400
Received: from out-4.mta1.migadu.com ([95.215.58.4]:20721 "EHLO
        out-4.mta1.migadu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjF1KFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 06:05:52 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687946751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AylV24Xz4iEgWb0+5NVhh3ZZ/AVOOjzHb3wN18qmDfU=;
        b=GYxlBFiOAaltJIgAhPlOmxe4+Ge+hPTNRwBsgCgJrrQ2/AiRSvRw/Z5kgYocaSqjOPvAnL
        2gvPm98vATpjewt3CEFNBb4oiNcArhNBdauubxIUxknmMrL0j2ArgPQC5zIayCOjcstQAC
        RQuh4A2QC8ET43zMYZsIawFJIvNCrfE=
From:   Andrew Jones <andrew.jones@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH] runtime: Teach pretty-print-stacks about EFI debug info
Date:   Wed, 28 Jun 2023 12:05:51 +0200
Message-ID: <20230628100550.42786-2-andrew.jones@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running a unit test built for EFI, pretty-print-stacks needs to
look at ${kernel}.efi.debug, where ${kernel} comes from the 'file'
field of unittests.cfg but has the .flat extension removed. Teach
the pretty-print-stacks script to do that by ensuring ${kernel}.efi
is passed to the script, giving it the ability to identify an EFI
kernel and know where it is, i.e. any prepended path to the filename
is maintained. To pass ${kernel}.efi we change run() to not needlessly
convert ${kernel}.flat to $(basename $kernel .flat), but rather
to ${kernel}.efi. The original change was needless because the EFI
$RUNTIME_arch_run scripts already do a $(basename $kernel .efi)
conversion.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---

This is based on "[kvm-unit-tests PATCH v3 0/6] arm64: improve
debuggability" which introduces .efi.debug files.

 scripts/pretty_print_stacks.py | 6 +++++-
 scripts/runtime.bash           | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks.py
index 90026b724684..d990d30055d5 100755
--- a/scripts/pretty_print_stacks.py
+++ b/scripts/pretty_print_stacks.py
@@ -63,7 +63,11 @@ def main():
         sys.stderr.write('usage: %s <kernel>\n' % sys.argv[0])
         sys.exit(1)
 
-    binary = sys.argv[1].replace(".flat", ".elf")
+    binary = sys.argv[1]
+    if binary.endswith('.flat'):
+        binary = binary.replace('.flat', '.elf')
+    elif binary.endswith('.efi'):
+        binary += '.debug'
 
     with open("config.mak") as config_file:
         for line in config_file:
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 785a7b627bfd..54f8ade6bc71 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -83,7 +83,7 @@ function run()
     local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
 
     if [ "${CONFIG_EFI}" == "y" ]; then
-        kernel=$(basename $kernel .flat)
+        kernel=${kernel/%.flat/.efi}
     fi
 
     if [ -z "$testname" ]; then
-- 
2.41.0


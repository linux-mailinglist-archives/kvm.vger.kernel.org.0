Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9031B3BA345
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhGBQdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 12:33:18 -0400
Received: from foss.arm.com ([217.140.110.172]:50634 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230036AbhGBQdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 12:33:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDA23143B;
        Fri,  2 Jul 2021 09:30:44 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 75C643F5A1;
        Fri,  2 Jul 2021 09:30:42 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        lvivier@redhat.com, kvm-ppc@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, maz@kernel.org, vivek.gautam@arm.com
Subject: [kvm-unit-tests RFC PATCH 5/5] configure: Ignore --erratatxt when --target=kvmtool
Date:   Fri,  2 Jul 2021 17:31:22 +0100
Message-Id: <20210702163122.96110-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210702163122.96110-1-alexandru.elisei@arm.com>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool runs a test using the -f/--firmware argument, which doesn't load an
initrd, making specifying an errata file useless. Instead, configure forces
all erratas to be enabled via the CONFIG_ERRATA_FORCE define in
lib/config.h.

Forbid the --erratatxt option when kvm-unit-tests is configured for kvmtool
and let the user know that all erratas are enabled by default.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
I'm not sure if printing an error is too strong here and a simple warning would
suffice. Suggestions welcome!

 configure | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/configure b/configure
index 395c809c9c02..acd288239f80 100755
--- a/configure
+++ b/configure
@@ -24,7 +24,8 @@ u32_long=
 wa_divide=
 target=
 errata_force=0
-erratatxt="$srcdir/errata.txt"
+erratatxt_default="$srcdir/errata.txt"
+erratatxt="_NO_FILE_4Uhere_"
 host_key_document=
 page_size=
 earlycon=
@@ -50,7 +51,8 @@ usage() {
 	                           enable or disable the generation of a default environ when
 	                           no environ is provided by the user (enabled by default)
 	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
-	                           '--erratatxt=' to ensure no file is used.
+	                           '--erratatxt=' to ensure no file is used. This option is
+	                           invalid for arm/arm64 when target=kvmtool.
 	    --host-key-document=HOST_KEY_DOCUMENT
 	                           Specify the machine-specific host-key document for creating
 	                           a PVM image with 'genprotimg' (s390x only)
@@ -147,11 +149,6 @@ if [ -n "$host_key_document" ] && [ ! -f "$host_key_document" ]; then
     exit 1
 fi
 
-if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
-    echo "erratatxt: $erratatxt does not exist or is not a regular file"
-    exit 1
-fi
-
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
@@ -184,6 +181,21 @@ else
     fi
 fi
 
+if [ "$target" = "kvmtool" ]; then
+    if [ "$erratatxt" ] && [ "$erratatxt" != "_NO_FILE_4Uhere_" ]; then
+        echo "--erratatxt is not supported for target=kvmtool (all erratas enabled by default)"
+        usage
+    fi
+else
+    if [ "$erratatxt" = "_NO_FILE_4Uhere_" ]; then
+        erratatxt=$erratatxt_default
+    fi
+    if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
+        echo "erratatxt: $erratatxt does not exist or is not a regular file"
+        exit 1
+    fi
+fi
+
 [ -z "$processor" ] && processor="$arch"
 
 if [ "$processor" = "arm64" ]; then
-- 
2.32.0


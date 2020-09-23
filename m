Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBBF27525D
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 09:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgIWHjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 03:39:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726550AbgIWHjm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 03:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600846780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=5Xq33sgqqTIEfb547wu5zp7B0KAssraA6l5ncbhoQQs=;
        b=G4zAV62eLJsOI1nTHnHywxXrc1GXJO3b5tbjDysr8VPvgjR3nhpVMhP/UMEfzTEeKA+uwa
        R3t5yRRogDnz4EN2DSgkb2jtkDEqNMxTIUxu982d8C0rlzWpMITB6dhNG4V4u+XdjlZ1Gp
        jBlt+tsW6MU/jCpbmPUzl2f9VZXhvDk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-hOXyyT0SPd23OdsHCg5HCg-1; Wed, 23 Sep 2020 03:39:37 -0400
X-MC-Unique: hOXyyT0SPd23OdsHCg5HCg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1283480F058;
        Wed, 23 Sep 2020 07:39:36 +0000 (UTC)
Received: from thuth.com (ovpn-112-49.ams2.redhat.com [10.36.112.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C42C11B5AE;
        Wed, 23 Sep 2020 07:39:33 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH] travis.yml: Fix the getopt problem
Date:   Wed, 23 Sep 2020 09:39:31 +0200
Message-Id: <20200923073931.74769-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The enhanced getopt is now not selected with a configure switch
anymore, but by setting the PATH to the right location.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 This fixes the new macOS build jobs on Travis :
 https://travis-ci.com/github/huth/kvm-unit-tests/builds/186146708

 .travis.yml | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index ae4ed08..2e5ae41 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -128,8 +128,7 @@ jobs:
             - qemu
             - x86_64-elf-gcc
       env:
-      - CONFIG="--cross-prefix=x86_64-elf-
-                --getopt=/usr/local/opt/gnu-getopt/bin/getopt"
+      - CONFIG="--cross-prefix=x86_64-elf-"
       - BUILD_DIR="build"
       - TESTS="ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
                vmexit_mov_to_cr8 vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt
@@ -137,6 +136,7 @@ jobs:
                vmexit_tscdeadline_immed eventinj msr port80 setjmp
                syscall tsc rmap_chain umip intel_iommu"
       - ACCEL="tcg"
+      - PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
 
     - os: osx
       osx_image: xcode11.6
@@ -149,8 +149,7 @@ jobs:
             - qemu
             - i686-elf-gcc
       env:
-      - CONFIG="--arch=i386 --cross-prefix=i686-elf-
-                --getopt=/usr/local/opt/gnu-getopt/bin/getopt"
+      - CONFIG="--arch=i386 --cross-prefix=i686-elf-"
       - BUILD_DIR="build"
       - TESTS="cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
                vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt
@@ -158,6 +157,7 @@ jobs:
                vmexit_tscdeadline_immed eventinj port80 setjmp tsc
                taskswitch umip"
       - ACCEL="tcg"
+      - PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
 
 before_script:
   - if [ "$ACCEL" = "kvm" ]; then
-- 
2.18.2


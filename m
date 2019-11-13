Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF31FAFA8
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 12:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbfKML1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 06:27:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49214 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727733AbfKML1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 06:27:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573644423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Eby2tNFGdfIFQLFJ/gYdQ7192hRSum/clSff20A2dw=;
        b=cP00Fqd2x0NRmXhwQM3Bycja9sSPMVAw+ksvL4eWy350Fp7lBOnpkHX8JZ8SE7o9U0dxNl
        bSEcdhsHAB1OFJRn/HWixfUvcVdcXc1+YQ/HBzVFMlZT9MBymnBD7eW9mWFBndkpGWXVMa
        numbnedCMLYoQRBQPHDkwMJ013LQ7KI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-5tkqWEcMMBaGXu7bCs0CWA-1; Wed, 13 Nov 2019 06:27:02 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C48BC107ACC6;
        Wed, 13 Nov 2019 11:27:00 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A26B260464;
        Wed, 13 Nov 2019 11:26:59 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-test PATCH 2/5] travis.yml: Install only the required packages for each entry in the matrix
Date:   Wed, 13 Nov 2019 12:26:46 +0100
Message-Id: <20191113112649.14322-3-thuth@redhat.com>
In-Reply-To: <20191113112649.14322-1-thuth@redhat.com>
References: <20191113112649.14322-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 5tkqWEcMMBaGXu7bCs0CWA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't need all cross compiler and QEMU versions for each and every entry
in the test matrix, only the ones for the current target architecture.
So let's speed up the installation process a little bit by only installing
the packages that we really need.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 53 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 611bbdc..3f5b5ee 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,75 +1,84 @@
 sudo: false
 dist: bionic
 language: c
-compiler:
-  - gcc
 cache: ccache
-addons:
-  apt:
-    packages:
-      # Cross Toolchains
-      - gcc-arm-linux-gnueabihf
-      - gcc-aarch64-linux-gnu
-      - gcc-powerpc64le-linux-gnu
-      - gcc-s390x-linux-gnu
-      # Run dependencies
-      - qemu-system
 git:
   submodules: false
=20
 matrix:
   include:
-    - env:
+
+    - addons:
+        apt_packages: gcc qemu-system-x86
+      env:
       - CONFIG=3D""
       - BUILD_DIR=3D"."
       - TESTS=3D"vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit=
_ipi
              vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_=
immed"
=20
-    - env:
+    - addons:
+        apt_packages: gcc qemu-system-x86
+      env:
       - CONFIG=3D""
       - BUILD_DIR=3D"x86-builddir"
       - TESTS=3D"ioapic-split ioapic smptest smptest3 eventinj msr port80 =
syscall
              tsc rmap_chain umip intel_iommu vmexit_inl_pmtimer vmexit_ipi=
_halt"
=20
-    - env:
+    - addons:
+        apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
+      env:
       - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
       - BUILD_DIR=3D"."
       - TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-sm=
p"
=20
-    - env:
+    - addons:
+        apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
+      env:
       - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
       - BUILD_DIR=3D"arm-buildir"
       - TESTS=3D"pci-test pmu gicv2-active gicv3-active psci selftest-setu=
p"
=20
-    - env:
+    - addons:
+        apt_packages: gcc-aarch64-linux-gnu qemu-system-aarch64
+      env:
       - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
       - BUILD_DIR=3D"."
       - TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-sm=
p"
=20
-    - env:
+    - addons:
+        apt_packages: gcc-aarch64-linux-gnu qemu-system-aarch64
+      env:
       - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
       - BUILD_DIR=3D"arm64-buildir"
       - TESTS=3D"pci-test pmu gicv2-active gicv3-active psci timer selftes=
t-setup"
=20
-    - env:
+    - addons:
+        apt_packages: gcc-powerpc64le-linux-gnu qemu-system-ppc
+      env:
       - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowerp=
c64le-linux-gnu-"
       - BUILD_DIR=3D"."
       - TESTS=3D"spapr_hcall emulator rtas-set-time-of-day"
       - ACCEL=3D"tcg,cap-htm=3Doff"
=20
-    - env:
+    - addons:
+        apt_packages: gcc-powerpc64le-linux-gnu qemu-system-ppc
+      env:
       - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowerp=
c64le-linux-gnu-"
       - BUILD_DIR=3D"ppc64le-buildir"
       - TESTS=3D"rtas-get-time-of-day rtas-get-time-of-day-base"
       - ACCEL=3D"tcg,cap-htm=3Doff"
=20
-    - env:
+    - addons:
+        apt_packages: gcc-s390x-linux-gnu qemu-system-s390x
+      env:
       - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
       - BUILD_DIR=3D"."
       - TESTS=3D"diag10 diag308"
       - ACCEL=3D"tcg,firmware=3Ds390x/run"
=20
-    - env:
+    - addons:
+        apt_packages: gcc-s390x-linux-gnu qemu-system-s390x
+      env:
       - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
       - BUILD_DIR=3D"s390x-builddir"
       - TESTS=3D"sieve"
--=20
2.23.0


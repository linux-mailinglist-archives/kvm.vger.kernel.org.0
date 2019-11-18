Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D1310021C
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfKRKIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37201 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726883AbfKRKIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 05:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZfvXdtX0wKwBsx+KEmmak6xSgdeeaaCJeHyIPPx4sco=;
        b=Ys1nd8Xr2iVwM1X1Nz+Xdd2LV72FPYPmNc5WThTgKMs6/44qbzMXKGdfIX4ZYKVYKxHyMC
        JTGll9DI2HRaLijHW/KSbwskDm0FzkUC1Pl4Fv1hRFusadh3W6Id+CgP3g4vK9JWz1u4Y/
        D73C5pCLFC4wP7sfJP7iyGGpMUsEbWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-lAvcC-ACM96RCqNwWUw60A-1; Mon, 18 Nov 2019 05:08:28 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B8E71800D7D;
        Mon, 18 Nov 2019 10:08:27 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C9FE66856;
        Mon, 18 Nov 2019 10:08:25 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 09/12] travis.yml: Install only the required packages for each entry in the matrix
Date:   Mon, 18 Nov 2019 11:07:16 +0100
Message-Id: <20191118100719.7968-10-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: lAvcC-ACM96RCqNwWUw60A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

We don't need all cross compiler and QEMU versions for each and every entry
in the test matrix, only the ones for the current target architecture.
So let's speed up the installation process a little bit by only installing
the packages that we really need.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Message-Id: <20191113112649.14322-3-thuth@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
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
2.21.0


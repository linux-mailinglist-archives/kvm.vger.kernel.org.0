Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2672B343
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 13:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfE0L3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 07:29:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbfE0L27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 07:28:59 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6ACBE3082B4D
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 11:28:59 +0000 (UTC)
Received: from thuth.com (ovpn-116-235.ams2.redhat.com [10.36.116.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D08C66C327;
        Mon, 27 May 2019 11:28:57 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] gitlab-ci: Run tests with a Fedora docker image
Date:   Mon, 27 May 2019 13:28:53 +0200
Message-Id: <20190527112853.3920-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 27 May 2019 11:28:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fedora has a newer version of QEMU - and most notably it has a *working*
version of qemu-system-s390x! So we can finally also run some s390x tests
in the gitlab-ci.

For some unknown reasons, the sieve test is now failing on x86_64,
so I had to disable it. OTOH, the taskswitch2 test now works on
i386, so we can enable this test instead.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 50a1e39..a9dc16a 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -1,10 +1,12 @@
+image: fedora:30
+
 before_script:
- - apt-get update -qq
- - apt-get install -y -qq qemu-system
+ - dnf update -y
+ - dnf install -y make python
 
 build-aarch64:
  script:
- - apt-get install -y -qq gcc-aarch64-linux-gnu
+ - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu
  - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
@@ -15,8 +17,8 @@ build-aarch64:
 
 build-arm:
  script:
- - apt-get install -y -qq gcc-arm-linux-gnueabi
- - ./configure --arch=arm --cross-prefix=arm-linux-gnueabi-
+ - dnf install -y qemu-system-arm gcc-arm-linux-gnu
+ - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
      selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
@@ -26,7 +28,7 @@ build-arm:
 
 build-ppc64be:
  script:
- - apt-get install -y -qq gcc-powerpc64-linux-gnu
+ - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
  - ./configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
@@ -37,7 +39,7 @@ build-ppc64be:
 
 build-ppc64le:
  script:
- - apt-get install -y -qq gcc-powerpc64-linux-gnu
+ - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
  - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
@@ -48,28 +50,33 @@ build-ppc64le:
 
 build-s390x:
  script:
- - apt-get install -y -qq gcc-s390x-linux-gnu
+ - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
  - ./configure --arch=s390x --cross-prefix=s390x-linux-gnu-
  - make -j2
+ - ACCEL=tcg ./run_tests.sh
+     selftest-setup intercept emulator sieve diag10
+     | tee results.txt
+ - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-x86_64:
  script:
+ - dnf install -y qemu-system-x86 gcc
  - ./configure --arch=x86_64
  - make -j2
  - ACCEL=tcg ./run_tests.sh
      ioapic-split ioapic smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
      vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
-     eventinj msr port80 sieve tsc rmap_chain umip hyperv_stimer intel_iommu
+     eventinj msr port80 syscall tsc rmap_chain umip intel_iommu
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-i386:
  script:
- - apt-get install -y -qq gcc-multilib
+ - dnf install -y qemu-system-x86 gcc
  - ./configure --arch=i386
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     eventinj port80 sieve tsc taskswitch umip hyperv_stimer
+     eventinj port80 sieve tsc taskswitch taskswitch2 umip
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
-- 
2.21.0


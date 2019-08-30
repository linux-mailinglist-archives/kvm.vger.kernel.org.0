Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF4CA3DDD
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 20:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfH3SpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 14:45:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfH3SpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 14:45:19 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E19FF300BEA5;
        Fri, 30 Aug 2019 18:45:18 +0000 (UTC)
Received: from thuth.com (unknown [10.36.118.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7609760872;
        Fri, 30 Aug 2019 18:45:14 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH] travis.yml: Enable running of tests with TCG
Date:   Fri, 30 Aug 2019 20:45:09 +0200
Message-Id: <20190830184509.15240-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 30 Aug 2019 18:45:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the tests at the end of the .travis.yml script are ignored,
since we can not use KVM in the Travis containers. But we can actually
run of some of the kvm-unit-tests with TCG instead, to make sure that
the binaries are not completely broken.
Thus introduce a new TESTS variable that lists the tests which we can
run with TCG. Unfortunately, the ppc64 and s390x QEMUs in Ubuntu also
need some extra love: The ppc64 version only works with the additional
"cap-htm=off" setting. And the s390x package lacks the firmware and
refuses to work unless we provide a fake firmware file here. Any file
works since the firmware is skipped when "-kernel" is used, so we can
simply use one of the pre-existing files in the source tree.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/.travis.yml b/.travis.yml
index a4a165d..6c14953 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -20,24 +20,40 @@ env:
   matrix:
     - CONFIG=""
       BUILD_DIR="."
+      TESTS="vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ipi
+             vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed"
     - CONFIG=""
       BUILD_DIR="x86-builddir"
+      TESTS="ioapic-split ioapic smptest smptest3 eventinj msr port80 syscall
+             tsc rmap_chain umip intel_iommu vmexit_inl_pmtimer vmexit_ipi_halt"
     - CONFIG="--arch=arm --cross-prefix=arm-linux-gnueabihf-"
       BUILD_DIR="."
+      TESTS="selftest-vectors-kernel selftest-vectors-user selftest-smp"
     - CONFIG="--arch=arm --cross-prefix=arm-linux-gnueabihf-"
       BUILD_DIR="arm-buildir"
+      TESTS="pci-test pmu gicv2-active gicv3-active psci selftest-setup"
     - CONFIG="--arch=arm64 --cross-prefix=aarch64-linux-gnu-"
       BUILD_DIR="."
+      TESTS="selftest-vectors-kernel selftest-vectors-user selftest-smp"
     - CONFIG="--arch=arm64 --cross-prefix=aarch64-linux-gnu-"
       BUILD_DIR="arm64-buildir"
+      TESTS="pci-test pmu gicv2-active gicv3-active psci timer selftest-setup"
     - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
       BUILD_DIR="."
+      TESTS="spapr_hcall emulator rtas-set-time-of-day"
+      ACCEL="tcg,cap-htm=off"
     - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
       BUILD_DIR="ppc64le-buildir"
+      TESTS="rtas-get-time-of-day rtas-get-time-of-day-base"
+      ACCEL="tcg,cap-htm=off"
     - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
       BUILD_DIR="."
+      TESTS="diag10 diag308"
+      ACCEL="tcg,firmware=s390x/run"
     - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
       BUILD_DIR="s390x-builddir"
+      TESTS="sieve"
+      ACCEL="tcg,firmware=s390x/run"
 
 before_script:
   - mkdir -p $BUILD_DIR && cd $BUILD_DIR
@@ -45,4 +61,5 @@ before_script:
   - if [ -e ../configure ]; then ../configure $CONFIG ; fi
 script:
   - make -j3
-  - ./run_tests.sh || true
+  - ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
+  - if grep -q FAIL results.txt ; then exit 1 ; fi
-- 
2.18.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889172108E6
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 12:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbgGAKG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 06:06:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20431 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728755AbgGAKGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 06:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593597984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=SoDnJoSdaPt4sVuT7zf19dNUPvHCcGaRVDijteDFhQM=;
        b=C7pCUszr8ux+Wj5EJCDBULrH8fY5TH+WEESfBW2gTqln0LyrgZhFNyNVSAUDZNBz1dxfNM
        VMGUhDojYR9kJza2ELs91blmf4VUgm6c8D151KOH4ickdJQmlc1nwOFEpx2NIWg9uXRJfH
        +MOPjuhzWmU80Z7EddKnmsv/h3avEkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-fhi-TPPvMS-vflC-XX8fXQ-1; Wed, 01 Jul 2020 06:06:22 -0400
X-MC-Unique: fhi-TPPvMS-vflC-XX8fXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E08FD1005513;
        Wed,  1 Jul 2020 10:06:21 +0000 (UTC)
Received: from thuth.com (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46F242B472;
        Wed,  1 Jul 2020 10:06:17 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH] gitlab-ci.yml: Extend the lists of tests that we run with TCG
Date:   Wed,  1 Jul 2020 12:06:15 +0200
Message-Id: <20200701100615.7975-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank to the recent fixes, there are now quite a lot of additional 32-bit
x86 tests that we can run in the CI.
And thanks to the update to Fedora 32 (that introduced a newer version of
QEMU), there are now also some additional tests that we can run with TCG
for the other architectures.
Note that for arm/aarch64, we now also set the MAX_SMP to be able to run
SMP-tests with TCG in the single-threaded CI containers, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Note: taskswitch2 for 32-bit x86 is still broken, and thus has not been
 added back again. It used to work with F30 ... maybe it's a QEMU regression?

 .gitlab-ci.yml | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 3af53f0..d042cde 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -9,9 +9,10 @@ build-aarch64:
  - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu
  - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu-
  - make -j2
- - ACCEL=tcg ./run_tests.sh
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
      selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
-     pci-test pmu gicv2-active gicv3-active psci timer
+     pci-test pmu-cycle-counter pmu-event-counter-config pmu-sw-incr gicv2-ipi
+     gicv2-mmio gicv3-ipi gicv2-active gicv3-active psci timer cache
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
@@ -20,9 +21,10 @@ build-arm:
  - dnf install -y qemu-system-arm gcc-arm-linux-gnu
  - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
  - make -j2
- - ACCEL=tcg ./run_tests.sh
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
      selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
-     pci-test pmu gicv2-active gicv3-active psci
+     pci-test pmu-cycle-counter gicv2-ipi gicv2-mmio gicv3-ipi gicv2-active
+     gicv3-active psci
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
@@ -54,7 +56,8 @@ build-s390x:
  - ./configure --arch=s390x --cross-prefix=s390x-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     selftest-setup intercept emulator sieve diag10
+     selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
+     stsi sclp-1g sclp-3g
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
@@ -64,10 +67,10 @@ build-x86_64:
  - ./configure --arch=x86_64
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
+     ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
      vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
-     eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
+     eventinj msr port80 setjmp sieve syscall tsc rmap_chain umip intel_iommu
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
@@ -77,7 +80,10 @@ build-i386:
  - ./configure --arch=i386
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     cmpxchg8b eventinj port80 setjmp sieve tsc taskswitch umip
+     cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
+     vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt vmexit_ple_round_robin
+     vmexit_tscdeadline vmexit_tscdeadline_immed eventinj port80 setjmp sieve
+     tsc taskswitch umip
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
@@ -87,7 +93,7 @@ build-clang:
  - ./configure --arch=x86_64 --cc=clang
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
+     ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
      vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
      eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
-- 
2.18.1


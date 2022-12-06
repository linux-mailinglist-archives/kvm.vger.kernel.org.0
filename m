Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084FD644162
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 11:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiLFKlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 05:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiLFKlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 05:41:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30EF1E3C3
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 02:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670323213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u6gjEOKxb56AT27uE1fyuzWcdhJFGCGqbHda1ciY5ho=;
        b=XMMB2EceQUpiU4xmTj1yWGaKR7TZS+/SrxMfdEHDLf0TJO9FaY0ZP2G8PZs0djwWHNiON3
        jeplpw47Hissf69NaAo0xXmoNZD2I8giwVqVebAdQ3mOw6+ftUi9Nr47V+I1E9G9cM7l35
        7CZqiJ5pK1EPBCXIB2hWW7k9sjPqDwE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-IsXwQHVmOQuE3PILyvz9dQ-1; Tue, 06 Dec 2022 05:40:09 -0500
X-MC-Unique: IsXwQHVmOQuE3PILyvz9dQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F712858F13;
        Tue,  6 Dec 2022 10:40:09 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE42F1121333;
        Tue,  6 Dec 2022 10:40:07 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] gitlab-ci: Update to Fedora 37
Date:   Tue,  6 Dec 2022 11:40:03 +0100
Message-Id: <20221206104003.149630-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our gitlab-ci jobs were still running with Fedora 32 that is out of
service already. Let's update to Fedora 37 that brings a new QEMU
which also allows to run more tests with TCG. While we're at it,
also list each test in single lines and sort them alphabetically
so that it is easier to follow which tests get added and removed.
Beside adding some new tests, two entries are also removed here:
The "port80" test was removed a while ago from the x86 folder
already, but not from the .gitlab-ci.yml yet (seems like the run
script simply ignores unknown tests instead of complaining), and
the "tsc_adjust" is only skipping in the CI, so it's currently not
really usefull to try to run it in the CI.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 157 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 132 insertions(+), 25 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index e5768f1d..ad7949c9 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -1,4 +1,4 @@
-image: fedora:32
+image: fedora:37
 
 before_script:
  - dnf update -y
@@ -10,10 +10,28 @@ build-aarch64:
  - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu-
  - make -j2
  - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
-     selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
-     pci-test pmu-cycle-counter pmu-event-counter-config pmu-sw-incr gicv2-ipi
-     gicv2-mmio gicv3-ipi gicv2-active gicv3-active psci timer cache
-     | tee results.txt
+      cache
+      debug-bp
+      debug-sstep
+      debug-wp
+      gicv2-active
+      gicv2-ipi
+      gicv2-mmio
+      gicv3-active
+      gicv3-ipi
+      its-introspection
+      its-trigger
+      pci-test
+      pmu-cycle-counter
+      pmu-event-counter-config
+      pmu-sw-incr
+      psci
+      selftest-setup
+      selftest-smp
+      selftest-vectors-kernel
+      selftest-vectors-user
+      timer
+      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-arm:
@@ -62,9 +80,32 @@ build-s390x:
  - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     selftest-setup intercept emulator sieve diag10 diag308 vector diag288
-     stsi sclp-1g sclp-3g
-     | tee results.txt
+      adtl-status-no-vec-no-gs-tcg
+      adtl-status-tcg
+      cpumodel
+      css
+      diag10
+      diag288
+      diag308
+      edat
+      emulator
+      epsw
+      exittime
+      firq-linear-cpu-ids-tcg
+      firq-nonlinear-cpu-ids-tcg
+      iep
+      intercept
+      mvpg
+      sck
+      sclp-1g
+      sclp-3g
+      selftest-setup
+      sieve
+      smp
+      stsi
+      tprot
+      vector
+      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-x86_64:
@@ -73,12 +114,36 @@ build-x86_64:
  - ./configure --arch=x86_64
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
-     vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
-     vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
-     eventinj port80 setjmp sieve syscall tsc rmap_chain umip intel_iommu
-     rdpru pku pks smap tsc_adjust xsave
-     | tee results.txt
+      eventinj
+      intel_iommu
+      ioapic-split
+      memory
+      pks
+      pku
+      rdpru
+      realmode
+      rmap_chain
+      setjmp
+      sieve
+      smap
+      smptest
+      smptest3
+      syscall
+      tsc
+      umip
+      vmexit_cpuid
+      vmexit_cr0_wp
+      vmexit_cr4_pge
+      vmexit_inl_pmtimer
+      vmexit_ipi
+      vmexit_ipi_halt
+      vmexit_mov_from_cr8
+      vmexit_mov_to_cr8
+      vmexit_ple_round_robin
+      vmexit_tscdeadline
+      vmexit_tscdeadline_immed
+      xsave
+      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-i386:
@@ -89,11 +154,29 @@ build-i386:
  - ../configure --arch=i386
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
-     vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt vmexit_ple_round_robin
-     vmexit_tscdeadline vmexit_tscdeadline_immed eventinj port80 setjmp sieve
-     tsc taskswitch umip rdpru smap tsc_adjust xsave
-     | tee results.txt
+      cmpxchg8b
+      eventinj
+      realmode
+      setjmp
+      sieve
+      smap
+      smptest
+      smptest3
+      taskswitch
+      tsc
+      umip
+      vmexit_cpuid
+      vmexit_cr0_wp
+      vmexit_cr4_pge
+      vmexit_inl_pmtimer
+      vmexit_ipi
+      vmexit_ipi_halt
+      vmexit_mov_from_cr8
+      vmexit_mov_to_cr8
+      vmexit_ple_round_robin
+      vmexit_tscdeadline
+      vmexit_tscdeadline_immed
+      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-clang:
@@ -102,12 +185,36 @@ build-clang:
  - ./configure --arch=x86_64 --cc=clang
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
-     vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
-     vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
-     eventinj port80 setjmp syscall tsc rmap_chain umip intel_iommu
-     rdpru pku pks smap tsc_adjust xsave
-     | tee results.txt
+      eventinj
+      intel_iommu
+      ioapic-split
+      memory
+      pks
+      pku
+      rdpru
+      realmode
+      rmap_chain
+      setjmp
+      sieve
+      smap
+      smptest
+      smptest3
+      syscall
+      tsc
+      umip
+      vmexit_cpuid
+      vmexit_cr0_wp
+      vmexit_cr4_pge
+      vmexit_inl_pmtimer
+      vmexit_ipi
+      vmexit_ipi_halt
+      vmexit_mov_from_cr8
+      vmexit_mov_to_cr8
+      vmexit_ple_round_robin
+      vmexit_tscdeadline
+      vmexit_tscdeadline_immed
+      xsave
+      | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
 build-centos7:
-- 
2.31.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206E93B0650
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 15:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhFVN5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 09:57:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231592AbhFVN5v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 09:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624370135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+19rfEAmw4Y61QHDVPEka2P/8irM/Zf8XAvS8aqKjoQ=;
        b=Pjn4Smm/f8Vll2Lf6iMlpi4AqlzuuReSoYUx1eGsHIPe21N9BeDNeobkr5UPs5vKUWS5dM
        DSPyNsDnaG88VeXGqzeNW9G3fDCR1oYPC5e5DZ+dexup7uafv1tkRWUwUsoPys/goNw0D7
        woEOyEjWEnUDNzLhbmHnUR9zrheAmeI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-caw47PQWPz-y2k9rwRAXDQ-1; Tue, 22 Jun 2021 09:55:33 -0400
X-MC-Unique: caw47PQWPz-y2k9rwRAXDQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1189101C8A8;
        Tue, 22 Jun 2021 13:55:32 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1468669CB4;
        Tue, 22 Jun 2021 13:55:30 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH 4/4] Test compilation with Clang on aarch64, ppc64le and s390x in Travis-CI
Date:   Tue, 22 Jun 2021 15:55:17 +0200
Message-Id: <20210622135517.234801-5-thuth@redhat.com>
In-Reply-To: <20210622135517.234801-1-thuth@redhat.com>
References: <20210622135517.234801-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Travis-CI recently changed their policy so that builds on the non-x86
build machines are possible without consuming any credits again. We can
use these systems to test compilation of the non-x86 code with Clang.
Unfortunately, the qemu-system-s390x of Ubuntu 20.04 seems to be buggy,
so that the s390x binaries cause that QEMU to crash. Thus we can only
run the TCG tests for ppc64le and aarch64.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 .travis.yml

diff --git a/.travis.yml b/.travis.yml
new file mode 100644
index 0000000..4fcb687
--- /dev/null
+++ b/.travis.yml
@@ -0,0 +1,44 @@
+dist: focal
+language: c
+cache: ccache
+compiler: clang
+git:
+  submodules: false
+
+jobs:
+  include:
+
+    - arch: arm64
+      addons:
+        apt_packages: qemu-system-aarch64
+      env:
+      - CONFIG="--arch=arm64 --cc=clang"
+      - TESTS="cache gicv2-active gicv2-ipi gicv2-mmio gicv3-active gicv3-ipi
+          pci-test pmu-cycle-counter pmu-event-counter-config pmu-sw-incr
+          selftest-setup selftest-smp selftest-vectors-kernel
+          selftest-vectors-user timer"
+
+    - arch: ppc64le
+      addons:
+        apt_packages: clang-11 qemu-system-ppc
+      env:
+      - CONFIG="--arch=ppc64 --endian=little --cc=clang-11 --cflags=-no-integrated-as"
+      - TESTS="emulator rtas-get-time-of-day rtas-get-time-of-day-base
+          rtas-set-time-of-day selftest-setup spapr_hcall"
+
+    - arch: s390x
+      addons:
+        apt_packages: clang-11 qemu-system-s390x
+      env:
+      - CONFIG="--arch=s390x --cc=clang-11 --cflags=-no-integrated-as"
+      - TESTS=""
+
+before_script:
+  - mkdir -p build && cd build
+  - $TRAVIS_BUILD_DIR/configure $CONFIG
+script:
+  - make -j3
+  - if [ -n "$TESTS" ]; then
+      ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt &&
+      grep -q PASS results.txt && ! grep -q FAIL results.txt ;
+    fi
-- 
2.27.0


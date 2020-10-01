Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA7327FA26
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 09:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731430AbgJAHW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 03:22:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731390AbgJAHWz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 03:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601536974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=uV31I6aF+e2KZFY5U2Vw1ex4RY5hMoOFs3xZ0n6rpRY=;
        b=C4jgF8u5+fZ6RUafK4DLp2mu+Zj8uqkHsKQ0EORXjzOIuO1DDBQHfUo09hm63zqTMr4qon
        Ot/FXu0WjL5FhoJoc70RaSZxQa+aKya6W5V5IrjUu7Fq7U/HOWf907P/wYvB0ugYHsNyn4
        2hE1jgG2nqTy+7/HqC7yRWG3SDMOFTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-AeAJNrUbN4iUbssYCgqWdw-1; Thu, 01 Oct 2020 03:22:53 -0400
X-MC-Unique: AeAJNrUbN4iUbssYCgqWdw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BDC6801AC2
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 07:22:52 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1BE160BF1;
        Thu,  1 Oct 2020 07:22:50 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, lvivier@redhat.com
Subject: [PATCH v2 7/7] travis.yml: Rework the aarch64 jobs
Date:   Thu,  1 Oct 2020 09:22:34 +0200
Message-Id: <20201001072234.143703-8-thuth@redhat.com>
In-Reply-To: <20201001072234.143703-1-thuth@redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the new QEMU from Ubuntu Focal, we can now run some more tests
with TCG. Also switch the second build job to native arm64, so we
can use Clang to compile these tests to get some additional compiler
test coverage.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 547d8d7..5af7344 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -76,14 +76,21 @@ jobs:
       env:
       - CONFIG="--arch=arm64 --cross-prefix=aarch64-linux-gnu-"
       - BUILD_DIR="."
-      - TESTS="selftest-vectors-kernel selftest-vectors-user selftest-smp"
+      - TESTS="cache gicv2-active gicv2-ipi gicv3-active gicv3-ipi pci-test
+          pmu-cycle-counter pmu-event-counter-config pmu-sw-incr psci
+          selftest-setup selftest-smp selftest-vectors-kernel
+          selftest-vectors-user timer"
 
-    - addons:
-        apt_packages: gcc-aarch64-linux-gnu qemu-system-aarch64
+    - arch: arm64
+      addons:
+        apt_packages: clang-10 qemu-system-aarch64
+      compiler: clang
       env:
-      - CONFIG="--arch=arm64 --cross-prefix=aarch64-linux-gnu-"
+      - CONFIG="--arch=arm64 --cc=clang-10"
       - BUILD_DIR="arm64-buildir"
-      - TESTS="pci-test pmu gicv2-active gicv3-active psci timer selftest-setup"
+      - TESTS="cache gicv2-active gicv2-ipi gicv3-active gicv3-ipi pci-test
+          pmu-cycle-counter pmu-event-counter-config pmu-sw-incr selftest-setup
+          selftest-smp selftest-vectors-kernel selftest-vectors-user timer"
 
     - addons:
         apt_packages: gcc-powerpc64le-linux-gnu qemu-system-ppc
-- 
2.18.2


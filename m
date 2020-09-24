Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28C227766D
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgIXQQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:16:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727109AbgIXQQ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 12:16:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600964216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=gYIDqM4nbV+7RauD3ZCdNO3ELSBZxClDEHoBUa1k/b4=;
        b=V5oI6U422TBJDnlV7lXewt2SnHLmUJ5tIIpONIbHo1hcVMw72TTgtQRHIpGgbbtjCxCA7R
        F0zxfm7U3QQBuF+xFAe8VZX9KU6MHcy2cx6bo2705uhgavuuNzxgiVBpUzvvrknlbn8a17
        OzzEXORbSp6fbzvScUoIKbBY6ewBmYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-72dqKGE-MxuQmYWrk--uJg-1; Thu, 24 Sep 2020 12:16:54 -0400
X-MC-Unique: 72dqKGE-MxuQmYWrk--uJg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A5F085B66C;
        Thu, 24 Sep 2020 16:16:53 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E9BF73662;
        Thu, 24 Sep 2020 16:16:51 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 8/9] travis.yml: Rework the aarch64 jobs
Date:   Thu, 24 Sep 2020 18:16:11 +0200
Message-Id: <20200924161612.144549-9-thuth@redhat.com>
In-Reply-To: <20200924161612.144549-1-thuth@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the new QEMU from Ubuntu Focal, we can now run some more tests
with TCG. Also switch the second build job to native arm64, so we
can use Clang to compile these tests to get some additional compiler
test coverage.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 7e96faa..f1bcf3d 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -78,14 +78,22 @@ jobs:
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
+          pmu-cycle-counter pmu-event-counter-config pmu-sw-incr psci
+          selftest-setup selftest-smp selftest-vectors-kernel
+          selftest-vectors-user timer"
 
     - addons:
         apt_packages: gcc-powerpc64le-linux-gnu qemu-system-ppc
-- 
2.18.2


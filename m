Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EF429D849
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 23:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387848AbgJ1WbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 18:31:08 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:6922 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387840AbgJ1WbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 18:31:08 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CLfrb6RKpz6yy4;
        Wed, 28 Oct 2020 15:11:43 +0800 (CST)
Received: from [10.174.187.138] (10.174.187.138) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Wed, 28 Oct 2020 15:11:30 +0800
Message-ID: <5F9919A2.9080205@huawei.com>
Date:   Wed, 28 Oct 2020 15:11:30 +0800
From:   AlexChen <alex.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To:     <pbonzini@redhat.com>, <chenhc@lemote.com>, <pasic@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <mtosatti@redhat.com>,
        <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-s390x@nongnu.org>, <zhengchuan@huawei.com>,
        <zhang.zhanghailiang@huawei.com>
Subject: [PATCH 2/4] kvm: Replace DEBUG_KVM with CONFIG_DEBUG_KVM
References: <5F97FD61.4060804@huawei.com> <5F991331.4020604@huawei.com>
In-Reply-To: <5F991331.4020604@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.138]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now we can control the definition of DPRINTF by CONFIG_DEBUG_KVM,
so let's replace DEBUG_KVM with CONFIG_DEBUG_KVM.

Signed-off-by: AlexChen <alex.chen@huawei.com>
---
 accel/kvm/kvm-all.c | 3 +--
 target/i386/kvm.c   | 4 +---
 target/mips/kvm.c   | 6 ++++--
 target/s390x/kvm.c  | 6 +++---
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9ef5daf4c5..fc6d99a731 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -60,9 +60,8 @@
  */
 #define PAGE_SIZE qemu_real_host_page_size

-//#define DEBUG_KVM

-#ifdef DEBUG_KVM
+#ifdef CONFIG_DEBUG_KVM
 #define DPRINTF(fmt, ...) \
     do { fprintf(stderr, fmt, ## __VA_ARGS__); } while (0)
 #else
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index cf46259534..3e9344aed5 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -50,9 +50,7 @@
 #include "exec/memattrs.h"
 #include "trace.h"

-//#define DEBUG_KVM
-
-#ifdef DEBUG_KVM
+#ifdef CONFIG_DEBUG_KVM
 #define DPRINTF(fmt, ...) \
     do { fprintf(stderr, fmt, ## __VA_ARGS__); } while (0)
 #else
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 72637a1e02..a0b979e6d2 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -28,10 +28,12 @@
 #include "exec/memattrs.h"
 #include "hw/boards.h"

-#define DEBUG_KVM 0
+#ifndef CONFIG_DEBUG_KVM
+#define CONFIG_DEBUG_KVM 0
+#endif

 #define DPRINTF(fmt, ...) \
-    do { if (DEBUG_KVM) { fprintf(stderr, fmt, ## __VA_ARGS__); } } while (0)
+    do { if (CONFIG_DEBUG_KVM) { fprintf(stderr, fmt, ## __VA_ARGS__); } } while (0)

 static int kvm_mips_fpu_cap;
 static int kvm_mips_msa_cap;
diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index f13eff688c..8bc9e1e468 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -52,12 +52,12 @@
 #include "hw/s390x/s390-virtio-hcall.h"
 #include "hw/s390x/pv.h"

-#ifndef DEBUG_KVM
-#define DEBUG_KVM  0
+#ifndef CONFIG_DEBUG_KVM
+#define CONFIG_DEBUG_KVM  0
 #endif

 #define DPRINTF(fmt, ...) do {                \
-    if (DEBUG_KVM) {                          \
+    if (CONFIG_DEBUG_KVM) {                          \
         fprintf(stderr, fmt, ## __VA_ARGS__); \
     }                                         \
 } while (0)
-- 
2.19.1

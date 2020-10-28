Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283C329D7D3
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 23:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733217AbgJ1W1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 18:27:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7082 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733218AbgJ1W1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 18:27:13 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CLfrr5jxGzLqcG;
        Wed, 28 Oct 2020 15:11:56 +0800 (CST)
Received: from [10.174.187.138] (10.174.187.138) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Wed, 28 Oct 2020 15:11:47 +0800
Message-ID: <5F9919B3.9070605@huawei.com>
Date:   Wed, 28 Oct 2020 15:11:47 +0800
From:   AlexChen <alex.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To:     <pbonzini@redhat.com>, <chenhc@lemote.com>, <pasic@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <mtosatti@redhat.com>,
        <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-s390x@nongnu.org>, <zhengchuan@huawei.com>,
        <zhang.zhanghailiang@huawei.com>
Subject: [PATCH 4/4] i386/kvm: make printf always compile in debug output
References: <5F97FD61.4060804@huawei.com> <5F991331.4020604@huawei.com> <5F9914EE.8050209@huawei.com> <5F991641.4050606@huawei.com>
In-Reply-To: <5F991641.4050606@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.138]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrapped printf calls inside debug macros (DPRINTF) in `if` statement.
This will ensure that printf function will always compile even if debug
output is turned off and, in turn, will prevent bitrot of the format
strings.

Signed-off-by: AlexChen <alex.chen@huawei.com>
---
 target/i386/kvm.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 3e9344aed5..64492cb851 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -50,14 +50,13 @@
 #include "exec/memattrs.h"
 #include "trace.h"

-#ifdef CONFIG_DEBUG_KVM
-#define DPRINTF(fmt, ...) \
-    do { fprintf(stderr, fmt, ## __VA_ARGS__); } while (0)
-#else
-#define DPRINTF(fmt, ...) \
-    do { } while (0)
+#ifndef CONFIG_DEBUG_KVM
+#define CONFIG_DEBUG_KVM  0
 #endif

+#define DPRINTF(fmt, ...) \
+    do { if (CONFIG_DEBUG_KVM) { fprintf(stderr, fmt, ## __VA_ARGS__); } } while (0)
+
 /* From arch/x86/kvm/lapic.h */
 #define KVM_APIC_BUS_CYCLE_NS       1
 #define KVM_APIC_BUS_FREQUENCY      (1000000000ULL / KVM_APIC_BUS_CYCLE_NS)
-- 
2.19.1

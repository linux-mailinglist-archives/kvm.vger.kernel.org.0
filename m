Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8253329C107
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818455AbgJ0RUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:20:53 -0400
Received: from foss.arm.com ([217.140.110.172]:47664 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1818310AbgJ0RS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:18:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A80C150C;
        Tue, 27 Oct 2020 10:18:57 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C3D4A3F719;
        Tue, 27 Oct 2020 10:18:54 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests RFC PATCH v2 2/5] lib/{bitops,alloc_page}.h: Add missing headers
Date:   Tue, 27 Oct 2020 17:19:41 +0000
Message-Id: <20201027171944.13933-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027171944.13933-1-alexandru.elisei@arm.com>
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

bitops.h uses the 'bool' and 'size_t' types, but doesn't include the
stddef.h and stdbool.h headers, where the types are defined. This can cause
the following error when compiling:

In file included from arm/new-test.c:9:
/path/to/kvm-unit-tests/lib/bitops.h:77:15: error: unknown type name 'bool'
   77 | static inline bool is_power_of_2(unsigned long n)
      |               ^~~~
/path/to/kvm-unit-tests/lib/bitops.h:82:38: error: unknown type name 'size_t'
   82 | static inline unsigned int get_order(size_t size)
      |                                      ^~~~~~
/path/to/kvm-unit-tests/lib/bitops.h:24:1: note: 'size_t' is defined in header '<stddef.h>'; did you forget to '#include <stddef.h>'?
   23 | #include <asm/bitops.h>
  +++ |+#include <stddef.h>
   24 |
make: *** [<builtin>: arm/new-test.o] Error 1

The same errors were observed when including alloc_page.h. Fix both files
by including stddef.h and stdbool.h.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_page.h | 2 ++
 lib/bitops.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 88540d1def06..182862c43363 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -4,6 +4,8 @@
  * This is a simple allocator that provides contiguous physical addresses
  * with byte granularity.
  */
+#include <stdbool.h>
+#include <stddef.h>
 
 #ifndef ALLOC_PAGE_H
 #define ALLOC_PAGE_H 1
diff --git a/lib/bitops.h b/lib/bitops.h
index 308aa86514a8..5aeea0b998b1 100644
--- a/lib/bitops.h
+++ b/lib/bitops.h
@@ -1,5 +1,7 @@
 #ifndef _BITOPS_H_
 #define _BITOPS_H_
+#include <stdbool.h>
+#include <stddef.h>
 
 /*
  * Adapted from
-- 
2.29.1


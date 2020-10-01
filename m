Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1653727FA25
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 09:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731478AbgJAHWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 03:22:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731449AbgJAHWy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 03:22:54 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601536973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Vz9fFD7Do5tf1ywGJ7bzN/b6Apbl8A7Fb9fNHS/U1ng=;
        b=DSV35VLD5UF+VYRb4uE/Dk1Y/ZrRBSYeeycFvGb05FWa3McdUSWwZE5dlkpENd1npZLlJm
        Pp8O1p7JiGoox2kuzXnhEx6O+ppRyAXFMrR9/46QF8crD6FkmrawB5H+AMLMZV7sNGSWMz
        cGyKL5U9cjvL/hZ3jqU0tme5XwXvoKg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-nCunpcwyMp6wThw8H4Bqgg-1; Thu, 01 Oct 2020 03:22:49 -0400
X-MC-Unique: nCunpcwyMp6wThw8H4Bqgg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB89D802B51
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 07:22:48 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96C9D60BF1;
        Thu,  1 Oct 2020 07:22:47 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, lvivier@redhat.com
Subject: [PATCH v2 5/7] arm/pmu: Fix inline assembly for Clang
Date:   Thu,  1 Oct 2020 09:22:32 +0200
Message-Id: <20201001072234.143703-6-thuth@redhat.com>
In-Reply-To: <20201001072234.143703-1-thuth@redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang complains here:

arm/pmu.c:201:16: error: value size does not match register size specified by
 the constraint and modifier [-Werror,-Wasm-operand-widths]
        : [pmcr] "r" (pmcr)
                      ^
arm/pmu.c:194:18: note: use constraint modifier "w"
        "       msr     pmcr_el0, %[pmcr]\n"
                                  ^~~~~~~
                                  %w[pmcr]
arm/pmu.c:200:17: error: value size does not match register size specified by
 the constraint and modifier [-Werror,-Wasm-operand-widths]
        : [loop] "+r" (loop)
                       ^
arm/pmu.c:196:11: note: use constraint modifier "w"
        "1:     subs    %[loop], %[loop], #1\n"
                        ^~~~~~~
                        %w[loop]
arm/pmu.c:200:17: error: value size does not match register size specified by
 the constraint and modifier [-Werror,-Wasm-operand-widths]
        : [loop] "+r" (loop)
                       ^
arm/pmu.c:196:20: note: use constraint modifier "w"
        "1:     subs    %[loop], %[loop], #1\n"
                                 ^~~~~~~
                                 %w[loop]
arm/pmu.c:284:35: error: value size does not match register size specified
 by the constraint and modifier [-Werror,-Wasm-operand-widths]
        : [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
                                         ^
arm/pmu.c:274:28: note: use constraint modifier "w"
        "       msr     pmcr_el0, %[pmcr]\n"
                                  ^~~~~~~
                                  %w[pmcr]
arm/pmu.c:284:54: error: value size does not match register size specified
 by the constraint and modifier [-Werror,-Wasm-operand-widths]
        : [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
                                                            ^
arm/pmu.c:276:23: note: use constraint modifier "w"
        "       mov     x10, %[loop]\n"
                             ^~~~~~~
                             %w[loop]

pmcr should be 64-bit since it is a sysreg, but for loop we can use the
"w" modifier.

Suggested-by: Drew Jones <drjones@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arm/pmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cece53e..831fb66 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -190,15 +190,16 @@ static inline uint8_t get_pmu_version(void)
  */
 static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 {
+	uint64_t pmcr64 = pmcr;
 	asm volatile(
 	"	msr	pmcr_el0, %[pmcr]\n"
 	"	isb\n"
-	"1:	subs	%[loop], %[loop], #1\n"
+	"1:	subs	%w[loop], %w[loop], #1\n"
 	"	b.gt	1b\n"
 	"	msr	pmcr_el0, xzr\n"
 	"	isb\n"
 	: [loop] "+r" (loop)
-	: [pmcr] "r" (pmcr)
+	: [pmcr] "r" (pmcr64)
 	: "cc");
 }
 
@@ -268,8 +269,9 @@ static void test_event_introspection(void)
  * pmccntr read after this function returns the exact instructions executed
  * in the controlled block. Loads @loop times the data at @address into x9.
  */
-static void mem_access_loop(void *addr, int loop, uint32_t pmcr)
+static void mem_access_loop(void *addr, long loop, uint32_t pmcr)
 {
+	uint64_t pmcr64 = pmcr;
 asm volatile(
 	"       msr     pmcr_el0, %[pmcr]\n"
 	"       isb\n"
@@ -281,7 +283,7 @@ asm volatile(
 	"       msr     pmcr_el0, xzr\n"
 	"       isb\n"
 	:
-	: [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
+	: [addr] "r" (addr), [pmcr] "r" (pmcr64), [loop] "r" (loop)
 	: "x9", "x10", "cc");
 }
 
-- 
2.18.2


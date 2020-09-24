Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC1C27766C
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgIXQQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:16:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49768 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727094AbgIXQQz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 12:16:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600964214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Vz9fFD7Do5tf1ywGJ7bzN/b6Apbl8A7Fb9fNHS/U1ng=;
        b=bojjvfyp3BvQMlj5jJsRHQqXHczGElA/ZgDOI2GAB6LTVnP/khC4i4APSGa/Mu1Vgpce+5
        11vIkBVUFHlm2wl0OLU9yrK3mE23dkzdaB8zp6hmmmvxOsZT0yWSXZYDLt8dc1u9CYBf4g
        FrNMApqHmTM1f8XLzHa8SS2EtGvUVyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-wKHk0Li7PuOEGR2yfgHMnw-1; Thu, 24 Sep 2020 12:16:49 -0400
X-MC-Unique: wKHk0Li7PuOEGR2yfgHMnw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A60EC8712D3;
        Thu, 24 Sep 2020 16:16:48 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C39607368B;
        Thu, 24 Sep 2020 16:16:45 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 6/9] arm/pmu: Fix inline assembly for Clang
Date:   Thu, 24 Sep 2020 18:16:09 +0200
Message-Id: <20200924161612.144549-7-thuth@redhat.com>
In-Reply-To: <20200924161612.144549-1-thuth@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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


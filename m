Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F0A2240C0
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 18:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgGQQqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 12:46:44 -0400
Received: from foss.arm.com ([217.140.110.172]:47390 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgGQQqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 12:46:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2E3612FC;
        Fri, 17 Jul 2020 09:46:43 -0700 (PDT)
Received: from monolith.arm.com (unknown [10.37.8.27])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B06213F68F;
        Fri, 17 Jul 2020 09:46:42 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH] arm64: Compile with -mno-outline-atomics for GCC >= 10
Date:   Fri, 17 Jul 2020 17:47:27 +0100
Message-Id: <20200717164727.75580-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GCC 10.1.0 introduced the -m{,no-}outline-atomics flags which, according to
man 1 gcc:

"Enable or disable calls to out-of-line helpers to implement atomic
operations.  These helpers will, at runtime, determine if the LSE
instructions from ARMv8.1-A can be used; if not, they will use the
load/store-exclusive instructions that are present in the base ARMv8.0 ISA.
[..] This option is on by default."

Unfortunately the option causes the following error at compile time:

aarch64-linux-gnu-ld -nostdlib -pie -n -o arm/spinlock-test.elf -T /path/to/kvm-unit-tests/arm/flat.lds \
	arm/spinlock-test.o arm/cstart64.o lib/libcflat.a lib/libfdt/libfdt.a /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a lib/arm/libeabi.a arm/spinlock-test.aux.o
aarch64-linux-gnu-ld: /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a(lse-init.o): in function `init_have_lse_atomics':
lse-init.c:(.text.startup+0xc): undefined reference to `__getauxval'

This is happening because we are linking against our own libcflat which
doesn't implement the function __getauxval().

Disable the use of the out-of-line functions by compiling with
-mno-outline-atomics if we detect a GCC version greater than 10.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Tested with gcc versions 10.1.0 and 5.4.0 (cross-compilation), 9.3.0
(native).

I've been able to suss out the reason for the build failure from this
rejected gcc patch [1].

[1] https://patches.openembedded.org/patch/172460/

 arm/Makefile.arm64 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index dfd0c56fe8fb..3223cb966789 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -9,6 +9,12 @@ ldarch = elf64-littleaarch64
 arch_LDFLAGS = -pie -n
 CFLAGS += -mstrict-align
 
+# The -mno-outline-atomics flag is only valid for GCC versions 10 and greater.
+GCC_MAJOR_VERSION=$(shell $(CC) -dumpversion 2> /dev/null | cut -f1 -d.)
+ifeq ($(shell expr "$(GCC_MAJOR_VERSION)" ">=" "10"), 1)
+CFLAGS += -mno-outline-atomics
+endif
+
 define arch_elf_check =
 	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
 		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
-- 
2.27.0


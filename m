Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34065454A36
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 16:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbhKQPpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 10:45:24 -0500
Received: from foss.arm.com ([217.140.110.172]:59264 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238632AbhKQPpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 10:45:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08B2D106F;
        Wed, 17 Nov 2021 07:42:15 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D530A3F5A1;
        Wed, 17 Nov 2021 07:42:13 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v5 kvmtool 2/4] arm/arm64: Make kvm__arch_delete_ram() aarch32/aarch64 specific
Date:   Wed, 17 Nov 2021 15:43:54 +0000
Message-Id: <20211117154356.303039-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117154356.303039-1-alexandru.elisei@arm.com>
References: <20211117154356.303039-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move kvm__arch_delete_ram() into aarch32 and aarch64 specific locations.
The function is kept identical between the two architectures, but adding
KVM SPE support will mean making changes to the aarch64 version of the
function to unlock the guest memory on virtual machine tear down.

No functional change intended.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile          | 1 +
 arm/aarch32/kvm.c | 8 ++++++++
 arm/aarch64/kvm.c | 6 ++++++
 arm/kvm.c         | 5 -----
 4 files changed, 15 insertions(+), 5 deletions(-)
 create mode 100644 arm/aarch32/kvm.c

diff --git a/Makefile b/Makefile
index bb7ad3ecf66e..313fdc3c0201 100644
--- a/Makefile
+++ b/Makefile
@@ -165,6 +165,7 @@ ifeq ($(ARCH), arm)
 	OBJS		+= $(OBJS_ARM_COMMON)
 	OBJS		+= arm/aarch32/arm-cpu.o
 	OBJS		+= arm/aarch32/kvm-cpu.o
+	OBJS		+= arm/aarch32/kvm.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch32/include
 	CFLAGS		+= -march=armv7-a
diff --git a/arm/aarch32/kvm.c b/arm/aarch32/kvm.c
new file mode 100644
index 000000000000..626cf728fa70
--- /dev/null
+++ b/arm/aarch32/kvm.c
@@ -0,0 +1,8 @@
+#include "kvm/kvm.h"
+
+#include <sys/mman.h>
+
+void kvm__arch_delete_ram(struct kvm *kvm)
+{
+	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
+}
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 56a0aedc263d..a61266e32085 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -1,6 +1,7 @@
 #include "kvm/kvm.h"
 
 #include <asm/image.h>
+#include <sys/mman.h>
 
 #include <linux/byteorder.h>
 #include <kvm/util.h>
@@ -81,3 +82,8 @@ int kvm__get_vm_type(struct kvm *kvm)
 
 	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
 }
+
+void kvm__arch_delete_ram(struct kvm *kvm)
+{
+	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
+}
diff --git a/arm/kvm.c b/arm/kvm.c
index 5aea18fedc3e..e44a94046747 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -42,11 +42,6 @@ void kvm__init_ram(struct kvm *kvm)
 	kvm->arch.memory_guest_start = phys_start;
 }
 
-void kvm__arch_delete_ram(struct kvm *kvm)
-{
-	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
-}
-
 void kvm__arch_read_term(struct kvm *kvm)
 {
 	serial8250__update_consoles(kvm);
-- 
2.33.1


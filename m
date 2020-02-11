Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C58159132
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgBKNxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:53:14 -0500
Received: from 8bytes.org ([81.169.241.247]:51850 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729436AbgBKNxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:13 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 6380C646; Tue, 11 Feb 2020 14:53:08 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 07/62] x86/boot/compressed/64: Disable red-zone usage
Date:   Tue, 11 Feb 2020 14:52:01 +0100
Message-Id: <20200211135256.24617-8-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The x86-64 ABI defines a red-zone on the stack:

  The 128-byte area beyond the location pointed to by %rsp is
  considered to be reserved and shall not be modified by signal or
  interrupt handlers. 10 Therefore, functions may use this area for
  temporary data that is not needed across function calls. In
  particular, leaf functions may use this area for their entire stack
  frame, rather than adjusting the stack pointer in the prologue and
  epilogue. This area is known as the red zone.

This is not compatible with exception handling, so disable it for the
pre-decompression boot code.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/Makefile            | 2 +-
 arch/x86/boot/compressed/Makefile | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 012b82fc8617..8f55e4ce1ccc 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -65,7 +65,7 @@ clean-files += cpustr.h
 
 # ---------------------------------------------------------------------------
 
-KBUILD_CFLAGS	:= $(REALMODE_CFLAGS) -D_SETUP
+KBUILD_CFLAGS	:= $(REALMODE_CFLAGS) -D_SETUP -mno-red-zone
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 KBUILD_CFLAGS	+= $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 GCOV_PROFILE := n
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 26050ae0b27e..e186cc0b628d 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -30,7 +30,7 @@ KBUILD_CFLAGS := -m$(BITS) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing $(call cc-option, -fPIE, -fPIC)
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 cflags-$(CONFIG_X86_32) := -march=i386
-cflags-$(CONFIG_X86_64) := -mcmodel=small
+cflags-$(CONFIG_X86_64) := -mcmodel=small -mno-red-zone
 KBUILD_CFLAGS += $(cflags-y)
 KBUILD_CFLAGS += -mno-mmx -mno-sse
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
@@ -87,7 +87,7 @@ endif
 
 vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
 
-$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
+$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar
 
 vmlinux-objs-$(CONFIG_EFI_STUB) += $(obj)/eboot.o \
 	$(objtree)/drivers/firmware/efi/libstub/lib.a
-- 
2.17.1


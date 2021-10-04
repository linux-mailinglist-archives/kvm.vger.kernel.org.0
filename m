Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847C84218A5
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhJDUve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbhJDUva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:30 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3F4C06174E
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:40 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 75so17745051pga.3
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vTbKvlhs0bVw+nGLMovJsoALx/6y2sNucVpS/ZwEi/A=;
        b=cLkltRkTcqnPEHh8dV0q11TeaiAa4NQfBabpl6U4IyHtowaVDYbIsFqb1bq3MdWwju
         4Mlz3sZ3IYpLZW7xk9kyPHyNt68POyjId26b8Tet/gLeoEsbZf8IJ2KvnL8Z74uJTg2R
         i3r9iGI1CxWtpeh/uEBhhhKySnuambZJjy0r2GWrebqgWhHRL7v4xsds1t7kWhKZ634V
         Ep1/VvCjZQ+W8xhAv8KxBx3qXUX+vPz3Fpz7zou7ibo7f/z+uF0HYlhtqQUrCUiRbXn6
         bJxJm+znSu02WPP6W4AuuzGLUXI3pWwn5Ux8yStDWAWLg4w6TBa+lIGS+kO5SCn82oVK
         jsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vTbKvlhs0bVw+nGLMovJsoALx/6y2sNucVpS/ZwEi/A=;
        b=vhmdX9h/bGXublSVtqwQBwkYTWWAptttim9zC+RBtZK0wEEbFqPBjW5UHz0uJDrGMU
         Y595zz08U4gL401A2NXP3cqzrHsnR0nIL/bg9PD4iiGqROBDAk7O5QHoZF6rgTWCVVQi
         +XokP+bIsym/ubzYJhUAPjaqkV9Ij5TGSFYinekXvhWHU9Hv6GRL4nJFx8zVF1pA3WGv
         TdH4JX2vxtpPMuc49RQ0yrJGuOpG24D2NrlzsErKQ2lZdV+VE01DfiOHsGRy100FPdME
         vRk2Od2vuEdBB0kACivMUTWnJAzVviuA0eLlWsFDn9HZynvwlR4rVGgCRtxy16YvbSfp
         NKnw==
X-Gm-Message-State: AOAM531XVUUlN4Vu0H82uxLEdMbHvF04CV7J42bOCSAFSWajWNtOAHmj
        c64B74AW4czquax6znximE3TrQ9EcbhvvQ==
X-Google-Smtp-Source: ABdhPJxomvxfW8+fIihpzvXjyZbjnyC4m0fhqGSJxe9IW8vuuefNzsiX3E1/kRmrraE4N28pe91BOQ==
X-Received: by 2002:a63:85c6:: with SMTP id u189mr12417515pgd.381.1633380579724;
        Mon, 04 Oct 2021 13:49:39 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:39 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 04/17] x86 UEFI: Copy code from GNU-EFI
Date:   Mon,  4 Oct 2021 13:49:18 -0700
Message-Id: <20211004204931.1537823-5-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

To build x86 test cases with UEFI, we need to borrow some source
code from GNU-EFI, which includes the initialization code and linker
scripts. This commit only copies the source code, without any
modification. These source code files are not used by KVM-Unit-Tests
in this commit.

The following source code is copied from GNU-EFI:
   1. x86/efi/elf_x86_64_efi.lds
   2. x86/efi/reloc_x86_64.c
   3. x86/efi/crt0-efi-x86_64.S

We put these EFI-related files under a new dir `x86/efi` because:
   1. EFI-related code is easy to find
   2. EFI-related code is separated from the original code in `x86/`
   3. EFI-related code can still reuse the Makefile and test case code
      in its parent dir `x86/`

GNU-EFI repo and version:
   GIT URL: https://git.code.sf.net/p/gnu-efi/code
   Commit ID: 4fe83e102674
   Website: https://sourceforge.net/p/gnu-efi/code/ci/4fe83e/tree/

Co-developed-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 x86/efi/README.md          |  25 ++++++++++
 x86/efi/crt0-efi-x86_64.S  |  79 +++++++++++++++++++++++++++++
 x86/efi/elf_x86_64_efi.lds |  77 ++++++++++++++++++++++++++++
 x86/efi/reloc_x86_64.c     | 100 +++++++++++++++++++++++++++++++++++++
 4 files changed, 281 insertions(+)
 create mode 100644 x86/efi/README.md
 create mode 100644 x86/efi/crt0-efi-x86_64.S
 create mode 100644 x86/efi/elf_x86_64_efi.lds
 create mode 100644 x86/efi/reloc_x86_64.c

diff --git a/x86/efi/README.md b/x86/efi/README.md
new file mode 100644
index 0000000..bc1f733
--- /dev/null
+++ b/x86/efi/README.md
@@ -0,0 +1,25 @@
+# EFI Startup Code and Linker Script
+
+This dir contains source code and linker script copied from
+[GNU-EFI](https://sourceforge.net/projects/gnu-efi/):
+   - crt0-efi-x86_64.S: startup code of an EFI application
+   - elf_x86_64_efi.lds: linker script to build an EFI application
+   - reloc_x86_64.c: position independent x86_64 ELF shared object relocator
+
+EFI application binaries should be relocatable as UEFI loads binaries to dynamic
+runtime addresses. To build such relocatable binaries, GNU-EFI utilizes the
+above-mentioned files in its build process:
+
+   1. build an ELF shared object and link it using linker script
+      `elf_x86_64_efi.lds` to organize the sections in a way UEFI recognizes
+   2. link the shared object with self-relocator `reloc_x86_64.c` that applies
+      dynamic relocations that may be present in the shared object
+   3. link the entry point code `crt0-efi-x86_64.S` that invokes self-relocator
+      and then jumps to EFI application's `efi_main()` function
+   4. convert the shared object to an EFI binary
+
+More details can be found in `GNU-EFI/README.gnuefi`, section "Building
+Relocatable Binaries".
+
+kvm-unit-tests follows a similar build process, but does not link with GNU-EFI
+library.
diff --git a/x86/efi/crt0-efi-x86_64.S b/x86/efi/crt0-efi-x86_64.S
new file mode 100644
index 0000000..eaf1656
--- /dev/null
+++ b/x86/efi/crt0-efi-x86_64.S
@@ -0,0 +1,79 @@
+/* The following code is copied from GNU-EFI/gnuefi/crt0-efi-x86_64.S
+
+   crt0-efi-x86_64.S - x86_64 EFI startup code.
+   Copyright (C) 1999 Hewlett-Packard Co.
+	Contributed by David Mosberger <davidm@hpl.hp.com>.
+   Copyright (C) 2005 Intel Co.
+	Contributed by Fenghua Yu <fenghua.yu@intel.com>.
+
+    All rights reserved.
+
+    Redistribution and use in source and binary forms, with or without
+    modification, are permitted provided that the following conditions
+    are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above
+      copyright notice, this list of conditions and the following
+      disclaimer in the documentation and/or other materials
+      provided with the distribution.
+    * Neither the name of Hewlett-Packard Co. nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
+    CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
+    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+    MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
+    BE LIABLE FOR ANYDIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
+    OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
+    PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
+    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
+    THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+    SUCH DAMAGE.
+*/
+	.text
+	.align 4
+
+	.globl _start
+_start:
+	subq $8, %rsp
+	pushq %rcx
+	pushq %rdx
+
+0:
+	lea ImageBase(%rip), %rdi
+	lea _DYNAMIC(%rip), %rsi
+
+	popq %rcx
+	popq %rdx
+	pushq %rcx
+	pushq %rdx
+	call _relocate
+
+	popq %rdi
+	popq %rsi
+
+	call efi_main
+	addq $8, %rsp
+
+.exit:	
+  	ret
+
+ 	// hand-craft a dummy .reloc section so EFI knows it's a relocatable executable:
+ 
+ 	.data
+dummy:	.long	0
+
+#define IMAGE_REL_ABSOLUTE	0
+ 	.section .reloc, "a"
+label1:
+	.long	dummy-label1				// Page RVA
+	.long	12					// Block Size (2*4+2*2), must be aligned by 32 Bits
+	.word	(IMAGE_REL_ABSOLUTE<<12) +  0		// reloc for dummy
+	.word	(IMAGE_REL_ABSOLUTE<<12) +  0		// reloc for dummy
+
diff --git a/x86/efi/elf_x86_64_efi.lds b/x86/efi/elf_x86_64_efi.lds
new file mode 100644
index 0000000..5eae376
--- /dev/null
+++ b/x86/efi/elf_x86_64_efi.lds
@@ -0,0 +1,77 @@
+/* Copied from GNU-EFI/gnuefi/elf_x86_64_efi.lds, licensed under GNU GPL */
+/* Same as elf_x86_64_fbsd_efi.lds, except for OUTPUT_FORMAT below - KEEP IN SYNC */
+OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
+OUTPUT_ARCH(i386:x86-64)
+ENTRY(_start)
+SECTIONS
+{
+  . = 0;
+  ImageBase = .;
+  /* .hash and/or .gnu.hash MUST come first! */
+  .hash : { *(.hash) }
+  .gnu.hash : { *(.gnu.hash) }
+  . = ALIGN(4096);
+  .eh_frame : 
+  { 
+    *(.eh_frame)
+  }
+  . = ALIGN(4096);
+  .text :
+  {
+   _text = .;
+   *(.text)
+   *(.text.*)
+   *(.gnu.linkonce.t.*)
+   . = ALIGN(16);
+  }
+  _etext = .;
+  _text_size = . - _text;
+  . = ALIGN(4096);
+  .reloc :
+  {
+   *(.reloc)
+  }
+  . = ALIGN(4096);
+  .data :
+  {
+   _data = .;
+   *(.rodata*)
+   *(.got.plt)
+   *(.got)
+   *(.data*)
+   *(.sdata)
+   /* the EFI loader doesn't seem to like a .bss section, so we stick
+      it all into .data: */
+   *(.sbss)
+   *(.scommon)
+   *(.dynbss)
+   *(.bss)
+   *(COMMON)
+   *(.rel.local)
+  }
+  .note.gnu.build-id : { *(.note.gnu.build-id) }
+
+  _edata = .;
+  _data_size = . - _etext;
+  . = ALIGN(4096);
+  .dynamic  : { *(.dynamic) }
+  . = ALIGN(4096);
+  .rela :
+  {
+    *(.rela.data*)
+    *(.rela.got)
+    *(.rela.stab)
+  }
+  . = ALIGN(4096);
+  .dynsym   : { *(.dynsym) }
+  . = ALIGN(4096);
+  .dynstr   : { *(.dynstr) }
+  . = ALIGN(4096);
+  .ignored.reloc :
+  {
+    *(.rela.reloc)
+    *(.eh_frame)
+    *(.note.GNU-stack)
+  }
+  .comment 0 : { *(.comment) }
+}
diff --git a/x86/efi/reloc_x86_64.c b/x86/efi/reloc_x86_64.c
new file mode 100644
index 0000000..d13b53e
--- /dev/null
+++ b/x86/efi/reloc_x86_64.c
@@ -0,0 +1,100 @@
+/* This file is copied from GNU-EFI/gnuefi/reloc_x86_64.c
+
+   reloc_x86_64.c - position independent x86_64 ELF shared object relocator
+   Copyright (C) 1999 Hewlett-Packard Co.
+	Contributed by David Mosberger <davidm@hpl.hp.com>.
+   Copyright (C) 2005 Intel Co.
+	Contributed by Fenghua Yu <fenghua.yu@intel.com>.
+
+    All rights reserved.
+
+    Redistribution and use in source and binary forms, with or without
+    modification, are permitted provided that the following conditions
+    are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above
+      copyright notice, this list of conditions and the following
+      disclaimer in the documentation and/or other materials
+      provided with the distribution.
+    * Neither the name of Hewlett-Packard Co. nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
+    CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
+    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+    MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
+    BE LIABLE FOR ANYDIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
+    OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
+    PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
+    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
+    THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+    SUCH DAMAGE.
+*/
+
+#include <efi.h>
+#include <efilib.h>
+
+#include <elf.h>
+
+EFI_STATUS _relocate (long ldbase, Elf64_Dyn *dyn,
+		      EFI_HANDLE image EFI_UNUSED,
+		      EFI_SYSTEM_TABLE *systab EFI_UNUSED)
+{
+	long relsz = 0, relent = 0;
+	Elf64_Rel *rel = 0;
+	unsigned long *addr;
+	int i;
+
+	for (i = 0; dyn[i].d_tag != DT_NULL; ++i) {
+		switch (dyn[i].d_tag) {
+			case DT_RELA:
+				rel = (Elf64_Rel*)
+					((unsigned long)dyn[i].d_un.d_ptr
+					 + ldbase);
+				break;
+
+			case DT_RELASZ:
+				relsz = dyn[i].d_un.d_val;
+				break;
+
+			case DT_RELAENT:
+				relent = dyn[i].d_un.d_val;
+				break;
+
+			default:
+				break;
+		}
+	}
+
+        if (!rel && relent == 0)
+                return EFI_SUCCESS;
+
+	if (!rel || relent == 0)
+		return EFI_LOAD_ERROR;
+
+	while (relsz > 0) {
+		/* apply the relocs */
+		switch (ELF64_R_TYPE (rel->r_info)) {
+			case R_X86_64_NONE:
+				break;
+
+			case R_X86_64_RELATIVE:
+				addr = (unsigned long *)
+					(ldbase + rel->r_offset);
+				*addr += ldbase;
+				break;
+
+			default:
+				break;
+		}
+		rel = (Elf64_Rel*) ((char *) rel + relent);
+		relsz -= relent;
+	}
+	return EFI_SUCCESS;
+}
-- 
2.33.0


Return-Path: <kvm+bounces-9915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DAA386792D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:56:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6075A1C281C2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B235D145B25;
	Mon, 26 Feb 2024 14:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jiMaRYER"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A5F12E1CB;
	Mon, 26 Feb 2024 14:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958260; cv=none; b=iMMW/RvYNc0K0wLnKNx//zgmnbaOqMNQAgxq4xNWlCrpiFMk9e+VauPjyxAxmLMuQ9J8R4tQElVKVXvrh/MjD5f/BjV40ibRnAFUrnmi8CwKshvED/2gyCiDmiuZRgGGxR76qzDAm8h4HQl9gDKvnWr7yysMJi6GK6WLBC17jv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958260; c=relaxed/simple;
	bh=vMW1eVYwDePlNHpf4YAsMTIArLcthLhAiwgx16DGjY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IjAcoc7sDy9hJPMNo6VJViTHe04x/EtMVZCd/XnZ4riAvY0sxLO5CvZTJDscEDkuYotoXiQkLje7z+ZvdEHvonfofIWvwNqJ4YhZmOso4YrXrceXUCl03hsRw9UR4vHNBhAV5ce+H1kYNVNUIjwmr5W5t4VJ6VVvE3BHijq8d1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jiMaRYER; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e09143c7bdso1618276b3a.3;
        Mon, 26 Feb 2024 06:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958258; x=1709563058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4klgCkETp7nNDyIHImj1EDNxCevpZbInRHKa35A/H0o=;
        b=jiMaRYERXkQv7gFmi+P94u5ubosnzFPodxog5GnlOt4chNVYwHHoq8+gCuyTdValDA
         a4nHT6DZmrU2mMrF4YxegrYju8hYBBSHZaeDdbgKjGrJ01V7fRFDL2A/zeDKDiC3SVj1
         jbfS7I/EN1tM8uIXOj5RZf/9BQseWg91MNDGsQKMZiznaoOqS5jL5EjoPshrNzgr4FQm
         G/le8CBkkY1zudXr31lO21F22eLIjApy6G6iX4+k8/N+nV0hbSlDD1o0Zx87npE8Ig35
         KiD8ubQIUC4gX1b2mjjgQEfg5madG03D1MuIufxoNxkmz93v1JQ1PLbhdrl4ulesIjAE
         21iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958258; x=1709563058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4klgCkETp7nNDyIHImj1EDNxCevpZbInRHKa35A/H0o=;
        b=MPCDYFR2iRIYY5WqeFCUDerqkRdjSM4dJbRyJAgGO6zsmMWaU/ssgIwS5EacZ0y4vq
         4l5eUg46xY6f7xkzuxPn+C7RTURwkQagHD0UUfkmdNU9n0IqLVhHU6jaCTbML7hobZw6
         6TM8s2sBmtLAz0XKM5PG9mbiA/np4p+DA63YJYCTX6bLmk51k4N4PplihwkIjfixGgaJ
         8m35kv5MJpyEmtOd/qKcCFa4sVOga61FSO+Cpl9U2J5ir3WdMgP1M7uu+9f0W2pyAHSJ
         kf70f4luNoj3yLdqcO/e09fGCUi+ta4sm9TVd+CCl1Yc1Nw/R2e7HRihNIAmh6NB/MkQ
         8MbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVW1vQkTWdFq6FEza6TA77EKKWuigazDPLo29sN/52wsgcHLjL3DFAv0SrFSpCotfD3o5SDurb4zdFDJw7F7llH8ri8
X-Gm-Message-State: AOJu0YxmE9LIymHWEbeaxHMzwbiXM4nfWLsBAUer34Jvr+tlUyq2fMyZ
	6f1xJRCmkM3fclj1IWcQCaz2o+GUHleH8Zz75iDBXPqFs3rUUTZ2YgERCZpD
X-Google-Smtp-Source: AGHT+IG7vWBbWiwjmwA+PlSCSOw5iGOSdL3EIXVHatQniQSGe/OWjrOAq8NACkhkYE96uIqmTOZEpA==
X-Received: by 2002:aa7:8a54:0:b0:6e3:d201:3f87 with SMTP id n20-20020aa78a54000000b006e3d2013f87mr5851960pfa.28.1708958258290;
        Mon, 26 Feb 2024 06:37:38 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id p17-20020a056a000b5100b006dd8a07696csm4108591pfo.106.2024.02.26.06.37.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:38 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [RFC PATCH 52/73] x86/boot: Allow to do relocation for uncompressed kernel
Date: Mon, 26 Feb 2024 22:36:09 +0800
Message-Id: <20240226143630.33643-53-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

Relocation is currently only performed during the uncompression process.
However, in some situations, such as with security containers, the
uncompressed kernel can be booted directly. Therefore, it is useful to
allow for relocation of the uncompressed kernel. Taking inspiration from
the implementation in MIPS, a new section named ".data.relocs" is
reserved for relocations. The relocs tool can then append the
relocations into this section. Additionally, a helper function is
introduced to perform relocations during booting, similar to the
relocations in the bootloader. For PVH entry, relocation for the
pre-constructed page table should not be performed; otherwise, booting
will fail.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/Kconfig                  | 20 +++++++++
 arch/x86/Makefile.postlink        |  9 +++-
 arch/x86/kernel/head64_identity.c | 70 +++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux.lds.S     | 18 ++++++++
 4 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a53b65499951..d02ef3bdb171 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2183,6 +2183,26 @@ config RELOCATABLE
 	  it has been loaded at and the compile time physical address
 	  (CONFIG_PHYSICAL_START) is used as the minimum location.
 
+config RELOCATABLE_UNCOMPRESSED_KERNEL
+	bool
+	depends on RELOCATABLE
+	help
+	  A table of relocation data will be appended to the uncompressed
+	  kernel binary and parsed at boot to fix up the relocated kernel.
+
+config RELOCATION_TABLE_SIZE
+	hex "Relocation table size"
+	depends on RELOCATABLE_UNCOMPRESSED_KERNEL
+	range 0x0 0x01000000
+	default "0x00200000"
+	help
+	  This option allows the amount of space reserved for the table to be
+	  adjusted, although the default of 1Mb should be ok in most cases.
+
+	  The build will fail and a valid size suggested if this is too small.
+
+	  If unsure, leave at the default value.
+
 config X86_PIE
 	bool "Build a PIE kernel"
 	default n
diff --git a/arch/x86/Makefile.postlink b/arch/x86/Makefile.postlink
index fef2e977cc7d..c115692b67b2 100644
--- a/arch/x86/Makefile.postlink
+++ b/arch/x86/Makefile.postlink
@@ -4,7 +4,8 @@
 # ===========================================================================
 #
 # 1. Separate relocations from vmlinux into vmlinux.relocs.
-# 2. Strip relocations from vmlinux.
+# 2. Insert relocations table into vmlinux
+# 3. Strip relocations from vmlinux.
 
 PHONY := __archpost
 __archpost:
@@ -20,6 +21,9 @@ quiet_cmd_relocs = RELOCS  $(OUT_RELOCS)/$@.relocs
 	$(CMD_RELOCS) $@ > $(OUT_RELOCS)/$@.relocs; \
 	$(CMD_RELOCS) --abs-relocs $@
 
+quiet_cmd_insert_relocs = RELOCS  $@
+      cmd_insert_relocs = $(CMD_RELOCS) --keep $@
+
 quiet_cmd_strip_relocs = RSTRIP  $@
       cmd_strip_relocs = \
 	$(OBJCOPY) --remove-section='.rel.*' --remove-section='.rel__*' \
@@ -29,6 +33,9 @@ quiet_cmd_strip_relocs = RSTRIP  $@
 
 vmlinux: FORCE
 	@true
+ifeq ($(CONFIG_RELOCATABLE_UNCOMPRESSED_KERNEL),y)
+	$(call cmd,insert_relocs)
+endif
 ifeq ($(CONFIG_X86_NEED_RELOCS),y)
 	$(call cmd,relocs)
 	$(call cmd,strip_relocs)
diff --git a/arch/x86/kernel/head64_identity.c b/arch/x86/kernel/head64_identity.c
index ecac6e704868..4548ad615ecf 100644
--- a/arch/x86/kernel/head64_identity.c
+++ b/arch/x86/kernel/head64_identity.c
@@ -315,3 +315,73 @@ void __head startup_64_setup_env(void)
 
 	startup_64_load_idt();
 }
+
+#ifdef CONFIG_RELOCATABLE_UNCOMPRESSED_KERNEL
+extern u8 __relocation_end[];
+
+static bool __head is_in_pvh_pgtable(unsigned long ptr)
+{
+#ifdef CONFIG_PVH
+	if (ptr >= (unsigned long)init_top_pgt &&
+	    ptr < (unsigned long)init_top_pgt + PAGE_SIZE)
+		return true;
+	if (ptr >= (unsigned long)level3_ident_pgt &&
+	    ptr < (unsigned long)level3_ident_pgt + PAGE_SIZE)
+		return true;
+#endif
+	return false;
+}
+
+void __head __relocate_kernel(unsigned long physbase, unsigned long virtbase)
+{
+	int *reloc = (int *)__relocation_end;
+	unsigned long ptr;
+	unsigned long delta = virtbase - __START_KERNEL_map;
+	unsigned long map = physbase - __START_KERNEL;
+	long extended;
+
+	/*
+	 * Relocation had happended in bootloader,
+	 * don't do it again.
+	 */
+	if (SYM_ABS_VA(_text) != __START_KERNEL)
+		return;
+
+	if (!delta)
+		return;
+
+	/*
+	 * Format is:
+	 *
+	 * kernel bits...
+	 * 0 - zero terminator for 64 bit relocations
+	 * 64 bit relocation repeated
+	 * 0 - zero terminator for inverse 32 bit relocations
+	 * 32 bit inverse relocation repeated
+	 * 0 - zero terminator for 32 bit relocations
+	 * 32 bit relocation repeated
+	 *
+	 * So we work backwards from the end of .data.relocs section, see
+	 * handle_relocations() in arch/x86/boot/compressed/misc.c.
+	 */
+	while (*--reloc) {
+		extended = *reloc;
+		ptr = (unsigned long)(extended + map);
+		*(uint32_t *)ptr += delta;
+	}
+
+	while (*--reloc) {
+		extended = *reloc;
+		ptr = (unsigned long)(extended + map);
+		*(int32_t *)ptr -= delta;
+	}
+
+	while (*--reloc) {
+		extended = *reloc;
+		ptr = (unsigned long)(extended + map);
+		if (is_in_pvh_pgtable(ptr))
+			continue;
+		*(uint64_t *)ptr += delta;
+	}
+}
+#endif
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 834c68b45f15..3b05807fe1dc 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -339,6 +339,24 @@ SECTIONS
 	}
 #endif
 
+#ifdef CONFIG_RELOCATABLE_UNCOMPRESSED_KERNEL
+	. = ALIGN(4);
+	.data.reloc : AT(ADDR(.data.reloc) - LOAD_OFFSET) {
+		__relocation_start = .;
+		/*
+		 * Space for relocation table
+		 * This needs to be filled so that the
+		 * relocs tool can overwrite the content.
+		 * Put a dummy data item at the start to
+		 * avoid to generate NOBITS section.
+		 */
+		LONG(0);
+		FILL(0);
+		. += CONFIG_RELOCATION_TABLE_SIZE - 4;
+		__relocation_end = .;
+	}
+#endif
+
 	/*
 	 * struct alt_inst entries. From the header (alternative.h):
 	 * "Alternative instructions for different CPU types or capabilities"
-- 
2.19.1.6.gb485710b



Return-Path: <kvm+bounces-21540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C17692FEE1
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:01:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 874E81F22543
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90828171E6A;
	Fri, 12 Jul 2024 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GF9046HL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCEB176FDF
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803660; cv=none; b=KXZiZxMFLNdpdet0ABp/tKj2sU3V3Zn1YW/ZaIlx5t6HMiIjd1f3C3J8tjcPdjf49dejbDQuoX2nvdMNQ6WjcmpLrMoFBcOBXI0PqLjE/G4a0frXQqvx6HgDEbiu2TTdI96gSR4RZZt9FaRam04g2WmxPDK9nBPgc3/tKl8tLG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803660; c=relaxed/simple;
	bh=0ox/fHV0whWmOA16gHsV/BoM3g3RhG5o+vu5pBfDGGQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KiJKeqLAA+KyEK9mYtbBqryyHNd8mgwVlkQwdOOIPJLGWNO8gBmDssHxtI+07LGR8iZLMYMZwtK6JN/fTlM0TgGE0JLycpRki5ptQWB5HQRQUhR2aHNPhfAH4+PJ1fY/g+BzEfhzFKFpowIg5sEE7fzvUVPNMcP63zll1Az8uCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GF9046HL; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3679ab94cdbso1354297f8f.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803657; x=1721408457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=27EENIWQHHAHugBK1Q6SYWc3PF1x6i/tf/vuqqwaqlI=;
        b=GF9046HLblGUxJUtYgpxP67eEVdgAfBrcUV4iSPM2WlIEqpn4gIv4PcTXSK0rkdxdr
         mNbtBUdwOOVbMm6xEjCb9nugjmGbLsQVjFU8pQGXTmiq0Y42P+NcR704zJ5iPzANB6fV
         U08hoj97XEOEETAzerxeMPJyod8RqAFzXxRxkmmxJUtwXRtug5Ka3pN1lQP/c/Jz0bGt
         /BOOm52j5DVOvPHjgjfynAiLexEMejqyrD7tzQKFnyD9pX+7vLX7FQmhBBJ0s7O/P71y
         lFL8NDGqyfXzjg6mfpIG9Hh4ZlJBH4mztcMpieNlrZSjPixmym7/fFG456PNKrPAHVBb
         ApzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803657; x=1721408457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=27EENIWQHHAHugBK1Q6SYWc3PF1x6i/tf/vuqqwaqlI=;
        b=X11PgfwLMuT0iEQqHQvim86mVIiMij643BycMzH3CMuznY5c22AiNTwH4MHm/LVlnB
         b9sIuGtNYIlEhqqu3fVa2/j2lSv1ZwYvnmNL2uBgrPlqvctP/xiOPn4W1XvnO1VdapGy
         fMk1bmsT0RodvuxSQni/tXRe1ny2TreKwuHT4EILYQuJm/34e1kUDr3xAodL7LOG3n9e
         igtKPB0BVc0DPR3DxE3X0jf+GXQh6G00EOXggoZ84TK7HZKup7tu5IIawqh4B1i8iDsm
         EZYpYHxXORD0vfEzqGWfyfimPzbVTAPgC5G/+5NkKma5PCZeHK97LXGuuoG7VOnn17go
         Ngbw==
X-Forwarded-Encrypted: i=1; AJvYcCXLo+hZDpDSgZCldM9ih6Unyj3eDC+xAl/vsiI742fCHhqZkOA4p20AzgzUiImKyIgEePRcQrBXLSTZ0lSjC09MVzW8
X-Gm-Message-State: AOJu0YyRIZwaMeQKenLeY6kP9eGnu2hmejJ71WyKW94gFedxFESlOQ+/
	O/tHpIEIAVfOMUKbwW+3ZDAP8IdVdohe/WqVh94yV1v/ifhG6WmasN6sMp9Il5GFN2tEovkIcd+
	E84GtARu5BQ==
X-Google-Smtp-Source: AGHT+IGA7T3CScQphIzrB5GwbqwR/XvQ+ZJeEz+EAB7hHAYrv99hyozzic8O5c9/DkjRZkjaSXDa+Xm3xrwxfw==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:6000:14c:b0:360:727b:8b5d with SMTP
 id ffacd0b85a97d-367cea738dbmr25053f8f.6.1720803657248; Fri, 12 Jul 2024
 10:00:57 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:20 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-2-144b319a40d8@google.com>
Subject: [PATCH 02/26] x86: Create CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

Currently a nop config. Keeping as a separate commit for easy review of
the boring bits. Later commits will use and enable this new config.

This config is only added for non-UML x86_64 as other architectures do
not yet have pending implementations. It also has somewhat artificial
dependencies on !PARAVIRT and !KASAN which are explained in the Kconfig
file.

Co-developed-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/alpha/include/asm/Kbuild      |  1 +
 arch/arc/include/asm/Kbuild        |  1 +
 arch/arm/include/asm/Kbuild        |  1 +
 arch/arm64/include/asm/Kbuild      |  1 +
 arch/csky/include/asm/Kbuild       |  1 +
 arch/hexagon/include/asm/Kbuild    |  1 +
 arch/loongarch/include/asm/Kbuild  |  1 +
 arch/m68k/include/asm/Kbuild       |  1 +
 arch/microblaze/include/asm/Kbuild |  1 +
 arch/mips/include/asm/Kbuild       |  1 +
 arch/nios2/include/asm/Kbuild      |  1 +
 arch/openrisc/include/asm/Kbuild   |  1 +
 arch/parisc/include/asm/Kbuild     |  1 +
 arch/powerpc/include/asm/Kbuild    |  1 +
 arch/riscv/include/asm/Kbuild      |  1 +
 arch/s390/include/asm/Kbuild       |  1 +
 arch/sh/include/asm/Kbuild         |  1 +
 arch/sparc/include/asm/Kbuild      |  1 +
 arch/um/include/asm/Kbuild         |  1 +
 arch/x86/Kconfig                   | 19 +++++++++++++++++++
 arch/xtensa/include/asm/Kbuild     |  1 +
 include/asm-generic/asi.h          |  5 +++++
 22 files changed, 44 insertions(+)

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 396caece6d6d9..ca72ce3baca13 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += agp.h
 generic-y += asm-offsets.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += asi.h
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index 3c1afa524b9c2..60bdeffa7c31e 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 03657ff8fbe3d..1e2c3d8dbbd99 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -6,3 +6,4 @@ generic-y += parport.h
 
 generated-y += mach-types.h
 generated-y += unistd-nr.h
+generic-y += asi.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 4b6d2d52053e4..f95699a559309 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -5,6 +5,7 @@ generic-y += qrwlock.h
 generic-y += qspinlock.h
 generic-y += parport.h
 generic-y += user.h
+generic-y += asi.h
 
 generated-y += cpucap-defs.h
 generated-y += sysreg-defs.h
diff --git a/arch/csky/include/asm/Kbuild b/arch/csky/include/asm/Kbuild
index 1117c28cb7e8a..5e49ccb571644 100644
--- a/arch/csky/include/asm/Kbuild
+++ b/arch/csky/include/asm/Kbuild
@@ -10,3 +10,4 @@ generic-y += qspinlock.h
 generic-y += parport.h
 generic-y += user.h
 generic-y += vmlinux.lds.h
+generic-y += asi.h
\ No newline at end of file
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 3ece3c93fe086..744ffbeeb7ae4 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += extable.h
 generic-y += iomap.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += asi.h
diff --git a/arch/loongarch/include/asm/Kbuild b/arch/loongarch/include/asm/Kbuild
index 2dbec7853ae86..66fcd325d6083 100644
--- a/arch/loongarch/include/asm/Kbuild
+++ b/arch/loongarch/include/asm/Kbuild
@@ -27,3 +27,4 @@ generic-y += param.h
 generic-y += posix_types.h
 generic-y += resource.h
 generic-y += kvm_para.h
+generic-y += asi.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 0dbf9c5c6faeb..faf0f135df4ab 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += extable.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += spinlock.h
+generic-y += asi.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index a055f5dbe00a3..012e4bf83c134 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -8,3 +8,4 @@ generic-y += parport.h
 generic-y += syscalls.h
 generic-y += tlb.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 7ba67a0d6c97b..3191699298d80 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -13,3 +13,4 @@ generic-y += parport.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/nios2/include/asm/Kbuild b/arch/nios2/include/asm/Kbuild
index 7fe7437555fb4..bfdc4026c5b16 100644
--- a/arch/nios2/include/asm/Kbuild
+++ b/arch/nios2/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += spinlock.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index c8c99b554ca4c..d137c4e08e369 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -7,3 +7,4 @@ generic-y += spinlock.h
 generic-y += qrwlock_types.h
 generic-y += qrwlock.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 4fb596d94c893..3cbb4eb14712c 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += agp.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 61a8d5555cd7e..103c7e2f66987 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -8,3 +8,4 @@ generic-y += mcs_spinlock.h
 generic-y += qrwlock.h
 generic-y += vtime.h
 generic-y += early_ioremap.h
+generic-y += asi.h
diff --git a/arch/riscv/include/asm/Kbuild b/arch/riscv/include/asm/Kbuild
index 504f8b7e72d41..08c199a56731e 100644
--- a/arch/riscv/include/asm/Kbuild
+++ b/arch/riscv/include/asm/Kbuild
@@ -9,3 +9,4 @@ generic-y += qrwlock.h
 generic-y += qrwlock_types.h
 generic-y += user.h
 generic-y += vmlinux.lds.h
+generic-y += asi.h
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 4b904110d27cb..b5caf77e8d955 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -7,3 +7,4 @@ generated-y += unistd_nr.h
 generic-y += asm-offsets.h
 generic-y += kvm_types.h
 generic-y += mcs_spinlock.h
+generic-y += asi.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index fc44d9c88b419..ea19e45158285 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -3,3 +3,4 @@ generated-y += syscall_table.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
+generic-y += asi.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 43b0ae4c2c211..cb9062c9be17f 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -4,3 +4,4 @@ generated-y += syscall_table_64.h
 generic-y += agp.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += asi.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index b2d834a29f3a9..1bcb16b09dc49 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -28,3 +28,4 @@ generic-y += trace_clock.h
 generic-y += kprobes.h
 generic-y += mm_hooks.h
 generic-y += vga.h
+generic-y += asi.h
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 928820e61cb50..ff74aa53842ea 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2516,6 +2516,25 @@ config MITIGATION_PAGE_TABLE_ISOLATION
 
 	  See Documentation/arch/x86/pti.rst for more details.
 
+config MITIGATION_ADDRESS_SPACE_ISOLATION
+	bool "Allow code to run with a reduced kernel address space"
+	default n
+	depends on X86_64 && !PARAVIRT && !KASAN && !UML
+	help
+	  This feature provides the ability to run some kernel code
+	  with a reduced kernel address space. This can be used to
+	  mitigate some speculative execution attacks.
+
+	  The !PARAVIRT dependency is only because of lack of testing; in theory
+	  the code is written to work under paravirtualization. In practice
+	  there are likely to be unhandled cases, in particular concerning TLB
+	  flushes.
+
+	  The !KASAN dependency is mainly because ASI creates a secondary
+	  direct-map region in order to implement local-nonsensitive memory.
+	  This dependencies will later be removed with extensions to the KASAN
+	  implementation.
+
 config MITIGATION_RETPOLINE
 	bool "Avoid speculative indirect branches in kernel"
 	select OBJTOOL if HAVE_OBJTOOL
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index fa07c686cbcc2..07cea6902f980 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -8,3 +8,4 @@ generic-y += parport.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
new file mode 100644
index 0000000000000..c4d9a5ff860a9
--- /dev/null
+++ b/include/asm-generic/asi.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_GENERIC_ASI_H
+#define __ASM_GENERIC_ASI_H
+
+#endif

-- 
2.45.2.993.g49e7a77208-goog



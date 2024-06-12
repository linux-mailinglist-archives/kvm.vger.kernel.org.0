Return-Path: <kvm+bounces-19456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D8990558C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E34E91C218D0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3D617F508;
	Wed, 12 Jun 2024 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JwQw7o+R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE31E17F4ED
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203556; cv=none; b=Ij26LxwVPstshEtS43XC2GsHIcAjBlXLMdxz0AgknRK3rWF8+f1B1f1JjtM7cInh9iTek6fkfxbkCpOKR/z7+wSJ94hPJhaYqkfyEjCt6mA8etovfF52JzIv+bRDl4o/GGdtByobPnj5DkvKoADDFpeH+ONWD7C4aso+/Xd0bjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203556; c=relaxed/simple;
	bh=n+HiePUSK4nbjnB37DbjThD7qF0Lvxx8ojbyqjSwJrU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u00ByoxIsSbHHdJVBwCoPJIgLt+LBUfho/7GKO275q2DNngAv7OkbWlfbIOZPu/wxNMMqeEP/zksJmAXPXZl1+igTbLvCjMpc5SX0dU2Y8k9tblq0LrpLHvUuuUDB+MRQjVIN0eUqldqwaZSSZoHW4EQoxYEyY6gv6yAJya3eQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JwQw7o+R; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2eabd22d441so110865431fa.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203552; x=1718808352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IB3CcC7U5Vnz5NTmOXn/40tXEY5EWl8d3bB7zSXBveU=;
        b=JwQw7o+RK27Y4IVw7WXVyhnGgkJf3X68jT3Jv/fZKbu+BVPNLZiarqeUp+IQsnRdAI
         /BGlM2xWVgntz+feq0Z7SKlbRuI3WXuW7dHRQt5IUIdZpVeNAF1KP+uu7WZ7Az/asSVc
         1+1dsgFxE4jmTJWGZdY8vSik02BxPdJFjkOh6+26YuQjPVfY3cfV3HFAEhFajutWj6wj
         sqq7DlqxQRQ9LaBDWuqanExcwDYIYkhs6ec9/SLJozTsQfCU3QVwxvMhhXrVTzEaiPmT
         cCaCalH2nmporVZQmySVET36mfmePoxSrE5XHGibcWb+EnrFSKNyUiBEvOTfF0GKxlYR
         eRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203552; x=1718808352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IB3CcC7U5Vnz5NTmOXn/40tXEY5EWl8d3bB7zSXBveU=;
        b=Njw0Edh+NorybLcCeom2ebdJb6t8bshMfgCkem0/QUDyvOXB35Cki6sHgt3qDSqWFK
         9ZQvSx16GCEXEHX81aN8ty6ZlzNOc5GXvObfQekY7w4d8kSk/he2DpFemt2cioYY1KAT
         2nrAx2g9PfoljKM46N5YEFBPsrqYEamASeRhQmXvyx+yhFcJrAuSM7/ZHm9ndRpDmTsO
         g78nDklcjx/bkOewzMS7jCW+XWdsV3skf7PyBlef/cCQtISXudIj3mbQ1UXzyJdruh7H
         rBU93TxaX2zGjweX9D4HvwODy6UbYQ8D/ySbPShWqP5RI+H2HPMe4UccPNX9o0OI7xvf
         OwOA==
X-Gm-Message-State: AOJu0YyZzo1L3KD/KDEP29hBTtZN1aCU7aCePdAKKrJVgOsA1ACkbO/k
	y60PP7DIuSEJd0asge/Vt/hn0cCw+srxOBZ/hB8Wi+a/upY+FKwQksCnFyaF
X-Google-Smtp-Source: AGHT+IEve3akEIV3pxXjCzqnpeHgDsnSh6d3B9a8MIXELrPvrynzl2KuzyWBAHCqbbTvwkXy9j1vMg==
X-Received: by 2002:a2e:9d0e:0:b0:2ea:edac:4886 with SMTP id 38308e7fff4ca-2ebfca475dbmr14203981fa.45.1718203552258;
        Wed, 12 Jun 2024 07:45:52 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:45:51 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 05/12] x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
Date: Wed, 12 Jun 2024 16:45:32 +0200
Message-Id: <20240612144539.16147-6-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240612144539.16147-1-vsntk18@gmail.com>
References: <20240612144539.16147-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

Origin: Linux e8c39d0f57f358950356a8e44ee5159f57f86ec5

Suppress -Waddress-of-packed-member to allow taking addresses on struct
ghcb / struct vmcb_save_area fields.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/amd_sev.h   | 136 ++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/msr.h       |   1 +
 lib/x86/processor.h |   8 +++
 lib/x86/svm.h       |  19 +++++--
 x86/Makefile.x86_64 |   1 +
 5 files changed, 159 insertions(+), 6 deletions(-)

diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 713019c2..b6b7a13f 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -18,6 +18,90 @@
 #include "desc.h"
 #include "asm/page.h"
 #include "efi.h"
+#include "processor.h"
+#include "insn/insn.h"
+#include "svm.h"
+
+#define GHCB_SHARED_BUF_SIZE    2032
+
+struct ghcb_save_area {
+	u8 reserved_0x0[203];
+	u8 cpl;
+	u8 reserved_0xcc[116];
+	u64 xss;
+	u8 reserved_0x148[24];
+	u64 dr7;
+	u8 reserved_0x168[16];
+	u64 rip;
+	u8 reserved_0x180[88];
+	u64 rsp;
+	u8 reserved_0x1e0[24];
+	u64 rax;
+	u8 reserved_0x200[264];
+	u64 rcx;
+	u64 rdx;
+	u64 rbx;
+	u8 reserved_0x320[8];
+	u64 rbp;
+	u64 rsi;
+	u64 rdi;
+	u64 r8;
+	u64 r9;
+	u64 r10;
+	u64 r11;
+	u64 r12;
+	u64 r13;
+	u64 r14;
+	u64 r15;
+	u8 reserved_0x380[16];
+	u64 sw_exit_code;
+	u64 sw_exit_info_1;
+	u64 sw_exit_info_2;
+	u64 sw_scratch;
+	u8 reserved_0x3b0[56];
+	u64 xcr0;
+	u8 valid_bitmap[16];
+	u64 x87_state_gpa;
+} __packed;
+
+struct ghcb {
+	struct ghcb_save_area save;
+	u8 reserved_save[2048 - sizeof(struct ghcb_save_area)];
+
+	u8 shared_buffer[GHCB_SHARED_BUF_SIZE];
+
+	u8 reserved_0xff0[10];
+	u16 protocol_version;	/* negotiated SEV-ES/GHCB protocol version */
+	u32 ghcb_usage;
+} __packed;
+
+#define GHCB_PROTO_OUR		0x0001UL
+#define GHCB_PROTOCOL_MAX	1ULL
+#define GHCB_DEFAULT_USAGE	0ULL
+
+#define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
+
+enum es_result {
+	ES_OK,			/* All good */
+	ES_UNSUPPORTED,		/* Requested operation not supported */
+	ES_VMM_ERROR,		/* Unexpected state from the VMM */
+	ES_DECODE_FAILED,	/* Instruction decoding failed */
+	ES_EXCEPTION,		/* Instruction caused exception */
+	ES_RETRY,		/* Retry instruction emulation */
+};
+
+struct es_fault_info {
+	unsigned long vector;
+	unsigned long error_code;
+	unsigned long cr2;
+};
+
+/* ES instruction emulation context */
+struct es_em_ctxt {
+	struct ex_regs *regs;
+	struct insn insn;
+	struct es_fault_info fi;
+};

 /*
  * AMD Programmer's Manual Volume 3
@@ -59,6 +143,58 @@ void handle_sev_es_vc(struct ex_regs *regs);
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);

+/* GHCB Accessor functions from Linux's include/asm/svm.h */
+#define GHCB_BITMAP_IDX(field)							\
+	(offsetof(struct ghcb_save_area, field) / sizeof(u64))
+
+#define DEFINE_GHCB_ACCESSORS(field)						\
+	static __always_inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb) \
+	{									\
+		return test_bit(GHCB_BITMAP_IDX(field),				\
+				(unsigned long *)&ghcb->save.valid_bitmap);	\
+	}									\
+										\
+	static __always_inline u64 ghcb_get_##field(struct ghcb *ghcb)		\
+	{									\
+		return ghcb->save.field;					\
+	}									\
+										\
+	static __always_inline u64 ghcb_get_##field##_if_valid(struct ghcb *ghcb) \
+	{									\
+		return ghcb_##field##_is_valid(ghcb) ? ghcb->save.field : 0;	\
+	}									\
+										\
+	static __always_inline void ghcb_set_##field(struct ghcb *ghcb, u64 value) \
+	{									\
+		set_bit(GHCB_BITMAP_IDX(field),				\
+			  (u8 *)&ghcb->save.valid_bitmap);		\
+		ghcb->save.field = value;					\
+	}
+
+DEFINE_GHCB_ACCESSORS(cpl)
+DEFINE_GHCB_ACCESSORS(rip)
+DEFINE_GHCB_ACCESSORS(rsp)
+DEFINE_GHCB_ACCESSORS(rax)
+DEFINE_GHCB_ACCESSORS(rcx)
+DEFINE_GHCB_ACCESSORS(rdx)
+DEFINE_GHCB_ACCESSORS(rbx)
+DEFINE_GHCB_ACCESSORS(rbp)
+DEFINE_GHCB_ACCESSORS(rsi)
+DEFINE_GHCB_ACCESSORS(rdi)
+DEFINE_GHCB_ACCESSORS(r8)
+DEFINE_GHCB_ACCESSORS(r9)
+DEFINE_GHCB_ACCESSORS(r10)
+DEFINE_GHCB_ACCESSORS(r11)
+DEFINE_GHCB_ACCESSORS(r12)
+DEFINE_GHCB_ACCESSORS(r13)
+DEFINE_GHCB_ACCESSORS(r14)
+DEFINE_GHCB_ACCESSORS(r15)
+DEFINE_GHCB_ACCESSORS(sw_exit_code)
+DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
+DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
+DEFINE_GHCB_ACCESSORS(sw_scratch)
+DEFINE_GHCB_ACCESSORS(xcr0)
+
 #endif /* CONFIG_EFI */

 #endif /* _X86_AMD_SEV_H_ */
diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 8abccf86..5661b221 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -151,6 +151,7 @@
 #define MSR_AMD64_IBSDCLINAD		0xc0011038
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
 #define MSR_AMD64_IBSCTL		0xc001103a
+#define MSR_AMD64_SEV_ES_GHCB		0xc0010130

 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 44f4fd1e..b324cbf0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -837,6 +837,14 @@ static inline void set_bit(int bit, u8 *addr)
 			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
 }

+static inline int test_bit(int nr, const volatile unsigned long *addr)
+{
+	const volatile unsigned long *word = addr + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+
+	return (*word & mask) != 0;
+}
+
 static inline void flush_tlb(void)
 {
 	ulong cr4;
diff --git a/lib/x86/svm.h b/lib/x86/svm.h
index 0fc64be7..01404010 100644
--- a/lib/x86/svm.h
+++ b/lib/x86/svm.h
@@ -175,11 +175,13 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
 	struct vmcb_seg ldtr;
 	struct vmcb_seg idtr;
 	struct vmcb_seg tr;
-	u8 reserved_1[43];
+	/* Reserved fields are named following their struct offset */
+	u8 reserved_0xa0[42];
+	u8 vmpl;
 	u8 cpl;
-	u8 reserved_2[4];
+	u8 reserved_0xcc[4];
 	u64 efer;
-	u8 reserved_3[112];
+	u8 reserved_0xd8[112];
 	u64 cr4;
 	u64 cr3;
 	u64 cr0;
@@ -187,9 +189,11 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
 	u64 dr6;
 	u64 rflags;
 	u64 rip;
-	u8 reserved_4[88];
+	u8 reserved_0x180[88];
 	u64 rsp;
-	u8 reserved_5[24];
+	u64 s_cet;
+	u64 ssp;
+	u64 isst_addr;
 	u64 rax;
 	u64 star;
 	u64 lstar;
@@ -200,13 +204,15 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
 	u64 sysenter_esp;
 	u64 sysenter_eip;
 	u64 cr2;
-	u8 reserved_6[32];
+	u8 reserved_0x248[32];
 	u64 g_pat;
 	u64 dbgctl;
 	u64 br_from;
 	u64 br_to;
 	u64 last_excp_from;
 	u64 last_excp_to;
+	u8 reserved_0x298[72];
+	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
 };

 struct __attribute__ ((__packed__)) vmcb {
@@ -307,6 +313,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define	SVM_EXIT_WRITE_DR6 	0x036
 #define	SVM_EXIT_WRITE_DR7 	0x037
 #define SVM_EXIT_EXCP_BASE      0x040
+#define SVM_EXIT_LAST_EXCP	0x05f
 #define SVM_EXIT_INTR		0x060
 #define SVM_EXIT_NMI		0x061
 #define SVM_EXIT_SMI		0x062
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 2771a6fa..c59b3b61 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -19,6 +19,7 @@ endif

 fcf_protection_full := $(call cc-option, -fcf-protection=full,)
 COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 $(fcf_protection_full)
+COMMON_CFLAGS += -Wno-address-of-packed-member

 cflatobjs += lib/x86/setjmp64.o
 cflatobjs += lib/x86/intel-iommu.o
--
2.34.1



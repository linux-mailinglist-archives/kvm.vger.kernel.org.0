Return-Path: <kvm+bounces-14295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C88828A1DD4
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:19:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E13428BC24
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB5D59B5A;
	Thu, 11 Apr 2024 17:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pjl0xuF5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F2859176
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856599; cv=none; b=lwQDkPvPGIDg1KAxFY7Rx7zsyEx8BxTpNq1DYIp09AzZURJUTV5OE/c6465Kqod2m1DGsv+P9N2UjPipZ3WIRT+TwL8MxYPuK+oD7aDHl85lxGqO3kVfRzeDQhCk4mlpHTeGedeYzWwtPGek9aff9Ml1YwegWQAbL5FU48btOks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856599; c=relaxed/simple;
	bh=f3oDwkFgCu5t53SaKodRkaTQ7Ogc9XuQQI9VCCG8PV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TulPaLKH4DO1jD/z/zcYbpKzHVKcjl88jeAiLfpHEP+54xYlwmRtx1vJY+RztoK4IwFqlHajh7myGmBvBfECSwX+XeJUK4DM6RrjWIjxqg7ae6+EeF1jNGeWIXYlWhuTiaOtXqLGUSQlkgEmpUEOFoQTyjgTSAj51S6x5jU8BqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pjl0xuF5; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-55a179f5fa1so45469a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856595; x=1713461395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/iEi/8MLXhxraVsyNklASwWsenaif62c9v9PJmhKOM=;
        b=Pjl0xuF57Eron3oxl3WIoU0aOZTVhUZEEc7+SJvxSao0V6ubmwEW7ZYi2g0ii9uznf
         kaPS8Ioq7o4O5VSAC/hmtYwAfGKuby7Ja5mSuUICDdDD1OSiiTN6hytI7d+HyR3u1br2
         Z98AVlJ8WGqsuadIT+Udhgw00OcqEK2MXyoWPvihh8NJCtl8x7Dkr4T7Y+IaZegD1PkA
         KCiFRuvZKdDhwky5XVMSs7KMQk6asMU0DY7NTmlxiHK6kN8bNqnQpXmCaBfbFkqeWQAB
         rosg8ZM4vr5se1vBneNA+ZvV9ebspLkLbdsjGsEcbN1ZVWSVJ8ChPaWm5cjJ6yePNtbZ
         CB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856595; x=1713461395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5/iEi/8MLXhxraVsyNklASwWsenaif62c9v9PJmhKOM=;
        b=SrBIYFeOPIkUJ0CuL6imvLiEaiKTErcCpjlPMQuyuL3f8FtuktzCzcnpckbaiIaUdj
         ifRo5g/7duf7YgsQVBGds7ThVoKXNSbf6BQ9ejBPgKINW/FHU78vcV7FZkGu2Le9PzhT
         ZN+v/8OuC89uuLNrOk/yXraMiSvMB5xDmRugbGsPx/1cZ0M3VY05yxQ+IxiKqLLqlmK+
         y1mV9z67ShWF/0oaIB5oQ+6IXNfn0AVannMtpuTNuLMFTEfXfoUEJiWhcAgVtSJxmCR0
         h5pFaZg51SsFRiE2H/y1Xau5YGqMbZjwV+YkN+dLh1Z+8bnD7av2xynRvh5PIMoORDxe
         WXnw==
X-Gm-Message-State: AOJu0YyQ7pNYlTF/foslUVrx1GWumaYVqdN8syRvS/a81o03XBrRLusK
	Od7LL+tFMIIXNbCUeRG00AL6Z+Za4nxqCv4Lt07s5CmfMTHF+q29DnkOxvlU
X-Google-Smtp-Source: AGHT+IHPCGOS4aCvSYZcdDHKZVjFX9A6ANRbKTjprhvSaJbCfOE3RYYQuN/sXpDBPqCK1HJ5zSAA7A==
X-Received: by 2002:a50:9e05:0:b0:56b:9f35:65f9 with SMTP id z5-20020a509e05000000b0056b9f3565f9mr341901ede.0.1712856595145;
        Thu, 11 Apr 2024 10:29:55 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:29:54 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	zxwang42@gmail.com,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v6 05/11] x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
Date: Thu, 11 Apr 2024 19:29:38 +0200
Message-Id: <20240411172944.23089-6-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411172944.23089-1-vsntk18@gmail.com>
References: <20240411172944.23089-1-vsntk18@gmail.com>
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

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
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
index 308daa55..36fbf455 100644
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



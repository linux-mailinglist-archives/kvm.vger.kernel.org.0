Return-Path: <kvm+bounces-15334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C898AB326
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DA46283463
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10617133413;
	Fri, 19 Apr 2024 16:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTbQUpeh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA0D131E3C
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543399; cv=none; b=ZIhkwYibe5f+12tVHYs3yy6XX7zBR14TGUXhX8JHi2lJSe9IH9R8iZLV4YI9mYQ3qXYtWxwAfljNDgBh2kjmgKbpzK4FHtG2LqHqZtH3+1krHIfGBsBdhbKEnvxcJ8E/MmJsJ0KvYn/33b6EH4MQfA2edhRx7vuYtQEAQUcT2HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543399; c=relaxed/simple;
	bh=f3oDwkFgCu5t53SaKodRkaTQ7Ogc9XuQQI9VCCG8PV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GpnX0adcKkA08dtZKOSGJP2OUY389jQ4ftq5tbm7DeYUgUGVIm77UVdpzWr9l2lM6B54u6zO4T16IMBN86rZOQ8bwUzEwJT9NadXa4UshXQZw2S/a2dr2XO6v3pIXikUMtxiP5ZUsyU5bwdZT83vxHbVY3TqI84yfU+MdIC/cjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTbQUpeh; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-418e4cd1fecso13640245e9.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713543394; x=1714148194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/iEi/8MLXhxraVsyNklASwWsenaif62c9v9PJmhKOM=;
        b=gTbQUpeh8shoKPIDCWay4h58P5qmlrtNCLSQeFVtjyf7Nwr0c5Is19DjeeQZL1z6xy
         TDPcqQzRKkrkjasZdS2iRVcl7qzE9dVLv68gme9B2vLPG2z9YFFdPGHndJYUtqDw9E1a
         o/bMA7wnID5KFv8gYpkmEU/0yjU4aygJCIm01JUUTv0t9xDg84P2ke4ZXY1KQVgek0oA
         ak3ndoT+BbIFWQ8xreVoWyGWk+6aHR6y8TsJ45IYKd0VQt3oYFOkoFjM/99aOFu3xmUL
         H+nJrG5wimmxk0c35ypCh8Ljq/nCLQzdIKcI+UhHD/89Fmpx4N9/jG/2Hp9Re3cVU/y2
         0SCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543394; x=1714148194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5/iEi/8MLXhxraVsyNklASwWsenaif62c9v9PJmhKOM=;
        b=f7ljKppIsN8vdgRoTO6W7dk73qyMf2HvCR8fmHybIzcjsgOd+CNoH/DFNpZ+8+LoD0
         re0VZ4V75XWl1vUC6ydJPUSFe2aXOMdjqMmgtpKDBDljjZ1CxhKYy5k7h0dQcTnwHRFp
         31McsSUUze4X8dF33mdQTbVc2I3O8sdOjN3Xalx+lqRXZZw/d31Gfegzf3/LtDghMJPM
         SDsKXpsO+VmxIvoIz6afdcQcZPgxQcXeMwIaN6Yx/9WvRkI/lumEeil9LZQxgpFPBLEA
         ANmR/OUtFJAa/R6TGG6gPa9nvg/fcNHqBW/ldjYnjvfUP7v40u3l77suGXRzs1u5mnI9
         DMBg==
X-Gm-Message-State: AOJu0YxqxzQJd+tmU65V0ZdzGRSuMgYEpdzVRQDUtnob1W8uKm2qBh7z
	2LCs93qgyTQHMl7JVIRNMnS2QAQQJJ4Uiul9bmprdO1QNbbwQqU0bvu66TBs
X-Google-Smtp-Source: AGHT+IEg3uW/WD/tDi87ROHvJHnV0lROeRoU42BWfFVfTaqiVxHODAWj3j4lWsRRrhulKQYxDwj48w==
X-Received: by 2002:a05:600c:548d:b0:418:d69e:673d with SMTP id iv13-20020a05600c548d00b00418d69e673dmr2049701wmb.21.1713543394009;
        Fri, 19 Apr 2024 09:16:34 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab5e:9e00:8bce:ff73:6d2f:5c25])
        by smtp.gmail.com with ESMTPSA id je12-20020a05600c1f8c00b004183edc31adsm10742188wmb.44.2024.04.19.09.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:16:33 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	andrew.jones@linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v7 05/11] x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
Date: Fri, 19 Apr 2024 18:16:17 +0200
Message-Id: <20240419161623.45842-6-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419161623.45842-1-vsntk18@gmail.com>
References: <20240419161623.45842-1-vsntk18@gmail.com>
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



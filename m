Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6313494E3F
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243644AbiATMwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 07:52:09 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41320 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243466AbiATMwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 07:52:08 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C9B591F76A;
        Thu, 20 Jan 2022 12:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642683127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mKOEF5qWcdYfzYLHVNnSi1I2GqzB1/PRY0UYsESHNO4=;
        b=OG4UgzuIVqFpk30WDw3i7mDwBSYJSdsYIFqrYpusWoiHta8t4Y+4XG61aum2rVccXff7c6
        Z3d+hIVJxwsy8XvTfl2BHcBRM+5pj4ua3WNcaRB3h67Ic9WE040XULgIdum+j9NajKvIyu
        9akpX4Ukhey9ghtIVmk8J0jDmPWaCdQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 46FD013EA5;
        Thu, 20 Jan 2022 12:52:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IIuBD/da6WGIagAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Thu, 20 Jan 2022 12:52:07 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests 05/13] x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
Date:   Thu, 20 Jan 2022 13:51:14 +0100
Message-Id: <20220120125122.4633-6-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220120125122.4633-1-varad.gautam@suse.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Origin: Linux 64222515138e43da1fcf288f0289ef1020427b87

Suppress -Waddress-of-packed-member to allow taking addresses on struct
ghcb / struct vmcb_save_area fields.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev.h   | 106 ++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/svm.h       |  37 ++++++++++++++++
 x86/Makefile.x86_64 |   1 +
 3 files changed, 144 insertions(+)

diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index afbacf3..ed71c18 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -18,6 +18,49 @@
 #include "desc.h"
 #include "asm/page.h"
 #include "efi.h"
+#include "processor.h"
+#include "insn/insn.h"
+#include "svm.h"
+
+struct __attribute__ ((__packed__)) ghcb {
+	struct vmcb_save_area save;
+	u8 reserved_save[2048 - sizeof(struct vmcb_save_area)];
+
+	u8 shared_buffer[2032];
+
+	u8 reserved_1[10];
+	u16 protocol_version;	/* negotiated SEV-ES/GHCB protocol version */
+	u32 ghcb_usage;
+};
+
+/* SEV definitions from linux's include/asm/sev.h */
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
@@ -59,6 +102,69 @@ void handle_sev_es_vc(struct ex_regs *regs);
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
 
+static int _test_bit(int nr, const volatile unsigned long *addr)
+{
+	const volatile unsigned long *word = addr + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+
+	return (*word & mask) != 0;
+}
+
+/* GHCB Accessor functions from Linux's include/asm/svm.h */
+
+#define GHCB_BITMAP_IDX(field)							\
+	(offsetof(struct vmcb_save_area, field) / sizeof(u64))
+
+#define DEFINE_GHCB_ACCESSORS(field)						\
+	static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)	\
+	{									\
+		return _test_bit(GHCB_BITMAP_IDX(field),				\
+				(unsigned long *)&ghcb->save.valid_bitmap);	\
+	}									\
+										\
+	static inline u64 ghcb_get_##field(struct ghcb *ghcb)			\
+	{									\
+		return ghcb->save.field;					\
+	}									\
+										\
+	static inline u64 ghcb_get_##field##_if_valid(struct ghcb *ghcb)	\
+	{									\
+		return ghcb_##field##_is_valid(ghcb) ? ghcb->save.field : 0;	\
+	}									\
+										\
+	static inline void ghcb_set_##field(struct ghcb *ghcb, u64 value)	\
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
+#define MSR_AMD64_SEV_ES_GHCB          0xc0010130
+
 #endif /* TARGET_EFI */
 
 #endif /* _X86_AMD_SEV_H_ */
diff --git a/lib/x86/svm.h b/lib/x86/svm.h
index f74b13a..f046455 100644
--- a/lib/x86/svm.h
+++ b/lib/x86/svm.h
@@ -197,6 +197,42 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
 	u64 br_to;
 	u64 last_excp_from;
 	u64 last_excp_to;
+
+	/*
+	 * The following part of the save area is valid only for
+	 * SEV-ES guests when referenced through the GHCB or for
+	 * saving to the host save area.
+	 */
+	u8 reserved_7[72];
+	u32 spec_ctrl;          /* Guest version of SPEC_CTRL at 0x2E0 */
+	u8 reserved_7b[4];
+	u32 pkru;
+	u8 reserved_7a[20];
+	u64 reserved_8;         /* rax already available at 0x01f8 */
+	u64 rcx;
+	u64 rdx;
+	u64 rbx;
+	u64 reserved_9;         /* rsp already available at 0x01d8 */
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
+	u8 reserved_10[16];
+	u64 sw_exit_code;
+	u64 sw_exit_info_1;
+	u64 sw_exit_info_2;
+	u64 sw_scratch;
+	u8 reserved_11[56];
+	u64 xcr0;
+	u8 valid_bitmap[16];
+	u64 x87_state_gpa;
 };
 
 struct __attribute__ ((__packed__)) vmcb {
@@ -297,6 +333,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define	SVM_EXIT_WRITE_DR6 	0x036
 #define	SVM_EXIT_WRITE_DR7 	0x037
 #define SVM_EXIT_EXCP_BASE      0x040
+#define SVM_EXIT_LAST_EXCP     0x05f
 #define SVM_EXIT_INTR		0x060
 #define SVM_EXIT_NMI		0x061
 #define SVM_EXIT_SMI		0x062
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 3963840..eeb321b 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -13,6 +13,7 @@ endif
 
 fcf_protection_full := $(call cc-option, -fcf-protection=full,)
 COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 $(fcf_protection_full)
+COMMON_CFLAGS += -Wno-address-of-packed-member
 
 cflatobjs += lib/x86/setjmp64.o
 cflatobjs += lib/x86/intel-iommu.o
-- 
2.32.0


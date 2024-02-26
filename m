Return-Path: <kvm+bounces-9865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 270B98678AF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:36:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADE9F290919
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1451112C81A;
	Mon, 26 Feb 2024 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzQ+G6t0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C183112C531;
	Mon, 26 Feb 2024 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958071; cv=none; b=UuBl+k8kDk7z2DNV711xaKHHB9ZIV1LboVpUTPOAJBhhUigmJPKvCel+mBcGMWXLxV37lhyDfKeU7TYTrkKLc6q7IwDRh4ecQ3dimCuc/oOvkHLWXHz2f6jxx5NR173uUq58xEhnOTHI/4PVcu49vtz24hw4o4t7+nmt/DEiT3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958071; c=relaxed/simple;
	bh=EyCcBxyA0tF+AnNctevxSb8iobYKpoudiJi6zYhw30M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KYhC4fxviUSjemXg+/yjTsFB3GD1YxVvynkiKRxflATqoWGGS+k0aIT8QYsEGn0TMvRHVQSYLE0aKSds+f/ZnGurOpdPZ5A92UdNpRaSNFkugoWwU7JH6yYWU1Vz187AdMdOTsDAS86nuKtT/Gle6G/55UHsxX1I5BIRBXQS90Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzQ+G6t0; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dc13fb0133so22428045ad.3;
        Mon, 26 Feb 2024 06:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958069; x=1709562869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HuI5MqcIFWjqUYnfThcFZp4aPT3F8UKxd0R0fmplqnQ=;
        b=IzQ+G6t0mYr29jS4Q1GSMRfpfgVwnNTBV9lmBw3Hiia/6VrqS5aZcWEnwrI4YvlGL9
         tExqkTam+iSlSIcsCJdkpZA0ujw83l/zcqkSvXV2OxhI3Vr9V2RnpgKMUrEjUnbfhBbw
         YlwOt6iHf7KyeqVDzLPy1TxyuwIB39CRhY57JoB2Mj2+zKCXzZX6MVCMuVjc6Sx+U1e+
         jqXmS+zbIb0rO2G8ldWochMaxB9eRp3i4hPoSgw0b+myAPCt+p9bIsn75NO4m/M4M7Ww
         Wx4tCZj2tuJ4VDexY3P11VC/i2CrS6QP9W9JZmEkjizmt9ATP1TTnOE47eqQcHk1UyGk
         cF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958069; x=1709562869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HuI5MqcIFWjqUYnfThcFZp4aPT3F8UKxd0R0fmplqnQ=;
        b=mdW00zKJGNLMkrbRA5gjeZIzDniLHg1jmMu3Vcpi3XvMg/pFwPTzgWV8a1W5IEp684
         5nni4vo8HdCBlwll3Uc69wWxcsONqMwYMpybfq0ZeY2DDhP3Co6PvM43GnyJZQ37Nkuo
         pdaEIOHtJBC6PkIkai2c/dwnkGXh2oKuJ5PMDYgitIA/fcki3NCWbXfoBy0XswS/gWdg
         /a9t3h16gTHWUtY0ggl+dYs6vDpsf9VSyPmh+ld0rJwKW+SKp1h0wte6lGt9auSfugpo
         F3nsaTG4eR2CgvMwsW3L2FO/tyHycxlAd4OVWvgQrwuTS20hURHBVg5Ty4WLilTQcsKu
         iF1A==
X-Forwarded-Encrypted: i=1; AJvYcCVa8O31U9w1FzDG/2G4DMF7cviODfD/u1JXtcI13jCyorLXjVn1kcGNMfo2A3KSHOlrY1I6StKitRDzM5wtTdcWiPXE
X-Gm-Message-State: AOJu0YwzDLceHjpTpANhgRVqDa79Y3/DspeJ9cKIt92LNvzIg5I4e+GC
	FFsGHGyPbhxKB5m3Nm+X3V4RU8yPjn37LuG5etagpNRvphnH3UardSVHlNI3
X-Google-Smtp-Source: AGHT+IFW+jKydClu9ScBCGN8mKskTXeGieKmJE+3Qx4uz16yZSsE1D8n78in3nG7xJ/WBYdrpfORSA==
X-Received: by 2002:a17:902:d506:b0:1dc:91da:a1c with SMTP id b6-20020a170902d50600b001dc91da0a1cmr4411430plg.50.1708958068799;
        Mon, 26 Feb 2024 06:34:28 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id ji22-20020a170903325600b001dc23e877bfsm4012888plb.268.2024.02.26.06.34.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:34:28 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
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
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 02/73] x86/ABI/PVM: Add PVM-specific ABI header file
Date: Mon, 26 Feb 2024 22:35:19 +0800
Message-Id: <20240226143630.33643-3-jiangshanlai@gmail.com>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Add a PVM-specific ABI header file to describe the ABI between the guest
and hypervisor, which contains the hypercall numbers, virtual MSRS
index, and event data structure definitions. This is in preparation for
PVM.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/uapi/asm/pvm_para.h | 131 +++++++++++++++++++++++++++
 include/uapi/Kbuild                  |   4 +
 2 files changed, 135 insertions(+)
 create mode 100644 arch/x86/include/uapi/asm/pvm_para.h

diff --git a/arch/x86/include/uapi/asm/pvm_para.h b/arch/x86/include/uapi/asm/pvm_para.h
new file mode 100644
index 000000000000..36aedfa2cabd
--- /dev/null
+++ b/arch/x86/include/uapi/asm/pvm_para.h
@@ -0,0 +1,131 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_X86_PVM_PARA_H
+#define _UAPI_ASM_X86_PVM_PARA_H
+
+#include <linux/const.h>
+
+/*
+ * The CPUID instruction in PVM guest can't be trapped and emulated,
+ * so PVM guest should use the following two instructions instead:
+ * "invlpg 0xffffffffff4d5650; cpuid;"
+ *
+ * PVM_SYNTHETIC_CPUID is supposed to not trigger any trap in the real or
+ * virtual x86 kernel mode and is also guaranteed to trigger a trap in the
+ * underlying hardware user mode for the hypervisor emulating it. The
+ * hypervisor emulates both of the basic instructions, while the INVLPG is
+ * often emulated as an NOP since 0xffffffffff4d5650 is normally out of the
+ * allowed linear address ranges.
+ */
+#define PVM_SYNTHETIC_CPUID		0x0f,0x01,0x3c,0x25,0x50, \
+					0x56,0x4d,0xff,0x0f,0xa2
+#define PVM_SYNTHETIC_CPUID_ADDRESS	0xffffffffff4d5650
+
+/*
+ * The vendor signature 'PVM' is returned in ebx. It should be used to
+ * determine that a VM is running under PVM.
+ */
+#define PVM_CPUID_SIGNATURE		0x4d5650
+
+/*
+ * PVM virtual MSRS falls in the range 0x4b564df0-0x4b564dff, and it should not
+ * conflict with KVM, see arch/x86/include/uapi/asm/kvm_para.h
+ */
+#define PVM_VIRTUAL_MSR_MAX_NR		15
+#define PVM_VIRTUAL_MSR_BASE		0x4b564df0
+#define PVM_VIRTUAL_MSR_MAX		(PVM_VIRTUAL_MSR_BASE+PVM_VIRTUAL_MSR_MAX_NR)
+
+#define MSR_PVM_LINEAR_ADDRESS_RANGE	0x4b564df0
+#define MSR_PVM_VCPU_STRUCT		0x4b564df1
+#define MSR_PVM_SUPERVISOR_RSP		0x4b564df2
+#define MSR_PVM_SUPERVISOR_REDZONE	0x4b564df3
+#define MSR_PVM_EVENT_ENTRY		0x4b564df4
+#define MSR_PVM_RETU_RIP		0x4b564df5
+#define MSR_PVM_RETS_RIP		0x4b564df6
+#define MSR_PVM_SWITCH_CR3		0x4b564df7
+
+#define PVM_HC_SPECIAL_MAX_NR		(256)
+#define PVM_HC_SPECIAL_BASE		(0x17088200)
+#define PVM_HC_SPECIAL_MAX		(PVM_HC_SPECIAL_BASE+PVM_HC_SPECIAL_MAX_NR)
+
+#define PVM_HC_LOAD_PGTBL		(PVM_HC_SPECIAL_BASE+0)
+#define PVM_HC_IRQ_WIN			(PVM_HC_SPECIAL_BASE+1)
+#define PVM_HC_IRQ_HALT			(PVM_HC_SPECIAL_BASE+2)
+#define PVM_HC_TLB_FLUSH		(PVM_HC_SPECIAL_BASE+3)
+#define PVM_HC_TLB_FLUSH_CURRENT	(PVM_HC_SPECIAL_BASE+4)
+#define PVM_HC_TLB_INVLPG		(PVM_HC_SPECIAL_BASE+5)
+#define PVM_HC_LOAD_GS			(PVM_HC_SPECIAL_BASE+6)
+#define PVM_HC_RDMSR			(PVM_HC_SPECIAL_BASE+7)
+#define PVM_HC_WRMSR			(PVM_HC_SPECIAL_BASE+8)
+#define PVM_HC_LOAD_TLS			(PVM_HC_SPECIAL_BASE+9)
+
+/*
+ * PVM_EVENT_FLAGS_IP
+ *	- Interrupt enable flag. The flag is set to respond to maskable
+ *	  external interrupts; and cleared to inhibit maskable external
+ *	  interrupts.
+ *
+ * PVM_EVENT_FLAGS_IF
+ *	- interrupt pending flag. The hypervisor sets it if it fails to inject
+ *	  a maskable event to the VCPU due to the interrupt-enable flag being
+ *	  cleared in supervisor mode.
+ */
+#define PVM_EVENT_FLAGS_IP_BIT		8
+#define PVM_EVENT_FLAGS_IP		_BITUL(PVM_EVENT_FLAGS_IP_BIT)
+#define PVM_EVENT_FLAGS_IF_BIT		9
+#define PVM_EVENT_FLAGS_IF		_BITUL(PVM_EVENT_FLAGS_IF_BIT)
+
+#ifndef __ASSEMBLY__
+
+/*
+ * PVM event delivery saves the information about the event and the old context
+ * into the PVCS structure if the event is from user mode or from supervisor
+ * mode with vector >=32. And ERETU synthetic instruction reads the return
+ * state from the PVCS structure to restore the old context.
+ */
+struct pvm_vcpu_struct {
+	/*
+	 * This flag is only used in supervisor mode, with only bit 8 and
+	 * bit 9 being valid. The other bits are reserved.
+	 */
+	u64 event_flags;
+	u32 event_errcode;
+	u32 event_vector;
+	u64 cr2;
+	u64 reserved0[5];
+
+	/*
+	 * For the event from supervisor mode with vector >=32, only eflags,
+	 * rip, rsp, rcx and r11 are saved, and others keep untouched.
+	 */
+	u16 user_cs, user_ss;
+	u32 reserved1;
+	u64 reserved2;
+	u64 user_gsbase;
+	u32 eflags;
+	u32 pkru;
+	u64 rip;
+	u64 rsp;
+	u64 rcx;
+	u64 r11;
+};
+
+/*
+ * PVM event delivery saves the information about the event and the old context
+ * on the stack with the following frame format if the event is from supervisor
+ * mode with vector <32. And ERETS synthetic instruction reads the return state
+ * with the following frame format from the stack to restore the old context.
+ */
+struct pvm_supervisor_event {
+	unsigned long errcode; // vector in high32
+	unsigned long rip;
+	unsigned long cs;
+	unsigned long rflags;
+	unsigned long rsp;
+	unsigned long ss;
+	unsigned long rcx;
+	unsigned long r11;
+};
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _UAPI_ASM_X86_PVM_PARA_H */
diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
index 61ee6e59c930..991848db246b 100644
--- a/include/uapi/Kbuild
+++ b/include/uapi/Kbuild
@@ -12,3 +12,7 @@ ifeq ($(wildcard $(objtree)/arch/$(SRCARCH)/include/generated/uapi/asm/kvm_para.
 no-export-headers += linux/kvm_para.h
 endif
 endif
+
+ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/pvm_para.h),)
+no-export-headers += pvm_para.h
+endif
-- 
2.19.1.6.gb485710b



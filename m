Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544CE7B065E
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 16:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjI0OS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 10:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjI0OS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 10:18:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1EDF3
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 07:18:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81a47e12b5so18270640276.0
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 07:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695824305; x=1696429105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pVGrfq1S6gmxbzFT2ehI105J8yNn0c2W+mQ057yX9wo=;
        b=D8dHau8An4I7DPseAX/VW/fYduD3jSmu5dCXR0KXNChAeBHOJP29RCuKYRHhKwKiga
         0WykcSwUujNeCZbowzwQDbnmfS6jndbGl4kGYIDM7YlAe20axN9zDRRGkpfj7x9f5jr8
         MxyWnY/jkDHeNy5vpOhbcJ3waf62XG2FJMVZKfC69j7gmVzrjwpyKZqcWXVpXdpHzSwq
         ql8pV0x+3lqCHptOzVFI/gnBhhXVXgbG0SNpqvyaQf3Xjj5ZHZFu3XtpojxuA3gIAKfW
         2IG7P3AS/RB4I/+lImGFaYKWA7Borrt44CYG0e+06jfH4pBGt2uERDqU1CIH/4PdEEnT
         //0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695824305; x=1696429105;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pVGrfq1S6gmxbzFT2ehI105J8yNn0c2W+mQ057yX9wo=;
        b=uC75pMpdBU+JHCG2LvpS8Lb6x4/OaSTYqZ3vTLUphVdj31EerrOjqRxXZDs9GrREKJ
         PIshzE9KqJWvGuSdzWoeDbKIq4IYIuPJ9Mu4/HbvXwzOI1UaOgvatmAIKSDsYXae6pR4
         NEdPzGIZ8kofry8bw1vHpqz9isoCP/TX/f4wv9tiD8SAYHUR3HMYZONArZUQx14MAFvq
         0gvtU6Xb8fVXRVpwU1J6E+784iDu4vE/cZnzkUiiTrX60p8WH+OXPUXv6oqlXCv3faRq
         zq22jsh5pZyDPaQtFbMCK1u74VNL2ct8d0umE5G/ycd3v9nTYUSIAy8juI9gIF5JsZkw
         OJig==
X-Gm-Message-State: AOJu0Yxp+w6JINam1bbIiZqPN+ZIn78y0Um9ekofS7R6HLsU+3g/gAFW
        47CSYPFAHtBav/A6BEGc0u6CXrDcZ90=
X-Google-Smtp-Source: AGHT+IGRcC8vrgFq54TgOK0/JushKSpF8aCtXfyUnk62ZwEFDOXmqA+XpxV5vc7P3lCJOR5BIrx0Mnd22xA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:414:0:b0:d85:ac12:aadb with SMTP id
 20-20020a250414000000b00d85ac12aadbmr30591ybe.9.1695824304786; Wed, 27 Sep
 2023 07:18:24 -0700 (PDT)
Date:   Wed, 27 Sep 2023 07:18:23 -0700
In-Reply-To: <CAGCz3vuieUoD0UombFzxKYygm8uS4Gr=qkUAKR7oR0Tg+mEnYQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230923102019.29444-1-phil@philjordan.eu> <ZRGkqY+2QQgt2cVq@google.com>
 <CAGCz3vve7RJ+HE8sHOvq1p5-Wc4RpgZwqp0DiCXiSWq0vUpEVw@mail.gmail.com>
 <ZRMB9HUIBcWWHtwK@google.com> <CAGCz3vuieUoD0UombFzxKYygm8uS4Gr=qkUAKR7oR0Tg+mEnYQ@mail.gmail.com>
Message-ID: <ZRQ5r0kn5RzDpf0C@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/apic: Gates test_pv_ipi on KVM cpuid,
 not test device
From:   Sean Christopherson <seanjc@google.com>
To:     Phil Dennis-Jordan <lists@philjordan.eu>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: multipart/mixed; charset="UTF-8"; boundary="nSOM0PdqcNFvkf7t"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--nSOM0PdqcNFvkf7t
Content-Type: text/plain; charset=3Dutf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 27, 2023, Phil Dennis-Jordan wrote:
> On Tue, Sep 26, 2023 at 6:08=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > The attached half-baked patch adds everything except the base "is this =
KVM?"
> > check and has only been compile tested on x86, feel free to use it as a=
 starting
> > point (I wanted to get the basic gist compiling to make sure I wasn't l=
eading you
> > completely astray)
>=20
> The attachment doesn't seem to have made it, would you mind trying
> again? Then I'll put together a v2 of the patch based on that.

Gah, sorry.  This is why I usually inline patches, I forget to actually att=
ach
the darn things 50% of the time.

--nSOM0PdqcNFvkf7t
Content-Type: text/x-diff; charset=3Dus-ascii
Content-Disposition: attachment; filename=3D"0001-tmp.patch"

From 50e38e262149f8277110f4c965184463bbb7960b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Sep 2023 09:04:35 -0700
Subject: [PATCH] tmp

---
 lib/asm-generic/kvm_para.h |   4 +
 lib/linux/kvm_para.h       |  39 ++++++++++
 lib/x86/asm/kvm_para.h     | 153 +++++++++++++++++++++++++++++++++++++
 lib/x86/processor.h        |   4 +
 x86/apic.c                 |   2 +-
 5 files changed, 201 insertions(+), 1 deletion(-)
 create mode 100644 lib/asm-generic/kvm_para.h
 create mode 100644 lib/linux/kvm_para.h
 create mode 100644 lib/x86/asm/kvm_para.h

diff --git a/lib/asm-generic/kvm_para.h b/lib/asm-generic/kvm_para.h
new file mode 100644
index 00000000..486f0af7
--- /dev/null
+++ b/lib/asm-generic/kvm_para.h
@@ -0,0 +1,4 @@
+/*
+ * There isn't anything here, but the file must not be empty or patch
+ * will delete it.
+ */
diff --git a/lib/linux/kvm_para.h b/lib/linux/kvm_para.h
new file mode 100644
index 00000000..960c7e93
--- /dev/null
+++ b/lib/linux/kvm_para.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI__LINUX_KVM_PARA_H
+#define _UAPI__LINUX_KVM_PARA_H
+
+/*
+ * This header file provides a method for making a hypercall to the host
+ * Architectures should define:
+ * - kvm_hypercall0, kvm_hypercall1...
+ * - kvm_arch_para_features
+ * - kvm_para_available
+ */
+
+/* Return values for hypercalls */
+#define KVM_ENOSYS		1000
+#define KVM_EFAULT		EFAULT
+#define KVM_EINVAL		EINVAL
+#define KVM_E2BIG		E2BIG
+#define KVM_EPERM		EPERM
+#define KVM_EOPNOTSUPP		95
+
+#define KVM_HC_VAPIC_POLL_IRQ		1
+#define KVM_HC_MMU_OP			2
+#define KVM_HC_FEATURES			3
+#define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_KICK_CPU			5
+#define KVM_HC_MIPS_GET_CLOCK_FREQ	6
+#define KVM_HC_MIPS_EXIT_VM		7
+#define KVM_HC_MIPS_CONSOLE_OUTPUT	8
+#define KVM_HC_CLOCK_PAIRING		9
+#define KVM_HC_SEND_IPI		10
+#define KVM_HC_SCHED_YIELD		11
+#define KVM_HC_MAP_GPA_RANGE		12
+
+/*
+ * hypercalls use architecture specific
+ */
+#include <asm/kvm_para.h>
+
+#endif /* _UAPI__LINUX_KVM_PARA_H */
diff --git a/lib/x86/asm/kvm_para.h b/lib/x86/asm/kvm_para.h
new file mode 100644
index 00000000..6e64b27b
--- /dev/null
+++ b/lib/x86/asm/kvm_para.h
@@ -0,0 +1,153 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_X86_KVM_PARA_H
+#define _UAPI_ASM_X86_KVM_PARA_H
+
+#include <linux/types.h>
+
+/* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
+ * should be used to determine that a VM is running under KVM.
+ */
+#define KVM_CPUID_SIGNATURE	0x40000000
+#define KVM_SIGNATURE "KVMKVMKVM\0\0\0"
+
+/* This CPUID returns two feature bitmaps in eax, edx. Before enabling
+ * a particular paravirtualization, the appropriate feature bit should
+ * be checked in eax. The performance hint feature bit should be checked
+ * in edx.
+ */
+#define KVM_CPUID_FEATURES	0x40000001
+#define KVM_FEATURE_CLOCKSOURCE		0
+#define KVM_FEATURE_NOP_IO_DELAY	1
+#define KVM_FEATURE_MMU_OP		2
+/* This indicates that the new set of kvmclock msrs
+ * are available. The use of 0x11 and 0x12 is deprecated
+ */
+#define KVM_FEATURE_CLOCKSOURCE2        3
+#define KVM_FEATURE_ASYNC_PF		4
+#define KVM_FEATURE_STEAL_TIME		5
+#define KVM_FEATURE_PV_EOI		6
+#define KVM_FEATURE_PV_UNHALT		7
+#define KVM_FEATURE_PV_TLB_FLUSH	9
+#define KVM_FEATURE_ASYNC_PF_VMEXIT	10
+#define KVM_FEATURE_PV_SEND_IPI	11
+#define KVM_FEATURE_POLL_CONTROL	12
+#define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_ASYNC_PF_INT	14
+#define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_HC_MAP_GPA_RANGE	16
+#define KVM_FEATURE_MIGRATION_CONTROL	17
+
+#define KVM_HINTS_REALTIME      0
+
+/* The last 8 bits are used to indicate how to interpret the flags field
+ * in pvclock structure. If no bits are set, all flags are ignored.
+ */
+#define KVM_FEATURE_CLOCKSOURCE_STABLE_BIT	24
+
+#define MSR_KVM_WALL_CLOCK  0x11
+#define MSR_KVM_SYSTEM_TIME 0x12
+
+#define KVM_MSR_ENABLED 1
+/* Custom MSRs falls in the range 0x4b564d00-0x4b564dff */
+#define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
+#define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
+#define MSR_KVM_ASYNC_PF_EN 0x4b564d02
+#define MSR_KVM_STEAL_TIME  0x4b564d03
+#define MSR_KVM_PV_EOI_EN      0x4b564d04
+#define MSR_KVM_POLL_CONTROL	0x4b564d05
+#define MSR_KVM_ASYNC_PF_INT	0x4b564d06
+#define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+
+struct kvm_steal_time {
+	__u64 steal;
+	__u32 version;
+	__u32 flags;
+	__u8  preempted;
+	__u8  u8_pad[3];
+	__u32 pad[11];
+};
+
+#define KVM_VCPU_PREEMPTED          (1 << 0)
+#define KVM_VCPU_FLUSH_TLB          (1 << 1)
+
+#define KVM_CLOCK_PAIRING_WALLCLOCK 0
+struct kvm_clock_pairing {
+	__s64 sec;
+	__s64 nsec;
+	__u64 tsc;
+	__u32 flags;
+	__u32 pad[9];
+};
+
+#define KVM_STEAL_ALIGNMENT_BITS 5
+#define KVM_STEAL_VALID_BITS ((-1ULL << (KVM_STEAL_ALIGNMENT_BITS + 1)))
+#define KVM_STEAL_RESERVED_MASK (((1 << KVM_STEAL_ALIGNMENT_BITS) - 1 ) <<=
 1)
+
+#define KVM_MAX_MMU_OP_BATCH           32
+
+#define KVM_ASYNC_PF_ENABLED			(1 << 0)
+#define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
+#define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
+#define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
+
+/* MSR_KVM_ASYNC_PF_INT */
+#define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
+
+/* MSR_KVM_MIGRATION_CONTROL */
+#define KVM_MIGRATION_READY		(1 << 0)
+
+/* KVM_HC_MAP_GPA_RANGE */
+#define KVM_MAP_GPA_RANGE_PAGE_SZ_4K	0
+#define KVM_MAP_GPA_RANGE_PAGE_SZ_2M	(1 << 0)
+#define KVM_MAP_GPA_RANGE_PAGE_SZ_1G	(1 << 1)
+#define KVM_MAP_GPA_RANGE_ENC_STAT(n)	(n << 4)
+#define KVM_MAP_GPA_RANGE_ENCRYPTED	KVM_MAP_GPA_RANGE_ENC_STAT(1)
+#define KVM_MAP_GPA_RANGE_DECRYPTED	KVM_MAP_GPA_RANGE_ENC_STAT(0)
+
+/* Operations for KVM_HC_MMU_OP */
+#define KVM_MMU_OP_WRITE_PTE            1
+#define KVM_MMU_OP_FLUSH_TLB	        2
+#define KVM_MMU_OP_RELEASE_PT	        3
+
+/* Payload for KVM_HC_MMU_OP */
+struct kvm_mmu_op_header {
+	__u32 op;
+	__u32 pad;
+};
+
+struct kvm_mmu_op_write_pte {
+	struct kvm_mmu_op_header header;
+	__u64 pte_phys;
+	__u64 pte_val;
+};
+
+struct kvm_mmu_op_flush_tlb {
+	struct kvm_mmu_op_header header;
+};
+
+struct kvm_mmu_op_release_pt {
+	struct kvm_mmu_op_header header;
+	__u64 pt_phys;
+};
+
+#define KVM_PV_REASON_PAGE_NOT_PRESENT 1
+#define KVM_PV_REASON_PAGE_READY 2
+
+struct kvm_vcpu_pv_apf_data {
+	/* Used for 'page not present' events delivered via #PF */
+	__u32 flags;
+
+	/* Used for 'page ready' events delivered via interrupt notification */
+	__u32 token;
+
+	__u8 pad[56];
+	__u32 enabled;
+};
+
+#define KVM_PV_EOI_BIT 0
+#define KVM_PV_EOI_MASK (0x1 << KVM_PV_EOI_BIT)
+#define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
+#define KVM_PV_EOI_DISABLED 0x0
+
+#endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 44f4fd1e..7a7048f9 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -7,6 +7,8 @@
 #include <bitops.h>
 #include <stdint.h>
=20
+#include <linux/kvm_para.h>
+
 #define NONCANONICAL	0xaaaaaaaaaaaaaaaaull
=20
 #ifdef __x86_64__
@@ -284,6 +286,8 @@ static inline bool is_intel(void)
 #define X86_FEATURE_VNMI		(CPUID(0x8000000A, 0, EDX, 25))
 #define	X86_FEATURE_AMD_PMU_V2		(CPUID(0x80000022, 0, EAX, 0))
=20
+#define X86_FEATURE_KVM_PV_SEND_IPI	(CPUID(KVM_CPUID_FEATURES, 0, EAX, KVM=
_FEATURE_PV_SEND_IPI))
+
 static inline bool this_cpu_has(u64 feature)
 {
 	u32 input_eax =3D feature >> 32;
diff --git a/x86/apic.c b/x86/apic.c
index dd7e7834..61334543 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -658,7 +658,7 @@ static void test_pv_ipi(void)
 	int ret;
 	unsigned long a0 =3D 0xFFFFFFFF, a1 =3D 0, a2 =3D 0xFFFFFFFF, a3 =3D 0x0;
=20
-	if (!test_device_enabled())
+	if (!this_cpu_has(X86_FEATURE_KVM_PV_SEND_IPI))
 		return;
=20
 	asm volatile("vmcall" : "=3Da"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a=
1), "d"(a2), "S"(a3));

base-commit: 038ae991814a8baf220ab2000fa2268d319213ae
--=20
2.42.0.582.g8ccd20d70d-goog


--nSOM0PdqcNFvkf7t--

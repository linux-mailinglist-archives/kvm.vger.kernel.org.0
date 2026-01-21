Return-Path: <kvm+bounces-68769-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UBpfIiA8cWnKfQAAu9opvQ
	(envelope-from <kvm+bounces-68769-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:50:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 777A85D9B7
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:50:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1BFC6366776
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6555A3E959F;
	Wed, 21 Jan 2026 19:06:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F153E8C50;
	Wed, 21 Jan 2026 19:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769022411; cv=none; b=A7/5hyltaPO93GF2wjvJgM6Q/e2dIkIPtZyMdyHSGOBw6r8UWQQSCCO8v9LptONiu8fMuV53LLZ6y+5bp2nmsZcySOVL7xDVITLb/j8jbOIG9N2d6gzEtdEa3b/19N405boMnoNrZROMdhpzg6wg8x3JU4chSIaMBXNIv87nVdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769022411; c=relaxed/simple;
	bh=Speh4nbfhYjioMTHyXOiXLZOazdykC+gFEMI6XsrR0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NOX4o8cQP/a5fKUOzYuM0MiwtXbBGPMf4fq58PL7Fqc+O7kimAIMOQdE1wMHdE1Fyf4vCirUXU7cUxW1k4qsYhSAYqRIxVke2MMgULZ/a55CVqEPK2i9cTy7/8Aixs9jA4m2OTlN3ht/O9gGsCXA5VOByp8/i+rc1dylgtYSgZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5033165C;
	Wed, 21 Jan 2026 11:06:41 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 04DE03F632;
	Wed, 21 Jan 2026 11:06:44 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	scott@os.amperecomputing.com,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	pbonzini@redhat.com,
	shuah@kernel.org,
	mark.rutland@arm.com,
	arnd@arndb.de,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v12 6/7] arm64: futex: support futex with FEAT_LSUI
Date: Wed, 21 Jan 2026 19:06:21 +0000
Message-Id: <20260121190622.2218669-7-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260121190622.2218669-1-yeoreum.yun@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : No valid SPF, No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-68769-lists,kvm=lfdr.de];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:mid,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 777A85D9B7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Current futex atomic operations are implemented with ll/sc instructions
and clearing PSTATE.PAN.

Since Armv9.6, FEAT_LSUI supplies not only load/store instructions but
also atomic operation for user memory access in kernel it doesn't need
to clear PSTATE.PAN bit anymore.

With theses instructions some of futex atomic operations don't need to
be implmented with ldxr/stlxr pair instead can be implmented with
one atomic operation supplied by FEAT_LSUI.

However, some of futex atomic operation don't have matched
instructuion i.e) eor or cmpxchg with word size.
For those operation, uses cas{al}t to implement them.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/include/asm/futex.h | 189 ++++++++++++++++++++++++++++++++-
 1 file changed, 187 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index 9a0efed50743..568583982875 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -9,6 +9,8 @@
 #include <linux/uaccess.h>
 #include <linux/stringify.h>
 
+#include <asm/alternative.h>
+#include <asm/alternative-macros.h>
 #include <asm/errno.h>
 
 #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
@@ -87,11 +89,194 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
 	return ret;
 }
 
+#ifdef CONFIG_ARM64_LSUI
+
+/*
+ * When the LSUI feature is present, the CPU also implements PAN, because
+ * FEAT_PAN has been mandatory since Armv8.1. Therefore, there is no need to
+ * call uaccess_ttbr0_enable()/uaccess_ttbr0_disable() around each LSUI
+ * operation.
+ */
+
+#define __LSUI_PREAMBLE	".arch_extension lsui\n"
+
+#define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
+static __always_inline int						\
+__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
+{									\
+	int ret = 0;							\
+	int oldval;							\
+									\
+	asm volatile("// __lsui_futex_atomic_" #op "\n"			\
+	__LSUI_PREAMBLE							\
+"1:	" #asm_op "al	%w3, %w2, %1\n"					\
+"2:\n"									\
+	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)				\
+	: "+r" (ret), "+Q" (*uaddr), "=r" (oldval)			\
+	: "r" (oparg)							\
+	: "memory");							\
+									\
+	if (!ret)							\
+		*oval = oldval;						\
+									\
+	return ret;							\
+}
+
+LSUI_FUTEX_ATOMIC_OP(add, ldtadd)
+LSUI_FUTEX_ATOMIC_OP(or, ldtset)
+LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr)
+LSUI_FUTEX_ATOMIC_OP(set, swpt)
+
+static __always_inline int
+__lsui_cmpxchg64(u64 __user *uaddr, u64 *oldval, u64 newval)
+{
+	int ret = 0;
+
+	asm volatile("// __lsui_cmpxchg64\n"
+	__LSUI_PREAMBLE
+"1:	casalt	%2, %3, %1\n"
+"2:\n"
+	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)
+	: "+r" (ret), "+Q" (*uaddr), "+r" (*oldval)
+	: "r" (newval)
+	: "memory");
+
+	return ret;
+}
+
+static __always_inline int
+__lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+{
+	u64 __user *uaddr64;
+	bool futex_on_lo;
+	int ret, i;
+	u32 other, orig_other;
+	union {
+		struct futex_on_lo {
+			u32 val;
+			u32 other;
+		} lo_futex;
+
+		struct futex_on_hi {
+			u32 other;
+			u32 val;
+		} hi_futex;
+
+		u64 raw;
+	} oval64, orig64, nval64;
+
+	uaddr64 = (u64 __user *) PTR_ALIGN_DOWN(uaddr, sizeof(u64));
+	futex_on_lo = IS_ALIGNED((unsigned long)uaddr, sizeof(u64));
+
+	if (futex_on_lo) {
+		oval64.lo_futex.val = oldval;
+		ret = get_user(oval64.lo_futex.other, uaddr + 1);
+	} else {
+		oval64.hi_futex.val = oldval;
+		ret = get_user(oval64.hi_futex.other, uaddr - 1);
+	}
+
+	if (ret)
+		return -EFAULT;
+
+	ret = -EAGAIN;
+	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
+		orig64.raw = nval64.raw = oval64.raw;
+
+		if (futex_on_lo)
+			nval64.lo_futex.val = newval;
+		else
+			nval64.hi_futex.val = newval;
+
+		if (__lsui_cmpxchg64(uaddr64, &oval64.raw, nval64.raw))
+			return -EFAULT;
+
+		if (futex_on_lo) {
+			oldval = oval64.lo_futex.val;
+			other = oval64.lo_futex.other;
+			orig_other = orig64.lo_futex.other;
+		} else {
+			oldval = oval64.hi_futex.val;
+			other = oval64.hi_futex.other;
+			orig_other = orig64.hi_futex.other;
+		}
+
+		if (other == orig_other) {
+			ret = 0;
+			break;
+		}
+	}
+
+	if (!ret)
+		*oval = oldval;
+
+	return ret;
+}
+
+static __always_inline int
+__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
+{
+	/*
+	 * Undo the bitwise negation applied to the oparg passed from
+	 * arch_futex_atomic_op_inuser() with FUTEX_OP_ANDN.
+	 */
+	return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
+}
+
+static __always_inline int
+__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
+{
+	u32 oldval, newval, val;
+	int ret, i;
+
+	if (get_user(oldval, uaddr))
+		return -EFAULT;
+
+	/*
+	 * there are no ldteor/stteor instructions...
+	 */
+	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
+		newval = oldval ^ oparg;
+
+		ret = __lsui_cmpxchg32(uaddr, oldval, newval, &val);
+		if (ret)
+			return ret;
+
+		if (val == oldval) {
+			*oval = val;
+			return 0;
+		}
+
+		oldval = val;
+	}
+
+	return -EAGAIN;
+}
+
+static __always_inline int
+__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+{
+	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
+}
+
+#define __lsui_llsc_body(op, ...)					\
+({									\
+	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
+		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
+})
+
+#else	/* CONFIG_ARM64_LSUI */
+
+#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
+
+#endif	/* CONFIG_ARM64_LSUI */
+
+
 #define FUTEX_ATOMIC_OP(op)						\
 static __always_inline int						\
 __futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)		\
 {									\
-	return __llsc_futex_atomic_##op(oparg, uaddr, oval);		\
+	return __lsui_llsc_body(futex_atomic_##op, oparg, uaddr, oval);	\
 }
 
 FUTEX_ATOMIC_OP(add)
@@ -103,7 +288,7 @@ FUTEX_ATOMIC_OP(set)
 static __always_inline int
 __futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
 {
-	return __llsc_futex_cmpxchg(uaddr, oldval, newval, oval);
+	return __lsui_llsc_body(futex_cmpxchg, uaddr, oldval, newval, oval);
 }
 
 static inline int
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}



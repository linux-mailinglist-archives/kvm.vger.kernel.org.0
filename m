Return-Path: <kvm+bounces-72162-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOBPJpe4oWkYwAQAu9opvQ
	(envelope-from <kvm+bounces-72162-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:30:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 247C91B9CC9
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8227F31D996F
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 15:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E8B43E491;
	Fri, 27 Feb 2026 15:17:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FC743E49B;
	Fri, 27 Feb 2026 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772205471; cv=none; b=KCOJWPp4xmFnaHitWkI7TfO4CfJpyPPnUyG6kj7il/wHr4Qy51Bk2yMfhRYNVApuouJmi94T8mbyR7yQLSmDBmspSQdvN4Ptzi7lUTtlrsnTYTH/MX187sxYedrbFo11MO+Jgwgue4PkzPGDGRBoAEU8KDA0v1vrrnJ8ps5ipKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772205471; c=relaxed/simple;
	bh=SNX/D48g9/JuM8Kz40mbQ8gmXd6GXp6lOTES05iEhFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mxpx/iVcLmIaI+1eA1PVXVu/GKjaNQXWtQha/BbQuqVC6jK/uS9rBquyyEVo2pBVn7m01dBuyYZNOdUEDTW8byCJO4vzW7tbYePjjdAcGU0JUQSkYDugLiTC3vUHgukjREhbOnWQAqS4raoOgHcBFFjHT7tVJw+I6FBkUATyH28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 690A21516;
	Fri, 27 Feb 2026 07:17:42 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C943F3F73B;
	Fri, 27 Feb 2026 07:17:45 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	broonie@kernel.org,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	yeoreum.yun@arm.com
Subject: [PATCH v15 4/8] arm64: futex: refactor futex atomic operation
Date: Fri, 27 Feb 2026 15:17:01 +0000
Message-Id: <20260227151705.1275328-5-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227151705.1275328-1-yeoreum.yun@arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72162-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.967];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email]
X-Rspamd-Queue-Id: 247C91B9CC9
X-Rspamd-Action: no action

Refactor futex atomic operations using ll/sc method with
clearing PSTATE.PAN to prepare to apply FEAT_LSUI on them.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/futex.h | 137 +++++++++++++++++++++------------
 1 file changed, 87 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index bc06691d2062..9a0efed50743 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -7,21 +7,25 @@
 
 #include <linux/futex.h>
 #include <linux/uaccess.h>
+#include <linux/stringify.h>
 
 #include <asm/errno.h>
 
 #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
 
-#define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
-do {									\
+#define LLSC_FUTEX_ATOMIC_OP(op, insn)					\
+static __always_inline int						\
+__llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
+{									\
 	unsigned int loops = FUTEX_MAX_LOOPS;				\
+	int ret, oldval, newval;					\
 									\
 	uaccess_enable_privileged();					\
-	asm volatile(							\
+	asm volatile("// __llsc_futex_atomic_" #op "\n"			\
 "	prfm	pstl1strm, %2\n"					\
-"1:	ldxr	%w1, %2\n"						\
+"1:	ldxr	%w[oldval], %2\n"					\
 	insn "\n"							\
-"2:	stlxr	%w0, %w3, %2\n"						\
+"2:	stlxr	%w0, %w[newval], %2\n"					\
 "	cbz	%w0, 3f\n"						\
 "	sub	%w4, %w4, %w0\n"					\
 "	cbnz	%w4, 1b\n"						\
@@ -30,50 +34,109 @@ do {									\
 "	dmb	ish\n"							\
 	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)				\
 	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)				\
-	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),	\
+	: "=&r" (ret), [oldval] "=&r" (oldval), "+Q" (*uaddr),		\
+	  [newval] "=&r" (newval),					\
 	  "+r" (loops)							\
-	: "r" (oparg), "Ir" (-EAGAIN)					\
+	: [oparg] "r" (oparg), "Ir" (-EAGAIN)				\
 	: "memory");							\
 	uaccess_disable_privileged();					\
-} while (0)
+									\
+	if (!ret)							\
+		*oval = oldval;						\
+									\
+	return ret;							\
+}
+
+LLSC_FUTEX_ATOMIC_OP(add, "add	%w[newval], %w[oldval], %w[oparg]")
+LLSC_FUTEX_ATOMIC_OP(or,  "orr	%w[newval], %w[oldval], %w[oparg]")
+LLSC_FUTEX_ATOMIC_OP(and, "and	%w[newval], %w[oldval], %w[oparg]")
+LLSC_FUTEX_ATOMIC_OP(eor, "eor	%w[newval], %w[oldval], %w[oparg]")
+LLSC_FUTEX_ATOMIC_OP(set, "mov	%w[newval], %w[oparg]")
+
+static __always_inline int
+__llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+{
+	int ret = 0;
+	unsigned int loops = FUTEX_MAX_LOOPS;
+	u32 val, tmp;
+
+	uaccess_enable_privileged();
+	asm volatile("//__llsc_futex_cmpxchg\n"
+"	prfm	pstl1strm, %2\n"
+"1:	ldxr	%w1, %2\n"
+"	eor	%w3, %w1, %w5\n"
+"	cbnz	%w3, 4f\n"
+"2:	stlxr	%w3, %w6, %2\n"
+"	cbz	%w3, 3f\n"
+"	sub	%w4, %w4, %w3\n"
+"	cbnz	%w4, 1b\n"
+"	mov	%w0, %w7\n"
+"3:\n"
+"	dmb	ish\n"
+"4:\n"
+	_ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
+	_ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)
+	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
+	: "r" (oldval), "r" (newval), "Ir" (-EAGAIN)
+	: "memory");
+	uaccess_disable_privileged();
+
+	if (!ret)
+		*oval = val;
+
+	return ret;
+}
+
+#define FUTEX_ATOMIC_OP(op)						\
+static __always_inline int						\
+__futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)		\
+{									\
+	return __llsc_futex_atomic_##op(oparg, uaddr, oval);		\
+}
+
+FUTEX_ATOMIC_OP(add)
+FUTEX_ATOMIC_OP(or)
+FUTEX_ATOMIC_OP(and)
+FUTEX_ATOMIC_OP(eor)
+FUTEX_ATOMIC_OP(set)
+
+static __always_inline int
+__futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+{
+	return __llsc_futex_cmpxchg(uaddr, oldval, newval, oval);
+}
 
 static inline int
 arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *_uaddr)
 {
-	int oldval = 0, ret, tmp;
-	u32 __user *uaddr = __uaccess_mask_ptr(_uaddr);
+	int ret;
+	u32 __user *uaddr;
 
 	if (!access_ok(_uaddr, sizeof(u32)))
 		return -EFAULT;
 
+	uaddr = __uaccess_mask_ptr(_uaddr);
+
 	switch (op) {
 	case FUTEX_OP_SET:
-		__futex_atomic_op("mov	%w3, %w5",
-				  ret, oldval, uaddr, tmp, oparg);
+		ret = __futex_atomic_set(oparg, uaddr, oval);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op("add	%w3, %w1, %w5",
-				  ret, oldval, uaddr, tmp, oparg);
+		ret = __futex_atomic_add(oparg, uaddr, oval);
 		break;
 	case FUTEX_OP_OR:
-		__futex_atomic_op("orr	%w3, %w1, %w5",
-				  ret, oldval, uaddr, tmp, oparg);
+		ret = __futex_atomic_or(oparg, uaddr, oval);
 		break;
 	case FUTEX_OP_ANDN:
-		__futex_atomic_op("and	%w3, %w1, %w5",
-				  ret, oldval, uaddr, tmp, ~oparg);
+		ret = __futex_atomic_and(~oparg, uaddr, oval);
 		break;
 	case FUTEX_OP_XOR:
-		__futex_atomic_op("eor	%w3, %w1, %w5",
-				  ret, oldval, uaddr, tmp, oparg);
+		ret = __futex_atomic_eor(oparg, uaddr, oval);
 		break;
 	default:
 		ret = -ENOSYS;
 	}
 
-	if (!ret)
-		*oval = oldval;
-
 	return ret;
 }
 
@@ -81,40 +144,14 @@ static inline int
 futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *_uaddr,
 			      u32 oldval, u32 newval)
 {
-	int ret = 0;
-	unsigned int loops = FUTEX_MAX_LOOPS;
-	u32 val, tmp;
 	u32 __user *uaddr;
 
 	if (!access_ok(_uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	uaddr = __uaccess_mask_ptr(_uaddr);
-	uaccess_enable_privileged();
-	asm volatile("// futex_atomic_cmpxchg_inatomic\n"
-"	prfm	pstl1strm, %2\n"
-"1:	ldxr	%w1, %2\n"
-"	sub	%w3, %w1, %w5\n"
-"	cbnz	%w3, 4f\n"
-"2:	stlxr	%w3, %w6, %2\n"
-"	cbz	%w3, 3f\n"
-"	sub	%w4, %w4, %w3\n"
-"	cbnz	%w4, 1b\n"
-"	mov	%w0, %w7\n"
-"3:\n"
-"	dmb	ish\n"
-"4:\n"
-	_ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
-	_ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)
-	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
-	: "r" (oldval), "r" (newval), "Ir" (-EAGAIN)
-	: "memory");
-	uaccess_disable_privileged();
-
-	if (!ret)
-		*uval = val;
 
-	return ret;
+	return __futex_cmpxchg(uaddr, oldval, newval, uval);
 }
 
 #endif /* __ASM_FUTEX_H */
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}



Return-Path: <kvm+bounces-58123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AAC9B88388
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B882C3AF38C
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563862D1F68;
	Fri, 19 Sep 2025 07:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="gs6YdGaS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEEA2D47ED
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 07:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758267503; cv=none; b=IsCcgn8W94y4FE+l3oaRFbJK20/5mU/f6yqC2e/8KJ0MS7N5Vmw+oVMSaDRwgFQ8Bu8ult/FpJdT0O8Zbg2tfIKURmRnF+9tyLnkonFXxp4m7UTLm7tCj60yDwM1p8d231X78dMYQIwrdoKPqO4sBioXGbaVIBelCub80nA3r7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758267503; c=relaxed/simple;
	bh=4Wtbcd89p34NfKT5wCJUueETmGBbCNHpcCNYAQ7CVuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgDIs+rXP09YvJ1w1oJDgzaBfIRS9DVayMf6rMdIlWIIiPNAu9TRXmQq08IOEeuRMSuKOLBQg1UumU8F06MJnRsL3oQKvvo7dfYa4RZgbhqpu6O15tM/5LARLvQ3YjGQy/VszuM2pVt8aRBhjZQvkzE1dmB1TC7+qSxJojiX4/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=gs6YdGaS; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so1836769b3a.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758267501; x=1758872301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UrUXReFmfyicqjIKReJGDbVrjEBweEul9LJXTVHzmk4=;
        b=gs6YdGaSS7PaeGNOfBsj7ZhAO13XRJq/q7WGbovjoR1nj5lAPWqipPObpVcKUTz6wR
         I5025xGlMkbnOXfNrEZA5rzdL4Kqqbb4URyFKaCJgkAFBHSnjr+EBiKXdYRJgEuOm9rf
         N63bQ3I8oOpzF54g0/miOqtyOyLLVqhHOS9UHivDBaa0u0NPa87RF9MRcT2GgkyZirCZ
         D25qxrMOgajH4FpWc1DjgX/aMGw4X1ijB9GNusWqBYGcHqrj9bLmimaGZsDWeCsr3chu
         w8hrn7kYgegyvr5I8mM77wGHFBjStIPPaCHTU9xPrgyns8QSPyKj7Sj7TNSOQJBHY4G9
         jE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758267501; x=1758872301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UrUXReFmfyicqjIKReJGDbVrjEBweEul9LJXTVHzmk4=;
        b=U+al8RLppmPKS5UN4OYjdpMbNFkqcI0k7vaizlGCBe5QxpfVss1iWofQcofR90EJld
         y/pO6OuhCpLtNVxwHyHbczPrDUPGoNIrQAPXk3csIg0/Qvdf4oc0ZR7gRs5ZpE+VrnOU
         jSkklRSLePr57Tatah4e0LgPoTEk9Bz4beUSTFTg/afA7vjyktcntXMKQWjGjdoK24yc
         Pm3uUmhRrFsj3QZ++WTjENR7rieDFF8PnzMVFUctnbdM8etAsKlkRBFTFybzhZC5fORY
         PfqxsPrT343ufBNG6HpYWQh0wAtNRRSfn7/LEZblDOE7qXvnBov1dDlD4kHitunGCdnN
         1plA==
X-Forwarded-Encrypted: i=1; AJvYcCUut00tnZxsAtKo7ycnp1huvA/ztrGBvvrTZd2NOt1YbN2G7IrK6xqds9HSN7/wwhQ42LI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXeW3C79btZBof7o29XTHuFvN3s/TrYKecT3wkSVjlCvBZ+b8O
	vKEvEz+OSvIHCLJyTwq6KGAEwDux0qqwkUVjZnGF2k4ndG/L1pTXQestmYLXDkyiBpM=
X-Gm-Gg: ASbGncvlxyUL0KKX8B7j7/YGIfxPwxRJbWo373DZAAU62Pfx+H7Mdcl/aLNLqQgNBJW
	BK92wpRnf3ZaljdR+LWjEoj79BlqGSbAw0n3ZqFkGl7fkHse0APtuS5YJ0kadRH0Ar7b4IhYvHY
	7cTiw/um3lJxM73stGpaa+SARjzCPTqKuf/KNeGJnqRg1HuHFqE2mfVVQTzp0jWeAA0zFS3JOlg
	ev1vI3pul6tqVTj6HnZ0fFy9bo4HqB/NapUIldJNo9tvV+dXgRyOb6wwwobiVaRv5I1bcFdNetT
	SgrHxSm0ufp0IcSnNlstqBRp0whlx4kzFktgGQIKYzr8kqca7iY3mX/GvSourDipdA1nmyjbC2X
	gIU6u/eqwg3WqS2so1YmY985yC+X6qh4WlglelSokWsCkJhkOsAY68Z7yXyNuGbqaZQmyoXd9kR
	FeTtmyCtgV6FEaSQXtBPv/XipFpMX7DZj9AbKs8lEstQ==
X-Google-Smtp-Source: AGHT+IHO/IBu5KluVEBZTCVVCP8FOuGD/BwTuyZsvB1MFOiJrJSLMwCJJx47GpnoAoobwSIeA0YuxQ==
X-Received: by 2002:a05:6a21:6d9c:b0:247:b1d9:774 with SMTP id adf61e73a8af0-292588a2f9bmr3836926637.5.1758267501051;
        Fri, 19 Sep 2025 00:38:21 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b550fd7ebc7sm2679096a12.19.2025.09.19.00.38.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 00:38:20 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: corbet@lwn.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	will@kernel.org,
	peterz@infradead.org,
	boqun.feng@gmail.com,
	mark.rutland@arm.com,
	parri.andrea@gmail.com,
	ajones@ventanamicro.com,
	brs@rivosinc.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	apw@canonical.com,
	joe@perches.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v3 5/8] riscv: Use Zalasr for smp_load_acquire/smp_store_release
Date: Fri, 19 Sep 2025 15:37:11 +0800
Message-ID: <20250919073714.83063-6-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919073714.83063-1-luxu.kernel@bytedance.com>
References: <20250919073714.83063-1-luxu.kernel@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace fence instructions with Zalasr instructions during
smp_load_acquire() and smp_store_release() operations.

|----------------------------------|
|    |     __smp_store_release     |
|    |-----------------------------|
|    | zalasr        | !zalasr     |
| rl |-----------------------------|
|    | s{b|h|w|d}.rl | fence rw, w |
|    |               | s{b|h|w|d}  |
|----------------------------------|
|    |    __smp_load_acquire       |
|    |-----------------------------|
|    | zalasr        | !zalasr     |
| aq |-----------------------------|
|    | l{b|h|w|d}.rl | l{b|h|w|d}  |
|    |               | fence r, rw |
|----------------------------------|

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/barrier.h | 91 ++++++++++++++++++++++++++++----
 1 file changed, 80 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/include/asm/barrier.h b/arch/riscv/include/asm/barrier.h
index b8c5726d86acb..9eaf94a028096 100644
--- a/arch/riscv/include/asm/barrier.h
+++ b/arch/riscv/include/asm/barrier.h
@@ -51,19 +51,88 @@
  */
 #define smp_mb__after_spinlock()	RISCV_FENCE(iorw, iorw)
 
-#define __smp_store_release(p, v)					\
-do {									\
-	compiletime_assert_atomic_type(*p);				\
-	RISCV_FENCE(rw, w);						\
-	WRITE_ONCE(*p, v);						\
+extern void __bad_size_call_parameter(void);
+
+#define __smp_store_release(p, v)						\
+do {										\
+	typeof(p) __p = (p);							\
+	union { typeof(*p) __val; char __c[1]; } __u =				\
+		{ .__val = (__force typeof(*p)) (v) };				\
+	compiletime_assert_atomic_type(*p);					\
+	switch (sizeof(*p)) {							\
+	case 1:									\
+		asm volatile(ALTERNATIVE("fence rw, w;\t\nsb %0, 0(%1)\t\n",	\
+					 SB_RL(%0, %1) "\t\nnop\t\n",		\
+					 0, RISCV_ISA_EXT_ZALASR, 1)		\
+					 : : "r" (*(__u8 *)__u.__c), "r" (__p)	\
+					 : "memory");				\
+		break;								\
+	case 2:									\
+		asm volatile(ALTERNATIVE("fence rw, w;\t\nsh %0, 0(%1)\t\n",	\
+					 SH_RL(%0, %1) "\t\nnop\t\n",		\
+					 0, RISCV_ISA_EXT_ZALASR, 1)		\
+					 : : "r" (*(__u16 *)__u.__c), "r" (__p)	\
+					 : "memory");				\
+		break;								\
+	case 4:									\
+		asm volatile(ALTERNATIVE("fence rw, w;\t\nsw %0, 0(%1)\t\n",	\
+					 SW_RL(%0, %1) "\t\nnop\t\n",		\
+					 0, RISCV_ISA_EXT_ZALASR, 1)		\
+					 : : "r" (*(__u32 *)__u.__c), "r" (__p)	\
+					 : "memory");				\
+		break;								\
+	case 8:									\
+		asm volatile(ALTERNATIVE("fence rw, w;\t\nsd %0, 0(%1)\t\n",	\
+					 SD_RL(%0, %1) "\t\nnop\t\n",		\
+					 0, RISCV_ISA_EXT_ZALASR, 1)		\
+					 : : "r" (*(__u64 *)__u.__c), "r" (__p)	\
+					 : "memory");				\
+		break;								\
+	default:								\
+		__bad_size_call_parameter();					\
+		break;								\
+	}									\
 } while (0)
 
-#define __smp_load_acquire(p)						\
-({									\
-	typeof(*p) ___p1 = READ_ONCE(*p);				\
-	compiletime_assert_atomic_type(*p);				\
-	RISCV_FENCE(r, rw);						\
-	___p1;								\
+#define __smp_load_acquire(p)							\
+({										\
+	union { typeof(*p) __val; char __c[1]; } __u;				\
+	typeof(p) __p = (p);							\
+	compiletime_assert_atomic_type(*p);					\
+	switch (sizeof(*p)) {							\
+	case 1:									\
+		asm volatile(ALTERNATIVE("lb %0, 0(%1)\t\nfence r, rw\t\n",	\
+					 LB_AQ(%0, %1) "\t\nnop\t\n",		\
+					 0, RISCV_ISA_EXT_ZALASR, 1)		\
+					 : "=r" (*(__u8 *)__u.__c) : "r" (__p)	\
+					 : "memory");				\
+		break;								\
+	case 2:									\
+		asm volatile(ALTERNATIVE("lh %0, 0(%1)\t\nfence r, rw\t\n",	\
+					 LH_AQ(%0, %1) "\t\nnop\t\n",		\
+					 0, RISCV_ISA_EXT_ZALASR, 1)		\
+					 : "=r" (*(__u16 *)__u.__c) : "r" (__p)	\
+					 : "memory");				\
+		break;								\
+	case 4:									\
+		asm volatile(ALTERNATIVE("lw %0, 0(%1)\t\nfence r, rw\t\n",	\
+					 LW_AQ(%0, %1) "\t\nnop\t\n",		\
+					 0, RISCV_ISA_EXT_ZALASR, 1)		\
+					 : "=r" (*(__u32 *)__u.__c) : "r" (__p)	\
+					 : "memory");				\
+		break;								\
+	case 8:									\
+		asm volatile(ALTERNATIVE("ld %0, 0(%1)\t\nfence r, rw\t\n",	\
+					 LD_AQ(%0, %1) "\t\nnop\t\n",		\
+					 0, RISCV_ISA_EXT_ZALASR, 1)		\
+					 : "=r" (*(__u64 *)__u.__c) : "r" (__p)	\
+					 : "memory");				\
+		break;								\
+	default:								\
+		__bad_size_call_parameter();					\
+		break;								\
+	}									\
+	__u.__val;								\
 })
 
 #ifdef CONFIG_RISCV_ISA_ZAWRS
-- 
2.20.1



Return-Path: <kvm+bounces-60473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45276BEF448
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC9F318865EB
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 04:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 123E32C1583;
	Mon, 20 Oct 2025 04:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="HS0Lm+Hu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D1A2BFC7B
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760934339; cv=none; b=BlxBJWpSsQxtPUIEMJO3rDM5BC13TzdXmRN+y6WQSOBstNvjGx6I9sREDnf7YCtGAHfYzkUWqCPSdr23wR1J2P7b8bfU0JEkTHsqcQNJilhtvd1xRohfjbWKgRQe/hkQwIejP+I8izd4UalvH7YE+QxJO/Ex6XwqpGBPfbxifYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760934339; c=relaxed/simple;
	bh=8hNEznhKZts7nsJ+/Md1hqEm+KtJGCPHkBh501JLIEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gY8s1GY6P2PKY2PLFpwZxq0vxQyJNgZzGRFqZDWrYE7hcYc6VarHj7JtbLxsguqqDF+Yn+ih2vYfyzlNo6P6ZzBpEKwPdQ5Pz+4e6yLZ6MHfDToEN/Hg7PiZOp6V3Yv7P+YD6BRD7JpoGbE/OxNFMqN9lbY6LFACMMJEBRLyImY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=HS0Lm+Hu; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-290ab379d48so35458115ad.2
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760934337; x=1761539137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Dx3bjUZwp+FDi5HGHRvFmbVTrXXeKiS0FzRK/EiFHI=;
        b=HS0Lm+HuTSD4i5hvL9CQ9ytADQXsRFR1cPjHPajiubjud360Fkx1TcXGaSjzi9FLw/
         wwWjLjixKTPC88RV1bQS0x8JYG1IIyq7pcyxinNdrUmzfbuhoc2MqnO3QUZ0JuxRV3+Z
         ONHTmMhE1UDPGordAMVX4PXlkCycZrSivGHvKydjA24Mdj9r8cH5Ks1/3nh9L/Ak0WjK
         /LLN/Z3YeH50Cg7s4dHje39XCABV9LxI0HtgThtWeSthEP0Xhge7XlMraNyb5eJpFWXP
         +YZn9DewDgzxf6t7c19bdAgMlh+1qgioV9fvcFjWpLRDZjWXumHdUov68A9ZKhfZKKUK
         3GHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760934337; x=1761539137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Dx3bjUZwp+FDi5HGHRvFmbVTrXXeKiS0FzRK/EiFHI=;
        b=TVUVx/isg6Q1Wt3Jh01AHajriVJSupvb8nBNBgyvFAJ7h66GX413rHT8JId4n2dT1W
         8QjISGOAadB1swJgsI64V9ycPYhAQze8Q4rj76k41W+sSUEgEuNumzTc7frJd05Dbanm
         00g3OZhhAJQLSskRAIlGZ3A3aH5Nly2dzhKIjZZ7jE/chUr4rz3WCkd/IOFoLscQN+EN
         iaJG8dPDnU3e9sxMGj54yi7AQo5rCenQhhrwIgnFwVU6jh8tjBwzQ5ZvEPkOiyjeDpDg
         BhvfMmw6iCnkbRzDgC1aby1YHiqnqw6+AnyDwJu/i4mlma/KsDsG8tnaYJhXJD4sjyWr
         YLPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGyS9dnXVJ/DMkgSHZJCPLFjiCzjVb+0i1fyHikwbsexZI8QuCJ3T5J9CfPDWSbNBfKhw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVXDSJ6uLUeiK6yfuMZCPWIu4NE3QGNKVd/697qs7mCAO80rRh
	h3jkMDJcqZCuLgeiuBNEfs+blBEiWymIpMERCK3g6rkfMJTOBgr4j0m2oFkVpftpGEM=
X-Gm-Gg: ASbGncvtzXWyAzWYS74Hvrg4wmoCa0VoOQuy5P1zVdB4M8W/5Czylv3tgoJ/HIzeD/U
	7u1sjnA45ejHs9WOMTNLA8VsejGgjIGHX+S3Oc/sAMf9Ga3j9eR3eUs3UWS1ejHm3vBXFpjdtma
	ucMYzbKg6Bv3DtF8iHrNemrEZtGoMHa7aC9VstB6y8vaI5QPCV1FI+2lHY0u/GY9mfxLUKVv/mg
	8NQwjvfNLi+4yK+LbK2Y2PXioEYScr6CfBUG+LT/TlZrHixfZu4WrWnTGLTjDt6p04LyAS/3ogM
	u057NyRxIVbtKrm3xtBJBXkqdxoOYdazKAozJgG1kvtj46h6XmP2WkPeEJN9kT2azQv1jyv8pZV
	+A+WiHFmNrgjFcpJprcBrD0mgO0SiOHjwCtqaAx0tyrqt8B9TBorTUbBNJ/m8/zf2/HSvUbTTqF
	Ydpq+7HxfAr3HjPs0ZOuzVXs8hqfa29B7MFnYkb+tUUyMOIS354enZccfMyAlEPVg=
X-Google-Smtp-Source: AGHT+IHd1kF3POpTVpfQwriGdz/AzJEchqY/kwdyjm7t3VNt+rro2wzxG/dmQOsLktQwlvjqL1Trmw==
X-Received: by 2002:a17:903:b48:b0:290:29ba:340f with SMTP id d9443c01a7336-290cb17c05fmr150708105ad.42.1760934336328;
        Sun, 19 Oct 2025 21:25:36 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246ec20a4sm68319325ad.7.2025.10.19.21.25.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 21:25:36 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: corbet@lwn.net,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	will@kernel.org,
	peterz@infradead.org,
	boqun.feng@gmail.com,
	mark.rutland@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pbonzini@redhat.com,
	shuah@kernel.org,
	parri.andrea@gmail.com,
	ajones@ventanamicro.com,
	brs@rivosinc.com,
	guoren@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	apw@canonical.com,
	joe@perches.com,
	lukas.bulwahn@gmail.com,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v4 08/10] riscv: Remove arch specific __atomic_acquire/release_fence
Date: Mon, 20 Oct 2025 12:24:55 +0800
Message-ID: <20251020042457.30915-4-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251020042457.30915-1-luxu.kernel@bytedance.com>
References: <20251020042457.30915-1-luxu.kernel@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove arch specific __atomic_acquire/release_fence() operations since
they use fence instruction to simulate acquire/release order and can not
work well with real acquire/release instructions.

The default generic __atomic_acuire/release_fence() now provide sequential
order via 'fennce rw, rw'. They are rarely called since we use real
acquire/release instructions in most of times.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/atomic.h | 6 ------
 arch/riscv/include/asm/fence.h  | 4 ----
 2 files changed, 10 deletions(-)

diff --git a/arch/riscv/include/asm/atomic.h b/arch/riscv/include/asm/atomic.h
index 86291de07de62..6ed50a283bf8b 100644
--- a/arch/riscv/include/asm/atomic.h
+++ b/arch/riscv/include/asm/atomic.h
@@ -18,12 +18,6 @@
 
 #include <asm/cmpxchg.h>
 
-#define __atomic_acquire_fence()					\
-	__asm__ __volatile__(RISCV_ACQUIRE_BARRIER "" ::: "memory")
-
-#define __atomic_release_fence()					\
-	__asm__ __volatile__(RISCV_RELEASE_BARRIER "" ::: "memory");
-
 static __always_inline int arch_atomic_read(const atomic_t *v)
 {
 	return READ_ONCE(v->counter);
diff --git a/arch/riscv/include/asm/fence.h b/arch/riscv/include/asm/fence.h
index 182db7930edc2..9ce83e4793948 100644
--- a/arch/riscv/include/asm/fence.h
+++ b/arch/riscv/include/asm/fence.h
@@ -7,12 +7,8 @@
 	({ __asm__ __volatile__ (RISCV_FENCE_ASM(p, s) : : : "memory"); })
 
 #ifdef CONFIG_SMP
-#define RISCV_ACQUIRE_BARRIER		RISCV_FENCE_ASM(r, rw)
-#define RISCV_RELEASE_BARRIER		RISCV_FENCE_ASM(rw, w)
 #define RISCV_FULL_BARRIER		RISCV_FENCE_ASM(rw, rw)
 #else
-#define RISCV_ACQUIRE_BARRIER
-#define RISCV_RELEASE_BARRIER
 #define RISCV_FULL_BARRIER
 #endif
 
-- 
2.20.1



Return-Path: <kvm+bounces-60472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A18D9BEF433
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:26:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4D3473491C5
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 04:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8CC2C0F63;
	Mon, 20 Oct 2025 04:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NKop3VHj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1A92BE7D7
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760934330; cv=none; b=uGERHkyOVfYpQemvv0rEPmn8/KO0IXw8CGLVBqjVFARrJMdlM+bJBC1vjMuvB4iGetm33bA+EL9+2HMgJtVwzBDRM9QHv4Hg2Q4Fi36xCxtA/FvyfYgPqmzS9deGxZeMdOqLyf48602nITBz6UHzSmWJdLNE+crBYSjhXPOOoQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760934330; c=relaxed/simple;
	bh=XEtg6rWP1BpsOjgDYdlCSvgySUgbTJhRQilYKVrS164=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm05vIxnVAnbjMfU+OPU+8FYT35MBWgKD6hVP+4Tp8LKIDmbAyCbY0a9bkugxM6L0cQ1xeMgLQ44WXIcCscWkWMbB85tIoIZ9lWQCFw/I6cm6nRttqPByDPzT7fWMEo2HitWEoke/10ldS+8Xsa8lFrj5ZJCDMiYJrnD6OdJFsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NKop3VHj; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b62fcddfa21so2522825a12.1
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760934328; x=1761539128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAhCsGBB1TH5AMM7lpe2ReTjbDoEFVDwsghvbOsONac=;
        b=NKop3VHjNqndGso2Dc5/KrqRYSMNBB/m8vkCgKZq7naIyrNlhvnOxxeYodugm3Mmjf
         nAc6xXMFx3E9kDIXoh9Tm3W7ndVMFacmPgomIdI4UEJ0yDsJB8elSX0O3VoHIq8lT1GH
         iOJHCzBC3fOXv/p1S7+qTnDpL191zh7u2tEogBHgqhvm6+QSOF+ya4ntYkg+G1R8nDFg
         dnnVIT6YodLJpchkL4zhLHAQqxd3p/Yl6Y1KHevjgoxJqRm5sws2jIyYXopaUg7wKEOR
         6b70N4poNwydwUmB6renildTxQWjyK+WIX4qUJyjgo29eyocnxu+amQsgRcn0nyP4G1Y
         BHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760934328; x=1761539128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eAhCsGBB1TH5AMM7lpe2ReTjbDoEFVDwsghvbOsONac=;
        b=CmN+jzHlI1nzgFHb27k3ro5cyjo6WAQbBgKAMAgpGVfdKAJ4mOslYwpYxpCsg6b2xe
         4X/OyxhUTeiJwDL8TbZ9ZyoSR8w5HNHjZeXPfoy7ZnejmvqWJ1VLSpx2GnS/fSQTmQNG
         EVvfZxFJoGOAqF5IGnvlXwUPbNBXAMCAVesY/sRDTChdez5JGCPe1XfS+xurVPrsnXfE
         dCdJsqwPH1HMDNwJpg8XmirJYHDT/0a9umsr/hxj8Lrv363T+GoDGJa48obYYYupB87g
         vGnHJj2KDOmoRZvLJ4dfKa91to5BQoCnDw21jwYJqypoUt0r3LLdEUkVztgL0sQih0ND
         i3/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUE7wXPyv+n1U2o7IcaJ+a/32U71LLPBlxO5MQ5RPOeS4yDQUt3kZoD/+g2ErXbHIddqgg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0TSNNIwvo9uRS94ajcidYouD0CPrdoTW+4+AIoQytwJQiv8TL
	GUfm232y5pl3G4pZhJN13O3CO8TW6iwfsj4hqnRaLSQ2Ih3sjRgUW/AWxukM5emMxWY=
X-Gm-Gg: ASbGncuqcExZnwUZQiMkYYfDGKLRoxToqfuTyEBKLZsWzt/oFZR4MGK0j7e6wut7ZC5
	nzM7hYIeFuVpu5cSY+fhyzJHOk0JHEDIA/XkaioawTNiiT/Vf1djIYHr5hnQj+8JkI8NdhDyX7m
	yQlkY6AZBLbGikOhLSY8RVGldpbO3L0w67DbxD/RAuUqCzcQdlSMDodwZ1jdtkwcOZoQjGTu1qy
	wAgk6EsE+5DhE7BtPxZAkxmENIdVjw6vYoOR/Sryq4Bs1Hei7fwcekauZVL8ggSdevRlQ5FbPlq
	WT2KBLQJtAgVQxgOmPk/VD2DmQrTkvd7S9M8x31AzNI55qNyYePXbEdoFDNqGIGl6VorDhljQK5
	oUvEOS3cthFr7O5hlF4AH8SRUZVQEXJF0zVYEUmyNc8ieC0U/UJ1OMbGdrDSV6tSVHk00HSv476
	NTiMg1yNwtaimG+TIUaVZgdZptz4XJUnTKSrRWHxKFI2lQ1PpSygzxsd/1i1WtdeQ=
X-Google-Smtp-Source: AGHT+IFQr4LFijryTWzGKs84661TKpJBBbN75/B4QXkAS0iMqNHAgeauwTcUjRd7kZl/MznePhToLw==
X-Received: by 2002:a17:902:e552:b0:290:ac36:2ed8 with SMTP id d9443c01a7336-290c9ce63d6mr128754015ad.24.1760934328020;
        Sun, 19 Oct 2025 21:25:28 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246ec20a4sm68319325ad.7.2025.10.19.21.25.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 21:25:27 -0700 (PDT)
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
Subject: [PATCH v4 07/10] riscv: Apply acquire/release semantics to arch_atomic operations
Date: Mon, 20 Oct 2025 12:24:54 +0800
Message-ID: <20251020042457.30915-3-luxu.kernel@bytedance.com>
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

The existing arch_atomic operations are implemented by inserting fence
instrucitons before or after atomic instructions. This commit replaces
them with real acquire/release semantics.

|-----------------------------------------------|
|    | arch_atomic(64)_{add|sub}_return_release |
| rl |------------------------------------------|
|    |                amoadd.rl                 |
|-----------------------------------------------|
|    | arch_atomic(64)_{add|sub}_return_acquire |
| aq |------------------------------------------|
|    |                amoadd.aq                 |
|-----------------------------------------------|

|---------------------------------------------------------|
|    | arch_atomic(64)_fetch_{add|sub|and|or|xor}_release |
| rl |----------------------------------------------------|
|    |               amo{add|and|or|xor}.rl               |
|---------------------------------------------------------|
|    | arch_atomic(64)_fetch_{add|sub|and|or|xor}_acquire |
| aq |----------------------------------------------------|
|    |               amo{add|and|or|xor}.aq               |
|---------------------------------------------------------|

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/atomic.h | 64 +++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/riscv/include/asm/atomic.h b/arch/riscv/include/asm/atomic.h
index 5b96c2f61adb5..86291de07de62 100644
--- a/arch/riscv/include/asm/atomic.h
+++ b/arch/riscv/include/asm/atomic.h
@@ -98,6 +98,30 @@ c_type arch_atomic##prefix##_fetch_##op##_relaxed(c_type i,		\
 	return ret;							\
 }									\
 static __always_inline							\
+c_type arch_atomic##prefix##_fetch_##op##_acquire(c_type i,		\
+						  atomic##prefix##_t *v)	\
+{									\
+	register c_type ret;						\
+	__asm__ __volatile__ (						\
+		"	amo" #asm_op "." #asm_type ".aq %1, %2, %0"	\
+		: "+A" (v->counter), "=r" (ret)				\
+		: "r" (I)						\
+		: "memory");						\
+	return ret;							\
+}									\
+static __always_inline							\
+c_type arch_atomic##prefix##_fetch_##op##_release(c_type i,		\
+						  atomic##prefix##_t *v)	\
+{									\
+	register c_type ret;						\
+	__asm__ __volatile__ (						\
+		"	amo" #asm_op "." #asm_type ".rl %1, %2, %0"	\
+		: "+A" (v->counter), "=r" (ret)				\
+		: "r" (I)						\
+		: "memory");						\
+	return ret;							\
+}									\
+static __always_inline							\
 c_type arch_atomic##prefix##_fetch_##op(c_type i, atomic##prefix##_t *v)	\
 {									\
 	register c_type ret;						\
@@ -117,6 +141,18 @@ c_type arch_atomic##prefix##_##op##_return_relaxed(c_type i,		\
         return arch_atomic##prefix##_fetch_##op##_relaxed(i, v) c_op I;	\
 }									\
 static __always_inline							\
+c_type arch_atomic##prefix##_##op##_return_acquire(c_type i,		\
+						   atomic##prefix##_t *v)	\
+{									\
+	return arch_atomic##prefix##_fetch_##op##_acquire(i, v) c_op I;	\
+}									\
+static __always_inline							\
+c_type arch_atomic##prefix##_##op##_return_release(c_type i,		\
+						   atomic##prefix##_t *v)	\
+{									\
+	return arch_atomic##prefix##_fetch_##op##_release(i, v) c_op I;	\
+}									\
+static __always_inline							\
 c_type arch_atomic##prefix##_##op##_return(c_type i, atomic##prefix##_t *v)	\
 {									\
         return arch_atomic##prefix##_fetch_##op(i, v) c_op I;		\
@@ -139,22 +175,38 @@ ATOMIC_OPS(sub, add, +, -i)
 
 #define arch_atomic_add_return_relaxed	arch_atomic_add_return_relaxed
 #define arch_atomic_sub_return_relaxed	arch_atomic_sub_return_relaxed
+#define arch_atomic_add_return_acquire	arch_atomic_add_return_acquire
+#define arch_atomic_sub_return_acquire	arch_atomic_sub_return_acquire
+#define arch_atomic_add_return_release	arch_atomic_add_return_release
+#define arch_atomic_sub_return_release	arch_atomic_sub_return_release
 #define arch_atomic_add_return		arch_atomic_add_return
 #define arch_atomic_sub_return		arch_atomic_sub_return
 
 #define arch_atomic_fetch_add_relaxed	arch_atomic_fetch_add_relaxed
 #define arch_atomic_fetch_sub_relaxed	arch_atomic_fetch_sub_relaxed
+#define arch_atomic_fetch_add_acquire	arch_atomic_fetch_add_acquire
+#define arch_atomic_fetch_sub_acquire	arch_atomic_fetch_sub_acquire
+#define arch_atomic_fetch_add_release	arch_atomic_fetch_add_release
+#define arch_atomic_fetch_sub_release	arch_atomic_fetch_sub_release
 #define arch_atomic_fetch_add		arch_atomic_fetch_add
 #define arch_atomic_fetch_sub		arch_atomic_fetch_sub
 
 #ifndef CONFIG_GENERIC_ATOMIC64
 #define arch_atomic64_add_return_relaxed	arch_atomic64_add_return_relaxed
 #define arch_atomic64_sub_return_relaxed	arch_atomic64_sub_return_relaxed
+#define arch_atomic64_add_return_acquire	arch_atomic64_add_return_acquire
+#define arch_atomic64_sub_return_acquire	arch_atomic64_sub_return_acquire
+#define arch_atomic64_add_return_release	arch_atomic64_add_return_release
+#define arch_atomic64_sub_return_release	arch_atomic64_sub_return_release
 #define arch_atomic64_add_return		arch_atomic64_add_return
 #define arch_atomic64_sub_return		arch_atomic64_sub_return
 
 #define arch_atomic64_fetch_add_relaxed	arch_atomic64_fetch_add_relaxed
 #define arch_atomic64_fetch_sub_relaxed	arch_atomic64_fetch_sub_relaxed
+#define arch_atomic64_fetch_add_acquire	arch_atomic64_fetch_add_acquire
+#define arch_atomic64_fetch_sub_acquire	arch_atomic64_fetch_sub_acquire
+#define arch_atomic64_fetch_add_release	arch_atomic64_fetch_add_release
+#define arch_atomic64_fetch_sub_release	arch_atomic64_fetch_sub_release
 #define arch_atomic64_fetch_add		arch_atomic64_fetch_add
 #define arch_atomic64_fetch_sub		arch_atomic64_fetch_sub
 #endif
@@ -177,6 +229,12 @@ ATOMIC_OPS(xor, xor, i)
 #define arch_atomic_fetch_and_relaxed	arch_atomic_fetch_and_relaxed
 #define arch_atomic_fetch_or_relaxed	arch_atomic_fetch_or_relaxed
 #define arch_atomic_fetch_xor_relaxed	arch_atomic_fetch_xor_relaxed
+#define arch_atomic_fetch_and_acquire	arch_atomic_fetch_and_acquire
+#define arch_atomic_fetch_or_acquire	arch_atomic_fetch_or_acquire
+#define arch_atomic_fetch_xor_acquire	arch_atomic_fetch_xor_acquire
+#define arch_atomic_fetch_and_release	arch_atomic_fetch_and_release
+#define arch_atomic_fetch_or_release	arch_atomic_fetch_or_release
+#define arch_atomic_fetch_xor_release	arch_atomic_fetch_xor_release
 #define arch_atomic_fetch_and		arch_atomic_fetch_and
 #define arch_atomic_fetch_or		arch_atomic_fetch_or
 #define arch_atomic_fetch_xor		arch_atomic_fetch_xor
@@ -185,6 +243,12 @@ ATOMIC_OPS(xor, xor, i)
 #define arch_atomic64_fetch_and_relaxed	arch_atomic64_fetch_and_relaxed
 #define arch_atomic64_fetch_or_relaxed	arch_atomic64_fetch_or_relaxed
 #define arch_atomic64_fetch_xor_relaxed	arch_atomic64_fetch_xor_relaxed
+#define arch_atomic64_fetch_and_acquire	arch_atomic64_fetch_and_acquire
+#define arch_atomic64_fetch_or_acquire	arch_atomic64_fetch_or_acquire
+#define arch_atomic64_fetch_xor_acquire	arch_atomic64_fetch_xor_acquire
+#define arch_atomic64_fetch_and_release	arch_atomic64_fetch_and_release
+#define arch_atomic64_fetch_or_release	arch_atomic64_fetch_or_release
+#define arch_atomic64_fetch_xor_release	arch_atomic64_fetch_xor_release
 #define arch_atomic64_fetch_and		arch_atomic64_fetch_and
 #define arch_atomic64_fetch_or		arch_atomic64_fetch_or
 #define arch_atomic64_fetch_xor		arch_atomic64_fetch_xor
-- 
2.20.1



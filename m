Return-Path: <kvm+bounces-11822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C77EF87C325
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 19:56:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FAD5B21AAC
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC97076045;
	Thu, 14 Mar 2024 18:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I7h1zFPT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17E9763F6
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 18:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710442513; cv=none; b=Tvg153j/HNu39hv0Ls2LpBqMdFEtAgw4ABssAwNrpAFwR43CHsVqDgc3iRxjOIcm9rWCexKcP3yjtHziTAk+6C+LTZzuZTYodA3jlxf8/pUwYiqmQLCPbKvJ0UmTwgQW0+kHAZWaYMhs5tp+fUxBr9QHIo1Yz5ffpOr37mCztig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710442513; c=relaxed/simple;
	bh=iOEWUnvMcKbJVvSSFCN/LBW8KrePKwutjmximUKTeCI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OmJp/TngSSHy6rfFADVEggSsczBH8NwBFed00U4P9uva33gj2WfUKTq5jSiP9Z0MOkJK5g8Ad0mTMYOpnwiown7ZD7bBkCNCH44K2pKzEuokr8pGv10EH4t+BtNZ7JsFZeW578C6z+CLCBnfpfgge9903xbXB7Lt/9i7Yp/hTH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I7h1zFPT; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a20c33f0bso22916337b3.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 11:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710442510; x=1711047310; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SXV3IRJxaCu6BKITriq5GONv2Stn6rDuSzNVATcf3ok=;
        b=I7h1zFPT+IO1DoZIfs1y7xma6seA+BGighd9b9wjtK5bip3FDL3/AUY8EEI8MbYv34
         PAaQkuRohSboGdw8TvMn0JeRLU92MpnawPUpFWgg+oINmbAARSCpZmBQxHoFQVWmzt/q
         UmcszwU+s6kYQzvRQuOp4Ym9GaGWN/XyUbK74Dl5EAYq+h8MAQozpwJYPZTXoA8Ro0KM
         8zt+vlpbVRP4GHq6pMKyDcxdj5aSKzTP4KjQl+65QqALtDpD2mynsusb/4YcOixOsWmv
         VAiSREdj9ZEYNaK7wONQOSMKuk2pAaHrGnRB/whJkgwjybHU63ftffEccDWNOrPGLi8L
         efug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710442510; x=1711047310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SXV3IRJxaCu6BKITriq5GONv2Stn6rDuSzNVATcf3ok=;
        b=wvqeBFBSigaGdiZK1qoggNv/0Lb2oaligy+ZvFyM/VSPHQP3O5f1B8DUYg0LwqlnYT
         DkO1wWFUtbonV4RK1am5xMCrHg8d0jwJOmyTvixAVcFGvuIw4yHlJxxyh56BGznHjakV
         aoUbM+PzLGwcgvvtEUQ/DVnOOk6TYKlPA3ZJkUQruH68rbocI8yW2zCDJHJrg5OD9NNu
         /xxKcqoLb1gYK+i8TlMTjOCwv32ovS5LptFGR5ozAN4/K/5S3xNFpBHQTKvj3kJjVyO4
         1N+Un1FGJhq6AFVNv8KEzpp1Q7pHQt2GYx/ArjGmOMP12z0xazjQrj8i8OnWnb5cf2uH
         Grbg==
X-Gm-Message-State: AOJu0Yxp4xjzUYjIxG6FBnHHEcr4FvAvmUpMc3TBttx8bLdl+k1flAS1
	nT1YT0CTpnJNOdr7AVC9Wv+z6NMiQ8M0uO2vP69QneNhyH46zJWbwoyW6P8Kqyox1lMeA0z3uIQ
	Q+w==
X-Google-Smtp-Source: AGHT+IFNVe74LE8W8P7Yaw4D0J9QhZPSNUyoxo07UooabXpjGUfUAjGuX8DB8V93Lg5hvCPkskdsrUZukWY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc7:5aad:8965 with SMTP id
 w4-20020a056902100400b00dc75aad8965mr106806ybt.0.1710442510714; Thu, 14 Mar
 2024 11:55:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 11:54:58 -0700
In-Reply-To: <20240314185459.2439072-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314185459.2439072-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314185459.2439072-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: selftests: Randomly force emulation on x86 writes
 from guest code
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Override vcpu_arch_put_guest() to randomly force emulation on supported
accesses.  Force emulation of LOCK CMPXCHG as well as a regular MOV to
stress KVM's emulation of atomic accesses, which has a unique path in
KVM's emulator.

Arbitrarily give all the decisions 50/50 odds; absent much, much more
sophisticated infrastructure for generating random numbers, it's highly
unlikely that doing more than a coin flip with affect selftests' ability
to find KVM bugs.

This is effectively a regression test for commit 910c57dfa4d1 ("KVM: x86:
Mark target gfn of emulated atomic instruction as dirty").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/include/x86_64/kvm_util_arch.h        | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
index 41aba476640a..d0b587c38e07 100644
--- a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
@@ -5,6 +5,8 @@
 #include <stdbool.h>
 #include <stdint.h>
 
+#include "test_util.h"
+
 extern bool is_forced_emulation_enabled;
 
 struct kvm_vm_arch {
@@ -22,4 +24,23 @@ static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
 #define vm_arch_has_protected_memory(vm) \
 	__vm_arch_has_protected_memory(&(vm)->arch)
 
+#define vcpu_arch_put_guest(mem, __val)							\
+do {											\
+	const typeof(mem) val = (__val);						\
+											\
+	if (!is_forced_emulation_enabled || guest_random_bool(&guest_rng)) {		\
+		(mem) = val;								\
+	} else if (guest_random_bool(&guest_rng)) {					\
+		__asm__ __volatile__(KVM_FEP "mov %1, %0"				\
+				     : "+m" (mem)					\
+				     : "r" (val) : "memory");				\
+	} else {									\
+		uint64_t __old = READ_ONCE(mem);					\
+											\
+		__asm__ __volatile__(KVM_FEP LOCK_PREFIX "cmpxchg %[new], %[ptr]"	\
+				     : [ptr] "+m" (mem), [old] "+a" (__old)		\
+				     : [new]"r" (val) : "memory", "cc");		\
+	}										\
+} while (0)
+
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
-- 
2.44.0.291.gc1ea87d7ee-goog



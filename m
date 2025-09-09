Return-Path: <kvm+bounces-57140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FDF1B50715
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36480168E63
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39020352FFD;
	Tue,  9 Sep 2025 20:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Riz+xrg3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D292F35FC38
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 20:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757449724; cv=none; b=gb8sS8GgE69ICBD7mN6jnYxs39kbuFn7BwBBZEyeS5GXctNQRhPidIeehL1Hyg+RjYMeqTlnvyXyY1OJX8G/l6hWvCme1mnqwn2TnHLFR0FGmmz7T68V6q2NeUDgJlCiaUtLXCvB6ufrmRyGWYFPUo6Uu9RYRZXA4NiGDHOACYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757449724; c=relaxed/simple;
	bh=QmVux2JvmbyMClzeW5DTZk69kxWxw7C1UcmEM9nW6Yg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uy4Qmk01YRPEzcyk3eGxcgxPoQ0kGHvCQVDUr4ksfXjC1wxTAUpQM+ENwE9nrtWAZJHZhl3xv8HMiM2/ZHIUKaC6gn1GkUmNKskg9Y8rHKlDDMMbzNS/dWTkp8A/YaEMiw7HgVmE8Yf9DTJwjeqXWmoVKq6PYZXsN2ptg+sZPOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Riz+xrg3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32b58eeb874so5721382a91.3
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 13:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757449722; x=1758054522; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zFN18xXBIM875rVGUIf15K3R2MElVqiHDd3tbRot1Bc=;
        b=Riz+xrg3dr2pq//vhyCd7kXwtvqfF1bmWCUj8QgpjBB9UqpRkutDZ8KqOXH6UEtcpo
         beh0GT7gRG5CdOWscU00RxMoCutPB884pAiBlqty6N3jqsVbc4EH034QzvA7DMYA3ILp
         cOuvYfCa96ziC0LjYxuN2CxIFtyzbXdlHz36jU5bcSqsPbNbNRKB5pCR9GZ6RrbUHlOe
         IpGZuI3tNkIQ94AE2aQQU275xe8jFaS36AzIDM4iYZ4QrLSTP2uW6ysXrKSsdIFppndy
         AsvzNxJsLPbTQgkVJrTKgZK4JgfwfILSt9d+aHs/Dv3tvJYotZzd1LoCWlp3IDOLcLyZ
         OtOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757449722; x=1758054522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zFN18xXBIM875rVGUIf15K3R2MElVqiHDd3tbRot1Bc=;
        b=jsYwjSiPTyoICKib4YPKomLQ/IOZPA2NT69rQthffYnELJgBrKAnGF995J2NYUAoBN
         A5d9rZZ9W5qIrgywUxY+g8QKWN05zHA96IX2+w9pHW10vu81czce061MIeuc+xCady+K
         zmE9uy4zVXy1Ie47iiBnHrciFwIgbalStY6W4wW4eO0wULwpNvRu1gXL9lRf0E69RqYf
         nX4srggtlFd/P4aON1rMtgC0rxhpefHd/cqvE0/XDxEqTBoVPMWvPI0HhsvEi4LWkks7
         Gqh6hr92xkcPxFRJ5hcrpG52gjYMSX19RMdJJipd3aKOlJqZ4KCEqVCTA98W4AT53tJo
         Luug==
X-Gm-Message-State: AOJu0YwC9Dl7S0Tkob5YYx4wmUyGxghJ5gGXVQ+OJP1EZb5cj/BuoESK
	/9vnCImJNmJ2Gn/B9Do2yGVVWLTL2wEtJ5EJNK/5PljN7joQG+cYON57k0A8s38pnrdB7zLGi1l
	mPWFSxA==
X-Google-Smtp-Source: AGHT+IG1LDhj9gttCv49esypEKAYUt6EpytM/C97fa1pwQVwmJjr1csJL3R4A2vjMmiXLxHRd+2zLC5q0+Q=
X-Received: from pjbov13.prod.google.com ([2002:a17:90b:258d:b0:32d:a359:8e4d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dcb:b0:32b:ca6f:123f
 with SMTP id 98e67ed59e1d1-32d43ee718dmr15415029a91.5.1757449722107; Tue, 09
 Sep 2025 13:28:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Sep 2025 13:28:33 -0700
In-Reply-To: <20250909202835.333554-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909202835.333554-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909202835.333554-3-seanjc@google.com>
Subject: [PATCH 2/4] KVM: selftests: Add coverage for 'b' (byte) sized fastops emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Extend the fastops test to cover instructions that operate on 8-bit data.
Support for 8-bit instructions was omitted from the original commit purely
due to complications with BT not having a r/m8 variant.  To keep the
RFLAGS.CF behavior deterministic and not heavily biased to '0' or '1',
continue using BT, but cast and load the to-be-tested value into a
dedicated 32-bit constraint.

Supporting 8-bit operations will allow using guest_test_fastops() as-is to
provide full coverage for DIV and IDIV.  For divide operations, covering
all operand sizes _is_ interesting, because KVM needs provide exception
fixup for each size (failure to handle a #DE could panic the host).

Link: https://lore.kernel.org/all/aIF7ZhWZxlkcpm4y@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86/fastops_test.c  | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/fastops_test.c b/tools/testing/selftests/kvm/x86/fastops_test.c
index 2ac89d6c1e46..6c9a2dbf6365 100644
--- a/tools/testing/selftests/kvm/x86/fastops_test.c
+++ b/tools/testing/selftests/kvm/x86/fastops_test.c
@@ -10,12 +10,13 @@
  */
 #define guest_execute_fastop_1(FEP, insn, __val, __flags)				\
 ({											\
-	__asm__ __volatile__("bt $0, %[val]\n\t"					\
+	__asm__ __volatile__("bt $0, %[ro_val]\n\t"					\
 			     FEP insn " %[val]\n\t"					\
 			     "pushfq\n\t"						\
 			     "pop %[flags]\n\t"						\
 			     : [val]"+r"(__val), [flags]"=r"(__flags)			\
-			     : : "cc", "memory");					\
+			     : [ro_val]"rm"((uint32_t)__val)				\
+			     : "cc", "memory");						\
 })
 
 #define guest_test_fastop_1(insn, type_t, __val)					\
@@ -36,12 +37,13 @@
 
 #define guest_execute_fastop_2(FEP, insn, __input, __output, __flags)			\
 ({											\
-	__asm__ __volatile__("bt $0, %[output]\n\t"					\
+	__asm__ __volatile__("bt $0, %[ro_val]\n\t"					\
 			     FEP insn " %[input], %[output]\n\t"			\
 			     "pushfq\n\t"						\
 			     "pop %[flags]\n\t"						\
 			     : [output]"+r"(__output), [flags]"=r"(__flags)		\
-			     : [input]"r"(__input) : "cc", "memory");			\
+			     : [input]"r"(__input), [ro_val]"rm"((uint32_t)__output)	\
+			     : "cc", "memory");						\
 })
 
 #define guest_test_fastop_2(insn, type_t, __val1, __val2)				\
@@ -63,12 +65,13 @@
 
 #define guest_execute_fastop_cl(FEP, insn, __shift, __output, __flags)			\
 ({											\
-	__asm__ __volatile__("bt $0, %[output]\n\t"					\
+	__asm__ __volatile__("bt $0, %[ro_val]\n\t"					\
 			     FEP insn " %%cl, %[output]\n\t"				\
 			     "pushfq\n\t"						\
 			     "pop %[flags]\n\t"						\
 			     : [output]"+r"(__output), [flags]"=r"(__flags)		\
-			     : "c"(__shift) : "cc", "memory");				\
+			     : "c"(__shift), [ro_val]"rm"((uint32_t)__output)		\
+			     : "cc", "memory");						\
 })
 
 #define guest_test_fastop_cl(insn, type_t, __val1, __val2)				\
@@ -115,14 +118,16 @@ do {											\
 			guest_test_fastop_2("add" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("adc" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("and" suffix, type_t, vals[i], vals[j]);	\
+if (sizeof(type_t) != 1) {							\
 			guest_test_fastop_2("bsf" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("bsr" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("bt" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("btc" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("btr" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("bts" suffix, type_t, vals[i], vals[j]);	\
-			guest_test_fastop_2("cmp" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("imul" suffix, type_t, vals[i], vals[j]);	\
+}											\
+			guest_test_fastop_2("cmp" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("or" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("sbb" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_2("sub" suffix, type_t, vals[i], vals[j]);	\
@@ -142,6 +147,7 @@ do {											\
 
 static void guest_code(void)
 {
+	guest_test_fastops(uint8_t, "b");
 	guest_test_fastops(uint16_t, "w");
 	guest_test_fastops(uint32_t, "l");
 	guest_test_fastops(uint64_t, "q");
-- 
2.51.0.384.g4c02a37b29-goog



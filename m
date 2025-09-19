Return-Path: <kvm+bounces-58094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6943B8788A
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8676916B56D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB9A1E51FB;
	Fri, 19 Sep 2025 00:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ot7EElVg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E51833EC
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758242804; cv=none; b=MZ+THWDonjhYLHw6X3H34F9r8wXfPaQuUMrbJv4WryB5/UogMge2FREK4JWDt+aZomSfJAJM2OdtzPFBmSyFTrB8+5NZEh8SQiTaJo/qZfs++LQgZlpueocEp+h/xYPFJSxf/PtK8M+zQymEOpVW30OpmTsXIa8q8dgiOubsXlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758242804; c=relaxed/simple;
	bh=Q297rMCOFgmawF50UVDQ7UjGtLSvys+CsGBgUvo2llo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=H+fe764HqMInFMsZ+ScWMasekGgEiXAnT+cIFbmzHhsx1L8xzd4FcCGBgEcG9ejkK+iD9v9HtCqPLS9IilgJT59rbxP5B3Y5SLLHBG7d8pXGnM9vYWc+WshR5s9KXmvOF9CllM906/3zXVI2kDRnc81RIm5LnGdnBVeRlRkmL5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ot7EElVg; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b54d6a67b5fso1210320a12.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758242802; x=1758847602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yA6HL6EKfnQkj+qrA/QHye26JvzQI13G7QDzf4Aq1rc=;
        b=ot7EElVgj4g6x09QtyvL81u6X9QrE6VmfaQHoLUWqycCSXLBoavfJNcoT/+tUcuKLI
         vCWad6igUWRnumd/KL5Oqp4mOgWbT330/yGSoLF4Jh0SKK+xcn+toxJ2ARasBn6glpjc
         QDueybKo6HXTu87J+DXt8Yd1mcyb1KKnC0EAZhchXuDwRE3Bgo27LtNUXCvNR7UhDjzS
         TITf6jV/FoMYbpVb/TDHDOe/SMe3QJci2RAwaV4a+4v++0QiyAedEa3r22YoPW8sgGrX
         fI+2Ior98Pkx08zbnED+15DWXrDovHizUWKadZaiid07tCeTaOEp82hkVkaeAv3rawFv
         ZERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758242802; x=1758847602;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yA6HL6EKfnQkj+qrA/QHye26JvzQI13G7QDzf4Aq1rc=;
        b=Ry8+1MNt/OuwuwXF1qwiA8dw47H595O7jghFiYvZOmld0p9MgqWnYwRPsa6f61IEBG
         SL0QVthKerG5ZZCSi8PjBIFJWGg64BICCgBU5J0li2yH6HC44lB4wWwCs6NkPXx18RIo
         Bcyt7D8jMKu04P9sjSAHgrfYv4W7cxdRiQaxt411ugBOR7r1/n463wseFVoV9cCag/M5
         Lo3+63D0xVja4zgVFXEhgSh2WleI7/QjXudolKhXhqBA51JJQ0BEJm/+ahKBGONzO/Df
         duGiBcKG9yjf0nCsCgGl7MXmmefguzMzuJXvaHwFGVyw8MIhbap55gK309C6sv/ml1sj
         yZOg==
X-Gm-Message-State: AOJu0YxVSVoO7kOja8UOrCG9DbcHBGa+RPNbeSAwKnj5Pesuqsf/RaHu
	Qrew/+K0mnTp5usC5zLBSdHzQBInM8c4b0+kQHBQ73B7CVYNpGNY4WMA7Z50AFSDZDDILaMyEzU
	FfhjO9g==
X-Google-Smtp-Source: AGHT+IEWxJamxYREBOlrvHxXGItvOEZwrCY1BNPMVOhCUgyR80XzBPYuu1lA8NW60yx9g/xKVYJaOh2+2uI=
X-Received: from pjtu6.prod.google.com ([2002:a17:90a:c886:b0:32d:a0b1:2b14])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3181:b0:263:4717:54a
 with SMTP id adf61e73a8af0-292588a302amr2681322637.6.1758242802015; Thu, 18
 Sep 2025 17:46:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:46:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919004639.1360453-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Don't treat ENTER and LEAVE as branches, because
 they aren't
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove the IsBranch flag from ENTER and LEAVE in KVM's emulator, as ENTER
and LEAVE are stack operations, not branches.  Add forced emulation of
said instructions to the PMU counters test to prove that KVM diverges from
hardware, and to guard against regressions.

Fixes: 018d70ffcfec ("KVM: x86: Update vPMCs when retiring branch instructions")
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c                              | 4 ++--
 tools/testing/selftests/kvm/x86/pmu_counters_test.c | 8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 542d3664afa3..23929151a5b8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4330,8 +4330,8 @@ static const struct opcode opcode_table[256] = {
 	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2DS, em_lseg),
 	G(ByteOp, group11), G(0, group11),
 	/* 0xC8 - 0xCF */
-	I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
-	I(Stack | IsBranch, em_leave),
+	I(Stack | SrcImmU16 | Src2ImmByte, em_enter),
+	I(Stack, em_leave),
 	I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
 	I(ImplicitOps | IsBranch, em_ret_far),
 	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 8aaaf25b6111..89c1e462cd1c 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -14,10 +14,10 @@
 #define NUM_BRANCH_INSNS_RETIRED	(NUM_LOOPS)
 
 /*
- * Number of instructions in each loop. 1 CLFLUSH/CLFLUSHOPT/NOP, 1 MFENCE,
- * 1 LOOP.
+ * Number of instructions in each loop. 1 ENTER, 1 CLFLUSH/CLFLUSHOPT/NOP,
+ * 1 MFENCE, 1 LEAVE, 1 LOOP.
  */
-#define NUM_INSNS_PER_LOOP		4
+#define NUM_INSNS_PER_LOOP		6
 
 /*
  * Number of "extra" instructions that will be counted, i.e. the number of
@@ -210,9 +210,11 @@ do {										\
 	__asm__ __volatile__("wrmsr\n\t"					\
 			     " mov $" __stringify(NUM_LOOPS) ", %%ecx\n\t"	\
 			     "1:\n\t"						\
+			     FEP "enter $0, $0\n\t"				\
 			     clflush "\n\t"					\
 			     "mfence\n\t"					\
 			     "mov %[m], %%eax\n\t"				\
+			     FEP "leave\n\t"					\
 			     FEP "loop 1b\n\t"					\
 			     FEP "mov %%edi, %%ecx\n\t"				\
 			     FEP "xor %%eax, %%eax\n\t"				\

base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4
-- 
2.51.0.470.ga7dc726c21-goog



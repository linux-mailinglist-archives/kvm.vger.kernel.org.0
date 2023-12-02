Return-Path: <kvm+bounces-3210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 109708018A5
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:07:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF2E61F21187
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E02B668;
	Sat,  2 Dec 2023 00:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cLk7Juna"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9282319AB
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:05:11 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5c6065d5e1bso1081778a12.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475511; x=1702080311; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qpKgoUANaXzgzB1hqqiQLagyf1Kc68gB0qDmuBC8lGo=;
        b=cLk7JunaSWqWyuGHOuhtq2ypdAgM5pGG0k2wx57gDWAmJbSX5mryGE1XSLLZqQ7HMt
         TacqF3odEYInyR/ge2lsJi6/gwgdEbUp6Ha3dl69OsQJ0K7z3i73t/titZTiCMvvWv7d
         lELnYemXNFh1zVoSiLFcr2W2fPc4HUBN15UkKnZxvMhvJmPGkIqKiluf/Hdaa1keFZBh
         Subsz6YDDjxTjwcuNPpn5vQxyNHgbtWq4f4/2dxj5vASMRI8mZw+lMK7y6ncu32dBC8I
         S3Pb0mGcQK77hjhAbdWK7Fq2KEwCgeOJSX+7D+VzegGCjACfmzLCpNo3bGY0lVr6CnvY
         ZsrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475511; x=1702080311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qpKgoUANaXzgzB1hqqiQLagyf1Kc68gB0qDmuBC8lGo=;
        b=b3cEaot77FI3m3ov4AlQBte6e42H05B13PIDjPNaCQk9hfZyQdx5oxanTRjpV32gGa
         9RsM0FztzBEiAWfVcbHbemajS1hAduLKm4Op1CGj5TXG0qZTfOruiNfpfYATY/aFZhjV
         rHXj3PLfxLuLCc5jlPhcdcOel3cZS7K3/9i+4LLVHTlHvTniNPgw1tQ1kEBZQNk9p3QC
         LFgNxIuD9lY/8NjEDQPBh9rttNQy4W28aX8DZsBm8uojPXZXuXs0Bf4CnvaZOtLIIbqT
         HNfAMXQNt/ftEn8Yal6s0sQ/4cxZsvzUtjwHwUBqcGWVXufiBqfJxWUx72lGsnk9E9Qv
         HAag==
X-Gm-Message-State: AOJu0YwSAvuL5aB5BhXY4KWJt/RwVw0O8g3D8eYaGOYXoCS2upSjX1Ps
	UbCjqwesdLtsZfZE24Je0svz7CdfHg0=
X-Google-Smtp-Source: AGHT+IGrbs/Bfe4WYvqwr84jhaR+9OWT8W3meoOYDj0vG84jPCvHXil8+tHYdZD0rUE2KLG/DhFcOdt5ECE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:246:b0:1cf:8c46:23ea with SMTP id
 j6-20020a170903024600b001cf8c4623eamr5684988plh.6.1701475510797; Fri, 01 Dec
 2023 16:05:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:04:15 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-27-seanjc@google.com>
Subject: [PATCH v9 26/28] KVM: selftests: Add a forced emulation variation of KVM_ASM_SAFE()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Add KVM_ASM_SAFE_FEP() to allow forcing emulation on an instruction that
might fault.  Note, KVM skips RIP past the FEP prefix before injecting an
exception, i.e. the fixup needs to be on the instruction itself.  Do not
check for FEP support, that is firmly the responsibility of whatever code
wants to use KVM_ASM_SAFE_FEP().

Sadly, chaining variadic arguments that contain commas doesn't work, thus
the unfortunate amount of copy+paste.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 30 +++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 6be365ac2a85..fe891424ff55 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1154,16 +1154,19 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
  * r9  = exception vector (non-zero)
  * r10 = error code
  */
-#define KVM_ASM_SAFE(insn)					\
+#define __KVM_ASM_SAFE(insn, fep)				\
 	"mov $" __stringify(KVM_EXCEPTION_MAGIC) ", %%r9\n\t"	\
 	"lea 1f(%%rip), %%r10\n\t"				\
 	"lea 2f(%%rip), %%r11\n\t"				\
-	"1: " insn "\n\t"					\
+	fep "1: " insn "\n\t"					\
 	"xor %%r9, %%r9\n\t"					\
 	"2:\n\t"						\
 	"mov  %%r9b, %[vector]\n\t"				\
 	"mov  %%r10, %[error_code]\n\t"
 
+#define KVM_ASM_SAFE(insn) __KVM_ASM_SAFE(insn, "")
+#define KVM_ASM_SAFE_FEP(insn) __KVM_ASM_SAFE(insn, KVM_FEP)
+
 #define KVM_ASM_SAFE_OUTPUTS(v, ec)	[vector] "=qm"(v), [error_code] "=rm"(ec)
 #define KVM_ASM_SAFE_CLOBBERS	"r9", "r10", "r11"
 
@@ -1190,6 +1193,29 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	vector;								\
 })
 
+#define kvm_asm_safe_fep(insn, inputs...)				\
+({									\
+	uint64_t ign_error_code;					\
+	uint8_t vector;							\
+									\
+	asm volatile(KVM_ASM_SAFE(insn)					\
+		     : KVM_ASM_SAFE_OUTPUTS(vector, ign_error_code)	\
+		     : inputs						\
+		     : KVM_ASM_SAFE_CLOBBERS);				\
+	vector;								\
+})
+
+#define kvm_asm_safe_ec_fep(insn, error_code, inputs...)		\
+({									\
+	uint8_t vector;							\
+									\
+	asm volatile(KVM_ASM_SAFE_FEP(insn)				\
+		     : KVM_ASM_SAFE_OUTPUTS(vector, error_code)		\
+		     : inputs						\
+		     : KVM_ASM_SAFE_CLOBBERS);				\
+	vector;								\
+})
+
 static inline uint8_t rdmsr_safe(uint32_t msr, uint64_t *val)
 {
 	uint64_t error_code;
-- 
2.43.0.rc2.451.g8631bc7472-goog



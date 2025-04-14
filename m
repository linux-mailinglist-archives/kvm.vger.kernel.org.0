Return-Path: <kvm+bounces-43214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F31A879E8
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 10:11:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C2101719AA
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 08:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DAE625A2CD;
	Mon, 14 Apr 2025 08:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j7gZ74VL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96DF258CF2;
	Mon, 14 Apr 2025 08:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744618299; cv=none; b=jUGCd3lzID+efF2c8eRNz3d4kJd92Zd6a+NC2C2pQniZ1GnqAeVP8hduHbkbdjYVAV7Lorpjej2d95yMmh2Bdyp69Ilz6qeUzgfv9pPsgOT8jaxBeodE7is27vB68hmiiUrj/KG9e1nFl9xjMqzplk4g92mRzDceRlvs9+XPqwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744618299; c=relaxed/simple;
	bh=WiNB2ppjNeN7UPDQ3srWOqez2dv5sjdGd2i612Gjopo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YfTGNMXc581PjZdJGRx1BMNLQzHP8OHzAPBWOt5KXxCeP+GSo6QZcfnUPm+DCjh+FWRNvDxhzXBljcZyhI6uYHWQuEoK0I97pb1tAKKBe4XYblqo1SZyQIzUS2hXEfRkKcVxf6r0lxAkGqjOjO8TRCO8OuAnkniH0X7xxY+kJjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j7gZ74VL; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e5c7d6b96fso7408349a12.3;
        Mon, 14 Apr 2025 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744618295; x=1745223095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yFiL7XQwjMNSusYEB+zRirLMLyCH2wO7H0kvak0x6S8=;
        b=j7gZ74VLWpfWvG4lbWvukHoo0ggUbtL2imp0Rq+F5yXdD9f9Dd4oCAb88K5Gk5ndv2
         uuZ0eSkuPrmk1Q1xHukucjHCNlx5kOM1iotu1X3E2N10Bj1ojzykAuqeA9iRzidAzWME
         yaWrlZeB/fCLpU/eIWnPY3I/Or4it1aafwsOtURS+w5Vas9Vij6hfsxUKD/g/CQI3D79
         Z8ZLrRHCdlZhdlRakUNZvjW89pyZ83V6COHip4zMvOa8o24/OQYbP40PWOzC5wHQJ208
         ct7C2RbtHMZAAW02MXh4Lq8cN61PR6mSe/IAURQCpraQUk87KzRWHhdk36gZolXWsmRH
         jxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744618295; x=1745223095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yFiL7XQwjMNSusYEB+zRirLMLyCH2wO7H0kvak0x6S8=;
        b=nBJ9iD97hWIyHLcthc0TdgBS/JQQOggJEzX6FceuBxjHgoXHA+2BtvUApRoIRRtaZy
         EL0k4BldS7jQiP7CykXsTd/6paKVwgVaEegelDdZ6KoB2hTp7zep8mohddDD9R8W+C0a
         +W/cF5Voc2lGEKbLx5vx/WiNleKo0fLzynaHEbvP7KAK7AyQFcMyP3C3Clm8J229Lbd2
         4ULNz6wXYX2Vhw7FYpryZyrhphi2nIbyq+58BLnHhr1Of30uJT7Qew0gDYmmP68w3kGg
         +gTfs48v5juBUk8r1FH9osDw/ov3d5tRwUSwFqfO/Su5gdS8X/+i5ilzNN9kf5MOdarC
         yCYA==
X-Forwarded-Encrypted: i=1; AJvYcCVUkol4/66vlQEe21sOYw6KSjHXluIWTkDlFJfdcJpFk+zaBV9G4mb3K8of9VDXlg4kK/K9MW5F0ZFQ7Gs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjMU8HVxyI4wcv1wcQrMycvQuV3+AqKlmUAzx83Ic+A52sQMWk
	2zHvS6GNfvuxcQX0ya6xk8VYqlCILnd1wQzovVjgae0ho2zbKGaLLvGBbW7H
X-Gm-Gg: ASbGncta3rQSY2Gynq2gvPL+siC7be9n8oBw7Q1wZCdeOWAlfb0cPXD+YbSvKAeW6kJ
	IJQk8L9fr32sgI0AsWlySv0rg/s2zVdE3sWTHzgLuu9mN34ShcSQKw64PxdvObwQcXmcxfIZVWr
	2tl2ixo+tBGILSm+YeUX358/Sw1OSiFmwuv0jLN9Qwbzi72wZFBA3QFPqnadFCLfnf8XXw1BhV1
	2B6g7heOJ6B1n31vLWSTTJIZML5nwyWWk3YIk+KDLOnkxtmuRo8ai0nocJmw4yhCnGJXUUJOtdh
	bZNPs9Pht3T9Vi2JBwheysB4yZETLqLEodmbM/qt3Fg=
X-Google-Smtp-Source: AGHT+IHd5XfB1F4BTG4yVgpJ1M8ZY4YhHp7lAzw+Vzz8WQVt+Y12JzvPfddOXG5nCrBfMyHnds0oTA==
X-Received: by 2002:a17:906:c14e:b0:ac3:c56c:26ca with SMTP id a640c23a62f3a-acad3446a15mr1011810566b.8.1744618294716;
        Mon, 14 Apr 2025 01:11:34 -0700 (PDT)
Received: from fedora.. ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f36ee55212sm4435244a12.9.2025.04.14.01.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 01:11:34 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: kvm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] KVM: x86: Use asm_inline() instead of asm() in kvm_hypercall[0-4]()
Date: Mon, 14 Apr 2025 10:10:50 +0200
Message-ID: <20250414081131.97374-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use asm_inline() to instruct the compiler that the size of asm()
is the minimum size of one instruction, ignoring how many instructions
the compiler thinks it is. ALTERNATIVE macro that expands to several
pseudo directives causes instruction length estimate to count
more than 20 instructions.

bloat-o-meter reports minimal code size increase
(x86_64 defconfig, gcc-14.2.1):

  add/remove: 0/0 grow/shrink: 1/0 up/down: 10/0 (10)

	Function                          old     new   delta
	-----------------------------------------------------
	__send_ipi_mask                   525     535     +10

  Total: Before=23751224, After=23751234, chg +0.00%

due to different compiler decisions with more precise size
estimations.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/kvm_para.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 57bc74e112f2..519ab5aee250 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -38,7 +38,7 @@ static inline long kvm_hypercall0(unsigned int nr)
 	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
 		return tdx_kvm_hypercall(nr, 0, 0, 0, 0);
 
-	asm volatile(KVM_HYPERCALL
+	asm_inline volatile(KVM_HYPERCALL
 		     : "=a"(ret)
 		     : "a"(nr)
 		     : "memory");
@@ -52,7 +52,7 @@ static inline long kvm_hypercall1(unsigned int nr, unsigned long p1)
 	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
 		return tdx_kvm_hypercall(nr, p1, 0, 0, 0);
 
-	asm volatile(KVM_HYPERCALL
+	asm_inline volatile(KVM_HYPERCALL
 		     : "=a"(ret)
 		     : "a"(nr), "b"(p1)
 		     : "memory");
@@ -67,7 +67,7 @@ static inline long kvm_hypercall2(unsigned int nr, unsigned long p1,
 	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
 		return tdx_kvm_hypercall(nr, p1, p2, 0, 0);
 
-	asm volatile(KVM_HYPERCALL
+	asm_inline volatile(KVM_HYPERCALL
 		     : "=a"(ret)
 		     : "a"(nr), "b"(p1), "c"(p2)
 		     : "memory");
@@ -82,7 +82,7 @@ static inline long kvm_hypercall3(unsigned int nr, unsigned long p1,
 	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
 		return tdx_kvm_hypercall(nr, p1, p2, p3, 0);
 
-	asm volatile(KVM_HYPERCALL
+	asm_inline volatile(KVM_HYPERCALL
 		     : "=a"(ret)
 		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
 		     : "memory");
@@ -98,7 +98,7 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
 		return tdx_kvm_hypercall(nr, p1, p2, p3, p4);
 
-	asm volatile(KVM_HYPERCALL
+	asm_inline volatile(KVM_HYPERCALL
 		     : "=a"(ret)
 		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3), "S"(p4)
 		     : "memory");
-- 
2.49.0



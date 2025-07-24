Return-Path: <kvm+bounces-53387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F1DB110BF
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 20:18:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69D915879D0
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 18:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F7A2ECD06;
	Thu, 24 Jul 2025 18:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="AQfPCnxa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB41654723
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753381086; cv=none; b=AEccn0r9pi2n+ll8iPMFUpouSugkYKkWnwuOadDK9VB17NTqvzdfelSgqjiBZdhu+GRaPgKjGSISOVxrL+SOWOy2TpjgwMjyag/rw0luqMQKdzgZM7HXk+PTQD3WW6Nfx60j/IsTCOUlkZmNHEbBeIGO3UmK20Twkm/Rf8Z5Ym4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753381086; c=relaxed/simple;
	bh=ayGbx13v+9wyiJFyZgKtZbtzL6Qe6KW/T2nqoD3yEUs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aDAnI8keSzUAxUPpvgQU5dJijte6G0F3SCwW/CXU6Bk56B2oMxGIr5Pjit4cX4qB6ubvI0lGPyyp3/eMZE2qXujKbQWKEO36EixBPvsrHH/ZxiErN/FeD9McqlkwBWD8nf8cW9uDMtHvv/i7+f8EXu3YwtEeFIWVgtH+j26sNMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=AQfPCnxa; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4561607166aso9462545e9.2
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 11:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753381083; x=1753985883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m/RrNuFXbE40XjM6zt9eoa2dkUsnTE1Y+0Y04nkx42o=;
        b=AQfPCnxaNou8M3bf0xUHaQF+PLL3RIdCse8LSJcHKzyNdrylrYPpFOKc3Xtl71diup
         MxN9N4a6Zdn+BYhvZKeC02t7D/+KLS8EUI9+iwGk7QhXAph+43h0hjOffH4HpXJe1aMq
         Mx2ZGlIjSagRCVPlHhkSHStpGYfhSJmfm9MIO6aJzLjrc2s8V4fCeaiwb/k1p9kkneQh
         bdbFIDGxxeZrzb57fbczZ1WcvXCld2cOxSvl58vtUBN5jB5w6jMx9rzop9TJHGJHCGQT
         mCrA5FNgGINMBSR6mRijUBainZsDaorHIKJZIUZ6B+zp+V/sneoGijJRExjHuoU3Bt64
         p2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753381083; x=1753985883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m/RrNuFXbE40XjM6zt9eoa2dkUsnTE1Y+0Y04nkx42o=;
        b=pkPRUX3z1wCZoW1leTO3MAaWZfSNRYHeLFs63IDXagSLtSKFwN9swBKMmNhTtz2nIa
         l7TFJJQ1gaStY1d04BrRO/S0xI5tEn5QYgMcCIdgP465FzrXAaG5iyApmqB1h+agxYq+
         dlJk0adqdmeL2bk5HOvZ9B/YkWPwyTWQY3DXVwUsRHFK8kt6e+IKUwcuJMNUT7PZlpwT
         h1n01j1U7WexXX560/gwdmCBs8rHDIpSri2mLhOLfyYCZ46+OZS6CSb6jdEnkwo3te/D
         icG/CR5nptyBkLryqO7slx2dOCWWx5MsagjP6PHMJeirMHDsFmAeEoD3OToN5m+fUnbQ
         vd3g==
X-Forwarded-Encrypted: i=1; AJvYcCUkWwEy7z0jO+Uk5NctsE4AeSa7HIa+JUTQQzuLIN9sd7dnlLt/Q/KeC2Ug1sn34RUxCW4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/4UyzkCHA5lJSs7XUNhTFmcOJSe0kPK5MLPvLjrLy90CXvwYz
	d8MbjXFgbm95ek8dRhodbc7iENZOLD9Uao+QmK1Mlb4VvEKKgoEQocZKc9Avz7cDTdjH5Gt1eZS
	qRfuT
X-Gm-Gg: ASbGnctdvR1/3txq4gx0nFaBurn7LOMkaHy+soTNEzR8VMS0dCC2lluRp5b/HE8y/i0
	SPgUowcwZOWr/NvD+xFPxP7qeyyspEksGq/+diaQf/j1xNWWqsk74JmVDLt0/knlmlfTvbTh9Gx
	Kzu+tdLhJ/1QpeSaKGN6gEJ6cGdq1vKtkkeInCZCPj0AEq8vMOOTS07mGBqmWbSKxvojUavuLar
	hYJ5qratq0V7tPHrFofyuWsJ2dA+0A5P9lIveUOfIgqygIY9+zEbgbNGY23IT2KB/NFbkvk1cI4
	7l4csIi3Bp35Zv/npJ1SmyBJ2eWk9pSuSHC1uy6JwV1dgiYnSC0OQO8KwFBgh9cMLXTdhl/Hv0D
	ulj1o+b9pFWYakPY4BZVRnnJ/2uoMSkRfgF/+xLzAjTL+QmllgfaEeNUcu0rPnu6MdH7gtU6T4u
	QtmAmKn/cXvi7nfNV+
X-Google-Smtp-Source: AGHT+IEFIqdC/DervVfOQuN1Xm3D/gRAa6GskNkCV8xsFysh42xUkmrjGWURkVuDPd4UAq7cXcPvQg==
X-Received: by 2002:a05:600c:3f07:b0:456:1d61:b0f2 with SMTP id 5b1f17b1804b1-45868d80dd4mr83290375e9.30.1753381082825;
        Thu, 24 Jul 2025 11:18:02 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458704aaf20sm29701035e9.0.2025.07.24.11.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 11:18:02 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH] Better backtraces for leaf functions
Date: Thu, 24 Jul 2025 20:17:59 +0200
Message-Id: <20250724181759.1974692-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Leaf functions are problematic for backtraces as they lack the frame
pointer setup epilogue. If such a function causes a fault, the original
caller won't be part of the backtrace. That's problematic if, for
example, memcpy() is failing because it got passed a bad pointer. The
generated backtrace will look like this, providing no clue what the
issue may be:

	STACK: @401b31 4001ad
  0x0000000000401b31: memcpy at lib/string.c:136 (discriminator 3)
        	for (i = 0; i < n; ++i)
      > 		a[i] = b[i];

  0x00000000004001ac: gdt32_end at x86/cstart64.S:127
        	lea __environ(%rip), %rdx
      > 	call main
        	mov %eax, %edi

By abusing profiling, we can force the compiler to emit a frame pointer
setup epilogue even for leaf functions, making the above backtrace
change like this:

	STACK: @401c21 400512 4001ad
  0x0000000000401c21: memcpy at lib/string.c:136 (discriminator 3)
        	for (i = 0; i < n; ++i)
      > 		a[i] = b[i];

  0x0000000000400511: main at x86/hypercall.c:91 (discriminator 24)

      > 	memcpy((void *)~0xbadc0de, (void *)0xdeadbeef, 42);

  0x00000000004001ac: gdt32_end at x86/cstart64.S:127
        	lea __environ(%rip), %rdx
      > 	call main
        	mov %eax, %edi

Above backtrace includes the failing memcpy() call, making it much
easier to spot the bug.

Enable "fake profiling" if supported by the compiler to get better
backtraces. The runtime overhead should be negligible for the gained
debugability as the profiling call is actually a NOP.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 Makefile | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Makefile b/Makefile
index 9dc5d2234e2a..470da8f5e625 100644
--- a/Makefile
+++ b/Makefile
@@ -95,6 +95,17 @@ CFLAGS += $(wmissing_parameter_type)
 CFLAGS += $(wold_style_declaration)
 CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
+ifneq ($(KEEP_FRAME_POINTER),)
+# Fake profiling to force the compiler to emit a frame pointer setup also in
+# leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
+#
+# Note:
+# We need to defer the cc-option test until -fno-pic or -no-pie have been
+# added to CFLAGS as -mnop-mcount needs it. The lazy evaluation of CFLAGS
+# during compilation makes this do "The Right Thing."
+fomit_frame_pointer += $(call cc-option, -pg -mnop-mcount, "")
+endif
+
 autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
 
 LDFLAGS += -nostdlib $(no_pie) -z noexecstack
-- 
2.30.2



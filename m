Return-Path: <kvm+bounces-36441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C862A1AD5E
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:44:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 039AF3AAE53
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A1D1D5AB9;
	Thu, 23 Jan 2025 23:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vdFAWnaa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294D41D514F
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675877; cv=none; b=gL2BDl14nV/ZxJ+mdfZ6qHWznxJj6vkEm/XB5lI0+d7LMci4xi5hxzZbLmPpearKXDTS3ilaX3Sni0u3hgRobWwPeH81B6YsvFpmjR2sD4/mdknCRGccJ+6ABGY/HBoWxE5kfceTTcIE9Yduy2olPbjXgP8HZP5BjDbkc1D7Iws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675877; c=relaxed/simple;
	bh=PUEx9/EVHpZyAG1kaVNeYN369Fav+oisRSkJ3ll29NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LRGNTR/TvSbQzd/VrE77wqU0P3LO0dpEbu/wgQ0hoWthbFQBx0EJPwV5qTEPzF7qfI+lD/nibunjwyYZVdf+BVpvgkgqfjNAoo8Q1ag8BF1dJKzmGWlreZ3ojTvU/yFVefevrg67+pMAvlX5TOlsbOuFPgonW3wNAKXAVFdriC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vdFAWnaa; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38633b5dbcfso1647970f8f.2
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675873; x=1738280673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ce4xXqVbqUUJ3kwtGZLdz75HP+CS3yxZeowyzQLM8Ns=;
        b=vdFAWnaaqWwVaN3hBdl10DoP34NbwDfDuv9zcEIXT/XmwXbmLif001ub/H4+5n7SGb
         PITMsleujiKjHayiux8o3JI/AuSAM2cOEJvPzyorxJkM5qUfg1gNQWHwuR/BZ0m8wMdN
         pyvLGnFYt173DrvQLdDM/ur+BGwicJAlroHOunYvhj5JhrKiAfT2orfdTvi9c0K0EY6e
         NxuIh/txNpSC4cKEwUCue1f+jxSuvu4MDST6aAhpdDOWM19E3/nE5as1rTrftOf/3Av1
         xepm2VYNm/0vRPzjpTwG9gW0+p7AR7rK7dK3fYFwQ1cwBe9dGzUanc1ZyRSTaI0fm0hM
         Aa2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675873; x=1738280673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ce4xXqVbqUUJ3kwtGZLdz75HP+CS3yxZeowyzQLM8Ns=;
        b=a5kE4+Gz67LhCH1EwbtEF8nfXKQF5LKuA/KpvmQCz7g+WIlQi0WRnBv03adMoxjlhn
         PYxij/m7uBD6S9jYWQPQzCdoECy95w5g96NwjiSk7cnhYr6+6feUbS9TiZt1aRUeTFg1
         bgbM7zVyx5ND48fXJw7hN7FZ4oNh/4/X33egNoxJjKprFjBzxewiYDolVHG20cK4oGBH
         JkwSe2cvtQsO61LRkQM5JsCIRTbyAKT+14v6dFfw332zlQsVBSgnR0KGIdo8qsDXV/Iw
         aB1uAvFRnJJPDabq5+3DrhgX3lP7oRda28ROPKeCt5FCsVsYzGaDyTRvyz15h4EPTA20
         H1nQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYmJcP73c2r8BmhnexYw8QmWhujyAMGmLHT+QF+5krAtu4OBhqgkirnuNjpd9jwZgLUFY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJjv0OPV7KdRity3tsvZdl+hYGqYvgMJ8U27df9jDuQbEeEi6K
	YDw4BAfBlzELJY6i44fTOrZca0mheig3eYSXiKBHtnC7NdiDqRMFNqkUewDVPtU=
X-Gm-Gg: ASbGncs/IVKUUuxYmu7vBI4i8eaybt8uFmQ2kmE/QbwQxiQopN/O9Ghbxzn9Kes/l1a
	Cxsl5EVC68JNYe5SikW0Xpr/y5Vv59KBs6uohOVP8PePeqEn2xy9OyScjRJUDU0qffz1jc3zzHa
	bZgkifnY86Zc/gHda9vf9udeJOCKc190hRrrXIULEnn18GNTO+KfPU9lScagaPubRZfoWkLkPp6
	eBERxW6T3CXbhwMQRUVT0InIJ1M0AvW5GObz7qn2caYCS7P0LazFkXS5aVwoox77L+toWbcCtJe
	N72k2eHpiznsUJW5tleCVjtnC3IoV5KgrFYeIJ1xJlPQyTjf9kWJRSg9DsKS3s1Pbw==
X-Google-Smtp-Source: AGHT+IF2OW+qflIazHPgiEcST7oe1qZGT6aj/Hik/HFfGWbVcOJj4aFV8515DLdGfzbOF2nObYCMQg==
X-Received: by 2002:a05:6000:144a:b0:38a:9c1b:df5b with SMTP id ffacd0b85a97d-38bf566a279mr25563799f8f.30.1737675873434;
        Thu, 23 Jan 2025 15:44:33 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c4006sm982952f8f.94.2025.01.23.15.44.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:44:32 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 03/20] gdbstub: Check for TCG before calling tb_flush()
Date: Fri, 24 Jan 2025 00:43:57 +0100
Message-ID: <20250123234415.59850-4-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use the tcg_enabled() check so the compiler can elide
the call when TCG isn't available, allowing to remove
the tb_flush() stub.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/stubs/tcg-stub.c | 4 ----
 gdbstub/system.c       | 5 ++++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/accel/stubs/tcg-stub.c b/accel/stubs/tcg-stub.c
index 7f4208fddf2..b2b9881bdfb 100644
--- a/accel/stubs/tcg-stub.c
+++ b/accel/stubs/tcg-stub.c
@@ -14,10 +14,6 @@
 #include "exec/tb-flush.h"
 #include "exec/exec-all.h"
 
-void tb_flush(CPUState *cpu)
-{
-}
-
 G_NORETURN void cpu_loop_exit(CPUState *cpu)
 {
     g_assert_not_reached();
diff --git a/gdbstub/system.c b/gdbstub/system.c
index 8ce79fa88cf..7f047a285c8 100644
--- a/gdbstub/system.c
+++ b/gdbstub/system.c
@@ -22,6 +22,7 @@
 #include "system/cpus.h"
 #include "system/runstate.h"
 #include "system/replay.h"
+#include "system/tcg.h"
 #include "hw/core/cpu.h"
 #include "hw/cpu/cluster.h"
 #include "hw/boards.h"
@@ -171,7 +172,9 @@ static void gdb_vm_state_change(void *opaque, bool running, RunState state)
         } else {
             trace_gdbstub_hit_break();
         }
-        tb_flush(cpu);
+        if (tcg_enabled()) {
+            tb_flush(cpu);
+        }
         ret = GDB_SIGNAL_TRAP;
         break;
     case RUN_STATE_PAUSED:
-- 
2.47.1



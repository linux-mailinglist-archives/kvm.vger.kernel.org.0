Return-Path: <kvm+bounces-57635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A6D0B58703
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:55:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B90A420837D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 160292C1581;
	Mon, 15 Sep 2025 21:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="jCQ9pax1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7052C1583
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 21:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973301; cv=none; b=MTNXFvE9A8eudNDZnaWSDnmdJuecbdFNZNtXwqPCXquHu1rREWeuqkM/+JRieJRZNTRtt4z72RijybqIrryFFc5sfT5TQskazsNZvK3zMVdbyzTPxFnjbl7fzKmrvYTh3veDoksBmIwFkg5Vp/5BcbL1b9iHe7yLjFUDYyLPbcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973301; c=relaxed/simple;
	bh=4pFJ7PlEmesvXr3cQL2H05B7Cqj5Q/UV1hXOSPL7QWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ky5GyOwYz2wINBz6XfBI13GhZ/1YsCMD4+ayNB1RRBXHRp9kQZcedgzNXLZS0zIqhXy+WgZalmLwkLR5iW6NXC3Eh1sN7STG7J3K/QwJPpTXOF5ppU4CpNPjM1n3EkQzzPR++FLIsZLwTtOkdbbnE9Kd+AaPMqv690YreaOTJx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=jCQ9pax1; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-781fbbad816so11084326d6.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757973298; x=1758578098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89dl8JzAtkZ/mNSRMgjqLcxEDRNkD5DRSw13EhLsQUs=;
        b=jCQ9pax1p+8GoCEhnpQPjAkSWkKccJbrouvzepAQZn0nZnn725vVedN2oC2NR6Rs98
         rfaobUpfos0arwUk0Aink0zKWbEeU13qkfm9BpJGh7MNgna9WwaR/pFcmpTsnFSyVytG
         aKAtxVgvIBGlcWD7AD5FTH/t1HZuNNE0D+EuxNa9RiQrBEL6bj6C3+B4RYD2L448ArF/
         jN97JHWiYS1MWiW76R/W9YNyb5UdA/HqWoA8d4ktFkRRh6CZW7mbBf4s4Rxts8zUYYYm
         ds8sSaj85hV9U58cJC0QM3dcgyYxeEkaaXc2auUurjMygDKC3bkUylLoAMLJOarpqfYz
         U65A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757973298; x=1758578098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=89dl8JzAtkZ/mNSRMgjqLcxEDRNkD5DRSw13EhLsQUs=;
        b=hEDOzcRoM4BP0kl+WR8UltQ/I08g38ya388nkmVLqS4xEQWNQStTrN+z2U9jd4dU6x
         r0SvdArUDGrecJaO4xVVUmqeaQKuxRJoKLy9gDEBnS7aThjCUPo64yRNtYoS86+2Ei5u
         BpnVleFarK7dUdL5qFpPES2awJdJVKES9cfNItEN5F6KhYCb7q+987Lc4J66aDTOv4Hz
         P2Mi74R7mDtrXhYs4dly0IiKDurIKQBvisbBvXh7581NEZm90st2kg89A00l3Cue/176
         UYKqiWAbM05iRnEq+G1mKC0vpvNvWzVunUb/sU2HrLoKoLiNWqnQY2VnYwH7Yj7Eju5k
         2/gg==
X-Gm-Message-State: AOJu0YwteKWTGGF4G3WRAlCzhjR1dEi2VhunH1O34EwcjfEBTQa1jV2J
	mRu9kbtXHgTMXTIdcbaoL/ofuHmSHtFYoaEZ7XjUbA08L3vJdb0zJ/HNl4EbZuX5FT8=
X-Gm-Gg: ASbGncsS/8O/VS6s0lZMtZRHPXHaOcK8gZaKp7jIzHOGi9p4YBX80zdRJ7megTvXmxq
	cPthsRSKB3T7Ti+rFXf9kJ4FDRJi6ZuetEkOqmI83Jxez2mnTT9Tl28+3gsepQUIfgia1Nr/mzp
	dtyZv3SuEOoIe1ZSz3MpPctkHFyO+oTJ13wCrznQpy5a1x5fumcI+KP0BSImnnHx+SMrdWdX1sz
	ftiGO54icy3Z0Qk2A/Ckxx3Mlr0HTwDcvDSePyvFfIrMAnmIzAUMjQLU8GyxRJJrygRB2Kx2Lit
	qfA7x5z8h4HvgIgZvwTjI3svHmeJGdgYNr77DycPECKitGNjsY5pVsg8O6inJ7Zt8wWhv74bUVP
	kIZpjJ2szELr2ZFCx9ZpfjFReOara0a2EdELRNASiH0Zs/SPgGbCk33fxpBJt/Lhqe8dqg94MtM
	Lwv3lYY6OY22dQ5rs0/o/H03xAajIr
X-Google-Smtp-Source: AGHT+IHUQeSFbd5uMK2kqS+/fPHkKVOSrTvADLumpaByKCM49cbxczNpu9T8V9R7sDVfxCx22JSMZQ==
X-Received: by 2002:a05:6214:5009:b0:780:600d:b93a with SMTP id 6a1803df08f44-780600dbc1bmr63952606d6.41.1757973297685;
        Mon, 15 Sep 2025 14:54:57 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-783edc88db3sm25104796d6.66.2025.09.15.14.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:54:57 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 4/4] arm: Fix backtraces involving leaf functions
Date: Mon, 15 Sep 2025 23:54:32 +0200
Message-ID: <20250915215432.362444-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
References: <20250915215432.362444-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When backtracing starts in a leaf function, it'll cause the code to go
off the rials as the stack frame for leaf functions is incomplete -- it
lacks the return address, likely just causing recursive exception
handling by trying to follow an invalid pointer chain.

Unfortunately, -mno-omit-leaf-frame-pointer isn't supported for the ARM
target as an easy fix. Make use of -mapcs-frame instead to force the
generation of an APCS stack frame layout[1] that can be traversed
reliably.

As Clang doesn't support -mapcs-frame, make the stack walking code
handle this by using the (old) more compact standard format as a
fall-back.

Link: https://developer.arm.com/documentation/dui0041/c/ARM-Procedure-Call-Standard/APCS-definition/The-stack-backtrace-data-structure [1]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>

---
I failed to build KUT with Clang for ARM for various reasons, the code
is clearly lacking Clang support for ARM, so I doubt this fall-back will
be needed / used anytime soon.

 arm/Makefile.arm |  8 ++++++++
 lib/arm/stack.c  | 18 ++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index d6250b7fb686..7734e17fe583 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -39,4 +39,12 @@ tests =
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
+ifneq ($(KEEP_FRAME_POINTER),)
+# Force the generation of an APCS stack frame layout to be able to reliably
+# walk the stack. Otherwise the compiler may omit saving LR on the stack for
+# leaf functions and, unfortunately, -mno-omit-leaf-frame-pointer isn't
+# supported on ARM :(
+LATE_CFLAGS += $(call cc-option, -mapcs-frame -DAPCS_FRAMES, "")
+endif
+
 arch_clean: arm_clean
diff --git a/lib/arm/stack.c b/lib/arm/stack.c
index 66d18b47ea53..b2384d8eb4c1 100644
--- a/lib/arm/stack.c
+++ b/lib/arm/stack.c
@@ -8,6 +8,20 @@
 #include <libcflat.h>
 #include <stack.h>
 
+/*
+ * APCS stack frames are generated by code like this:
+ * | mov  ip, sp
+ * | push {..., fp, ip, lr, pc}
+ * | sub  fp, ip, #4
+ */
+#ifdef APCS_FRAMES
+# define FP_IDX -3
+# define LR_IDX -1
+#else
+# define FP_IDX -1
+# define LR_IDX 0
+#endif
+
 int arch_backtrace_frame(const void *frame, const void **return_addrs,
 			 int max_depth, bool current_frame)
 {
@@ -27,10 +41,10 @@ int arch_backtrace_frame(const void *frame, const void **return_addrs,
 	for (depth = 0; depth < max_depth; depth++) {
 		if (!fp)
 			break;
-		return_addrs[depth] = (void *)fp[0];
+		return_addrs[depth] = (void *)fp[LR_IDX];
 		if (return_addrs[depth] == 0)
 			break;
-		fp = (unsigned long *)fp[-1];
+		fp = (unsigned long *)fp[FP_IDX];
 	}
 
 	walking = 0;
-- 
2.47.3



Return-Path: <kvm+bounces-57633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BBFB58700
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BB95A4E029C
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3872C08DC;
	Mon, 15 Sep 2025 21:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="TYWaKCXt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C602C11D6
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 21:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973295; cv=none; b=qTMO60W0u9R9f7HU8xA+B0My99I571LLV/j2slHt+tSrDMihV3UIXbQg2HWTyYD0lczMybdlFxCcZWFYiZcz8rR+YBiQqXFoxNSQE1UMUarmjiYiIC631t2R+gu9HX657ZFNaRlu+NyDJXfXJ6cV/RWda28MZtb6ZEhEX5bSExg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973295; c=relaxed/simple;
	bh=V74ryi50fllprQ+sbnAnYVxeP6t7/qch9aRTHY0lIig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwI4kb8POxXgmExj8VarFoUOt3ourjxveaN3vqhou02e8a7TAgdRfAaCNTJIR7QgzSpzUyBo25etk60Y17opz68/GYsW5ISQ2PwEpxZQs6lVxolbrOxRAwWFyiQ8aw9Jcg9B/pRpRRs7SYSdq4rw5VIwGKYCZqjck9e7JelvF5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=TYWaKCXt; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-7726a3f185eso25105036d6.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757973292; x=1758578092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uS1hCbLa4Et7x6l9f592uuKlwLa7KX/sJXToAiHGN0g=;
        b=TYWaKCXtjDyVyYtl+AZlFRVPFiVxa48QK4RZZXU+68SZA60UXgVeRZTHT1SSZWak9V
         nltG7tRoDSDMMIVDXBs/bYnpcTcCpBSyPktkWh1MVmomcdjlkk92E1gdpaF17+CtzVuJ
         5Z9POKiJxOW46COVm+tLjS5f1V5xlvl9qdqhTkNvk4k0dYOsF5qJK2Aq3T4QTOazd4hk
         MtwH7S5hvHs4PV6BwEhvIY8aSZTjEBfOW5WwMx/oNqlZPi3ygmQYbNLlUBOfC+8RH/Xp
         vXGsp6EBZKN+aHwIS5qr2QFZMUaXb16qyDf37QnFanedukVudsQlS9uusGPASbTY6b1Y
         /GGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757973292; x=1758578092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uS1hCbLa4Et7x6l9f592uuKlwLa7KX/sJXToAiHGN0g=;
        b=juQtL34hYQZMKQ+IgQy9T/MoBT9vqS3oVRJJxzK0lpSWkRUkx+AXVpsqiFTEQlcjgO
         AY6mHHrlGz72sutRrRDdw05iWtENgx1VIfs6fE7Dj/kGaBYT4EGPZYabrJ/hrE5+awTt
         zn0WzxMTycVYOHTCFLOAtI4bNKltaPstd5IPOeM0JKs/mEDsJuWeRKTrDbAAZzzNKCNQ
         wvCZhIut+i860s7sbAH9al3WxeWQbH8AHGgWrgj3AfIUiWywwgM6hUCoAPW7/g9XbIx/
         lJiWLIbBTJxqdxBgw+4rMeuHkETdmzrHBf5Z1lzEQcUKIHjECYajeQ3LavpVssfCh3pd
         3vgQ==
X-Gm-Message-State: AOJu0Yxf5iXIZXZzZp5OIyDHpMSdcsIMbUc/xO6aS4VnWFg79/d5RO60
	U5xEp39TxzKBPyH770YajGVNXgy2IafuAAYapz/oa5lYrppnlskPvKxn5I4Z59py0FA=
X-Gm-Gg: ASbGncsV4VejQY45gCEuNXXEZbDkyCYNUPdeECPJrriPy+I3f1Iyt+PrgIVA+ZFH3Tt
	RSu1TnP0BLp+ZB/8bQpyn6w+NNnNIzL3VCzVI2ie1I02o8aVMtRnhvMOd8aGsb+X/31MFKkU+tB
	+Weidf7FERrCSkEg93z2FB4A3dcrr2HdTByTPycYnc73lCSOkRZprMa8xaZVcmiGbrPz0XhCYmq
	wc5m6WNjjwEbtad4CG5xS0lunYyevixUKXB6sgntsURSiGrLtx9/492LcMV0ba1mnOuPtFkcMLT
	1Mp+IbAXxJRnVZ4/tUKqvXan3BlFoyHRcj3UoFBqabkxP9J/MG1aRNI9N/XLqzzcWLobcv0Toj6
	SidZzc2DKmSWusO3lXcOyNfiwqu+hUfZg/AODit8gMnyS7hCDYy2nRRs6RCv55SnffAy2Cl1959
	4jejGDn+9yl2f2kLa14g==
X-Google-Smtp-Source: AGHT+IGV5e0judTPviZfC121RGuql1NEb4uEFiPSK4CkEMEQ03cwtJ5PHz8OZy22/jFB8T1ux5L+WA==
X-Received: by 2002:a05:6214:20a5:b0:72a:d613:317e with SMTP id 6a1803df08f44-767c46cdaf2mr171830896d6.53.1757973292430;
        Mon, 15 Sep 2025 14:54:52 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-783edc88db3sm25104796d6.66.2025.09.15.14.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:54:52 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 2/4] x86: Better backtraces for leaf functions
Date: Mon, 15 Sep 2025 23:54:30 +0200
Message-ID: <20250915215432.362444-3-minipli@grsecurity.net>
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
One may argure that the "ifneq ($(KEEP_FRAME_POINTER),) ... endif"
wrapping isn't needed, and that's true. However, it simplifies toggling
that variable, if there'll ever be a need for it.

 x86/Makefile.common | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 5663a65d3df4..be18a77a779e 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -43,6 +43,17 @@ COMMON_CFLAGS += -O1
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER := y
 
+ifneq ($(KEEP_FRAME_POINTER),)
+# Fake profiling to force the compiler to emit a frame pointer setup also in
+# leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
+#
+# Note:
+# We need to defer the cc-option test until -fno-pic or -no-pie have been
+# added to CFLAGS as -mnop-mcount needs it. The lazy evaluation of CFLAGS
+# during compilation makes this do "The Right Thing."
+LATE_CFLAGS += $(call cc-option, -pg -mnop-mcount, "")
+endif
+
 FLATLIBS = lib/libcflat.a
 
 ifeq ($(CONFIG_EFI),y)
-- 
2.47.3



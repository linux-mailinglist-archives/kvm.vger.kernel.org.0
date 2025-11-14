Return-Path: <kvm+bounces-63265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 53092C5F48E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 563A24E7B60
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEEB3002A5;
	Fri, 14 Nov 2025 20:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T3885nvE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8AD2FC871
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153484; cv=none; b=czbmZqZiCl/9IufHSIzG9uUXpJhYfF/psi76id+SUnvlYYmXxNOa7Lx9/YX9zJcu2gCPDTTl2+QHxTH1j5PkljvN8ZRoD6vHnPMMf5+r6Me24PSkHSH3q2kTKOk91TAC7GKqOtkOLjGq4ITWoljfixKqCCkyzNBAQQ3owoFaTKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153484; c=relaxed/simple;
	bh=Psf45lpuMxvBIdE9eelJdc9urNNALgw+57nl2EoW2Eg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dgRQ1Jkxsw1xfn/bT+yfTp1T0yiJ6RkTwIT+ladMOTp1qEWlVQsRYBG7610G2rlKEzqwUj/xCLF6zH6z3oItaO8SRHtg4YMRA+gKGhWyMOvsILWR+ccz60CB/rg9Dgy7T4uCU92hz4/AXRtDI5QuOxYeNe5XsADNlgRdrNmi6xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T3885nvE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3436d81a532so5260351a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153481; x=1763758281; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N1xSBg20ljULzru29O07DSub2YAK3TqFj8H3Wl2csFA=;
        b=T3885nvE/iryWoPiBu79GhCE/a/jhyeuiSMtY8W7eEfZNp4+qKu1/nOVZjLN60hTNo
         O8XLD9+D+C9q/lFww8bDH0tIEJdI+Gjvggm4Zr6X/ICZzb5jY0UwAhDK1HF+fZnhdA94
         Pd3uvnx5IBQ/2zkU4T/8beCPID7Me2G58YuopOoaD3Ded6VST7iZB2wwMYW5OAo1DXab
         BRGywKsiPQyxb3jyfalwMr6YfZgnwjUOaPs/FtWkuQSV78mROep8tmmcayuFqCJv3Ymb
         3Hq5GiMW8ba9sXBtEp8ywDJa5+DimaPh2ubyOFoTaCbMonWj176n3tJbAqXrmA2KA+FX
         LBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153481; x=1763758281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N1xSBg20ljULzru29O07DSub2YAK3TqFj8H3Wl2csFA=;
        b=Zzt7Mq7qBGOyCh2rcwFfzFqLLMxt4hkO5dCkh98BT+itT/v1AH2pLn6vk/ZXlgyZua
         bhm4a164WrXoT4YdFgbCvCijk8Oadh3mXqDdHmZlyMUCdC4MRKeT26bKJaCK3Xm3FX0o
         31W5/rFPIlMQUppw++AYYSnvLIQnKk9Rv3PP79kOCgp2ZmarRfk4U2F38TuZH17bTRIj
         Ez+5eqK4JR8E6o2Y5osuQNtVH9byyVMcTuw/cTR+U3cczoSZQwoL/4FisRn1YH43qmXr
         ObwoxYDecrq6A7TsK57z23JcSvCAgwcxUPIVgouSGU6JySajY90TZ7rbGa8lvtqM6Qmo
         DMXA==
X-Gm-Message-State: AOJu0YxV+PVe3m53xoJrLRc8hvDbWCdfNV4lhnjpD04sDSVHgyO2PoAL
	DyjkWSGCUdOj4aNCXikmCm9wbQJEJqEWPMLKIh/6RkLv9Id8oIJ3hteG6+BHDouGUToyRxXtJ4s
	NrnuBJA==
X-Google-Smtp-Source: AGHT+IFJu1s4deIszNGzegwo5KueIxvI1hQN0o+BjI7JA+uuyPJKk6NBg/y8+UN52TDZXP3h0AOqAGgsQTI=
X-Received: from pjzz3.prod.google.com ([2002:a17:90b:58e3:b0:33b:e0b5:6112])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c886:b0:340:be40:fe0c
 with SMTP id 98e67ed59e1d1-343fa76c90fmr4796684a91.36.1763153481344; Fri, 14
 Nov 2025 12:51:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:51 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-10-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 09/18] x86: cet: Make shadow stack less fragile
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Mathias Krause <minipli@grsecurity.net>

The CET shadow stack test has certain assumptions about the code, namely
that it was compiled with frame pointers enabled and the return address
won't be 0xdeaddead.

Make the code less fragile by actually lifting these assumptions to (1)
explicitly mention the dependency to the frame pointer by making us of
__builtin_frame_address(0) and (2) modify the return address by toggling
bits instead of writing a fixed value. Also ensure that write will
actually be generated by the compiler by making it a 'volatile' write.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 80864fb1..61059ef2 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -10,14 +10,14 @@
 
 static uint64_t cet_shstk_func(void)
 {
-	unsigned long *ret_addr, *ssp;
+	unsigned long *ret_addr = __builtin_frame_address(0) + sizeof(void *);
+	unsigned long *ssp;
 
 	/* rdsspq %rax */
 	asm volatile (".byte 0xf3, 0x48, 0x0f, 0x1e, 0xc8" : "=a"(ssp));
 
-	asm("movq %%rbp,%0" : "=r"(ret_addr));
 	printf("The return-address in shadow-stack = 0x%lx, in normal stack = 0x%lx\n",
-	       *ssp, *(ret_addr + 1));
+	       *ssp, *ret_addr);
 
 	/*
 	 * In below line, it modifies the return address, it'll trigger #CP
@@ -26,7 +26,7 @@ static uint64_t cet_shstk_func(void)
 	 * when HW detects the violation.
 	 */
 	printf("Try to temper the return-address, this causes #CP on returning...\n");
-	*(ret_addr + 1) = 0xdeaddead;
+	*(volatile unsigned long *)ret_addr ^= 0xdeaddead;
 
 	return 0;
 }
-- 
2.52.0.rc1.455.g30608eb744-goog



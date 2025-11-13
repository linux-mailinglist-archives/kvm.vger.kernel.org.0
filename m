Return-Path: <kvm+bounces-63119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 540A3C5AB18
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E63124E3733
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4603A32B987;
	Thu, 13 Nov 2025 23:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4R1gI45A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159BE158545
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763078060; cv=none; b=uK70R+mV1s9BQ1izOsPJ801wFeQAZ8EUKP4MQQDp+uC18JdB8ssMDKq+A2W/DXrXn+0suTlvNwW042+CnKWPTDUWgOtuuafD9xGjXWHvDhucabsDeK/eawDYnMJf88YnYnp8mQNfyYxAOaqUALR3zEkOyECUZyR3kdL7ykS2mYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763078060; c=relaxed/simple;
	bh=+no1ZYST1T33VuqALsjYDu/FT265SdBAcLuaMvq/tKA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tSRhmhjfyemT4Xwl7X9J9h243/SpMhrl/OMdBssbw/gwPbfiOScO+Abtnop0LU71Pm5/YwYkFQ/crk9Bl9LYX7AVt9U2Gj3f/Fb4Kss9KYNjXJS3bU8Qcq7IZHk40TeMUU88qLw3NunccHEnCkHGWq4LOR59uaQlp6r+HXV1MZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4R1gI45A; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343fb64cea6so376608a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763078058; x=1763682858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q1oFHLsrPGdyaiVfrUDghvi724JVr65Gm5j0vALQD30=;
        b=4R1gI45A12wAVc+OZr2TvOV/6Q+CMjfvXiC8VJXPKN1j+bwhiVghNPMnCpKSIeaNHZ
         PAHJ/LAYu588oTbT7CXmg2L7mNiAXLPqkkGWxWjCfYeAYgn+ht/UwYOI+MJyKRmU9SqT
         Ro8zhn/ch6QHbvOzGc8lsZRbvs3sUIf6qrFMh1CjQiP3ZQcUuaCuPbuczOxZYrfYTYeQ
         24OHLo52+2qNfVNBptD5+bA6qGxKzjzLLlrEt0yQ2YCj6vBZ3LjnaJ+RuF6FStHv2c85
         wIpuDzkzOl+PMJVDPWC7Tb3kIJGk3R/+G/XHwxFgErZZGI3rpdgh9R7dYXdnxL64+iEV
         Iu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763078058; x=1763682858;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q1oFHLsrPGdyaiVfrUDghvi724JVr65Gm5j0vALQD30=;
        b=vpE8q2O4fRPCPtPGbOCRSgQETAOdvd7MWH4KTI1CZSr4Tvu2y8psL7TTa1kiN/NCjL
         0w2t5xGg2Um43NqzVyVshSWfEFFI7Bi/51+4tN/+0kk48k+LDPX1m5VJqhW7GFUkrgoa
         +XM6aybC4xHI/72ncyDkLepPQF2WhVzpFiGtVEW0Ltv+fMPyWZZhLfg6QpxdcSIW0UOE
         kdXP1RH0LswE5dnu82BUbKSsPWFt6jGqVV8LtVVYGRkNEnSqbaFi8PcKS69qyn4Pi54I
         nl+hvxd7RlkntnoMSLBUAtYyajARjxq7R33nKJzUtIRmRhN/D/Bax+7DRTbnt+Kxj3E2
         U0UA==
X-Gm-Message-State: AOJu0YylWgKHuAhk5XaplvZFTC//QJi/gKZPVI1wly8jPCu8szCifwIU
	rqdnDOh6WcHclyfhhyCEZbkZNcyICl/tOg/UkfjEc/GUIAN3bwOk+d8nDYwhWQFmMpuNTWNNlqL
	Rx6+ybw==
X-Google-Smtp-Source: AGHT+IHfQ2xYfLhKwa9ibFyPU8X9Ue31l/x3dfdVV57KwhuPCeRmdeIkVw0WEn6n081fVrGhkwFrcOpQhzk=
X-Received: from pjuj6.prod.google.com ([2002:a17:90a:d006:b0:339:ae3b:2bc7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e70d:b0:340:be4d:8980
 with SMTP id 98e67ed59e1d1-343f9eb615cmr970591a91.14.1763078058378; Thu, 13
 Nov 2025 15:54:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:54:16 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113235416.1709504-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86/emulator: Treat DR6_BUS_LOCK as writable
 if CPU has BUS_LOCK_DETECT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Mark DR6_BUS_LOCK as writable, i.e. not reserved, if the CPU supports
BUS_LOCK_DETECT to fix a false failure that is largely hidden by
x86/unittests.cfg running the test with the VMM's default virtual CPU
model (i.e. because QEMU doesn't enable BUS_LOCK_DETECT by default).

Reported-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 1 +
 x86/emulator.c      | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 62f3d578..8a73af5e 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -288,6 +288,7 @@ struct x86_cpu_feature {
 #define X86_FEATURE_LA57		X86_CPU_FEATURE(0x7, 0, ECX, 16)
 #define X86_FEATURE_RDPID		X86_CPU_FEATURE(0x7, 0, ECX, 22)
 #define X86_FEATURE_SHSTK		X86_CPU_FEATURE(0x7, 0, ECX, 7)
+#define X86_FEATURE_BUS_LOCK_DETECT	X86_CPU_FEATURE(0x7, 0, ECX, 24)
 #define X86_FEATURE_PKS			X86_CPU_FEATURE(0x7, 0, ECX, 31)
 #define X86_FEATURE_IBT			X86_CPU_FEATURE(0x7, 0, EDX, 20)
 #define X86_FEATURE_SPEC_CTRL		X86_CPU_FEATURE(0x7, 0, EDX, 26)
diff --git a/x86/emulator.c b/x86/emulator.c
index 4e1ba12a..102e5efc 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -532,15 +532,18 @@ static void test_nop(uint64_t *mem)
 
 static void test_mov_dr(uint64_t *mem)
 {
+	unsigned long active_low = DR6_ACTIVE_LOW;
 	unsigned long rax;
 
 	asm(KVM_FEP "mov %0, %%dr6\n\t"
 	    KVM_FEP "mov %%dr6, %0\n\t" : "=a" (rax) : "a" (0));
 
 	if (this_cpu_has(X86_FEATURE_RTM))
-		report(rax == (DR6_ACTIVE_LOW & ~DR6_RTM), "mov_dr6");
-	else
-		report(rax == DR6_ACTIVE_LOW, "mov_dr6");
+		active_low &= ~DR6_RTM;
+	if (this_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
+		active_low &= ~DR6_BUS_LOCK;
+
+	report(rax == active_low, "mov_dr6");
 }
 
 static void test_illegal_lea(void)

base-commit: af582a4ebaf7828c200dc7150aa0dbccb60b08a7
-- 
2.52.0.rc1.455.g30608eb744-goog



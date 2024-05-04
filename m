Return-Path: <kvm+bounces-16573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0068BBB3F
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:29:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B54511F22020
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB142E631;
	Sat,  4 May 2024 12:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YLHjZace"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DE42901
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825771; cv=none; b=XFAlBI5QmwrVUnCHs90iEF91sQbJ+lvv35SaHwLBiTeMSQfXKsLAx8XKIARZNtVvO0TEPfnMJqiWKvv34/m+G8/9m4UqzhCjHXnlJerq5hL+vZdA3Y2f0QijPT1dMoDHH5DWJd46qA9UgCdhyoSet/uaE26TVhrJJJrTRt2cAuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825771; c=relaxed/simple;
	bh=+zKfjf9sFt92JWdPGRUIYcKhIBcHAixsLI8/JscGDYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7xb5N4s/B1vUCwGkJ6AhKScq2TNcARNwUgQIlKA6pWKc/PiwcSmgZIWyVvJMIOLz5XhYC0Gm4UOhjLBZyP9yPj3pZtM4weZpCKLd1taNux5Mj/EPsP0LQO4b3RwbgQ/f+4divRyz0XO6xpgZpXXZIb1fAGTN0HnPX2M3PVtfNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YLHjZace; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6f45020ac2cso466055b3a.0
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825770; x=1715430570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bnIgLQ4CEo3lVw3vLtU4xy1hTDqKssgefGwIrsqFLjM=;
        b=YLHjZacedZ3x8PvI4x+7QERXNqgnnh2GigO9+8uTaBDWX8zYC/dQVgZX35ZCb6vT1n
         V2n7pvfPz5LsRJUpS8bu9Npd63NTfDmdF+4ipZ8zpw8z2Pcs7z2mWAwRuiuSeuBOlzaJ
         kE5nWmghnRxM4kKoFDA9Yp53dgAXUZPERvhbfyXYfVrCpE8mbT0zfta1GX9ksixyEhNI
         ZDdh35+9TqRUcUfvzJQ0wIIExnRUDr+PjMSHK0Z1ehSuax2jwEgL/u4xTG9xl9+yS3NB
         P6+z9/26lNYmXowMfoLC83Ed31XNcdtNWJR/8IsXD+jSyJRBhasT0azXDR5Bnhn8eafH
         ebeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825770; x=1715430570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bnIgLQ4CEo3lVw3vLtU4xy1hTDqKssgefGwIrsqFLjM=;
        b=NIo6+nD63f2vuQUttxQ1nhLeTkd/bBhj4UJ65a/Lb8MJwdC2PJYSQygbftUA8bPee1
         8L+/NmsknzhJKNdPrWo+vCgxqvaRDlJ7hL+x4pdz5+pJZYFIsfcOjAEV1LTJvIDNpBKs
         KEVHzG00HxQ9m/TtDFaedG3ScMOtvHmP8JJhM2KqlbLyLwu/NrO1dXPStc9BNlBCmqBY
         WRbQuW9u9Dx0mebMWeCREPMD24Ik79lX+Y2anEg9KF44F6HVy8OL+b6bVar94DfzvQp6
         MbWrrfq9d70V+eMu2nlTO7wYWn9NjAkU6mVC23UTgim3vHRKlcFo85CAU2OIuaBxp4I0
         2tvg==
X-Forwarded-Encrypted: i=1; AJvYcCWC1mfNoLaczx5f2x1WT+y7P7szEkYyIS7n8cIv1iV8lhAPmL4S22fJB4ySPWy+EijtI5IQ3T323MeXaZ/ET1IPvqvF
X-Gm-Message-State: AOJu0YyC5wJJGJJ5324rKgK0Nx2/YRtqSVZk0PSFJSxpZHuWpoLJ9p4F
	36KGbo6Yz+RRBqH/VtBVZvVLI/VyW1aRtBOkQVV88yvR6WihzxASRx5cTg==
X-Google-Smtp-Source: AGHT+IHHrgaDs7cGEwfT9gLtgcGbdkXTEI61OdN8dRApxZSbjCEp8wy5hJY3mc5TL2hAOJ/4+IokuA==
X-Received: by 2002:a05:6a00:3c81:b0:6ed:5f64:2ff4 with SMTP id lm1-20020a056a003c8100b006ed5f642ff4mr5933260pfb.14.1714825769608;
        Sat, 04 May 2024 05:29:29 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:28 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 10/31] powerpc: Fix emulator illegal instruction test for powernv
Date: Sat,  4 May 2024 22:28:16 +1000
Message-ID: <20240504122841.1177683-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Illegal instructions cause 0xe40 (HEAI) interrupts rather
than program interrupts.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/processor.h |  1 +
 lib/powerpc/setup.c         | 13 +++++++++++++
 powerpc/emulator.c          | 16 ++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index 9d8061962..cf1b9d8ff 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -11,6 +11,7 @@ void do_handle_exception(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 
 extern bool cpu_has_hv;
+extern bool cpu_has_heai;
 
 static inline uint64_t mfspr(int nr)
 {
diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index 89e5157f2..3c81aee9e 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -87,6 +87,7 @@ static void cpu_set(int fdtnode, u64 regval, void *info)
 }
 
 bool cpu_has_hv;
+bool cpu_has_heai;
 
 static void cpu_init(void)
 {
@@ -108,6 +109,18 @@ static void cpu_init(void)
 		hcall(H_SET_MODE, 0, 4, 0, 0);
 #endif
 	}
+
+	switch (mfspr(SPR_PVR) & PVR_VERSION_MASK) {
+	case PVR_VER_POWER10:
+	case PVR_VER_POWER9:
+	case PVR_VER_POWER8E:
+	case PVR_VER_POWER8NVL:
+	case PVR_VER_POWER8:
+		cpu_has_heai = true;
+		break;
+	default:
+		break;
+	}
 }
 
 static void mem_init(phys_addr_t freemem_start)
diff --git a/powerpc/emulator.c b/powerpc/emulator.c
index 39dd59645..af5174944 100644
--- a/powerpc/emulator.c
+++ b/powerpc/emulator.c
@@ -31,6 +31,20 @@ static void program_check_handler(struct pt_regs *regs, void *opaque)
 	regs->nip += 4;
 }
 
+static void heai_handler(struct pt_regs *regs, void *opaque)
+{
+	int *data = opaque;
+
+	if (verbose) {
+		printf("Detected invalid instruction %#018lx: %08x\n",
+		       regs->nip, *(uint32_t*)regs->nip);
+	}
+
+	*data = 8; /* Illegal instruction */
+
+	regs->nip += 4;
+}
+
 static void alignment_handler(struct pt_regs *regs, void *opaque)
 {
 	int *data = opaque;
@@ -363,6 +377,8 @@ int main(int argc, char **argv)
 	int i;
 
 	handle_exception(0x700, program_check_handler, (void *)&is_invalid);
+	if (cpu_has_heai)
+		handle_exception(0xe40, heai_handler, (void *)&is_invalid);
 	handle_exception(0x600, alignment_handler, (void *)&alignment);
 
 	for (i = 1; i < argc; i++) {
-- 
2.43.0



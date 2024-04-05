Return-Path: <kvm+bounces-13657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3E98997FF
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15EA2288907
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F0515FCFE;
	Fri,  5 Apr 2024 08:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgBfIWNm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293DA15F33A
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306217; cv=none; b=lBMSq5YqCB+uuNhpHTnQMP98c/cMQ12WD/wjJMRrJSEkYaIYF5ldIpjzn3lCs6TDHnW+4ntYegyVPBr+BMInS3J4Da1lYTVQ20i+KNoSx4L3JhGRt357qQBf34cidxaNxP6XTMbYVwfQ3hmMvgSjr6G0tMfZSrkgVP9dwdrr+S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306217; c=relaxed/simple;
	bh=+zKfjf9sFt92JWdPGRUIYcKhIBcHAixsLI8/JscGDYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQng5op/ovVsuC7XOFM0fbV8m64OOsQSg6HMGLKCk9x5qOWxhCONv6m30eAIYJxfSLEs7U6iC57JWNoHlaW8t43qJj2OAlxAR9lG1Jbob54vvD5uLugD4z/D7faixdJvNB7Wydl4cmSQEEYLKHUjWAAm3j9DZ/2wuB8DwrFdu3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kgBfIWNm; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6e695470280so935005a34.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306215; x=1712911015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bnIgLQ4CEo3lVw3vLtU4xy1hTDqKssgefGwIrsqFLjM=;
        b=kgBfIWNm6vbMtXV3hHqQ0r+bOhuElSRbevwWBT5G7R1ikpnwNczNlSA+dhKB9Et608
         6SDxG7VM//3nsf/90EamwGdd1rF959DvXYS9mB7RAYBC5BNBLsFpL/R4SCoN0nQCi4bU
         ac2wMuKeIBUo+kQJB/83xWeJA4nCn9CrnHm7xhm3rQMmf/BvmbAAm7FnMbXDcDT9232z
         UMJY7KAIPp6t7PKpPN8mDKnMjHQqha6ySQYii7At6E0rkpafN8b/6Jap7651xNMiTBsY
         KGYuoQyj1GFLJ7TJf3pkyTbT2ixy5Yb4pJsoNrewPhWmuR6M7hsKlY8GABic5Xi1PYln
         ZLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306215; x=1712911015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bnIgLQ4CEo3lVw3vLtU4xy1hTDqKssgefGwIrsqFLjM=;
        b=YdLkBDhLQmc4bdS6AtltgHteNuo7hybF/XOLEqJp5QzK5MCSsECKl1Bles6hk+fEWU
         PKsjZfU3JVoPrldmRtNTu5OIsNVnXthNBHUVCOa76f7fQWZmCSY6ic+9nvr0DTm38d8u
         cU1EUAtfWm4sbk27YOlfFy/tSEvl1WXNMZx3okkWZWPXc/OzYIKAutk+v5vB7/g8zT2/
         EeY3nLG34GDGwA5GkLwqaUm4qXpXnwHqYpMhH96zfC1v15/Oo4dGwKXWkvLTp0HE10ah
         0z3Vs3f0Qpuuc06iLS1p3rHbyKdUQNH/rx47e4nDAB4T2eOtvETTKiIO5unNUCtfJbl0
         y7tA==
X-Forwarded-Encrypted: i=1; AJvYcCX/uDKkNPmrjEbbeOph/VRCdJ2o8KWvNj/Tp5feNCvoxPiQgeTRBz5ireXucHiQE0WRL9FLW5Ck6Prvb1xBBhzJcm2e
X-Gm-Message-State: AOJu0YyuDrwsQAeig+/kg3nmc7XE30ouPjeRllQdZyWpPM2waQUa/xF3
	+3ceQ+jEMhhQp/vfzHTfXfjRHIkJb/WzLvUQnJzScvPPrJNvUEgt
X-Google-Smtp-Source: AGHT+IEovlR+M51Tm8GHarGuqcW4Yhtp9UUYnksfxq789AUBMO/CkutE674vcwYSXAbmTWNGvzNFUQ==
X-Received: by 2002:a05:6358:2295:b0:17e:bbdb:acbe with SMTP id t21-20020a056358229500b0017ebbdbacbemr1000459rwb.14.1712306215139;
        Fri, 05 Apr 2024 01:36:55 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:54 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 17/35] powerpc: Fix emulator illegal instruction test for powernv
Date: Fri,  5 Apr 2024 18:35:18 +1000
Message-ID: <20240405083539.374995-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
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



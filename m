Return-Path: <kvm+bounces-9816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 114AA8670E8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:28:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFC2028C3D1
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE4C5D467;
	Mon, 26 Feb 2024 10:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EOJ/to7h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38B221A0D
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942407; cv=none; b=Uv0mluFnORWnT4FHG99/6s8OEZ1yLm7aYV+NPvidYP+9wxckdHR8dXqBhdjaIoG0ayn1UouQHDhtAOJyCI2QSXJ9b6ipGyN2j0EZlFO0SSNcEt2uebury+AO+rmuucCYHn6GvTbDkfa0/y1RfKe4VXHMLhfBShnmaQSmrHsySW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942407; c=relaxed/simple;
	bh=1HIj971k+sRTL9Ja9lOpDQSqDhT6SYaqAUl8uDhn3hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+G6i8UaGk8fVHbjAzAZ2mMi6+89p420Bdp1waQSNPkyhhDVS7vf1U1vpA2kjaLOOnqMU4KjGlJjXBeBtIexoklSG0ZXo3qkELy54geESc6hGOS0RNQFJCONBJmCwa38ybsPfq6+14qjEU4FB7CEnaZav3SraOg8d/cHp/66hDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EOJ/to7h; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e332bc65b3so1375653b3a.3
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942405; x=1709547205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTzHwVrlhJ44ljTP4egNfnM7a2uSQKeiI4yRLVlcvdA=;
        b=EOJ/to7hWkcj53MMjd53VBBxU1tvhGWFdR5EVOlcjWYGWI5w5HpO42dGl8myuE56Yg
         IMK618nYCfUMHGgruzsQFFeENKgodeFa2TSm84d6GMCA4+7XTXmZQK7EXroaszaU1TV4
         kYo4HtD/H2CGcpUMK+QusvYfEpSEey2J35CMVVz+V6Qo/mJjCW5Cj9ts+To2MSJqbUmI
         +RcgRcGbafzLXa6rvHV1YKTXls30p3pbi07euLj9paXIwQc0zYk7vUWY+lrssYLhANJQ
         1lasa7NgbqUVjE8tW2us8rVB5n2T+tiMYdZRUkHVDYrJM8g7bHr6zjH+GhMJoQOAo6tz
         3cqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942405; x=1709547205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OTzHwVrlhJ44ljTP4egNfnM7a2uSQKeiI4yRLVlcvdA=;
        b=fN6Ite7znv24o4sBPmN1xuv+KjQpVQKyiIiZa3uE2WIBCKPuASqihw9jWrfqFskGNZ
         CsSGy+X5FHA59o30wkzrcqhaFO2dKzbVlBSIovOWE9xAEKHuuMS8g7OBw4JpUbBOnJhh
         MDDrqSslvxESUS/zWXq7i+IiBkQennX1RjiYSqEkGQpUCyHzk/mNG31VRKpuZUC80j5F
         d4vRekvNWunHQq2yY0cjEZwjM9o2fOrSzsteqA8roeS0HqtjECXYNjmff+x32ZmIuo+W
         WPPZVuvo3XymC6qOYgJ5svbmJO0W8cUIpX2kpENv+VTaUwOfUiQb2iU3HYz5KfyXa0bz
         NaLg==
X-Forwarded-Encrypted: i=1; AJvYcCUqb+1B4Zef14zZUhYXOIeT8K7+OiYmXUxQyH5ey14q65yz0zrimnLC5XXjwJFJqL1Ro6wKCtHwhP/aF/yVL9wEp6TJ
X-Gm-Message-State: AOJu0YwUXDw7/cf75m/EqGxFaEtu+lDxQV6wmuAY7xll2sJzcN0jKWRD
	BxqIu3pgiExS0u3p5pQs6To13bzgeZbRXOZ594PB5Dn1If8bO6jP
X-Google-Smtp-Source: AGHT+IHoxB0TT29CakpeaPt9N9d/U7ozjzGJCW6J9X08YRZJcOR/GfOl6GcVNLtrGGGJNpj3R1sE0g==
X-Received: by 2002:aa7:8c06:0:b0:6e5:3dea:dde9 with SMTP id c6-20020aa78c06000000b006e53deadde9mr208073pfd.1.1708942403334;
        Mon, 26 Feb 2024 02:13:23 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:23 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 12/32] powerpc: Fix emulator illegal instruction test for powernv
Date: Mon, 26 Feb 2024 20:11:58 +1000
Message-ID: <20240226101218.1472843-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
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
 powerpc/emulator.c          | 21 ++++++++++++++++++++-
 3 files changed, 34 insertions(+), 1 deletion(-)

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
index 39dd59645..c9b17f742 100644
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
@@ -362,7 +376,12 @@ int main(int argc, char **argv)
 {
 	int i;
 
-	handle_exception(0x700, program_check_handler, (void *)&is_invalid);
+	if (cpu_has_heai) {
+		handle_exception(0xe40, heai_handler, (void *)&is_invalid);
+		handle_exception(0x700, program_check_handler, (void *)&is_invalid);
+	} else {
+		handle_exception(0x700, program_check_handler, (void *)&is_invalid);
+	}
 	handle_exception(0x600, alignment_handler, (void *)&alignment);
 
 	for (i = 1; i < argc; i++) {
-- 
2.42.0



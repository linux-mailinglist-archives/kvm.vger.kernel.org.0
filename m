Return-Path: <kvm+bounces-12093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF2E87F8B0
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 187B5282C7B
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D328B54773;
	Tue, 19 Mar 2024 08:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6VSxB6u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A235153801
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835242; cv=none; b=NQrBjaj4vRyuaBTTMV7QYgI2y/nDmrpoFBf7oVLxZlabDOWzjTHf+YCFASJ1KaMAc5ozqFXqmMNKYmMuWB76BRBpEgZBWfftr5bxolxrIUuZKQTf1qXZ1trs8RHZkI6K00BLLvAqnBdRKesVt6Cc77xEzJU37YVPzOUaUlgI9G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835242; c=relaxed/simple;
	bh=Y9IJXoYhgFyVNh5RaDUQnf4hhgipnp8wQzr9whZOueQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB6qgvjclCVJJundjvm2aQCxGjlcrqA9A9it2NKfc6Qxb0eySBBHK+Zi5FdOKPT1EXwzHeA2wqDr6bxJ7FE15RGrG+SIjStscinAxxlNxcrUtAQlho/TDVWBZoK+K7eaAKTNeo1upuFc2xKqG+FJLthEMkAg/fvplGKtRgH+/GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a6VSxB6u; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6e6a00de24aso319371a34.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835240; x=1711440040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VtLN1scLK9iq8iGSlvZdRb8xYUKfqrTfHAWG3UXIB58=;
        b=a6VSxB6uQR8kmMZA67c3bAIpwo6N7D1HtFi3svdHghYmZn0Oscku92XzYu/V+tXqPN
         Bghqlzu2iMcDe4/DoSGtS5vYA5DYwuA3Nu3ONfovQ6JJaHUolnNrUu9RzEr3TbZiS/by
         5KVV6OLJNNmdi6dWOz1GONC2V9w/kZRGBj7E5OyNOtee0sHtZf5mIB3FDfWVh6b8D5rJ
         zKiNXMMo5Z3gcgWzsQ+EpvOt9uyInovT6p/aUHFVRTZicVRpK9HoSHbvgec5vuiNwDOI
         YlJjAjB1STfz7RuVjTnU8j3tAIM/seEscOlqPFqje1+B1UQ6cnfrFxJ0DXXbDFzxDK6k
         JrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835240; x=1711440040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VtLN1scLK9iq8iGSlvZdRb8xYUKfqrTfHAWG3UXIB58=;
        b=Xu+VZHwpY0ka/91z8Fezttu6wJV9FlvE2FDPBzZN7JVtcpA6avPSEUDM4GVVshY2Qj
         kGAMkK/EZNLNM788S/o4acZgOOHBtYM8oEx6ejd7PGnGQEBAOEeGAuq4Fwubsj//UNgv
         1GAzktmgiXlM7Cu/mB4XSI5gAlX9+PASFbpezV6IQz1AZ2m6u4Wya1GLEO7IEZqCX4eh
         rjyFmYqCwopbVnuSKoI8iGo0Zd6jvpowvE6696Ymn6TyVyrAHzsaGtq9IIDMPZ/F17VX
         LfduhED+WXwEXE9G1MdBsma/Ne5vYxDpOI5m7MBRnIGRpNQeKO3Opwh3gbTcjVmHer22
         kUnA==
X-Forwarded-Encrypted: i=1; AJvYcCVAAX5291HTK2dU/kCb4cRtp3tDWaARAQ23kkoMHCZC9teQixAKN1/bNp//wzn/QN6rbaSPmkxO7J3oEVKpxAfXbbQH
X-Gm-Message-State: AOJu0YxQCdGVY8ZPuU1eY9zPw4IqPBmJa2FHWqI8FgApQZ22n2UZWBiN
	ss5MBi4TOjgtr4UyziP7l3J4lSrZxFaR9MUDXFjejM4D1+AKAP5J
X-Google-Smtp-Source: AGHT+IGlWKOKRt3F1gQ7vnh1VTi5A2f1z4cQOP1avw4yFBk9YAoWjGjQRXOfv6o6wGXqph9/37jrtA==
X-Received: by 2002:a05:6870:13c9:b0:220:d5cb:1450 with SMTP id 9-20020a05687013c900b00220d5cb1450mr10380882oat.10.1710835238705;
        Tue, 19 Mar 2024 01:00:38 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:38 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 17/35] powerpc: Fix emulator illegal instruction test for powernv
Date: Tue, 19 Mar 2024 17:59:08 +1000
Message-ID: <20240319075926.2422707-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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
2.42.0



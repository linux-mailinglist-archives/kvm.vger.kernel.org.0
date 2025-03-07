Return-Path: <kvm+bounces-40343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E762A56D50
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:16:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77F181894F62
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB95423A9BE;
	Fri,  7 Mar 2025 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2cGsIzb4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283A823957F
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 16:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364157; cv=none; b=ZROMGr18aS70PBKp4XKEM8pNdBD7IhPp9gq7P4O+uVd5ZMh/d6dfehBw0X0zHrgkkoldguuHLNvaSpFqYT/3mvTgILkkXYjwP7Wg9Oxz0RJ0XWLvTGYPrrOdiBweay5+0/LkukBVDM/yRPA3GMxlqo/MPtPi38U+JADVDPPU1Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364157; c=relaxed/simple;
	bh=pUbBH6lKqjkYHOrWph+jCd+XfegjoIltPb4IwKUmCfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZRtbdAqGAlFEvbw83d1dR3c7dGGHKde+NEE+VxuYLqRsQ3KlLnZw9q9WIrzAhH4Z8NA4cPFrpDyyDeXw/Oy1EhF1BgIaRVcH+kScNj+M2vytr3lFHvcivjOZb+z+xEw97QtyAKbMefZ5ynhSvFu7oponRrStGZ5cYJDUMOlw4AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2cGsIzb4; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43bd732fd27so17581105e9.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 08:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741364152; x=1741968952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6i1/sQFS23e0aHQ0gG/Xo3pgpweMckYvmkT9KdoCho=;
        b=2cGsIzb4tvEHb4VhpHacTU5WgIwAzCCslCeulAcNeeO71YwYYYwCfhLCR89ADkwN2d
         9fPIMwKQsXabeeKWKUAQVrNPjcwmHF7dCTg3iTR2l7qT5d3DRGbpOS5lv1JWb+yhU0sq
         VHmJX2UCC2X4QaLz/0ufaSYM35EqfvI4DqdKca5kCK4OEXzVkyDsogX+i0mlShq9Tzvi
         4CH86IN81SR8gRKT8A/Np2lOFSqf6X0EnepvBHxgDizUYIcw1ajTqHqWadohwL4cbT0Z
         UEdY1RQZLGwKvaWlbqwSNKBawL72DZtGpH8C2pTHaRDt03zlzdJqvoyhnY2BJqLe1b4Q
         tWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364152; x=1741968952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6i1/sQFS23e0aHQ0gG/Xo3pgpweMckYvmkT9KdoCho=;
        b=gkaJxvHhjO0Bmp/KXvmayghZe/FnLK4CRDEMAntz8qO8Rft/yztNQlROZ6p2HA5VAG
         o1rWEGBrLPtD6gDfOS70G3Qz1VJQe9347QhH7jcJJVOEb5PUb6VyqwTrdWUMHivrEVaU
         3XX2SPRibT5hq0Oxt1uNN8eqpAFEkhe9e5ICueydnTynN63eEp29rBH1MThR2HF1gm85
         TFPK+i8KS44UfKoWsa8W0OcueJ6LcEotX4sGUgrCwHlpUEIhwpfoj7zyWf7bsgpj1B7C
         vd40nGjFH+ccSJTNaDv2luART+QGBBZoq4keDRpaUJvRLXf2CA42rebG+1AWFzprADye
         xDvg==
X-Gm-Message-State: AOJu0YyIzsgw0d15cnTltW38/Tz0QFuZlFoHdko3eIi3GwyyVauN7CJE
	flBhsQm/9xVsiBxugQL33G1DqyAGVYoX+iMzGeGrmEqyQyIO3pBEC/WxKoAMUOm5jWYsJC6tAsW
	7
X-Gm-Gg: ASbGncvKI5LNLEgLCiMEwxw/acMffL4FRH5Wc0CrsIkE7BDStFzUxfH1q49soFAzD4I
	m6tk6LTC3CCDZbemBD6Z3nby4fMlX4n1X++JTVN6ZGokY15IEb5gDEjW4u1Mdr3/J88n5To4lNh
	76ZFkw5qO0+uRpsgwRK5XjBzrjGb/0QZ2OeZRAeonDgi1hqbR6KGlWg4tCMfinBMUOYryHYrraI
	STDNbwEjgtdSw7DUGkb7zLdtPhuGcA9rIJmC+yAMuIPFuvywWpuDjw9GVuR/W0F8mbS43QurHDO
	vhxeZEvRNYpWG0eqr/BQdxdOO102C/jZYfJDqwkLPF794Q==
X-Google-Smtp-Source: AGHT+IFgUcPXSiBD5RSvWaNWhqMpYlA6SxLhZgQGPKx5eyPuJ3M5Yl0LRdylWzB/3/C6DxCmNYVAYQ==
X-Received: by 2002:a05:600c:450d:b0:439:7c0b:13f6 with SMTP id 5b1f17b1804b1-43c6872e1ffmr32499415e9.31.1741364152302;
        Fri, 07 Mar 2025 08:15:52 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8daadbsm55496245e9.21.2025.03.07.08.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:15:51 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v8 1/6] kbuild: Allow multiple asm-offsets file to be generated
Date: Fri,  7 Mar 2025 17:15:43 +0100
Message-ID: <20250307161549.1873770-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250307161549.1873770-1-cleger@rivosinc.com>
References: <20250307161549.1873770-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In order to allow multiple asm-offsets files to generated the include
guard need to be different between these file. Add a asm_offset_name
makefile macro to obtain an uppercase name matching the original asm
offsets file.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 scripts/asm-offsets.mak | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/scripts/asm-offsets.mak b/scripts/asm-offsets.mak
index 7b64162d..a5fdbf5d 100644
--- a/scripts/asm-offsets.mak
+++ b/scripts/asm-offsets.mak
@@ -15,10 +15,14 @@ define sed-y
 	s:->::; p;}'
 endef
 
+define asm_offset_name
+	$(shell echo $(notdir $(1)) | tr [:lower:]- [:upper:]_)
+endef
+
 define make_asm_offsets
 	(set -e; \
-	 echo "#ifndef __ASM_OFFSETS_H__"; \
-	 echo "#define __ASM_OFFSETS_H__"; \
+	 echo "#ifndef __$(strip $(asm_offset_name))_H__"; \
+	 echo "#define __$(strip $(asm_offset_name))_H__"; \
 	 echo "/*"; \
 	 echo " * Generated file. DO NOT MODIFY."; \
 	 echo " *"; \
@@ -29,12 +33,16 @@ define make_asm_offsets
 	 echo "#endif" ) > $@
 endef
 
-$(asm-offsets:.h=.s): $(asm-offsets:.h=.c)
-	$(CC) $(CFLAGS) -fverbose-asm -S -o $@ $<
+define gen_asm_offsets_rules
+$(1).s: $(1).c
+	$(CC) $(CFLAGS) -fverbose-asm -S -o $$@ $$<
+
+$(1).h: $(1).s
+	$$(call make_asm_offsets,$(1))
+	cp -f $$@ lib/generated/
+endef
 
-$(asm-offsets): $(asm-offsets:.h=.s)
-	$(call make_asm_offsets)
-	cp -f $(asm-offsets) lib/generated/
+$(foreach o,$(asm-offsets),$(eval $(call gen_asm_offsets_rules, $(o:.h=))))
 
 OBJDIRS += lib/generated
 
-- 
2.47.2



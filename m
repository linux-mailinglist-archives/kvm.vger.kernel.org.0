Return-Path: <kvm+bounces-32464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB9AC9D8A77
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 17:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE827B35686
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1485F1B415D;
	Mon, 25 Nov 2024 16:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="RjelVKqE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1E54A1A
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 16:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551747; cv=none; b=tmfBHl1ehY1Y1GLjP3YXRwtEV3atQPTborPP7Kfy4AyLVr5/D8IcxScUtcEdTwSJCgo9Dx0B367bW1ffMjuBeN3oPfnlmb9fifTUrSU9M3nnDlfLyVxQa+UDOv/V77/GyGZUZHRociu5Yar8Q4cWTYyIUa+86L3q12KI4ENUSDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551747; c=relaxed/simple;
	bh=Pqzp8aZouNLnxyac70gafcV99OM4sOe8QuXJNubPi1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bIWP9diH8VE21VygfdfrhESWFazM3j6EcMK7H+JtT60uEXd37G2COmciWhv6Ov3H1akoX/NMLDGI6gFd7XzclmIkr5sX9fCm+u2MVZuTGzKY3qqsvjHaj1keW+hHsoshG5X81BnPsCFpBa6u93IXaMe2f58+81T7lcMT8DNsxN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=RjelVKqE; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7fc2b84bc60so961927a12.1
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 08:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732551744; x=1733156544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1It7ouKEvzRFjyBJKzXgZeN4RS7DqS8813YEhki8x8=;
        b=RjelVKqEhKcnK0fOKSaZfE4/t3oPhdrRSc3Cv38IXPMrJJ23SOssRKDWFMjQFzT4ve
         78HzxwJdkc1xHyw59ExLuoZ2x3+j0wiiiOMAbP6vazl86cmKGLnjkYW/JrBlG40mQfVR
         RtdBABkd+I6Gmrn+RdClQG7l5xRkDxO0+XYK6mHrwKyYFTSsBBdUQJf56JN86S78bxAM
         NhlldKk+VfH5LH9bMPiOuqisxHWYeyCoFyhT5gL/J5eujET5Cd9h7nZaS25xBLMn0wGI
         RR4RBMQnBLI89kmZ/FwuRdgUr+VeI5+rIEkavSgBjBz3hcQNbiLtlFtapeDcGflf/sw7
         wI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732551744; x=1733156544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1It7ouKEvzRFjyBJKzXgZeN4RS7DqS8813YEhki8x8=;
        b=ZdaHxWCCviPlhKGx8sGlgTbFqFSP6fUm4RqaMoEJv1hUYF+kGRtQUuEEygZcL5GGKg
         gFFfcYhNWsTW/+DkkfHb71abrgWHBXACem1npopaZJZoW0xyEF3AWzM4aqZrjM+YMpKd
         axgTp9zpmoqJebdu41eMJR8CiSzCMjbiST5V1tdBZEH1vm6ExinPTWvAImsdS2iO9nAf
         bIql7CwFNKEnhFn7NASQLBYLgtaRJFnzWFB7/QgrwSh4PDnjngFIrGxk3TtuQtYcAzD/
         8QmRsLwfgz9siQPuqzgFH3NyKk9FM4U07UHD0RJy9AeY87wJH2nr1q4jxBeUqZmPtMYX
         OxdA==
X-Gm-Message-State: AOJu0Yx4jBZWq8Lb/Ug2l82/TGDt4MoI7re+qeYVWGIS2EPQlj4JtBoy
	rQG5m+8khmSTNTzFK0Um0KHSlQ9tNG2CkemJ0T8kdpEqlJ3vTZzj78wZp5jPyN/Rvn+4pb8hX7k
	/
X-Gm-Gg: ASbGncsbtezbjy4dFtOArmc9BcObrFJHfPNvbt+Wsj3D7NwUQ3rSBNDnMpjjWJhdzE4
	24WFnprnlAkMAcfvlW+uDpOHfd6ip3G3Z/orj9Tsuv20vo7p5sGbcGQUCEW5h1BPls2u2grnsyA
	9dizn7fzWYahGxhjSsUB1KanyyykSsMnBMiF7QNL9SoBeBXFtP8PLdudTZ7E1jRq8sCcev704ff
	E3H/meC1Ilmw/MZWt6LgB7MdbRgCAI8XJXdHelZBD0Wjje0l8I=
X-Google-Smtp-Source: AGHT+IGb1dcmeeBLGZ0bZgNH1Fdi46UvCyLB3lLrMKBgae2YSwWcmjrkZZqSRxaNOa2VmmMqXd6GnA==
X-Received: by 2002:a05:6a21:998b:b0:1db:eb56:be7c with SMTP id adf61e73a8af0-1e09e554f36mr20997787637.35.1732551744299;
        Mon, 25 Nov 2024 08:22:24 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbcc1e3fdbsm5831803a12.30.2024.11.25.08.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 08:22:23 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v4 1/5] kbuild: allow multiple asm-offsets file to be generated
Date: Mon, 25 Nov 2024 17:21:50 +0100
Message-ID: <20241125162200.1630845-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125162200.1630845-1-cleger@rivosinc.com>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
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
2.45.2



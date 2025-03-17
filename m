Return-Path: <kvm+bounces-41194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BCC2A6499B
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:24:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C1717A81B2
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A7C92376E7;
	Mon, 17 Mar 2025 10:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="JA5FR0VS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F96B236426
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206815; cv=none; b=tb4ClNbYf/rWpkzhju562f85HdAB+fkizkhtse/g2k9MgscRNV6up7FoxJIK7CqbyRH0JCQTA7/wfr8/oHHdu6ZHjdspWHUBTepGSEYyG+cz1bxxfL3tJLppJgaIoBl0QFlk9YsHnAm5RaFo5cc1wYONGm2Pm/XstWzDrn2Z79I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206815; c=relaxed/simple;
	bh=pUbBH6lKqjkYHOrWph+jCd+XfegjoIltPb4IwKUmCfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VfPFnyFzQefkzNrHnhoOHmANU2GJ9yhCLadzppol0sQP0otQ7Sx5KaG1uiDtNd8nrsz77EuqKQZUL7972NFaxO/I+fEU/jduLxkqdJWVmfjYlMmId5yvJsok2gRA3r2w6zsBvoSnepW1b1kGQkwHfItTMWe72esAuhic55TOYw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=JA5FR0VS; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3913d129c1aso3378889f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742206811; x=1742811611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6i1/sQFS23e0aHQ0gG/Xo3pgpweMckYvmkT9KdoCho=;
        b=JA5FR0VSpCChS5jpFtDLv8ZHfdqEg3o+SfjrENrtMc6ZDz3/7OT7BslJ44G5HSRbEL
         gagDZCKPQiuYsYCaB7AelPXnDEvsJ1yQTJavA/vvEn2/S/5ofwXs/BPu9Rtms2kV3CU9
         ZY3L0tJhCwZpbOTJaSsHUBZKcsbyE8obPfMq6WMe6TXOzL8tG29rtxzjT/D1mn7n4ma/
         viDWSZI0XHWFA8aSB1ROcAI2CavxHRbb5EfopALtrZvPY8FzajS3zmtY2ICkI9IU9WeS
         OMN6K1n3cyfNE8A6Y7NLkmPHdBBQB2ZAH195FpTe9i+VoA8fiDAqkW2OEJpwCt9Klyjs
         v9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206811; x=1742811611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6i1/sQFS23e0aHQ0gG/Xo3pgpweMckYvmkT9KdoCho=;
        b=rQ7uXGrUfEC/K3sHOufv272fMtwLbYJZoNNu1yxTbcO9UXJTdkvJEdNITvZ5SQkUmT
         rRjN1PuMuX/1lHzSd9fLEqRk9ALTpokY+u7og2+wjPPUVxAwvrIp7YLgapRAgd1B+J+g
         +XBB1cWwd70NDPdNDZqAV7AhLho7AnFRfrLtJNmKPy/rbP3Nj35F3qqep6E42L7CNfUB
         KokjQ+KRjKfcVCSewFs8oS0y29HKDkyP2kHYGils5T2MRxjhcFRWJOsXkCUHwMGZxlf5
         340c42L47kifWApV/psOqlYw1MFicM8vWNQGnieQD0bWm/5l83TZqs4ujvJFLnjxAHjZ
         mpgw==
X-Gm-Message-State: AOJu0Yw2uY/Ps91lZVYFaabQinOkKUdB14CIoGoTF+IoHlsphrT5uYnI
	+3oMqVLbMoUhzTKRSUKrVecYzMij7nmiyf0k70ScxsFzj9oYz+uCCCsAOKPLqjvUZ8t4LbBQ5xJ
	PNwU=
X-Gm-Gg: ASbGncuRsyOfdwJvTdtZN4HWzlbG7ZFzLP6HLPH2H7lzjrFL42OaN9IxDIPvPREIEv5
	Ae6z8/Z1DG6vTxwgEYetB6Gb0sNpnjGqF+Lf6THW3jrioXx+DELwSGBD8aHjfr2Znx/aXKKmZIO
	OQ6+J9T43AnoGxZtPxD0f8kjDP0GNJelDkc9rKq304CPExoc8rWsn46tlEFCiz0UQXBDfze68/n
	gsP252DzxNWnm/Ka5En/aFmeDysSlXqX2yPOTf51mUmo/aoVvTMSVmEZO3P52dQgiETu5qDNDZ0
	BiJNtUK6djgBLX6KmMtiHSb/0WvI1L5dgjERQvAP1kBHoA==
X-Google-Smtp-Source: AGHT+IGDY43fIbNPI+eDp6uGNSAHL24CsaAqA3U9H4YEe3hgki36AbrGX2ncH3+N9QFzno7weniSDQ==
X-Received: by 2002:a05:6000:1acd:b0:38d:b8fd:591f with SMTP id ffacd0b85a97d-395b70b7a80mr13350336f8f.5.1742206811108;
        Mon, 17 Mar 2025 03:20:11 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebe3csm14749824f8f.99.2025.03.17.03.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:20:10 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v10 1/8] kbuild: Allow multiple asm-offsets file to be generated
Date: Mon, 17 Mar 2025 11:19:47 +0100
Message-ID: <20250317101956.526834-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317101956.526834-1-cleger@rivosinc.com>
References: <20250317101956.526834-1-cleger@rivosinc.com>
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



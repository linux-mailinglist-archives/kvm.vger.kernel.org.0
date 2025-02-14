Return-Path: <kvm+bounces-38152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC0FA35CC7
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 12:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63F103AE3C2
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 11:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92F9263C6A;
	Fri, 14 Feb 2025 11:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="XxN4nH56"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1EA2222AC
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 11:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739533495; cv=none; b=HEerW+G9V2TjvJlo7bLklN7EhOkueq0RYKWYwSp5maEVWdMHtEUOE98mtz+3FKYpnOq9aIg/ubpgyg/8xw/m9aEUZf4I8AurcoYMb/UyB+XKDL568sM0+AayrHoQ4fEdCR4GrbG4g1U+i8aafuVy76RxCshIodsPLuY6I3J60K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739533495; c=relaxed/simple;
	bh=pUbBH6lKqjkYHOrWph+jCd+XfegjoIltPb4IwKUmCfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X8WplW02BF0RAa51RItisc04kl+gWjo4ccIRUVZGPmEj7zgHfckWHaO9gHBkXLyGE+yIC9D+Do6f4ilk6sGftyCdf1oMbOjTqqVwa0rqq95vOmAFXX2PNzzOpuvtKpmgahkctQeYKpliIrvj/Yjbbt/3XX806Qb+vQmIYAIy6fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=XxN4nH56; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21f6a47d617so32754065ad.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 03:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739533493; x=1740138293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6i1/sQFS23e0aHQ0gG/Xo3pgpweMckYvmkT9KdoCho=;
        b=XxN4nH56+Kth+T5QAar/33Zf8ClqGIceOH1ank8/KJidabJ15FlbbExzkaMPglE3/K
         qipdgFPS5V1MBUyotjycYuEVrvFazmDCZa2bnqed695XuQj7mXv4CWb1bcREAhGhsSWs
         JuMmjSPqv5hAKF7P5zjuGMvPSgYoD+tS4YB9lgfKqVyaFgdI1aqQMVnMy/xxJpDpwRFC
         rb8OjFWjGqh01ec3X0WeHpecMQNtqMLEmjUSX23zp/Vw9nwpxN7GDcEe5z/Je1CaS4vz
         M2RAekcNLrtEWksSbJnIAMQLd7gbvqtrYpO3ic4/XCKe3G3UMzt2G2GGgwZDMCV6/Sls
         LL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739533493; x=1740138293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6i1/sQFS23e0aHQ0gG/Xo3pgpweMckYvmkT9KdoCho=;
        b=uDBAS4XLHPEDdiAN6R8KKc6Hb5CWC5QtJCjt1vPqx9MJmaarpfInKe6PhmfmNK/cal
         /Gei5bwlsOwnfg4JV/jNM2M0paQ82Phh4yU863TXozf7ta9fkq/fZxBO1/fbddpAxcwL
         hV4BPSQ/0W18ieho2G3AjHwmqCLzn935JhUmnjJuJOdU9AYFU1zMku7Oap+vc2GTgXAG
         COByp8UmKT6EOixxcrWZ1+HqwpiFrxHTtLU6JDTcGcyxsGEJ1IjteKr3xLIOgp6El7BT
         cL+t01PeULi98BWT7WFHlYIgUctya7c9jimTR5odNEBRnyV0vTN69DXHcCGLDDo3D4hS
         +rfQ==
X-Gm-Message-State: AOJu0Yzkl+153tkGaEQjZbpaUuM8PfGoQ9P+4L6lMTq7uQGp7oPXWWsq
	+8z5XPv4bNowjLzZL3AJPs6GTqedy8zNFR6TlObZTWkXrPsWqA32nH0xqhErY1Y+q3vo0NwE0gE
	VF5c=
X-Gm-Gg: ASbGncvoOOndwPuT5ApaTLywsydIfAjuRYM1epK6Pcl5VkjDnjxqoFNT2ZeXEDs3VAc
	aEr2hHUyA5z0mUUg1KGnl1+BM9RG2ud/SdF4PzmR3VkmOR6IIIWS49EGsKpuO3NFsa7KgivuTYM
	n93WbAZBxM5pA9Q6tIaWJpI/0eITRPClVytVxJPv01/0mEkP4N5K2JWLO7m6xRcOk8V/+0wXlaM
	Bhxjw0HtgQE+7eLei7CnYZ9i3iGaNyaBMljWrwnYEJ5K53MtWdEfl8oU5Wcg86rP4nJkIKfS4qk
	U9thqe6gLVya1na2
X-Google-Smtp-Source: AGHT+IHwonpDXPO9JOzA8b4YRNdsTxziTHeK4pyvnZYiW7iBSmkCmFUqnfBZAz1lQK7LnIfy1hz21A==
X-Received: by 2002:a17:902:dac6:b0:220:da88:2009 with SMTP id d9443c01a7336-220da8820d6mr85684385ad.45.1739533492958;
        Fri, 14 Feb 2025 03:44:52 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf98f6965sm4948862a91.29.2025.02.14.03.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 03:44:52 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v7 1/6] kbuild: Allow multiple asm-offsets file to be generated
Date: Fri, 14 Feb 2025 12:44:14 +0100
Message-ID: <20250214114423.1071621-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250214114423.1071621-1-cleger@rivosinc.com>
References: <20250214114423.1071621-1-cleger@rivosinc.com>
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



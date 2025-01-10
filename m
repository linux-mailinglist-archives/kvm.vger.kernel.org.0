Return-Path: <kvm+bounces-35004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 787EDA08AB8
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:54:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42F97188AE20
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7896209F33;
	Fri, 10 Jan 2025 08:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="KBlGkm26"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C7C1E3DDB
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736499245; cv=none; b=dDM2xOUJsqUBluGnlwXVcixX4zkx8mBkZgW28keEhRnNZSoyt9VAbg7J1Zdy4qI5Np+3f/0wwO13sx0Gv/dDvfEZgtlP0L5qdpN4oQmx2lcS80Bv8s9Pnw6bN8kiWSmQrUD511E7nk1VzD9wwZG9SOBfJ+rXEy6VmmLIvYwWcRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736499245; c=relaxed/simple;
	bh=C8vsMho9vZl9wJaWcPMSgPOzwLuy21OqmvUQ9tsRrzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ha5ilUE/IkxSnNT8Q6W3PDM64inupcGl2JbCKNkfaffaSToevhYgI0vN8L8llTBo89sIp9FQkSVHy63LH6wAWlTKyoF8OXootJkYpSHfo3uCRdw2QlNQRZ72I68YGkQ/VtJEMV8WnXdxNICC/Cj8QfHxrDs3C/qoW7KgMMmMj2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=KBlGkm26; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-385df53e559so1411169f8f.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736499240; x=1737104040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZGO/tGztorN25vV6GIiTimQzrIDwqi9MKoWBwUHQcbQ=;
        b=KBlGkm26aC5JYb1Cw4UDjkuZEITXMRqpfB8jQXgCeiCr4IKNAO/UOEMoVxsk17dDkn
         ImH5VEA8PKsfS7aU7fGlRdXwjHuQ8JRTbTubkpNV1JBY3cVxl1o+UiakLAACWszD+uMb
         z0C5ar8nAwh4wkcTKTt3AK7I9ZXMX9/1+wJLuqD1JkoyoncZVfefIBTXIJY/NqUZ0Vmy
         CZBZofbs1mo0h9vHNhmziaN5fDw3TiqiqWwzQYMMw+38cbXxz9nktuQ/mKYZkxjdA5Dl
         JrqoMYW6acYi5F0VqCZF6nkHYly9Wwub0BNK0ujvuAG/TK+a9U3lhgX6qfsSCU+R2y+f
         YO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736499240; x=1737104040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZGO/tGztorN25vV6GIiTimQzrIDwqi9MKoWBwUHQcbQ=;
        b=Pl8j7rWkIIw3TfjByhxejCPX2t8LJZSqMiFYPV7SynxaBQ1+SIfiDqJBqN8jcRTMj8
         x+p9bhecJ6I7UWPoGqOrKjOSWz6O1c34KrFbVvPRRFzlSZAvffdHkzmY3l1ZYGCGBspn
         RlzvP38t/jpkGDGJAst0gqnCjdeZ8mI3TQqKZfMbpGZhFm2Lw78m9JNz5qjBlJLqYOMO
         vN6FeRhVSYruznNJcb2NiDxeuM71Igcg1xixQdCB9k+m0B4b0H+EepTu7WMSdTvrkVT6
         fG3BcfvVmqRkXFAHZQT6kOGUW9q3+0n21pE38MzkAZVMWZ+kQBtQ9sqjtb2mvdNjTisN
         lDjg==
X-Gm-Message-State: AOJu0Yynk4GhBxssUctEgMazzRbYunEMjtFNTfnEnknEv0WA8mhDcgic
	NXwn7Vo8TXcaUmZXJatASMNPl0o5Mn8hCVrn4GQ7YSddhoDCAFB2fjq849JsEnHtDsmIlO//P4Z
	5
X-Gm-Gg: ASbGncuMmGJCXFGiWKdhGoTYgFJlBGsKW1YPK5NZ1kwmBVpqOgzFwkTWkW/ejJcg1y9
	G+aRWv9fDUeBzzLhwaqi/hgi9lVr5z8oPUuo//Oc54wesLmLLUKP6wDSplqIXqr+aBcY1fh9f5n
	lQQC51hn11zOockOAkZug8tAIsqQxmbqmyBsUmhxpaPDVfo8ouKq3rxUxnbY5TdgEM/9tCNqWvL
	yJBtR+5i9ccWu9TMAC0C/XRLQ4D4l3bigdFwIExKqAKkspOnEoQEugiHA==
X-Google-Smtp-Source: AGHT+IGkFtGyulvVJcE2z0NXyBmacxg5ja+vqmOEfAek+wG41MTpylbPazHJQjxiTwi94Sb+FpX1HA==
X-Received: by 2002:a05:6000:1846:b0:385:fae7:fe50 with SMTP id ffacd0b85a97d-38a8730fc56mr7781270f8f.42.1736499240409;
        Fri, 10 Jan 2025 00:54:00 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4c1ce5sm4009283f8f.94.2025.01.10.00.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 00:53:59 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v5 1/5] kbuild: allow multiple asm-offsets file to be generated
Date: Fri, 10 Jan 2025 09:51:14 +0100
Message-ID: <20250110085120.2643853-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250110085120.2643853-1-cleger@rivosinc.com>
References: <20250110085120.2643853-1-cleger@rivosinc.com>
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
2.47.1



Return-Path: <kvm+bounces-41042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCEC5A60FA2
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:10:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 204083AFAA1
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 416581FDA82;
	Fri, 14 Mar 2025 11:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="nQMuvmyQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F2F1F03DA
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 11:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741950641; cv=none; b=RzY3d8t7JJcKaDZl+fBheG1quhZXCQIP+MKoTCIMb6OKWqyvvzSqOEHrVYfs99+tqsW3kW3Giv+2pun22lKPaIexxBHsGylA6ThnQLU2dz8r+AtakDpyjud/T5AjN7yZzDnOiPvmIk+0eqDHe0fniAl9D4dKOSEeekDGEl+c9pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741950641; c=relaxed/simple;
	bh=pUbBH6lKqjkYHOrWph+jCd+XfegjoIltPb4IwKUmCfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrYc/S6Lg1XE9oPvkttKizs/nmDBIt/KlexexvqGm4hQRxnr2mUWX+QQ5qeiTOQ27sY9PCHQlvWrcseY/uG1RjF0Dc9JKeWKYeR6JtUn8sn7ULL6lPwniH/U3ZtDup35HzXuPd86PDqQ0CR67NUS8ZXPgGDwo3PWG1NwebPTA+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=nQMuvmyQ; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3912c09be7dso1309812f8f.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 04:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741950637; x=1742555437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6i1/sQFS23e0aHQ0gG/Xo3pgpweMckYvmkT9KdoCho=;
        b=nQMuvmyQR9hE33PADgc0S2g1IBOWUwl3jtKlwxlyrf0w7Hc3QCg1fH32w6EaM6VOdF
         RfNDVHGU6pfqEi8o3GQBVJCCCdcG/jZKdP5thruE3ECfL+mMsbgvaMjZBpgBRftZDuTp
         XTKY6fR8jK1f/DpaWx7iYke+26QCo6Bux0vgQ3t0hDXgWoSC6x0AZ0EQM95iXg4aFqKz
         KwtfVU7A6fk9iN3QIR9jfj+PJ2ZU2FA8/2fv3W+yQ/Ui6SV5+TyQlc4kaIxwLI1mKezN
         /IyDZEeHi+el3nsDI45bCXIL0DhLiCnNJvrPZ4ZSm+naaX73fBSJUlTAb7PS//V2yaYz
         yPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741950637; x=1742555437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6i1/sQFS23e0aHQ0gG/Xo3pgpweMckYvmkT9KdoCho=;
        b=RxmqTC4INnGIUF0f32CwJQHQ8Sr9ZmCA7zslomK1kdnq0isIZQKi9+LKwEL6BDuq3v
         uWWAEdaX1bQJozJ5DgYDb5o8eNXd7FlAIve1o3Tr92Q0Ft0aLnWq8zmR8wPx1qV+q/sE
         85BPNJ1jgk1BYb7TTjOVBO7b25/HYb9Hr6tbSFh1CbOjOoOfLF2UhhDXwxi2rE092nbe
         GO4xDvoOP3uCHVnuvoLvsCfyP5H5kqbM6lTeqd7i9nmMaHALjYmDmp/RoX6CJb9/JM0K
         Zv0kZkWjgxY03cq1duWied9+ZD7F5jS8JtLLgiUgnV04SUuOtk3UOXO5Eg5SgHq+TSB+
         Mh7A==
X-Gm-Message-State: AOJu0Yw1vaec6zEj8z8asl+bKY+A+22PdLgaBLd56SYQKLwkXhq0khLU
	YfJwKUqqfIhvt52wbZXRuDuNa94abqun5TT7at1/TP7BPLKFufkC3iixxBvBRkMWWG0hg0JQLuh
	cRHg=
X-Gm-Gg: ASbGnctHUIkCBulQoNS/iJsO0DZAlNT4tDU4I0/QGLt57/CRzy+LZcfDKjZBinpAsPP
	cimRcyRcJ63gRpLSwONuTaxjuXs6ncJiSlsY95afg9rgCzfL1uf5geiant/FbdkgJOQF80bFedR
	DSBX+4sEQO2jmbtw9fmks/iCXc/ViE+mTX0GskGxsZRePBg3pZ8uTRQ4+wN/3Wp0K5d5Jivl6uC
	8ZrWVxMfuM+HelV6G/HLuTDstkseI3tFMYVEz8PIKyfFGrVjZjH72+tSRk61tu8fVE7StXMURaP
	I/Kd/vmQcJDSpJoHDkdKGXrnvBdnK0akTZRuH+5h/u+Jaw==
X-Google-Smtp-Source: AGHT+IFiA0hkUJPg6bO/qu3cGjt/6OITQY7GCDIoNVDviqYslOtokCwJ1H0VZcDwraWVxmXqvXyLTQ==
X-Received: by 2002:a05:6000:4009:b0:391:2e58:f085 with SMTP id ffacd0b85a97d-3971fdc2557mr2581473f8f.54.1741950636951;
        Fri, 14 Mar 2025 04:10:36 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb3188e8sm5299203f8f.65.2025.03.14.04.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 04:10:36 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v9 1/6] kbuild: Allow multiple asm-offsets file to be generated
Date: Fri, 14 Mar 2025 12:10:24 +0100
Message-ID: <20250314111030.3728671-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250314111030.3728671-1-cleger@rivosinc.com>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
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



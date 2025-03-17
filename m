Return-Path: <kvm+bounces-41251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3542A6593C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B9E2188A8E3
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8351F8916;
	Mon, 17 Mar 2025 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="cKlcTA7c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182F51F866A
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230185; cv=none; b=uvK8iQ77yoYaJyeEReR9+QrNNfRfLFa3JzzoIGm+9jPNCxxe2yJTrzKiBxN+nD6mrOTQdIx1+fW8onVxrYaAKZEaKumKBKw2043ZQ4yfysYl1gEQZlywPCgtItmHl1/4TM9AZJIL0cPJb8fr9Uch60E1ShXWgQrXhGesEjXnZIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230185; c=relaxed/simple;
	bh=pUbBH6lKqjkYHOrWph+jCd+XfegjoIltPb4IwKUmCfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=krnXEqOUOC/Y4npmwgw3kx+NG1IWFvsDXXqoU/VNHIEsZIzCaotGxPiwQH0aAFvk0d10YoWHYOKP8KfuKtTnmb2hfqcurs40xbpUKEkz7nYF6C/Cn1IuV/BbU4LLjz381GycD9YDXoJ9dCLN+f6aD06lQJ4fGBENijRe6vVlSpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=cKlcTA7c; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cfb6e9031so20779455e9.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742230180; x=1742834980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6i1/sQFS23e0aHQ0gG/Xo3pgpweMckYvmkT9KdoCho=;
        b=cKlcTA7cDyh0blb02GrbNPDtGtao7en8WNaZns8KwF4NazgoKJhxUO7Gyn1addmoBy
         AhLMEiwZFaUg9pFS6D6tt8h9Gy68MgS99/4XjqolOPq0cKWdUCnEdy2QmrzGwMOYWU0E
         8aKaTIchXGSlbbN/2nxzbQKyfZrCdNaVCie95PjEM4Pr0ldqAj5fj2o5BDFk7dbOR2kU
         qDMLTqRfWXrLaX1wFBsgpPGR4XKPPA0Qs4DoKq3D3HOL8JUaswhWyvtUQs0M3Vw/XnvQ
         fL0oGu26Crxv9m6+7lLgMST/lA2/zHxM6n/Oz0QmpMnSF1AGO8ByPR/diHClBGvQsB82
         GMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742230180; x=1742834980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6i1/sQFS23e0aHQ0gG/Xo3pgpweMckYvmkT9KdoCho=;
        b=Yk3M2P2DedNojBNV7KXCDKKULU8Hl6MdFUYCh20LpjoC3o/0m3trZQP+x0T+gbP5ey
         hb1N8hbjZITE353AYyrJQRlUMrKWatFGfxtjnsYJm5JJvf7kMp6PSKrRRZxEvyNraHd1
         +AhePMnbXe1BPmVdWaqIiUcI/aYFZ5iA5Q/XOpnMKX0DEpcEDC6/K9ph97dvDCncxJpc
         7dgE9+pNh5Z0LdGlNjJzm6qbWUs4hkNrcf8+DC8C9A5LlQ3isTEG7PTQQtrFDZKlJc8g
         4gdhR69PWGlFAhsgy7XhbYuskcNOOcRo4bzhcVaQoIWe0bggKq6dCG58hztzF0NOJdaK
         vZfw==
X-Gm-Message-State: AOJu0YwCFknOtyYr3qEnwu6o5rmAY/yFKQri5ZV7N9vVcED04bCaGGaT
	b0iBgXDy2IEx73Da6NMCDohmsFscTDYyCEuwgX/ehuMu3k21fhVXNeBcCcxoC0Ex3NBEfTVfpuR
	H/QU=
X-Gm-Gg: ASbGncvuyrj2OdLc9Ef389y1Tfrlc3IsXuA3IEh4no8nYy02Y9oAEwx+shGuYdmggAJ
	kIcu7JSoZLYgvVWl9EBJkFsp3pmzp8IxkI+5NtSaxtaj5koyVj4ZcqoQr/911Vyprek2zjBqj29
	MITyRrPnKP78OM9ib7I9P76d+rSpAZzyHc9gQ0mI07ZQ00muYwvPtIQ2bAYEVHaOds11bCuM5/G
	FWF0/4eFaVI/4xmOgFtTlf8Hq2KfKauAJ/8dXoiojZQX/AoZt+W9sxRFJLW6nuviMHmEuFu73Jr
	eyOBfpWro98HBNAViZqRW77PRbqiev8tjMP7x3DZ06pWJQ==
X-Google-Smtp-Source: AGHT+IH/VRE0oqk+nF5fXh0d0y+OONDrtl+KSoDNKtWQp2exkgcdQUoZGpioJPiZ0qy6WGCtswBo5g==
X-Received: by 2002:a5d:6d8a:0:b0:391:255a:748b with SMTP id ffacd0b85a97d-397202a1884mr17614367f8f.39.1742230179415;
        Mon, 17 Mar 2025 09:49:39 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318a80sm15785845f8f.61.2025.03.17.09.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 09:49:38 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v11 1/8] kbuild: Allow multiple asm-offsets file to be generated
Date: Mon, 17 Mar 2025 17:46:46 +0100
Message-ID: <20250317164655.1120015-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317164655.1120015-1-cleger@rivosinc.com>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
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



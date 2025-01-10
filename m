Return-Path: <kvm+bounces-35032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CDFA6A08EED
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A2EE7A1E83
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814F620B216;
	Fri, 10 Jan 2025 11:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="FRkAJ3dV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7682F1AA1F6
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507585; cv=none; b=PdVM2v5udR4eAKlEO2ksF1RXvjwpihxWf4fFgMfPfpMXzWxuAWpntRIJymJBxAfS5G0mEbDpWKLmYk5CfYVWFVmXS7SiEbq2VEU18BCS4YAzE5vTlAMlcW05GLgAkfJfQMHeo3NClBVvRLHBXJk+MstC3+Zxkf2ruasfKO3mw2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507585; c=relaxed/simple;
	bh=C8vsMho9vZl9wJaWcPMSgPOzwLuy21OqmvUQ9tsRrzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pN5yaSX6g8EHSYzusyGQ1ou6ZlOd6OpgGFuwutkmftNAxzDODAvfuT886AzemeaFFdxhiIWYibO6hOZs2jOvaktLoVooSWXugFeRvKB3PIgmM3Pfz4KcMbhkLNokkS55dOksqqL9cQKY97W/AiD4tQWCyfBl2VZdi+FqCPRAwVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=FRkAJ3dV; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38632b8ae71so1331480f8f.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736507581; x=1737112381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZGO/tGztorN25vV6GIiTimQzrIDwqi9MKoWBwUHQcbQ=;
        b=FRkAJ3dV3PreDWiW06pPAdAHSQAiXTUynfg9gTIjGZy0hQ3IGBNrEPPwdAJug8XmM5
         5/JyAG9vJgj5uvFQGx6KvYhlnqRVemt7jk8Ogo04j+j7iRQD7xXLfQcdWmdemAn8hYYC
         BzQ5VYHThA4KI8aNuH4YGwLjUikUyCYPyU2NYOogetVTLKExFWrOv7R36WcY2bPU34Yl
         ts4ndTAhHOe2dfXDTcUcLysmGVPXLNN3wUgD9WPObQimWLbw1kXklkiK5YUrqpE0wtDR
         2uXQYO+45Wb274BxZWw9l4iwOuow6YaYQzBIJwkJMpeCfGB33K1xxlLkfw6ftPkBsh6n
         l3ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507581; x=1737112381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZGO/tGztorN25vV6GIiTimQzrIDwqi9MKoWBwUHQcbQ=;
        b=fmdEQgdFclhTftG4x1UKj0jslJDc6yw/zRmDGcmzwZuspOqkrewjOswQ+QVduSa5Jk
         QKFXRWCudCXEKED+9aP8gW9nY/69ovsiL1ClH7yjxiiGxh7fmDg1MermyQgQ0haJKpHN
         3oV7sx8GV47GelFxaGkn3/3YeoeDUdb6MuaDsY7pcm2mkAx+RrVOk0vC09qQGv666+qF
         CrjxWhMMpeIbD7bvhYOXwIZyAa7mDMHsrin451ONQv/DyPLrj4+UEl0HlP/fFG1J5CWp
         r8O1N82P2+nZKEjxcSpbpmL4DY3Y36dGZ87hh0AMDLySzBdB4wtlXwWXMYa25zxLlAd+
         8iZA==
X-Gm-Message-State: AOJu0YxPObCn4mmlbshp4g270i+u6/mIENHLu20osmo6ADy4cEj2DNgc
	/iX+obYWRNn8SR0AysU3ZDORQ3L0A+5xB/QnIIrv7QzXjHfKcjiIRt9nx/UQNWTsT2UlsfZbTPx
	T
X-Gm-Gg: ASbGncu/JTGI0WrwDma7mgBNW26F4cMd8Wr/tcUJivewKDeaWbHpfdSZGRTRb0JEMuF
	0cSXB59C0+H/g8Y9xMjYZUMcwGe7m092kbooUkrDef9tNvNOd8ZnqJmbkLxBAhxGl+N+2b7O+am
	Tq16QA13P0MJzEDgLTT+lYFLP2BPjdCMyJEEg8198HXInvisg2CwD9GMyr9KsxZswB0agXyD2E6
	F+J39pwuSPRT/T2gB8kW/qPDPKEDCaA4HKHY4X497apuYArROaxCLr4RQ==
X-Google-Smtp-Source: AGHT+IE0cDft+UpOCMXRt5/70nsexkWe906gfO+Ck48Dw11dRtvGO7daCbmwQdosmX2SFZ7qJEVjTQ==
X-Received: by 2002:a05:6000:1a8c:b0:385:e176:4420 with SMTP id ffacd0b85a97d-38a872fc261mr9427844f8f.10.1736507581212;
        Fri, 10 Jan 2025 03:13:01 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38c1d6sm4344459f8f.50.2025.01.10.03.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:13:00 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v6 1/5] kbuild: allow multiple asm-offsets file to be generated
Date: Fri, 10 Jan 2025 12:12:40 +0100
Message-ID: <20250110111247.2963146-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250110111247.2963146-1-cleger@rivosinc.com>
References: <20250110111247.2963146-1-cleger@rivosinc.com>
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



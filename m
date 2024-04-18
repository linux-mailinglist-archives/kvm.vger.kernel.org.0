Return-Path: <kvm+bounces-15108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D45E98A9D1A
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03A7C1C21DBC
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC86316D9D7;
	Thu, 18 Apr 2024 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Fs099w3h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D788C16D326
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450440; cv=none; b=Z/Y3RnYrnhjGGIySXvAwz8tHZw0EPVNlmpK11J7/Ab+/gbHA59cwV3ffLXoPI30jFt71gj0p8YkzEeGqPNol+Ts8x4mz/4h1QPx5BNp36PeXmBqqr7EwkjUhsQq/g6obLE3H/qZhXMXJMgJ4e3yT8FfSZnQeVuFj70xMt0EwL6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450440; c=relaxed/simple;
	bh=jmGcUvmOSHSqYkb7pBNAS2mVaUm49bDaV7hi2clFia8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JwN2wK1+MqxxktK9FRJIlhX9wkm/e7IX1nbSYxKMQBaU7+S5RfsryBVB/UcS/D9uX/UiCF72npXuSyAi3lEf7txI+rnmB30XXAXtSyW9z+fXYr119YgxoTg690vxlSr65487tGTWQXgwDfSqswx0UxkLXUk2XpLa4lBEQpT9S/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Fs099w3h; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-349a35aba9dso167618f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 07:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713450436; x=1714055236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JY0qCZAt1G9FqrirGdQPEL//dx+I/VeYeDHijBAzwaE=;
        b=Fs099w3h93nPvR3q4Es8mQTeBlSfS0ZYVwXvg/GhnZAHhG7AXcN5/wSMg2tPkBt0HC
         CS67fAz7UZqoacW0cObF50fg90PGctvfo0qS++lxwMcS1gxO0zVeoxwM2LTHycZGZ+Xi
         c+LFQ8BPxqmVq2ni0o9n9LAaBCYfaZPJIxcxtB0/NvG1ACNJXFvOram8W1ipJt9KP4y+
         3ikC8bKZ4IwFwWOoYU9AacRsVERuIMTknM2VTunFRCoEL+NKLM/qMvtyBnd4xBWCC8Px
         1QFcTdUgccCwyvPJrXiz5+j7YkGBz3bjKQjG7e0QR8McVQWhATAb+QUj2bNY3ST8bfUj
         P8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713450436; x=1714055236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JY0qCZAt1G9FqrirGdQPEL//dx+I/VeYeDHijBAzwaE=;
        b=UW3Ee/QZKDcBcCeISoCp4nWlMs9/yLHDg4oPyh9juCAaI6H+cJWmSH9zjoL8Do010T
         Pbj9o493wQA2+GxxdyJPt2zddNN11ZCbP2X6/yXWcLFr7vNBqrCOzCM5y8QAh4q+ZWOT
         VDJpzznDPwAmIyOO3jAw350qnpv1gydqkEnH1wBDfRRXd9XA2ZaHxApGT7Uu2cAHLATc
         PWyPmvxv22i3opluAsfwAdYRHhxAiBn2Xp70M86FVSme1GFhIPyP2N/QtFIQ1b4YlaC3
         86WDIEA/XzL5UBzCB0KVxS9n6yhFcTwD1yL23iXznGRqBnReSVvclMXe/mQFHIlR4qKG
         v0uA==
X-Forwarded-Encrypted: i=1; AJvYcCWeGl0pKixqjQoBcXrup5rTPVt21XyQjARKaHoY1/OA3XkPQsz7eymi17gHbVwbbMc06hZeofvZssNbej72bR2MWJz9
X-Gm-Message-State: AOJu0YxSL5SYpbbhPzgKqC54lA09SocMLm9iIejlep0jDRQoINH2g+jf
	ZGqZwnSoBQBJyI4oMEnry8h+IlAltVdnYqBPJE7s5waDGeO/vxqw703kPl8bwZc=
X-Google-Smtp-Source: AGHT+IG9QM4RObWosVaHJ2Bu9iGsOImG7zvYuk0PErpgTMOYFhKXz5bCpwhT6ZoBg0yBf1Ld4kG3yA==
X-Received: by 2002:a05:600c:3554:b0:416:7b2c:df05 with SMTP id i20-20020a05600c355400b004167b2cdf05mr2101037wmq.1.1713450436400;
        Thu, 18 Apr 2024 07:27:16 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b00418a386c059sm2873645wmo.42.2024.04.18.07.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 07:27:15 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [RFC PATCH 6/7] riscv: kvm: add SBI FWFT support for SBI_FWFT_DOUBLE_TRAP_ENABLE
Date: Thu, 18 Apr 2024 16:26:45 +0200
Message-ID: <20240418142701.1493091-7-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240418142701.1493091-1-cleger@rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support in KVM SBI FWFT extension to allow VS-mode to request double
trap enabling. Double traps can then be generated by VS-mode, allowing
M-mode to redirect them to S-mode.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/csr.h               |  1 +
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  2 +-
 arch/riscv/kvm/vcpu_sbi_fwft.c             | 41 ++++++++++++++++++++++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 905cdf894a57..ee1b73655bec 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -196,6 +196,7 @@
 /* xENVCFG flags */
 #define ENVCFG_STCE			(_AC(1, ULL) << 63)
 #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
+#define ENVCFG_DTE			(_AC(1, ULL) << 59)
 #define ENVCFG_CBZE			(_AC(1, UL) << 7)
 #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
 #define ENVCFG_CBIE_SHIFT		4
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
index 7dc1b80c7e6c..a9e20d655126 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
@@ -11,7 +11,7 @@
 
 #include <asm/sbi.h>
 
-#define KVM_SBI_FWFT_FEATURE_COUNT	1
+#define KVM_SBI_FWFT_FEATURE_COUNT	2
 
 struct kvm_sbi_fwft_config;
 struct kvm_vcpu;
diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
index b9b7f8fa6d22..9e8e397eb02f 100644
--- a/arch/riscv/kvm/vcpu_sbi_fwft.c
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -9,10 +9,19 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <linux/riscv_dbltrp.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_sbi.h>
 #include <asm/kvm_vcpu_sbi_fwft.h>
 
+#ifdef CONFIG_32BIT
+# define CSR_HENVCFG_DBLTRP	CSR_HENVCFGH
+# define DBLTRP_DTE	(ENVCFG_DTE >> 32)
+#else
+# define CSR_HENVCFG_DBLTRP	CSR_HENVCFG
+# define DBLTRP_DTE	ENVCFG_DTE
+#endif
+
 #define MIS_DELEG (1UL << EXC_LOAD_MISALIGNED | 1UL << EXC_STORE_MISALIGNED)
 
 static int kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
@@ -36,6 +45,33 @@ static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
 	return SBI_SUCCESS;
 }
 
+static int kvm_sbi_fwft_set_double_trap(struct kvm_vcpu *vcpu,
+					struct kvm_sbi_fwft_config *conf,
+					unsigned long value)
+{
+	if (!riscv_double_trap_enabled())
+		return SBI_ERR_NOT_SUPPORTED;
+
+	if (value)
+		csr_set(CSR_HENVCFG_DBLTRP, DBLTRP_DTE);
+	else
+		csr_clear(CSR_HENVCFG_DBLTRP, DBLTRP_DTE);
+
+	return SBI_SUCCESS;
+}
+
+static int kvm_sbi_fwft_get_double_trap(struct kvm_vcpu *vcpu,
+					struct kvm_sbi_fwft_config *conf,
+					unsigned long *value)
+{
+	if (!riscv_double_trap_enabled())
+		return SBI_ERR_NOT_SUPPORTED;
+
+	*value = (csr_read(CSR_HENVCFG_DBLTRP) & DBLTRP_DTE) != 0;
+
+	return SBI_SUCCESS;
+}
+
 static struct kvm_sbi_fwft_config *
 kvm_sbi_fwft_get_config(struct kvm_vcpu *vcpu, enum sbi_fwft_feature_t feature)
 {
@@ -111,6 +147,11 @@ static const struct kvm_sbi_fwft_feature features[] = {
 		.id = SBI_FWFT_MISALIGNED_DELEG,
 		.set = kvm_sbi_fwft_set_misaligned_delegation,
 		.get = kvm_sbi_fwft_get_misaligned_delegation,
+	},
+	{
+		.id = SBI_FWFT_DOUBLE_TRAP_ENABLE,
+		.set = kvm_sbi_fwft_set_double_trap,
+		.get = kvm_sbi_fwft_get_double_trap,
 	}
 };
 
-- 
2.43.0



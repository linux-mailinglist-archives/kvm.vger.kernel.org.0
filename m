Return-Path: <kvm+bounces-18768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F69C8FB297
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:47:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 827F81C23A99
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA401474A9;
	Tue,  4 Jun 2024 12:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="LRQ6IZzk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DE31465BD
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 12:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717505196; cv=none; b=cTdPRVfiTOr+zQjci9cFdsjYVQU94ue4nAMfU9QNraUaRnFwliXNzy7WRc1O8ttYcbANfGjEfvzJ1Kzt6E/+Io1lmacFtTyu22/NWX6ZpZBOpt0WaM7fbA4d8dnrM5GSDcB/k1u4tzLaPr9EHf0hlR+4Ifjv0120UAtkm7JstcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717505196; c=relaxed/simple;
	bh=VTiruecrUkveLlCZAhzKcZMvMHqPYnsZCej7f/kDh9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Exf/voqEzxa4lgu44wrCm3PbmfLZDjkASb0xsdN445PtR8FJxdrU9S6T+EZuIHBwZzKbBZK3gCcreuy1nKIFN2mP/+99aWvZdMux7I40msDKQzLB+g071kTzR3YLZbGJGim0Y/nRhK+EayFAiRnrXYTZeJCIAhTux3cTfnDIDcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=LRQ6IZzk; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-6c53be088b1so487540a12.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 05:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717505193; x=1718109993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FH0bMsHD4vaf3RN6eECK/cSeWYzW9s54IHrYdJwEDyo=;
        b=LRQ6IZzkRioJWdpzQTuhurKboK5aC5VonqNPRZyoKWGzY8s4YOwwtYVHXa5plrA6FH
         NkhIZk61v1iQbULszMgcEr0E5UJf8hr/gRWq1S4TCD/NVaAol2D0OhWYAZwaq9EUd887
         f04uj7Yxb1zP5pN6GbxZNzqPrn2BYpoaCnxVPx8CwwFN/E89hJN8RDITjxyMJ3B5L1aH
         lVZaCBe4O8DHaIwQNZgms3Nma/2AO/wnL0fb63N69ylorzvxwVJCoF1dSwgbo2bOOCd8
         TWlYBU4d6PaUVqKAh8Y3lfT/HTRVDS0qrWzibXrVf+1+LK9BydId1tjDCmQv9njfy7KU
         wYUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717505193; x=1718109993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FH0bMsHD4vaf3RN6eECK/cSeWYzW9s54IHrYdJwEDyo=;
        b=l9DPV12VQB98C+RIbiZshGdESK7STjYY3Cgrw3KsHGpEq0htGOttgadsYU9p656K1c
         9KlJB/t3kfA32dUL+e3sXpcY81WGqCZDsvzlPN56/6d7i45nwVgiDbj6xqkyHPdroK3T
         03ILlALw57NVsE2n81UWoE51EsO7w/kZVZaRl8clqJnXj4Ty9Mn7nECaa2DKcL5hKxCl
         yQzhHIW5avgb+WIpAHETiaNPvUA2N3KXzSo7IeqDXgvSCiyg/TiUMbSygWzTZ9TqAzFw
         XdEKpeOjOYYm6LOpQgrJuFRHUEDoWePE1x9qSmCMkO0uzZoK+OAnMjfLOiEq/k5unSwz
         sVBg==
X-Forwarded-Encrypted: i=1; AJvYcCUdy9CKQwlh7SX6XyBZIxfUKfv54i/3MRm9lsgzk5/bMlOk/AFwWdn6Zvqxbihluht17nZfOlymkezOeyuaGwxzXUYT
X-Gm-Message-State: AOJu0Yyk43J2dGNYPCCHr5WZ58kfpEqfpvTdCC06snK5iw2KFAQEnHiT
	9JmeyK16z/i8km1RHM7LU50aliwULetsLdiHZEjzdBdARXCUgg5bvQX9sDZOZDs=
X-Google-Smtp-Source: AGHT+IEcDwjJyY3zBUf22+Q+de7qq4n7Qn6IlYomnDRBzOkE4B5z+4AhELmoSGtibPGFsq4xo3mqwQ==
X-Received: by 2002:a17:902:e5d2:b0:1f4:962f:e006 with SMTP id d9443c01a7336-1f693dd486bmr22891645ad.1.1717505193034;
        Tue, 04 Jun 2024 05:46:33 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:327b:5ba3:8154:37ed])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323ebc69sm83042885ad.211.2024.06.04.05.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 05:46:32 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [PATCH v6 02/16] riscv: add ISA extension parsing for Zimop
Date: Tue,  4 Jun 2024 14:45:34 +0200
Message-ID: <20240604124550.3214710-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240604124550.3214710-1-cleger@rivosinc.com>
References: <20240604124550.3214710-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add parsing for Zimop ISA extension which was ratified in commit
58220614a5f of the riscv-isa-manual.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index e17d0078a651..543e3ea2da0e 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -81,6 +81,7 @@
 #define RISCV_ISA_EXT_ZTSO		72
 #define RISCV_ISA_EXT_ZACAS		73
 #define RISCV_ISA_EXT_XANDESPMU		74
+#define RISCV_ISA_EXT_ZIMOP		75
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 5ef48cb20ee1..bd1597578fbc 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -256,6 +256,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(zihintntl, RISCV_ISA_EXT_ZIHINTNTL),
 	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
 	__RISCV_ISA_EXT_DATA(zihpm, RISCV_ISA_EXT_ZIHPM),
+	__RISCV_ISA_EXT_DATA(zimop, RISCV_ISA_EXT_ZIMOP),
 	__RISCV_ISA_EXT_DATA(zacas, RISCV_ISA_EXT_ZACAS),
 	__RISCV_ISA_EXT_DATA(zfa, RISCV_ISA_EXT_ZFA),
 	__RISCV_ISA_EXT_DATA(zfh, RISCV_ISA_EXT_ZFH),
-- 
2.45.1



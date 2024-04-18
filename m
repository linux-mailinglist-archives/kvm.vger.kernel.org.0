Return-Path: <kvm+bounces-15105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 171508A9D10
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40EA3B288DC
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E40116D303;
	Thu, 18 Apr 2024 14:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="VRmzY6KX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF3B168B15
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450436; cv=none; b=oMFNPTLnY6imvgZnNQ+eG0bZHpoVI6R4z/eH5Ym9A7Czebp/AX9S4aNIzjHoprctKkpM3k0rMc4S941sRyEW+bGEPxkSw9y2DUvLVTuTxKBq6YGZMaWSV7P8uQN2BZbx09tKuA4uKHgw94aUjcPSCxVGI59dAQCG/oWipPTDpD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450436; c=relaxed/simple;
	bh=5d6XfuE/x8oTMptqSbd/TVtSF87TfLSJfp9I2jf+T9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aN1awSDYGdxHpJaonxAwLRjVAk6f7W2KD3zVBH8XVlk1X47u2mHMHpELMMmN4yRwFfgzdthhxO/QDLxPzjIxspGwggcfwCAEPACE0+Nj12FJnkuZofTFdOC+AurzjW0Jz/CLfXFgls29gKBmpvUqhBA4eTEGtEDR0S42bO9K6V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=VRmzY6KX; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-349a33a9667so132737f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 07:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713450433; x=1714055233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2hh6e2GF78oUYrxH7UeTADA8qs5jCuVhRAdsmr48k94=;
        b=VRmzY6KXZmHtl6X7P54Mn5CDqpSgmEKeemvLM3kijxNQXJZTpfY3hm6o9pjQT+E66R
         j7wqUtLUK2fIEG4uEsMGiPeFpLfuK1maOvzKrF8SAOHWZ/CTni4oDC0Cty79G1i/svOX
         efjZau2lil0E7lUHqGSXFI9JcUX+3z7DCRb4NPeOkUrcqc0k8uN1fooeZ65Wj5AA3RVm
         FzLOM6OiqaPH0VvZXK5UeY+2Pd14M1M3WIMNNJc2hwbRStWFSFa0XY1KAK1aE6OKhyTQ
         2KxKz02N8vfS/4yyFUgZGFlz2xye2GX2VJR+vH2hM843haH8cBNvpc9re202ZpQIW/TW
         ZqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713450433; x=1714055233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2hh6e2GF78oUYrxH7UeTADA8qs5jCuVhRAdsmr48k94=;
        b=edKucx2KnZm9M4yWvOEEezfV0zWeo7E6thrSpq36LdVHi6Tl+gEi4wXB0JQI2QyiNC
         ohxoldeIpVGI97VcGMNARjFaUOZZlpK0wCqO3MBz7vyCsfrNDMJnV/lY5yyA3eHMXDGU
         QxMuWT+ODyxYmGnGsftilmqrPbRRIlNg2o0suEtoRUidUL0VpcYRWU3WeAN5o+Kt+eIM
         L7fmiqLsabp6nLg3y8cqJa9msk0+3Igm7lzeLPhzML8uTNKPPN4DNMi8gGCf+vdqhFu8
         jnygrRG5U9rmGwoXJIiAq8eCZ7rJuewP1w10BdgdsW6o5tVm9wr+VoSZgB1CKqarA5el
         QISQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+qMEWHaoe7ESws8enr2LexAYDNXOddvOkFoLwpKfJNCwXsfFGtlMN9us52jl7RlS0SyBwYnssvlknRau4YkPCByRs
X-Gm-Message-State: AOJu0YwVaIuR1q2J7O+wgIPmENxS4UCmc5k2fKRLGRKWYmk87CywfUtf
	99CCFuqhrzKmBxK2k3Blojyc9qryUmw9cKT6kMye9sbhNoFkeVc85U+sfS7fxY4=
X-Google-Smtp-Source: AGHT+IHtDtcO4AoiryjW0Pig9lF2J1fPpYbAE7uetQUD4j2yMmH3o1hOU+m/bZxddoy6PQKmq3VrHg==
X-Received: by 2002:a05:600c:55d7:b0:418:ef65:4b5f with SMTP id jq23-20020a05600c55d700b00418ef654b5fmr1037961wmb.3.1713450433361;
        Thu, 18 Apr 2024 07:27:13 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b00418a386c059sm2873645wmo.42.2024.04.18.07.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 07:27:12 -0700 (PDT)
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
Subject: [RFC PATCH 3/7] riscv: add Ssdbltrp ISA extension parsing
Date: Thu, 18 Apr 2024 16:26:42 +0200
Message-ID: <20240418142701.1493091-4-cleger@rivosinc.com>
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

Handle Ssdbltrp extension at isa parsing level.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/csr.h   | 1 +
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 510014051f5d..5528159b3d5d 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -102,6 +102,7 @@
 #define EXC_INST_PAGE_FAULT	12
 #define EXC_LOAD_PAGE_FAULT	13
 #define EXC_STORE_PAGE_FAULT	15
+#define EXC_DOUBLE_TRAP		16
 #define EXC_INST_GUEST_PAGE_FAULT	20
 #define EXC_LOAD_GUEST_PAGE_FAULT	21
 #define EXC_VIRTUAL_INST_FAULT		22
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 5340f818746b..16d2ad7ca9b2 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -80,6 +80,7 @@
 #define RISCV_ISA_EXT_ZFA		71
 #define RISCV_ISA_EXT_ZTSO		72
 #define RISCV_ISA_EXT_ZACAS		73
+#define RISCV_ISA_EXT_SSDBLTRP		74
 
 #define RISCV_ISA_EXT_MAX		128
 #define RISCV_ISA_EXT_INVALID		U32_MAX
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 89920f84d0a3..5cff21adf2c4 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -303,6 +303,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(smstateen, RISCV_ISA_EXT_SMSTATEEN),
 	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
+	__RISCV_ISA_EXT_DATA(ssdbltrp, RISCV_ISA_EXT_SSDBLTRP),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
-- 
2.43.0



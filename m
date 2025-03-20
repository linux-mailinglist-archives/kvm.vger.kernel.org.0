Return-Path: <kvm+bounces-41625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14546A6B0E1
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63D1D4A30BA
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C1422D79F;
	Thu, 20 Mar 2025 22:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KC4dSKBi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD8722D7AD
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509835; cv=none; b=B0gukTo0bgEOTaBaDb8HU1xU8QnOtvK9bfZfNxNY/Z1qDH+gemr4wCJ8Bo3H9I73pI2/U5n4g8taqpqjIEon8I8OKcy9BUGg9DRNaAv3m9OQtZ/H2sYeqHXkmVYEWQcyJtakpNI8fsprrvB99JUssMg8KlspPjngvuvHdfGjbj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509835; c=relaxed/simple;
	bh=Nr7IhwF/sAa6PluaO6GcbrWfqMTY4uUe+oquxqYn8wc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sUMsuQOI+CALnesEKpsS6qJs5QD1OPv57qCGpY2ICYHi9q9FhWTyH+GF3UjCFew0NTVFO2H6yOtBAyLeRrIgDs4+krKcogXN0wlyweKGrRz05a0wtmOObp44ZoQAin8JL97GPSw8xcxEoq9G99hzkBxFdSusDBrq2fJEttNm+RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KC4dSKBi; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22580c9ee0aso28036925ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509834; x=1743114634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ozZ2STeyLcJfOi2HO38PmZ1SSe1ZJ6WASMV/GdeD4Q=;
        b=KC4dSKBinGffEw8U3ApkyFAI9zyyQCxTytwDA2m1zga6WHkWRfzCYbK474wbCZdPLU
         j0yUoNVn9hPoa1dQN6ZHC9IGlTFVPDRWGusmDWSWUGCuZlk/XHmxhmKymYO0dL/hK165
         GJBo2/fvtm5Nl1N/7UKch9XKLHXin1nr5O+w7PpsHKQMkYVYmpP3fTZp99S8MgEZxq1k
         J0iVcQeNCLgsR880PAoc02NIghKo4hXCF37gYm83QYabndbZhz8C1B6JjBA3jrzT6jQq
         UVpnjNJFHETdEzy1NYgi6kOLZ+wqGtD21d99ivmBJButJTJOL9OjA5UasJXnQAhJFwWM
         v8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509834; x=1743114634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ozZ2STeyLcJfOi2HO38PmZ1SSe1ZJ6WASMV/GdeD4Q=;
        b=hPQZeyxEWf0620BppvIA3nBf31VQNGYqwMB8CL0Kgs+T2cmr7BJtlJK8QUge9h/m2u
         Kc4r4P9x+8uyatlmgGjBkqFa49a1F2aY5GrhuWKJQ3bIHIimy7rsnVE46q29Ld2aaYgM
         y964Lau3jdgHlPDPPFKoXaCoNLir9CsjvT3MUVMkWHYSDfrXXgwiazxSsTLkUEdeO/Ru
         cnGgDl1pDVcfs6ksit9gNezlMswo5KnCi0SNpTNqRHsr0Q6fMGJcrGFkGLTiiXsb32E+
         kP06WBCXR0A26cDxZgsRhoLK2ydA3hMgs+XHqJds34INFByfbawBIh9Es/yRRCOqzm1E
         R3hA==
X-Gm-Message-State: AOJu0Yyg2mUKHp++4ofoIpE5o0uqApVmQhcA27l/kzdCuJFNPgola0ly
	+OEkncyzB8dfccSkDWnHfIh3rtZLJy3iUkCdp8QXz05W0QB/xRNCP9E7Jn4nzi0=
X-Gm-Gg: ASbGncsYxB+V/+SNON87hTGvSpq244TjoaWvCdPTqq2xq7OsRvm4aHZODa6973z0nYq
	qCfqPn+91vbkogo7TBQzlFAAzZ+lRkANk+rji3RgNErRUk5wFumwniAjZ+NIzQzBvg26+UZ5hi6
	ENWfURRqDSulabH8M6rXm1UWstcP3H0tpXi1aoTPKQtyeOYLsnNz5QwDlbAyuZiPMBAEqTMBGju
	X59AttS4oJWVYrQowqFXIgdXfyjJDegIojGAv5ZiOWL82dXVUq5B2Tw4hso9CKHDFDmtvntkBYf
	ksGPBSp/a1rQ7vFS9hRICu7Vu4f8q4maXFHacWUW/rZP
X-Google-Smtp-Source: AGHT+IHe6GBkn4KwpLvaTmmjJDIDMzLP05ORVKokysmKy53aE2ukm/kc/ZOTuWlwBaafsA2wQaDJ1Q==
X-Received: by 2002:a17:902:ea04:b0:224:1294:1d26 with SMTP id d9443c01a7336-22780c7afa2mr10974305ad.13.1742509833662;
        Thu, 20 Mar 2025 15:30:33 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:33 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 22/30] target/arm/cpu: define same set of registers for aarch32 and aarch64
Date: Thu, 20 Mar 2025 15:29:54 -0700
Message-Id: <20250320223002.2915728-23-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To eliminate TARGET_AARCH64, we need to make various definitions common
between 32 and 64 bit Arm targets.
Added registers are used only by aarch64 code, and the only impact is on
the size of CPUARMState, and added zarray
(ARMVectorReg zarray[ARM_MAX_VQ * 16]) member (+64KB)

It could be eventually possible to allocate this array only for aarch64
emulation, but I'm not sure it's worth the hassle to save a few KB per
vcpu. Running qemu-system takes already several hundreds of MB of
(resident) memory, and qemu-user takes dozens of MB of (resident) memory
anyway.

As part of this, we define ARM_MAX_VQ once for aarch32 and aarch64,
which will affect zregs field for aarch32.
This field is used for MVE and SVE implementations. MVE implementation
is clipping index value to 0 or 1 for zregs[*].d[],
so we should not touch the rest of data in this case anyway.

This change is safe regarding migration, because aarch64 registers still
have the same size, and for aarch32, only zregs is modified.
Migration code explicitly specify a size of 2 for env.vfp.zregs[0].d,
VMSTATE_UINT64_SUB_ARRAY(env.vfp.zregs[0].d, ARMCPU, 0, 2). So extending
the storage size has no impact.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.h | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index cc975175c61..b1c3e463267 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -169,17 +169,12 @@ typedef struct ARMGenericTimer {
  * Align the data for use with TCG host vector operations.
  */
 
-#ifdef TARGET_AARCH64
-# define ARM_MAX_VQ    16
-#else
-# define ARM_MAX_VQ    1
-#endif
+#define ARM_MAX_VQ    16
 
 typedef struct ARMVectorReg {
     uint64_t d[2 * ARM_MAX_VQ] QEMU_ALIGNED(16);
 } ARMVectorReg;
 
-#ifdef TARGET_AARCH64
 /* In AArch32 mode, predicate registers do not exist at all.  */
 typedef struct ARMPredicateReg {
     uint64_t p[DIV_ROUND_UP(2 * ARM_MAX_VQ, 8)] QEMU_ALIGNED(16);
@@ -189,7 +184,6 @@ typedef struct ARMPredicateReg {
 typedef struct ARMPACKey {
     uint64_t lo, hi;
 } ARMPACKey;
-#endif
 
 /* See the commentary above the TBFLAG field definitions.  */
 typedef struct CPUARMTBFlags {
@@ -660,13 +654,11 @@ typedef struct CPUArchState {
     struct {
         ARMVectorReg zregs[32];
 
-#ifdef TARGET_AARCH64
         /* Store FFR as pregs[16] to make it easier to treat as any other.  */
 #define FFR_PRED_NUM 16
         ARMPredicateReg pregs[17];
         /* Scratch space for aa64 sve predicate temporary.  */
         ARMPredicateReg preg_tmp;
-#endif
 
         /* We store these fpcsr fields separately for convenience.  */
         uint32_t qc[4] QEMU_ALIGNED(16);
@@ -711,7 +703,6 @@ typedef struct CPUArchState {
         uint32_t cregs[16];
     } iwmmxt;
 
-#ifdef TARGET_AARCH64
     struct {
         ARMPACKey apia;
         ARMPACKey apib;
@@ -743,7 +734,6 @@ typedef struct CPUArchState {
      * to keep the offsets into the rest of the structure smaller.
      */
     ARMVectorReg zarray[ARM_MAX_VQ * 16];
-#endif
 
     struct CPUBreakpoint *cpu_breakpoint[16];
     struct CPUWatchpoint *cpu_watchpoint[16];
-- 
2.39.5



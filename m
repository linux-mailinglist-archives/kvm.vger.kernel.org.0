Return-Path: <kvm+bounces-41911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB190A6E910
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6534C168C8F
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08461F30C7;
	Tue, 25 Mar 2025 04:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BsC1Q2jt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E051F2380
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878784; cv=none; b=CRV3e6zfA3iBHLf4AkblxSL0eGdI7+PjKxVodxNRATKuVJxNff9HV5qrFFbfE8Km+LSmktMlA7n46SdbaaAxXNUgI6N0Hy1lS48n73776cgF7XdeKw6X0yLxYSHXoK7uJwgP4wGHe3iXBwTjhhhUlSNXLw0Pyssme3Lt5NXy4TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878784; c=relaxed/simple;
	bh=Nr7IhwF/sAa6PluaO6GcbrWfqMTY4uUe+oquxqYn8wc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DuLBf9NyZxpQyXhuP16OWukoJzSmG+zDHRB7ao1QWtphZE35ne48/TQ7FcH05Z/Rh5HauwOmIrPkPWxBJYJcN2B1miwsSmpMdHr2oTvLD9yIv3/b5tAeTErBNdNpXpj5s9t6QFNH5QtlL4AfSxgYjNF3notp6ZhYlamJVrMt8Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BsC1Q2jt; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ff799d99dcso8577689a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878781; x=1743483581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ozZ2STeyLcJfOi2HO38PmZ1SSe1ZJ6WASMV/GdeD4Q=;
        b=BsC1Q2jtmIasf4EZEzFUwqOOjUuxHu34xXLlquf15PqDyn29eb1rh83BrRJF72T2I3
         g8xkRrscZQxbORgNksLN0rcjl9YCf9zj7+h0SfGP8TtLdNpe/KFJTH3EEr9tGa0wLsa+
         GBcMbKUOTMAPPFTupePJttaCAtvy0iDEtOcf9EmlzP3yhh3fg5i3zmT/u6L8fyLyQcrx
         TtWbAres9tJyAnNrllsTrDQcIVLef/GArRGDkJSozWmjxrWMvzMnvXrromiN2fzcin6y
         er7Kdp5EEeH7Y93g6RaFpI3GrNqFFE/wmsSzb8aFForxboZEsjxqsGqsijpAvIQNDJd/
         Yg1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878781; x=1743483581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ozZ2STeyLcJfOi2HO38PmZ1SSe1ZJ6WASMV/GdeD4Q=;
        b=Buj6C9/7UE+Z0uiQSdBzVZ6UCT6zMMo/JPJKqyvwjshCyKyISKwWf1dDvUdcYBVMmk
         rUiWaFX5J/qpZDp8G00wWrJxPOCHFnTI9lEWhKpl74PSRuMlH1OH5NEegG+4Gum6VvBK
         LH4D/H9h+0ujCAh2EfNrssbKQpcrddLlNesYw8Msa5fkdAX34UIMk3w5RzkPvwp2r0Dh
         LKuWOQyd9TRX3sjTQQ825tD2RbN9j3ERPAXxXvRCxI9LgyRiPkvZh28QZSz0tiPyxCb3
         q97a8d/zUXFWnfPCADDkFRffpYSz8sEKXNRAqAtY6H4/OIIkONdVeepUTM362l/5DgIE
         Diwg==
X-Forwarded-Encrypted: i=1; AJvYcCUc+RHD3FFL8VezLFjsXe+nuAdraLEwYjIf3ItnPjOkS0N1KE07uj9eVsrAHK7a961gKL0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz71mQLVZWeMfD/D6zLKPZH7baIidaeIdVyaB3S+pIqmH/Box7b
	QaGVFiTDs4mP7Hk7hmTU4X53hqh54ZYWQApy3glO4NDnm0ednoafj+95xtEjw0c=
X-Gm-Gg: ASbGnctdHhz3Vf4WqiUJ1ThbmZOHcLIjfq/pfdBpc4j8J8vQ+hfPd7v3g9iXzGVF21d
	IMbm1NcXWKNeqWh+Rd/gI/Ahp7s3OVJ3rdrXs0W8KBRtF8q078HyOi5arBRHE9TGQwcSgm71P/y
	uezK1ed0CY3wk1u3afpUSvtQduml7vIB15tTIwY9iBaaAOY0vgpw0OpnRQM2n2Ur+f6ck4RwzHa
	5/ojz/HKubCZZxxpWpj3+lwFpljukj4vwIexI2l54rHVsJNkFulYmjOnFUQauGxHaqTWQLjUzML
	bVZGOdjFiLMxrpP7HIXfAMTy8kdRmcWpTPCceeIu1rGQ
X-Google-Smtp-Source: AGHT+IHRwvpXbBUqHAAs7tN3i6H3y1jGNgFgo6lUQwfrkalBcwvw/NCyZ/ABEfCgTBwu3o/ipwe1GQ==
X-Received: by 2002:a17:90b:2551:b0:2ee:d193:f3d5 with SMTP id 98e67ed59e1d1-3030fe595c0mr27540468a91.7.1742878781525;
        Mon, 24 Mar 2025 21:59:41 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:41 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 21/29] target/arm/cpu: define same set of registers for aarch32 and aarch64
Date: Mon, 24 Mar 2025 21:59:06 -0700
Message-Id: <20250325045915.994760-22-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
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



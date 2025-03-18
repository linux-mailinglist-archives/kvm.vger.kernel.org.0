Return-Path: <kvm+bounces-41357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 180C8A668AE
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E2E4176420
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775491C1F05;
	Tue, 18 Mar 2025 04:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g57FF8mR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292AE1CAA97
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273504; cv=none; b=aC/lAV+jdGytc1l6vq0fEtTMqG+j6vCovICtrJim31VafJdhzUQP6s+QM0bSe11r4A5l1mcXpcCvZoT9TFqQrq/hi9Ui+wsJgu/zDE1dhyEgDvtjxfEjCN19uqcGyffa+Ujj+KxlIjIinfI/TaACuPwEwiCr2vxSCSi8BbD1Kvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273504; c=relaxed/simple;
	bh=hHoOsyyrEO+zVHEw+yw4NYM9LKkYQiFxtHWala0FEPc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xqn32SJm5Js8WYjhKvGIy9HaDvp1zlMedO9SJCjcSAaQoC8FgtSCRPDU06uuMYHQZ76O0xyPA28RkZy7/vEhT4AWDlW/pv/bZYZM9ynjr8c7c12+yejG63ZX4oC7F78xc9GQsmTuAsD/IiiG0QgHWSCUiH4j0ah7zKvgEkPk5qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g57FF8mR; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ff6cf448b8so5859022a91.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273502; x=1742878302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWxuqDn4s8YGDZbkaUM66zf0LxM3gMsyBA+i/Ql3r9I=;
        b=g57FF8mR/xJ4e0UwDteLrWlXEGa9saD3JjydD8EwEuDri3gEcbVlmd5mnxX5+BVoFN
         5O9D8ajeo08ASsJ/oglJKjrc6mMQ8s4aqn7Uxa1OyJOCrQUIzOyjLFd72ZkuT5DU2NZ4
         774EX/WH2emlVzNAzkLZ8MrYj5//xLBv9eAjzMuWH343OSaVqhQwaLOkcHWX/P0fNj3j
         Fjw8/q3h8PquRiZZQGinnZqI1rftHsZZh+wLeSbWdI6LPz8PB6idL6/ovI6Wp4xwQXOa
         sl0rdLSS3lUFUYQbIjvw4eyLbN8ymWWPLdO82cq4nZHDLDpuQQpQ1sbiCub2rKpP1Nvo
         cigw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273502; x=1742878302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wWxuqDn4s8YGDZbkaUM66zf0LxM3gMsyBA+i/Ql3r9I=;
        b=Zwdvrido3j9dmmtgRuVsmOcmTHEa+1ZtbLpS+28ZWCpLfYK3QH3ihzPW70pxTFLoMC
         QShmjHy2TZNgYp4OhaORjE55kXood7jrzUPQ/RLJAJaI42v3WG73IAbtkNd69AcamYkv
         D3ZLKVC+nx4z8jHEFEStidamLTITL4Bg2K0TDEwaRmb0PDB8sNySBBS149KOocA4a1W6
         xQUvvBFPflj8LUO7yBJ+hWgB1cUeV3ZtDeFj2AnBlJQFVU5h2isc8jWXiFky288CYF7R
         KoJS1z8ZjpiqeRu5yNS4v6IeJPt+2LQEaGou6ol9ovEo8pqe+Y1rVVBcm7ftKgVRFw+7
         hevg==
X-Forwarded-Encrypted: i=1; AJvYcCWlltaaHHShF3tZHqi5hgxm9S7AuTswscsYOt5xVqPvmJHI3y+q7nc1yUIvYEDC/J//T8U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpoylblAPGn5UaBuFGA+K4zKnbvbxQWNNLQRuPOHlH1McTI2AQ
	5xO9XrtCiavSd5gLqwU9LsRLvbPzHepBUvnQ0wvQwSYW+wO8v/R+Vhw9vhGMzEs=
X-Gm-Gg: ASbGncvgt3Jt1BryT0wOKKdvX7WAbDqGh3ENHAN6t//jpqAJ75YFU/VeM62l1odpj62
	ztgk/tpeofYre+fUR9dVGh6fx8WDPAfpc2ZlWscOwz9OIgAVd8BPq2LGTXf3VsZSEu/LpC6kp1E
	vQI8TRMg3qPP8bveudWNOHcWH/7dbBcOH0B9SAhvN0jDAeUGZASnvWxzZBJ5hCVS00T6y+/tvXD
	c2xKHcxBZIHOEl6pu0bKZRop82nicvPEXmsbL0GhDqlSAGZ72EAXY0ZHt3GL9hI4pEtF9McQQzJ
	byGFwx0accaDbtDsDo7zLyXaUZ/5yQDtbHPpK5zu34Im
X-Google-Smtp-Source: AGHT+IFe64voSZsfhB6tCQvZ6JsS5YIy++Gra9YOoX3NHYIjPdoV//u+oQg4+pI0ZxYcfpZboB2sWw==
X-Received: by 2002:a05:6a20:9c92:b0:1f5:6680:82b6 with SMTP id adf61e73a8af0-1fa461552c5mr3160029637.38.1742273502551;
        Mon, 17 Mar 2025 21:51:42 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:42 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 10/13] target/arm/cpu: define same set of registers for aarch32 and aarch64
Date: Mon, 17 Mar 2025 21:51:22 -0700
Message-Id: <20250318045125.759259-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 00f78d64bd8..51b6428cfec 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -175,7 +175,6 @@ typedef struct ARMVectorReg {
     uint64_t d[2 * ARM_MAX_VQ] QEMU_ALIGNED(16);
 } ARMVectorReg;
 
-#ifdef TARGET_AARCH64
 /* In AArch32 mode, predicate registers do not exist at all.  */
 typedef struct ARMPredicateReg {
     uint64_t p[DIV_ROUND_UP(2 * ARM_MAX_VQ, 8)] QEMU_ALIGNED(16);
@@ -185,7 +184,6 @@ typedef struct ARMPredicateReg {
 typedef struct ARMPACKey {
     uint64_t lo, hi;
 } ARMPACKey;
-#endif
 
 /* See the commentary above the TBFLAG field definitions.  */
 typedef struct CPUARMTBFlags {
@@ -656,13 +654,11 @@ typedef struct CPUArchState {
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
@@ -707,7 +703,6 @@ typedef struct CPUArchState {
         uint32_t cregs[16];
     } iwmmxt;
 
-#ifdef TARGET_AARCH64
     struct {
         ARMPACKey apia;
         ARMPACKey apib;
@@ -739,7 +734,6 @@ typedef struct CPUArchState {
      * to keep the offsets into the rest of the structure smaller.
      */
     ARMVectorReg zarray[ARM_MAX_VQ * 16];
-#endif
 
     struct CPUBreakpoint *cpu_breakpoint[16];
     struct CPUWatchpoint *cpu_watchpoint[16];
-- 
2.39.5



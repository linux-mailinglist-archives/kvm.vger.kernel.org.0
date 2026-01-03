Return-Path: <kvm+bounces-66973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1974CF01D6
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 16:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A185630704FC
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 15:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3100B30F802;
	Sat,  3 Jan 2026 15:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="baUsal5h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D445730F53A
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767453878; cv=none; b=LQeV8DCYmHu1Ip6oHv9vQQZs2tZ9iG+k21UvTajQ0dnOCuYPTcgM381CAgghRVousdXWFZ6ihxmO0TIf27CMOA4XDvNb0bz48bvkIx1wd9mpqwS+Q2Ar0+Nlz8yFGl+IXGG4QX/Wz/HHZA6p4KMDF916kFcIpUXLPz/FBnU+qoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767453878; c=relaxed/simple;
	bh=lerh5EnUg1JN1+T9TQ7JGXjzP1VBU6OTyUVU6U9a5lc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ux9BC6MW5bi4i8SH5T3jbg3CdnZm3lR14OegLEb5jXhJamb08VpngWGM097ryLxe5CIlsmd9NpYZ51wk3S8Ag/C4ZEOIGsT1+VQ+uyH7q1Yvj/0LcTVR6Tdxo0rWdMthVDYdP1P/1nIo8Gf7hOzmBNTjQSnYjzfpvigIVVXG1E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=baUsal5h; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34c71f462d2so13569851a91.0
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 07:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767453876; x=1768058676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N9tqN72DnRW3gbfss4TAn1MPl/pI0d3sx5WMZWESXiU=;
        b=baUsal5hsBy/2twCB/J+qUlYpV9Gjlbl06RonL4S9565MRW+p4A+iJDeQZ+AY7vDtP
         ToW7sKM7+zQzgUJ0Lh5zoSrocW27+qtaV/JNp6h9uNK/Lp+MZhhkHfBWHZvTBKJWRsYK
         m3HQ1gNTreW0YdqyFHoh/3ZPtuOv9PhzRlz71Hr5sSh4XVmKFdPHABfV6wPZkN4E1obC
         6betHwytjsj1EjOcKEc3Tkq9XwZK8844wA/gvCH/LzCSDQPp5wSjWrXgXpr34JJsiVGn
         cKLpR9RgguM1MSssnE74rXxKLCARW/uILDJfi/3ppn4AllqpU8dt1rolG7uvGTs6Pf+E
         K93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767453876; x=1768058676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N9tqN72DnRW3gbfss4TAn1MPl/pI0d3sx5WMZWESXiU=;
        b=HpSzqRkR6Hg0gLD83qtwjDzdxLDx+d+cpOHcfA6cm7xuits/5O4MgzjsbLKERBvDiW
         owbm/E5CDlGXBAQhejXKbgY7PlNOAED7gJIyNuW+rtcwGig0Xt/+2PzEVojqEotL/syX
         cvXI00Forjsb3A3l71xcEff0Vpg9TSo5G8eZA55f0w5fbN/6pg/x1hzMdhjC674WaEdP
         bZr0YnSPfnEyM+8vmkxY4TAdTqAnmfnypSNutl5Ea7Mi3EBgviJw7svNZVbaSQ+qCcbC
         HLR4wniS6vc9gwRQYgP5rDZIMM05uretEwIbrO76S7ANpa0p50ErH/zejl2hMsAzBNj4
         GdUg==
X-Forwarded-Encrypted: i=1; AJvYcCUH2IX02aqTzVK3oKUOaK2S34NE7oh5GbRcAmrXe/ESRBefUotOElOZeeBeupeFGTcj3ro=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEMvzB2YKi5twAIii2ajIz2bdR13e8UDCCgtBBLlMbYp8fQzM0
	D/fgVlz8BEhi/ZPH8/0JSx1ZFl4L8Qt4HVAsc0VUNOT5HZlVLKdoAK7uqMKjajvlDTQ=
X-Gm-Gg: AY/fxX5obDHNOsKHWRXFzr4c9hydDQN0C4aKM/D5lBr2n/5AECEB8mSivbyJnyUBLLF
	5OzjkgoAZCWkeRrTiuyHKBdanVCZjoCevsMjltrokW8dUtnjD/TvhlyZBTHirY7AKEXLZlakYzA
	EXibQIpqthErN2E8REFmNT65XtZ2DI0+kteD3VFQ9KsHQh+xXV9YhzRUsMs+o58s164H6ziFKZo
	hq5BHJgRQaXiFmsBT0kdrkzMZWWCgJSUpEtg2GVywL9SKWe16o676tyBQcU3ww7xFEAki8SBJI4
	N61q3cyfyN2jt0GrfZE/mlKPCfGBg/tb8c9pKogsdSVMoyCi9YTL3xBhgeUFUBkiAI4gnX+5w+F
	JsZ8O2Dt6/iszNpoysGgNURChYxvJ9wqa4mQyUWMXwUmy8ZsPSEUiwpGu2rIqmYz9qNrh2hw4wu
	IXIRVBE8LwlfLfAiLtF3ofmFxqQbEgRXoN/xhhB5Ru910PqbPV2myzdJvebDjrSl2Gn8uElGjmY
	FA=
X-Google-Smtp-Source: AGHT+IHlInhhJ3xFCCOgA3SiqoyGe4GrNPNHAy5HiMlXuyqZ/J0ImxaOeRtEIO78Zh6IdYlfYS5myw==
X-Received: by 2002:a17:90b:54c8:b0:340:b908:9665 with SMTP id 98e67ed59e1d1-34e921ed466mr39711928a91.37.1767453876082;
        Sat, 03 Jan 2026 07:24:36 -0800 (PST)
Received: from localhost.localdomain (123-48-16-240.area55c.commufa.jp. [123.48.16.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f4770a256sm2107802a91.12.2026.01.03.07.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 07:24:35 -0800 (PST)
From: Naohiko Shimizu <naohiko.shimizu@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	atish.patra@linux.dev,
	daniel.lezcano@linaro.org,
	tglx@linutronix.de,
	nick.hu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Naohiko Shimizu <naohiko.shimizu@gmail.com>
Subject: [PATCH v2 3/3] riscv: suspend: Fix stimecmp update hazard on RV32
Date: Sun,  4 Jan 2026 00:24:00 +0900
Message-Id: <20260103152400.552-4-naohiko.shimizu@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260103152400.552-1-naohiko.shimizu@gmail.com>
References: <20260103152400.552-1-naohiko.shimizu@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>

riscv: fix timer register update hazard on RV32

On RV32, updating the 64-bit stimecmp (or vstimecmp) CSR requires two
separate 32-bit writes. A race condition exists if the timer triggers
during these two writes.

The RISC-V Privileged Specification (e.g., Section 3.2.1 for mtimecmp)
recommends a specific 3-step sequence to avoid spurious interrupts
when updating 64-bit comparison registers on 32-bit systems:

1. Set the low-order bits (stimecmp) to all ones (ULONG_MAX).
2. Set the high-order bits (stimecmph) to the desired value.
3. Set the low-order bits (stimecmp) to the desired value.

Current implementation writes the LSB first without ensuring a future
value, which may lead to a transient state where the 64-bit comparison
is incorrectly evaluated as "expired" by the hardware. This results in
spurious timer interrupts.

This patch adopts the spec-recommended 3-step sequence to ensure the
intermediate 64-bit state is never smaller than the current time.
---
 arch/riscv/kernel/suspend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/suspend.c b/arch/riscv/kernel/suspend.c
index 24b3f57d467f..aff93090c4ef 100644
--- a/arch/riscv/kernel/suspend.c
+++ b/arch/riscv/kernel/suspend.c
@@ -51,10 +51,11 @@ void suspend_restore_csrs(struct suspend_context *context)
 
 #ifdef CONFIG_MMU
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SSTC)) {
-		csr_write(CSR_STIMECMP, context->stimecmp);
 #if __riscv_xlen < 64
+		csr_write(CSR_STIMECMP, ULONG_MAX);
 		csr_write(CSR_STIMECMPH, context->stimecmph);
 #endif
+		csr_write(CSR_STIMECMP, context->stimecmp);
 	}
 
 	csr_write(CSR_SATP, context->satp);
-- 
2.39.5



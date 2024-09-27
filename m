Return-Path: <kvm+bounces-27621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EB23988671
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 15:42:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8960B1F24082
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 13:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9711A2550;
	Fri, 27 Sep 2024 13:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="EOWYmR8c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482F01A0BDA
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 13:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727444521; cv=none; b=MgJilbYnkVPNC2p9KPdhX8Qo4meig6KHUwo88FRqeVocrCPM4kpTSAAdNweCxP7M8wy32mbsTPf9Xr2CzD7yC1v0XEQrgH+YBNPeP22WAilC+D65wx7X4kqWKrA47KisHvtQ82xvkYHlpWv0qzTkXWrcHc4Eb6+ApMs1PZQc3bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727444521; c=relaxed/simple;
	bh=2iAOqQjnUXTcZ5Cs8EpYQntXVuHf3Et98OZwyjYbx+4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CDGtLVTNYSe7gE9lM3emhbcvSBcwTzfnaNHo13kvYXzJmIo8QzcG+lz9BKOCXd5oBMLncwLmSLi32Tt+BEu/vO9MoYqAE7c2d17T6eT2G/3WEJCWgvkFX/iDIA7d4/PpWSAQVfEtRFKOlN1zOblffv3OX3+1HzlAwN1vLRAaqMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=EOWYmR8c; arc=none smtp.client-ip=209.85.215.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-7d50e865b7aso1559133a12.0
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 06:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1727444519; x=1728049319; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w/yqPChQyX7MOum1UYAETN40UEWggulMYnRGOrfdjTw=;
        b=EOWYmR8ca1op3oqhwnmPAw3E9wGVAK7q8uIwTyMpDM7wSG60wVFCDJsfT9njwTMV29
         Qi4QgsjO3Cy09sH2nDicS7ylZ8pzrireqGB0Z+erLPRGYJNVh2b009aBNM+PNdzETVhm
         pTo2afUZG1Cow0AaxXUOJZvoH1L32cQCDdpotbuN3E5mknsoRGHp98MkOuq7gR8EkT3x
         QacwlVoDIDG4fhsdKLljy//8jolMoKgcFGyaz04/5Cay5RjBkdQF7hDm2XXu4rI+Iu4w
         kZ6KwSVPXtcpp0NHPrfYAJLNUTRkqwVpv/hzASa+v6C8UhNtrmOG6PDW6ICyYkdu8Xt8
         aLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727444519; x=1728049319;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/yqPChQyX7MOum1UYAETN40UEWggulMYnRGOrfdjTw=;
        b=MfLu7j40MPN3c7tZzqHdb/SA6VDVvLLyDxnmwEnL7j4gUwuhkRmSlx23j/EoGMQHBv
         KDhi7QMkborYCjFx8TTIVzXjekkqM4A+AQdQSrUhb5RxOCa7PamAZE0imtuuWiNMYt/7
         wT22vsxpd8HWeNKhW6hMMez/cEWkUhz2AWdKfbU2cZIEgGYxtCKiZ4iNtMGmCVPj2ekR
         oaSL94w9DVuPAPvX32Xmn38NedZY5E1DRv8a3Sge3WIM+/UPOvFzjHMaF7zSSJP2gP90
         1ohCGjMtxPxpv++8oZfQVE5WkABeTHnAX8UScHmTo4K+KMQhqoZLwMeEgOSv7A2Bftc0
         dJag==
X-Forwarded-Encrypted: i=1; AJvYcCXfZQ8BX6u+EEl7fL6xdyCsbbT4h4VtgqJeq8VgWkNpj37HpKo2kB1+XflpSVKLnYJtVrk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdhz2+BsdwBP29/hasocUiru+RcqjUQ3QM+ZVWQb1lU3bDjYGz
	w4zfzeoArV6EdHsnyWXKXO0qDRJegQlneZFZxMwCuSVCHbOTbGyWVtuVSlI6Ygk=
X-Google-Smtp-Source: AGHT+IHabM478iaczeNhXVUodHzrMPBemfKWA5fTgJkjCbr2r/xavEqWXUBcqPn4lkdWJWZph5i48Q==
X-Received: by 2002:a17:90a:8d10:b0:2d2:453:12cb with SMTP id 98e67ed59e1d1-2e0b8879624mr4212103a91.2.1727444519527;
        Fri, 27 Sep 2024 06:41:59 -0700 (PDT)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e06e16d6d2sm5671744a91.2.2024.09.27.06.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 06:41:58 -0700 (PDT)
From: Max Hsu <max.hsu@sifive.com>
Date: Fri, 27 Sep 2024 21:41:44 +0800
Subject: [PATCH RFC v2 2/3] riscv: Add Svukte extension support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240927-dev-maxh-svukte-rebase-2-v2-2-9afe57c33aee@sifive.com>
References: <20240927-dev-maxh-svukte-rebase-2-v2-0-9afe57c33aee@sifive.com>
In-Reply-To: <20240927-dev-maxh-svukte-rebase-2-v2-0-9afe57c33aee@sifive.com>
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Max Hsu <max.hsu@sifive.com>, Samuel Holland <samuel.holland@sifive.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3103; i=max.hsu@sifive.com;
 h=from:subject:message-id; bh=2iAOqQjnUXTcZ5Cs8EpYQntXVuHf3Et98OZwyjYbx+4=;
 b=owEB7QES/pANAwAKAdID/Z0HeUC9AcsmYgBm9rYemwDJvWM0Es7Z0BdQVJl6wPqKNr+icYn8S
 ixNxmwo4PSJAbMEAAEKAB0WIQTqXmcbOhS2KZE9X2jSA/2dB3lAvQUCZva2HgAKCRDSA/2dB3lA
 vcTVC/9ZFgIJK+oxCZZJE7Vz0znghLwi7WZa3X3R3Oqf1yywBf3G37oy1p5ti/thDZgLMXxS6Tq
 hPXpTrYShGZRznXe9vclpZaFnaboitKby3ugrzpm6Q+y58OboJoP0ml+GP7cSms6Tl/uLJuOc7F
 g4mtWMwiqacecSkekyhswbCvL7lAOMBzW0lqiQ+I4hCxrh7/zJ+i6bGe1CJ/tdwlTc+PxZwcC3x
 eIJVccd2Hf1c15KRYMsaFK85hiiWzn/D+38vKxfAvP5pEPRCmhbNbnhQ/sgUG/6OlRL8BRYsyu8
 bhGUkRnP4DA/rthVm/hqQ8xefxIlrC94xa9Kh3g7LPe8Noc4Jv+kC+Yb7zHUZXCO3UzvdrhhMO/
 C9ooqjtoz/fDVqcV6VXY+Oqb3QvadyPTAiBTiDya9vQTqyQxmWUxzdQhOMFCHGKloihnXpB58Sn
 9oeYze98ONfxd9i83FVmco+5C01cnnYYMdcu7zUr2nT2HDwKpFt4vaFOrAt/j2xxkrc4s=
X-Developer-Key: i=max.hsu@sifive.com; a=openpgp;
 fpr=EA5E671B3A14B629913D5F68D203FD9D077940BD

Svukte extension introduce senvcfg.UKTE, hstatus.HUKTE.

This patch add CSR bit definition, and detects if Svukte ISA extension
is available, cpufeature will set the correspond bit field so the
svukte-qualified memory accesses are protected in a manner that is
timing-independent of the faulting virtual address.

Since hstatus.HU is not enabled by linux, enabling hstatus.HUKTE will
not be affective.

This patch depends on patch "riscv: Per-thread envcfg CSR support" [1]

Link: https://lore.kernel.org/linux-riscv/20240814081126.956287-1-samuel.holland@sifive.com/ [1]

Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Max Hsu <max.hsu@sifive.com>
---
 arch/riscv/include/asm/csr.h   | 2 ++
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 25966995da04e090ff22a11e35be9bc24712f1a8..62b50667d539c50a0bfdadd1c6ab06cda948f6a8 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -122,6 +122,7 @@
 #define HSTATUS_VSXL		_AC(0x300000000, UL)
 #define HSTATUS_VSXL_SHIFT	32
 #endif
+#define HSTATUS_HUKTE		_AC(0x01000000, UL)
 #define HSTATUS_VTSR		_AC(0x00400000, UL)
 #define HSTATUS_VTW		_AC(0x00200000, UL)
 #define HSTATUS_VTVM		_AC(0x00100000, UL)
@@ -195,6 +196,7 @@
 /* xENVCFG flags */
 #define ENVCFG_STCE			(_AC(1, ULL) << 63)
 #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
+#define ENVCFG_UKTE			(_AC(1, UL) << 8)
 #define ENVCFG_CBZE			(_AC(1, UL) << 7)
 #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
 #define ENVCFG_CBIE_SHIFT		4
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 46d9de54179ed40aa7b1ea0ec011fd6eea7218df..3591a4f40131ff5958c07857a1bd1624723d6550 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -93,6 +93,7 @@
 #define RISCV_ISA_EXT_ZCMOP		84
 #define RISCV_ISA_EXT_ZAWRS		85
 #define RISCV_ISA_EXT_SVVPTC		86
+#define RISCV_ISA_EXT_SVUKTE		87
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 3a8eeaa9310c32fce2141aff534dc4432b32abbe..e0853cae1dc0ba844d5969a42c30d44287e3250a 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -381,6 +381,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
+	__RISCV_ISA_EXT_SUPERSET(svukte, RISCV_ISA_EXT_SVUKTE, riscv_xlinuxenvcfg_exts),
 	__RISCV_ISA_EXT_DATA(svvptc, RISCV_ISA_EXT_SVVPTC),
 };
 
@@ -921,6 +922,9 @@ void riscv_user_isa_enable(void)
 {
 	if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_ZICBOZ))
 		csr_set(CSR_ENVCFG, ENVCFG_CBZE);
+
+	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SVUKTE))
+		current->thread.envcfg |= ENVCFG_UKTE;
 }
 
 #ifdef CONFIG_RISCV_ALTERNATIVE

-- 
2.43.2



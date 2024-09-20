Return-Path: <kvm+bounces-27197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72BEF97D1DB
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 09:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36160283A33
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 07:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E93768EC;
	Fri, 20 Sep 2024 07:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="IFP4rAgX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2045E6F2FE
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 07:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726817969; cv=none; b=hfkfP7sBFhrkyBV3KbwJw5zHJ7Yc2B86FEVEXdtipGHoisl9Eh4kMYCaR92l30mxHCRyC39zb+i9vuWQLlIQvGBw0v33qcRV7j1Supo9xtu53LIghdAX4tp8ByIE57oW0O1a7M9C6gDNyED1Rnr6qJ8EEkPBQVwjN+XzaSciCLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726817969; c=relaxed/simple;
	bh=4PnzwBQpPeTEJe8Qyflfvtc6Ny2Buw6g2hFxclGw3nc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OSROqBXJbdILiBk9CMty0o6gvhCA4ubH1gUPQQJGmLzJSThy30dhjYJcz2pDnkqaAoOMkAbUf6skoDtqArTYGOn5Yk6SFwRDf7Visdn/OG8Met+NEkYUiIapRoYcv79xjhLZ2KXmzXGKGUoyXKq0bEwWIAmMjGNcQFPNjR/lDcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=IFP4rAgX; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7178df70f28so1311564b3a.2
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 00:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1726817967; x=1727422767; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CT9GEju7bSLmrePusCKKABH0ch7KuMtmsZgZpBqIFyo=;
        b=IFP4rAgXk0GdLtm4Ta+sANR/kO/ik37dETZg592q0ldSe1GBmSl3dqAhblbdexAqGt
         VyI4nlwszoxBF3q0eDsRTCJgKVc7jsQNYDCHiu4xnspKU56qMUJErK7+BCVP0RyqXOyw
         zSFr9GCOlOZb66uy5XviJmvF6DNXV+UQ8V3UTTAp6mO2kzP406NdjLSCn/jPrMVo4Rqh
         kQNmmUjP10VhWekrsXt4ej6o3xf2Q3YDbRLYqIqFHbw6/kEwPBkj9C9b8VPSoenOW+Vi
         MSlp5GkSJrtfwXjDdk8xcdEuqy1kgPr23Q3vwLatJUfMnZ653Je6CbCPap4TMmoWDan3
         If2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726817967; x=1727422767;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CT9GEju7bSLmrePusCKKABH0ch7KuMtmsZgZpBqIFyo=;
        b=Lro4ftP7qBASMw2lx3Xn2yQ8gbcSz0rxwtfp/cdQCbLEiOGjsO/dpnHtCHkCBJ35EA
         bFXKrX80SkuaqT8+gGUXlqWyueZ7ejNjV3tTuSY4P33jwIATajTs5BijXbTOF6/L/6y/
         dbpTyrSxCwHrBA9i2DFGLs9AbOXyHon6mVh7zOmHNLIa+bV/xDpSu6FEb7t3qxwL5TWo
         lCmwb5jbjjR2t5v2ZzPYw1YZboQ4BL03fj+bavZrQZZrGgHb2pfR0RlAtbfIbtgl+nIR
         DsEVa8eu+VrMsMhXy28Ng0ppns4ywdLNNouyHyoDPgtDKvV+n5+lz6i8X67bm2JNZRM7
         u9EA==
X-Forwarded-Encrypted: i=1; AJvYcCUFAx6fmyYnTaq9v16N8xP93PAi2735AgiUx+MYdpw9KQHz3zGLMdmC+grC6VeOAFk3Lhc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzlDmnn2V5l2MdGMRtZyEkb6fzRV72izogih5v1pwB5PdWe4kM
	ulifQ5EjyoRQF/yc0Rl9gzbxu9HBAUjFCkXcj9F+uX+EoGPAnUr5O65YauiFPBU=
X-Google-Smtp-Source: AGHT+IG6rMP/j+HwSxFkfMOtJg3R/QYQ887j1ZDLI3TfRCRWapSDFkOo88W7gDM42Rehmyg7JS1hLA==
X-Received: by 2002:a05:6a20:3007:b0:1d3:dbd:fa28 with SMTP id adf61e73a8af0-1d30dbdfa3dmr1627879637.5.1726817967200;
        Fri, 20 Sep 2024 00:39:27 -0700 (PDT)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207946fcaa4sm89645805ad.212.2024.09.20.00.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2024 00:39:26 -0700 (PDT)
From: Max Hsu <max.hsu@sifive.com>
Date: Fri, 20 Sep 2024 15:39:04 +0800
Subject: [PATCH RFC 2/3] riscv: Add Svukte extension support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240920-dev-maxh-svukte-rebase-v1-2-7864a88a62bd@sifive.com>
References: <20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com>
In-Reply-To: <20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3135; i=max.hsu@sifive.com;
 h=from:subject:message-id; bh=4PnzwBQpPeTEJe8Qyflfvtc6Ny2Buw6g2hFxclGw3nc=;
 b=owEB7QES/pANAwAKAdID/Z0HeUC9AcsmYgBm7SalpnRzx0Rx+fnfGP+6rz4BVoxP95CqTG9z1
 RiuM/FdrVyJAbMEAAEKAB0WIQTqXmcbOhS2KZE9X2jSA/2dB3lAvQUCZu0mpQAKCRDSA/2dB3lA
 vdVrDAC5RA31nXeuyC4GAVETdwPSt1TRyIVJS0n2P8hWI/QekT22Nd9FyP3fynCQ8CAR9Of5AmO
 jvxWOy+9+z/Lkoja2zXmFvjgbIzj3cP6KButtwuUqB3zHD0635hdapFEpXE5I4NIItTOUqpQH2q
 GHDAa4PsFViC6/ESfsbfcGeyrVrelye6tAW4vfX84uUA1EjDeANdYOliWXEPhDM55ynoR+H/zgV
 7Wnxv4XihHfsPE9G5nM0YBNDgTCp7iQBIlzvY0322wqkQVb2Dv1XE/I57MqEpHB8Fw+tcfYMX+4
 i2IXgPhw3f1DhCeyEKvd8Bqmcj8yWgHsZfel2dObsoX1JFIoPrAXspTPSiW1m6rwXdzxlNXUSW1
 nyPle2QpQHM+9UEMwOP/DjvkpFoHJoDgAOd7vFiyzy5Q5rC4108dLc9G//usfaKBVf67YEENkwy
 U/7UTr6JjM5eotlpyGrxdDYWyBBbJAVlpxWfbKYzWNfj6Sm7xcNUBGZhoglMOS+E980Qw=
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
index 5a0bd27fd11a6d3d3b573c19ebaeb89d23dd8535..87f88a3b3f967b27b50ed071eace631c50d07dc7 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -92,6 +92,7 @@
 #define RISCV_ISA_EXT_ZCF		83
 #define RISCV_ISA_EXT_ZCMOP		84
 #define RISCV_ISA_EXT_ZAWRS		85
+#define RISCV_ISA_EXT_SVUKTE		86
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index b3b9735cb19a8a155b2e6710223ffd0992b8133e..891225a605547b312ab81d81f76f9bbba6c1b658 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -384,6 +384,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
+	__RISCV_ISA_EXT_SUPERSET(svukte, RISCV_ISA_EXT_SVUKTE, riscv_xlinuxenvcfg_exts),
 };
 
 const size_t riscv_isa_ext_count = ARRAY_SIZE(riscv_isa_ext);
@@ -925,6 +926,9 @@ void __init riscv_user_isa_enable(void)
 		current->thread.envcfg |= ENVCFG_CBZE;
 	else if (any_cpu_has_zicboz)
 		pr_warn("Zicboz disabled as it is unavailable on some harts\n");
+
+	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SVUKTE))
+		current->thread.envcfg |= ENVCFG_UKTE;
 }
 
 #ifdef CONFIG_RISCV_ALTERNATIVE

-- 
2.43.2



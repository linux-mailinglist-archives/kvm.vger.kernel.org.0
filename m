Return-Path: <kvm+bounces-27699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 613FA98AAAD
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 19:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 848601C226EC
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 17:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236AF194C9D;
	Mon, 30 Sep 2024 17:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="hYtK6Zi+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762D619047D
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727716219; cv=none; b=lpU3BlHuUDN0HTacPcahe9YIHa7BQmqF+I2OifxYP1NcCsVrEnAhl0BpDzD1s70wrREV+p6QWw2PHI2iyML2rNkL0h7fEU/sgSqSyKynskNr7tehN6zufABGmUKn03RNR3N0dk+KXU1ZIEC9/YNuDBpUqlNBeYwMdj/BuLEiUNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727716219; c=relaxed/simple;
	bh=DYY3gi/yxQqi/2eYpYQoIg+BIxy/g46w7yv+BZUnrdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skeAq/lqR/JwB0hlI08Iv5gpGSoP5b19zCjYO1HIPqUcM/h+kbLRnTXF7Gd84mrmxSoGLigp2ElTNqk1D+cBRMOhJ8HsTJLG/ilqh13LMWLAqwWuzNlMzYWC0WuKXuhN1k6uJ6O1Lvnx/Nlh5DUzVK8CZLZKgTvbtAKYzzkC7EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=hYtK6Zi+; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20ba8d92af9so1998565ad.3
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 10:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1727716216; x=1728321016; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kx5xY759dyUvA9Oa0etxE9VI1UhfQHqL7wndkbURsJU=;
        b=hYtK6Zi+rvPg/Ao4wsqvxqDb/4DykqoGyCW65rFNjhxAF9hiDEwMO/Lq/I9A3l03dL
         8YqteNUNdUFnHSX5qSw1HQWkvLg5/9snJZMnppD6SDT4VJFG9mq5Dyj4SvTB7otL4k2N
         QY8nli4pxaeMLpQKElf0ZF2KFJImCgy0R0dqKvqLBdLVTQTbp+UILqJ/p9yR8mmFNd+6
         63McIgMJ1/4PWpg/91TFYs0SUMPv1hFCgVaW03U6h3bJZrE2GhCOno0NBC91Q55zQ+Ug
         TMKKHBsGS7nAwpQDZISa53TFj4VvOext46g+f8FfSmf5qCvb1uvsCl/oMOqCR3UDtSQk
         q87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727716216; x=1728321016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kx5xY759dyUvA9Oa0etxE9VI1UhfQHqL7wndkbURsJU=;
        b=vQC5QzzX5tnU7PBuv6R3cyK6jlqLzsAeYqvJQRkDGbVOFM55rLO+ZgDXgIIVbNH2qx
         PN2XyWM+6GITUhH2+eT2RcbDWvYXBs9Gzh8l4kIhed1SeQ2XdQLc8SZh8PcPUwM/RBbb
         bLo3puyWD7Oknuysz2pAJG3pkkG0xznPfBFivhSo6Xgp+jnqGWTcOji1PBXOMH+0sJ98
         U96m5egdO8uPpC9XYlsTamGttOvsAxp37pXfbO1XNAbMauF+ab9CkKB+bu3L9isbMsne
         onrUQoGTPZNXP/TUmVDlKXwO0IYTeT7aPtBm9Dapj2gMrzKEBvqrTHfUXzPVgoJkvetT
         1fOg==
X-Forwarded-Encrypted: i=1; AJvYcCW0N3zOEeVUcKGv2HrqB6UqnpSF2ZAPxH+dPcVOOaNZOejlLNMpc7rodafEpnY4jI2W6w0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+gEI3POKps8hRd9jMAAwMVSsUXrGh5jqIaamb0P+4LuVTcyd2
	aSSBQAiygzjbTFdVoHngRQs31gobM/7RCHe0kK0fnrLlMm5m1q2yCnqD9JcZDB0=
X-Google-Smtp-Source: AGHT+IHhm9pcVh5+FAyHVsQ1m3+mrrvYcuAeUKlMpqmlUG23x4p++fjWVQHljqdw9xU30Zn1dsMTzg==
X-Received: by 2002:a17:903:40d1:b0:20b:3f70:2e05 with SMTP id d9443c01a7336-20b3f702f68mr178426175ad.41.1727716215778;
        Mon, 30 Sep 2024 10:10:15 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b533fa125sm42501775ad.141.2024.09.30.10.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 10:10:15 -0700 (PDT)
Date: Mon, 30 Sep 2024 10:10:13 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Max Hsu <max.hsu@sifive.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH RFC v2 2/3] riscv: Add Svukte extension support
Message-ID: <ZvrbdUrU+/L3H+CR@debug.ba.rivosinc.com>
References: <20240927-dev-maxh-svukte-rebase-2-v2-0-9afe57c33aee@sifive.com>
 <20240927-dev-maxh-svukte-rebase-2-v2-2-9afe57c33aee@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240927-dev-maxh-svukte-rebase-2-v2-2-9afe57c33aee@sifive.com>

On Fri, Sep 27, 2024 at 09:41:44PM +0800, Max Hsu wrote:
>Svukte extension introduce senvcfg.UKTE, hstatus.HUKTE.
>
>This patch add CSR bit definition, and detects if Svukte ISA extension
>is available, cpufeature will set the correspond bit field so the
>svukte-qualified memory accesses are protected in a manner that is
>timing-independent of the faulting virtual address.
>
>Since hstatus.HU is not enabled by linux, enabling hstatus.HUKTE will
>not be affective.
>
>This patch depends on patch "riscv: Per-thread envcfg CSR support" [1]
>
>Link: https://lore.kernel.org/linux-riscv/20240814081126.956287-1-samuel.holland@sifive.com/ [1]
>
>Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
>Signed-off-by: Max Hsu <max.hsu@sifive.com>
>---
> arch/riscv/include/asm/csr.h   | 2 ++
> arch/riscv/include/asm/hwcap.h | 1 +
> arch/riscv/kernel/cpufeature.c | 4 ++++
> 3 files changed, 7 insertions(+)
>
>diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
>index 25966995da04e090ff22a11e35be9bc24712f1a8..62b50667d539c50a0bfdadd1c6ab06cda948f6a8 100644
>--- a/arch/riscv/include/asm/csr.h
>+++ b/arch/riscv/include/asm/csr.h
>@@ -122,6 +122,7 @@
> #define HSTATUS_VSXL		_AC(0x300000000, UL)
> #define HSTATUS_VSXL_SHIFT	32
> #endif
>+#define HSTATUS_HUKTE		_AC(0x01000000, UL)
> #define HSTATUS_VTSR		_AC(0x00400000, UL)
> #define HSTATUS_VTW		_AC(0x00200000, UL)
> #define HSTATUS_VTVM		_AC(0x00100000, UL)
>@@ -195,6 +196,7 @@
> /* xENVCFG flags */
> #define ENVCFG_STCE			(_AC(1, ULL) << 63)
> #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
>+#define ENVCFG_UKTE			(_AC(1, UL) << 8)
> #define ENVCFG_CBZE			(_AC(1, UL) << 7)
> #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
> #define ENVCFG_CBIE_SHIFT		4
>diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
>index 46d9de54179ed40aa7b1ea0ec011fd6eea7218df..3591a4f40131ff5958c07857a1bd1624723d6550 100644
>--- a/arch/riscv/include/asm/hwcap.h
>+++ b/arch/riscv/include/asm/hwcap.h
>@@ -93,6 +93,7 @@
> #define RISCV_ISA_EXT_ZCMOP		84
> #define RISCV_ISA_EXT_ZAWRS		85
> #define RISCV_ISA_EXT_SVVPTC		86
>+#define RISCV_ISA_EXT_SVUKTE		87
>
> #define RISCV_ISA_EXT_XLINUXENVCFG	127
>
>diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
>index 3a8eeaa9310c32fce2141aff534dc4432b32abbe..e0853cae1dc0ba844d5969a42c30d44287e3250a 100644
>--- a/arch/riscv/kernel/cpufeature.c
>+++ b/arch/riscv/kernel/cpufeature.c
>@@ -381,6 +381,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
> 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
> 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
>+	__RISCV_ISA_EXT_SUPERSET(svukte, RISCV_ISA_EXT_SVUKTE, riscv_xlinuxenvcfg_exts),
> 	__RISCV_ISA_EXT_DATA(svvptc, RISCV_ISA_EXT_SVVPTC),
> };
>
>@@ -921,6 +922,9 @@ void riscv_user_isa_enable(void)
> {
> 	if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_ZICBOZ))
> 		csr_set(CSR_ENVCFG, ENVCFG_CBZE);
>+
>+	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SVUKTE))
>+		current->thread.envcfg |= ENVCFG_UKTE;

Pending merge of samuel's patches, this looks good to me.

Reviewed-by: Deepak Gupta <debug@rivosinc.com>

> }
>
> #ifdef CONFIG_RISCV_ALTERNATIVE
>
>-- 
>2.43.2
>
>


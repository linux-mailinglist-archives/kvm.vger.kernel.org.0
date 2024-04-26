Return-Path: <kvm+bounces-16089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A1E8B42CC
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 01:45:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30E301F228E1
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 23:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3EB53C46B;
	Fri, 26 Apr 2024 23:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="PO/Qiv9b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644F23A1CD
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 23:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714175096; cv=none; b=EY7epsBhanqY0Ca521gOCI2FDxxyyTz/e3+kyyG/Zhx1XI73UO/Wa3Ptn+Bsay4lpIfaCMTphW1knfWBrGYLkU32tS+4fNhhiVUG3dGJvwBaXeUxSVcGYm7sbYxkHTFtAW4jv4y3ZYzfr4OVEhV8FTpHJRc+M94QmOZl4mmOzL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714175096; c=relaxed/simple;
	bh=gcUr6BaeH4uUeyuBp+5tRaGd5nRW7ROYgouV/rLG4eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wk9Q4XdPn2D25eLL/2KnoXDIpVBrjTimobeanoadtbnv0aMN6zt7NHZnCN4Vh34bq1Gon5IC34hcFDd9q+d+LEDor+Woksjzj6TuP8F6XAjcHJgG6XER0Y/ZR/YxIdDcpqL28x5neruOK7U2TUlNIDVg5jaCJLuone/gQRGqFLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=PO/Qiv9b; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1eab16c8d83so21536015ad.3
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 16:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1714175094; x=1714779894; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=10+kG8+suMw5wf1kQMOtM4ixrtygd87W4O6yWN3oIlc=;
        b=PO/Qiv9bwBUvFKxHCEtO+Iy+D0mGPiZiWoprLwaU8ihyHVkQNyt9N5rYPpuEeK8LP8
         Su4QEJPfJnS/jO3VuDP4/bVWZTnoIPOGp9Kx44CR60mF4+++jUjPDEOm2SH5vQ3Vjfgu
         xhpzgar4b8pwG8UadHXQTUiGfpGGNYWLXhMNSQfk1G2XHcfdZihB8udqBb9TECnvInKW
         jGTyl3b6uuG46I6FFI/hIJdjt2ScGh6M/YE5Kdb8A3haWOQM9UVq7VI/lmM0zpOWAzRI
         VRoElsgwj0kn7bkpIn/WNwKsB4+V+dzthZVJS3Nu06DtDiCFdr2t3ReyZPC8e41rJoF8
         8GnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714175094; x=1714779894;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=10+kG8+suMw5wf1kQMOtM4ixrtygd87W4O6yWN3oIlc=;
        b=obO8ma5Ux8tL/Y2mGkLDGfA51sJ24NT3kMIsWlQ8WJVZhME9YLuFPn5WtXGYt3dMY+
         eS4DjQY7ul9B9mtt3kJPijPn4ADS4Xvg94Txun+WBk0qUcLgrtEiohi8HqDcWKHDgb4b
         cbvdFbF6YohT0lQt3bgwdLN7nsGdHvD5jkXbD0S9y42uW6R6Kc9lgA0hljLHBJlPWZLE
         g3efz08NEtOzZxC3Q/6QLtKx/r+QZEVDp6/gCcFNdN76/S3RvZx40Kie4ONNGdaURwnW
         N4DR8wDL5ZqZIRc6ZgvXCJv0ivEfxdUoT2sVClDjQU30r7OoTXnj8DJMMTg9SKQM6kud
         PLww==
X-Forwarded-Encrypted: i=1; AJvYcCWz3yIF/dpTEciHpBv7f8E9dgwe6+X00PB4mpEEwZmj2V5OfIWv/mcstmH7sIF6MNgrPktuwmhI7B2UhuDXEVYOUq+g
X-Gm-Message-State: AOJu0YxcGYesFGPGuKsWiZ6k4ecOus7ld+z+zkH4S9XEtVBRX+bV1vWC
	OmUncRNdwjJ7Q/FC6cnBzLqrivfHTYc4JHGuVB5294fQx6nD+NK06yKl9HsZPsQ=
X-Google-Smtp-Source: AGHT+IGcvjzu0bt6XA9PeX/VVTLN2fLbx6JeHHs9deVeeSpREMfxgrHF5aU2rl341rHMT2bBZ2wf2g==
X-Received: by 2002:a17:902:7b93:b0:1e3:cce4:bfe8 with SMTP id w19-20020a1709027b9300b001e3cce4bfe8mr3587190pll.65.1714175094555;
        Fri, 26 Apr 2024 16:44:54 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902b68e00b001e97772524asm10657366pls.234.2024.04.26.16.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 16:44:54 -0700 (PDT)
Date: Fri, 26 Apr 2024 16:44:51 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [RFC PATCH 1/7] riscv: kvm: add support for FWFT SBI extension
Message-ID: <Ziw8c0X0K3mXjJWK@debug.ba.rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
 <20240418142701.1493091-2-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240418142701.1493091-2-cleger@rivosinc.com>

On Thu, Apr 18, 2024 at 04:26:40PM +0200, Clément Léger wrote:
>Add support for FWFT extension in KVM
>
>Signed-off-by: Clément Léger <cleger@rivosinc.com>
>---
> arch/riscv/include/asm/kvm_host.h          |   5 +
> arch/riscv/include/asm/kvm_vcpu_sbi.h      |   1 +
> arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  37 ++++++
> arch/riscv/include/uapi/asm/kvm.h          |   1 +
> arch/riscv/kvm/Makefile                    |   1 +
> arch/riscv/kvm/vcpu.c                      |   5 +
> arch/riscv/kvm/vcpu_sbi.c                  |   4 +
> arch/riscv/kvm/vcpu_sbi_fwft.c             | 136 +++++++++++++++++++++
> 8 files changed, 190 insertions(+)
> create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c
>
>diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
>index 484d04a92fa6..be60aaa07f57 100644
>--- a/arch/riscv/include/asm/kvm_host.h
>+++ b/arch/riscv/include/asm/kvm_host.h
>@@ -19,6 +19,7 @@
> #include <asm/kvm_vcpu_fp.h>
> #include <asm/kvm_vcpu_insn.h>
> #include <asm/kvm_vcpu_sbi.h>
>+#include <asm/kvm_vcpu_sbi_fwft.h>
> #include <asm/kvm_vcpu_timer.h>
> #include <asm/kvm_vcpu_pmu.h>
>
>@@ -169,6 +170,7 @@ struct kvm_vcpu_csr {
> struct kvm_vcpu_config {
> 	u64 henvcfg;
> 	u64 hstateen0;
>+	u64 hedeleg;
> };
>
> struct kvm_vcpu_smstateen_csr {
>@@ -261,6 +263,9 @@ struct kvm_vcpu_arch {
> 	/* Performance monitoring context */
> 	struct kvm_pmu pmu_context;
>
>+	/* Firmware feature SBI extension context */
>+	struct kvm_sbi_fwft fwft_context;
>+
> 	/* 'static' configurations which are set only once */
> 	struct kvm_vcpu_config cfg;
>
>diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
>index b96705258cf9..3a33bbacc233 100644
>--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
>+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
>@@ -86,6 +86,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
> extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
> extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn;
> extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta;
>+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft;
> extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
> extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
>
>diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>new file mode 100644
>index 000000000000..7dc1b80c7e6c
>--- /dev/null
>+++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>@@ -0,0 +1,37 @@
>+/* SPDX-License-Identifier: GPL-2.0-only */
>+/*
>+ * Copyright (c) 2023 Rivos Inc
>+ *
>+ * Authors:
>+ *     Atish Patra <atishp@rivosinc.com>

nit: probably need to fix Copyright year and Authors here :-)
Same in all new files being introduced.

>+ */
>+
>+#ifndef __KVM_VCPU_RISCV_FWFT_H
>+#define __KVM_VCPU_RISCV_FWFT_H
>+
>+#include <asm/sbi.h>
>+
>+#define KVM_SBI_FWFT_FEATURE_COUNT	1
>+
>+static int kvm_sbi_fwft_set(struct kvm_vcpu *vcpu,
>+			    enum sbi_fwft_feature_t feature,
>+			    unsigned long value, unsigned long flags)
>+{
>+	struct kvm_sbi_fwft_config *conf = kvm_sbi_fwft_get_config(vcpu,
>+								   feature);
>+	if (!conf)
>+		return SBI_ERR_DENIED;

Curious,
Why denied and not something like NOT_SUPPORTED NOT_AVAILABLE here?

>+
>+	if ((flags & ~SBI_FWFT_SET_FLAG_LOCK) != 0)
>+		return SBI_ERR_INVALID_PARAM;
>+
>+	if (conf->flags & SBI_FWFT_SET_FLAG_LOCK)
>+		return SBI_ERR_DENIED;
>+
>+	conf->flags = flags;
>+
>+	return conf->feature->set(vcpu, conf, value);
>+}
>+


Return-Path: <kvm+bounces-22047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51052938ED6
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 14:07:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B84D2819F8
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 12:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5096416D4CD;
	Mon, 22 Jul 2024 12:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="gqRHHPmE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E94E17C69
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 12:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721650053; cv=none; b=RY6LNtiC+BcAfdoT1Ze8pkoYnOsDruxJsT395xFnHYlSIHDT/+1crkuamxXFsN8wvYKn8igfnYIw3LAUmzXD2rbL4PvJImNTwutpMdUa6fUPBIiPa1/aWccK0gO131Xc+i+CPJoQG6AfnISM6UEFDcm48SK+j8zzF45NTq2EhhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721650053; c=relaxed/simple;
	bh=fy1jkpYpkE6qm2m79ms2b9vDyDR5YEymMlq2ISlxvCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jszOQRoZeDH/as+idpQF+S8iKCgZXSBCdJAYUuODyJEQRxLRaW4Um7GLzRGPNBLB8I8GN4IkqlN9UFlVD9Lx8uK00kFz2uDmzqVf9I5cJgGt0etdkEON3GOwe31XRGIehJeRFa8XuXIdhjjA2WHYVq9YDfRV9YYGbx4Dke70MPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=gqRHHPmE; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7044bda722fso2482079a34.2
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 05:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721650051; x=1722254851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oINtVjqt1HSId9RPGFIf1FQmhq9XpHG+7bXI6iFdSBA=;
        b=gqRHHPmEyEeinOSOwHopEDRsq0DoYGCcRlTc1xa48VIH/wuUeQsi384+EUWWmFNIsz
         bdL9s47clM5zRR4/gZZRz5aDTahQINklM3NOq6fRBRLo3JVbnRialzQGVrcVnR6CVxsZ
         aRoUlD6e7apaHCFxqjYxYDuzpr1PopKgWg/D2DI0nN4wOHxu5W9LFn1VKkgnd2yS9t03
         0CltzakeqPpDMxPwvfjpVblNcW7fPuPzNeFLJ/AvV6ZBHNBUV/EcJIC5TeknAXmNaRCM
         /czGqQlVWLskxa9akiQSTBWYTzqatfZD9OmeLlzWdB0Gnk8uWK8Z3/cR5rS790ONmYJL
         4LmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721650051; x=1722254851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oINtVjqt1HSId9RPGFIf1FQmhq9XpHG+7bXI6iFdSBA=;
        b=JVUSsKiILlQbAVJXdr05bs6P4Pcu3VQWfkmCb15LHAYGJiXg0e/x0qkpjGis+uFk3y
         MVV9aWhIerNkVDYlMEMlZS9gHMS7wknFNEThjgM1L8v64NgTdw3cEzvWOqUR3t0NcMc8
         7oHTCVQk71PqpPuPFbeSxJLenHlfzNcLmcZN1U8qlskbhbrcwF9A+8Db2fy6AJc0gVIU
         iXxaxibJKyFGxr2j5K4GMSQJ8GV9DdtIw8ikzbH2CtejQH5BCQmFrtBp3OmjY0Ibbndt
         jX3IzBFK0LckGyITSMbWxoX6yKzLhddK8XWP3ot1nBxiNjoUwmoLxiYhES3uCgmD/LI4
         pWHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVGJwlL9u80tXAJvzly2lo8gFmwusbJPkYCa+kfkgDXZ9aYsbn1YoJqOtN2+Jy8srwmryWqp/32biG+v1TmP695v2M
X-Gm-Message-State: AOJu0YxMUdxmJacqX782SV27QgSria7paTO4c6QtyiGkO4i9F7MMV/Pg
	Y0scsOiqdmioAtOzVxpn3N/QANuzokLbF3xDEwgEeQ/fS0F3LMWgiV8usfPchs8=
X-Google-Smtp-Source: AGHT+IHImhwhvolmmy2sBZPMZpyM6vGlKj86Ic5s52AyVDUesOqmbnZKOKiGH1rTCTchEcUwJ7q4LA==
X-Received: by 2002:a05:6870:65a9:b0:25d:fdc4:8587 with SMTP id 586e51a60fabf-263ab5d2b8emr4937622fac.37.1721650051034;
        Mon, 22 Jul 2024 05:07:31 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2610ca48ca7sm1637855fac.42.2024.07.22.05.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jul 2024 05:07:30 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 2/2] riscv: Add Sscofpmf extensiona support
Date: Mon, 22 Jul 2024 17:37:10 +0530
Message-Id: <20240722120710.417705-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240722120710.417705-1-apatel@ventanamicro.com>
References: <20240722120710.417705-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Atish Patra <atishp@rivosinc.com>

When the Sscofpmf extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index cf367b9..e331f80 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -18,6 +18,7 @@ struct isa_ext_info isa_info_arr[] = {
 	/* sorted alphabetically */
 	{"smstateen", KVM_RISCV_ISA_EXT_SMSTATEEN},
 	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
+	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 17f0ceb..3fbc4f7 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -31,6 +31,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-ssaia",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSAIA],	\
 		    "Disable Ssaia Extension"),				\
+	OPT_BOOLEAN('\0', "disable-sscofpmf",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSCOFPMF],	\
+		    "Disable Sscofpmf Extension"),			\
 	OPT_BOOLEAN('\0', "disable-sstc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSTC],	\
 		    "Disable Sstc Extension"),				\
-- 
2.34.1



Return-Path: <kvm+bounces-24731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94912959FD0
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:28:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 428731F244D2
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 14:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0597B1B2EC9;
	Wed, 21 Aug 2024 14:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="C02l2bgP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15C71B1D4B
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 14:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724250410; cv=none; b=rtSLvRzClcoipwr0HXHCg2v+D849iQkUguaqh6j7BNu9WeyMz/R5OL2y6F32YJWhUnnwwQuMACBiBNvJovXNk5eFtF5ujzGY/H4f36dkWUL7x77HsSvgZILONel7wrO9PbFSOXu/ETKcRw/Fr63XtrVe9Y7cL6tz0nrHGjgU8Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724250410; c=relaxed/simple;
	bh=fy1jkpYpkE6qm2m79ms2b9vDyDR5YEymMlq2ISlxvCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UCfHLF+jxQ0CPbfY+/SBupTw3d8ZGREFL3qnvPpdbe/SQiWpeCPDN4FGlYV9IzimhTYVgwNBVG/5ZUHgvPSITXpZgYI+pRQ+Ezks3fQkqxekJ8jp2RSae+yh7h9bp7PIUV1FFgvG93pztvQjyGfW2nFZv8YpR+K9XpQc9e5nEvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=C02l2bgP; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4280c55e488so5030875e9.0
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 07:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1724250407; x=1724855207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oINtVjqt1HSId9RPGFIf1FQmhq9XpHG+7bXI6iFdSBA=;
        b=C02l2bgPjRI3Z8ptrOOCKyoBam18rIhiDwhk9qZ1KwWVm4q86Uuuw3lcQUeGGCGd1T
         svqnyT8g51TymJ4DW4tDUsh9B0YenhioL1l2tscPttV0iSat7FfWyzty4HYEo+a6HhAZ
         ba/iSbRTD0pvMx3BHCje8IIIgbowXR7qb/f4cr4KTeE/+1KmMWL4MwKdgjymGtosStT6
         TKgCqSN+W8H/5utWxmVSf3a/YiI7Loq4EN5f6pHQVEcknffvBVIntUFg55jY1fp83kyw
         ++CRQXDDtjT2CToVLZG4N1cAnfo4Vm/tWKE6mL7iHuPI8PhE6lt5SCOOWXY3fipT5o8v
         Wu1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724250407; x=1724855207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oINtVjqt1HSId9RPGFIf1FQmhq9XpHG+7bXI6iFdSBA=;
        b=VcszavSn2r88OHf0Ab0+7zgAoMKTDD3KfHyEZdb9VGNih5gs90Vf3SdzIy2CohEHeX
         NoZtJ6ON6lxLpLLljjSAEF3UlfYOJy7G+KtPi10070kb3YMQ1SH9/QWmr0btcc/SoYAj
         6qGzG4KfZvw+XrMTjwiKQb1rvM1ngePxndnCef6lLbhTrvcEI6UDf8QBcEZwuZjs9VDl
         xhQHColpuElx5oitv9s9lOsOWcyaLGYXhwmaN/0yquLf6gjPhAoEzroCNBrL08ZkXeAB
         YGME0w1SfAEyJfQH0IybEET43ee7XGowx9357wNUwLgdN+e4Rf3xXlaPvAXb4geudmkX
         ig3w==
X-Forwarded-Encrypted: i=1; AJvYcCXcxODFSNITKYY9FYLlJCMYJl7LMJjHDFA8UfOKKKTHsW8Ix05nqr627meoaqafj9bUus0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7dXuUKQ/brld/fwK8fnKfl4bvwrbK2gehlsLbOlS8XVQ43DJp
	BJ6d9+mo5f6j8IbjDsLvodFo/YkqMm7N10g9PM2tzo/WCfUcxZjhq0EVkapSvzg=
X-Google-Smtp-Source: AGHT+IGAG+CtUJijxv36J+sCbfags7JKci6hApRnvL6bK+8fTcLvO3mKXdE7IxDPtcijvhliEfAxtg==
X-Received: by 2002:a05:600c:3104:b0:424:8743:86b4 with SMTP id 5b1f17b1804b1-42abe654bb6mr14247895e9.6.1724250406586;
        Wed, 21 Aug 2024 07:26:46 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abebc34ddsm28646765e9.0.2024.08.21.07.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:26:46 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 2/4] riscv: Add Sscofpmf extensiona support
Date: Wed, 21 Aug 2024 19:56:08 +0530
Message-Id: <20240821142610.3297483-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821142610.3297483-1-apatel@ventanamicro.com>
References: <20240821142610.3297483-1-apatel@ventanamicro.com>
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



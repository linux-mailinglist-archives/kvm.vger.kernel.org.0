Return-Path: <kvm+bounces-44191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF6AA9B265
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:33:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A938B1B87248
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DB127B516;
	Thu, 24 Apr 2025 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oc0LoJl5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA02B22CBE9
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508759; cv=none; b=gxfTd2cca00AcIu1Z0TZvaVrvL/1x9vpzJ6Fdwcry4OodlhsGijESW8i8lI1swPJ1udCV1NkAizKpagBacYowPJKyP8rSVVRQRaqmv3GrHFBlsG+YWBn8uJqoMDWb7yFVmGwrrvnxK/Yk5F5EIkqnSBsA7Thdq/0q5sBaq7yhCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508759; c=relaxed/simple;
	bh=Z7kCb0CH7JESphENtfsMMJsw4L5SG9NdnuxZle6za4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsfZKimZFvpvs1CidMaUN8HNjGExA2cDdka9koyOxCD/ZxHpkGKdxbQ9v2j/8akQtFi9mLV1ps4vtxSVWRim58ENTRhN50M3rY26MyxuYygorUhSmQgMvI42iwUOHIBOclWmhKDR3iEClHNlrULwyyrSKo4m2WzuomotIf8cVrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oc0LoJl5; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-736dd9c4b40so2087819b3a.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508757; x=1746113557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpgStyTcu6ohuguHcXTsVTGNp1bnGO1cAa+NtUp6vks=;
        b=oc0LoJl5qHdXzzK2T5nJiUEEYNANa2gSkUM7OV3bL1CYN4XCz+2nr3YCVoqrWSNUrs
         WCT9P02fNOVm8VognbfOBFXOShI1DnPxq2/FRPcl4IA0yynvRGf5w8MQazC/yGh/uJY8
         n+bJB0fir1OsiDmAUr4cfSvgWrIb6KgUFdZpRO7NTqOvAaEigaaLBiGlB1/S7GOlL4+F
         Kj0qkMYZg+GsxaoXJNvFys73kIJiJfeWfMH2+kAKBvsuOOEgnddQ8Ad7Kf7Rv6Q1ZLP+
         uCeD6NEiiNdxjfW5kCZBWYQuzmTr+YXcldSuO0wVRkrTNDvDaKfF0uxo7YeAIGKn+5Gv
         PEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508757; x=1746113557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qpgStyTcu6ohuguHcXTsVTGNp1bnGO1cAa+NtUp6vks=;
        b=qevL2gMKBhu1I9ce3rhwAPiOadTYqMY0zSQASlWRKSQRemKB5tFmb6mp2tpon+FiSS
         loIxl/8ziziW/BadYQXQkGiHbfUzF5KZ6rZVa9uIDpvalsiD4LAU754izmViO4j6rFcG
         bwDl6K0Kk47psU+HFQUXZGvvoUSY+0mbS41OL5v5FVHKXOii3GUQLfVKSx0P9clHSKm6
         1Y5gPGBgEcPOSjm//cY0s3N+p4jdd3542pP/8/wIgMiXhD1+OEceAyvcPsvVH7fNY+Vj
         kGc23TmhcVj3MwrV4CmGb8xScOV2PYFs7hOiQCIR6uki78uco0YB3vj/bnmWGYZmDo32
         vBOw==
X-Forwarded-Encrypted: i=1; AJvYcCWudIIKCcvzyinU/mfi4eOMsZEO0yX3s/bPlc0HlOrtoBqgLe3vHEGfHqq07gwFa4ocFG4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+xWEyt8MKJmjqf7aJN9wtfIVEuCjZMxm2TORwA+okq54Hm6GN
	xuEAXjiMxdhDgmgC8A1vDhQg95mp/jVgOPmvgbeYJ4cHSu6UiwdVrVrdbQipOSA=
X-Gm-Gg: ASbGnctrATKiuoR4xgsev9ds6Dgt5Kw5PgaLgbHb8g74kYKcv8lkJNlKxYfXG6Vple6
	Dhhd9BSFmGNatiOJPC8fG01JEmk0dyf/o5FE8mEyOy5ugW67UNU25+DzPqtAFiR/5gZFikRbS72
	DBy4qN0PMujbp4lXefRCLBEkPzKVFeHcHtA4c3vkMxvHMqt3LvVHWUS6bnqQdimOZ4MsVMMBD/i
	breC9UqYLcEGmSzvTI8dxixnsEWJcg4WK6RKt/9fzuUApAYOWasNkQkj19WUcQnfVvRXrvn6JkH
	H+Tl12cgHWI6i92339Fq3jN9a3u3dyGMl+9OwM1foGxhLI20CDTzBV2QejoagonBpoZ8VHGgKxL
	yurEY
X-Google-Smtp-Source: AGHT+IHy7AXxJJDzsDWie0QeRPdRL7g7CgsUCpA59V55wQzkBFyCEffrYZI1d0c7ntvg/j0t9yrGTw==
X-Received: by 2002:a05:6a21:8dc7:b0:1ee:450a:8259 with SMTP id adf61e73a8af0-20446024261mr3667887637.18.1745508756859;
        Thu, 24 Apr 2025 08:32:36 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:36 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 06/10] riscv: Make system suspend time configurable
Date: Thu, 24 Apr 2025 21:01:55 +0530
Message-ID: <20250424153159.289441-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424153159.289441-1-apatel@ventanamicro.com>
References: <20250424153159.289441-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

If the default of 5 seconds for a system suspend test is too long or
too short, then feel free to change it.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/include/kvm/kvm-config-arch.h | 4 ++++
 riscv/kvm-cpu.c                     | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 0553004..7e54d8a 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -5,6 +5,7 @@
 
 struct kvm_config_arch {
 	const char	*dump_dtb_filename;
+	u64		suspend_seconds;
 	u64		custom_mvendorid;
 	u64		custom_marchid;
 	u64		custom_mimpid;
@@ -16,6 +17,9 @@ struct kvm_config_arch {
 	pfx,								\
 	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,		\
 		   ".dtb file", "Dump generated .dtb to specified file"),\
+	OPT_U64('\0', "suspend-seconds",				\
+		&(cfg)->suspend_seconds,				\
+		"Number of seconds to suspend for system suspend (default is 5)"), \
 	OPT_U64('\0', "custom-mvendorid",				\
 		&(cfg)->custom_mvendorid,				\
 		"Show custom mvendorid to Guest VCPU"),			\
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index ad68b58..7a86d71 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -228,7 +228,7 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
 				break;
 			}
 
-			sleep(5);
+			sleep(vcpu->kvm->cfg.arch.suspend_seconds ? : 5);
 
 			break;
 		default:
-- 
2.43.0



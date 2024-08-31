Return-Path: <kvm+bounces-25623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 776D0967141
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 13:28:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8BD51C21813
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 11:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C21B917E00A;
	Sat, 31 Aug 2024 11:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="e0u8Cu+i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF5433EA
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725103693; cv=none; b=Gh9ixuzxHrIe0aLL5bonr1P4FAuUkilbpE1AAWYWOQfOjKb0cpBJftGA8fy43t8jdsJPa6Su97/CQsNPtVgGj+DiSw0TBMWfVaExF9KaLuel0XKz5g+SgfWuI6sPuLnGvScNAXeRRFOVJhzZ0fi6ygyDmFxAixTm8ADKNgcFZBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725103693; c=relaxed/simple;
	bh=FKHQvOo9erP7n7MEe+57gTtAshMO2GWD8mVbGlwKP+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oejk0OSKQEx2WI5NGfsvPVgen19TyY7wYMtU3KPn3HC1QmZMhmr/0xGWoWV1MefNpuAZelTeeDj6vC+V8ELoHzR+UKWj2scku/yvnJcFQiq6ydklHRoNk97evpWo2+ZZZk1CVYj4++6Y7n2yeH1KYoq2494+Z5mFaR6VqaqvdaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=e0u8Cu+i; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7141d7b270dso2218147b3a.2
        for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 04:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1725103691; x=1725708491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r6po97RhZOZUf+IwPgmxPkXAAKqo/0ExO40UV6np7to=;
        b=e0u8Cu+iSwSL54/CC1S1ayztN4bvtBa6VPQExcHOr3JaxENNzdYt3JeAvYPlqKprHX
         lCmXRV0eY8LPKTy1gwdMTpTal93pcEUpq7DlXS0R0dStTPyEHvM9S20BgXz5PrlUWPB5
         Ou69iNF+AccftYai8iZQ+zVIgIsOOK9HMWPr4/7kShKK67b2HfWyvehWWA8h17diOdyA
         NI1n47vjzq2GoNl5qlAo/QFlrjUHGlONDrB7VmP3Yio23KJGMge5puhShewUUxMA1y+v
         4mlxsp917oS4uxajmNsANxkpGboUDGeXDbPGhfqBuEheHvB8v+2w7bZhfsUjg7/nKZiv
         3x4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725103691; x=1725708491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r6po97RhZOZUf+IwPgmxPkXAAKqo/0ExO40UV6np7to=;
        b=Pd6lVM6yqpC0vqeAfRqYgHdyrSwKTchm0VzByesRa4/ncWbMy2T+R7MVSteKZun97y
         6OYpYlLteleRMFpLhq0ZsrMsjyBxxNGXXx/0Vz+JRl+wJJosaPvYyN2ediZlqWkQtosW
         ncriMxFQtak7Xh9ZR9J6wuJqtvYEJ7acbhKXobdBTqYVNtruehiM5AzqicSaKqMMVkGz
         Qe1g2/PcrmqIu3IPQX9yImiMzwxkSdPk3iTokwGhTTwrwjRF/s59tzHaoR20xWqTWggA
         SGJDHD+uRMtpsy1DfFlMXBG79h8gpioUT89QABFkj1PX8DinIw3ri9zEW9BoBBExVfbl
         NiCA==
X-Forwarded-Encrypted: i=1; AJvYcCUD9AQYfg3d2eeF09qeccSggLD2HJVgp4PB2WAtgVKz/xwC5/DLkPHFmiKszzjWysrbWNo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/h5axeA/hIRA3BucuTXjOQNwU6zl1tUPL0WxykfswACEqaVjK
	i9WTU48Q+M/tOioDvB7ukfw2OAC2T/9ZD2iPCDzvEZ483oEmhFESKQ+v4J1qeHI=
X-Google-Smtp-Source: AGHT+IGCVKzkl5zO2EKWqgNuFwQNK7XHEay2aT6rHxuqgJByJRJTnZ4Qv+QSyrTUaTCGSKYNrf52CA==
X-Received: by 2002:a05:6a21:1585:b0:1c0:f2a5:c8dc with SMTP id adf61e73a8af0-1ced6549f90mr512913637.50.1725103690686;
        Sat, 31 Aug 2024 04:28:10 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20542d5d1b2sm11934415ad.36.2024.08.31.04.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2024 04:28:10 -0700 (PDT)
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
Subject: [kvmtool PATCH 3/8] riscv: Add Zca extension support
Date: Sat, 31 Aug 2024 16:57:38 +0530
Message-ID: <20240831112743.379709-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240831112743.379709-1-apatel@ventanamicro.com>
References: <20240831112743.379709-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zca extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 9d0c038..4fe4583 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -32,6 +32,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
 	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
+	{"zca", KVM_RISCV_ISA_EXT_ZCA},
 	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 0b79d62..40679ef 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -73,6 +73,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zbs",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
 		    "Disable Zbs Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zca",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCA],	\
+		    "Disable Zca Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfa",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
 		    "Disable Zfa Extension"),				\
-- 
2.43.0



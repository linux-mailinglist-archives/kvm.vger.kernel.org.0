Return-Path: <kvm+bounces-12601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7567788AA92
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:02:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5DE62A7959
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22AE2757EB;
	Mon, 25 Mar 2024 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SEerhQd8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDF674E37
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380746; cv=none; b=hf6vY2SdoAr98l1Qjtc5IyKVFOG1pdrvpN6E25NLdLy02cGicjpVRkAtzzyU1ymBrJCM5w9icEnckY7H/+k93j/SjHzQDFg9ikMXxCnxrue3O32O2xAh11xHOYvLnoNSC1C9Q+c1QNPdOO4MpibWhvwjlTBxBVsXD1I63tiLgIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380746; c=relaxed/simple;
	bh=WQGsUrL1Tt2vMz7njVQ6Z6386puHvbXgRmXaSA6NOqw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ClduNCz5CZ/e8Mqh7Oppr5ChlTE0lxncENERpx07dCdm+zcNN9g99cQI1uB3i5fFVxCPZxqM6qTDnolgRAlBBFmSUT1SiPBxRKR+7aqL/8G4w+QVNbseknJjM2BkHPFj7T5jLn8QMS0yhNFDtVSTMNngxgK4998AG2dk8r5zZak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=SEerhQd8; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e0878b76f3so21701765ad.0
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711380744; x=1711985544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DkCfColGR9bTT6WQltCO6K4bbcIOQkopwMdSmeJg1nY=;
        b=SEerhQd8OAhKDSDEO3/t4z1Jhmqz/UTsoJ8jHHSQ7+XVuBnsb0IK/wwuiZZJQxrRPZ
         G4g6cjmxlhjMtkND1U9sX5VnjkgJg9TLviyUxMejDlMyOqn8WCeXVqKSbmkJZT5TiXc0
         adjGD/NBgVh5+jtOC6Q8jTGx9TBL+TiWrSh6IitPX18eqVwvQNiA4PkDwXiT1csIHhR1
         acIvY9tkn2VILtyGQuXNjieZ8ZD6H5AcQDafbyIpjG7ywmidi5dTqwbPWz5FlLrZvP6j
         V7wXr8+PKWdEAy6juNja0EK6wvEal+pGci3+OqbcZf1ja9ZHafzc8N6MlSBEmrC5U3DI
         G0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380744; x=1711985544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DkCfColGR9bTT6WQltCO6K4bbcIOQkopwMdSmeJg1nY=;
        b=XhlWe5bOgSk1V10ouk/23LVIwISTlbheiH/ccvhvnMo1I6rl6sDeHLWTlr+bo0dNwy
         1nmIqJUIE/rmr+N9SKhyCOKT+P1p6vZmbWEgsVMiKYVa1HaMSwfW2wn9aPE95F4nc+5M
         8KZUis402UQswUMHrMNVyFcEoZL5j9rJAtev2BmaLFKnRcVQFr4/uNoX2NzRVJ9/y4ZG
         860E2TNlx4HI+lmpsezVo46UAzkKm8k3t+7sZULAF2s3L75SuPiNuyPIn+Cn46v1VeXa
         3lz4Dj3o09cg1zV89PBj9km4Y7DR0WhP1ZlI8FgVWgtMk89GePZ2bkNuODV+T4TspkGT
         cd5A==
X-Forwarded-Encrypted: i=1; AJvYcCUqnbXNap5efGFNGbgMHwqqg5vYio/D34XN53aXtpaEKIFWF3aNmAaZf9uTXaTomxjkxa7I/jc+2CJ8Ulz+DgHpunua
X-Gm-Message-State: AOJu0Yyu/1kh9ZT3jNlfpLGatJHDXHjtXtxVFGopLzvBjM3KThErqKZz
	QhDnaib6/M9aKZDQF1EzlgapeVJlqHXEaiEJPbF05Avuc/QQPeZYEEqLCTFWsa4=
X-Google-Smtp-Source: AGHT+IGHFnkbxH0FS9kWv8SjN1JEVLQ12GYixxzAuAG+1JMhlP8qfDUA6Abc1zhD0P1HVn6xauiqyw==
X-Received: by 2002:a17:902:da92:b0:1e0:b5ee:e9cb with SMTP id j18-20020a170902da9200b001e0b5eee9cbmr6202281plx.22.1711380744151;
        Mon, 25 Mar 2024 08:32:24 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.87.36])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001dd0d090954sm4789044plg.269.2024.03.25.08.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 08:32:23 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 08/10] riscv: Add Zvfh[min] extensions support
Date: Mon, 25 Mar 2024 21:01:39 +0530
Message-Id: <20240325153141.6816-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240325153141.6816-1-apatel@ventanamicro.com>
References: <20240325153141.6816-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zvfh[min] extensions are available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 2 ++
 riscv/include/kvm/kvm-config-arch.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 80e045d..005301e 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -49,6 +49,8 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zkt", KVM_RISCV_ISA_EXT_ZKT},
 	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB},
 	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC},
+	{"zvfh", KVM_RISCV_ISA_EXT_ZVFH},
+	{"zvfhmin", KVM_RISCV_ISA_EXT_ZVFHMIN},
 	{"zvkb", KVM_RISCV_ISA_EXT_ZVKB},
 	{"zvkg", KVM_RISCV_ISA_EXT_ZVKG},
 	{"zvkned", KVM_RISCV_ISA_EXT_ZVKNED},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 2935c01..10ca3b8 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -124,6 +124,12 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zvbc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVBC],	\
 		    "Disable Zvbc Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zvfh",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVFH],	\
+		    "Disable Zvfh Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zvfhmin",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVFHMIN],	\
+		    "Disable Zvfhmin Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zvkb",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKB],	\
 		    "Disable Zvkb Extension"),				\
-- 
2.34.1


